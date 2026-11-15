-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local State = require(Modules.Objects.State)
local defaultRole = require(Modules.References.defaultRole)
local deepCopyTable = require(Modules.TableUtil.deepCopyTable)
local SettingsList = require(UI.Components.SettingsList)
local SettingsRole = require(UI.Config.SettingsRole)
local RoleLockRules = require(UI.Config.RoleLockRules)
local Pressable = require(UI.Components.Pressable)
local DataPopup = require(UI.Components.DataPopup)
local SerializeRole = require(UI.Util.SerializeRole)
local ParseRole = require(UI.Util.ParseRole)
local Remote = require(Modules.Objects.Remote)
local Children = Fusion.Children
local t1 = {
    key = true,
    rank = true,
    useDefaults = true
}

return function(p1, p2) -- line: 43
    -- upvalues: Modules (copy), Fusion (copy), Theme (copy), State (copy), defaultRole (copy), deepCopyTable (copy), SettingsList (copy), SettingsRole (copy), RoleLockRules (copy), Pressable (copy), DataPopup (copy), SerializeRole (copy), ParseRole (copy), Remote (copy), Children (copy), t1 (copy)
    local t2 = {}

    for _, v1 in SettingsRole do
        local t3 = {}

        for _, v2 in v1.objects do
            if typeof(v2.title) ~= "string" or not t1[v2.title] then
                table.insert(t3, v2)
            end
        end

        if #t3 ~= 0 then
            table.insert(t2, {
                heading = v1.heading,
                objects = t3
            })
        end
    end

    local function buildSeed() -- line: 60
        -- upvalues: defaultRole (copy), deepCopyTable (copy)
        local v3 = deepCopyTable(defaultRole)

        v3.name = ""
        v3.key = nil
        v3.rank = nil
        v3.useDefaults = nil

        return v3
    end

    local new = State.new
    local v4 = deepCopyTable(defaultRole)

    v4.name = ""
    v4.key = nil
    v4.rank = nil
    v4.useDefaults = nil

    local v5 = new(false, v4)

    local function v6(p3) -- line: 71
        -- upvalues: p1 (copy), RoleLockRules (copy)
        local title = p3.obj.title

        if typeof(title) ~= "string" then
            return nil
        end

        local v7 = RoleLockRules.getRulesFor(title)

        if #v7 == 0 then
            return nil
        end

        local valueByTitle = p3.valueByTitle

        return p1:Computed(function(p4) -- line: 77
            -- upvalues: v7 (copy), valueByTitle (copy)
            for _, v8 in v7 do
                if v8.parent then
                    local v9 = valueByTitle[v8.parent]

                    if v9 and p4(v9) == true then
                        return true
                    end
                end

                if v8.parents then
                    for _, v10 in v8.parents do
                        local v11 = valueByTitle[v10]

                        if v11 and p4(v11) == true then
                            return true
                        end
                    end
                end

                if v8.requiredTrue then
                    for _, v12 in v8.requiredTrue do
                        local v13 = valueByTitle[v12]

                        if v13 and p4(v13) ~= true then
                            return true
                        end
                    end
                end
            end

            return false
        end)
    end

    local v14 = p1:Value(false)
    local v15 = p1:Value("")
    local name = p1:Fuse(v5, "name")
    local v16 = p1:Computed(function(p5) -- line: 103
        -- upvalues: v14 (copy), name (copy)
        if p5(v14) then
            return false
        end

        local v17 = p5(name)

        if typeof(v17) == "string" then
            return v17:gsub("%s", "") ~= ""
        end

        return false
    end)
    local v18 = p1:New("Frame")({
        Name = "RoleCreatePage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })
    local v19 = p1:Value(nil)

    local function confirmCreate() -- line: 117
        -- upvalues: p2 (copy), v5 (copy), v14 (copy), v15 (copy), v16 (copy), Modules (copy), Fusion (copy), Remote (copy)
        if not Fusion.peek(v16) then
            return
        end

        v14:set(true)
        v15:set("")
        task.spawn(function() -- line: 121
            -- upvalues: p2 (copy), v5 (copy), v14 (copy), v15 (copy), Modules (copy), Remote (copy)
            local v20 = v5:getAll()
            local v21, v22, v23 = Remote.get("CreateRole"):invokeServerAsync(v20)

            v14:set(false)

            if v21 then
                if p2.onCreated then
                    p2.onCreated((tostring(v22)))
                end
            else
                local v25 = tostring(v22 or "Failed to create role")

                v15:set(v25)

                local Prompt = require(Modules.Prompt);

                (if v23 == "error" then Prompt.error else Prompt.warn)(v25)
            end
        end)
    end

    local function buildActions() -- line: 141
        -- upvalues: p1 (copy), p2 (copy), v14 (copy), v16 (copy), confirmCreate (copy), Fusion (copy), Theme (copy), Pressable (copy), Children (copy)
        local v26 = Pressable(p1, {
            name = "CancelButton",
            size = UDim2.fromOffset(96, 34),
            backgroundColor = Theme.Color.Neutral,
            onActivate = function() -- onActivate | line: 146
                -- upvalues: p2 (copy), v14 (copy), Fusion (copy)
                if not Fusion.peek(v14) and p2.onCancel then
                    p2.onCancel()
                end
            end,
            layoutOrder = 1,
            [Children] = {
                p1:New("UICorner")({
                    CornerRadius = p1:Computed(function(p6) -- line: 153
                        -- upvalues: Theme (copy)
                        return UDim.new(0, (p6(Theme.Layout.CornerRadius)))
                    end)
                }),
                p1:New("UIStroke")({
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Theme.Color.NeutralStroke
                }),
                p1:New("TextLabel")({
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Text = "Cancel",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    FontFace = p1:Computed(function(p7) -- line: 165
                        -- upvalues: Theme (copy)
                        return Font.new(p7(Theme.Font.Body), p7(Theme.FontWeight.Body))
                    end),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(1, 1),
                    TextColor3 = Theme.Color.BaseContent,
                    TextSize = Theme.TextSize.Body,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center
                })
            }
        })
        local v27 = Pressable(p1, {
            name = "CreateButton",
            size = UDim2.fromOffset(140, 34),
            backgroundColor = p1:Computed(function(p8) -- line: 182
                -- upvalues: v16 (copy), Theme (copy)
                if p8(v16) then
                    return (p8(Theme.Color.Primary))
                end

                return (p8(Theme.Color.Primary):Lerp(Color3.new(0, 0, 0), 0.3))
            end),
            interactable = v16,
            onActivate = confirmCreate,
            layoutOrder = 2,
            [Children] = {
                p1:New("UICorner")({
                    CornerRadius = p1:Computed(function(p9) -- line: 192
                        -- upvalues: Theme (copy)
                        return UDim.new(0, (p9(Theme.Layout.CornerRadius)))
                    end)
                }),
                p1:New("UIStroke")({
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Theme.Color.NeutralStroke
                }),
                p1:New("TextLabel")({
                    Name = "Label",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    FontFace = p1:Computed(function(p10) -- line: 204
                        -- upvalues: Theme (copy)
                        return Font.new(p10(Theme.Font.Body), p10(Theme.FontWeight.Body))
                    end),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(1, 1),
                    Text = p1:Computed(function(p11) -- line: 209
                        -- upvalues: v14 (copy)
                        if p11(v14) then
                            return "Creating..."
                        end

                        return "Create"
                    end),
                    TextColor3 = Theme.Color.PrimaryContent,
                    TextSize = Theme.TextSize.Body,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    TextTransparency = p1:Computed(function(p12) -- line: 216
                        -- upvalues: v16 (copy)
                        if p12(v16) then
                            return 0
                        end

                        return 0.35
                    end)
                })
            }
        })

        return p1:New("Frame")({
            Name = "ActionsRow",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            [Children] = {
                p1:New("UIPadding")({
                    PaddingTop = UDim.new(0, 18)
                }),
                p1:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = p1:Computed(function(p13) -- line: 237
                        -- upvalues: Theme (copy)
                        return UDim.new(0, (p13(Theme.Layout.Padding)))
                    end)
                }),
                v26,
                v27
            }
        })
    end

    local v28, v29

    local function closeDataPopup() -- line: 247
        -- upvalues: v28 (ref), v29 (ref), Fusion (copy)
        if v29 then
            v29:Destroy()
            v29 = nil
        end

        if v28 then
            Fusion.doCleanup(v28)
            v28 = nil
        end
    end

    local function openDataPopup() -- line: 257
        -- upvalues: v5 (copy), v18 (copy), v19 (copy), v28 (ref), v29 (ref), Fusion (copy), DataPopup (copy), SerializeRole (copy), ParseRole (copy)
        if v29 then
            v29:Destroy()
            v29 = nil
        end

        if v28 then
            Fusion.doCleanup(v28)
            v28 = nil
        end

        local v30 = Fusion.scoped(Fusion)

        v28 = v30

        local v34 = DataPopup(v30, {
            visible = v30:Value(true),
            copyText = SerializeRole((v5:getAll())),
            onClose = function() -- onClose | line: 267
                -- upvalues: v28 (ref), v29 (ref), Fusion (copy)
                if v29 then
                    v29:Destroy()
                    v29 = nil
                end

                if v28 then
                    Fusion.doCleanup(v28)
                    v28 = nil
                end
            end,
            onLoad = function(p14) -- onLoad | line: 268
                -- upvalues: v19 (copy), Fusion (copy), ParseRole (copy)
                local v35, v36, v37 = ParseRole(p14)

                if not v35 then
                    return false, "Failed loading data, please re-write"
                end

                local v38 = Fusion.peek(v19)

                if v38 and v38.setFieldValue then
                    for v39, v40 in v36 do
                        v38.setFieldValue(v39, v40)
                    end

                    return true, (("Successfully updated %* role values"):format(v37 or 0))
                end

                return false, "Settings list not ready"
            end
        })

        v34.Parent = v18
        v29 = v34
    end

    SettingsList(p1, {
        pathPrefix = nil,
        undoOnDestroy = false,
        hideConfirmBar = true,
        settingsData = t2,
        stateSource = v5,
        onItemSelectorOpen = p2.onItemSelectorOpen,
        panelClosed = p2.panelClosed,
        controllerRef = v19,
        footerSlot = buildActions(),
        lockRule = v6,
        objectOverrides = {
            data = {
                onActivate = openDataPopup
            }
        }
    }).Parent = v18
    table.insert(p1, closeDataPopup)

    if p2.idle ~= nil then
        p1:Observer(p2.idle):onChange(function() -- line: 308
            -- upvalues: p2 (copy), v5 (copy), v14 (copy), v15 (copy), v19 (copy), Fusion (copy), defaultRole (copy), deepCopyTable (copy)
            if Fusion.peek(p2.idle) == true then
                return
            end

            local v41 = deepCopyTable(defaultRole)

            v41.name = ""
            v41.key = nil
            v41.rank = nil
            v41.useDefaults = nil
            v5:setAll(v41)
            v14:set(false)
            v15:set("")

            local v42 = Fusion.peek(v19)

            if v42 and v42.scrollToTop then
                v42.scrollToTop()
            end
        end)
    end

    table.insert(p1, function() -- line: 320
        -- upvalues: v5 (copy)
        if v5 and v5.destroy then
            v5:destroy()
        end
    end)

    return v18
end
