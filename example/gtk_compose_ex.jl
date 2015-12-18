#!/usr/bin/env julia

using Gtk, Compose, Click

# Create a 400x400 canvas
canvas = @GtkCanvas(400, 400)
win = @GtkWindow(canvas, "GTK-Compose Example")

rect = rectangle(0.25, 0.25, 0.5, 0.5)
vect = compose(context(0mm, 0mm, 100mm, 100mm), 
               rect, 
               fill("black"))

cl = create_clickable(rect, vect)

attend(cl, :click) do frm, x, y
  info_dialog("Clicked Square", win)
end

# Use the fuse function to stitch things together

# ComposeClickMap needs to wrap SimpleClickMap to account for pixel density
# which that object is updated with internal to fuse
fuse(SimpleClickMap(cl), canvas, vect)

show(canvas)

# block the main thread of execution if not interactive
if !isinteractive()
  signal_connect(win, :destroy) do widget
    Gtk.gtk_quit()
  end
  Gtk.gtk_main()
end

