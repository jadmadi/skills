#!/usr/bin/env bash
# Bootstrap a new skill from the TEMPLATE

set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/skills"
TEMPLATE_DIR="$SKILLS_DIR/TEMPLATE"

if [[ $# -ne 1 ]]; then
    echo "Usage: $(basename "$0") <skill-name>"
    echo ""
    echo "Creates a new skill directory from the TEMPLATE."
    exit 1
fi

SKILL_NAME="$1"
SKILL_DIR="$SKILLS_DIR/$SKILL_NAME"

if [[ -d "$SKILL_DIR" ]]; then
    echo "Error: skill '$SKILL_NAME' already exists at $SKILL_DIR"
    exit 1
fi

if [[ ! -d "$TEMPLATE_DIR" ]]; then
    echo "Error: TEMPLATE directory not found at $TEMPLATE_DIR"
    exit 1
fi

cp -r "$TEMPLATE_DIR" "$SKILL_DIR"

# Replace placeholder name in SKILL.md
sed -i "s/name: template-skill/name: $SKILL_NAME/g" "$SKILL_DIR/SKILL.md"

echo "Created new skill: $SKILL_DIR"
echo ""
echo "Next steps:"
echo "  1. Edit $SKILL_DIR/SKILL.md"
echo "  2. Update the description and instructions"
echo "  3. Add scripts/, references/, or assets/ if needed"
echo "  4. Test with: scripts/test-skill.sh $SKILL_NAME"
