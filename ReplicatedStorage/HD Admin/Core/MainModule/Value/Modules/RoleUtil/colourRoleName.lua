-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local escapeRichText = require(Modules.DataUtil.escapeRichText)

return function(p1) -- line: 6
    -- upvalues: escapeRichText (copy)
    local v1 = if typeof(p1.color) == "Color3" then p1.color else Color3.new(1, 1, 1)

    return (("<font color=\"#%*\"><b>%*</b></font>"):format(string.format("%02X%02X%02X", math.floor(v1.R * 255 + 0.5), math.floor(v1.G * 255 + 0.5), (math.floor(v1.B * 255 + 0.5))), (escapeRichText((tostring(p1.name))))))
end
