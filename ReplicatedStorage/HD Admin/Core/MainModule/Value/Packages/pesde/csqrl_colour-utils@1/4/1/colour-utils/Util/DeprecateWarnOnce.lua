-- https://lua.expert

local function deprecateWarnOnce(p1) -- line: 1
    return function(p2, p3, p4) -- line: 2
        -- upvalues: p1 (copy)
        local v1 = false

        return function(...) -- line: 5
            -- upvalues: p2 (copy), p3 (copy), p4 (copy), v1 (ref), p1 (copy)
            if v1 then
                return p1(...)
            end

            local v2 = p4 and (" and will be removed in %*"):format(p4) or ""

            v1 = true
            warn((("%* is deprecated%*. Please use %* instead."):format(p2, v2, p3)))

            return p1(...)
        end
    end
end

return deprecateWarnOnce
