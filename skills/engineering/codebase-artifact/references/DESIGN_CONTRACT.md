# Design Contract

Copy this `<style>` block verbatim as the base. Extend it; never contradict it.

## CSS Variables & Base Styles

```css
:root {
  --bg:           #0f1117;
  --surface:      #171b26;
  --surface-2:    #1e2333;
  --border:       #2a2f45;
  --text-primary: #e8ecf4;
  --text-muted:   #6b7591;
  --accent:       #5b8dee;
  --accent-2:     #e8734a;
  --accent-3:     #4ecb8d;
  --code-bg:      #131720;

  --node-page:      #1e2a45;
  --node-component: #1e3328;
  --node-external:  #2d2218;
  --node-decision:  #2d1f38;
  --node-border:    #3a4060;
  --edge-flow:      #5b8dee;
  --edge-contains:  #4ecb8d;
  --edge-data:      #e8734a;

  --font-display: 'Georgia', 'Times New Roman', serif;
  --font-body:    'Segoe UI', system-ui, -apple-system, sans-serif;
  --font-mono:    'Cascadia Code', 'Fira Code', 'Consolas', monospace;

  --radius:  8px;
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 16px;
  --space-4: 24px;
  --space-5: 40px;
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

body {
  background: var(--bg);
  color: var(--text-primary);
  font-family: var(--font-body);
  font-size: 14px;
  line-height: 1.6;
  max-width: 1100px;
  margin: 0 auto;
  padding: var(--space-5) var(--space-4);
}

h1 { font-family: var(--font-display); font-size: 28px; font-weight: normal; letter-spacing: -0.5px; }
h2 { font-size: 11px; font-weight: 600; letter-spacing: 2px; text-transform: uppercase;
     color: var(--text-muted); margin-bottom: var(--space-3); margin-top: var(--space-5); }

.section { border: 1px solid var(--border); border-radius: var(--radius);
           background: var(--surface); padding: var(--space-4); margin-bottom: var(--space-4); }

.pill { display: inline-block; padding: 2px 10px; border-radius: 99px; font-size: 11px;
        font-weight: 600; border: 1px solid var(--border); color: var(--text-muted);
        margin-right: var(--space-1); margin-bottom: var(--space-1); }

/* Annotated snippet layout */
.snippet-grid { display: grid; grid-template-columns: 1fr 220px; gap: var(--space-3); }
.code-block { background: var(--code-bg); border-radius: 6px; padding: var(--space-3);
              overflow-x: auto; }
.code-block pre { font-family: var(--font-mono); font-size: 12px; line-height: 1.7;
                  color: #c9d1e0; }
.annotations { display: flex; flex-direction: column; gap: var(--space-2); }
.annotation { background: var(--surface-2); border-left: 3px solid var(--accent);
              border-radius: 0 4px 4px 0; padding: var(--space-2) var(--space-3);
              font-size: 12px; color: var(--text-muted); }
.annotation strong { color: var(--accent); display: block; font-size: 11px; margin-bottom: 2px; }

/* Component index table */
table { width: 100%; border-collapse: collapse; font-size: 13px; }
th { text-align: left; padding: var(--space-2) var(--space-3); color: var(--text-muted);
     font-size: 11px; font-weight: 600; letter-spacing: 1px; text-transform: uppercase;
     border-bottom: 1px solid var(--border); }
td { padding: var(--space-2) var(--space-3); border-bottom: 1px solid var(--border);
     vertical-align: top; }
tr:last-child td { border-bottom: none; }
.tag { font-family: var(--font-mono); font-size: 11px; color: var(--accent-3); }
```

## Strict Bans

Never use:
- External font imports (`@import url(...)`, Google Fonts, etc.)
- CDN script tags
- `fetch()` or `XMLHttpRequest` at page render
- `<img src="">` for diagrams — embed SVG directly
- Purple-on-white color schemes
- Inter, Roboto, or Arial as the display font
- Tables for layout (only for tabular data)
