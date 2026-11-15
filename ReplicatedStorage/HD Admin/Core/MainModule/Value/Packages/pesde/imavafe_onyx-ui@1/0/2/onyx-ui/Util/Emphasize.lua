-- https://lua.expert

local ColorUtils = require(script.Parent.Parent.Parent.ColorUtils)

local function Emphasize(p1, p2) -- line: 17
    -- upvalues: ColorUtils (copy)
    return ColorUtils.Emphasize(p1, p2 * (1 + ColorUtils.GetPerceivedBrightness(p1)))
end

return Emphasize
