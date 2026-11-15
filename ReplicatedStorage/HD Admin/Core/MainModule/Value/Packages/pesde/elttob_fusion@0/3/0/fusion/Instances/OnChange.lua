-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local t1 = {}

local function OnChange(p1) -- line: 17
    -- upvalues: External (copy), t1 (copy)
    local v1 = t1[p1]

    if v1 == nil then
        v1 = {
            type = "SpecialKey",
            kind = "OnChange",
            stage = "observer"
        }

        function v1.apply(_, p3, p4, p5) -- line: 26
            -- upvalues: p1 (copy), External (copy)
            local GetPropertyChangedSignal = p5.GetPropertyChangedSignal
            local ok, result = pcall(GetPropertyChangedSignal, p5, p1)

            if ok then
                if typeof(p4) == "function" then
                    table.insert(p3, result:Connect(function() -- line: 39
                        -- upvalues: p4 (copy), p5 (copy), p1 (copy)
                        p4(p5[p1])
                    end))
                else
                    External.logError("invalidChangeHandler", nil, p1)
                end
            else
                External.logError("cannotConnectChange", nil, p5.ClassName, p1)
            end
        end

        t1[p1] = v1
    end

    return v1
end

return OnChange
