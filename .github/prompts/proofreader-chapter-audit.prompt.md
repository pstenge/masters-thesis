---
description: "Use when you want AcademicProofReader to run a full chapter audit for structure, flow, style consistency, and LaTeX/citation hygiene."
---

Use the `AcademicProofReader` agent to audit `${input:chapter_file}` and its included section files.

Scope:
- Perform a chapter-level pass, not just sentence-level edits.
- Preserve chapter intent and technical claims.

Audit checklist:
1. Structural coherence:
- Check whether sections/subsections follow a logical progression.
- Identify missing transitions between major ideas.
2. Writing quality:
- Detect verbosity, repetition, and ambiguity.
- Improve clarity while preserving precision.
3. Consistency:
- Terminology consistency across the chapter (SLAM, localisation/localization, ENU, GNSS, etc.).
- Tense consistency (present for persistent facts, past for completed experiments).
4. LaTeX correctness:
- Reference style consistency (`\\cref`, citation commands, equation references).
- Flag suspicious constructs that risk compile or formatting issues.
5. Citation hygiene:
- Flag suspicious placeholders (e.g., `[cite: 1]`, malformed `\\cite{...}` usage).
- Mark claims that appear unsupported and likely need a citation.

Return format:
- `High-priority findings`
- `Medium/low-priority findings`
- `Patch-ready rewrite suggestions`
- `Chapter-level next actions`
