-- https://lua.expert

require(script.Parent.Parent.Types)

local function toSet(p1) -- line: 20
    local t1 = {}

    for _, v1 in ipairs(p1) do
        t1[v1] = true
    end

    return t1
end

return toSet
