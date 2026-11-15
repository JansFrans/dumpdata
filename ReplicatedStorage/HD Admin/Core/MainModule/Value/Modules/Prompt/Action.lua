-- https://lua.expert

local t1 = {
    NumberInput = "Number",
    NumberSlider = "Number",
    ColorPicker = "Color",
    Toggle = "Bool",
    Options = "Options"
}
local t2 = {}
local Players = game:GetService("Players")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Remote = require(Modules.Objects.Remote)
local Prompt = require(Modules.Prompt)
local Log = require(Modules.Log)
local generateUID = require(Modules.DataUtil.generateUID)
local createConnection = require(Modules.AssetUtil.createConnection)
local v1, v2
local t3 = {}

local function audiencePlayer(p1) -- line: 51
    -- upvalues: Players (copy)
    return Players:GetPlayerByUserId(p1.audienceUserId)
end

local function pushState(p2, p3, p4) -- line: 55
    -- upvalues: Players (copy), v2 (ref)
    p3.state = p4

    local PlayerByUserId = Players:GetPlayerByUserId(p3.audienceUserId)

    if PlayerByUserId and v2 then
        v2:fireClient(PlayerByUserId, p2, p4)
    end
end

local function pushButtonLoading(p5, p6, p7) -- line: 63
    -- upvalues: Players (copy), v2 (ref), t3 (copy)
    local v3 = t3[p5]

    if v3 then
        local PlayerByUserId = Players:GetPlayerByUserId(v3.audienceUserId)

        if PlayerByUserId and v2 then
            local v4 = v2

            v4:fireClient(PlayerByUserId, p5, nil, {
                buttonLoading = {
                    [p6] = p7
                }
            })
        end
    end
end

local function close(p8) -- line: 74
    -- upvalues: Players (copy), Prompt (copy), t3 (copy)
    local v5 = t3[p8]

    if not v5 then
        return
    end

    t3[p8] = nil

    if v5.taskRef then
        v5.taskRef.actionPromptId = nil
    end

    local PlayerByUserId = Players:GetPlayerByUserId(v5.audienceUserId)

    if PlayerByUserId then
        Prompt.dismissRaw(PlayerByUserId, p8)
    end
end

local function destroyTaskAndEntry(p9, p10) -- line: 89
    -- upvalues: Modules (copy)
    local entryUID = if typeof(p9.extra) == "table" then p9.extra.entryUID else nil

    p9:destroy()

    if typeof(entryUID) == "string" then
        require(Modules.Parent.Services.Tasks.PermTasks).remove(entryUID, p10)
    end
end

local function ensureControlRemote() -- line: 98
    -- upvalues: Players (copy), Remote (copy), Prompt (copy), Log (copy), v1 (ref), v2 (ref), t3 (copy), pushButtonLoading (copy), destroyTaskAndEntry (copy)
    if v1 then
        return
    end

    v2 = Remote.new("PromptUpdate", "Event", "Low")
    v1 = Remote.new("PromptControl", "Event", "Low")

    if v1 then
        local v6 = v1

        v6:onServerEvent(function(p11, p12, p13, p14, p15) -- line: 109
            -- upvalues: Players (copy), Prompt (copy), Log (copy), v2 (ref), t3 (copy), pushButtonLoading (copy), destroyTaskAndEntry (copy)
            if typeof(p12) ~= "string" then
                return
            end

            local v7 = t3[p12]

            if v7 and p11.UserId == v7.audienceUserId then
                local taskRef = v7.taskRef

                if p13 == "control" and typeof(p14) == "string" then
                    local v8 = v7.controls[p14]

                    if v8 then
                        v8(p15)
                    end
                elseif p13 == "button" and typeof(p14) == "string" then
                    local v9 = v7.buttons[p14]

                    if v9 then
                        task.spawn(function() -- line: 131
                            -- upvalues: p12 (copy), p14 (copy), v9 (copy), Log (copy), pushButtonLoading (copy)
                            pushButtonLoading(p12, p14, true)

                            local ok, result = pcall(v9)

                            pushButtonLoading(p12, p14, false)

                            if not ok then
                                Log.warn((("Prompt button '%*' errored: %*"):format(p14, result)))
                            end
                        end)
                    end
                elseif p13 ~= "iconButton" or typeof(p14) ~= "string" then
                    if p13 == "deactivate" then
                        if taskRef and taskRef.isActive and not taskRef.deactivated then
                            taskRef:deactivate()
                            v7.state = "inactive"

                            local PlayerByUserId = Players:GetPlayerByUserId(v7.audienceUserId)

                            if PlayerByUserId and v2 then
                                v2:fireClient(PlayerByUserId, p12, "inactive")
                            end
                        end
                    elseif p13 == "activate" then
                        if taskRef and taskRef.isActive and taskRef.deactivated then
                            taskRef:reactivate()
                            v7.state = "active"

                            local PlayerByUserId = Players:GetPlayerByUserId(v7.audienceUserId)

                            if PlayerByUserId and v2 then
                                v2:fireClient(PlayerByUserId, p12, "active")
                            end
                        end
                    elseif p13 == "rerun" then
                        if v7.rerunnable and taskRef and taskRef.isActive and not taskRef.deactivated and taskRef.rerunCommand then
                            taskRef:deactivate()
                            taskRef:reactivate()
                        end
                    elseif p13 == "dismiss" then
                        if taskRef and taskRef.isActive and (taskRef.deactivated or v7.endOnClose) then
                            destroyTaskAndEntry(taskRef, "prompt card dismissed")
                        else
                            local v10 = t3[p12]

                            if not v10 then
                                return
                            end

                            t3[p12] = nil

                            if v10.taskRef then
                                v10.taskRef.actionPromptId = nil
                            end

                            local PlayerByUserId = Players:GetPlayerByUserId(v10.audienceUserId)

                            if PlayerByUserId then
                                Prompt.dismissRaw(PlayerByUserId, p12)
                            end
                        end
                    elseif p13 == "end" then
                        local isActive = if taskRef then taskRef.isActive else nil

                        if taskRef and isActive then
                            destroyTaskAndEntry(taskRef, "prompt card end")
                        else
                            local v11 = t3[p12]

                            if not v11 then
                                return
                            end

                            t3[p12] = nil

                            if v11.taskRef then
                                v11.taskRef.actionPromptId = nil
                            end

                            local PlayerByUserId = Players:GetPlayerByUserId(v11.audienceUserId)

                            if PlayerByUserId then
                                Prompt.dismissRaw(PlayerByUserId, p12)
                            end
                        end
                    end
                elseif typeof(p15) == "boolean" then
                    local v12 = v7.iconButtons[p14]

                    if v12 then
                        v12(p15)
                    end
                end
            end
        end)
    end
end

local function sanitiseConfig(p16) -- line: 185
    local t4 = {}

    for v13, v14 in p16 do
        if typeof(v14) ~= "function" and v13 ~= "inputType" then
            t4[v13] = v14
        end
    end

    return t4
end

local function validateThroughArg(p17, p18, p19) -- line: 195
    -- upvalues: Modules (copy)
    local Args = require(Modules.Parser.Args)
    local v15 = if typeof(p18) == "string" and #p18 > 200 then string.sub(p18, 1, 200) else p18
    local unparse = p17.unparse
    local ok, result = pcall(unparse, p17, v15)

    if ok and typeof(result) == "string" then
        local v16 = Args.processStringToParse(result, p17.maxCharacters)
        local parse = p17.parse
        local ok, result2 = pcall(parse, p17, v16, p19, p19)

        if ok then
            return result2
        end
    end

    return nil
end

local function buildIconButtons(p20, p21) -- line: 214
    local t5 = {}

    p20.iconButtons = {}

    if p21.iconButtons then
        for v17, v18 in p21.iconButtons do
            local v19 = "i" .. v17

            p20.iconButtons[v19] = v18.onAction or function() -- line: 220
            end
            table.insert(t5, {
                id = v19,
                component = v18.component,
                active = v18.active == true,
                assetId = v18.assetId,
                emoteName = v18.emoteName,
                animationId = v18.animationId
            })
        end
    end

    return t5
end

function t2.bind(p22, p23) -- line: 236
    -- upvalues: t1 (copy), Players (copy), Modules (copy), Prompt (copy), generateUID (copy), createConnection (copy), v2 (ref), t3 (copy), ensureControlRemote (copy), sanitiseConfig (copy), validateThroughArg (copy), buildIconButtons (copy)
    ensureControlRemote()

    local v20 = p23.audience or p22.target

    if typeof(v20) ~= "Instance" or not v20:IsA("Player") then
        return createConnection(function() -- line: 241
        end)
    end

    local v21 = generateUID(10)
    local t7 = {
        state = "active",
        taskRef = p22,
        configRef = p23,
        audienceUserId = v20.UserId,
        controls = {},
        buttons = {},
        iconButtons = {},
        rerunnable = p23.rerun == true,
        endOnClose = p23.endOnClose == true
    }
    local t8 = {}
    local t9 = {}
    local t10 = {}

    local function addControl(p24, p25, p26) -- line: 259
        -- upvalues: p22 (copy), v21 (copy), t7 (copy), t8 (copy), t1 (copy), Players (copy), Modules (copy), v2 (ref), sanitiseConfig (copy), validateThroughArg (copy)
        local Args = require(Modules.Parser.Args)
        local v23 = "c" .. #t8 + 1
        local inputType, config, value = p25.inputType, p25.config, p25.value
        local v24 = config
        local v25 = value
        local v26 = inputType

        if p24 then
            local v27 = p22:getArgDetail(p24)
            local v28 = v27 and v27.inputObject

            if v28 then
                local v29 = inputType or v28.inputType

                v24 = config or sanitiseConfig(v28)

                if value == nil then
                    v25 = p22:getArg(p24)
                end

                v26 = v29

                if v25 == nil then
                    v25 = v28.default
                end
            end
        end

        local v30
        local v31 = p24 or t1[v26 or ""]
        local v32 = if p24 == nil then v31 and Args.get(v31) else p22:getArgDetail(p24)

        if v32 then
            local v33 = table.clone(v32)

            v30 = v33

            if typeof(v24) == "table" then
                if v24.min ~= nil then
                    v33.min = v24.min
                end

                if v24.max ~= nil then
                    v33.max = v24.max
                end

                if v24.step ~= nil then
                    v33.step = v24.step
                end

                if v24.maxCharacters ~= nil then
                    v33.maxCharacters = v24.maxCharacters
                end
            end
        end

        t7.controls[v23] = function(p27) -- line: 293
            -- upvalues: p24 (copy), p26 (copy), v23 (copy), v30 (ref), p22 (copy), v21 (copy), t7 (copy), Players (copy), Modules (copy), v2 (ref), validateThroughArg (copy)
            if v30 == nil then
                return
            end

            local v34 = p22.targetUserId or p22.callerUserId
            local v35 = validateThroughArg(v30, p27, v34)

            if v35 ~= nil then
                if p24 then
                    local ArgProducts = require(Modules.CommandUtil.ArgProducts)
                    local v36 = p22:getArgDetail(p24)
                    local v37 = ArgProducts.getProducts(v36)

                    if v37 and not ArgProducts.matchesDefault(v36, v35) then
                        local PlayerByUserId = Players:GetPlayerByUserId(t7.audienceUserId)

                        if not PlayerByUserId then
                            return
                        end

                        if not ArgProducts.ownsAnyAsync(PlayerByUserId, v37) then
                            local v38 = require(Modules.Parent.Services.Commands).getCommand(p22.commandKey)
                            local v39 = if v38 then v38.name else p22.commandKey

                            ArgProducts.sendUnlockNoticeAsync(PlayerByUserId, v37, v36, v39)

                            if v2 then
                                v2:fireClient(PlayerByUserId, v21, nil, {
                                    controlValues = {
                                        [v23] = p22:getArg(p24)
                                    }
                                })
                            end

                            return
                        end
                    end
                end

                p26(v35)
            end
        end

        local t11 = {
            id = v23,
            inputType = v26 or "NumberInput"
        }

        t11.config = v24 or {}
        t11.value = v25

        local label = p25.label

        if not label then
            label = if v32 then v32.display or v32.key or tostring(v31) else nil
        end

        t11.label = label
        table.insert(t8, t11)
    end

    if p23.args then
        for _, v41 in p23.args do
            local v42, v43

            if typeof(v41) == "table" then
                v43 = v41
                v42 = v41.arg
            else
                v42 = v41
                v43 = {}
            end

            if v42 then
                local v44 = v42

                addControl(v42, v43, function(p28) -- line: 343
                    -- upvalues: p22 (copy), t7 (copy), v44 (copy)
                    p22:setArg(v44, p28)

                    local configRef = t7.configRef

                    if not p22.deactivated and configRef.onChange then
                        configRef.onChange(v44, p28)
                    end
                end)
            end
        end
    end

    if p23.toggle then
        addControl(nil, {
            inputType = "Toggle",
            value = p23.toggle.value,
            label = p23.toggle.label
        }, function(p29) -- line: 358
            -- upvalues: t7 (copy)
            local toggle = t7.configRef.toggle

            if toggle and toggle.onChange then
                toggle.onChange(p29)
            end
        end)
    end

    if p23.buttons then
        for v45, v46 in p23.buttons do
            local v47 = "b" .. v45

            t7.buttons[v47] = function() -- line: 369
                -- upvalues: t7 (copy), v45 (copy)
                local buttons = t7.configRef.buttons
                local v48 = if typeof(buttons) == "table" then buttons[v45] else nil
                local v49 = v48 and v48.onActivate

                if v49 then
                    v49()
                end
            end

            table.insert(t9, {
                id = v47,
                label = v46.label,
                style = v46.style,
                confirm = v46.confirm == true
            })
        end
    end

    for _, v50 in buildIconButtons(t7, p23) do
        table.insert(t10, v50)
    end

    local v51 = p23.deactivate ~= false
    local rerunnable = t7.rerunnable

    t3[v21] = t7
    p22.actionPromptId = v21

    local v52 = require(Modules.Parent.Services.Commands).getCommand(p22.commandKey)
    local title = p23.title
    local v53, v54

    if title then
        v53 = title
        v54 = true
    elseif v52 then
        local name = v52.name

        if name then
            v53 = name
            v54 = true
        else
            v54 = false
        end
    else
        v54 = false
    end

    if not v54 then
        v53 = p22.commandKey
    end

    if typeof(p23.votePreview) == "table" and p23.votePreview.fromUserId ~= nil then
        Prompt.addUserInfoAsync(p23.votePreview)
    end

    local t13 = {
        state = "active",
        title = v53,
        duration = if typeof(p23.duration) == "number" then p23.duration else 0,
        subtext = p23.subtext,
        votePreview = p23.votePreview,
        controls = t8,
        buttons = t9,
        iconButtons = t10,
        catalogLink = p23.catalogLink,
        toggleable = v51,
        rerun = rerunnable,
        retrieved = p23.retrieved == true
    }

    Prompt.fireRaw(v20, "action", p23.text or "", t13, v21)

    return createConnection(function() -- line: 414
        -- upvalues: v21 (copy), Players (copy), Prompt (copy), t3 (copy)
        local v55 = t3[v21]

        if not v55 then
            return
        end

        t3[v21] = nil

        if v55.taskRef then
            v55.taskRef.actionPromptId = nil
        end

        local PlayerByUserId = Players:GetPlayerByUserId(v55.audienceUserId)

        if PlayerByUserId then
            Prompt.dismissRaw(PlayerByUserId, v21)
        end
    end)
end

function t2.update(p30, p31) -- line: 419
    -- upvalues: Players (copy), v2 (ref), t3 (copy), buildIconButtons (copy)
    local actionPromptId = p30.actionPromptId

    if typeof(actionPromptId) == "string" then
        local v56 = t3[actionPromptId]

        if v56 then
            v56.configRef = p31
            v56.rerunnable = p31.rerun == true
            v56.endOnClose = p31.endOnClose == true

            local v57 = buildIconButtons(v56, p31)
            local PlayerByUserId = Players:GetPlayerByUserId(v56.audienceUserId)

            if PlayerByUserId and v2 then
                v2:fireClient(PlayerByUserId, actionPromptId, nil, {
                    iconButtons = v57
                })
            end
        end
    end
end

function t2.unbind(p32) -- line: 438
    -- upvalues: Players (copy), Prompt (copy), t3 (copy)
    local actionPromptId = p32.actionPromptId

    if typeof(actionPromptId) ~= "string" then
        return
    end

    local v59 = t3[actionPromptId]

    if not v59 then
        return
    end

    t3[actionPromptId] = nil

    if v59.taskRef then
        v59.taskRef.actionPromptId = nil
    end

    local PlayerByUserId = Players:GetPlayerByUserId(v59.audienceUserId)

    if PlayerByUserId then
        Prompt.dismissRaw(PlayerByUserId, actionPromptId)
    end
end

return t2
