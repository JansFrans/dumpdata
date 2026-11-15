-- https://lua.expert

local v1 = table.create(500)

local function RunFunction(p1, p2, ...) -- line: 6
    -- upvalues: v1 (copy)
    p1(...)
    table.insert(v1, p2)
end

local function Yield() -- line: 11
    -- upvalues: RunFunction (copy)
    while true do
        RunFunction(coroutine.yield())
    end
end

local function FastDefer(p3, ...) -- line: 17
    -- upvalues: v1 (copy), Yield (copy)
    local v2 = #v1
    local v3

    if v2 > 0 then
        v3 = v1[v2]
        v1[v2] = nil
    else
        v3 = coroutine.create(Yield)
        coroutine.resume(v3)
    end

    return task.defer(v3, p3, v3, ...)
end

return FastDefer
