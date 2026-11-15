-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Pressable = require(UI.Components.Pressable)
local LoadingSpinner = require(UI.Components.LoadingSpinner)
local Icons = require(UI.Config.Icons)
local Children = Fusion.Children

return function(p1, p2) -- line: 33
    -- upvalues: Theme (copy), Pressable (copy), LoadingSpinner (copy), Icons (copy), Children (copy)
    local v1 = p2.buttonSize or 30
    local v2 = p2.iconSize or 14
    local loading = p2.loading
    local t1 = {
        p1:New("UICorner")({
            CornerRadius = UDim.new(0, 6)
        })
    }

    if p2.flexNone then
        table.insert(t1, p1:New("UIFlexItem")({
            FlexMode = Enum.UIFlexMode.None
        }))
    end

    if loading ~= nil then
        local v3 = LoadingSpinner(p1, {
            thickness = 2,
            paddingY = 0,
            size = v2 * 0.6,
            color = Theme.Color.BaseContent,
            visible = loading
        })

        v3.AnchorPoint = Vector2.new(0.5, 0.5)
        v3.Position = UDim2.fromScale(0.5, 0.5)
        table.insert(t1, v3)
    end

    return Pressable(p1, {
        name = "FavouriteButton",
        backgroundColor = Theme.Color.NeutralStroke,
        size = UDim2.fromOffset(v1, v1),
        automaticSize = Enum.AutomaticSize.None,
        layoutOrder = p2.layoutOrder,
        visible = p2.visible,
        anchorPoint = p2.anchorPoint,
        position = p2.position,
        iconColor = Theme.Color.BaseContent,
        iconSize = v2,
        iconImage = p1:Computed(function(p3) -- line: 64
            -- upvalues: p2 (copy), Icons (copy)
            if p3(p2.isFavourited) then
                return Icons.FavouriteFill
            end

            return Icons.FavouriteHollow
        end),
        iconTransparency = if loading == nil then nil else p1:Computed(function(p4) -- line: 68
            -- upvalues: loading (copy)
            if p4(loading) then
                return 1
            end

            return 0
        end),
        onActivate = function() -- onActivate | line: 72
            -- upvalues: p2 (copy)
            if p2.onToggle then
                p2.onToggle()
            end
        end,
        [Children] = t1
    })
end
