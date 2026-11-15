-- https://lua.expert

return function(p1, p2) -- line: 1
    local v1 = tonumber(p1)

    if not p1 then
        return false, "Invalid number"
    end

    if math.floor(v1) <= 0 then
        return false, "Invalid asset number"
    end

    local v2 = Enum.InfoType.Asset
    local EnumType = p2.EnumType

    if EnumType == Enum.BundleType then
        v2 = Enum.InfoType.Bundle
    end

    local MarketplaceService = game:GetService("MarketplaceService")

    local function v3() -- line: 16
        -- upvalues: p1 (copy), v2 (ref), MarketplaceService (copy)
        return MarketplaceService:GetProductInfo(p1, v2)
    end

    local ok, result = pcall(v3)

    if not ok then
        return false, (tostring(result))
    end

    local v4 = EnumType == Enum.BundleType
    local v5, v6

    if v4 then
        v5 = result.BundleType == p2.Name
    else
        v6 = result.AssetTypeId == p2.Value
    end

    if (not v4 or v5) and (v4 or v6) then
        return true, result
    end

    return false, (("AssetId is not type '%*'"):format((tostring(p2.Name))))
end
