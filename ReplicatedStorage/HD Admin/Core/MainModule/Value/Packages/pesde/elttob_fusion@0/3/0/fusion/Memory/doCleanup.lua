-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local scopePool = require(ParentParent.Memory.scopePool)
local poisonScope = require(ParentParent.Memory.poisonScope)
local t1 = {}

local function doCleanup(p1) -- line: 24
    -- upvalues: External (copy), scopePool (copy), poisonScope (copy), t1 (copy), doCleanup (copy)
    if t1[p1] then
        return External.logError("destroyedTwice")
    end

    t1[p1] = true

    if typeof(p1) == "Instance" then
        p1:Destroy()
    elseif typeof(p1) == "RBXScriptConnection" then
        p1:Disconnect()
    elseif typeof(p1) == "function" then
        p1()
    elseif typeof(p1) == "table" then
        if typeof(p1.destroy) == "function" then
            p1:destroy()
        elseif typeof(p1.Destroy) == "function" then
            p1:Destroy()
        elseif p1[1] ~= nil then
            for i = #p1, 1, -1 do
                doCleanup(p1[i])
                p1[i] = nil
            end

            if External.isTimeCritical() then
                scopePool.giveIfEmpty(p1)
            else
                poisonScope(p1, "`doCleanup()` was previously called on this scope. Ensure you are not reusing scopes after cleanup.")
            end
        end
    end

    t1[p1] = nil
end

return doCleanup
