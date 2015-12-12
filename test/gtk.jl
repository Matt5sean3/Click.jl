
# Tries to test integration with Gtk
# Does this essentially headlessly
using Gtk
clickRect = ClickableBounds(Rectangle(20, 20, 100, 20))

m = SimpleClickMap(clickRect)

canvas = @GtkCanvas()
# win = @GtkWindow(canvas, "Test Gtk")
link_click_map(canvas, m)

start = time()

downEvt = Gtk.GdkEventButton(
  Gtk.GEnum(Gtk.GdkEventType.BUTTON_PRESS),
  Ptr{Void}(0),
  # win.handle,
  1,
  round((time() - start) * 1000),
  40.0, 30.0,
  Ptr{Float64}(0),
  Gtk.GdkModifierType.BUTTON1,
  1,
  Ptr{Void}(0),
  0.0,
  0.0)

upEvt = Gtk.GdkEventButton(
  Gtk.GdkEventType.BUTTON_RELEASE,
  Ptr{Void}(0),
  # win.handle,
  1,
  Int32(round((time() - start) * 1000)),
  40.0, 30.0,
  Ptr{Float64}(0),
  0,
  1,
  Ptr{Void}(0),
  0.0,
  0.0)

rightDownEvt = Gtk.GdkEventButton(
  Gtk.GEnum(Gtk.GdkEventType.BUTTON_PRESS),
  Ptr{Void}(0),
  # win.handle,
  1,
  round((time() - start) * 1000),
  40.0, 30.0,
  Ptr{Float64}(0),
  Gtk.GdkModifierType.BUTTON3,
  3,
  Ptr{Void}(0),
  0.0,
  0.0)

rightUpEvt = Gtk.GdkEventButton(
  Gtk.GdkEventType.BUTTON_RELEASE,
  Ptr{Void}(0),
  # win.handle,
  1,
  Int32(round((time() - start) * 1000)),
  40.0, 30.0,
  Ptr{Float64}(0),
  0,
  3,
  Ptr{Void}(0),
  0.0,
  0.0)

centerDownEvt = Gtk.GdkEventButton(
  Gtk.GEnum(Gtk.GdkEventType.BUTTON_PRESS),
  Ptr{Void}(0),
  # win.handle,
  1,
  round((time() - start) * 1000),
  40.0, 30.0,
  Ptr{Float64}(0),
  Gtk.GdkModifierType.BUTTON2,
  2,
  Ptr{Void}(0),
  0.0,
  0.0)

centerUpEvt = Gtk.GdkEventButton(
  Gtk.GdkEventType.BUTTON_RELEASE,
  Ptr{Void}(0),
  # win.handle,
  1,
  Int32(round((time() - start) * 1000)),
  40.0, 30.0,
  Ptr{Float64}(0),
  0,
  2,
  Ptr{Void}(0),
  0.0,
  0.0)

moveEvt = Gtk.GdkEventMotion(
  Gtk.GdkEventType.MOTION_NOTIFY,
  Ptr{Void}(0),
  # win.handle,
  1,
  Int32(round((time() - start) * 1000)),
  0.0, 0.0,
  Ptr{Float64}(0),
  0,
  0,
  Ptr{Void}(0),
  0.0,
  0.0)

leftClicks = 0
attend(clickRect, :click) do frm
  global leftClicks
  leftClicks += 1
end

rightClicks = 0
attend(clickRect, :rightclick) do frm
  global rightClicks
  rightClicks += 1
end

centerClicks = 0
attend(clickRect, :centerclick) do frm
  global centerClicks
  centerClicks += 1
end

@test leftClicks == 0
@test rightClicks == 0
@test centerClicks == 0

# show(canvas)

signal_emit(canvas, "button-press-event", Cint, 
            downEvt, 
            pointer_from_objref(m))

@test leftClicks == 0
@test rightClicks == 0
@test centerClicks == 0

signal_emit(canvas, "button-release-event", Cint, 
            upEvt, 
            pointer_from_objref(m))

@test leftClicks == 1
@test rightClicks == 0
@test centerClicks == 0

signal_emit(canvas, "button-press-event", Cint, 
            rightDownEvt, 
            pointer_from_objref(m))

@test leftClicks == 1
@test rightClicks == 0
@test centerClicks == 0

signal_emit(canvas, "button-release-event", Cint, 
            rightUpEvt, 
            pointer_from_objref(m))

@test leftClicks == 1
@test rightClicks == 1
@test centerClicks == 0

signal_emit(canvas, "button-press-event", Cint, 
            centerDownEvt, 
            pointer_from_objref(m))

@test leftClicks == 1
@test rightClicks == 1
@test centerClicks == 0

signal_emit(canvas, "button-release-event", Cint, 
            centerUpEvt, 
            pointer_from_objref(m))

@test leftClicks == 1
@test rightClicks == 1
@test centerClicks == 1

signal_emit(canvas, "motion-notify-event", Cint, 
            moveEvt, 
            pointer_from_objref(m))

# destroy(win)
