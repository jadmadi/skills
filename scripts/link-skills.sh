#!/usr/bin/env bash
set -euo pipefail

# Links every skill in this repo into the local skill directories used by
# each agent harness on this machine, via symlink. Because it's a symlink
# into this repo (not a copy), a `git pull` is all that's needed to keep
# installed skills current -- there's nothing to re-sync after an edit.
#
# Once these skills are installed via `npx skills add jadmadi/skills` (see
# README.md) and kept current with `skills update`, that CLI manages its own
# local copy and symlinks it in for you -- this script is the manual
# equivalent for local development on this repo itself.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=(
  "$HOME/.claude/skills"
  "$HOME/.config/devin/skills"
  "$HOME/.agents/skills"
  "$HOME/.codeium/windsurf/skills"
  "$HOME/.cursor/skills"
)

# Collect the repo's skills once (skip TEMPLATE -- it's a scaffold, not a
# shipped skill), link into every destination that exists on this machine.
names=()
srcs=()
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  names+=("$(basename "$src")")
  srcs+=("$src")
done < <(find "$REPO/skills" -mindepth 2 -name SKILL.md -not -path '*/TEMPLATE/*' -print0)

for DEST in "${DESTS[@]}"; do
  if [[ ! -d "$DEST" ]]; then
    continue
  fi

  # If $DEST is itself a symlink into this repo, we'd end up writing the
  # per-skill symlinks back into the repo's own skills/ tree. Detect and
  # bail out instead of polluting the working copy.
  if [ -L "$DEST" ]; then
    resolved="$(readlink -f "$DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $DEST is a symlink into this repo ($resolved)." >&2
        echo "Remove it (rm \"$DEST\") and re-run; the script will recreate it as a real dir." >&2
        exit 1
        ;;
    esac
  fi

  for i in "${!names[@]}"; do
    name="${names[$i]}"
    src="${srcs[$i]}"
    target="$DEST/$name"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      rm -rf "$target"
    fi

    ln -sfn "$src" "$target"
    echo "linked $name -> $src ($DEST)"
  done
done
