-- https://lua.expert

local v1 = ("HD Admin"):gsub(" ", "")
local MainModule = script:FindFirstAncestor("MainModule")
local Value = MainModule.Value
local v2 = Value
local Signal = require(Value.Modules.Objects.Signal)
local v3 = false
local v4 = Signal.new()
local t1 = {}

t1.applicationName = "HD Admin"
t1.appNameClean = v1
t1.serverName = "HD Admin"
t1.serverLocation = "ServerStorage"
t1.sharedName = "HD Admin"
t1.sharedLocation = "ReplicatedStorage"
t1.handshake = nil

local function registerAsLoaded() -- line: 53
    -- upvalues: v3 (ref), v4 (copy)
    if not v3 then
        v3 = true
        v4:Fire()
    end
end

local function convertViewportToFolder(p1) -- line: 60
    if not (p1 and p1:IsA("ViewportFrame")) then
        return nil
    end

    local Model = Instance.new("Model")

    Model.Name = p1.Name

    for _, child in p1:GetChildren() do
        child.Parent = Model
    end

    Model.Parent = p1.Parent
    p1:Destroy()

    return Model
end

local function waitForSharedValue() -- line: 82
    -- upvalues: MainModule (copy)
    local v5 = os.clock() + 10
    local Value

    while true do
        if not (os.clock() < v5) then
            return MainModule:FindFirstChild("Value")
        end

        Value = MainModule:FindFirstChild("Value")

        local ViewportFrame = if Value then Value:IsA("ViewportFrame") else nil

        if not Value or ViewportFrame then
            task.wait()
            continue
        end

        break
    end

    return Value
end

function t1.initialize(p2, p3) -- line: 96
    -- upvalues: t1 (copy), MainModule (copy)
    if script:FindFirstChild("HasStarted") then
        return false
    end

    local ObjectValue = Instance.new("ObjectValue")

    ObjectValue.Value = p2
    ObjectValue.Name = "HasStarted"
    ObjectValue.Parent = script
    t1.handshake = p3

    local Core = p2 and p2:FindFirstChild("Core")

    if Core and MainModule.Parent ~= Core then
        local MainModule2 = Core:FindFirstChild("MainModule")

        if MainModule2 and MainModule2 ~= MainModule then
            MainModule2:Destroy()
        end

        MainModule.Parent = Core
    end

    t1.startServer()

    return true
end

function t1.waitUntilLoaded() -- line: 123
    -- upvalues: v3 (ref), v4 (copy)
    if not v3 then
        v4:Wait()
    end
end

function t1.getLoader() -- line: 130
    local HasStarted = script:FindFirstChild("HasStarted")

    return if HasStarted then HasStarted.Value else nil
end

function t1.getSharedContainer() -- line: 138
    -- upvalues: t1 (copy)
    return (game:GetService(t1.sharedLocation):FindFirstChild(t1.sharedName))
end

function t1.getSharedValue() -- line: 144
    -- upvalues: t1 (copy)
    local v6 = t1.getSharedContainer()

    if v6 then
        return v6.Core.MainModule:FindFirstChild("Value")
    end

    return nil
end

function t1.getServerContainer() -- line: 152
    -- upvalues: t1 (copy)
    return (game:GetService(t1.serverLocation):FindFirstChild(t1.serverName))
end

function t1.getServerValue() -- line: 158
    -- upvalues: t1 (copy)
    local v7 = t1.getServerContainer()

    if v7 then
        return v7.Core.MainModule:FindFirstChild("Value")
    end

    return nil
end

function t1.getServerModules() -- line: 166
    -- upvalues: t1 (copy)
    local v8 = t1.getServerValue()

    return if v8 then v8.Modules else nil
end

function t1.getInstance(p4, p5) -- line: 174
    -- upvalues: t1 (copy)
    if not (p4 and p4:IsA("Instance")) then
        return nil
    end

    local v9 = p4:FindFirstChild(p5)

    if v9 then
        return v9
    end

    if game:GetService("RunService"):IsClient() then
        return nil
    end

    local v10 = t1.getSharedContainer()

    if not v10 then
        return nil
    end

    local t2 = {}
    local v11 = t1.getServerContainer()

    if not v11 then
        return nil
    end

    local v12 = p4

    for _ = 1, 100 do
        table.insert(t2, v12.Name)
        v12 = v12.Parent

        if v12 == nil or v12 == v11 or v12 == v10 then
            break
        end
    end

    if v12 ~= v10 then
        v11 = v10
    end

    local function getNextPart(p6) -- line: 223
        -- upvalues: t2 (copy)
        local v13 = #t2
        local v14 = p6

        for i = v13, 1, -1 do
            v14 = v14:FindFirstChild(t2[i])

            if not v14 then
                return nil
            end
        end

        return v14
    end

    local v15 = #t2
    local v16 = false
    local v17

    for i = v15, 1, -1 do
        local v18 = v11:FindFirstChild(t2[i])

        if not v18 then
            v17 = nil
            v16 = true
            break
        end

        v11 = v18
    end

    if not v16 then
        v17 = v11
    end

    local function checkChildren(p7) -- line: 234
        -- upvalues: p5 (copy), checkChildren (copy)
        if not p7 or not p7:IsA("Instance") then
            return nil
        end

        local v19 = p7:FindFirstChild(p5)

        if v19 then
            return v19
        end

        for _, child in p7:GetChildren() do
            if child:IsA("ModuleScript") or child:IsA("Folder") or child:IsA("Configuration") then
                local v20 = checkChildren(child)

                if v20 then
                    return v20
                end
            end
        end

        return nil
    end

    return (checkChildren(v17))
end

function t1.canStart() -- line: 255
    local v21 = script:WaitForChild("HasStarted", 999)

    if not v21 or v21.Value == false then
        return false, "Another HD Admin was initialized"
    end

    return true
end

function t1.requireChildren(p8) -- line: 267
    for _, child in p8:GetChildren() do
        if child:IsA("ModuleScript") then
            task.spawn(require, child)
        end
    end
end

function t1.startClient() -- line: 275
    -- upvalues: t1 (copy), v2 (ref), v3 (ref), v4 (copy), waitForSharedValue (copy)
    if t1.canStart() == false then
        return
    end

    local v22 = waitForSharedValue()

    if v22 then
        v2 = v22

        local function destroyServerOnlyInstances(p9) -- line: 289
            -- upvalues: destroyServerOnlyInstances (copy)
            for _, child in p9:GetChildren() do
                if not child:GetAttribute("ServerOnly") or child:GetAttribute("HasSharedDescendant") == true then
                    destroyServerOnlyInstances(child)
                else
                    child:Destroy()
                end
            end
        end

        destroyServerOnlyInstances(v22)
        t1.requireChildren(v22.Controllers)

        if not v3 then
            v3 = true
            v4:Fire()
        end
    end
end

function t1.startServer() -- line: 306
    -- upvalues: t1 (copy), MainModule (copy), v2 (ref), v3 (ref), v4 (copy), convertViewportToFolder (copy)
    if t1.canStart() == false then
        return
    end

    local Modules = v2.Modules
    local v23 = t1.getLoader()
    local Config = v23:FindFirstChild("Config")

    v2 = convertViewportToFolder(v2)

    if Config then
        for _, child in Config:GetChildren() do
            convertViewportToFolder(child)
        end
    end

    local function createContainer(p10, p11) -- line: 324
        local Folder = Instance.new("Folder")
        local Service = game:GetService(p11)

        for _, child in Service:GetChildren() do
            if child.Name == p10 then
                child.Parent = nil
            end
        end

        Folder.Name = p10
        Folder.Parent = Service

        local Folder2 = Instance.new("Folder")

        Folder2.Name = "Core"
        Folder2.Parent = Folder

        local Folder3 = Instance.new("Folder")

        Folder3.Name = "Config"
        Folder3.Parent = Folder

        return Folder
    end

    local v24 = createContainer(t1.serverName, t1.serverLocation)
    local ObjectValue = Instance.new("ObjectValue")

    ObjectValue.Name = MainModule.Name
    ObjectValue.Value = v2
    ObjectValue.Parent = v24.Core

    local v25 = createContainer(t1.sharedName, t1.sharedLocation)
    local Framework = Modules.Framework
    local ModuleReference, ReferenceBack, ReferenceBackConfig, ReferenceBackClientAPI = Framework.ModuleReference, Framework.ReferenceBack, Framework.ReferenceBackConfig, Framework.ReferenceBackClientAPI
    local ReferenceBackServerAPI, ReferenceBackCommandAPI, EmptyFunction = Framework.ReferenceBackServerAPI, Framework.ReferenceBackCommandAPI, Framework.EmptyFunction
    local Config2 = Modules.Parent.Services.Config

    for v26, _ in require(Config2).getAccessible() do
        local v27 = Config and Config:FindFirstChild(v26)
        local Config3 = v25.Config

        if v27 then
            if v27:IsA("ModuleScript") then
                local Config = v24.Config
                local clone = ReferenceBackConfig:Clone()
                local clone2 = ReferenceBackConfig:Clone()

                clone.Name = v26
                clone2.Name = v26
                clone.Parent = Config
                clone2.Parent = Config3
                v27:SetAttribute("Client", true)
            else
                v27.Parent = Config3
            end
        else
            local Config4 = v24.Config
            local clone = ReferenceBackConfig:Clone()
            local clone2 = ReferenceBackConfig:Clone()

            clone.Name = v26
            clone2.Name = v26
            clone.Parent = Config4
            clone2.Parent = Config3
            v27 = EmptyFunction:Clone()
            v27.Name = v26
            v27.Parent = Config or Config2
            v27:SetAttribute("Client", true)
        end
    end

    local function labelAsForClient(p12) -- line: 398
        if p12:IsA("ModuleScript") and p12.Name:lower() == "client" then
            p12:SetAttribute("Client", true)
        end
    end

    local Commands = Config and Config:FindFirstChild("Commands")

    if Commands then
        local Commands2 = v2.Services.Commands

        local function moveChildrenToCoreCommands(p13, p14) -- line: 410
            -- upvalues: moveChildrenToCoreCommands (copy)
            for _, child in p13:GetChildren() do
                if child:IsA("ModuleScript") then
                    for _, child in child:GetChildren() do
                        if child:IsA("ModuleScript") and child.Name:lower() == "client" then
                            child:SetAttribute("Client", true)
                        end
                    end

                    child.Parent = p14
                else
                    local Folder = Instance.new("Folder")

                    Folder.Name = child.Name
                    Folder.Parent = p14
                    moveChildrenToCoreCommands(child, Folder)
                end
            end
        end

        moveChildrenToCoreCommands(Commands, Commands2)
    end

    for _, descendant in Modules.Internal.Commands:GetDescendants() do
        if descendant:IsA("ModuleScript") and descendant.Name:lower() == "client" then
            descendant:SetAttribute("Client", true)
        end
    end

    if Config then
        for _, child in Config:GetChildren() do
            local v28 = Config2:FindFirstChild(child.Name)

            if child:IsA("ModuleScript") then
                if v28 then
                    local v29 = require(v28)
                    local v30 = require(child)

                    local function mergeTablesRecursively(p15, p16) -- line: 481
                        -- upvalues: mergeTablesRecursively (copy)
                        for v31, v32 in p16 do
                            if type(v32) == "table" then
                                if type(p15[v31]) == "table" then
                                    mergeTablesRecursively(p15[v31], v32)
                                else
                                    p15[v31] = v32
                                end
                            else
                                p15[v31] = v32
                            end
                        end
                    end

                    mergeTablesRecursively(v29, v30)
                else
                    child.Parent = Config2
                end
            else
                if v28 then
                    v28:Destroy()
                end

                child.Parent = Config2
            end
        end

        Config:Destroy()
    end

    local function getServerParentFromPathway(p17) -- line: 502
        -- upvalues: ObjectValue (copy), ModuleReference (copy), ReferenceBack (copy), MainModule (copy)
        local v34 = ObjectValue
        local v35 = MainModule
        local n1 = 0
        local v36 = MainModule

        for v37, v38 in p17 do
            v36 = v36:FindFirstChild(v38.Name)

            if not v36 then
                break
            end

            if v36:GetAttribute("Server") == true and v36:IsA("ModuleScript") then
                n1 = v37
            end
        end

        local v39 = #p17
        local v40 = ObjectValue

        for v41, v42 in p17 do
            local v43 = v35:FindFirstChild(v42.Name)

            if not v43 then
                v34 = v40
                break
            end

            local v44 = v40:FindFirstChild(v43.Name)

            if v44 then
                v40 = v44
                v35 = v43
            else
                local ModuleScript = v43:IsA("ModuleScript")
                local HasSharedDescendant = v43:GetAttribute("HasSharedDescendant")
                local v45 = v43

                if not (n1 <= v41) or v41 == v39 then
                    if ModuleScript then
                        if v43:GetAttribute("Server") ~= true or v43:GetAttribute("Client") == true then
                            v45 = ReferenceBack:Clone()
                            v45:SetAttribute("HasSharedDescendant", HasSharedDescendant)
                            v45.Name = v43.Name
                            v45.Parent = v35
                            v35 = v43
                        else
                            local clone = ModuleReference:Clone()

                            clone:SetAttribute("HasSharedDescendant", HasSharedDescendant)
                            clone:SetAttribute("ServerOnly", true)
                            clone.Name = v43.Name
                            clone.Parent = v35

                            for _, child in v43:GetChildren() do
                                if child:IsA("ModuleScript") or child:IsA("Folder") or child:IsA("Configuration") then
                                    child.Parent = clone
                                end
                            end

                            v35 = clone
                        end
                    else
                        v35 = v43
                        v45 = Instance.new("Folder")
                        v45.Name = v43.Name
                    end
                else
                    v35 = nil
                end

                v45.Parent = v40
                v40 = v45
            end

            if not v35 then
                v34 = v40
                break
            end

            v34 = v40
        end

        return v34
    end

    local deepCopyTable = require(Modules.TableUtil.deepCopyTable)

    local function setNewParentFromPathway(p18, p19) -- line: 571
        -- upvalues: getServerParentFromPathway (copy), deepCopyTable (copy)
        local v46 = deepCopyTable(p19)

        table.insert(v46, p18)
        getServerParentFromPathway(v46)
    end

    local function checkToMoveChildren(p20, p21, p22) -- line: 579
        -- upvalues: getServerParentFromPathway (copy), deepCopyTable (copy), checkToMoveChildren (copy)
        local v47 = deepCopyTable(p21)

        table.insert(v47, p20)

        for _, child in p20:GetChildren() do
            if child:IsA("ModuleScript") or child:IsA("Folder") or child:IsA("Configuration") then
                local v48 = child:GetAttribute("Server") == true
                local v49 = p22 or v48

                if child:GetAttribute("Client") == true then
                    local v50 = child

                    v49 = nil

                    for _ = 1, 100 do
                        v50 = v50.Parent

                        if not v50 or v50.Name == "Modules" then
                            v49 = nil
                            break
                        end

                        if v50:GetAttribute("HasSharedDescendant") ~= true then
                            v50:SetAttribute("HasSharedDescendant", true)
                        end
                    end
                end

                if v49 and not v48 then
                    child:SetAttribute("Server", true)
                end

                checkToMoveChildren(child, v47, v49)

                if v49 then
                    local v51 = deepCopyTable(v47)

                    table.insert(v51, child)
                    getServerParentFromPathway(v51)
                end
            end
        end
    end

    checkToMoveChildren(v2, {})
    MainModule.Parent = v25.Core

    local function insertLoadedMarker(p23) -- line: 621
        local BoolValue = Instance.new("BoolValue")

        BoolValue.Value = true
        BoolValue.Name = "Loaded"
        BoolValue.Parent = p23
    end

    local CommandAPI = v23.Core.CommandAPI
    local clone = ReferenceBackCommandAPI:Clone()

    clone.Name = "CommandAPI"
    clone.Parent = v23.Core

    local clone2 = ReferenceBackCommandAPI:Clone()

    clone2.Name = "CommandAPI"
    clone2.Parent = v24.Core
    CommandAPI.Parent = v25.Core

    local BoolValue = Instance.new("BoolValue")

    BoolValue.Value = true
    BoolValue.Name = "Loaded"
    BoolValue.Parent = CommandAPI
    t1.requireChildren(v2.Services)

    local ClientAPI = v23.Core.ClientAPI
    local clone3 = ReferenceBackClientAPI:Clone()

    clone3.Name = "ClientAPI"
    clone3.Parent = v23.Core
    ClientAPI.Parent = v25.Core

    local ServerAPI = v23.Core.ServerAPI
    local clone4 = ReferenceBackServerAPI:Clone()

    clone4.Name = "ServerAPI"
    clone4.Parent = v23.Core
    ServerAPI.Parent = v24.Core

    local clone5 = ReferenceBackServerAPI:Clone()

    clone5.Name = "ServerAPI"
    clone5.Parent = v25.Core

    local BoolValue2 = Instance.new("BoolValue")

    BoolValue2.Value = true
    BoolValue2.Name = "Loaded"
    BoolValue2.Parent = ClientAPI

    local BoolValue3 = Instance.new("BoolValue")

    BoolValue3.Value = true
    BoolValue3.Name = "Loaded"
    BoolValue3.Parent = ServerAPI

    if not v3 then
        v3 = true
        v4:Fire()
    end
end

return t1
