-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local _ = require(Modules.Parent.Services.Config.Settings).SystemSettings
local ParserSettings = require(Modules.Parser.ParserSettings)

return {
    commandStatementsFromBatchUnFormatted = "%s([^%s]+)",
    descriptionsFromCommandStatement = string.format("%s?([^%s]+)", ParserSettings.SpaceSeparator, ParserSettings.SpaceSeparator),
    argumentsFromCollection = string.format("([^%s]+)%s?", ParserSettings.Collective, ParserSettings.Collective),
    capsuleFromKeyword = string.format("%%(%s%%)", string.format("(%s)", ".-"))
}
