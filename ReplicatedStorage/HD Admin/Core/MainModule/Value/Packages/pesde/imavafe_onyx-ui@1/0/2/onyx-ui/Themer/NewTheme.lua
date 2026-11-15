-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)

require(script.Parent.ThemeSpec)

local ColorUtils = require(ParentParent.Parent.ColorUtils)
local Util = require(ParentParent.Util)

local function ReconcileValues(p1, p2) -- line: 9
    -- upvalues: Fusion (copy), ReconcileValues (copy)
    for v1, v2 in pairs(p1) do
        if typeof(v2) == "table" and v2.set then
            if typeof(p2[v1]) == "table" and p2[v1].get then
                v2:set(Fusion.peek(p2[v1]))
            elseif p2[v1] ~= nil then
                v2:set(p2[v1])
            end
        elseif typeof(v2) == "table" and typeof(p2[v1]) == "table" then
            ReconcileValues(v2, p2[v1])
        end
    end
end

local function ProcessColors(p3) -- line: 25
    -- upvalues: Fusion (copy), ColorUtils (copy), Util (copy)
    for _, v5 in pairs(p3.Colors) do
        local v6 = Fusion.peek(v5.Main)

        if v6 ~= nil then
            if Fusion.peek(v5.Contrast) == nil then
                v5.Contrast:set(Util.Emphasize(v6, Fusion.peek(p3.Emphasis.Contrast)))
            end

            if Fusion.peek(v5.Dark) == nil then
                v5.Dark:set(ColorUtils.Darken(v6, Fusion.peek(p3.Emphasis.Strong)))
            end

            if Fusion.peek(v5.Light) == nil then
                v5.Light:set(ColorUtils.Lighten(v6, Fusion.peek(p3.Emphasis.Strong)))
            end
        end
    end
end

local function ProcessEmphasis(p4) -- line: 44
    -- upvalues: Fusion (copy)
    local v7 = Fusion.peek(p4.Regular)

    p4.Light:set(v7 * 2 / 3)
    p4.Strong:set(v7 * 2)
end

local function ProcessMultipliers(p5) -- line: 51
    -- upvalues: Fusion (copy)
    local v8 = Fusion.peek(p5.Base)

    for v9, v10 in pairs(p5) do
        if Fusion.peek(v10) == nil then
            local v11 = tonumber(v9)

            if v11 ~= nil then
                v10:set(v8 * v11)
            end
        end
    end

    if p5.Full ~= nil then
        p5.Full:set(v8 * 10000)
    end
end

local function NewTheme(p6, p7) -- line: 70
    -- upvalues: Fusion (copy), Util (copy), ReconcileValues (copy), ProcessColors (copy), ProcessMultipliers (copy)
    local v12 = Fusion.innerScope(p6, Fusion)
    local t1 = {
        Colors = {
            Primary = {
                Main = v12:Value(Util.Colors.Black),
                Dark = v12:Value(nil),
                Light = v12:Value(nil),
                Contrast = v12:Value(nil)
            },
            Secondary = {
                Main = v12:Value(Util.Colors.Black),
                Dark = v12:Value(nil),
                Light = v12:Value(nil),
                Contrast = v12:Value(nil)
            },
            Accent = {
                Main = v12:Value(Util.Colors.Black),
                Dark = v12:Value(nil),
                Light = v12:Value(nil),
                Contrast = v12:Value(nil)
            },
            Neutral = {
                Main = v12:Value(Util.Colors.Gray["300"]),
                Dark = v12:Value(nil),
                Light = v12:Value(nil),
                Contrast = v12:Value(nil)
            },
            NeutralContent = {
                Main = v12:Value(Util.Colors.Gray["800"]),
                Dark = v12:Value(nil),
                Light = v12:Value(nil),
                Contrast = v12:Value(nil)
            },
            Base = {
                Main = v12:Value(Util.Colors.White),
                Dark = v12:Value(nil),
                Light = v12:Value(nil),
                Contrast = v12:Value(nil)
            },
            BaseContent = {
                Main = v12:Value(Util.Colors.Black),
                Dark = v12:Value(nil),
                Light = v12:Value(nil),
                Contrast = v12:Value(nil)
            },
            Success = {
                Main = v12:Value(Util.Colors.Green["400"]),
                Dark = v12:Value(nil),
                Light = v12:Value(nil),
                Contrast = v12:Value(nil)
            },
            Error = {
                Main = v12:Value(Util.Colors.Red["400"]),
                Dark = v12:Value(nil),
                Light = v12:Value(nil),
                Contrast = v12:Value(nil)
            },
            Warning = {
                Main = v12:Value(Util.Colors.Orange["400"]),
                Dark = v12:Value(nil),
                Light = v12:Value(nil),
                Contrast = v12:Value(nil)
            },
            Info = {
                Main = v12:Value(Util.Colors.Blue["400"]),
                Dark = v12:Value(nil),
                Light = v12:Value(nil),
                Contrast = v12:Value(nil)
            }
        },
        Font = {
            Body = v12:Value("GothamSsm"),
            Heading = v12:Value("GothamSsm"),
            Monospace = v12:Value("GothamSsm")
        },
        FontWeight = {
            Body = v12:Value(Enum.FontWeight.Regular),
            Bold = v12:Value(Enum.FontWeight.Bold),
            Heading = v12:Value(Enum.FontWeight.Bold)
        },
        TextSize = {
            Base = v12:Value(16),
            ["0.75"] = v12:Value(nil),
            ["0.875"] = v12:Value(nil),
            ["1"] = v12:Value(nil),
            ["1.125"] = v12:Value(nil),
            ["1.25"] = v12:Value(nil),
            ["1.5"] = v12:Value(nil),
            ["1.875"] = v12:Value(nil),
            ["2.25"] = v12:Value(nil),
            ["3"] = v12:Value(nil),
            ["3.75"] = v12:Value(nil),
            ["4.5"] = v12:Value(nil)
        },
        Padding = {
            Base = v12:Value(16),
            ["0"] = v12:Value(0),
            ["0.25"] = v12:Value(nil),
            ["0.5"] = v12:Value(nil),
            ["0.75"] = v12:Value(nil),
            ["1"] = v12:Value(nil),
            ["1.5"] = v12:Value(nil),
            ["2"] = v12:Value(nil),
            ["3"] = v12:Value(nil),
            ["4"] = v12:Value(nil),
            ["6"] = v12:Value(nil),
            ["8"] = v12:Value(nil),
            ["12"] = v12:Value(nil),
            ["16"] = v12:Value(nil),
            ["20"] = v12:Value(nil),
            ["24"] = v12:Value(nil),
            ["28"] = v12:Value(nil),
            ["32"] = v12:Value(nil),
            ["36"] = v12:Value(nil),
            ["40"] = v12:Value(nil),
            ["44"] = v12:Value(nil),
            ["48"] = v12:Value(nil)
        },
        Spacing = {
            Base = v12:Value(22),
            ["0"] = v12:Value(0),
            ["0.25"] = v12:Value(nil),
            ["0.5"] = v12:Value(nil),
            ["0.75"] = v12:Value(nil),
            ["1"] = v12:Value(nil),
            ["1.5"] = v12:Value(nil),
            ["2"] = v12:Value(nil),
            ["3"] = v12:Value(nil),
            ["4"] = v12:Value(nil),
            ["6"] = v12:Value(nil),
            ["8"] = v12:Value(nil),
            ["12"] = v12:Value(nil),
            ["16"] = v12:Value(nil),
            ["20"] = v12:Value(nil),
            ["24"] = v12:Value(nil),
            ["28"] = v12:Value(nil),
            ["32"] = v12:Value(nil),
            ["36"] = v12:Value(nil),
            ["40"] = v12:Value(nil),
            ["44"] = v12:Value(nil),
            ["48"] = v12:Value(nil)
        },
        Sizing = {
            Base = v12:Value(22),
            ["0"] = v12:Value(0),
            ["0.25"] = v12:Value(nil),
            ["0.5"] = v12:Value(nil),
            ["0.75"] = v12:Value(nil),
            ["1"] = v12:Value(nil),
            ["1.5"] = v12:Value(nil),
            ["2"] = v12:Value(nil),
            ["3"] = v12:Value(nil),
            ["4"] = v12:Value(nil),
            ["6"] = v12:Value(nil),
            ["8"] = v12:Value(nil),
            ["12"] = v12:Value(nil),
            ["16"] = v12:Value(nil),
            ["20"] = v12:Value(nil),
            ["24"] = v12:Value(nil),
            ["28"] = v12:Value(nil),
            ["32"] = v12:Value(nil),
            ["36"] = v12:Value(nil),
            ["40"] = v12:Value(nil),
            ["44"] = v12:Value(nil),
            ["48"] = v12:Value(nil)
        },
        CornerRadius = {
            Base = v12:Value(4),
            ["0"] = v12:Value(0),
            ["0.5"] = v12:Value(nil),
            ["1"] = v12:Value(nil),
            ["1.5"] = v12:Value(nil),
            ["2"] = v12:Value(nil),
            ["3"] = v12:Value(nil),
            ["4"] = v12:Value(nil),
            ["6"] = v12:Value(nil),
            Full = v12:Value(nil)
        },
        StrokeThickness = {
            Base = v12:Value(2),
            ["0"] = v12:Value(0),
            ["1"] = v12:Value(nil),
            ["2"] = v12:Value(nil),
            ["3"] = v12:Value(nil),
            ["4"] = v12:Value(nil),
            ["8"] = v12:Value(nil)
        },
        StrokeEmphasis = {
            Regular = v12:Value(0.1),
            Light = v12:Value(nil),
            Strong = v12:Value(nil),
            Contrast = v12:Value(1)
        },
        SpringSpeed = {
            Base = v12:Value(40),
            ["0.1"] = v12:Value(nil),
            ["0.175"] = v12:Value(nil),
            ["0.25"] = v12:Value(nil),
            ["0.375"] = v12:Value(nil),
            ["0.5"] = v12:Value(nil),
            ["0.75"] = v12:Value(nil),
            ["1"] = v12:Value(nil),
            ["1.5"] = v12:Value(nil),
            ["2"] = v12:Value(nil),
            Immediate = v12:Value(1000)
        },
        SpringDampening = {
            Base = v12:Value(1),
            ["0.1"] = v12:Value(nil),
            ["0.175"] = v12:Value(nil),
            ["0.25"] = v12:Value(nil),
            ["0.375"] = v12:Value(nil),
            ["0.5"] = v12:Value(nil),
            ["0.75"] = v12:Value(nil),
            ["1"] = v12:Value(nil),
            ["1.5"] = v12:Value(nil),
            ["2"] = v12:Value(nil),
            ["5"] = v12:Value(nil),
            ["10"] = v12:Value(nil),
            Full = v12:Value(1000)
        },
        Sound = {
            Hover = v12:Value(v12:New("Sound")({
                SoundId = "rbxassetid://10066936758",
                Volume = 0.05
            })),
            Click = v12:Value(v12:New("Sound")({
                SoundId = "rbxassetid://16480549841",
                Volume = 0.5
            })),
            Focus = v12:Value(v12:New("Sound")({
                SoundId = "rbxassetid://16480549841",
                Volume = 0.5
            })),
            Switch = v12:Value(v12:New("Sound")({
                SoundId = "rbxassetid://9119713951",
                Volume = 0.5
            }))
        },
        Emphasis = {
            Regular = v12:Value(0.2),
            Light = v12:Value(nil),
            Strong = v12:Value(nil),
            Contrast = v12:Value(1)
        }
    }

    ReconcileValues(t1, p7)

    local Emphasis = t1.Emphasis
    local v13 = Fusion.peek(Emphasis.Regular)

    Emphasis.Light:set(v13 * 2 / 3)
    Emphasis.Strong:set(v13 * 2)

    local StrokeEmphasis = t1.StrokeEmphasis
    local v14 = Fusion.peek(StrokeEmphasis.Regular)

    StrokeEmphasis.Light:set(v14 * 2 / 3)
    StrokeEmphasis.Strong:set(v14 * 2)
    ProcessColors(t1)
    ProcessMultipliers(t1.Padding)
    ProcessMultipliers(t1.Spacing)
    ProcessMultipliers(t1.Sizing)
    ProcessMultipliers(t1.TextSize)
    ProcessMultipliers(t1.CornerRadius)
    ProcessMultipliers(t1.StrokeThickness)
    ProcessMultipliers(t1.SpringSpeed)
    ProcessMultipliers(t1.SpringDampening)

    return t1
end

return NewTheme
