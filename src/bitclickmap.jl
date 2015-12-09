
"""
```julia
BitBounds(arr::Array{UInt64, 2}, idx::UInt64)
```
"""
type BitBounds <: Bounds
  map::Array{Int64, 2}
  idx::UInt64
end

function check_bounds(bounds::BitBounds, x::Number, y::Number)
  return bounds.map[x, y] == bounds.idx
end

"""
```julia
BitClickable(b::BitBounds)
```
"""
typealias BitClickable ClickableBounds{BitBounds}
# 
# """
# ```julia
# BitClickMap(m::ClickMap, width::UInt64, height::UInt64)
# ```
# 
# Creates a click map from the other click map
# 
# Memory heavy but lighter on the processer
# Only allows one clickable to be activated at a time
# """
# type BitClickMap <: m::ClickMap
#   map::Array{Int64, 2}
#   clicks::Array{1, BitClickable}
#   width::UInt64
#   height::UInt64
# end
# 
# function clickables(m::BitClickMap)
#   return m.clicks
# end
# 
# function update(m::BitClickMap, x::Number, y::Number, trigger::Symbol)
#   idx = m.map[x, y]
#   if idx > 0
#     update(clicks[idx], x, y, trigger)
#   end
# end

