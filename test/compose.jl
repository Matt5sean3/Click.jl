using Click
using Compose

# test simplest case compose support
r = rectangle(20px, 10px, 40px, 20px)
x = compose(context(0px, 0px, 400px, 400px), r)

c = create_bounds(r, x)

@test check_bounds(c, 0, 0) == false
@test check_bounds(c, 21, 11) == true # top-left corner
@test check_bounds(c, 19, 11) == false
@test check_bounds(c, 21, 9) == false
@test check_bounds(c, 59, 11) == true # top-right corner
@test check_bounds(c, 59, 9) == false
@test check_bounds(c, 61, 11) == false
@test check_bounds(c, 21, 29) == true # bottom-left corner
@test check_bounds(c, 21, 31) == false
@test check_bounds(c, 19, 29) == false
@test check_bounds(c, 59, 29) == true # bottom-right corner
@test check_bounds(c, 61, 29) == false
@test check_bounds(c, 59, 31) == false

# test compose with translative compositions
x = compose(context(0px, 0px, 400px, 400px), 
      compose(context(0.0, 0.0, 0.5, 0.5), r),
      compose(context(0.5, 0.5, 0.5, 0.5), r))

c = create_bounds(r, x)

@test check_bounds(c, 21, 11) == true # top-left corner
@test check_bounds(c, 19, 11) == false
@test check_bounds(c, 21, 9) == false
@test check_bounds(c, 59, 11) == true # top-right corner
@test check_bounds(c, 59, 9) == false
@test check_bounds(c, 61, 11) == false
@test check_bounds(c, 21, 29) == true # bottom-left corner
@test check_bounds(c, 21, 31) == false
@test check_bounds(c, 19, 29) == false
@test check_bounds(c, 59, 29) == true # bottom-right corner
@test check_bounds(c, 61, 29) == false
@test check_bounds(c, 59, 31) == false

@test check_bounds(c, 221, 211) == true # top-left corner
@test check_bounds(c, 219, 211) == false
@test check_bounds(c, 221, 209) == false
@test check_bounds(c, 259, 211) == true # top-right corner
@test check_bounds(c, 259, 209) == false
@test check_bounds(c, 261, 211) == false
@test check_bounds(c, 221, 229) == true # bottom-left corner
@test check_bounds(c, 221, 231) == false
@test check_bounds(c, 219, 229) == false
@test check_bounds(c, 259, 229) == true # bottom-right corner
@test check_bounds(c, 261, 229) == false
@test check_bounds(c, 259, 231) == false
