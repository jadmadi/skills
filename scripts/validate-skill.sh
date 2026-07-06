#!/usr/bin/env bash
# Validate a skill's SKILL.md structure.
#
# This is a fast, dependency-free local check. It is NOT a substitute for the
# official reference validator (https://github.com/agentskills/agentskills/
# tree/main/skills-ref), which enforces the full spec (character classes,
# hyphen rules, etc.) -- run that before publishing. This script exists for
# quick local iteration.

set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/skills"

if [[ $# -ne 1 ]]; then
    echo "Usage: $(basename "$0") <bucket>/<skill-name>"
    echo "Example: $(basename "$0") engineering/adoo"
    exit 1
fi

SKILL_PATH="$1"
SKILL_NAME="$(basename "$SKILL_PATH")"
SKILL_FILE="$SKILLS_DIR/$SKILL_PATH/SKILL.md"

ERRORS=0

if [[ ! -f "$SKILL_FILE" ]]; then
    echo "ERROR: SKILL.md not found at $SKILL_FILE"
    exit 1
fi

# Count --- lines (should be at least 2)
DASHES=$(grep -c '^---$' "$SKILL_FILE" || true)
if [[ "$DASHES" -lt 2 ]]; then
    echo "ERROR: YAML frontmatter needs opening and closing '---' (found $DASHES)"
    ERRORS=$((ERRORS + 1))
fi

# Check required frontmatter fields
if ! grep -qE '^name:' "$SKILL_FILE"; then
    echo "ERROR: Missing required field 'name' in frontmatter"
    ERRORS=$((ERRORS + 1))
else
    FRONTMATTER_NAME=$(grep -m1 -E '^name:' "$SKILL_FILE" | sed -E 's/^name:[[:space:]]*//')
    if [[ "$FRONTMATTER_NAME" != "$SKILL_NAME" ]]; then
        echo "ERROR: frontmatter name '$FRONTMATTER_NAME' does not match directory name '$SKILL_NAME'"
        ERRORS=$((ERRORS + 1))
    fi
    if [[ ! "$FRONTMATTER_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
        echo "ERROR: name '$FRONTMATTER_NAME' must be lowercase alphanumeric with single hyphens (no leading/trailing/consecutive hyphens)"
        ERRORS=$((ERRORS + 1))
    fi
fi

if ! grep -qE '^description:' "$SKILL_FILE"; then
    echo "ERROR: Missing required field 'description' in frontmatter"
    ERRORS=$((ERRORS + 1))
else
    # Rough description length check (from 'description:' to next field or closing ---).
    # Handles both single-line ("description: foo") and block-scalar
    # ("description: >-" / "description: |" followed by indented lines) styles.
    DESC_BLOCK=$(awk '/^description:/{found=1} found && /^---$/{exit} found{print}' "$SKILL_FILE" \
        | sed -e '1s/^description:[[:space:]]*//' -e '1s/^[|>][-+]\{0,1\}[[:space:]]*$//' \
        | tr -d '\n' | wc -c)
    if [[ "$DESC_BLOCK" -gt 1024 ]]; then
        echo "ERROR: description block is ~$DESC_BLOCK chars (max: 1024)"
        ERRORS=$((ERRORS + 1))
    fi
fi

# Check body length
BODY_START=$(awk '/^---$/{count++} count==2{print NR; exit}' "$SKILL_FILE" || true)
if [[ -n "$BODY_START" && "$BODY_START" -gt 0 ]]; then
    LINE_COUNT=$(wc -l < "$SKILL_FILE")
    BODY_LINES=$((LINE_COUNT - BODY_START))
    if [[ "$BODY_LINES" -gt 500 ]]; then
        echo "WARNING: SKILL.md body is $BODY_LINES lines (recommended: <500)"
        echo "  Consider splitting content into references/ or scripts/"
    fi
fi

if [[ "$ERRORS" -eq 0 ]]; then
    echo "OK: $SKILL_PATH passes validation"
else
    echo "FAILED: $ERRORS error(s) found"
    exit 1
fi
