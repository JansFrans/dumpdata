-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local getHRP = require(Modules.PlayerUtil.getHRP)
local Event = require(Modules.Objects.Remote).new("PlayTextToSpeech", "Event")

return function(p1, p2, p3) -- line: 10
    -- upvalues: getHRP (copy), Event (copy)
    if typeof(p2) == "string" and getHRP(p1) then
        Event:fireClient(p1, p2, p3 or "9")
    end
end
