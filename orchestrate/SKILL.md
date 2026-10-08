---
name: orchestrate
description: Use when work should be delegated across subagents while one orchestrator keeps decisions, scope, integration, budget, and final acceptance.
---

# Orchestrate

The orchestrator owns task understanding, product and architecture decisions, decomposition, integration, cost discipline, and final acceptance. Subagents handle bounded research, implementation, testing, and review.

The objective is not to maximize the number or capability of agents. Use the cheapest model that can reliably perform each bounded role.

## Workflow

1. Read the request and applicable repository instructions.
2. Resolve decisions that affect scope, behavior, architecture, public interfaces, permissions, or acceptance criteria before delegation.
3. Split work into bounded packages. Run independent packages concurrently only when doing so materially helps.
4. Prevent concurrent writers from touching the same files, tests, schemas, generated artifacts, or shared configuration.
5. Dispatch each package with:
   - objective;
   - exact allowed scope and ownership;
   - acceptance criteria;
   - required checks;
   - non-goals;
   - permission limits;
   - expected evidence.
6. Receive results through native messages. A HANDOFF must report:
   - result or finding;
   - files changed or inspected;
   - checks run;
   - acceptance mapping;
   - remaining risks;
   - recommended next step.
7. Inspect actual evidence. `DONE` is a claim, not proof.
8. Return defects to the responsible implementer.
9. Use a fresh independent reviewer for work with meaningful behavioral, integration, security, or regression risk.
10. Synthesize the final answer only after the integrated result is verified.

Keep coordination in messages and HANDOFF replies. Do not create planning files, state files, logs, or bookkeeping artifacts unless the user or repository contract explicitly requires them.

## Budget-first model routing

Use the user's explicit routing when provided. Otherwise prefer this routing when the models are available.

### Orchestrator

Use **GPT-6.1 Sol** with **medium** reasoning by default.

Responsibilities:
- understand the task;
- define scope and acceptance;
- decompose work;
- choose workers;
- make architecture and product decisions;
- integrate results;
- decide whether escalation is justified;
- perform final acceptance.

Increase Sol reasoning to **high** when the task contains ambiguous architecture, difficult debugging, risky migrations, or conflicting evidence.

### Luna workers

Use **GPT-6 Luna** with **low** reasoning for cheap, bounded mechanical work:

- repository search and file discovery;
- gathering narrow context;
- running commands;
- running targeted tests;
- running smoke checks;
- collecting stdout, stderr, traces, screenshots, or logs;
- comparing observed output against explicit acceptance criteria;
- checking deterministic conditions;
- summarizing evidence for the orchestrator.

Use Luna with **medium** reasoning for bounded analysis when the required decision is local, reversible, and supported by explicit evidence.

Do not ask Luna to own an ambiguous root-cause investigation, architecture decision, broad refactor, or risky behavioral change merely to save tokens.

A test failure alone is not a reason to escalate models. Luna reports the failure and evidence; the orchestrator decides what reasoning is required next.

### Implementation and debugging

Use **GPT-6.1 Sol** with **medium** reasoning for normal code changes.

Use **GPT-6.1 Sol** with **high** reasoning for:
- non-obvious root-cause analysis;
- concurrency or race-condition bugs;
- cross-cutting refactors;
- state-machine or workflow bugs;
- behavior involving several fallback paths;
- changes with meaningful regression risk.

A Luna worker may make a mechanical edit only when the exact change is fully specified, behavior is not being redesigned, and no local engineering judgment is required. Otherwise use Sol.

### Independent review

Use a **fresh GPT-6.1 Sol agent** with **medium** reasoning by default.

The reviewer must verify the diff, acceptance criteria, relevant tests, and regression risk independently. Do not use the implementing agent as the only reviewer for meaningful changes.

Use **high** reasoning when the change is large, subtle, security-sensitive, or has already failed review once.

### Astra escalation

Use **GPT-6 Astra** only when at least one of these conditions is true:

- the architecture remains materially ambiguous after Sol analysis;
- two competent Sol implementation/debugging attempts failed on the same root problem;
- implementer and independent reviewer disagree on a substantive issue;
- there is meaningful security, destructive-data, or irreversible migration risk;
- the orchestrator cannot reach a confident acceptance decision from the available evidence.

Do not escalate merely because a test failed, a command returned an error, or a worker asked for a stronger model.

If Astra is unavailable, keep the task on GPT-6.1 Sol and increase reasoning effort instead of blocking the workflow.

## Cost and concurrency discipline

- Prefer one capable worker over several overlapping workers.
- Default to at most **two concurrent subagents** unless there are clearly independent work packages.
- Do not spawn separate agents for trivial steps the current worker can perform cheaply.
- Use Luna to gather and compress context before handing a narrow evidence package to Sol.
- Run the smallest checks that establish the requested behavior first.
- Do not run a full test suite automatically when targeted checks and smoke tests are sufficient, unless repository rules or the task explicitly require the full suite.
- Avoid repeated reviewer loops. A review must identify concrete defects or accept the result.

## Testing

Testing has two separate roles:

1. **Execution and evidence collection**: normally Luna.
2. **Interpretation and repair**: Sol when engineering judgment is required.

A typical flow is:

```text
Luna: run targeted checks and collect evidence
  -> PASS: continue acceptance
  -> FAIL: return exact evidence to orchestrator
      -> Sol: diagnose and implement minimal fix
          -> Luna: rerun targeted checks
              -> Luna: run smoke if appropriate
                  -> fresh Sol reviewer: verify acceptance
```

When TDD is requested, establish accepted behavior and an exact observable boundary first. A tester demonstrates a meaningful RED before implementation; an implementer produces the smallest GREEN result; a fresh reviewer verifies behavior and test quality. Tests written after existing implementation are regression tests, not TDD.

## Permissions and boundaries

Invocation authorizes delegation only inside the requested task. It does not authorize expanded scope, commits, pushes, deployments, publication, destructive changes, or messages to people or services outside the run.

Never delete or revert existing work without authorization.

If delegation or a requested model is unavailable, preserve the same roles using available agents and report the fallback in the HANDOFF or final result.
