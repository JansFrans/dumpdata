-- https://lua.expert

local function pop(p1, p2) -- line: 20
    local v1 = #p1
    local t1 = {}

    for i = 1, v1 - (if type(p2) == "number" then p2 else 1) do
        table.insert(t1, p1[i])
    end

    return t1
end

return pop
