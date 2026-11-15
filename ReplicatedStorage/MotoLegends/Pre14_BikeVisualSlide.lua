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

return {
    Apply = function(p1, p2, p3) -- Apply | line: 12
        -- upvalues: Config (copy), BikeDynamics (copy), BikeVisualLife (copy), self (copy), self2 (copy), self3 (copy)
        local PrimaryPart = p1.PrimaryPart
        local VisualSlide = PrimaryPart and PrimaryPart:FindFirstChild("VisualSlide")

        if not VisualSlide then
            return
        end

        local v4 = (PrimaryPart:GetAttribute("LossStage") or "") ~= ""
        local v5 = p1:GetAttribute("Crash") ~= ""
        local v6 = if v4 then 1.0471975511965976 else Config.RearYaw * 1.4
        local v7 = if v4 or v5 then 0 else math.clamp(p2 or 0, -v6, v6)
        local v10 = v7

        if not v4 or v5 then
        elseif PrimaryPart:GetAttribute("LossStage") == "HIGHSIDE" and not PrimaryPart:GetAttribute("HighsideCaught") or PrimaryPart:GetAttribute("SpinOutLowside") == true then
            local LossInitialRearYaw = PrimaryPart:GetAttribute("LossInitialRearYaw") or PrimaryPart:GetAttribute("LossRearYaw") or 0
            local v12 = LossInitialRearYaw - (PrimaryPart:GetAttribute("PhysicalRearYaw") or 0)
            local v13 = v12 * LossInitialRearYaw > 0
            local v14 = if v13 then math.clamp(v12, -v6, v6) else nil

            v10 = if not v13 or not v14 then 0 else v14
        end

        local v16 = self[p1]

        if v16 == nil then
            v16 = p1:GetAttribute("RenderedRearYaw") or v10
        end

        local elapsed = os.clock()
        local v18 = math.clamp(p3 or elapsed - (self3[p1] or elapsed - 0.016666666666666666), 0.004166666666666667, 0.05)

        self3[p1] = elapsed

        local v19 = if v4 or v5 then 9 else 16
        local v20 = v19 * v19
        local v21 = self2[p1] or 0
        local v22 = v21 + ((v10 - v16) * v20 - 2 * v19 * v21) * v18
        local v23 = v16 + v22 * v18

        if math.abs(v23) < 1E-04 and math.abs(v22) < 0.001 then
            v22 = 0
            v23 = 0
        end

        self2[p1] = v22
        self[p1] = v23

        local v24 = BikeDynamics.SlideFrame(PrimaryPart.CFrame.Rotation, v23)
        local body = BikeVisualLife.Update(p1, v18).body
        local v25 = v24 * body

        BikeVisualLife.ApplyRider(p1, body)
        VisualSlide.Transform = v25

        for _, v26 in { "LeftHand", "RightHand", "LeftFoot", "RightFoot" } do
            local v27 = PrimaryPart:FindFirstChild(v26 .. "Target")

            if v27 then
                local VisualBase = v27:GetAttribute("VisualBase")

                if not VisualBase then
                    VisualBase = v27.CFrame
                    v27:SetAttribute("VisualBase", VisualBase)
                end

                v27.CFrame = v25 * VisualBase
            end
        end

        if math.abs((p1:GetAttribute("RenderedRearYaw") or 0) - v23) > 0.001 then
            p1:SetAttribute("RenderedRearYaw", v23)
        end
    end
}
