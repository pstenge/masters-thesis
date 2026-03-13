# Masters Thesis

LaTeX source for a Master's thesis in Software Engineering on robot localisation in vineyard environments.

---

## Repository Structure

### Root files

| File | Purpose |
|---|---|
| `thesis.tex` | Main entry point; inputs all chapters and front matter |
| `MastersThesis.bib` | BibTeX bibliography database |
| `electhesis.cls` | LaTeX document class for ME/PhD theses |
| `electhesis.bst` | BibTeX style for formatting references |
| `eleccite.sty` | Macros for citation commands |
| `Makefile` | Build automation |
| `abstract.tex` | Abstract |
| `acknowledgements.tex` | Acknowledgements |
| `notation.tex` | Notation table |
| `preface.tex` | Preface |
| `appendix-a.tex` | Appendix A |

### Chapter directories

Each chapter directory contains a top-level `.tex` file that `\input`s section files from a `tex/` subdirectory. Chapters with figures have a `figures/` subdirectory.

| Directory | Chapter |
|---|---|
| `1-intro/` | Introduction |
| `2-background/` | Background and literature context |
| `3-SLAM/` | SLAM experiment |
| `4-precise-alignment/` | Precise alignment experiment |
| `5-conclusion/` | Conclusion and future work |

Each experiment chapter (`3-SLAM/`, `4-precise-alignment/`) is further divided into sub-sections:

```
<chapter>/
├── <chapter>.tex          # Top-level chapter file
├── <n>-intro/tex/
├── <n>-related-work/tex/
├── <n>-methodology/tex/
├── <n>-results/tex/
├── <n>-discussion/tex/
└── <n>-summary/tex/
```

---

## Agentic Workflows (`.github/`)

This repository is configured with GitHub Copilot agentic workflows for writing assistance, proofreading, and build automation.

### Global instructions

`.github/copilot-instructions.md` — Injected into every Copilot session. Declares project context, repository layout, and universal conventions (UK English, `\cref{}`, `\cite{}`/`\autocite{}`, no modifications to style files, minimal-scope edits).

---

### Agents (`.github/agents/`)

Named Copilot agents invokable via `@AgentName` in chat.

| Agent | File | Purpose |
|---|---|---|
| `AcademicProofReader` | `AcademicProofReader.agent.md` | Grammar, style, LaTeX hygiene, and citation checks. Produces a structured diagnostic report with line-level edits. Will not invent citations or alter technical claims. |
| `AcademicWriter` | `AcademicWriter.agent.md` | Drafts new LaTeX sections in a formal, measured academic style. Outputs paste-ready LaTeX with rationale and follow-up questions. Will not fabricate results. |
| `BibManager` | `BibManager.agent.md` | Bibliography hygiene: cross-checks `\cite{}` keys against `MastersThesis.bib`, flags missing/duplicate/malformed entries, and suggests BibTeX-ready patches. Will not invent metadata. |

---

### Prompts (`.github/prompts/`)

Reusable prompt templates, each parameterised by a file path input. Run them from the Copilot chat prompt picker.

| Prompt | Input parameter | Purpose |
|---|---|---|
| `chapter-review.prompt.md` | `chapter_file` | Full chapter review: structure, weak claims, verbose passages, citation checks, terminology. Returns a prioritised issue list and LaTeX-ready edits. |
| `proofreader-chapter-audit.prompt.md` | `chapter_file` | Five-point audit via `AcademicProofReader`: structural coherence, writing quality, terminology/tense, LaTeX correctness, citation hygiene. |
| `proofreader-changed-files.prompt.md` | `chapter_dir` | Delegates to `AcademicProofReader` to review only git-changed `.tex` files in a chapter directory. |
| `proofreader-section-pass.prompt.md` | `section_file` | Focused section-level polish via `AcademicProofReader`: grammar, paragraph flow, argument clarity, local LaTeX correctness. |

---

### Skills (`.github/skills/`)

Reusable, self-contained workflows loaded by agents or Copilot on demand.

| Skill | Directory | Purpose |
|---|---|---|
| `academic-proofreader` | `skills/academic-proofreader/` | Five-stage proofreading workflow (scope → language → logic → LaTeX → consistency). Outputs a structured report using `assets/review-output-template.md`. |
| `bib-fixer` | `skills/bib-fixer/` | Four-step bibliography maintenance: detect used keys, compare against `.bib`, report issues, suggest field normalisation. |
| `compile-pdf` | `skills/compile-pdf/` | Runs the `pdflatex → bibtex → pdflatex → pdflatex` build, verifies `thesis.pdf` was updated, and applies minimal fixes if the build fails. |

---

### Hooks (`.github/hooks/`)

`hooks.json` defines a `latex-sanity-check` automation that fires on every `.tex` file save. It optionally runs `latexmk -pdf` on `thesis.tex` and `chktex` on the saved file. Both commands are marked optional, so failures do not block saving.
