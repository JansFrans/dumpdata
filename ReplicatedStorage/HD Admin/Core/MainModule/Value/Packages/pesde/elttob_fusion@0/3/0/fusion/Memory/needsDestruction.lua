-- https://lua.expert

local function needsDestruction(p1) -- line: 11
    return typeof(p1) == "Instance"
end

return needsDestruction
