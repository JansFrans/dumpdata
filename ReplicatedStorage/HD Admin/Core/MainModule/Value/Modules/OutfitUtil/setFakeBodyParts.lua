-- https://lua.expert

local function createFakeBodyPart(p1, p2) -- line: 1
    local Name, Parent = p2.Name, p2.Parent
    local v1 = Parent and Parent:IsA("Accessory")

    if v1 then
        local HDPartName = Parent:GetAttribute("HDPartName")

        if not HDPartName then
            HDPartName = "Handle" .. math.random(1, 10000) .. Parent.Name
            Parent:SetAttribute("HDPartName", HDPartName)
        end

        Name = HDPartName
    end

    local v2 = p1:FindFirstChild("Fake" .. Name)
    local v3 = v2

    if v2 then
        v2:SetAttribute("DisableMorphPart", true)
        v2:Destroy()
        v3 = nil
        v2 = nil
    end

    local SpecialMesh = p2:FindFirstChildOfClass("SpecialMesh")
    local v4 = Name:gsub(" ", "")
    local v5 = false

    for _, child in p1:GetChildren() do
        if child:IsA("CharacterMesh") and v4:match(child.BodyPart.Name) then
            SpecialMesh = Instance.new("SpecialMesh")
            v5 = true
            SpecialMesh.MeshId = "rbxassetid://" .. child.MeshId
        end
    end

    local v6, v7

    if SpecialMesh then
        local MeshId = SpecialMesh.MeshId
        local v8
        local result = v2

        if not MeshId or MeshId == "" or MeshId == " " then
            v8 = true
        else
            local InsertService = game:GetService("InsertService")

            local function v9() -- line: 42
                -- upvalues: MeshId (copy), InsertService (copy)
                return InsertService:CreateMeshPartAsync(MeshId, Enum.CollisionFidelity.Default, Enum.RenderFidelity.Automatic)
            end

            local ok

            ok, result = pcall(v9)

            if ok and result then
                local Scale = SpecialMesh.Scale

                v3 = result
                result.Size *= Scale
                result.CFrame = p2.CFrame
            else
                result = v2
            end

            v8 = false
        end

        v7 = v8

        if v5 then
            SpecialMesh:Destroy()
        end

        v6 = result
    else
        v6 = v2
        v7 = false
    end

    if not v6 then
        v6 = p2:Clone()
        v3 = v6
    end

    for _, child in v6:GetChildren() do
        if child:IsA("WrapLayer") then
            child.Order -= 20
        elseif child.Name ~= "OriginalSize" or not child:IsA("Vector3Value") or v1 then
            child:Destroy()
        end
    end

    if v7 then
        SpecialMesh:Clone().Parent = v6
    end

    v6.CanCollide = false
    v6.CanTouch = false

    if v6:IsA("MeshPart") then
        v6.TextureID = ""
    end

    v6.Name = "Fake" .. Name

    local WeldConstraint = Instance.new("WeldConstraint")

    WeldConstraint.Part0 = v6
    WeldConstraint.Part1 = p2
    WeldConstraint.Parent = v6
    p2.Transparency = 1

    local t1 = {}
    local Head = p1:FindFirstChild("Head")

    if not v1 or not Head then
        Head = p2
    end

    v6.Color = Head.Color
    v6.Parent = p1
    table.insert(t1, Head:GetPropertyChangedSignal("Color"):Once(function() -- line: 93
        -- upvalues: v3 (ref), Head (ref)
        v3.Color = Head.Color
    end))
    v3.Destroying:Once(function() -- line: 96
        -- upvalues: t1 (copy)
        for _, v12 in t1 do
            v12:Disconnect()
        end
    end)

    return v3
end

local function clearFakeBodyParts(p3) -- line: 104
    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("BasePart") then
            if string.sub(descendant.Name, 1, 4) == "Fake" then
                descendant:SetAttribute("DisableMorphPart", true)
                descendant:Destroy()
            elseif descendant.Name ~= "HumanoidRootPart" then
                descendant.Transparency = 0
            end
        end
    end
end

local function setFakePart(p4, p5, p6) -- line: 117
    -- upvalues: createFakeBodyPart (copy), setFakePart (copy)
    task.defer(function() -- line: 118
        -- upvalues: p4 (copy), p5 (copy), p6 (copy), createFakeBodyPart (copy), setFakePart (copy)
        local Name, Parent = p6.Name, p6.Parent
        local Name2 = if not (Parent and Parent:IsA("Accessory")) then nil else Parent.Name
        local v13 = createFakeBodyPart(p4, p6)
        local t2 = {}

        local function disconnectAll() -- line: 124
            -- upvalues: t2 (copy)
            for _, v14 in t2 do
                v14:Disconnect()
            end
        end

        local function charIsAlive() -- line: 129
            -- upvalues: p4 (copy)
            local Humanoid = p4:FindFirstChildOfClass("Humanoid")

            if p4.Parent == nil or Humanoid == nil then
                return false
            end

            return Humanoid.Health > 0
        end

        local function refakeReplacement() -- line: 133
            -- upvalues: Name (copy), v13 (copy), Name2 (copy), p4 (copy), p5 (copy), setFakePart (copy)
            if v13:GetAttribute("DisableMorphPart") then
                return
            end

            local Humanoid = p4:FindFirstChildOfClass("Humanoid")

            if p4.Parent ~= nil and Humanoid ~= nil and Humanoid.Health > 0 then
                if Name2 then
                    for _ = 1, 40 do
                        for _, child in p4:GetChildren() do
                            if child:IsA("Accessory") and child.Name == Name2 and not child:GetAttribute("HDPartName") and not child:GetAttribute("HDFakeClaimed") then
                                local BasePart = child:FindFirstChildWhichIsA("BasePart")

                                if BasePart then
                                    child:SetAttribute("HDFakeClaimed", true)
                                    setFakePart(p4, p5, BasePart)

                                    return
                                end
                            end
                        end

                        task.wait(0.1)

                        local Humanoid = p4:FindFirstChildOfClass("Humanoid")

                        if p4.Parent == nil or Humanoid == nil or not (Humanoid.Health > 0) then
                            return
                        end
                    end
                else
                    local v15 = p4:WaitForChild(Name, 4)

                    if v15 then
                        setFakePart(p4, p5, v15)
                    end
                end
            end
        end

        table.insert(t2, p6.Destroying:Once(function() -- line: 166
            -- upvalues: v13 (copy), t2 (copy), refakeReplacement (copy)
            for _, v17 in t2 do
                v17:Disconnect()
            end

            v13:Destroy()
            refakeReplacement()
        end))
        table.insert(t2, p6:GetPropertyChangedSignal("Size"):Once(function() -- line: 171
            -- upvalues: v13 (copy), t2 (copy), p4 (copy), p5 (copy), p6 (copy), setFakePart (copy)
            for _, v19 in t2 do
                v19:Disconnect()
            end

            v13:Destroy()

            if not v13:GetAttribute("DisableMorphPart") then
                local Humanoid = p4:FindFirstChildOfClass("Humanoid")

                if p4.Parent ~= nil and Humanoid ~= nil and Humanoid.Health > 0 then
                    setFakePart(p4, p5, p6)
                end
            end
        end))

        for v20, v21 in p5 do
            if v20 == "Material" then
                v13.Material = v21

                if v21 == Enum.Material.Glass then
                    v13.Transparency = 0.5
                else
                    v13.Transparency = 0
                end
            elseif v20 == "Reflectance" then
                v13.Reflectance = v21
            elseif v20 == "Transparency" then
                v13.Transparency = v21
            elseif v20 == "Color" then
                v13.Color = v21
            end
        end
    end)
end

local function checkBodyPart(p7) -- line: 199
    if p7:IsA("BasePart") and p7.Name ~= "HumanoidRootPart" and string.sub(p7.Name, 1, 4) ~= "Fake" then
        return true
    end

    return false
end

local function setFakeBodyParts(p8, p9) -- line: 207
    -- upvalues: createFakeBodyPart (copy), setFakePart (copy)
    if not p8 then
        return nil
    end

    for _, descendant in p8:GetDescendants() do
        local Parent = descendant.Parent

        if (Parent == p8 or Parent and Parent:IsA("Accessory")) and descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" and string.sub(descendant.Name, 1, 4) ~= "Fake" then
            task.defer(function() -- line: 118
                -- upvalues: p8 (copy), p9 (copy), descendant (copy), createFakeBodyPart (copy), setFakePart (copy)
                local Name, Parent = descendant.Name, descendant.Parent
                local Name2 = if not (Parent and Parent:IsA("Accessory")) then nil else Parent.Name
                local v22 = createFakeBodyPart(p8, descendant)
                local t3 = {}

                local function disconnectAll() -- line: 124
                    -- upvalues: t3 (copy)
                    for _, v23 in t3 do
                        v23:Disconnect()
                    end
                end

                local function charIsAlive() -- line: 129
                    -- upvalues: p8 (copy)
                    local Humanoid = p8:FindFirstChildOfClass("Humanoid")

                    if p8.Parent == nil or Humanoid == nil then
                        return false
                    end

                    return Humanoid.Health > 0
                end

                local function refakeReplacement() -- line: 133
                    -- upvalues: p8 (copy), p9 (copy), setFakePart (copy), Name (copy), Name2 (copy), v22 (copy)
                    if v22:GetAttribute("DisableMorphPart") then
                        return
                    end

                    local Humanoid = p8:FindFirstChildOfClass("Humanoid")

                    if p8.Parent ~= nil and Humanoid ~= nil and Humanoid.Health > 0 then
                        if Name2 then
                            for _ = 1, 40 do
                                for _, child in p8:GetChildren() do
                                    if child:IsA("Accessory") and child.Name == Name2 and not child:GetAttribute("HDPartName") and not child:GetAttribute("HDFakeClaimed") then
                                        local BasePart = child:FindFirstChildWhichIsA("BasePart")

                                        if BasePart then
                                            child:SetAttribute("HDFakeClaimed", true)
                                            setFakePart(p8, p9, BasePart)

                                            return
                                        end
                                    end
                                end

                                task.wait(0.1)

                                local Humanoid = p8:FindFirstChildOfClass("Humanoid")

                                if p8.Parent == nil or Humanoid == nil or not (Humanoid.Health > 0) then
                                    return
                                end
                            end
                        else
                            local v24 = p8:WaitForChild(Name, 4)

                            if v24 then
                                setFakePart(p8, p9, v24)
                            end
                        end
                    end
                end

                table.insert(t3, descendant.Destroying:Once(function() -- line: 166
                    -- upvalues: v22 (copy), t3 (copy), refakeReplacement (copy)
                    for _, v26 in t3 do
                        v26:Disconnect()
                    end

                    v22:Destroy()
                    refakeReplacement()
                end))
                table.insert(t3, descendant:GetPropertyChangedSignal("Size"):Once(function() -- line: 171
                    -- upvalues: p8 (copy), p9 (copy), descendant (copy), setFakePart (copy), v22 (copy), t3 (copy)
                    for _, v28 in t3 do
                        v28:Disconnect()
                    end

                    v22:Destroy()

                    if not v22:GetAttribute("DisableMorphPart") then
                        local Humanoid = p8:FindFirstChildOfClass("Humanoid")

                        if p8.Parent ~= nil and Humanoid ~= nil and Humanoid.Health > 0 then
                            setFakePart(p8, p9, descendant)
                        end
                    end
                end))

                for v29, v30 in p9 do
                    if v29 == "Material" then
                        v22.Material = v30

                        if v30 == Enum.Material.Glass then
                            v22.Transparency = 0.5
                        else
                            v22.Transparency = 0
                        end
                    elseif v29 == "Reflectance" then
                        v22.Reflectance = v30
                    elseif v29 == "Transparency" then
                        v22.Transparency = v30
                    elseif v29 == "Color" then
                        v22.Color = v30
                    end
                end
            end)
        end
    end

    local connection = p8.ChildAdded:Connect(function(p10) -- line: 218
        -- upvalues: p8 (copy), p9 (copy), createFakeBodyPart (copy), setFakePart (copy)
        if p10:IsA("Accessory") then
            task.defer(function() -- line: 222
                -- upvalues: p10 (copy), p8 (copy), p9 (copy), createFakeBodyPart (copy), setFakePart (copy)
                if p10:GetAttribute("HDPartName") or p10:GetAttribute("HDFakeClaimed") then
                    return
                end

                local v31 = p10:FindFirstChildWhichIsA("BasePart") or p10:WaitForChild("Handle", 4)

                if v31 and v31:IsA("BasePart") and v31:IsA("BasePart") and v31.Name ~= "HumanoidRootPart" and string.sub(v31.Name, 1, 4) ~= "Fake" and p10.Parent == p8 then
                    task.defer(function() -- line: 118
                        -- upvalues: v31 (copy), p8 (copy), p9 (copy), createFakeBodyPart (copy), setFakePart (copy)
                        local Name, Parent = v31.Name, v31.Parent
                        local Name2 = if not (Parent and Parent:IsA("Accessory")) then nil else Parent.Name
                        local v32 = createFakeBodyPart(p8, v31)
                        local t4 = {}

                        local function disconnectAll() -- line: 124
                            -- upvalues: t4 (copy)
                            for _, v33 in t4 do
                                v33:Disconnect()
                            end
                        end

                        local function charIsAlive() -- line: 129
                            -- upvalues: p8 (copy)
                            local Humanoid = p8:FindFirstChildOfClass("Humanoid")

                            if p8.Parent == nil or Humanoid == nil then
                                return false
                            end

                            return Humanoid.Health > 0
                        end

                        local function refakeReplacement() -- line: 133
                            -- upvalues: p8 (copy), p9 (copy), setFakePart (copy), Name (copy), Name2 (copy), v32 (copy)
                            if v32:GetAttribute("DisableMorphPart") then
                                return
                            end

                            local Humanoid = p8:FindFirstChildOfClass("Humanoid")

                            if p8.Parent ~= nil and Humanoid ~= nil and Humanoid.Health > 0 then
                                if Name2 then
                                    for _ = 1, 40 do
                                        for _, child in p8:GetChildren() do
                                            if child:IsA("Accessory") and child.Name == Name2 and not child:GetAttribute("HDPartName") and not child:GetAttribute("HDFakeClaimed") then
                                                local BasePart = child:FindFirstChildWhichIsA("BasePart")

                                                if BasePart then
                                                    child:SetAttribute("HDFakeClaimed", true)
                                                    setFakePart(p8, p9, BasePart)

                                                    return
                                                end
                                            end
                                        end

                                        task.wait(0.1)

                                        local Humanoid = p8:FindFirstChildOfClass("Humanoid")

                                        if p8.Parent == nil or Humanoid == nil or not (Humanoid.Health > 0) then
                                            return
                                        end
                                    end
                                else
                                    local v34 = p8:WaitForChild(Name, 4)

                                    if v34 then
                                        setFakePart(p8, p9, v34)
                                    end
                                end
                            end
                        end

                        table.insert(t4, v31.Destroying:Once(function() -- line: 166
                            -- upvalues: v32 (copy), t4 (copy), refakeReplacement (copy)
                            for _, v36 in t4 do
                                v36:Disconnect()
                            end

                            v32:Destroy()
                            refakeReplacement()
                        end))
                        table.insert(t4, v31:GetPropertyChangedSignal("Size"):Once(function() -- line: 171
                            -- upvalues: v31 (copy), p8 (copy), p9 (copy), setFakePart (copy), v32 (copy), t4 (copy)
                            for _, v38 in t4 do
                                v38:Disconnect()
                            end

                            v32:Destroy()

                            if not v32:GetAttribute("DisableMorphPart") then
                                local Humanoid = p8:FindFirstChildOfClass("Humanoid")

                                if p8.Parent ~= nil and Humanoid ~= nil and Humanoid.Health > 0 then
                                    setFakePart(p8, p9, v31)
                                end
                            end
                        end))

                        for v39, v40 in p9 do
                            if v39 == "Material" then
                                v32.Material = v40

                                if v40 == Enum.Material.Glass then
                                    v32.Transparency = 0.5
                                else
                                    v32.Transparency = 0
                                end
                            elseif v39 == "Reflectance" then
                                v32.Reflectance = v40
                            elseif v39 == "Transparency" then
                                v32.Transparency = v40
                            elseif v39 == "Color" then
                                v32.Color = v40
                            end
                        end
                    end)
                end
            end)
        end
    end)

    return function() -- line: 232
        -- upvalues: connection (copy)
        connection:Disconnect()
    end
end

return setFakeBodyParts
