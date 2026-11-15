-- https://lua.expert

local GetContrastingColor = require(script.Parent.Parent.Util.Assert).prepTypeOf("GetContrastingColor")
local Darken = require(script.Parent.Parent.Darken)
local GetContrastRatio = require(script.Parent.GetContrastRatio)
local Lighten = require(script.Parent.Parent.Lighten)
local isDark = require(script.Parent.Parent.isDark)

return function(p1, p2, p3) -- line: 20
    -- upvalues: GetContrastingColor (copy), Darken (copy), GetContrastRatio (copy), Lighten (copy), isDark (copy)
    GetContrastingColor("foreground", "Color3", p1)
    GetContrastingColor("background", "Color3", p2)

    local v1 = if type(p3) == "number" then p3 else 4.5
    local v2 = GetContrastRatio(p1, p2)

    if v1 <= v2 then
        return p1
    end

    if isDark(p2) then
        return Lighten(p1, (v1 - v2) / v1)
    end

    return Darken(p1, (v1 - v2) / v1)
end
