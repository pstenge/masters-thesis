---
name: check-citation-correctness
description: "Audits all citations in a given thesis section against their source papers on arXiv. Auto-discovers every \\cite{} and \\autocite{} key in the section, verifies each attributed claim by downloading and reading the paper, and writes a full verdict report to plans/citation-check-report.md. Use this when you want to check whether the claims a section makes about cited works are actually accurate."
model: claude-opus-4.6
---

# Skill: Section Citation Correctness Auditor

## Purpose
Given a thesis section, find every cited paper, download it from arXiv, and verify that the claim attributed to it in the text is actually supported by the paper. Catches wrong-paper citations, overclaiming, misrepresented results, and missing caveats. Writes a structured report with verdicts and suggested fixes.

## Inputs
- A target `.tex` section file (provided by the user)
- `MastersThesis.bib` — for resolving citation keys to arXiv IDs
- The `arxiv-check-citation` skill — this skill delegates per-citation verification to it

## Workflow

### Step 1 — Discover all citation keys

Scan the target section file for every `\cite{...}` and `\autocite{...}` command.
- If the file contains `\input{...}` directives, follow them and scan those files too.
- Collect the **unique set** of citation keys across all scanned files.
- Log the full list before proceeding so the user can see the scope.

### Step 2 — Invoke the `arxiv-check-citation` skill

Invoke the `arxiv-check-citation` skill, passing:
- The complete list of citation keys from Step 1
- The target section file as the thesis `.tex` context
- `MastersThesis.bib` as the bibliography source

The skill handles downloading each paper, extracting citation context windows, and assigning a verdict to each occurrence.

### Step 3 — Write the report

Save the full output to `plans/citation-check-report.md`. Create the `plans/` directory if it does not exist.

Structure the report as follows — ordered from most to least urgent:

```
# Citation Correctness Report

**Section audited**: <path to section file>
**Date**: <today's date>
**Citation keys checked**: N
**Consistent**: N | **Imprecise**: N | **Inconsistent**: N | **Unverifiable**: N

---

## ✗ INCONSISTENT — action required

<entries here, each with: attributed claim, what the paper actually says, suggested fix>

---

## ⚠ IMPRECISE — review recommended

<entries here, each with: what is overstated/missing, suggested minimal fix>

---

## ? UNVERIFIABLE — manual check required

<entries here, each with: reason the paper could not be checked>

---

## ✓ CONSISTENT — no action needed

<entries here, brief note only>
```

For every ⚠ **IMPRECISE** or ✗ **INCONSISTENT** entry, always include:
- The exact thesis sentence containing the citation
- What the paper actually says (with section/figure/table reference where possible)
- A concrete LaTeX-ready suggested fix

## Guardrails
- Follow all guardrails defined in the `arxiv-check-citation` skill.
- Do **not** modify any `.tex` or `.bib` files — this is a read-only audit.
- Do not mark a citation as INCONSISTENT merely because the paper is on a related but different topic — only flag when the specific attributed claim is not supported.
- If a paper is not on arXiv, mark it as UNVERIFIABLE and note it for manual review.
- Use UK English throughout (localisation, optimisation, modelling).
