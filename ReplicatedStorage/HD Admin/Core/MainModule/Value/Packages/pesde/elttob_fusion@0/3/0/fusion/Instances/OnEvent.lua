-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local t1 = {}

local function getProperty_unsafe(p1, p2) -- line: 17
    return p1[p2]
end

local function OnEvent(p3) -- line: 24
    -- upvalues: External (copy), t1 (copy), getProperty_unsafe (copy)
    local v1 = t1[p3]

    if v1 == nil then
        v1 = {
            type = "SpecialKey",
            kind = "OnEvent",
            stage = "observer"
        }

        function v1.apply(_, p5, p6, p7) -- line: 33
            -- upvalues: p3 (copy), External (copy), getProperty_unsafe (copy)
            local ok, result = pcall(getProperty_unsafe, p7, p3)

            if not ok or typeof(result) ~= "RBXScriptSignal" then
                External.logError("cannotConnectEvent", nil, p7.ClassName, p3)
            elseif typeof(p6) == "function" then
                table.insert(p5, result:Connect(p6))
            else
                External.logError("invalidEventHandler", nil, p3)
            end
        end

        t1[p3] = v1
    end

    return v1
end

return OnEvent
