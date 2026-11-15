-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)

require(UI.Util.Theme)

local Children = Fusion.Children
local CheckItem = require(script.Parent.CheckItem)

return function(p1, p2) -- line: 23
    -- upvalues: Fusion (copy), Children (copy), CheckItem (copy)
    local v1 = p2.items or p1:Value({})
    local v2 = p2.selection or p1:Value({})
    local onToggle = p2.onToggle

    return p1:New("Frame")({
        Name = "Checklist",
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p1:New("UIListLayout")({
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4)
            }),
            p1:ForValues(v1, function(_, p4, p5) -- line: 41
                -- upvalues: onToggle (copy), v2 (copy), Fusion (copy), CheckItem (copy)
                local v4 = p4:Computed(function(p6) -- line: 42
                    -- upvalues: p5 (copy), v2 (copy)
                    return table.find(p6(v2), p5) ~= nil
                end)

                return CheckItem(p4, {
                    content = p4:Value(p5),
                    checked = v4,
                    onCheck = function(p7) -- onCheck | line: 49
                        -- upvalues: p5 (copy), onToggle (copy), v2 (copy), Fusion (copy)
                        local v5 = table.clone(Fusion.peek(v2))
                        local v6 = table.find(v5, p5)

                        if not p7 or v6 then
                            if not p7 and v6 then
                                table.remove(v5, v6)
                            end
                        else
                            table.insert(v5, p5)
                        end

                        v2:set(v5)

                        if onToggle then
                            local v7 = if typeof(onToggle) == "table" then Fusion.peek(onToggle) else onToggle

                            if v7 then
                                v7(p5, p7)
                            end
                        end
                    end
                })
            end)
        }
    })
end
