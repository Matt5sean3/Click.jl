
"""
integrate(m::ClickMap, canvas, image)

The fuse function has methods to fuse a clickmap, canvas, and image.
"""
fuse(m::ClickMap, canvas, image) =
  error("Integration has not been implemented between the given objects")

# For now only Gtk and Compose can integrate

# Various fuse methods will be contained in this file
@require Gtk begin

@require Compose begin

function fuse(m::ClickMap, canvas::GtkCanvas, image::Compose.Context)
  # Create the ComposeClickMap to make adjustments for screen density
  # Initializes to 96 dpi but is updated by the draw loop
  cm = ComposeClickMap(m, 1 / (96 / 25.4))
  @guarded Gtk.draw(canvas) do widget
    surf = Compose.CAIROSURFACE(Gtk.cairo_surface(widget))
    cm.mmpp = 1 / surf.ppmm
    Compose.draw(surf, image)
  end
  # Force showing the canvas at this point
  link_click_map(canvas, cm)
end

end

end
