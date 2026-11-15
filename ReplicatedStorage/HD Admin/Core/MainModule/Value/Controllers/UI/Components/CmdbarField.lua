-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local Pressable = require(UI.Components.Pressable)
local Icons = require(UI.Config.Icons)

return function(p1, p2) -- line: 39
    -- upvalues: UserInputService (copy), Fusion (copy), Theme (copy), Children (copy), Pressable (copy), Icons (copy)
    local v1 = false
    local v2 = ""
    local v5 = p1:New("TextBox")({
        Name = "Input",
        LayoutOrder = 2,
        AutoLocalize = false,
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        FontFace = p1:Computed(function(p3) -- line: 49
            -- upvalues: Theme (copy)
            return Font.new(p3(Theme.Font.Body), p3(Theme.FontWeight.Body))
        end),
        PlaceholderColor3 = Theme.Color.NeutralContentDark,
        PlaceholderText = p2.placeholder or "Run a command",
        Text = p2.text,
        TextColor3 = Theme.Color.BaseContent,
        TextSize = Theme.TextSize.Subtitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.fromScale(0, 1),
        [Fusion.OnEvent("Focused")] = function() -- line: 61
            -- upvalues: p2 (copy), v1 (ref)
            v1 = true
            p2.focused:set(true)
        end,
        [Fusion.OnEvent("FocusLost")] = function(p4) -- line: 65
            -- upvalues: p2 (copy), v1 (ref)
            v1 = false
            p2.focused:set(false)
            p2.cursorPosition:set(-1)

            if p4 then
                p2.onSubmit()
            end
        end,
        [Fusion.OnChange("Text")] = function(p5) -- line: 73
            -- upvalues: p2 (copy), v2 (ref), Fusion (copy)
            local v3 = p5:gsub("[\r\n\t]", "")

            if v3 ~= p5 then
                local v4 = Fusion.peek(p2.boxRef)

                if v4 then
                    v4.Text = v3
                end
            end

            if p2.wasDeletion then
                p2.wasDeletion:set(#v3 < #v2)
            end

            v2 = v3
            p2.text:set(v3)
        end,
        [Fusion.OnChange("CursorPosition")] = function(p6) -- line: 87
            -- upvalues: p2 (copy)
            p2.cursorPosition:set(p6)
        end,
        [Children] = {
            p1:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            })
        }
    })

    p2.boxRef:set(v5)
    table.insert(p1, (UserInputService.InputBegan:Connect(function(p7) -- line: 98
        -- upvalues: p2 (copy), v1 (ref), Fusion (copy)
        local v6 = p2.active ~= nil and Fusion.peek(p2.active) == true

        if v1 or v6 then
            local KeyCode = p7.KeyCode

            if KeyCode == Enum.KeyCode.Up then
                p2.onNavigate(-1)
            elseif KeyCode == Enum.KeyCode.Down then
                p2.onNavigate(1)
            elseif KeyCode == Enum.KeyCode.Tab then
                p2.onAccept()
            elseif KeyCode == Enum.KeyCode.Escape or v1 and (KeyCode == Enum.KeyCode.Quote or KeyCode == Enum.KeyCode.Semicolon) and #Fusion.peek(p2.text) <= 1 then
                p2.onClose()
            end
        end
    end)))

    return p1:New("Frame")({
        Name = "CmdbarField",
        BackgroundColor3 = Theme.Color.Neutral,
        LayoutOrder = p2.layoutOrder,
        Size = UDim2.new(1, 0, 0, 42),
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 10)
            }),
            p1:New("UIStroke")({
                Thickness = 1.5,
                Color = p1:Spring(p1:Computed(function(p8) -- line: 132
                    -- upvalues: p2 (copy), Theme (copy)
                    if p8(p2.active or p2.focused) then
                        return (p8(Theme.Color.Primary))
                    end

                    return (p8(Theme.Color.NeutralStroke))
                end), 40, 1)
            }),
            p1:New("UIPadding")({
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 8)
            }),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalFlex = Enum.UIFlexAlignment.None,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            }),
            p1:New("ImageLabel")({
                Name = "Glyph",
                LayoutOrder = 1,
                BackgroundTransparency = 1,
                Image = Icons.TerminalFill,
                ImageColor3 = p1:Computed(function(p9) -- line: 154
                    -- upvalues: p2 (copy), Theme (copy)
                    if p9(p2.active or p2.focused) then
                        return (p9(Theme.Color.Primary))
                    end

                    return (p9(Theme.Color.NeutralContentMain))
                end),
                Size = UDim2.fromOffset(20, 20)
            }),
            v5,
            Pressable(p1, {
                name = "Run",
                layoutOrder = 3,
                size = UDim2.fromOffset(30, 30),
                backgroundColor = Theme.Color.Neutral,
                iconImage = Icons.RunCommand,
                iconColor = Theme.Color.Primary,
                iconSize = 18,
                onActivate = p2.onRun or p2.onSubmit,
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = UDim.new(0, 8)
                    })
                }
            })
        }
    })
end
