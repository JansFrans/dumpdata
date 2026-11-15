-- https://lua.expert

local v1 = {}
local v2 = false
local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local RunService = game:GetService("RunService")

return function() -- line: 15
    -- upvalues: v1 (ref), v2 (ref), t1 (copy), Modules (copy), RunService (copy)
    if RunService:IsClient() then
        if v2 then
            return true, v1
        end

        local v3, v4 = require(Modules.Objects.Remote).get("GetToolsInfo"):invokeServerAsync()

        if not v3 then
            return false, (tostring(v4))
        end

        v1 = v4
        v2 = true

        return true, v4
    end

    if not v2 then
        local n1 = 0

        for _, v5 in { "ReplicatedStorage", "ServerStorage", "Lighting", "StarterPack" } do
            local v6 = n1

            for _, descendant in game:GetService(v5):GetDescendants() do
                v6 += 1
                n1 = v6

                if v6 % 1000 == 0 then
                    task.wait()
                end

                if descendant:IsA("Tool") and #descendant:GetChildren() ~= 0 then
                    local v7 = descendant.Name:lower()

                    if not t1[v7] then
                        local v8 = v1

                        table.insert(v8, {
                            name = descendant.Name,
                            textureId = descendant.TextureId,
                            tool = descendant
                        })
                        t1[v7] = descendant
                    end
                end
            end
        end

        v2 = true
    end

    return true, v1
end
