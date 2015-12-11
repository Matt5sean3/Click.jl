
"""
```julia
SimpleClickMap()
SimpleClickMap(c...)
```

* `c` - Clickables that the click map is initialized with
"""
type SimpleClickMap <: ClickMap
  clicks::Array{Clickable, 1}
  function SimpleClickMap()
    return new(Array{Clickable, 1}())
  end
  function SimpleClickMap(c...)
    return new(Array{Clickable, 1}(collect(c)))
  end
end

function clickables(m::SimpleClickMap)
  return m.clicks
end

Base.push!(m::SimpleClickMap, c...) = push!(m.clicks, c...)
