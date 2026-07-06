# SVG Diagram Grammar

Use these rules for EVERY SVG diagram. Do not invent alternatives.

## Nodes

| Type | Shape | Attributes | Size |
|------|-------|-----------|------|
| **Screen/Page** | `<rect>` | rx=6, fill=var(--node-page), stroke=var(--node-border) | 120×44px |
| **Component** | `<rect>` | rx=4, fill=var(--node-component), stroke=var(--node-border) | 100×36px |
| **External/API** | `<rect>` | rx=16 (pill), fill=var(--node-external) | 110×32px |
| **Decision** | `<polygon>` (diamond) | fill=var(--node-decision) | — |

Labels:
- font-size=12px
- font-family=var(--font-mono) for component labels
- font-family=var(--font-body) for page labels

## Edges

| Type | Style | Use For |
|------|-------|---------|
| **Navigation flow** | stroke=var(--edge-flow), stroke-width=1.5, marker-end=arrowhead | User navigation between screens |
| **Renders/contains** | stroke=var(--edge-contains), stroke-width=1, stroke-dasharray=4 2 | Parent-child component relationships |
| **Data fetch** | stroke=var(--edge-data), stroke-width=1, stroke-dasharray=2 2 | API calls, data loading |

## Layout Rules

- **Journey map**: left-to-right, swimlanes separated by horizontal bands labeled User / System / Data
- **Component tree**: top-down, root centered at top, children evenly spaced below parent
- **Minimum node spacing**: 24px horizontal, 40px vertical
- **Always include** a `<defs>` block with `<marker>` arrowheads:

```xml
<defs>
  <marker id="arrowhead" markerWidth="10" markerHeight="7"
          refX="10" refY="3.5" orient="auto">
    <polygon points="0 0, 10 3.5, 0 7" fill="var(--edge-flow)"/>
  </marker>
</defs>
```

## Color Tokens (from design contract)

Use CSS custom properties so the SVG inherits from the page theme:
- `--node-page`: #1e2a45
- `--node-component`: #1e3328
- `--node-external`: #2d2218
- `--node-decision`: #2d1f38
- `--node-border`: #3a4060
- `--edge-flow`: #5b8dee
- `--edge-contains`: #4ecb8d
- `--edge-data`: #e8734a
