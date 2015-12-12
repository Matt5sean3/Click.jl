type Listener
  callback::Function
  active::Bool
end

function call(x::Listener, args...)
  x.active && x.callback(args...)
end

"""
```julia
type CliclableBounds{B <: Bounds}
ClickableBounds(bounds::Bounds)
```

* `bounds` - Boundaries to create a clickable object using
"""
type ClickableBounds{B <: Bounds} <: Clickable
  bounds::B
  hover::Bool
  mouseButtons::Array{Bool, 1}
  listeners::Dict{Symbol, Array{Listener, 1}}

  function ClickableBounds(bounds::B)
    triggers = [:move, :down, :up, :rightdown, :rightup, :centerdown, :centerup, 
      :out, :in, :click, :rightclick, :centerclick]
    callbacks = Dict{Symbol, Array{Listener, 1}}()
    for trigger in triggers
      callbacks[trigger] = Array{Listener, 1}()
    end
    new(bounds, false, [false, false, false], callbacks)
  end

end

function ClickableBounds(bounds::Bounds)
  return ClickableBounds{typeof(bounds)}(bounds)
end

function attend{C <: ClickableBounds}(f::Function, frm::C, trigger::Symbol)
  list = frm.listeners[trigger]
  push!(list, Listener(f, true))
  return length(list)
end

function deactivate(frm::ClickableBounds{Bounds}, trigger::Symbol, id)
  frm.listeners[trigger][id][2] = false
end

function reactivate(frm::ClickableBounds{Bounds}, trigger::Symbol, id)
  frm.listeners[trigger][id][2] = true
end

# nop, used internally to simplify code
Base.push!(arr::Array{Listener, 1}) = arr

function update{C <: ClickableBounds}(frm::C,
                x::Number, 
                y::Number, 
                trigger::Symbol)
  triggered = Array{Listener, 1}()
  isin = check_bounds(frm.bounds, x, y)
  if isin
    # Always pass through when in bounds
    push!(triggered, frm.listeners[trigger]...)
    # Uses a sort of if-statement short-hand
    trigger == :down && (frm.mouseButtons[1] = true)

    trigger == :up && frm.mouseButtons[1] && 
      push!(triggered, frm.listeners[:click]...)

    trigger == :rightdown && (frm.mouseButtons[3] = true)

    trigger == :rightup && frm.mouseButtons[3] && 
      push!(triggered, frm.listeners[:rightclick]...)

    trigger == :centerdown && (frm.mouseButtons[2] = true)

    trigger == :centerup && frm.mouseButtons[2] &&
      push!(triggered, frm.listeners[:centerclick]...)
  end
  if frm.hover
    # Previously in bounds
    if !isin
      # Reset mouse clicking
      frm.mouseButtons[1] = false
      frm.mouseButtons[2] = false
      frm.mouseButtons[3] = false
      # left the bounds
      push!(triggered, frm.listeners[:out]...)
    end
  else
    # Previously out of bounds
    if isin
      # entered bounds
      push!(triggered, frm.listeners[:in]...)
    end
  end
  frm.hover = isin
  [listener(frm) for listener in triggered]
end

