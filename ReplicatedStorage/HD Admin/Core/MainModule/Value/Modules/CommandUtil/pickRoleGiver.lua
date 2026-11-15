-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Presets = require(Modules.Parent.Controllers.UI.Config.Presets)

local function classifyProduct(p1) -- line: 27
    -- upvalues: Presets (copy)
    if typeof(p1) ~= "table" then
        return nil, nil, nil
    end

    local type, id = p1.type, p1.id

    if type == "GamePass" and typeof(id) == "number" then
        return "GamePass", id, Enum.InfoType.GamePass
    end

    if type == "Asset" and typeof(id) == "number" then
        return "Asset", id, Enum.InfoType.Asset
    end

    if type == "Bundle" and typeof(id) == "number" then
        return "Bundle", id, Enum.InfoType.Bundle
    end

    if type == "Preset" and typeof(p1.preset) == "string" then
        local v1 = Presets.products[p1.preset]

        if v1 and typeof(v1.id) == "number" then
            local infoType = v1.infoType

            if infoType == Enum.InfoType.GamePass then
                return "GamePass", v1.id, infoType
            end

            if infoType == Enum.InfoType.Asset then
                return "Asset", v1.id, infoType
            end

            if infoType == Enum.InfoType.Bundle then
                return "Bundle", v1.id, infoType
            end
        end
    end

    return nil, nil, nil
end

local function pickRoleGiver(p2, p3) -- line: 51
    -- upvalues: classifyProduct (copy)
    local t1, t2, t3

    if typeof(p2) == "table" then
        local t4, t5, t6

        for _, v2 in p2 do
            local v3, v4, v5 = classifyProduct(v2)

            if v3 == "GamePass" and t4 == nil then
                t4 = {
                    kind = "GamePass",
                    id = v4,
                    infoType = v5
                }
            elseif v3 == "Asset" and t5 == nil then
                t5 = {
                    kind = "Asset",
                    id = v4,
                    infoType = v5
                }
            elseif v3 == "Bundle" and t6 == nil then
                t6 = {
                    kind = "Bundle",
                    id = v4,
                    infoType = v5
                }
            end

            t3 = t6
            t1 = t4
            t2 = t5
        end
    end

    if t1 then
        return t1
    end

    if t2 then
        return t2
    end

    if t3 then
        return t3
    end

    if typeof(p3) == "table" then
        for _, v6 in p3 do
            if typeof(v6) == "table" and typeof(v6.groupId) == "number" then
                return {
                    kind = "Group",
                    groupId = v6.groupId
                }
            end
        end
    end

    return nil
end

return pickRoleGiver
