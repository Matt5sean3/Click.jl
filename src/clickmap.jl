
"""
ClickMap is an abstract type that implements these functions:

has default implementation:
* `update`

required
* `clickables`

optional
* `Base.push!`

A modifiable ClickMap must implement the Base.push! function to allow adding
new clickables to the 
"""
abstract ClickMap
import Base: push!

# default implementation
function update(m::ClickMap, x::Number, y::Number, trigger::Symbol)
  [update(clickable, x, y, trigger) for clickable in clickables(m)]
end

"""
```julia
clickable(m::ClickMap)
```
* `m` - the click map containing the clickables.

Returns all the clickables contained in the ClickMap
"""
clickables(m::ClickMap) = 
  error("`clickables` not implemented for the given ClickMap")

Base.push!(m::ClickMap, c...) = 
  warn("`Base.push!` not implemented for the given ClickMap")
