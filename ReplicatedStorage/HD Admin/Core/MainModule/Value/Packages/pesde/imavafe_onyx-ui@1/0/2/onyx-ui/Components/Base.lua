-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children

return function(p1, p2) -- line: 389
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), Children (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util)
    local v2 = Themer.Theme:now()
    local Frame = Util.Fallback(p2.ClassName, "Frame")
    local Base = Util.Fallback(p2.Name, "Base")
    local v3 = Util.Fallback(p2.AutomaticSize, Enum.AutomaticSize.XY)
    local v4 = Util.Fallback(p2.BackgroundColor3, v2.Colors.Base.Main)
    local v5 = Util.Fallback(p2.Corner, {
        Radius = v1:UDim(v1, 0, v2.CornerRadius["1"])
    })
    local v7 = Util.Fallback(p2.Stroke, {
        Thickness = v2.StrokeThickness["1"],
        Color = v1:Computed(function(p3) -- line: 402
            -- upvalues: v2 (copy), v4 (copy), Util (copy)
            return Util.Emphasize(p3(v4), p3(v2.StrokeEmphasis.Regular))
        end),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        LineJoinMode = v1:Computed(function(p4) -- line: 406
            -- upvalues: v5 (copy)
            local v6 = p4(p4(v5).Radius)

            if v6 ~= nil and (v6.Offset > 1 or v6.Scale > 1) then
                return Enum.LineJoinMode.Round
            end

            return Enum.LineJoinMode.Miter
        end)
    })
    local v8 = Util.Fallback(p2.Padding, {
        All = v1:UDim(0, v2.Padding["1"])
    })
    local v9 = Util.Fallback(p2.List, {
        Padding = v1:UDim(0, v2.Padding["1"]),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v10 = Util.Fallback(p2.Grid, {
        CellPadding = v1:UDim2Offset(v2.Padding["1"], v2.Padding["1"]),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v11 = Util.Fallback(p2.Table, {
        Padding = v1:UDim2Offset(v2.Padding["1"], v2.Padding["1"]),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v12 = Util.Fallback(p2.Page, {
        Padding = v1:UDim(0, v2.Padding["1"]),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v13 = v1:Computed(function(p5) -- line: 436
        -- upvalues: p2 (copy), v8 (copy)
        local v14 = p5(p2.Padding) ~= nil
        local v15 = p5(v8) or {}
        local t2 = {
            v15.All,
            v15.Top,
            v15.Left,
            v15.Right,
            v15.Bottom
        }

        if v14 then
            for _, v16 in t2 do
                if typeof((p5(v16))) == "UDim" then
                    return true
                end
            end
        end

        return false
    end)

    return v1:New(Frame)({
        Name = Base,
        AutomaticSize = v3,
        Parent = p2.Parent,
        Position = p2.Position,
        Rotation = p2.Rotation,
        AnchorPoint = p2.AnchorPoint,
        Size = p2.Size,
        Visible = p2.Visible,
        ZIndex = p2.ZIndex,
        LayoutOrder = p2.LayoutOrder,
        ClipsDescendants = p2.ClipsDescendants,
        Active = p2.Active,
        Selectable = p2.Selectable,
        Interactable = p2.Interactable,
        BackgroundColor3 = p2.BackgroundColor3,
        BackgroundTransparency = p2.BackgroundTransparency,
        NextSelectionDown = p2.NextSelectionDown,
        NextSelectionUp = p2.NextSelectionUp,
        NextSelectionRight = p2.NextSelectionRight,
        NextSelectionLeft = p2.NextSelectionLeft,
        SelectionImageObject = p2.SelectionImageObject,
        SelectionOrder = p2.SelectionOrder,
        SizeConstraint = p2.SizeConstraint,
        AutoLocalize = p2.AutoLocalize,
        RootLocalizationTable = p2.RootLocalizationTable,
        SelectionBehaviorDown = p2.SelectionBehaviorDown,
        SelectionBehaviorUp = p2.SelectionBehaviorUp,
        SelectionBehaviorRight = p2.SelectionBehaviorRight,
        SelectionBehaviorLeft = p2.SelectionBehaviorLeft,
        SelectionGroup = p2.SelectionGroup,
        [Children] = {
            v1:Computed(function(p6) -- line: 490
                -- upvalues: p2 (copy), v1 (copy), v5 (copy)
                local v20 = p6(v5) or {}

                if p6(p2.Corner) == nil or p6(v20.Enabled) == false then
                    return
                end

                return v1:New("UICorner")({
                    CornerRadius = v20.Radius
                })
            end),
            v1:Computed(function(p7) -- line: 500
                -- upvalues: v1 (copy), v8 (copy), v13 (copy)
                local v22 = p7(v13)
                local v23 = p7(v8) or {}

                if v22 ~= true then
                    return
                end

                return v1:New("UIPadding")({
                    PaddingTop = v1:Computed(function(p8) -- line: 506
                        -- upvalues: v23 (copy)
                        local v24 = p8(v23.All)

                        return p8(v23.Top) or v24 or UDim.new()
                    end),
                    PaddingBottom = v1:Computed(function(p9) -- line: 512
                        -- upvalues: v23 (copy)
                        local v25 = p9(v23.All)

                        return p9(v23.Bottom) or v25 or UDim.new()
                    end),
                    PaddingLeft = v1:Computed(function(p10) -- line: 518
                        -- upvalues: v23 (copy)
                        local v26 = p10(v23.All)

                        return p10(v23.Left) or v26 or UDim.new()
                    end),
                    PaddingRight = v1:Computed(function(p11) -- line: 524
                        -- upvalues: v23 (copy)
                        local v27 = p11(v23.All)

                        return p11(v23.Right) or v27 or UDim.new()
                    end)
                })
            end),
            v1:Computed(function(p12) -- line: 533
                -- upvalues: p2 (copy), v1 (copy), v7 (copy), Children (copy)
                local v29 = p12(v7) or {}

                if p12(p2.Stroke) == nil or p12(v29.Enabled) == false then
                    return
                end

                return v1:New("UIStroke")({
                    Enabled = v29.Enabled,
                    Thickness = v29.Thickness,
                    Color = v29.Color,
                    Transparency = v29.Transparency,
                    ApplyStrokeMode = v29.ApplyStrokeMode,
                    LineJoinMode = v29.LineJoinMode,
                    BorderOffset = v29.Offset,
                    BorderStrokePosition = v29.Position,
                    StrokeSizingMode = v29.SizingMode,
                    ZIndex = v29.ZIndex,
                    [Children] = {
                        v1:Computed(function(p13) -- line: 551
                            -- upvalues: v29 (copy), v1 (copy)
                            local v30 = p13(v29.Gradient) or {}

                            if v29.Gradient == nil or p13(v30.Enabled) == false then
                                return
                            end

                            return v1:New("UIGradient")({
                                Enabled = v30.Enabled,
                                Color = v30.Color,
                                Offset = v30.Offset,
                                Rotation = v30.Rotation,
                                Transparency = v30.Transparency
                            })
                        end)
                    }
                })
            end),
            v1:Computed(function(p14) -- line: 569
                -- upvalues: p2 (copy), v1 (copy)
                local v32 = p14(p2.Gradient) or {}

                if p14(p2.Gradient) == nil or p14(v32.Enabled) == false then
                    return
                end

                return v1:New("UIGradient")({
                    Enabled = v32.Enabled,
                    Color = v32.Color,
                    Offset = v32.Offset,
                    Rotation = v32.Rotation,
                    Transparency = v32.Transparency
                })
            end),
            v1:Computed(function(p15) -- line: 585
                -- upvalues: p2 (copy), v1 (copy)
                local v34 = p15(p2.Scale) or {}

                if p15(p2.Scale) == nil or p15(v34.Enabled) == false then
                    return
                end

                return v1:New("UIScale")({
                    Scale = v34.Scale
                })
            end),
            v1:Computed(function(p16) -- line: 595
                -- upvalues: p2 (copy), v1 (copy)
                local v36 = p16(p2.Aspect) or {}

                if p16(p2.Aspect) == nil or p16(v36.Enabled) == false then
                    return
                end

                return v1:New("UIAspectRatioConstraint")({
                    AspectRatio = v36.Ratio,
                    DominantAxis = v36.DominantAxis,
                    AspectType = v36.Type
                })
            end),
            v1:Computed(function(p17) -- line: 607
                -- upvalues: p2 (copy), v1 (copy)
                local v38 = p17(p2.SizeLimit) or {}
                local UISizeConstraint, t6

                if p17(v38.Enabled) ~= false and p17(v38.Max) ~= nil then
                    UISizeConstraint = v1:New("UISizeConstraint")
                    t6 = {}
                    t6.MaxSize = v38.Max
                    t6.MinSize = v38.Min

                    return UISizeConstraint(t6)
                end

                if p17(v38.Min) == nil then
                    return
                end

                UISizeConstraint = v1:New("UISizeConstraint")
                t6 = {}
                t6.MaxSize = v38.Max
                t6.MinSize = v38.Min

                return UISizeConstraint(t6)
            end),
            v1:Computed(function(p18) -- line: 620
                -- upvalues: p2 (copy), v1 (copy)
                local v40 = p18(p2.TextSizeLimit) or {}

                if p18(v40.Max) == nil and p18(v40.Min) == nil then
                    return
                end

                return v1:New("UITextSizeConstraint")({
                    MaxTextSize = v40.Max,
                    MinTextSize = v40.Min
                })
            end),
            v1:Computed(function(p19) -- line: 632
                -- upvalues: p2 (copy), v1 (copy), v9 (copy)
                local v42 = p19(v9) or {}

                if p19(p2.List) == nil or p19(v42.Enabled) == false then
                    return
                end

                return v1:New("UIListLayout")({
                    Padding = v42.Padding,
                    FillDirection = v42.FillDirection,
                    SortOrder = v42.SortOrder,
                    Wraps = v42.Wraps,
                    HorizontalAlignment = v42.HorizontalAlignment,
                    HorizontalFlex = v42.HorizontalFlex,
                    ItemLineAlignment = v42.ItemLineAlignment,
                    VerticalAlignment = v42.VerticalAlignment,
                    VerticalFlex = v42.VerticalFlex
                })
            end),
            v1:Computed(function(p20) -- line: 650
                -- upvalues: p2 (copy), v1 (copy), v10 (copy)
                local v44 = p20(v10) or {}

                if p20(p2.Grid) == nil or p20(v44.Enabled) == false then
                    return
                end

                return v1:New("UIGridLayout")({
                    CellPadding = v44.CellPadding,
                    CellSize = v44.CellSize,
                    FillDirection = v44.FillDirection,
                    FillDirectionMaxCells = v44.FillDirectionMaxCells,
                    SortOrder = v44.SortOrder,
                    StartCorner = v44.StartCorner,
                    HorizontalAlignment = v44.HorizontalAlignment,
                    VerticalAlignment = v44.VerticalAlignment
                })
            end),
            v1:Computed(function(p21) -- line: 667
                -- upvalues: p2 (copy), v1 (copy), v11 (copy)
                local v46 = p21(v11) or {}

                if p21(p2.Table) == nil or p21(v46.Enabled) == false then
                    return
                end

                return v1:New("UITableLayout")({
                    Padding = v46.Padding,
                    FillEmptySpaceColumns = v46.FillEmptySpaceColumns,
                    FillEmptySpaceRows = v46.FillEmptySpaceRows,
                    FillDirection = v46.FillDirection,
                    SortOrder = v46.SortOrder,
                    MajorAxis = v46.MajorAxis,
                    HorizontalAlignment = v46.HorizontalAlignment,
                    VerticalAlignment = v46.VerticalAlignment
                })
            end),
            v1:Computed(function(p22) -- line: 686
                -- upvalues: p2 (copy), v1 (copy), v12 (copy)
                local v48 = p22(v12) or {}

                if p22(p2.Page) == nil or p22(v48.Enabled) == false then
                    return
                end

                return v1:New("UIPageLayout")({
                    Animated = v48.Animated,
                    Circular = v48.Circular,
                    EasingDirection = v48.EasingDirection,
                    EasingStyle = v48.EasingStyle,
                    Padding = v48.Padding,
                    TweenTime = v48.TweenTime,
                    FillDirection = v48.FillDirection,
                    SortOrder = v48.SortOrder,
                    HorizontalAlignment = v48.HorizontalAlignment,
                    VerticalAlignment = v48.VerticalAlignment,
                    GamepadInputEnabled = v48.GamepadInputEnabled,
                    ScrollWheelInputEnabled = v48.ScrollWheelInputEnabled,
                    TouchInputEnabled = v48.TouchInputEnabled
                })
            end),
            v1:Computed(function(p23) -- line: 708
                -- upvalues: p2 (copy), v1 (copy)
                local v49 = p23(p2.Flex) or {}

                if p23(p2.Flex) == nil or p23(v49.Mode) == Enum.UIFlexMode.None then
                    return
                end

                return v1:New("UIFlexItem")({
                    FlexMode = v49.Mode,
                    FlexItemLineAlignment = v49.ItemLineAlignment,
                    FlexGrowRatio = v49.GrowRatio,
                    FlexShrinkRatio = v49.ShrinkRatio
                })
            end),
            p2[Children]
        }
    })
end
