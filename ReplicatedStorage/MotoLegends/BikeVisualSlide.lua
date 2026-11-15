-- https://lua.expert

local Config = require(script.Parent.Config)
local BikeDynamics = require(script.Parent.BikeDynamics)
local BikeVisualLife = require(script.Parent.BikeVisualLife)
local self = setmetatable({}, {
    __mode = "k"
})
local self2 = setmetatable({}, {
    __mode = "k"
})
local self3 = setmetatable({}, {
    __mode = "k"
})
local t1 = {}

t1.SlideCurve = BikeDynamics.SlideCurve

local function curve(p1) -- line: 15
    -- upvalues: BikeDynamics (copy)
    local CurveSlide = BikeDynamics.CurveSlide

    if typeof(CurveSlide) == "function" then
        return CurveSlide(p1)
    end

    return p1 or 0
end

function t1.Apply(p2, p3, p4, p5) -- line: 19
    -- upvalues: Config (copy), BikeDynamics (copy), BikeVisualLife (copy), self (copy), self2 (copy), self3 (copy)
    local PrimaryPart = p2.PrimaryPart
    local VisualSlide = PrimaryPart and PrimaryPart:FindFirstChild("VisualSlide")

    if not VisualSlide then
        return
    end

    local v4 = (PrimaryPart:GetAttribute("LossStage") or "") ~= ""
    local v5 = p2:GetAttribute("Crash") ~= ""
    local v6 = if v4 then 1.0471975511965976 else Config.RearYaw * 2.8
    local v7 = if typeof(p5) == "number" then p5 else p2:GetAttribute("VisualBrakeShare")
    local v9 = math.clamp(if typeof(v7) == "number" and v7 == v7 and v7 then v7 else 0, 0, 1)

    p3 = p3 or 0

    local v11

    if v4 or v5 then
        v11 = 0
    else
        local v12 = p3 * (1 - v9)
        local CurveSlide = BikeDynamics.CurveSlide

        v11 = math.clamp((if typeof(CurveSlide) == "function" then CurveSlide(v12) else v12 or 0) + p3 * v9, -v6, v6)
    end

    local v15 = v11

    if not v4 or v5 then
    elseif PrimaryPart:GetAttribute("LossStage") == "HIGHSIDE" and not PrimaryPart:GetAttribute("HighsideCaught") or PrimaryPart:GetAttribute("SpinOutLowside") == true then
        local LossInitialRearYaw = PrimaryPart:GetAttribute("LossInitialRearYaw") or PrimaryPart:GetAttribute("LossRearYaw") or 0
        local v17 = PrimaryPart:GetAttribute("PhysicalRearYaw") or 0
        local CurveSlide = BikeDynamics.CurveSlide
        local v18 = (if typeof(CurveSlide) == "function" then CurveSlide(LossInitialRearYaw) else LossInitialRearYaw or 0) - v17
        local v19 = v18 * LossInitialRearYaw > 0
        local v20 = if v19 then math.clamp(v18, -v6, v6) else nil

        v15 = if not v19 or not v20 then 0 else v20
    end

    local v22 = self[p2]

    if v22 == nil then
        v22 = p2:GetAttribute("RenderedRearYaw") or v15
    end

    local elapsed = os.clock()
    local v24 = math.clamp(p4 or elapsed - (self3[p2] or elapsed - 0.016666666666666666), 0.004166666666666667, 0.05)

    self3[p2] = elapsed

    local v25 = if v4 or v5 then 9 else 16
    local v26 = v25 * v25
    local v27 = self2[p2] or 0
    local v28 = v27 + ((v15 - v22) * v26 - 2 * v25 * v27) * v24
    local v29 = v22 + v28 * v24

    if math.abs(v29) < 1E-04 and math.abs(v28) < 0.001 then
        v28 = 0
        v29 = 0
    end

    self2[p2] = v28
    self[p2] = v29

    local v30 = BikeDynamics.SlideFrame(PrimaryPart.CFrame.Rotation, v29)
    local body = BikeVisualLife.Update(p2, v24).body
    local v31 = v30 * body

    BikeVisualLife.ApplyRider(p2, body)
    VisualSlide.Transform = v31

    for _, v32 in { "LeftHand", "RightHand", "LeftFoot", "RightFoot" } do
        local v33 = PrimaryPart:FindFirstChild(v32 .. "Target")

        if v33 then
            local VisualBase = v33:GetAttribute("VisualBase")

            if not VisualBase then
                VisualBase = v33.CFrame
                v33:SetAttribute("VisualBase", VisualBase)
            end

            v33.CFrame = v31 * VisualBase
        end
    end

    if math.abs((p2:GetAttribute("RenderedRearYaw") or 0) - v29) > 0.001 then
        p2:SetAttribute("RenderedRearYaw", v29)
    end
end

return require(script.Parent:WaitForChild("OwnerFeatures14")).Wrap(t1, script.Parent, "Pre14_BikeVisualSlide")
