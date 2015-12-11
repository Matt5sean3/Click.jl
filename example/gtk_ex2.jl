#!/usr/bin/env julia
using Click, Click.Primitives, Gtk, Graphics

# create a 200x200 canvas in a window
canvas = @GtkCanvas(200, 200)
win = @GtkWindow(canvas, "Gtk Example")

# Setup drawing the rectangle
@guarded draw(canvas) do c
  ctx = getgc(c)
  set_source_rgb(ctx, 1.0, 0.0, 0.0)
  rectangle(ctx, 50, 50, 100, 100)
  fill(ctx)
end

# create a 100x100 clickable rectangle
rect = Rectangle(50, 50, 100, 100)
clickRect = ClickableRectangle(rect)

# Attach a callback to a click event
attend(clickRect, :click) do widget
  global win
  info_dialog("Clicked the rectangle", win)
end

# create a ClickMap containing the clickable rectangle
m = SimpleClickMap(clickRect)

# link the click map to the canvas
link_click_map(canvas, m)

# Display the result
show(canvas)

# Pause main thread execution in non-interactive mode
if !isinteractive()
  signal_connect(win, :destroy) do widget
    Gtk.gtk_quit()
  end
  Gtk.gtk_main()
end
