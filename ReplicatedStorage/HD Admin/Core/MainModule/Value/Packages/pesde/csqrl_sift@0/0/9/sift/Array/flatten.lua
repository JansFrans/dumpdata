-- https://lua.expert

return ((function()
    local flatten

    function flatten(p1, p2) -- line: 24
        -- upvalues: flatten (ref)
        local v1 = if type(p2) == "number" then p2 else 1e999
        local t1 = {}

        for _, v2 in ipairs(p1) do
            if type(v2) == "table" and v1 > 0 then
                local v3 = flatten(v2, v1 - 1)

                for _, v4 in ipairs(v3) do
                    table.insert(t1, v4)
                end
            else
                table.insert(t1, v2)
            end
        end

        return t1
    end

    return flatten
end)())
