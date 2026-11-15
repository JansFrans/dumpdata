-- https://lua.expert

local Players = game:GetService("Players")
local AvatarEditorService = game:GetService("AvatarEditorService")
local MarketplaceService = game:GetService("MarketplaceService")
local AssetService = game:GetService("AssetService")
local LocalPlayer = Players.LocalPlayer
local t1 = {
    [2] = "GraphicTShirt",
    [11] = "Shirt",
    [12] = "Pants"
}
local t2 = {
    [8] = Enum.AccessoryType.Hat,
    [41] = Enum.AccessoryType.Hair,
    [42] = Enum.AccessoryType.Face,
    [43] = Enum.AccessoryType.Neck,
    [44] = Enum.AccessoryType.Shoulder,
    [45] = Enum.AccessoryType.Front,
    [46] = Enum.AccessoryType.Back,
    [47] = Enum.AccessoryType.Waist,
    [64] = Enum.AccessoryType.TShirt,
    [65] = Enum.AccessoryType.Shirt,
    [66] = Enum.AccessoryType.Pants,
    [67] = Enum.AccessoryType.Jacket,
    [68] = Enum.AccessoryType.Sweater,
    [69] = Enum.AccessoryType.Shorts,
    [70] = Enum.AccessoryType.LeftShoe,
    [71] = Enum.AccessoryType.RightShoe,
    [72] = Enum.AccessoryType.DressSkirt
}
local t3 = {
    [64] = true,
    [65] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [70] = true,
    [71] = true,
    [72] = true
}
local v1 = false
local v2

AvatarEditorService.PromptSaveAvatarCompleted:Connect(function(p1) -- line: 80
    -- upvalues: v1 (ref), v2 (ref)
    v1 = false

    local v3 = v2

    v2 = nil

    if v3 then
        v3(p1)
    end
end)

local t5 = {}
local t4 = {}

function t4.classify(p2, p3) -- line: 96
    -- upvalues: MarketplaceService (copy), AssetService (copy), t1 (copy), t2 (copy), t5 (copy)
    local v4 = t5[p2]

    if v4 then
        return v4
    end

    local t6

    if p3 == Enum.MarketplaceProductType.AvatarBundle then
        local function v5() -- line: 103
            -- upvalues: p2 (copy), AssetService (copy)
            return AssetService:GetBundleDetailsAsync(p2)
        end

        local ok, result = pcall(v5)

        t6 = {
            kind = "bundle",
            typeLabel = "bundle",
            name = if ok and typeof(result) == "table" and result.Name then result.Name else "bundle",
            assetId = p2
        }
    else
        local function v6() -- line: 109
            -- upvalues: p2 (copy), MarketplaceService (copy)
            return MarketplaceService:GetProductInfo(p2, Enum.InfoType.Asset)
        end

        local ok, result = pcall(v6)

        if ok and typeof(result) == "table" then
            local AssetTypeId = result.AssetTypeId
            local v7, v8

            if AssetTypeId == 61 then
                v7 = "emote"
                v8 = "emote"
            elseif t2[AssetTypeId] then
                v7 = "accessory"
                v8 = "accessory"
            elseif t1[AssetTypeId] then
                v7 = "clothing"
                v8 = "clothing"
            end

            t6 = {
                name = result.Name or "item",
                assetId = p2,
                kind = v7,
                assetTypeId = AssetTypeId,
                typeLabel = v8
            }
        else
            t6 = {
                name = "item",
                assetId = p2
            }
        end
    end

    t5[p2] = t6

    return t6
end

function t4.gamePassName(p4) -- line: 137
    -- upvalues: MarketplaceService (copy)
    local function v9() -- line: 138
        -- upvalues: p4 (copy), MarketplaceService (copy)
        return MarketplaceService:GetProductInfo(p4, Enum.InfoType.GamePass)
    end

    local ok, result = pcall(v9)

    if ok and typeof(result) == "table" and result.Name then
        return result.Name
    end

    return "gamepass"
end

local function buildDescription(p5, p6) -- line: 146
    -- upvalues: t1 (copy), t2 (copy), t3 (copy)
    if p6.kind == "emote" then
        local EquippedEmotes = p5:GetEquippedEmotes()
        local t7 = {}

        for _, v10 in EquippedEmotes do
            t7[v10.Slot] = true
        end

        local v11

        for i = 1, 8 do
            if not t7[i] then
                v11 = i
                break
            end
        end

        if not v11 then
            return false, "wheelFull"
        end

        local v12 = p6.name == ""
        local name = if not v12 then p6.name else nil

        if v12 or not name then
            name = "Emote " .. tostring(p6.assetId)
        end

        p5:AddEmote(name, p6.assetId)
        table.insert(EquippedEmotes, {
            Slot = v11,
            Name = name,
            Id = p6.assetId
        })
        p5:SetEquippedEmotes(EquippedEmotes)
    elseif p6.kind == "accessory" then
        local v13 = p6.assetTypeId and t2[p6.assetTypeId]

        if not v13 then
            return false, "error"
        end

        local v14 = p6.assetTypeId ~= nil and t3[p6.assetTypeId] == true
        local Accessories = p5:GetAccessories(true)
        local n1 = 0

        for _, v15 in Accessories do
            if typeof(v15.Order) == "number" and n1 < v15.Order then
                n1 = v15.Order
            end
        end

        local t9 = {
            AssetId = p6.assetId,
            AccessoryType = v13
        }

        if v14 then
            t9.IsLayered = true
            t9.Order = n1 + 1
        end

        table.insert(Accessories, t9)
        p5:SetAccessories(Accessories, true)
    else
        if p6.kind ~= "clothing" then
            return false, "error"
        end

        local v16 = p6.assetTypeId and t1[p6.assetTypeId]

        if not v16 then
            return false, "error"
        end

        p5[v16] = p6.assetId
    end

    return true, nil
end

local function fetchBundleDescription(p7) -- line: 203
    -- upvalues: Players (copy), AssetService (copy)
    local function v17() -- line: 204
        -- upvalues: p7 (copy), Players (copy), AssetService (copy)
        local Id

        for _, v18 in AssetService:GetBundleDetailsAsync(p7).Items do
            if v18.Type == "UserOutfit" then
                Id = v18.Id
                break
            end
        end

        if not Id then
            error("Bundle has no outfit")
        end

        return Players:GetHumanoidDescriptionFromOutfitId(Id)
    end

    local ok, result = pcall(v17)

    return if ok and typeof(result) == "Instance" then result else nil
end

function t4.equip(p8) -- line: 225
    -- upvalues: Players (copy), AvatarEditorService (copy), AssetService (copy), LocalPlayer (copy), v1 (ref), v2 (ref), buildDescription (copy)
    if v1 then
        return "busy"
    end

    v1 = true

    local function release(p9) -- line: 230
        -- upvalues: v1 (ref)
        v1 = false

        return p9
    end

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        local RigType = Humanoid.RigType
        local result, result2

        if p8.kind == "bundle" then
            local assetId = p8.assetId

            local function v19() -- line: 204
                -- upvalues: assetId (copy), Players (copy), AssetService (copy)
                local Id

                for _, v20 in AssetService:GetBundleDetailsAsync(assetId).Items do
                    if v20.Type == "UserOutfit" then
                        Id = v20.Id
                        break
                    end
                end

                if not Id then
                    error("Bundle has no outfit")
                end

                return Players:GetHumanoidDescriptionFromOutfitId(Id)
            end

            local ok

            ok, result = pcall(v19)

            if not ok or typeof(result) ~= "Instance" then
                result = nil
            end

            if not result then
                v1 = false

                return "error"
            end

            result2 = result
        else
            local function v21() -- line: 254
                -- upvalues: Players (copy), LocalPlayer (copy)
                return Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
            end

            local ok

            ok, result = pcall(v21)

            if not ok or typeof(result) ~= "Instance" then
                v1 = false

                return "error"
            end

            result2 = result

            local v22, v23 = buildDescription(result, p8)

            if not v22 then
                local v24 = v23 or "error"

                v1 = false

                return v24
            end
        end

        local result3 = result

        local function v25() -- line: 270
            -- upvalues: result2 (ref), AvatarEditorService (copy)
            return AvatarEditorService:ConformToAvatarRulesAsync(result2)
        end

        local ok, result4 = pcall(v25)

        if ok and typeof(result4) == "Instance" then
            result3 = result4
        end

        local v26
        local v27 = false

        v2 = function(p10) -- line: 280
            -- upvalues: v26 (ref), v27 (ref)
            v26 = p10
            v27 = true
        end

        local function v28() -- line: 284
            -- upvalues: RigType (copy), result3 (ref), AvatarEditorService (copy)
            AvatarEditorService:PromptSaveAvatar(result3, RigType)
        end

        if pcall(v28) then
            local elapsed = os.clock()

            while not v27 and os.clock() - elapsed < 120 do
                task.wait()
            end

            if v27 then
                local Success = Enum.AvatarPromptResult.Success

                if v26 == Success then
                    return "success"
                end

                local PermissionDenied = Enum.AvatarPromptResult.PermissionDenied

                if v26 == PermissionDenied then
                    return "declined"
                end
            else
                v2 = nil
                v1 = false
            end

            return "failed"
        end

        v2 = nil
        v1 = false

        return "error"
    end

    v1 = false

    return "noCharacter"
end

return t4
