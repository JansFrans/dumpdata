-- https://lua.expert

local DeprecateWarnOnce = require(script.Util.DeprecateWarnOnce)
local GetContrastRatioCompat = require(script.GetContrastRatioCompat)
local WCAG = require(script.WCAG)
local t1 = {
    Darken = require(script.Darken),
    Desaturate = require(script.Desaturate),
    Emphasize = require(script.Emphasize),
    GetLuminance = require(script.GetLuminance),
    GetPerceivedBrightness = require(script.GetPerceivedBrightness),
    Invert = require(script.Invert),
    isDark = require(script.isDark),
    isLight = require(script.isLight),
    Lighten = require(script.Lighten),
    Rotate = require(script.Rotate),
    Saturate = require(script.Saturate),
    APCA = require(script.APCA),
    Blend = require(script.Blend),
    Blind = require(script.Blind),
    Hex = require(script.Hex),
    HSL = require(script.HSL),
    Int = require(script.Int),
    LAB = require(script.LAB),
    LCH = require(script.LCH),
    Palette = require(script.Palette),
    WCAG = WCAG
}

t1.Emphasise = DeprecateWarnOnce(t1.Emphasize)("ColorUtils.Emphasise", "ColorUtils.Emphasize")
t1.GetContrastingColor = DeprecateWarnOnce(WCAG.GetContrastingColor)("ColorUtils.GetContrastingColor", "WCAG.GetContrastingColor")
t1.GetContrastingColour = DeprecateWarnOnce(t1.GetContrastingColor)("ColorUtils.GetContrastingColour", "WCAG.GetContrastingColor")
t1.GetContrastRatio = DeprecateWarnOnce(GetContrastRatioCompat)("ColorUtils.GetContrastRatio", "WCAG.GetContrastRatio")

return t1
