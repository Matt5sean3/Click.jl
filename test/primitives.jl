
# Image Map
dummy = Rectangle(20, 30, 40, 50)
@test check_bounds(dummy, 0, 0) == false
@test check_bounds(dummy, 80, 80) == false
@test check_bounds(dummy, 40, 80) == false
@test check_bounds(dummy, 40, 40) == true

dummyCircle = Circle(40, 40, 30)
@test check_bounds(dummyCircle, 0, 0) == false
@test check_bounds(dummyCircle, 40, 40) == true
@test check_bounds(dummyCircle, 15, 15) == false
@test check_bounds(dummyCircle, 15, 25) == true

# TODO sort out ConvexPolygon type detection
dummyPoly = ConvexPolygon{Int64}((20, 20), (20, 40), (40, 40))
@test check_bounds(dummyPoly, 0, 0) == false
@test check_bounds(dummyPoly, 30, 35) == true
@test check_bounds(dummyPoly, 30, 25) == false
