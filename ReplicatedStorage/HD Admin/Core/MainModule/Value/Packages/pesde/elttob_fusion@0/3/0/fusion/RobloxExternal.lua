-- https://lua.expert

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local External = require(script.Parent.External)
local t1 = {
    policies = {
        allowWebLinks = RunService:IsStudio()
    },
    doTaskImmediate = function(p1) -- doTaskImmediate | line: 24
        task.spawn(p1)
    end,
    doTaskDeferred = function(p2) -- doTaskDeferred | line: 33
        task.defer(p2)
    end,
    logErrorNonFatal = function(p3) -- logErrorNonFatal | line: 42
        task.spawn(error, p3, 0)
    end,
    logWarn = warn
}

local function performUpdateStep() -- line: 56
    -- upvalues: External (copy)
    External.performUpdateStep(os.clock())
end

local v1

function t1.startScheduler() -- line: 64
    -- upvalues: RunService (copy), HttpService (copy), performUpdateStep (copy), v1 (ref)
    if v1 ~= nil then
        return
    end

    if RunService:IsClient() then
        local v2 = "FusionUpdateStep_" .. HttpService:GenerateGUID()

        RunService:BindToRenderStep(v2, Enum.RenderPriority.First.Value, performUpdateStep)

        v1 = function() -- line: 77
            -- upvalues: v2 (copy), RunService (copy)
            RunService:UnbindFromRenderStep(v2)
        end
    else
        local connection = RunService.Heartbeat:Connect(performUpdateStep)

        v1 = function() -- line: 82
            -- upvalues: connection (copy)
            connection:Disconnect()
        end
    end
end

function t1.stopScheduler() -- line: 91
    -- upvalues: v1 (ref)
    if v1 ~= nil then
        v1()
        v1 = nil
    end
end

return t1
