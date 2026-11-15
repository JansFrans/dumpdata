-- https://lua.expert

local isDark = require(script.Parent.Util.Assert).prepTypeOf("isDark")
local GetLuminance = require(script.Parent.GetLuminance)

return function(p1) -- line: 13
    -- upvalues: isDark (copy), GetLuminance (copy)
    isDark("color", "Color3", p1)

    return GetLuminance(p1) < 0.5
end
