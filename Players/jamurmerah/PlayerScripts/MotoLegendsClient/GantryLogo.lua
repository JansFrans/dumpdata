-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local UIArt = require(MotoLegends:WaitForChild("UIArt"))
local v1

local function apply(p1) -- line: 8
    -- upvalues: v1 (ref)
    if not (p1:IsA("ImageLabel") and v1) then
        return
    end

    p1.ImageContent = v1

    local HidesText = p1:GetAttribute("HidesText")

    HidesText = HidesText and p1.Parent and p1.Parent:FindFirstChild(HidesText)

    if HidesText and HidesText:IsA("GuiObject") then
        HidesText.Visible = false
    end
end

task.spawn(function() -- line: 15
    -- upvalues: CollectionService (copy), UIArt (copy), v1 (ref), apply (copy)
    v1 = UIArt.Get("MotoLegendsLogo")

    if v1 then
        for _, v2 in CollectionService:GetTagged("MotoLegendsLogo") do
            apply(v2)
        end
    end
end)
CollectionService:GetInstanceAddedSignal("MotoLegendsLogo"):Connect(apply)
