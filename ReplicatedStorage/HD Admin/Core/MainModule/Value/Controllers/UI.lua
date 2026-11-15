-- https://lua.expert

local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local fuseState = require(Modules.DataUtil.fuseState)
local ScreenGui = require(script.Containers.ScreenGui)
local Navigate = require(script.Util.Navigate)
local AboutPreload = require(script.Util.AboutPreload)
local Permissions = require(script.Util.Permissions)
local LayerOrder = require(script.Config.LayerOrder)
local Icons = require(script.Config.Icons)
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = Fusion.scoped({
    Value = Fusion.Value,
    Computed = Fusion.Computed,
    Fuse = fuseState,
    New = Fusion.New,
    ForValues = Fusion.ForValues,
    Spring = Fusion.Spring,
    Observer = Fusion.Observer
})

task.defer(function() -- line: 31
    -- upvalues: Modules (copy), Fusion (copy), ScreenGui (copy), Navigate (copy), AboutPreload (copy), Permissions (copy), LayerOrder (copy), Icons (copy), LocalPlayer (copy), v1 (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local v2 = v1:Value(false)

    LayerOrder.init(v1)

    local v3 = ScreenGui(v1, {
        parent = PlayerGui,
        menuVisible = v2,
        onClose = function() -- onClose | line: 43
            -- upvalues: v2 (copy)
            v2:set(false)
        end
    })

    require(script.Util.Cmdbar.Setup)(v1, v3)

    local appIcon = require(Modules.References.appIcon)

    appIcon:bindEvent("toggled", function(_, p2, p3) -- line: 52
        -- upvalues: v2 (copy)
        if p3 ~= "MenuForceClosed" then
            v2:set(p2)
        end
    end)
    v1:Observer(v2):onChange(function() -- line: 60
        -- upvalues: v2 (copy), appIcon (copy), Fusion (copy), AboutPreload (copy)
        if Fusion.peek(v2) then
            AboutPreload.warm()
        elseif appIcon.isSelected then
            appIcon:deselect("MenuForceClosed")
        end
    end)

    local v4 = Permissions.iconMode(v1)

    local function applyIconMode() -- line: 71
        -- upvalues: v2 (copy), appIcon (copy), v4 (copy), Fusion (copy), Icons (copy)
        local v5 = Fusion.peek(v4)

        if v5 == "None" then
            v2:set(false)
            appIcon:setEnabled(false)
        else
            local v6 = if v5 == "Commands" then Icons.Topbar.Commands else Icons.Topbar.Menu

            appIcon:setImage(v6.deselected, "deselected")
            appIcon:setImage(v6.selected, "selected")
            appIcon:setImageScale(v6.deselectedScale, "deselected")
            appIcon:setImageScale(v6.selectedScale, "selected")
            appIcon:setEnabled(true)
        end
    end

    applyIconMode()
    v1:Observer(v4):onChange(applyIconMode)
    Navigate.bindPanelVisibility({
        setVisible = function(p4) -- setVisible | line: 91
            -- upvalues: v2 (copy), appIcon (copy)
            v2:set(p4)

            if not p4 or appIcon.isSelected then
                if not p4 and appIcon.isSelected then
                    appIcon:deselect("MenuForceClosed")
                end
            else
                appIcon:select()
            end
        end,
        isVisible = function() -- isVisible | line: 99
            -- upvalues: v2 (copy), Fusion (copy)
            return Fusion.peek(v2)
        end
    })
end)

return t1
