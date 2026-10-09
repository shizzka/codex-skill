---
name: explain-the-change
description: Explain a just-completed implementation or debugging change so the user can understand and defend it. Invoke when the user says "с объяснением", "объясни изменения", "объясни на пальцах", "как пятилетнему", "teach me this change", asks why a function lives where it does, or explicitly invokes explain-the-change. Generic across repositories; use after the change is complete, not instead of implementation.
---

# Explain the Change

Turn a completed code change into a mental model the user can actually carry away.

This is a teaching pass, not another implementation pass. Do not modify code unless the user separately asks for a change.

## Grounding

Explain the actual change, not generic programming theory.

Before explaining:

1. inspect the relevant diff, commit, or working-tree change;
2. identify the smallest execution path that reaches the changed code;
3. read enough surrounding code to explain why the changed function/module is there;
4. distinguish facts visible in code from assumptions.

If the change context is unclear, first locate the latest user-requested change. Do not invent architecture from filenames or test names.

## Default explanation

Use beginner-friendly language by default. Assume the user may understand the product behavior much better than the implementation.

Explain in this order:

1. **What problem existed** — one concrete sentence.
2. **What happens now** — one concrete sentence.
3. **Execution path** — show the path with arrows, for example:
   `command -> handler -> service -> provider -> result`.
4. **What changed** — name the important files/functions and explain each one's job.
5. **Why this code lives here** — explain ownership and boundaries, not merely "because the architecture says so".
6. **Why the fix works** — connect the changed condition/state/call to the original failure.
7. **What would break without it** — give 1-3 concrete failure scenarios.
8. **How we proved it** — tests, logs, traces, manual/E2E evidence, or explicitly state what was not proven.
9. **Interview version** — finish with a short explanation the user could repeat to another engineer.

Prefer line/file references and tiny critical snippets over dumping whole functions.

## "Explain like I'm five" mode

When the user asks "на пальцах", "как пятилетнему", "ELI5", or equivalent:

- start with an everyday analogy;
- introduce at most one new technical term at a time;
- define each term immediately;
- keep the first pass short;
- then map the analogy back to the real functions/files.

Do not make the explanation childish or patronizing. The point is low cognitive load, not baby talk.

## Understanding checks

When useful, add 2-3 tiny questions after the explanation, for example:

- "Что первым вызывает эту функцию?"
- "Что произойдет, если этот guard убрать?"
- "Почему состояние сохраняется здесь, а не в UI-слое?"

Questions should test the exact change, not trivia or syntax memorization.

If the user answers incorrectly, explain the gap and point back to the relevant code path. Do not turn the session into an exam unless the user asks.

## Anti-bullshit rules

Do not use empty phrases such as:

- "улучшили robustness";
- "сделали архитектуру чище";
- "повысили maintainability";
- "оптимизировали flow";

unless you immediately state the observable mechanism and trade-off.

Do not pretend the user now "knows Python" because one diff was explained.

Do not hide uncertainty. If the reason a function lives in a module is historical rather than architectural, say that.

Do not teach syntax for its own sake. Teach syntax only when it blocks understanding of the change.

## Boundaries

- Do not run a full test suite just to explain an already verified change.
- Do not refactor while teaching.
- Do not broaden into a repository tour unless necessary to explain the execution path.
- Do not repeat information already explained in the task handoff.
- Keep the explanation proportional to the change.

The goal is simple: after the pass, the user should be able to say what changed, why it belongs there, why it fixes the bug, and what would fail if it were removed.
