-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Pressable = require(UI.Components.Pressable)
local FavouriteButton = require(UI.Components.FavouriteButton)
local UnlockButton = require(UI.Components.UnlockButton)
local Children = Fusion.Children

return function(p1, p2) -- line: 29
    -- upvalues: Fusion (copy), Theme (copy), Pressable (copy), FavouriteButton (copy), UnlockButton (copy), Children (copy)
    local v1 = "rbxthumb://type=Asset&id=" .. tostring(p2.accessoryId) .. "&w=150&h=150"
    local v2 = p1:Value(false)
    local v3 = p1:Value(false)
    local v4 = p1:Value(false)
    local v5 = p1:Computed(function(p3) -- line: 34
        -- upvalues: v2 (copy), v3 (copy), Theme (copy), Pressable (copy)
        return Pressable.applyHighlight(p3, p3(Theme.Color.Neutral), v3, v2)
    end)

    return p1:New("Frame")({
        Name = "CosmeticCard",
        BackgroundColor3 = v5,
        LayoutOrder = p2.layoutOrder,
        Size = UDim2.new(0, 0, 0, 136),
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 9)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            Pressable(p1, {
                name = "Body",
                size = UDim2.new(1, 0, 0, 108),
                automaticSize = Enum.AutomaticSize.None,
                onActivate = function() -- onActivate | line: 55
                    -- upvalues: p2 (copy)
                    if p2.onBuy then
                        p2.onBuy()
                    end
                end,
                onHoverChanged = function(p4) -- onHoverChanged | line: 58
                    -- upvalues: v2 (copy)
                    v2:set(p4)
                end,
                onPressChanged = function(p5) -- onPressChanged | line: 59
                    -- upvalues: v3 (copy)
                    v3:set(p5)
                end,
                [Children] = {
                    p1:New("ImageLabel")({
                        Name = "Thumb",
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0),
                        Image = v1,
                        Position = UDim2.new(0.5, 0, 0, 8),
                        ScaleType = Enum.ScaleType.Fit,
                        Size = UDim2.fromOffset(70, 70)
                    }),
                    p1:New("TextLabel")({
                        Name = "Name",
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0),
                        FontFace = p1:Computed(function(p6) -- line: 74
                            -- upvalues: Theme (copy)
                            return Font.new(p6(Theme.Font.Body), p6(Theme.FontWeight.Body))
                        end),
                        Position = UDim2.new(0.5, 0, 0, 84),
                        Size = UDim2.new(1, -16, 0, 18),
                        Text = p2.name,
                        TextColor3 = Theme.Color.BaseContent,
                        TextSize = Theme.TextSize.Body,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        TextXAlignment = Enum.TextXAlignment.Center
                    }),
                    FavouriteButton(p1, {
                        buttonSize = 26,
                        iconSize = 16,
                        isFavourited = p2.isFavourited,
                        loading = v4,
                        onToggle = function() -- onToggle | line: 88
                            -- upvalues: p2 (copy), v4 (copy), Fusion (copy)
                            if not Fusion.peek(v4) then
                                v4:set(true)
                                task.spawn(function() -- line: 91
                                    -- upvalues: p2 (copy), v4 (copy)
                                    if p2.onFavourite then
                                        p2.onFavourite()
                                    end

                                    v4:set(false)
                                end)
                            end
                        end,
                        anchorPoint = Vector2.new(1, 0),
                        position = UDim2.new(1, -6, 0, 6)
                    })
                }
            }),
            p1:New("Frame")({
                Name = "UnlockHolder",
                AnchorPoint = Vector2.new(0.5, 1),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 1),
                Size = UDim2.new(1, 0, 0, 28),
                [Children] = {
                    UnlockButton(p1, {
                        flatTop = true,
                        style = "Neutral",
                        onUnlock = p2.onBuy,
                        robuxPrice = p2.robuxPrice
                    })
                }
            })
        }
    })
end
