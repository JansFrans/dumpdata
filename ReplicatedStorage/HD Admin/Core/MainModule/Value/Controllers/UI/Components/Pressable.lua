-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)

require(UI.Util.Theme)

local Children = Fusion.Children
local Platform = require(UI.Util.Platform)
local registerSound = require(Modules.AssetUtil.registerSound)
local Navigate = require(UI.Util.Navigate)
local PressableSounds, SharedHover, SharedClick

local function ensureSharedSounds() -- line: 49
    -- upvalues: registerSound (copy), PressableSounds (ref), SharedHover (ref), SharedClick (ref)
    if SharedHover then
        return
    end

    local SoundService = game:GetService("SoundService")
    local PressableSounds2 = SoundService:FindFirstChild("PressableSounds")

    if not PressableSounds2 then
        PressableSounds2 = Instance.new("Folder")
        PressableSounds2.Name = "PressableSounds"
        PressableSounds2.Parent = SoundService
    end

    PressableSounds = PressableSounds2

    local SharedHover2 = PressableSounds2:FindFirstChild("SharedHover")

    if not SharedHover2 then
        SharedHover2 = Instance.new("Sound")
        SharedHover2.Name = "SharedHover"
        SharedHover2.SoundId = "rbxassetid://10066936758"
        SharedHover2.Volume = 0.1
        SharedHover2.RollOffMaxDistance = 0
        SharedHover2.Parent = PressableSounds2
        registerSound(SharedHover2, "Interface")
    end

    SharedHover = SharedHover2

    local SharedClick2 = PressableSounds2:FindFirstChild("SharedClick")

    if not SharedClick2 then
        SharedClick2 = Instance.new("Sound")
        SharedClick2.Name = "SharedClick"
        SharedClick2.SoundId = "rbxassetid://16480549841"
        SharedClick2.Volume = 0.2
        SharedClick2.RollOffMaxDistance = 0
        SharedClick2.Parent = PressableSounds2
        registerSound(SharedClick2, "Interface")
    end

    SharedClick = SharedClick2
end

local function applyHighlight(p1, p2, p3, p4) -- line: 85
    local v1 = if 0.299 * p2.R + 0.587 * p2.G + 0.114 * p2.B > 0.5 then Color3.new(0, 0, 0) else Color3.new(1, 1, 1)

    if p1(p3) then
        return p2:Lerp(v1, 0.2)
    end

    if p1(p4) then
        return p2:Lerp(v1, 0.1)
    end

    return p2
end

local function pressable(p5, p6) -- line: 98
    -- upvalues: Fusion (copy), Children (copy), Platform (copy), registerSound (copy), Navigate (copy), SharedHover (ref), SharedClick (ref), ensureSharedSounds (copy)
    debug.profilebegin("HD_Pressable")

    local v2 = p5:Value(false)
    local v3 = p5:Value(false)
    local v4 = p6.backgroundColor ~= nil
    local darken = p6.darken
    local v5 = p5:Computed(function(p7) -- line: 105
        -- upvalues: p6 (copy), v2 (copy), v3 (copy), darken (copy), v4 (copy)
        local v6 = if v4 then p7(p6.backgroundColor) else Color3.new(1, 1, 1)
        local v7 = if if darken == nil then 0.299 * v6.R + 0.587 * v6.G + 0.114 * v6.B > 0.5 else darken == true then Color3.new(0, 0, 0) else Color3.new(1, 1, 1)

        if p7(v3) then
            return v6:Lerp(v7, 0.2)
        end

        if p7(v2) then
            return v6:Lerp(v7, 0.1)
        end

        return v6
    end)

    if not Platform.isMobile then
        v5 = p5:Spring(v5, 70, 1)
    end

    local v8

    if p6.iconImage ~= nil then
        v8 = p5:Computed(function(p8) -- line: 129
            -- upvalues: p6 (copy), v2 (copy), v3 (copy)
            local v9 = if p6.iconColor then p8(p6.iconColor) else Color3.new(1, 1, 1)

            if p8(v3) then
                return v9:Lerp(Color3.fromRGB(128, 128, 128), 0.4)
            end

            if p8(v2) then
                return v9:Lerp(Color3.fromRGB(128, 128, 128), 0.2)
            end

            return v9
        end)

        if not Platform.isMobile then
            v8 = p5:Spring(v8, 70, 1)
        end
    end

    local v10 = if Platform.isMobile or p6.hoverScale == nil then nil else p5:Spring(p5:Computed(function(p9) -- line: 143
        -- upvalues: p6 (copy), v2 (copy)
        if p9(v2) then
            return p6.hoverScale
        end

        return 1
    end), 70, 1)

    ensureSharedSounds()

    local v11 = SharedHover
    local v12 = SharedClick
    local v13

    if p6.soundHover ~= nil then
        v13 = p5:New("Sound")({
            Name = "CustomHoverSound",
            Volume = 0.1,
            RollOffMaxDistance = 0,
            SoundId = p6.soundHover
        })
        registerSound(v13, "Interface")
        v11 = v13
    end

    local v14

    if p6.soundActivate ~= nil then
        v14 = p5:New("Sound")({
            Name = "CustomClickSound",
            Volume = 0.2,
            RollOffMaxDistance = 0,
            SoundId = p6.soundActivate
        })
        registerSound(v14, "Interface")
        v12 = v14
    end

    local v20 = p5:New("TextButton")({
        Name = p6.name or "Pressable",
        AutoButtonColor = false,
        AutomaticSize = p6.automaticSize,
        AnchorPoint = p6.anchorPoint,
        BackgroundColor3 = v5,
        BackgroundTransparency = if v4 then p6.backgroundTransparency or 0 else 1,
        ClipsDescendants = p6.clipsDescendants,
        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
        LayoutOrder = p6.layoutOrder,
        Position = p6.position,
        Size = p6.size or UDim2.fromScale(1, 1),
        Text = "",
        TextColor3 = Color3.new(),
        TextSize = 1,
        Visible = p6.visible,
        Interactable = p6.interactable == nil or p6.interactable,
        ZIndex = p6.zIndex,
        [Fusion.OnEvent("MouseEnter")] = function() -- line: 195
            -- upvalues: p6 (copy), v2 (copy), v11 (ref)
            v2:set(true)

            if p6.onHoverChanged then
                p6.onHoverChanged(true)
            end

            if not v11.IsPlaying then
                v11:Play()
            end
        end,
        [Fusion.OnEvent("MouseLeave")] = function() -- line: 202
            -- upvalues: p6 (copy), v2 (copy), v3 (copy), Fusion (copy)
            v2:set(false)

            if Fusion.peek(v3) then
                v3:set(false)

                if p6.onPressChanged then
                    p6.onPressChanged(false)
                end
            end

            if p6.onHoverChanged then
                p6.onHoverChanged(false)
            end
        end,
        [Fusion.OnEvent("MouseButton1Down")] = function() -- line: 210
            -- upvalues: p6 (copy), v3 (copy)
            v3:set(true)

            if p6.onPressChanged then
                p6.onPressChanged(true)
            end
        end,
        [Fusion.OnEvent("MouseButton1Up")] = function() -- line: 214
            -- upvalues: p6 (copy), v3 (copy)
            v3:set(false)

            if p6.onPressChanged then
                p6.onPressChanged(false)
            end
        end,
        [Fusion.OnEvent("Activated")] = function() -- line: 218
            -- upvalues: p6 (copy), v12 (ref), Fusion (copy)
            v12:Play()

            local onActivate = p6.onActivate

            if onActivate then
                local v15 = if typeof(onActivate) == "table" then Fusion.peek(onActivate) else onActivate

                if v15 then
                    v15()
                end
            end
        end,
        [Children] = {
            v13,
            v14,
            if v10 == nil then nil else p5:New("UIScale")({
                Scale = v10
            }),
            if v8 ~= nil then p5:New("ImageLabel")({
                Name = "Icon",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = p6.iconImage,
                ImageColor3 = v8,
                ImageTransparency = p6.iconTransparency or 0,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = p5:Computed(function(p10) -- line: 239
                    -- upvalues: p6 (copy)
                    local v18 = if p6.iconSize then p10(p6.iconSize) else 20

                    return UDim2.fromOffset(v18, v18)
                end)
            }) else nil,
            p6[Children]
        }
    })

    Navigate.registerActivate(v20, function() -- line: 249
        -- upvalues: p6 (copy), Fusion (copy)
        local onActivate = p6.onActivate

        if onActivate then
            if typeof(onActivate) == "table" then
                onActivate = Fusion.peek(onActivate)
            end

            if onActivate then
                onActivate()
            end
        end
    end)
    debug.profileend()

    return v20
end

return (setmetatable({
    applyHighlight = applyHighlight
}, {
    __call = function(_, p12, p13) -- __call | line: 264
        -- upvalues: pressable (copy)
        return (pressable(p12, p13))
    end
}))
