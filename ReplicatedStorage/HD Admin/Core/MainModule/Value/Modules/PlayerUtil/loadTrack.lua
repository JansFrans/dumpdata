-- https://lua.expert

local getAnimator = require(script.Parent.getAnimator)

return function(p1, p2) -- line: 3
    -- upvalues: getAnimator (copy)
    local v1 = getAnimator(p1)

    if not v1 or not p1 then
        return nil, nil
    end

    local Character = p1.Character
    local Animation = Instance.new("Animation")

    Animation.Name = tostring(p2)
    Animation.AnimationId = "rbxassetid://" .. p2
    Animation.Parent = Character

    return v1:LoadAnimation(Animation), Animation
end
