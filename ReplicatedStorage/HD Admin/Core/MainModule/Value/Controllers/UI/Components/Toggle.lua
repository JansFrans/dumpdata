-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local InputRow = require(script.Parent.InputRow)
local Pressable = require(UI.Components.Pressable)

return function(p1, p2) -- line: 30
    -- upvalues: Fusion (copy), Theme (copy), Children (copy), InputRow (copy), Pressable (copy)
    local v1 = p2.title or ""
    local v2 = p1:Value(if p2.value then Fusion.peek(p2.value) == true else p2.default == true)
    local v3 = false

    table.insert(p1, function() -- line: 40
        -- upvalues: v3 (ref)
        v3 = true
    end)
    p1:Observer(v2):onChange(function() -- line: 42
        -- upvalues: p2 (copy), v2 (copy), v3 (ref), Fusion (copy)
        local v5, v6

        if not v3 and p2.value then
            v5 = Fusion.peek(v2)
            v6 = Fusion.peek(p2.value) == true

            if v6 ~= v5 then
                p2.value:set(v5)
            end
        end
    end)

    if p2.value ~= nil then
        p1:Observer(p2.value):onChange(function() -- line: 53
            -- upvalues: p2 (copy), v2 (copy), v3 (ref), Fusion (copy)
            if not v3 then
                local v7 = Fusion.peek(p2.value) == true

                if v7 ~= Fusion.peek(v2) then
                    v2:set(v7)
                end
            end
        end)
    end

    local v8 = p1:Spring(p1:Computed(function(p3) -- line: 62
        -- upvalues: v2 (copy)
        if p3(v2) then
            return (UDim2.new(1, -20, 0.5, 0))
        end

        return (UDim2.new(0, 4, 0.5, 0))
    end), 60, 1)
    local v9 = p1:Spring(p1:Computed(function(p4) -- line: 69
        -- upvalues: v2 (copy), Theme (copy)
        if p4(v2) then
            return (p4(Theme.Color.Primary))
        end

        return (p4(Theme.Color.NeutralContent))
    end), 60, 1)

    return InputRow(p1, {
        title = v1,
        name = "Toggle",
        labelSize = p2.labelSize or UDim2.new(1, -60, 0, 0),
        labelTextSize = p2.labelTextSize,
        frameTransparency = 1,
        hideStroke = true,
        framePaddingRight = 0,
        [Children] = {
            p1:New("Frame")({
                Name = "TrackWrap",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                [Children] = {
                    Pressable(p1, {
                        name = "Track",
                        anchorPoint = Vector2.new(1, 0.5),
                        position = UDim2.new(1, 0, 0.5, 0),
                        size = UDim2.fromOffset(48, 26),
                        backgroundColor = v9,
                        onActivate = function() -- onActivate | line: 96
                            -- upvalues: v2 (copy), Fusion (copy)
                            v2:set(not Fusion.peek(v2))
                        end,
                        [Children] = {
                            p1:New("UICorner")({
                                CornerRadius = UDim.new(1, 0)
                            }),
                            p1:New("Frame")({
                                Name = "Thumb",
                                AnchorPoint = Vector2.new(0, 0.5),
                                BackgroundColor3 = p1:Computed(function(p5) -- line: 104
                                    -- upvalues: v2 (copy), Theme (copy)
                                    if p5(v2) then
                                        return (p5(Theme.Color.PrimaryContent))
                                    end

                                    return (p5(Theme.Color.BaseContent))
                                end),
                                Position = v8,
                                Size = UDim2.fromOffset(16, 16),
                                ZIndex = 2,
                                [Children] = {
                                    p1:New("UICorner")({
                                        CornerRadius = UDim.new(1, 0)
                                    })
                                }
                            })
                        }
                    })
                }
            })
        }
    })
end
