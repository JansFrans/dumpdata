-- https://lua.expert

return function(p1, p2) -- line: 4
    p1.CharacterAdded:Connect(p2)

    local Character = p1.Character

    if Character then
        task.defer(p2, Character)
    end
end
