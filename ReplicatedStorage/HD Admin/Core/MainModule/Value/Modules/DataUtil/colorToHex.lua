-- https://lua.expert

return function(p1, p2) -- line: 1
    local v2 = math.floor(p1.r * 255 + 0.5)
    local v4 = math.floor(p1.g * 255 + 0.5)
    local v6 = math.floor(p1.b * 255 + 0.5)

    return (if p2 == true then "" else "#") .. ("%02x%02x%02x"):format(v2, v4, v6)
end
