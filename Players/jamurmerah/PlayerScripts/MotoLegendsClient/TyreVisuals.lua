-- https://lua.expert

local AssetService = game:GetService("AssetService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local TyreCatalog = require(MotoLegends:WaitForChild("TyreCatalog"))
local t1 = {
    Object_92 = true
}
local t2 = {
    Object_8 = true
}

local function v1() -- line: 15
    -- upvalues: AssetService (copy)
    return AssetService:CreateEditableImageAsync(Content.fromUri("rbxassetid://110600632501943"))
end

local ok, result = pcall(v1)

if not ok or not result then
    warn("[TyreVisuals] tyre texture not readable: " .. tostring(result))
else
    local Size = result.Size
    local v2 = result:ReadPixelsBuffer(Vector2.zero, Size)

    result:Destroy()

    local v3 = Size.X * Size.Y
    local X, Y = Size.X, Size.Y
    local v4 = buffer.create(v3)
    local v5 = v3 - 1
    local n1 = 0
    local n2 = 0
    local n3 = 0
    local n4 = 0

    for i = 0, v5 do
        local v6 = i * 4
        local v7 = buffer.readu8(v2, v6)
        local v8 = buffer.readu8(v2, v6 + 1)
        local v9 = buffer.readu8(v2, v6 + 2)
        local v10 = math.max(v7, v8, v9)
        local v11 = math.min(v7, v8, v9)

        if v10 > 110 and v10 - v11 < 40 then
            buffer.writeu8(v4, i, 1)
        elseif v10 < 70 and v10 - v11 < 12 then
            n1 += v7
            n2 += v8
            n3 += v9
            n4 += 1
        end

        if i % 131072 == 0 then
            task.wait()
        end
    end

    local t3 = {
        math.floor(n1 / math.max(n4, 1)),
        math.floor(n2 / math.max(n4, 1)),
        (math.floor(n3 / math.max(n4, 1)))
    }
    local v17 = buffer.create(v3)
    local v18 = buffer.create(v3)

    for i = 0, v3 - 1 do
        if buffer.readu8(v4, i) == 1 and buffer.readu8(v18, i) == 0 then
            local t4 = {
                i
            }
            local t5 = {}

            buffer.writeu8(v18, i, 1)

            while #t4 > 0 do
                local v19 = table.remove(t4)

                table.insert(t5, v19)

                for _, v20 in { -1, 1, -X, X } do
                    local v21 = v19 + v20

                    if v21 >= 0 and v21 < v3 and buffer.readu8(v4, v21) == 1 and buffer.readu8(v18, v21) == 0 then
                        buffer.writeu8(v18, v21, 1)
                        table.insert(t4, v21)
                    end
                end
            end

            if #t5 >= 4000 then
                for _, v22 in t5 do
                    buffer.writeu8(v17, v22, 1)
                end
            end
        end

        if i % 131072 == 0 then
            task.wait()
        end
    end

    local t6 = {}

    for i = 0, v3 - 1 do
        local v23 = buffer.readu8(v17, i) == 1
        local v24 = i * 4
        local v25 = not v23

        v25 = v25 and math.max(buffer.readu8(v2, v24), buffer.readu8(v2, v24 + 1), (buffer.readu8(v2, v24 + 2))) < t3[1] + 9

        local v29

        if v23 or v25 then
            v29 = v23
        else
            local v30 = i % X
            local v31 = i // X

            v29 = v23

            for j = -2, 2 do
                for k = -2, 2 do
                    local v32 = v30 + k
                    local v33 = v31 + j

                    if v32 >= 0 and v32 < X and v33 >= 0 and v33 < Y and buffer.readu8(v17, v33 * X + v32) == 1 then
                        v29 = true
                        break
                    end
                end

                if v29 then
                    break
                end
            end
        end

        if v29 then
            local v35 = i * 4
            local v39 = math.max(buffer.readu8(v2, v35), buffer.readu8(v2, v35 + 1), (buffer.readu8(v2, v35 + 2)))
            local v40 = if v23 then 1 else math.clamp((v39 - t3[1] - 8) / 100, 0, 1)

            if v40 > 0 then
                table.insert(t6, {
                    v35,
                    v40,
                    v39
                })
            end
        end

        if i % 65536 == 0 then
            task.wait()
        end
    end

    local t8 = {}

    local function variant(p1) -- line: 76
        -- upvalues: AssetService (copy), TyreCatalog (copy), Size (copy), v2 (copy), v3 (copy), t3 (copy), t6 (copy), t8 (copy)
        if t8[p1] ~= nil then
            return t8[p1] or nil
        end

        local v42 = TyreCatalog.Compounds[p1] or TyreCatalog.Compounds[TyreCatalog.Default]

        if v42 and v42.Stripe == Color3.fromRGB(245, 245, 245) then
            t8[p1] = Content.fromUri("rbxassetid://110600632501943")

            return t8[p1]
        end

        local function v43() -- line: 80
            -- upvalues: v42 (copy), AssetService (copy), Size (copy), v2 (copy), v3 (copy), t3 (copy), t6 (copy)
            local v44 = buffer.create(v3 * 4)

            buffer.copy(v44, 0, v2)

            local v45, v46, v47

            if v42 and v42.Stripe then
                v45 = v42.Stripe.R * 255
                v46 = v42.Stripe.G * 255
                v47 = v42.Stripe.B * 255
            end

            for _, v48 in t6 do
                local v49 = v48[1]
                local v50 = v48[2]
                local v51 = v48[3]
                local v52 = buffer.readu8(v44, v49)
                local v54 = buffer.readu8(v44, v49 + 1)
                local v56 = buffer.readu8(v44, v49 + 2)
                local v57, v58, v59

                if v45 then
                    local v61 = math.clamp(v51 / 225, 0, 1.1)

                    v57 = v45 * v61
                    v58 = v46 * v61
                    v59 = v47 * v61
                else
                    v57 = t3[1]
                    v58 = t3[2]
                    v59 = t3[3]
                end

                buffer.writeu8(v44, v49, (math.clamp(math.floor(v52 + (v57 - v52) * v50 + 0.5), 0, 255)))
                buffer.writeu8(v44, v49 + 1, (math.clamp(math.floor(v54 + (v58 - v54) * v50 + 0.5), 0, 255)))
                buffer.writeu8(v44, v49 + 2, (math.clamp(math.floor(v56 + (v59 - v56) * v50 + 0.5), 0, 255)))
            end

            local v73 = AssetService:CreateEditableImage({
                Size = Size
            })

            v73:WritePixelsBuffer(Vector2.zero, Size, v44)

            return Content.fromObject(v73)
        end

        local ok, result = pcall(v43)

        if not ok then
            warn("[TyreVisuals] " .. p1 .. ": " .. tostring(result))
        end

        t8[p1] = not not (ok and result) and result

        if not ok or not result then
            result = nil
        end

        return result
    end

    local t9 = {}

    local function bikeOf(p2) -- line: 107
        local Parent = p2.Parent

        while true do
            if not Parent or Parent == workspace then
                return nil
            end

            if Parent:IsA("Model") and (Parent:GetAttribute("OwnerUserId") ~= nil or Parent:GetAttribute("TyreFront") ~= nil) then
                break
            end

            Parent = Parent.Parent
        end

        return Parent
    end

    local function sameContent(p3, p4) -- line: 117
        if p3 == nil or p4 == nil or p3.SourceType ~= p4.SourceType then
            return false
        end

        if p3.SourceType == Enum.ContentSourceType.Uri then
            return p3.Uri == p4.Uri
        end

        return p3.Object == p4.Object
    end

    local v75

    local function apply(p5) -- line: 124
        -- upvalues: TyreCatalog (copy), variant (copy), t9 (copy), bikeOf (copy), v75 (ref)
        local v76 = t9[p5]

        if not v76 then
            return
        end

        if not (v76.bike and v76.bike.Parent) then
            v76.bike = bikeOf(p5)
        end

        if v76.bike then
            v75(v76.bike)
        end

        local v77, v78

        if v76.bike then
            local Attribute = v76.bike:GetAttribute(if v76.rear then "TyreRear" else "TyreFront")

            if Attribute then
                v77 = Attribute
                v78 = true
            else
                v78 = false
            end
        else
            v78 = false
        end

        if not v78 then
            v77 = TyreCatalog.Default
        end

        if not TyreCatalog.Compounds[v77] then
            v77 = TyreCatalog.Default
        end

        local v79 = variant(v77)

        if v79 then
            local TextureContent = p5.TextureContent

            if TextureContent == nil or v79 == nil or TextureContent.SourceType ~= v79.SourceType or not (if TextureContent.SourceType == Enum.ContentSourceType.Uri then TextureContent.Uri == v79.Uri else TextureContent.Object == v79.Object) then
                p5.TextureContent = v79
            end
        end

        v76.shown = v77
        p5:SetAttribute("TyreShown", v77)
    end

    local t10 = {}

    v75 = function(p6) -- line: 136
        -- upvalues: t9 (copy), apply (copy), t10 (copy)
        if t10[p6] then
            return
        end

        t10[p6] = true

        local function changed() -- line: 139
            -- upvalues: p6 (copy), t9 (copy), apply (copy)
            for v80, v81 in t9 do
                if v81.bike == p6 then
                    apply(v80)
                end
            end
        end

        p6:GetAttributeChangedSignal("TyreFront"):Connect(changed)
        p6:GetAttributeChangedSignal("TyreRear"):Connect(changed)
        p6:GetAttributeChangedSignal("OwnerUserId"):Connect(changed)
        p6.Destroying:Connect(function() -- line: 143
            -- upvalues: p6 (copy), t10 (copy)
            t10[p6] = nil
        end)
    end

    local function add(p7) -- line: 145
        -- upvalues: t1 (copy), t2 (copy), t9 (copy), bikeOf (copy), apply (copy)
        local v82, v83

        if t9[p7] then
            v83 = true
        elseif p7:IsA("MeshPart") and p7.TextureID == "rbxassetid://110600632501943" then
            v82 = t1[p7.Name]
            v82 = v82 or not t2[p7.Name] and p7.Size.X > p7.Size.Y * 0.25
            v83 = false
        else
            v83 = true
        end

        if v83 then
            return
        end

        t9[p7] = {
            bike = bikeOf(p7),
            rear = v82
        }
        p7.Destroying:Connect(function() -- line: 149
            -- upvalues: p7 (copy), t9 (copy)
            t9[p7] = nil
        end)
        apply(p7)
    end

    for _, descendant in workspace:GetDescendants() do
        if descendant:IsA("MeshPart") then
            add(descendant)
        end
    end

    workspace.DescendantAdded:Connect(function(p8) -- line: 153
        -- upvalues: add (copy)
        if p8:IsA("MeshPart") then
            task.defer(add, p8)
        end
    end)
    task.spawn(function() -- line: 157
        -- upvalues: t9 (copy), apply (copy)
        while true do
            task.wait(1)

            for v84, _ in t9 do
                if v84.Parent then
                    apply(v84)
                else
                    t9[v84] = nil
                end
            end
        end
    end)
end
