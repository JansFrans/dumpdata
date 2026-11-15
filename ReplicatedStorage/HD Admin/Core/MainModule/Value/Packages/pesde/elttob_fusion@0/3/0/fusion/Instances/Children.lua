-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local Observer = require(ParentParent.Graph.Observer)
local peek = require(ParentParent.State.peek)
local castToState = require(ParentParent.State.castToState)
local doCleanup = require(ParentParent.Memory.doCleanup)

return {
    type = "SpecialKey",
    kind = "Children",
    stage = "descendants",
    apply = function(_, p2, p3, p4) -- apply | line: 28
        -- upvalues: External (copy), Observer (copy), peek (copy), castToState (copy), doCleanup (copy)
        local v1 = {}
        local v2 = {}
        local v3 = {}
        local v4 = {}

        local function updateChildren() -- line: 44
            -- upvalues: p3 (ref), p4 (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), updateChildren (copy), External (copy), Observer (copy), peek (copy), castToState (copy), doCleanup (copy)
            local v5 = v1
            local v6 = v2

            v2 = v5
            v1 = v6

            local v7 = v3
            local v8 = v4

            v4 = v7
            v3 = v8

            local function processChild(p5, p6) -- line: 48
                -- upvalues: processChild (copy), p4 (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), updateChildren (copy), External (copy), Observer (copy), peek (copy), castToState (copy)
                local v9 = typeof(p5)

                if v9 == "Instance" then
                    local v10 = v1

                    v10[p5] = true

                    if v2[p5] ~= nil then
                        local v11 = v2

                        v11[p5] = nil
                    else
                        p5.Parent = p4
                    end
                elseif castToState(p5) then
                    local v12 = peek(p5)

                    if v12 ~= nil then
                        processChild(v12, p6)
                    end

                    local v13 = v4[p5]

                    if v13 ~= nil then
                        local v15 = v4

                        v15[p5] = nil
                    else
                        v13 = {}
                        Observer(v13, p5):onChange(updateChildren)
                    end

                    local v16 = v3

                    v16[p5] = v13
                elseif v9 == "table" then
                    for v17, v18 in pairs(p5) do
                        local v19 = typeof(v17)
                        local v20 = if v19 == "string" then v17 elseif v19 == "number" and p6 ~= nil then p6 .. "_" .. v17 else nil

                        processChild(v18, v20)
                    end
                else
                    External.logWarn("unrecognisedChildType", v9)
                end
            end

            if p3 ~= nil then
                processChild(p3)
            end

            for v21 in pairs(v2) do
                v21.Parent = nil
            end

            table.clear(v2)

            for _, v22 in pairs(v4) do
                doCleanup(v22)
            end

            table.clear(v4)
        end

        table.insert(p2, function() -- line: 140
            -- upvalues: p3 (ref), updateChildren (copy)
            p3 = nil
            updateChildren()
        end)
        updateChildren()
    end
}
