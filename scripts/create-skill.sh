#!/usr/bin/env bash
# Bootstrap a new skill from the TEMPLATE

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
TEMPLATE_DIR="$REPO_DIR/TEMPLATE"

if [[ $# -ne 2 ]]; then
    echo "Usage: $(basename "$0") <bucket> <skill-name>"
    echo ""
    echo "Creates a new skill directory from the TEMPLATE at skills/<bucket>/<skill-name>."
    echo ""
    echo "Known buckets: engineering, cloudflare"
    echo "(any bucket name works -- these are just the ones currently populated)"
    exit 1
fi

BUCKET="$1"
SKILL_NAME="$2"
SKILL_DIR="$SKILLS_DIR/$BUCKET/$SKILL_NAME"

if [[ -d "$SKILL_DIR" ]]; then
    echo "Error: skill '$SKILL_NAME' already exists at $SKILL_DIR"
    exit 1
fi

if [[ ! -d "$TEMPLATE_DIR" ]]; then
    echo "Error: TEMPLATE directory not found at $TEMPLATE_DIR"
    exit 1
fi

mkdir -p "$SKILLS_DIR/$BUCKET"
cp -r "$TEMPLATE_DIR" "$SKILL_DIR"

# Replace placeholder name in SKILL.md -- must match the directory name per
# the Agent Skills spec (https://agentskills.io/specification)
sed -i "s/name: template-skill/name: $SKILL_NAME/g" "$SKILL_DIR/SKILL.md"

echo "Created new skill: $SKILL_DIR"
echo ""
echo "Next steps:"
echo "  1. Edit $SKILL_DIR/SKILL.md"
echo "  2. Update the description and instructions"
echo "  3. Add scripts/, references/, or assets/ if needed"
echo "  4. Validate with: scripts/validate-skill.sh $BUCKET/$SKILL_NAME"
echo "  5. Add an entry to skills/$BUCKET/README.md, the top-level README.md, and skills.sh.json"
