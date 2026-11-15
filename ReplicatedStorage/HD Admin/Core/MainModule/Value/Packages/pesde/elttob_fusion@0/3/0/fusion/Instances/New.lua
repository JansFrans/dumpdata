-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local defaultProps = require(ParentParent.Instances.defaultProps)
local applyInstanceProps = require(ParentParent.Instances.applyInstanceProps)

local function New(p1, p2) -- line: 19
    -- upvalues: External (copy), defaultProps (copy), applyInstanceProps (copy)
    if p2 == nil then
        External.logError("scopeMissing", nil, "instances using New", "myScope:New \"" .. p1 .. "\" { ... }")
    end

    return function(p3) -- line: 31
        -- upvalues: p1 (copy), p2 (copy), External (copy), defaultProps (copy), applyInstanceProps (copy)
        local new = Instance.new
        local ok, result = pcall(new, p2)

        if not ok then
            External.logError("cannotCreateClass", nil, p2)
        end

        local v1 = defaultProps[p2]

        if v1 ~= nil then
            for v2, v3 in pairs(v1) do
                result[v2] = v3
            end
        end

        table.insert(p1, result)
        applyInstanceProps(p1, p3, result)

        return result
    end
end

return New
