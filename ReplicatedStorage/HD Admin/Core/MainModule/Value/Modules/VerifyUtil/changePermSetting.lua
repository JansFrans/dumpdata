-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local getDataSize = require(Modules.VerifyUtil.getDataSize)
local User = require(Modules.Objects.User)

return function(p1, p2, p3) -- line: 5
    -- upvalues: getDataSize (copy), User (copy)
    local v1 = User.getUser(p1)

    if not v1 then
        return false, "User not loaded"
    end

    if getDataSize(p3) > 1000 then
        return false, "Perm value is too large"
    end

    v1.perm:set(p2, p3)

    return true
end
