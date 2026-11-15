-- https://lua.expert

local function includes(p1, p2) -- line: 19
    for _, v1 in pairs(p1) do
        if v1 == p2 then
            return true
        end
    end

    return false
end

return includes
