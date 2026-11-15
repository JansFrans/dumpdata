-- https://lua.expert

return function(p1) -- line: 1
    local v1 = p1:gsub("#", "")
    local v3 = tonumber("0x" .. v1:sub(1, 2))
    local v5 = tonumber("0x" .. v1:sub(3, 4))
    local v7 = tonumber("0x" .. v1:sub(5, 6))

    return Color3.fromRGB(v3, v5, v7)
end
