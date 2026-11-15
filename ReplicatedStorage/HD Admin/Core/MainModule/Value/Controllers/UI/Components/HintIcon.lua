-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local HintBubble = require(UI.Util.HintBubble)
local Pressable = require(UI.Components.Pressable)
local n1 = 0

return function(p1, p2) -- line: 33
    -- upvalues: UserInputService (copy), Fusion (copy), Theme (copy), HintBubble (copy), Pressable (copy), n1 (ref)
    local v1

    v1 = Pressable(p1, {
        name = "HintIcon",
        backgroundColor = nil,
        size = p2.size or UDim2.fromOffset(20, 20),
        position = p2.position,
        anchorPoint = p2.anchorPoint,
        layoutOrder = p2.layoutOrder,
        visible = p2.visible,
        iconImage = p2.icon,
        iconColor = p2.iconColor or Theme.Color.NeutralContentDark,
        iconSize = p2.iconSize or 16,
        onHoverChanged = function(p3) -- onHoverChanged | line: 46
            -- upvalues: p2 (copy), v1 (ref), Fusion (copy), HintBubble (copy)
            if p3 then
                local show = HintBubble.show
                local v2 = v1

                show(v2, tostring(Fusion.peek(p2.hintText)), "hover")
            elseif HintBubble.via() == "hover" then
                HintBubble.hide(v1)
            end
        end,
        onActivate = function() -- onActivate | line: 53
            -- upvalues: p2 (copy), v1 (ref), UserInputService (copy), Fusion (copy), HintBubble (copy), n1 (ref)
            if UserInputService.MouseEnabled and UserInputService:GetLastInputType() ~= Enum.UserInputType.Touch then
                return
            end

            if HintBubble.owner() == v1 and HintBubble.via() == "tap" then
                HintBubble.hide(v1)

                return
            end

            local show = HintBubble.show
            local v3 = v1

            show(v3, tostring(Fusion.peek(p2.hintText)), "tap")
            n1 += 1

            local v4 = n1

            task.delay(4, function() -- line: 66
                -- upvalues: v4 (copy), v1 (ref), HintBubble (copy), n1 (ref)
                if n1 == v4 and HintBubble.owner() == v1 then
                    HintBubble.hide(v1)
                end
            end)
        end
    })
    table.insert(p1, function() -- line: 75
        -- upvalues: v1 (ref), HintBubble (copy)
        HintBubble.hide(v1)
    end)

    return v1
end
