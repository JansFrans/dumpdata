-- https://lua.expert

local isLight = require(script.Parent.Util.Assert).prepTypeOf("isLight")
local isDark = require(script.Parent.isDark)

return function(p1) -- line: 13
    -- upvalues: isLight (copy), isDark (copy)
    isLight("color", "Color3", p1)

    return not isDark(p1)
end
