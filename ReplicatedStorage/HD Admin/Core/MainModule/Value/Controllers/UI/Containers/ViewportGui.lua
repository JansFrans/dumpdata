-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Children = Fusion.Children
local Viewport = require(UI.Config.Viewport)
local Panels = require(UI.Config.Panels)
local PanelGui = require(script.Parent.PanelGui)
local PopupLayer = require(script.Parent.PopupLayer)

return function(p1, p2) -- line: 25
    -- upvalues: Fusion (copy), Children (copy), Viewport (copy), Panels (copy), PanelGui (copy), PopupLayer (copy)
    local v1 = p1:Value(Vector2.zero)

    Panels.init(p1, v1)

    local v2 = Panels.getState()
    local v3 = p1:Computed(function(p3) -- line: 32
        -- upvalues: v2 (copy)
        local t1 = {}

        for _, v4 in p3(v2) do
            t1[v4.id] = v4
        end

        return t1
    end)
    local v5 = p1:New("Frame")({
        Name = "ViewportGui",
        Parent = p2.parent,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Active = false,
        Selectable = false,
        [Children] = {
            PopupLayer(p1, {
                channel = "top"
            }),
            PopupLayer(p1, {
                channel = "centre"
            }),
            PanelGui(p1, {
                position = Viewport.MenuDefaultPosition,
                visible = p2.menuVisible,
                onClose = p2.onClose,
                dragOffset = v1
            }),
            Fusion.ForPairs(p1, v3, function(_, p5, _, p7) -- line: 59
                -- upvalues: Viewport (copy), Panels (copy), PanelGui (copy)
                local v6 = p5:Computed(function(p8) -- line: 60
                    -- upvalues: p7 (copy), Viewport (copy), Panels (copy)
                    local v7 = p8(Viewport.MenuDefaultPosition)
                    local v8 = p8(Viewport.ViewportSize)
                    local v9 = p8(Viewport.Scale)
                    local spawnDragSnapshot = p7.spawnDragSnapshot
                    local v10 = v7.X.Scale * v8.X + v7.X.Offset + spawnDragSnapshot.X
                    local v11 = v7.Y.Scale * v8.Y + v7.Y.Offset + spawnDragSnapshot.Y
                    local cascadeMultiplier = p7.cascadeMultiplier
                    local v12 = v10 + Panels.POPUP_OFFSET.X * cascadeMultiplier * v9
                    local v13 = v11 + Panels.POPUP_OFFSET.Y * cascadeMultiplier * v9
                    local v14 = Panels.POPUP_PANEL_WIDTH * v9 / 2
                    local v15 = Panels.POPUP_MIN_VISIBLE_HEIGHT * v9
                    local v18 = math.clamp(v12, v14, (math.max(v14, v8.X - v14)))
                    local v21 = math.clamp(v13, 0, (math.max(0, v8.Y - v15)))

                    return UDim2.fromOffset(v18, v21)
                end)

                return p7.id, PanelGui(p5, {
                    mode = "fitContent",
                    profilePanel = p7,
                    position = v6,
                    visible = p5:Value(true),
                    dragOffset = p7.dragOffset,
                    onClose = function() -- onClose | line: 86
                        -- upvalues: p7 (copy), Panels (copy)
                        Panels.close(p7.id)
                    end
                })
            end)
        }
    })

    PopupLayer(p1, {
        channel = "sidebar",
        host = v5
    })

    return v5
end
