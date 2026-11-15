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

local TyreCatalog = require(MotoLegends:WaitForChild("TyreCatalog"))
local RaceIcons = require(MotoLegends:WaitForChild("RaceIcons"))
local _require = require
local ok, result = pcall(_require, MotoLegends:WaitForChild("NumberFormat"))
local TyreAction = MotoLegends:WaitForChild("TyreAction")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local JerezRaceHUD = PlayerGui:WaitForChild("JerezRaceHUD")
local v1 = Color3.fromRGB(231, 0, 0)
local v2 = Color3.new(0, 0, 0)
local v3 = Color3.new(1, 1, 1)
local v4 = Color3.fromRGB(20, 22, 28)
local v5 = Color3.fromRGB(150, 154, 162)
local v6 = Color3.fromRGB(214, 217, 224)
local v7 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
local v8 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v9 = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold)
local t1 = {
    F = "Front",
    R = "Rear"
}

local function money(p1) -- line: 41
    -- upvalues: ok (copy), result (copy)
    if ok and result.Money then
        return result.Money(p1)
    end

    return "$" .. tostring(p1)
end

local function price(p2) -- line: 43
    return "$" .. string.format("%d", (math.floor((p2 or 0) + 0.5)))
end

local function pctText(p3) -- line: 46
    if p3 >= 0.9995 then
        return "100%"
    end

    return ("%d%%"):format((math.clamp(math.floor(p3 * 100 + 0.5), 0, 99)))
end

local function corner(p4, p5) -- line: 50
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = p5
    UICorner.Parent = p4

    return UICorner
end

local function stroke(p6, p7, p8) -- line: 51
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p7
    UIStroke.Thickness = p8 or 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = p6

    return UIStroke
end

local function label(p9, p10, p11, p12, p13, p14) -- line: 52
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

local function setImage(p15, p16) -- line: 56
    -- upvalues: RaceIcons (copy)
    local v13 = RaceIcons.Get(p16)

    if not v13 then
        return false
    end

    p15.ImageContent = v13

    return true
end

local v14

local function readState() -- line: 60
    -- upvalues: HttpService (copy), LocalPlayer (copy), v14 (ref)
    local TyreState = LocalPlayer:GetAttribute("TyreState")
    local JSONDecode = HttpService.JSONDecode

    if typeof(TyreState) ~= "string" or not TyreState then
        TyreState = "{}"
    end

    local ok, result = pcall(JSONDecode, HttpService, TyreState)

    if ok and typeof(result) == "table" and result then
        v14 = result
    else
        v14 = {}
    end

    return v14
end

local function leftOf(p17, p18, p19) -- line: 66
    -- upvalues: v14 (ref), readState (copy)
    local v15 = v14 or readState()
    local v16 = v15[p17] and v15[p17][p18]
    local v17 = v16 and v16[p19]

    if typeof(v17) ~= "number" or not v17 then
        v17 = 1
    end

    return v17
end

local function fitted(p20) -- line: 72
    -- upvalues: LocalPlayer (copy), TyreCatalog (copy), v14 (ref), readState (copy)
    local fit = (v14 or readState()).fit
    local v18 = fit and fit[p20]

    if typeof(v18) == "table" then
        return v18[1], v18[2]
    end

    return LocalPlayer:GetAttribute(if p20 == "F" then "TyreFront" else "TyreRear") or TyreCatalog.Default, LocalPlayer:GetAttribute("TyreSlot" .. p20) or 1
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "TyreMenuHUD"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 41
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local n1 = 1

local function u(p21) -- line: 83
    -- upvalues: n1 (ref)
    return (math.max(1, (math.floor(p21 * n1 + 0.5))))
end

local t2 = {
    open = false,
    side = "F",
    mode = "pit",
    confirm = {},
    rows = {}
}

local function pillStyle(p22, p23) -- line: 87
    -- upvalues: v1 (copy), v3 (copy), v4 (copy)
    p22.BackgroundColor3 = p23 and v1 or v3
    p22.TextColor3 = p23 and v3 or v4

    local UIStroke = p22:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = p23 and v1 or v4
    end
end

local function pill(p24, p25, p26, p27) -- line: 91
    -- upvalues: TweenService (copy), v4 (copy), v7 (copy), n1 (ref)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p25
    TextButton.AutoButtonColor = false
    TextButton:SetAttribute("NoHover", true)
    TextButton.BorderSizePixel = 0
    TextButton.AnchorPoint = Vector2.new(1, 0.5)
    TextButton.Size = UDim2.fromOffset(math.max(1, (math.floor(p26 * n1 + 0.5))), (math.max(1, (math.floor(11 * n1 + 0.5)))))
    TextButton.FontFace = v7
    TextButton.TextSize = math.max(1, (math.floor(7 * n1 + 0.5)))
    TextButton.Text = p27
    TextButton.AutoLocalize = false

    local v29 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v29
    UICorner.Parent = TextButton

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v4
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = TextButton
    TextButton.Parent = p24

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = TextButton
    TextButton.MouseEnter:Connect(function() -- line: 96
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.12), {
            Scale = 1.06
        }):Play()
    end)
    TextButton.MouseLeave:Connect(function() -- line: 97
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.12), {
            Scale = 1
        }):Play()
    end)

    return TextButton
end

local function chip(p28, p29, p30) -- line: 100
    -- upvalues: TyreCatalog (copy), v3 (copy), v4 (copy), v5 (copy), v7 (copy)
    local v30 = TyreCatalog.Compounds[p29]
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Compound"
    TextLabel.BackgroundColor3 = v30 and v30.Color or v5
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.fromOffset(p30, p30)
    TextLabel.Text = v30 and v30.Letter or "?"
    TextLabel.FontFace = v7
    TextLabel.TextSize = math.floor(p30 * 0.62)
    TextLabel.AutoLocalize = false

    local BackgroundColor3 = TextLabel.BackgroundColor3

    TextLabel.TextColor3 = 0.299 * BackgroundColor3.R + 0.587 * BackgroundColor3.G + 0.114 * BackgroundColor3.B > 0.6 and v4 or v3

    local v32 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v32
    UICorner.Parent = TextLabel
    TextLabel.Parent = p28

    return TextLabel
end

local v33

local function toast(p31) -- line: 110
    -- upvalues: t2 (copy)
    if t2.toast then
        t2.toast.Text = p31
        t2.toast.TextTransparency = 0
        t2.toastAt = os.clock()
    end
end

local function act(p32, p33, p34) -- line: 115
    -- upvalues: TyreAction (copy), t1 (copy), t2 (copy), v33 (ref)
    if t2.pending then
        return
    end

    t2.pending = true

    local side = t2.side

    task.spawn(function() -- line: 119
        -- upvalues: p32 (copy), p33 (copy), p34 (copy), side (copy), TyreAction (copy), t1 (copy), t2 (copy), v33 (ref)
        local InvokeServer = TyreAction.InvokeServer
        local ok, result = pcall(InvokeServer, TyreAction, p32, side, p33, p34)

        t2.pending = false

        if ok then
            if typeof(result) == "table" and result.ok == false then
                local v34 = result.err or "NOT AVAILABLE"

                if t2.toast then
                    t2.toast.Text = v34
                    t2.toast.TextTransparency = 0
                    t2.toastAt = os.clock()
                end
            elseif p32 == "Restore" then
                local v35 = string.upper(t1[side])
                local v36 = string.upper(p33)
                local v37 = typeof(result) == "table" and result.cost or 0
                local v39 = ("%s %s %d RESTORED · -%s"):format(v35, v36, p34, "$" .. string.format("%d", (math.floor((v37 or 0) + 0.5))))

                if t2.toast then
                    t2.toast.Text = v39
                    t2.toast.TextTransparency = 0
                    t2.toastAt = os.clock()
                end
            elseif p32 == "Fit" then
                local v40 = ("%s %s %d FITTED"):format(string.upper(t1[side]), string.upper(p33), p34)

                if t2.toast then
                    t2.toast.Text = v40
                    t2.toast.TextTransparency = 0
                    t2.toastAt = os.clock()
                end
            end
        elseif t2.toast then
            t2.toast.Text = "CONNECTION ERROR · TRY AGAIN"
            t2.toast.TextTransparency = 0
            t2.toastAt = os.clock()
        end

        v33()
    end)
end

local function fill() -- line: 130
    -- upvalues: UserInputService (copy), TyreCatalog (copy), TyreAction (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), t1 (copy), fitted (copy), n1 (ref), t2 (copy), pill (copy), chip (copy), v33 (ref)
    local content = t2.content

    if not content then
        return
    end

    for _, child in content:GetChildren() do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    t2.rows = {}

    local v41 = if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then 22 else 18
    local n2 = 0

    for _, v42 in TyreCatalog.Order do
        local v43 = TyreCatalog.Compounds[v42]

        n2 += 1

        local Frame = Instance.new("Frame")

        Frame.Name = "Header_" .. v42
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(20 * n1 + 0.5)))))
        Frame.LayoutOrder = n2
        Frame.Parent = content

        local v48 = chip(Frame, v42, (math.max(1, (math.floor(12 * n1 + 0.5)))))

        v48.AnchorPoint = Vector2.new(0, 0.5)
        v48.Position = UDim2.new(0, 0, 0.5, 0)

        local Name = v43.Name
        local v51 = math.max(1, (math.floor(11 * n1 + 0.5)))
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "Title"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = Name
        TextLabel.FontFace = v7
        TextLabel.TextSize = v51
        TextLabel.TextColor3 = v3
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.AutoLocalize = false
        TextLabel.Parent = Frame
        TextLabel.Position = UDim2.fromOffset(math.max(1, (math.floor(17 * n1 + 0.5))), 0)
        TextLabel.Size = UDim2.new(0.5, 0, 1, 0)

        local v54 = v43.Hint or ""
        local v57 = math.max(1, (math.floor(6.5 * n1 + 0.5)))
        local TextLabel2 = Instance.new("TextLabel")

        TextLabel2.Name = "Hint"
        TextLabel2.BackgroundTransparency = 1
        TextLabel2.Text = v54
        TextLabel2.FontFace = v8
        TextLabel2.TextSize = v57
        TextLabel2.TextColor3 = v5
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel2.AutoLocalize = false
        TextLabel2.Parent = Frame
        TextLabel2.AnchorPoint = Vector2.new(1, 0)
        TextLabel2.Position = UDim2.fromScale(1, 0)
        TextLabel2.Size = UDim2.new(0.6, 0, 1, 0)
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Right

        for i = 1, TyreCatalog.PerCompound do
            n2 += 1

            local Frame = Instance.new("Frame")

            Frame.Name = ("Row_%s_%d"):format(v42, i)
            Frame.BackgroundColor3 = v3
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(v41 * n1 + 0.5)))))
            Frame.LayoutOrder = n2

            local v62 = UDim.new(0, (math.max(1, (math.floor(3 * n1 + 0.5)))))
            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = v62
            UICorner.Parent = Frame
            Frame.Parent = content

            local v63 = "Tyre " .. i
            local v66 = math.max(1, (math.floor(8.5 * n1 + 0.5)))
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = "Label"
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = v63
            TextLabel.FontFace = v8
            TextLabel.TextSize = v66
            TextLabel.TextColor3 = v4
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.AutoLocalize = false
            TextLabel.Parent = Frame
            TextLabel.Position = UDim2.fromOffset(math.max(1, (math.floor(10 * n1 + 0.5))), 0)
            TextLabel.Size = UDim2.new(0, math.max(1, (math.floor(40 * n1 + 0.5))), 1, 0)

            local Frame2 = Instance.new("Frame")

            Frame2.Name = "Tread"
            Frame2.AnchorPoint = Vector2.new(0, 0.5)
            Frame2.Position = UDim2.new(0, math.max(1, (math.floor(50 * n1 + 0.5))), 0.5, 0)
            Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(40 * n1 + 0.5))), (math.max(1, (math.floor(5 * n1 + 0.5)))))
            Frame2.BackgroundColor3 = v6
            Frame2.BorderSizePixel = 0

            local v78 = UDim.new(1, 0)
            local UICorner2 = Instance.new("UICorner")

            UICorner2.CornerRadius = v78
            UICorner2.Parent = Frame2
            Frame2.Parent = Frame

            local Frame3 = Instance.new("Frame")

            Frame3.Name = "Fill"
            Frame3.BorderSizePixel = 0
            Frame3.Size = UDim2.fromScale(1, 1)

            local v79 = UDim.new(1, 0)
            local UICorner3 = Instance.new("UICorner")

            UICorner3.CornerRadius = v79
            UICorner3.Parent = Frame3
            Frame3.Parent = Frame2

            local v82 = math.max(1, (math.floor(7.5 * n1 + 0.5)))
            local TextLabel2 = Instance.new("TextLabel")

            TextLabel2.Name = "Percent"
            TextLabel2.BackgroundTransparency = 1
            TextLabel2.Text = "100%"
            TextLabel2.FontFace = v7
            TextLabel2.TextSize = v82
            TextLabel2.TextColor3 = v4
            TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel2.AutoLocalize = false
            TextLabel2.Parent = Frame
            TextLabel2.Position = UDim2.fromOffset(math.max(1, (math.floor(94 * n1 + 0.5))), 0)
            TextLabel2.Size = UDim2.new(0, math.max(1, (math.floor(30 * n1 + 0.5))), 1, 0)

            local FIT = pill(Frame, "Fit", 38, "FIT")

            FIT.Position = UDim2.new(1, -math.max(1, (math.floor(6 * n1 + 0.5))), 0.5, 0)

            local RESTORE = pill(Frame, "Restore", 58, "RESTORE")

            RESTORE.Position = UDim2.new(1, -math.max(1, (math.floor(6 * n1 + 0.5))) - math.max(1, (math.floor(38 * n1 + 0.5))) - math.max(1, (math.floor(4 * n1 + 0.5))), 0.5, 0)

            local v97 = v42 .. ":" .. i

            FIT.Activated:Connect(function() -- line: 157
                -- upvalues: v42 (copy), i (copy), TyreAction (copy), t1 (copy), fitted (copy), t2 (copy), v33 (ref)
                local v98, v99 = fitted(t2.side)

                if v98 == v42 and v99 == i or t2.pending then
                    return
                end

                t2.pending = true

                local side = t2.side
                local spawn = task.spawn
                local v100 = "Fit"

                spawn(function() -- line: 119
                    -- upvalues: side (copy), v100 (copy), v42 (copy), i (copy), TyreAction (copy), t1 (copy), t2 (copy), v33 (ref)
                    local InvokeServer = TyreAction.InvokeServer
                    local ok, result = pcall(InvokeServer, TyreAction, v100, side, v42, i)

                    t2.pending = false

                    if ok then
                        if typeof(result) == "table" and result.ok == false then
                            local v101 = result.err or "NOT AVAILABLE"

                            if t2.toast then
                                t2.toast.Text = v101
                                t2.toast.TextTransparency = 0
                                t2.toastAt = os.clock()
                            end
                        elseif v100 == "Restore" then
                            local v102 = string.upper(t1[side])
                            local v103 = string.upper(v42)
                            local v104 = typeof(result) == "table" and result.cost or 0
                            local v106 = ("%s %s %d RESTORED · -%s"):format(v102, v103, i, "$" .. string.format("%d", (math.floor((v104 or 0) + 0.5))))

                            if t2.toast then
                                t2.toast.Text = v106
                                t2.toast.TextTransparency = 0
                                t2.toastAt = os.clock()
                            end
                        elseif v100 == "Fit" then
                            local v107 = ("%s %s %d FITTED"):format(string.upper(t1[side]), string.upper(v42), i)

                            if t2.toast then
                                t2.toast.Text = v107
                                t2.toast.TextTransparency = 0
                                t2.toastAt = os.clock()
                            end
                        end
                    elseif t2.toast then
                        t2.toast.Text = "CONNECTION ERROR · TRY AGAIN"
                        t2.toast.TextTransparency = 0
                        t2.toastAt = os.clock()
                    end

                    v33()
                end)
            end)
            RESTORE.Activated:Connect(function() -- line: 162
                -- upvalues: v42 (copy), i (copy), v97 (copy), TyreAction (copy), t1 (copy), t2 (copy), v33 (ref)
                local v108 = t2.side .. ":" .. v97

                if not (t2.confirm[v108] and os.clock() - t2.confirm[v108] < 3) then
                    t2.confirm[v108] = os.clock()
                else
                    t2.confirm[v108] = nil

                    if not t2.pending then
                        t2.pending = true

                        local side = t2.side
                        local spawn = task.spawn
                        local v109 = "Restore"

                        spawn(function() -- line: 119
                            -- upvalues: side (copy), v109 (copy), v42 (copy), i (copy), TyreAction (copy), t1 (copy), t2 (copy), v33 (ref)
                            local InvokeServer = TyreAction.InvokeServer
                            local ok, result = pcall(InvokeServer, TyreAction, v109, side, v42, i)

                            t2.pending = false

                            if ok then
                                if typeof(result) == "table" and result.ok == false then
                                    local v110 = result.err or "NOT AVAILABLE"

                                    if t2.toast then
                                        t2.toast.Text = v110
                                        t2.toast.TextTransparency = 0
                                        t2.toastAt = os.clock()
                                    end
                                elseif v109 == "Restore" then
                                    local v111 = string.upper(t1[side])
                                    local v112 = string.upper(v42)
                                    local v113 = typeof(result) == "table" and result.cost or 0
                                    local v115 = ("%s %s %d RESTORED · -%s"):format(v111, v112, i, "$" .. string.format("%d", (math.floor((v113 or 0) + 0.5))))

                                    if t2.toast then
                                        t2.toast.Text = v115
                                        t2.toast.TextTransparency = 0
                                        t2.toastAt = os.clock()
                                    end
                                elseif v109 == "Fit" then
                                    local v116 = ("%s %s %d FITTED"):format(string.upper(t1[side]), string.upper(v42), i)

                                    if t2.toast then
                                        t2.toast.Text = v116
                                        t2.toast.TextTransparency = 0
                                        t2.toastAt = os.clock()
                                    end
                                end
                            elseif t2.toast then
                                t2.toast.Text = "CONNECTION ERROR · TRY AGAIN"
                                t2.toast.TextTransparency = 0
                                t2.toastAt = os.clock()
                            end

                            v33()
                        end)
                    end
                end

                v33()
            end)
            table.insert(t2.rows, {
                compound = v42,
                slot = i,
                fill = Frame3,
                pct = TextLabel2,
                fit = FIT,
                restore = RESTORE,
                key = v97
            })
        end
    end

    v33()
end

local function setSide(p35) -- line: 174
    -- upvalues: t2 (copy), fill (copy)
    if t2.side == p35 and t2.content and #t2.rows > 0 then
        return
    end

    t2.side = p35
    fill()

    if t2.content then
        t2.content.CanvasPosition = Vector2.zero
    end
end

local v117

local function build() -- line: 182
    -- upvalues: TweenService (copy), TyreCatalog (copy), RaceIcons (copy), v1 (copy), v2 (copy), v3 (copy), v5 (copy), v7 (copy), v8 (copy), t1 (copy), ScreenGui (copy), n1 (ref), t2 (copy), v33 (ref), fill (copy), v117 (ref)
    if t2.root then
        t2.root:Destroy()
    end

    t2.rows = {}
    t2.cats = {}
    t2.summary = {}

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
    t2.root = Frame

    local v118 = math.max(1, (math.floor(12 * n1 + 0.5)))
    local Frame2 = Instance.new("TextLabel")

    Frame2.Name = "Title"
    Frame2.BackgroundTransparency = 1
    Frame2.Text = "TYRES"
    Frame2.FontFace = v7
    Frame2.TextSize = v118
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

    local v119 = -math.max(1, (math.floor(26 * n1 + 0.5)))
    local v122 = math.floor(18 * n1 + 0.5)

    TextButton.Position = fromOffset(1, v119, 0, (math.max(1, v122)))
    fromOffset = UDim2.fromOffset
    v118 = math.max(1, (math.floor(30 * n1 + 0.5)))

    local ScrollingFrame = 16 * n1 + 0.5

    TextButton.Size = fromOffset(v118, (math.max(1, (math.floor(ScrollingFrame)))))
    TextButton.ZIndex = 3
    TextButton.Modal = false
    TextButton.Parent = Frame
    t2.close = TextButton

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Plate"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ImageColor3 = v3
    ImageLabel.ZIndex = 3
    ImageLabel.Parent = TextButton
    v119 = RaceIcons.Get("ref_top_plate")

    if v119 then
        ImageLabel.ImageContent = v119
    else
        ImageLabel.BackgroundTransparency = 0
        ImageLabel.BackgroundColor3 = v3
        v118 = UDim.new
        v122 = 4 * n1 + 0.5
        ScrollingFrame = math.floor(v122)
        v118 = v118(0, (math.max(1, ScrollingFrame)))
        v119 = Instance.new("UICorner")
        v119.CornerRadius = v118
        v119.Parent = ImageLabel
    end

    Frame2 = math.max(1, (math.floor(10 * n1 + 0.5)))

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "X"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "X"
    TextLabel2.FontFace = v7
    TextLabel2.TextSize = Frame2
    TextLabel2.TextColor3 = v2
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.AutoLocalize = false
    TextLabel2.Parent = TextButton
    TextLabel2.Size = UDim2.fromScale(1, 1)
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel2.ZIndex = 4

    local function hover(p36) -- line: 203
        -- upvalues: ImageLabel (copy), TextLabel2 (copy), TweenService (copy), v1 (copy), v2 (copy), v3 (copy)
        TweenService:Create(ImageLabel, TweenInfo.new(0.18), {
            ImageColor3 = p36 and v1 or v3,
            BackgroundColor3 = p36 and v1 or v3
        }):Play()
        TweenService:Create(TextLabel2, TweenInfo.new(0.18), {
            TextColor3 = p36 and v3 or v2
        }):Play()
    end

    TextButton.MouseEnter:Connect(function() -- line: 207
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.MouseLeave:Connect(function() -- line: 207
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.SelectionGained:Connect(function() -- line: 208
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.SelectionLost:Connect(function() -- line: 208
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.Activated:Connect(function() -- line: 209
        -- upvalues: v117 (ref)
        v117()
    end)
    Frame2 = Instance.new("TextLabel")
    Frame2.Name = "Countdown"
    Frame2.AnchorPoint = Vector2.new(1, 0.5)
    Frame2.Position = UDim2.new(1, -math.max(1, (math.floor(46 * n1 + 0.5))), 0, (math.max(1, (math.floor(18 * n1 + 0.5)))))
    Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(40 * n1 + 0.5))), (math.max(1, (math.floor(12 * n1 + 0.5)))))
    Frame2.BackgroundColor3 = v1
    Frame2.BorderSizePixel = 0
    Frame2.FontFace = v7
    Frame2.TextSize = math.max(1, (math.floor(7.5 * n1 + 0.5)))
    Frame2.TextColor3 = v3
    Frame2.Text = ""
    Frame2.AutoLocalize = false
    Frame2.Visible = false

    local v121 = UDim.new(1, 0)
    local v120 = Instance.new("UICorner")

    v120.CornerRadius = v121
    v120.Parent = Frame2
    Frame2.Parent = Frame
    t2.countdown = Frame2
    Frame2 = Instance.new("Frame")
    Frame2.Name = "TimerLine"
    Frame2.AnchorPoint = Vector2.new(0, 0)
    Frame2.Position = UDim2.new(0, 0, 1, (math.max(1, (math.floor(3 * n1 + 0.5)))))
    Frame2.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    Frame2.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    Frame2.BackgroundTransparency = 0.1
    Frame2.BorderSizePixel = 0
    Frame2.Visible = t2.mode == "grid"
    Frame2.Parent = Frame
    v121 = Instance.new("Frame")
    v121.Name = "Fill"
    v121.Size = UDim2.fromScale(1, 1)
    v121.BackgroundColor3 = v1
    v121.BorderSizePixel = 0
    v121.Parent = Frame2
    t2.timerFill = v121
    ScrollingFrame = math.max(1, (math.floor(7.5 * n1 + 0.5)))

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Balance"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.FontFace = v8
    TextLabel.TextSize = ScrollingFrame
    TextLabel.TextColor3 = v5
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = Frame
    TextLabel.AnchorPoint = Vector2.new(1, 0.5)
    v120 = UDim2.new
    v122 = -math.max(1, (math.floor(46 * n1 + 0.5)))

    local new = 18 * n1 + 0.5
    local Frame3 = math.floor(new)

    TextLabel.Position = v120(1, v122, 0, (math.max(1, Frame3)))
    TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(110 * n1 + 0.5))), (math.max(1, (math.floor(12 * n1 + 0.5)))))
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right
    t2.balance = TextLabel
    Frame2 = Instance.new("Frame")
    Frame2.Name = "Categories"
    Frame2.BackgroundTransparency = 1
    Frame2.Position = UDim2.fromOffset(0, (math.max(1, (math.floor(36 * n1 + 0.5)))))
    v120 = UDim2.fromOffset
    ScrollingFrame = math.max(1, (math.floor(78 * n1 + 0.5)))

    local TextButton2 = 166 * n1 + 0.5

    Frame2.Size = v120(ScrollingFrame, (math.max(1, (math.floor(TextButton2)))))
    Frame2.Parent = Frame
    v120 = Instance.new("UIListLayout")
    v120.SortOrder = Enum.SortOrder.LayoutOrder
    v120.Parent = Frame2

    local v126, v127, v128, v129, TextLabel4

    for v130, v131 in TyreCatalog.Sides do
        TextButton2 = Instance.new("TextButton")
        TextButton2.Name = "Cat_" .. t1[v131]
        TextButton2.AutoButtonColor = false
        TextButton2:SetAttribute("NoHover", true)
        TextButton2.BorderSizePixel = 0
        Frame3 = UDim2.new
        v126 = 20 * n1 + 0.5
        v127 = math.floor(v126)
        TextButton2.Size = Frame3(1, 0, 0, (math.max(1, v127)))
        TextButton2.LayoutOrder = v130
        TextButton2.BackgroundColor3 = v1
        TextButton2.BackgroundTransparency = 1
        TextButton2.Text = t1[v131]
        TextButton2.FontFace = v8
        v129 = 9.5 * n1 + 0.5
        v128 = math.floor(v129)
        TextButton2.TextSize = math.max(1, v128)
        TextButton2.TextColor3 = v3
        TextButton2.TextXAlignment = Enum.TextXAlignment.Left
        TextButton2.AutoLocalize = false
        Frame3 = Instance.new("UIPadding")
        new = UDim.new
        v127 = 10 * n1 + 0.5
        TextLabel4 = math.floor(v127)
        Frame3.PaddingLeft = new(0, (math.max(1, TextLabel4)))
        Frame3.Parent = TextButton2
        TextButton2.Parent = Frame2

        local t6 = {
            hover = false,
            side = v131,
            button = TextButton2
        }

        new = TextButton2.MouseEnter
        new:Connect(function() -- line: 233
            -- upvalues: t6 (copy), v33 (ref)
            t6.hover = true
            v33()
        end)
        new = TextButton2.MouseLeave
        new:Connect(function() -- line: 233
            -- upvalues: t6 (copy), v33 (ref)
            t6.hover = false
            v33()
        end)
        new = TextButton2.Activated
        new:Connect(function() -- line: 234
            -- upvalues: v131 (copy), t2 (copy), fill (copy)
            if t2.side == v131 and t2.content and #t2.rows > 0 then
                return
            end

            t2.side = v131
            fill()

            if t2.content then
                t2.content.CanvasPosition = Vector2.zero
            end
        end)
        t2.cats[v131] = t6
    end

    Frame2 = Instance.new("Frame")
    Frame2.Name = "Fitted"
    Frame2.BackgroundTransparency = 1
    Frame2.Position = UDim2.fromOffset(math.max(1, (math.floor(10 * n1 + 0.5))), (math.max(1, (math.floor(88 * n1 + 0.5)))))
    Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(64 * n1 + 0.5))), (math.max(1, (math.floor(60 * n1 + 0.5)))))
    Frame2.Parent = Frame
    v122 = math.max(1, (math.floor(6.5 * n1 + 0.5)))

    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Name = "Caption"
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = "FITTED"
    TextLabel3.FontFace = v7
    TextLabel3.TextSize = v122
    TextLabel3.TextColor3 = v5
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.AutoLocalize = false
    TextLabel3.Parent = Frame2
    ScrollingFrame = UDim2.fromOffset
    v122 = math.max(1, (math.floor(64 * n1 + 0.5)))
    Frame3 = 10 * n1 + 0.5
    TextLabel3.Size = ScrollingFrame(v122, (math.max(1, (math.floor(Frame3)))))

    for v133, v134 in TyreCatalog.Sides do
        Frame3 = Instance.new("Frame")
        Frame3.Name = "Fitted" .. v134
        Frame3.BackgroundTransparency = 1

        local Frame = UDim2.fromOffset

        v126 = (12 + (v133 - 1) * 16) * n1 + 0.5
        v127 = math.floor(v126)
        Frame3.Position = Frame(0, (math.max(1, v127)))
        Frame = UDim2.fromOffset
        v129 = math.floor(64 * n1 + 0.5)
        new = math.max(1, v129)
        TextLabel4 = 13 * n1 + 0.5
        Frame3.Size = Frame(new, (math.max(1, (math.floor(TextLabel4)))))
        Frame3.Parent = Frame2
        Frame = Instance.new("Frame")
        Frame.BackgroundTransparency = 1
        new = UDim2.fromOffset
        TextLabel4 = 11 * n1 + 0.5
        v128 = math.max(1, (math.floor(TextLabel4)))
        v127 = 11 * n1 + 0.5
        TextLabel4 = math.floor(v127)
        Frame.Size = new(v128, (math.max(1, TextLabel4)))
        Frame.AnchorPoint = Vector2.new(0, 0.5)
        Frame.Position = UDim2.new(0, 0, 0.5, 0)
        Frame.Parent = Frame3
        v127 = 7 * n1 + 0.5
        TextLabel4 = math.floor(v127)
        v129 = math.max(1, TextLabel4)
        TextLabel4 = Instance.new("TextLabel")
        TextLabel4.Name = "Text"
        TextLabel4.BackgroundTransparency = 1
        TextLabel4.Text = ""
        TextLabel4.FontFace = v8
        TextLabel4.TextSize = v129
        TextLabel4.TextColor3 = v3
        TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel4.AutoLocalize = false
        TextLabel4.Parent = Frame3
        v128 = UDim2.fromOffset
        v127 = 15 * n1 + 0.5
        TextLabel4.Position = v128(math.max(1, (math.floor(v127))), 0)
        v128 = UDim2.new
        v126 = math.floor(15 * n1 + 0.5)
        TextLabel4.Size = v128(1, -math.max(1, v126), 1, 0)
        t2.summary[v134] = {
            holder = Frame,
            text = TextLabel4
        }
    end

    v122 = math.max(1, (math.floor(6.5 * n1 + 0.5)))
    TextLabel3 = Instance.new("TextLabel")
    TextLabel3.Name = "Toast"
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = ""
    TextLabel3.FontFace = v8
    TextLabel3.TextSize = v122
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
    t2.toast = TextLabel3
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
    t2.content = ScrollingFrame

    local UIPadding = Instance.new("UIListLayout")

    UIPadding.SortOrder = Enum.SortOrder.LayoutOrder
    UIPadding.Padding = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    UIPadding.Parent = ScrollingFrame
    UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingRight = UDim.new(0, (math.max(1, (math.floor(8 * n1 + 0.5)))))
    UIPadding.PaddingTop = UDim.new(0, (math.max(1, (math.floor(2 * n1 + 0.5)))))
    UIPadding.PaddingBottom = UDim.new(0, (math.max(1, (math.floor(6 * n1 + 0.5)))))
    UIPadding.Parent = ScrollingFrame
end

v33 = function() -- line: 259
    -- upvalues: LocalPlayer (copy), TyreCatalog (copy), ok (copy), result (copy), v1 (copy), v3 (copy), v4 (copy), t1 (copy), pctText (copy), v14 (ref), readState (copy), fitted (copy), n1 (ref), t2 (copy), chip (copy)
    if t2.root then
        readState()

        for v138, v139 in t2.cats do
            local button = v139.button

            if v138 == t2.side then
                button.BackgroundTransparency = 0
            elseif v139.hover then
                button.BackgroundTransparency = 0.75
            else
                button.BackgroundTransparency = 1
            end
        end

        for v140, v141 in t2.summary do
            local v142, v143 = fitted(v140)
            local v144 = v14 or readState()
            local v145 = v144[v140] and v144[v140][v142]
            local v146 = v145 and v145[v143]
            local v147 = typeof(v146) == "number" and v146 or 1

            if v141.compound ~= v142 then
                v141.compound = v142

                for _, child in v141.holder:GetChildren() do
                    child:Destroy()
                end

                chip(v141.holder, v142, (math.max(1, (math.floor(11 * n1 + 0.5)))))
            end

            v141.text.Text = ("%s  %s"):format(string.upper(t1[v140]), pctText(v147))
        end

        local elapsed = os.clock()

        for _, v150 in t2.rows do
            local side = t2.side
            local compound, slot = v150.compound, v150.slot
            local v151 = v14 or readState()
            local v152 = v151[side] and v151[side][compound]
            local v153 = v152 and v152[slot]
            local v154 = typeof(v153) == "number" and v153 or 1

            v150.fill.Size = UDim2.fromScale(math.clamp(v154, 0, 1), 1)
            v150.fill.BackgroundColor3 = TyreCatalog.Color(v154)
            v150.fill.Visible = v154 > 0.005

            local pct = v150.pct

            if v154 >= 0.9995 then
                pct.Text = "100%"
            else
                pct.Text = ("%d%%"):format((math.clamp(math.floor(v154 * 100 + 0.5), 0, 99)))
            end

            local v157, v158 = fitted(t2.side)
            local v159 = v157 == v150.compound and v158 == v150.slot
            local v160 = if v159 then "FITTED" else "FIT"

            if v150.fit.Text ~= v160 then
                v150.fit.Text = v160
            end

            local fit = v150.fit

            fit.BackgroundColor3 = v159 and v1 or v3
            fit.TextColor3 = v159 and v3 or v4

            local UIStroke = fit:FindFirstChildOfClass("UIStroke")

            if UIStroke then
                UIStroke.Color = v159 and v1 or v4
            end

            local v161 = v154 < 0.9995

            v150.restore.Visible = v161

            local v162 = t2.side .. ":" .. v150.key
            local v163 = t2.confirm[v162] and elapsed - t2.confirm[v162] < 3
            local v164

            if v163 then
                local v165 = TyreCatalog.RestoreCostFor(v154)

                v164 = "PAY " .. "$" .. string.format("%d", (math.floor((v165 or 0) + 0.5))) or "RESTORE"
            else
                v164 = "RESTORE"
                t2.confirm[v162] = nil
            end

            if v150.restore.Text ~= v164 then
                v150.restore.Text = v164
            end

            local restore = v150.restore
            local v167 = v163 == true

            restore.BackgroundColor3 = v167 and v1 or v3
            restore.TextColor3 = v167 and v3 or v4

            local UIStroke2 = restore:FindFirstChildOfClass("UIStroke")

            if UIStroke2 then
                UIStroke2.Color = v167 and v1 or v4
            end
        end

        if not t2.balance then
            return
        end

        local balance = t2.balance
        local v168 = LocalPlayer:GetAttribute("Money") or 0

        if ok and result.Money then
            balance.Text = result.Money(v168)
        else
            balance.Text = "$" .. tostring(v168)
        end
    end
end

local v169 = MotoLegends:FindFirstChild("CloseMenus") or Instance.new("BindableEvent")

v169.Name = "CloseMenus"
v169.Parent = MotoLegends

local function openMenu(p37, p38) -- line: 301
    -- upvalues: JerezRaceHUD (copy), t2 (copy), fill (copy), build (copy), v169 (copy)
    if not t2.open then
        v169:Fire("Tyres")
    end

    t2.mode = p37 or "pit"
    t2.crewRoot = p38

    if JerezRaceHUD:GetAttribute("LobbySettings") == true then
        JerezRaceHUD:SetAttribute("LobbySettings", false)
    end

    build()
    t2.open = true
    t2.root.Visible = true
    t2.close.Modal = true
    t2.rows = {}
    fill()
end

v117 = function() -- line: 308
    -- upvalues: t2 (copy)
    if t2.open then
        t2.open = false
        t2.crewRoot = nil
        table.clear(t2.confirm)

        if t2.root then
            t2.root.Visible = false
            t2.close.Modal = false
        end
    end
end

v169.Event:Connect(function(p39) -- line: 313
    -- upvalues: v117 (ref)
    if p39 ~= "Tyres" then
        v117()
    end
end)
LocalPlayer:GetAttributeChangedSignal("TyreState"):Connect(function() -- line: 314
    -- upvalues: t2 (copy), v33 (ref)
    if t2.open then
        v33()
    end
end)
LocalPlayer:GetAttributeChangedSignal("Money"):Connect(function() -- line: 315
    -- upvalues: t2 (copy), v33 (ref)
    if t2.open then
        v33()
    end
end)
JerezRaceHUD:GetAttributeChangedSignal("LobbySettings"):Connect(function() -- line: 317
    -- upvalues: JerezRaceHUD (copy), v117 (ref)
    if JerezRaceHUD:GetAttribute("LobbySettings") == true then
        v117()
    end
end)
UserInputService.InputBegan:Connect(function(p40) -- line: 318
    -- upvalues: t2 (copy), v117 (ref)
    if t2.open and p40.KeyCode == Enum.KeyCode.ButtonB then
        v117()
    end
end)
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 319
    -- upvalues: t2 (copy), fill (copy), build (copy)
    if t2.open then
        local side = t2.side

        build()
        t2.side = side
        t2.root.Visible = true
        t2.close.Modal = true
        fill()
    end
end)

local function setupPrompt(p41) -- line: 325
    -- upvalues: LocalPlayer (copy), t2 (copy), v117 (ref), openMenu (copy)
    if not p41:IsA("ProximityPrompt") then
        return
    end

    local function mine() -- line: 327
        -- upvalues: p41 (copy), LocalPlayer (copy)
        return p41:GetAttribute("TyreOwner") == LocalPlayer.UserId
    end

    local function update() -- line: 328
        -- upvalues: p41 (copy), LocalPlayer (copy)
        p41.Enabled = p41:GetAttribute("TyreOwner") == LocalPlayer.UserId
    end

    p41.Enabled = p41:GetAttribute("TyreOwner") == LocalPlayer.UserId
    p41:GetAttributeChangedSignal("TyreOwner"):Connect(update)
    p41.Triggered:Connect(function(p42) -- line: 330
        -- upvalues: p41 (copy), LocalPlayer (copy), t2 (copy), v117 (ref), openMenu (copy)
        if p42 == LocalPlayer and p41:GetAttribute("TyreOwner") == LocalPlayer.UserId then
            local elapsed = os.clock()

            if not (elapsed - (t2.lastToggle or 0) < 0.6) then
                t2.lastToggle = elapsed

                local v170 = p41.Parent and p41.Parent.Parent
                local v171 = v170 and v170:GetAttribute("TyreGrid") == true

                if t2.open then
                    v117()
                else
                    local v172 = if v171 then "grid" else "pit"
                    local Parent = p41.Parent
                    local ok, result = pcall(openMenu, v172, Parent)

                    if not ok then
                        warn("[TyreClient] opening the tyre menu failed: " .. tostring(result))
                    end
                end
            end
        end
    end)
end

for _, v173 in CollectionService:GetTagged("TyrePrompt") do
    setupPrompt(v173)
end

CollectionService:GetInstanceAddedSignal("TyrePrompt"):Connect(setupPrompt)

local v174 = MotoLegends:GetAttribute("TyrePickId") or 0

local function pickLeft() -- line: 350
    -- upvalues: MotoLegends (copy)
    return (MotoLegends:GetAttribute("TyrePickEnd") or 0) - workspace:GetServerTimeNow()
end

local function checkPick() -- line: 351
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), openMenu (copy), v174 (ref)
    local v175 = MotoLegends:GetAttribute("TyrePickId") or 0

    if v175 ~= v174 and (MotoLegends:GetAttribute("TyrePickEnd") or 0) - workspace:GetServerTimeNow() > 0.3 and LocalPlayer:GetAttribute("RaceParticipant") == true then
        v174 = v175
        openMenu("grid")
    end
end

MotoLegends:GetAttributeChangedSignal("TyrePickId"):Connect(checkPick)
MotoLegends:GetAttributeChangedSignal("TyrePickEnd"):Connect(checkPick)
task.defer(checkPick)
RunService.Heartbeat:Connect(function() -- line: 362
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), TyreCatalog (copy), t2 (copy), v33 (ref), v117 (ref)
    if t2.toast and t2.toastAt then
        local v176 = os.clock() - t2.toastAt

        if v176 > 2.5 then
            t2.toast.TextTransparency = math.clamp((v176 - 2.5) / 0.5, 0, 1)

            if v176 > 3 then
                t2.toastAt = nil
            end
        end
    end

    if t2.open then
        if t2.mode == "grid" then
            local v178 = (MotoLegends:GetAttribute("TyrePickEnd") or 0) - workspace:GetServerTimeNow()

            if v178 <= 0 then
                v117()

                return
            end

            if t2.timerFill then
                t2.timerFill.Size = UDim2.fromScale(math.clamp(v178 / (MotoLegends:GetAttribute("TyrePickSeconds") or TyreCatalog.PickSeconds), 0, 1), 1)
            end
        elseif t2.crewRoot then
            local v180 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if not (t2.crewRoot.Parent and (not v180 or not ((v180.Position - t2.crewRoot.Position).Magnitude > 18))) then
                v117()

                return
            end
        end

        for v181, v182 in t2.confirm do
            if os.clock() - v182 >= 3 then
                t2.confirm[v181] = nil
                v33()

                return
            end
        end
    end
end)
task.spawn(function() -- line: 385
    -- upvalues: TweenService (copy), RunService (copy), LocalPlayer (copy), TyreCatalog (copy), JerezRaceHUD (copy), v2 (copy), v3 (copy), v9 (copy)
    local v183 = JerezRaceHUD:WaitForChild("TelemetryAnchor", 60)

    if not v183 then
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

    local t7 = {}

    local function text(p43, p44, p45, p46) -- line: 393
        -- upvalues: v3 (copy), v9 (copy)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = p44
        TextLabel:SetAttribute("KeepFont", true)
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderSizePixel = 0
        TextLabel.FontFace = v9
        TextLabel.TextSize = p46
        TextLabel.TextColor3 = v3
        TextLabel.Text = p45
        TextLabel.AutoLocalize = false
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel.TextYAlignment = Enum.TextYAlignment.Center
        TextLabel.Parent = p43

        return TextLabel
    end

    for v184, v185 in TyreCatalog.Sides do
        local v186 = (v184 - 1) * 26
        local Frame2 = Instance.new("Frame")

        Frame2.Name = "CompoundDisc" .. v185
        Frame2.BackgroundColor3 = v2
        Frame2.BackgroundTransparency = 0
        Frame2.BorderSizePixel = 0
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame2.Position = UDim2.fromOffset(v186 + 9.5, 7)
        Frame2.Size = UDim2.fromOffset(18, 18)

        local v187 = UDim.new(1, 0)
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = v187
        UICorner.Parent = Frame2
        Frame2.Parent = Frame
        Frame2.Visible = false

        local v188 = text(Frame2, "Compound" .. v185, "M", 11)

        v188.Position = UDim2.fromScale(0, 0)
        v188.Size = UDim2.fromScale(1, 1)

        local Frame3 = Instance.new("Frame")

        Frame3.Name = "Tyre" .. v185
        Frame3.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
        Frame3.BorderSizePixel = 0
        Frame3.Position = UDim2.fromOffset(v186, 19)
        Frame3.Size = UDim2.fromOffset(19, 50)

        local v189 = UDim.new(1, 0)
        local UICorner2 = Instance.new("UICorner")

        UICorner2.CornerRadius = v189
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

        local v190 = UDim.new(1, 0)
        local UICorner3 = Instance.new("UICorner")

        UICorner3.CornerRadius = v190
        UICorner3.Parent = CanvasGroup
        CanvasGroup.Parent = Frame4

        local t8 = {}

        for v191, v192 in TyreCatalog.Zones do
            local Frame = Instance.new("Frame")

            Frame.Name = v192
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = TyreCatalog.RateColor(0)
            Frame.Position = UDim2.new((v191 - 1) / 3, v191 > 1 and 1 or 0, 0, 0)
            Frame.Size = UDim2.new(0.3333333333333333, v191 == 2 and -1 or 0, 1, 0)
            Frame.Parent = CanvasGroup
            t8[v192] = {
                frame = Frame,
                color = TyreCatalog.RateColor(0)
            }
        end

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Name = "Outline"
        UIStroke.Thickness = 2
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Color = v3
        UIStroke.Transparency = 0
        UIStroke.Parent = Frame3
        UIStroke.Thickness = 2.5

        local v193 = text(Frame3, "Side", v185, 13)

        v193.AnchorPoint = Vector2.new(0.5, 0.5)
        v193.Position = UDim2.fromScale(0.5, 0.5)
        v193.Size = UDim2.fromScale(1, 1)
        v193.ZIndex = 3
        v193.TextColor3 = v3
        v193.TextStrokeTransparency = 1
        t7[v185] = {
            shown = nil,
            letter = v188,
            fill = CanvasGroup,
            clip = Frame4,
            color = TyreCatalog.RateColor(0),
            segs = t8,
            stroke = UIStroke
        }
    end

    Frame.Parent = v183

    local function update() -- line: 436
        -- upvalues: Frame (copy), t7 (copy), TweenService (copy), LocalPlayer (copy), TyreCatalog (copy), v3 (copy)
        local v194 = LocalPlayer:GetAttribute("TyreFront") ~= nil

        Frame.Visible = v194

        if v194 then
            for v195, v196 in t7 do
                local Attribute = LocalPlayer:GetAttribute(if v195 == "F" then "TyreFront" else "TyreRear")
                local v198 = TyreCatalog.Compounds[Attribute]

                v196.letter.Text = v198 and v198.Letter or "-"

                local stroke = v196.stroke

                if v198 then
                    stroke.Color = v198.Stripe or v198.Color or v3
                else
                    stroke.Color = v3
                end

                v196.fill.BackgroundColor3 = v196.stroke.Color

                local v200 = math.clamp(LocalPlayer:GetAttribute("TyreWear" .. v195) or 1, 0, 1)

                v196.left = v200

                if v196.shown == nil or math.abs(v196.shown - v200) > 0.2 then
                    v196.clip.Size = UDim2.fromScale(1, v200)
                else
                    TweenService:Create(v196.clip, TweenInfo.new(0.4), {
                        Size = UDim2.fromScale(1, v200)
                    }):Play()
                end

                v196.shown = v200
                v196.clip.Visible = v200 > 0.005
            end
        end
    end

    local v202 = TyreCatalog.RateColor(0)
    local v203 = Color3.fromRGB(45, 110, 255)
    local v204 = Color3.fromRGB(40, 210, 235)
    local v205 = Color3.fromRGB(255, 225, 30)
    local v206 = Color3.fromRGB(255, 140, 20)
    local v207 = Color3.fromRGB(255, 40, 30)

    local function tempColor(p47, p48) -- line: 463
        -- upvalues: v202 (copy), v203 (copy), v204 (copy), v205 (copy), v206 (copy), v207 (copy), TyreCatalog (copy)
        local v208 = TyreCatalog.TempWindows[p47]

        if not v208 or typeof(p48) ~= "number" then
            return v202
        end

        local v209 = v208[1]
        local v210 = v208[2]
        local v211 = (v209 + v210) / 2

        if p48 <= v209 - 25 then
            return v203
        end

        if p48 < v209 then
            return v203:Lerp(v204, (p48 - (v209 - 25)) / 25)
        end

        if p48 < v209 + (v211 - v209) * 0.5 then
            return v204:Lerp(v202, (p48 - v209) / ((v211 - v209) * 0.5))
        end

        if p48 <= v211 then
            return v202
        end

        if p48 <= v210 then
            return v202:Lerp(v205, (p48 - v211) / (v210 - v211))
        end

        if p48 <= v210 + 12 then
            return v205:Lerp(v206, (p48 - v210) / 12)
        end

        return v206:Lerp(v207, (math.clamp((p48 - v210 - 12) / 13, 0, 1)))
    end

    for _, v213 in { "TyreFront", "TyreRear", "TyreWearF", "TyreWearR" } do
        LocalPlayer:GetAttributeChangedSignal(v213):Connect(update)
    end

    update()
    RunService.Heartbeat:Connect(function(p49) -- line: 479
        -- upvalues: v183 (copy), Frame (copy), t7 (copy), tempColor (copy), LocalPlayer (copy), TyreCatalog (copy)
        if not (Frame.Visible and v183.Visible) then
            return
        end

        local v215 = math.sin(os.clock() * 6) * 0.5 + 0.5
        local v217 = 1 - math.exp(-math.min(p49, 0.1) * 4)

        for v218, v219 in t7 do
            local v220 = LocalPlayer:GetAttribute("TyreRate" .. v218) or 0
            local v221 = TyreCatalog.RateColor(v220)

            v219.color = v219.color:Lerp(v221, v217)

            local Attribute = LocalPlayer:GetAttribute(if v218 == "F" then "TyreFront" else "TyreRear")
            local Attribute2 = LocalPlayer:GetAttribute("TyreTemp" .. v218)

            for v223, v224 in v219.segs do
                local Attribute3 = LocalPlayer:GetAttribute("TyreTemp" .. v218 .. v223)

                if typeof(Attribute3) ~= "number" then
                    Attribute3 = Attribute2
                end

                v224.color = v224.color:Lerp(tempColor(Attribute, Attribute3), v217)
                v224.frame.BackgroundColor3 = v224.color
            end

            v219.fill.GroupTransparency = (v219.left or 1) <= 0.15 and v215 * 0.45 or 0
        end
    end)
end)

return true
