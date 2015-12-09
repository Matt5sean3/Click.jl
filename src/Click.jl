module Click

using Requires

export Clickable, ClickMap, attend, deactivate, reactivate, update, bounding_box
include("clickable.jl")
# Click maps aggregate clickable objects for an easier interface
include("clickmap.jl")
# A simple click map is sufficient for many cases
include("simpleclickmap.jl")
export Bounds, create_bounds, check_bounds
# Most basic backend object
include("bounds.jl")
include("clickablebounds.jl")

# Cases with numerous, complex clickables can use bitclickmaps
include("bitclickmap.jl")

# Graphics generators
include("imagemap.jl")
@require Compose include("compose.jl")

# Graphical Backends
@require Gtk include("gtk.jl")
@require Tk include("tk.jl")
# plan to support other backends once I know more about them

end # module
