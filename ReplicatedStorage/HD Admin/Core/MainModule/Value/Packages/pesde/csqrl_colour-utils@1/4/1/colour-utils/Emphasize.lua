-- https://lua.expert

local Darken = require(script.Parent.Darken)
local GetLuminance = require(script.Parent.GetLuminance)
local Lighten = require(script.Parent.Lighten)

return function(p1, p2, p3) -- line: 14
    -- upvalues: Darken (copy), GetLuminance (copy), Lighten (copy)
    return (if type(p3) ~= "number" or not p3 then 0.5 else p3) < GetLuminance(p1) and Darken(p1, p2) or Lighten(p1, p2)
end
