-- https://lua.expert

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Serializer = require(Modules.Serializer)
local DataStores = require(Modules.DataStores)
local User = require(Modules.Objects.User)
local t1 = {}
local t2 = {}

local function cacheKey(p1, p2) -- line: 29
    return string.format("%d_%d", p1, p2)
end

local function readCache(p3, p4) -- line: 33
    -- upvalues: t2 (copy)
    local v1 = string.format("%d_%d", p3, p4)
    local v2 = t2[v1]

    if v2 then
        if not (os.clock() - v2.fetchedAt > 60) then
            return v2.owned
        end

        t2[v1] = nil
    end

    return nil
end

local function writeCache(p5, p6, p7) -- line: 44
    -- upvalues: t2 (copy)
    t2[string.format("%d_%d", p5, p6)] = {
        owned = p7,
        fetchedAt = os.clock()
    }
end

local function decodeBlob(p8) -- line: 48
    -- upvalues: Serializer (copy)
    local v3 = if typeof(p8) == "string" then Serializer.decompress(p8) else p8

    if typeof(v3) ~= "table" then
        return nil
    end

    if v3._isSerialized == true then
        v3._isSerialized = nil
        v3 = Serializer.deserialize(v3)
    end

    return v3
end

local function writeToOnlinePlayer(p9, p10, p11) -- line: 60
    -- upvalues: User (copy)
    local v4 = User.getUser(p9)

    if v4 and v4.perm then
        local AssetOwnership = v4.perm:get("AssetOwnership")

        if typeof(AssetOwnership) ~= "table" then
            AssetOwnership = {}
        end

        if not AssetOwnership[p10] then
            local n1 = 0

            for _ in AssetOwnership do
                n1 += 1
            end

            if n1 >= 200 then
                local n2 = 1e999
                local v5

                for v6, v7 in AssetOwnership do
                    local savedAt = if typeof(v7) == "table" then v7.savedAt else nil

                    if typeof(savedAt) == "number" and savedAt < n2 then
                        n2 = savedAt
                        v5 = v6
                    end
                end

                if v5 then
                    v4.perm:set("AssetOwnership", v5, nil)
                end
            end
        end

        v4.perm:set("AssetOwnership", p10, {
            owned = p11,
            savedAt = os.time()
        })
    end
end

function t1.check(p12, p13) -- line: 88
    -- upvalues: Players (copy), MarketplaceService (copy), Serializer (copy), DataStores (copy), t2 (copy), writeToOnlinePlayer (copy)
    if typeof(p12) ~= "number" or p12 <= 0 then
        return false
    end

    local owned

    if typeof(p13) ~= "number" or p13 <= 0 then
        return false
    else
        local v9 = string.format("%d_%d", p12, p13)
        local v10 = t2[v9]

        if v10 then
            if os.clock() - v10.fetchedAt > 60 then
                t2[v9] = nil
            else
                owned = v10.owned
            end
        end
    end

    if owned ~= nil then
        return owned
    end

    local v11 = tostring(p13)
    local PlayerByUserId = Players:GetPlayerByUserId(p12)

    if not PlayerByUserId then
        local v12, v13 = DataStores.getAsync("PlayerStore", (tostring(p12)))

        if not v12 then
            t2[string.format("%d_%d", p12, p13)] = {
                owned = false,
                fetchedAt = os.clock()
            }

            return false
        end

        local v14 = if typeof(v13) == "string" then Serializer.decompress(v13) else v13
        local v15

        if typeof(v14) == "table" then
            if v14._isSerialized == true then
                v14._isSerialized = nil
                v15 = Serializer.deserialize(v14)
            else
                v15 = v14
            end
        end

        local perm = if typeof(v15) == "table" then v15.perm else nil
        local AssetOwnership = if typeof(perm) == "table" then perm.AssetOwnership else nil
        local v16 = if typeof(AssetOwnership) == "table" then AssetOwnership[v11] else nil
        local v17 = typeof(v16) == "table" and v16.owned == true

        t2[string.format("%d_%d", p12, p13)] = {
            owned = v17,
            fetchedAt = os.clock()
        }

        return v17
    end

    local PlayerOwnsAsset = MarketplaceService.PlayerOwnsAsset
    local ok, result = pcall(PlayerOwnsAsset, MarketplaceService, PlayerByUserId, p13)
    local v18 = ok and result == true

    t2[string.format("%d_%d", p12, p13)] = {
        owned = v18,
        fetchedAt = os.clock()
    }

    if ok then
        writeToOnlinePlayer(PlayerByUserId, v11, v18)
    end

    return v18
end

function t1.record(p14, p15, p16) -- line: 122
    -- upvalues: t2 (copy), writeToOnlinePlayer (copy)
    if typeof(p14) == "Instance" and p14:IsA("Player") and typeof(p15) == "number" and not (p15 <= 0) then
        writeToOnlinePlayer(p14, tostring(p15), p16)

        local UserId = p14.UserId

        t2[string.format("%d_%d", UserId, p15)] = {
            owned = p16,
            fetchedAt = os.clock()
        }
    end
end

return t1
