-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Presets = require(UI.Config.Presets)
local isInternalRole = require(Modules.RoleUtil.isInternalRole)
local GroupService = game:GetService("GroupService")
local MarketplaceService = game:GetService("MarketplaceService")

local function infoTypeSubtype(p1) -- line: 45
    if p1 == Enum.InfoType.GamePass then
        return "GamePass"
    end

    if p1 == Enum.InfoType.Asset then
        return "Asset"
    end

    if p1 == Enum.InfoType.Bundle then
        return "Bundle"
    end

    if p1 == Enum.InfoType.Subscription then
        return "Subscription"
    end

    return if p1 == Enum.InfoType.Product then "Asset" else nil
end

local function extractGivers(p2) -- line: 55
    -- upvalues: Presets (copy), isInternalRole (copy)
    if typeof(p2) ~= "table" then
        return {}
    end

    local t1 = {}
    local t2 = {}

    local function ensure(p3, p4, p5) -- line: 60
        -- upvalues: t1 (copy), t2 (copy)
        local v1 = p3 .. ":" .. p4
        local v2 = t1[v1]

        if v2 then
            return v2
        end

        local t3 = {
            type = p3,
            id = p4,
            name = p5,
            roleKeys = {}
        }

        t1[v1] = t3
        table.insert(t2, v1)

        return t3
    end

    local function addRole(p6, p7) -- line: 74
        for _, v3 in p6.roleKeys do
            if v3 == p7 then
                return
            end
        end

        table.insert(p6.roleKeys, p7)
    end

    for v4, v5 in p2 do
        if typeof(v4) == "string" and typeof(v5) == "table" and not isInternalRole(v5) then
            local giveToGroups = v5.giveToGroups

            if typeof(giveToGroups) == "table" then
                for _, v6 in giveToGroups do
                    if typeof(v6) == "table" then
                        local v7 = v6.groupId or v6.id

                        if v7 ~= nil then
                            local v8 = tostring(v7)
                            local v9 = ensure("Group", v8, v6.name or v6.label or ("Group %*"):format(v8))
                            local v10 = false

                            for _, v11 in v9.roleKeys do
                                if v11 == v4 then
                                    v10 = true
                                    break
                                end
                            end

                            if not v10 then
                                table.insert(v9.roleKeys, v4)
                            end
                        end
                    end
                end
            end

            local giveToProducts = v5.giveToProducts

            if typeof(giveToProducts) == "table" then
                for _, v12 in giveToProducts do
                    if typeof(v12) == "table" then
                        if v12.type == "Preset" then
                            local preset = v12.preset

                            if typeof(preset) == "string" then
                                local v13 = Presets.products[preset]
                                local v14 = preset

                                if v13 and typeof(v13.label) == "string" then
                                    v14 = v13.label
                                end

                                local v15 = ensure("ProductPreset", preset, v14)

                                if v13 and v15.subtype == nil then
                                    local infoType = v13.infoType

                                    if infoType == Enum.InfoType.GamePass then
                                        v15.subtype = "GamePass"
                                    elseif infoType == Enum.InfoType.Asset then
                                        v15.subtype = "Asset"
                                    elseif infoType == Enum.InfoType.Bundle then
                                        v15.subtype = "Bundle"
                                    elseif infoType == Enum.InfoType.Subscription then
                                        v15.subtype = "Subscription"
                                    elseif infoType == Enum.InfoType.Product then
                                        v15.subtype = "Asset"
                                    else
                                        v15.subtype = nil
                                    end
                                end

                                local v16 = false

                                for _, v17 in v15.roleKeys do
                                    if v17 == v4 then
                                        v16 = true
                                        break
                                    end
                                end

                                if not v16 then
                                    table.insert(v15.roleKeys, v4)
                                end
                            end
                        else
                            local productId = v12.productId or v12.id or v12.assetId

                            if productId ~= nil then
                                local v18 = tostring(productId)
                                local v19 = ensure("Product", v18, v12.name or v12.label or ("Product %*"):format(v18))

                                if v19.subtype == nil then
                                    local type = v12.type

                                    if type == "GamePass" or type == "Asset" or type == "Bundle" then
                                        v19.subtype = type
                                    end
                                end

                                local v20 = false

                                for _, v21 in v19.roleKeys do
                                    if v21 == v4 then
                                        v20 = true
                                        break
                                    end
                                end

                                if not v20 then
                                    table.insert(v19.roleKeys, v4)
                                end
                            end
                        end
                    end
                end
            end

            if v5.giveToEveryone == true then
                local v22 = t1["Everyone:everyone"]

                if not v22 then
                    v22 = {
                        type = "Everyone",
                        id = "everyone",
                        name = "Everyone",
                        roleKeys = {}
                    }
                    t1["Everyone:everyone"] = v22
                    table.insert(t2, "Everyone:everyone")
                end

                local v23 = false

                for _, v24 in v22.roleKeys do
                    if v24 == v4 then
                        v23 = true
                        break
                    end
                end

                if not v23 then
                    table.insert(v22.roleKeys, v4)
                end
            end

            if v5.giveToPrivateServerOwner == true then
                local v25 = t1["PrivateServerOwner:privateserverowner"]

                if not v25 then
                    v25 = {
                        type = "PrivateServerOwner",
                        id = "privateserverowner",
                        name = "Private Server Owner",
                        roleKeys = {}
                    }
                    t1["PrivateServerOwner:privateserverowner"] = v25
                    table.insert(t2, "PrivateServerOwner:privateserverowner")
                end

                local v26 = false

                for _, v27 in v25.roleKeys do
                    if v27 == v4 then
                        v26 = true
                        break
                    end
                end

                if not v26 then
                    table.insert(v25.roleKeys, v4)
                end
            end

            local giveToFriends = v5.giveToFriends

            if giveToFriends == true then
                local v28 = t1["Friend:friends"]

                if not v28 then
                    v28 = {
                        type = "Friend",
                        id = "friends",
                        name = "Friends",
                        roleKeys = {}
                    }
                    t1["Friend:friends"] = v28
                    table.insert(t2, "Friend:friends")
                end

                local v29 = false

                for _, v30 in v28.roleKeys do
                    if v30 == v4 then
                        v29 = true
                        break
                    end
                end

                if not v29 then
                    table.insert(v28.roleKeys, v4)
                end
            elseif typeof(giveToFriends) == "table" then
                for _, v31 in giveToFriends do
                    if typeof(v31) == "table" then
                        local v32 = v31.userId or v31.id

                        if v32 ~= nil then
                            local v33 = tostring(v32)
                            local name = v31.name or v31.label or ("Friend of %*"):format(v33)
                            local v34 = "Friend" .. ":" .. v33
                            local v35 = t1[v34]

                            if not v35 then
                                v35 = {
                                    type = "Friend",
                                    id = v33,
                                    name = name,
                                    roleKeys = {}
                                }
                                t1[v34] = v35
                                table.insert(t2, v34)
                            end

                            local v36 = false

                            for _, v37 in v35.roleKeys do
                                if v37 == v4 then
                                    v36 = true
                                    break
                                end
                            end

                            if not v36 then
                                table.insert(v35.roleKeys, v4)
                            end
                        end
                    end
                end
            end

            local giveToUsers = v5.giveToUsers

            if typeof(giveToUsers) == "table" then
                for _, v38 in giveToUsers do
                    if typeof(v38) == "table" and v38.type == "Preset" then
                        local preset = v38.preset

                        if typeof(preset) == "string" then
                            local v39 = Presets.users[preset]
                            local v40 = preset

                            if v39 and typeof(v39.label) == "string" then
                                v40 = v39.label
                            end

                            local v41 = "UserPreset" .. ":" .. preset
                            local v42 = t1[v41]

                            if not v42 then
                                v42 = {
                                    type = "UserPreset",
                                    id = preset,
                                    name = v40,
                                    roleKeys = {}
                                }
                                t1[v41] = v42
                                table.insert(t2, v41)
                            end

                            local v43 = false

                            for _, v44 in v42.roleKeys do
                                if v44 == v4 then
                                    v43 = true
                                    break
                                end
                            end

                            if not v43 then
                                table.insert(v42.roleKeys, v4)
                            end
                        end
                    end
                end
            end
        end
    end

    local t4 = {}

    for _, v45 in t2 do
        table.insert(t4, t1[v45])
    end

    return t4
end

local function buildGroupBreakdown(p8, p9) -- line: 180
    -- upvalues: isInternalRole (copy)
    local t5 = {
        groupId = p9,
        sections = {}
    }

    if typeof(p8) == "table" then
        local t6 = {}
        local t7 = {}
        local t8 = {}
        local t9 = {}

        for v47, v48 in p8 do
            if typeof(v47) == "string" and typeof(v48) == "table" and not isInternalRole(v48) then
                local giveToGroups = v48.giveToGroups

                if typeof(giveToGroups) == "table" then
                    for _, v49 in giveToGroups do
                        if typeof(v49) == "table" and tostring(v49.groupId) == p9 then
                            local type = v49.type

                            if type == "AnyMember" then
                                if not t6[v47] then
                                    t6[v47] = true
                                    table.insert(t7, v47)
                                end
                            elseif type == "SpecificRoles" and typeof(v49.roles) == "table" then
                                for _, v50 in v49.roles do
                                    if typeof(v50) == "table" then
                                        local rank, name = v50.rank, v50.name

                                        if typeof(rank) == "number" then
                                            if typeof(name) ~= "string" then
                                                name = ""
                                            end

                                            local v51 = tostring(rank) .. ":" .. name
                                            local v52 = t8[v51]

                                            if v52 == nil then
                                                v52 = {
                                                    rank = rank,
                                                    name = name,
                                                    roleSet = {},
                                                    order = {}
                                                }
                                                t8[v51] = v52
                                                table.insert(t9, v51)
                                            end

                                            if not v52.roleSet[v47] then
                                                v52.roleSet[v47] = true
                                                table.insert(v52.order, v47)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        local function sortHdKeys(p10) -- line: 228
            -- upvalues: p8 (copy)
            table.sort(p10, function(p11, p12) -- line: 229
                -- upvalues: p8 (copy)
                local v54 = typeof(p8[p11]) == "table" and p8[p11].rank or 0
                local v56 = typeof(p8[p12]) == "table" and p8[p12].rank or 0

                if v54 == v56 then
                    return p11 < p12
                end

                return v56 < v54
            end)
        end

        if #t7 > 0 then
            table.sort(t7, function(p13, p14) -- line: 229
                -- upvalues: p8 (copy)
                local v58 = typeof(p8[p13]) == "table" and p8[p13].rank or 0
                local v60 = typeof(p8[p14]) == "table" and p8[p14].rank or 0

                if v58 == v60 then
                    return p13 < p14
                end

                return v60 < v58
            end)
            table.insert(t5.sections, {
                kind = "AllMembers",
                rank = nil,
                name = nil,
                hdAdminRoleKeys = t7
            })
        end

        table.sort(t9, function(p15, p16) -- line: 248
            -- upvalues: t8 (copy)
            local v61 = t8[p15]
            local v62 = t8[p16]

            if v61.rank == v62.rank then
                return v61.name < v62.name
            end

            return v61.rank > v62.rank
        end)

        for _, v63 in t9 do
            local v64 = t8[v63]
            local order = v64.order

            table.sort(order, function(p17, p18) -- line: 229
                -- upvalues: p8 (copy)
                local v66 = typeof(p8[p17]) == "table" and p8[p17].rank or 0
                local v68 = typeof(p8[p18]) == "table" and p8[p18].rank or 0

                if v66 == v68 then
                    return p17 < p18
                end

                return v68 < v66
            end)
            table.insert(t5.sections, {
                kind = "SpecificRole",
                rank = v64.rank,
                name = v64.name,
                hdAdminRoleKeys = v64.order
            })
        end
    end

    return t5
end

local v69 = Fusion.scoped({
    Value = Fusion.Value
}):Value({})
local t12 = {}

local function fetchGroupName(p19) -- line: 273
    -- upvalues: Fusion (copy), GroupService (copy), v69 (copy)
    local v70 = tonumber(p19)

    if not v70 then
        return
    end

    local function v71() -- line: 276
        -- upvalues: v70 (copy), GroupService (copy)
        return GroupService:GetGroupInfoAsync(v70)
    end

    local ok, result = pcall(v71)

    if ok and typeof(result) == "table" and typeof(result.Name) == "string" then
        local v72 = "Group:" .. p19
        local v73 = Fusion.peek(v69)
        local v74 = table.clone(v73)

        v74[v72] = result.Name
        v69:set(v74)
    end
end

local function fetchProductName(p20) -- line: 288
    -- upvalues: Fusion (copy), MarketplaceService (copy), v69 (copy)
    local v75 = tonumber(p20)

    if not v75 then
        return
    end

    local function tryInfo(p21) -- line: 292
        -- upvalues: v75 (copy), MarketplaceService (copy)
        local function v76() -- line: 293
            -- upvalues: p21 (copy), v75 (copy), MarketplaceService (copy)
            return MarketplaceService:GetProductInfo(v75, p21)
        end

        local ok, result = pcall(v76)

        return if ok and typeof(result) == "table" and typeof(result.Name) == "string" then result.Name else nil
    end

    local GamePass = Enum.InfoType.GamePass

    local function v77() -- line: 293
        -- upvalues: v75 (copy), GamePass (copy), MarketplaceService (copy)
        return MarketplaceService:GetProductInfo(v75, GamePass)
    end

    local ok, result = pcall(v77)
    local Name = if not not (ok and typeof(result) == "table" and typeof(result.Name) == "string") then result.Name else nil
    local Name2

    if Name then
        Name2 = Name
    else
        local Asset = Enum.InfoType.Asset

        local function v79() -- line: 293
            -- upvalues: v75 (copy), Asset (copy), MarketplaceService (copy)
            return MarketplaceService:GetProductInfo(v75, Asset)
        end

        local ok, result = pcall(v79)
        local Name = if ok and typeof(result) == "table" and typeof(result.Name) == "string" then result.Name else nil

        if Name then
            Name2 = Name
        else
            local Product = Enum.InfoType.Product

            local function v80() -- line: 293
                -- upvalues: v75 (copy), Product (copy), MarketplaceService (copy)
                return MarketplaceService:GetProductInfo(v75, Product)
            end

            local ok, result = pcall(v80)

            if ok and typeof(result) == "table" and typeof(result.Name) == "string" then
                Name2 = result.Name
            end
        end
    end

    if not Name2 then
        return
    end

    local v81 = "Product:" .. p20
    local v82 = Fusion.peek(v69)
    local v83 = table.clone(v82)

    v83[v81] = Name2
    v69:set(v83)
end

local function ensureFetch(p22, p23) -- line: 311
    -- upvalues: Fusion (copy), v69 (copy), t12 (copy), fetchGroupName (copy), fetchProductName (copy)
    local v84 = p22 .. ":" .. p23

    if not t12[v84] and not Fusion.peek(v69)[v84] then
        t12[v84] = true

        if p22 == "Group" then
            task.spawn(fetchGroupName, p23)
        elseif p22 == "Product" then
            task.spawn(fetchProductName, p23)
        end
    end
end

local function makeNameComputed(p24, p25) -- line: 324
    -- upvalues: v69 (copy), ensureFetch (copy)
    ensureFetch(p25.type, p25.id)

    local v85 = p25.type .. ":" .. p25.id

    return p24:Computed(function(p26) -- line: 327
        -- upvalues: p25 (copy), v85 (copy), v69 (copy)
        return p26(v69)[v85] or p25.name
    end)
end

local function typeLabel(p27) -- line: 333
    if p27.type == "Friend" and p27.id == "friends" then
        return "Friends"
    end

    if p27.type == "UserPreset" then
        return "User Preset"
    end

    if p27.type == "Everyone" or p27.type == "PrivateServerOwner" then
        return "Preset"
    end

    if p27.type == "Product" then
        if typeof(p27.subtype) == "string" then
            return p27.subtype
        end

        return "Product"
    end

    if p27.type ~= "ProductPreset" then
        return p27.type
    end

    if typeof(p27.subtype) == "string" then
        return p27.subtype
    end

    return "Product Preset"
end

local function giverSubtitle(p28) -- line: 346
    -- upvalues: typeLabel (copy)
    local v86 = typeLabel(p28)

    if p28.type == "Friend" and p28.id == "friends" or p28.type == "UserPreset" or p28.type == "ProductPreset" or p28.type == "Everyone" or p28.type == "PrivateServerOwner" then
        return v86
    end

    return v86 .. ": " .. p28.id
end

local function compactSubtitle(p29) -- line: 355
    -- upvalues: typeLabel (copy)
    return (typeLabel(p29))
end

return {
    extract = extractGivers,
    imageUrl = function(p30) -- giverImageUrl | line: 359
        -- upvalues: Presets (copy)
        local id = p30.id

        if p30.type == "Group" then
            return (("rbxthumb://type=GroupIcon&id=%*&w=150&h=150"):format(id))
        end

        if p30.type == "Product" then
            return (("rbxthumb://type=%*&id=%*&w=150&h=150"):format(if p30.subtype == "GamePass" then "GamePass" elseif p30.subtype == "Bundle" then "BundleThumbnail" else "Asset", id))
        end

        if p30.type == "Friend" then
            if id == "friends" then
                return ""
            end

            return (("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(id))
        end

        if p30.type == "Everyone" or p30.type == "PrivateServerOwner" then
            local Creator = Presets.users.Creator
            local v87 = if Creator then typeof(Creator.icon) == "string" else nil

            if not Creator or not v87 then
                return ""
            end

            return Creator.icon
        end

        if p30.type == "UserPreset" then
            local v88 = Presets.users[id]
            local v89 = if v88 then typeof(v88.icon) == "string" else nil

            if not v88 or not v89 then
                return ""
            end

            return v88.icon
        end

        if p30.type ~= "ProductPreset" then
            return ""
        end

        local v90 = Presets.products[id]
        local v91 = if v90 then typeof(v90.icon) == "string" else nil

        if not v90 or not v91 then
            return ""
        end

        return v90.icon
    end,
    subtitleFor = giverSubtitle,
    compactSubtitleFor = compactSubtitle,
    makeNameComputed = makeNameComputed,
    buildGroupBreakdown = buildGroupBreakdown
}
