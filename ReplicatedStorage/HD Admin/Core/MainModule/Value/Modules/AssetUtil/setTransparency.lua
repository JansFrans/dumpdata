-- https://lua.expert

return function(p1, p2) -- line: 1
    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" or descendant.Name == "face" and descendant:IsA("Decal") then
            descendant.Transparency = p2
        elseif descendant:IsA("ParticleEmitter") and descendant.Name == "BodyEffect" or descendant:IsA("PointLight") or descendant:IsA("BillboardGui") then
            descendant.Enabled = descendant.Enabled and p2 < 1
        end
    end
end
