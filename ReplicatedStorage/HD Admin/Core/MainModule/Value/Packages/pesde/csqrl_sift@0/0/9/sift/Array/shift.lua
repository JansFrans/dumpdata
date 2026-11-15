-- https://lua.expert

local function shift(p1, p2) -- line: 20
    local v1 = #p1
    local t1 = {}

    for i = if type(p2) == "number" then p2 + 1 else 2, v1 do
        table.insert(t1, p1[i])
    end

    return t1
end

return shift
