
"""
```julia
DraggableClickable(c::Clickable)
DraggableClickable(b::Bounds)
```

Creates a `Draggable` from a `Clickable.` `Draggable` objects are also 
`Clickable` objects.

Uses Float64 in transform matrixes for efficiency
"""
type DraggableClickable <: Draggable
  clickable::Clickable
  transform::Matrix{Float64}
  leftState::Bool
  oldPos::NTuple{2, Float64}
  function DraggableClickable(c::Clickable)
    ret = new(c, eye(3), false, (0.0, 0.0))
    # By default, this is configured to use translative dragging
    attend(ret, :out) do frm, x, y
      ret.leftState = false
    end
    attend(ret, :down) do frm, x, y
      glob = transform_matrix(ret) * [x, y, 1]
      ret.oldPos = (glob[1], glob[2])
      ret.leftState = true
    end
    attend(ret, :up) do frm, x, y
      ret.leftState = false
    end
    attend(ret, :move) do frm, x, y
      # Needs to convert back to global coordinates
      glob = transform_matrix(ret) * [x, y, 1]
      if ret.leftState
        translate(ret, glob[1] - ret.oldPos[1], glob[2] - ret.oldPos[2])
        ret.oldPos = (glob[1], glob[2])
      end
    end
    return ret
  end
  function DraggableClickable(b::Bounds)
    # Create a ClickableBounds object internally
    DraggableClickable(ClickableBounds(b))
  end
end

# parameter is necessary
function transform(d::DraggableClickable, mat::Matrix)
  d.transform = mat * d.transform
end

function transform_matrix(d::DraggableClickable)
  return d.transform
end

# Use an intermediate step before bounds checking
function check_bounds(d::DraggableClickable, x::Number, y::Number)
  xp = d.transform * [x, y, 1.0]
  check_bounds(d.clickable, xp[1], xp[2])
end

# Pass off super-type responsibilities with inlining
attend(f::Function, d::DraggableClickable, trigger::Symbol) = 
  attend(f, d.clickable, trigger)

deactivate(d::DraggableClickable, trigger::Symbol, id) =
  deactivate(d.clickable, trigger, id)

reactivate(d::DraggableClickable, trigger::Symbol, id) =
  reactivate(d.clickable, trigger, id)

# Take an intermediate step before updating
function update(d::DraggableClickable, x::Number, y::Number, trigger::Symbol)
  xp = inv(transform_matrix(d)) * [x, y, 1.0]
  update(d.clickable, xp[1], xp[2], trigger)
end

