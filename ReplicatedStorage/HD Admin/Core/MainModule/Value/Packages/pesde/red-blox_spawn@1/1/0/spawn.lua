-- https://lua.expert

local t1 = {}

local function RunCallback(p1, p2, ...) -- line: 3
    -- upvalues: t1 (copy)
    p1(...)
    table.insert(t1, p2)
end

local function Yielder() -- line: 8
    -- upvalues: RunCallback (copy)
    while true do
        RunCallback(coroutine.yield())
    end
end

return function(p3, ...) -- line: 14
    -- upvalues: t1 (copy), Yielder (copy)
    local v1

    if #t1 > 0 then
        v1 = t1[#t1]
        t1[#t1] = nil
    else
        v1 = coroutine.create(Yielder)
        coroutine.resume(v1)
    end

    task.spawn(v1, p3, v1, ...)
end
