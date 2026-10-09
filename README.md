# codex-skill

Reusable Codex skills with a budget-first orchestration policy.

The repository is intentionally split into generic orchestration and domain-specific skills. Job Hunter rules do **not** live inside the orchestrator.

## Included skills

### `explain-the-change`

A generic post-task teaching pass for any repository.

Invoke it directly or simply add **"с объяснением"** to a task. It explains the real diff and execution path, why changed code belongs where it does, what would break without it, and how the change was verified. It can switch to a low-jargon "на пальцах" / ELI5 mode without turning the answer into generic Python lessons.

It is deliberately **not** automatic: implementation stays implementation. The orchestrator only reminds the user once after meaningful engineering work that this teaching pass is available.

### `orchestrate`

Adapted from [harnessmachine/codex-orchestrate](https://github.com/harnessmachine/codex-orchestrate).

It keeps orchestration implicit, but adds a delegation threshold and explicit model routing:

- **GPT-6.1 Sol** owns orchestration, coding, debugging, integration and review.
- **GPT-6 Luna** gets substantial bounded mechanical work: multi-file/context search, multi-source research, test batches, logs, traces, screenshots and evidence collection.
- Luna workers are spawned explicitly as `gpt-6-luna` with low reasoning by default. The skill does not rely on inheriting the parent Sol model.
- **GPT-6 Astra** is escalation-only.
- A trivial lookup, one known file, one command, or one tiny check stays on the current agent. Delegating it would often cost more than doing it directly.
- Low-risk review is batched at natural milestones instead of spawning a fresh Sol reviewer after every intermediate blocker.
- Default concurrency is at most two subagents.

### `hh-apply-debug`

Evidence-first debugging for HeadHunter apply-flow bugs in Job Hunter.

It handles browser-state classification, resume identity, employer questions, cover-letter detection, confirmation/submit controls, uncertain dispatch, regression fixtures and bounded E2E verification.

### `jh-runtime-debug`

Evidence-first debugging for non-HH-apply Job Hunter runtime failures.

It covers matcher/provider fallback, search pipeline, profile isolation, state, analytics, Telegram control-plane, resume/facts pipeline, command dispatch and cross-module runtime regressions.

### `jh-e2e-smoke`

Bounded end-to-end acceptance for Job Hunter.

It defines offline, authenticated read-only, live pre-submit and explicitly authorized live-submit smoke levels, and reports exactly what integration path was proven.

### `jh-release-gate`

A bounded release gate for a frozen Job Hunter candidate.

It enforces the order targeted checks -> required E2E smoke -> one independent review -> at most one final full-suite run for the unchanged candidate, then returns PASS, FAIL or BLOCKED.

## Install all skills

Preferred installation keeps this repository in a stable location and symlinks each skill into Codex:

```bash
CODEX_ROOT="${CODEX_HOME:-$HOME/.codex}"
REPO="$CODEX_ROOT/shizzka-codex-skills"

if [ -d "$REPO/.git" ]; then
  git -C "$REPO" pull --ff-only
else
  git clone https://github.com/shizzka/codex-skill.git "$REPO"
fi

bash "$REPO/install.sh"
```

Then start a new Codex session or restart Codex so the skills are rediscovered.

The installer backs up any conflicting existing skill before creating the new symlink. It does not delete the backup.

## Give this repository to an agent

You can give an agent only this URL:

```text
https://github.com/shizzka/codex-skill
```

and say:

```text
Install all Codex skills from this repository and follow its AGENTS.md.
```

The root `AGENTS.md` contains the canonical installation contract.

## Update

```bash
CODEX_ROOT="${CODEX_HOME:-$HOME/.codex}"
REPO="$CODEX_ROOT/shizzka-codex-skills"
git -C "$REPO" pull --ff-only
bash "$REPO/install.sh"
```

Start a new Codex session after updating so the changed skill instructions are loaded.

## Layout

```text
skills/
  orchestrate/
  explain-the-change/
  hh-apply-debug/
  jh-runtime-debug/
  jh-e2e-smoke/
  jh-release-gate/
install.sh
AGENTS.md
```

Job Hunter-specific skills stay beside `orchestrate` under `skills/`; generic model routing and delegation policy remain inside `orchestrate`.
