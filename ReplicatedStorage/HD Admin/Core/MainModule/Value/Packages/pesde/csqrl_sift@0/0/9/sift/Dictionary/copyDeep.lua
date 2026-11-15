-- https://lua.expert

return ((function()
    local copyDeep

    function copyDeep(p1) -- line: 20
        -- upvalues: copyDeep (ref)
        local v1 = table.clone(p1)

        for v2, v3 in pairs(p1) do
            if type(v3) == "table" then
                v1[v2] = copyDeep(v3)
            end
        end

        return v1
    end

    return copyDeep
end)())
