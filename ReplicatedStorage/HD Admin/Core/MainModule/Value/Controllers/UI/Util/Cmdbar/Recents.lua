-- https://lua.expert

local t1 = {
    toList = function(p1) -- toList | line: 31
        if typeof(p1) ~= "table" then
            return {}
        end

        local t2 = {}

        for v1, v2 in p1 do
            if typeof(v2) == "string" then
                table.insert(t2, {
                    order = if typeof(v1) == "number" then v1 else tonumber(v1) or 1e999,
                    message = v2
                })
            end
        end

        table.sort(t2, function(p2, p3) -- line: 42
            return p2.order < p3.order
        end)

        local t4 = {}

        for _, v3 in t2 do
            table.insert(t4, v3.message)
        end

        return t4
    end
}

function t1.rows(p4) -- line: 52
    -- upvalues: t1 (copy)
    local v4 = t1.toList(p4)
    local t5 = {}

    for v5, v6 in v4 do
        if v5 > 8 then
            break
        end

        table.insert(t5, {
            kind = "recent",
            keys = { v6 },
            text = v6,
            display = v6,
            recency = #v4 - v5
        })
    end

    return t5
end

return t1
