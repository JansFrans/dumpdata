-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Demojify = require(Modules.Serializer.Demojify)
local isNumberSafe = require(script.Parent.isNumberSafe)

return function(p1) -- line: 6
    -- upvalues: Demojify (copy), isNumberSafe (copy)
    if typeof(p1) ~= "string" or not utf8.len(p1) or Demojify.process(p1) ~= p1 then
        return false
    end

    return not not (not tonumber(p1) or isNumberSafe(p1))
end
