-- https://lua.expert

return ((function()
    local fingerprintValue

    function fingerprintValue(p1) -- line: 5
        -- upvalues: fingerprintValue (ref)
        local v1 = typeof(p1)

        if v1 == "table" then
            local t1 = {}

            for v2 in p1 do
                table.insert(t1, v2)
            end

            table.sort(t1, function(p2, p3) -- line: 12
                return tostring(p2) < tostring(p3)
            end)

            local t2 = {}

            for _, v3 in t1 do
                table.insert(t2, tostring(v3) .. "=" .. fingerprintValue(p1[v3]))
            end

            return "{" .. table.concat(t2, ",") .. "}"
        end

        if v1 == "Color3" then
            return p1:ToHex()
        end

        return (tostring(p1))
    end

    return fingerprintValue
end)())
