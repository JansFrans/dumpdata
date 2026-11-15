-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Navigate = require(UI.Util.Navigate)
local Children = Fusion.Children
local RoleBadge = require(script.Parent.RoleBadge)

return function(p1, p2) -- line: 33
    -- upvalues: Fusion (copy), Theme (copy), Navigate (copy), Children (copy), RoleBadge (copy)
    local v1 = p2.roles or p1:Value({})
    local v2 = p2.truncated or p1:Value(false)
    local userId, onAddRole, onRemoveRole = p2.userId, p2.onAddRole, p2.onRemoveRole

    local function fireAddRole() -- line: 40
        -- upvalues: onAddRole (copy), Fusion (copy)
        local v3 = onAddRole

        if typeof(onAddRole) == "table" then
            v3 = Fusion.peek(onAddRole)
        end

        if v3 then
            v3()
        end
    end

    local v4 = p1:Computed(function(p3) -- line: 47
        -- upvalues: v1 (copy)
        return p3(v1)[1]
    end)
    local v5 = p1:Computed(function(p4) -- line: 52
        -- upvalues: v1 (copy)
        return (math.max(0, #p4(v1) - 1))
    end)

    return p1:New("ScrollingFrame")({
        Name = "RolesReel",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4)
            }),
            p1:Computed(function(p5) -- line: 75
                -- upvalues: p1 (copy), v4 (copy), v5 (copy), v2 (copy), Theme (copy), Children (copy), RoleBadge (copy)
                if p5(v2) then
                    local v9 = p5(v4)

                    if v9 then
                        return p1:New("Frame")({
                            Name = "TruncatedBadges",
                            AutomaticSize = Enum.AutomaticSize.XY,
                            BackgroundTransparency = 1,
                            [Children] = {
                                p1:New("UIListLayout")({
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    VerticalAlignment = Enum.VerticalAlignment.Center,
                                    SortOrder = Enum.SortOrder.LayoutOrder,
                                    Padding = UDim.new(0, 4)
                                }),
                                RoleBadge(p1, {
                                    id = p1:Value(v9.id),
                                    name = p1:Value(v9.name),
                                    color = p1:Value(v9.color)
                                }),
                                p1:Computed(function(p6) -- line: 96
                                    -- upvalues: p1 (copy), v5 (copy), Theme (copy), RoleBadge (copy)
                                    local v10 = p6(v5)

                                    if v10 <= 0 then
                                        return nil
                                    end

                                    return RoleBadge(p1, {
                                        id = p1:Value("overflow"),
                                        name = p1:Value((("+%*"):format(v10))),
                                        color = p1:Value(Theme.Color.NeutralContentDark)
                                    })
                                end)
                            }
                        })
                    end
                end

                return nil
            end),
            p1:Computed(function(p7) -- line: 109
                -- upvalues: p1 (copy), userId (copy), onRemoveRole (copy), v2 (copy), v1 (copy), RoleBadge (copy)
                if p7(v2) then
                    return nil
                end

                return p1:ForValues(v1, function(_, p9, p10) -- line: 112
                    -- upvalues: userId (copy), onRemoveRole (copy), RoleBadge (copy)
                    return RoleBadge(p9, {
                        id = p9:Value(p10.id),
                        name = p9:Value(p10.name),
                        color = p9:Value(p10.color),
                        userId = userId,
                        onRemove = onRemoveRole
                    })
                end)
            end),
            p1:Computed(function(p11) -- line: 123
                -- upvalues: p1 (copy), onAddRole (copy), fireAddRole (copy), v2 (copy), Fusion (copy), Theme (copy), Navigate (copy), Children (copy)
                if p11(v2) or not onAddRole then
                    return nil
                end

                return Navigate.makeActivatable(p1:New("TextButton")({
                    Name = "AddRole",
                    AutoButtonColor = false,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Theme.Color.Neutral,
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                    Text = "",
                    TextColor3 = Color3.new(),
                    TextSize = 1,
                    [Fusion.OnEvent("Activated")] = fireAddRole,
                    [Children] = {
                        p1:New("UICorner")({
                            CornerRadius = UDim.new(1, 0)
                        }),
                        p1:New("UIPadding")({
                            PaddingTop = UDim.new(0, 4),
                            PaddingBottom = UDim.new(0, 4),
                            PaddingLeft = UDim.new(0, 8),
                            PaddingRight = UDim.new(0, 8)
                        }),
                        p1:New("ImageLabel")({
                            BackgroundTransparency = 1,
                            Image = "rbxassetid://13845892460",
                            ImageColor3 = Theme.Color.NeutralContentMain,
                            Size = UDim2.fromOffset(14, 14)
                        })
                    }
                }), fireAddRole)
            end)
        }
    })
end
