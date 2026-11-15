-- https://lua.expert

local function isInternalRole(p1) -- line: 5
    if typeof(p1) == "table" then
        return p1.internal == true
    end

    return false
end

return isInternalRole
