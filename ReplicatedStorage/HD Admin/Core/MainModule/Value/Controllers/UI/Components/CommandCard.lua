-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Pressable = require(UI.Components.Pressable)
local Icons = require(UI.Config.Icons)
local FavouriteButton = require(UI.Components.FavouriteButton)
local Children = Fusion.Children

return function(p1, p2) -- line: 28
    -- upvalues: Fusion (copy), Theme (copy), Pressable (copy), Icons (copy), FavouriteButton (copy), Children (copy)
    local v1 = p1:Value(false)
    local v2 = p1:Value(false)
    local v3 = p1:Value(false)
    local v4 = p1:Computed(function(p3) -- line: 32
        -- upvalues: v1 (copy), v2 (copy), Theme (copy), Pressable (copy)
        return Pressable.applyHighlight(p3, p3(Theme.Color.Neutral), v2, v1)
    end)
    local v5 = if p2.icon then 64 else 38
    local t2 = {
        p1:New("ImageLabel")({
            Name = "Thumb",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Image = p2.icon or Icons.Pages.Commands,
            Position = UDim2.new(0.5, 0, 0, (64 - v5) / 2 + 8),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromOffset(v5, v5)
        }),
        p1:New("TextLabel")({
            Name = "Name",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            FontFace = p1:Computed(function(p4) -- line: 52
                -- upvalues: Theme (copy)
                return Font.new(p4(Theme.Font.Body), p4(Theme.FontWeight.Body))
            end),
            Position = UDim2.new(0.5, 0, 0, 80),
            Size = UDim2.new(1, -12, 0, 18),
            Text = p2.commandName,
            TextColor3 = Theme.Color.BaseContent,
            TextSize = Theme.TextSize.Body,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Center
        })
    }

    if p2.onFavourite then
        table.insert(t2, FavouriteButton(p1, {
            buttonSize = 26,
            iconSize = 16,
            isFavourited = p2.isFavourited or false,
            loading = v3,
            onToggle = function() -- onToggle | line: 68
                -- upvalues: p2 (copy), v3 (copy), Fusion (copy)
                if not Fusion.peek(v3) then
                    v3:set(true)
                    task.spawn(function() -- line: 71
                        -- upvalues: p2 (copy), v3 (copy)
                        if p2.onFavourite then
                            p2.onFavourite()
                        end

                        v3:set(false)
                    end)
                end
            end,
            anchorPoint = Vector2.new(1, 0),
            position = UDim2.new(1, -6, 0, 6)
        }))
    end

    return p1:New("Frame")({
        Name = "CommandCard",
        BackgroundColor3 = v4,
        LayoutOrder = p2.layoutOrder,
        Size = UDim2.new(0, 0, 0, 108),
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
                size = UDim2.fromScale(1, 1),
                automaticSize = Enum.AutomaticSize.None,
                onActivate = function() -- onActivate | line: 100
                    -- upvalues: p2 (copy)
                    if p2.onRun then
                        p2.onRun()
                    end
                end,
                onHoverChanged = function(p5) -- onHoverChanged | line: 103
                    -- upvalues: v1 (copy)
                    v1:set(p5)
                end,
                onPressChanged = function(p6) -- onPressChanged | line: 104
                    -- upvalues: v2 (copy)
                    v2:set(p6)
                end,
                [Children] = t2
            })
        }
    })
end
