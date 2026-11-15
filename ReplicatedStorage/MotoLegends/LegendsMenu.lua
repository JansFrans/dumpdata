-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Parent = script.Parent
local RaceIcons = require(Parent.RaceIcons)
local UIArt = require(Parent.UIArt)
local NumberFormat = require(Parent.NumberFormat)
local LegendsCatalog = require(Parent.LegendsCatalog)
local LegendRig = require(Parent.LegendRig)

return {
    New = function(p1, p2, p3, p4) -- New | line: 13
        -- upvalues: MarketplaceService (copy), TweenService (copy), HttpService (copy), Parent (copy), RaceIcons (copy), UIArt (copy), NumberFormat (copy), LegendsCatalog (copy), LegendRig (copy)
        local t2 = {}
        local v1 = Color3.new(1, 1, 1)
        local v2 = Color3.new(0, 0, 0)
        local v3 = Color3.fromRGB(231, 0, 0)
        local v4 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)

        local function say(p5) -- line: 16
            -- upvalues: p4 (copy)
            if p4 then
                p4(p5)
            end
        end

        local Frame = Instance.new("Frame")

        Frame.Name = "LegendsMenu"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = Color3.fromRGB(7, 12, 21)
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.Visible = false
        Frame.ZIndex = 40
        Frame.Active = true
        Frame.Parent = p1

        local ScreenGui = Instance.new("ScreenGui")

        ScreenGui.Name = "LegendsBackdrop"
        ScreenGui.ScreenInsets = Enum.ScreenInsets.None
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Enabled = false
        ScreenGui.Parent = p3:WaitForChild("PlayerGui")

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Background"
        Frame2.BorderSizePixel = 0
        Frame2.Size = UDim2.fromScale(1, 1)
        Frame2.Active = true
        Frame2.Parent = ScreenGui
        Frame2.BackgroundColor3 = Frame.BackgroundColor3

        local function syncBackdrop() -- line: 24
            -- upvalues: p1 (copy), Frame (copy), ScreenGui (copy)
            ScreenGui.Enabled = Frame.Visible and p1.Enabled
            ScreenGui.DisplayOrder = p1.DisplayOrder - 1
        end

        Frame:GetPropertyChangedSignal("Visible"):Connect(syncBackdrop)
        p1:GetPropertyChangedSignal("DisplayOrder"):Connect(syncBackdrop)
        p1:GetPropertyChangedSignal("Enabled"):Connect(syncBackdrop)
        ScreenGui.Enabled = Frame.Visible and p1.Enabled
        ScreenGui.DisplayOrder = p1.DisplayOrder - 1

        local Frame3 = Instance.new("Frame")

        Frame3.Name = "ReferenceCanvas"
        Frame3.BackgroundTransparency = 1
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame3.Position = UDim2.fromScale(0.5, 0.5)
        Frame3.Size = UDim2.fromOffset(2000, 1125)
        Frame3.ZIndex = 40
        Frame3.Parent = Frame

        local UIScale = Instance.new("UIScale", Frame3)

        local function fit() -- line: 28
            -- upvalues: UIScale (copy)
            local ViewportSize = workspace.CurrentCamera.ViewportSize

            UIScale.Scale = math.min(ViewportSize.X / 2000, ViewportSize.Y / 1125)
        end

        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)

        local ViewportSize = workspace.CurrentCamera.ViewportSize

        UIScale.Scale = math.min(ViewportSize.X / 2000, ViewportSize.Y / 1125)

        local function text(p6, p7, p8, p9, p10, p11, p12, p13) -- line: 30
            -- upvalues: v1 (copy), v4 (copy)
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = p7
            TextLabel.Text = p8
            TextLabel.BackgroundTransparency = 1
            TextLabel.Position = UDim2.fromOffset(p9, p10)
            TextLabel.Size = UDim2.fromOffset(p11, p12)
            TextLabel.TextColor3 = v1
            TextLabel.FontFace = v4
            TextLabel.TextSize = p13
            TextLabel.ZIndex = 43
            TextLabel.Parent = p6

            return TextLabel
        end

        local function image(p14, p15, p16, p17, p18, p19, p20, p21) -- line: 33
            -- upvalues: UIArt (copy)
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = p15
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Position = UDim2.fromOffset(p17, p18)
            ImageLabel.Size = UDim2.fromOffset(p19, p20)
            ImageLabel.ZIndex = p21 or 43
            ImageLabel.Parent = p14

            if p16 then
                UIArt.Apply(ImageLabel, p16)
            end

            return ImageLabel
        end

        local function pressable(p22, p23) -- line: 38
            -- upvalues: TweenService (copy)
            p22:SetAttribute("NoHover", true)
            p22.AutoButtonColor = false

            local UIScale = Instance.new("UIScale", p22)

            local function set(p24) -- line: 41
                -- upvalues: p23 (copy)
                if p23 then
                    p23(p24)
                end
            end

            p22.MouseEnter:Connect(function() -- line: 42
                -- upvalues: p23 (copy)
                if p23 then
                    p23(true)
                end
            end)
            p22.MouseLeave:Connect(function() -- line: 42
                -- upvalues: p23 (copy), UIScale (copy), TweenService (copy)
                if p23 then
                    p23(false)
                end

                TweenService:Create(UIScale, TweenInfo.new(0.12), {
                    Scale = 1
                }):Play()
            end)
            p22.SelectionGained:Connect(function() -- line: 43
                -- upvalues: p23 (copy)
                if p23 then
                    p23(true)
                end
            end)
            p22.SelectionLost:Connect(function() -- line: 43
                -- upvalues: p23 (copy)
                if p23 then
                    p23(false)
                end
            end)
            p22.MouseButton1Down:Connect(function() -- line: 44
                -- upvalues: UIScale (copy), TweenService (copy)
                TweenService:Create(UIScale, TweenInfo.new(0.08), {
                    Scale = 0.94
                }):Play()
            end)
            p22.MouseButton1Up:Connect(function() -- line: 45
                -- upvalues: UIScale (copy), TweenService (copy)
                TweenService:Create(UIScale, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
                    Scale = 1
                }):Play()
            end)

            return p22
        end

        image(Frame3, "Halftone", "LegendsDots", 700, 0, 600, 620, 41)

        local v9 = text(Frame3, "LegendTitle", "", 400, 160, 1200, 62, 54)

        v9.AutoLocalize = false

        local UIStroke = Instance.new("UIStroke", v9)

        UIStroke.Color = v2
        UIStroke.Thickness = 3
        UIStroke.LineJoinMode = Enum.LineJoinMode.Miter

        local UIGradient = Instance.new("UIGradient", v9)

        UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 16)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 45, 95)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 130, 225))
        })

        local v10 = Color3.fromRGB(235, 0, 20)

        UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, v10),
            ColorSequenceKeypoint.new(0.38, v10),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 120, 130)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 235, 235)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 120, 130)),
            ColorSequenceKeypoint.new(0.62, v10),
            ColorSequenceKeypoint.new(1, v10)
        })
        UIGradient.Offset = Vector2.new(-0.7, 0)
        Instance.new("UIScale", v9)

        local t3 = {}
        local v11 = false

        local function titleColor(p25) -- line: 66
            -- upvalues: v1 (copy), UIGradient (copy), v10 (copy)
            p25 = p25 or v10

            local v13 = p25:Lerp(v1, 0.55)
            local v14 = p25:Lerp(v1, 0.92)

            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, p25),
                ColorSequenceKeypoint.new(0.38, p25),
                ColorSequenceKeypoint.new(0.45, v13),
                ColorSequenceKeypoint.new(0.5, v14),
                ColorSequenceKeypoint.new(0.55, v13),
                ColorSequenceKeypoint.new(0.62, p25),
                ColorSequenceKeypoint.new(1, p25)
            })
        end

        game:GetService("RunService").RenderStepped:Connect(function() -- line: 74
            -- upvalues: Frame (copy), UIGradient (copy), t3 (copy), v11 (ref)
            if Frame.Visible then
                local v16 = math.clamp(os.clock() % 3 / 1.8, 0, 1)
                local v17 = v16 * v16 * (3 - v16 * 2)

                if v11 then
                    UIGradient.Offset = Vector2.new(v17 * 1.4 + -0.7, 0)
                end

                for _, v18 in t3 do
                    if v18.Surface.Visible then
                        v18.Gradient.Offset = Vector2.new(v17 * 2.4 + -1.2, 0)
                    end
                end
            end
        end)

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "TitleLine"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Position = UDim2.fromOffset(851, 236)
        ImageLabel.Size = UDim2.fromOffset(298, 6)
        ImageLabel.ZIndex = 43
        ImageLabel.Parent = Frame3
        UIArt.Apply(ImageLabel, "Line")

        local v19 = text(Frame3, "Description", "", 600, 262, 800, 52, 23)

        v19.LineHeight = 1.12
        v19.AutoLocalize = true

        local ImageLabel2 = Instance.new("ImageLabel")

        ImageLabel2.Name = "Legend"
        ImageLabel2.BackgroundTransparency = 1
        ImageLabel2.Position = UDim2.fromOffset(741, 384)
        ImageLabel2.Size = UDim2.fromOffset(497, 622)
        ImageLabel2.ZIndex = 42
        ImageLabel2.Parent = Frame3

        local UIScale2 = Instance.new("UIScale", ImageLabel2)
        local t4 = {}
        local elapsed = os.clock()
        local n1 = 0

        local function newRigView(p26, p27, p28, p29, p30, p31) -- line: 97
            -- upvalues: v1 (copy), v2 (copy), t4 (copy), n1 (ref), TweenService (copy), Parent (copy), LegendRig (copy)
            local t5 = {
                Pairs = {}
            }

            local function makePair(p32, p33) -- line: 99
                -- upvalues: p26 (copy), p27 (copy), p28 (copy), p29 (copy), p30 (copy), p31 (copy), n1 (ref), LegendRig (copy)
                local ViewportFrame = Instance.new("ViewportFrame")

                ViewportFrame.Name = "Legend3DOutline_" .. p32
                ViewportFrame.BackgroundTransparency = 1
                ViewportFrame.Size = UDim2.fromScale(1, 1)
                ViewportFrame.ZIndex = p27
                ViewportFrame.Ambient = Color3.new(1, 1, 1)
                ViewportFrame.LightColor = Color3.new(0, 0, 0)
                ViewportFrame.Visible = false

                local ViewportFrame2 = Instance.new("ViewportFrame")

                ViewportFrame2.Name = "Legend3D_" .. p32
                ViewportFrame2.BackgroundTransparency = 1
                ViewportFrame2.Size = UDim2.fromScale(1, 1)
                ViewportFrame2.ZIndex = p27 + 1
                ViewportFrame2.Visible = false
                ViewportFrame2.Ambient = Color3.fromRGB(165, 150, 145)
                ViewportFrame2.LightColor = Color3.fromRGB(255, 246, 236)
                ViewportFrame2.LightDirection = Vector3.new(0.55, -0.6, -0.6)

                if p29 then
                    p29(ViewportFrame2)
                    p29(ViewportFrame)
                end

                local Camera = Instance.new("Camera")

                Camera.Parent = ViewportFrame2
                ViewportFrame2.CurrentCamera = Camera

                local Camera2 = Instance.new("Camera")

                Camera2.Parent = ViewportFrame
                ViewportFrame.CurrentCamera = Camera2

                local v20 = LegendRig.Cameras[p32]
                local v21 = v20 and v20[p28]

                if v21 then
                    local v22 = if p30 then math.deg(math.atan(p30 * math.tan(math.rad(v21.Fov) / 2)) * 2) or v21.Fov else v21.Fov

                    Camera.FieldOfView = v22
                    Camera.CFrame = CFrame.lookAt(v21.Pos, v21.Look)
                    Camera2.FieldOfView = v22
                    Camera2.CFrame = Camera.CFrame
                end

                local clone = p33:Clone()
                local v26 = LegendRig.MakeOutline(p33, p31)

                LegendRig.Apply(clone, p32, CFrame.identity, n1)
                LegendRig.Apply(v26, p32, CFrame.identity, n1)
                clone.Parent = ViewportFrame2
                v26.Parent = ViewportFrame
                ViewportFrame.Parent = p26
                ViewportFrame2.Parent = p26

                return {
                    View = ViewportFrame2,
                    Outline = ViewportFrame,
                    Model = clone,
                    OutlineModel = v26
                }
            end

            t5.View = Instance.new("ViewportFrame")
            t5.View.Visible = false
            t5.View.BackgroundTransparency = 1
            t5.Outline = Instance.new("ViewportFrame")
            t5.Outline.Visible = false
            t5.Outline.BackgroundTransparency = 1

            function t5.Set(p34) -- line: 122
                -- upvalues: t5 (copy), makePair (copy), n1 (ref), Parent (copy), LegendRig (copy)
                if t5.Id == p34 and t5.Model then
                    return true
                end

                local LegendRigs = Parent:FindFirstChild("LegendRigs")
                local v27 = p34 and LegendRigs and LegendRigs:FindFirstChild(p34)
                local View, Outline = t5.View, t5.Outline

                if v27 then
                    local v28 = t5.Pairs[p34]

                    if not v28 then
                        v28 = makePair(p34, v27)
                        t5.Pairs[p34] = v28
                    end

                    v28.View.ImageTransparency = View.ImageTransparency
                    v28.Outline.ImageTransparency = Outline.ImageTransparency
                    v28.View.ImageColor3 = View.ImageColor3
                    v28.Outline.ImageColor3 = Outline.ImageColor3

                    local Visible = View.Visible

                    View.Visible = false
                    Outline.Visible = false
                    t5.Id = p34
                    t5.View = v28.View
                    t5.Outline = v28.Outline
                    t5.Model = v28.Model
                    t5.OutlineModel = v28.OutlineModel
                    LegendRig.Apply(t5.Model, p34, CFrame.identity, n1)
                    LegendRig.Apply(t5.OutlineModel, p34, CFrame.identity, n1)
                    t5.View.Visible = Visible
                    t5.Outline.Visible = Visible

                    return true
                end

                View.Visible = false
                Outline.Visible = false
                t5.Id = nil
                t5.Model = nil
                t5.OutlineModel = nil

                return false
            end

            function t5.Show(p35) -- line: 141
                -- upvalues: t5 (copy), n1 (ref), LegendRig (copy)
                if p35 and t5.Model then
                    LegendRig.Apply(t5.Model, t5.Id, CFrame.identity, n1)
                    LegendRig.Apply(t5.OutlineModel, t5.Id, CFrame.identity, n1)
                end

                t5.View.Visible = p35
                t5.Outline.Visible = p35
            end

            function t5.Silhouette(p36) -- line: 145
                -- upvalues: t5 (copy), v1 (copy), v2 (copy)
                t5.View.ImageColor3 = p36 and v2 or v1
                t5.Outline.ImageColor3 = p36 and Color3.fromRGB(65, 72, 86) or v1
            end

            function t5.Fade() -- line: 149
                -- upvalues: t5 (copy), TweenService (copy)
                t5.View.ImageTransparency = 1
                t5.Outline.ImageTransparency = 1
                TweenService:Create(t5.View, TweenInfo.new(0.25), {
                    ImageTransparency = 0
                }):Play()
                TweenService:Create(t5.Outline, TweenInfo.new(0.25), {
                    ImageTransparency = 0
                }):Play()
            end

            function t5.Warm(p37) -- line: 153
                -- upvalues: t5 (copy), makePair (copy), Parent (copy)
                local LegendRigs = Parent:FindFirstChild("LegendRigs")
                local v29 = LegendRigs and LegendRigs:FindFirstChild(p37)

                if v29 and not t5.Pairs[p37] then
                    t5.Pairs[p37] = makePair(p37, v29)
                end
            end

            table.insert(t4, t5)

            return t5
        end

        local v30 = newRigView(ImageLabel2, 41, "Main", function(p38) -- line: 161
            p38.AnchorPoint = Vector2.new(0.5, 1)
            p38.Position = UDim2.fromScale(0.5, 1)
            p38.Size = UDim2.fromScale(1.15, 1.15)
        end)

        task.spawn(function() -- line: 163
            -- upvalues: v30 (copy), Parent (copy)
            local v31 = Parent:WaitForChild("LegendRigs", 10)

            if not v31 then
                return
            end

            for _, child in v31:GetChildren() do
                v30.Warm(child.Name)
            end

            local function v32() -- line: 167
                -- upvalues: v31 (copy)
                game:GetService("ContentProvider"):PreloadAsync(v31:GetDescendants())
            end

            pcall(v32)
        end)
        n1 = os.clock() - elapsed
        game:GetService("RunService"):BindToRenderStep("LegendsRigPose", Enum.RenderPriority.First.Value, function() -- line: 171
            -- upvalues: Frame (copy), t4 (copy), elapsed (copy), n1 (ref), LegendRig (copy)
            n1 = os.clock() - elapsed

            if Frame.Visible then
                local v33 = n1

                for _, v34 in t4 do
                    if v34.Model and v34.View.Visible and v34.View.Parent and v34.View.Parent.Visible then
                        LegendRig.Apply(v34.Model, v34.Id, CFrame.identity, v33)

                        if v34.OutlineModel then
                            LegendRig.Apply(v34.OutlineModel, v34.Id, CFrame.identity, v33)
                        end
                    end
                end
            end
        end)

        local v35 = text(Frame3, "EmptyMark", "?", 800, 480, 400, 420, 100)

        v35.AutoLocalize = false
        v35.TextScaled = true
        v35.TextColor3 = Color3.fromRGB(40, 44, 52)
        v35.ZIndex = 42

        local v36 = text(Frame3, "SprintOnlyHint", "LEGEND ABILITIES ONLY WORK IN THE SPRINT RACE", 600, 1030, 800, 32, 22)

        v36.TextColor3 = Color3.fromRGB(170, 178, 192)
        v36.ZIndex = 44

        local UIStroke2 = Instance.new("UIStroke", v36)

        UIStroke2.Color = v2
        UIStroke2.Thickness = 1.5
        UIStroke2.Transparency = 0.35
        image(Frame3, "MoneyIcon", "CashIcon", 1486, 130, 53, 50)
        UIStroke2 = text(Frame3, "Money", "0", 1557, 130, 200, 50, 38)
        UIStroke2.AutoLocalize = false
        UIStroke2.TextXAlignment = Enum.TextXAlignment.Left

        local function moneyValue() -- line: 190
            -- upvalues: p3 (copy)
            return p3:GetAttribute("Money") or 0
        end

        local v37 = require(script.Parent:WaitForChild("MoneyCounter")).Bind(UIStroke2, function(p39) -- line: 191
            -- upvalues: NumberFormat (copy)
            return NumberFormat.Short(p39):upper()
        end, Frame)

        local function updateMoney() -- line: 192
            -- upvalues: p3 (copy), v37 (copy)
            v37(p3:GetAttribute("Money") or 0)
        end

        p3:GetAttributeChangedSignal("Money"):Connect(updateMoney)
        v37(p3:GetAttribute("Money") or 0)

        local TextButton = Instance.new("TextButton")

        TextButton.Name = "Close"
        TextButton.Text = ""
        TextButton.BackgroundTransparency = 1
        TextButton.Position = UDim2.fromOffset(1737, 117)
        TextButton.Size = UDim2.fromOffset(141, 76)
        TextButton.ZIndex = 44
        TextButton.Parent = Frame3

        local ImageLabel3 = Instance.new("ImageLabel")

        ImageLabel3.Name = "ClosePlate"
        ImageLabel3.BackgroundTransparency = 1
        ImageLabel3.Size = UDim2.fromScale(1, 1)
        ImageLabel3.ImageContent = RaceIcons.Get("ref_top_plate")
        ImageLabel3.ImageColor3 = v1
        ImageLabel3.ZIndex = 44
        ImageLabel3.Parent = TextButton

        local v38 = text(TextButton, "X", "X", 0, 0, 141, 76, 44)

        v38.AutoLocalize = false
        v38.ZIndex = 45
        v38.TextColor3 = v2
        pressable(TextButton, function(p40) -- line: 197
            -- upvalues: v1 (copy), v2 (copy), v3 (copy), ImageLabel3 (copy), v38 (copy), TweenService (copy)
            TweenService:Create(ImageLabel3, TweenInfo.new(0.18), {
                ImageColor3 = p40 and v3 or v1
            }):Play()
            TweenService:Create(v38, TweenInfo.new(0.18), {
                TextColor3 = p40 and v1 or v2
            }):Play()
        end)
        TextButton.Activated:Connect(function() -- line: 198
            -- upvalues: Frame (copy)
            Frame.Visible = false
        end)

        local function pill(p41, p42, p43, p44, p45, p46, p47, p48, p49, p50) -- line: 201
            -- upvalues: v1 (copy), v2 (copy), v3 (copy), Frame3 (copy), text (copy), image (copy), pressable (copy), TweenService (copy)
            local TextButton = Instance.new("TextButton")

            TextButton.Name = p41
            TextButton.Text = ""
            TextButton.BorderSizePixel = 0
            TextButton.BackgroundColor3 = v1
            TextButton.Position = UDim2.fromOffset(1616, p42)
            TextButton.Size = UDim2.fromOffset(271, p43)
            TextButton.ZIndex = 43
            TextButton.Parent = Frame3
            Instance.new("UICorner", TextButton).CornerRadius = UDim.new(1, 0)

            local v41 = image(TextButton, "Icon", p44, p45, p46, p47, p48, 44)

            if p44 == "RobuxIcon" then
                v41.ImageColor3 = v2
            end

            local v42 = text(TextButton, "Price", p50, p49, 0, 271 - p49, p43, 38)

            v42.AutoLocalize = false
            v42.TextXAlignment = Enum.TextXAlignment.Left
            v42.ZIndex = 44
            v42.TextColor3 = v2
            pressable(TextButton, function(p51) -- line: 206
                -- upvalues: p44 (copy), TextButton (copy), v41 (copy), v42 (copy), v1 (copy), v2 (copy), v3 (copy), TweenService (copy)
                TweenService:Create(TextButton, TweenInfo.new(0.18), {
                    BackgroundColor3 = p51 and v3 or v1
                }):Play()
                TweenService:Create(v42, TweenInfo.new(0.18), {
                    TextColor3 = p51 and v1 or v2
                }):Play()

                if p44 ~= "RobuxIcon" then
                    return
                end

                TweenService:Create(v41, TweenInfo.new(0.18), {
                    ImageColor3 = p51 and v1 or v2
                }):Play()
            end)

            return TextButton
        end

        local v46 = pill("RollRobux", 828, 83, "RobuxIcon", 75, 20, 41, 44, 130, (tostring(LegendsCatalog.Prices.RollRobux)))
        local v47 = pill("RollMoney", 930, 82, "CashIcon", 54, 17, 51, 50, 125, NumberFormat.Short(LegendsCatalog.Prices.RollMoney):upper())
        local v48 = LegendsCatalog.Clean(nil)
        local v49 = false
        local n2 = 0

        local function readState() -- line: 218
            -- upvalues: p3 (copy), v48 (ref), HttpService (copy), LegendsCatalog (copy)
            local JSONDecode = HttpService.JSONDecode
            local v50 = p3:GetAttribute("LegendsState") or "{}"
            local ok, result = pcall(JSONDecode, HttpService, v50)

            v48 = LegendsCatalog.Clean(if not ok or not result then nil else result)
        end

        local t11 = {}
        local refresh
        local n3 = 0

        local function fadeAll(p52, p53) -- line: 228
            -- upvalues: v9 (copy), UIStroke (copy), ImageLabel (copy), v19 (copy), ImageLabel2 (copy), v30 (copy), TweenService (copy)
            for _, v51 in {
                    v30.View,
                    v30.Outline,
                    ImageLabel2
                } do
                TweenService:Create(v51, p53, {
                    ImageTransparency = p52
                }):Play()
            end

            TweenService:Create(v9, p53, {
                TextTransparency = p52
            }):Play()
            TweenService:Create(UIStroke, p53, {
                Transparency = p52
            }):Play()
            TweenService:Create(v19, p53, {
                TextTransparency = p52
            }):Play()
            TweenService:Create(ImageLabel, p53, {
                ImageTransparency = p52
            }):Play()
        end

        local function switchLegend() -- line: 233
            -- upvalues: v9 (copy), UIStroke (copy), ImageLabel (copy), v19 (copy), ImageLabel2 (copy), v30 (copy), v48 (ref), v49 (ref), t11 (copy), refresh (ref), n3 (ref), fadeAll (copy)
            n3 += 1

            local v52 = n3

            for v53, v54 in t11 do
                v54.Badge.Visible = v48.unlocked[v53] and v48.selected == v53
            end

            fadeAll(1, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
            task.delay(0.12, function() -- line: 237
                -- upvalues: v52 (copy), v9 (copy), UIStroke (copy), ImageLabel (copy), v19 (copy), ImageLabel2 (copy), v30 (copy), v49 (ref), refresh (ref), n3 (ref), fadeAll (copy)
                if v52 == n3 and not v49 then
                    refresh(false)

                    for _, v55 in {
                            v30.View,
                            v30.Outline,
                            ImageLabel2,
                            ImageLabel
                        } do
                        v55.ImageTransparency = 1
                    end

                    v9.TextTransparency = 1
                    UIStroke.Transparency = 1
                    v19.TextTransparency = 1
                    fadeAll(0, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
                end
            end)
        end

        local function showLegend(p54, p55) -- line: 245
            -- upvalues: v9 (copy), UIStroke (copy), UIGradient (copy), v11 (ref), titleColor (copy), ImageLabel (copy), v19 (copy), ImageLabel2 (copy), UIScale2 (copy), v30 (copy), v35 (copy), v48 (ref), TweenService (copy), UIArt (copy), LegendsCatalog (copy)
            p55 = p55 or v48.slots[v48.selected]

            local v57 = p55 ~= "" and LegendsCatalog.Legends[p55]

            if v57 then
                v9.Text = v57.Title
                v19.Text = v57.Description:gsub("%.+%s*$", "")
                ImageLabel2.Visible = true
                v35.Visible = false
                ImageLabel.Visible = true
                UIStroke.Transparency = 0
                titleColor(v57.Color)
                v30.Silhouette(false)
                v19.TextTransparency = 0
                v9.TextTransparency = 0

                if v57.Rig and v30.Set(v57.Rig) then
                    v30.Show(true)
                    ImageLabel2.ImageContent = Content.none
                else
                    v30.Set(nil)
                    v30.Show(false)
                    UIArt.Apply(ImageLabel2, v57.Art)
                end

                v11 = true
            else
                v9.Text = ""
                v19.Text = ""
                ImageLabel2.Visible = false
                v30.Show(false)
                v35.Visible = true
                ImageLabel.Visible = false
                v11 = false
                UIGradient.Offset = Vector2.new(-0.7, 0)
            end

            if not p54 or not v57 or v30.Model then
                return
            end

            UIScale2.Scale = 0.82
            ImageLabel2.ImageTransparency = 1
            TweenService:Create(UIScale2, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
            TweenService:Create(ImageLabel2, TweenInfo.new(0.25), {
                ImageTransparency = 0
            }):Play()
        end

        function refresh(p56) -- line: 268
            -- upvalues: v1 (copy), v10 (copy), v48 (ref), t11 (copy), showLegend (copy), Parent (copy), UIArt (copy), LegendsCatalog (copy)
            for v58, v59 in t11 do
                local v60 = v48.slots[v58]
                local v61 = v60 ~= "" and LegendsCatalog.Legends[v60]
                local v62 = not v48.unlocked[v58]

                v59.Card.Visible = v62 or v61 ~= nil

                if v62 then
                    UIArt.Apply(v59.Card, "LockedSlot")
                    v59.Card.ImageTransparency = 0
                    v59.Card.BackgroundTransparency = 1
                elseif v61 then
                    v59.Card.ImageContent = Content.none
                    v59.Card.ImageTransparency = 1
                    v59.Card.BackgroundTransparency = 0
                    v59.Card.BackgroundColor3 = v1
                end

                local Solid = v59.Solid

                if v61 ~= nil then
                    Solid.Visible = not v62
                else
                    Solid.Visible = false
                end

                if v61 then
                    v59.Solid.BackgroundColor3 = v61.Color or v10
                end

                v59.Empty.Visible = not v62 and not v61

                local Portrait = v59.Portrait

                if v61 ~= nil then
                    Portrait.Visible = not v62
                else
                    Portrait.Visible = false
                end

                v59.RigClip.Visible = v59.Portrait.Visible

                if not v61 or v62 then
                    v59.Rig.Show(false)
                    v59.PortraitImage.Visible = true
                elseif v61.Rig and v59.Rig.Set(v61.Rig) then
                    v59.Rig.Show(true)
                    v59.PortraitImage.Visible = false
                else
                    v59.Rig.Show(false)
                    v59.PortraitImage.Visible = true
                    UIArt.Apply(v59.PortraitImage, v61.Art)
                end

                v59.Badge.Visible = not v62 and v48.selected == v58

                local v63 = v61 and not v62 and v61.Number or nil
                local v64 = v63 and Parent.UIArt:FindFirstChild(v63)

                v59.Number.Visible = v64 ~= nil

                if v64 then
                    local v65 = v64:GetAttribute("W") or 2
                    local v66 = v64:GetAttribute("H") or 1
                    local v68 = math.min(54, 104 * v66 / v65)

                    v59.Number.Size = UDim2.fromOffset(math.floor(v68 * v65 / v66 + 0.5), (math.floor(v68 + 0.5)))

                    if v59.NumberArt ~= v63 then
                        v59.NumberArt = v63
                        v59.Number.ImageContent = Content.none
                        UIArt.Apply(v59.Number, v63)
                    end
                end
            end

            showLegend(p56)
        end

        local function prompt(p57) -- line: 306
            -- upvalues: p3 (copy), p4 (copy), v48 (ref), MarketplaceService (copy), LegendsCatalog (copy)
            local v72 = LegendsCatalog.Passes[p57]

            if v72 then
                if v72 == 0 then
                    if p4 then
                        p4("COMING SOON")
                    end
                else
                    if p57 == "Slot3" and not v48.unlocked[2] then
                        if p4 then
                            p4("UNLOCK SLOT 2 FIRST")
                        end

                        return
                    end

                    MarketplaceService:PromptGamePassPurchase(p3, v72)
                end
            else
                local v73 = LegendsCatalog.Products[p57]

                if not v73 or v73 == 0 then
                    if p4 then
                        p4("COMING SOON")
                    end
                else
                    MarketplaceService:PromptProductPurchase(p3, v73)
                end
            end
        end

        local v74, Frame4, ImageLabel4

        for i = 1, LegendsCatalog.SlotCount do
            v74 = (i - 1) * 307 + 123

            local ImageButton = Instance.new("ImageButton")

            ImageButton.Name = "Slot" .. i
            ImageButton.BackgroundTransparency = 1
            ImageButton.ImageTransparency = 1
            ImageButton.Position = UDim2.fromOffset(110, v74)
            ImageButton.Size = UDim2.fromOffset(209, 265)
            ImageButton.ZIndex = 42
            ImageButton.Parent = Frame3

            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "Card"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Position = UDim2.fromOffset(0, 0)
            ImageLabel.Size = UDim2.fromOffset(209, 265)
            ImageLabel.ZIndex = 43
            ImageLabel.Parent = ImageButton
            Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 18)

            local Frame = Instance.new("Frame")

            Frame.Name = "SolidLegendColor"
            Frame.BackgroundColor3 = v10
            Frame.BorderSizePixel = 0
            Frame.Position = UDim2.fromOffset(8, 8)
            Frame.Size = UDim2.fromOffset(193, 249)
            Frame.ZIndex = 43
            Frame.ClipsDescendants = true
            Frame.Visible = false
            Frame.Parent = ImageButton
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

            local Frame2 = Instance.new("Frame")

            Frame2.Name = "SlotShine"
            Frame2.BackgroundColor3 = v1
            Frame2.BorderSizePixel = 0
            Frame2.Size = UDim2.fromScale(1, 1)
            Frame2.ZIndex = 43
            Frame2.Parent = Frame

            local Frame5 = Instance.new("UIGradient")

            Frame5.Name = "LeftToRightShine"
            Frame5.Rotation = 15
            Frame5.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.34, 1),
                NumberSequenceKeypoint.new(0.5, 0.6),
                NumberSequenceKeypoint.new(0.66, 1),
                NumberSequenceKeypoint.new(1, 1)
            })
            Frame5.Offset = Vector2.new(-1.2, 0)
            Frame5.Parent = Frame2
            table.insert(t3, {
                Surface = Frame,
                Gradient = Frame5
            })
            Frame5 = Instance.new("Frame")
            Frame5.Name = "Empty"
            Frame5.BackgroundColor3 = v1
            Frame5.BorderSizePixel = 0
            Frame5.Position = UDim2.fromOffset(1, 1)
            Frame5.Size = UDim2.fromOffset(207, 263)
            Frame5.ZIndex = 43
            Frame5.Parent = ImageButton
            Instance.new("UICorner", Frame5).CornerRadius = UDim.new(0, 18)
            Frame4 = Instance.new("Frame")
            Frame4.Name = "Inner"
            Frame4.BackgroundColor3 = v2
            Frame4.BorderSizePixel = 0
            Frame4.Position = UDim2.fromOffset(8, 8)
            Frame4.Size = UDim2.fromOffset(191, 247)
            Frame4.ZIndex = 44
            Frame4.Parent = Frame5
            Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 12)
            Frame4 = text(Frame4, "Mark", "?", 0, 0, 191, 247, 120)
            Frame4.AutoLocalize = false
            Frame4.TextColor3 = Color3.fromRGB(75, 75, 75)
            Frame4.ZIndex = 45
            Frame4 = Instance.new("Frame")
            Frame4.Name = "Portrait"
            Frame4.ClipsDescendants = true
            Frame4.BackgroundTransparency = 1
            Frame4.Position = UDim2.fromOffset(9, 9)
            Frame4.Size = UDim2.fromOffset(191, 247)
            Frame4.ZIndex = 44
            Frame4.Parent = ImageButton
            Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 12)

            local ImageLabel2 = Instance.new("ImageLabel")

            ImageLabel2.Name = "Rider"
            ImageLabel2.BackgroundTransparency = 1
            ImageLabel2.Position = UDim2.fromOffset(-47, 17)
            ImageLabel2.Size = UDim2.fromOffset(279, 349)
            ImageLabel2.ZIndex = 44
            ImageLabel2.Parent = Frame4

            local Frame6 = Instance.new("Frame")

            Frame6.Name = "RigClip"
            Frame6.BackgroundTransparency = 1
            Frame6.BorderSizePixel = 0
            Frame6.ClipsDescendants = true
            Frame6.Position = UDim2.fromOffset(-191, -391)
            Frame6.Size = UDim2.fromOffset(591, 647)
            Frame6.ZIndex = 44
            Frame6.Visible = false
            Frame6.Parent = ImageButton

            local v75 = newRigView(Frame6, 44, "Slot", function(p58) -- line: 348
                p58.AnchorPoint = Vector2.new(0.5, 0.5)
                p58.Position = UDim2.fromOffset(295.5, 523.5)
                p58.Size = UDim2.fromOffset(362.9, 469.29999999999995)
            end, 1.9)
            local v76 = image(ImageButton, "Selected", "SelectedSlot", 1, -1, 58, 58, 46)

            ImageLabel4 = Instance.new("ImageLabel")
            ImageLabel4.Name = "RiderNumber"
            ImageLabel4.BackgroundTransparency = 1
            ImageLabel4.Position = UDim2.fromOffset(0, 0)
            ImageLabel4.Size = UDim2.fromOffset(0, 0)
            ImageLabel4.ZIndex = 46
            ImageLabel4.Parent = ImageButton
            ImageLabel4.AnchorPoint = Vector2.new(1, 1)
            ImageLabel4.Position = UDim2.fromOffset(204, 261)
            ImageLabel4.Visible = false

            local Frame7 = Instance.new("Frame")

            Frame7.Name = "Hover"
            Frame7.BackgroundColor3 = v1
            Frame7.BackgroundTransparency = 1
            Frame7.BorderSizePixel = 0
            Frame7.Position = UDim2.fromOffset(9, 9)
            Frame7.Size = UDim2.fromOffset(191, 247)
            Frame7.ZIndex = 45
            Frame7.Parent = ImageButton
            Instance.new("UICorner", Frame7).CornerRadius = UDim.new(0, 12)
            pressable(ImageButton, function(p59) -- line: 356
                -- upvalues: Frame7 (copy), TweenService (copy)
                TweenService:Create(Frame7, TweenInfo.new(0.18), {
                    BackgroundTransparency = p59 and 0.85 or 1
                }):Play()
            end)
            t11[i] = {
                Button = ImageButton,
                Card = ImageLabel,
                Solid = Frame,
                Empty = Frame5,
                Portrait = Frame4,
                PortraitImage = ImageLabel2,
                Badge = v76,
                Rig = v75,
                Number = ImageLabel4,
                RigClip = Frame6
            }
            ImageButton.Activated:Connect(function() -- line: 358
                -- upvalues: p4 (copy), v48 (ref), v49 (ref), switchLegend (copy), prompt (copy), i (copy), Parent (copy)
                if not v49 then
                    if v48.unlocked[i] then
                        if v48.selected ~= i then
                            v48.selected = i
                            switchLegend()
                            task.spawn(function() -- line: 363
                                -- upvalues: p4 (copy), i (copy), Parent (copy)
                                local function v78() -- line: 364
                                    -- upvalues: i (copy), Parent (copy)
                                    return Parent:WaitForChild("LegendsAction"):InvokeServer("Select", i)
                                end

                                local ok, result = pcall(v78)

                                if ok and result and not result.ok and result.err then
                                    local err = result.err

                                    if p4 then
                                        p4(err)
                                    end
                                end
                            end)
                        end
                    else
                        prompt("Slot" .. i)
                    end
                end
            end)
        end

        local ImageButton = Instance.new("ImageButton")

        ImageButton.Name = "IndexButton"
        ImageButton.BackgroundTransparency = 1
        ImageButton.ImageTransparency = 1
        ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageButton.Position = UDim2.fromOffset(1751, 537)
        ImageButton.Size = UDim2.fromOffset(124, 134)
        ImageButton.ZIndex = 43
        ImageButton.Parent = Frame3

        local v79 = image(ImageButton, "Icon", "IndexHelmet", 8, 0, 108, 90, 44)
        local v80 = text(ImageButton, "Label", "INDEX", 0, 94, 124, 40, 33)

        v80.ZIndex = 44
        pressable(ImageButton, function(p60) -- line: 381
            -- upvalues: v1 (copy), v3 (copy), v79 (copy), v80 (copy), TweenService (copy)
            TweenService:Create(v79, TweenInfo.new(0.18), {
                ImageColor3 = p60 and v3 or v1
            }):Play()
            TweenService:Create(v80, TweenInfo.new(0.18), {
                TextColor3 = p60 and v3 or v1
            }):Play()
        end)
        v74 = p3:WaitForChild("PlayerGui")

        local ScreenGui2 = Instance.new("ScreenGui")

        ScreenGui2.Name = "LegendsIndexBackdrop"
        ScreenGui2.ScreenInsets = Enum.ScreenInsets.None
        ScreenGui2.IgnoreGuiInset = true
        ScreenGui2.ResetOnSpawn = false
        ScreenGui2.Enabled = false
        ScreenGui2.Parent = v74

        local Frame5 = Instance.new("Frame")

        Frame5.Name = "Dim"
        Frame5.BorderSizePixel = 0
        Frame5.BackgroundColor3 = Color3.fromRGB(3, 5, 9)
        Frame5.BackgroundTransparency = 1
        Frame5.Size = UDim2.fromScale(1, 1)
        Frame5.Active = true
        Frame5.Parent = ScreenGui2

        local Frame6 = Instance.new("Frame")

        Frame6.Name = "Blur"
        Frame6.BackgroundTransparency = 1
        Frame6.Size = UDim2.fromScale(1, 1)
        Frame6.Parent = ScreenGui2

        Frame4 = function() -- line: 392
            -- upvalues: Frame6 (copy)
            Instance.new("UIBlur").Parent = Frame6
        end

        pcall(Frame4)

        local ScreenGui3 = Instance.new("ScreenGui")

        ScreenGui3.Name = "LegendsIndex"
        ScreenGui3.ScreenInsets = p1.ScreenInsets
        ScreenGui3.IgnoreGuiInset = p1.IgnoreGuiInset
        ScreenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui3.ResetOnSpawn = false
        ScreenGui3.Enabled = false
        ScreenGui3.Parent = v74

        local Frame7 = Instance.new("Frame")

        Frame7.Name = "Pop"
        Frame7.BackgroundTransparency = 1
        Frame7.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame7.Position = UDim2.fromScale(0.5, 0.5)
        Frame7.Size = UDim2.fromScale(1, 1)
        Frame7.Parent = ScreenGui3
        Instance.new("UIScale", Frame7)
        Frame4 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)

        local Frame8 = Instance.new("Frame")

        Frame8.Name = "IndexWindow"
        Frame8.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame8.Position = UDim2.fromScale(0.5, 0.5)
        Frame8.Size = UDim2.fromOffset(290, 232)
        Frame8.BackgroundColor3 = v2
        Frame8.BorderSizePixel = 0
        Frame8.Active = true
        Frame8.Parent = Frame7
        Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 4)

        local UIScale3 = Instance.new("UIScale", Frame8)

        local function winFit() -- line: 404
            local ViewportSize = workspace.CurrentCamera.ViewportSize

            return (math.min(ViewportSize.Y / 360, (ViewportSize.X - 24) / 330))
        end

        local function winLabel(p61, p62, p63, p64, p65) -- line: 405
            -- upvalues: Frame8 (copy)
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = p61
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = p62
            TextLabel.FontFace = p63
            TextLabel.TextSize = p64
            TextLabel.TextColor3 = p65
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.AutoLocalize = false
            TextLabel.Parent = Frame8

            return TextLabel
        end

        ImageLabel4 = Instance.new("TextLabel")
        ImageLabel4.Name = "Title"
        ImageLabel4.BackgroundTransparency = 1
        ImageLabel4.Text = "INDEX"
        ImageLabel4.FontFace = v4
        ImageLabel4.TextSize = 12
        ImageLabel4.TextColor3 = v1
        ImageLabel4.TextXAlignment = Enum.TextXAlignment.Left
        ImageLabel4.AutoLocalize = false
        ImageLabel4.Parent = Frame8
        ImageLabel4.Position = UDim2.fromOffset(13, 8)
        ImageLabel4.Size = UDim2.fromOffset(160, 14)
        ImageLabel4 = Instance.new("Frame")
        ImageLabel4.Name = "Divider"
        ImageLabel4.BorderSizePixel = 0
        ImageLabel4.BackgroundColor3 = v1
        ImageLabel4.Position = UDim2.fromOffset(12, 27)
        ImageLabel4.Size = UDim2.fromOffset(99, 1)
        ImageLabel4.Parent = Frame8

        local TextButton2 = Instance.new("UIGradient")

        TextButton2.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.8, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        TextButton2.Parent = ImageLabel4
        TextButton2 = Color3.fromRGB(150, 154, 162)

        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "FoundCount"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = ""
        TextLabel.FontFace = Frame4
        TextLabel.TextSize = 8
        TextLabel.TextColor3 = TextButton2
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.AutoLocalize = false
        TextLabel.Parent = Frame8
        TextLabel.AnchorPoint = Vector2.new(1, 0.5)
        TextLabel.Position = UDim2.new(1, -48, 0, 18)
        TextLabel.Size = UDim2.fromOffset(60, 14)
        TextLabel.TextXAlignment = Enum.TextXAlignment.Right
        TextButton2 = Instance.new("TextButton")
        TextButton2.Name = "Close"
        TextButton2.Text = ""
        TextButton2.AutoButtonColor = false
        TextButton2.BackgroundTransparency = 1
        TextButton2.BorderSizePixel = 0
        TextButton2:SetAttribute("NoHover", true)
        TextButton2.AnchorPoint = Vector2.new(0.5, 0.5)
        TextButton2.Position = UDim2.new(1, -26, 0, 18)
        TextButton2.Size = UDim2.fromOffset(30, 16)
        TextButton2.ZIndex = 3
        TextButton2.Parent = Frame8

        local ImageLabel5 = Instance.new("ImageLabel")

        ImageLabel5.Name = "Plate"
        ImageLabel5.BackgroundTransparency = 1
        ImageLabel5.Size = UDim2.fromScale(1, 1)
        ImageLabel5.ImageContent = RaceIcons.Get("ref_top_plate")
        ImageLabel5.ImageColor3 = v1
        ImageLabel5.ZIndex = 3
        ImageLabel5.Parent = TextButton2

        local TextLabel2 = Instance.new("TextLabel")

        TextLabel2.Name = "X"
        TextLabel2.BackgroundTransparency = 1
        TextLabel2.Text = "X"
        TextLabel2.FontFace = v4
        TextLabel2.TextSize = 10
        TextLabel2.TextColor3 = v2
        TextLabel2.AutoLocalize = false
        TextLabel2.Size = UDim2.fromScale(1, 1)
        TextLabel2.ZIndex = 4
        TextLabel2.Parent = TextButton2

        local function closeHover(p66) -- line: 419
            -- upvalues: v1 (copy), v2 (copy), v3 (copy), ImageLabel5 (copy), TextLabel2 (copy), TweenService (copy)
            TweenService:Create(ImageLabel5, TweenInfo.new(0.18), {
                ImageColor3 = p66 and v3 or v1
            }):Play()
            TweenService:Create(TextLabel2, TweenInfo.new(0.18), {
                TextColor3 = p66 and v1 or v2
            }):Play()
        end

        TextButton2.MouseEnter:Connect(function() -- line: 420
            -- upvalues: closeHover (copy)
            closeHover(true)
        end)
        TextButton2.MouseLeave:Connect(function() -- line: 420
            -- upvalues: closeHover (copy)
            closeHover(false)
        end)
        TextButton2.SelectionGained:Connect(function() -- line: 421
            -- upvalues: closeHover (copy)
            closeHover(true)
        end)
        TextButton2.SelectionLost:Connect(function() -- line: 421
            -- upvalues: closeHover (copy)
            closeHover(false)
        end)

        local ScrollingFrame = Instance.new("ScrollingFrame")

        ScrollingFrame.Name = "Cards"
        ScrollingFrame.BackgroundTransparency = 1
        ScrollingFrame.BorderSizePixel = 0
        ScrollingFrame.Position = UDim2.fromOffset(8, 34)
        ScrollingFrame.Size = UDim2.fromOffset(274, 192)
        ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        ScrollingFrame.ScrollBarThickness = 2
        ScrollingFrame.ScrollBarImageColor3 = v1
        ScrollingFrame.Parent = Frame8

        local v89 = math.max(1, (math.ceil(#LegendsCatalog.Order / 4)))

        ScrollingFrame.CanvasSize = UDim2.fromOffset(0, 22 + v89 * 71 + (v89 - 1) * 22 + 8)
        v89 = Instance.new("UIPadding", ScrollingFrame)
        v89.PaddingTop = UDim.new(0, 22)
        v89.PaddingBottom = UDim.new(0, 8)
        v89 = Instance.new("UIGridLayout")
        v89.CellSize = UDim2.fromOffset(56, 71)
        v89.CellPadding = UDim2.fromOffset(12, 22)
        v89.FillDirectionMaxCells = 4
        v89.HorizontalAlignment = Enum.HorizontalAlignment.Center
        v89.SortOrder = Enum.SortOrder.LayoutOrder
        v89.Parent = ScrollingFrame
        v89 = Color3.fromRGB(205, 210, 220)

        local v90 = LegendRig.OutlineThickness * 4
        local t17 = {}
        local v91

        for v92, v93 in LegendsCatalog.Order do
            v91 = LegendsCatalog.Legends[v93]

            local Frame = Instance.new("Frame")

            Frame.Name = "Legend_" .. v93
            Frame.LayoutOrder = v92
            Frame.BackgroundTransparency = 1
            Frame.Parent = ScrollingFrame

            local Frame2 = Instance.new("Frame")

            Frame2.Name = "Card"
            Frame2.BorderSizePixel = 0
            Frame2.BackgroundColor3 = v1
            Frame2.Size = UDim2.fromScale(1, 1)
            Frame2.ZIndex = 1
            Frame2.Parent = Frame
            Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 5)

            local Frame3 = Instance.new("Frame")

            Frame3.Name = "Fill"
            Frame3.BorderSizePixel = 0
            Frame3.BackgroundColor3 = v91.Color or v10
            Frame3.ClipsDescendants = true
            Frame3.Position = UDim2.fromOffset(2, 2)
            Frame3.Size = UDim2.fromOffset(52, 67)
            Frame3.ZIndex = 2
            Frame3.Parent = Frame
            Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 3)

            local Frame4 = Instance.new("Frame")

            Frame4.Name = "Shine"
            Frame4.BackgroundColor3 = v1
            Frame4.BorderSizePixel = 0
            Frame4.Size = UDim2.fromScale(1, 1)
            Frame4.Parent = Frame3

            local Frame5 = Instance.new("UIGradient")

            Frame5.Rotation = 15
            Frame5.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.34, 1),
                NumberSequenceKeypoint.new(0.5, 0.6),
                NumberSequenceKeypoint.new(0.66, 1),
                NumberSequenceKeypoint.new(1, 1)
            })
            Frame5.Offset = Vector2.new(-1.2, 0)
            Frame5.Parent = Frame4
            table.insert(t3, {
                Surface = Frame4,
                Gradient = Frame5
            })
            Frame5 = Instance.new("Frame")
            Frame5.Name = "RigClip"
            Frame5.BackgroundTransparency = 1
            Frame5.BorderSizePixel = 0
            Frame5.ClipsDescendants = true
            Frame5.Position = UDim2.fromOffset(-50, -65)
            Frame5.Size = UDim2.fromOffset(156, 134)
            Frame5.ZIndex = 3
            Frame5.Parent = Frame

            local function rigLayout(p67) -- line: 458
                p67.AnchorPoint = Vector2.new(0.5, 0.5)
                p67.Position = UDim2.fromOffset(78, 100.5)
                p67.Size = UDim2.fromOffset(98.8, 127.3)
            end

            local v95 = newRigView(Frame5, 1, "Slot", rigLayout, 1.9)
            local v94 = newRigView(Frame5, 1, "Slot", rigLayout, 1.9, v90)
            local v96 = v91.Rig ~= nil and v95.Set(v91.Rig) and v94.Set(v91.Rig)

            if v96 then
                v94.View.ImageColor3 = v2
                v94.Outline.ImageColor3 = v89
            end

            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "Rider"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Position = UDim2.fromOffset(39.4066985645933, 71.55502392344498)
            ImageLabel.Size = UDim2.fromOffset(74.75598086124403, 93.51196172248804)
            ImageLabel.ZIndex = 3
            ImageLabel.Parent = Frame5
            ImageLabel.Visible = not v96

            if not v96 and v91.Art then
                UIArt.Apply(ImageLabel, v91.Art)
            end

            local ImageLabel2 = Instance.new("ImageLabel")

            ImageLabel2.Name = "RiderNumber"
            ImageLabel2.BackgroundTransparency = 1
            ImageLabel2.Position = UDim2.fromOffset(0, 0)
            ImageLabel2.Size = UDim2.fromOffset(0, 0)
            ImageLabel2.ZIndex = 4
            ImageLabel2.Parent = Frame
            ImageLabel2.AnchorPoint = Vector2.new(1, 1)
            ImageLabel2.Position = UDim2.fromOffset(54.66028708133972, 69.93301435406698)
            ImageLabel2.Visible = false
            Frame = v91.Number and Parent.UIArt:FindFirstChild(v91.Number)

            if Frame then
                local v98 = Frame:GetAttribute("W") or 2
                local v99 = Frame:GetAttribute("H") or 1
                local v97 = math.min(14.468899521531101, 27.86602870813397 * v99 / v98)

                ImageLabel2.Size = UDim2.fromOffset(v97 * v98 / v99, v97)
                UIArt.Apply(ImageLabel2, v91.Number)
            end

            table.insert(t17, {
                Found = false,
                Id = v93,
                Legend = v91,
                Card = Frame2,
                Fill = Frame3,
                Shine = Frame4,
                Rig = v95,
                Shadow = v94,
                HasRig = v96,
                Art = ImageLabel,
                Number = ImageLabel2,
                HasNumber = Frame ~= nil
            })
        end

        local v101 = false

        local function refreshIndex() -- line: 480
            -- upvalues: v1 (copy), v2 (copy), v10 (copy), v48 (ref), TextLabel (copy), t17 (copy), v101 (ref), LegendsCatalog (copy)
            local n4 = 0

            for _, v102 in t17 do
                local v103 = LegendsCatalog.Found(v48, v102.Id)

                v102.Found = v103

                if v103 then
                    n4 += 1
                end

                v102.Card.BackgroundColor3 = v103 and v1 or Color3.fromRGB(55, 60, 70)

                local Fill = v102.Fill

                if v103 then
                    Fill.BackgroundColor3 = v102.Legend.Color or v10 or v2
                else
                    Fill.BackgroundColor3 = v2
                end

                v102.Shine.Visible = v103
                v102.Number.Visible = v103 and v102.HasNumber

                if not v102.HasRig then
                    v102.Art.ImageColor3 = v103 and v1 or v2
                end

                if v101 then
                    v102.Rig.Show(v102.HasRig and v103)
                    v102.Shadow.Show(v102.HasRig and not v103)
                end
            end

            TextLabel.Text = n4 .. " / " .. #t17
        end

        local function setIndex(p68) -- line: 494
            -- upvalues: p1 (copy), p3 (copy), v48 (ref), ScreenGui2 (copy), Frame5 (copy), ScreenGui3 (copy), UIScale3 (copy), ScrollingFrame (copy), t17 (copy), v101 (ref), refreshIndex (copy), HttpService (copy), LegendsCatalog (copy)
            if v101 == p68 then
                return
            end

            v101 = p68

            if p68 then
                local JSONDecode = HttpService.JSONDecode
                local v104 = p3:GetAttribute("LegendsState") or "{}"
                local ok, result = pcall(JSONDecode, HttpService, v104)

                v48 = LegendsCatalog.Clean(if not ok or not result then nil else result)
                refreshIndex()
                ScreenGui2.DisplayOrder = p1.DisplayOrder + 1
                ScreenGui3.DisplayOrder = p1.DisplayOrder + 2

                local ViewportSize = workspace.CurrentCamera.ViewportSize

                UIScale3.Scale = math.min(ViewportSize.Y / 360, (ViewportSize.X - 24) / 330)
                ScrollingFrame.CanvasPosition = Vector2.zero
                ScreenGui2.Enabled = true
                ScreenGui3.Enabled = true
                Frame5.BackgroundTransparency = 0.35
            else
                ScreenGui2.Enabled = false
                ScreenGui3.Enabled = false

                for _, v107 in t17 do
                    v107.Rig.Show(false)
                    v107.Shadow.Show(false)
                end
            end
        end

        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 508
            -- upvalues: UIScale3 (copy), v101 (ref)
            if not v101 then
                return
            end

            local ViewportSize = workspace.CurrentCamera.ViewportSize

            UIScale3.Scale = math.min(ViewportSize.Y / 360, (ViewportSize.X - 24) / 330)
        end)
        ImageButton.Activated:Connect(function() -- line: 509
            -- upvalues: p1 (copy), p3 (copy), v48 (ref), v49 (ref), ScreenGui2 (copy), Frame5 (copy), ScreenGui3 (copy), UIScale3 (copy), ScrollingFrame (copy), v101 (ref), refreshIndex (copy), HttpService (copy), LegendsCatalog (copy)
            if v49 or v101 == true then
                return
            end

            v101 = true

            local JSONDecode = HttpService.JSONDecode
            local v110 = p3:GetAttribute("LegendsState") or "{}"
            local ok, result = pcall(JSONDecode, HttpService, v110)

            v48 = LegendsCatalog.Clean(if not ok or not result then nil else result)
            refreshIndex()
            ScreenGui2.DisplayOrder = p1.DisplayOrder + 1
            ScreenGui3.DisplayOrder = p1.DisplayOrder + 2

            local ViewportSize = workspace.CurrentCamera.ViewportSize

            UIScale3.Scale = math.min(ViewportSize.Y / 360, (ViewportSize.X - 24) / 330)
            ScrollingFrame.CanvasPosition = Vector2.zero
            ScreenGui2.Enabled = true
            ScreenGui3.Enabled = true
            Frame5.BackgroundTransparency = 0.35
        end)
        TextButton2.Activated:Connect(function() -- line: 510
            -- upvalues: setIndex (copy)
            setIndex(false)
        end)
        p3:GetAttributeChangedSignal("LegendsState"):Connect(function() -- line: 511
            -- upvalues: p3 (copy), v48 (ref), v101 (ref), refreshIndex (copy), HttpService (copy), LegendsCatalog (copy)
            if v101 then
                task.delay(0.15, function() -- line: 511
                    -- upvalues: p3 (copy), v48 (ref), v101 (ref), refreshIndex (copy), HttpService (copy), LegendsCatalog (copy)
                    if not v101 then
                        return
                    end

                    local JSONDecode = HttpService.JSONDecode
                    local v113 = p3:GetAttribute("LegendsState") or "{}"
                    local ok, result = pcall(JSONDecode, HttpService, v113)

                    v48 = LegendsCatalog.Clean(ok and result or nil)
                    refreshIndex()
                end)
            end
        end)

        local function revealRoll(p69, p70) -- line: 516
            -- upvalues: p3 (copy), v9 (copy), UIGradient (copy), v11 (ref), ImageLabel (copy), v19 (copy), ImageLabel2 (copy), UIScale2 (copy), v30 (copy), v48 (ref), v49 (ref), n2 (ref), refresh (ref), n3 (ref), showLegend (copy), TweenService (copy), HttpService (copy), LegendsCatalog (copy)
            if LegendsCatalog.Legends[p69] then
                n2 += 1

                local v114 = n2

                n3 += 1

                for _, v115 in {
                        v30.View,
                        v30.Outline,
                        ImageLabel2,
                        ImageLabel
                    } do
                    v115.ImageTransparency = 0
                end

                UIScale2.Scale = 1
                v49 = true
                v48.slots[p70] = p69
                v48.selected = p70

                local ImageLabelPosition = ImageLabel2.Position

                task.spawn(function() -- line: 523
                    -- upvalues: p69 (copy), p70 (copy), v114 (copy), ImageLabelPosition (copy), p3 (copy), v9 (copy), UIGradient (copy), v11 (ref), v19 (copy), ImageLabel2 (copy), v30 (copy), v48 (ref), v49 (ref), n2 (ref), refresh (ref), showLegend (copy), TweenService (copy), HttpService (copy), LegendsCatalog (copy)
                    local elapsed = os.clock()

                    for i = 1, 24 do
                        if v114 ~= n2 then
                            return
                        end

                        local v116 = LegendsCatalog.Order[(i - 1) % #LegendsCatalog.Order + 1]

                        if i == 24 then
                            v116 = p69
                        end

                        showLegend(false, v116)
                        v30.Silhouette(true)
                        v11 = false
                        UIGradient.Offset = Vector2.new(-0.7, 0)
                        v19.TextTransparency = 0.3
                        ImageLabel2.Position = ImageLabelPosition + UDim2.fromOffset(0, -7)
                        TweenService:Create(ImageLabel2, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = ImageLabelPosition
                        }):Play()

                        local v117 = (1 - (1 - i / 24) ^ 0.3333333333333333) * 3.8

                        task.wait((math.max(0, v117 - (os.clock() - elapsed))))
                    end

                    if v114 ~= n2 then
                        return
                    end

                    v49 = false

                    local JSONDecode = HttpService.JSONDecode
                    local v119 = p3:GetAttribute("LegendsState") or "{}"
                    local ok, result = pcall(JSONDecode, HttpService, v119)

                    v48 = LegendsCatalog.Clean(if not ok or not result then nil else result)
                    v48.slots[p70] = p69
                    v48.selected = p70
                    ImageLabel2.Position = ImageLabelPosition
                    refresh(false)
                    v30.Fade()
                    v9.TextTransparency = 0.5
                    v19.TextTransparency = 0.6
                    TweenService:Create(v9, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0
                    }):Play()
                    TweenService:Create(v19, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0
                    }):Play()
                end)
            else
                v49 = false

                local JSONDecode = HttpService.JSONDecode
                local v120 = p3:GetAttribute("LegendsState") or "{}"
                local ok, result = pcall(JSONDecode, HttpService, v120)

                v48 = LegendsCatalog.Clean(if not ok or not result then nil else result)
                refresh(false)
            end
        end

        v47.Activated:Connect(function() -- line: 546
            -- upvalues: p3 (copy), p4 (copy), v48 (ref), v49 (ref), refresh (ref), revealRoll (copy), HttpService (copy), Parent (copy), LegendsCatalog (copy)
            if v49 then
                return
            end

            if (p3:GetAttribute("Money") or 0) < LegendsCatalog.Prices.RollMoney then
                if p4 then
                    p4("INSUFFICIENT MONEY")
                end
            else
                v49 = true

                local function v121() -- line: 550
                    -- upvalues: Parent (copy)
                    return Parent:WaitForChild("LegendsAction"):InvokeServer("RollMoney")
                end

                local ok, result = pcall(v121)

                if not ok or not result then
                    v49 = false

                    if p4 then
                        p4("TRY AGAIN")
                    end

                    local JSONDecode = HttpService.JSONDecode
                    local v122 = p3:GetAttribute("LegendsState") or "{}"
                    local ok, result = pcall(JSONDecode, HttpService, v122)

                    v48 = LegendsCatalog.Clean(if not ok or not result then nil else result)
                    refresh(false)
                elseif result.ok then
                    local JSONDecode = HttpService.JSONDecode
                    local v123 = p3:GetAttribute("LegendsState") or "{}"
                    local ok, result2 = pcall(JSONDecode, HttpService, v123)

                    v48 = LegendsCatalog.Clean(if not ok or not result2 then nil else result2)
                    revealRoll(result.legend, result.slot)
                else
                    v49 = false

                    if result.err then
                        local err = result.err

                        if p4 then
                            p4(err)
                        end
                    end

                    local JSONDecode = HttpService.JSONDecode
                    local v124 = p3:GetAttribute("LegendsState") or "{}"
                    local ok, result2 = pcall(JSONDecode, HttpService, v124)

                    v48 = LegendsCatalog.Clean(if not ok or not result2 then nil else result2)
                    refresh(false)
                end
            end
        end)
        v46.Activated:Connect(function() -- line: 555
            -- upvalues: p3 (copy), p4 (copy), v49 (ref), MarketplaceService (copy), LegendsCatalog (copy)
            if not v49 then
                local Roll = LegendsCatalog.Passes.Roll

                if Roll then
                    if Roll ~= 0 then
                        MarketplaceService:PromptGamePassPurchase(p3, Roll)
                    elseif p4 then
                        p4("COMING SOON")
                    end
                else
                    local Roll = LegendsCatalog.Products.Roll

                    if not Roll or Roll == 0 then
                        if p4 then
                            p4("COMING SOON")
                        end
                    else
                        MarketplaceService:PromptProductPurchase(p3, Roll)
                    end
                end
            end
        end)
        task.spawn(function() -- line: 556
            -- upvalues: p3 (copy), v48 (ref), v49 (ref), refresh (ref), revealRoll (copy), HttpService (copy), Parent (copy), LegendsCatalog (copy)
            Parent:WaitForChild("LegendsEvent").OnClientEvent:Connect(function(p71, p72, p73) -- line: 557
                -- upvalues: p3 (copy), v48 (ref), v49 (ref), refresh (ref), revealRoll (copy), HttpService (copy), LegendsCatalog (copy)
                local JSONDecode = HttpService.JSONDecode
                local v125 = p3:GetAttribute("LegendsState") or "{}"
                local ok, result = pcall(JSONDecode, HttpService, v125)

                v48 = LegendsCatalog.Clean(if not ok or not result then nil else result)

                if p71 == "Rolled" then
                    revealRoll(p72, p73)
                elseif p71 == "Unlocked" then
                    v48.unlocked[p72] = true

                    if p73 ~= false then
                        v48.selected = p72
                    end

                    if not v49 then
                        refresh(false)
                    end
                end
            end)
        end)
        p3:GetAttributeChangedSignal("LegendsState"):Connect(function() -- line: 563
            -- upvalues: p3 (copy), v48 (ref), v49 (ref), refresh (ref), HttpService (copy), LegendsCatalog (copy)
            task.delay(0.12, function() -- line: 565
                -- upvalues: p3 (copy), v48 (ref), v49 (ref), refresh (ref), HttpService (copy), LegendsCatalog (copy)
                local JSONDecode = HttpService.JSONDecode
                local v126 = p3:GetAttribute("LegendsState") or "{}"
                local ok, result = pcall(JSONDecode, HttpService, v126)

                v48 = LegendsCatalog.Clean(if not ok or not result then nil else result)

                if not v49 then
                    refresh(false)
                end
            end)
        end)

        local v127

        local function result() -- line: 569
            -- upvalues: p3 (copy), v127 (ref)
            v127 = require(p3.PlayerScripts:FindFirstChild("PlayerModule")):GetControls()
        end

        pcall(result)
        Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 570
            -- upvalues: p1 (copy), p2 (copy), p3 (copy), Frame (copy), v37 (copy), v48 (ref), v49 (ref), n2 (ref), refresh (ref), setIndex (copy), v127 (ref), HttpService (copy), LegendsCatalog (copy)
            if Frame.Visible then
                p1.DisplayOrder = 30
                p2:SetAttribute("LegendsOpen", true)

                if v127 then
                    v127:Disable()
                end

                local JSONDecode = HttpService.JSONDecode
                local v128 = p3:GetAttribute("LegendsState") or "{}"
                local ok, result = pcall(JSONDecode, HttpService, v128)

                v48 = LegendsCatalog.Clean(if not ok or not result then nil else result)
                v37(p3:GetAttribute("Money") or 0)
                refresh(false)
            else
                n2 += 1
                v49 = false
                setIndex(false)
                p1.DisplayOrder = 9
                p2:SetAttribute("LegendsOpen", false)

                if v127 then
                    v127:Enable()
                end
            end
        end)
        p3.CharacterAdded:Connect(function() -- line: 579
            -- upvalues: Frame (copy)
            Frame.Visible = false
        end)
        result = HttpService.JSONDecode
        v91 = p3:GetAttribute("LegendsState") or "{}"

        local Visible

        Visible, result = pcall(result, HttpService, v91)
        v48 = LegendsCatalog.Clean(if not Visible or not result then nil else result)
        refresh(false)
        t2.Frame = Frame

        return t2
    end
}
