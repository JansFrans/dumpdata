-- https://lua.expert

local function slice(p1, p2, p3) -- line: 21
    local v1 = #p1
    local t1 = {}
    local v2 = if type(p2) == "number" then p2 else 1
    local v3 = if type(p3) == "number" then p3 else v1

    if v2 < 1 then
        v2 += v1
    end

    if v3 < 1 then
        v3 += v1
    end

    for i = v2, v3 do
        table.insert(t1, p1[i])
    end

    return t1
end

return slice
