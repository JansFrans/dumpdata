-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local InputRow = require(script.Parent.InputRow)
local Platform = require(UI.Util.Platform)
local UserInputService = game:GetService("UserInputService")
local registerSound = require(Modules.AssetUtil.registerSound)
local SharedHover, SharedClick
local t1 = nil
local Parent, ScrollingEnabled, onDragMove, onDragEnd
local v1 = false

local function ensureSliderSounds() -- line: 52
    -- upvalues: registerSound (copy), SharedHover (ref), SharedClick (ref)
    if SharedHover then
        return
    end

    local SoundService = game:GetService("SoundService")
    local PressableSounds = SoundService:FindFirstChild("PressableSounds")

    if not PressableSounds then
        PressableSounds = Instance.new("Folder")
        PressableSounds.Name = "PressableSounds"
        PressableSounds.Parent = SoundService
    end

    local SharedHover2 = PressableSounds:FindFirstChild("SharedHover")

    if not SharedHover2 then
        SharedHover2 = Instance.new("Sound")
        SharedHover2.Name = "SharedHover"
        SharedHover2.SoundId = "rbxassetid://10066936758"
        SharedHover2.Volume = 0.1
        SharedHover2.RollOffMaxDistance = 0
        SharedHover2.Parent = PressableSounds
    end

    SharedHover = SharedHover2
    registerSound(SharedHover, "Interface")

    local SharedClick2 = PressableSounds:FindFirstChild("SharedClick")

    if not SharedClick2 then
        SharedClick2 = Instance.new("Sound")
        SharedClick2.Name = "SharedClick"
        SharedClick2.SoundId = "rbxassetid://16480549841"
        SharedClick2.Volume = 0.2
        SharedClick2.RollOffMaxDistance = 0
        SharedClick2.Parent = PressableSounds
    end

    SharedClick = SharedClick2
    registerSound(SharedClick, "Interface")
end

local function lockAncestorScrolling(p1) -- line: 84
    -- upvalues: Platform (copy), Parent (ref), ScrollingEnabled (ref)
    if not Platform.isMobile or Parent then
        return
    end

    local Parent2 = p1.Parent

    while true do
        if Parent2 then
            if Parent2:IsA("ScrollingFrame") then
                break
            end

            Parent2 = Parent2.Parent
            continue
        end

        return
    end

    Parent = Parent2
    ScrollingEnabled = Parent2.ScrollingEnabled
    Parent2.ScrollingEnabled = false
end

local function unlockAncestorScrolling() -- line: 99
    -- upvalues: Parent (ref), ScrollingEnabled (ref)
    local Parent2 = Parent
    local ScrollingEnabled2 = ScrollingEnabled

    Parent = nil
    ScrollingEnabled = nil

    if Parent2 and Parent2.Parent then
        if ScrollingEnabled2 ~= nil then
            Parent2.ScrollingEnabled = ScrollingEnabled2
        else
            Parent2.ScrollingEnabled = true
        end
    end
end

local function ensureSharedListeners() -- line: 110
    -- upvalues: UserInputService (copy), onDragMove (ref), onDragEnd (ref), v1 (ref)
    if v1 then
        return
    end

    v1 = true
    UserInputService.InputChanged:Connect(function(p2) -- line: 113
        -- upvalues: onDragMove (ref)
        local onDragMove2 = onDragMove

        if onDragMove2 and (p2.UserInputType == Enum.UserInputType.MouseMovement or p2.UserInputType == Enum.UserInputType.Touch) then
            onDragMove2(p2)
        end
    end)
    UserInputService.InputEnded:Connect(function(p3) -- line: 120
        -- upvalues: onDragEnd (ref)
        local onDragEnd2 = onDragEnd

        if onDragEnd2 and (p3.UserInputType == Enum.UserInputType.MouseButton1 or p3.UserInputType == Enum.UserInputType.Touch) then
            onDragEnd2(p3)
        end
    end)
end

local function snapToStep(p4, p5) -- line: 129
    -- upvalues: Modules (copy)
    if p5 and p5 > 0 then
        return require(Modules.MathUtil.roundToNearest)(p4, p5)
    end

    return p4
end

local function fractionToValue(p6, p7, p8, p9) -- line: 138
    if p9 and p7 < p8 then
        return p7 + (p8 - p7 + 1) ^ p6 - 1
    end

    return p7 + p6 * (p8 - p7)
end

local function valueToFraction(p10, p11, p12, p13) -- line: 145
    if p12 == p11 then
        return 0
    end

    if not p13 then
        return (p10 - p11) / (p12 - p11)
    end

    return math.log((math.max(p10 - p11 + 1, 1))) / math.log(p12 - p11 + 1)
end

return function(p14, p15) -- line: 157
    -- upvalues: Modules (copy), Fusion (copy), Theme (copy), Children (copy), InputRow (copy), SharedHover (ref), SharedClick (ref), t1 (ref), Parent (ref), ScrollingEnabled (ref), onDragMove (ref), onDragEnd (ref), ensureSliderSounds (copy), lockAncestorScrolling (copy), ensureSharedListeners (copy)
    local v6 = p15.title or ""
    local v7 = p15.min or 0
    local v8 = p15.max or 100
    local step, logarithmic = p15.step, p15.logarithmic
    local v11 = math.clamp(tonumber(if p15.value then Fusion.peek(p15.value) else p15.default) or v7, v7, v8)
    local v12 = p14:Value(v11)
    local v13 = if v8 == v7 then 0 elseif logarithmic then math.log((math.max(v11 - v7 + 1, 1))) / math.log(v8 - v7 + 1) else (v11 - v7) / (v8 - v7)
    local v18 = p14:Value(v13)

    if p15.value ~= nil then
        p14:Observer(p15.value):onChange(function() -- line: 176
            -- upvalues: p15 (copy), v7 (copy), v8 (copy), logarithmic (copy), v12 (copy), v18 (copy), Fusion (copy)
            local v19 = tonumber(Fusion.peek(p15.value))

            if v19 ~= nil then
                local v20 = math.clamp(v19, v7, v8)

                if v20 ~= Fusion.peek(v12) then
                    v12:set(v20)

                    local v21 = if v8 == v7 then 0 elseif logarithmic then math.log((math.max(v20 - v7 + 1, 1))) / math.log(v8 - v7 + 1) else (v20 - v7) / (v8 - v7)

                    v18:set(v21)
                end
            end
        end)
    end

    local function setFromFraction(p16) -- line: 186
        -- upvalues: p15 (copy), v7 (copy), v8 (copy), step (copy), logarithmic (copy), v12 (copy), v18 (copy), Modules (copy), Fusion (copy)
        local v26 = math.clamp(p16, 0, 1)
        local v27 = if not (logarithmic and v7 < v8) then v7 + v26 * (v8 - v7) else v7 + (v8 - v7 + 1) ^ v26 - 1

        if step and step > 0 then
            v27 = require(Modules.MathUtil.roundToNearest)(v27, step)
        end

        local v28 = math.clamp(v27, v7, v8)
        local v29 = Fusion.peek(v12)

        v12:set(v28)

        local v30 = if v8 == v7 then 0 elseif logarithmic then math.log((math.max(v28 - v7 + 1, 1))) / math.log(v8 - v7 + 1) else (v28 - v7) / (v8 - v7)

        v18:set(v30)

        if p15.value and v28 ~= v29 then
            p15.value:set(v28)
        end
    end

    local t2 = {}
    local v35 = p14:Value(false)
    local v36 = p14:Value(false)
    local v37 = p14:Value(false)
    local v38, v39

    local function getFraction(p17) -- line: 205
        -- upvalues: v39 (ref)
        if v39 then
            return (math.clamp((p17.Position.X - v39.AbsolutePosition.X - 7) / (v39.AbsoluteSize.X - 14), 0, 1))
        end

        return 0
    end

    ensureSliderSounds()

    local function onDragMove2(p18) -- line: 213
        -- upvalues: setFromFraction (copy), v35 (copy), v36 (copy), v39 (ref), Fusion (copy)
        if not Fusion.peek(v35) then
            return
        end

        v36:set(true)
        setFromFraction(if v39 then math.clamp((p18.Position.X - v39.AbsolutePosition.X - 7) / (v39.AbsoluteSize.X - 14), 0, 1) else 0)
    end

    local function onDragEnd2(_) -- line: 220
        -- upvalues: t2 (copy), v35 (copy), v36 (copy), v37 (copy), v38 (ref), Fusion (copy), SharedClick (ref), t1 (ref), Parent (ref), ScrollingEnabled (ref), onDragMove (ref), onDragEnd (ref)
        if t1 ~= t2 then
            return
        end

        if Fusion.peek(v35) == true and SharedClick then
            SharedClick.TimePosition = 0
            SharedClick:Play()
        end

        if v38 then
            task.cancel(v38)
            v38 = nil
        end

        t1 = nil
        onDragMove = nil
        onDragEnd = nil

        local Parent2 = Parent
        local ScrollingEnabled2 = ScrollingEnabled

        Parent = nil
        ScrollingEnabled = nil

        if Parent2 and Parent2.Parent then
            if ScrollingEnabled2 ~= nil then
                Parent2.ScrollingEnabled = ScrollingEnabled2
            else
                Parent2.ScrollingEnabled = true
            end
        end

        v35:set(false)
        v36:set(false)
        v37:set(false)
    end

    local v52 = p14:New("TextButton")({
        Name = "Track",
        LayoutOrder = 2,
        AutoButtonColor = false,
        BackgroundColor3 = Theme.Color.NeutralContent,
        Size = UDim2.new(1, 0, 0, 15),
        Text = "",
        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
        TextColor3 = Color3.new(),
        TextSize = 1,
        [Fusion.OnEvent("MouseEnter")] = function() -- line: 246
            -- upvalues: SharedHover (ref)
            if not SharedHover then
                return
            end

            SharedHover.TimePosition = 0
            SharedHover:Play()
        end,
        [Fusion.OnEvent("InputBegan")] = function(p20) -- line: 252
            -- upvalues: setFromFraction (copy), t2 (copy), v35 (copy), v37 (copy), v38 (ref), v39 (ref), onDragMove2 (copy), onDragEnd2 (copy), Fusion (copy), t1 (ref), onDragMove (ref), onDragEnd (ref), lockAncestorScrolling (copy)
            if p20.UserInputType ~= Enum.UserInputType.MouseButton1 and p20.UserInputType ~= Enum.UserInputType.Touch or t1 ~= nil and t1 ~= t2 then
                return
            end

            t1 = t2
            onDragMove = onDragMove2
            onDragEnd = onDragEnd2

            if v39 then
                lockAncestorScrolling(v39)
            end

            v35:set(true)
            setFromFraction(if v39 then math.clamp((p20.Position.X - v39.AbsolutePosition.X - 7) / (v39.AbsoluteSize.X - 14), 0, 1) else 0)
            v38 = task.delay(0.2, function() -- line: 262
                -- upvalues: v35 (copy), v37 (copy), Fusion (copy)
                if Fusion.peek(v35) then
                    v37:set(true)
                end
            end)
        end,
        [Children] = {
            p14:New("UICorner")({
                CornerRadius = UDim.new(1, 0)
            }),
            p14:New("UIStroke")({
                Transparency = 0.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralContent
            }),
            p14:New("Frame")({
                Name = "Fill",
                BackgroundColor3 = p15.fillColor or Theme.Color.Primary,
                Size = p14:Computed(function(p21) -- line: 279
                    -- upvalues: v18 (copy)
                    local v47 = p21(v18)

                    return UDim2.new(v47, math.round((1 - v47 * 2) * 7), 1, 0)
                end),
                [Children] = {
                    p14:New("UICorner")({
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            }),
            p14:New("Frame")({
                Name = "Thumb",
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Theme.Color.BaseContent,
                Position = p14:Computed(function(p22) -- line: 290
                    -- upvalues: v18 (copy)
                    local v50 = p22(v18)

                    return UDim2.new(v50, math.round((0.5 - v50) * 14), 0.5, 0)
                end),
                Size = UDim2.fromOffset(14, 14),
                ZIndex = 2,
                [Children] = {
                    p14:New("UICorner")({
                        CornerRadius = UDim.new(1, 0)
                    }),
                    p14:New("UIStroke")({
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = Theme.Color.Base,
                        Thickness = p15.thumbStrokeThickness or 1
                    })
                }
            })
        }
    })

    v39 = v52
    ensureSharedListeners()
    table.insert(p14, function() -- line: 313
        -- upvalues: t2 (copy), t1 (ref), Parent (ref), ScrollingEnabled (ref), onDragMove (ref), onDragEnd (ref)
        local Parent2, v54

        if t1 == t2 then
            t1 = nil
            onDragMove = nil
            onDragEnd = nil
            Parent2 = Parent

            local ScrollingEnabled2 = ScrollingEnabled

            Parent = nil
            ScrollingEnabled = nil

            if Parent2 and Parent2.Parent then
                v54 = ScrollingEnabled2 == nil or ScrollingEnabled2
                Parent2.ScrollingEnabled = v54
            end
        end
    end)

    local t8 = {
        p14:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            SortOrder = Enum.SortOrder.LayoutOrder
        }),
        v52,
        p14:New("Frame")({
            Name = "RangeLabels",
            LayoutOrder = 3,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            [Children] = {
                if p15.hideRangeLabels then nil else p14:New("TextLabel")({
                    Name = "Min",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.fromScale(0, 0.5),
                    Size = UDim2.fromOffset(60, 14),
                    FontFace = p14:Computed(function(p23) -- line: 344
                        -- upvalues: Theme (copy)
                        return Font.new(p23(Theme.Font.Body), p23(Theme.FontWeight.Regular))
                    end),
                    Text = tostring(v7),
                    TextColor3 = Theme.Color.NeutralContentDark,
                    TextSize = Theme.TextSize.Small,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                if p15.hideRangeLabels then nil else p14:New("TextLabel")({
                    Name = "Max",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.fromScale(1, 0.5),
                    Size = UDim2.fromOffset(60, 14),
                    FontFace = p14:Computed(function(p24) -- line: 358
                        -- upvalues: Theme (copy)
                        return Font.new(p24(Theme.Font.Body), p24(Theme.FontWeight.Regular))
                    end),
                    Text = tostring(v8),
                    TextColor3 = Theme.Color.NeutralContentDark,
                    TextSize = Theme.TextSize.Small,
                    TextXAlignment = Enum.TextXAlignment.Right
                }),
                p14:New("TextLabel")({
                    Name = "Value",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Theme.Color.Base,
                    BackgroundTransparency = 0,
                    FontFace = p14:Computed(function(p25) -- line: 372
                        -- upvalues: Theme (copy)
                        return Font.new(p25(Theme.Font.Body), p25(Theme.FontWeight.Bold))
                    end),
                    Position = p14:Computed(function(p26) -- line: 375
                        -- upvalues: v18 (copy)
                        local v58 = p26(v18)

                        return UDim2.new(v58, math.round((0.5 - v58) * 14), 0.5, 0)
                    end),
                    Size = UDim2.fromOffset(0, 14),
                    Text = p14:Computed(function(p27) -- line: 380
                        -- upvalues: v12 (copy)
                        return (tostring((p27(v12))))
                    end),
                    TextColor3 = Theme.Color.BaseContent,
                    TextSize = Theme.TextSize.Label,
                    Visible = p14:Computed(function(p28) -- line: 385
                        -- upvalues: v36 (copy), v37 (copy)
                        return p28(v36) or p28(v37)
                    end),
                    ZIndex = 2,
                    [Children] = {
                        p14:New("UIPadding")({
                            PaddingLeft = UDim.new(0, 4),
                            PaddingRight = UDim.new(0, 4)
                        })
                    }
                })
            }
        })
    }

    if p15.showValueInput then
        local v61 = p14:Value((tostring(Fusion.peek(v12))))
        local v62 = p14:Value(false)

        p14:Observer(v12):onChange(function() -- line: 404
            -- upvalues: v12 (copy), v61 (copy), v62 (copy), Fusion (copy)
            if not Fusion.peek(v62) then
                v61:set((tostring((Fusion.peek(v12)))))
            end
        end)

        local v76 = p14:New("TextBox")({
            Name = "ValueInput",
            BackgroundTransparency = 1,
            ClearTextOnFocus = false,
            FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json"),
            LayoutOrder = 2,
            Size = UDim2.new(0, 50, 1, 3),
            Text = v61,
            TextColor3 = Theme.Color.BaseContent,
            TextSize = Theme.TextSize.Label,
            TextXAlignment = Enum.TextXAlignment.Center,
            [Fusion.OnEvent("Focused")] = function() -- line: 421
                -- upvalues: v62 (copy)
                v62:set(true)
            end,
            [Fusion.OnEvent("FocusLost")] = function(_) -- line: 424
                -- upvalues: v7 (copy), v8 (copy), logarithmic (copy), v12 (copy), setFromFraction (copy), v61 (copy), v62 (copy), Fusion (copy)
                v62:set(false)

                local v66 = tonumber(tostring((Fusion.peek(v61))):match("^%-?%d+") or "")

                if v66 then
                    local v68 = math.clamp(math.round(v66), v7, v8)
                    local v69 = if v8 == v7 then 0 elseif logarithmic then math.log((math.max(v68 - v7 + 1, 1))) / math.log(v8 - v7 + 1) else (v68 - v7) / (v8 - v7)

                    setFromFraction(v69)
                end

                v61:set((tostring((Fusion.peek(v12)))))
            end,
            [Fusion.OnChange("Text")] = function(p30) -- line: 435
                -- upvalues: v61 (copy)
                v61:set(p30:match("^%-?%d*") or "")
            end,
            [Children] = {
                p14:New("UICorner")({
                    CornerRadius = UDim.new(1, 0)
                }),
                p14:New("UIStroke")({
                    Transparency = 0.6,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Theme.Color.NeutralContentDark
                })
            }
        })

        t8 = {
            p14:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6)
            }),
            p14:New("Frame")({
                Name = "SliderArea",
                LayoutOrder = 1,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                [Children] = {
                    p14:New("UIFlexItem")({
                        FlexMode = Enum.UIFlexMode.Fill
                    }),
                    table.unpack(t8)
                }
            }),
            v76
        }
    end

    return InputRow(p14, {
        title = v6,
        name = "NumberInput",
        framePaddingTop = p15.framePaddingTop or 11,
        framePaddingX = 0,
        framePaddingRight = p15.framePaddingRight,
        framePaddingBottom = 4,
        frameTransparency = 1,
        hideStroke = true,
        fixedHeight = p15.sliderHeight,
        labelSize = p15.labelSize,
        labelTextSize = p15.labelTextSize,
        labelIcon = p15.labelIcon,
        [Children] = t8
    })
end
