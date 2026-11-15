-- https://lua.expert

local copy = require(script.Parent.copy)

local function update(p1, p2, p3, p4) -- line: 30
    -- upvalues: copy (copy)
    local v1 = copy(p1)

    if v1[p2] then
        if p3 then
            v1[p2] = p3(v1[p2], p2)

            return v1
        end
    elseif typeof(p4) == "function" then
        v1[p2] = p4(p2)
    end

    return v1
end

return update
