# Copilot Instructions for This Thesis

## Project Overview
- Master's thesis in Software Engineering: robot localisation in vineyard environments.
- LaTeX source (`.tex`) with a single bibliography database (`MastersThesis.bib`).
- Style files: `electhesis.cls`, `electhesis.bst`, `eleccite.sty` — do not modify unless explicitly asked.
- Main entry point: `thesis.tex`.

## Repository Layout

Front matter (root): `abstract.tex`, `acknowledgements.tex`, `notation.tex`, `preface.tex`, `appendix-a.tex`.

### Chapter file structure

```
1-intro/
├── introduction.tex
└── tex/
    ├── 1-motivation.tex
    ├── 1-research-context.tex
    ├── 1-research-objectives.tex
    └── 1-thesis-structure.tex

2-background/
├── background.tex
└── tex/
    ├── 2-robot-localisation.tex
    ├── 2-vineyard-pruning.tex
    └── 2-vineyard-robotics.tex

3-SLAM/
├── SLAM.tex
├── 3-intro/tex/3-intro.tex
├── 3-related-work/tex/3-related-work.tex
├── 3-methodology/tex/3-methodology.tex
├── 3-results/tex/3-results.tex
├── 3-discussion/tex/3-discussion.tex
└── 3-summary/tex/3-summary.tex

4-precise-alignment/
├── precise-alignment.tex
├── 4-intro/tex/4-intro.tex
├── 4-related-work/tex/4-related-work.tex
├── 4-methodology/tex/4-methodology.tex
├── 4-results/tex/4-results.tex
├── 4-discussion/tex/4-discussion.tex
└── 4-summary/tex/4-summary.tex

5-conclusion/
├── conclusion.tex
└── tex/5-future-work.tex
```

The top-level `.tex` file in each chapter `\input`s the section files listed above. Some chapters also have `figures/` subdirectories.

## Universal Conventions
- Use UK English (e.g., "localisation," "optimisation," "modelling").
- Preserve the existing chapter structure and file layout.
- Keep edits minimal and local to the requested scope.
- Prefer `\cref{}` for cross-references.
- Use `\cite{...}` or `\autocite{...}`; never hardcode citation numbers.
- Only reference citation keys that exist in `MastersThesis.bib`.
- Favour precise, academic, and technically correct language.
