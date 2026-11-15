-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Prompt = require(Modules.Prompt)

require(Modules.Objects.Task)

local Players = game:GetService("Players")
local getHumanoid = require(Modules.PlayerUtil.getHumanoid)
local getDescription = require(Modules.OutfitUtil.getDescription)
local applyDescription = require(Modules.OutfitUtil.applyDescription)
local AssetService = game:GetService("AssetService")

game:GetService("ReplicatedStorage")

local t1 = {}
local t2 = {}

local function getWebsiteDescriptionAsync(p1) -- line: 16
    -- upvalues: Players (copy), t2 (copy)
    local Name, _ = p1.Name, p1.Character
    local v1 = t2[Name]

    if not v1 then
        local function v2() -- line: 21
            -- upvalues: p1 (copy), Players (copy)
            return Players:GetHumanoidDescriptionFromUserId(p1.UserId)
        end

        local ok, result = pcall(v2)

        if not ok then
            return false, result
        end

        t2[Name] = result
        p1:GetPropertyChangedSignal("Parent"):Once(function() -- line: 29
            -- upvalues: Name (copy), result (copy), t2 (copy)
            t2[Name] = nil
            result:Destroy()
        end)
        v1 = result
    end

    return true, v1
end

local function getBundleDescriptionAsync(p2) -- line: 37
    -- upvalues: Players (copy), AssetService (copy), t1 (copy)
    local v3 = tostring(p2)
    local v4 = t1[v3]

    if v4 then
        return true, v4
    end

    local function v5() -- line: 43
        -- upvalues: p2 (copy), AssetService (copy)
        return AssetService:GetBundleDetailsAsync(p2)
    end

    local ok, result = pcall(v5)

    if not ok then
        return false, (tostring(result))
    end

    local Id, Id2

    for _, v6 in result.Items do
        if v6.Type == "UserOutfit" then
            local Id3 = v6.Id

            Id = Id3
            Id2 = Id3
            break
        end
    end

    if not Id2 then
        return false, "Missing Bundle Outfit"
    end

    local function v7() -- line: 59
        -- upvalues: Id (ref), Players (copy)
        return Players:GetHumanoidDescriptionFromOutfitId(Id)
    end

    local ok2, result2 = pcall(v7)

    if not ok2 or not result2 then
        return false, (tostring(result2))
    end

    t1[v3] = result2

    return true, result2
end

local function getFinalDescriptionAsync(p3, p4, p5) -- line: 69
    -- upvalues: getHumanoid (copy), getWebsiteDescriptionAsync (copy), getBundleDescriptionAsync (copy)
    local v8 = getHumanoid(p3)

    if v8 then
        v8:UnequipTools()
    end

    local v9 = p5 and p5.IgnoreAccessories
    local t3 = {}

    if typeof(v9) == "table" then
        for _, v10 in v9 do
            t3[v10] = true
        end
    end

    local v11 = p5 and p5.IgnoreBodyParts
    local t4 = {}

    if typeof(v11) == "table" then
        for _, v12 in v11 do
            t4[v12] = true
        end
    end

    local v13 = p5 and p5.RemoveBodyParts
    local t5 = {}

    if typeof(v13) == "table" then
        for _, v14 in v13 do
            t5[v14] = true
        end
    end

    local v15, v16 = getWebsiteDescriptionAsync(p3)

    if not v15 or not v16 then
        return false, (tostring(v16))
    end

    local v17, v18 = getBundleDescriptionAsync(p4)

    if not v17 or typeof(v18) ~= "Instance" then
        return false, (tostring(v18))
    end

    local clone = v18:Clone()

    for _, child in v16:GetChildren() do
        if child:IsA("AccessoryDescription") then
            local Name = child.AccessoryType.Name

            if v9 ~= true and not t3[Name] then
                child:Clone().Parent = clone
            end
        elseif child:IsA("BodyPartDescription") then
            local Name = child.BodyPart.Name

            if v11 ~= true and not t4[Name] then
                local child2

                for _, child3 in clone:GetChildren() do
                    if child3:IsA("BodyPartDescription") and child3.BodyPart == child.BodyPart then
                        child2 = child3
                    end
                end

                if child2 then
                    child2.Color = child.Color
                else
                    child:Clone().Parent = clone
                end
            end

            if t5[Name] then
                clone[Name] = v16[Name]
            end
        end
    end

    for _, v19 in {
            "ClimbAnimation",
            "FallAnimation",
            "IdleAnimation",
            "JumpAnimation",
            "MoodAnimation",
            "RunAnimation",
            "SwimAnimation",
            "WalkAnimation",
            "GraphicTShirt",
            "Pants",
            "Shirt"
        } do
        clone[v19] = v16[v19]
    end

    local function splitByCapitals(p6) -- line: 146
        return p6:gsub("(%u)", " %1"):gsub("^%s", ""):split(" ")
    end

    if p5 then
        for v20, v21 in p5 do
            if v20:sub(1, 5) == "Scale" then
                for _, v22 in (tostring(v20:sub(6)):gsub("(%u)", " %1"):gsub("^%s", ""):split(" ")) do
                    clone[v22 .. "Scale"] = v21
                end
            end
        end
    end

    local _ = p3.Character

    if getHumanoid(p3) then
        return true, clone
    end

    return false, "Missing Humanoid"
end

local function runBundleId(p7, p8, p9) -- line: 171
    -- upvalues: Prompt (copy), getHumanoid (copy), getDescription (copy), applyDescription (copy), getFinalDescriptionAsync (copy)
    if p9 then
        local _ = p9.Aliases
    end

    local target = p7.target

    if target then
        local v23, v24 = getFinalDescriptionAsync(target, p8, p9)

        if not v23 or typeof(v24) ~= "Instance" then
            Prompt.warn(p7.caller, (tostring(v24)))
        else
            p7:keep("UntilTargetRespawns")
            p7:buff(target, "Outfit", -10, function(p10, p11) -- line: 184
                -- upvalues: target (copy), v24 (copy), getHumanoid (copy), getDescription (copy), applyDescription (copy)
                if p10 then
                    v24:Destroy()
                end

                local v25 = getHumanoid(target)

                if not v25 then
                    return
                end

                local v26 = p11 or getDescription(v25)

                if p10 then
                    applyDescription(v25, v26)
                else
                    applyDescription(v25, p11, v24)
                end

                return v26
            end)
        end
    else
        Prompt.warn(p7.caller, "No target player found.")
    end
end

return runBundleId
