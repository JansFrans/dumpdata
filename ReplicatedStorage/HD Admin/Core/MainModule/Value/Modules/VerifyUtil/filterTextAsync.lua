-- https://lua.expert

local TextService = game:GetService("TextService")
local v1 = game:GetService("RunService"):IsClient()
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local v2

local function textOnlyContainsHashtagsOrWhitespaces(p1) -- line: 9
    return p1:match("^[#%s]*$") ~= nil
end

return function(p2, p3, p4) -- line: 13
    -- upvalues: TextService (copy), v1 (copy), Modules (copy), v2 (ref)
    if v1 then
        local Remote = require(Modules.Objects.Remote)

        v2 = v2 or Remote.get("FilterText")

        local v3, v4 = v2:invokeServerAsync(p2, p4)

        return v3, v4
    end

    local v5 = if p4 then Enum.TextFilterContext.PrivateChat else Enum.TextFilterContext.PublicChat

    local function v6() -- line: 23
        -- upvalues: p2 (copy), p3 (copy), v5 (copy), TextService (copy)
        return TextService:FilterStringAsync(p2, p3, v5)
    end

    local ok, result = pcall(v6)

    if not ok then
        return false, (tostring(result))
    end

    local result2

    local function filterForBroadcast() -- line: 30
        -- upvalues: result (copy), result2 (ref)
        if result2 then
            return true, result2
        end

        local function v7() -- line: 34
            -- upvalues: result (copy)
            return result:GetNonChatStringForBroadcastAsync()
        end

        local ok, result3 = pcall(v7)

        if not ok then
            return false, (tostring(result3))
        end

        if result3:match("^[#%s]*$") ~= nil then
            return false, "Text was rejected for broadcast"
        end

        result2 = result3

        return true, result3
    end

    if p4 then
        local function v8() -- line: 50
            -- upvalues: p4 (copy), result (copy)
            return result:GetNonChatStringForUserAsync(p4)
        end

        local ok, result3 = pcall(v8)

        if ok then
            if result3:match("^[#%s]*$") ~= nil then
                return false, (("Text was rejected for user %*"):format(p4))
            end

            return true, result3
        end

        local result4, v9

        if result2 then
            v9 = true
            result4 = result2
        else
            local function v10() -- line: 34
                -- upvalues: result (copy)
                return result:GetNonChatStringForBroadcastAsync()
            end

            local ok

            ok, result4 = pcall(v10)

            if ok then
                if result4:match("^[#%s]*$") ~= nil then
                    v9 = false
                    result4 = "Text was rejected for broadcast"
                else
                    result2 = result4
                    v9 = true
                end
            else
                v9 = false
                result4 = tostring(result4)
            end
        end

        return v9, result4
    end

    local result3, v11

    if result2 then
        v11 = true
        result3 = result2
    else
        local function v12() -- line: 34
            -- upvalues: result (copy)
            return result:GetNonChatStringForBroadcastAsync()
        end

        local ok

        ok, result3 = pcall(v12)

        if ok then
            if result3:match("^[#%s]*$") ~= nil then
                v11 = false
                result3 = "Text was rejected for broadcast"
            else
                result2 = result3
                v11 = true
            end
        else
            v11 = false
            result3 = tostring(result3)
        end
    end

    return v11, result3
end
