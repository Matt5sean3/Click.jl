module Click

using Requires

import Base: convert

export Clickable, ClickableBounds, ClickMap, attend, deactivate, reactivate, 
       update, bounding_box, SimpleClickMap, link_click_map
export Bounds, check_bounds
# Most basic backend object
include("bounds.jl")
include("clickable.jl")
include("draggable.jl")
# Click maps aggregate clickable objects for an easier interface
include("clickmap.jl")

# A simple click map is sufficient for many cases
include("simpleclickmap.jl")
# A more complex to implement click map that generally has good performance
# TODO implement
# include("treeclickmap.jl")

include("clickablebounds.jl")
include("draggableclickable.jl")
# Mostly included for documentation purposes
include("link_click_map.jl")

# Basic shapes to work with
include("primitives.jl")
# Graphics generators
@require Compose include("compose.jl")

# Graphical Backends
@require Gtk include("gtk.jl")
@require Tk include("tk.jl")
# plan to support other backends once I know more about them
# particularly, GLFW

end # module
