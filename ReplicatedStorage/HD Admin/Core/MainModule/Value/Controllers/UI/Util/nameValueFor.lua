-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local getNameFromUserIdAsync = require(Modules.PlayerUtil.getNameFromUserIdAsync)

local function peekUserId(p1) -- line: 19
    -- upvalues: Fusion (copy)
    local v1 = if typeof(p1) == "table" then Fusion.peek(p1) else p1

    return if typeof(v1) == "number" and not (v1 <= 0) then v1 else nil
end

return function(p2, p3) -- line: 30
    -- upvalues: Fusion (copy), getNameFromUserIdAsync (copy)
    local v2 = p2:Value("")

    local function resolve(p4) -- line: 33
        -- upvalues: p3 (copy), v2 (copy), Fusion (copy), getNameFromUserIdAsync (copy)
        task.spawn(function() -- line: 34
            -- upvalues: p4 (copy), p3 (copy), v2 (copy), Fusion (copy), getNameFromUserIdAsync (copy)
            local v3, v4 = getNameFromUserIdAsync(p4)

            if not v3 or typeof(v4) ~= "string" then
                v4 = tostring(p4)
            end

            local v5 = p3

            if typeof(p3) == "table" then
                v5 = Fusion.peek(p3)
            end

            if typeof(v5) ~= "number" or v5 <= 0 then
                v5 = nil
            end

            if v5 == p4 then
                v2:set(v4)
            end
        end)
    end

    local v6 = if typeof(p3) == "table" then Fusion.peek(p3) else p3

    if typeof(v6) ~= "number" or v6 <= 0 then
        v6 = nil
    end

    if v6 then
        local spawn = task.spawn
        local v7 = v6

        spawn(function() -- line: 34
            -- upvalues: p3 (copy), v2 (copy), v7 (copy), Fusion (copy), getNameFromUserIdAsync (copy)
            local v8, v9 = getNameFromUserIdAsync(v7)

            if not v8 or typeof(v9) ~= "string" then
                v9 = tostring(v7)
            end

            local v10 = p3

            if typeof(p3) == "table" then
                v10 = Fusion.peek(p3)
            end

            if typeof(v10) ~= "number" or v10 <= 0 then
                v10 = nil
            end

            if v10 == v7 then
                v2:set(v9)
            end
        end)
    end

    if typeof(p3) == "table" then
        p2:Observer(p3):onChange(function() -- line: 48
            -- upvalues: p3 (copy), v2 (copy), Fusion (copy), getNameFromUserIdAsync (copy)
            v2:set("")

            local v11 = p3

            if typeof(p3) == "table" then
                v11 = Fusion.peek(p3)
            end

            if typeof(v11) ~= "number" or v11 <= 0 then
                v11 = nil
            end

            if not v11 then
                return
            end

            task.spawn(function() -- line: 34
                -- upvalues: v11 (ref), p3 (copy), v2 (copy), Fusion (copy), getNameFromUserIdAsync (copy)
                local v12, v13 = getNameFromUserIdAsync(v11)

                if not v12 or typeof(v13) ~= "string" then
                    v13 = tostring(v11)
                end

                local v14 = p3

                if typeof(p3) == "table" then
                    v14 = Fusion.peek(p3)
                end

                if typeof(v14) ~= "number" or v14 <= 0 then
                    v14 = nil
                end

                if v14 == v11 then
                    v2:set(v13)
                end
            end)
        end)
    end

    return v2
end
