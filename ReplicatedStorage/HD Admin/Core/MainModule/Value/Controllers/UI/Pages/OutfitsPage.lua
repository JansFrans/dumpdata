-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local ScrollList = require(UI.Components.ScrollList)
local SearchBar = require(UI.Components.SearchBar)
local CosmeticCard = require(UI.Components.CosmeticCard)
local CosmeticMarket = require(UI.Util.CosmeticMarket)
local Children = Fusion.Children

return function(p1, p2) -- line: 34
    -- upvalues: ScrollList (copy), SearchBar (copy), CosmeticCard (copy), CosmeticMarket (copy), Children (copy)
    local SpecialAccessories = p1:Fuse("everyone", "SpecialAccessories")
    local v1 = p1:Value("")
    local v2 = p1:Computed(function(p3) -- line: 38
        -- upvalues: SpecialAccessories (copy), v1 (copy)
        local v3 = p3(SpecialAccessories)

        if typeof(v3) ~= "table" then
            return {}
        end

        local v4 = p3(v1):lower()
        local t1 = {}

        for _, v5 in v3 do
            if typeof(v5) == "table" and v5.id then
                local v6 = if v5.comingSoon == true then "Coming Soon" else tostring(v5.name)

                if v4 == "" or v6:lower():find(v4, 1, true) then
                    table.insert(t1, v5)
                end
            end
        end

        table.sort(t1, function(p4, p5) -- line: 51
            local v7 = p4.order or 1e999
            local v8 = p5.order or 1e999

            if v7 == v8 then
                return p4.name < p5.name
            end

            return v7 < v8
        end)

        local t2 = {}

        for i = 1, #t1, 2 do
            local t3 = {}

            for j = 0, 1 do
                local v9 = t1[i + j]

                if not v9 then
                    break
                end

                table.insert(t3, {
                    id = v9.id,
                    name = v9.name,
                    comingSoon = v9.comingSoon == true
                })
            end

            table.insert(t2, {
                layoutOrder = #t2 + 1,
                tiles = t3
            })
        end

        return t2
    end)

    local function renderRow(p6, p7) -- line: 70
        -- upvalues: CosmeticCard (copy), CosmeticMarket (copy), Children (copy)
        local t6 = {}

        for v10, v11 in p7.tiles do
            local id = v11.id
            local v12 = v11.comingSoon == true
            local v13 = p6:Value(if v12 then 0 else CosmeticMarket.peekPrice(id))
            local v14 = p6:Value(not v12 and CosmeticMarket.peekFavourite(id))

            if not v12 then
                CosmeticMarket.seedPrice(id, v13)
                CosmeticMarket.seedFavourite(id, v14)
            end

            t6[v10] = CosmeticCard(p6, {
                accessoryId = id,
                name = if v12 then "Coming Soon" else v11.name,
                robuxPrice = v13,
                isFavourited = v14,
                onFavourite = function() -- onFavourite | line: 86
                    -- upvalues: id (copy), v12 (copy), v14 (copy), CosmeticMarket (copy)
                    if v12 then
                        CosmeticMarket.notifyComingSoon()
                    else
                        CosmeticMarket.toggleFavourite(id, v14)
                    end
                end,
                onBuy = function() -- onBuy | line: 93
                    -- upvalues: id (copy), v12 (copy), CosmeticMarket (copy)
                    if v12 then
                        CosmeticMarket.notifyComingSoon()
                    else
                        CosmeticMarket.buy(id)
                    end
                end,
                layoutOrder = v10
            })
        end

        for i = #p7.tiles + 1, 2 do
            t6[i] = p6:New("Frame")({
                Name = "Filler",
                BackgroundTransparency = 1,
                LayoutOrder = i,
                Size = UDim2.new(0, 0, 0, 0)
            })
        end

        return p6:New("Frame")({
            Name = "OutfitsRow",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = p7.layoutOrder,
            Size = UDim2.new(1, 0, 0, 0),
            [Children] = {
                p6:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                t6
            }
        })
    end

    return p1:New("Frame")({
        Name = "Outfits",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            p1:New("UIListLayout")({
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            ScrollList(p1, {
                useStream = false,
                paddingRight = 10,
                layoutOrder = 1,
                isReady = p1:Computed(function(p8) -- line: 143
                    -- upvalues: SpecialAccessories (copy)
                    local v16 = p8(SpecialAccessories)

                    if typeof(v16) == "table" then
                        return next(v16) ~= nil
                    end

                    return false
                end),
                items = v2,
                visibleItems = v2,
                renderItem = renderRow,
                padding = UDim.new(0, 8),
                idle = p2.idle,
                headerGap = UDim.new(0, 8),
                header = SearchBar(p1, {
                    placeholderText = "Search cosmetics",
                    layoutOrder = 0,
                    searchText = v1
                })
            })
        }
    })
end
