-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local ScrollList = require(UI.Components.ScrollList)
local SearchBar = require(UI.Components.SearchBar)
local EmoteRow = require(UI.Components.EmoteRow)
local Remote = require(Modules.Objects.Remote)
local promptSetFavoriteAsync = require(Modules.AssetUtil.promptSetFavoriteAsync)
local Children = Fusion.Children
local SendMessage = Remote.get("SendMessage")
local FavoriteEmote = Remote.get("FavoriteEmote")
local GetActiveCommands = Remote.get("GetActiveCommands")
local UpdateActiveCommands = Remote.get("UpdateActiveCommands")

return function(p1, p2) -- line: 38
    -- upvalues: Fusion (copy), ScrollList (copy), SearchBar (copy), EmoteRow (copy), promptSetFavoriteAsync (copy), Children (copy), SendMessage (copy), FavoriteEmote (copy), GetActiveCommands (copy), UpdateActiveCommands (copy)
    local Emotes = p1:Fuse("everyone", "Emotes")
    local FavoritedEmotes = p1:Fuse("perm", "FavoritedEmotes")
    local v1 = p1:Fuse("perm", { "YouSettings", "Prefix" })
    local v2 = p1:Value("")
    local v3 = p1:Value(nil)
    local v4 = p1:Value(false)

    local function applyActiveMap(p3) -- line: 48
        -- upvalues: v4 (copy)
        if type(p3) == "table" then
            v4:set(p3.emote == true)
        end
    end

    task.defer(function() -- line: 53
        -- upvalues: v4 (copy), GetActiveCommands (copy)
        local v6, v7 = GetActiveCommands:invokeServerAsync()

        if v6 and type(v7) == "table" then
            v4:set(v7.emote == true)
        end
    end)

    local v9 = UpdateActiveCommands:onClientEvent(applyActiveMap)

    table.insert(p1, function() -- line: 58
        -- upvalues: v9 (copy)
        v9:Disconnect()
    end)
    p1:Observer(v4):onChange(function() -- line: 59
        -- upvalues: v3 (copy), v4 (copy), Fusion (copy)
        if not Fusion.peek(v4) then
            v3:set(nil)
        end
    end)

    local function prefix() -- line: 65
        -- upvalues: v1 (copy), Fusion (copy)
        local v11 = Fusion.peek(v1)

        if typeof(v11) ~= "string" or v11 == "" then
            return ";"
        end

        return v11
    end

    local function toggleEmote(p4, p5) -- line: 69
        -- upvalues: v1 (copy), v3 (copy), v4 (copy), Fusion (copy), SendMessage (copy)
        local v12, v13

        if Fusion.peek(v4) and Fusion.peek(v3) == p4 then
            local v14 = Fusion.peek(v1)

            if typeof(v14) ~= "string" or v14 == "" then
                v14 = ";"
            end

            v13 = v14 .. "unemote me"
        else
            local v15 = Fusion.peek(v1)

            if typeof(v15) ~= "string" or v15 == "" then
                v15 = ";"
            end

            v13 = v15 .. "emote me " .. p5
            v12 = p4
        end

        v3:set(v12)
        task.spawn(function() -- line: 73
            -- upvalues: v13 (ref), v4 (copy), SendMessage (copy)
            local _, ClientRun = SendMessage:invokeServerAsync(v13, "ClientRun")
            local v16, v17

            if type(ClientRun) == "table" and type(ClientRun.activeCommands) == "table" then
                local activeCommands = ClientRun.activeCommands

                if type(activeCommands) == "table" then
                    v16 = v4
                    v17 = activeCommands.emote == true
                    v16:set(v17)
                end
            end
        end)
    end

    local function toggleFavourite(p6, p7) -- line: 81
        -- upvalues: promptSetFavoriteAsync (copy), FavoriteEmote (copy)
        local v18 = not p7

        if promptSetFavoriteAsync(p6, v18) then
            FavoriteEmote:invokeServerAsync(p6, v18)
        end
    end

    local v19 = p1:Computed(function(p8) -- line: 89
        -- upvalues: Emotes (copy), FavoritedEmotes (copy), v2 (copy), v3 (copy), toggleEmote (copy), promptSetFavoriteAsync (copy), FavoriteEmote (copy)
        local v20 = p8(Emotes)

        if typeof(v20) ~= "table" then
            return {}
        end

        local v21 = p8(FavoritedEmotes)
        local v22 = typeof(v21) == "table"
        local v23 = p8(v2):lower()

        local function favRecord(p9) -- line: 96
            -- upvalues: v21 (copy), v22 (copy)
            local v24 = v22 and v21[tostring(p9.emoteId)]

            return v24
        end

        local function isFavourited(p10) -- line: 99
            -- upvalues: v21 (copy), v22 (copy)
            local v25 = v22 and v21[tostring(p10.emoteId)]

            return v25 ~= nil
        end

        local function favTime(p11) -- line: 102
            -- upvalues: v21 (copy), v22 (copy)
            local v26 = v22 and v21[tostring(p11.emoteId)]

            if typeof(v26) == "table" and typeof(v26.addedTime) == "number" then
                return v26.addedTime
            end

            return 0
        end

        local t1 = {}

        for _, v27 in v20 do
            if typeof(v27) == "table" and v27.emoteId and (v23 == "" or v27.name:lower():find(v23, 1, true)) then
                table.insert(t1, v27)
            end
        end

        table.sort(t1, function(p12, p13) -- line: 113
            -- upvalues: v21 (copy), v22 (copy)
            local v28 = v22 and v21[tostring(p12.emoteId)]
            local v29 = v28 ~= nil
            local v30 = v22 and v21[tostring(p13.emoteId)]

            if v29 ~= (v30 ~= nil) then
                return v29
            end

            if v29 then
                local v31 = v22 and v21[tostring(p12.emoteId)]
                local v32 = typeof(v31) == "table"
                local v33 = if v32 then typeof(v31.addedTime) == "number" else nil
                local v34 = if not v32 or not v33 then 0 else v31.addedTime
                local v35 = v22 and v21[tostring(p13.emoteId)]
                local v36 = typeof(v35) == "table"
                local v37 = if v36 then typeof(v35.addedTime) == "number" else nil
                local v38 = if not v36 or not v37 then 0 else v35.addedTime

                if v34 ~= v38 then
                    return v38 < v34
                end
            end

            local v39 = p12.order or 1e999
            local v40 = p13.order or 1e999

            if v39 == v40 then
                return p12.name < p13.name
            end

            return v39 < v40
        end)

        local t2 = {}

        for i = 1, #t1, 3 do
            local t3 = {}

            for j = 0, 2 do
                local v41 = t1[i + j]

                if not v41 then
                    break
                end

                local emoteId, name = v41.emoteId, v41.name

                table.insert(t3, {
                    emoteName = name,
                    emoteId = emoteId,
                    isFavourited = (v22 and v21[tostring(v41.emoteId)]) ~= nil,
                    activeEmoteId = v3,
                    onRun = function() -- onRun | line: 138
                        -- upvalues: emoteId (copy), name (copy), toggleEmote (copy)
                        toggleEmote(emoteId, name)
                    end,
                    onFavourite = function() -- onFavourite | line: 139
                        -- upvalues: v21 (copy), v22 (copy), v41 (copy), emoteId (copy), promptSetFavoriteAsync (copy), FavoriteEmote (copy)
                        local v43 = v22

                        v43 = v43 and v21[tostring(v41.emoteId)]

                        local v44 = v43 == nil

                        if promptSetFavoriteAsync(emoteId, v44) then
                            FavoriteEmote:invokeServerAsync(emoteId, v44)
                        end
                    end
                })
            end

            table.insert(t2, {
                columns = 3,
                layoutOrder = #t2 + 1,
                cards = t3
            })
        end

        return t2
    end)

    return p1:New("Frame")({
        Name = "Emotes",
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
                isReady = p1:Computed(function(p14) -- line: 160
                    -- upvalues: Emotes (copy)
                    local v46 = p14(Emotes)

                    if typeof(v46) == "table" then
                        return next(v46) ~= nil
                    end

                    return false
                end),
                items = v19,
                visibleItems = v19,
                renderItem = function(p15, p16) -- renderItem | line: 167
                    -- upvalues: EmoteRow (copy)
                    return EmoteRow(p15, p16)
                end,
                padding = UDim.new(0, 8),
                idle = p2.idle,
                headerGap = UDim.new(0, 8),
                header = SearchBar(p1, {
                    placeholderText = "Search emotes",
                    layoutOrder = 0,
                    searchText = v2
                })
            })
        }
    })
end
