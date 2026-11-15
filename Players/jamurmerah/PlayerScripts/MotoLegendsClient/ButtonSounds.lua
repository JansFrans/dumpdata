-- https://lua.expert

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local function make(p1, p2, p3) -- line: 6
    -- upvalues: SoundService (copy)
    local Sound = Instance.new("Sound")

    Sound.Name = p1
    Sound.SoundId = "rbxassetid://" .. p2
    Sound.Volume = p3
    Sound.Parent = SoundService

    return Sound
end

local Sound = Instance.new("Sound")

Sound.Name = "UIButtonHover"
Sound.SoundId = "rbxassetid://139800881181209"
Sound.Volume = 0.5
Sound.Parent = SoundService

local Sound2 = Instance.new("Sound")

Sound2.Name = "UIButtonClick"
Sound2.SoundId = "rbxassetid://122728779313257"
Sound2.Volume = 0.6
Sound2.Parent = SoundService

local n1 = 0
local self = setmetatable({}, {
    __mode = "k"
})
local t3 = {}

game:GetService("RunService"):BindToRenderStep("ButtonHoverOnScriptScale", Enum.RenderPriority.Last.Value + 5, function() -- line: 15
    -- upvalues: t3 (copy)
    for v2, v3 in t3 do
        local v4 = v2.Parent and v2:FindFirstChildOfClass("UIScale")

        if v4 then
            if v3.leaving then
                if v3.written and v4.Scale == v3.written then
                    v4.Scale = v3.base
                end

                t3[v2] = nil
            elseif v4.Scale ~= v3.written then
                v3.base = v4.Scale
                v3.written = v3.base * 1.06
                v4.Scale = v3.written
            end
        else
            t3[v2] = nil
        end
    end
end)

local v5 = Vector2.new(0.5, 0.5)

local function centreOrigin(p4) -- line: 31
    -- upvalues: v5 (copy)
    local t4 = {
        written = nil,
        anchor = p4.AnchorPoint,
        pos = p4.Position
    }

    local function inLayout() -- line: 34
        -- upvalues: p4 (copy)
        return p4.Parent ~= nil and p4.Parent:FindFirstChildWhichIsA("UIGridStyleLayout") ~= nil
    end

    local function apply() -- line: 35
        -- upvalues: p4 (copy), t4 (copy), v5 (copy)
        local anchor = t4.anchor
        local Size = p4.Size

        if p4.AnchorPoint ~= v5 then
            t4.anchorWritten = true
            p4.AnchorPoint = v5
        end

        if p4.Parent ~= nil and p4.Parent:FindFirstChildWhichIsA("UIGridStyleLayout") ~= nil then
            return
        end

        local v6 = t4.pos + UDim2.new(Size.X.Scale * (0.5 - anchor.X), Size.X.Offset * (0.5 - anchor.X), Size.Y.Scale * (0.5 - anchor.Y), Size.Y.Offset * (0.5 - anchor.Y))

        t4.written = v6

        if p4.Position ~= v6 then
            p4.Position = v6
        end
    end

    p4:GetPropertyChangedSignal("Position"):Connect(function() -- line: 43
        -- upvalues: p4 (copy), t4 (copy), apply (copy)
        if p4.Position ~= t4.written then
            t4.pos = p4.Position
            apply()
        end
    end)
    p4:GetPropertyChangedSignal("AnchorPoint"):Connect(function() -- line: 47
        -- upvalues: p4 (copy), t4 (copy), apply (copy), v5 (copy)
        if p4.AnchorPoint == v5 then
            if t4.anchorWritten then
                t4.anchorWritten = false
            else
                t4.anchor = v5
                t4.pos = p4.Position
            end
        else
            t4.anchor = p4.AnchorPoint
            t4.pos = p4.Position
            apply()
        end
    end)
    p4:GetPropertyChangedSignal("Size"):Connect(function() -- line: 55
        -- upvalues: t4 (copy), apply (copy), v5 (copy)
        if t4.anchor ~= v5 then
            apply()
        end
    end)
    apply()
end

local function hook(p5) -- line: 58
    -- upvalues: SoundService (copy), TweenService (copy), Sound (copy), Sound2 (copy), n1 (ref), self (copy), t3 (copy), centreOrigin (copy)
    if not self[p5] and p5:IsA("GuiButton") and not p5:GetAttribute("NoSound") then
        local LayerCollector = p5:FindFirstAncestorWhichIsA("LayerCollector")

        if LayerCollector and LayerCollector.Name == "TouchGui" then
            return
        end

        self[p5] = true
        centreOrigin(p5)

        local UIScale = p5:FindFirstChildOfClass("UIScale")
        local v7 = UIScale
        local v8 = UIScale ~= nil and UIScale.Scale ~= 1
        local v9, v10, v11
        local t5 = {}

        local function grow(p6) -- line: 69
            -- upvalues: p5 (copy), v7 (ref), v9 (ref), v10 (ref), v11 (ref), t5 (copy), v8 (copy), TweenService (copy), t3 (copy)
            if v8 then
                if p6 then
                    t3[p5] = t3[p5] or {}
                else
                    local v12 = t3[p5]

                    if v12 then
                        v12.leaving = true
                    end
                end
            else
                v7 = p5:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", p5)
                v9 = v9 or v7.Scale

                if v10 then
                    v10:Cancel()
                end

                local v13 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local v14 = v7
                local v15 = if p6 then v9 * 1.06 else nil

                if not p6 or not v15 then
                    v15 = v9
                end

                v10 = TweenService:Create(v14, v13, {
                    Scale = v15
                })
                v10:Play()

                local LayerCollector = p5:FindFirstAncestorWhichIsA("LayerCollector")

                if p6 and LayerCollector and LayerCollector:IsA("ScreenGui") then
                    local AbsoluteSize = LayerCollector.AbsoluteSize
                    local AbsolutePosition, AbsoluteSize2 = p5.AbsolutePosition, p5.AbsoluteSize
                    local v16

                    if AbsoluteSize2.X > 0 and AbsoluteSize2.Y > 0 then
                        local v17 = math.max(AbsolutePosition.X, 0)
                        local v18 = math.max(AbsolutePosition.Y, 0)
                        local v20 = math.min(AbsolutePosition.X + AbsoluteSize2.X, AbsoluteSize.X)
                        local v22 = math.min(AbsolutePosition.Y + AbsoluteSize2.Y, AbsoluteSize.Y)
                        local v23 = AbsolutePosition + AbsoluteSize2 / 2
                        local v24 = (Vector2.new((v17 + v20) / 2, (v18 + v22) / 2) - v23) * -0.06000000000000005 / (AbsoluteSize2 * 1.06)

                        v16 = if math.abs(v24.X) > 5E-04 then v24 or nil else math.abs(v24.Y) > 5E-04 and v24 or nil
                        v11 = v16
                    end
                end

                if not (if p6 then not v11 else not next(t5)) then
                    for _, child in p5:GetChildren() do
                        if child:IsA("GuiObject") then
                            local v25 = UDim2.fromScale(v11.X, v11.Y)

                            if p6 then
                                if not t5[child] then
                                    t5[child] = true
                                    child.Position += v25
                                end
                            elseif t5[child] then
                                t5[child] = nil
                                child.Position -= v25
                            end
                        end
                    end
                end

                if not p6 then
                    v11 = nil
                end
            end
        end

        local function enter() -- line: 103
            -- upvalues: p5 (copy), grow (copy), SoundService (copy), Sound (copy), n1 (ref)
            grow(true)

            if p5.Active and not (os.clock() - n1 < 0.04) then
                n1 = os.clock()
                SoundService:PlayLocalSound(Sound)
            end
        end

        p5.MouseEnter:Connect(enter)
        p5.SelectionGained:Connect(enter)
        p5.MouseLeave:Connect(function() -- line: 109
            -- upvalues: grow (copy)
            grow(false)
        end)
        p5.SelectionLost:Connect(function() -- line: 109
            -- upvalues: grow (copy)
            grow(false)
        end)
        p5.Activated:Connect(function() -- line: 110
            -- upvalues: SoundService (copy), Sound2 (copy)
            SoundService:PlayLocalSound(Sound2)
        end)
    end
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

for _, descendant in PlayerGui:GetDescendants() do
    hook(descendant)
end

PlayerGui.DescendantAdded:Connect(hook)
