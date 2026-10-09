---
name: jh-runtime-debug
description: Diagnose and fix non-HH-apply Job Hunter runtime failures. Use for matcher/provider fallback, search pipeline, profile isolation, state, analytics, Telegram control-plane, resume/facts pipeline, command dispatch, or other runtime regressions outside the HeadHunter browser apply UI. Prefer evidence-first root cause and targeted regression coverage. Route HH apply/browser bugs to hh-apply-debug.
---

# Job Hunter Runtime Debug

Debug Job Hunter runtime failures from evidence, not from speculative refactors.

This skill covers non-HH-apply runtime behavior. Use `hh-apply-debug` for HeadHunter response forms, resume selection inside apply UI, employer questions, cover-letter controls, confirmation, submit, or ambiguous HH browser state.

## Triage first

Identify:

- failing command/run;
- profile;
- source;
- run id or timestamp when available;
- first incorrect stage;
- expected behavior;
- observed behavior;
- whether any remote/external action may have occurred.

Preserve the smallest useful log window and state evidence. Do not dump an entire multi-megabyte log into the main context when a bounded excerpt proves the transition.

## Classify the failure

Prefer one primary class:

- command/dispatch;
- search/source collection;
- dedupe/filter;
- matcher/LLM decision;
- provider routing/fallback/quota;
- resume/facts/knowledge grounding;
- profile isolation/config activation;
- local state/idempotency;
- analytics/reporting;
- Telegram/control-plane;
- concurrency/lifecycle;
- unknown/cross-cutting.

Classification is a starting hypothesis, not permission to edit that subsystem.

## Workflow

1. Read repository instructions and inspect evidence around the first bad transition.
2. Reproduce the smallest failing case offline or deterministically when possible.
3. Separate root cause from downstream noise. Later failures caused by the same bad state are not separate bugs by default.
4. Add or identify a regression test/fixture that fails for the observed reason.
5. Make the smallest fix that restores the intended contract.
6. Run targeted checks.
7. Run a bounded integration check when the defect crosses module boundaries.
8. Use `jh-e2e-smoke` if the fix needs end-to-end acceptance.
9. Return evidence, not confidence language.

## Provider and LLM failures

Do not convert provider exhaustion, timeout, malformed output, or unavailable scoring into a semantic candidate rejection.

Preserve fail-safe/deferred behavior unless the requested change explicitly changes that contract.

When investigating quota/fallback behavior, distinguish:

- provider unavailable;
- account/quota exhausted;
- model unavailable;
- malformed response;
- transport error;
- application policy rejection.

Do not "fix" quota exhaustion by silently lowering decision quality or bypassing safety guards.

## State and profile failures

Treat cross-profile leakage, stale state, duplicate dispatch, and uncertain external actions as high-risk.

Do not delete state, cookies, queues, or history to make a test pass unless the user explicitly authorizes that destructive action and it is actually part of the fix.

## Handoff

Return:

- root cause;
- failure class;
- first bad transition;
- evidence inspected;
- files changed;
- regression test/fixture;
- targeted/integration checks and results;
- candidate SHA or working-tree state;
- residual risk or unresolved uncertainty.

If the bug is actually in HH apply/browser state, stop and route it to `hh-apply-debug`.
