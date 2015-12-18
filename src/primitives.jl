
# An Primitive submodule
# Provides basic shapes to work with
module Primitives


import Click: ClickableBounds, DraggableClickable, Bounds, check_bounds
import Base: convert

export Primitive, Rectangle, Circle, ConvexPolygon

abstract Primitive <: Bounds

"""
```julia
Rectangle(x::Number, y::Number, width::Number, height::Number)
```
"""
type Rectangle <: Primitive
  x::Number
  y::Number
  width::Number
  height::Number
end

check_bounds(bounds::Rectangle, x::Number, y::Number) = 
  return bounds.x < x < bounds.x + bounds.width && 
    bounds.y < y < bounds.y + bounds.height

type Circle <: Primitive
  x::Number
  y::Number
  r::Number
end

function check_bounds(bounds::Circle, x::Number, y::Number)
  dx = x - bounds.x
  dy = y - bounds.y
  return dx * dx + dy * dy < bounds.r * bounds.r
end

"""
```julia
ConvexPolygon(points::Array{NTuple{2, Number}, 1})
```
"""
type ConvexPolygon{N <: Number} <: Primitive
  lines::Array{NTuple{3, N}, 1}
  # Can't do type detection
  function ConvexPolygon(points...)
    # convex polygons are simple enough
    npoints = length(points)
    lines = Array{NTuple{3, N}, 1}()
    for i in 1:npoints
      p1 = points[i]
      p2 = points[(i % npoints) + 1]
      A = p2[2] - p1[2]
      B = p1[1] - p2[1]
      C = p1[1] * A + p1[2] * B
      # Ax + By = C
      # inequality determines side of the line
      push!(lines, (A, B, C))
    end
    # concave polygons get complicated
    new(lines)
  end
end

function check_bounds(bounds::ConvexPolygon, x::Number, y::Number)
  line = bounds.lines[1]
  side = line[1] * x + line[2] * y > line[3]
  for line in bounds.lines
    # Ax + By > C
    if side != (line[1] * x + line[2] * y > line[3])
      return false
    end
  end
  return true
end

end # module
