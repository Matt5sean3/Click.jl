"""
```julia
abstract Clickable <: Bounds
```

An object implementing the `Clickable` interface.
Additionally, the `Bounds` interface must be implemented.

required
* `attend`
* `update`

optional
* `deactivate`
* `reactivate`
* `bounding_box`

see also: `attend`, `update`, `deactivate`, `reactivate`, `bounding_box`
"""
abstract Clickable <: Bounds

"""
```julia
attend(f::Function, frm::Clickable, trigger::Symbol)
```

* `f` - callback function of the form `f(frm)`
* `frm` - clickable object
* `trigger` - Symbol denoting which action to listen for

Returns the identifier of the added listener which can be used in the 
`reactivate` and `deactivate functions.

This is compatible with the do-end syntax

```julia
attend(frm, :click) do frm, x, y
  # ... CODE TO EXECUTE UPON CLICK ...
end
```

The `trigger` symbols:
* `:move` - mouse is moving while over the form
* `:down` - left mouse button is pushed down over the form
* `:up` - left mouse button lifts up over the form
* `:rightdown` - right mouse button is pushed down over the form
* `:rightup` - right mouse button lifts up over the form
* `:centerdown` - Middle mouse down
* `:centerup` - Middle mouse up

* `:out` - mouse enters the form covers
* `:in` - mouse exits the form covers
* `:click` - left mouse button is pushed down and lifted while over the form
* `:rightclick` - right mouse button goes down and up over the form
* `:centerclick` - center mouse button goes down and up over the form
```

"""
attend(f::Function, frm::Clickable, trigger::Symbol) = 
  error(string("`attend` not implemented for the given Clickable(", 
               typeof(frm), ")"))

"""
```julia
deactivate(frm::Clickable, trigger::Symbol, idx::Integer)
```

* `frm` - clickable object
* `trigger` - Symbol denoting which action to deactivate the listener for
* `id` - Identifier of the listener

Deactivates the listener on that trigger with the given index

see also: `attend`
"""
deactivate(frm::Clickable, trigger::Symbol, id) =
  warn("`deactivate` not implemented for the given clickable")

"""
```julia
reactivate(frm::Clickable, trigger::Symbol, idx::Integer)
```

* `frm` - clickable object
* `trigger` - Symbol denoting which action to reactivate the listener for
* `id` - Identifier of the listener

Reactivates the listener on that trigger with the given index

see also: `deactivate`, `attend`
"""
reactivate(frm::Clickable, trigger::Symbol, id) = 
  warn("`reactivate` not implemented for the given Clickable")

"""
```julia
update(frm::Clickable, x::Number, y::Number, trigger::Symbol)
```

* `frm` - clickable object
* `x` - horizontal position of the cursor
* `y` - vertical position of the cursor
* `trigger` - symbol indicating the type of update

Provides the backend a means to update the clickable. Checking for whether the 
mouse is inbounds or out of bounds of the clickable is done internally.

`type` supports the symbols:
* `:move` - Mouse movement generally
* `:down` - Left mouse down
* `:up` - Left mouse up
* `:rightdown` - Right mouse down
* `:rightup` - Right mouse up
* `:centerdown` - Middle mouse down
* `:centerup` - Middle mouse up
"""
update(frm::Clickable, x::Number, y::Number, trigger::Symbol) = 
  error("`update` not implemented for the given Clickable")

"""
```julia
bounding_box(frm::Clickable)::Tuple{Number, Number, Number, Number}
```

Provides the backend a tuple specifying a rectangle

The tuple has 4 numbers. The first is the x-coordinate, the second is the 
y-coordinate, third is the width, and the fourth is the height.

This is available mostly for debugging and speeding-up interfaces
with numerous clickables or clickables with complex bound checking.
"""
bounding_box(frm::Clickable) =
  warn("`bounding_box` not implemented for the given Clickable")

