-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local EmoteCard = require(UI.Components.EmoteCard)
local Children = Fusion.Children

return function(p1, p2) -- line: 30
    -- upvalues: EmoteCard (copy), Children (copy)
    local t1 = {}

    for v1, v2 in p2.cards do
        local v3 = if v2.activeEmoteId then p1:Computed(function(p3) -- line: 34
            -- upvalues: v2 (copy)
            return p3(v2.activeEmoteId) == v2.emoteId
        end) else nil

        t1[v1] = EmoteCard(p1, {
            emoteName = v2.emoteName,
            emoteId = v2.emoteId,
            isFavourited = v2.isFavourited,
            isActive = v3,
            onRun = v2.onRun,
            onFavourite = v2.onFavourite,
            onUnlock = v2.onUnlock,
            layoutOrder = v1
        })
    end

    for i = #p2.cards + 1, p2.columns do
        t1[i] = p1:New("Frame")({
            Name = "Filler",
            BackgroundTransparency = 1,
            LayoutOrder = i,
            Size = UDim2.new(0, 0, 0, 0)
        })
    end

    return p1:New("Frame")({
        Name = "EmoteRow",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = p2.layoutOrder,
        Size = UDim2.new(1, 0, 0, 0),
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            t1
        }
    })
end
