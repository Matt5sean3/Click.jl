"""
```julia
create_bounds(primitive, ctx)
```

* `primitive` - Basic shape unit from a supported library
* `ctx` - Context linking the primitive to the global coordinate system

Generates a new bounds object from a basic shape unit in a supported
library.
"""
create_bounds(ctx, primitive) =
  error("No bounds support for the given primitive")

"""
```julia
create_clickable(ctx, primitive)
```
"""
create_clickable(ctx, primitive) = 
  error("No clickable support for the given primitive")

"""
```julia
create_draggable(ctx, primitive)
```
"""
create_draggable(ctx, primitive) = 
  error("No draggable support for the given primitive")

