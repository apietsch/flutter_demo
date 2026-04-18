## Context

The screening workspace is already implemented in the app and reachable from the lorem loader screen, but it is not represented in OpenSpec. The current behavior includes a seeded paper list, status-based filtering, and user actions to mark papers as include, exclude, or maybe, with an exclusion note required through a dialog flow.

## Goals / Non-Goals

**Goals:**
- Capture the existing screening workspace behavior as an OpenSpec capability.
- Describe the current user-visible screening actions, filters, and exclude-note flow.
- Create a requirements baseline that future screening changes can extend safely.

**Non-Goals:**
- Redesign the screening workspace UI.
- Introduce persistence, backend integration, or imported paper sources.
- Change the current seeded-paper behavior during this spec capture.

## Decisions

- Model the screening workspace as a new standalone capability named `screening-workspace`.
  Rationale: the feature is already implemented and distinct enough to deserve its own contract instead of being implied by broader demo-entry-point context.
- Describe the current screen as a seeded local workflow rather than a data-backed system.
  Rationale: the code currently operates on in-memory seeded paper items, so the spec should reflect present behavior without implying server integration.
- Include the exclude-note requirement explicitly.
  Rationale: requiring an exclusion note is one of the main decision-path differences in the current UI and should not be lost in future refactors.

## Risks / Trade-offs

- [Risk] The spec could accidentally imply persistence or imported datasets that do not exist yet. -> Mitigation: keep requirements scoped to seeded papers and local state transitions only.
- [Risk] Future screening changes may need to modify these requirements once real data integration is added. -> Mitigation: treat this as a baseline capability that can be extended through later delta specs.
