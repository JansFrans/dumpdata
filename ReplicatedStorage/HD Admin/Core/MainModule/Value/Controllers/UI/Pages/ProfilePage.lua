-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local ProfileBody = require(UI.Components.ProfileBody)
local Children = Fusion.Children

return function(p1, p2) -- line: 22
    -- upvalues: ProfileBody (copy), Children (copy)
    local v1 = p1:New("Frame")({
        Name = "PopupOverlay",
        BackgroundTransparency = 1,
        ZIndex = 100,
        Size = UDim2.fromScale(1, 1)
    })

    return p1:New("Frame")({
        Name = "ProfilePage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            ProfileBody(p1, {
                userId = p2.userId,
                giverIdentity = p2.giverIdentity,
                popupParent = v1
            }),
            v1
        }
    })
end
