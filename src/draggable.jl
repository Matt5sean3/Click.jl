
# A draggable is essentially a movable blob
# by necessity
"""
```julia
abstract Draggable <: Clickable
```

has default implementation:
* `rotate`
* `translate`

required:
* `transform`

optional:
* `transform_matrix`

A draggable object is essentially a clickable object that can be moved using 
simple transforms.
"""
# transform is the only method that needs to be implemented
abstract Draggable <: Clickable

"""
```julia
transform(d::Draggable, A::Matrix{Number, 2})
```

* `A` - a 3x3 homogeneous transform matrix

Must be implemented to apply the transform such that if the draggable were a
point cloud with a point at x, it's transformed location would be x'
x' = A * x
"""
transform(d::Draggable, mat::Matrix) = 
  error("Transform not implemented for this draggable")

"""
```julia
rotate(d::Draggable, angle::Number)
```

Rotates the draggable, has a default implementation
that uses transform internally.
"""
rotate(d::Draggable, angle::Number) =
  transform(d, [cos(angle) -sin(angle) 0.0; 
                sin(angle)  cos(angle) 0.0; 
                0.0         0.0        1.0])

"""
```julia
translate(d::Draggable, dx::Number, dy::Number)
```
"""
translate(d::Draggable, dx::Number, dy::Number) =
  transform(d, [1.0 0.0 dx; 
                0.0 1.0 dy; 
                0.0 0.0 1.0])

"""
```julia
transform_matrix(d::Draggable)
```

Used to access the homogeneous transform matrix between local coordinates 
of the draggable and global coordinates, not necessarily writable.
"""
transform_matrix(d::Draggable) =
  warn("`transform_matrix` not implemented for this `Draggable`")

