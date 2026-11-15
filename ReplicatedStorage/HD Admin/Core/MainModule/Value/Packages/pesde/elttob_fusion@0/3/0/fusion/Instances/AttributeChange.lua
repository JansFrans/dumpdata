-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local t1 = {}

local function AttributeChange(p1) -- line: 17
    -- upvalues: External (copy), t1 (copy)
    local v1 = t1[p1]

    if v1 == nil then
        v1 = {
            type = "SpecialKey",
            kind = "AttributeChange",
            stage = "observer"
        }

        function v1.apply(_, p3, p4, p5) -- line: 26
            -- upvalues: p1 (copy), External (copy)
            if typeof(p4) ~= "function" then
                External.logError("invalidAttributeChangeHandler", nil, p1)
            end

            table.insert(p3, p5:GetAttributeChangedSignal(p1):Connect(function() -- line: 37
                -- upvalues: p4 (copy), p5 (copy), p1 (copy)
                p4(p5:GetAttribute(p1))
            end))
        end

        t1[p1] = v1
    end

    return v1
end

return AttributeChange
