-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local ScrollList = require(UI.Components.ScrollList)
local SearchBar = require(UI.Components.SearchBar)
local CommandCard = require(UI.Components.CommandCard)
local OutfitsButton = require(UI.Components.OutfitsButton)
local Remote = require(Modules.Objects.Remote)
local promptSetFavoriteAsync = require(Modules.AssetUtil.promptSetFavoriteAsync)
local Children = Fusion.Children
local SendMessage = Remote.get("SendMessage")
local FavoriteEmote = Remote.get("FavoriteEmote")

local function thumbUrl(p1) -- line: 32
    if typeof(p1) ~= "table" then
        return nil
    end

    local id = p1.id

    if typeof(id) ~= "number" then
        return nil
    end

    local kind = p1.kind

    if kind == "Bundle" then
        return (("rbxthumb://type=BundleThumbnail&id=%*&w=150&h=150"):format(id))
    end

    if kind == "Image" then
        return (("rbxassetid://%*"):format(id))
    end

    return (("rbxthumb://type=Asset&id=%*&w=150&h=150"):format(id))
end

local function emoteIdOf(p2) -- line: 46
    if typeof(p2) == "table" and p2.kind == "Emote" then
        local id = p2.id

        if typeof(id) == "number" then
            return id
        end
    end

    return nil
end

return function(p3, p4) -- line: 54
    -- upvalues: UI (copy), ScrollList (copy), SearchBar (copy), CommandCard (copy), OutfitsButton (copy), promptSetFavoriteAsync (copy), Children (copy), SendMessage (copy), FavoriteEmote (copy)
    local Commands = p3:Fuse("everyone", "Commands")
    local FavoritedEmotes = p3:Fuse("perm", "FavoritedEmotes")
    local BoosterDisplay = p3:Fuse("everyone", "BoosterDisplay")
    local v1 = p3:Value("")

    table.insert(p3, function() -- line: 62
        -- upvalues: UI (copy)
        require(UI.Config.Panels).notifyBoosterStackClosed("commands")
    end)

    local function runCommand(p5, p6) -- line: 67
        -- upvalues: SendMessage (copy)
        local v3 = (if typeof(p5) ~= "string" or p5 == "" then "/" else p5) .. p6

        task.spawn(function() -- line: 70
            -- upvalues: v3 (copy), SendMessage (copy)
            SendMessage:invokeServerAsync(v3, "ClientRun")
        end)
    end

    local function toggleFavourite(p7, p8) -- line: 75
        -- upvalues: promptSetFavoriteAsync (copy), FavoriteEmote (copy)
        local v4 = not p8

        if promptSetFavoriteAsync(p7, v4) then
            FavoriteEmote:invokeServerAsync(p7, v4)
        end
    end

    local v5 = p3:Computed(function(p9) -- line: 83
        -- upvalues: p4 (copy), Commands (copy), FavoritedEmotes (copy), BoosterDisplay (copy), v1 (copy), promptSetFavoriteAsync (copy), SendMessage (copy), FavoriteEmote (copy)
        local v6 = p9(Commands)

        if typeof(v6) ~= "table" then
            return {}
        end

        local v7 = p9(v1):lower()
        local v8 = p4.display or p9(BoosterDisplay)

        local function hasBoosterTag(p10) -- line: 91
            local tags = p10.tags

            if typeof(tags) == "table" then
                for _, v9 in tags do
                    if v9 == "_Booster" then
                        return true
                    end
                end
            end

            return false
        end

        local v10 = p9(FavoritedEmotes)
        local v11 = typeof(v10) == "table"

        local function favRecord(p11) -- line: 102
            -- upvalues: v10 (copy), v11 (copy)
            return v11 and v10[tostring(p11)]
        end

        local t1 = {}
        local n1 = 0

        for _, v12 in v6 do
            if typeof(v12) == "table" and v12.key ~= "/commands" then
                local tags = v12.tags
                local v13

                if typeof(tags) == "table" then
                    local v14 = false

                    for _, v15 in tags do
                        if v15 == "_Booster" then
                            v13 = true
                            v14 = true
                            break
                        end
                    end

                    if not v14 then
                        v13 = false
                    end
                else
                    v13 = false
                end

                if v13 then
                    local name = v12.name

                    if typeof(name) == "string" and (v7 == "" or name:lower():find(v7, 1, true)) then
                        n1 += 1

                        local v16 = v8 and v8[v12.key]
                        local id

                        if typeof(v16) == "table" and v16.kind == "Emote" then
                            id = v16.id

                            if typeof(id) ~= "number" then
                                id = nil
                            end
                        end

                        local v17 = if id then v11 and v10[tostring(id)] else nil
                        local v18 = if typeof(v17) ~= "table" then 0 elseif typeof(v17.addedTime) == "number" then v17.addedTime else 0

                        table.insert(t1, {
                            cmd = v12,
                            sourceIndex = n1,
                            emoteId = id,
                            isFavourited = v17 ~= nil,
                            addedTime = v18
                        })
                    end
                end
            end
        end

        table.sort(t1, function(p12, p13) -- line: 128
            if p12.isFavourited ~= p13.isFavourited then
                return p12.isFavourited
            end

            if p12.isFavourited and p12.addedTime ~= p13.addedTime then
                return p12.addedTime > p13.addedTime
            end

            return p12.sourceIndex < p13.sourceIndex
        end)

        local t3 = {}

        for i = 1, #t1, 3 do
            local t4 = {}

            for j = 0, 2 do
                local v20 = t1[i + j]

                if not v20 then
                    break
                end

                local cmd = v20.cmd
                local prefix, name = cmd.prefix, cmd.name
                local emoteId, isFavourited = v20.emoteId, v20.isFavourited
                local t5 = {
                    commandName = name
                }
                local v21 = v8 and v8[cmd.key]

                if typeof(v21) == "table" then
                    local id = v21.id

                    if typeof(id) == "number" then
                        local kind = v21.kind

                        t5.icon = if kind == "Bundle" then ("rbxthumb://type=BundleThumbnail&id=%*&w=150&h=150"):format(id) elseif kind == "Image" then ("rbxassetid://%*"):format(id) else ("rbxthumb://type=Asset&id=%*&w=150&h=150"):format(id)
                    else
                        t5.icon = nil
                    end
                else
                    t5.icon = nil
                end

                function t5.onRun() -- line: 148
                    -- upvalues: prefix (copy), name (copy), SendMessage (copy)
                    local v22 = prefix

                    if typeof(v22) ~= "string" or v22 == "" then
                        v22 = "/"
                    end

                    local v23 = v22 .. name

                    task.spawn(function() -- line: 70
                        -- upvalues: v23 (copy), SendMessage (copy)
                        SendMessage:invokeServerAsync(v23, "ClientRun")
                    end)
                end

                t5.isFavourited = isFavourited
                t5.onFavourite = if emoteId then function() -- line: 150
                    -- upvalues: emoteId (copy), isFavourited (copy), promptSetFavoriteAsync (copy), FavoriteEmote (copy)
                    local v24 = not isFavourited

                    if promptSetFavoriteAsync(emoteId, v24) then
                        FavoriteEmote:invokeServerAsync(emoteId, v24)
                    end
                end else nil
                table.insert(t4, t5)
            end

            table.insert(t3, {
                columns = 3,
                layoutOrder = #t3 + 1,
                cards = t4
            })
        end

        return t3
    end)

    local function renderRow(p14, p15) -- line: 158
        -- upvalues: CommandCard (copy), Children (copy)
        local t7 = {}

        for v25, v26 in p15.cards do
            t7[v25] = CommandCard(p14, {
                commandName = v26.commandName,
                icon = v26.icon,
                isFavourited = v26.isFavourited,
                onFavourite = v26.onFavourite,
                onRun = v26.onRun,
                layoutOrder = v25
            })
        end

        for i = #p15.cards + 1, p15.columns do
            t7[i] = p14:New("Frame")({
                Name = "Filler",
                BackgroundTransparency = 1,
                LayoutOrder = i,
                Size = UDim2.new(0, 0, 0, 0)
            })
        end

        return p14:New("Frame")({
            Name = "CommandRow",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = p15.layoutOrder,
            Size = UDim2.new(1, 0, 0, 0),
            [Children] = {
                p14:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                t7
            }
        })
    end

    return p3:New("Frame")({
        Name = "Commands",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            p3:New("UIListLayout")({
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            ScrollList(p3, {
                useStream = false,
                paddingRight = 10,
                layoutOrder = 1,
                isReady = p3:Computed(function(p16) -- line: 209
                    -- upvalues: Commands (copy)
                    return typeof(p16(Commands)) == "table"
                end),
                items = v5,
                visibleItems = v5,
                renderItem = renderRow,
                padding = UDim.new(0, 8),
                idle = p4.idle,
                headerGap = UDim.new(0, 8),
                header = SearchBar(p3, {
                    placeholderText = "Search commands",
                    layoutOrder = 0,
                    searchText = v1,
                    gap = UDim.new(0, 6),
                    slot = OutfitsButton(p3, {
                        onActivate = function() -- onActivate | line: 227
                            -- upvalues: UI (copy)
                            require(UI.Config.Panels).openOutfits()
                        end
                    })
                })
            })
        }
    })
end
