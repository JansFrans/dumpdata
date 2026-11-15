-- https://lua.expert

return function(p1) -- line: 1
    if not p1 then
        return
    end

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            if string.sub(descendant.Name, 1, 4) == "Fake" then
                descendant:SetAttribute("DisableMorphPart", true)
                descendant:Destroy()
            elseif descendant.Name ~= "HumanoidRootPart" then
                descendant.Transparency = 0
            end
        end
    end
end
