-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = RunService:IsServer()
local v2 = RunService:IsStudio()
local v3 = script:FindFirstAncestor("HD Admin")
local v4
local t1 = {}
local t2 = {}

local function joinArguments(...) -- line: 26
    local v5 = table.pack(...)

    for i = 1, v5.n do
        v5[i] = tostring(v5[i])
    end

    return table.concat(v5, " ", 1, v5.n)
end

local function isDebugEnabled() -- line: 36
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (ref)
    if v4 ~= nil then
        return v4
    end

    if v2 then
        v4 = true

        return true
    end

    if v1 then
        local v7 = require(script.Parent.Framework).getLoader()

        if not v7 then
            return false
        end

        v4 = v7:GetAttribute("Debug") == true

        if v3 then
            v3:SetAttribute("Debug", v4)
        end
    else
        local Debug = if v3 then v3:GetAttribute("Debug") else nil

        if Debug == nil then
            return false
        end

        v4 = Debug == true
    end

    return v4
end

function t2.warn(...) -- line: 67
    -- upvalues: joinArguments (copy)
    warn("[HD Admin] " .. joinArguments(...))
end

function t2.debug(...) -- line: 72
    -- upvalues: joinArguments (copy), isDebugEnabled (copy)
    if isDebugEnabled() then
        print("[HD Admin] " .. joinArguments(...))
    end
end

function t2.once(p1, ...) -- line: 79
    -- upvalues: t1 (copy), t2 (copy)
    if not t1[p1] then
        t1[p1] = true
        t2.warn(...)
    end
end

return t2
