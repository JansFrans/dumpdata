-- https://lua.expert

local Packages = script:FindFirstAncestor("MainModule").Value.Packages
local UI = script:FindFirstAncestor("MainModule").Value.Controllers.UI
local Fusion = require(Packages.Fusion)
local Children = Fusion.Children
local NumberSlider = require(UI.Components.NumberSlider)
local Icons = require(UI.Config.Icons)

local function hueToDegrees(p1) -- line: 20
    local v2 = math.round(p1 * 360)

    if v2 == 0 then
        return 360
    end

    return v2
end

return function(p2, p3) -- line: 27
    -- upvalues: Fusion (copy), Children (copy), NumberSlider (copy), Icons (copy)
    local v3 = p3.color or p2:Value(Color3.new(1, 1, 1))
    local v4, v5, v6 = Color3.toHSV(Fusion.peek(v3))
    local v8 = math.round(v4 * 360)

    if v8 == 0 then
        v8 = 360
    end

    local v9 = p2:Value(v8)
    local v11 = p2:Value((math.round(v5 * 100)))
    local v13 = p2:Value((math.round(v6 * 100)))
    local v14 = false

    table.insert(p2, function() -- line: 36
        -- upvalues: v14 (ref)
        v14 = false
    end)

    local function rebuildColor() -- line: 38
        -- upvalues: v3 (copy), v9 (copy), v11 (copy), v13 (copy), v14 (ref), Fusion (copy)
        if not v14 then
            v3:set(Color3.fromHSV(Fusion.peek(v9) / 360, Fusion.peek(v11) / 100, Fusion.peek(v13) / 100))
        end
    end

    p2:Observer(v9):onChange(function() -- line: 48
        -- upvalues: rebuildColor (copy)
        task.defer(rebuildColor)
    end)
    p2:Observer(v11):onChange(function() -- line: 49
        -- upvalues: rebuildColor (copy)
        task.defer(rebuildColor)
    end)
    p2:Observer(v13):onChange(function() -- line: 50
        -- upvalues: rebuildColor (copy)
        task.defer(rebuildColor)
    end)
    p2:Observer(v3):onChange(function() -- line: 52
        -- upvalues: v3 (copy), v9 (copy), v11 (copy), v13 (copy), v14 (ref), Fusion (copy)
        local v16 = Fusion.peek(v3)

        if typeof(v16) ~= "Color3" then
            return
        end

        local v17, v18, v19 = Color3.toHSV(v16)
        local v21 = math.round(v17 * 360)

        if v21 == 0 then
            v21 = 360
        end

        local v23 = math.round(v18 * 100)
        local v25 = math.round(v19 * 100)

        if v21 == Fusion.peek(v9) and v23 == Fusion.peek(v11) and v25 == Fusion.peek(v13) then
            return
        end

        v14 = true
        v9:set(v21)
        v11:set(v23)
        v13:set(v25)
        task.defer(function() -- line: 66
            -- upvalues: v14 (ref)
            v14 = false
        end)
    end)

    return p2:New("Frame")({
        Name = "ColorSlider",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        [Children] = {
            p2:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            NumberSlider(p2, {
                min = 1,
                max = 360,
                step = 1,
                hideRangeLabels = true,
                sliderHeight = 25,
                showValueInput = true,
                framePaddingTop = 5,
                framePaddingRight = 2,
                thumbStrokeThickness = 2,
                labelIcon = Icons.Color,
                labelSize = UDim2.new(0, 25, 0, 25),
                value = v9,
                fillColor = v3
            }),
            NumberSlider(p2, {
                min = 0,
                max = 100,
                step = 1,
                hideRangeLabels = true,
                sliderHeight = 25,
                showValueInput = true,
                framePaddingTop = 5,
                framePaddingRight = 2,
                thumbStrokeThickness = 2,
                labelIcon = Icons.LightBulbOutline,
                labelSize = UDim2.new(0, 25, 0, 25),
                value = v11,
                fillColor = v3
            }),
            NumberSlider(p2, {
                min = 0,
                max = 100,
                step = 1,
                hideRangeLabels = true,
                sliderHeight = 25,
                showValueInput = true,
                framePaddingTop = 5,
                framePaddingRight = 2,
                thumbStrokeThickness = 2,
                labelIcon = Icons.BrightnessHigh,
                labelSize = UDim2.new(0, 25, 0, 25),
                value = v13,
                fillColor = v3
            })
        }
    })
end
