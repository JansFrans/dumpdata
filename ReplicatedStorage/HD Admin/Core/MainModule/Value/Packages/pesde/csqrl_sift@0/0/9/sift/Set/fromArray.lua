-- https://lua.expert

local function fromArray(p1) -- line: 20
    local v1 = table.create(#p1)

    for _, v2 in ipairs(p1) do
        v1[v2] = true
    end

    return v1
end

return fromArray
