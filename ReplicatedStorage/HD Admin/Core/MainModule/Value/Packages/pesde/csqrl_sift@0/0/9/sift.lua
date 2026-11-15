-- https://lua.expert

require(script.Types)

local t1 = {
    Array = require(script.Array),
    Dictionary = require(script.Dictionary),
    Set = require(script.Set),
    None = require(script.None),
    Types = require(script.Types),
    equalObjects = require(script.Util.equalObjects),
    isEmpty = require(script.Util.isEmpty)
}

t1.List = t1.Array

return t1
