-- https://lua.expert

return function(p1) -- line: 2
    local t1 = {}

    function t1.disconnect(_) -- line: 4
        -- upvalues: p1 (copy)
        p1()
    end

    t1.Disconnect = t1.disconnect
    t1.Destroy = t1.disconnect

    return t1
end
