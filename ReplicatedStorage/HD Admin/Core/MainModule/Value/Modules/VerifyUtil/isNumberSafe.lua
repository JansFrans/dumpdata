-- https://lua.expert

return function(p1) -- line: 4
    local v1 = if typeof(p1) == "string" then tonumber(p1) else p1

    if typeof(v1) == "number" and v1 == v1 then
        return math.abs(v1) ~= 1e999
    end

    return false
end
