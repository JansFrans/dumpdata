-- https://lua.expert

local Packages = script:FindFirstAncestor("MainModule").Value.Modules.Parent.Packages

require(Packages.Fusion)

local v1

return {
    init = function(p1) -- init | line: 19
        -- upvalues: v1 (ref)
        v1 = p1:Value(nil)
    end,
    getState = function() -- getState | line: 23
        -- upvalues: v1 (ref)
        return v1
    end,
    open = function(p2, p3, p4) -- open | line: 27
        -- upvalues: v1 (ref)
        if v1 then
            v1:set({
                emoteId = p2,
                emoteName = p3,
                animationId = p4
            })
        end
    end,
    close = function() -- close | line: 33
        -- upvalues: v1 (ref)
        if v1 then
            v1:set(nil)
        end
    end
}
