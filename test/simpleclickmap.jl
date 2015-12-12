
clickRect = ClickableBounds(Rectangle(20, 20, 100, 20))
clickCirc = ClickableBounds(Circle(30, 100, 20))
clickTri = ClickableBounds(ConvexPolygon{Int64}((70, 60), (90, 60), (90, 80)))

rectClicks = 0
attend(clickRect, :click) do frm
  global rectClicks
  rectClicks += 1
end

circClicks = 0
attend(clickCirc, :click) do frm
  global circClicks
  circClicks += 1
end

triClicks = 0
attend(clickTri, :click) do frm
  global triClicks
  triClicks += 1
end

# test to ensure that triggers propagate through the click map correctly
@test rectClicks == 0
@test circClicks == 0
@test triClicks == 0
m = SimpleClickMap(clickRect, clickCirc, clickTri)
update(m, 0, 0, :down)
update(m, 0, 0, :up)
@test rectClicks == 0
@test circClicks == 0
@test triClicks == 0
update(m, 30, 30, :down)
update(m, 30, 30, :up)
@test rectClicks == 1
@test circClicks == 0
@test triClicks == 0

