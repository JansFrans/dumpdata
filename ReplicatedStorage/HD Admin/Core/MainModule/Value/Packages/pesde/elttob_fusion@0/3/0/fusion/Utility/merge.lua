-- https://lua.expert

local External = require(script.Parent.Parent.External)

local function merge(p1, p2, ...) -- line: 13
    -- upvalues: External (copy)
    local t1 = { ... }

    if not (#t1 < 1) then
        for _, v1 in t1 do
            for v2, v3 in v1 do
                if p2[v2] ~= nil then
                    if not p1 then
                        External.logError("mergeConflict", nil, (tostring(v2)))
                    end
                else
                    p2[v2] = v3
                end
            end
        end
    end

    return p2
end

return merge
