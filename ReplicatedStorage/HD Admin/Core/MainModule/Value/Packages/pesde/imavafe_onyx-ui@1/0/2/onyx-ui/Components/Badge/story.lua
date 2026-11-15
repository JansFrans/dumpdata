-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local Children = Fusion.Children
local t1 = {
    Frame = require(ParentParent.Components.Frame),
    Badge = require(ParentParent.Components.Badge),
    Text = require(ParentParent.Components.Text)
}

return {
    story = function(p1) -- story | line: 19
        -- upvalues: Fusion (copy), Themer (copy), Util (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()
        local v3 = v1:Value(0)
        local v4 = task.spawn(function() -- line: 25
            -- upvalues: v3 (copy), Fusion (copy)
            while task.wait(0.08) do
                if Fusion.peek(v3) == 100 then
                    task.wait(3)
                    v3:set(1)
                else
                    v3:set(Fusion.peek(v3) + 1)
                end
            end
        end)

        v1:innerScope({
            function() -- line: 37
                -- upvalues: v4 (copy)
                task.cancel(v4)
            end
        })
        v1:Frame({
            Parent = p1.target,
            List = {
                Padding = v1:UDim(0, v2.Spacing["0.5"])
            },
            [Children] = {
                v1:Badge({
                    Content = { "Badge" }
                }),
                v1:Badge({
                    Content = { "rbxassetid://103798699021677", "-50%" },
                    Color = Util.Colors.Red["500"]
                }),
                v1:Badge({
                    Content = { "rbxassetid://140490867216758", "LIMITED" },
                    Color = Util.Colors.Red["500"]
                }),
                v1:Badge({
                    Content = v1:Computed(function(p2) -- line: 61
                        -- upvalues: v3 (copy)
                        if p2(v3) >= 100 then
                            return { "99+" }
                        end

                        return { p2(v3) }
                    end),
                    Color = v2.Colors.Primary.Main
                }),
                v1:Frame({
                    List = {
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal,
                        Padding = v1:UDim(0, v2.Spacing["0.25"])
                    },
                    [Children] = {
                        v1:Text({
                            Text = "It's also proportional alongside text."
                        }),
                        v1:Badge({
                            Content = { "rbxassetid://137979359742656", "TRUE" },
                            Color = Util.Colors.Green["500"]
                        })
                    }
                })
            }
        })
    end,
    fusion = Fusion
}
