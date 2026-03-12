# Skill: Bib Fixer

## Purpose
Help maintain clean, consistent BibTeX entries for a robotics thesis.

## Inputs
- `MastersThesis.bib`
- Any `.tex` files that contain citation commands (`\\cite{...}`)

## What This Skill Does
1. Detect citation keys used in `.tex` files.
2. Compare against keys defined in `MastersThesis.bib`.
3. Report missing keys, likely typos, and duplicates.
4. Suggest normalization for common fields (`author`, `title`, `year`, `journal`, `booktitle`, `doi`).

## Example Workflow
1. Search all `\\cite{...}` usages across thesis chapters.
2. Build a unique list of citation keys.
3. Cross-check keys against `MastersThesis.bib`.
4. Return a compact report:
   - Missing keys
   - Unused bibliography entries
   - Formatting inconsistencies

## Guardrails
- Do not invent bibliographic facts.
- If metadata is unknown, mark as TODO instead of guessing.
- Keep existing citation key naming conventions unless asked to rename.
