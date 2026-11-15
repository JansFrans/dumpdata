-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local LoadingSpinner = require(UI.Components.LoadingSpinner)
local StreamList = require(UI.Components.StreamList)
local UserInputService = game:GetService("UserInputService")
local v1 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

return function(p1, p2) -- line: 43
    -- upvalues: Theme (copy), Children (copy), LoadingSpinner (copy), StreamList (copy), v1 (copy)
    local v2 = p2.minLoadTime or 0.4
    local v3 = p1:Value(false)

    task.delay(v2, function() -- line: 48
        -- upvalues: v3 (copy)
        v3:set(true)
    end)

    local v4 = p1:Computed(function(p3) -- line: 52
        -- upvalues: p2 (copy), v3 (copy)
        if p3(v3) then
            return not p3(p2.isReady)
        end

        return true
    end)
    local v5 = p1:Computed(function(p4) -- line: 57
        -- upvalues: v4 (copy)
        return not p4(v4)
    end)
    local v9 = p1:New("ScrollingFrame")({
        Name = "ScrollingFrame",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BottomImage = "rbxassetid://16547643439",
        CanvasSize = UDim2.new(),
        LayoutOrder = 2,
        MidImage = "rbxassetid://16547330984",
        ScrollBarImageColor3 = Theme.Color.NeutralContentDark,
        ScrollBarImageTransparency = v1 and 1 or 0,
        ScrollBarThickness = v1 and 2 or 8,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Selectable = false,
        Size = UDim2.fromScale(1, 1),
        TopImage = "rbxassetid://16547667444",
        VerticalScrollBarInset = Enum.ScrollBarInset.Always,
        Visible = v5,
        [Children] = {
            p1:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }),
            p1:New("UIPadding")({
                PaddingBottom = UDim.new(0, 1),
                PaddingLeft = UDim.new(0, 1),
                PaddingRight = UDim.new(0, if v1 then 4 else p2.paddingRight or 2),
                PaddingTop = UDim.new(0, 1)
            }),
            p1:New("UIListLayout")({
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = p2.headerGap or UDim.new(0, 0),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p2.header,
            p1:Computed(function(p5, p6) -- line: 96
                -- upvalues: p2 (copy), Children (copy), StreamList (copy)
                if p2.useStream == nil or p5(p2.useStream) then
                    return StreamList(p6, {
                        layoutOrder = 1,
                        items = p2.items,
                        visibleItems = p2.visibleItems,
                        itemKey = p2.itemKey,
                        renderItem = p2.renderItem,
                        padding = p2.padding,
                        idle = p2.idle,
                        idleGrace = p2.idleGrace,
                        parentScrollingFrame = scroller
                    })
                end

                return p6:New("Frame")({
                    Name = "DirectList",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Size = UDim2.fromScale(1, 0),
                    [Children] = {
                        p6:New("UIListLayout")({
                            HorizontalFlex = Enum.UIFlexAlignment.Fill,
                            Padding = p2.padding or UDim.new(0, 8),
                            SortOrder = Enum.SortOrder.LayoutOrder
                        }),
                        p6:ForValues(p2.visibleItems or p2.items, function(_, p8, p9) -- line: 123
                            -- upvalues: p2 (copy)
                            return p2.renderItem(p8, p9)
                        end)
                    }
                })
            end)
        }
    })

    if p2.onScrollerReady then
        p2.onScrollerReady(v9)
    end

    local v10, v11

    v11 = if v1 then 4 else p2.paddingRight or 2

    local v12 = 1 + v11 + (if v1 then 2 else 8)
    local v13

    if p2.overlay then
        v13 = p1:New("Frame")({
            Name = "OverlayWrapper",
            AnchorPoint = Vector2.new(0, 0),
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(1, 0),
            Size = UDim2.new(1, -v12, 1, 0),
            ZIndex = 5,
            [Children] = { p2.overlay }
        })
        v10 = v13
    end

    local v15 = p1:Value(0)

    if p2.overlay and p2.overlay:IsA("GuiObject") then
        local overlay = p2.overlay

        local function updateSpinnerInset() -- line: 157
            -- upvalues: v15 (copy), overlay (copy)
            if not overlay.Visible then
                v15:set(0)

                return
            end

            local Y = overlay.AbsoluteSize.Y

            if Y <= 0 then
                Y = overlay.Size.Y.Offset
            end

            v15:set(Y)
        end

        local t6 = {
            overlay:GetPropertyChangedSignal("Visible"):Connect(updateSpinnerInset),
            overlay:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSpinnerInset)
        }

        table.insert(p1, function() -- line: 172
            -- upvalues: t6 (copy)
            for _, v17 in t6 do
                v17:Disconnect()
            end
        end)

        if overlay.Visible then
            local Y = overlay.AbsoluteSize.Y

            if Y <= 0 then
                Y = overlay.Size.Y.Offset
            end

            v15:set(Y)
        else
            v15:set(0)
        end
    end

    local v19 = p1:New("Frame")({
        Name = "ScrollContainer",
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            p1:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }),
            v9,
            p1:Computed(function(p10, p11) -- line: 190
                -- upvalues: v4 (copy), v15 (copy), Children (copy), LoadingSpinner (copy)
                if p10(v4) then
                    return p11:New("Frame")({
                        Name = "LoadingArea",
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Position = p11:Computed(function(p12) -- line: 196
                            -- upvalues: v15 (copy)
                            return UDim2.fromOffset(0, p12(v15))
                        end),
                        Size = UDim2.fromScale(1, 0),
                        [Children] = {
                            LoadingSpinner(p11, {
                                layoutOrder = 1
                            })
                        }
                    })
                end

                return nil
            end),
            v13
        }
    })

    if p2.pinBelowHeader and v13 and p2.header and p2.header:IsA("GuiObject") then
        local header = p2.header

        local function updateOverlayPosition() -- line: 213
            -- upvalues: v9 (copy), v10 (ref), v12 (copy), header (copy)
            local v21 = math.max(0, header.AbsolutePosition.Y + header.AbsoluteSize.Y - v9.AbsolutePosition.Y)
            local v22 = v10

            v22.Position = UDim2.fromOffset(1, v21)
            v22.Size = UDim2.new(1, -v12, 1, -v21)
        end

        local t8 = {
            v9:GetPropertyChangedSignal("CanvasPosition"):Connect(updateOverlayPosition),
            v9:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateOverlayPosition),
            header:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateOverlayPosition)
        }

        table.insert(p1, function() -- line: 226
            -- upvalues: t8 (copy)
            for _, v24 in t8 do
                v24:Disconnect()
            end
        end)
        task.defer(updateOverlayPosition)
    end

    return p1:New("Frame")({
        Name = "ScrollList",
        BackgroundTransparency = 1,
        LayoutOrder = p2.layoutOrder or 1,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p1:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }),
            p1:New("UIListLayout")({
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            v19
        }
    })
end
