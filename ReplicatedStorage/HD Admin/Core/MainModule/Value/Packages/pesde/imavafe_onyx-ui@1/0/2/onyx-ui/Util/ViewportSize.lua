-- https://lua.expert

local Workspace = game:GetService("Workspace")
local t1 = {
    SizeListener = nil,
    Size = Vector2.new(),
    Observers = {}
}

function t1.Observe(_, p2) -- line: 9
    -- upvalues: t1 (copy)
    table.insert(t1.Observers, p2)
    p2(t1.Size)
end

function t1._SetSize(_, p4) -- line: 14
    -- upvalues: t1 (copy)
    t1.Size = p4

    for _, v1 in t1.Observers do
        v1(p4)
    end
end

function t1._SetCamera(_, p6) -- line: 22
    -- upvalues: t1 (copy)
    if t1.SizeListener ~= nil then
        t1.SizeListener:Disconnect()
    end

    t1:_SetSize(p6.ViewportSize)
    t1.SizeListener = p6:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 29
        -- upvalues: p6 (copy), t1 (copy)
        t1:_SetSize(p6.ViewportSize)
    end)
end

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 34
    -- upvalues: Workspace (copy), t1 (copy)
    t1:_SetCamera(Workspace.CurrentCamera)
end)
t1:_SetCamera(Workspace.CurrentCamera)

return t1
