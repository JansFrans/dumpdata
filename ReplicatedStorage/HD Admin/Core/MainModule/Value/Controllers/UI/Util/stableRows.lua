-- https://lua.expert

return function() -- line: 22
    local t1 = {}
    local t2 = {}

    return function(p1, p2, p3) -- reuse | line: 25
        -- upvalues: t1 (ref), t2 (ref)
        local v1 = t2[p1] or t1[p1]

        if v1 and v1.fingerprint == p2 then
            local t3 = t2

            t3[p1] = v1

            return v1.row
        end

        local v2 = p3()
        local t4 = t2

        t4[p1] = {
            fingerprint = p2,
            row = v2
        }

        return v2
    end, function() -- sweep | line: 35
        -- upvalues: t1 (ref), t2 (ref)
        t1 = t2
        t2 = {}
    end
end
