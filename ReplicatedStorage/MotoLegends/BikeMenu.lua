-- https://lua.expert

game:GetService("Players")

local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local AssetService = game:GetService("AssetService")
local ContentProvider = game:GetService("ContentProvider")
local Parent = script.Parent
local Config = require(Parent.Config)
local BikeCatalog = require(Parent.BikeCatalog)
local RaceIcons = require(Parent.RaceIcons)
local UIArt = require(Parent.UIArt)
local NumberFormat = require(Parent.NumberFormat)
local BikeStats = require(Parent.BikeStats)
local t1 = {}
local v1 = Color3.fromRGB(7, 12, 21)
local v2 = -Config.RideHeight
local v4 = Vector3.new(-1.05, v2 + 2.6, 0.45)
local t2 = {}

local function silhouette(p1, p2) -- line: 39
    -- upvalues: AssetService (copy), t2 (copy)
    if t2[p1] then
        return t2[p1]
    end

    local function v5() -- line: 41
        -- upvalues: p2 (copy), AssetService (copy)
        local Object = p2.Object
        local Size = Object.Size
        local v6 = Object:ReadPixelsBuffer(Vector2.zero, Size)

        for i = 0, Size.X * Size.Y - 1 do
            buffer.writeu8(v6, i * 4, 255)
            buffer.writeu8(v6, i * 4 + 1, 255)
            buffer.writeu8(v6, i * 4 + 2, 255)

            if i % 40000 == 0 then
                task.wait()
            end
        end

        local v7 = AssetService:CreateEditableImage({
            Size = Size
        })

        v7:WritePixelsBuffer(Vector2.zero, Size, v6)

        return Content.fromObject(v7)
    end

    local ok, result = pcall(v5)

    if ok then
        t2[p1] = result

        return result
    end

    warn("BikeMenu shine " .. p1 .. ": " .. tostring(result))
end

local function dotsImage() -- line: 55
    -- upvalues: AssetService (copy)
    local v8 = buffer.create(3240000)

    for i = -21, 21 do
        for j = -21, 21 do
            local v9 = j * 21.43 + 450
            local v10 = i * 21.43 + 450
            local v12 = math.sqrt((v9 - 450) ^ 2 + (v10 - 450) ^ 2) / 445

            if v12 < 1 then
                local v13 = (1 - v12) ^ 0.42 * 3.4

                if v13 > 0.45 then
                    for k = math.max(0, (math.floor(v10 - v13 - 1))), math.min(899, (math.ceil(v10 + v13 + 1))) do
                        for n = math.max(0, (math.floor(v9 - v13 - 1))), math.min(899, (math.ceil(v9 + v13 + 1))) do
                            local v26 = math.clamp(v13 - math.sqrt((n + 0.5 - v9) ^ 2 + (k + 0.5 - v10) ^ 2) + 0.5, 0, 1)

                            if v26 > 0 then
                                local v28 = math.floor(v26 * 255 + 0.5) * 16777216 + 4735036

                                buffer.writeu32(v8, (k * 900 + n) * 4, v28)
                            end
                        end
                    end
                end
            end
        end
    end

    local v29 = AssetService:CreateEditableImage({
        Size = Vector2.new(900, 900)
    })

    v29:WritePixelsBuffer(Vector2.zero, Vector2.new(900, 900), v8)

    return Content.fromObject(v29)
end

function t1.New(p3, p4, p5, p6) -- line: 79
    -- upvalues: RunService (copy), ContextActionService (copy), UserInputService (copy), TweenService (copy), HttpService (copy), AssetService (copy), ContentProvider (copy), Parent (copy), Config (copy), BikeCatalog (copy), RaceIcons (copy), UIArt (copy), NumberFormat (copy), BikeStats (copy), v1 (copy), v2 (copy), v4 (copy), silhouette (copy), dotsImage (copy)
    local t3 = {}
    local v30 = Color3.new(1, 1, 1)
    local v31 = Color3.new(0, 0, 0)
    local v32 = Color3.fromRGB(231, 0, 0)
    local v33 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)

    local function tween(p7, p8, p9, p10, p11) -- line: 82
        -- upvalues: TweenService (copy)
        local tween = TweenService:Create(p7, TweenInfo.new(p9 or 0.2, p10 or Enum.EasingStyle.Quad, p11 or Enum.EasingDirection.Out), p8)

        tween:Play()

        return tween
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "BikeSelection"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Visible = false
    Frame.ZIndex = 40
    Frame.Parent = p3

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "BikeSelectionStage"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = v1
    Frame2.BackgroundTransparency = 1
    Frame2.Size = UDim2.fromScale(1, 1)
    Frame2.Visible = false
    Frame2.ZIndex = 40
    Frame2.Active = true
    Frame2.Parent = p3

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "BikeSelectionBackdrop"
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Enabled = false
    ScreenGui.Parent = p5:WaitForChild("PlayerGui")

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "Background"
    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = v1
    Frame3.Size = UDim2.fromScale(1, 1)
    Frame3.Active = true
    Frame3.Parent = ScreenGui

    local function syncBackdrop() -- line: 95
        -- upvalues: p3 (copy), Frame2 (copy), ScreenGui (copy)
        ScreenGui.Enabled = Frame2.Visible and p3.Enabled
        ScreenGui.DisplayOrder = p3.DisplayOrder - 1
    end

    Frame2:GetPropertyChangedSignal("Visible"):Connect(syncBackdrop)
    p3:GetPropertyChangedSignal("DisplayOrder"):Connect(syncBackdrop)
    p3:GetPropertyChangedSignal("Enabled"):Connect(syncBackdrop)
    ScreenGui.Enabled = Frame2.Visible and p3.Enabled
    ScreenGui.DisplayOrder = p3.DisplayOrder - 1

    local function layer(p12, p13) -- line: 97
        -- upvalues: Frame2 (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = p12
        Frame.BackgroundTransparency = 1
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromScale(0.5, 0.5)
        Frame.Size = UDim2.fromOffset(2000, 1125)
        Frame.ZIndex = p13
        Frame.Parent = Frame2

        return Frame, Instance.new("UIScale", Frame)
    end

    local Frame4 = Instance.new("Frame")

    Frame4.Name = "LightHolder"
    Frame4.BackgroundTransparency = 1
    Frame4.Size = UDim2.fromScale(1, 1)
    Frame4.ZIndex = 1
    Frame4.Parent = Frame3

    local function placeLights() -- line: 105
        -- upvalues: p3 (copy), ScreenGui (copy), Frame4 (copy)
        local v35 = math.max(0, p3.AbsolutePosition.Y - ScreenGui.AbsolutePosition.Y)
        local v37 = math.ceil(ScreenGui.AbsoluteSize.X * 0.2)

        Frame4.Position = UDim2.fromOffset(-v37, v35)
        Frame4.Size = UDim2.new(1, v37 * 2, 0, p3.AbsoluteSize.Y)
    end

    for _, v38 in { p3, ScreenGui } do
        v38:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeLights)
        v38:GetPropertyChangedSignal("AbsolutePosition"):Connect(placeLights)
    end

    placeLights()

    local Folder = Instance.new("Folder")

    Folder.Name = "LightSignal"

    local v39, v40 = layer("Backdrop", 2)
    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "BikePreview3D"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Size = UDim2.fromScale(1, 1)
    ViewportFrame.ZIndex = 4
    ViewportFrame.Ambient = Color3.fromRGB(150, 150, 160)
    ViewportFrame.LightColor = Color3.fromRGB(255, 248, 240)
    ViewportFrame.Parent = Frame2

    local WorldModel = Instance.new("WorldModel")

    WorldModel.Parent = ViewportFrame

    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 30
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera

    local v41, v42 = layer("ReferenceCanvas", 5)
    local t4 = {}

    for v43, v44 in BikeCatalog.Teams do
        t4[v43] = v44.Color
    end

    local t5 = {
        ColorSpeed = 2.5,
        LengthBreath = 0.12,
        ThicknessBreath = 0.22,
        DesignSize = Vector2.new(2000, 1125),
        Colors = t4,
        LightLanes = {
            {
                Top = 0,
                Bottom = 24,
                Center = 0.18,
                Height = 0.25
            },
            {
                Top = 24,
                Bottom = 39,
                Center = 0.47,
                Height = 0.19
            },
            {
                Top = 39,
                Bottom = 58,
                Center = 0.76,
                Height = 0.22
            }
        }
    }
    local MenuFX = Parent:FindFirstChild("MenuFX")
    local v45
    local TouchEnabled = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    if MenuFX and not TouchEnabled then
        local _require = require
        local MenuPreviewLighting = MenuFX.MenuPreviewLighting
        local ok

        ok, _require = pcall(_require, MenuPreviewLighting)

        if ok then
            v45 = _require.Attach(ViewportFrame, WorldModel, {
                Strength = 0.88,
                RimWidth = 5,
                FrontAmbient = Color3.fromRGB(200, 200, 210)
            }, Folder)
        end
    end

    local result

    local function startFX() -- line: 134
        -- upvalues: Frame (copy), Frame4 (copy), t5 (copy), MenuFX (copy), result (ref)
        if result and result.Parent or not MenuFX then
            return
        end

        local function v46() -- line: 137
            -- upvalues: Frame (copy), Frame4 (copy), t5 (copy), MenuFX (copy)
            return require(MenuFX.MenuBackgroundFX).Start(Frame4, Frame, t5)
        end

        local ok, result2 = pcall(v46)

        if ok then
            result = result2
        else
            warn("[BikeMenu] light FX: " .. tostring(result2))
        end
    end

    local function stopFX() -- line: 140
        -- upvalues: result (ref)
        if result then
            result:Destroy()
            result = nil
        end
    end

    local function refreshLighting() -- line: 143
        -- upvalues: v45 (ref)
        if v45 then
            v45.Refresh()
        end
    end

    local function fit() -- line: 144
        -- upvalues: v40 (copy), v42 (copy)
        local ViewportSize = workspace.CurrentCamera.ViewportSize
        local v49 = math.min(ViewportSize.X / 2000, ViewportSize.Y / 1125)

        v40.Scale = v49
        v42.Scale = v49
    end

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)

    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local v52 = math.min(ViewportSize.X / 2000, ViewportSize.Y / 1125)

    v40.Scale = v52
    v42.Scale = v52

    local t6 = {}
    local t7 = {}

    local function preloadDisplay(p14) -- line: 150
        -- upvalues: p5 (copy), t6 (copy), t7 (copy), ContentProvider (copy), Parent (copy)
        if t6[p14] then
            return
        end

        while t7[p14] do
            task.wait(0.05)
        end

        if not t6[p14] then
            local v53 = Parent:FindFirstChild(p14 .. "Display")

            if v53 then
                t7[p14] = true

                local t8 = {
                    v53
                }
                local Folder

                for _, descendant in v53:GetDescendants() do
                    local v54 = descendant:IsA("MeshPart") and descendant:GetAttribute("LiveryTexture")

                    if typeof(v54) == "string" and v54 ~= "" then
                        if not Folder then
                            Folder = Instance.new("Folder")
                            Folder.Name = "BikePreviewPreload"
                            Folder.Parent = p5.PlayerGui
                        end

                        local ImageLabel = Instance.new("ImageLabel")

                        ImageLabel.Visible = false
                        ImageLabel.Image = v54
                        ImageLabel.Parent = Folder
                        table.insert(t8, ImageLabel)
                    end
                end

                local function v55() -- line: 164
                    -- upvalues: t8 (copy), ContentProvider (copy)
                    ContentProvider:PreloadAsync(t8)
                end

                pcall(v55)

                if Folder then
                    Folder:Destroy()
                end

                t7[p14] = nil
                t6[p14] = true
            end
        end
    end

    local v50 = #BikeCatalog.Order
    local v51 = table.find(BikeCatalog.Order, p5:GetAttribute("SelectedBike")) or 1
    local t9 = {}
    local v56 = v50 - 1
    local v57, v58

    for i = 0, v56 do
        local v59 = i % 2 == 1

        if v59 then
            v57 = (i + 1) // 2
        end

        local v60 = if not v59 or not v57 then -(i // 2) else v57

        v58 = BikeCatalog.Order[(v51 - 1 + v60) % v50 + 1]
        table.insert(t9, v58)
    end

    for _ = 1, 3 do
        v57 = task.spawn
        v57(function() -- line: 176
            -- upvalues: preloadDisplay (copy), t9 (copy)
            while #t9 > 0 do
                preloadDisplay(table.remove(t9, 1))
            end
        end)
    end

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Halftone"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.fromOffset(550, 115)
    ImageLabel.Size = UDim2.fromOffset(900, 900)
    ImageLabel.ZIndex = 1
    ImageLabel.Parent = v39
    task.spawn(function() -- line: 181
        -- upvalues: ImageLabel (copy), dotsImage (copy)
        local ok, result = pcall(dotsImage)

        if ok and result then
            ImageLabel.ImageContent = result
        end
    end)

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.Name = "TeamLogo"
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel2.Position = UDim2.fromOffset(1010, 345)
    ImageLabel2.Size = UDim2.fromOffset(450, 290)
    ImageLabel2.ScaleType = Enum.ScaleType.Fit
    ImageLabel2.ZIndex = 2
    ImageLabel2.Parent = v39

    local UIScale = Instance.new("UIScale", ImageLabel2)
    local ImageLabel3 = Instance.new("ImageLabel")

    ImageLabel3.Name = "Shine"
    ImageLabel3.BackgroundTransparency = 1
    ImageLabel3.Size = UDim2.fromScale(1, 1)
    ImageLabel3.ScaleType = Enum.ScaleType.Fit
    ImageLabel3.ZIndex = 3
    ImageLabel3.Parent = ImageLabel2

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 15

    local TextButton = NumberSequence.new

    v57 = NumberSequenceKeypoint.new(0, 1)

    local v61 = NumberSequenceKeypoint.new(0.36, 1)
    local v62 = NumberSequenceKeypoint.new(0.5, 0.45)

    v58 = NumberSequenceKeypoint.new(0.64, 1)

    local new = NumberSequenceKeypoint.new
    local v63

    UIGradient.Transparency = TextButton({
        v57,
        v61,
        v62,
        v58,
        new(1, 1)
    })
    UIGradient.Offset = Vector2.new(-1.2, 0)
    UIGradient.Parent = ImageLabel3
    TextButton = Instance.new("TextButton")
    TextButton.Name = "OrbitArea"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false
    TextButton:SetAttribute("NoHover", true)
    TextButton:SetAttribute("NoSound", true)
    TextButton.Position = UDim2.fromOffset(500, 120)
    TextButton.Size = UDim2.fromOffset(1000, 840)
    TextButton.ZIndex = 4
    TextButton.Parent = v41

    local Frame5 = Instance.new("Frame")

    Frame5.Name = "Teams"
    Frame5.BackgroundTransparency = 1
    Frame5.Size = UDim2.fromOffset(352, 1125)
    Frame5.ZIndex = 2
    Frame5.Parent = v41

    local v64 = UDim2.fromOffset(101, 0)
    local v65 = UDim2.fromOffset(-492, 0)

    Frame5.Position = v64

    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Controls"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.Size = UDim2.fromOffset(2000, 1125)
    CanvasGroup.ZIndex = 3
    CanvasGroup.Parent = v41

    local function text(p15, p16, p17, p18, p19, p20, p21, p22) -- line: 199
        -- upvalues: v30 (copy), v33 (copy)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = p16
        TextLabel.Text = p17
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.fromOffset(p18, p19)
        TextLabel.Size = UDim2.fromOffset(p20, p21)
        TextLabel.TextColor3 = v30
        TextLabel.FontFace = v33
        TextLabel.TextSize = p22
        TextLabel.ZIndex = 43
        TextLabel.Parent = p15

        return TextLabel
    end

    local function button(p23, p24, p25, p26, p27, p28, p29) -- line: 202
        -- upvalues: v30 (copy), v31 (copy), v32 (copy), v33 (copy), TweenService (copy)
        local TextButton = Instance.new("TextButton")

        TextButton.Name = p24
        TextButton.Text = p25
        TextButton:SetAttribute("NoHover", true)
        TextButton.AutoButtonColor = false
        TextButton.BorderSizePixel = 0
        TextButton.BackgroundColor3 = v30
        TextButton.TextColor3 = v31
        TextButton.FontFace = v33
        TextButton.TextSize = 48
        TextButton.Position = UDim2.fromOffset(p26, p27)
        TextButton.Size = UDim2.fromOffset(p28, p29)
        TextButton.ZIndex = 44
        TextButton.Parent = p23
        Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 7)

        local function hover(p30) -- line: 205
            -- upvalues: TextButton (copy), v30 (copy), v31 (copy), v32 (copy), TweenService (copy)
            if TextButton:GetAttribute("Locked") then
                return
            end

            local DarkStyle = TextButton:GetAttribute("DarkStyle")
            local v66 = if p30 and v32 then v32 elseif DarkStyle and v31 then v31 else v30
            local t10 = {
                BackgroundColor3 = v66,
                TextColor3 = if (p30 or DarkStyle) and v30 then v30 else v31
            }

            TweenService:Create(TextButton, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t10):Play()
        end

        TextButton.MouseEnter:Connect(function() -- line: 210
            -- upvalues: hover (copy)
            hover(true)
        end)
        TextButton.MouseLeave:Connect(function() -- line: 210
            -- upvalues: hover (copy)
            hover(false)
        end)
        TextButton.SelectionGained:Connect(function() -- line: 211
            -- upvalues: hover (copy)
            hover(true)
        end)
        TextButton.SelectionLost:Connect(function() -- line: 211
            -- upvalues: hover (copy)
            hover(false)
        end)

        return TextButton
    end

    local v67 = text(CanvasGroup, "LoadingPreview", "LOADING BIKE...", 700, 925, 600, 40, 24)

    v67.Visible = false
    v67.TextColor3 = Color3.fromRGB(150, 155, 165)
    Frame:GetAttributeChangedSignal("PreviewLoading"):Connect(function() -- line: 214
        -- upvalues: Frame (copy), v67 (copy)
        v67.Visible = Frame:GetAttribute("PreviewLoading") == true
    end)

    local PreviewLoading = Instance.new("ImageLabel")

    PreviewLoading.Name = "MoneyIcon"
    PreviewLoading.BackgroundTransparency = 1
    PreviewLoading.Position = UDim2.fromOffset(1486, 130)
    PreviewLoading.Size = UDim2.fromOffset(53, 50)
    PreviewLoading.ZIndex = 43
    PreviewLoading.Parent = CanvasGroup
    UIArt.Apply(PreviewLoading, "CashIcon")
    PreviewLoading = text(CanvasGroup, "Money", "0", 1557, 130, 200, 50, 38)
    PreviewLoading.TextXAlignment = Enum.TextXAlignment.Left

    local v68 = require(script.Parent:WaitForChild("MoneyCounter")).Bind(PreviewLoading, function(p31) -- line: 219
        -- upvalues: NumberFormat (copy)
        return NumberFormat.Short(p31):upper()
    end, Frame)

    local function updateMoney() -- line: 220
        -- upvalues: p5 (copy), v68 (copy)
        v68(p5:GetAttribute("Money") or 0)
    end

    p5:GetAttributeChangedSignal("Money"):Connect(updateMoney)
    v68(p5:GetAttribute("Money") or 0)

    local TextButton2 = Instance.new("TextButton")

    TextButton2.Name = "Close"
    TextButton2.Text = ""
    TextButton2.BackgroundTransparency = 1
    TextButton2:SetAttribute("NoHover", true)
    TextButton2.AutoButtonColor = false
    TextButton2.Position = UDim2.fromOffset(1737, 117)
    TextButton2.Size = UDim2.fromOffset(141, 76)
    TextButton2.ZIndex = 44
    TextButton2.Parent = CanvasGroup

    local ImageLabel4 = Instance.new("ImageLabel")

    ImageLabel4.Name = "ClosePlate"
    ImageLabel4.BackgroundTransparency = 1
    ImageLabel4.Size = UDim2.fromScale(1, 1)
    ImageLabel4.ImageContent = RaceIcons.Get("ref_top_plate")
    ImageLabel4.ImageColor3 = v30
    ImageLabel4.ZIndex = 44
    ImageLabel4.Parent = TextButton2

    local v69 = text(TextButton2, "X", "X", 0, 0, 141, 76, 44)

    v69.ZIndex = 45
    v69.TextColor3 = v31

    local UIScale2 = Instance.new("UIScale", TextButton2)

    local function closeHover(p32) -- line: 227
        -- upvalues: v30 (copy), v31 (copy), v32 (copy), ImageLabel4 (copy), v69 (copy), TweenService (copy)
        local t11 = {
            ImageColor3 = p32 and v32 or v30
        }

        TweenService:Create(ImageLabel4, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t11):Play()

        local t12 = {
            TextColor3 = p32 and v30 or v31
        }

        TweenService:Create(v69, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t12):Play()
    end

    TextButton2.MouseEnter:Connect(function() -- line: 228
        -- upvalues: closeHover (copy)
        closeHover(true)
    end)
    TextButton2.MouseLeave:Connect(function() -- line: 228
        -- upvalues: UIScale2 (copy), closeHover (copy), TweenService (copy)
        closeHover(false)

        local t13 = {
            Scale = 1
        }

        TweenService:Create(UIScale2, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t13):Play()
    end)
    TextButton2.SelectionGained:Connect(function() -- line: 229
        -- upvalues: closeHover (copy)
        closeHover(true)
    end)
    TextButton2.SelectionLost:Connect(function() -- line: 229
        -- upvalues: closeHover (copy)
        closeHover(false)
    end)
    TextButton2.MouseButton1Down:Connect(function() -- line: 230
        -- upvalues: UIScale2 (copy), TweenService (copy)
        local t14 = {
            Scale = 0.94
        }

        TweenService:Create(UIScale2, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t14):Play()
    end)
    TextButton2.MouseButton1Up:Connect(function() -- line: 231
        -- upvalues: UIScale2 (copy), TweenService (copy)
        local t15 = {
            Scale = 1
        }
        local Back = Enum.EasingStyle.Back

        TweenService:Create(UIScale2, TweenInfo.new(0.16, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t15):Play()
    end)

    local v70 = button(CanvasGroup, "SpawnSelectedBike", "SPAWN", 826, 983, 348, 59)

    v70.TextSize = 34
    v70.UICorner.CornerRadius = UDim.new(1, 0)

    local Frame6 = Instance.new("Frame")

    Frame6.Name = "PriceRow"
    Frame6.BackgroundTransparency = 1
    Frame6.Size = UDim2.fromScale(1, 1)
    Frame6.ZIndex = 45
    Frame6.Visible = false
    Frame6.Parent = v70

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = Frame6
    UIListLayout = Instance.new("ImageLabel")
    UIListLayout.Name = "CashIcon"
    UIListLayout.BackgroundTransparency = 1
    UIListLayout.ScaleType = Enum.ScaleType.Fit
    UIListLayout.Size = UDim2.fromOffset(38, 36)
    UIListLayout.LayoutOrder = 1
    UIListLayout.ZIndex = 45
    UIListLayout.Parent = Frame6
    UIArt.Apply(UIListLayout, "CashIcon")

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Price"
    TextLabel.BackgroundTransparency = 1
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.Size = UDim2.fromScale(0, 1)
    TextLabel.LayoutOrder = 2
    TextLabel.ZIndex = 45
    TextLabel.FontFace = v33
    TextLabel.TextSize = 34
    TextLabel.TextColor3 = v70.TextColor3
    TextLabel:SetAttribute("KeepFont", true)
    TextLabel.Parent = Frame6
    v70:GetPropertyChangedSignal("TextColor3"):Connect(function() -- line: 241
        -- upvalues: v70 (copy), TextLabel (copy)
        TextLabel.TextColor3 = v70.TextColor3
    end)

    local UIScale3 = Instance.new("UIScale", v70)

    v70.MouseLeave:Connect(function() -- line: 243
        -- upvalues: UIScale3 (copy), TweenService (copy)
        local t16 = {
            Scale = 1
        }

        TweenService:Create(UIScale3, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t16):Play()
    end)
    v70.MouseButton1Down:Connect(function() -- line: 244
        -- upvalues: UIScale3 (copy), TweenService (copy)
        local t17 = {
            Scale = 0.95
        }

        TweenService:Create(UIScale3, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t17):Play()
    end)
    v70.MouseButton1Up:Connect(function() -- line: 245
        -- upvalues: UIScale3 (copy), TweenService (copy)
        local t18 = {
            Scale = 1
        }
        local Back = Enum.EasingStyle.Back

        TweenService:Create(UIScale3, TweenInfo.new(0.16, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t18):Play()
    end)

    local v71 = button(CanvasGroup, "GoToPit", "GO TO PIT", 1519, 990, 236, 45)

    v71.TextSize = 24
    v71.UICorner.CornerRadius = UDim.new(1, 0)
    v71:SetAttribute("DarkStyle", true)
    v71.BackgroundColor3 = v31
    v71.TextColor3 = v30

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v30
    UIStroke.Thickness = 2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = v71

    local UIScale4 = Instance.new("UIScale", v71)

    v71.MouseLeave:Connect(function() -- line: 253
        -- upvalues: UIScale4 (copy), TweenService (copy)
        local t19 = {
            Scale = 1
        }

        TweenService:Create(UIScale4, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t19):Play()
    end)
    v71.MouseButton1Down:Connect(function() -- line: 254
        -- upvalues: UIScale4 (copy), TweenService (copy)
        local t20 = {
            Scale = 0.95
        }

        TweenService:Create(UIScale4, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t20):Play()
    end)
    v71.MouseButton1Up:Connect(function() -- line: 255
        -- upvalues: UIScale4 (copy), TweenService (copy)
        local t21 = {
            Scale = 1
        }
        local Back = Enum.EasingStyle.Back

        TweenService:Create(UIScale4, TweenInfo.new(0.16, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t21):Play()
    end)
    v71.Activated:Connect(function() -- line: 256
        -- upvalues: Frame (copy), Parent (copy)
        if Frame.Visible then
            local ChampionshipEvent = Parent:FindFirstChild("ChampionshipEvent")

            if ChampionshipEvent then
                local LocalPlayer = game:GetService("Players").LocalPlayer

                LocalPlayer:SetAttribute("PitIntroRequest", (LocalPlayer:GetAttribute("PitIntroRequest") or 0) + 1)
                ChampionshipEvent:FireServer("GoToPit")
                Frame.Visible = false
            end
        end
    end)

    local v72 = button(CanvasGroup, "StartFlyingLap", "START FLYING LAP", 1519, 933, 236, 45)

    v72.TextSize = 24
    v72.UICorner.CornerRadius = UDim.new(1, 0)
    v72:SetAttribute("DarkStyle", true)
    v72.BackgroundColor3 = v31
    v72.TextColor3 = v30
    v72.Visible = false

    local UICorner = Instance.new("UIStroke")

    UICorner.Color = v30
    UICorner.Thickness = 2
    UICorner.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UICorner.Parent = v72

    local UIScale5 = Instance.new("UIScale", v72)

    v72.MouseLeave:Connect(function() -- line: 274
        -- upvalues: UIScale5 (copy), TweenService (copy)
        local t22 = {
            Scale = 1
        }

        TweenService:Create(UIScale5, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t22):Play()
    end)
    v72.MouseButton1Down:Connect(function() -- line: 275
        -- upvalues: UIScale5 (copy), TweenService (copy)
        local t23 = {
            Scale = 0.95
        }

        TweenService:Create(UIScale5, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t23):Play()
    end)
    v72.MouseButton1Up:Connect(function() -- line: 276
        -- upvalues: UIScale5 (copy), TweenService (copy)
        local t24 = {
            Scale = 1
        }
        local Back = Enum.EasingStyle.Back

        TweenService:Create(UIScale5, TweenInfo.new(0.16, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t24):Play()
    end)

    local t25 = {}
    local t26 = {}
    local v73 = BikeCatalog.Teams[p5:GetAttribute("SelectedBike")]
    local SelectedBike

    if v73 then
        SelectedBike = p5:GetAttribute("SelectedBike")
        v63 = SelectedBike
    end

    if not v73 or not SelectedBike then
        v63 = "Ducati"
        SelectedBike = "Ducati"
    end

    local v74 = table.find(BikeCatalog.Order, SelectedBike) or 1
    local t27 = {}
    local t28 = {
        1521
    }
    local t29 = {
        393, 502, 619
    }
    local v75

    local function v76() -- line: 289
        -- upvalues: v75 (ref), AssetService (copy)
        local v77 = buffer.create(50688)

        for i = 0, 87 do
            local v78 = (1 - (i + 0.5) / 88) * 32
            local v79 = v78 + 112

            for j = 0, 143 do
                local v83 = math.clamp(math.min(j + 1 - v78, v79 - j), 0, 1)

                if v83 > 0 then
                    local v85 = math.floor(v83 * 255 + 0.5) * 16777216 + 16777215

                    buffer.writeu32(v77, (i * 144 + j) * 4, v85)
                end
            end
        end

        local v86 = AssetService:CreateEditableImage({
            Size = Vector2.new(144, 88)
        })

        v86:WritePixelsBuffer(Vector2.zero, Vector2.new(144, 88), v77)
        v75 = Content.fromObject(v86)
    end

    pcall(v76)

    local t30 = {}

    for v87, v88 in BikeStats.Order do
        local v89 = t29[v87] or t29[#t29] + (v87 - #t29) * 115

        text(CanvasGroup, "Stat" .. v88.Key, v88.Label, t28[1], v89, 420, 34, 32).TextXAlignment = Enum.TextXAlignment.Left

        local t31 = {}

        for i = 1, BikeStats.MaxRating do
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "StatBar" .. v88.Key .. i
            ImageLabel.BorderSizePixel = 0
            ImageLabel.ZIndex = 43
            ImageLabel.Position = UDim2.fromOffset(t28[1] + (i - 1) * 38, v89 + 43)
            ImageLabel.Size = UDim2.fromOffset(36, 22)

            if v75 then
                ImageLabel.BackgroundTransparency = 1
                ImageLabel.ImageContent = v75
                ImageLabel.ImageColor3 = v30
            else
                ImageLabel.BackgroundColor3 = v30
                ImageLabel.ImageTransparency = 1
            end

            ImageLabel.Parent = CanvasGroup
            t31[i] = ImageLabel
        end

        t30[v88.Key] = t31
    end

    local function refreshStats(p33) -- line: 316
        -- upvalues: v63 (ref), v30 (copy), v32 (copy), v75 (ref), t30 (copy), TweenService (copy), BikeStats (copy)
        local v90 = BikeStats.Ratings(v63)
        local v91 = if v75 then "ImageColor3" else "BackgroundColor3"

        for v92, v93 in t30 do
            local v94 = v90 and v90[v92] or 0

            for v95, v96 in v93 do
                local v97 = v95 <= v94 and v32 or v30

                if p33 then
                    local t32 = {
                        [v91] = v97
                    }

                    TweenService:Create(v96, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t32):Play()
                else
                    v96[v91] = v97
                end
            end
        end
    end

    local function defaults() -- line: 328
        -- upvalues: p5 (copy), HttpService (copy), Config (copy)
        local t33 = {
            tcs = Config.TCS,
            aw = Config.AW,
            ebs = Config.EBS
        }
        local JSONDecode = HttpService.JSONDecode
        local v98 = p5:GetAttribute("SavedSettings") or "{}"
        local ok, result = pcall(JSONDecode, HttpService, v98)

        if ok then
            for _, v99 in { "tcs", "aw", "ebs" } do
                local v100 = result[v99]

                if typeof(v100) == "number" and v100 % 1 == 0 and v100 >= 1 and v100 <= 5 then
                    t33[v99] = v100
                end
            end
        end

        return t33
    end

    local function updateSetup() -- line: 335
        -- upvalues: v63 (ref), Frame (copy), Frame2 (copy), t25 (copy), t27 (copy), refreshStats (copy), defaults (copy)
        for v101, v102 in t27 do
            local v103 = v101:upper()

            if not t25[v63] then
                local v104 = v63

                t25[v104] = defaults()
            end

            v102.Text = v103 .. " " .. t25[v63][v101]
        end

        Frame:SetAttribute("SelectedBike", v63)
        refreshStats(Frame2.Visible)
    end

    local clone, result2
    local n1 = 0
    local n2 = 0.9075712110370514
    local n3 = 0.9075712110370514

    local function clearScene() -- line: 345
        -- upvalues: clone (ref), result2 (ref), n1 (ref)
        n1 += 1

        if clone then
            clone:Destroy()
            clone = nil
        end

        if result2 then
            result2:Destroy()
            result2 = nil
        end
    end

    local function buildRider() -- line: 350
        -- upvalues: p5 (copy), WorldModel (copy), v45 (ref), result2 (ref), v2 (copy)
        if result2 then
            result2:Destroy()
            result2 = nil
        end

        local Character = p5.Character

        if not Character then
            return
        end

        local Archivable = Character.Archivable

        Character.Archivable = true

        local function v106() -- line: 354
            -- upvalues: Character (copy)
            return Character:Clone()
        end

        local ok, result = pcall(v106)

        Character.Archivable = Archivable

        if not (ok and result) then
            return
        end

        result.Name = "PreviewRider"
        result:SetAttribute("RaceCrashActive", nil)

        local Animate = Character:FindFirstChild("Animate")
        local v107 = Animate and Animate:FindFirstChild("idle")

        v107 = v107 and (v107:FindFirstChild("Animation1") or v107:FindFirstChildWhichIsA("Animation"))

        local v108 = if v107 and v107.AnimationId ~= "" then v107.AnimationId else nil

        for _, descendant in result:GetDescendants() do
            if descendant:IsA("BaseScript")
                or descendant:IsA("Sound")
                or descendant:IsA("BillboardGui")
                or descendant:IsA("ParticleEmitter")
                or descendant:IsA("Trail")
                or descendant:IsA("ForceField")
                or descendant:IsA("IKControl") then
                descendant:Destroy()
            elseif descendant:IsA("Motor6D") then
                descendant.Transform = CFrame.identity
            elseif descendant:IsA("BasePart") then
                descendant.Anchored = false
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
                descendant.Massless = true
                descendant.LocalTransparencyModifier = 0
            end
        end

        local Humanoid = result:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.EvaluateStateMachine = false
            Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            Humanoid.Sit = false
            Humanoid.PlatformStand = false
        end

        local HumanoidRootPart = result:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            result:Destroy()

            return
        end

        HumanoidRootPart.Anchored = true
        HumanoidRootPart.Transparency = 1
        result.PrimaryPart = HumanoidRootPart

        local v109

        if Humanoid and Humanoid.RigType == Enum.HumanoidRigType.R15 then
            v109 = Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2
        else
            local v110 = result:FindFirstChild("Left Leg")

            v109 = (v110 and v110.Size.Y or 2) + HumanoidRootPart.Size.Y / 2
        end

        local v112 = Vector3.new(-2.75, v2 + v109, 1.4500000476837158)
        local v113 = CFrame.Angles(0, -0.4188790204786391, 0) * Vector3.new(-0.7880108, 0, -0.6156615)

        result:PivotTo(CFrame.lookAt(v112, v112 + v113))
        result.Parent = WorldModel
        result2 = result

        if v45 then
            v45.Refresh()
        end

        if Humanoid then
            local v114 = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
            local Animation = Instance.new("Animation")

            if not v108 then
                v108 = if Humanoid.RigType == Enum.HumanoidRigType.R15 then "rbxassetid://507766666" else "rbxassetid://180435571"
            end

            Animation.AnimationId = v108

            local LoadAnimation = v114.LoadAnimation
            local ok, result = pcall(LoadAnimation, v114, Animation)

            if ok and result then
                result.Looped = true
                result.Priority = Enum.AnimationPriority.Idle
                result:Play(0)
            end
        end
    end

    local function buildBike() -- line: 391
        -- upvalues: v63 (ref), Frame (copy), Frame2 (copy), WorldModel (copy), v45 (ref), t6 (copy), preloadDisplay (copy), clone (ref), n1 (ref), Parent (copy), Config (copy)
        n1 += 1

        local v115 = n1
        local v116 = Parent:FindFirstChild(v63 .. "Display")

        if v116 then
            Frame:SetAttribute("PreviewUnavailable", false)

            if not t6[v63] then
                if clone then
                    clone:Destroy()
                    clone = nil
                end

                Frame:SetAttribute("PreviewLoading", true)

                local v117 = v63
                local v118 = false
                local elapsed = os.clock()

                task.spawn(function() -- line: 403
                    -- upvalues: v117 (copy), v118 (ref), preloadDisplay (copy)
                    preloadDisplay(v117)
                    v118 = true
                end)

                while not v118 and v115 == n1 and os.clock() - elapsed < 2.5 do
                    task.wait()
                end
            end

            if v115 == n1 and Frame2.Visible then
                Frame:SetAttribute("PreviewLoading", false)

                local clone2 = v116:Clone()

                clone2.Name = "PreviewBike"
                clone2:ScaleTo(v116:GetScale() * Config.VisualScale)
                clone2:PivotTo(CFrame.new())

                for _, descendant in clone2:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true
                        descendant.CanCollide = false
                        descendant.CanTouch = false
                        descendant.CanQuery = false
                    elseif descendant:IsA("BaseScript") or descendant:IsA("Sound") then
                        descendant:Destroy()
                    end
                end

                local function v119() -- line: 414
                    -- upvalues: clone2 (copy), Parent (copy)
                    require(Parent:WaitForChild("PaddockStandPose")).Apply(clone2)
                end

                pcall(v119)

                if clone then
                    clone:Destroy()
                end

                clone = clone2
                clone2.Parent = WorldModel

                if v45 then
                    v45.Refresh()
                end
            end
        else
            Frame:SetAttribute("PreviewUnavailable", true)
            Frame:SetAttribute("PreviewLoading", false)

            if clone then
                clone:Destroy()
                clone = nil
            end
        end
    end

    local function previewCamera() -- line: 419
        -- upvalues: n2 (ref), v4 (copy)
        local ViewportSize = workspace.CurrentCamera.ViewportSize
        local v122 = math.min(ViewportSize.X / 2000, ViewportSize.Y / 1125)
        local v124 = 0.2679491924311227 * (ViewportSize.Y / math.max(v122 * 1125, 1))
        local v126 = math.atan(v122 * 87.5 / (ViewportSize.Y / 2) * v124)
        local v131 = v4 + Vector3.new(-math.sin(n2) * 0.992546151641322, 0.12186934340514748, -math.cos(n2) * 0.992546151641322) * 24.735685585049538

        return CFrame.lookAt(v131, v4) * CFrame.Angles(v126, 0, 0), (math.deg(math.atan(v124) * 2))
    end

    local function setLogo(_) -- line: 427
        -- upvalues: v63 (ref), ImageLabel2 (copy), ImageLabel3 (copy), Parent (copy), BikeCatalog (copy), UIArt (copy), silhouette (copy)
        local v134 = BikeCatalog.Teams[v63]
        local v135 = Parent.UIArt:FindFirstChild("TeamLogo" .. v63) and "TeamLogo" .. v63 or v134.Bar.Logo
        local v136 = v63

        ImageLabel3.ImageContent = Content.none
        task.spawn(function() -- line: 433
            -- upvalues: v135 (copy), v136 (copy), v63 (ref), ImageLabel2 (copy), ImageLabel3 (copy), UIArt (copy), silhouette (copy)
            local v137 = UIArt.Get(v135)

            if v136 == v63 and ImageLabel2.Parent then
                if v137 then
                    ImageLabel2.ImageContent = v137
                end

                local v138 = v137 and silhouette(v135, v137)

                if v136 == v63 and v138 then
                    ImageLabel3.ImageContent = v138
                end
            end
        end)
    end

    local t34 = {}
    local v139 = false
    local v140 = false
    local v141 = NumberFormat.Short(BikeCatalog.Price):upper()
    local v143 = tostring((math.floor(BikeCatalog.Price))):reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")

    local function refreshOwned() -- line: 447
        -- upvalues: p5 (copy), t34 (ref), HttpService (copy)
        t34 = {}

        local JSONDecode = HttpService.JSONDecode
        local v144 = p5:GetAttribute("OwnedBikes") or "[]"
        local ok, result = pcall(JSONDecode, HttpService, v144)

        if ok and typeof(result) == "table" then
            for _, v145 in result do
                local t35 = t34

                t35[v145] = true
            end
        end
    end

    local function ownedCount() -- line: 452
        -- upvalues: t34 (ref)
        local n4 = 0

        for _ in t34 do
            n4 += 1
        end

        return n4
    end

    local function ownershipKnown() -- line: 453
        -- upvalues: p5 (copy)
        return p5:GetAttribute("OwnedBikes") ~= nil
    end

    local function canRide(p35) -- line: 455
        -- upvalues: p5 (copy), t34 (ref), Config (copy)
        if t34[p35] == true then
            return true
        end

        return p5:GetAttribute("OwnedBikes") == nil and p35 == Config.Bike
    end

    refreshOwned()

    local t36 = {}
    local v146

    local function wrap(p36) -- line: 461
        -- upvalues: BikeCatalog (copy)
        return (p36 - 1) % #BikeCatalog.Order + 1
    end

    local function slotState(p37) -- line: 462
        local v147 = math.abs(p37)
        local v148 = UDim2.fromOffset(0, 562 + p37 * 115 - 49.5 - 12)
        local v149 = if v147 <= 1 then 0 else 1
        local v150 = if p37 == 0 then 1 else 0.45

        if p37 == 0 then
            return v148, v149, v150, 0
        end

        return v148, v149, v150, 1
    end

    local function makeRow(p38, p39, p40) -- line: 466
        -- upvalues: p5 (copy), v30 (copy), v31 (copy), v33 (copy), Frame5 (copy), t34 (ref), v141 (copy), v146 (ref), TweenService (copy), BikeCatalog (copy), UIArt (copy)
        local v151 = BikeCatalog.Teams[p38]
        local v152 = math.abs(p40)
        local v153 = UDim2.fromOffset(0, 562 + p40 * 115 - 49.5 - 12)
        local v154 = if v152 <= 1 then 0 else 1
        local v155 = if p40 == 0 then 1 else 0.45
        local v156 = if p40 == 0 then 0 else 1
        local CanvasGroup = Instance.new("CanvasGroup")

        CanvasGroup.Name = "Row_" .. p38
        CanvasGroup.BackgroundTransparency = 1
        CanvasGroup.Size = UDim2.fromOffset(352, 123)
        CanvasGroup.Position = v153
        CanvasGroup.GroupTransparency = v154
        CanvasGroup.ZIndex = 1
        CanvasGroup.Parent = Frame5

        local TextButton = Instance.new("TextButton")

        TextButton.Name = "Bar"
        TextButton.Text = ""
        TextButton:SetAttribute("NoHover", true)
        TextButton.AutoButtonColor = false
        TextButton.BorderSizePixel = 0
        TextButton.BackgroundColor3 = v151.Color
        TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
        TextButton.Position = UDim2.fromScale(0.5, 0.5)
        TextButton.Size = UDim2.fromOffset(328, 99)
        TextButton.ZIndex = 2
        TextButton.Parent = CanvasGroup
        TextButton.Interactable = math.abs(p39) <= 1

        local v158 = math.min(0.84, 86 / v151.Bar.H)
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Logo"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
        ImageLabel.Size = UDim2.fromOffset(v151.Bar.W * v158, v151.Bar.H * v158)
        ImageLabel.ZIndex = 3
        ImageLabel.Parent = TextButton
        UIArt.Apply(ImageLabel, v151.Bar.Logo)

        if p5:GetAttribute("OwnedBikes") ~= nil then
            local t37 = t34
            local n5 = 0

            for _ in t37 do
                n5 += 1
            end

            if n5 > 0 and not t34[p38] then
                local TextLabel = Instance.new("TextLabel")

                TextLabel.Name = "PriceTag"
                TextLabel.BorderSizePixel = 0
                TextLabel.BackgroundColor3 = v31
                TextLabel.BackgroundTransparency = 0.2
                TextLabel.AnchorPoint = Vector2.new(1, 1)
                TextLabel.Position = UDim2.new(1, -8, 1, -8)
                TextLabel.Size = UDim2.fromOffset(0, 28)
                TextLabel.AutomaticSize = Enum.AutomaticSize.X
                TextLabel.FontFace = v33
                TextLabel.TextSize = 18
                TextLabel.TextColor3 = v30
                TextLabel.Text = v141
                TextLabel.ZIndex = 3
                TextLabel.Parent = TextButton
                Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 6)

                local UIPadding = Instance.new("UIPadding", TextLabel)

                UIPadding.PaddingLeft = UDim.new(0, 10)
                UIPadding.PaddingRight = UDim.new(0, 10)
            end
        end

        local Frame = Instance.new("Frame")

        Frame.Name = "Dim"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = v31
        Frame.BackgroundTransparency = v155
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.ZIndex = 4
        Frame.Parent = TextButton

        local UIGradient

        if p39 == 0 then
            local Frame = Instance.new("Frame")

            Frame.Name = "Shine"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v30
            Frame.Size = UDim2.fromScale(1, 1)
            Frame.ZIndex = 5
            Frame.Parent = TextButton
            UIGradient = Instance.new("UIGradient")
            UIGradient.Rotation = 15
            UIGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.34, 1),
                NumberSequenceKeypoint.new(0.5, 0.6),
                NumberSequenceKeypoint.new(0.66, 1),
                NumberSequenceKeypoint.new(1, 1)
            })
            UIGradient.Offset = Vector2.new(-1.2, 0)
            UIGradient.Parent = Frame
        end

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = v30
        UIStroke.Thickness = 7
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
        UIStroke.Transparency = v156
        UIStroke.Parent = TextButton

        local UIScale = Instance.new("UIScale", TextButton)

        local function hover(p41) -- line: 493
            -- upvalues: p39 (copy), Frame (copy), TweenService (copy)
            if p39 == 0 then
                return
            end

            local t38 = {
                BackgroundTransparency = p41 and 0.25 or 0.45
            }

            TweenService:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t38):Play()
        end

        TextButton.MouseEnter:Connect(function() -- line: 494
            -- upvalues: p39 (copy), Frame (copy), TweenService (copy)
            if p39 ~= 0 then
                local t39 = {
                    BackgroundTransparency = 0.25
                }

                TweenService:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t39):Play()
            end
        end)
        TextButton.MouseLeave:Connect(function() -- line: 494
            -- upvalues: p39 (copy), Frame (copy), UIScale (copy), TweenService (copy)
            if p39 ~= 0 then
                local t40 = {
                    BackgroundTransparency = 0.45
                }

                TweenService:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t40):Play()
            end

            local t41 = {
                Scale = 1
            }

            TweenService:Create(UIScale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t41):Play()
        end)
        TextButton.SelectionGained:Connect(function() -- line: 495
            -- upvalues: p39 (copy), Frame (copy), TweenService (copy)
            if p39 ~= 0 then
                local t42 = {
                    BackgroundTransparency = 0.25
                }

                TweenService:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t42):Play()
            end
        end)
        TextButton.SelectionLost:Connect(function() -- line: 495
            -- upvalues: p39 (copy), Frame (copy), TweenService (copy)
            if p39 ~= 0 then
                local t43 = {
                    BackgroundTransparency = 0.45
                }

                TweenService:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t43):Play()
            end
        end)
        TextButton.MouseButton1Down:Connect(function() -- line: 496
            -- upvalues: UIScale (copy), TweenService (copy)
            local t44 = {
                Scale = 0.96
            }

            TweenService:Create(UIScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t44):Play()
        end)
        TextButton.MouseButton1Up:Connect(function() -- line: 497
            -- upvalues: UIScale (copy), TweenService (copy)
            local t45 = {
                Scale = 1
            }
            local Back = Enum.EasingStyle.Back

            TweenService:Create(UIScale, TweenInfo.new(0.16, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t45):Play()
        end)
        TextButton.Activated:Connect(function() -- line: 498
            -- upvalues: p39 (copy), v146 (ref)
            if p39 ~= 0 then
                v146(p39)
            end
        end)

        return {
            group = CanvasGroup,
            dim = Frame,
            stroke = UIStroke,
            slot = p39,
            shine = UIGradient
        }
    end

    local function renderRows(p42) -- line: 501
        -- upvalues: v74 (ref), t36 (ref), makeRow (copy), TweenService (copy), BikeCatalog (copy)
        for _, v159 in t36 do
            v159.group:Destroy()
        end

        t36 = {}

        for i = -2, 2 do
            local v160 = BikeCatalog.Order[(v74 + i - 1) % #BikeCatalog.Order + 1]
            local v161 = if p42 then i + p42 else nil
            local v163 = makeRow(v160, i, if not p42 or not v161 then i else v161)

            table.insert(t36, v163)

            if p42 then
                local v164 = math.abs(i)
                local v165 = UDim2.fromOffset(0, 562 + i * 115 - 49.5 - 12)
                local v166 = if v164 <= 1 then 0 else 1
                local v167 = if i == 0 then 1 else 0.45
                local v168 = if i == 0 then 0 else 1
                local group = v163.group
                local t47 = {
                    Position = v165,
                    GroupTransparency = v166
                }
                local Quart = Enum.EasingStyle.Quart

                TweenService:Create(group, TweenInfo.new(0.28, Quart or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t47):Play()

                local dim = v163.dim
                local t48 = {
                    BackgroundTransparency = v167
                }
                local Quart2 = Enum.EasingStyle.Quart

                TweenService:Create(dim, TweenInfo.new(0.28, Quart2 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t48):Play()

                local stroke = v163.stroke
                local t49 = {
                    Transparency = v168
                }
                local Quart3 = Enum.EasingStyle.Quart

                TweenService:Create(stroke, TweenInfo.new(0.28, Quart3 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t49):Play()
            end
        end
    end

    local v169 = false
    local n6 = 0

    v146 = function(p43) -- line: 514
        -- upvalues: v63 (ref), p6 (copy), Frame (copy), v74 (ref), updateSetup (copy), buildBike (copy), setLogo (copy), v139 (ref), renderRows (copy), v169 (ref), n6 (ref), Parent (copy), BikeCatalog (copy)
        if not Frame.Visible or v169 or v139 or p43 == 0 or os.clock() - n6 < 0.16 then
            return
        end

        n6 = os.clock()

        local v170 = math.clamp(p43, -1, 1)

        v74 = (v74 + v170 - 1) % #BikeCatalog.Order + 1
        v63 = BikeCatalog.Order[v74]
        renderRows(v170)
        updateSetup()
        setLogo(true)
        task.spawn(buildBike)

        if not Parent:FindFirstChild(v63 .. "Display") and p6 then
            p6("COMING SOON")
        end
    end

    local v171, v172, MouseBehavior, X

    TextButton.InputBegan:Connect(function(p44) -- line: 527
        -- upvalues: Frame (copy), v169 (ref), v171 (ref), v172 (ref), X (ref)
        if Frame.Visible and not v169 then
            if p44.UserInputType == Enum.UserInputType.MouseButton1 then
                v171 = "left"
                X = p44.Position.X
            elseif p44.UserInputType == Enum.UserInputType.Touch then
                v172 = p44
                X = p44.Position.X
            end
        end
    end)
    UserInputService.InputBegan:Connect(function(p45) -- line: 532
        -- upvalues: Frame (copy), v169 (ref), v171 (ref), MouseBehavior (ref), UserInputService (copy)
        if not Frame.Visible or v169 or p45.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return
        end

        v171 = "right"
        MouseBehavior = UserInputService.MouseBehavior
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
    end)
    UserInputService.InputChanged:Connect(function(p46) -- line: 538
        -- upvalues: Frame (copy), Frame5 (copy), n3 (ref), v146 (ref), v169 (ref), v171 (ref), v172 (ref), X (ref)
        if not Frame.Visible or v169 then
            return
        end

        if (not v171 or p46.UserInputType ~= Enum.UserInputType.MouseMovement) and p46 ~= v172 then
            if p46.UserInputType == Enum.UserInputType.MouseWheel then
                local Position = p46.Position
                local AbsolutePosition, AbsoluteSize = Frame5.AbsolutePosition, Frame5.AbsoluteSize

                if Position.X >= AbsolutePosition.X and Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
                    v146(p46.Position.Z > 0 and -1 or 1)
                end
            end
        else
            local X2 = p46.Delta.X
            local v174

            if v171 == "right" then
                v174 = X2
            else
                v174 = p46.Position.X - (X or p46.Position.X)
                X = p46.Position.X
            end

            n3 -= v174 * 0.008
        end
    end)

    local function endDrag() -- line: 549
        -- upvalues: v171 (ref), v172 (ref), MouseBehavior (ref), UserInputService (copy)
        v171 = nil
        v172 = nil

        if MouseBehavior then
            UserInputService.MouseBehavior = MouseBehavior
            MouseBehavior = nil
        end
    end

    UserInputService.InputEnded:Connect(function(p47) -- line: 553
        -- upvalues: v171 (ref), v172 (ref), MouseBehavior (ref), UserInputService (copy)
        if p47.UserInputType == Enum.UserInputType.MouseButton1 and v171 == "left" then
            v171 = nil
        end

        if p47.UserInputType == Enum.UserInputType.MouseButton2 and v171 == "right" then
            v171 = nil
            v172 = nil

            if MouseBehavior then
                UserInputService.MouseBehavior = MouseBehavior
                MouseBehavior = nil
            end
        end

        if p47 == v172 then
            v172 = nil
        end
    end)

    local n7 = 0
    local n8 = 0
    local v176

    p5:GetAttributeChangedSignal("OwnedBikes"):Connect(function() -- line: 560
        -- upvalues: Frame (copy), refreshOwned (copy), renderRows (copy), v169 (ref)
        refreshOwned()

        if Frame.Visible and not v169 then
            renderRows()
        end
    end)

    local TextButton3 = Instance.new("TextButton")

    TextButton3.Name = "BuyConfirm"
    TextButton3.Text = ""
    TextButton3.AutoButtonColor = false
    TextButton3.Selectable = false
    TextButton3.BackgroundTransparency = 1
    TextButton3:SetAttribute("NoHover", true)
    TextButton3:SetAttribute("NoSound", true)
    TextButton3.Size = UDim2.fromScale(1, 1)
    TextButton3.ZIndex = 60
    TextButton3.Visible = false
    TextButton3.Parent = Frame2

    local Frame7 = Instance.new("Frame")

    Frame7.Name = "Holder"
    Frame7.BackgroundTransparency = 1
    Frame7.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame7.Position = UDim2.fromScale(0.5, 0.5)
    Frame7.Size = UDim2.fromOffset(2000, 1125)
    Frame7.ZIndex = 60
    Frame7.Parent = TextButton3

    local UIScale6 = Instance.new("UIScale", Frame7)

    UIScale6.Scale = v42.Scale
    v42:GetPropertyChangedSignal("Scale"):Connect(function() -- line: 573
        -- upvalues: v42 (copy), UIScale6 (copy)
        UIScale6.Scale = v42.Scale
    end)

    local Frame8 = Instance.new("Frame")

    Frame8.Name = "Panel"
    Frame8.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame8.Position = UDim2.fromOffset(1000, 562.5)
    Frame8.Size = UDim2.fromOffset(775, 312.5)
    Frame8.BackgroundColor3 = v31
    Frame8.BorderSizePixel = 0
    Frame8.ZIndex = 61
    Frame8.Parent = Frame7
    Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 12.5)

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "Title"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Position = UDim2.fromOffset(40.625, 34.375)
    TextLabel2.Size = UDim2.fromOffset(500, 31.25)
    TextLabel2.Text = "BIKE"
    TextLabel2.TextSize = 31.25
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.FontFace = v33
    TextLabel2.TextColor3 = v30
    TextLabel2.ZIndex = 62
    TextLabel2.Parent = Frame8

    local Frame9 = Instance.new("Frame")

    Frame9.Name = "Divider"
    Frame9.AnchorPoint = Vector2.new(0, 0.5)
    Frame9.Position = UDim2.fromOffset(37.5, 84.375)
    Frame9.Size = UDim2.fromOffset(309.375, 3.125)
    Frame9.BorderSizePixel = 0
    Frame9.BackgroundColor3 = v30
    Frame9.ZIndex = 62
    Frame9.Parent = Frame8
    Instance.new("UIGradient", Frame9).Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    })

    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Name = "Message"
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel3.Position = UDim2.new(0.5, 0, 0, 156.25)
    TextLabel3.Size = UDim2.new(1, -75, 0, 37.5)
    TextLabel3.Text = ""
    TextLabel3.TextSize = 31.25
    TextLabel3.TextWrapped = true
    TextLabel3.FontFace = v33
    TextLabel3.TextColor3 = v30
    TextLabel3.ZIndex = 62
    TextLabel3.Parent = Frame8

    local TextButton4 = Instance.new("TextButton")

    TextButton4.Name = "Confirm"
    TextButton4.AutoButtonColor = false
    TextButton4.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton4.Position = UDim2.new(0.5, 0, 0, 250)
    TextButton4.Size = UDim2.fromOffset(296.875, 59.375)
    TextButton4.BackgroundColor3 = v30
    TextButton4.BorderSizePixel = 0
    TextButton4.Text = "CONFIRM"
    TextButton4.TextSize = 37.5
    TextButton4.FontFace = v33
    TextButton4.TextColor3 = v31
    TextButton4.ZIndex = 63
    TextButton4.Parent = Frame8
    Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(1, 0)

    local TextButton5 = Instance.new("TextButton")

    TextButton5.Name = "Close"
    TextButton5.Text = ""
    TextButton5.AutoButtonColor = false
    TextButton5.BackgroundTransparency = 1
    TextButton5.BorderSizePixel = 0
    TextButton5:SetAttribute("NoHover", true)
    TextButton5.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton5.Position = UDim2.new(1, -81.25, 0, 56.25)
    TextButton5.Size = UDim2.fromOffset(93.75, 50)
    TextButton5.ZIndex = 64
    TextButton5.Parent = Frame8

    local ImageLabel5 = Instance.new("ImageLabel")

    ImageLabel5.Name = "Plate"
    ImageLabel5.BackgroundTransparency = 1
    ImageLabel5.Size = UDim2.fromScale(1, 1)
    ImageLabel5.ImageColor3 = v30
    ImageLabel5.ZIndex = 64
    ImageLabel5.Parent = TextButton5

    local ref_top_plate = RaceIcons.Get("ref_top_plate")

    if ref_top_plate then
        ImageLabel5.ImageContent = ref_top_plate
    else
        ImageLabel5.BackgroundTransparency = 0
        ImageLabel5.BackgroundColor3 = v30
    end

    local TextLabel4 = Instance.new("TextLabel")

    TextLabel4.Name = "X"
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Size = UDim2.fromScale(1, 1)
    TextLabel4.Text = "X"
    TextLabel4.TextSize = 31.25
    TextLabel4.FontFace = v33
    TextLabel4.TextColor3 = v31
    TextLabel4.ZIndex = 65
    TextLabel4.Parent = TextButton5

    local UIScale7 = Instance.new("UIScale", TextButton5)

    local function h(p48) -- line: 593
        -- upvalues: v30 (copy), v31 (copy), v32 (copy), ImageLabel5 (copy), TextLabel4 (copy), TweenService (copy)
        local t50 = {
            ImageColor3 = p48 and v32 or v30
        }

        TweenService:Create(ImageLabel5, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t50):Play()

        local t51 = {
            TextColor3 = p48 and v30 or v31
        }

        TweenService:Create(TextLabel4, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t51):Play()
    end

    TextButton5.MouseEnter:Connect(function() -- line: 594
        -- upvalues: h (copy)
        h(true)
    end)
    TextButton5.MouseLeave:Connect(function() -- line: 594
        -- upvalues: UIScale7 (copy), h (copy), TweenService (copy)
        h(false)

        local t52 = {
            Scale = 1
        }

        TweenService:Create(UIScale7, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t52):Play()
    end)
    TextButton5.SelectionGained:Connect(function() -- line: 595
        -- upvalues: h (copy)
        h(true)
    end)
    TextButton5.SelectionLost:Connect(function() -- line: 595
        -- upvalues: h (copy)
        h(false)
    end)
    TextButton5.MouseButton1Down:Connect(function() -- line: 596
        -- upvalues: UIScale7 (copy), TweenService (copy)
        local t53 = {
            Scale = 0.9
        }

        TweenService:Create(UIScale7, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t53):Play()
    end)
    TextButton5.MouseButton1Up:Connect(function() -- line: 597
        -- upvalues: UIScale7 (copy), TweenService (copy)
        local t54 = {
            Scale = 1
        }
        local Back = Enum.EasingStyle.Back

        TweenService:Create(UIScale7, TweenInfo.new(0.16, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t54):Play()
    end)

    local function closeConfirm() -- line: 599
        -- upvalues: v139 (ref), v140 (ref), TextButton3 (copy)
        if not v140 then
            v139 = false
            TextButton3.Visible = false
        end
    end

    local function openConfirm() -- line: 603
        -- upvalues: v63 (ref), t34 (ref), v139 (ref), v140 (ref), v141 (copy), TextButton3 (copy), TextLabel2 (copy), TextLabel3 (copy), TextButton4 (copy), BikeCatalog (copy)
        local v177 = BikeCatalog.Teams[v63]

        if not v177 or v140 then
            return
        end

        v139 = true
        TextButton4.Text = "CONFIRM"
        TextLabel2.Text = "BIKE"

        local n9 = 0

        for _ in t34 do
            n9 += 1
        end

        TextLabel3.Text = n9 == 0 and "CHOOSE " .. v177.Name:upper() .. "?" or "BUY " .. v177.Name:upper() .. " FOR " .. v141 .. "?"
        TextButton3.Visible = true
    end

    local function confirmBuy() -- line: 609
        -- upvalues: v63 (ref), p6 (copy), updateSetup (copy), t34 (ref), v139 (ref), v140 (ref), renderRows (copy), TextButton3 (copy), TextButton4 (copy), Parent (copy)
        local v179 = v139

        if not v179 or v140 then
            return
        end

        local v180 = v63

        v140 = true
        TextButton4.Text = "..."

        local function v181() -- line: 612
            -- upvalues: v180 (copy), Parent (copy)
            return Parent:WaitForChild("BikeShop"):InvokeServer("Buy", v180)
        end

        local ok, result = pcall(v181)

        v140 = false
        TextButton4.Text = "CONFIRM"

        if ok and typeof(result) == "table" and result.ok then
            local t55 = t34

            t55[v180] = true

            if not v140 then
                v139 = false
                TextButton3.Visible = false
            end

            renderRows()
            updateSetup()
        else
            local err = typeof(result) == "table" and result.err or "TRY AGAIN"

            if p6 then
                p6(err)
            end

            if err == "NOT ENOUGH MONEY" then
                if v140 then
                    return
                end

                v139 = false
                TextButton3.Visible = false
            end
        end
    end

    TextButton4.Activated:Connect(confirmBuy)
    TextButton5.Activated:Connect(closeConfirm)

    local function sink() -- line: 625
        return Enum.ContextActionResult.Sink
    end

    local function navigate(_, p50, p51) -- line: 626
        -- upvalues: Frame (copy), v139 (ref), v140 (ref), v146 (ref), v176 (ref), TextButton3 (copy), confirmBuy (copy), UserInputService (copy)
        if p50 == Enum.UserInputState.Begin and not UserInputService:GetFocusedTextBox() then
            local KeyCode = p51.KeyCode

            if v139 then
                if KeyCode == Enum.KeyCode.ButtonA then
                    confirmBuy()
                elseif KeyCode == Enum.KeyCode.ButtonB and not v140 then
                    v139 = false
                    TextButton3.Visible = false
                end
            elseif KeyCode ~= Enum.KeyCode.W and KeyCode ~= Enum.KeyCode.Up and KeyCode ~= Enum.KeyCode.DPadUp then
                if KeyCode ~= Enum.KeyCode.S and KeyCode ~= Enum.KeyCode.Down and KeyCode ~= Enum.KeyCode.DPadDown then
                    if KeyCode == Enum.KeyCode.ButtonA then
                        v176()
                    elseif KeyCode == Enum.KeyCode.ButtonB then
                        Frame.Visible = false
                    end
                else
                    v146(1)
                end
            else
                v146(-1)
            end
        end

        return Enum.ContextActionResult.Sink
    end

    UserInputService.InputChanged:Connect(function(p52) -- line: 639
        -- upvalues: Frame (copy), v146 (ref), n7 (ref), n8 (ref)
        if p52.KeyCode ~= Enum.KeyCode.Thumbstick1 or not Frame.Visible then
            return
        end

        local v182 = if p52.Position.Y > 0.55 then -1 elseif p52.Position.Y < -0.55 then 1 else 0

        if v182 == n7 then
            return
        end

        n7 = v182
        n8 = os.clock() + 0.4

        if v182 ~= 0 then
            v146(v182)
        end
    end)

    local Lighting = game:GetService("Lighting")
    local t56

    local function coverWorld(p53) -- line: 650
        -- upvalues: Lighting (copy), t56 (ref)
        if p53 == (t56 ~= nil) then
            return
        end

        if p53 then
            t56 = {}

            for _, descendant in Lighting:GetDescendants() do
                if descendant:IsA("PostEffect") and descendant.Enabled then
                    local t57 = t56

                    t57[descendant] = true
                    descendant.Enabled = false
                end
            end
        else
            for v183 in t56 do
                if v183.Parent then
                    v183.Enabled = true
                end
            end

            t56 = nil
        end
    end

    local v184

    RunService.RenderStepped:Connect(function(p54) -- line: 661
        -- upvalues: v63 (ref), p5 (copy), v30 (copy), v31 (copy), Frame (copy), Frame2 (copy), Frame3 (copy), Folder (copy), Camera (copy), result (ref), UIGradient (copy), v70 (copy), Frame6 (copy), TextLabel (copy), v71 (copy), v72 (copy), n2 (ref), n3 (ref), previewCamera (copy), t34 (ref), v143 (copy), t36 (ref), v146 (ref), v169 (ref), n7 (ref), n8 (ref), coverWorld (copy), v184 (ref), UserInputService (copy), Parent (copy), Config (copy)
        local v185, v186

        if not Parent:GetAttribute("CircuitClosed") or p5:GetAttribute("RaceParticipant") == true then
            local v188 = v63

            v185 = t34[v188] == true or p5:GetAttribute("OwnedBikes") == nil and v188 == Config.Bike
            v186 = false
        else
            v186 = true
        end

        local v189

        if v186 then
            v189 = "locked"
        else
            local v190, v191

            if v185 then
                v191 = true
            elseif Parent:FindFirstChild(v63 .. "Display") then
                v190 = p5:GetAttribute("OwnedBikes") ~= nil
                v191 = false
            else
                v191 = true
            end

            if v191 then
                v189 = "spawn"
            elseif v190 then
                local n10 = 0

                for _ in t34 do
                    n10 += 1
                end

                v189 = if n10 == 0 then "free" else "buy"
            else
                v189 = "loading"
            end
        end

        if v189 ~= v184 then
            v184 = v189

            local v192 = v189 == "locked" or v189 == "loading"

            v70:SetAttribute("Locked", v192)
            v70.Active = not v192
            v70.Text = if v189 == "locked" then "RACE IN PROGRESS"
                elseif v189 == "loading" then "LOADING..."
                elseif v189 == "buy" then ""
                else "SPAWN"
            Frame6.Visible = v189 == "buy"

            if v189 == "buy" then
                TextLabel.Text = v143
            end

            v70.TextSize = (v189 == "spawn" or v189 == "free") and 34 or 24
            v70.BackgroundColor3 = v30
            v70.TextColor3 = v192 and Color3.fromRGB(145, 145, 145) or v31
        end

        local v196, v197

        if v189 ~= "spawn" or Parent:FindFirstChild(v63 .. "Display") == nil then
            v197 = false
        else
            local v198 = v63

            v196 = t34[v198] == true or p5:GetAttribute("OwnedBikes") == nil and v198 == Config.Bike
            v197 = v196 and Parent:GetAttribute("SessionPhase") == "Qualifying"
        end

        if v72.Visible ~= v197 then
            v72.Visible = v197
        end

        local SessionPhase = Parent:GetAttribute("SessionPhase")
        local v199 = (SessionPhase == "Grid" or SessionPhase == "Lights" or SessionPhase == "Racing") and p5:GetAttribute("RaceParticipant") == true

        if not v199 then
            v199 = p5:GetAttribute("RaceGridLocked")

            if not v199 then
                v199 = p5:GetAttribute("AFKMode") == true or SessionPhase == "RaceResults" and Parent:GetAttribute("PodiumActive") == true
            end
        end

        local v200 = not v199

        if v71.Visible ~= v200 then
            v71.Visible = v200
        end

        coverWorld(Frame2.Visible and Frame3.BackgroundTransparency < 0.005)

        if Frame2.Visible then
            if Frame.Visible and not v169 then
                if n7 ~= 0 and os.clock() >= n8 then
                    n8 = os.clock() + 0.26
                    v146(n7)
                end

                for _, v201 in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
                    if v201.KeyCode == Enum.KeyCode.Thumbstick2 and math.abs(v201.Position.X) > 0.15 then
                        n3 -= v201.Position.X * p54 * 2.4
                    end
                end
            end

            n2 += (n3 - n2) * (1 - math.exp(-p54 * 12))

            local v206, v207 = previewCamera()

            Camera.CFrame = v206
            Camera.FieldOfView = v207

            if result then
                for _, v208 in { "CurrentColor", "LeftBrightness", "RightBrightness" } do
                    Folder:SetAttribute(v208, result:GetAttribute(v208))
                end
            end

            local v210 = math.clamp(os.clock() % 3 / 1.8, 0, 1)
            local v211 = v210 * v210 * (3 - v210 * 2)

            UIGradient.Offset = Vector2.new(v211 * 2.4 + -1.2, 0)

            for _, v212 in t36 do
                if v212.shine then
                    v212.shine.Offset = Vector2.new(v211 * 2.4 + -1.2, 0)
                end
            end
        end
    end)

    local t60, v213

    local function v214() -- line: 709
        -- upvalues: p5 (copy), v213 (ref)
        v213 = require(p5.PlayerScripts:FindFirstChild("PlayerModule")):GetControls()
    end

    pcall(v214)

    local function releaseCharacter() -- line: 710
        -- upvalues: v171 (ref), v172 (ref), MouseBehavior (ref), t60 (ref), v213 (ref), ContextActionService (copy), UserInputService (copy)
        v171 = nil
        v172 = nil

        if MouseBehavior then
            UserInputService.MouseBehavior = MouseBehavior
            MouseBehavior = nil
        end

        if v213 then
            v213:Enable()
        end

        if t60 then
            local h, root = t60.h, t60.root

            if h.Parent then
                h.WalkSpeed = t60.speed
                h.AutoRotate = t60.rotate
                h:Move((Vector3.new(0, 0, 0)))
            end

            if root and root.Parent then
                root.Anchored = t60.anchored
            end

            t60 = nil
        end

        ContextActionService:UnbindAction("BikePreviewNoOrbit")
        ContextActionService:UnbindAction("BikePreviewNoMovement")
        ContextActionService:UnbindAction("BikeMenuNavigate")
    end

    local function resetLook() -- line: 721
        -- upvalues: Frame3 (copy), ViewportFrame (copy), ImageLabel (copy), ImageLabel2 (copy), UIScale (copy), ImageLabel3 (copy), Frame5 (copy), v64 (copy), CanvasGroup (copy)
        Frame3.BackgroundTransparency = 0
        ViewportFrame.ImageTransparency = 0
        ImageLabel.ImageTransparency = 0
        ImageLabel2.ImageTransparency = 0
        UIScale.Scale = 1
        CanvasGroup.GroupTransparency = 0
        Frame5.Position = v64
        ImageLabel3.Visible = true
    end

    local function closeMenu() -- line: 725
        -- upvalues: p3 (copy), p4 (copy), Frame2 (copy), Frame3 (copy), ViewportFrame (copy), v45 (ref), result (ref), ImageLabel (copy), ImageLabel2 (copy), UIScale (copy), ImageLabel3 (copy), Frame5 (copy), v64 (copy), CanvasGroup (copy), clone (ref), result2 (ref), n1 (ref), v139 (ref), v140 (ref), TextButton3 (copy), releaseCharacter (copy)
        v140 = false

        if not v140 then
            v139 = false
            TextButton3.Visible = false
        end

        releaseCharacter()
        n1 += 1

        if clone then
            clone:Destroy()
            clone = nil
        end

        if result2 then
            result2:Destroy()
            result2 = nil
        end

        if v45 then
            v45.Refresh()
        end

        if result then
            result:Destroy()
            result = nil
        end

        Frame2.Visible = false
        Frame3.BackgroundTransparency = 0
        ViewportFrame.ImageTransparency = 0
        ImageLabel.ImageTransparency = 0
        ImageLabel2.ImageTransparency = 0
        UIScale.Scale = 1
        CanvasGroup.GroupTransparency = 0
        Frame5.Position = v64
        ImageLabel3.Visible = true
        p4:SetAttribute("BikesPreviewOpen", false)
        p3.DisplayOrder = 9
    end

    local function openMenu() -- line: 730
        -- upvalues: v63 (ref), p3 (copy), p4 (copy), p5 (copy), Frame2 (copy), Frame3 (copy), ViewportFrame (copy), startFX (copy), ImageLabel (copy), ImageLabel2 (copy), UIScale (copy), ImageLabel3 (copy), Frame5 (copy), v64 (copy), v65 (copy), CanvasGroup (copy), v68 (copy), v74 (ref), updateSetup (copy), clone (ref), result2 (ref), n1 (ref), n2 (ref), n3 (ref), buildRider (copy), buildBike (copy), setLogo (copy), renderRows (copy), sink (copy), navigate (copy), t60 (ref), v213 (ref), ContextActionService (copy), TweenService (copy), BikeCatalog (copy)
        Frame3.BackgroundTransparency = 0
        ViewportFrame.ImageTransparency = 0
        ImageLabel.ImageTransparency = 0
        ImageLabel2.ImageTransparency = 0
        UIScale.Scale = 1
        CanvasGroup.GroupTransparency = 0
        Frame5.Position = v64
        ImageLabel3.Visible = true
        Frame2.Visible = true
        p3.DisplayOrder = 30
        p4:SetAttribute("BikesPreviewOpen", true)

        if v213 then
            v213:Disable()
        end

        local Character = p5.Character
        local v215 = Character

        if Character then
            v215 = Character:FindFirstChildOfClass("Humanoid")
            Character = Character:FindFirstChild("HumanoidRootPart")
        end

        if v215 then
            t60 = {
                h = v215,
                root = Character,
                speed = v215.WalkSpeed,
                rotate = v215.AutoRotate,
                anchored = Character and Character.Anchored
            }
            v215:Move((Vector3.new(0, 0, 0)))
            v215.WalkSpeed = 0
            v215.AutoRotate = false

            if Character and not v215.SeatPart then
                Character.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                Character.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                Character.Anchored = true
            end
        end

        ContextActionService:BindActionAtPriority("BikePreviewNoOrbit", sink, false, 5000, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseWheel)
        ContextActionService:BindActionAtPriority("BikePreviewNoMovement", sink, false, 5000, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump)
        ContextActionService:BindActionAtPriority("BikeMenuNavigate", navigate, false, 5001, Enum.KeyCode.W, Enum.KeyCode.S, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown, Enum.KeyCode.ButtonA, Enum.KeyCode.ButtonB)
        v74 = table.find(BikeCatalog.Order, v63) or 1
        n2 = 0.9075712110370514
        n3 = 0.9075712110370514
        updateSetup()
        v68(p5:GetAttribute("Money") or 0)
        renderRows()
        setLogo(true)
        startFX()
        Frame3.BackgroundTransparency = 1

        local t62 = {
            BackgroundTransparency = 0
        }

        TweenService:Create(Frame3, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t62):Play()
        Frame5.Position = v65

        local t63 = {
            Position = v64
        }
        local Quart = Enum.EasingStyle.Quart

        TweenService:Create(Frame5, TweenInfo.new(0.4, Quart or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t63):Play()
        n1 += 1

        if clone then
            clone:Destroy()
            clone = nil
        end

        if result2 then
            result2:Destroy()
            result2 = nil
        end

        buildRider()
        task.spawn(buildBike)
    end

    local n11 = 0

    local function finishTransition() -- line: 751
        -- upvalues: p3 (copy), p4 (copy), Frame (copy), Frame2 (copy), Frame3 (copy), ViewportFrame (copy), v45 (ref), result (ref), ImageLabel (copy), ImageLabel2 (copy), UIScale (copy), ImageLabel3 (copy), Frame5 (copy), v64 (copy), CanvasGroup (copy), clone (ref), result2 (ref), n1 (ref), v169 (ref), RunService (copy)
        RunService:UnbindFromRenderStep("BikeSpawnTransition")
        v169 = false

        if Frame.Visible then
            return
        end

        n1 += 1

        if clone then
            clone:Destroy()
            clone = nil
        end

        if result2 then
            result2:Destroy()
            result2 = nil
        end

        if v45 then
            v45.Refresh()
        end

        if result then
            result:Destroy()
            result = nil
        end

        Frame2.Visible = false
        Frame3.BackgroundTransparency = 0
        ViewportFrame.ImageTransparency = 0
        ImageLabel.ImageTransparency = 0
        ImageLabel2.ImageTransparency = 0
        UIScale.Scale = 1
        CanvasGroup.GroupTransparency = 0
        Frame5.Position = v64
        ImageLabel3.Visible = true
        p4:SetAttribute("BikesPreviewOpen", false)
        p3.DisplayOrder = 9
    end

    local function cancelTransition() -- line: 758
        -- upvalues: v169 (ref), n11 (ref), finishTransition (copy)
        if v169 then
            n11 += 1
            finishTransition()
        end
    end

    Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 762
        -- upvalues: p3 (copy), p4 (copy), Frame (copy), Frame2 (copy), Frame3 (copy), ViewportFrame (copy), v45 (ref), result (ref), ImageLabel (copy), ImageLabel2 (copy), UIScale (copy), ImageLabel3 (copy), Frame5 (copy), v64 (copy), CanvasGroup (copy), clone (ref), result2 (ref), n1 (ref), v139 (ref), v140 (ref), v169 (ref), TextButton3 (copy), releaseCharacter (copy), openMenu (copy), n11 (ref), finishTransition (copy)
        if Frame.Visible then
            if v169 then
                n11 += 1
                finishTransition()
            end

            openMenu()
        elseif not v169 then
            v140 = false

            if not v140 then
                v139 = false
                TextButton3.Visible = false
            end

            releaseCharacter()
            n1 += 1

            if clone then
                clone:Destroy()
                clone = nil
            end

            if result2 then
                result2:Destroy()
                result2 = nil
            end

            if v45 then
                v45.Refresh()
            end

            if result then
                result:Destroy()
                result = nil
            end

            Frame2.Visible = false
            Frame3.BackgroundTransparency = 0
            ViewportFrame.ImageTransparency = 0
            ImageLabel.ImageTransparency = 0
            ImageLabel2.ImageTransparency = 0
            UIScale.Scale = 1
            CanvasGroup.GroupTransparency = 0
            Frame5.Position = v64
            ImageLabel3.Visible = true
            p4:SetAttribute("BikesPreviewOpen", false)
            p3.DisplayOrder = 9
        end
    end)
    TextButton2.Activated:Connect(function() -- line: 766
        -- upvalues: Frame (copy), v169 (ref)
        if not v169 then
            Frame.Visible = false
        end
    end)

    local function fadeStage(p55) -- line: 769
        -- upvalues: Frame3 (copy), Frame4 (copy), ViewportFrame (copy), ImageLabel (copy), ImageLabel2 (copy), t36 (ref), TweenService (copy)
        local t64 = {
            BackgroundTransparency = 1
        }

        TweenService:Create(Frame3, TweenInfo.new(p55 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t64):Play()

        local t65 = {
            ImageTransparency = 1
        }
        local v216 = p55 * 0.85

        TweenService:Create(ViewportFrame, TweenInfo.new(v216 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t65):Play()

        local t66 = {
            ImageTransparency = 1
        }
        local v217 = p55 * 0.7

        TweenService:Create(ImageLabel, TweenInfo.new(v217 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t66):Play()

        local t67 = {
            ImageTransparency = 1
        }
        local v218 = p55 * 0.7

        TweenService:Create(ImageLabel2, TweenInfo.new(v218 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t67):Play()

        for _, v219 in t36 do
            local group = v219.group
            local t68 = {
                GroupTransparency = 1
            }
            local v220 = p55 * 0.5

            TweenService:Create(group, TweenInfo.new(v220 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t68):Play()
        end

        for _, descendant in Frame4:GetDescendants() do
            if descendant:IsA("ImageLabel") then
                local t69 = {
                    ImageTransparency = 1
                }
                local v221 = p55 * 0.8

                TweenService:Create(descendant, TweenInfo.new(v221 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t69):Play()
            end
        end
    end

    v176 = function(p56) -- line: 775
        -- upvalues: v63 (ref), p4 (copy), p5 (copy), p6 (copy), Frame (copy), ImageLabel3 (copy), Frame5 (copy), v65 (copy), CanvasGroup (copy), v72 (copy), t25 (copy), defaults (copy), previewCamera (copy), t34 (ref), v139 (ref), t36 (ref), v169 (ref), openConfirm (copy), releaseCharacter (copy), n11 (ref), finishTransition (copy), fadeStage (copy), RunService (copy), TweenService (copy), Parent (copy), Config (copy), BikeCatalog (copy), v4 (copy)
        local v222 = p56 == true

        if not Frame.Visible or v169 then
            return
        end

        local v223 = true

        if v222 then
            if v72.Visible then
                local v224 = v63

                v223 = t34[v224] == true or p5:GetAttribute("OwnedBikes") == nil and v224 == Config.Bike
            else
                v223 = false
            end
        end

        if not v223 then
            return
        end

        if not Parent:GetAttribute("CircuitClosed") or p5:GetAttribute("RaceParticipant") == true then
            if Parent:FindFirstChild(v63 .. "Display") then
                if not v139 then
                    local v225 = v63

                    if t34[v225] == true or p5:GetAttribute("OwnedBikes") == nil and v225 == Config.Bike then
                        local clone = table.clone

                        if not t25[v63] then
                            t25[v63] = defaults()
                        end

                        local v227 = clone(t25[v63])

                        if BikeCatalog.ValidAssists(v227) then
                            local Character = p5.Character
                            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                            local v228 = Humanoid and Humanoid.SeatPart
                            local v229, v230 = previewCamera()

                            v169 = true
                            n11 += 1

                            local v231 = n11

                            releaseCharacter()
                            p4:SetAttribute("BikesPreviewOpen", false)
                            ImageLabel3.Visible = false

                            for _, v232 in t36 do
                                if v232.shine then
                                    v232.shine.Parent.Visible = false
                                end
                            end

                            local t70 = {
                                Position = v65
                            }
                            local Quart = Enum.EasingStyle.Quart
                            local In = Enum.EasingDirection.In

                            TweenService:Create(Frame5, TweenInfo.new(0.45, Quart or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t70):Play()

                            for _, v233 in t36 do
                                local group = v233.group
                                local t71 = {
                                    GroupTransparency = 1
                                }
                                local Quad = Enum.EasingStyle.Quad
                                local In = Enum.EasingDirection.In

                                TweenService:Create(group, TweenInfo.new(0.42, Quad or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t71):Play()
                            end

                            local t72 = {
                                GroupTransparency = 1
                            }

                            TweenService:Create(CanvasGroup, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t72):Play()
                            Parent.SpawnBike:FireServer(v63, v227, if v222 then "FlyingLap" else nil)
                            Frame.Visible = false
                            task.spawn(function() -- line: 802
                                -- upvalues: v229 (copy), v230 (copy), v231 (copy), v228 (copy), p5 (copy), n11 (ref), finishTransition (copy), fadeStage (copy), RunService (copy), v4 (copy)
                                local v235 = os.clock() + 8
                                local v236

                                while true do
                                    if os.clock() < v235 then
                                        if v231 == n11 then
                                            local Character = p5.Character
                                            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                                            v236 = Humanoid and Humanoid.SeatPart

                                            if v236 and v236.Name == "RiderSeat" and v236 ~= v228 and v236.Parent and v236.Parent.PrimaryPart then
                                                break
                                            end

                                            RunService.Heartbeat:Wait()
                                            continue
                                        end

                                        return
                                    end

                                    v236 = nil
                                    break
                                end

                                if v231 == n11 then
                                    if v236 then
                                        RunService.RenderStepped:Wait()
                                        RunService.RenderStepped:Wait()

                                        if v231 == n11 then
                                            local PrimaryPart = v236.Parent.PrimaryPart
                                            local _CFrame = PrimaryPart.CFrame
                                            local LookVector = _CFrame.LookVector
                                            local v240 = CFrame.new(_CFrame.Position) * CFrame.Angles(0, math.atan2(-LookVector.X, -LookVector.Z), 0)
                                            local v241 = v240 * v229
                                            local v242 = v240 * v4
                                            local v243 = RaycastParams.new()

                                            v243.FilterType = Enum.RaycastFilterType.Include

                                            local t73 = {
                                                workspace.Terrain
                                            }
                                            local v244 = workspace:FindFirstChild("RaceCollision", true)

                                            if v244 then
                                                table.insert(t73, v244)
                                            end

                                            v243.FilterDescendantsInstances = t73

                                            local elapsed = os.clock()

                                            fadeStage(0.6)
                                            RunService:BindToRenderStep("BikeSpawnTransition", Enum.RenderPriority.Camera.Value + 20, function() -- line: 832
                                                -- upvalues: PrimaryPart (copy), v241 (copy), v242 (copy), v243 (copy), elapsed (copy), v230 (copy), v231 (copy), n11 (ref), finishTransition (copy), RunService (copy)
                                                if v231 ~= n11 then
                                                    RunService:UnbindFromRenderStep("BikeSpawnTransition")

                                                    return
                                                end

                                                local CurrentCamera = workspace.CurrentCamera

                                                if not PrimaryPart.Parent then
                                                    finishTransition()

                                                    return
                                                end

                                                local v247 = math.clamp((os.clock() - elapsed - 0.08) / 1.35, 0, 1)

                                                if v247 >= 1 then
                                                    finishTransition()
                                                else
                                                    local v248 = v247 < 0.5 and v247 ^ 3 * 4 or 1 - (v247 * -2 + 2) ^ 3 / 2
                                                    local _CFrame, FieldOfView = CurrentCamera.CFrame, CurrentCamera.FieldOfView
                                                    local v249 = PrimaryPart.Position + Vector3.new(0, 1.5, 0)
                                                    local v250 = v241.Position - v249
                                                    local v251 = _CFrame.Position - v249
                                                    local v252 = math.atan2(v250.X, v250.Z)
                                                    local v253 = v252 + ((math.atan2(v251.X, v251.Z) - v252 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v248
                                                    local Magnitude = Vector3.new(v250.X, 0, v250.Z).Magnitude
                                                    local v254 = Magnitude + (Vector3.new(v251.X, 0, v251.Z).Magnitude - Magnitude) * v248
                                                    local v255 = v250.Y + (v251.Y - v250.Y) * v248
                                                    local v258 = v249 + Vector3.new(math.sin(v253) * v254, v255, math.cos(v253) * v254)
                                                    local v259 = workspace:Raycast(v249, v258 - v249, v243)

                                                    if v259 then
                                                        v258 = v259.Position + v259.Normal * 0.7
                                                    end

                                                    local v260 = v242:Lerp(_CFrame.Position + _CFrame.LookVector * math.max(v251.Magnitude, 4), v248)

                                                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                                                    CurrentCamera.CFrame = CFrame.lookAt(v258, v260)
                                                    CurrentCamera.FieldOfView = v230 + (FieldOfView - v230) * v248
                                                end
                                            end)
                                        end
                                    else
                                        fadeStage(0.35)
                                        task.wait(0.4)

                                        if v231 == n11 then
                                            finishTransition()

                                            local CurrentCamera = workspace.CurrentCamera
                                            local Character = p5.Character
                                            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                                            if Humanoid and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                                                CurrentCamera.CameraType = Enum.CameraType.Custom
                                                CurrentCamera.CameraSubject = Humanoid
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                    elseif p5:GetAttribute("OwnedBikes") ~= nil then
                        openConfirm()
                    elseif p6 then
                        p6("LOADING...")
                    end
                end
            elseif p6 then
                p6("COMING SOON")
            end
        end
    end

    v70.Activated:Connect(function() -- line: 854
        -- upvalues: v176 (ref)
        v176(false)
    end)
    v72.Activated:Connect(function() -- line: 855
        -- upvalues: v176 (ref)
        v176(true)
    end)
    UserInputService.InputBegan:Connect(function(p57) -- line: 856
        -- upvalues: p4 (copy), Frame (copy), v176 (ref), UserInputService (copy)
        if Frame.Visible and not UserInputService:GetFocusedTextBox() and p57.KeyCode == Enum.KeyCode.X and p4:GetAttribute("Freecam") ~= true then
            v176()
        end
    end)
    p5.CharacterAdded:Connect(function() -- line: 860
        -- upvalues: Frame (copy), v169 (ref), n11 (ref), finishTransition (copy)
        if v169 then
            n11 += 1
            finishTransition()
        end

        Frame.Visible = false
    end)
    p5:GetAttributeChangedSignal("SavedSettings"):Connect(function() -- line: 861
        -- upvalues: t25 (copy), t26 (copy), updateSetup (copy), BikeCatalog (copy)
        for _, v261 in BikeCatalog.Order do
            if not t26[v261] then
                t25[v261] = nil
            end
        end

        updateSetup()
    end)
    updateSetup()
    t3.Frame = Frame
    t3.SpawnButton = v70
    t3.Stage = Frame2

    return t3
end

return t1
