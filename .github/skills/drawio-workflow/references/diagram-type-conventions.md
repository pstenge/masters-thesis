# Diagram Type Conventions

Guidance for selecting the right diagram type, laying out elements, and applying colour.

---

## Diagram Types

### Architecture Diagram

Use to show services, data stores, and external systems and how they interconnect.

- Shapes: rectangles for services, cylinders for databases, clouds for external systems.
- Group related components in swimlanes (e.g., one swimlane per team or deployment boundary).
- Connect with labelled arrows showing data flow direction.

### Flowchart

Use to show a sequential process with conditional branches.

- Shapes: ellipses for start/end, rectangles for process steps, diamonds for decisions.
- Flow top-to-bottom or left-to-right consistently throughout.
- Label decision branches explicitly ("Yes" / "No").

### Sequence Diagram

Use to show ordered interactions between actors or services over time.

- Layout: vertical swimlanes, one per actor or service.
- Draw horizontal connectors between swimlanes in time order from top to bottom.
- Label each connector with the message or call name.

### Entity-Relationship (ER) Diagram

Use to show data model entities and the relationships between them.

- Shapes: rectangles for entities; list attributes inside using line breaks (`<br>`).
- Connect entities with labelled connectors indicating cardinality (e.g., `1`, `*`, `0..1`).

---

## Layout Guidelines

- Use the default 10 px grid. Align all shapes to the grid.
- Leave at least 40 px of space between shapes.
- Group shapes that belong together — use swimlanes or visual proximity.
- Prefer orthogonal connectors (`edgeStyle=orthogonalEdgeStyle`) over diagonal lines.
- Place the most upstream or triggering element top-left; downstream or dependent elements flow right or down.

---

## Colour Conventions

Apply colour sparingly to convey meaning, not decoration. Default unlabelled shapes need no `fillColor` override.

| Purpose | Style attribute |
|---|---|
| Primary service / main path | `fillColor=#dae8fc;strokeColor=#6c8ebf;` |
| External / third-party | `fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;` |
| Data store | `fillColor=#fff2cc;strokeColor=#d6b656;` |
| Warning / error path | `fillColor=#ffe6cc;strokeColor=#d79b00;` |
| Success / done state | `fillColor=#d5e8d4;strokeColor=#82b366;` |

Apply a colour style by adding it to the `style` attribute of any `mxCell`:

```xml
<mxCell id="2" value="API Gateway" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
  <mxGeometry x="160" y="160" width="120" height="60" as="geometry" />
</mxCell>
```
