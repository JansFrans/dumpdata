-- https://lua.expert

local GetPerceivedBrightness = require(script.Parent.Util.Assert).prepTypeOf("GetPerceivedBrightness")

return function(p1) -- line: 12
    -- upvalues: GetPerceivedBrightness (copy)
    GetPerceivedBrightness("color", "Color3", p1)

    local v1 = p1.R * 255
    local v2 = p1.G * 255
    local v3 = p1.B * 255

    return (v1 * 299 + v2 * 587 + v3 * 114) / 1000 / 255
end
