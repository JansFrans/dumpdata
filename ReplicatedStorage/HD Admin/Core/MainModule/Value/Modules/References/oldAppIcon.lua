-- https://lua.expert

local MainModule = script:FindFirstAncestor("MainModule")

return require(MainModule.Value.Modules.Objects.Icon).new():setLabel("v2 OLD"):setImage(139559302589584, "deselected"):setImage(90888779036359, "selected"):setImageScale(0.45, "deselected"):setImageScale(0.45, "selected"):autoDeselect(false):setOrder(-1)
