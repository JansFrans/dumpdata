-- https://lua.expert

local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local KeyboardEnabled = game:GetService("UserInputService").KeyboardEnabled
local t1 = {
    kind = "exit",
    text = "",
    display = KeyboardEnabled and "Exit <font color=\"#8a8f98\">(press <font weight=\"Heavy\"><b>;</b></font> or <font weight=\"Heavy\"><b>'</b></font> to re-open)</font>" or "Exit",
    rich = KeyboardEnabled
}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Children = Fusion.Children
local CmdbarField = require(UI.Components.CmdbarField)
local CmdbarList = require(UI.Components.CmdbarList)
local Segmenter = require(UI.Util.Cmdbar.Segmenter)
local Resolver = require(UI.Util.Cmdbar.Resolver)
local Ranker = require(UI.Util.Cmdbar.Ranker)
local Candidates = require(UI.Util.Cmdbar.Candidates)
local Recents = require(UI.Util.Cmdbar.Recents)
local ModifierUtil = require(UI.Util.Cmdbar.ModifierUtil)
local CommandAccess = require(UI.Util.CommandAccess)
local Icons = require(UI.Config.Icons)
local Args = require(Modules.Parser.Args)
local isValidPrefix = require(Modules.CommandUtil.isValidPrefix)
local getGameSetting = require(Modules.CommandUtil.getGameSetting)
local SendMessage = require(Modules.Objects.Remote).get("SendMessage")

local function trimText(p1) -- line: 51
    return (p1:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function ensurePrefixed(p2, p3) -- line: 55
    -- upvalues: isValidPrefix (copy)
    if isValidPrefix(p2:sub(1, 1)) then
        return p2
    end

    return p3 .. p2
end

local function buildSignature(p4, p5, p6) -- line: 62
    -- upvalues: ModifierUtil (copy), Args (copy)
    local t2 = {}

    if p6 and #p6 > 0 then
        table.insert(t2, table.concat(p6, " "))
    end

    table.insert(t2, p4.name or "?")

    local v2 = ModifierUtil.effectiveArgs(p4, p6 or {})

    if typeof(v2) == "table" then
        for v3, v4 in v2 do
            local v5 = Args.get(v4)
            local v6 = if v5 then v5.display or v5.key else nil

            if typeof(v6) ~= "string" then
                v6 = if typeof(v4) == "string" then v4 else "arg"
            end

            local v7

            if v5 then
                if typeof(v5.inputObject) == "table" then
                    local inputObject = v5.inputObject

                    v7 = if inputObject.inputType ~= "NumberInput" then ""
                        elseif typeof(inputObject.min) ~= "number" then ""
                        elseif typeof(inputObject.max) == "number" then (" %*-%*"):format(inputObject.min, inputObject.max)
                        else ""
                else
                    v7 = ""
                end
            else
                v7 = ""
            end

            local v8 = "<" .. tostring(v6):lower() .. v7 .. ">"

            if v3 == p5 then
                v8 = "[ " .. v8 .. " ]"
            end

            table.insert(t2, v8)
        end
    end

    return table.concat(t2, " ")
end

local function decorate(p7) -- line: 93
    -- upvalues: Icons (copy)
    local kind = p7.kind

    if kind == "player" then
        return p7.image, true
    end

    if kind == "qualifier" then
        return Icons.PersonTagFill, false
    end

    if kind == "modifier" then
        return Icons.ZapFill, false
    end

    if kind == "recent" then
        return Icons.RecentCalendarFill, false
    end

    if kind == "exit" then
        return Icons.Close, false
    end

    if kind == "duration" then
        return Icons.HourglassHalfOutline, false
    end

    return nil, false
end

local function isCompleteToken(p8, p9) -- line: 111
    if typeof(p8) ~= "table" then
        return false
    end

    local v9 = p9:lower()

    if typeof(p8.text) == "string" and p8.text:lower() == v9 then
        return true
    end

    if typeof(p8.keys) == "table" then
        for _, v10 in p8.keys do
            if typeof(v10) == "string" and v10:lower() == v9 then
                return true
            end
        end
    end

    return false
end

local function buildRows(p10) -- line: 129
    -- upvalues: Icons (copy)
    local t3 = {}

    for v11, v12 in p10 do
        local kind = v12.kind
        local v13, v14

        if kind == "player" then
            v13 = v12.image
            v14 = true
        else
            if kind == "qualifier" then
                v13 = Icons.PersonTagFill
            elseif kind == "modifier" then
                v13 = Icons.ZapFill
            elseif kind == "recent" then
                v13 = Icons.RecentCalendarFill
            elseif kind == "exit" then
                v13 = Icons.Close
            elseif kind == "duration" then
                v13 = Icons.HourglassHalfOutline
            end

            v14 = false
        end

        t3[v11] = {
            index = v11,
            display = v12.display or v12.text,
            description = v12.description,
            image = v13,
            imageRounded = v14,
            swatch = v12.swatch,
            rich = v12.rich == true,
            locked = v12.locked == true,
            showUnlock = v12.runState ~= nil and v12.runState.unlockState == "unlock"
        }
    end

    return t3
end

local function escapeRich(p11) -- line: 149
    return (p11:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function annotateAliases(p12, p13) -- line: 154
    -- upvalues: Ranker (copy)
    for v15, v16 in p12 do
        if typeof(v16.keyLabels) == "table" then
            local v17 = Ranker.aliasHit(p13, v16.keys)

            if v17 ~= nil then
                local v18 = v16.keyLabels[v17] or v17
                local v19 = if typeof(v16.display) == "string" then v16.display else v18
                local v20 = table.clone(v16)

                v20.display = v18:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. " <font color=\"#8a8f98\">(alias of " .. v19:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. ")</font>"
                v20.insert = v17
                v20.rich = true
                p12[v15] = v20
            end
        end
    end

    return p12
end

return function(p14, p15) -- line: 176
    -- upvalues: RunService (copy), StarterGui (copy), t1 (copy), Fusion (copy), Children (copy), CmdbarField (copy), CmdbarList (copy), Segmenter (copy), Resolver (copy), Ranker (copy), Candidates (copy), Recents (copy), ModifierUtil (copy), CommandAccess (copy), Args (copy), isValidPrefix (copy), getGameSetting (copy), SendMessage (copy), buildSignature (copy), isCompleteToken (copy), buildRows (copy), annotateAliases (copy)
    local v21 = false

    table.insert(p14, function() -- line: 178
        -- upvalues: v21 (ref)
        v21 = true
    end)

    local v23 = ";"

    task.spawn(function() -- line: 183
        -- upvalues: v21 (ref), v23 (ref), getGameSetting (copy)
        local Prefix = getGameSetting("Prefix")

        if not v21 and typeof(Prefix) == "string" and #Prefix > 0 then
            v23 = Prefix
        end
    end)

    local v24 = p14:Value("")
    local v25 = p14:Value(-1)
    local v26 = p14:Value(1)
    local v27 = p14:Value(false)
    local v28 = p14:Value(nil)
    local v29 = p14:Value(1)
    local v30 = p14:Value(0)
    local v31 = p14:Value(false)
    local CommandInfo = p14:Fuse("everyone", "CommandInfo")
    local YouMember = p14:Fuse("temp", "YouMember")
    local RoleInfo = p14:Fuse("everyone", "RoleInfo")
    local RecentCommands = p14:Fuse("perm", "RecentCommands")
    local v32 = p14:Fuse("perm", { "YouSettings", "Prefix" })

    local function currentPrefix() -- line: 205
        -- upvalues: v23 (ref), v32 (copy), Fusion (copy)
        local v33 = Fusion.peek(v32)

        if typeof(v33) == "string" and #v33 > 0 then
            return v33
        end

        if typeof(v23) ~= "string" or not (#v23 > 0) then
            return ";"
        end

        return v23
    end

    local v35 = p14:Computed(function(p16) -- line: 216
        -- upvalues: v25 (copy), v26 (copy)
        local v36 = p16(v25)

        if v36 >= 1 then
            return v36
        end

        return (p16(v26))
    end)
    local v37 = p14:Computed(function(p17) -- line: 221
        -- upvalues: v24 (copy), Segmenter (copy)
        return Segmenter.scan(p17(v24))
    end)
    local v38 = p14:Computed(function(p18) -- line: 224
        -- upvalues: v24 (copy), v35 (copy), v37 (copy), Resolver (copy)
        return Resolver.resolve(p18(v37), p18(v35), p18(v24))
    end)
    local v39 = p14:Computed(function(p19) -- line: 227
        -- upvalues: RecentCommands (copy), Recents (copy)
        return Recents.rows(p19(RecentCommands))
    end)
    local v40 = p14:Computed(function(p20) -- line: 231
        -- upvalues: CommandInfo (copy), YouMember (copy), RoleInfo (copy), CommandAccess (copy)
        local v41 = p20(CommandInfo)
        local v42 = p20(YouMember)
        local v43 = p20(RoleInfo)
        local t5 = {}
        local t6 = {}
        local t7 = {}

        if typeof(v41) == "table" then
            local t8 = {}

            for _, v44 in v41 do
                if typeof(v44) == "table" then
                    table.insert(t8, v44)
                end
            end

            for _, v45 in (CommandAccess.buildViewable(t8, v42, v43)) do
                local v46 = CommandAccess.runState(v45, v42, v43)
                local t9 = {}
                local t10 = {}
                local name = v45.name

                if typeof(name) == "string" and name ~= "" then
                    local v47 = name:lower()

                    table.insert(t9, v47)
                    t10[v47] = name
                    t5[v47] = v45
                end

                if typeof(v45.aliases) == "table" then
                    for _, v48 in v45.aliases do
                        if typeof(v48) == "string" and v48 ~= "" then
                            local v49 = v48:lower()

                            table.insert(t9, v49)
                            t10[v49] = v48
                            t5[v49] = v45
                        end
                    end
                end

                if typeof(v45.undoAliases) == "table" then
                    for _, v50 in v45.undoAliases do
                        if typeof(v50) == "string" and v50 ~= "" then
                            local v51 = v50:lower()

                            table.insert(t9, v51)
                            t10[v51] = v50
                            t5[v51] = v45
                        end
                    end
                end

                for _, v52 in t9 do
                    table.insert(t6, v52)
                end

                if v45.hide ~= true then
                    local name

                    if typeof(v43) == "table" and typeof(v45.primaryRole) == "string" then
                        local v53 = v43[v45.primaryRole]

                        if typeof(v53) == "table" then
                            name = v53.name
                        end
                    end

                    table.insert(t7, {
                        kind = "command",
                        keys = t9,
                        keyLabels = t10,
                        text = (v45.name or ""):lower(),
                        insert = (v45.name or ""):lower(),
                        display = v45.name,
                        command = v45,
                        locked = not v46.usable,
                        runState = v46,
                        description = name
                    })
                end
            end
        end

        return {
            byKey = t5,
            names = t6,
            commandCandidates = t7
        }
    end)
    local v54 = p14:Computed(function(p21) -- line: 302
        -- upvalues: v30 (copy), v31 (copy), v37 (copy), v38 (copy), v39 (copy), v40 (copy), t1 (copy), Ranker (copy), Candidates (copy), ModifierUtil (copy), Args (copy), buildSignature (copy), isCompleteToken (copy), buildRows (copy), annotateAliases (copy)
        p21(v30)

        local v55 = p21(v38)
        local v56 = p21(v40)
        local v57 = {}
        local v58

        if v55.kind == "command" then
            if v55.query == "" then
                v57 = {
                    t1
                }
                v58 = ""

                for _, v59 in Ranker.rank("", p21(v39), {
                        maxResults = 7
                    }) do
                    table.insert(v57, v59)
                end
            else
                local commandCandidates = v56.commandCandidates
                local v60 = ModifierUtil.expand(v55.query, commandCandidates)
                local v61 = ModifierUtil.modifierCandidates(v55.query)

                if #v60 > 0 or #v61 > 0 then
                    commandCandidates = table.clone(commandCandidates)

                    for _, v62 in v60 do
                        table.insert(commandCandidates, v62)
                    end

                    for _, v63 in v61 do
                        table.insert(commandCandidates, v63)
                    end
                end

                v57 = annotateAliases(Ranker.rank(v55.query, commandCandidates, {
                    maxResults = 8
                }), v55.query)
                v58 = ""
            end
        elseif v55.kind == "capsuleArg" then
            local commandText = p21(v37).commandText
            local v65, v66 = ModifierUtil.resolve(if typeof(commandText) ~= "string" then "" else commandText, v56.byKey)

            if v65 then
                v58 = buildSignature(v65, nil, v66)

                local v67 = ModifierUtil.capsuleArgs(v65)[v55.argIndex or 1]

                if v67 ~= nil then
                    local v68 = Args.get(v67)

                    if v68 then
                        v57 = Ranker.rank(v55.query, Candidates.forArg(v68), {
                            maxResults = 8
                        })
                    end
                end
            else
                v58 = ""
            end
        else
            local commandText = p21(v37).commandText
            local v69, v70 = ModifierUtil.resolve(if typeof(commandText) ~= "string" then "" else commandText, v56.byKey)

            if v69 then
                v58 = buildSignature(v69, v55.argIndex, v70)

                local v71 = ModifierUtil.effectiveArgs(v69, v70)[v55.argIndex]

                if v71 ~= nil then
                    local v72 = Args.get(v71)

                    if v72 then
                        v57 = Ranker.rank(v55.query, Candidates.forArg(v72), {
                            maxResults = 8
                        })
                    end
                end
            else
                v58 = ""
            end
        end

        if p21(v31) and v55.query ~= "" and #v57 > 0 and isCompleteToken(v57[1], v55.query) then
            v57 = {}
        end

        return {
            candidates = v57,
            rows = buildRows(v57),
            signature = v58
        }
    end)
    local v73 = p14:Computed(function(p22) -- line: 369
        -- upvalues: v54 (copy)
        return p22(v54).rows
    end)
    local v74 = p14:Computed(function(p23) -- line: 372
        -- upvalues: v54 (copy)
        return p23(v54).signature
    end)
    local v75 = p14:Computed(function(p24) -- line: 375
        -- upvalues: p15 (copy), v73 (copy)
        return p24(p15.visible) and #p24(v73) > 0
    end)

    p14:Observer(v25):onChange(function() -- line: 379
        -- upvalues: v21 (ref), v25 (copy), v26 (copy), Fusion (copy)
        if not v21 then
            local v76 = Fusion.peek(v25)

            if v76 >= 1 then
                v26:set(v76)
            end
        end
    end)
    p14:Observer(v54):onChange(function() -- line: 389
        -- upvalues: v21 (ref), v29 (copy)
        if not v21 then
            v29:set(1)
        end
    end)
    p14:Observer(v38):onChange(function() -- line: 395
        -- upvalues: v21 (ref), v30 (copy), v37 (copy), v38 (copy), v40 (copy), Fusion (copy), Candidates (copy), ModifierUtil (copy), Args (copy)
        if v21 then
            return
        end

        local v77 = Fusion.peek(v38)

        if v77.kind == "arg" then
            local commandText = Fusion.peek(v37).commandText
            local v78 = Fusion.peek(v40)
            local v79, v80 = ModifierUtil.resolve(if typeof(commandText) ~= "string" then "" else commandText, v78.byKey)

            if v79 then
                local v81 = ModifierUtil.effectiveArgs(v79, v80)[v77.argIndex]

                if v81 ~= nil then
                    local v82 = Args.get(v81)

                    if v82 and Candidates.needsPicker(v82) then
                        Candidates.ensurePicker(v82, function() -- line: 415
                            -- upvalues: v21 (ref), v30 (copy), Fusion (copy)
                            if not v21 then
                                v30:set(Fusion.peek(v30) + 1)
                            end
                        end)
                    end
                end
            end
        end
    end)

    local function refocus() -- line: 424
        -- upvalues: p15 (copy), v21 (ref), v28 (copy), RunService (copy), Fusion (copy)
        task.spawn(function() -- line: 425
            -- upvalues: p15 (copy), v21 (ref), v28 (copy), RunService (copy), Fusion (copy)
            RunService.Heartbeat:Wait()

            if not v21 then
                local v83 = Fusion.peek(v28)

                if v83 and Fusion.peek(p15.visible) then
                    v83:CaptureFocus()
                end
            end
        end)
    end

    local function setCursor(p25) -- line: 438
        -- upvalues: v21 (ref), v25 (copy), v26 (copy), v28 (copy), Fusion (copy)
        task.defer(function() -- line: 439
            -- upvalues: p25 (copy), v21 (ref), v25 (copy), v26 (copy), v28 (copy), Fusion (copy)
            if v21 then
                return
            end

            local v84 = Fusion.peek(v28)

            if v84 then
                v84.CursorPosition = p25
            end

            v25:set(p25)
            v26:set((math.max(p25, 1)))
        end)
    end

    local function resetToPrefix() -- line: 452
        -- upvalues: v23 (ref), v24 (copy), v29 (copy), v32 (copy), Fusion (copy)
        local v85 = Fusion.peek(v32)

        if typeof(v85) ~= "string" or not (#v85 > 0) then
            v85 = if typeof(v23) ~= "string" or not (#v23 > 0) then ";" else v23
        end

        v24:set(v85)
        v29:set(1)
    end

    local function acceptSelected(p26) -- line: 457
        -- upvalues: p15 (copy), v21 (ref), v24 (copy), v25 (copy), v26 (copy), v28 (copy), v29 (copy), v37 (copy), v38 (copy), v40 (copy), v54 (copy), RunService (copy), Fusion (copy), Resolver (copy), ModifierUtil (copy)
        local v87 = Fusion.peek(v54).candidates[Fusion.peek(v29)]

        if v87 then
            if v87.kind == "exit" then
                p15.visible:set(false)
            else
                if v87.kind == "recent" then
                    v24:set(v87.text)

                    local v88 = #v87.text + 1

                    task.defer(function() -- line: 439
                        -- upvalues: v88 (copy), v21 (ref), v25 (copy), v26 (copy), v28 (copy), Fusion (copy)
                        if v21 then
                            return
                        end

                        local v89 = Fusion.peek(v28)

                        if v89 then
                            v89.CursorPosition = v88
                        end

                        v25:set(v88)
                        v26:set((math.max(v88, 1)))
                    end)
                else
                    local v90 = Fusion.peek(v38)
                    local v91 = v90.kind == "capsuleArg"
                    local v92 = p26 and v87.advance ~= false and not v91
                    local v93, v94 = Resolver.apply(Fusion.peek(v24), v90, v87.insert, v92, v87.caretBack)
                    local v95, v96

                    if v91 then
                        local commandText = Fusion.peek(v37).commandText
                        local v97 = ModifierUtil.resolve(if typeof(commandText) ~= "string" then "" else commandText, Fusion.peek(v40).byKey)

                        if (if v97 then #ModifierUtil.capsuleArgs(v97) else 1) > (v90.argIndex or 1) then
                            v95 = v93:sub(1, v94 - 1) .. "," .. v93:sub(v94)
                            v96 = v94 + 1
                        else
                            local v99 = if v93:sub(v94, v94) == ")" then v93 else v93:sub(1, v94 - 1) .. ")" .. v93:sub(v94)
                            local v98 = v94 + 1

                            v95 = if v99:sub(v98, v98) == " " then v99 else v99:sub(1, v98 - 1) .. " " .. v99:sub(v98)
                            v96 = v98 + 1
                        end
                    else
                        v95 = v93
                        v96 = v94
                    end

                    v24:set(v95)
                    task.defer(function() -- line: 439
                        -- upvalues: v96 (ref), v21 (ref), v25 (copy), v26 (copy), v28 (copy), Fusion (copy)
                        if v21 then
                            return
                        end

                        local v100 = Fusion.peek(v28)

                        if v100 then
                            v100.CursorPosition = v96
                        end

                        v25:set(v96)
                        v26:set((math.max(v96, 1)))
                    end)
                end

                task.spawn(function() -- line: 425
                    -- upvalues: p15 (copy), v21 (ref), v28 (copy), RunService (copy), Fusion (copy)
                    RunService.Heartbeat:Wait()

                    if not v21 then
                        local v101 = Fusion.peek(v28)

                        if v101 and Fusion.peek(p15.visible) then
                            v101:CaptureFocus()
                        end
                    end
                end)
            end
        end
    end

    local function navigate(p27) -- line: 506
        -- upvalues: v29 (copy), v73 (copy), Fusion (copy)
        local v102 = #Fusion.peek(v73)

        if v102 == 0 then
            return
        end

        local v103 = Fusion.peek(v29) + p27

        if not (v103 < 1) then
            v102 = if v102 < v103 then 1 else v103
        end

        v29:set(v102)
    end

    local function dispatch(p28) -- line: 520
        -- upvalues: p15 (copy), v23 (ref), v32 (copy), Fusion (copy), isValidPrefix (copy), SendMessage (copy)
        local v104 = p28:gsub("^%s+", ""):gsub("%s+$", "")

        if #v104 ~= 0 and (#v104 ~= 1 or not isValidPrefix(v104)) then
            local v105 = Fusion.peek(v32)

            if typeof(v105) ~= "string" or not (#v105 > 0) then
                v105 = if typeof(v23) ~= "string" or not (#v23 > 0) then ";" else v23
            end

            if not isValidPrefix(v104:sub(1, 1)) then
                v104 = v105 .. v104
            end

            task.spawn(function() -- line: 529
                -- upvalues: v104 (ref), SendMessage (copy)
                SendMessage:invokeServerAsync(v104, "ClientCommandBar")
            end)
            p15.visible:set(false)
        end
    end

    local function submit() -- line: 535
        -- upvalues: p15 (copy), v24 (copy), v29 (copy), v37 (copy), v38 (copy), v40 (copy), v54 (copy), acceptSelected (copy), dispatch (copy), Fusion (copy), Resolver (copy), ModifierUtil (copy)
        local v107 = Fusion.peek(v54).candidates[Fusion.peek(v29)]

        if v107 and v107.kind == "exit" then
            p15.visible:set(false)

            return
        end

        local v108 = Fusion.peek(v38)
        local v109 = Fusion.peek(v40)
        local v110 = false

        if not v107 or v107.kind == "recent" then
            v110 = true
        elseif v107.kind == "command" then
            local command = v107.command
            local _, v111 = ModifierUtil.resolve(if typeof(v107.text) == "string" then v107.text else "", v109.byKey)

            v110 = typeof(command) == "table" and #ModifierUtil.effectiveArgs(command, v111) == 0
        elseif v108.kind == "arg" then
            local commandText = Fusion.peek(v37).commandText
            local v112, v113 = ModifierUtil.resolve(if typeof(commandText) ~= "string" then "" else commandText, v109.byKey)
            local v114 = if v112 == nil then 0 else #ModifierUtil.effectiveArgs(v112, v113)

            v110 = v112 == nil or v114 <= v108.argIndex
        end

        if not v110 then
            acceptSelected(true)

            return
        end

        local v115 = if v107 then v107.kind == "recent" else nil

        dispatch(if v107 and v115 then v107.text elseif v107 then Resolver.apply(Fusion.peek(v24), v108, v107.insert, false, v107.caretBack) else Fusion.peek(v24))
    end

    local function runNow() -- line: 577
        -- upvalues: v24 (copy), dispatch (copy), Fusion (copy)
        dispatch(Fusion.peek(v24))
    end

    local function close() -- line: 581
        -- upvalues: p15 (copy)
        p15.visible:set(false)
    end

    p14:Observer(p15.visible):onChange(function() -- line: 585
        -- upvalues: p15 (copy), v21 (ref), v23 (ref), v24 (copy), v28 (copy), v29 (copy), v32 (copy), RunService (copy), StarterGui (copy), Fusion (copy)
        if v21 then
            return
        end

        if Fusion.peek(p15.visible) then
            local function v117() -- line: 591
                -- upvalues: StarterGui (copy)
                StarterGui:SetCore("ChatActive", false)
            end

            pcall(v117)

            local v118 = Fusion.peek(v32)

            if typeof(v118) ~= "string" or not (#v118 > 0) then
                v118 = if typeof(v23) ~= "string" or not (#v23 > 0) then ";" else v23
            end

            v24:set(v118)
            v29:set(1)
            task.spawn(function() -- line: 425
                -- upvalues: p15 (copy), v21 (ref), v28 (copy), RunService (copy), Fusion (copy)
                RunService.Heartbeat:Wait()

                if not v21 then
                    local v120 = Fusion.peek(v28)

                    if v120 and Fusion.peek(p15.visible) then
                        v120:CaptureFocus()
                    end
                end
            end)
        else
            local v121 = Fusion.peek(v28)

            if v121 then
                v121:ReleaseFocus()
            end
        end
    end)

    return p14:New("Frame")({
        Name = "Cmdbar",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = p15.visible,
        ZIndex = 11,
        [Children] = {
            p14:New("Frame")({
                Name = "Group",
                AnchorPoint = Vector2.new(0.5, 1),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 1, -70),
                Size = UDim2.new(1, -40, 0, 0),
                ZIndex = 2,
                [Children] = {
                    p14:New("UISizeConstraint")({
                        MaxSize = Vector2.new(560, 1e999)
                    }),
                    p14:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        VerticalAlignment = Enum.VerticalAlignment.Bottom,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 8)
                    }),
                    CmdbarList(p14, {
                        layoutOrder = 1,
                        rows = v73,
                        selectedIndex = v29,
                        signature = v74,
                        visible = v75,
                        onActivateIndex = function(p29) -- onActivateIndex | line: 639
                            -- upvalues: v29 (copy), submit (copy)
                            v29:set(p29)
                            submit()
                        end,
                        onHoverIndex = function(p30) -- onHoverIndex | line: 643
                            -- upvalues: v29 (copy)
                            v29:set(p30)
                        end
                    }),
                    CmdbarField(p14, {
                        layoutOrder = 2,
                        text = v24,
                        cursorPosition = v25,
                        focused = v27,
                        active = p15.visible,
                        wasDeletion = v31,
                        boxRef = v28,
                        onSubmit = submit,
                        onRun = runNow,
                        onNavigate = navigate,
                        onAccept = function() -- onAccept | line: 659
                            -- upvalues: acceptSelected (copy)
                            acceptSelected(true)
                        end,
                        onClose = close
                    })
                }
            })
        }
    })
end
