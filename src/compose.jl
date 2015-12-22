module ComposeLink

using Compose
using Click
using Click.Primitives
import Base: copy

# Provides context for a compose primitive

type Transform
  mat::Matrix
  x::Compose.AbsoluteLength
  y::Compose.AbsoluteLength
end

# Provides advanced support for working with Compose

# To work correctly this needs to know the Context's pixel to millimeter
# conversion

type ComposeBounds <: Bounds
  origin::Compose.Context
  geom::Compose.Form
  primitives::Array{Tuple{Bounds, Transform}, 1}
  lastHash::UInt64
  function ComposeBounds(geom::Compose.Form, base::Context)
    ret = new(base, geom)
    # generate the transforms
    generate_clickables!(ret)
    return ret
  end
end

function copy(t::Transform)
  return Transform(copy(t.mat), t.x.value * mm, t.y.value * mm) 
end

composeform_to_primitive(prim::Compose.FormPrimitive, transform::Transform) = 
  error(string("No support for Compose primitive: ", typeof(prim)))

# Required many times
function absolute_units(m::Measure, t::Transform)
  tp = typeof(m)
  v = 0.0
  if tp <: cx || tp <: typeof(w)
    v = m.value * t.x / mm
  elseif tp <: cy || tp <: typeof(h)
    v = m.value * t.y / mm
  else
    v = m / mm
  end
  return v
end

# For now, just support rectangles and circles
function composeform_to_primitive(prim::Compose.RectanglePrimitive, 
                                  t::Transform)
  # convert relative units to absolute
  ms = (prim.corner[1], prim.corner[2], prim.width, prim.height)
  vs = [absolute_units(m, t) for m in ms]
  return Rectangle(vs[1], vs[2], 
                   vs[3], vs[4])
end

function composeform_to_primitive(prim::Compose.CirclePrimitive,
                                  t::Transform)
  ms = (prim.center[1], prim.center[2], prim.radius)
  vs = [absolute_units(m, t) for m in ms]
  return Circle(v[1], 
                v[2], 
                v[3])
end

function generate_clickables!(x::ComposeBounds)
  x.lastHash = hash(x.origin) + hash(x.geom)
  bounds = Array{Tuple{Bounds, Transform}, 1}()
  transforms = generate_transforms(x.geom, x.origin)
  for transform in transforms
    for primitive in x.geom.primitives
      bound = composeform_to_primitive(primitive, transform)
      push!(bounds, (bound, transform))
    end
  end
  x.primitives = bounds
end


"""
```julia
generate_transforms(p::Compose.FormPrimitive,
                    base::Context,
                    t::Transform)
```

The resulting transforms are paired with context info
"""
function generate_transforms(p::Compose.Form, 
                             base::Context, 
                             t::Transform = Transform(eye(3), 0mm, 0mm))
  # Generate the local to global transform
  t = copy(t)

  # Matching screen units to Compose.jl units is difficult

  dx = absolute_units(base.box.x0[1], t)
  dy = absolute_units(base.box.x0[2], t)
  t.mat *= [1.0 0.0 dx;
            0.0 1.0 dy;
            0.0 0.0 1.0]

  # Change context
  t.x = absolute_units(Compose.width(base.box), t)mm
  t.y = absolute_units(Compose.height(base.box), t)mm

#   # Compose doesn't seem to implement rotations yet
#   # rotate
#   rot = get(base.rot, Rotation(0.0, (0.0mm, 0.0mm)))
#   co = cos(rot.theta)
#   si = sin(rot.theta)
#   dxr = absolute_units(rot.offset[1], t)
#   dyr = absolute_units(rot.offset[2], t)
# 
#   println([co   si -co * dxr - dyr * si + dxr;
#             -si  co  si * dxr - dyr * co + dyr;
#             0.0 0.0 1.0])
#   t.mat *= [co   si -co * dxr - dyr * si + dxr;
#             -si  co  si * dxr - dyr * co + dyr;
#             0.0 0.0 1.0]

  # Check the contained children
  ret = Array{Transform, 1}()
  for child in Compose.children(base)
    tp = typeof(child)
    if tp <: Compose.Container
      genned = generate_transforms(p, child, t)
      if length(genned) > 0
        # Check recursively
        push!(ret, genned...)
      end
    end
    if tp <: Compose.Form && p == child
      # final transform matrix lacks scaling
      # so it's all placed in a tuple
      push!(ret, t)
    end
    # ignore containers
  end
  return ret
end
# Works in 2D for now
# extending to 3D isn't impossible, but is much more complicated
# Using Vec2 retains the option for higher dimensional extension later

end # module

"""
```julia
ComposeClickMap(internal::ClickMap, mmpp::Float64)
```

* `internal` - A click map that is wrapped for use with Compose
* `mmpp` - Number of millimeters per pixel
The compose Click Map is required to adjust for pixel density and conversion
from pixels to millimeters
"""
type ComposeClickMap <: ClickMap
  internal::ClickMap
  mmpp::Float64
end

# Adjust for screen density
update(m::ComposeClickMap, x::Number, y::Number, trigger::Symbol) = 
  update(m.internal, x * m.mmpp, y * m.mmpp, trigger)

# Just pass the function on to the internal ClickMap
clickables(m::ComposeClickMap) = 
  clickables(m.internal)

Base.push!(m::ComposeClickMap, c...) =
  Base.push!(m.internal, c...)


# Create bounds from a Compose form
function create_bounds(geom::Compose.Form, base::Compose.Context)
  return ComposeLink.ComposeBounds(geom, base)
end

function create_clickable(geom::Compose.Form, base::Compose.Context)
  return ClickableBounds(ComposeLink.ComposeBounds(geom, base))
end

function check_bounds(geom::ComposeLink.ComposeBounds, x::Number, y::Number)
  # Very computationally intensive process sometimes
  if geom.lastHash != hash(geom.origin) + hash(geom.geom)
    # regenerate the clickables
    ComposeLink.generate_clickables!(geom)
  end

  # Run each transform
  # Check every primitive
  for bound in geom.primitives
    # Transform to local coordinates
    xv = inv(bound[2].mat) * [x, y, 1.0]
    if check_bounds(bound[1], xv[1], xv[2])
      return true
    end
  end
  return false
end

