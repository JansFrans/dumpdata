-- https://lua.expert

return require(script.Parent._Filter)("Overlay", function(p1, p2) -- line: 11
    local v1 = p1 * 255
    local v2 = p2 * 255

    return v1 < 128 and v2 * 2 * v1 / 255 or 255 - (255 - v1) * 2 * (255 - v2) / 255
end)
