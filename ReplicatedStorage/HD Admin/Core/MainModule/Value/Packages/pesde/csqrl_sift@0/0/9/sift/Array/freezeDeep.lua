-- https://lua.expert

return ((function()
    local freezeDeep

    function freezeDeep(p1) -- line: 21
        -- upvalues: freezeDeep (ref)
        local t1 = {}

        for i = 1, #p1 do
            local v1 = p1[i]

            if type(v1) == "table" then
                local freezeDeep2 = freezeDeep

                table.insert(t1, freezeDeep2(v1))
            else
                table.insert(t1, v1)
            end
        end

        table.freeze(t1)

        return t1
    end

    return freezeDeep
end)())
