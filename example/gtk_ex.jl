#!/usr/bin/env julia
using Click, Gtk, Graphics, Click.Primitives

# Create a simple click map onto a 400x400 smily face created with Cairo

# Click the left eye to toggle the red component of color
# Click the right eye to toggle the blue component of color
color = [0.0, 0.0, 0.0]

# specify geometry
circGeom = ((200, 200, 150),
            (125, 125, 10),
            (275, 125, 10))
arcGeom = ((200, 200, 125, 45 * pi / 180, 135 * pi / 180), )

left = ClickableBounds(
           Primitives.Circle(
               circGeom[2][1], 
               circGeom[2][2], 
               circGeom[2][3]))
right = ClickableBounds(
           Primitives.Circle(
               circGeom[3][1], 
               circGeom[3][2], 
               circGeom[3][3]))

# Create the simple click map to match up with geometry

canvas = @GtkCanvas(400, 400)

attend(left, :click) do frm, x, y
  global color
  global canvas
  if color[1] < 1.0
    color[1] = 1.0
  else
    color[1] = 0.0
  end
  # trigger canvas redraw
  draw(canvas)
end

attend(right, :click) do frm, x, y
  global color
  global canvas
  if color[3] < 1.0
    color[3] = 1.0
  else
    color[3] = 0.0
  end
  # trigger canvas redraw
  draw(canvas)
end

link_click_map(canvas, SimpleClickMap(left, right))

win = @GtkWindow(canvas, "GTK Smily Face Example")

@guarded draw(canvas) do c

  global color
  global circGeom
  global arcGeom
  
  ctx = getgc(c)

  set_source_rgb(ctx, color[1], color[2], color[3])
  set_line_width(ctx, 5)

  for circ in circGeom
    new_path(ctx)
    circle(ctx, circ...)
    stroke(ctx)
  end

  for ar in arcGeom
    new_path(ctx)
    arc(ctx, ar...)
    stroke(ctx)
  end

end

show(canvas)

if !isinteractive()
  signal_connect(win, :destroy) do widget
    Gtk.gtk_quit()
  end
  Gtk.gtk_main()
end
