-- https://lua.expert

local t1 = {}
local MarketplaceService = game:GetService("MarketplaceService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local products = require(Modules.References.products)
local ownsAssetAsync = require(Modules.AssetUtil.ownsAssetAsync)
local areValuesEqual = require(Modules.DataUtil.areValuesEqual)
local t2 = {}

local function getUserTemp(p1) -- line: 21
    -- upvalues: Modules (copy)
    local v1 = require(Modules.Objects.User).getUser(p1)

    return if v1 then v1.temp else nil
end

local function escapeRich(p2) -- line: 27
    return (p2:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function resolveDisplayName(p3) -- line: 31
    -- upvalues: MarketplaceService (copy), products (copy), t2 (copy)
    local v2 = t2[p3]

    if v2 then
        return v2
    end

    local v3 = products[p3]

    if not v3 then
        return p3
    end

    local function v4() -- line: 40
        -- upvalues: v3 (copy), MarketplaceService (copy)
        return MarketplaceService:GetProductInfo(v3.id, v3.infoType)
    end

    local ok, result = pcall(v4)
    local v5 = p3

    if ok and typeof(result) == "table" and typeof(result.Name) == "string" then
        v5 = result.Name
    end

    t2[p3] = v5

    return v5
end

function t1.getProducts(p4) -- line: 53
    local products = if typeof(p4) == "table" then p4.products else nil

    return if typeof(products) == "table" and #products ~= 0 then products else nil
end

function t1.matchesDefault(p5, p6) -- line: 61
    -- upvalues: areValuesEqual (copy)
    local default = p5.default

    if default == nil and typeof(p5.inputObject) == "table" then
        default = p5.inputObject.default
    end

    return areValuesEqual(p6, default)
end

function t1.ownsAnyAsync(p7, p8) -- line: 70
    -- upvalues: Modules (copy), ownsAssetAsync (copy)
    local v6 = require(Modules.Objects.User).getUser(p7)
    local temp = if v6 then v6.temp else nil
    local v7 = if temp then temp:get("OwnedArgProducts") else nil

    if typeof(v7) == "table" then
        for _, v8 in p8 do
            if v7[v8] == true then
                return true
            end
        end
    end

    for _, v9 in p8 do
        local v10, v11 = ownsAssetAsync(v9, p7)

        if v10 and v11 == true then
            if temp then
                if typeof(v7) ~= "table" then
                    v7 = {}
                end

                v7[v9] = true
                temp:set("OwnedArgProducts", v7)
            end

            return true
        end
    end

    return false
end

function t1.sendUnlockNoticeAsync(p9, p10, _, _) -- line: 94
    -- upvalues: Modules (copy), resolveDisplayName (copy)
    local v12 = require(Modules.Objects.User).getUser(p9)
    local temp = if v12 then v12.temp else nil
    local elapsed = os.clock()

    if temp then
        local ArgProductsDenyClock = temp:get("ArgProductsDenyClock")

        if typeof(ArgProductsDenyClock) == "number" and elapsed - ArgProductsDenyClock < 2 then
            return
        end

        temp:set("ArgProductsDenyClock", elapsed)
    end

    local v13 = p10[1]
    local Prompt = require(Modules.Prompt)
    local v14 = ("You need <b>%*</b> for this."):format((resolveDisplayName(v13):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))

    Prompt.info(p9, v14, {
        duration = 0,
        linkButtons = {
            {
                label = "Unlock",
                promptProduct = v13
            }
        }
    })
end

return t1
