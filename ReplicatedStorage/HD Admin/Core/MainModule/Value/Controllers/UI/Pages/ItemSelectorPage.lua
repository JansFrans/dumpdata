-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local SearchBar = require(UI.Components.SearchBar)
local ScrollList = require(UI.Components.ScrollList)
local CheckItem = require(UI.Components.CheckItem)
local Checkbox = require(UI.Components.Checkbox)
local SplitRow = require(UI.Components.SplitRow)
local Pressable = require(UI.Components.Pressable)
local Icons = require(UI.Config.Icons)
local Players = game:GetService("Players")
local GroupService = game:GetService("GroupService")
local MarketplaceService = game:GetService("MarketplaceService")
local t1 = {
    {
        id = "GamePass",
        label = "GamePass",
        searchDescription = "Search GamePass ID...",
        enum = Enum.InfoType.GamePass
    },
    {
        id = "Asset",
        label = "Asset",
        searchDescription = "Search Accessory/Emote/Asset ID",
        enum = Enum.InfoType.Asset
    },
    {
        id = "Bundle",
        label = "Bundle",
        searchDescription = "Search Bundle ID...",
        enum = Enum.InfoType.Bundle
    }
}

local function resolveUser(p1) -- line: 70
    -- upvalues: Players (copy)
    local result = tonumber(p1)

    if not result then
        local GetUserIdFromNameAsync = Players.GetUserIdFromNameAsync
        local ok

        ok, result = pcall(GetUserIdFromNameAsync, Players, p1)

        if not ok then
            return nil, "No user found"
        end
    end

    local GetNameFromUserIdAsync = Players.GetNameFromUserIdAsync
    local ok, result2 = pcall(GetNameFromUserIdAsync, Players, result)

    if not ok or typeof(result2) ~= "string" then
        return nil, "No user found"
    end

    local PlayerByUserId = Players:GetPlayerByUserId(result)
    local v1 = result2

    if PlayerByUserId then
        v1 = PlayerByUserId.DisplayName
        result2 = PlayerByUserId.Name
    end

    return {
        category = "custom",
        key = tostring(result),
        label = v1 .. " @" .. result2,
        header = v1,
        body = "@" .. result2,
        icon = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(result) .. "&w=48&h=48",
        rawValue = PlayerByUserId or result
    }, nil
end

local function resolveGroup(p2) -- line: 97
    -- upvalues: GroupService (copy)
    local v2 = tonumber(p2)

    if not v2 or v2 <= 0 then
        return nil, "Enter a valid group ID"
    end

    local function v3() -- line: 100
        -- upvalues: v2 (copy), GroupService (copy)
        return GroupService:GetGroupInfoAsync(v2)
    end

    local ok, result = pcall(v3)

    if not ok or typeof(result) ~= "table" then
        return nil, (("No group found for \"%*\""):format(p2))
    end

    local v4 = if typeof(result.Name) == "string" then result.Name else "Group " .. tostring(v2)

    return {
        category = "custom",
        groupConfig = true,
        roleLabel = "All Roles",
        key = "group:" .. tostring(v2),
        label = v4,
        header = v4,
        body = tostring(v2),
        icon = "rbxthumb://type=GroupIcon&id=" .. tostring(v2) .. "&w=150&h=150",
        rawValue = {
            type = "AnyMember",
            groupId = v2
        }
    }, nil
end

local function resolveProduct(p3, p4, p5) -- line: 118
    -- upvalues: MarketplaceService (copy)
    local v5 = tonumber(p3)

    if not v5 or v5 <= 0 then
        return nil, "Enter a valid ID"
    end

    local function v6() -- line: 121
        -- upvalues: p5 (copy), v5 (copy), MarketplaceService (copy)
        return MarketplaceService:GetProductInfo(v5, p5)
    end

    local ok, result = pcall(v6)

    if not ok or typeof(result) ~= "table" then
        return nil, "Could not find a " .. p4 .. " with that id"
    end

    local v7 = if typeof(result.Name) == "string" then result.Name else "#" .. tostring(v5)
    local v8 = if typeof(result.IconImageAssetId) == "number" and result.IconImageAssetId > 0 then "rbxassetid://" .. tostring(result.IconImageAssetId) else ""

    return {
        category = "custom",
        productConfig = true,
        key = string.lower(p4) .. ":" .. tostring(v5),
        label = v7,
        header = v7,
        icon = if not (#v8 > 0) then nil else v8,
        rawValue = {
            type = p4,
            id = v5
        }
    }, nil
end

return function(p6, p7) -- line: 143
    -- upvalues: Fusion (copy), Theme (copy), Children (copy), SearchBar (copy), ScrollList (copy), CheckItem (copy), Checkbox (copy), SplitRow (copy), Pressable (copy), Icons (copy), t1 (copy), resolveUser (copy), resolveGroup (copy), resolveProduct (copy)
    local v9 = p6:Value("")

    local function peekConfig() -- line: 146
        -- upvalues: p7 (copy), Fusion (copy)
        return (Fusion.peek(p7.config))
    end

    local v10 = p6:Computed(function(p8) -- line: 150
        -- upvalues: p7 (copy)
        local v11 = p8(p7.config)

        if not v11 then
            return false
        end

        if v11.canAdd == true then
            return true
        end

        return v11.canAddAnyUser == true
    end)
    local v12 = p6:Computed(function(p9) -- line: 157
        -- upvalues: p7 (copy)
        local v13 = p9(p7.config)

        if v13 then
            return v13.limitPickerToOneItem == true
        end

        return false
    end)
    local v14 = p6:Computed(function(p10) -- line: 162
        -- upvalues: p7 (copy)
        local v15 = p10(p7.config)

        if v15 then
            return v15.displayServerPlayersInPicker == true
        end

        return true
    end)
    local t3 = {}
    local v16
    local v17 = p6:Computed(function(p11) -- line: 171
        -- upvalues: p7 (copy), t3 (ref), v16 (ref)
        local v18 = p11(p7.config)

        if not v18 then
            return {}
        end

        if v18 ~= v16 then
            v16 = v18
            t3 = {}
        end

        local v19 = p11(v18.allItems)
        local v20 = p11(v18.pendingKeys)
        local t4 = {}

        for _, v21 in v19 do
            if v21.hiddenFromPicker == true then
                if typeof(v20) == "table" and v20[v21.key] == true then
                    t3[v21.key] = true
                end

                if t3[v21.key] == true then
                    table.insert(t4, v21)
                end
            else
                table.insert(t4, v21)
            end
        end

        return t4
    end)
    local v22 = p6:Computed(function(p12) -- line: 193
        -- upvalues: v9 (copy), v17 (copy)
        local v23 = p12(v17)
        local v24 = string.lower((string.gsub(p12(v9), "%s", "")))

        if #v24 == 0 then
            return v23
        end

        local t7 = {}

        for _, v25 in v23 do
            local v26 = v25.category or "custom"
            local v30 = string.lower(v25.label) .. (if v25.header then string.lower(v25.header) else "") .. (if not v25.body then "" elseif v26 == "qualifier" then "" else " " .. string.lower(v25.body)) .. " " .. string.lower((tostring(v25.key)))

            if string.find(v30, v24, 1, true) then
                table.insert(t7, v25)
            end
        end

        return t7
    end)
    local v31 = p6:Computed(function(p13) -- line: 212
        -- upvalues: p7 (copy)
        local v32 = p13(p7.config)

        return if v32 and (v32.canAdd == true or v32.canAddAnyUser == true) then v32.addFlow or "User" else nil
    end)
    local GamePass = p6:Value("GamePass")
    local v33 = p6:Value(false)
    local v34 = p6:Value("")
    local v35 = false

    table.insert(p6, function() -- line: 225
        -- upvalues: v35 (ref)
        v35 = true
    end)

    local v37 = p6:Computed(function(p14) -- line: 227
        -- upvalues: v31 (copy), GamePass (copy), t1 (copy)
        local v38 = p14(v31)

        if v38 == "User" then
            return "Search by name or user ID..."
        end

        if v38 == "Group" then
            return "Search by group ID..."
        end

        if v38 ~= "Product" then
            return "Filter..."
        end

        local v39 = p14(GamePass)

        for _, v40 in t1 do
            if v40.id == v39 and v40.searchDescription then
                return v40.searchDescription
            end
        end

        return "Search by product ID..."
    end)

    local function infoEnumFor(p15) -- line: 241
        -- upvalues: t1 (copy)
        for _, v41 in t1 do
            if v41.id == p15 then
                return v41.enum
            end
        end

        return Enum.InfoType.GamePass
    end

    local function keyExists(p16, p17) -- line: 248
        -- upvalues: Fusion (copy)
        for _, v42 in (Fusion.peek(p16.allItems)) do
            if v42.key == p17 then
                return true
            end
        end

        return false
    end

    local function userAlreadyListed(p18, p19) -- line: 256
        -- upvalues: Fusion (copy)
        local v43 = tonumber(p19) ~= nil
        local v44 = string.lower(p19)

        for _, v45 in (Fusion.peek(p18.allItems)) do
            if v43 then
                if v45.key == p19 then
                    return true
                end
            else
                local body = v45.body

                if typeof(body) == "string" and string.lower((string.gsub(body, "^@", ""))) == v44 then
                    return true
                end
            end
        end

        return false
    end

    local n1 = 0

    local function runResolve() -- line: 275
        -- upvalues: p7 (copy), v9 (copy), v31 (copy), GamePass (copy), v33 (copy), v34 (copy), v35 (ref), userAlreadyListed (copy), n1 (ref), Fusion (copy), t1 (copy), resolveUser (copy), resolveGroup (copy), resolveProduct (copy)
        local v46 = Fusion.peek(p7.config)
        local v47 = Fusion.peek(v31)
        local v48 = string.gsub(Fusion.peek(v9), "%s+", "")

        n1 += 1

        local v49 = n1

        v34:set("")

        if v46 then
            if v46.setPreview then
                v46.setPreview(nil)
            end

            if v47 and #v48 ~= 0 then
                if v47 == "User" then
                    if userAlreadyListed(v46, v48) then
                        v33:set(false)

                        return
                    end
                elseif v47 == "Group" then
                    if not tonumber(v48) then
                        v34:set("Enter a valid group ID")
                        v33:set(false)

                        return
                    end

                    local v50 = "group:" .. v48
                    local v51 = false
                    local v52

                    for _, v53 in (Fusion.peek(v46.allItems)) do
                        if v53.key == v50 then
                            v52 = true
                            v51 = true
                            break
                        end
                    end

                    if not v51 then
                        v52 = false
                    end

                    if v52 then
                        v33:set(false)

                        return
                    end
                elseif v47 == "Product" then
                    if not tonumber(v48) then
                        v34:set("Enter a valid ID")
                        v33:set(false)

                        return
                    end

                    local v54 = string.lower((Fusion.peek(GamePass))) .. ":" .. v48
                    local v55 = false
                    local v56

                    for _, v57 in (Fusion.peek(v46.allItems)) do
                        if v57.key == v54 then
                            v56 = true
                            v55 = true
                            break
                        end
                    end

                    if not v55 then
                        v56 = false
                    end

                    if v56 then
                        v33:set(false)

                        return
                    end
                end

                v33:set(true)

                local v58 = Fusion.peek(GamePass)
                local v59 = false
                local v60

                for _, v61 in t1 do
                    if v61.id == v58 then
                        v60 = v61.enum
                        v59 = true
                        break
                    end
                end

                if not v59 then
                    v60 = Enum.InfoType.GamePass
                end

                task.delay(0.3, function() -- line: 316
                    -- upvalues: v47 (copy), v48 (copy), v49 (copy), v58 (copy), v60 (ref), p7 (copy), v33 (copy), v34 (copy), v35 (ref), n1 (ref), Fusion (copy), resolveUser (copy), resolveGroup (copy), resolveProduct (copy)
                    if not v35 and v49 == n1 then
                        task.spawn(function() -- line: 318
                            -- upvalues: v47 (copy), v48 (copy), v49 (copy), v58 (copy), v60 (ref), p7 (copy), v33 (copy), v34 (copy), v35 (ref), n1 (ref), Fusion (copy), resolveUser (copy), resolveGroup (copy), resolveProduct (copy)
                            local v63, v64

                            if v47 == "User" then
                                v63, v64 = resolveUser(v48)
                            elseif v47 == "Group" then
                                v63, v64 = resolveGroup(v48)
                            else
                                v63, v64 = resolveProduct(v48, v58, v60)
                            end

                            if v35 or v49 ~= n1 then
                                return
                            end

                            v33:set(false)

                            local v65 = Fusion.peek(p7.config)

                            if v63 ~= nil then
                                if v65 ~= nil then
                                    local key = v63.key
                                    local v66 = false
                                    local v67

                                    for _, v68 in (Fusion.peek(v65.allItems)) do
                                        if v68.key == key then
                                            v67 = true
                                            v66 = true
                                            break
                                        end
                                    end

                                    if not v66 then
                                        v67 = false
                                    end

                                    if not v67 and v65.setPreview then
                                        v65.setPreview(v63)
                                    end
                                end
                            elseif v47 ~= "User" or tonumber(v48) ~= nil then
                                v34:set(v64 or "")
                            else
                                v34:set("")
                            end
                        end)
                    end
                end)

                return
            end
        end

        v33:set(false)
    end

    p6:Observer(v9):onChange(runResolve)
    p6:Observer(GamePass):onChange(runResolve)
    p6:Observer(p7.config):onChange(function() -- line: 351
        -- upvalues: v9 (copy), GamePass (copy), v33 (copy), v34 (copy)
        v9:set("")
        v34:set("")
        v33:set(false)
        GamePass:set("GamePass")
    end)

    local function makeTypeChip(p20, p21, p22) -- line: 358
        -- upvalues: GamePass (copy), Theme (copy), Children (copy), Pressable (copy)
        local v69 = p20:Computed(function(p23) -- line: 359
            -- upvalues: p21 (copy), GamePass (copy)
            return p23(GamePass) == p21
        end)

        return Pressable(p20, {
            name = "TypeChip_" .. p21,
            automaticSize = Enum.AutomaticSize.XY,
            backgroundColor = p20:Computed(function(p24) -- line: 365
                -- upvalues: v69 (copy), Theme (copy)
                if p24(v69) then
                    return (p24(Theme.Color.Primary))
                end

                return (p24(Theme.Color.Neutral))
            end),
            size = UDim2.fromOffset(0, 0),
            onActivate = function() -- onActivate | line: 369
                -- upvalues: p21 (copy), GamePass (copy)
                GamePass:set(p21)
            end,
            [Children] = {
                p20:New("UICorner")({
                    CornerRadius = UDim.new(0, 6)
                }),
                p20:New("UIPadding")({
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 14),
                    PaddingRight = UDim.new(0, 14)
                }),
                p20:New("TextLabel")({
                    Name = "Label",
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    FontFace = p20:Computed(function(p25) -- line: 384
                        -- upvalues: Theme (copy)
                        return Font.new(p25(Theme.Font.Body), p25(Theme.FontWeight.Body))
                    end),
                    Text = p22,
                    TextColor3 = p20:Computed(function(p26) -- line: 388
                        -- upvalues: v69 (copy), Theme (copy)
                        if p26(v69) then
                            return (p26(Theme.Color.PrimaryContent))
                        end

                        return (p26(Theme.Color.BaseContent))
                    end),
                    TextSize = Theme.TextSize.Subtitle
                })
            }
        })
    end

    local t10 = {
        key = "__cat_custom",
        isHeader = true,
        label = "Custom"
    }
    local t11 = {
        key = "__cat_players",
        isHeader = true,
        label = "In-Game"
    }
    local t12 = {
        key = "__cat_qualifiers",
        isHeader = true,
        label = "Qualifiers"
    }
    local t13 = {
        key = "__cat_presets",
        isHeader = true,
        label = "Presets"
    }

    local function buildGrouped(p27) -- line: 402
        -- upvalues: t10 (copy), t11 (copy), t12 (copy), t13 (copy)
        local t14 = {}
        local t15 = {}
        local t16 = {}
        local t17 = {}

        for _, v72 in p27 do
            local v73 = v72.category or "custom"

            if v73 == "qualifier" then
                table.insert(t16, v72)
            elseif v73 == "player" then
                table.insert(t15, v72)
            elseif v73 == "preset" then
                table.insert(t17, v72)
            else
                table.insert(t14, v72)
            end
        end

        local v74 = (if #t14 > 0 then 1 else 0) + (if #t15 > 0 then 1 else 0) + (if #t16 > 0 then 1 else 0) + (if #t17 > 0 then 1 else 0) > 1
        local t18 = {}

        if #t17 > 0 then
            if v74 then
                table.insert(t18, t13)
            end

            for _, v75 in t17 do
                table.insert(t18, v75)
            end
        end

        if #t14 > 0 then
            if v74 then
                table.insert(t18, t10)
            end

            for _, v76 in t14 do
                table.insert(t18, v76)
            end
        end

        if #t15 > 0 then
            if v74 then
                table.insert(t18, t11)
            end

            for _, v77 in t15 do
                table.insert(t18, v77)
            end
        end

        if #t16 > 0 then
            if v74 then
                table.insert(t18, t12)
            end

            for _, v78 in t16 do
                table.insert(t18, v78)
            end
        end

        return t18
    end

    local v79 = p6:Computed(function(p28) -- line: 444
        -- upvalues: v17 (copy), buildGrouped (copy)
        return (buildGrouped((p28(v17))))
    end)
    local v81 = p6:Computed(function(p29) -- line: 449
        -- upvalues: v22 (copy), buildGrouped (copy)
        return (buildGrouped((p29(v22))))
    end)
    local v83 = p6:Computed(function(p30) -- line: 456
        -- upvalues: v81 (copy)
        local t19 = {}

        for v84, v85 in (p30(v81)) do
            t19[v85] = v84
        end

        return t19
    end)
    local v86 = p6:Computed(function(p31) -- line: 464
        -- upvalues: p7 (copy)
        local v87 = p31(p7.config)

        if not v87 then
            return 0
        end

        local n2 = 0

        for _ in (p31(v87.pendingKeys)) do
            n2 += 1
        end

        return n2
    end)

    local function toggleKey(p32) -- line: 473
        -- upvalues: p7 (copy), Fusion (copy)
        local v88 = Fusion.peek(p7.config)

        if not v88 then
            return
        end

        local v89 = Fusion.peek(v88.pendingKeys)

        if v88.singleSelection and not v89[p32] then
            v88.pendingKeys:set({
                [p32] = true
            })

            if v88.pendingOrderedKeys then
                v88.pendingOrderedKeys:set({
                    p32
                })
            end

            return
        end

        local maxItems = v88.maxItems
        local n3 = 0

        for _ in v89 do
            n3 += 1
        end

        local v90 = table.clone(v89)
        local v91

        if v90[p32] then
            v91 = false
            v90[p32] = nil
        elseif n3 < maxItems then
            v91 = true
            v90[p32] = true
        else
            v91 = false
        end

        v88.pendingKeys:set(v90)

        if v88.pendingOrderedKeys then
            local v92 = Fusion.peek(v88.pendingOrderedKeys)
            local v93 = table.find(v92, p32)
            local v94 = table.clone(v92)

            if v93 then
                table.remove(v94, v93)
            elseif v91 then
                table.insert(v94, p32)
            end

            v88.pendingOrderedKeys:set(v94)
        end
    end

    local function makeRow(p33, p34) -- line: 511
        -- upvalues: p7 (copy), toggleKey (copy), Fusion (copy), Theme (copy), Children (copy), CheckItem (copy), Checkbox (copy), SplitRow (copy), Pressable (copy), Icons (copy)
        if p34.isHeader then
            return p33:New("TextLabel")({
                Name = "CategoryHeader",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                FontFace = p33:Computed(function(p35) -- line: 518
                    -- upvalues: Theme (copy)
                    return Font.new(p35(Theme.Font.Body), p35(Theme.FontWeight.Bold))
                end),
                Text = p34.label,
                TextColor3 = Theme.Color.NeutralContentDark,
                TextSize = Theme.TextSize.Label,
                TextXAlignment = Enum.TextXAlignment.Left,
                [Children] = {
                    p33:New("UIPadding")({
                        PaddingTop = UDim.new(0, 6),
                        PaddingBottom = UDim.new(0, 2),
                        PaddingLeft = UDim.new(0, 4)
                    })
                }
            })
        end

        local v95 = p33:Computed(function(p36) -- line: 536
            -- upvalues: p34 (copy), p7 (copy)
            local v96 = p36(p7.config)

            if v96 then
                return p36(v96.pendingKeys)[p34.key] == true
            end

            return false
        end)
        local v97 = Fusion.peek(p7.config)
        local v98 = if v97 ~= nil and v97.pendingOrderedKeys ~= nil and v97.singleSelection ~= true then p33:Computed(function(p37) -- line: 544
            -- upvalues: p34 (copy), p7 (copy)
            local v99 = p37(p7.config)

            if v99 and v99.pendingOrderedKeys then
                local v100 = p37(v99.pendingOrderedKeys)

                return table.find(v100, p34.key) or nil
            end

            return nil
        end) else nil
        local v101 = Fusion.peek(p7.config)
        local v102 = v101 ~= nil and v101.limitPickerToOneItem == true
        local fontFamily = p34.fontFamily
        local v103 = if fontFamily then Font.new(fontFamily) else nil

        if p34.tagConfig == true then
            local rawValue2 = if typeof(p34.rawValue) == "string" then p34.rawValue else nil
            local header = p34.header or p34.label or p34.key
            local v104 = string.format("<b>%s</b>", header)
            local body = p34.body
            local v105 = if body then body:match("^(%d+)") else nil

            return SplitRow(p33, {
                height = 38,
                name = "TagRow_" .. p34.key,
                left = {
                    name = "TagToggle",
                    fills = true,
                    onActivate = function() -- onActivate | line: 579
                        -- upvalues: p34 (copy), toggleKey (copy)
                        toggleKey(p34.key)
                    end,
                    [Children] = {
                        p33:New("Frame")({
                            Name = "ContentGroup",
                            BackgroundTransparency = 1,
                            Size = UDim2.fromScale(1, 1),
                            [Children] = {
                                p33:New("UIPadding")({
                                    PaddingLeft = UDim.new(0, 12),
                                    PaddingRight = UDim.new(0, 12)
                                }),
                                p33:New("UIListLayout")({
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    VerticalAlignment = Enum.VerticalAlignment.Center,
                                    Padding = UDim.new(0, 10),
                                    SortOrder = Enum.SortOrder.LayoutOrder
                                }),
                                Checkbox(p33, {
                                    layoutOrder = 1,
                                    checked = v95
                                }),
                                p33:New("TextLabel")({
                                    Name = "Label",
                                    BackgroundTransparency = 1,
                                    FontFace = p33:Computed(function(p38) -- line: 607
                                        -- upvalues: Theme (copy)
                                        return Font.new(p38(Theme.Font.Body), p38(Theme.FontWeight.Regular))
                                    end),
                                    LayoutOrder = 2,
                                    RichText = true,
                                    Size = UDim2.new(1, 0, 1, 0),
                                    Text = v104,
                                    TextColor3 = Theme.Color.BaseContent,
                                    TextSize = Theme.TextSize.Subtitle,
                                    TextTruncate = Enum.TextTruncate.SplitWord,
                                    TextXAlignment = Enum.TextXAlignment.Left,
                                    TextYAlignment = Enum.TextYAlignment.Center,
                                    [Children] = {
                                        p33:New("UIFlexItem")({
                                            FlexMode = Enum.UIFlexMode.Fill
                                        })
                                    }
                                }),
                                if v105 then p33:New("Frame")({
                                    Name = "CountBadge",
                                    AutomaticSize = Enum.AutomaticSize.X,
                                    BackgroundColor3 = Theme.Color.NeutralStroke,
                                    LayoutOrder = 3,
                                    Size = UDim2.new(0, 0, 0, 22),
                                    [Children] = {
                                        p33:New("UICorner")({
                                            CornerRadius = UDim.new(1, 0)
                                        }),
                                        p33:New("UIPadding")({
                                            PaddingLeft = UDim.new(0, 6),
                                            PaddingRight = UDim.new(0, 6)
                                        }),
                                        p33:New("UISizeConstraint")({
                                            MinSize = Vector2.new(22, 0)
                                        }),
                                        p33:New("UIListLayout")({
                                            FillDirection = Enum.FillDirection.Horizontal,
                                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                            HorizontalFlex = Enum.UIFlexAlignment.None,
                                            VerticalAlignment = Enum.VerticalAlignment.Center,
                                            VerticalFlex = Enum.UIFlexAlignment.None,
                                            SortOrder = Enum.SortOrder.LayoutOrder
                                        }),
                                        p33:New("TextLabel")({
                                            Name = "Count",
                                            BackgroundTransparency = 1,
                                            AutomaticSize = Enum.AutomaticSize.X,
                                            FontFace = p33:Computed(function(p39) -- line: 653
                                                -- upvalues: Theme (copy)
                                                return Font.new(p39(Theme.Font.Body), p39(Theme.FontWeight.Body))
                                            end),
                                            Size = UDim2.new(0, 0, 1, 0),
                                            Text = v105,
                                            TextColor3 = Theme.Color.NeutralContentMain,
                                            TextSize = Theme.TextSize.Small,
                                            TextYAlignment = Enum.TextYAlignment.Center
                                        })
                                    }
                                }) else nil
                            }
                        })
                    }
                },
                right = {
                    name = "ViewCommandsButton",
                    fills = false,
                    onActivate = function() -- onActivate | line: 672
                        -- upvalues: rawValue2 (copy), p7 (copy)
                        if rawValue2 and p7.onOpenViewCommandsForTag then
                            p7.onOpenViewCommandsForTag(rawValue2)
                        end
                    end,
                    [Children] = {
                        p33:New("ImageLabel")({
                            Name = "Icon",
                            BackgroundTransparency = 1,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Image = Icons.Pages.Commands,
                            ImageColor3 = Theme.Color.NeutralContentMain,
                            Position = UDim2.fromScale(0.5, 0.5),
                            Size = UDim2.fromOffset(16, 16)
                        })
                    }
                }
            })
        end

        local t25 = {}

        t25.header = p34.header and p33:Value(p34.header) or nil

        local body = p34.body
        local v111 = if typeof(body) == "table" then p34.body else p34.body and p33:Value(p34.body) or nil

        t25.body = v111
        t25.icon = p34.icon and p33:Value(p34.icon) or nil
        t25.category = p34.category and p33:Value(p34.category) or nil
        t25.colorIndicator = p34.color
        t25.hintIcon = p34.hintIcon
        t25.hintText = p34.hintText
        t25.checked = v95
        t25.labelFont = v103
        t25.orderNumber = v98
        t25.hideCheckbox = v102
        t25.strongSelected = if v102 then v95 else nil

        function t25.onCheck(_) -- line: 708
            -- upvalues: p34 (copy), v102 (copy), p7 (copy), toggleKey (copy), Fusion (copy)
            if not v102 then
                toggleKey(p34.key)

                return
            end

            local v112 = Fusion.peek(p7.config)

            if v112 then
                v112.pendingKeys:set({
                    [p34.key] = true
                })
                v112.onConfirm()
            end

            if p7.onConfirmBack then
                p7.onConfirmBack()
            end
        end

        t25.onRemove = if p34.category == "custom" then function() -- line: 720
            -- upvalues: p34 (copy), p7 (copy), Fusion (copy)
            local v113 = Fusion.peek(p7.config)

            if v113 and v113.onRemoveCustomUser then
                v113.onRemoveCustomUser(p34.key)
            end
        end else nil

        local v114 = CheckItem(p33, t25)

        if p34.groupConfig == true then
            local v115 = p34.roleLabel or "All Roles"

            local function getLiveRawValue() -- line: 732
                -- upvalues: p34 (copy)
                return p34.rawValue
            end

            local rawValue = p34.rawValue
            local v116 = typeof(rawValue) == "table"
            local v117 = if v116 then typeof(rawValue.groupId) == "number" else nil
            local groupId = if not v116 or not v117 then nil else rawValue.groupId

            return p33:New("Frame")({
                Name = "GroupConfigItem",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                [Children] = {
                    p33:New("UIListLayout")({
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    v114,
                    p33:New("Frame")({
                        Name = "ConfigInput",
                        LayoutOrder = 1,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = Theme.Color.Base,
                        Size = UDim2.fromScale(1, 0),
                        Visible = v95,
                        [Children] = {
                            p33:New("UICorner")({
                                CornerRadius = UDim.new(0, 6)
                            }),
                            p33:New("UIStroke")({
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Color = Theme.Color.NeutralStroke
                            }),
                            p33:New("UIPadding")({
                                PaddingBottom = UDim.new(0, 6),
                                PaddingLeft = UDim.new(0, 6),
                                PaddingRight = UDim.new(0, 10),
                                PaddingTop = UDim.new(0, 6)
                            }),
                            p33:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                Padding = UDim.new(0, 8),
                                SortOrder = Enum.SortOrder.LayoutOrder
                            }),
                            Pressable(p33, {
                                name = "CogButton",
                                size = UDim2.fromOffset(30, 30),
                                backgroundColor = Theme.Color.Neutral,
                                layoutOrder = 0,
                                iconImage = Icons.SettingsCogFill,
                                iconSize = 16,
                                onActivate = function() -- onActivate | line: 781
                                    -- upvalues: p34 (copy), groupId (copy), p7 (copy)
                                    if groupId and p7.onOpenConfigureGroupRoles then
                                        p7.onOpenConfigureGroupRoles(groupId, p34.rawValue)
                                    end
                                end,
                                [Children] = {
                                    p33:New("UICorner")({
                                        CornerRadius = UDim.new(0, 6)
                                    }),
                                    p33:New("UIAspectRatioConstraint")({
                                        Name = "UIAspectRatioConstraint",
                                        AspectType = Enum.AspectType.ScaleWithParentSize,
                                        DominantAxis = Enum.DominantAxis.Height
                                    })
                                }
                            }),
                            p33:New("TextLabel")({
                                Name = "RoleLabel",
                                LayoutOrder = 1,
                                AutomaticSize = Enum.AutomaticSize.Y,
                                BackgroundTransparency = 1,
                                Size = UDim2.fromScale(1, 0),
                                FontFace = p33:Computed(function(p41) -- line: 801
                                    -- upvalues: Theme (copy)
                                    return Font.new(p41(Theme.Font.Body), p41(Theme.FontWeight.Body))
                                end),
                                Text = v115,
                                TextColor3 = Theme.Color.NeutralContentDark,
                                TextSize = Theme.TextSize.Subtitle,
                                TextTruncate = Enum.TextTruncate.SplitWord,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                [Children] = {
                                    p33:New("UIFlexItem")({
                                        FlexMode = Enum.UIFlexMode.Fill
                                    })
                                }
                            })
                        }
                    })
                }
            })
        end

        if p34.productConfig == true then
            local rawValue = p34.rawValue
            local v123 = if typeof(rawValue) == "table" then tostring(rawValue.type or "") .. ": " .. tostring(rawValue.id or "") else ""

            return p33:New("Frame")({
                Name = "ProductConfigItem",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                [Children] = {
                    p33:New("UIListLayout")({
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    v114,
                    p33:New("Frame")({
                        Name = "ConfigInput",
                        LayoutOrder = 1,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = Theme.Color.Base,
                        Size = UDim2.fromScale(1, 0),
                        Visible = v95,
                        [Children] = {
                            p33:New("UICorner")({
                                CornerRadius = UDim.new(0, 6)
                            }),
                            p33:New("UIStroke")({
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Color = Theme.Color.NeutralStroke
                            }),
                            p33:New("UIPadding")({
                                PaddingBottom = UDim.new(0, 11),
                                PaddingLeft = UDim.new(0, 10),
                                PaddingRight = UDim.new(0, 10),
                                PaddingTop = UDim.new(0, 11)
                            }),
                            p33:New("TextLabel")({
                                Name = "ProductLabel",
                                BackgroundTransparency = 1,
                                AutomaticSize = Enum.AutomaticSize.Y,
                                Size = UDim2.fromScale(1, 0),
                                FontFace = p33:Computed(function(p42) -- line: 862
                                    -- upvalues: Theme (copy)
                                    return Font.new(p42(Theme.Font.Body), p42(Theme.FontWeight.Body))
                                end),
                                Text = v123,
                                TextColor3 = Theme.Color.NeutralContentDark,
                                TextSize = Theme.TextSize.Subtitle,
                                TextTruncate = Enum.TextTruncate.SplitWord,
                                TextXAlignment = Enum.TextXAlignment.Left
                            })
                        }
                    })
                }
            })
        end

        local configurable = p34.configurable

        if not configurable then
            return v114
        end

        local v127 = Fusion.peek(p7.config)
        local v128 = v127 and v127.configurableValues
        local v129 = p33:Value(v128 and Fusion.peek(v128)[p34.key] or "")

        p33:Observer(v129):onChange(function() -- line: 887
            -- upvalues: p34 (copy), v128 (copy), v129 (copy), Fusion (copy)
            local v130 = Fusion.peek(v129)
            local v131 = v130:gsub("%s", "")

            if v131 ~= v130 then
                task.defer(function() -- line: 891
                    -- upvalues: v131 (copy), v129 (copy)
                    v129:set(v131)
                end)

                return
            end

            if v128 then
                local v132 = Fusion.peek(v128)
                local v133 = table.clone(v132)

                v133[p34.key] = v131
                v128:set(v133)
            end
        end)

        local v134 = configurable == "epochTime"
        local t30 = {
            p33:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p33:New("UIPadding")({
                PaddingBottom = UDim.new(0, 11),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, v134 and 122 or 10),
                PaddingTop = UDim.new(0, 11)
            }),
            p33:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            })
        }

        if v134 then
            table.insert(t30, p33:New("TextButton")({
                Name = "FillCurrentTime",
                AnchorPoint = Vector2.new(1, 0.5),
                AutoLocalize = false,
                BackgroundColor3 = Theme.Color.NeutralContent,
                Position = UDim2.new(1, 112, 0.5, 0),
                Size = UDim2.fromOffset(104, 26),
                FontFace = p33:Computed(function(p43) -- line: 925
                    -- upvalues: Theme (copy)
                    return Font.new(p43(Theme.Font.Body), p43(Theme.FontWeight.Body))
                end),
                Text = "Fill Current Time",
                TextColor3 = Theme.Color.BaseContent,
                TextSize = Theme.TextSize.Small,
                [Fusion.OnEvent("Activated")] = function() -- line: 931
                    -- upvalues: v129 (copy)
                    v129:set((tostring(os.time())))
                end,
                [Children] = {
                    p33:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    })
                }
            }))
        end

        return p33:New("Frame")({
            Name = "ConfigurableItem",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            [Children] = {
                p33:New("UIListLayout")({
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                v114,
                p33:New("Frame")({
                    Name = "ConfigInput",
                    LayoutOrder = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                    Visible = v95,
                    [Children] = {
                        p33:New("TextBox")({
                            Name = "ConfigTextBox",
                            AutoLocalize = false,
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundColor3 = Theme.Color.Base,
                            ClearTextOnFocus = false,
                            ClipsDescendants = true,
                            FontFace = p33:Computed(function(p44) -- line: 966
                                -- upvalues: Theme (copy)
                                return Font.new(p44(Theme.Font.Body), p44(Theme.FontWeight.Body))
                            end),
                            PlaceholderColor3 = Theme.Color.NeutralContentDark,
                            PlaceholderText = configurable,
                            Size = UDim2.fromScale(1, 0),
                            Text = v129,
                            TextColor3 = Theme.Color.NeutralContentMain,
                            TextSize = Theme.TextSize.Subtitle,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            [Fusion.OnChange("Text")] = function(p45) -- line: 976
                                -- upvalues: v129 (copy)
                                v129:set(p45)
                            end,
                            [Children] = t30
                        })
                    }
                })
            }
        })
    end

    local Primary = Theme.Color.Primary
    local v137 = p6:Computed(function(p46) -- line: 989
        -- upvalues: Theme (copy)
        local v138 = p46(Theme.Color.Primary)
        local v139, v140, v141 = Color3.toHSV(v138)
        local v144 = Color3.fromHSV(v139, v140 * 0.92, (math.min(v141 * 1.06, 1)))

        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, v144),
            ColorSequenceKeypoint.new(1, v138)
        })
    end)
    local PrimaryContent = Theme.Color.PrimaryContent
    local Frame = p6:New("Frame")
    local t35 = {
        Name = "ItemSelectorPage",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1
    }
    local Frame2 = p6:New("Frame")
    local t36 = {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v145 = p6:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local Frame3 = p6:New("Frame")
    local t37 = {
        Name = "ListArea",
        LayoutOrder = 1,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0)
    }
    local v146 = p6:New("UIFlexItem")({
        FlexMode = Enum.UIFlexMode.Fill
    })
    local v147 = p6:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local t38 = {
        layoutOrder = 1,
        paddingRight = 10,
        isReady = p6:Computed(function(p47) -- line: 1032
            -- upvalues: p7 (copy)
            return p47(p7.config) ~= nil
        end),
        items = v79,
        visibleItems = v81,
        renderItem = function(p48, p49) -- renderItem | line: 1040
            -- upvalues: v14 (copy), v83 (copy), makeRow (copy), Fusion (copy)
            local v148 = makeRow(p48, p49)

            if v148 and Fusion.peek(v14) ~= true then
                p48:Observer(v83):onBind(function() -- line: 1044
                    -- upvalues: p49 (copy), v148 (copy), v83 (copy), Fusion (copy)
                    local v149 = Fusion.peek(v83)[p49]

                    if v149 and v148.LayoutOrder ~= v149 then
                        v148.LayoutOrder = v149
                    end
                end)
            end

            return v148
        end,
        padding = UDim.new(0, 8),
        idle = p7.idle,
        useStream = v14,
        headerGap = UDim.new(0, 12)
    }
    local Frame4 = p6:New("Frame")
    local t39 = {
        Name = "HeaderWrapper",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0)
    }
    local v150 = p6:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local Frame5 = p6:New("Frame")
    local t40 = {
        Name = "TypeChips",
        LayoutOrder = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        Visible = p6:Computed(function(p50) -- line: 1078
            -- upvalues: v31 (copy)
            return p50(v31) == "Product"
        end)
    }
    local t41 = {
        p6:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.None,
            VerticalFlex = Enum.UIFlexAlignment.None,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    }

    for v151, v152 in t1 do
        local v153 = makeTypeChip(p6, v152.id, v152.label)

        v153.LayoutOrder = v151
        table.insert(t41, v153)
    end

    t40[Children] = t41
    t39[Children] = {
        v150,
        Frame5(t40),
        SearchBar(p6, {
            layoutOrder = 1,
            searchText = v9,
            placeholderText = v37
        }),
        p6:New("TextLabel")({
            Name = "StatusLabel",
            LayoutOrder = 2,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            FontFace = p6:Computed(function(p51) -- line: 1110
                -- upvalues: Theme (copy)
                return Font.new(p51(Theme.Font.Body), p51(Theme.FontWeight.Regular))
            end),
            Text = p6:Computed(function(p52) -- line: 1113
                -- upvalues: v33 (copy), v34 (copy)
                if p52(v33) then
                    return "Searching..."
                end

                return (p52(v34))
            end),
            TextColor3 = p6:Computed(function(p53) -- line: 1117
                -- upvalues: v33 (copy), Theme (copy)
                if p53(v33) then
                    return p53(Theme.Color.NeutralContentDark)
                end

                return p53(Theme.Color.Error)
            end),
            TextSize = Theme.TextSize.Label,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = p6:Computed(function(p54) -- line: 1123
                -- upvalues: v33 (copy), v34 (copy)
                return p54(v33) or #p54(v34) > 0
            end),
            [Children] = {
                p6:New("UIPadding")({
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    PaddingBottom = UDim.new(0, 4)
                })
            }
        }),
        p6:New("TextLabel")({
            Name = "EmptyState",
            LayoutOrder = 3,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            FontFace = p6:Computed(function(p55) -- line: 1141
                -- upvalues: Theme (copy)
                return Font.new(p55(Theme.Font.Body), p55(Theme.FontWeight.Regular))
            end),
            Text = p6:Computed(function(p56) -- line: 1144
                -- upvalues: v31 (copy)
                local v157 = p56(v31)

                if v157 == "Group" then
                    return "No groups yet. Search a group ID above to add"
                end

                if v157 == "Product" then
                    return "No products yet. Pick a type and search an ID above"
                end

                return "Nobody here yet. Search a name or ID above to add"
            end),
            TextColor3 = Theme.Color.NeutralContentDark,
            TextSize = Theme.TextSize.Subtitle,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            Visible = p6:Computed(function(p57) -- line: 1154
                -- upvalues: p7 (copy), v10 (copy)
                if p57(v10) then
                    local v158 = p57(p7.config)

                    if v158 then
                        return #p57(v158.allItems) == 0
                    end
                end

                return false
            end),
            [Children] = {
                p6:New("UIPadding")({
                    PaddingTop = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 4)
                })
            }
        })
    }
    t38.header = Frame4(t39)
    t37[Children] = {
        v146,
        v147,
        ScrollList(p6, t38)
    }
    t36[Children] = {
        v145,
        Frame3(t37),
        p6:New("Frame")({
            Name = "Divider",
            LayoutOrder = 2,
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = Theme.Color.NeutralStroke,
            Visible = p6:Computed(function(p58) -- line: 1179
                -- upvalues: v12 (copy)
                return not p58(v12)
            end)
        }),
        p6:New("Frame")({
            Name = "BottomBar",
            LayoutOrder = 3,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            Visible = p6:Computed(function(p59) -- line: 1188
                -- upvalues: v12 (copy)
                return not p59(v12)
            end),
            [Children] = {
                p6:New("UIPadding")({
                    Name = "UIPadding",
                    PaddingBottom = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 0),
                    PaddingRight = UDim.new(0, 0),
                    PaddingTop = UDim.new(0, 14)
                }),
                Pressable(p6, {
                    name = "ConfirmButton",
                    automaticSize = Enum.AutomaticSize.Y,
                    backgroundColor = Primary,
                    size = UDim2.fromScale(1, 0),
                    onActivate = function() -- onActivate | line: 1205
                        -- upvalues: p7 (copy), Fusion (copy)
                        local v162 = Fusion.peek(p7.config)

                        if v162 and v162.onConfirm then
                            v162.onConfirm()
                        end

                        if p7.onConfirmBack then
                            p7.onConfirmBack()
                        end
                    end,
                    [Children] = {
                        p6:New("UICorner")({
                            CornerRadius = UDim.new(0, 6)
                        }),
                        p6:New("UIPadding")({
                            PaddingTop = UDim.new(0, 8),
                            PaddingBottom = UDim.new(0, 8),
                            PaddingLeft = UDim.new(0, 24),
                            PaddingRight = UDim.new(0, 24)
                        }),
                        p6:New("UIStroke")({
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            Color = Color3.new(1, 1, 1),
                            [Children] = {
                                p6:New("UIGradient")({
                                    Rotation = 90,
                                    Color = v137
                                })
                            }
                        }),
                        p6:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            SortOrder = Enum.SortOrder.LayoutOrder
                        }),
                        p6:New("TextLabel")({
                            Name = "Label",
                            BackgroundTransparency = 1,
                            RichText = true,
                            AutomaticSize = Enum.AutomaticSize.XY,
                            Size = UDim2.fromOffset(0, 0),
                            FontFace = p6:Computed(function(p60) -- line: 1244
                                -- upvalues: Theme (copy)
                                return Font.new(p60(Theme.Font.Body), p60(Theme.FontWeight.Body))
                            end),
                            Text = p6:Computed(function(p61) -- line: 1248
                                -- upvalues: v86 (copy)
                                local v167 = p61(v86)

                                if v167 == 0 then
                                    return "Confirm"
                                end

                                return (string.format("Confirm (%d)", v167))
                            end),
                            TextColor3 = PrimaryContent,
                            TextSize = Theme.TextSize.Subtitle
                        })
                    }
                })
            }
        })
    }
    t35[Children] = { Frame2(t36) }

    return Frame(t35)
end
