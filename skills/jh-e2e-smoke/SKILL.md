---
name: jh-e2e-smoke
description: Verify that Job Hunter still completes its minimum useful end-to-end path after a change. Use for bounded smoke/E2E acceptance, especially after browser, orchestration, profile, state, provider, or application-flow changes. Prefer the smallest real path that proves integration. Do not replace focused regression tests with a giant suite and do not perform a real external submit without explicit authorization.
---

# Job Hunter E2E Smoke

Prove that the tractor moves in the intended direction.

This skill is an acceptance check, not a debugging workflow and not a substitute for focused regression tests. Compose with `orchestrate` when evidence collection or independent verification is substantial.

## Establish the smoke boundary

Before running anything, identify:

- the change or candidate being verified;
- the user-visible or operational path that must still work;
- the smallest integration boundary that can prove it;
- whether authentication or live browser state is required;
- whether any step can submit an application, send a message, change remote state, or trigger another external action.

Reuse repository commands and existing test entry points. Do not invent a new harness merely to run a smoke check.

## Safety levels

Use the least risky level that proves the requested behavior.

### Level 0: offline integration

Use fixtures, synthetic pages, mocked providers, or local state. No network action is required.

### Level 1: authenticated read-only

Use an existing authenticated browser/session only to navigate, inspect, search, fetch, or classify. Do not submit, send, confirm, or mutate remote state.

### Level 2: live pre-submit

Exercise the real flow up to the final external-action boundary. Verify that the expected resume, fields, questions, controls, and state are correct, then stop before submission.

### Level 3: live submit

Use only when the user explicitly authorizes the concrete external action for this run. Capture what is about to be submitted before dispatch and stop on ambiguity.

Never promote a lower-confidence UI state into a higher safety level merely to finish the smoke.

## Workflow

1. Read repository instructions and the exact change under test.
2. Identify one minimum critical path. Prefer one source and one representative scenario over broad coverage.
3. Confirm the safety level and required authorization.
4. Run the smallest prerequisite checks needed to avoid wasting a live run.
5. Execute the smoke path once.
6. Capture evidence at each meaningful boundary:
   - command or entry point;
   - profile/source used;
   - relevant stage transitions;
   - selected resume or candidate identity when applicable;
   - browser/DOM classification when applicable;
   - final observed state;
   - whether any external action occurred.
7. If the smoke fails, stop broadening the run. Return the first concrete integration blocker and route debugging to the appropriate skill.
8. If the smoke passes, report exactly what was proven and what was intentionally not exercised.

## What counts as PASS

PASS requires direct evidence that the selected critical path crossed the intended integration boundaries and reached the expected final state.

A unit-test pass alone is not an E2E smoke pass.

A browser opening successfully is not an apply-flow pass.

A worker saying "looks good" is not evidence.

## Failure routing

- HH apply/browser state bug -> `hh-apply-debug`
- provider/matcher/profile/state/analytics/Telegram/runtime bug -> `jh-runtime-debug`
- candidate/release acceptance -> return evidence to `jh-release-gate`

Do not fix unrelated defects discovered during the smoke unless they block the approved path.

## Handoff

Return:

- candidate SHA or working-tree state;
- smoke level used;
- exact path exercised;
- commands/checks run;
- evidence and final state;
- external actions performed, if any;
- PASS / FAIL / BLOCKED;
- first blocker or residual uncertainty.
