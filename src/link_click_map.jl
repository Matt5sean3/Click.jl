"""
```julia
link_click_map(widget, m::ClickMap)
```

* `widget` - widget internal to GUI system that the click map is mapped onto
* `m` - click map that is mapped onto the widget

Most GUIs have a concept of a widget at some level. For the most basic GUI
frameworks the only widget may be a window with all innards of the window
acting as a drawing canvas.

As an example, GLFW really only implements a Window widget which the ClickMap
is mapped onto.

However, Gtk has multiple widgets that make sense to map onto such as Image,
Canvas, and others which can all be mapped onto.
"""
link_click_map(widget, m::ClickMap) = 
  error("ClickMap linking not implemented for the given widget")
