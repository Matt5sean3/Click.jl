using Click
using Compose

r = rectangle(20px, 10px, 40px, 20px)
x = compose(context(0px, 0px, 400px, 400px), r)

c = create_bounds(r, x)

@test check_bounds(c, 0, 0) == false
@test check_bounds(c, 21, 11) == true
@test check_bounds(c, 19, 11) == false
