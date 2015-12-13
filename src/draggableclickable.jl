
"""
```julia
DraggableClickable(c::Clickable)
DraggableClickable(b::Bounds)
```

Creates a `Draggable` from a `Clickable.` `Draggable` objects are also 
`Clickable` objects.
"""
type DraggableClickable <: Draggable
  clickable::Clickable
  transform::Matrix{Number}
  leftState::Bool
  oldPos::Array{Number, 1}
  function DraggableClickable(c::Clickable)
    ret = new(c, eye(3))
    # By default, this is configured to use translative dragging
    attend(ret, :out) do frm, x, y
      frm.leftState = false
    end
    attend(ret, :down) do frm, x, y
      oldPos[1] = x
      oldPos[2] = y
      frm.leftState = true
    end
    attend(ret, :up) do frm, x, y
      frm.leftState = false
    end
    attend(ret, :move) do frm, x, y
      if frm.leftState
        translate(x - oldPos[1], oldPos[2])
      end
    end
    return ret
  end
  function DraggableClickable(b::Bounds)
    # Create a ClickableBounds object internally
    DraggableClickable(ClickableBounds(b))
  end
end

function transform(d::DraggableClickable, mat::Matrix{Number})
  d.transform *= inv(mat)
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
  xp = d.transform * [x, y, 1.0]
  update(d.clickable, xp[1], xp[2], trigger)
end

