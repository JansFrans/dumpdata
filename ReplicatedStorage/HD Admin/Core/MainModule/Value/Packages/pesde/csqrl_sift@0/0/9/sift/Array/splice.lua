-- https://lua.expert

local function splice(p1, p2, p3, ...) -- line: 22
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

    for i = 1, v2 - 1 do
        table.insert(t1, p1[i])
    end

    for _, v5 in ipairs({ ... }) do
        table.insert(t1, v5)
    end

    for i = v3 + 1, v1 do
        table.insert(t1, p1[i])
    end

    return t1
end

return splice
