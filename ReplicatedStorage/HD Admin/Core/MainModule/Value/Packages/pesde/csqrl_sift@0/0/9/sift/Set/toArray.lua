-- https://lua.expert

local function toArray(p1) -- line: 17
    local t1 = {}

    for v1, _ in pairs(p1) do
        table.insert(t1, v1)
    end

    return t1
end

return toArray
