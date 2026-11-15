-- https://lua.expert

return ((function()
    local deepCopyTable

    function deepCopyTable(p1) -- line: 1
        -- upvalues: deepCopyTable (ref)
        assert(type(p1) == "table", "First argument must be a table")

        local v2 = table.create(#p1)

        for v3, v4 in p1 do
            if type(v4) == "table" then
                v2[v3] = deepCopyTable(v4)
            else
                v2[v3] = v4
            end
        end

        return v2
    end

    return deepCopyTable
end)())
