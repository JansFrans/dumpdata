-- https://lua.expert

local function delete(p1, ...) -- line: 20
    local t1 = {}

    for v1, _ in pairs(p1) do
        t1[v1] = true
    end

    for _, v2 in ipairs({ ... }) do
        t1[v2] = nil
    end

    return t1
end

return delete
