-- https://lua.expert

return {
    DataLimit = 5000,
    GetChildren = true,
    ChildrenAllowlist = { "AccessoryDescription", "BodyPartDescription" },
    ProcessInstance = function(p1) -- line: 5
        local AvatarEditorService = game:GetService("AvatarEditorService")

        local function v1() -- line: 7
            -- upvalues: p1 (copy), AvatarEditorService (copy)
            return AvatarEditorService:ConformToAvatarRules(p1)
        end

        local ok, result = pcall(v1)

        if not ok then
            result = Instance.new("HumanoidDescription")
        end

        result.Name = p1.Name

        return result
    end,
    Template = {
        BackAccessory = "0",
        FaceAccessory = "0",
        FrontAccessory = "0",
        HairAccessory = "0",
        HatAccessory = "0",
        NeckAccessory = "0",
        ShouldersAccessory = "0",
        WaistAccessory = "0",
        ClimbAnimation = 0,
        FallAnimation = 0,
        IdleAnimation = 0,
        JumpAnimation = 0,
        MoodAnimation = 0,
        RunAnimation = 0,
        SwimAnimation = 0,
        WalkAnimation = 0,
        HeadColor = Color3.new(1, 1, 1),
        LeftArmColor = Color3.new(1, 1, 1),
        LeftLegColor = Color3.new(1, 1, 1),
        RightArmColor = Color3.new(1, 1, 1),
        RightLegColor = Color3.new(1, 1, 1),
        TorsoColor = Color3.new(1, 1, 1),
        Face = 0,
        Head = 0,
        LeftArm = 0,
        LeftLeg = 0,
        RightArm = 0,
        RightLeg = 0,
        Torso = 0,
        GraphicTShirt = 0,
        Pants = 0,
        Shirt = 0,
        BodyTypeScale = 0,
        DepthScale = 0,
        HeadScale = 0,
        HeightScale = 0,
        ProportionScale = 0,
        WidthScale = 0
    }
}
