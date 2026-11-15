-- https://lua.expert

local Parent = script.Parent
local OnyxNight = require(script.OnyxNight)
local NewTheme = require(script.NewTheme)

require(script.ThemeSpec)

local Contextual = require(Parent.Parent.Fusion).Contextual

return {
    NewTheme = function(p1, p2) -- NewTheme | line: 41
        -- upvalues: NewTheme (copy)
        return NewTheme(p1, p2)
    end,
    Theme = Contextual(OnyxNight)
}
