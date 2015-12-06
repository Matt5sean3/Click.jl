module Click

using Requires

export Clickable, listen, deactivate, reactivate, update, bounding_box
include("clickable.jl")
export Bounds, create_bounds, check_bounds
include("bounds.jl")
include("clickablebounds.jl")

# Graphics generators
include("imagemap.jl")
@require Compose include("compose.jl")

# Graphical Backends
@require Gtk include("gtk.jl")
@require Tk include("tk.jl")
# plan to support other backends once I know more about them

end # module
