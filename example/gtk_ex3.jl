#!/usr/bin/env julia

using Click, Click.Primitives, Cairo, Gtk

rectGeom = (20, 20, 60, 20)
drag = DraggableClickable(Rectangle(rectGeom...))


# Create 400x400 canvas
canvas = @GtkCanvas(400, 400)
win = @GtkWindow(canvas, "Gtk Drag Example")

color = (0.0, 0.0, 0.0, 1.0)
@guarded draw(canvas) do widget
  global color
  ctx = getgc(widget)

  # Clear the canvas
  set_source_rgba(ctx, 0.0, 0.0, 0.0, 0.0)

  set_operator(ctx, Cairo.OPERATOR_CLEAR)
  paint(ctx)

  set_operator(ctx, Cairo.OPERATOR_OVER)

  set_source_rgba(ctx, color...)
  set_line_width(ctx, 5)

  mat = transform_matrix(drag)
  set_matrix(ctx, CairoMatrix(
    mat[1, 1], mat[2, 1], 
    mat[1, 2], mat[2, 2], 
    mat[1, 3], mat[2, 3]))
  
  rectangle(ctx, rectGeom...)
  stroke(ctx)
end

attend(drag, :move) do frm, x, y
  global canvas
  draw(canvas)
end

attend(drag, :click) do frm, x, y
  global color
  global win
  global canvas
  if color[1] == 0.0
    color = (1.0, 1.0, 1.0, 1.0)
  else
    color = (0.0, 0.0, 0.0, 1.0)
  end
  draw(canvas)
end

m = SimpleClickMap(drag)
link_click_map(canvas, m)

show(canvas)

if !isinteractive()
  signal_connect(win, :destroy) do widget
    Gtk.gtk_quit()
  end
  Gtk.gtk_main()
end
