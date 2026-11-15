-- https://lua.expert

local t1 = {
    perm = true,
    join = true,
    global = true,
    wasglobal = true,
    undo = true,
    un = true,
    unperm = true,
    preview = true
}

return function(p1, p2) -- line: 15
    -- upvalues: t1 (copy)
    if typeof(p2) ~= "table" then
        return p1
    end

    local t2 = {}

    for v1 in p2 do
        local v2 = tostring(v1):lower()

        if not t1[v2] then
            table.insert(t2, v2:sub(1, 1):upper() .. v2:sub(2))
        end
    end

    if #t2 == 0 then
        return p1
    end

    table.sort(t2)

    return table.concat(t2) .. p1
end
