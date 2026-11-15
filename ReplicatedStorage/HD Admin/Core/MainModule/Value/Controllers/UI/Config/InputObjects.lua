-- https://lua.expert

local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local Components = Modules.Parent.Controllers.UI.Components

require(Packages.Fusion)
t1.items = {
    ItemSelector = function(p1, p2) -- line: 13
        -- upvalues: Components (copy)
        return require(Components.ItemSelector)(p1, {
            title = p2.title,
            default = p2.default,
            value = p2.value,
            canAnyUserBeAddedToPicker = p2.canAnyUserBeAddedToPicker,
            displayServerPlayersInPicker = p2.displayServerPlayersInPicker,
            displayQualifiersInPicker = p2.displayQualifiersInPicker,
            pickerGetter = p2.pickerGetter,
            presetGetter = p2.presetGetter,
            itemsGetter = p2.itemsGetter,
            maxItems = p2.maxItems,
            limitPickerToOneItem = p2.limitPickerToOneItem,
            sharedCustomUsers = p2.sharedCustomUsers,
            onOpen = p2.onOpen,
            labelSize = p2.labelSize,
            labelTextSize = p2.labelTextSize,
            itemToEntry = p2.itemToEntry,
            entryToKey = p2.entryToKey,
            hydrateEntry = p2.hydrateEntry,
            addFlow = p2.addFlow,
            autoOpen = p2.autoOpen
        })
    end,
    TextInput = function(p3, p4) -- line: 39
        -- upvalues: Components (copy)
        return require(Components.TextInput)(p3, {
            title = p4.title,
            default = p4.default,
            value = p4.value,
            validationStatus = p4.validationStatus,
            filterText = p4.filterText,
            mustBeStringSafe = p4.mustBeStringSafe,
            preventWhitespaces = p4.preventWhitespaces,
            firstArgValue = p4.firstArgValue,
            verifier = p4.verifier,
            limitTextLength = p4.limitTextLength,
            clearTextOnFocus = p4.clearTextOnFocus,
            labelSize = p4.labelSize,
            labelTextSize = p4.labelTextSize
        })
    end,
    NumberInput = function(p5, p6) -- line: 58
        -- upvalues: Components (copy)
        if if p6.useSlider == nil then p6.min ~= nil and p6.max ~= nil else p6.useSlider == true then
            return require(Components.NumberSlider)(p5, {
                title = p6.title,
                default = p6.default,
                value = p6.value,
                min = p6.min,
                max = p6.max,
                step = p6.step or 0.1,
                logarithmic = p6.logarithmic,
                labelSize = p6.labelSize,
                labelTextSize = p6.labelTextSize
            })
        end

        return require(Components.NumberInput)(p5, {
            title = p6.title,
            default = p6.default,
            value = p6.value,
            min = p6.min,
            max = p6.max,
            step = p6.step,
            allowEmpty = p6.allowEmpty,
            placeholderText = p6.placeholderText,
            labelSize = p6.labelSize,
            labelTextSize = p6.labelTextSize
        })
    end,
    DurationSelector = function(p7, p8) -- line: 92
        -- upvalues: Components (copy)
        return require(Components.DurationSelector)(p7, {
            title = p8.title,
            default = p8.default,
            value = p8.value,
            labelSize = p8.labelSize,
            labelTextSize = p8.labelTextSize
        })
    end,
    ColorPicker = function(p9, p10) -- line: 103
        -- upvalues: Components (copy)
        return require(Components.ColorPicker)(p9, {
            title = p10.title,
            default = p10.default,
            value = p10.value,
            labelSize = p10.labelSize,
            labelTextSize = p10.labelTextSize,
            slidersHeight = p10.slidersHeight
        })
    end,
    Toggle = function(p11, p12) -- line: 115
        -- upvalues: Components (copy)
        return require(Components.Toggle)(p11, {
            title = p12.title,
            default = p12.default,
            value = p12.value,
            labelSize = p12.labelSize,
            labelTextSize = p12.labelTextSize
        })
    end,
    Options = function(p13, p14) -- line: 126
        -- upvalues: Components (copy)
        return require(Components.Options)(p13, {
            title = p14.title,
            default = p14.default,
            value = p14.value,
            optionsArray = p14.optionsArray,
            optionsDisplayArray = p14.optionsDisplayArray,
            optionCommands = p14.optionCommands,
            labelSize = p14.labelSize,
            labelTextSize = p14.labelTextSize
        })
    end,
    ActionButton = function(p15, p16) -- line: 140
        -- upvalues: Components (copy)
        return require(Components.ActionButton)(p15, {
            title = p16.title,
            buttonText = p16.buttonText,
            buttonIcon = p16.buttonIcon,
            onActivate = p16.onActivate,
            labelSize = p16.labelSize,
            labelTextSize = p16.labelTextSize
        })
    end,
    InputFields = function(p17, p18) -- line: 152
        -- upvalues: Components (copy)
        return require(Components.InputFields)(p17, {
            title = p18.title,
            default = p18.default,
            value = p18.value,
            validationStatus = p18.validationStatus,
            maxItems = p18.maxItems,
            filterText = p18.filterText,
            firstArgValue = p18.firstArgValue,
            labelSize = p18.labelSize,
            labelTextSize = p18.labelTextSize
        })
    end
}

return t1
