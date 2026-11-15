-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local v1 = false
local v2

local function acknowledge() -- line: 18
    -- upvalues: Modules (copy)
    task.spawn(function() -- line: 19
        -- upvalues: Modules (copy)
        require(Modules.Objects.Remote).get("AcknowledgeVetting"):invokeServerAsync()
    end)
end

local function open(p1) -- line: 25
    -- upvalues: Modules (copy), v1 (ref), v2 (ref)
    v1 = p1 == true

    local Navigate = require(Modules.Parent.Controllers.UI.Util.Navigate)

    Navigate.openPanel()
    Navigate.toPage("VetCommands")

    local v3 = v2

    if v3 then
        task.spawn(v3)
    end
end

local function setOpenListener(p2) -- line: 38
    -- upvalues: v2 (ref)
    v2 = p2
end

return {
    open = open,
    acknowledge = acknowledge,
    consumePendingFocus = function() -- consumePendingFocus | line: 44
        -- upvalues: v1 (ref)
        local v4 = v1

        v1 = false

        return v4
    end,
    setOpenListener = setOpenListener
}
