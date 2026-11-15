-- https://lua.expert

local function fromEntries(p1) -- line: 17
    local t1 = {}

    for _, v1 in ipairs(p1) do
        t1[v1[1]] = v1[2]
    end

    return t1
end

return fromEntries
