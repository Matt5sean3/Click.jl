
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

clickRect = ClickableBounds(dummy)
clickCircle = ClickableBounds(dummyCircle)
clickPoly = ClickableBounds(dummyPoly)

circleClicked = 0
attend(clickCircle, :click) do clickable
  global circleClicked
  circleClicked += 1
end

polyClicked = 0
attend(clickPoly, :click) do clickable
  global polyClicked
  polyClicked += 1
end


rectClicked = 0
attend(clickRect, :click) do clickable
  global rectClicked
  rectClicked += 1
end
# left down then up at same spot outside
# no click
update(clickRect, 0, 0, :down)
update(clickRect, 0, 0, :up)
@test rectClicked == 0

# left down inside, then up outside
# no click
update(clickRect, 40,40, :down)
update(clickRect, 0, 0, :up)
@test rectClicked == 0

# left down outside, then up inside
# no click
update(clickRect, 0, 0, :down)
update(clickRect, 40,40, :up)
@test rectClicked == 0

# left down inside, move outside, then up inside
# no click

update(clickRect, 40, 40, :down)
update(clickRect, 0, 0, :move)
update(clickRect, 40, 40, :up)
@test rectClicked == 0

# left down then up at same spot inside
# yes click
update(clickRect, 40, 40, :down)
update(clickRect, 40, 40, :up)
@test rectClicked == 1

# left down then up at different spot inside
# yes click
update(clickRect, 40, 40, :down)
update(clickRect, 40, 45, :up)
@test rectClicked == 2

# same tests for right mouse button
rightRectClicked = 0
attend(clickRect, :rightclick) do clickable
  global rightRectClicked
  rightRectClicked += 1
end
update(clickRect, 0, 0, :rightdown)
update(clickRect, 0, 0, :rightup)
@test rightRectClicked == 0
update(clickRect, 40,40, :rightdown)
update(clickRect, 0, 0, :rightup)
@test rightRectClicked == 0
update(clickRect, 0, 0, :rightdown)
update(clickRect, 40,40, :rightup)
@test rightRectClicked == 0
update(clickRect, 40, 40, :rightdown)
update(clickRect, 0, 0, :rightmove)
update(clickRect, 40, 40, :rightup)
@test rightRectClicked == 0
update(clickRect, 40, 40, :rightdown)
update(clickRect, 40, 40, :rightup)
@test rightRectClicked == 1
update(clickRect, 40, 40, :rightdown)
update(clickRect, 40, 45, :rightup)
@test rightRectClicked == 2

# same tests for center mouse button
centerRectClicked = 0
attend(clickRect, :centerclick) do clickable
  global centerRectClicked
  centerRectClicked += 1
end
update(clickRect, 0, 0, :centerdown)
update(clickRect, 0, 0, :centerup)
@test centerRectClicked == 0
update(clickRect, 40,40, :centerdown)
update(clickRect, 0, 0, :centerup)
@test centerRectClicked == 0
update(clickRect, 0, 0, :centerdown)
update(clickRect, 40,40, :centerup)
@test centerRectClicked == 0
update(clickRect, 40, 40, :centerdown)
update(clickRect, 0, 0, :centermove)
update(clickRect, 40, 40, :centerup)
@test centerRectClicked == 0
update(clickRect, 40, 40, :centerdown)
update(clickRect, 40, 40, :centerup)
@test centerRectClicked == 1
update(clickRect, 40, 40, :centerdown)
update(clickRect, 40, 45, :centerup)
@test centerRectClicked == 2

