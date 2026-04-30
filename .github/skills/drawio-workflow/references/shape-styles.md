# Shape Styles

XML templates for all common draw.io shapes and connectors. Copy and increment the `id` attribute for each new element.

## Contents
- Process / Rectangle
- Decision / Diamond
- Start / End (Ellipse)
- Database / Cylinder
- Cloud / External Service
- Swimlane / Container
- Connector (Arrow)

---

## Process / Rectangle

Use for services, steps, and general components.

```xml
<mxCell id="2" value="Label" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="1">
  <mxGeometry x="160" y="160" width="120" height="60" as="geometry" />
</mxCell>
```

---

## Decision / Diamond

Use for conditional branch points in flowcharts.

```xml
<mxCell id="3" value="Decision?" style="rhombus;whiteSpace=wrap;html=1;" vertex="1" parent="1">
  <mxGeometry x="160" y="280" width="120" height="80" as="geometry" />
</mxCell>
```

---

## Start / End (Ellipse)

Use for terminal points (start and end) in flowcharts.

```xml
<mxCell id="4" value="Start" style="ellipse;whiteSpace=wrap;html=1;" vertex="1" parent="1">
  <mxGeometry x="180" y="80" width="80" height="40" as="geometry" />
</mxCell>
```

---

## Database / Cylinder

Use for data stores and databases.

```xml
<mxCell id="5" value="Database" style="shape=mxgraph.flowchart.database;whiteSpace=wrap;html=1;" vertex="1" parent="1">
  <mxGeometry x="160" y="400" width="120" height="80" as="geometry" />
</mxCell>
```

---

## Cloud / External Service

Use for third-party or external system dependencies.

```xml
<mxCell id="6" value="External API" style="shape=mxgraph.cisco.clouds.cloud;whiteSpace=wrap;html=1;" vertex="1" parent="1">
  <mxGeometry x="360" y="160" width="120" height="80" as="geometry" />
</mxCell>
```

---

## Swimlane / Container

Use to group related components (e.g., a microservice, an actor, a bounded context).

```xml
<mxCell id="7" value="Service Name" style="swimlane;startSize=30;" vertex="1" parent="1">
  <mxGeometry x="80" y="80" width="300" height="200" as="geometry" />
</mxCell>
```

Place child elements inside the swimlane by setting `parent="7"` (the swimlane's ID).

---

## Connector (Arrow)

Use orthogonal style for clean, grid-aligned paths.

```xml
<mxCell id="8" value="" style="edgeStyle=orthogonalEdgeStyle;" edge="1" source="2" target="3" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

Add `value="Label"` on connectors when the relationship needs a name (e.g., data flow direction, cardinality, message name).
