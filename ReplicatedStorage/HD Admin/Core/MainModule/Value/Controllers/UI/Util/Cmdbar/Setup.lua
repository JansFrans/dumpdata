-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local CmdbarState = require(UI.Config.CmdbarState)
local Permissions = require(UI.Util.Permissions)
local InputController = require(Modules.Parent.Controllers.InputController)

return function(p1, p2) -- line: 28
    -- upvalues: UI (copy), Fusion (copy), CmdbarState (copy), Permissions (copy), InputController (copy)
    local CommandBar = Permissions.canViewPage(p1, "CommandBar")
    local v1 = false

    local function onAccessChanged() -- line: 31
        -- upvalues: p1 (copy), p2 (copy), CommandBar (copy), v1 (ref), UI (copy), Fusion (copy), CmdbarState (copy), InputController (copy)
        local v2 = Fusion.peek(CommandBar)

        CmdbarState.canOpen:set(v2)

        if not v2 then
            CmdbarState.visible:set(false)

            return
        end

        if not v1 then
            v1 = true
            require(UI.Containers.Cmdbar)(p1, {
                visible = CmdbarState.visible
            }).Parent = p2
            p1:New("TextButton")({
                Name = "CmdbarBackdrop",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                Size = UDim2.fromScale(1, 1),
                Text = "",
                TextColor3 = Color3.new(),
                TextSize = 1,
                Visible = CmdbarState.visible,
                ZIndex = 0,
                [Fusion.OnEvent("Activated")] = function() -- line: 61
                    -- upvalues: CmdbarState (copy)
                    CmdbarState.setOpen(false)
                end
            }).Parent = p2
            InputController.onPressed(Enum.KeyCode.Quote, CmdbarState.toggle)
            InputController.onPressed(Enum.KeyCode.Semicolon, CmdbarState.toggle)
        end
    end

    p1:Observer(CommandBar):onChange(onAccessChanged)
    onAccessChanged()
end
