-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local GroupService = game:GetService("GroupService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local isInternalRole = require(Modules.RoleUtil.isInternalRole)
local Children = Fusion.Children
local Popup = require(UI.Components.Popup)
local Pressable = require(UI.Components.Pressable)
local RoleBadge = require(UI.Components.RoleBadge)
local Presets = require(UI.Config.Presets)
local promptPurchaseAsync = require(Modules.AssetUtil.promptPurchaseAsync)
local ClientGroupJoin = require(Modules.Parent.Controllers.ClientGroupJoin)
local v1 = Fusion.scoped({
    Value = Fusion.Value
}):Value({})
local t1 = {}

local function fetchGiverInfo(p1) -- line: 51
    -- upvalues: MarketplaceService (copy), GroupService (copy), Fusion (copy), v1 (copy), t1 (copy)
    local v2 = ("%*:%*"):format(p1.kind, p1.id)

    if t1[v2] or Fusion.peek(v1)[v2] then
        return
    end

    t1[v2] = true
    task.spawn(function() -- line: 56
        -- upvalues: p1 (copy), v2 (copy), MarketplaceService (copy), GroupService (copy), Fusion (copy), v1 (copy)
        local Name, v3

        if p1.kind == "Group" then
            local function v4() -- line: 60
                -- upvalues: p1 (copy), GroupService (copy)
                return GroupService:GetGroupInfoAsync(p1.id)
            end

            local ok, result = pcall(v4)

            if ok and typeof(result) == "table" and typeof(result.Name) == "string" then
                Name = result.Name
            end
        else
            local function v5() -- line: 67
                -- upvalues: p1 (copy), MarketplaceService (copy)
                return MarketplaceService:GetProductInfo(p1.id, p1.infoType)
            end

            local ok, result = pcall(v5)

            if ok and typeof(result) == "table" then
                Name = if typeof(result.Name) == "string" then result.Name else nil
                v3 = tonumber(result.PriceInRobux)
            end
        end

        local v6 = Fusion.peek(v1)
        local v7 = table.clone(v6)

        v7[v2] = {
            name = Name,
            price = v3
        }
        v1:set(v7)
    end)
end

local function listGivers(p2) -- line: 84
    -- upvalues: Presets (copy)
    local t2 = {}
    local t3 = {}

    local function add(p3, p4, p5) -- line: 87
        -- upvalues: t2 (copy), t3 (copy)
        local v8 = ("%*:%*"):format(p3, p4)

        if t3[v8] then
            return
        end

        t3[v8] = true
        table.insert(t2, {
            kind = p3,
            id = p4,
            infoType = p5
        })
    end

    if typeof(p2) == "table" then
        local giveToProducts = p2.giveToProducts

        if typeof(giveToProducts) == "table" then
            for _, v9 in giveToProducts do
                if typeof(v9) == "table" then
                    local type, id = v9.type, v9.id

                    if type == "GamePass" and typeof(id) == "number" then
                        local GamePass = Enum.InfoType.GamePass
                        local v10 = ("GamePass:%*"):format(id)

                        if not t3[v10] then
                            t3[v10] = true
                            table.insert(t2, {
                                kind = "GamePass",
                                id = id,
                                infoType = GamePass
                            })
                        end
                    elseif type == "Asset" and typeof(id) == "number" then
                        local Asset = Enum.InfoType.Asset
                        local v11 = ("Asset:%*"):format(id)

                        if not t3[v11] then
                            t3[v11] = true
                            table.insert(t2, {
                                kind = "Asset",
                                id = id,
                                infoType = Asset
                            })
                        end
                    elseif type == "Bundle" and typeof(id) == "number" then
                        local Bundle = Enum.InfoType.Bundle
                        local v12 = ("Bundle:%*"):format(id)

                        if not t3[v12] then
                            t3[v12] = true
                            table.insert(t2, {
                                kind = "Bundle",
                                id = id,
                                infoType = Bundle
                            })
                        end
                    elseif type == "Preset" and typeof(v9.preset) == "string" then
                        local v13 = Presets.products[v9.preset]

                        if v13 and typeof(v13.id) == "number" then
                            local infoType = v13.infoType

                            if infoType == Enum.InfoType.GamePass then
                                local id = v13.id
                                local v14 = ("GamePass:%*"):format(id)

                                if not t3[v14] then
                                    t3[v14] = true
                                    table.insert(t2, {
                                        kind = "GamePass",
                                        id = id,
                                        infoType = infoType
                                    })
                                end
                            elseif infoType == Enum.InfoType.Asset then
                                local id = v13.id
                                local v15 = ("Asset:%*"):format(id)

                                if not t3[v15] then
                                    t3[v15] = true
                                    table.insert(t2, {
                                        kind = "Asset",
                                        id = id,
                                        infoType = infoType
                                    })
                                end
                            elseif infoType == Enum.InfoType.Bundle then
                                local id = v13.id
                                local v16 = ("Bundle:%*"):format(id)

                                if not t3[v16] then
                                    t3[v16] = true
                                    table.insert(t2, {
                                        kind = "Bundle",
                                        id = id,
                                        infoType = infoType
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end

        local giveToGroups = p2.giveToGroups

        if typeof(giveToGroups) == "table" then
            for _, v17 in giveToGroups do
                if typeof(v17) == "table" and typeof(v17.groupId) == "number" then
                    local groupId = v17.groupId
                    local v18 = ("Group:%*"):format(groupId)

                    if not t3[v18] then
                        t3[v18] = true
                        table.insert(t2, {
                            kind = "Group",
                            infoType = nil,
                            id = groupId
                        })
                    end
                end
            end
        end
    end

    return t2
end

local function escapeRich(p6) -- line: 129
    return (p6:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function giverImageUrl(p7) -- line: 133
    return (("rbxthumb://type=%*&id=%*&w=150&h=150"):format(if p7.kind == "Group" then "GroupIcon"
        elseif p7.kind == "GamePass" then "GamePass"
        elseif p7.kind == "Bundle" then "BundleThumbnail"
        else "Asset", p7.id))
end

return function(p8, p9) -- line: 143
    -- upvalues: Theme (copy), isInternalRole (copy), Children (copy), Popup (copy), Pressable (copy), RoleBadge (copy), promptPurchaseAsync (copy), ClientGroupJoin (copy), v1 (copy), fetchGiverInfo (copy), listGivers (copy)
    local v19 = p8:Computed(function(p10) -- line: 144
        -- upvalues: p9 (copy)
        local v20 = p10(p9.roleInfoFuse)
        local v21 = p10(p9.roleKey)

        return if typeof(v20) == "table" and typeof(v21) == "string" then v20[v21] else nil
    end)
    local v22 = p8:Computed(function(p11) -- line: 150
        -- upvalues: p9 (copy), v19 (copy)
        local v23 = p11(v19)
        local v24 = typeof(v23) == "table"
        local v25 = if v24 then typeof(v23.name) == "string" else nil

        if v24 and v25 then
            return v23.name
        end

        local v26 = p11(p9.roleKey)

        if typeof(v26) == "string" then
            return v26
        end

        return ""
    end)
    local v27 = p8:Computed(function(p12) -- line: 158
        -- upvalues: v19 (copy)
        local v28 = p12(v19)

        if not (typeof(v28) == "table" and typeof(v28.color) == "Color3") then
            return Color3.fromRGB(161, 161, 170)
        end

        return v28.color
    end)
    local v31 = p8:Computed(function(p13) -- line: 165
        -- upvalues: p9 (copy)
        local v32 = p13(p9.youMemberFuse)
        local v33 = p13(p9.roleKey)
        local v34 = typeof(v32) == "table"
        local v35 = if v34 then typeof(v32.roleKeys) == "table" else nil

        if v34 and v35 then
            for _, v36 in v32.roleKeys do
                if v36 == v33 then
                    return true
                end
            end
        end

        return false
    end)
    local v37 = p8:Computed(function(p14) -- line: 174
        -- upvalues: v19 (copy), listGivers (copy)
        return (listGivers(p14(v19)))
    end)
    local v38 = p8:Computed(function(p15) -- line: 177
        -- upvalues: p9 (copy)
        local t12 = {
            total = 0,
            usable = 0,
            viaKey = nil
        }
        local v39 = p15(p9.commandsFuse)
        local v40 = p15(p9.roleKey)

        if typeof(v39) == "table" and typeof(v40) == "string" then
            local v41 = p15(p9.youMemberFuse)
            local t13 = {}

            if typeof(v41) == "table" and typeof(v41.roleKeys) == "table" then
                for _, v42 in v41.roleKeys do
                    if v42 ~= v40 then
                        t13[v42] = true
                    end
                end
            end

            local t14 = {}

            for _, v43 in v39 do
                local roles = v43.roles

                if typeof(roles) == "table" then
                    local v44 = false

                    for _, v45 in roles do
                        if v45 == v40 then
                            v44 = true
                            break
                        end
                    end

                    if v44 then
                        t12.total += 1

                        local v46 = false

                        for _, v47 in roles do
                            if t13[v47] then
                                v46 = true
                                t14[v47] = (t14[v47] or 0) + 1
                            end
                        end

                        if v46 then
                            t12.usable += 1
                        end
                    end
                end
            end

            local v48 = p15(p9.roleInfoFuse)
            local n1 = -1
            local n2 = 0

            for v49, v50 in t14 do
                local v51 = typeof(v48) == "table" and typeof(v48[v49]) == "table" and tonumber(v48[v49].rank) or 0

                if n2 < v50 or v50 == n2 and n1 < v51 then
                    n2 = v50
                    t12.viaKey = v49
                    n1 = v51
                end
            end

            if n2 < t12.total then
                t12.viaKey = nil
            end
        end

        return t12
    end)
    local v53 = p8:Computed(function(p16) -- line: 235
        -- upvalues: v19 (copy)
        local v54 = p16(v19)

        if typeof(v54) == "table" then
            return v54.inheritCommandsFromJuniorRoles == true
        end

        return false
    end)
    local v55 = p8:Computed(function(p17) -- line: 239
        -- upvalues: p9 (copy), v19 (copy), isInternalRole (copy)
        local v56 = p17(v19)

        if typeof(v56) ~= "table" or v56.inheritCommandsFromJuniorRoles ~= true then
            return {}
        end

        local v57 = p17(p9.roleInfoFuse)

        if typeof(v57) ~= "table" then
            return {}
        end

        local v58 = tonumber(v56.rank) or 0
        local t15 = {}

        for v59, v60 in v57 do
            if typeof(v59) == "string" and typeof(v60) == "table" and not isInternalRole(v60) and typeof(v60.rank) == "number" and not (v58 <= v60.rank) then
                table.insert(t15, {
                    key = v59,
                    name = if typeof(v60.name) == "string" then v60.name else v59,
                    color = if typeof(v60.color) == "Color3" then v60.color else Color3.fromRGB(161, 161, 170),
                    rank = v60.rank
                })
            end
        end

        table.sort(t15, function(p18, p19) -- line: 257
            if p18.rank == p19.rank then
                return p18.key < p19.key
            end

            return p18.rank > p19.rank
        end)

        return t15
    end)

    local function sectionTitle(p20, p21) -- line: 263
        -- upvalues: p8 (copy), Theme (copy)
        return p8:New("TextLabel")({
            Name = "SectionTitle",
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            FontFace = p8:Computed(function(p22) -- line: 268
                -- upvalues: Theme (copy)
                return Font.new(p22(Theme.Font.Body), p22(Theme.FontWeight.Bold))
            end),
            LayoutOrder = p21,
            Size = UDim2.fromScale(1, 0),
            Text = p20,
            TextColor3 = Theme.Color.NeutralContentDark,
            TextSize = Theme.TextSize.Label,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end

    local v71 = p8:New("TextLabel")({
        Name = "Status",
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        RichText = true,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        FontFace = p8:Computed(function(p23) -- line: 284
            -- upvalues: Theme (copy)
            return Font.new(p23(Theme.Font.Body), p23(Theme.FontWeight.Body))
        end),
        Size = UDim2.fromScale(1, 0),
        Text = p8:Computed(function(p24) -- line: 290
            -- upvalues: p9 (copy), v19 (copy), v22 (copy), v27 (copy), v31 (copy), v37 (copy), v38 (copy)
            if p24(v31) then
                return "You have this role!"
            end

            local v61 = p24(v38)

            if v61.viaKey ~= nil and v61.total > 0 and v61.usable >= v61.total then
                local v63 = p24(p9.roleInfoFuse)
                local v62 = if typeof(v63) == "table" then v63[v61.viaKey] else nil
                local v64 = typeof(v62) == "table"
                local v65 = if v64 then typeof(v62.name) == "string" else nil
                local v66 = if not v64 or not v65 then v61.viaKey else v62.name
                local v67 = typeof(v62) == "table"
                local v68 = if v67 then typeof(v62.color) == "Color3" else nil
                local v69 = ("<b><font color=\"#%*\">%*</font></b>"):format(if not v67 or not v68 then "ffffff" else v62.color:ToHex(), (v66:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))

                return (("You don't own %* but can use with your role %*"):format(("<b><font color=\"#%*\">%*</font></b>"):format(p24(v27):ToHex(), (p24(v22):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))), v69))
            end

            local v70 = p24(v19)

            if typeof(v70) ~= "table" then
                v70 = nil
            end

            if v70 and v70.giveToEveryone == true then
                return "This role is given to everyone"
            end

            if #p24(v37) ~= 0 then
                return "You don't own this role yet"
            end

            if not v70 or v70.giveToPrivateServerOwner ~= true then
                return "This role can't be unlocked"
            end

            return "This role is given to the private server owner"
        end),
        TextColor3 = p8:Computed(function(p25) -- line: 319
            -- upvalues: v27 (copy), v31 (copy), Theme (copy)
            if p25(v31) then
                return (p25(v27))
            end

            return (p25(Theme.Color.NeutralContentDark))
        end),
        TextSize = Theme.TextSize.Body,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v73 = p8:New("TextLabel")({
        Name = "CommandCount",
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        FontFace = p8:Computed(function(p26) -- line: 331
            -- upvalues: Theme (copy)
            return Font.new(p26(Theme.Font.Body), p26(Theme.FontWeight.Regular))
        end),
        Size = UDim2.fromScale(1, 0),
        Text = p8:Computed(function(p27) -- line: 336
            -- upvalues: v38 (copy), v53 (copy), v55 (copy)
            local total = p27(v38).total
            local v72 = ("Unlocks %* command%*"):format(total, if total == 1 then "" else "s")

            if not (p27(v53) and #p27(v55) > 0) then
                return v72
            end

            return (("%* including from these junior roles:"):format(v72))
        end),
        TextColor3 = Theme.Color.BaseContent,
        TextSize = Theme.TextSize.Body,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v87 = p8:New("Frame")({
        Name = "UnlockSection",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.fromScale(1, 0),
        Visible = p8:Computed(function(p28) -- line: 356
            -- upvalues: v37 (copy)
            return #p28(v37) > 0
        end),
        [Children] = {
            p8:New("UIListLayout")({
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalFlex = Enum.UIFlexAlignment.None,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            }),
            sectionTitle(p8:Computed(function(p29) -- line: 366
                -- upvalues: v31 (copy)
                if p29(v31) then
                    return "Unlocked via:"
                end

                return "How to unlock:"
            end), 1),
            p8:New("Frame")({
                Name = "GiverRows",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Size = UDim2.fromScale(1, 0),
                [Children] = {
                    p8:New("UIListLayout")({
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        VerticalFlex = Enum.UIFlexAlignment.None,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 8)
                    }),
                    p8:ForValues(v37, function(_, p31, p32) -- line: 382
                        -- upvalues: Theme (copy), Children (copy), Pressable (copy), promptPurchaseAsync (copy), ClientGroupJoin (copy), v1 (copy), fetchGiverInfo (copy)
                        fetchGiverInfo(p32)

                        local v75 = ("%*:%*"):format(p32.kind, p32.id)
                        local v76 = p31:Computed(function(p33) -- line: 385
                            -- upvalues: p32 (copy), v75 (copy), v1 (copy)
                            local v77 = p33(v1)[v75]
                            local v78 = if v77 then typeof(v77.name) == "string" else nil

                            if not v77 or not v78 then
                                return (("%* %*"):format(p32.kind, p32.id))
                            end

                            return v77.name
                        end)
                        local kind = p32.kind
                        local v79 = p31:Computed(function(p34) -- line: 393
                            -- upvalues: p32 (copy), v75 (copy), v1 (copy)
                            if p32.kind == "Group" then
                                return "Join"
                            end

                            local v80 = p34(v1)[v75]
                            local price = if v80 then v80.price else nil

                            if typeof(price) == "number" and price > 0 then
                                return ((" %*"):format(price))
                            end

                            if v80 then
                                return "Free"
                            end

                            return "..."
                        end)

                        return p31:New("Frame")({
                            Name = ("Giver_%*"):format(v75),
                            BackgroundColor3 = Theme.Color.NeutralContent,
                            Size = UDim2.new(1, 0, 0, 48),
                            [Children] = {
                                p31:New("UICorner")({
                                    CornerRadius = UDim.new(0, 6)
                                }),
                                p31:New("UIStroke")({
                                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                    Color = Theme.Color.NeutralStroke
                                }),
                                p31:New("UIListLayout")({
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalFlex = Enum.UIFlexAlignment.None,
                                    VerticalFlex = Enum.UIFlexAlignment.None,
                                    VerticalAlignment = Enum.VerticalAlignment.Center,
                                    SortOrder = Enum.SortOrder.LayoutOrder,
                                    Padding = UDim.new(0, 10)
                                }),
                                p31:New("UIPadding")({
                                    PaddingLeft = UDim.new(0, 8),
                                    PaddingRight = UDim.new(0, 8)
                                }),
                                p31:New("ImageLabel")({
                                    Name = "Icon",
                                    BackgroundColor3 = Theme.Color.Neutral,
                                    LayoutOrder = 1,
                                    Size = UDim2.fromOffset(34, 34),
                                    Image = ("rbxthumb://type=%*&id=%*&w=150&h=150"):format(if p32.kind == "Group" then "GroupIcon"
                                        elseif p32.kind == "GamePass" then "GamePass"
                                        elseif p32.kind == "Bundle" then "BundleThumbnail"
                                        else "Asset", p32.id),
                                    [Children] = {
                                        p31:New("UICorner")({
                                            CornerRadius = UDim.new(0, 6)
                                        })
                                    }
                                }),
                                p31:New("Frame")({
                                    Name = "Labels",
                                    AutomaticSize = Enum.AutomaticSize.Y,
                                    BackgroundTransparency = 1,
                                    LayoutOrder = 2,
                                    Size = UDim2.fromScale(0, 0),
                                    [Children] = {
                                        p31:New("UIFlexItem")({
                                            FlexMode = Enum.UIFlexMode.Fill
                                        }),
                                        p31:New("UIListLayout")({
                                            HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                            VerticalFlex = Enum.UIFlexAlignment.None,
                                            SortOrder = Enum.SortOrder.LayoutOrder,
                                            Padding = UDim.new(0, 2)
                                        }),
                                        p31:New("TextLabel")({
                                            Name = "GiverName",
                                            BackgroundTransparency = 1,
                                            LayoutOrder = 1,
                                            AutomaticSize = Enum.AutomaticSize.Y,
                                            FontFace = p31:Computed(function(p35) -- line: 454
                                                -- upvalues: Theme (copy)
                                                return Font.new(p35(Theme.Font.Body), p35(Theme.FontWeight.Body))
                                            end),
                                            Size = UDim2.fromScale(1, 0),
                                            Text = v76,
                                            TextColor3 = Theme.Color.BaseContent,
                                            TextSize = Theme.TextSize.Body,
                                            TextTruncate = Enum.TextTruncate.AtEnd,
                                            TextXAlignment = Enum.TextXAlignment.Left
                                        }),
                                        p31:New("TextLabel")({
                                            Name = "GiverSubtitle",
                                            BackgroundTransparency = 1,
                                            LayoutOrder = 2,
                                            AutomaticSize = Enum.AutomaticSize.Y,
                                            FontFace = p31:Computed(function(p36) -- line: 469
                                                -- upvalues: Theme (copy)
                                                return Font.new(p36(Theme.Font.Body), p36(Theme.FontWeight.Regular))
                                            end),
                                            Size = UDim2.fromScale(1, 0),
                                            Text = kind,
                                            TextColor3 = Theme.Color.NeutralContentDark,
                                            TextSize = Theme.TextSize.Label,
                                            TextXAlignment = Enum.TextXAlignment.Left
                                        })
                                    }
                                }),
                                Pressable(p31, {
                                    name = "PromptGiver",
                                    layoutOrder = 3,
                                    size = UDim2.fromOffset(78, 28),
                                    backgroundColor = Theme.Color.Primary,
                                    onActivate = function() -- onActivate | line: 488
                                        -- upvalues: p32 (copy), promptPurchaseAsync (copy), ClientGroupJoin (copy)
                                        if p32.kind == "Group" then
                                            ClientGroupJoin.promptAndVerify(p32.id)
                                        else
                                            task.spawn(promptPurchaseAsync, p32.id, nil, p32.infoType)
                                        end
                                    end,
                                    [Children] = {
                                        p31:New("UICorner")({
                                            CornerRadius = UDim.new(0, 6)
                                        }),
                                        p31:New("TextLabel")({
                                            Name = "Label",
                                            BackgroundTransparency = 1,
                                            FontFace = p31:Computed(function(p37) -- line: 500
                                                -- upvalues: Theme (copy)
                                                return Font.new(p37(Theme.Font.Body), p37(Theme.FontWeight.Bold))
                                            end),
                                            Size = UDim2.fromScale(1, 1),
                                            Text = v79,
                                            TextColor3 = Theme.Color.PrimaryContent,
                                            TextSize = Theme.TextSize.Label,
                                            TextXAlignment = Enum.TextXAlignment.Center,
                                            TextYAlignment = Enum.TextYAlignment.Center
                                        })
                                    }
                                })
                            }
                        })
                    end)
                }
            })
        }
    })
    local v88 = p8:New("Frame")({
        Name = "JuniorBadges",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 4,
        Size = UDim2.fromScale(1, 0),
        Visible = p8:Computed(function(p38) -- line: 526
            -- upvalues: v53 (copy), v55 (copy)
            return p38(v53) and #p38(v55) > 0
        end),
        [Children] = {
            p8:New("UIListLayout")({
                Wraps = true,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.None,
                VerticalFlex = Enum.UIFlexAlignment.None,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p8:ForValues(v55, function(_, p40, p41) -- line: 540
                -- upvalues: Theme (copy), RoleBadge (copy)
                return RoleBadge(p40, {
                    large = true,
                    id = p40:Value(p41.key),
                    name = p40:Value(p41.name),
                    color = p40:Value(p41.color),
                    backgroundColor = Theme.Color.NeutralContent
                })
            end)
        }
    })

    return Popup(p8, {
        visible = p9.visible,
        title = v22,
        titleContent = RoleBadge(p8, {
            large = true,
            id = p9.roleKey,
            name = v22,
            color = v27,
            backgroundColor = Theme.Color.NeutralContent
        }),
        content = { v71, v87, v73, v88 }
    })
end
