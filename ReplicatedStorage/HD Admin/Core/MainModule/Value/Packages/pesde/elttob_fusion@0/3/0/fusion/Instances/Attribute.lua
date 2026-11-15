-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local checkLifetime = require(ParentParent.Memory.checkLifetime)
local Observer = require(ParentParent.Graph.Observer)
local castToState = require(ParentParent.State.castToState)
local peek = require(ParentParent.State.peek)
local t1 = {}

local function Attribute(p1) -- line: 23
    -- upvalues: checkLifetime (copy), Observer (copy), castToState (copy), peek (copy), t1 (copy)
    local v1 = t1[p1]

    if v1 == nil then
        v1 = {
            type = "SpecialKey",
            kind = "Attribute",
            stage = "self"
        }

        function v1.apply(_, p3, p4, p5) -- line: 32
            -- upvalues: p1 (copy), checkLifetime (copy), Observer (copy), castToState (copy), peek (copy)
            if castToState(p4) then
                checkLifetime.bOutlivesA(p3, p5, p4.scope, p4.oldestTask, checkLifetime.formatters.boundAttribute, p1)
                Observer(p3, p4):onBind(function() -- line: 45
                    -- upvalues: p4 (copy), p5 (copy), p1 (copy), peek (copy)
                    p5:SetAttribute(p1, peek(p4))
                end)
            else
                p5:SetAttribute(p1, p4)
            end
        end

        t1[p1] = v1
    end

    return v1
end

return Attribute
