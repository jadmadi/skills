# jadmadi-skills

Personal AI agent skills — developed, tested, and shared for the community.

## What is this?

This repo contains [agent skills](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/skill) — reusable instruction modules that extend what AI coding assistants can do. Each skill lives in its own directory under `skills/` and can be installed into Claude Code, Windsurf, Devin, or any agent framework that supports markdown skill files.

## Repo Structure

```
jadmadi-skills/
├── README.md
├── skills/
│   ├── TEMPLATE/           # Copy this to create a new skill
│   │   └── SKILL.md
│   └── <your-skill>/       # One directory per skill
│       ├── SKILL.md        # Required: instructions + YAML frontmatter
│       ├── scripts/        # Optional: executable helpers
│       ├── references/     # Optional: docs loaded on demand
│       └── assets/         # Optional: templates, icons, fonts
```

## Quick Start

### For Users (Installing Skills)

**Claude Code:**
```bash
# Global install
ln -s "$PWD/skills/<skill-name>" ~/.claude/skills/<skill-name>

# Or project-local (repo-root/.claude/skills/)
mkdir -p .claude/skills
ln -s "$PWD/skills/<skill-name>" .claude/skills/<skill-name>
```

**Windsurf:**
```bash
mkdir -p ~/.codeium/windsurf/skills
ln -s "$PWD/skills/<skill-name>" ~/.codeium/windsurf/skills/<skill-name>
```

**Devin:**
```bash
mkdir -p ~/.config/devin/skills
ln -s "$PWD/skills/<skill-name>" ~/.config/devin/skills/<skill-name>
```

**Generic / Other Agents:**
```bash
mkdir -p ~/.agents/skills
ln -s "$PWD/skills/<skill-name>" ~/.agents/skills/<skill-name>
```

### For Contributors (Creating Skills)

1. Copy the template:
   ```bash
   cp -r skills/TEMPLATE skills/my-new-skill
   ```

2. Edit `skills/my-new-skill/SKILL.md`:
   - Set `name` and `description` in YAML frontmatter
   - Write concise instructions (under 500 lines)
   - Include concrete examples and triggers

3. Test the skill by symlinking it into your agent's skills directory and using it in a session.

## Skill Anatomy

A minimal skill is just a directory with a `SKILL.md` file:

```yaml
---
name: my-skill
description: What it does. Use when user mentions [trigger words].
---

# My Skill

## Quick Start
[Minimal working example]

## Workflows
[Step-by-step processes]
```

### Description Best Practices

The `description` field is the **only** thing the agent sees when deciding whether to load your skill. Make it count:

- **First sentence:** what the skill does
- **Second sentence:** "Use when [specific triggers]"
- **Max ~1024 characters**
- **Be specific:** include keywords, contexts, file types

Example (good):
> Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when user mentions PDFs, forms, or document extraction.

Example (bad):
> Helps with documents.

## Skills Index

| Skill | Description | Status |
|-------|-------------|--------|
| [codebase-artifact](skills/codebase-artifact/) | Scan a codebase and produce a self-contained HTML architecture document with SVG diagrams | ready |

## License

MIT — feel free to use, modify, and share.

## Author

Jad Madi — [github.com/jadmadi](https://github.com/jadmadi)
