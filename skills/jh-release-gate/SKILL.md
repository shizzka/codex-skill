---
name: jh-release-gate
description: Decide whether a Job Hunter change set is ready to ship. Use after implementation or a stabilization batch when a candidate needs focused verification, E2E smoke, independent review, and at most one final full-suite run. Prevent endless reviewer/test loops. Do not publish, tag, merge, deploy, or push unless separately authorized.
---

# Job Hunter Release Gate

Turn a finished change set into a binary release decision with bounded verification.

This skill does not own implementation. It verifies a concrete candidate and stops when evidence is sufficient or a blocking defect is found.

## Candidate freeze

Start from one explicit candidate:

- commit SHA, branch head, or clearly described working-tree state;
- intended change scope;
- acceptance criteria;
- known risks or deliberately deferred work.

If the candidate changes after verification begins, invalidate only the evidence affected by that change. Do not automatically restart every gate.

## Gate order

Run gates from cheapest and most local to broadest.

### 1. Candidate sanity

Verify:

- the diff matches the intended scope;
- no obvious generated/runtime/private artifacts are accidentally included;
- no unrelated refactor or dependency churn slipped in;
- repository instructions are satisfied.

### 2. Targeted checks

Run the smallest relevant tests, fixtures, linters, or deterministic checks for the changed behavior.

On failure, stop. Return the blocker to implementation/debugging. Do not run the full suite to obtain a larger pile of red output.

### 3. Critical smoke

Use `jh-e2e-smoke` when the change crosses integration boundaries or affects a live workflow.

A browser/integration change is not releasable from unit tests alone.

### 4. Independent review

Use one fresh review at the natural candidate boundary.

Focus review on:

- regression risk;
- safety/fail-closed behavior;
- external action boundaries;
- state/profile isolation;
- stale or duplicate dispatch risk;
- mismatch between tests and real behavior.

Do not spawn repeated reviewers merely because the previous reviewer accepted the candidate.

If review finds a blocker, fix it outside this gate, then rerun only the evidence invalidated by the fix plus the final acceptance steps.

### 5. Full suite once

Run the complete regular regression suite only after targeted checks, smoke, and review are green, unless repository policy explicitly requires an earlier full run.

For one unchanged candidate, the default budget is one final full-suite run.

If it fails, record the exact failures and stop. Do not enter an automatic fix -> full suite -> review -> full suite loop.

## Release decision

Return exactly one decision:

- **PASS**: required evidence is green for the frozen candidate;
- **FAIL**: a reproducible defect violates acceptance or safety;
- **BLOCKED**: required verification cannot be performed or evidence is ambiguous.

PASS means "candidate is technically ready under the checked scope." It does not authorize merge, push, tag, release, deployment, or real external actions.

## Evidence package

Report:

- candidate SHA / working-tree identity;
- intended scope;
- targeted checks and results;
- smoke result and level, if applicable;
- independent review result;
- full-suite command/result, if run;
- skipped gates with concrete reason;
- residual risks/deferred items;
- final PASS / FAIL / BLOCKED decision.

Do not hide a skipped gate behind a generic "tests passed" statement.
