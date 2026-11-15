-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local InputObjects = require(UI.Config.InputObjects)

return function(p1, p2) -- line: 31
    -- upvalues: Theme (copy), Children (copy), InputObjects (copy)
    local v1 = InputObjects.items[p2.settingType]
    local v2

    if v1 then
        local t1 = {
            inputType = p2.settingType,
            title = p2.label,
            value = p2.value,
            min = p2.min,
            max = p2.max
        }
        local t2

        if p2.choices then
            t2 = {}

            for _, v3 in p2.choices do
                table.insert(t2, v3.label)
            end
        end

        t1.optionsArray = t2
        v2 = v1(p1, t1)
    end

    return p1:New("Frame")({
        Name = "Setting",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            if not p2.description or p2.description == "" then nil else p1:New("TextLabel")({
                Name = "Description",
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                RichText = true,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                FontFace = p1:Computed(function(p3) -- line: 69
                    -- upvalues: Theme (copy)
                    return Font.new(p3(Theme.Font.Body), p3(Theme.FontWeight.Regular))
                end),
                Size = UDim2.fromScale(1, 0),
                Text = p2.description,
                TextColor3 = Theme.Color.NeutralContentDark,
                TextSize = Theme.TextSize.Small,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            if v2 then p1:New("Frame")({
                Name = "InputWrapper",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Size = UDim2.fromScale(1, 0),
                [Children] = { v2 }
            }) else nil
        }
    })
end
