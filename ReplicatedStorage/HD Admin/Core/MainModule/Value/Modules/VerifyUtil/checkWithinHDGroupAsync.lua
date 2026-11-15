-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local JoinHDGroup = require(Modules.Objects.Remote).new("JoinHDGroup")
local t1 = {}
local t2 = {}

JoinHDGroup:onServerEvent(function(p1) -- line: 7
    if not p1:GetAttribute("JoinedHDGroup") then
        p1:SetAttribute("JoinedHDGroup", true)
    end
end)

return function(p2) -- line: 15
    -- upvalues: JoinHDGroup (copy), t1 (copy), t2 (copy)
    local Name = p2.Name

    if t2[Name] then
        repeat
            task.wait(0.05)
        until not t2[Name]
    end

    local v1 = t1[Name]

    if v1 then
        return v1
    end

    t2[Name] = true

    local JoinedHDGroup = p2:GetAttribute("JoinedHDGroup")
    local ok, result

    if not JoinedHDGroup then
        local function v2() -- line: 29
            -- upvalues: p2 (copy)
            return p2:IsInGroupAsync(4676369)
        end

        ok, result = pcall(v2)
    end

    local v3

    if not JoinedHDGroup and (not ok or result ~= true) then
        v3 = false
        JoinHDGroup:fireClient(p2, 4676369, "Group exclusive command. Join HD Admin to unlock!")
    else
        v3 = true
    end

    t1[Name] = v3
    t2[Name] = nil
    task.delay(0.5, function() -- line: 41
        -- upvalues: Name (copy), t1 (copy)
        t1[Name] = nil
    end)

    return v3
end
