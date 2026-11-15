-- https://lua.expert

require(script.Parent.Types)

local v1

return {
    setDebugger = function(p1) -- setDebugger | line: 26
        -- upvalues: v1 (ref)
        local v2 = v1

        if v2 ~= nil then
            v2.stopDebugging()
        end

        v1 = p1

        if p1 ~= nil then
            p1.startDebugging()
        end

        return v2
    end,
    trackScope = function(p2) -- trackScope | line: 46
        -- upvalues: v1 (ref)
        if v1 ~= nil then
            v1.trackScope(p2)
        end
    end,
    untrackScope = function(p3) -- untrackScope | line: 61
        -- upvalues: v1 (ref)
        if v1 ~= nil then
            v1.trackScope(p3)
        end
    end
}
