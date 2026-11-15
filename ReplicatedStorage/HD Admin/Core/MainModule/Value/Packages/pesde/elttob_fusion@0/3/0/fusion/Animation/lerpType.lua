-- https://lua.expert

local Oklab = require(script.Parent.Parent.Colour.Oklab)

local function lerpType(p1, p2, p3) -- line: 15
    -- upvalues: Oklab (copy)
    local v1 = typeof(p1)

    if typeof(p2) == v1 then
        if v1 == "number" then
            return (p2 - p1) * p3 + p1
        end

        if v1 == "CFrame" then
            return p1:Lerp(p2, p3)
        end

        if v1 == "Color3" then
            local v2 = Oklab.fromSRGB(p1)
            local v3 = Oklab.fromSRGB(p2)

            return Oklab.toSRGB(v2:Lerp(v3, p3), false)
        end

        if v1 == "ColorSequenceKeypoint" then
            local v4 = Oklab.fromSRGB(p1.Value)
            local v5 = Oklab.fromSRGB(p2.Value)

            return ColorSequenceKeypoint.new((p2.Time - p1.Time) * p3 + p1.Time, Oklab.toSRGB(v4:Lerp(v5, p3), false))
        end

        if v1 == "DateTime" then
            return DateTime.fromUnixTimestampMillis((p2.UnixTimestampMillis - p1.UnixTimestampMillis) * p3 + p1.UnixTimestampMillis)
        end

        if v1 == "NumberRange" then
            return NumberRange.new((p2.Min - p1.Min) * p3 + p1.Min, (p2.Max - p1.Max) * p3 + p1.Max)
        end

        if v1 == "NumberSequenceKeypoint" then
            return NumberSequenceKeypoint.new((p2.Time - p1.Time) * p3 + p1.Time, (p2.Value - p1.Value) * p3 + p1.Value, (p2.Envelope - p1.Envelope) * p3 + p1.Envelope)
        end

        if v1 == "PhysicalProperties" then
            return PhysicalProperties.new((p2.Density - p1.Density) * p3 + p1.Density, (p2.Friction - p1.Friction) * p3 + p1.Friction, (p2.Elasticity - p1.Elasticity) * p3 + p1.Elasticity, (p2.FrictionWeight - p1.FrictionWeight) * p3 + p1.FrictionWeight, (p2.ElasticityWeight - p1.ElasticityWeight) * p3 + p1.ElasticityWeight)
        end

        if v1 == "Ray" then
            return Ray.new(p1.Origin:Lerp(p2.Origin, p3), p1.Direction:Lerp(p2.Direction, p3))
        end

        if v1 == "Rect" then
            return Rect.new(p1.Min:Lerp(p2.Min, p3), p1.Max:Lerp(p2.Max, p3))
        end

        if v1 == "Region3" then
            local v6 = p1.CFrame.Position:Lerp(p2.CFrame.Position, p3)
            local v7 = p1.Size:Lerp(p2.Size, p3) / 2

            return Region3.new(v6 - v7, v6 + v7)
        end

        if v1 == "Region3int16" then
            return Region3int16.new(Vector3int16.new((p2.Min.X - p1.Min.X) * p3 + p1.Min.X, (p2.Min.Y - p1.Min.Y) * p3 + p1.Min.Y, (p2.Min.Z - p1.Min.Z) * p3 + p1.Min.Z), Vector3int16.new((p2.Max.X - p1.Max.X) * p3 + p1.Max.X, (p2.Max.Y - p1.Max.Y) * p3 + p1.Max.Y, (p2.Max.Z - p1.Max.Z) * p3 + p1.Max.Z))
        end

        if v1 == "UDim" then
            return UDim.new((p2.Scale - p1.Scale) * p3 + p1.Scale, (p2.Offset - p1.Offset) * p3 + p1.Offset)
        end

        if v1 == "UDim2" or v1 == "Vector2" then
            return p1:Lerp(p2, p3)
        end

        if v1 == "Vector2int16" then
            return Vector2int16.new((p2.X - p1.X) * p3 + p1.X, (p2.Y - p1.Y) * p3 + p1.Y)
        end

        if v1 == "Vector3" then
            return p1:Lerp(p2, p3)
        end

        if v1 == "Vector3int16" then
            return Vector3int16.new((p2.X - p1.X) * p3 + p1.X, (p2.Y - p1.Y) * p3 + p1.Y, (p2.Z - p1.Z) * p3 + p1.Z)
        end
    end

    if p3 < 0.5 then
        return p1
    end

    return p2
end

return lerpType
