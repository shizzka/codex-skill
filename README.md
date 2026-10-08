# codex-skill

Reusable Codex skills with a budget-first orchestration policy.

The repository is intentionally split into generic orchestration and domain-specific skills. Job Hunter rules do **not** live inside the orchestrator.

## Included skills

### `orchestrate`

Adapted from [harnessmachine/codex-orchestrate](https://github.com/harnessmachine/codex-orchestrate).

It keeps orchestration implicit, but adds a delegation threshold:

- **GPT-6.1 Sol** owns orchestration, coding, debugging, integration and review.
- **GPT-6 Luna** gets substantial bounded mechanical work: multi-file/context search, multi-source research, test batches, logs, traces, screenshots and evidence collection.
- **GPT-6 Astra** is escalation-only.
- A trivial lookup, one known file, one command, or one tiny check stays on the current agent. Delegating it would often cost more than doing it directly.
- Default concurrency is at most two subagents.

### `hh-apply-debug`

Evidence-first debugging for HeadHunter apply-flow bugs in Job Hunter.

It handles browser-state classification, resume identity, employer questions, cover-letter detection, confirmation/submit controls, uncertain dispatch, regression fixtures and bounded E2E verification.

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

## Layout

```text
skills/
  orchestrate/
  hh-apply-debug/
install.sh
AGENTS.md
```

Future skills such as `jh-e2e-smoke` and `jh-release-gate` belong beside these under `skills/`, not inside `orchestrate`.
