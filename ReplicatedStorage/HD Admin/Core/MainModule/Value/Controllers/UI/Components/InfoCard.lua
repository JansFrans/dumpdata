-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Navigate = require(UI.Util.Navigate)
local Children = Fusion.Children

return function(p1, p2) -- line: 25
    -- upvalues: Fusion (copy), Theme (copy), Navigate (copy), Children (copy)
    local v1 = p2.title or p1:Value("Title")
    local titleIcon = p2.titleIcon
    local v2 = p2.body or p1:Value("")
    local v3 = p2.color or Theme.Color.Neutral
    local onActivate = p2.onActivate

    local function fireActivate() -- line: 32
        -- upvalues: onActivate (copy), Fusion (copy)
        if onActivate then
            local v4 = if typeof(onActivate) == "table" then Fusion.peek(onActivate) else onActivate

            if v4 then
                v4()
            end
        end
    end

    return Navigate.makeActivatable(p1:New("TextButton")({
        Name = "InfoCard",
        AutoButtonColor = false,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = v3,
        Size = UDim2.fromScale(1, 0),
        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
        Text = "",
        TextColor3 = Color3.new(),
        TextSize = 1,
        [Fusion.OnEvent("Activated")] = fireActivate,
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 9)
            }),
            p1:New("UIPadding")({
                PaddingTop = UDim.new(0, 16),
                PaddingBottom = UDim.new(0, 16),
                PaddingLeft = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 16)
            }),
            p1:New("UIStroke")({
                Transparency = 0.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralContent
            }),
            p1:New("UIListLayout")({
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            }),
            p1:New("Frame")({
                Name = "TitleRow",
                LayoutOrder = 1,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                [Children] = {
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 6)
                    }),
                    p1:Computed(function(p3) -- line: 83
                        -- upvalues: p1 (copy), titleIcon (copy), Theme (copy)
                        local v10 = titleIcon and p3(titleIcon) or nil

                        if not (v10 and #v10 > 0) then
                            return nil
                        end

                        return p1:New("ImageLabel")({
                            Name = "Icon",
                            LayoutOrder = 1,
                            BackgroundTransparency = 1,
                            Image = v10,
                            ImageColor3 = Theme.Color.BaseContent,
                            Size = UDim2.fromOffset(18, 18)
                        })
                    end),
                    p1:New("TextLabel")({
                        Name = "Title",
                        LayoutOrder = 2,
                        BackgroundTransparency = 1,
                        AutomaticSize = Enum.AutomaticSize.XY,
                        FontFace = p1:Computed(function(p4) -- line: 102
                            -- upvalues: Theme (copy)
                            return Font.new(p4(Theme.Font.Body), p4(Theme.FontWeight.Bold))
                        end),
                        Text = v1,
                        TextColor3 = Theme.Color.BaseContent,
                        TextSize = Theme.TextSize.Body
                    })
                }
            }),
            p1:New("TextLabel")({
                Name = "Body",
                LayoutOrder = 2,
                BackgroundTransparency = 1,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.XY,
                FontFace = p1:Computed(function(p5) -- line: 117
                    -- upvalues: Theme (copy)
                    return Font.new(p5(Theme.Font.Body), p5(Theme.FontWeight.Regular))
                end),
                Text = v2,
                TextColor3 = Theme.Color.NeutralContentMain,
                TextSize = Theme.TextSize.Label,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.fromScale(1, 0)
            })
        }
    }), fireActivate)
end
