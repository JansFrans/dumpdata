-- https://lua.expert

local function withKeys(p1, ...) -- line: 19
    local t1 = {}

    for _, v1 in ipairs({ ... }) do
        t1[v1] = p1[v1]
    end

    return t1
end

return withKeys
