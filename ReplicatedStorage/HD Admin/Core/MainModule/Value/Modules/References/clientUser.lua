-- https://lua.expert

local MainModule = script:FindFirstAncestor("MainModule")
local State = require(MainModule.Value.Modules.Objects.State)
local v1 = State.new()

v1:sync("UserPerm")

local v2 = State.new()

v2:sync("UserTemp")

local v3 = State.new()

v3:sync("UserEveryone")

return {
    temp = v2,
    perm = v1,
    everyone = v3
}
