-- https://lua.expert

local StarterGui = game:GetService("StarterGui")

local function ensure() -- line: 3
    -- upvalues: StarterGui (copy)
    local GetCoreGuiEnabled = StarterGui.GetCoreGuiEnabled
    local PlayerList = Enum.CoreGuiType.PlayerList
    local ok, result = pcall(GetCoreGuiEnabled, StarterGui, PlayerList)

    if not ok or result then
        return
    end

    local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled
    local PlayerList2 = Enum.CoreGuiType.PlayerList

    pcall(SetCoreGuiEnabled, StarterGui, PlayerList2, true)
end

for _ = 1, 20 do
    local GetCoreGuiEnabled = StarterGui.GetCoreGuiEnabled
    local PlayerList = Enum.CoreGuiType.PlayerList
    local ok, result = pcall(GetCoreGuiEnabled, StarterGui, PlayerList)

    if ok and not result then
        local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled
        local PlayerList = Enum.CoreGuiType.PlayerList

        pcall(SetCoreGuiEnabled, StarterGui, PlayerList, true)
    end

    task.wait(0.5)
end

while task.wait(2) do
    local GetCoreGuiEnabled = StarterGui.GetCoreGuiEnabled
    local PlayerList = Enum.CoreGuiType.PlayerList
    local ok, result = pcall(GetCoreGuiEnabled, StarterGui, PlayerList)

    if ok and not result then
        local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled
        local PlayerList = Enum.CoreGuiType.PlayerList

        pcall(SetCoreGuiEnabled, StarterGui, PlayerList, true)
    end
end
