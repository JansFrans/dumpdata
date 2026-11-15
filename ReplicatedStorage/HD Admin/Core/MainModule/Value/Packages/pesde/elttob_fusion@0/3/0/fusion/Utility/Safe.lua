-- https://lua.expert

local _ = script.Parent.Parent

local function Safe(p1) -- line: 13
    local try, fallback = p1.try, p1.fallback
    local _, v1 = xpcall(try, fallback)

    return v1
end

return Safe
