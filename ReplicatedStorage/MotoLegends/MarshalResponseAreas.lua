-- https://lua.expert

return {
    Contains = function(p1, p2) -- Contains | line: 2
        if p1:IsA("BasePart") and p1:GetAttribute("Enabled") ~= false then
            local v2 = p1.CFrame:PointToObjectSpace(p2)
            local v3 = p1.Size * 0.5 + Vector3.new(0.001, 0.001, 0.001)
            local v1 = false

            if math.abs(v2.X) <= v3.X and math.abs(v2.Y) <= v3.Y then
                v1 = math.abs(v2.Z) <= v3.Z
            end

            return v1
        end

        return false
    end
}
