-- https://lua.expert

local HttpService = game:GetService("HttpService")
local t1 = {
    MinScale = 0.5,
    MaxScale = 2,
    Followers = {
        Pedal = { "ThrottleCaption", "FrontCaption" }
    },
    IsFollower = {
        ThrottleCaption = true,
        FrontCaption = true
    },
    Names = {
        Steer = "Lean Stick",
        Pedal = "Throttle / Brake",
        RearBrake = "Rear Brake",
        Leave = "Leave",
        Cam = "Camera",
        Clutch = "Clutch",
        GearUp = "Gear +",
        GearDown = "Gear -",
        RHD = "RHD",
        LookBack = "Look Back",
        AssistTCS = "TCS",
        AssistAW = "AW",
        AssistEBS = "EBS",
        ArrowLeft = "Lean Left",
        ArrowRight = "Lean Right",
        ArrowUp = "Wheelie",
        ArrowDown = "Stoppie",
        Gas2 = "Throttle",
        Front2 = "Front Brake",
        Rear2 = "Rear Brake (button)"
    },
    Decode = function(p1) -- Decode | line: 17
        -- upvalues: HttpService (copy)
        if typeof(p1) == "string" and p1 ~= "" then
            local JSONDecode = HttpService.JSONDecode
            local ok
            local result

            ok, result = pcall(JSONDecode, HttpService, p1)
            result = ok and typeof(result) == "table" and result or {}

            return result
        end

        return {}
    end,
    Encode = function(p2) -- Encode | line: 22
        -- upvalues: HttpService (copy)
        local JSONEncode = HttpService.JSONEncode
        local ok, result = pcall(JSONEncode, HttpService, p2)

        if not ok or not result then
            result = "{}"
        end

        return result
    end
}

local function scaleTexts(p3, p4) -- line: 23
    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            if not descendant.TextScaled then
                descendant.TextSize = math.max(1, (math.floor(descendant.TextSize * p4 + 0.5)))
            end
        elseif descendant:IsA("UITextSizeConstraint") then
            descendant.MaxTextSize = math.max(1, (math.floor(descendant.MaxTextSize * p4 + 0.5)))
        elseif descendant:IsA("UIStroke") then
            descendant.Thickness *= math.sqrt(p4)
        end
    end
end

function t1.Apply(p5, p6) -- line: 31
    -- upvalues: t1 (copy), scaleTexts (copy)
    local v5 = if typeof(p6) ~= "table" or not p6 then t1.Decode(p6) else p6

    if next(v5) ~= nil then
        for _, child in p5:GetChildren() do
            local v6 = v5[child.Name]

            if child:IsA("GuiObject") and not t1.IsFollower[child.Name] and typeof(v6) == "table" then
                local v8 = math.clamp(tonumber(v6.s) or 1, t1.MinScale, t1.MaxScale)
                local v9 = tonumber(v6.x)
                local v10 = tonumber(v6.y)
                local v11 = child.AbsolutePosition + child.AbsoluteSize * child.AnchorPoint
                local Size = child.Size

                child.Size = UDim2.new(Size.X.Scale, Size.X.Offset * v8, Size.Y.Scale, Size.Y.Offset * v8)

                if v8 ~= 1 then
                    scaleTexts(child, v8)
                end

                if v9 and v10 then
                    child.Position = UDim2.fromScale(math.clamp(v9, 0, 1), (math.clamp(v10, 0, 1)))
                end

                local v12 = t1.Followers[child.Name]

                if v12 then
                    local AbsolutePosition, AbsoluteSize = p5.AbsolutePosition, p5.AbsoluteSize
                    local v13 = v9 and v10 and Vector2.new(math.clamp(v9, 0, 1) * AbsoluteSize.X, math.clamp(v10, 0, 1) * AbsoluteSize.Y) + AbsolutePosition or v11

                    for _, v14 in v12 do
                        local v15 = p5:FindFirstChild(v14)

                        if v15 and v15:IsA("GuiObject") then
                            local v16 = v13 + (v15.AbsolutePosition + v15.AbsoluteSize * v15.AnchorPoint - v11) * v8 - AbsolutePosition

                            v15.Position = UDim2.fromOffset(v16.X, v16.Y)

                            if v8 ~= 1 then
                                v15.Size = UDim2.new(v15.Size.X.Scale, v15.Size.X.Offset * v8, v15.Size.Y.Scale, v15.Size.Y.Offset * v8)
                                scaleTexts(v15, v8)

                                if v15:IsA("TextLabel") and not v15.TextScaled then
                                    v15.TextSize = math.max(1, (math.floor(v15.TextSize * v8 + 0.5)))
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

return t1
