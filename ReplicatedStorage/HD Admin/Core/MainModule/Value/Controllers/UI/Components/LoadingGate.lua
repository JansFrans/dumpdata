-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Children = require(Packages.Fusion).Children
local LoadingSpinner = require(UI.Components.LoadingSpinner)

return function(p1, p2) -- line: 23
    -- upvalues: Children (copy), LoadingSpinner (copy)
    local v1 = p2.minLoadTime or 0.4
    local v2 = p1:Value(false)

    task.delay(v1, function() -- line: 27
        -- upvalues: v2 (copy)
        v2:set(true)
    end)

    local v3 = p1:Computed(function(p3) -- line: 31
        -- upvalues: p2 (copy), v2 (copy)
        if p3(v2) then
            return not p3(p2.isReady)
        end

        return true
    end)
    local v4 = p1:Computed(function(p4) -- line: 35
        -- upvalues: v3 (copy)
        return not p4(v3)
    end)

    return p1:New("Frame")({
        Name = "LoadingGate",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = p2.layoutOrder or 0,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p1:New("UIListLayout")({
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p1:Computed(function(p5, p6) -- line: 50
                -- upvalues: v3 (copy), LoadingSpinner (copy)
                if p5(v3) then
                    return LoadingSpinner(p6, {
                        layoutOrder = 0
                    })
                end

                return nil
            end),
            p1:New("Frame")({
                Name = "Content",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Size = UDim2.fromScale(1, 0),
                Visible = v4,
                [Children] = p2[Children]
            })
        }
    })
end
