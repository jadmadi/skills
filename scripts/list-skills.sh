#!/usr/bin/env bash
set -euo pipefail

# Adapted from mattpocock/skills' scripts/list-skills.sh:
# https://github.com/mattpocock/skills/blob/main/scripts/list-skills.sh

REPO="$(cd "$(dirname "$0")/.." && pwd)"

cd "$REPO"
find skills -name SKILL.md -not -path '*/TEMPLATE/*' | sort
