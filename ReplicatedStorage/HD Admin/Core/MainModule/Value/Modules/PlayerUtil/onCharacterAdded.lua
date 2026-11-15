-- https://lua.expert

return function(p1, p2) -- line: 3
    local Character = p1.Character

    if Character then
        task.defer(p2, Character)
    else
        p1.CharacterAdded:Once(function(p3) -- line: 8
            -- upvalues: p2 (copy)
            p2(p3)
        end)
    end
end
