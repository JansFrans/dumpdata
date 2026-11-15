-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Viewport = require(UI.Config.Viewport)
local EmotePreview = require(UI.Config.EmotePreview)
local EmotePreviewBody = require(UI.Components.EmotePreviewBody)
local Pressable = require(UI.Components.Pressable)
local Icons = require(UI.Config.Icons)
local Children = Fusion.Children

return function(p1, _) -- line: 24
    -- upvalues: Lighting (copy), Fusion (copy), Theme (copy), Viewport (copy), EmotePreview (copy), EmotePreviewBody (copy), Pressable (copy), Icons (copy), Children (copy)
    local v1 = EmotePreview.getState()
    local v2 = p1:Computed(function(p3) -- line: 26
        -- upvalues: v1 (copy)
        return v1 ~= nil and p3(v1) ~= nil
    end)
    local v3 = p1:Computed(function(p4) -- line: 30
        -- upvalues: v2 (copy)
        if p4(v2) then
            return 0.2
        end

        return 1
    end)
    local v4 = p1:Spring(p1:Computed(function(p5) -- line: 34
        -- upvalues: v2 (copy)
        if p5(v2) then
            return 18
        end

        return 0
    end), 30, 1)

    p1:New("BlurEffect")({
        Name = "HDEmotePreviewBlur",
        Parent = Lighting,
        Size = v4,
        Enabled = p1:Computed(function(p6) -- line: 41
            -- upvalues: v4 (copy)
            return p6(v4) > 0.1
        end)
    })

    local Emotes = p1:Fuse("everyone", "Emotes")
    local v5 = p1:Computed(function(p7) -- line: 47
        -- upvalues: v1 (copy), Emotes (copy)
        local v6 = if v1 then p7(v1) else nil

        if not v6 then
            return "Emote"
        end

        if typeof(v6.emoteName) == "string" and v6.emoteName ~= "" then
            return v6.emoteName
        end

        local v7 = p7(Emotes)
        local v8 = if typeof(v7) == "table" then v7[tostring(v6.emoteId)] else nil

        if not (v8 and v8.name) then
            return "Emote"
        end

        return v8.name
    end)

    return p1:New("Frame")({
        Name = "EmotePreviewModal",
        Active = false,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = v2,
        ZIndex = 10,
        [Children] = {
            p1:New("TextButton")({
                Name = "Backdrop",
                Active = true,
                AutoButtonColor = false,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BackgroundTransparency = v3,
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                Size = UDim2.fromScale(1, 1),
                Text = "",
                TextColor3 = Color3.new(),
                TextSize = 1,
                [Fusion.OnEvent("Activated")] = function() -- line: 78
                    -- upvalues: EmotePreview (copy)
                    EmotePreview.close()
                end
            }),
            p1:New("Frame")({
                Name = "CardHolder",
                AnchorPoint = Vector2.new(0.5, 0.5),
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0.5),
                [Children] = {
                    p1:New("UIScale")({
                        Scale = Viewport.Scale
                    }),
                    p1:Computed(function(p8, p9) -- line: 93
                        -- upvalues: v1 (copy), v5 (copy), Theme (copy), EmotePreview (copy), EmotePreviewBody (copy), Pressable (copy), Icons (copy), Children (copy)
                        local v11 = if v1 then p8(v1) else nil

                        if v11 then
                            return p9:New("TextButton")({
                                Name = "Card",
                                AutoButtonColor = false,
                                AutomaticSize = Enum.AutomaticSize.Y,
                                BackgroundColor3 = Theme.Color.Base,
                                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                                Size = UDim2.fromOffset(320, 0),
                                Text = "",
                                TextColor3 = Color3.new(),
                                TextSize = 1,
                                [Children] = {
                                    p9:New("UICorner")({
                                        CornerRadius = UDim.new(0, 12)
                                    }),
                                    p9:New("UIStroke")({
                                        Transparency = 0.5,
                                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                        Color = Theme.Color.NeutralStroke
                                    }),
                                    p9:New("UIPadding")({
                                        PaddingBottom = UDim.new(0, 14),
                                        PaddingLeft = UDim.new(0, 14),
                                        PaddingRight = UDim.new(0, 14),
                                        PaddingTop = UDim.new(0, 12)
                                    }),
                                    p9:New("UIListLayout")({
                                        FillDirection = Enum.FillDirection.Vertical,
                                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                        Padding = UDim.new(0, 12),
                                        SortOrder = Enum.SortOrder.LayoutOrder
                                    }),
                                    p9:New("Frame")({
                                        Name = "TitleRow",
                                        BackgroundTransparency = 1,
                                        LayoutOrder = 1,
                                        Size = UDim2.new(1, 0, 0, 28),
                                        [Children] = {
                                            p9:New("TextLabel")({
                                                Name = "Title",
                                                BackgroundTransparency = 1,
                                                AnchorPoint = Vector2.new(0.5, 0.5),
                                                FontFace = p9:Computed(function(p10) -- line: 139
                                                    -- upvalues: Theme (copy)
                                                    return Font.new(p10(Theme.Font.Heading), p10(Theme.FontWeight.Bold))
                                                end),
                                                Position = UDim2.fromScale(0.5, 0.5),
                                                Size = UDim2.new(1, -64, 1, 0),
                                                Text = v5,
                                                TextColor3 = Theme.Color.BaseContent,
                                                TextSize = Theme.TextSize.Title,
                                                TextTruncate = Enum.TextTruncate.AtEnd,
                                                TextXAlignment = Enum.TextXAlignment.Center
                                            }),
                                            Pressable(p9, {
                                                name = "Close",
                                                iconSize = 16,
                                                size = UDim2.fromOffset(28, 28),
                                                automaticSize = Enum.AutomaticSize.None,
                                                anchorPoint = Vector2.new(1, 0.5),
                                                position = UDim2.fromScale(1, 0.5),
                                                iconImage = Icons.Close,
                                                iconColor = Theme.Color.NeutralContentMain,
                                                onActivate = function() -- onActivate | line: 159
                                                    -- upvalues: EmotePreview (copy)
                                                    EmotePreview.close()
                                                end
                                            })
                                        }
                                    }),
                                    EmotePreviewBody(p9, {
                                        layoutOrder = 2,
                                        emoteId = v11.emoteId,
                                        animationId = v11.animationId
                                    })
                                }
                            })
                        end

                        return nil
                    end)
                }
            })
        }
    })
end
