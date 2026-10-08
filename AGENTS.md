# AGENTS.md

## Purpose

This repository contains reusable Codex skills.

Keep generic orchestration separate from product/domain-specific skills. Do not add Job Hunter, HeadHunter, Playwright, OSINT, or other domain rules to `skills/orchestrate`.

## Installation contract

When a user asks to install the skills from this repository:

1. Use a stable clone location:
   ```bash
   CODEX_ROOT="${CODEX_HOME:-$HOME/.codex}"
   REPO="$CODEX_ROOT/shizzka-codex-skills"
   ```
2. If `$REPO/.git` exists, update it with:
   ```bash
   git -C "$REPO" pull --ff-only
   ```
3. Otherwise clone:
   ```bash
   git clone https://github.com/shizzka/codex-skill.git "$REPO"
   ```
4. Run:
   ```bash
   bash "$REPO/install.sh"
   ```
5. Report which skills were installed and any backups created.
6. Tell the user a new Codex session/restart may be required for discovery.

Do not manually copy selected files when the installer is available.

## Skill layout

Every installable skill lives directly under `skills/<skill-name>/` and contains `SKILL.md`.

The installer discovers these directories automatically.

## Orchestrator policy

`skills/orchestrate` is a generic budget-aware adaptation of the upstream orchestrator.

Keep these principles intact:

- implicit invocation is allowed;
- do not delegate trivial work;
- GPT-6.1 Sol owns orchestration and engineering judgment;
- GPT-6 Luna handles substantial bounded mechanical/context work;
- GPT-6 Astra is escalation-only;
- default concurrency is at most two subagents;
- evidence matters more than worker claims.

Domain-specific workflows belong in separate skills and may compose with `orchestrate`.

## Changes

Preserve upstream attribution and MIT license in `skills/orchestrate`.

Prefer small skills with clear triggers, boundaries, invariants, and evidence requirements over large catch-all instruction files.
