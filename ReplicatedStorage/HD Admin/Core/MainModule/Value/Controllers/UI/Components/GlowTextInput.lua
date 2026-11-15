-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children, OnChange, OnEvent = Fusion.Children, Fusion.OnChange, Fusion.OnEvent
local registerSound = require(Modules.AssetUtil.registerSound)
local Navigate = require(UI.Util.Navigate)
local SharedFocus

local function ensureFocusSound() -- line: 17
    -- upvalues: Fusion (copy), Theme (copy), registerSound (copy), SharedFocus (ref)
    if SharedFocus then
        return
    end

    local SoundService = game:GetService("SoundService")
    local PressableSounds = SoundService:FindFirstChild("PressableSounds")

    if not PressableSounds then
        PressableSounds = Instance.new("Folder")
        PressableSounds.Name = "PressableSounds"
        PressableSounds.Parent = SoundService
    end

    local SharedFocus2 = PressableSounds:FindFirstChild("SharedFocus")

    if not SharedFocus2 then
        SharedFocus2 = Instance.new("Sound")
        SharedFocus2.Name = "SharedFocus"
        SharedFocus2.SoundId = Fusion.peek(Theme.Sound.Focus)
        SharedFocus2.Volume = 0.2
        SharedFocus2.RollOffMaxDistance = 0
        SharedFocus2.Parent = PressableSounds
        registerSound(SharedFocus2, "Interface")
    end

    SharedFocus = SharedFocus2
end

return function(p1, p2) -- line: 58
    -- upvalues: Theme (copy), Children (copy), OnChange (copy), OnEvent (copy), Navigate (copy), SharedFocus (ref), ensureFocusSound (copy)
    local v1 = p1:Value(false)

    local function clearText() -- line: 61
        -- upvalues: p2 (copy)
        if p2.text then
            p2.text:set("")
        end
    end

    local v2 = p1:Spring(p1:Computed(function(p3) -- line: 68
        -- upvalues: v1 (copy), Theme (copy)
        if p3(v1) then
            return (p3(Theme.Color.Primary))
        end

        return (p3(Theme.Color.NeutralStroke))
    end), 40, 1)

    p1:Spring(p1:Computed(function(p4) -- line: 75
        -- upvalues: v1 (copy)
        if p4(v1) then
            return 0.92
        end

        return 1
    end), 40, 1)
    ensureFocusSound()

    return p1:New("Frame")({
        Name = p2.name or "GlowTextInput",
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Theme.Color.Neutral,
        BackgroundTransparency = 0,
        LayoutOrder = p2.layoutOrder,
        Size = UDim2.new(0, 0, 0, 36),
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p1:New("UIPadding")({
                PaddingTop = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8)
            }),
            p1:New("UIStroke")({
                Thickness = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = v2
            }),
            if p2.flexMode == nil then nil else p1:New("UIFlexItem")({
                FlexMode = p2.flexMode
            }),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.None,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6)
            }),
            p1:New("ImageLabel")({
                Name = "SearchIcon",
                BackgroundTransparency = 1,
                Image = "rbxassetid://101445923461783",
                LayoutOrder = 0,
                ImageColor3 = Theme.Color.NeutralContentDark,
                Size = UDim2.fromOffset(16, 16)
            }),
            p1:New("TextBox")({
                Name = "Input",
                AutoLocalize = false,
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ClearTextOnFocus = p2.clearTextOnFocus or false,
                ClipsDescendants = true,
                FontFace = p1:Computed(function(p5) -- line: 131
                    -- upvalues: Theme (copy)
                    return Font.new(p5(Theme.Font.Body), p5(Theme.FontWeight.Regular))
                end),
                PlaceholderColor3 = Theme.Color.NeutralContentDark,
                PlaceholderText = p2.placeholderText or "",
                Text = p2.text or "",
                TextColor3 = Theme.Color.BaseContent,
                TextSize = p2.textSize or Theme.TextSize.Subtitle,
                TextTransparency = 0,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                LayoutOrder = 1,
                [OnChange("Text")] = function(p6) -- line: 144
                    -- upvalues: p2 (copy)
                    if p2.text then
                        p2.text:set(p6)
                    end
                end,
                [OnEvent("Focused")] = function() -- line: 149
                    -- upvalues: p2 (copy), v1 (copy), SharedFocus (ref)
                    v1:set(true)

                    if SharedFocus then
                        SharedFocus.TimePosition = 0
                        SharedFocus:Play()
                    end

                    if p2.onFocus then
                        p2.onFocus()
                    end
                end,
                [OnEvent("FocusLost")] = function() -- line: 157
                    -- upvalues: p2 (copy), v1 (copy)
                    v1:set(false)

                    if p2.onFocusLost then
                        p2.onFocusLost()
                    end
                end,
                [Children] = {
                    p1:New("UIFlexItem")({
                        FlexMode = Enum.UIFlexMode.Fill
                    })
                }
            }),
            Navigate.makeActivatable(p1:New("ImageButton")({
                Name = "ClearButton",
                BackgroundTransparency = 1,
                Image = "rbxassetid://80218226919142",
                ImageColor3 = Theme.Color.NeutralContentDark,
                Size = UDim2.fromOffset(16, 16),
                LayoutOrder = 2,
                Visible = p1:Computed(function(p7) -- line: 175
                    -- upvalues: p1 (copy), p2 (copy)
                    return #p7(p2.text or p1:Value("")) > 0
                end),
                [OnEvent("Activated")] = clearText
            }), clearText)
        }
    })
end
