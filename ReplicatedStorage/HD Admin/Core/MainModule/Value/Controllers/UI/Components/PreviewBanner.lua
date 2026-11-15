-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI

require(Packages.Fusion)

local Banner = require(UI.Components.Banner)
local Remote = require(Modules.Objects.Remote)

return function(p1, p2) -- line: 24
    -- upvalues: Banner (copy), Remote (copy)
    local layoutOrder, size

    if p2 then
        size = p2.size
        layoutOrder = p2.layoutOrder
    end

    local PreviewingRoles = p1:Fuse("temp", "PreviewingRoles")
    local RoleInfo = p1:Fuse("everyone", "RoleInfo")
    local v1 = p1:Computed(function(p3) -- line: 30
        -- upvalues: PreviewingRoles (copy)
        local v2 = p3(PreviewingRoles)

        if typeof(v2) == "table" then
            return #v2 > 0
        end

        return false
    end)
    local v3 = p1:Computed(function(p4) -- line: 35
        -- upvalues: PreviewingRoles (copy), RoleInfo (copy)
        local v4 = p4(PreviewingRoles)

        if typeof(v4) ~= "table" or #v4 == 0 then
            return ""
        end

        local v5 = p4(RoleInfo)
        local t1 = {}

        for _, v6 in v4 do
            local v7 = if typeof(v5) == "table" then v5[v6] else nil
            local v8 = v6

            if typeof(v7) == "table" and typeof(v7.name) == "string" then
                v8 = v7.name
            end

            table.insert(t1, (("\"%*\""):format(v8)))
        end

        return (("Previewing %*"):format((table.concat(t1, ", "))))
    end)

    local function exitPreview() -- line: 50
        -- upvalues: Remote (copy)
        task.spawn(function() -- line: 51
            -- upvalues: Remote (copy)
            local ClearPreviewingRoles = Remote.get("ClearPreviewingRoles")

            if ClearPreviewingRoles then
                ClearPreviewingRoles:invokeServerAsync()
            end
        end)
    end

    return Banner(p1, {
        name = "PreviewBanner",
        buttonLabel = "Exit",
        text = v3,
        onButton = exitPreview,
        visible = v1,
        size = size,
        layoutOrder = layoutOrder
    })
end
