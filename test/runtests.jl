using Click

# A basic bounds checker
type DummyRectangleBounds <: Bounds
  x::Number
  y::Number
  width::Number
  height::Number
end

function check_bounds(bounds::DummyRectangleBounds, x::Number, y::Number)
  return bounds.x < x < bounds.x + bounds.width && 
    bounds.y < y < bounds.y + bounds.width
end

dummy = DummyRectangleBounds(20, 30, 40, 50)
@test check_bounds(dummy, 0, 0) == false
@test check_bounds(dummy, 80, 80) == false
@test check_bounds(dummy, 40, 80) == false
@test check_bounds(dummy, 40, 40) == true

# Doesn't really test anything outside the test code itself yet
