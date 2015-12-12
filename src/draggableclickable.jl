
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
  function DraggableClickable(c::Clickable)
    new(c, eye(3))
  end
  function DraggableClickable(b::Bounds)
    # Create a ClickableBounds object internally
    new(ClickableBounds(b), eye(3))
  end
end

function transform(d::DraggableClickable, mat::Matrix{Number})
  d.transform *= inv(mat)
end

# Use an intermediate step before bounds checking
function check_bounds(d::DraggableClickable, x::Number, y::Number)
  x = [x, y, 1.0]
  xp = d.transform * x
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
  x = [x, y, 1.0]
  xp = d.transform * x
  update(d.clickable, xp[1], xp[2], trigger)
end

