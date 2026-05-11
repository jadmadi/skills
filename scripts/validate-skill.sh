#!/usr/bin/env bash
# Validate a skill's SKILL.md structure

set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/skills"

if [[ $# -ne 1 ]]; then
    echo "Usage: $(basename "$0") <skill-name>"
    exit 1
fi

SKILL_NAME="$1"
SKILL_FILE="$SKILLS_DIR/$SKILL_NAME/SKILL.md"

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
fi

if ! grep -qE '^description:' "$SKILL_FILE"; then
    echo "ERROR: Missing required field 'description' in frontmatter"
    ERRORS=$((ERRORS + 1))
else
    # Rough description length check (from 'description:' to next field or closing ---)
    DESC_BLOCK=$(awk '/^description:/{found=1} found && /^---$/{exit} found{print}' "$SKILL_FILE" | tail -n +2 | tr -d '\n' | wc -c)
    if [[ "$DESC_BLOCK" -gt 1200 ]]; then
        echo "WARNING: description block is ~$DESC_BLOCK chars (recommended: <1024)"
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
    echo "OK: $SKILL_NAME passes validation"
else
    echo "FAILED: $ERRORS error(s) found"
    exit 1
fi
