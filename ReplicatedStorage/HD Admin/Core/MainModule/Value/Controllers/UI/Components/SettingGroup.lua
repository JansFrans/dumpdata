-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Setting = require(UI.Components.Setting)
local Children = Fusion.Children

return function(p1, p2) -- line: 35
    -- upvalues: Theme (copy), Setting (copy), Children (copy)
    local v1 = p2.settings or p1:Value({})

    return p1:New("Frame")({
        Name = "SettingGroup",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0, 0),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p1:New("TextLabel")({
                Name = "Heading",
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                AutomaticSize = Enum.AutomaticSize.XY,
                FontFace = p1:Computed(function(p3) -- line: 56
                    -- upvalues: Theme (copy)
                    return Font.new(p3(Theme.Font.Heading), p3(Theme.FontWeight.Heading))
                end),
                Text = p2.heading,
                TextColor3 = Theme.Color.BaseContent,
                TextSize = Theme.TextSize.Subtitle,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            p1:New("Frame")({
                Name = "Divider",
                LayoutOrder = 2,
                BackgroundColor3 = Theme.Color.NeutralContent,
                Size = UDim2.new(1, 0, 0, 1)
            }),
            p1:New("Frame")({
                Name = "Rows",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 3,
                Size = UDim2.new(1, 0, 0, 0),
                [Children] = {
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        Padding = UDim.new(0, 12),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p1:New("UIPadding")({
                        PaddingTop = UDim.new(0, 12),
                        PaddingBottom = UDim.new(0, 4)
                    }),
                    p1:ForValues(v1, function(_, p5, p6, p7) -- line: 92
                        -- upvalues: Setting (copy), Children (copy)
                        return p5:New("Frame")({
                            Name = "SettingEntry_" .. p6.key,
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            LayoutOrder = p7,
                            Size = UDim2.new(1, 0, 0, 0),
                            [Children] = {
                                Setting(p5, {
                                    label = p6.label,
                                    description = p6.description,
                                    settingType = p6.settingType,
                                    value = p6.value,
                                    choices = p6.choices,
                                    min = p6.min,
                                    max = p6.max,
                                    onUserActivate = p6.onUserActivate
                                })
                            }
                        })
                    end)
                }
            })
        }
    })
end
