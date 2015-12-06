# Provides advanced support for working with Compose
using Compose
import Compose: Form, FormPrimitive
import Measures: Vec2
"""
```julia
create_bounds(base::Compose.Context, form::Compose.Form)
```

Generates a new bounds object from the Compose form
"""
create_bounds(base::Context, primitive::FormPrimitive) =
  warn("No bounds support for the given primitive")
# Works in 2D for now
# extending to 3D isn't impossible, but is much more complicated
# Using Vec2 retains the option for higher dimensional extension later

# polygon
type PolygonBounds{P <: Vec2} <: Bounds
  origin::Context
  poly::SimplePolygonPrimitive{P}
  units::Measure
end

function create_bounds(base::Context, poly::PolygonPrimitive{Vec2})
  lines = Array{Tuple{Vec2, Vec2}}()
  len = length(poly.points)
  for i in 1:len
    from = poly.points[i]
    to = poly.points[(i + 1) % len]
    push!(lines, (from, to))
  end
  return PolygonBounds(base, poly)

end

function check_bounds()

# rectangle
type RectangleBounds{P <: Vec2, M1 <: Measure, M2 <: Measure} <: Bounds
  origin::Context
  rect::RectanglePrimitive{P, M1, M2}
  units::Measure
end

function create_bounds{M1 <: Measure, M2 <: Measure}(base::Context, 
      rect::RectanglePrimitive{Vec2, M1, M2})
  
end

# circle
type CircleBounds{M} <: Bounds
  origin::Context
  circle
  units::Measure
end

function create_bounds{M}(base::Context, circle::CirclePrimitive{Vec2, M})
end

# ellipse
type EllipseBounds <: Bounds
  origin::Context
  ellipse
end

function create_bounds(base::Context, ellipse::EllipsePrimitive{Vec2, Vec2, Vec2})
end

# text
type TextBounds <: Bounds
  origin::Context
  text::TextPrimitive
end

function create_bounds(base::Context, text::TextPrimitive)
end

# composite
type CompositeBounds <: Bounds
  bounds::Array{Bounds}
end

function create_bounds(base::Context, composite::Form)
  return CompositeBounds(
    [create_bounds(primitive) for primitive in composite.primitives])
end
