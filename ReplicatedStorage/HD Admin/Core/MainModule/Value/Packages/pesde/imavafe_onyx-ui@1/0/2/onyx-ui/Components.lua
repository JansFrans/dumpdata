-- https://lua.expert

local t1 = {
    Base = require(script.Base),
    Text = require(script.Text),
    Frame = require(script.Frame),
    Badge = require(script.Badge),
    Avatar = require(script.Avatar),
    AutoScaler = require(script.AutoScaler),
    BaseButton = require(script.BaseButton),
    Button = require(script.Button),
    Card = require(script.Card),
    Checkbox = require(script.Checkbox),
    Divider = require(script.Divider),
    Group = require(script.Group),
    Heading = require(script.Heading),
    Icon = require(script.Icon),
    IconButton = require(script.IconButton),
    IconText = require(script.IconText),
    Image = require(script.Image),
    ProgressBar = require(script.ProgressBar),
    Scroller = require(script.Scroller),
    Switch = require(script.Switch),
    TextInput = require(script.TextInput),
    TextArea = require(script.TextArea),
    TitleBar = require(script.TitleBar),
    TextSwap = require(script.TextSwap),
    Slider = require(script.Slider),
    Tabs = require(script.Tabs),
    IconSwap = require(script.IconSwap)
}

task.spawn(function() -- line: 33
    -- upvalues: t1 (copy)
    for _, child in ipairs(script:GetChildren()) do
        if string.sub(child.Name, -6) ~= ".story" then
            local function v1() -- line: 37
                -- upvalues: child (copy)
                return require(child)
            end

            local ok, result = pcall(v1)

            if ok then
                if t1[child.Name] ~= result then
                    assert(false, (("Component %* is not listed."):format(child)))
                end
            else
                assert(false, (("%* errored during require."):format(child)))
            end
        end
    end
end)

return t1
