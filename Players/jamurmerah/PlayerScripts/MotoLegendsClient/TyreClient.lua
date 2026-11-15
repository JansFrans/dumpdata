-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")

while MotoLegends:GetAttribute("TyresEnabled") ~= true do
    MotoLegends:GetAttributeChangedSignal("TyresEnabled"):Wait()
end

local _require = os.clock()

while workspace:GetAttribute("OwnerFeatures14Decided") ~= true and os.clock() - _require < 25 do
    task.wait(0.25)
end

if workspace:GetAttribute("OwnerFeatures14") ~= true and script:FindFirstChild("Pre14") then
    require(script.Pre14)

    return
end

local TyreCatalog = require(MotoLegends:WaitForChild("TyreCatalog"))
local RaceIcons = require(MotoLegends:WaitForChild("RaceIcons"))
local _require2 = require
local ok, result = pcall(_require2, MotoLegends:WaitForChild("NumberFormat"))
local TyreAction = MotoLegends:WaitForChild("TyreAction")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local JerezRaceHUD = PlayerGui:WaitForChild("JerezRaceHUD")
local v1 = Color3.fromRGB(231, 0, 0)
local v2 = Color3.new(0, 0, 0)
local v3 = Color3.new(1, 1, 1)
local v4 = Color3.fromRGB(20, 22, 28)
local v5 = Color3.fromRGB(150, 154, 162)

Color3.fromRGB(214, 217, 224)

local v6 = Color3.fromRGB(38, 40, 46)
local v7 = Color3.fromRGB(66, 68, 78)
local v8 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
local v9 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v10 = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold)
local t1 = {
    F = "Front",
    R = "Rear"
}

local function money(p1) -- line: 48
    -- upvalues: ok (copy), result (copy)
    if ok and result.Money then
        return result.Money(p1)
    end

    return "$" .. tostring(p1)
end

local function price(p2) -- line: 50
    return "$" .. string.format("%d", (math.floor((p2 or 0) + 0.5)))
end

local function pctText(p3) -- line: 53
    if p3 >= 0.9995 then
        return "100%"
    end

    return ("%d%%"):format((math.clamp(math.floor(p3 * 100 + 0.5), 0, 99)))
end

local function corner(p4, p5) -- line: 57
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = p5
    UICorner.Parent = p4

    return UICorner
end

local function stroke(p6, p7, p8) -- line: 58
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p7
    UIStroke.Thickness = p8 or 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = p6

    return UIStroke
end

local function label(p9, p10, p11, p12, p13, p14) -- line: 59
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p10
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p11
    TextLabel.FontFace = p12
    TextLabel.TextSize = p13
    TextLabel.TextColor3 = p14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = p9

    return TextLabel
end

local function setImage(p15, p16) -- line: 63
    -- upvalues: RaceIcons (copy)
    local v14 = RaceIcons.Get(p16)

    if not v14 then
        return false
    end

    p15.ImageContent = v14

    return true
end

local v15

local function readState() -- line: 67
    -- upvalues: HttpService (copy), LocalPlayer (copy), v15 (ref)
    local TyreState = LocalPlayer:GetAttribute("TyreState")
    local JSONDecode = HttpService.JSONDecode

    if typeof(TyreState) ~= "string" or not TyreState then
        TyreState = "{}"
    end

    local ok, result = pcall(JSONDecode, HttpService, TyreState)

    if ok and typeof(result) == "table" and result then
        v15 = result
    else
        v15 = {}
    end

    return v15
end

local function leftOf(p17, p18, p19) -- line: 73
    -- upvalues: v15 (ref), readState (copy)
    local v16 = v15 or readState()
    local v17 = v16[p17] and v16[p17][p18]
    local v18 = v17 and v17[p19]

    if typeof(v18) ~= "number" or not v18 then
        v18 = 1
    end

    return v18
end

local function zonesOf(p20, p21, p22) -- line: 80
    -- upvalues: TyreCatalog (copy), v15 (ref), readState (copy)
    local v19 = v15 or readState()
    local Z = v19.Z and v19.Z[p20] and v19.Z[p20][p21] and v19.Z[p20][p21][p22]
    local v20 = v15 or readState()
    local v21 = v20[p20] and v20[p20][p21]
    local v22 = v21 and v21[p22]

    if typeof(v22) ~= "number" or not v22 then
        v22 = 1
    end

    if typeof(Z) ~= "table" then
        return {
            L = v22,
            C = v22,
            R = v22
        }
    end

    local t2 = {}

    for _, v23 in TyreCatalog.Zones do
        local v24 = Z[v23]

        t2[v23] = typeof(v24) == "number" and v24 or v22
    end

    return t2
end

local function tyreIcon(p23, p24, p25, p26, p27) -- line: 93
    -- upvalues: TyreCatalog (copy), v4 (copy)
    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = p24
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    CanvasGroup.BorderSizePixel = 0
    CanvasGroup.Size = UDim2.fromOffset(p25, p26)

    local v25 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v25
    UICorner.Parent = CanvasGroup
    CanvasGroup.Parent = p23
    p27 = p27 or v4

    local v29 = math.max(1, (math.floor(p25 / 9 + 0.5)))
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p27
    UIStroke.Thickness = v29 or 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = CanvasGroup

    local t3 = {}

    for v30, v31 in TyreCatalog.Zones do
        local Frame = Instance.new("Frame")

        Frame.Name = v31
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.Position = UDim2.fromScale((v30 - 1) / 3, 0)
        Frame.Size = UDim2.fromScale(0.3333333333333333, 1)
        Frame.Parent = CanvasGroup

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Tread"
        Frame2.AnchorPoint = Vector2.new(0, 1)
        Frame2.Position = UDim2.fromScale(0, 1)
        Frame2.Size = UDim2.fromScale(1, 1)
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = TyreCatalog.Color(1)
        Frame2.Parent = Frame
        t3[v31] = Frame2
    end

    for i = 1, 2 do
        local Frame = Instance.new("Frame")

        Frame.Name = "Groove" .. i
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
        Frame.ZIndex = 2
        Frame.AnchorPoint = Vector2.new(0.5, 0)
        Frame.Position = UDim2.fromScale(i / 3, 0)
        Frame.Size = UDim2.new(0, 1, 1, 0)
        Frame.Parent = CanvasGroup
    end

    return {
        box = CanvasGroup,
        cols = t3
    }
end

local function setIcon(p28, p29) -- line: 111
    -- upvalues: TyreCatalog (copy)
    for v32, v33 in p28.cols do
        local v35 = math.clamp(p29[v32] or 1, 0, 1)

        v33.Size = UDim2.fromScale(1, v35)
        v33.BackgroundColor3 = TyreCatalog.Color(v35)
        v33.Visible = v35 > 0.005
    end
end

local function pillIcon(p30, p31, p32, p33, _) -- line: 121
    -- upvalues: TyreCatalog (copy), v3 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p31
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromOffset(p32, p33)

    local v36 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v36
    UICorner.Parent = Frame
    Frame.Parent = p30

    local v39 = math.max(1, (math.floor(p32 * 2.5 / 19 + 0.5)))
    local v42 = math.max(1, (math.floor(p32 / 19 + 0.5)))
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v3
    UIStroke.Thickness = v39 or 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame

    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Tread"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.BorderSizePixel = 0
    CanvasGroup.Size = UDim2.fromScale(1, 1)

    local v43 = UDim.new(1, 0)
    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = v43
    UICorner2.Parent = CanvasGroup
    CanvasGroup.Parent = Frame

    local t4 = {}
    local t5 = {}

    for v44, v45 in TyreCatalog.Zones do
        local Frame = Instance.new("Frame")

        Frame.Name = v45
        Frame.BorderSizePixel = 0
        Frame.AnchorPoint = Vector2.new(0, 1)
        Frame.Position = UDim2.new((v44 - 1) / 3, v44 > 1 and v42 or 0, 1, 0)
        Frame.Size = UDim2.new(0.3333333333333333, v44 == 2 and -v42 or 0, 1, 0)
        Frame.Parent = CanvasGroup
        t4[v45] = {
            frame = Frame,
            index = v44
        }
    end

    for i = 1, 2 do
        local Frame = Instance.new("Frame")

        Frame.Name = "Line" .. i
        Frame.BorderSizePixel = 0
        Frame.ZIndex = 2
        Frame.Position = UDim2.new(i / 3, 0, 0, 0)
        Frame.Size = UDim2.new(0, v42, 1, 0)
        Frame.Parent = CanvasGroup
        t5[i] = Frame
    end

    return {
        box = Frame,
        stroke = UIStroke,
        cols = t4,
        lines = t5,
        gap = v42
    }
end

local function setPill(p35, p36, p37) -- line: 142
    -- upvalues: TyreCatalog (copy), v3 (copy)
    local v46 = TyreCatalog.Compounds[p37]
    local v47, v48

    if v46 then
        local Stripe = v46.Stripe

        if Stripe then
            v47 = Stripe
            v48 = true
        else
            local Color = v46.Color

            if Color then
                v47 = Color
                v48 = true
            else
                v48 = false
            end
        end
    else
        v48 = false
    end

    if not v48 then
        v47 = v3
    end

    p35.stroke.Color = v47

    for _, v49 in p35.lines do
        v49.BackgroundColor3 = v47
    end

    for v50, v51 in p35.cols do
        local v53 = math.clamp(p36[v50] or 1, 0, 1)

        v51.frame.Size = UDim2.new(0.3333333333333333, v51.index == 2 and -p35.gap or 0, v53, 0)
        v51.frame.BackgroundColor3 = v53 <= 0.15 and Color3.fromRGB(255, 45, 35) or Color3.fromRGB(40, 210, 235)
        v51.frame.Visible = v53 > 0.005
    end
end

local function fitted(p38) -- line: 153
    -- upvalues: LocalPlayer (copy), TyreCatalog (copy), v15 (ref), readState (copy)
    local fit = (v15 or readState()).fit
    local v54 = fit and fit[p38]

    if typeof(v54) == "table" then
        return v54[1], v54[2]
    end

    return LocalPlayer:GetAttribute(if p38 == "F" then "TyreFront" else "TyreRear") or TyreCatalog.Default, LocalPlayer:GetAttribute("TyreSlot" .. p38) or 1
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "TyreMenuHUD"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 41
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local n1 = 1

local function u(p39) -- line: 164
    -- upvalues: n1 (ref)
    return (math.max(1, (math.floor(p39 * n1 + 0.5))))
end

local t6 = {
    open = false,
    side = "F",
    mode = "pit",
    confirm = {},
    rows = {}
}

local function pillStyle(p40, p41) -- line: 168
    -- upvalues: v1 (copy), v3 (copy), v4 (copy)
    p40.BackgroundColor3 = p41 and v1 or v3
    p40.TextColor3 = p41 and v3 or v4

    local UIStroke = p40:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = p41 and v1 or v4
    end
end

local function pill(p42, p43, p44, p45) -- line: 172
    -- upvalues: TweenService (copy), v4 (copy), v8 (copy), n1 (ref)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p43
    TextButton.AutoButtonColor = false
    TextButton:SetAttribute("NoHover", true)
    TextButton.BorderSizePixel = 0
    TextButton.AnchorPoint = Vector2.new(1, 0.5)
    TextButton.Size = UDim2.fromOffset(math.max(1, (math.floor(p44 * n1 + 0.5))), (math.max(1, (math.floor(11 * n1 + 0.5)))))
    TextButton.FontFace = v8
    TextButton.TextSize = math.max(1, (math.floor(7 * n1 + 0.5)))
    TextButton.Text = p45
    TextButton.AutoLocalize = false

    local v65 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v65
    UICorner.Parent = TextButton

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v4
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = TextButton
    TextButton.Parent = p42

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = TextButton
    TextButton.MouseEnter:Connect(function() -- line: 177
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.12), {
            Scale = 1.06
        }):Play()
    end)
    TextButton.MouseLeave:Connect(function() -- line: 178
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.12), {
            Scale = 1
        }):Play()
    end)

    return TextButton
end

local function chip(p46, p47, p48) -- line: 181
    -- upvalues: TyreCatalog (copy), v3 (copy), v4 (copy), v5 (copy), v8 (copy)
    local v66 = TyreCatalog.Compounds[p47]
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Compound"
    TextLabel.BackgroundColor3 = v66 and v66.Color or v5
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.fromOffset(p48, p48)
    TextLabel.Text = v66 and v66.Letter or "?"
    TextLabel.FontFace = v8
    TextLabel.TextSize = math.floor(p48 * 0.62)
    TextLabel.AutoLocalize = false

    local BackgroundColor3 = TextLabel.BackgroundColor3

    TextLabel.TextColor3 = 0.299 * BackgroundColor3.R + 0.587 * BackgroundColor3.G + 0.114 * BackgroundColor3.B > 0.6 and v4 or v3

    local v68 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v68
    UICorner.Parent = TextLabel
    TextLabel.Parent = p46

    return TextLabel
end

local v69

local function toast(p49) -- line: 191
    -- upvalues: t6 (copy)
    if t6.toast then
        t6.toast.Text = p49
        t6.toast.TextTransparency = 0
        t6.toastAt = os.clock()
    end
end

local function act(p50, p51, p52) -- line: 196
    -- upvalues: TyreAction (copy), t1 (copy), t6 (copy), v69 (ref)
    if t6.pending then
        return
    end

    t6.pending = true

    local side = t6.side

    task.spawn(function() -- line: 200
        -- upvalues: p50 (copy), p51 (copy), p52 (copy), side (copy), TyreAction (copy), t1 (copy), t6 (copy), v69 (ref)
        local InvokeServer = TyreAction.InvokeServer
        local ok, result = pcall(InvokeServer, TyreAction, p50, side, p51, p52)

        t6.pending = false

        if ok then
            if typeof(result) == "table" and result.ok == false then
                local v70 = result.err or "NOT AVAILABLE"

                if t6.toast then
                    t6.toast.Text = v70
                    t6.toast.TextTransparency = 0
                    t6.toastAt = os.clock()
                end
            elseif p50 == "Restore" then
                local v71 = string.upper(t1[side])
                local v72 = string.upper(p51)
                local v73 = typeof(result) == "table" and result.cost or 0
                local v75 = ("%s %s %d RESTORED · -%s"):format(v71, v72, p52, "$" .. string.format("%d", (math.floor((v73 or 0) + 0.5))))

                if t6.toast then
                    t6.toast.Text = v75
                    t6.toast.TextTransparency = 0
                    t6.toastAt = os.clock()
                end
            elseif p50 == "Fit" then
                local v76 = ("%s %s %d FITTED"):format(string.upper(t1[side]), string.upper(p51), p52)

                if t6.toast then
                    t6.toast.Text = v76
                    t6.toast.TextTransparency = 0
                    t6.toastAt = os.clock()
                end
            end
        elseif t6.toast then
            t6.toast.Text = "CONNECTION ERROR · TRY AGAIN"
            t6.toast.TextTransparency = 0
            t6.toastAt = os.clock()
        end

        v69()
    end)
end

local function fill() -- line: 211
    -- upvalues: UserInputService (copy), TyreCatalog (copy), TyreAction (copy), v3 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), t1 (copy), pillIcon (copy), fitted (copy), n1 (ref), t6 (copy), pill (copy), chip (copy), v69 (ref)
    local content = t6.content

    if not content then
        return
    end

    for _, child in content:GetChildren() do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    t6.rows = {}

    local _ = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local n2 = 0

    for _, v77 in TyreCatalog.Order do
        local v78 = TyreCatalog.Compounds[v77]
        local v79 = n2 + 1
        local Frame = Instance.new("Frame")

        Frame.Name = "Header_" .. v77
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(20 * n1 + 0.5)))))
        Frame.LayoutOrder = v79
        Frame.Parent = content

        local v84 = chip(Frame, v77, (math.max(1, (math.floor(12 * n1 + 0.5)))))

        v84.AnchorPoint = Vector2.new(0, 0.5)
        v84.Position = UDim2.new(0, 0, 0.5, 0)

        local Name = v78.Name
        local v87 = math.max(1, (math.floor(11 * n1 + 0.5)))
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "Title"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = Name
        TextLabel.FontFace = v8
        TextLabel.TextSize = v87
        TextLabel.TextColor3 = v3
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.AutoLocalize = false
        TextLabel.Parent = Frame
        TextLabel.Position = UDim2.fromOffset(math.max(1, (math.floor(17 * n1 + 0.5))), 0)
        TextLabel.Size = UDim2.new(0.5, 0, 1, 0)

        local v90 = v78.Hint or ""
        local v93 = math.max(1, (math.floor(6.5 * n1 + 0.5)))
        local TextLabel2 = Instance.new("TextLabel")

        TextLabel2.Name = "Hint"
        TextLabel2.BackgroundTransparency = 1
        TextLabel2.Text = v90
        TextLabel2.FontFace = v9
        TextLabel2.TextSize = v93
        TextLabel2.TextColor3 = v5
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel2.AutoLocalize = false
        TextLabel2.Parent = Frame
        TextLabel2.AnchorPoint = Vector2.new(1, 0)
        TextLabel2.Position = UDim2.fromScale(1, 0)
        TextLabel2.Size = UDim2.new(0.6, 0, 1, 0)
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Right
        n2 = v79 + 1

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Cards_" .. v77
        Frame2.BackgroundTransparency = 1
        Frame2.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(74 * n1 + 0.5)))))
        Frame2.LayoutOrder = n2
        Frame2.Parent = content

        local UIListLayout = Instance.new("UIListLayout")

        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, (math.max(1, (math.floor(6 * n1 + 0.5)))))
        UIListLayout.Parent = Frame2

        for i = 1, TyreCatalog.PerCompound do
            local Frame = Instance.new("Frame")

            Frame.Name = "Tyre" .. i
            Frame.BackgroundTransparency = 1
            Frame.LayoutOrder = i
            Frame.Size = UDim2.fromOffset(math.max(1, (math.floor(46 * n1 + 0.5))), (math.max(1, (math.floor(74 * n1 + 0.5)))))
            Frame.Parent = Frame2

            local TextButton = Instance.new("TextButton")

            TextButton.Name = "Card"
            TextButton.Text = ""
            TextButton.AutoButtonColor = false
            TextButton:SetAttribute("NoHover", true)
            TextButton.BackgroundColor3 = v6
            TextButton.BorderSizePixel = 0
            TextButton.Size = UDim2.fromOffset(math.max(1, (math.floor(46 * n1 + 0.5))), (math.max(1, (math.floor(58 * n1 + 0.5)))))

            local v110 = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = v110
            UICorner.Parent = TextButton
            TextButton.Parent = Frame

            local v113 = math.max(1, (math.floor(n1 + 0.5)))
            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = v7
            UIStroke.Thickness = v113 or 1
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Parent = TextButton

            local v119 = pillIcon(TextButton, "TyreIcon", math.max(1, (math.floor(16 * n1 + 0.5))), (math.max(1, (math.floor(42 * n1 + 0.5)))))

            v119.box.AnchorPoint = Vector2.new(0.5, 0.5)
            v119.box.Position = UDim2.fromScale(0.5, 0.5)

            local FIT = pill(TextButton, "Fit", 34, "FIT")

            FIT.AnchorPoint = Vector2.new(0.5, 0.5)
            FIT.Position = UDim2.fromScale(0.5, 0.5)
            FIT.ZIndex = 5
            FIT.Visible = false

            local RESTORE = pill(Frame, "Restore", 46, "RESTORE")

            RESTORE.AnchorPoint = Vector2.new(0.5, 0)
            RESTORE.Position = UDim2.new(0.5, 0, 0, (math.max(1, (math.floor(62 * n1 + 0.5)))))
            RESTORE.Size = UDim2.fromOffset(math.max(1, (math.floor(46 * n1 + 0.5))), (math.max(1, (math.floor(12 * n1 + 0.5)))))
            RESTORE.TextSize = math.max(1, (math.floor(6 * n1 + 0.5)))
            RESTORE.Visible = false

            local v129 = v77 .. ":" .. i

            TextButton.Activated:Connect(function() -- line: 246
                -- upvalues: v129 (copy), t6 (copy), v69 (ref)
                local v130

                if t6.selected ~= v129 then
                    v130 = v129
                    v130 = v130 or nil
                end

                t6.selected = v130
                v69()
            end)
            FIT.Activated:Connect(function() -- line: 250
                -- upvalues: v77 (copy), i (copy), TyreAction (copy), t1 (copy), fitted (copy), t6 (copy), v69 (ref)
                local v131, v132 = fitted(t6.side)

                if v131 == v77 and v132 == i or t6.pending then
                    return
                end

                t6.pending = true

                local side = t6.side
                local spawn = task.spawn
                local v133 = "Fit"

                spawn(function() -- line: 200
                    -- upvalues: side (copy), v133 (copy), v77 (copy), i (copy), TyreAction (copy), t1 (copy), t6 (copy), v69 (ref)
                    local InvokeServer = TyreAction.InvokeServer
                    local ok, result = pcall(InvokeServer, TyreAction, v133, side, v77, i)

                    t6.pending = false

                    if ok then
                        if typeof(result) == "table" and result.ok == false then
                            local v134 = result.err or "NOT AVAILABLE"

                            if t6.toast then
                                t6.toast.Text = v134
                                t6.toast.TextTransparency = 0
                                t6.toastAt = os.clock()
                            end
                        elseif v133 == "Restore" then
                            local v135 = string.upper(t1[side])
                            local v136 = string.upper(v77)
                            local v137 = typeof(result) == "table" and result.cost or 0
                            local v139 = ("%s %s %d RESTORED · -%s"):format(v135, v136, i, "$" .. string.format("%d", (math.floor((v137 or 0) + 0.5))))

                            if t6.toast then
                                t6.toast.Text = v139
                                t6.toast.TextTransparency = 0
                                t6.toastAt = os.clock()
                            end
                        elseif v133 == "Fit" then
                            local v140 = ("%s %s %d FITTED"):format(string.upper(t1[side]), string.upper(v77), i)

                            if t6.toast then
                                t6.toast.Text = v140
                                t6.toast.TextTransparency = 0
                                t6.toastAt = os.clock()
                            end
                        end
                    elseif t6.toast then
                        t6.toast.Text = "CONNECTION ERROR · TRY AGAIN"
                        t6.toast.TextTransparency = 0
                        t6.toastAt = os.clock()
                    end

                    v69()
                end)
            end)
            RESTORE.Activated:Connect(function() -- line: 255
                -- upvalues: v77 (copy), i (copy), v129 (copy), TyreAction (copy), t1 (copy), t6 (copy), v69 (ref)
                local v141 = t6.side .. ":" .. v129

                if not (t6.confirm[v141] and os.clock() - t6.confirm[v141] < 3) then
                    t6.confirm[v141] = os.clock()
                else
                    t6.confirm[v141] = nil

                    if not t6.pending then
                        t6.pending = true

                        local side = t6.side
                        local spawn = task.spawn
                        local v142 = "Restore"

                        spawn(function() -- line: 200
                            -- upvalues: side (copy), v142 (copy), v77 (copy), i (copy), TyreAction (copy), t1 (copy), t6 (copy), v69 (ref)
                            local InvokeServer = TyreAction.InvokeServer
                            local ok, result = pcall(InvokeServer, TyreAction, v142, side, v77, i)

                            t6.pending = false

                            if ok then
                                if typeof(result) == "table" and result.ok == false then
                                    local v143 = result.err or "NOT AVAILABLE"

                                    if t6.toast then
                                        t6.toast.Text = v143
                                        t6.toast.TextTransparency = 0
                                        t6.toastAt = os.clock()
                                    end
                                elseif v142 == "Restore" then
                                    local v144 = string.upper(t1[side])
                                    local v145 = string.upper(v77)
                                    local v146 = typeof(result) == "table" and result.cost or 0
                                    local v148 = ("%s %s %d RESTORED · -%s"):format(v144, v145, i, "$" .. string.format("%d", (math.floor((v146 or 0) + 0.5))))

                                    if t6.toast then
                                        t6.toast.Text = v148
                                        t6.toast.TextTransparency = 0
                                        t6.toastAt = os.clock()
                                    end
                                elseif v142 == "Fit" then
                                    local v149 = ("%s %s %d FITTED"):format(string.upper(t1[side]), string.upper(v77), i)

                                    if t6.toast then
                                        t6.toast.Text = v149
                                        t6.toast.TextTransparency = 0
                                        t6.toastAt = os.clock()
                                    end
                                end
                            elseif t6.toast then
                                t6.toast.Text = "CONNECTION ERROR · TRY AGAIN"
                                t6.toast.TextTransparency = 0
                                t6.toastAt = os.clock()
                            end

                            v69()
                        end)
                    end
                end

                v69()
            end)
            table.insert(t6.rows, {
                compound = v77,
                slot = i,
                icon = v119,
                card = TextButton,
                cardStroke = UIStroke,
                fit = FIT,
                restore = RESTORE,
                key = v129
            })
        end
    end

    v69()
end

local function setSide(p53) -- line: 267
    -- upvalues: t6 (copy), fill (copy)
    if t6.side == p53 and t6.content and #t6.rows > 0 then
        return
    end

    t6.side = p53
    t6.selected = nil
    fill()

    if t6.content then
        t6.content.CanvasPosition = Vector2.zero
    end
end

local v150

local function build() -- line: 275
    -- upvalues: TweenService (copy), TyreCatalog (copy), RaceIcons (copy), v1 (copy), v2 (copy), v3 (copy), v5 (copy), v8 (copy), v9 (copy), t1 (copy), pillIcon (copy), ScreenGui (copy), n1 (ref), t6 (copy), v69 (ref), fill (copy), v150 (ref)
    if t6.root then
        t6.root:Destroy()
    end

    t6.rows = {}
    t6.cats = {}
    t6.summary = {}

    local Frame = workspace.CurrentCamera.ViewportSize

    n1 = math.min(Frame.Y / 360, (Frame.X - 24) / 330)
    Frame = Instance.new("Frame")
    Frame.Name = "TyreWindow"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(math.max(1, (math.floor(330 * n1 + 0.5))), (math.max(1, (math.floor(210 * n1 + 0.5)))))
    Frame.BackgroundColor3 = v2
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Visible = false

    local TextButton = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    local fromOffset = Instance.new("UICorner")

    fromOffset.CornerRadius = TextButton
    fromOffset.Parent = Frame
    Frame.Parent = ScreenGui
    t6.root = Frame

    local v151 = math.max(1, (math.floor(12 * n1 + 0.5)))
    local Frame2 = Instance.new("TextLabel")

    Frame2.Name = "Title"
    Frame2.BackgroundTransparency = 1
    Frame2.Text = "TYRES"
    Frame2.FontFace = v8
    Frame2.TextSize = v151
    Frame2.TextColor3 = v3
    Frame2.TextXAlignment = Enum.TextXAlignment.Left
    Frame2.AutoLocalize = false
    Frame2.Parent = Frame
    Frame2.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(8 * n1 + 0.5)))))
    Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(160 * n1 + 0.5))), (math.max(1, (math.floor(14 * n1 + 0.5)))))
    TextButton = Instance.new("Frame")
    TextButton.Name = "Divider"
    TextButton.BorderSizePixel = 0
    TextButton.BackgroundColor3 = v3
    TextButton.Position = UDim2.fromOffset(math.max(1, (math.floor(12 * n1 + 0.5))), (math.max(1, (math.floor(27 * n1 + 0.5)))))
    TextButton.Size = UDim2.fromOffset(math.max(1, (math.floor(99 * n1 + 0.5))), (math.max(1, (math.floor(n1 + 0.5)))))
    TextButton.Parent = Frame
    fromOffset = Instance.new("UIGradient")
    fromOffset.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    fromOffset.Parent = TextButton
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Close"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton:SetAttribute("NoHover", true)
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    fromOffset = UDim2.new

    local v152 = -math.max(1, (math.floor(26 * n1 + 0.5)))
    local v155 = math.floor(18 * n1 + 0.5)

    TextButton.Position = fromOffset(1, v152, 0, (math.max(1, v155)))
    fromOffset = UDim2.fromOffset
    v151 = math.max(1, (math.floor(30 * n1 + 0.5)))

    local ScrollingFrame = 16 * n1 + 0.5

    TextButton.Size = fromOffset(v151, (math.max(1, (math.floor(ScrollingFrame)))))
    TextButton.ZIndex = 3
    TextButton.Modal = false
    TextButton.Parent = Frame
    t6.close = TextButton

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Plate"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ImageColor3 = v3
    ImageLabel.ZIndex = 3
    ImageLabel.Parent = TextButton
    v152 = RaceIcons.Get("ref_top_plate")

    if v152 then
        ImageLabel.ImageContent = v152
    else
        ImageLabel.BackgroundTransparency = 0
        ImageLabel.BackgroundColor3 = v3
        v151 = UDim.new
        v155 = 4 * n1 + 0.5
        ScrollingFrame = math.floor(v155)
        v151 = v151(0, (math.max(1, ScrollingFrame)))
        v152 = Instance.new("UICorner")
        v152.CornerRadius = v151
        v152.Parent = ImageLabel
    end

    Frame2 = math.max(1, (math.floor(10 * n1 + 0.5)))

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "X"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "X"
    TextLabel2.FontFace = v8
    TextLabel2.TextSize = Frame2
    TextLabel2.TextColor3 = v2
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.AutoLocalize = false
    TextLabel2.Parent = TextButton
    TextLabel2.Size = UDim2.fromScale(1, 1)
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel2.ZIndex = 4

    local function hover(p54) -- line: 296
        -- upvalues: ImageLabel (copy), TextLabel2 (copy), TweenService (copy), v1 (copy), v2 (copy), v3 (copy)
        TweenService:Create(ImageLabel, TweenInfo.new(0.18), {
            ImageColor3 = p54 and v1 or v3,
            BackgroundColor3 = p54 and v1 or v3
        }):Play()
        TweenService:Create(TextLabel2, TweenInfo.new(0.18), {
            TextColor3 = p54 and v3 or v2
        }):Play()
    end

    TextButton.MouseEnter:Connect(function() -- line: 300
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.MouseLeave:Connect(function() -- line: 300
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.SelectionGained:Connect(function() -- line: 301
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.SelectionLost:Connect(function() -- line: 301
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.Activated:Connect(function() -- line: 302
        -- upvalues: v150 (ref)
        v150()
    end)
    Frame2 = Instance.new("TextLabel")
    Frame2.Name = "Countdown"
    Frame2.AnchorPoint = Vector2.new(1, 0.5)
    Frame2.Position = UDim2.new(1, -math.max(1, (math.floor(46 * n1 + 0.5))), 0, (math.max(1, (math.floor(18 * n1 + 0.5)))))
    Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(40 * n1 + 0.5))), (math.max(1, (math.floor(12 * n1 + 0.5)))))
    Frame2.BackgroundColor3 = v1
    Frame2.BorderSizePixel = 0
    Frame2.FontFace = v8
    Frame2.TextSize = math.max(1, (math.floor(7.5 * n1 + 0.5)))
    Frame2.TextColor3 = v3
    Frame2.Text = ""
    Frame2.AutoLocalize = false
    Frame2.Visible = false

    local v154 = UDim.new(1, 0)
    local v153 = Instance.new("UICorner")

    v153.CornerRadius = v154
    v153.Parent = Frame2
    Frame2.Parent = Frame
    t6.countdown = Frame2
    Frame2 = Instance.new("Frame")
    Frame2.Name = "TimerLine"
    Frame2.AnchorPoint = Vector2.new(0, 0)
    Frame2.Position = UDim2.new(0, 0, 1, (math.max(1, (math.floor(3 * n1 + 0.5)))))
    Frame2.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    Frame2.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    Frame2.BackgroundTransparency = 0.1
    Frame2.BorderSizePixel = 0
    Frame2.Visible = t6.mode == "grid"
    Frame2.Parent = Frame
    v154 = Instance.new("Frame")
    v154.Name = "Fill"
    v154.Size = UDim2.fromScale(1, 1)
    v154.BackgroundColor3 = v1
    v154.BorderSizePixel = 0
    v154.Parent = Frame2
    t6.timerFill = v154
    ScrollingFrame = math.max(1, (math.floor(7.5 * n1 + 0.5)))

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Balance"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.FontFace = v9
    TextLabel.TextSize = ScrollingFrame
    TextLabel.TextColor3 = v5
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = Frame
    TextLabel.AnchorPoint = Vector2.new(1, 0.5)
    v153 = UDim2.new
    v155 = -math.max(1, (math.floor(46 * n1 + 0.5)))

    local new = 18 * n1 + 0.5
    local Frame3 = math.floor(new)

    TextLabel.Position = v153(1, v155, 0, (math.max(1, Frame3)))
    TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(110 * n1 + 0.5))), (math.max(1, (math.floor(12 * n1 + 0.5)))))
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right
    t6.balance = TextLabel
    Frame2 = Instance.new("Frame")
    Frame2.Name = "Categories"
    Frame2.BackgroundTransparency = 1
    Frame2.Position = UDim2.fromOffset(0, (math.max(1, (math.floor(36 * n1 + 0.5)))))
    v153 = UDim2.fromOffset
    ScrollingFrame = math.max(1, (math.floor(78 * n1 + 0.5)))

    local TextButton2 = 166 * n1 + 0.5

    Frame2.Size = v153(ScrollingFrame, (math.max(1, (math.floor(TextButton2)))))
    Frame2.Parent = Frame
    v153 = Instance.new("UIListLayout")
    v153.SortOrder = Enum.SortOrder.LayoutOrder
    v153.Parent = Frame2

    local v159, v160, v161, v162, TextLabel4

    for v163, v164 in TyreCatalog.Sides do
        TextButton2 = Instance.new("TextButton")
        TextButton2.Name = "Cat_" .. t1[v164]
        TextButton2.AutoButtonColor = false
        TextButton2:SetAttribute("NoHover", true)
        TextButton2.BorderSizePixel = 0
        Frame3 = UDim2.new
        v159 = 20 * n1 + 0.5
        v160 = math.floor(v159)
        TextButton2.Size = Frame3(1, 0, 0, (math.max(1, v160)))
        TextButton2.LayoutOrder = v163
        TextButton2.BackgroundColor3 = v1
        TextButton2.BackgroundTransparency = 1
        TextButton2.Text = t1[v164]
        TextButton2.FontFace = v9
        v162 = 9.5 * n1 + 0.5
        v161 = math.floor(v162)
        TextButton2.TextSize = math.max(1, v161)
        TextButton2.TextColor3 = v3
        TextButton2.TextXAlignment = Enum.TextXAlignment.Left
        TextButton2.AutoLocalize = false
        Frame3 = Instance.new("UIPadding")
        new = UDim.new
        v160 = 10 * n1 + 0.5
        TextLabel4 = math.floor(v160)
        Frame3.PaddingLeft = new(0, (math.max(1, TextLabel4)))
        Frame3.Parent = TextButton2
        TextButton2.Parent = Frame2

        local t10 = {
            hover = false,
            side = v164,
            button = TextButton2
        }

        new = TextButton2.MouseEnter
        new:Connect(function() -- line: 326
            -- upvalues: t10 (copy), v69 (ref)
            t10.hover = true
            v69()
        end)
        new = TextButton2.MouseLeave
        new:Connect(function() -- line: 326
            -- upvalues: t10 (copy), v69 (ref)
            t10.hover = false
            v69()
        end)
        new = TextButton2.Activated
        new:Connect(function() -- line: 327
            -- upvalues: v164 (copy), t6 (copy), fill (copy)
            if t6.side == v164 and t6.content and #t6.rows > 0 then
                return
            end

            t6.side = v164
            t6.selected = nil
            fill()

            if t6.content then
                t6.content.CanvasPosition = Vector2.zero
            end
        end)
        t6.cats[v164] = t10
    end

    Frame2 = Instance.new("Frame")
    Frame2.Name = "Fitted"
    Frame2.BackgroundTransparency = 1
    Frame2.Position = UDim2.fromOffset(math.max(1, (math.floor(10 * n1 + 0.5))), (math.max(1, (math.floor(88 * n1 + 0.5)))))
    Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(64 * n1 + 0.5))), (math.max(1, (math.floor(60 * n1 + 0.5)))))
    Frame2.Parent = Frame
    v155 = math.max(1, (math.floor(6.5 * n1 + 0.5)))

    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Name = "Caption"
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = "FITTED"
    TextLabel3.FontFace = v8
    TextLabel3.TextSize = v155
    TextLabel3.TextColor3 = v5
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.AutoLocalize = false
    TextLabel3.Parent = Frame2
    ScrollingFrame = UDim2.fromOffset
    v155 = math.max(1, (math.floor(64 * n1 + 0.5)))
    Frame3 = 10 * n1 + 0.5
    TextLabel3.Size = ScrollingFrame(v155, (math.max(1, (math.floor(Frame3)))))

    for v166, v167 in TyreCatalog.Sides do
        Frame3 = Instance.new("Frame")
        Frame3.Name = "Fitted" .. v167
        Frame3.BackgroundTransparency = 1

        local Frame = UDim2.fromOffset

        v159 = (12 + (v166 - 1) * 16) * n1 + 0.5
        v160 = math.floor(v159)
        Frame3.Position = Frame(0, (math.max(1, v160)))
        Frame = UDim2.fromOffset
        v162 = math.floor(64 * n1 + 0.5)
        new = math.max(1, v162)
        TextLabel4 = 13 * n1 + 0.5
        Frame3.Size = Frame(new, (math.max(1, (math.floor(TextLabel4)))))
        Frame3.Parent = Frame2
        Frame = Instance.new("Frame")
        Frame.BackgroundTransparency = 1
        new = UDim2.fromOffset
        TextLabel4 = 11 * n1 + 0.5
        v161 = math.max(1, (math.floor(TextLabel4)))
        v160 = 11 * n1 + 0.5
        TextLabel4 = math.floor(v160)
        Frame.Size = new(v161, (math.max(1, TextLabel4)))
        Frame.AnchorPoint = Vector2.new(0, 0.5)
        Frame.Position = UDim2.new(0, 0, 0.5, 0)
        Frame.Parent = Frame3
        v160 = 7 * n1 + 0.5
        TextLabel4 = math.floor(v160)
        v162 = math.max(1, TextLabel4)
        TextLabel4 = Instance.new("TextLabel")
        TextLabel4.Name = "Text"
        TextLabel4.BackgroundTransparency = 1
        TextLabel4.Text = ""
        TextLabel4.FontFace = v9
        TextLabel4.TextSize = v162
        TextLabel4.TextColor3 = v3
        TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel4.AutoLocalize = false
        TextLabel4.Parent = Frame3
        v161 = UDim2.fromOffset
        v160 = 15 * n1 + 0.5
        TextLabel4.Position = v161(math.max(1, (math.floor(v160))), 0)
        v161 = UDim2.new
        v159 = math.floor(15 * n1 + 0.5)
        TextLabel4.Size = v161(1, -math.max(1, v159), 1, 0)
        v159 = math.floor(6 * n1 + 0.5)
        v161 = pillIcon(Frame3, "TyreIcon", math.max(1, v159), math.max(1, (math.floor(13 * n1 + 0.5))), 1)
        v161.box.AnchorPoint = Vector2.new(1, 0.5)
        v162 = v161.box
        v162.Position = UDim2.new(1, -math.max(1, (math.floor(2 * n1 + 0.5))), 0.5, 0)
        t6.summary[v167] = {
            holder = Frame,
            text = TextLabel4,
            icon = v161
        }
    end

    v155 = math.max(1, (math.floor(6.5 * n1 + 0.5)))
    TextLabel3 = Instance.new("TextLabel")
    TextLabel3.Name = "Toast"
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = ""
    TextLabel3.FontFace = v9
    TextLabel3.TextSize = v155
    TextLabel3.TextColor3 = v3
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.AutoLocalize = false
    TextLabel3.Parent = Frame
    TextLabel3.AnchorPoint = Vector2.new(0, 1)
    TextLabel3.Position = UDim2.new(0, math.max(1, (math.floor(10 * n1 + 0.5))), 1, -math.max(1, (math.floor(6 * n1 + 0.5))))
    TextLabel3.Size = UDim2.fromOffset(math.max(1, (math.floor(70 * n1 + 0.5))), (math.max(1, (math.floor(30 * n1 + 0.5)))))
    TextLabel3.TextWrapped = true
    TextLabel3.TextYAlignment = Enum.TextYAlignment.Bottom
    TextLabel3.TextTransparency = 1
    t6.toast = TextLabel3
    ScrollingFrame = Instance.new("Frame")
    ScrollingFrame.Name = "Separator"
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(44, 46, 54)
    ScrollingFrame.Position = UDim2.fromOffset(math.max(1, (math.floor(80 * n1 + 0.5))), (math.max(1, (math.floor(36 * n1 + 0.5)))))
    ScrollingFrame.Size = UDim2.fromOffset(math.max(1, (math.floor(n1 + 0.5))), (math.max(1, (math.floor(166 * n1 + 0.5)))))
    ScrollingFrame.Parent = Frame
    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "Content"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(math.max(1, (math.floor(86 * n1 + 0.5))), (math.max(1, (math.floor(34 * n1 + 0.5)))))
    ScrollingFrame.Size = UDim2.fromOffset(math.max(1, (math.floor(238 * n1 + 0.5))), (math.max(1, (math.floor(170 * n1 + 0.5)))))
    ScrollingFrame.ScrollBarThickness = math.max(2, (math.max(1, (math.floor(2 * n1 + 0.5)))))
    ScrollingFrame.ScrollBarImageColor3 = v3
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.Parent = Frame
    t6.content = ScrollingFrame

    local UIPadding = Instance.new("UIListLayout")

    UIPadding.SortOrder = Enum.SortOrder.LayoutOrder
    UIPadding.Padding = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    UIPadding.Parent = ScrollingFrame
    UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    UIPadding.PaddingRight = UDim.new(0, (math.max(1, (math.floor(8 * n1 + 0.5)))))
    UIPadding.PaddingTop = UDim.new(0, (math.max(1, (math.floor(3 * n1 + 0.5)))))
    UIPadding.PaddingBottom = UDim.new(0, (math.max(1, (math.floor(6 * n1 + 0.5)))))
    UIPadding.Parent = ScrollingFrame
end

v69 = function() -- line: 354
    -- upvalues: LocalPlayer (copy), TyreCatalog (copy), ok (copy), result (copy), v1 (copy), v3 (copy), v4 (copy), v6 (copy), v7 (copy), t1 (copy), v15 (ref), readState (copy), zonesOf (copy), setPill (copy), fitted (copy), n1 (ref), t6 (copy), chip (copy)
    if t6.root then
        readState()

        for v172, v173 in t6.cats do
            local button = v173.button

            if v172 == t6.side then
                button.BackgroundTransparency = 0
            elseif v173.hover then
                button.BackgroundTransparency = 0.75
            else
                button.BackgroundTransparency = 1
            end
        end

        for v174, v175 in t6.summary do
            local v176, v177 = fitted(v174)
            local v178 = v15 or readState()
            local v179 = v178[v174] and v178[v174][v176]

            if typeof(v179 and v179[v177]) == "number" then
            end

            if v175.compound ~= v176 then
                v175.compound = v176

                for _, child in v175.holder:GetChildren() do
                    child:Destroy()
                end

                chip(v175.holder, v176, (math.max(1, (math.floor(11 * n1 + 0.5)))))
            end

            v175.text.Text = string.upper(t1[v174])
            setPill(v175.icon, zonesOf(v174, v176, v177), v176)
        end

        local elapsed = os.clock()

        for _, v183 in t6.rows do
            local side = t6.side
            local compound, slot = v183.compound, v183.slot
            local v184 = v15 or readState()
            local v185 = v184[side] and v184[side][compound]
            local v186 = v185 and v185[slot]
            local v187 = typeof(v186) == "number" and v186 or 1

            setPill(v183.icon, zonesOf(t6.side, v183.compound, v183.slot), v183.compound)

            local v188, v189 = fitted(t6.side)
            local v190 = v188 == v183.compound and v189 == v183.slot
            local v191 = t6.selected == v183.key

            v183.card.BackgroundColor3 = v190 and v1 or v6

            local cardStroke = v183.cardStroke
            local v192

            if v191 then
                v192 = v3

                if not v3 then
                    v192 = v190 and v1 or v7
                end
            else
                v192 = v190 and v1 or v7
            end

            cardStroke.Color = v192

            local cardStroke2 = v183.cardStroke
            local v193

            if v191 then
                v193 = math.max(2, (math.floor(n1 * 1.5 + 0.5)))

                if not v193 then
                    local v196 = n1

                    v193 = math.max(1, (math.floor(v196 + 0.5)))
                end
            else
                local v199 = n1

                v193 = math.max(1, (math.floor(v199 + 0.5)))
            end

            cardStroke2.Thickness = v193
            v183.fit.Visible = v191 and not v190

            local fit = v183.fit

            fit.BackgroundColor3 = v3
            fit.TextColor3 = v4

            local UIStroke = fit:FindFirstChildOfClass("UIStroke")

            if UIStroke then
                UIStroke.Color = v4
            end

            local v202 = v187 < 0.9995

            v183.restore.Visible = v191 and v202

            local v203 = t6.side .. ":" .. v183.key
            local v204 = t6.confirm[v203] and elapsed - t6.confirm[v203] < 3
            local v205

            if v204 then
                local v206 = TyreCatalog.RestoreCostFor(v187)

                v205 = "PAY " .. "$" .. string.format("%d", (math.floor((v206 or 0) + 0.5))) or "RESTORE"
            else
                v205 = "RESTORE"
                t6.confirm[v203] = nil
            end

            if v183.restore.Text ~= v205 then
                v183.restore.Text = v205
            end

            local restore = v183.restore
            local v208 = v204 == true

            restore.BackgroundColor3 = v208 and v1 or v3
            restore.TextColor3 = v208 and v3 or v4

            local UIStroke2 = restore:FindFirstChildOfClass("UIStroke")

            if UIStroke2 then
                UIStroke2.Color = v208 and v1 or v4
            end
        end

        if not t6.balance then
            return
        end

        local balance = t6.balance
        local v209 = LocalPlayer:GetAttribute("Money") or 0

        if ok and result.Money then
            balance.Text = result.Money(v209)
        else
            balance.Text = "$" .. tostring(v209)
        end
    end
end

local v210 = MotoLegends:FindFirstChild("CloseMenus") or Instance.new("BindableEvent")

v210.Name = "CloseMenus"
v210.Parent = MotoLegends

local function openMenu(p55, p56) -- line: 398
    -- upvalues: JerezRaceHUD (copy), t6 (copy), fill (copy), build (copy), v210 (copy)
    if not t6.open then
        v210:Fire("Tyres")
    end

    t6.mode = p55 or "pit"
    t6.crewRoot = p56

    if JerezRaceHUD:GetAttribute("LobbySettings") == true then
        JerezRaceHUD:SetAttribute("LobbySettings", false)
    end

    build()
    t6.open = true
    t6.root.Visible = true
    t6.close.Modal = true
    t6.rows = {}
    fill()
end

v150 = function() -- line: 405
    -- upvalues: t6 (copy)
    if t6.open then
        t6.open = false
        t6.crewRoot = nil
        table.clear(t6.confirm)
        t6.selected = nil

        if t6.root then
            t6.root.Visible = false
            t6.close.Modal = false
        end
    end
end

v210.Event:Connect(function(p57) -- line: 410
    -- upvalues: v150 (ref)
    if p57 ~= "Tyres" then
        v150()
    end
end)
LocalPlayer:GetAttributeChangedSignal("TyreState"):Connect(function() -- line: 411
    -- upvalues: t6 (copy), v69 (ref)
    if t6.open then
        v69()
    end
end)
LocalPlayer:GetAttributeChangedSignal("Money"):Connect(function() -- line: 412
    -- upvalues: t6 (copy), v69 (ref)
    if t6.open then
        v69()
    end
end)
JerezRaceHUD:GetAttributeChangedSignal("LobbySettings"):Connect(function() -- line: 414
    -- upvalues: JerezRaceHUD (copy), v150 (ref)
    if JerezRaceHUD:GetAttribute("LobbySettings") == true then
        v150()
    end
end)
UserInputService.InputBegan:Connect(function(p58) -- line: 415
    -- upvalues: t6 (copy), v150 (ref)
    if t6.open and p58.KeyCode == Enum.KeyCode.ButtonB then
        v150()
    end
end)
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 416
    -- upvalues: t6 (copy), fill (copy), build (copy)
    if t6.open then
        local side = t6.side

        build()
        t6.side = side
        t6.root.Visible = true
        t6.close.Modal = true
        fill()
    end
end)

local function setupPrompt(p59) -- line: 422
    -- upvalues: LocalPlayer (copy), t6 (copy), v150 (ref), openMenu (copy)
    if not p59:IsA("ProximityPrompt") then
        return
    end

    local function mine() -- line: 424
        -- upvalues: p59 (copy), LocalPlayer (copy)
        return p59:GetAttribute("TyreOwner") == LocalPlayer.UserId
    end

    local function update() -- line: 425
        -- upvalues: p59 (copy), LocalPlayer (copy)
        p59.Enabled = p59:GetAttribute("TyreOwner") == LocalPlayer.UserId
    end

    p59.Enabled = p59:GetAttribute("TyreOwner") == LocalPlayer.UserId
    p59:GetAttributeChangedSignal("TyreOwner"):Connect(update)
    p59.Triggered:Connect(function(p60) -- line: 427
        -- upvalues: p59 (copy), LocalPlayer (copy), t6 (copy), v150 (ref), openMenu (copy)
        if p60 == LocalPlayer and p59:GetAttribute("TyreOwner") == LocalPlayer.UserId then
            local elapsed = os.clock()

            if not (elapsed - (t6.lastToggle or 0) < 0.6) then
                t6.lastToggle = elapsed

                local v211 = p59.Parent and p59.Parent.Parent
                local v212 = v211 and v211:GetAttribute("TyreGrid") == true

                if t6.open then
                    v150()
                else
                    local v213 = if v212 then "grid" else "pit"
                    local Parent = p59.Parent
                    local ok, result = pcall(openMenu, v213, Parent)

                    if not ok then
                        warn("[TyreClient] opening the tyre menu failed: " .. tostring(result))
                    end
                end
            end
        end
    end)
end

for _, v214 in CollectionService:GetTagged("TyrePrompt") do
    setupPrompt(v214)
end

CollectionService:GetInstanceAddedSignal("TyrePrompt"):Connect(setupPrompt)

local v215 = MotoLegends:GetAttribute("TyrePickId") or 0

local function pickLeft() -- line: 447
    -- upvalues: MotoLegends (copy)
    return (MotoLegends:GetAttribute("TyrePickEnd") or 0) - workspace:GetServerTimeNow()
end

local function checkPick() -- line: 448
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), openMenu (copy), v215 (ref)
    local v216 = MotoLegends:GetAttribute("TyrePickId") or 0

    if v216 ~= v215 and (MotoLegends:GetAttribute("TyrePickEnd") or 0) - workspace:GetServerTimeNow() > 0.3 and LocalPlayer:GetAttribute("RaceParticipant") == true then
        v215 = v216
        openMenu("grid")
    end
end

MotoLegends:GetAttributeChangedSignal("TyrePickId"):Connect(checkPick)
MotoLegends:GetAttributeChangedSignal("TyrePickEnd"):Connect(checkPick)
task.defer(checkPick)
RunService.Heartbeat:Connect(function() -- line: 459
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), TyreCatalog (copy), t6 (copy), v69 (ref), v150 (ref)
    if t6.toast and t6.toastAt then
        local v217 = os.clock() - t6.toastAt

        if v217 > 2.5 then
            t6.toast.TextTransparency = math.clamp((v217 - 2.5) / 0.5, 0, 1)

            if v217 > 3 then
                t6.toastAt = nil
            end
        end
    end

    if t6.open then
        if t6.mode == "grid" then
            local v219 = (MotoLegends:GetAttribute("TyrePickEnd") or 0) - workspace:GetServerTimeNow()

            if v219 <= 0 then
                v150()

                return
            end

            if t6.timerFill then
                t6.timerFill.Size = UDim2.fromScale(math.clamp(v219 / (MotoLegends:GetAttribute("TyrePickSeconds") or TyreCatalog.PickSeconds), 0, 1), 1)
            end
        elseif t6.crewRoot then
            local v221 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if not (t6.crewRoot.Parent and (not v221 or not ((v221.Position - t6.crewRoot.Position).Magnitude > 18))) then
                v150()

                return
            end
        end

        for v222, v223 in t6.confirm do
            if os.clock() - v223 >= 3 then
                t6.confirm[v222] = nil
                v69()

                return
            end
        end
    end
end)
task.spawn(function() -- line: 482
    -- upvalues: TweenService (copy), RunService (copy), LocalPlayer (copy), TyreCatalog (copy), JerezRaceHUD (copy), v2 (copy), v3 (copy), v10 (copy)
    local v224 = JerezRaceHUD:WaitForChild("TelemetryAnchor", 60)

    if not v224 then
        return
    end

    local _ = {
        W = 19,
        H = 50,
        Gap = 7,
        Letter = 14,
        LetterGap = 5
    }
    local Frame = Instance.new("Frame")

    Frame.Name = "TyreIndicator"
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(1, 1)
    Frame.Size = UDim2.fromOffset(45, 69)
    Frame.Position = UDim2.fromOffset(-4, 122)
    Frame.Visible = false

    local t11 = {}

    local function text(p61, p62, p63, p64) -- line: 490
        -- upvalues: v3 (copy), v10 (copy)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = p62
        TextLabel:SetAttribute("KeepFont", true)
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderSizePixel = 0
        TextLabel.FontFace = v10
        TextLabel.TextSize = p64
        TextLabel.TextColor3 = v3
        TextLabel.Text = p63
        TextLabel.AutoLocalize = false
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel.TextYAlignment = Enum.TextYAlignment.Center
        TextLabel.Parent = p61

        return TextLabel
    end

    for v225, v226 in TyreCatalog.Sides do
        local v227 = (v225 - 1) * 26
        local Frame2 = Instance.new("Frame")

        Frame2.Name = "CompoundDisc" .. v226
        Frame2.BackgroundColor3 = v2
        Frame2.BackgroundTransparency = 0
        Frame2.BorderSizePixel = 0
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame2.Position = UDim2.fromOffset(v227 + 9.5, 7)
        Frame2.Size = UDim2.fromOffset(18, 18)

        local v228 = UDim.new(1, 0)
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = v228
        UICorner.Parent = Frame2
        Frame2.Parent = Frame
        Frame2.Visible = false

        local v229 = text(Frame2, "Compound" .. v226, "M", 11)

        v229.Position = UDim2.fromScale(0, 0)
        v229.Size = UDim2.fromScale(1, 1)

        local Frame3 = Instance.new("Frame")

        Frame3.Name = "Tyre" .. v226
        Frame3.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
        Frame3.BorderSizePixel = 0
        Frame3.Position = UDim2.fromOffset(v227, 19)
        Frame3.Size = UDim2.fromOffset(19, 50)

        local v230 = UDim.new(1, 0)
        local UICorner2 = Instance.new("UICorner")

        UICorner2.CornerRadius = v230
        UICorner2.Parent = Frame3
        Frame3.Parent = Frame

        local Frame4 = Instance.new("Frame")

        Frame4.Name = "TreadClip"
        Frame4.BackgroundTransparency = 1
        Frame4.BorderSizePixel = 0
        Frame4.ClipsDescendants = true
        Frame4.AnchorPoint = Vector2.new(0, 1)
        Frame4.Position = UDim2.fromScale(0, 1)
        Frame4.Size = UDim2.fromScale(1, 1)
        Frame4.Parent = Frame3

        local CanvasGroup = Instance.new("CanvasGroup")

        CanvasGroup.Name = "Tread"
        CanvasGroup.AnchorPoint = Vector2.new(0, 1)
        CanvasGroup.Position = UDim2.fromScale(0, 1)
        CanvasGroup.Size = UDim2.fromOffset(19, 50)
        CanvasGroup.BackgroundColor3 = v3
        CanvasGroup.BackgroundTransparency = 0
        CanvasGroup.BorderSizePixel = 0

        local v231 = UDim.new(1, 0)
        local UICorner3 = Instance.new("UICorner")

        UICorner3.CornerRadius = v231
        UICorner3.Parent = CanvasGroup
        CanvasGroup.Parent = Frame4
        CanvasGroup.BackgroundTransparency = 1

        local t12 = {}
        local t13 = {}

        for v232, v233 in TyreCatalog.Zones do
            local Frame = Instance.new("Frame")

            Frame.Name = v233
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = TyreCatalog.RateColor(0)
            Frame.AnchorPoint = Vector2.new(0, 1)
            Frame.Position = UDim2.new((v232 - 1) / 3, v232 > 1 and 1 or 0, 1, 0)
            Frame.Size = UDim2.new(0.3333333333333333, v232 == 2 and -1 or 0, 1, 0)
            Frame.Parent = CanvasGroup
            t12[v233] = {
                left = 1,
                frame = Frame,
                color = TyreCatalog.RateColor(0),
                index = v232
            }
        end

        for i = 1, 2 do
            local Frame = Instance.new("Frame")

            Frame.Name = "Line" .. i
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v3
            Frame.ZIndex = 2
            Frame.Position = UDim2.new(i / 3, 0, 0, 0)
            Frame.Size = UDim2.new(0, 1, 1, 0)
            Frame.Parent = CanvasGroup
            t13[i] = Frame
        end

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Name = "Outline"
        UIStroke.Thickness = 2
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Color = v3
        UIStroke.Transparency = 0
        UIStroke.Parent = Frame3
        UIStroke.Thickness = 2.5

        local v234 = text(Frame3, "Side", v226, 13)

        v234.AnchorPoint = Vector2.new(0.5, 0.5)
        v234.Position = UDim2.fromScale(0.5, 0.5)
        v234.Size = UDim2.fromScale(1, 1)
        v234.ZIndex = 3
        v234.TextColor3 = v3
        v234.TextStrokeTransparency = 1
        t11[v226] = {
            shown = nil,
            letter = v229,
            fill = CanvasGroup,
            clip = Frame4,
            color = TyreCatalog.RateColor(0),
            segs = t12,
            stroke = UIStroke,
            lines = t13
        }
    end

    Frame.Parent = v224

    local function update() -- line: 543
        -- upvalues: Frame (copy), t11 (copy), TweenService (copy), LocalPlayer (copy), TyreCatalog (copy), v3 (copy)
        local v235 = LocalPlayer:GetAttribute("TyreFront") ~= nil

        Frame.Visible = v235

        if v235 then
            for v236, v237 in t11 do
                local Attribute = LocalPlayer:GetAttribute(if v236 == "F" then "TyreFront" else "TyreRear")
                local v239 = TyreCatalog.Compounds[Attribute]

                v237.letter.Text = v239 and v239.Letter or "-"

                local stroke = v237.stroke

                if v239 then
                    stroke.Color = v239.Stripe or v239.Color or v3
                else
                    stroke.Color = v3
                end

                v237.fill.BackgroundColor3 = v237.stroke.Color

                for _, v240 in v237.lines do
                    v240.BackgroundColor3 = v237.stroke.Color
                end

                local v242 = math.clamp(LocalPlayer:GetAttribute("TyreWear" .. v236) or 1, 0, 1)
                local n3 = 1

                for v243, v244 in v237.segs do
                    local Attribute = LocalPlayer:GetAttribute("TyreWear" .. v236 .. v243)
                    local v246 = math.clamp(typeof(Attribute) == "number" and Attribute or v242, 0, 1)

                    n3 = math.min(n3, v246)

                    local v247 = UDim2.new(0.3333333333333333, if v244.index == 2 then -1 else 0, v246, 0)

                    if math.abs(v244.left - v246) > 0.2 then
                        v244.frame.Size = v247
                    else
                        TweenService:Create(v244.frame, TweenInfo.new(0.4), {
                            Size = v247
                        }):Play()
                    end

                    v244.left = v246
                    v244.frame.Visible = v246 > 0.005
                end

                v237.left = n3
                v237.clip.Size = UDim2.fromScale(1, 1)
                v237.clip.Visible = true
            end
        end
    end

    local v249 = TyreCatalog.RateColor(0)
    local v250 = Color3.fromRGB(45, 110, 255)
    local v251 = Color3.fromRGB(40, 210, 235)
    local v252 = Color3.fromRGB(255, 225, 30)
    local v253 = Color3.fromRGB(255, 140, 20)
    local v254 = Color3.fromRGB(255, 40, 30)

    local function tempColor(p65, p66) -- line: 578
        -- upvalues: v249 (copy), v250 (copy), v251 (copy), v252 (copy), v253 (copy), v254 (copy), TyreCatalog (copy)
        local v255 = TyreCatalog.TempWindows[p65]

        if not v255 or typeof(p66) ~= "number" then
            return v249
        end

        local v256 = v255[1]
        local v257 = v255[2]
        local v258 = (v256 + v257) / 2

        if p66 <= v256 - 25 then
            return v250
        end

        if p66 < v256 then
            return v250:Lerp(v251, (p66 - (v256 - 25)) / 25)
        end

        if p66 < v256 + (v258 - v256) * 0.5 then
            return v251:Lerp(v249, (p66 - v256) / ((v258 - v256) * 0.5))
        end

        if p66 <= v258 then
            return v249
        end

        if p66 <= v257 then
            return v249:Lerp(v252, (p66 - v258) / (v257 - v258))
        end

        if p66 <= v257 + 12 then
            return v252:Lerp(v253, (p66 - v257) / 12)
        end

        return v253:Lerp(v254, (math.clamp((p66 - v257 - 12) / 13, 0, 1)))
    end

    for _, v260 in {
            "TyreFront",
            "TyreRear",
            "TyreWearF",
            "TyreWearR",
            "TyreWearFL",
            "TyreWearFC",
            "TyreWearFR",
            "TyreWearRL",
            "TyreWearRC",
            "TyreWearRR"
        } do
        LocalPlayer:GetAttributeChangedSignal(v260):Connect(update)
    end

    update()
    RunService.Heartbeat:Connect(function(p67) -- line: 594
        -- upvalues: v224 (copy), Frame (copy), t11 (copy), tempColor (copy), LocalPlayer (copy), TyreCatalog (copy)
        if not (Frame.Visible and v224.Visible) then
            return
        end

        local v262 = math.sin(os.clock() * 6) * 0.5 + 0.5
        local v264 = 1 - math.exp(-math.min(p67, 0.1) * 4)

        for v265, v266 in t11 do
            local v267 = LocalPlayer:GetAttribute("TyreRate" .. v265) or 0
            local v268 = TyreCatalog.RateColor(v267)

            v266.color = v266.color:Lerp(v268, v264)

            local Attribute = LocalPlayer:GetAttribute(if v265 == "F" then "TyreFront" else "TyreRear")
            local Attribute2 = LocalPlayer:GetAttribute("TyreTemp" .. v265)

            for v270, v271 in v266.segs do
                local Attribute3 = LocalPlayer:GetAttribute("TyreTemp" .. v265 .. v270)

                if typeof(Attribute3) ~= "number" then
                    Attribute3 = Attribute2
                end

                v271.color = v271.color:Lerp(tempColor(Attribute, Attribute3), v264)
                v271.frame.BackgroundColor3 = v271.color
            end

            v266.fill.GroupTransparency = (v266.left or 1) <= 0.15 and v262 * 0.45 or 0
        end
    end)
end)
