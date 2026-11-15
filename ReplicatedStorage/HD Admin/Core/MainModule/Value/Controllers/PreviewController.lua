-- https://lua.expert

local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Prompt = require(Modules.Prompt)
local Remote = require(Modules.Objects.Remote)
local Fusion = require(Modules.Parent.Packages.Fusion)
local fuseState = require(Modules.DataUtil.fuseState)
local Icons = require(Modules.Parent.Controllers.UI.Config.Icons)
local v1 = Fusion.scoped({
    Value = Fusion.Value,
    Computed = Fusion.Computed,
    Observer = Fusion.Observer
})
local PreviewingRoles = fuseState(v1, "temp", "PreviewingRoles")
local RoleInfo = fuseState(v1, "everyone", "RoleInfo")
local v2 = v1:Value({})
local v3
local v4 = ""
local v5 = false

local function roleNamesLabel(p1) -- line: 35
    -- upvalues: Fusion (copy), RoleInfo (copy)
    local v6 = Fusion.peek(RoleInfo)
    local t2 = {}

    for _, v7 in p1 do
        local v8 = if typeof(v6) == "table" then v6[v7] else nil
        local v9 = v7

        if typeof(v8) == "table" and typeof(v8.name) == "string" then
            v9 = v8.name
        end

        table.insert(t2, (("\"%*\""):format(v9)))
    end

    return table.concat(t2, ", ")
end

local function onCardAction(p2, p3) -- line: 48
    -- upvalues: Remote (copy), v2 (copy), v5 (ref)
    if p2 ~= "button" or p3 ~= "endPreview" or v5 then
        return
    end

    v5 = true
    v2:set({
        endPreview = true
    })
    task.spawn(function() -- line: 54
        -- upvalues: Remote (copy), v2 (copy), v5 (ref)
        local ClearPreviewingRoles = Remote.get("ClearPreviewingRoles")

        if ClearPreviewingRoles then
            ClearPreviewingRoles:invokeServerAsync()
        end

        v5 = false
        v2:set({})
    end)
end

local function refreshCard() -- line: 64
    -- upvalues: Prompt (copy), Fusion (copy), Icons (copy), PreviewingRoles (copy), v2 (copy), v3 (ref), v4 (ref), roleNamesLabel (copy), onCardAction (copy)
    local v11 = Fusion.peek(PreviewingRoles)

    if typeof(v11) ~= "table" then
        v11 = {}
    end

    if #v11 == 0 then
        v4 = ""

        if v3 then
            v3.Disconnect()
            v3 = nil
        end
    else
        local v12 = table.concat(v11, ",")

        if v12 ~= v4 or not v3 then
            v4 = v12

            if v3 then
                v3.Disconnect()
            end

            v3 = Prompt.action(("You're previewing %*"):format((roleNamesLabel(v11))), {
                title = "Role Preview",
                duration = 0,
                dismissable = false,
                icon = Icons.Pages.Roles,
                buttons = {
                    {
                        id = "endPreview",
                        label = "Exit Preview"
                    }
                },
                buttonLoadingState = v2,
                onAction = onCardAction
            })
        end
    end
end

v1:Observer(PreviewingRoles):onChange(refreshCard)
refreshCard()

return t1
