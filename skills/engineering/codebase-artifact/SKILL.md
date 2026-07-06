---
name: codebase-artifact
description: |
  Scan any codebase and produce a single self-contained HTML file documenting its
  architecture, user journey, component hierarchy, and key code patterns as a
  polished visual artifact. Use when the user says "document this codebase",
  "generate a codebase overview", "visualize project architecture", "create a
  project map", "codebase audit", or wants an HTML summary of a project structure.
license: MIT
metadata:
  author: jadmadi
  version: "1.0.0"
---

# Codebase Artifact Agent

Generate a single, self-contained HTML file that documents a codebase's architecture, user journey, component hierarchy, and key code patterns as a polished visual artifact.

**Output constraints:** One `.html` file. No external files, CDN links, or runtime fetches. Must open correctly with `file://` protocol.

## Quick Start

1. Scan the codebase following the protocol below
2. Build three mental models: user journey, component tree, data flow
3. Write the HTML using the structure and design contract
4. Output ONLY raw HTML — no markdown fences, no preamble

## Step 1 — Codebase Scanning Protocol

Scan in this exact order. Stop each category when you have enough signal.

1. **Project identity** — `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`
   Extract: framework, language, major dependencies, project name/description.

2. **Entry points & routing** — `src/App.*`, `pages/`, `routes/`, `router.*`, `index.*`
   Extract: all named routes, their component, and any auth/guard conditions.
   This IS the user journey skeleton.

3. **Layout & shell** — Any component imported by the root or every route
   Extract: nav structure, persistent UI regions (sidebar, topbar, footer), layout slots.

4. **Page-level components** — One file per route from step 2
   Extract: the component's purpose, its primary data dependencies, child components it renders, and any significant user interactions (forms, modals, CTAs).

5. **Shared/atomic components** — `components/`, `ui/`, `common/`, `shared/`
   Extract: component name, props interface, which pages use it.

6. **Data & state layer** — `store/`, `context/`, `hooks/`, `api/`, `services/`, `lib/`
   Extract: state slices or context names, API endpoints called, async patterns used.

7. **Configuration & environment** — `.env.example`, `config.*`, `constants.*`
   Extract: feature flags, environment-dependent behavior, key constants.

Build a mental model with these three structures before writing any HTML:
- **User journey**: ordered list of screens a user passes through for the primary flow
- **Component tree**: parent → child relationships for the main layout
- **Data flow**: where data originates and how it reaches the UI

## Step 2 — Output Structure

The HTML file has exactly these sections, in order:

1. **Header bar** — project name, tech stack pills, generated timestamp
2. **Journey map** — SVG swimlane diagram of the primary user flow
3. **Component tree** — SVG hierarchy diagram of the component structure
4. **Component index** — scannable table: name | type | used by | key props
5. **Annotated snippets** — 3–6 key code excerpts with margin annotations
6. **Data flow note** — 1–2 paragraphs + small SVG showing data origin → UI
7. **Footer** — file count scanned, frameworks detected

Never add sections. Never remove sections.

## Step 3 — SVG Diagram Grammar

Read [references/SVG_GRAMMAR.md](references/SVG_GRAMMAR.md) for complete node types, edge styles, and layout rules.

Key rules:
- **Screen/Page**: rect, rx=6, fill=var(--node-page), 120×44px
- **Component**: rect, rx=4, fill=var(--node-component), 100×36px
- **External/API**: rect, rx=16 (pill), fill=var(--node-external), 110×32px
- **Decision**: diamond (polygon), fill=var(--node-decision)
- **Navigation flow**: stroke=var(--edge-flow), stroke-width=1.5, marker-end=arrowhead
- **Renders/contains**: stroke=var(--edge-contains), stroke-width=1, stroke-dasharray=4 2
- **Data fetch**: stroke=var(--edge-data), stroke-width=1, stroke-dasharray=2 2
- Journey map: left-to-right, swimlanes (User / System / Data)
- Component tree: top-down, root centered, children evenly spaced
- Always include a `<defs>` block with `<marker>` arrowheads

## Step 4 — Design Contract

Read [references/DESIGN_CONTRACT.md](references/DESIGN_CONTRACT.md) for the complete CSS block.

Copy the CSS `:root` variables and base styles verbatim, then extend. Key bans:
- No external font imports, CDN scripts, or `fetch()`
- No `<img src>` for diagrams — embed SVG directly
- No purple-on-white schemes
- No Inter, Roboto, or Arial as display font
- Tables only for tabular data

## Step 5 — Self-Containment Rules

The output must be a single `.html` file that:
- Opens correctly with `file://` protocol (no server required)
- Has zero network requests
- Embeds all SVGs inline (not as `<img>`)
- Has all CSS in a `<style>` tag in `<head>`
- Has all JS in `<script>` tags before `</body>`
- Declares `<!DOCTYPE html>` and `<meta charset="UTF-8">`
- Has `<meta name="viewport" content="width=device-width, initial-scale=1">`

## Step 6 — Annotated Snippet Rules

Select 3–6 code excerpts that reveal something non-obvious:
- Prefer: auth guards, custom hooks, data transformation, routing logic, interesting patterns
- Avoid: boilerplate, config files, obvious CRUD, imports-only blocks

For each snippet:
- Trim to ≤ 30 lines — cut aggressively, mark omissions with `// ...`
- Provide a filename + line range label
- Write 2–4 margin annotations, each anchored to a specific line or concept
- Annotation tone: explain *why*, not *what*

## Output Instructions

1. Scan the codebase using the protocol in Step 1
2. Build the three mental models (journey, tree, data flow)
3. Write the HTML file using the structure in Step 2
4. Use the SVG grammar from Step 3 / references/SVG_GRAMMAR.md
5. Apply the design contract from Step 4 / references/DESIGN_CONTRACT.md
6. Verify self-containment rules from Step 5
7. **Output ONLY the raw HTML.** No explanation. No markdown fences. No preamble.
   The first character of your response must be `<` and the last must be `>`.
