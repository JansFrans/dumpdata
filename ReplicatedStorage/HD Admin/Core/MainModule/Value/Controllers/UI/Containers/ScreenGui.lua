-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Children = require(Packages.Fusion).Children
local ViewportGui = require(script.Parent.ViewportGui)
local EmotePreview = require(UI.Config.EmotePreview)
local EmotePreviewModal = require(script.Parent.EmotePreviewModal)

return function(p1, p2) -- line: 24
    -- upvalues: Children (copy), ViewportGui (copy), EmotePreview (copy), EmotePreviewModal (copy)
    EmotePreview.init(p1)

    return p1:New("ScreenGui")({
        Name = "HDAdmin",
        Parent = p2.parent,
        DisplayOrder = 20,
        ScreenInsets = Enum.ScreenInsets.None,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Enabled = true,
        [Children] = {
            ViewportGui(p1, {
                menuVisible = p2.menuVisible,
                onClose = p2.onClose
            }),
            EmotePreviewModal(p1, {})
        }
    })
end
