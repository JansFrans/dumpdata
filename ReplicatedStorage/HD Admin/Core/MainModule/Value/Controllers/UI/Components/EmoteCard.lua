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

return function(p1, p2) -- line: 30
    -- upvalues: Fusion (copy), Theme (copy), Pressable (copy), FavouriteButton (copy), UnlockButton (copy), Children (copy)
    local v1 = "rbxthumb://type=Asset&id=" .. tostring(p2.emoteId) .. "&w=150&h=150"
    local isActive = p2.isActive
    local v2 = p1:Value(false)
    local v3 = p1:Value(false)
    local v4 = p1:Value(false)
    local v5 = p1:Computed(function(p3) -- line: 36
        -- upvalues: isActive (copy), v2 (copy), v3 (copy), Theme (copy), Pressable (copy)
        local v6 = p3(Theme.Color.Neutral)

        if isActive and p3(isActive) then
            v6 = v6:Lerp(p3(Theme.Color.Primary), 0.35)
        end

        return Pressable.applyHighlight(p3, v6, v3, v2)
    end)
    local v7 = p1:Computed(function(p4) -- line: 43
        -- upvalues: isActive (copy), Theme (copy)
        if isActive and p4(isActive) then
            return p4(Theme.Color.Primary)
        end

        return p4(Theme.Color.NeutralStroke)
    end)

    return p1:New("Frame")({
        Name = "EmoteCard",
        BackgroundColor3 = v5,
        LayoutOrder = p2.layoutOrder,
        Size = UDim2.new(0, 0, 0, p2.onUnlock and 136 or 108),
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 9)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = v7
            }),
            Pressable(p1, {
                name = "Body",
                size = UDim2.new(1, 0, 0, 108),
                automaticSize = Enum.AutomaticSize.None,
                onActivate = function() -- onActivate | line: 67
                    -- upvalues: p2 (copy)
                    if p2.onRun then
                        p2.onRun()
                    end
                end,
                onHoverChanged = function(p5) -- onHoverChanged | line: 70
                    -- upvalues: v2 (copy)
                    v2:set(p5)
                end,
                onPressChanged = function(p6) -- onPressChanged | line: 71
                    -- upvalues: v3 (copy)
                    v3:set(p6)
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
                        FontFace = p1:Computed(function(p7) -- line: 86
                            -- upvalues: Theme (copy)
                            return Font.new(p7(Theme.Font.Body), p7(Theme.FontWeight.Body))
                        end),
                        Position = UDim2.new(0.5, 0, 0, 84),
                        Size = UDim2.new(1, -16, 0, 18),
                        Text = p2.emoteName,
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
                        onToggle = function() -- onToggle | line: 100
                            -- upvalues: p2 (copy), v4 (copy), Fusion (copy)
                            if not Fusion.peek(v4) then
                                v4:set(true)
                                task.spawn(function() -- line: 103
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
            if p2.onUnlock then p1:New("Frame")({
                Name = "UnlockHolder",
                AnchorPoint = Vector2.new(0.5, 1),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 1),
                Size = UDim2.new(1, 0, 0, 28),
                [Children] = {
                    UnlockButton(p1, {
                        flatTop = true,
                        onUnlock = p2.onUnlock
                    })
                }
            }) else nil
        }
    })
end
