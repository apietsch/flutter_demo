# Figma Make Design Usage

This project can consume a Figma Make export (`.make`) as a design handoff artifact.

## What was used
- Input file: `Paper Screening Workspace.make`
- Target implementation: Flutter UI in `lib/features/screening/ui/screening_workspace_page.dart`
- App entry integration: button from `LoremLoaderPage` app bar

## How the `.make` file was interpreted
A `.make` file is a ZIP container. We extracted and inspected:
- `thumbnail.png` for visual layout reference
- `meta.json` for basic canvas metadata
- `ai_chat.json` for design intent, UI structure, and labels
- bundled `images/*` assets when needed

## Implemented from the design
- Paper Screening Workspace header + subtitle
- Horizontal filter chips with live counts
- Paper cards with PMID, title, author/journal/year
- Decision actions: Include, Exclude, Maybe
- Exclude note capture dialog
- Status badge updates and filtering behavior

## Repeatable workflow
1. Place exported `.make` file in repo root.
2. Extract it locally (`unzip`) and inspect `thumbnail.png`, `meta.json`, `ai_chat.json`.
3. Map visual + interaction patterns to Flutter widgets.
4. Integrate new screen via navigation from existing home page.
5. Validate with `flutter analyze` and run on target device/simulator.

## Notes
- Keep extracted temp folders (for example `.tmp/`) out of git.
- Commit the source `.make` file only when it should be part of project history.
