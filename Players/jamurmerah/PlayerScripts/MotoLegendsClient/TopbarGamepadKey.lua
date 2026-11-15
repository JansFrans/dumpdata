-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {}

local function apply(p1) -- line: 10
    -- upvalues: t1 (copy)
    if not p1 or not p1:IsA("ObjectValue") or not p1.Value or t1[p1.Value] then
        return
    end

    local _require = require
    local Value = p1.Value
    local ok, result = pcall(_require, Value)

    if ok and typeof(result) == "table" then
        t1[p1.Value] = true
        result.highlightKey = false
        task.delay(1.5, function() -- line: 17
            -- upvalues: result (copy)
            local function v1() -- line: 18
                -- upvalues: result (copy)
                for _, v2 in result.iconsDictionary or {} do
                    if typeof(v2) == "table" and v2.setIndicator then
                        v2:setIndicator()
                    end
                end
            end

            pcall(v1)
        end)
    end
end

local TopbarPlusReference = ReplicatedStorage:FindFirstChild("TopbarPlusReference")

if TopbarPlusReference then
    apply(TopbarPlusReference)
end

ReplicatedStorage.ChildAdded:Connect(function(p2) -- line: 26
    -- upvalues: apply (copy)
    if p2.Name == "TopbarPlusReference" then
        task.defer(apply, p2)
    end
end)
