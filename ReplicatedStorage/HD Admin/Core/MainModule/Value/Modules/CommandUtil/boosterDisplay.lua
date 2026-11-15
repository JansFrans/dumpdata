-- https://lua.expert

local t2 = {}

return {
    register = function(p1, p2, p3) -- register | line: 7
        -- upvalues: t2 (copy)
        t2[p1] = {
            kind = p2,
            id = p3
        }
    end,
    getAll = function() -- getAll | line: 11
        -- upvalues: t2 (copy)
        return t2
    end
}
