-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Navigate = require(UI.Util.Navigate)
local Pressable = require(UI.Components.Pressable)
local Platform = require(UI.Util.Platform)
local Children = Fusion.Children

return function(p1, p2) -- line: 34
    -- upvalues: Fusion (copy), Theme (copy), Navigate (copy), Pressable (copy), Platform (copy), Children (copy)
    local v1 = p2.id or p1:Value("Guest")
    local v2 = p2.name or p1:Value("Guest")
    local v3 = p2.color or Theme.Color.Primary
    local userId, onRemove = p2.userId, p2.onRemove
    local v4 = p2.large == true
    local v5 = if v4 then 11 else 8
    local v6 = if v4 then 10 else 8
    local v7 = if v4 then 6 else 4
    local textSize = p2.textSize

    if not textSize then
        textSize = if v4 then 17 else Theme.TextSize.Label
    end

    local pillHeight = p2.pillHeight

    if not pillHeight then
        pillHeight = if v4 then 29 else 22
    end

    return p1:New("Frame")({
        Name = "RoleBadge",
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = p2.backgroundColor or Theme.Color.Neutral,
        LayoutOrder = p2.layoutOrder or 0,
        Size = UDim2.fromOffset(0, pillHeight),
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(1, 0)
            }),
            p1:New("UIPadding")({
                PaddingLeft = UDim.new(0, v5),
                PaddingRight = UDim.new(0, v5)
            }),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, v7)
            }),
            p1:New("ImageLabel")({
                Name = "PermIcon",
                LayoutOrder = 0,
                BackgroundTransparency = 1,
                Image = "rbxassetid://132613467203568",
                ImageColor3 = Theme.Color.BaseContent,
                Size = UDim2.fromOffset(v6 + 4, v6 + 4),
                Visible = p2.isPermanent ~= nil and p2.isPermanent
            }),
            p1:New("ImageLabel")({
                Name = "GiverIcon",
                LayoutOrder = 0,
                BackgroundTransparency = 1,
                Image = "rbxassetid://88899389634128",
                ImageColor3 = Theme.Color.BaseContent,
                Size = UDim2.fromOffset(v6 + 4, v6 + 4),
                Visible = p2.isGiver ~= nil and p2.isGiver
            }),
            p1:New("Frame")({
                Name = "Dot",
                LayoutOrder = 1,
                Size = UDim2.fromOffset(v6, v6),
                BackgroundColor3 = v3,
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            }),
            p1:New("TextLabel")({
                Name = "Name",
                LayoutOrder = 2,
                BackgroundTransparency = 1,
                TextWrapped = false,
                AutomaticSize = Enum.AutomaticSize.XY,
                FontFace = p1:Computed(function(p3) -- line: 104
                    -- upvalues: Theme (copy)
                    return Font.new(p3(Theme.Font.Body), p3(Theme.FontWeight.Body))
                end),
                Text = v2,
                TextColor3 = Theme.Color.BaseContent,
                TextSize = textSize
            }),
            p1:Computed(function(p4, p5) -- line: 113
                -- upvalues: userId (copy), onRemove (copy), v4 (copy), v1 (copy), Fusion (copy), Theme (copy), Navigate (copy), Pressable (copy), Platform (copy), Children (copy)
                local v15 = userId and p4(userId) or nil

                if v15 == nil then
                    return nil
                end

                local function fireRemove() -- line: 116
                    -- upvalues: v15 (copy), onRemove (copy), v1 (copy), Fusion (copy)
                    if onRemove then
                        local v16 = if typeof(onRemove) == "table" then Fusion.peek(onRemove) else onRemove

                        if v16 then
                            v16(Fusion.peek(v1), v15)
                        end
                    end
                end

                local v17 = if v4 then 22 else 18
                local v18 = if v4 then 12 else 10
                local v19 = p5:Value(false)
                local v20 = p5:Value(false)
                local v21 = p5:Computed(function(p6) -- line: 127
                    -- upvalues: v19 (copy), v20 (copy)
                    if p6(v20) then
                        return 0.65
                    end

                    if p6(v19) then
                        return 0.82
                    end

                    return 1
                end)

                if not Platform.isMobile then
                    v21 = p5:Spring(v21, 70, 1)
                end

                local v22 = Pressable(p5, {
                    name = "Remove",
                    layoutOrder = 3,
                    size = UDim2.fromOffset(v17, v17),
                    backgroundColor = nil,
                    iconImage = "rbxassetid://80218226919142",
                    iconColor = Theme.Color.NeutralContentDark,
                    iconSize = v18,
                    onActivate = fireRemove,
                    onHoverChanged = function(p7) -- onHoverChanged | line: 144
                        -- upvalues: v19 (copy)
                        v19:set(p7)
                    end,
                    onPressChanged = function(p8) -- onPressChanged | line: 145
                        -- upvalues: v20 (copy)
                        v20:set(p8)
                    end,
                    [Children] = {
                        p5:New("Frame")({
                            Name = "Halo",
                            BackgroundColor3 = Theme.Color.NeutralContent,
                            BackgroundTransparency = v21,
                            BorderSizePixel = 0,
                            Size = UDim2.fromScale(1, 1),
                            ZIndex = 0,
                            [Children] = {
                                p5:New("UICorner")({
                                    CornerRadius = UDim.new(1, 0)
                                })
                            }
                        })
                    }
                })

                return Navigate.makeActivatable(v22, fireRemove)
            end)
        }
    })
end
