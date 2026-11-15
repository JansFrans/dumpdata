-- https://lua.expert

return require(script.Parent._Filter)("Multiply", function(p1, p2) -- line: 11
    return p2 * 255 * (p1 * 255) / 255
end)
