---
name: thesis-citation-audit
description: "Orchestrates a full-thesis citation correctness audit. Runs the check-citation-correctness skill on every content section in batches of 3 parallel subagents, tracks progress in SQLite, resumes gracefully if interrupted, and assembles a master report at plans/citation-check-report.md. Use when you want to systematically verify citation accuracy across the entire thesis."
model: claude-opus-4.6
---

# Skill: Thesis-Wide Citation Audit Orchestrator

## Purpose
Systematically run the `check-citation-correctness` skill across all 20 content sections of the thesis. Process sections in parallel batches of 3, track progress in SQLite, handle arXiv rate limits, and compile all findings into one master report.

---

## Section Inventory

This list is canonical — 20 content sections, excluding front matter and chapter-level wrapper files. Do not modify it unless the thesis structure changes.

| ID | File path |
|----|-----------|
| `1-motivation` | `1-intro/tex/1-motivation.tex` |
| `1-research-context` | `1-intro/tex/1-research-context.tex` |
| `1-research-objectives` | `1-intro/tex/1-research-objectives.tex` |
| `1-thesis-structure` | `1-intro/tex/1-thesis-structure.tex` |
| `2-robot-localisation` | `2-background/tex/2-robot-localisation.tex` |
| `2-vineyard-pruning` | `2-background/tex/2-vineyard-pruning.tex` |
| `2-vineyard-robotics` | `2-background/tex/2-vineyard-robotics.tex` |
| `3-intro` | `3-SLAM/3-intro/tex/3-intro.tex` |
| `3-related-work` | `3-SLAM/3-related-work/tex/3-related-work.tex` |
| `3-methodology` | `3-SLAM/3-methodology/tex/3-methodology.tex` |
| `3-results` | `3-SLAM/3-results/tex/3-results.tex` |
| `3-discussion` | `3-SLAM/3-discussion/tex/3-discussion.tex` |
| `3-summary` | `3-SLAM/3-summary/tex/3-summary.tex` |
| `4-intro` | `4-precise-alignment/4-intro/tex/4-intro.tex` |
| `4-related-work` | `4-precise-alignment/4-related-work/tex/4-related-work.tex` |
| `4-methodology` | `4-precise-alignment/4-methodology/tex/4-methodology.tex` |
| `4-results` | `4-precise-alignment/4-results/tex/4-results.tex` |
| `4-discussion` | `4-precise-alignment/4-discussion/tex/4-discussion.tex` |
| `4-summary` | `4-precise-alignment/4-summary/tex/4-summary.tex` |
| `5-conclusion` | `5-conclusion/conclusion.tex` (covers `5-future-work` via `\input`) |

---

## Workflow

### Phase 0 — Initialise the database

Use the `sql` tool (session database) to create the tracking table and populate it:

```sql
CREATE TABLE IF NOT EXISTS citation_audit (
    id            TEXT PRIMARY KEY,
    file_path     TEXT NOT NULL,
    status        TEXT DEFAULT 'pending',
    -- status values: pending | in_progress | done | failed | skipped
    citations_found   INTEGER,
    consistent_count  INTEGER,
    imprecise_count   INTEGER,
    inconsistent_count INTEGER,
    unverifiable_count INTEGER,
    report_path   TEXT,
    error_text    TEXT,
    started_at    TEXT,
    completed_at  TEXT
);
```

Insert all 20 sections with `status = 'pending'` using `INSERT OR IGNORE` so re-runs within the same session do not reset already-completed sections.

Print the initial status table to confirm setup.

---

### Phase 1 — Resume check

Before starting any batch, check whether `plans/citation-reports/` already contains report files from a previous run (the directory may not exist — that is fine).

For each file found matching `plans/citation-reports/<section-id>.md`:
1. Mark the corresponding row as `status = 'done'` in the DB.
2. Parse the report's summary header to extract verdict counts and update the `consistent_count`, `imprecise_count`, `inconsistent_count`, `unverifiable_count` columns.
3. Set `report_path` to the file path.

After the resume scan, print a summary:
```
Resume scan: N sections already complete, M sections pending.
```

---

### Phase 2 — Batch processing

Repeat the following loop until no sections remain with `status = 'pending'`:

#### 2a — Select next batch

Query the DB for up to 3 pending sections:
```sql
SELECT id, file_path FROM citation_audit
WHERE status = 'pending'
LIMIT 3;
```

Mark them `in_progress`:
```sql
UPDATE citation_audit SET status = 'in_progress', started_at = datetime('now')
WHERE id IN ('<id1>', '<id2>', '<id3>');
```

#### 2b — Launch parallel subagents

For each section in the batch, launch a **background** subagent using the `task` tool. Each subagent's prompt must:
- Invoke the `check-citation-correctness` skill on the section file.
- Override the default output path: save the section report to `plans/citation-reports/<section-id>.md` (not the default `plans/citation-check-report.md`).
- Include the full section file path relative to the repo root.
- Note that if arXiv download fails due to rate limiting, the subagent should fall back to web search to read the paper.

Example subagent prompt template:
```
Use the check-citation-correctness skill on <file_path>.
Save the report to plans/citation-reports/<section-id>.md instead of the default path.
If arXiv rate limits are hit when downloading a paper, fall back to web search to read the paper's content.
```

Launch all subagents in the batch before waiting for any of them — do not wait sequentially.

#### 2c — Collect results

Wait for all background subagents in the batch to complete (use `read_agent` for each agent ID).

For each completed subagent:
- **Success**: Read the report file at `plans/citation-reports/<section-id>.md`. Parse the summary header for verdict counts. Update the DB:
  ```sql
  UPDATE citation_audit
  SET status = 'done',
      citations_found = <N>,
      consistent_count = <N>,
      imprecise_count = <N>,
      inconsistent_count = <N>,
      unverifiable_count = <N>,
      report_path = 'plans/citation-reports/<section-id>.md',
      completed_at = datetime('now')
  WHERE id = '<section-id>';
  ```
- **Failure / no report written**: Mark `status = 'failed'` and record the error text.

#### 2d — Rate limit handling

After each batch completes, check whether any subagent reported an arXiv rate limit error. If so:
- Print a notice: `⚠ arXiv rate limit detected — pausing 30 seconds before next batch.`
- Wait 30 seconds before launching the next batch.
- Remind subagents in the next batch to use web search as fallback.

#### 2e — Print progress

After each batch, print a compact status table:
```sql
SELECT status, COUNT(*) as count FROM citation_audit GROUP BY status;
```

---

### Phase 3 — Assemble the master report

Once all sections have `status` of `done`, `failed`, or `skipped`:

1. Compute aggregate totals across all completed sections:
   ```sql
   SELECT
       SUM(citations_found)     AS total_citations,
       SUM(consistent_count)    AS total_consistent,
       SUM(imprecise_count)     AS total_imprecise,
       SUM(inconsistent_count)  AS total_inconsistent,
       SUM(unverifiable_count)  AS total_unverifiable
   FROM citation_audit WHERE status = 'done';
   ```

2. Read all individual section report files.

3. Write `plans/citation-check-report.md` with this structure:

```
# Thesis-Wide Citation Correctness Report

**Date**: <today>
**Sections audited**: N / 20
**Total citation keys checked**: N
**Consistent**: N | **Imprecise**: N | **Inconsistent**: N | **Unverifiable**: N

---

## Executive Summary

| Section | Citations | ✓ | ⚠ | ✗ | ? | Status |
|---------|-----------|---|---|---|---|--------|
| <one row per section> |

---

## ✗ INCONSISTENT — action required

<All inconsistent findings from all sections, grouped by section, with suggested fixes>

---

## ⚠ IMPRECISE — review recommended

<All imprecise findings from all sections, grouped by section, with suggested fixes>

---

## ? UNVERIFIABLE — manual check required

<All unverifiable findings from all sections>

---

## ✓ CONSISTENT — no action needed

<Brief list only — section name and count>

---

## Failed / incomplete sections

<List any sections where status = 'failed' with error details>
```

4. Print: `Master report written to plans/citation-check-report.md`

---

## Guardrails

- Do **not** modify any `.tex` or `.bib` files — this is a read-only audit.
- Create `plans/` and `plans/citation-reports/` if they do not exist before writing any report.
- Use `INSERT OR IGNORE` when inserting sections so re-running within the same session is safe.
- If a section has zero citations after scanning, mark it `skipped` (not `done`) and note it in the master report — do not waste a subagent on it.
- Never mark a section `done` unless the report file was actually written and verified readable.
- Use UK English throughout (localisation, optimisation, modelling).
- If all 20 sections fail, report the errors clearly rather than silently writing an empty master report.
