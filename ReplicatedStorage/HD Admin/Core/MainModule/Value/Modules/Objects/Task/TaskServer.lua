-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Remote = require(Modules.Objects.Remote)
local RunService = game:GetService("RunService")
local v1
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 12
    -- upvalues: t1 (copy)
    local t2 = {
        taskUID = p1
    }

    setmetatable(t2, t1)

    return t2
end

function t1.replicate(p2, ...) -- line: 31
    -- upvalues: Remote (copy), RunService (copy), v1 (ref)
    if RunService:IsServer() then
        error("task.server should only be used on the client!")
    end

    v1 = v1 or Remote.get("RequestReplication")

    if v1 then
        local v2 = require(script.Parent).getTask(p2.taskUID)

        if v2 then
            local UID = v2.UID
            local v3 = v1
            local t3 = { ... }

            v2.defer(function() -- line: 50
                -- upvalues: v2 (copy), UID (copy), v3 (copy), t3 (copy)
                if v2.isActive then
                    v3:invokeServerAsync(UID, unpack(t3))
                end
            end)
        end
    end
end

return t1
