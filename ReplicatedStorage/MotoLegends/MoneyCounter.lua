-- https://lua.expert

local TweenService = game:GetService("TweenService")
local t1 = {}

local function duration(p1) -- line: 6
    return (math.clamp(math.log10(p1 + 1) * 0.25 + 0.4, 0.4, 1.6))
end

function t1.Bind(p2, p3, p4) -- line: 7
    -- upvalues: TweenService (copy)
    local NumberValue = Instance.new("NumberValue")
    local v3
    local v4 = false
    local n1 = 0

    local function render() -- line: 10
        -- upvalues: p2 (copy), p3 (copy), NumberValue (copy)
        local v5 = p3((math.round(NumberValue.Value)))

        if p2.Text ~= v5 then
            p2.Text = v5
        end
    end

    NumberValue.Changed:Connect(render)
    p2.Destroying:Connect(function() -- line: 12
        -- upvalues: NumberValue (copy), v3 (ref)
        if v3 then
            v3:Cancel()
        end

        NumberValue:Destroy()
    end)

    local function roll() -- line: 13
        -- upvalues: p2 (copy), p3 (copy), NumberValue (copy), v3 (ref), n1 (ref), TweenService (copy)
        if v3 then
            v3:Cancel()
            v3 = nil
        end

        local v7 = n1
        local v8 = math.abs(v7 - NumberValue.Value)

        if v8 < 1 then
            NumberValue.Value = n1

            local v9 = p3((math.round(NumberValue.Value)))

            if p2.Text ~= v9 then
                p2.Text = v9
            end
        else
            v3 = TweenService:Create(NumberValue, TweenInfo.new(math.clamp(math.log10(v8 + 1) * 0.25 + 0.4, 0.4, 1.6), Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Value = n1
            })
            v3:Play()
        end
    end

    if p4 then
        p4:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 21
            -- upvalues: p2 (copy), p3 (copy), p4 (copy), NumberValue (copy), roll (copy)
            if p4.Visible then
                NumberValue.Value = 0

                local v12 = p3((math.round(NumberValue.Value)))

                if p2.Text ~= v12 then
                    p2.Text = v12
                end

                roll()
            end
        end)
    end

    return function(p5) -- line: 25
        -- upvalues: p2 (copy), p3 (copy), NumberValue (copy), v4 (ref), n1 (ref), roll (copy)
        n1 = tonumber(p5) or 0

        if v4 then
            roll()
        else
            v4 = true
            NumberValue.Value = n1

            local v13 = p3((math.round(NumberValue.Value)))

            if p2.Text ~= v13 then
                p2.Text = v13
            end
        end
    end
end

return t1
