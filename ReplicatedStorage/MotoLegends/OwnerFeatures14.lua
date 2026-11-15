-- https://lua.expert

local t1 = {}
local v1 = workspace:GetAttribute("OwnerFeatures14") == true

workspace:GetAttributeChangedSignal("OwnerFeatures14"):Connect(function() -- line: 14
    -- upvalues: v1 (ref)
    v1 = workspace:GetAttribute("OwnerFeatures14") == true
end)

function t1.On() -- line: 15
    -- upvalues: v1 (ref)
    return v1
end

function t1.Wrap(p1, p2, p3) -- line: 17
    -- upvalues: v1 (ref)
    local result
    local v2 = false

    local function oldTable() -- line: 19
        -- upvalues: p2 (copy), p3 (copy), result (ref), v2 (ref)
        if v2 then
            return result
        end

        v2 = true

        local v3 = p2 and p2:FindFirstChild(p3)

        if v3 then
            local _require = require
            local ok, result2 = pcall(_require, v3)

            if not ok or typeof(result2) ~= "table" then
                warn("[OwnerFeatures14] " .. p3 .. " failed: " .. tostring(result2))
            else
                result = result2
            end
        end

        return result
    end

    return (setmetatable({}, {
        __index = function(_, p5) -- __index | line: 28
            -- upvalues: p1 (copy), oldTable (copy), v1 (ref)
            if not v1 then
                local v4 = oldTable()

                if v4 then
                    return v4[p5]
                end
            end

            return p1[p5]
        end,
        __newindex = function(_, p7, p8) -- __newindex | line: 33
            -- upvalues: p1 (copy), oldTable (copy)
            p1[p7] = p8

            local v5 = oldTable()

            if v5 then
                v5[p7] = p8
            end
        end
    }))
end

return t1
