# Click!
Julia package to allow simpler interaction with graphics

## Warning
Large portions of this package still need testing so not everything is 
guaranteed to work.

## Image Maps
The simplest application of this library is to create a click map for a static 
image that is loaded into a GUI. Create the image map and connect it to the 
underlying GUI using this package as seen below for Gtk.

This code (example/gtk\_ex2.jl) creates a window with a square in the center 
of the window that opens an info dialog when clicked.

```julia
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
```

## Using GTK and Compose
A very useful case is to make objects from a library, such as Compose\*, which
abstracts the drawing process, clickable. This example 
(example/gtk\_compose\_ex.jl) demonstrates this by allowing essentially the 
same square to be clicked at both locations at which it is drawn. It also 
hides certain implementation details such as Gtk's drawing loop.

```julia
#!/usr/bin/env julia

using Gtk, Compose, Click

# Create a 400x400 canvas
canvas = @GtkCanvas(400, 400)
win = @GtkWindow(canvas, "GTK-Compose Example")

rect = rectangle(0.25, 0.25, 0.5, 0.5)
vect = compose(context(0mm, 0mm, 300mm, 300mm),
         rectangle(0.0, 0.0, 1.0, 1.0),
         fill("green"),
         compose(context(0.0, 0.0, 0.5, 0.5),
           rect,
           fill("black")),
         compose(context(0.5, 0.5, 0.5, 0.5),
           rect,
           fill("blue")))

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
```

\* Be careful with this at the moment as Compose support is a work in progress.
