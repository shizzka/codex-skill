#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_ROOT="${CODEX_HOME:-$HOME/.codex}"
TARGET="$CODEX_ROOT/skills"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_ROOT="$CODEX_ROOT/skill-backups/$STAMP"

mkdir -p "$TARGET"

installed=0
backed_up=0

for src in "$ROOT"/skills/*; do
  [[ -d "$src" && -f "$src/SKILL.md" ]] || continue

  name="$(basename "$src")"
  dst="$TARGET/$name"

  if [[ -L "$dst" ]]; then
    current="$(readlink "$dst")"
    if [[ "$current" == "$src" ]]; then
      echo "ok: $name already linked"
      installed=$((installed + 1))
      continue
    fi
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$BACKUP_ROOT"
    mv "$dst" "$BACKUP_ROOT/$name"
    echo "backup: $dst -> $BACKUP_ROOT/$name"
    backed_up=$((backed_up + 1))
  fi

  ln -s "$src" "$dst"
  echo "installed: $name -> $src"
  installed=$((installed + 1))
done

echo
echo "Installed skills: $installed"
if (( backed_up > 0 )); then
  echo "Backed up conflicts: $backed_up"
  echo "Backup location: $BACKUP_ROOT"
fi

echo "Start a new Codex session or restart Codex to rediscover skills."
