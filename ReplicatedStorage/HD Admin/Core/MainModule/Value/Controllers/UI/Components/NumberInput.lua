-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local InputRow = require(script.Parent.InputRow)

local function clampAndStep(p1, p2, p3, p4) -- line: 30
    -- upvalues: Modules (copy)
    local v1 = if p4 and p4 > 0 then require(Modules.MathUtil.roundToNearest)(p1, p4) else p1

    if p2 then
        v1 = math.max(v1, p2)
    end

    if p3 then
        v1 = math.min(v1, p3)
    end

    return v1
end

return function(p5, p6) -- line: 42
    -- upvalues: Modules (copy), Fusion (copy), Theme (copy), Children (copy), InputRow (copy)
    local v2 = p6.title or ""
    local min, max, step = p6.min, p6.max, p6.step
    local v3 = not step or step % 1 ~= 0
    local v4 = p6.allowEmpty == true
    local v5 = if p6.value then Fusion.peek(p6.value) else p6.default
    local v6 = tonumber(v5) or 0

    if step and step > 0 then
        v6 = require(Modules.MathUtil.roundToNearest)(v6, step)
    end

    if min then
        v6 = math.max(v6, min)
    end

    if max then
        v6 = math.min(v6, max)
    end

    local v7 = p5:Value(false)
    local v8 = p5:Value(v6)
    local v9 = p5:Value(if if v4 then v5 ~= nil else p6.value ~= nil or p6.default ~= nil then tostring(v6) else "")
    local v10

    if p6.value ~= nil then
        p5:Observer(p6.value):onChange(function() -- line: 63
            -- upvalues: p6 (copy), min (copy), max (copy), step (copy), v7 (copy), v8 (copy), v9 (copy), Modules (copy), Fusion (copy)
            if Fusion.peek(v7) == true then
                return
            end

            local v11 = tonumber(Fusion.peek(p6.value))

            if v11 == nil then
                return
            end

            if step and step > 0 then
                v11 = require(Modules.MathUtil.roundToNearest)(v11, step)
            end

            if min then
                v11 = math.max(v11, min)
            end

            if max then
                v11 = math.min(v11, max)
            end

            if v11 ~= Fusion.peek(v8) then
                v8:set(v11)
                v9:set((tostring(v11)))
            end
        end)
    end

    local function filterInput(p7) -- line: 74
        -- upvalues: v3 (copy)
        local v12 = p7:sub(1, 1) == "-"
        local v13 = (if v12 then p7:sub(2) else p7):gsub("[^0-9%.]", "")

        if v3 then
            local v14 = v13:find("%.", 1, true)

            if v14 then
                v13 = v13:sub(1, v14) .. v13:sub(v14 + 1):gsub("%.", "")
            end
        else
            v13 = v13:gsub("%.", "")
        end

        if v12 then
            return "-" .. v13
        end

        return v13
    end

    local function commit(p8) -- line: 89
        -- upvalues: p6 (copy), min (copy), max (copy), step (copy), v8 (copy), v9 (copy), v4 (copy), Modules (copy), Fusion (copy)
        if v4 and p8 == "" then
            if p6.value then
                p6.value:set(nil)
            end

            v9:set("")
        else
            local v15 = tonumber(p8)

            if v15 then
                if step and step > 0 then
                    v15 = require(Modules.MathUtil.roundToNearest)(v15, step)
                end

                if min then
                    v15 = math.max(v15, min)
                end

                if max then
                    v15 = math.min(v15, max)
                end

                v8:set(v15)
                v9:set((tostring(v15)))

                if p6.value then
                    p6.value:set(v15)
                end
            else
                local v16 = v4

                if v4 then
                    v16 = p6.value ~= nil and Fusion.peek(p6.value) == nil
                end

                v9:set(if v16 then "" else tostring(Fusion.peek(v8)))
            end
        end
    end

    v10 = p5:New("TextBox")({
        Name = "TextInput",
        AutoLocalize = false,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        FontFace = p5:Computed(function(p9) -- line: 114
            -- upvalues: Theme (copy)
            return Font.new(p9(Theme.Font.Body), p9(Theme.FontWeight.Bold))
        end),
        PlaceholderColor3 = Theme.Color.NeutralContentDark,
        PlaceholderText = p6.placeholderText or v9,
        Size = UDim2.fromScale(1, 0),
        Text = v9,
        TextColor3 = Theme.Color.BaseContent,
        TextSize = Theme.TextSize.Subtitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        [Fusion.OnEvent("Focused")] = function() -- line: 126
            -- upvalues: v7 (copy)
            v7:set(true)
        end,
        [Fusion.OnEvent("FocusLost")] = function() -- line: 129
            -- upvalues: v7 (copy), v9 (copy), commit (copy), Fusion (copy)
            v7:set(false)
            commit(Fusion.peek(v9))
        end,
        [Fusion.OnChange("Text")] = function(p10) -- line: 133
            -- upvalues: v9 (copy), v10 (ref), filterInput (copy)
            local v18 = filterInput(p10)

            if v18 ~= p10 then
                local v19 = v10

                if v19 then
                    v19.Text = v18
                end
            end

            v9:set(v18)
        end
    })

    return InputRow(p5, {
        title = v2,
        name = "NumberInput",
        labelSize = p6.labelSize,
        labelTextSize = p6.labelTextSize,
        clipsDescendants = true,
        strokeFocused = v7,
        [Children] = { v10 }
    })
end
