---
name: hh-apply-debug
description: Diagnose and fix HeadHunter apply-flow browser bugs in Job Hunter. Use for failures involving response forms, resume selection, employer questions, cover-letter fields, submit controls, unexpected HH UI, confirmation, or manual AI apply. Prefer evidence-driven minimal fixes and regression tests. Do not use for ordinary non-HH Job Hunter bugs or roadmap edits.
---

# HH Apply Debug

Investigate the observed browser state before changing selectors or flow logic.

This skill defines the HH-specific debugging contract. It composes with a generic orchestration skill; it does not own model routing or general repository policy.

## Workflow

1. Read repository instructions and identify the exact failing apply stage.
2. Preserve the failing evidence:
   - screenshot when available;
   - relevant DOM/HTML shape;
   - trace/log stage;
   - current URL and safe UI classification;
   - external-action state.
3. Reproduce the smallest failing case offline when possible.
4. Classify the failure:
   - UI classification;
   - stale page/lifecycle;
   - resume identity;
   - employer questionnaire;
   - cover-letter detection;
   - submit or confirmation control;
   - action-boundary/uncertainty.
5. Add a regression fixture/test representing the observed UI or state.
6. Apply the smallest fix that preserves existing safety invariants.
7. Run targeted tests.
8. Run a bounded browser/E2E check when permitted.
9. Produce exact candidate SHA and evidence for review.

Never make an unknown textarea, button, dialog, or form actionable merely because it resembles a known control.

If an external action may already have occurred, treat the outcome as uncertain and do not retry automatically.

For action invariants read `references/apply-invariants.md`.

For evidence collection and DOM classification read `references/browser-evidence.md`.

Before handoff run `bash scripts/candidate-report.sh`.

## Handoff requirements

Return:

- root cause;
- observed UI/DOM class;
- changed files;
- regression test or fixture added;
- targeted checks and their results;
- browser/E2E evidence if run;
- candidate commit SHA or working-tree state;
- unresolved uncertainty or residual risk.

Do not claim success from unit tests alone when the bug is a browser-flow integration failure.
