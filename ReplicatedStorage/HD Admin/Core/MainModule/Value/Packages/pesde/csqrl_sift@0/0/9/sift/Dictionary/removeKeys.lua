-- https://lua.expert

local copy = require(script.Parent.copy)

local function removeKeys(p1, ...) -- line: 20
    -- upvalues: copy (copy)
    local v1 = copy(p1)

    for _, v2 in ipairs({ ... }) do
        v1[v2] = nil
    end

    return v1
end

return removeKeys
