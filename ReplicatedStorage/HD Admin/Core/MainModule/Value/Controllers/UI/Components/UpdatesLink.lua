-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Icons = require(UI.Config.Icons)
local Pressable = require(script.Parent.Pressable)
local Prompt = require(Modules.Prompt)
local Children = Fusion.Children
local v1 = Color3.fromRGB(161, 161, 170)

local function selectForCopy(p1) -- line: 29
    -- upvalues: UserInputService (copy), Prompt (copy)
    p1:CaptureFocus()
    p1.SelectionStart = 1
    p1.CursorPosition = #p1.Text + 1

    local v2 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "Hold the link and tap Copy" or "Press Ctrl+C (Cmd+C on Mac) to copy"

    Prompt.info(v2)
end

return function(p2, p3) -- line: 40
    -- upvalues: UserInputService (copy), Theme (copy), Icons (copy), Pressable (copy), Prompt (copy), Children (copy), v1 (copy)
    local v3 = p3.url or "https://devforum.roblox.com/"
    local v4 = p2:Value(false)
    local v5 = p2:Computed(function(p4) -- line: 44
        -- upvalues: Theme (copy)
        local v6 = p4(Theme.Color.Base)

        return 0.299 * v6.R + 0.587 * v6.G + 0.114 * v6.B > 0.5
    end)
    local v7 = p2:New("TextBox")({
        Name = "TextInput",
        AutoLocalize = false,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        FontFace = p2:Computed(function(p5) -- line: 56
            -- upvalues: Theme (copy)
            return Font.new(p5(Theme.Font.Body), p5(Theme.FontWeight.Body))
        end),
        LayoutOrder = 1,
        Size = UDim2.new(0, 0, 0, 0),
        Text = v3,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextEditable = false,
        TextSize = Theme.TextSize.Subtitle,
        TextTransparency = p2:Computed(function(p6) -- line: 65
            -- upvalues: v5 (copy)
            if p6(v5) then
                return 0
            end

            return 0.25
        end),
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        [Children] = {
            p2:New("UIPadding")({
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 8)
            }),
            p2:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            })
        }
    })
    local v13 = p2:New("Frame")({
        Name = "Pill",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = p2:Computed(function(p7) -- line: 88
            -- upvalues: v5 (copy)
            if p7(v5) then
                return 0.4
            end

            return 0.75
        end),
        LayoutOrder = 2,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p2:New("UICorner")({
                CornerRadius = UDim.new(1, 0)
            }),
            p2:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = v1
            }),
            p2:New("UIPadding")({
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 3)
            }),
            p2:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            v7,
            Pressable(p2, {
                name = "CopyButton",
                layoutOrder = 2,
                size = UDim2.fromOffset(30, 30),
                backgroundColor = Color3.fromRGB(255, 255, 255),
                backgroundTransparency = p2:Computed(function(p8) -- line: 117
                    -- upvalues: v4 (copy)
                    if p8(v4) then
                        return 0.6
                    end

                    return 0.82
                end),
                iconImage = Icons.Copy,
                iconColor = Color3.fromRGB(255, 255, 255),
                iconSize = 16,
                onHoverChanged = function(p9) -- onHoverChanged | line: 123
                    -- upvalues: v4 (copy)
                    v4:set(p9)
                end,
                onActivate = function() -- onActivate | line: 126
                    -- upvalues: v7 (copy), UserInputService (copy), Prompt (copy)
                    v7:CaptureFocus()
                    v7.SelectionStart = 1
                    v7.CursorPosition = #v7.Text + 1

                    local v12 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "Hold the link and tap Copy" or "Press Ctrl+C (Cmd+C on Mac) to copy"

                    Prompt.info(v12)
                end,
                [Children] = {
                    p2:New("UICorner")({
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            })
        }
    })

    return p2:New("Frame")({
        Name = "UpdatesLink",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = p3.layoutOrder,
        Size = p3.size or UDim2.fromScale(1, 0),
        [Children] = {
            p2:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p2:Computed(function(_, p11) -- line: 150
                -- upvalues: p3 (copy), Theme (copy)
                if p3.label then
                    return p11:New("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                        AutomaticSize = Enum.AutomaticSize.XY,
                        FontFace = p11:Computed(function(p12) -- line: 156
                            -- upvalues: Theme (copy)
                            return Font.new(p12(Theme.Font.Body), p12(Theme.FontWeight.Regular))
                        end),
                        Text = p3.label,
                        TextColor3 = Color3.fromRGB(244, 244, 247),
                        TextSize = Theme.TextSize.Label
                    })
                end

                return nil
            end),
            v13
        }
    })
end
