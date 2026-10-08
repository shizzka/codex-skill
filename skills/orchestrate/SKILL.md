---
name: orchestrate
description: Use when work benefits from delegation across subagents while one orchestrator keeps decisions, scope, integration, budget, and final acceptance. Invoke implicitly for substantial multi-step, parallelizable, context-heavy, implementation, debugging, testing, or review work. Do not delegate trivial single-lookups or one-step checks merely because delegation is available.
---

# Orchestrate

The orchestrator owns task understanding, product and architecture decisions, decomposition, integration, cost discipline, and final acceptance. Subagents handle bounded research, implementation, testing, and review.

The objective is not to maximize agent count or model capability. Use the cheapest model that can reliably perform each bounded role, while avoiding delegation overhead when the current agent can complete a small task directly.

## Delegation threshold

Before spawning a subagent, compare delegation overhead with the expected work.

Keep the work on the current orchestrator when it is small and local, for example:

- one straightforward web lookup;
- reading one or two known files;
- one deterministic command or targeted test;
- a tiny edit whose behavior is already fully specified;
- a check where packaging context and receiving a handoff would cost more than doing it directly.

Prefer delegation when at least one is true:

- the work requires several searches, files, pages, logs, traces, screenshots, or test commands;
- the work can run independently in parallel;
- the mechanical work would consume substantial orchestrator context;
- a bounded worker can return a compact evidence package instead of raw context;
- implementation and verification should be separated;
- an independent reviewer is justified by regression, security, integration, or behavioral risk.

Do not spawn a worker only to save model price on a task that is too small to amortize delegation overhead.

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
9. Use a fresh independent reviewer only when the change has meaningful behavioral, integration, security, or regression risk.
10. Synthesize the final answer only after the integrated result is verified.

Keep coordination in messages and HANDOFF replies. Do not create planning files, state files, logs, or bookkeeping artifacts unless the user or repository contract explicitly requires them.

## Budget-first model routing

Use the user's explicit routing when provided. Otherwise prefer this routing when the models are available.

### GPT-6.1 Sol: orchestrator and engineering work

Use **GPT-6.1 Sol** with **medium** reasoning by default for:

- orchestration;
- implementation;
- debugging;
- architecture and product decisions;
- integration;
- acceptance;
- independent review.

Increase reasoning to **high** for ambiguous architecture, difficult root-cause analysis, concurrency bugs, risky migrations, cross-cutting refactors, or conflicting evidence.

### GPT-6 Luna: bounded mechanical work

Use **GPT-6 Luna** with **low** reasoning for sufficiently substantial but bounded mechanical work:

- repository search and file discovery;
- multi-file context gathering;
- multi-source web research where the target question is already well defined;
- running targeted tests or smoke checks;
- collecting stdout, stderr, logs, traces, screenshots, DOM evidence, or command results;
- deterministic comparisons against explicit acceptance criteria;
- compressing raw evidence into a narrow handoff.

Use Luna with **medium** reasoning for bounded local analysis when the decision is reversible, evidence-backed, and does not require architecture ownership.

Do not delegate a single quick lookup to Luna by default. The orchestration and handoff can cost more than the lookup itself.

Do not ask Luna to own ambiguous root-cause investigation, architecture, broad refactors, or risky behavioral changes merely to save tokens.

A failing test alone is not a reason to escalate models. Luna returns the failure and evidence; the orchestrator decides what reasoning is required next.

### GPT-6 Astra: escalation only

Use **GPT-6 Astra** only when at least one condition is true:

- architecture remains materially ambiguous after a serious Sol analysis;
- two competent Sol implementation/debugging attempts fail on the same root problem;
- implementer and independent reviewer disagree on a substantive issue;
- there is meaningful security, destructive-data, or irreversible migration risk;
- Sol cannot reach a confident acceptance decision from the available evidence.

Do not escalate merely because a command failed, a test is red, or a worker requested a stronger model.

If Astra is unavailable, keep the task on GPT-6.1 Sol and increase reasoning effort rather than blocking the workflow.

## Cost and concurrency discipline

- Prefer one capable worker over several overlapping workers.
- Default to at most **two concurrent subagents** unless work packages are clearly independent.
- Do not spawn separate agents for trivial steps the current worker can perform cheaply.
- Use Luna to gather and compress bulky mechanical context before handing a narrow evidence package to Sol.
- Run the smallest checks that establish requested behavior first.
- Do not run a full test suite automatically when targeted checks and smoke tests are sufficient, unless repository rules or the task require it.
- Avoid repeated reviewer loops. Review must identify concrete defects or accept the result.
- Reuse existing evidence instead of asking multiple workers to rediscover the same context.

## Testing

Separate test execution from engineering interpretation.

Typical flow:

```text
Sol orchestrator
  -> Luna: run a meaningful batch of checks and collect evidence
      -> PASS: Sol accepts or continues
      -> FAIL: Luna returns exact evidence
          -> Sol: diagnose and implement the smallest fix
              -> Luna: rerun targeted checks
                  -> optional bounded smoke
                      -> fresh Sol reviewer only if risk justifies it
```

For one tiny test command, Sol may run it directly. Do not create a Luna worker solely to execute a command that is cheaper than the handoff.

When TDD is requested, establish accepted behavior and an exact observable boundary first. A tester demonstrates a meaningful RED before implementation; an implementer produces the smallest GREEN result; a fresh reviewer verifies behavior and test quality. Tests written after existing implementation are regression tests, not TDD.

## Permissions and boundaries

Invocation authorizes delegation only inside the requested task. It does not authorize expanded scope, commits, pushes, deployments, publication, destructive changes, or messages to people or services outside the run.

Never delete or revert existing work without authorization.

If delegation or a requested model is unavailable, preserve the same roles using available agents and report the fallback in the HANDOFF or final result.
