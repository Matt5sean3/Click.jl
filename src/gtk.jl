using Gtk

module GtkLink
# Mostly used as a namespace
# These functions are only meant to be used internally
using Click
using Gtk

buttonDown = [
  :down,
  :centerdown,
  :rightdown
  ]
function pressed(widget::Ptr, event::Ptr{Gtk.GdkEvent}, m::ClickMap)
  evt = Gtk.GdkEvent(event)
  update(m, evt.x, evt.y, buttonDown[evt.button])
  return Cint(0)
end

buttonUp = [
  :up,
  :centerup,
  :rightup
  ]
function released(widget::Ptr, event::Ptr{Gtk.GdkEvent}, m::ClickMap)
  evt = Gtk.GdkEvent(event)
  update(m, evt.x, evt.y, buttonUp[evt.button])
  return Cint(0)
end

function moved(widget::Ptr, event::Ptr{Gtk.GdkEvent}, m::ClickMap)
  evt = Gtk.GdkEvent(event)
  update(m, evt.x, evt.y, :move)
  return Cint(0)
end

end # module

# Should be able to connect to any widget that supports mouse events

# However, it's not recommended to use this to accomplish goals that can be
# achieved in a way that makes sense with just Gtk

# GtkEventBox isn't wrapped by Gtk.jl but would work for this
# and would fill some functionality here

function link_click_map(widget::Gtk.GtkWidget, m::ClickMap)
  # Only widgets with GDK windows are usable
  # gtk_widget_get_has_window wrapping
  if !Gtk.GAccessor.has_window(widget)
    # Widgets without a GDK window internally cannot be used
    error("Only widgets with GDK windows can be used with click maps")
  end

  # button-press-event requires GDK_BUTTON_PRESS_MASK
  # Gtk.GdkEventMask.BUTTON_PRESS
  # button-release-event requires GDK_BUTTON_RELEASE_MASK
  # Gtk.GdkEventMask.BUTTON_RELEASE
  # motion-notify-event requires GDK_POINTER_MOTION_MASK
  # Gtk.GdkEventMask.POINTER_MOTION

  # gtk_widget_add_events wrapping, generally safer than gtk_widget_set_events
  Gtk.add_events(widget,
      Gtk.GdkEventMask.BUTTON_PRESS |
      Gtk.GdkEventMask.BUTTON_RELEASE |
      Gtk.GdkEventMask.POINTER_MOTION )

  # uses Gtk.jl's "more_signals.md" functionality for better performance
  signal_connect(GtkLink.pressed, widget, "button-press-event", Cint, 
                 (Ptr{Gtk.GdkEvent}, ), false, m)
  signal_connect(GtkLink.released, widget, "button-release-event", Cint, 
                 (Ptr{Gtk.GdkEvent}, ), false, m)
  signal_connect(GtkLink.moved, widget, "motion-notify-event", Cint, 
                 (Ptr{Gtk.GdkEvent}, ), false, m)
end

