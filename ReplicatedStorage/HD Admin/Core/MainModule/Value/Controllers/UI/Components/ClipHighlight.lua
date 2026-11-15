-- https://lua.expert

local Packages = script:FindFirstAncestor("MainModule").Value.Modules.Parent.Packages
local Children = require(Packages.Fusion).Children

return function(p1, p2) -- line: 22
    -- upvalues: Children (copy)
    local v1 = p2.cornerRadius or 9
    local side = p2.side
    local v2 = side == "top" or side == "bottom"
    local v3 = side == "left" or side == "top"
    local noExtend = p2.noExtend
    local v4 = p1:Computed(function(p3) -- line: 32
        -- upvalues: v1 (copy), noExtend (copy)
        if noExtend ~= nil and p3(noExtend) then
            return 0
        end

        return v1
    end)
    local v5 = if v3 then UDim2.fromScale(0, 0) else p1:Computed(function(p4) -- line: 39
        -- upvalues: v4 (copy), v2 (copy)
        local v6 = p4(v4)

        if v2 then
            return (UDim2.new(0, 0, 0, -v6))
        end

        return (UDim2.new(0, -v6, 0, 0))
    end)
    local v7 = p1:Computed(function(p5) -- line: 44
        -- upvalues: v4 (copy), v2 (copy)
        local v8 = p5(v4)

        if v2 then
            return (UDim2.new(1, 0, 1, v8))
        end

        return (UDim2.new(1, v8, 1, 0))
    end)

    return p1:New("Frame")({
        Name = "ClipWrapper",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 1, 0),
        [Children] = {
            p1:New("Frame")({
                Name = "Highlight",
                BackgroundColor3 = p2.color,
                Position = v5,
                Size = v7,
                [Children] = {
                    if p2.hideCorner then nil else p1:New("UICorner")({
                        CornerRadius = UDim.new(0, v1)
                    })
                }
            })
        }
    })
end
