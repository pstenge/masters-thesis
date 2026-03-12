---
description: "Use when you want AcademicProofReader to polish one LaTeX section for grammar, flow, argument clarity, and local LaTeX correctness."
---

Use the `AcademicProofReader` agent to review `${input:section_file}`.

Context:
- This is a Master's thesis in robotics/software engineering.
- Keep technical meaning unchanged.
- Keep edits local to the target section.

Review objectives:
1. Correct grammar, punctuation, and awkward phrasing.
2. Improve paragraph flow and sentence transitions.
3. Tighten argument logic so each paragraph has one clear purpose.
4. Enforce consistent academic tone and terminology.
5. Check local LaTeX usage:
- Prefer `\\cref{...}` over bare `\\ref{...}` where appropriate.
- Keep math variables in `$...$`.
- Use citation commands (`\\cite{...}` or `\\autocite{...}`), not inline placeholders.

Project-specific checks:
- Flag inconsistent spelling variants (e.g., `localisation` vs `localization`) and recommend one form consistent with nearby text.
- Flag unresolved citation placeholders such as `[cite: n]`.

Return format:
- `Issues (prioritized)`
- `Suggested edits (LaTeX-ready)`
- `Open questions` (only if needed)
