-- https://lua.expert

return function(p1, p2) -- line: 1
    local function anchor(p3) -- line: 2
        -- upvalues: p2 (copy)
        if p3:IsA("BasePart") then
            p3.Anchored = p2
        end
    end

    if p1:IsA("BasePart") then
        p1.Anchored = p2
    end

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = p2
        end
    end
end
