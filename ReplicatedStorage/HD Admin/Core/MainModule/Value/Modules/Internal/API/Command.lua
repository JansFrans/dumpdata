-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Task = require(Modules.Objects.Task)
local Prompt = require(Modules.Prompt)

return {
    loadCommands = function(p1) -- loadCommands | line: 30
        -- upvalues: Modules (copy)
        return require(Modules.Internal).loadCommands(p1)
    end,
    prompt = function(p2, ...) -- prompt | line: 37
        -- upvalues: Prompt (copy)
        local v1 = Prompt[p2]

        if typeof(v1) ~= "function" then
            error((("HD Admin: '%*' is not a valid prompt type"):format((tostring(p2)))))
        end

        return v1(...)
    end,
    getHumanoid = require(Modules.PlayerUtil.getHumanoid),
    getHRP = require(Modules.PlayerUtil.getHRP),
    getHead = require(Modules.PlayerUtil.getHead),
    getNeck = require(Modules.PlayerUtil.getNeck),
    getTorso = require(Modules.PlayerUtil.getTorso),
    loadCharacter = require(Modules.PlayerUtil.loadCharacter),
    getUserInfoAsync = require(Modules.PlayerUtil.getUserInfoAsync),
    getNameFromUserIdAsync = require(Modules.PlayerUtil.getNameFromUserIdAsync),
    teleportAsync = require(Modules.PlayerUtil.teleportAsync),
    getAllowedTargets = require(Modules.PlayerUtil.getAllowedTargets),
    unequipTools = require(Modules.PlayerUtil.unequipTools),
    getTasks = Task.getTasks,
    getTasksByCallerId = Task.getTasksByCallerId,
    systemMessage = require(Modules.ChatUtil.systemMessage),
    forceBubbleChat = require(Modules.ChatUtil.forceBubbleChat),
    forceChat = function() -- line: 72
    end,
    checkTextLimit = function(p3, p4) -- checkTextLimit | line: 74
        -- upvalues: Modules (copy)
        return require(Modules.ChatSafety).checkTextLimit(p3, p4)
    end,
    refundTextLimit = function(p5, p6) -- refundTextLimit | line: 80
        -- upvalues: Modules (copy)
        return require(Modules.ChatSafety).refundTextLimit(p5, p6)
    end,
    getDescription = require(Modules.OutfitUtil.getDescription),
    applyDescription = require(Modules.OutfitUtil.applyDescription),
    outfitBuff = require(Modules.OutfitUtil.outfitBuff),
    setFakeBodyParts = require(Modules.OutfitUtil.setFakeBodyParts),
    clearFakeBodyParts = require(Modules.OutfitUtil.clearFakeBodyParts),
    runBundleId = require(Modules.OutfitUtil.runBundleId),
    registerSound = require(Modules.AssetUtil.registerSound),
    setAnchored = require(Modules.AssetUtil.setAnchored),
    setTransparency = require(Modules.AssetUtil.setTransparency),
    promptPurchaseAsync = require(Modules.AssetUtil.promptPurchaseAsync),
    ownsAssetAsync = require(Modules.AssetUtil.ownsAssetAsync),
    isTypeAsync = require(Modules.VerifyUtil.isTypeAsync),
    loadAssetCommand = require(Modules.CommandUtil.loadAssetCommand),
    getToolsInfoAsync = require(Modules.CommandUtil.getToolsInfoAsync),
    getTargets = require(Modules.CommandUtil.getTargets),
    setCameraSubject = require(Modules.CommandUtil.setCameraSubject),
    runPromptCommand = require(Modules.CommandUtil.runPromptCommand),
    runEmoteId = require(Modules.CommandUtil.runEmoteId),
    createEmoteCommand = require(Modules.CommandUtil.createEmoteCommand),
    createBundleCommand = require(Modules.CommandUtil.createBundleCommand),
    bindEmotePrompt = require(Modules.CommandUtil.bindEmotePrompt),
    openProfile = require(Modules.CommandUtil.openProfile),
    openPage = require(Modules.CommandUtil.openPage),
    openEmotes = require(Modules.CommandUtil.openEmotes),
    colourRoleName = require(Modules.RoleUtil.colourRoleName),
    isTableEmpty = require(Modules.TableUtil.isTableEmpty),
    round = require(Modules.MathUtil.round)
}
