-- https://lua.expert

local function removeValue(p1, p2) -- line: 18
    local t1 = {}

    for _, v1 in ipairs(p1) do
        if v1 ~= p2 then
            table.insert(t1, v1)
        end
    end

    return t1
end

return removeValue
