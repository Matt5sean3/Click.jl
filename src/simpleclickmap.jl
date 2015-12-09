
"""
```julia
SimpleClickMap()
```
"""
type SimpleClickMap
  clicks::Array{Clickable, 1}
  function SimpleClickMap()
    return new(Array{Clickable, 1}())
  end
end

function clickables(m::SimpleClickMap)
  return m.clicks
end

Base.push!(m::SimpleClickMap, c...) = push!(m.clicks, c...)
