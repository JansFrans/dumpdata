-- https://lua.expert

return {
    truthy = function() -- truthy | line: 1
        return true
    end,
    noop = function() -- noop | line: 5
    end,
    returned = function(...) -- returned | line: 7
        return ...
    end
}
