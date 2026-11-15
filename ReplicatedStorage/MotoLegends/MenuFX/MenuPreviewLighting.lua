-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = Color3.new(1, 1, 1)

return {
    Attach = function(p1, p2, p3, p4) -- Attach | line: 9
        -- upvalues: RunService (copy), v1 (copy)
        local t2 = {}
        local t3 = {}
        local v2 = false

        local function geometry(p5, p6) -- line: 12
            -- upvalues: p1 (copy), p3 (copy)
            p5.Position = p1.Position + UDim2.fromOffset(p6 == "Left" and -p3.RimWidth or p3.RimWidth, 0)
            p5.Size = p1.Size
            p5.AnchorPoint = p1.AnchorPoint
            p5.ZIndex = p1.ZIndex - 1
            p5.Visible = p1.Visible
            p5.Rotation = p1.Rotation
            p5.CurrentCamera = p1.CurrentCamera
        end

        for _, v3 in { "Left", "Right" } do
            local ViewportFrame = Instance.new("ViewportFrame")

            ViewportFrame.Name = p1.Name .. v3 .. "Light"
            ViewportFrame.BackgroundTransparency = 1
            ViewportFrame.BorderSizePixel = 0
            ViewportFrame.Active = false
            ViewportFrame.Ambient = Color3.new(1, 1, 1)
            ViewportFrame.LightColor = Color3.new(0, 0, 0)
            ViewportFrame.ImageTransparency = 1
            geometry(ViewportFrame, v3)
            ViewportFrame.Parent = p1.Parent

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Name = "SideRimMask"
            UIGradient.Rotation = 0
            UIGradient.Transparency = v3 == "Left" and NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.35, 0.08),
                NumberSequenceKeypoint.new(0.62, 1),
                NumberSequenceKeypoint.new(1, 1)
            }) or NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.38, 1),
                NumberSequenceKeypoint.new(0.65, 0.08),
                NumberSequenceKeypoint.new(1, 0)
            })
            UIGradient.Parent = ViewportFrame

            local WorldModel = Instance.new("WorldModel")

            WorldModel.Parent = ViewportFrame
            table.insert(t2, {
                intensity = 0.6,
                view = ViewportFrame,
                world = WorldModel,
                side = v3
            })
        end

        local n1 = 0
        local n2 = 0
        local t5 = {
            Refresh = function() -- Refresh | line: 30
                -- upvalues: p2 (copy), t2 (copy), t3 (copy), n1 (ref), n2 (ref)
                n1 = 0.15
                n2 = 0.03333333333333333
                table.clear(t3)

                for _, v4 in t2 do
                    v4.world:ClearAllChildren()

                    for _, child in p2:GetChildren() do
                        if child:IsA("Model") then
                            local clone = child:Clone()

                            clone.Name = child.Name .. "LightPass"

                            local function map(p7, p8) -- line: 40
                                -- upvalues: map (copy), t3 (copy)
                                if p7:IsA("BasePart") then
                                    table.insert(t3, {
                                        source = p7,
                                        replica = p8
                                    })
                                end

                                local Children = p7:GetChildren()
                                local Children2 = p8:GetChildren()

                                for v5, v6 in Children do
                                    if Children2[v5] then
                                        map(v6, Children2[v5])
                                    end
                                end
                            end

                            map(child, clone)

                            for _, descendant in clone:GetDescendants() do
                                if descendant:IsA("BaseScript")
                                    or descendant:IsA("Animator")
                                    or descendant:IsA("Sound")
                                    or descendant:IsA("Decal")
                                    or descendant:IsA("Texture")
                                    or descendant:IsA("SurfaceAppearance")
                                    or descendant:IsA("Clothing")
                                    or descendant:IsA("ShirtGraphic")
                                    or descendant:IsA("BodyColors") then
                                    descendant:Destroy()
                                elseif descendant:IsA("BasePart") then
                                    descendant.Anchored = true
                                    descendant.CanCollide = false
                                    descendant.CanTouch = false
                                    descendant.CanQuery = false
                                    descendant.Color = Color3.new(1, 1, 1)
                                    descendant.Material = Enum.Material.SmoothPlastic
                                    descendant.Reflectance = 0
                                    descendant.CastShadow = false

                                    if descendant:IsA("MeshPart") then
                                        descendant.TextureID = ""

                                        local function v7() -- line: 51
                                            -- upvalues: descendant (copy)
                                            descendant.RenderFidelity = Enum.RenderFidelity.Performance
                                        end

                                        pcall(v7)
                                    end
                                elseif descendant:IsA("SpecialMesh") then
                                    descendant.TextureId = ""
                                    descendant.VertexColor = Vector3.new(1, 1, 1)
                                end
                            end

                            clone.Parent = v4.world
                        end
                    end
                end
            end
        }
        local t7 = {}

        for _, v8 in { "Position", "Size", "AnchorPoint", "ZIndex", "Visible", "Rotation", "CurrentCamera" } do
            table.insert(t7, p1:GetPropertyChangedSignal(v8):Connect(function() -- line: 61
                -- upvalues: t2 (copy), geometry (copy)
                for _, v10 in t2 do
                    geometry(v10.view, v10.side)
                end
            end))
        end

        local CFrame
        local n3 = 1
        local n4 = 0

        local function onScreen() -- line: 67
            -- upvalues: p1 (copy)
            local v11 = p1

            while true do
                if not v11 then
                    return false
                end

                if v11:IsA("GuiObject") then
                    if v11.Visible then
                        v11 = v11.Parent
                        continue
                    end

                    break
                end

                if v11:IsA("LayerCollector") then
                    return v11.Enabled
                end

                v11 = v11.Parent
            end

            return false
        end

        local connection

        local function stop() -- line: 77
            -- upvalues: t2 (copy), v2 (ref), t7 (copy), connection (ref)
            if v2 then
                return
            end

            v2 = true

            if connection then
                connection:Disconnect()
            end

            for _, v12 in t7 do
                v12:Disconnect()
            end

            for _, v13 in t2 do
                v13.view:Destroy()
            end
        end

        connection = RunService.RenderStepped:Connect(function(p9) -- line: 84
            -- upvalues: p1 (copy), p3 (copy), p4 (copy), t2 (copy), t3 (copy), n1 (ref), n2 (ref), CFrame (ref), n3 (ref), n4 (ref), onScreen (copy), stop (copy), v1 (copy)
            if not p1.Parent then
                stop()

                return
            end

            local CurrentCamera = p1.CurrentCamera

            if CurrentCamera then
                local CurrentColor, v14

                if p1.ImageTransparency >= 0.999 then
                    v14 = true
                elseif onScreen() then
                    CurrentColor = p4 and p4:GetAttribute("CurrentColor") or v1
                    v14 = false
                else
                    v14 = true
                end

                if not v14 then
                    local CFrame2 = CurrentCamera.CFrame

                    if not (CFrame and (CFrame.Position - CFrame2.Position).Magnitude > 0.001) then
                        n3 += p9
                    else
                        n3 = 0
                    end

                    CFrame = CFrame2

                    if n1 > 0 then
                        n1 -= p9
                        n3 = 0
                    end

                    local v15 = if n3 < 0.12 then 1 else 0

                    n4 += (v15 - n4) * (1 - math.exp(-p9 * (if n4 < v15 then 30 else 6)))

                    local v19 = false

                    for _, v20 in t2 do
                        local v21 = p4 and p4:GetAttribute(v20.side .. "Brightness") or 0.6

                        v20.intensity = v20.intensity + (v21 - v20.intensity) * (1 - math.exp(-p9 * 4))

                        local v24 = p3.Strength * (0.7 + 0.3 * v20.intensity) * (1 - p1.ImageTransparency) * (1 - n4)
                        local v25 = p1.Visible and n4 < 0.98

                        if v20.view.Visible ~= v25 then
                            v20.view.Visible = v25
                        end

                        if v25 then
                            v19 = true
                        end

                        local v26 = 1 - v24

                        if math.abs(v20.view.ImageTransparency - v26) > 0.001 then
                            v20.view.ImageTransparency = v26
                        end

                        if v20.view.ImageColor3 ~= CurrentColor then
                            v20.view.ImageColor3 = CurrentColor
                        end

                        if math.abs((v20.view:GetAttribute("LightIntensity") or -1) - v20.intensity) > 0.005 then
                            v20.view:SetAttribute("LightIntensity", v20.intensity)
                        end
                    end

                    if p1.Ambient ~= p3.FrontAmbient then
                        p1.Ambient = p3.FrontAmbient
                    end

                    if p1.LightColor ~= v1 then
                        p1.LightColor = v1
                    end

                    local Unit = CFrame2:VectorToWorldSpace((Vector3.new(-0.12, -0.5, -1))).Unit

                    if (p1.LightDirection - Unit).Magnitude > 1E-04 then
                        p1.LightDirection = Unit
                    end

                    if v19 then
                        n2 += p9

                        if not (n2 < 0.03333333333333333) then
                            n2 = 0

                            for _, v29 in t3 do
                                if v29.source.Parent and v29.replica.Parent then
                                    if v29.replica.CFrame ~= v29.source.CFrame then
                                        v29.replica.CFrame = v29.source.CFrame
                                    end

                                    if v29.replica.Transparency ~= v29.source.Transparency then
                                        v29.replica.Transparency = v29.source.Transparency
                                    end
                                end
                            end
                        end
                    else
                        n2 = 0.03333333333333333
                    end
                else
                    for _, v30 in t2 do
                        if v30.view.Visible then
                            v30.view.Visible = false
                        end
                    end

                    CFrame = nil
                end
            end
        end)
        table.insert(t7, p1.Destroying:Connect(stop))

        return t5
    end
}
