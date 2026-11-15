-- https://lua.expert

if game:GetService("RunService"):IsClient() then
    error("HD Admin: ServerAPI can only be used on the server. Require Core.ClientAPI from client scripts instead")
end

local v1 = game:GetService("ServerStorage"):FindFirstChild("HD Admin")

return require(v1.Core.ServerAPI)
