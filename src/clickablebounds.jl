type Listener
  callback::Function
  active::Bool
end

function call(x::Listener, args...)
  x.active && x.callback(args...)
end

"""
```julia
ClickableBounds(bounds::Bounds)
```

* `base` - context containing the clickable form
* `form` - clickable form in compose

Essentially creates a `Clickable` object from a `Bounds` object. The resulting
object is also a `Bounds` object since `Clickable` objects are also `Bounds` 
objects.
"""
type ClickableBounds <: Clickable
  bounds::Bounds
  hover::Bool
  mouseButtons::Array{Bool, 1}
  listeners::Dict{Symbol, Array{Listener, 1}}

  function ClickableBounds(bounds::Bounds)
    triggers = [:move, :down, :up, :rightdown, :rightup, :centerdown, :centerup, 
      :out, :in, :click, :rightclick, :centerclick]
    callbacks = Dict{Symbol, Array{Listener, 1}}()
    for trigger in triggers
      callbacks[trigger] = Array{Listener, 1}()
    end
    new(bounds, false, [false, false, false], callbacks)
  end

end

# check_bounds just gets passed to the now internally kept bounds object
check_bounds(b::ClickableBounds, x::Number, y::Number) = 
  check_bounds(b.bounds, x, y)

function attend(f::Function, b::ClickableBounds, trigger::Symbol)
  list = b.listeners[trigger]
  push!(list, Listener(f, true))
  return length(list)
end

function deactivate(b::ClickableBounds, trigger::Symbol, id)
  b.listeners[trigger][id][2] = false
end

function reactivate(b::ClickableBounds, trigger::Symbol, id)
  b.listeners[trigger][id][2] = true
end

# nop, used internally to simplify code
Base.push!(arr::Array{Listener, 1}) = arr

function update(b::ClickableBounds,
                x::Number, 
                y::Number, 
                trigger::Symbol)
  triggered = Array{Listener, 1}()
  isin = check_bounds(b.bounds, x, y)
  if isin
    # Always pass through when in bounds
    push!(triggered, b.listeners[trigger]...)
    # Uses a sort of if-statement short-hand
    trigger == :down && (b.mouseButtons[1] = true)

    trigger == :up && b.mouseButtons[1] && 
      push!(triggered, b.listeners[:click]...)

    trigger == :rightdown && (b.mouseButtons[3] = true)

    trigger == :rightup && b.mouseButtons[3] && 
      push!(triggered, b.listeners[:rightclick]...)

    trigger == :centerdown && (b.mouseButtons[2] = true)

    trigger == :centerup && b.mouseButtons[2] &&
      push!(triggered, b.listeners[:centerclick]...)
  end
  if b.hover
    # Previously in bounds
    if !isin
      # Reset mouse clicking
      b.mouseButtons[1] = false
      b.mouseButtons[2] = false
      b.mouseButtons[3] = false
      # left the bounds
      push!(triggered, b.listeners[:out]...)
    end
  else
    # Previously out of bounds
    if isin
      # entered bounds
      push!(triggered, b.listeners[:in]...)
    end
  end
  b.hover = isin
  [listener(b, x, y) for listener in triggered]
end

