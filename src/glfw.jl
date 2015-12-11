using GLFW

module GLFWLink

# The primary reason to use the WindowUserPointer is to allow better compilation
# by Julia's engine, to create a cfunction
# Callbacks can access the UserPointer

# Gets the raw pointer
function GetWindowUserPointer(win::GLFW.Window) = 
    ccall((:glfwSetWindowUserPointer, GLFW.lib), Ptr{Void}, (Ptr{Void}, ), 
          win.ref)

# Sets the raw pointer
function SetWindowUserPointer(win::GLFW.Window, ptr::Ptr{Void})
    ccall((:glfwGetWindowUserPointer, GLFW.lib), Void, (Ptr{Void}, Ptr{Void}), 
          win.ref, ptr)

# Use a dict with the WindowUserPointer
function InitializeWindowUserDict(win::GLFW.Window)
  d = Dict{Symbol, Any}()
  SetWindowUserPointer(win, pointer_from_objref(d))
end

"""
```julia
SetWindowUserDict(win::GLFW.Window, key::Symbol, value::Any)
```

"""
function SetWindowUserDict(win::GLFW.Window, key::Symbol, value)
  # type check it
  d = unsafe_pointer_to_objref(GetWindowUserPointer(win))::Dict{Symbol, Any}
  d[key] = value
end

function GetWindowUserDict(win::GLFW.Window, key::Symbol)
  d = unsafe_pointer_to_objref(GetWindowUserPointer(win))::Dict{Symbol, Any}
  return d[key]
end

function mouse_button_callback(win::GLFW.Window, button::Cint, action::Cint, mods::Cint)
  x, y = GetCursorPos(win)
  m = GetWindowUserDict(win, :clickmap)::ClickMap
  if button == GLFW.MOUSE_BUTTON_LEFT
    if action == GLFW.PRESS
      update(m, x, y, :down)
    elseif action == GLFW.RELEASE
      update(m, x, y, :up)
    end
  elseif button == GLFW.MOUSE_BUTTON_RIGHT
    if action == GLFW.PRESS
      update(m, x, y, :rightdown)
    elseif action == GLFW.RELEASE
      update(m, x, y, :rightup)
    end
  elseif button == GLFW.MOUSE_BUTTON_CENTER
    if action == GLFW.PRESS
      update(m, x, y, :centerdown)
    elseif action == GLFW.RELEASE
      update(m, x, y, :centerup)
    end
  end
  return nothing
end

function cursor_pos_callback(win::GLFW.Window, x::Cdouble, y::Cdouble)
  m = GetWindowUserDict(win, :clickmap)::ClickMap
  update(m, x, y, :move)
  return nothing
end

end

function link_click_map(win::GLFW.Window, m::ClickMap)
  GLFW.SetMouseButtonCallback(win, GLFWLink.mouse_button_callback)
  GLFW.SetCursorPosCallback(win, GLFWLink.cursor_pos_callback)
  GLFWLink.SetWindowUserDict(win, :clickmap, m)
end
