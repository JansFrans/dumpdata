-- https://lua.expert

require(script.Parent.Parent.Types)

return ((function()
    local flatten

    function flatten(p1, p2) -- line: 30
        -- upvalues: flatten (ref)
        local v1 = if type(p2) == "number" then p2 else 1e999
        local v2 = {}

        for v3, v4 in pairs(p1) do
            if type(v4) == "table" and v1 > 0 then
                local v5 = flatten(v4, v1 - 1)

                for v6, v7 in pairs(v2) do
                    v5[v6] = v7
                end

                v2 = v5
            else
                v2[v3] = v4
            end
        end

        return v2
    end

    return flatten
end)())
