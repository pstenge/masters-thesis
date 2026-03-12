---
description: "Use when you want AcademicProofReader to review only changed LaTeX files in a specific chapter (git diff scoped)."
---

Use the `AcademicProofReader` agent to review only modified files under `${input:chapter_dir}`.

Scope rules:
1. Identify changed files using git diff status.
2. Restrict to LaTeX files matching `${input:chapter_dir}/**/*.tex`.
3. Ignore unchanged files.
4. If no changed `.tex` files exist, return `No changed LaTeX files found in scope`.

Review focus (changed lines first, then local context):
- Grammar, punctuation, and sentence clarity.
- Paragraph flow and local argument continuity.
- LaTeX hygiene in edited regions:
- `\\cref{...}` consistency for cross-references.
- Math variables in `$...$`.
- Citation command correctness (`\\cite{...}` / `\\autocite{...}`).
- Suspicious placeholders (e.g., `[cite: n]`).

Project consistency checks in edited files:
- Terminology consistency with nearby text (e.g., `localisation` preferred unless context requires otherwise).
- Tense consistency in method/result narratives.

Return format:
- `Changed files reviewed`
- `High-priority issues`
- `Patch-ready LaTeX edits`
- `Residual risks` (if any)
