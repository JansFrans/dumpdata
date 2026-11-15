-- https://lua.expert

local Log = require(script.Parent.Log)
local v1 = false
local t2 = {}

return {
    isIsolated = function() -- isIsolated | line: 23
        -- upvalues: v1 (ref)
        return v1
    end,
    onIsolate = function(p1) -- onIsolate | line: 27
        -- upvalues: v1 (ref), t2 (ref)
        if v1 then
            task.spawn(p1)

            return function() -- line: 30
            end
        end

        table.insert(t2, p1)

        return function() -- line: 33
            -- upvalues: p1 (copy), t2 (ref)
            local v2 = table.find(t2, p1)

            if v2 then
                table.remove(t2, v2)
            end
        end
    end,
    isolate = function() -- isolate | line: 41
        -- upvalues: Log (copy), v1 (ref), t2 (ref)
        if v1 then
            return
        end

        v1 = true
        Log.once("isolated", "This server is isolated. Changes made here work as normal but won't be saved or sent to other servers.")

        local t4 = t2

        t2 = {}

        for _, v3 in t4 do
            task.spawn(v3)
        end
    end,
    _resetForTesting = function() -- _resetForTesting | line: 54
        -- upvalues: v1 (ref), t2 (ref)
        v1 = false
        t2 = {}
    end
}
