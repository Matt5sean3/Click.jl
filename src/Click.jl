module Click

using Requires

export Clickable, ClickableBounds, ClickMap, attend, deactivate, reactivate, 
       update, bounding_box, SimpleClickMap, link_click_map
include("clickable.jl")
# Click maps aggregate clickable objects for an easier interface
include("clickmap.jl")
# A simple click map is sufficient for many cases
include("simpleclickmap.jl")
# A more complex to implement click map that generally has good performance
# TODO implement
# include("treeclickmap.jl")
export Bounds, create_bounds, check_bounds
# Most basic backend object
include("bounds.jl")
include("clickablebounds.jl")
# Mostly included for documentation purposes
include("link_click_map.jl")

# Cases with numerous, complex clickables can use bitclickmaps
include("bitclickmap.jl")

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
