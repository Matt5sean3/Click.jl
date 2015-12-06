using Compose

type Listener
  callback::Function
  active::Bool
end

function call(x::Listener, args...)
  x.active && x.callback(args...)
end

"""
```julia
ClickableForm(base::Compose.Context, form::Compose.Form)
(base::Compose.Context, form::Compose.Form)
```

* `base` - context containing the clickable form
* `form` - clickable form in compose
"""
type ClickableBounds <: Clickable
  bounds::Bounds
  hover::Bool
  mouseButtons::NTuple{3, Bool}
  listeners::Dict{Symbol, Array{Listener}}
end

function ClickableBounds(bounds::Bounds)
  triggers = [:move, :down, :up, :rightdown, :rightup, :centerdown, :centerup, 
    :out, :in, :click, :rightclick, :centerclick]
  callbacks = Dict{Symbol, Array{Listener}}()
  for trigger in triggers
    callbacks[trigger] = Array{Listener}()
  end
  return Clickable(bounds, false, (false, false, false), callbacks)
end

function listen(f::Function, frm::ClickableBounds, trigger::Symbol)
  list = frm.listeners[trigger]
  push!(list, (f, true))
  return length(list)
end

function deactivate(frm::ClickableBounds, trigger::Symbol, id)
  frm.listeners[trigger][id][2] = false
end

function reactivate(frm::ClickableBounds, trigger::Symbol, id)
  frm.listeners[trigger][id][2] = true
end

function update(frm::ClickableBounds, x::Number, y::Number, trigger::Symbol)
  triggered = Array{Listener, 1}()
  isin = check_bounds(frm.bounds, x, y)
  if isin
    # Always pass through when in bounds
    push!(triggered, frm.listeners[trigger]...)
    # Uses a sort of if-statement short-hand
    trigger == :down && (mouseButtons[1] = true)

    trigger == :up && mouseButtons[1] && 
      push!(triggered, frm.listeners[:click]...)

    trigger == :rightdown && (mouseButtons[3] = true)

    trigger == :rightup && mouseButtons[3] && 
      push!(triggered, frm.listeners[:rightclick]...)

    trigger == :centerdown && (mouseButtons[2] = true)

    trigger == :centerup && mouseButtons[2] &&
      push!(triggered, frm.listeners[:centerclick]...)
  end
  if frm.hover
    # Previously in bounds
    if !isin
      # Reset mouse clicking
      mouseButtons = (false, false, false)
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

