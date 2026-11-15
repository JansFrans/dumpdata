-- https://lua.expert

local Parent = require(script.Parent)
local deferringHumanoids, deferringHumanoidsComplete = Parent.deferringHumanoids, Parent.deferringHumanoidsComplete
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local n1 = 0
local t1 = {
    BackAccessory = true,
    FaceAccessory = true,
    FrontAccessory = true,
    HairAccessory = true,
    HatAccessory = true,
    NeckAccessory = true,
    ShouldersAccessory = true,
    WaistAccessory = true
}

local function withoutDuplicateAccessories(p1) -- line: 23
    local t2 = {}
    local t3 = {}

    for i = #p1, 1, -1 do
        local v1 = p1[i]
        local AssetId = if typeof(v1) == "table" then v1.AssetId else nil

        if AssetId ~= nil then
            local v2 = ("%*-%*"):format(AssetId, (tostring(v1.AccessoryType)))

            if not t2[v2] then
                t2[v2] = true
                table.insert(t3, 1, v1)
            end
        end
    end

    return t3
end

return function(p2, p3, p4) -- line: 44
    -- upvalues: deferringHumanoids (copy), deferringHumanoidsComplete (copy), Modules (copy), n1 (ref), t1 (copy), withoutDuplicateAccessories (copy)
    if typeof(p2) ~= "Instance" or not p2:IsA("Humanoid") then
        return nil
    end

    local v3 = p4

    if typeof(p4) == "Instance" and p4:IsA("HumanoidDescription") then
        local Template = require(Modules.Serializer.Serializables.HumanoidDescription).Template

        v3 = {}

        for v4, _ in Template do
            if not v3[v4] and not t1[v4] then
                v3[v4] = p4[v4]
            end
        end

        v3._Accessories = p4:GetAccessories(true)
    end

    local function createBaseDesc(p5) -- line: 66
        -- upvalues: n1 (ref)
        if p5:GetAttribute("BaseDescriptionUID") then
            return p5:Clone()
        end

        n1 += 1
        p5:SetAttribute("BaseDescriptionUID", n1)

        return p5:Clone()
    end

    local v6 = deferringHumanoids[p2]

    if v6 then
        if v3 then
            table.insert(v6.array, v3)
        end

        return v6.baseDesc
    end

    local v7 = p3
    local v8

    if p3 then
        if not p3:GetAttribute("BaseDescriptionUID") then
            n1 += 1
            p3:SetAttribute("BaseDescriptionUID", n1)
        end

        v8 = p3:Clone()
        v7 = v8
    else
        local AppliedDescription = p2:GetAppliedDescription()

        v8 = AppliedDescription
        v7 = AppliedDescription
    end

    local t4 = {
        array = { v3 },
        baseDesc = v8
    }

    deferringHumanoids[p2] = t4
    deferringHumanoidsComplete[p2] = t4
    task.defer(function() -- line: 109
        -- upvalues: p2 (copy), p3 (copy), v7 (ref), t4 (copy), deferringHumanoids (copy), deferringHumanoidsComplete (copy), t1 (copy), withoutDuplicateAccessories (copy)
        local v10 = v7:GetAccessories(false)
        local t5 = {}
        local n2 = 0
        local v11 = false

        for _, v12 in t4.array do
            local v13 = v10
            local v14 = n2
            local v15 = v11

            for v16, v17 in v12 do
                if v16 == "_Accessories" and type(v17) == "table" then
                    local v18 = v14

                    for _, v19 in v17 do
                        v18 += 1
                        v14 = v18
                        table.insert(v13, v19)
                    end
                elseif v16 == "_ClearAccessories" and v17 == true then
                    v14 += 1
                    v13 = {}
                    v15 = true
                else
                    t5[v16] = v17
                end

                v11 = v15
                v10 = v13
                n2 = v14
            end
        end

        if n2 > 0 then
            v7:SetAccessories(withoutDuplicateAccessories(v10), true)
        end

        if v11 then
            for v21, _ in t1 do
                v7[v21] = ""
            end
        end

        for v23, v24 in t5 do
            v7[v23] = v24
        end

        deferringHumanoids[p2] = nil

        local function v26() -- line: 148
            -- upvalues: p2 (copy), v7 (ref)
            p2:ApplyDescription(v7, Enum.AssetTypeVerification.Always)
        end

        pcall(v26)
        deferringHumanoidsComplete[p2] = nil

        if p3 then
            v7:Destroy()
        end
    end)

    return v7
end
