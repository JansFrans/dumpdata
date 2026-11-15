-- https://lua.expert

local AvatarEditorService = game:GetService("AvatarEditorService")
local v1 = game:GetService("RunService"):IsClient()
local v2 = false

return function(p1, p2) -- line: 13
    -- upvalues: AvatarEditorService (copy), v1 (copy), v2 (ref)
    if not v1 or v2 then
        return false
    end

    v2 = true

    local v3
    local connection = AvatarEditorService.PromptSetFavoriteCompleted:Once(function(p3) -- line: 24
        -- upvalues: v3 (ref)
        v3 = p3
    end)

    local function v4() -- line: 28
        -- upvalues: p1 (copy), p2 (copy), AvatarEditorService (copy)
        AvatarEditorService:PromptSetFavorite(p1, Enum.AvatarItemType.Asset, p2)
    end

    if pcall(v4) then
        local elapsed = os.clock()

        while v3 == nil and os.clock() - elapsed < 30 do
            task.wait()
        end
    end

    connection:Disconnect()
    v2 = false

    if v3 == nil then
        return false
    end

    local PermissionDenied = Enum.AvatarPromptResult.PermissionDenied

    return v3 ~= PermissionDenied
end
