-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local Children = Fusion.Children
local RunService = game:GetService("RunService")
local UI = Modules.Parent.Controllers.UI
local Theme = require(UI.Util.Theme)

return function(p1, p2) -- line: 26
    -- upvalues: Fusion (copy), Children (copy), RunService (copy), Theme (copy)
    local v1 = p1:Value(0)
    local v2

    local function startHeartbeat() -- line: 31
        -- upvalues: v1 (copy), v2 (ref), Fusion (copy), RunService (copy)
        v2 = v2 or RunService.Heartbeat:Connect(function(p3) -- line: 33
            -- upvalues: v1 (copy), Fusion (copy)
            v1:set(Fusion.peek(v1) + p3 * 540)
        end)
    end

    local function stopHeartbeat() -- line: 37
        -- upvalues: v2 (ref)
        if v2 then
            v2:Disconnect()
            v2 = nil
        end
    end

    local visible = p2.visible

    if (visible == nil or Fusion.peek(visible) ~= false) and not v2 then
        v2 = RunService.Heartbeat:Connect(function(p4) -- line: 33
            -- upvalues: v1 (copy), Fusion (copy)
            v1:set(Fusion.peek(v1) + p4 * 540)
        end)
    end

    if visible ~= nil then
        p1:Observer(visible):onChange(function() -- line: 50
            -- upvalues: v1 (copy), v2 (ref), visible (copy), Fusion (copy), RunService (copy)
            if Fusion.peek(visible) then
                v2 = v2 or RunService.Heartbeat:Connect(function(p5) -- line: 33
                    -- upvalues: v1 (copy), Fusion (copy)
                    v1:set(Fusion.peek(v1) + p5 * 540)
                end)
            elseif v2 then
                v2:Disconnect()
                v2 = nil
            end
        end)
    end

    table.insert(p1, function() -- line: 59
        -- upvalues: v2 (ref)
        if v2 then
            v2:Disconnect()
            v2 = nil
        end
    end)

    local v4 = p2.size or 28
    local v5 = p2.color or Theme.Color.NeutralContentDark
    local v6 = p2.thickness or 3
    local v7 = p2.paddingY or 24
    local v9 = p1:New("Frame")({
        Name = "Spinner",
        BackgroundTransparency = 1,
        Size = p1:Computed(function(p6) -- line: 71
            -- upvalues: v4 (copy)
            local v8 = if type(v4) == "number" then v4 else p6(v4)

            return UDim2.fromOffset(v8, v8)
        end),
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0.5, 0)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = v5,
                Thickness = v6,
                [Children] = {
                    p1:New("UIGradient")({
                        Rotation = v1,
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(0.853386, 0.0710383),
                            NumberSequenceKeypoint.new(1, 0.551913)
                        })
                    })
                }
            })
        }
    })

    return p1:New("Frame")({
        Name = "LoadingSpinner",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = p2.layoutOrder or 0,
        Size = UDim2.fromScale(1, 0),
        Visible = p2.visible or true,
        [Children] = {
            p1:New("UIPadding")({
                PaddingBottom = UDim.new(0, v7),
                PaddingTop = UDim.new(0, v7)
            }),
            p1:New("UIListLayout")({
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            v9
        }
    })
end
