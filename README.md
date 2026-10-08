# codex-skill

A small collection of reusable Codex skills.

## Skills

### orchestrate

Budget-aware orchestration for delegated Codex work.

Default routing:

- **GPT-6 Luna** for repository search, context gathering, command execution, test runs, log collection, and other bounded mechanical checks.
- **GPT-6.1 Sol** for orchestration, implementation, debugging, architecture decisions, integration, and independent review.
- **GPT-6 Astra** only as an escalation path for genuinely hard or high-risk cases. If Astra is unavailable, fall back to GPT-6.1 Sol with higher reasoning effort.

The policy deliberately prefers the cheapest model that can reliably perform the role. A failing test by itself is not a reason to escalate.

## Install

Clone the repository somewhere convenient and link the skill directory into Codex:

```bash
git clone https://github.com/shizzka/codex-skill.git
mkdir -p ~/.codex/skills
ln -s "$(pwd)/codex-skill/orchestrate" ~/.codex/skills/orchestrate
```

Restart Codex or start a new session after installation.

## Upstream

The `orchestrate` skill is adapted from [harnessmachine/codex-orchestrate](https://github.com/harnessmachine/codex-orchestrate), licensed under the MIT License. See `orchestrate/LICENSE`.
