-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local GlowTextInput = require(script.Parent.GlowTextInput)

return function(p1, p2) -- line: 29
    -- upvalues: Theme (copy), Children (copy), GlowTextInput (copy)
    return p1:New("Frame")({
        Name = "SearchRow",
        BackgroundTransparency = 1,
        LayoutOrder = p2.layoutOrder or 0,
        Size = UDim2.new(1, 0, 0, 38),
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = p2.gap or UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                VerticalFlex = Enum.UIFlexAlignment.Fill
            }),
            p1:New("Frame")({
                Name = "LeadingSlot",
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                LayoutOrder = 0,
                Visible = if p2.leadingSlotVisible == nil then p2.leadingSlot ~= nil else p2.leadingSlotVisible,
                [Children] = if p2.leadingSlot then { p2.leadingSlot } else nil
            }),
            GlowTextInput(p1, {
                name = "SearchInput",
                layoutOrder = 1,
                placeholderText = p2.placeholderText or "Search",
                text = p2.searchText,
                backgroundColor = Theme.Color.Base,
                flexMode = Enum.UIFlexMode.Fill,
                onFocusLost = p2.onFocusLost
            }),
            p1:New("Frame")({
                Name = "TrailingSlot",
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Visible = if p2.slotVisible == nil then p2.slot ~= nil else p2.slotVisible,
                [Children] = if p2.slot then { p2.slot } else nil
            })
        }
    })
end
