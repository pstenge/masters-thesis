# Copilot Instructions for This Thesis

## Project Overview
- Master's thesis in Software Engineering: robot localisation in vineyard environments.
- LaTeX source (`.tex`) with a single bibliography database (`MastersThesis.bib`).
- Style files: `electhesis.cls`, `electhesis.bst`, `eleccite.sty` — do not modify unless explicitly asked.
- Main entry point: `thesis.tex`.

## Repository Layout

| Directory | Contents |
|---|---|
| `1-intro/` | Introduction chapter |
| `2-background/` | Background and literature context |
| `3-SLAM/` | SLAM experiment chapter |
| `4-precise-alignment/` | Precise alignment experiment chapter |
| `5-conclusion/` | Conclusion and future work |

Each chapter directory contains a top-level `.tex` file that `\input`s section files from a `tex/` subdirectory. Some chapters also have `figures/` subdirectories.

Front matter: `abstract.tex`, `acknowledgements.tex`, `notation.tex`, `preface.tex`.

## Universal Conventions
- Use UK English (e.g., "localisation," "optimisation," "modelling").
- Preserve the existing chapter structure and file layout.
- Keep edits minimal and local to the requested scope.
- Prefer `\cref{}` for cross-references.
- Use `\cite{...}` or `\autocite{...}`; never hardcode citation numbers.
- Only reference citation keys that exist in `MastersThesis.bib`.
- Favour precise, academic, and technically correct language.
