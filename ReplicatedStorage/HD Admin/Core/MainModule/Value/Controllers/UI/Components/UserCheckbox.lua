-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Navigate = require(UI.Util.Navigate)
local Children = Fusion.Children
local UserDetails = require(script.Parent.UserDetails)

return function(p1, p2) -- line: 27
    -- upvalues: Fusion (copy), Theme (copy), Navigate (copy), Children (copy), UserDetails (copy)
    local v1 = p2.userId or p1:Value(1)
    local v2 = p1:Value(false)

    if p2.checked ~= nil then
        v2 = p1:Value(Fusion.peek(p2.checked))
    end

    local label, onCheck, onUserActivate = p2.label, p2.onCheck, p2.onUserActivate

    local function fireCheck() -- line: 37
        -- upvalues: v2 (ref), onCheck (copy), Fusion (copy)
        local v3 = not Fusion.peek(v2)

        v2:set(v3)

        if onCheck then
            local v4 = if typeof(onCheck) == "table" then Fusion.peek(onCheck) else onCheck

            if v4 then
                v4(v3)
            end
        end
    end

    local function fireUserActivate() -- line: 47
        -- upvalues: onUserActivate (copy), Fusion (copy)
        if onUserActivate then
            local v5 = if typeof(onUserActivate) == "table" then Fusion.peek(onUserActivate) else onUserActivate

            if v5 then
                v5()
            end
        end
    end

    local v6 = p1:Computed(function(p3) -- line: 55
        -- upvalues: v2 (ref), Theme (copy)
        if p3(v2) then
            return Theme.Color.Primary
        end

        return Theme.Color.NeutralContentDark
    end)

    return p1:New("Frame")({
        Name = "UserCheckbox",
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = Theme.Color.Neutral,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 9)
            }),
            p1:New("UIStroke")({
                Transparency = 0.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 0)
            }),
            Navigate.makeActivatable(p1:New("TextButton")({
                Name = "CheckZone",
                LayoutOrder = 1,
                AutoButtonColor = false,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                Text = "",
                TextColor3 = Color3.new(),
                TextSize = 1,
                [Fusion.OnEvent("Activated")] = fireCheck,
                [Children] = {
                    p1:New("UIPadding")({
                        PaddingTop = UDim.new(0, 12),
                        PaddingBottom = UDim.new(0, 12),
                        PaddingLeft = UDim.new(0, 12),
                        PaddingRight = UDim.new(0, 8)
                    }),
                    p1:New("Frame")({
                        Name = "Checkbox",
                        Size = UDim2.fromOffset(18, 18),
                        BackgroundColor3 = p1:Computed(function(p4) -- line: 100
                            -- upvalues: v2 (ref), Theme (copy)
                            if p4(v2) then
                                return (p4(Theme.Color.Primary))
                            end

                            return (p4(Theme.Color.Neutral))
                        end),
                        [Children] = {
                            p1:New("UICorner")({
                                CornerRadius = UDim.new(0, 4)
                            }),
                            p1:New("UIStroke")({
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Color = v6
                            }),
                            p1:New("ImageLabel")({
                                Name = "Check",
                                BackgroundTransparency = 1,
                                Image = "rbxassetid://13858820127",
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),
                                Size = UDim2.fromScale(0.75, 0.75),
                                ImageColor3 = Theme.Color.PrimaryContent,
                                Visible = v2
                            })
                        }
                    })
                }
            }), fireCheck),
            Navigate.makeActivatable(p1:New("TextButton")({
                Name = "UserZone",
                LayoutOrder = 2,
                AutoButtonColor = false,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                Text = "",
                TextColor3 = Color3.new(),
                TextSize = 1,
                [Fusion.OnEvent("Activated")] = fireUserActivate,
                [Children] = {
                    p1:New("UIPadding")({
                        PaddingTop = UDim.new(0, 8),
                        PaddingBottom = UDim.new(0, 8),
                        PaddingLeft = UDim.new(0, 4),
                        PaddingRight = UDim.new(0, 12)
                    }),
                    UserDetails(p1, {
                        userId = v1
                    })
                }
            }), fireUserActivate),
            p1:Computed(function(p5) -- line: 148
                -- upvalues: p1 (copy), label (copy), Theme (copy), Children (copy)
                local v12 = label and p5(label) or nil

                if not v12 or #v12 == 0 then
                    return nil
                end

                return p1:New("TextLabel")({
                    Name = "Label",
                    LayoutOrder = 3,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundTransparency = 1,
                    FontFace = p1:Computed(function(p6) -- line: 156
                        -- upvalues: Theme (copy)
                        return Font.new(p6(Theme.Font.Body), p6(Theme.FontWeight.Body))
                    end),
                    Text = v12,
                    TextColor3 = Theme.Color.NeutralContentDark,
                    TextSize = Theme.TextSize.Label,
                    TextWrapped = false,
                    [Children] = {
                        p1:New("UIPadding")({
                            PaddingRight = UDim.new(0, 12)
                        })
                    }
                })
            end)
        }
    })
end
