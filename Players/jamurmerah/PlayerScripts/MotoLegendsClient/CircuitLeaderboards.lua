-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("RunService")

local CollectionService = game:GetService("CollectionService")
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local t1 = {}
local LeaderboardBoardUI = require(MotoLegends:WaitForChild("LeaderboardBoardUI"))
local LegendRig = require(MotoLegends:WaitForChild("LegendRig"))
local LeaderboardRemotes = ReplicatedStorage:WaitForChild("LeaderboardRemotes")
local Request = LeaderboardRemotes:WaitForChild("Request")
local Updated = LeaderboardRemotes:WaitForChild("Updated")
local LeaderboardRigs = ReplicatedStorage:WaitForChild("LeaderboardRigs")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local t2 = {}
local t3 = {}

local function active(p1) -- line: 40
    return p1.scr ~= nil and p1.scr.views[p1.scr.cur] == p1
end

local Track = require(MotoLegends:WaitForChild("Config")).Track

local function off(p2) -- line: 48
    if p2:IsA("BasePart") and p2.CanQuery then
        p2.CanQuery = false
    end
end

task.spawn(function() -- line: 49
    -- upvalues: Track (copy), off (copy)
    local v1 = workspace:WaitForChild(Track, 60)

    if v1 then
        local v2 = v1:WaitForChild("TrackLimits", 60)

        if v2 then
            v2.DescendantAdded:Connect(off)

            for v3, descendant in v2:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.CanQuery then
                    descendant.CanQuery = false
                end

                if v3 % 500 == 0 then
                    task.wait()
                end
            end
        end
    end
end)

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local v4 = MotoLegends:WaitForChild("OpenProfile", 30)

local function openFor(p3, p4) -- line: 61
    -- upvalues: v4 (copy)
    local v5, u, t4, v6, v7

    if typeof(p3) == "table" then
        if typeof(p3.u) == "number" and v4 then
            v5 = v4
            u = p3.u
            t4 = {}
            v6 = p3.d or p3.n
            v7 = false
        else
            v7 = true
        end
    else
        v7 = true
    end

    if v7 then
        return
    end

    t4.name = v6
    t4.country = p3.c ~= "" and p3.c or nil
    t4.bike = p3.b ~= "" and p3.b or nil
    t4.pts = p4 == "points" and p3.v or nil
    v5:Fire(u, t4)
end

local v8 = Color3.fromRGB(12, 12, 14)
local v9 = Color3.fromRGB(34, 34, 38)

local function wire(p5, p6, p7, p8) -- line: 71
    -- upvalues: UserInputService (copy), TweenService (copy), openFor (copy), v8 (copy), v9 (copy)
    local function show(p9) -- line: 72
        -- upvalues: p8 (copy), TweenService (copy), v8 (copy), v9 (copy)
        TweenService:Create(p8.stroke, TweenInfo.new(if p9 then 0.12 else 0.15), {
            Transparency = p9 and 0 or 1
        }):Play()

        if p8.bar then
            TweenService:Create(p8.bar, TweenInfo.new(if p9 then 0.12 else 0.15), {
                BackgroundColor3 = p9 and v9 or v8
            }):Play()
        end
    end

    p5.MouseEnter:Connect(function() -- line: 76
        -- upvalues: p6 (copy), show (copy), UserInputService (copy)
        if p6() then
            UserInputService.MouseIcon = "rbxasset://SystemCursors/PointingHand"
            show(true)
        end
    end)
    p5.MouseLeave:Connect(function() -- line: 81
        -- upvalues: p8 (copy), show (copy), UserInputService (copy), TweenService (copy)
        UserInputService.MouseIcon = ""
        show(false)

        if p8.scale then
            TweenService:Create(p8.scale, TweenInfo.new(0.12), {
                Scale = 1
            }):Play()
        end
    end)
    p5.MouseButton1Down:Connect(function() -- line: 86
        -- upvalues: p6 (copy), p8 (copy), TweenService (copy)
        if p8.scale and p6() then
            TweenService:Create(p8.scale, TweenInfo.new(0.08), {
                Scale = 0.97
            }):Play()
        end
    end)
    p5.MouseButton1Up:Connect(function() -- line: 89
        -- upvalues: p8 (copy), TweenService (copy)
        if p8.scale then
            TweenService:Create(p8.scale, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
                Scale = 1
            }):Play()
        end
    end)
    p5.Activated:Connect(function() -- line: 92
        -- upvalues: p6 (copy), p7 (copy), show (copy), UserInputService (copy), openFor (copy)
        local v12 = p6()

        if not v12 then
            return
        end

        show(false)
        UserInputService.MouseIcon = ""
        openFor(v12, p7())
    end)
end

local v13

local function rowAt(p10, p11) -- line: 101
    return p10.rows[p11] or p10.old[p11]
end

local function absorb(p12, p13) -- line: 105
    -- upvalues: v13 (ref)
    local v14 = true

    if typeof(p13) == "table" then
        if typeof(p13.v) ~= "number" or p13.v < p12.version then
        else
            if p13.v > p12.version then
                p12.old = p12.rows
                p12.rows = {}
                p12.version = p13.v
                p12.pending = {}
                p12.loaded = 0
                p12.finished = false
            end

            v14 = false
        end
    end

    if v14 then
        return
    end

    p12.loaded = math.max(p12.loaded, tonumber(p13.loaded) or 0)
    p12.finished = p12.finished or p13.finished == true
    p12.status = p13.status or p12.status

    for _, v16 in p13.rows or {} do
        p12.rows[v16.r] = v16
    end

    for _, v17 in p13.top or {} do
        p12.rows[v17.r] = v17
    end

    if p13.you then
        p12.you = p13.you
    end

    v13(p12)
end

local function need(p14, p15) -- line: 119
    -- upvalues: Request (copy), v13 (ref), absorb (copy)
    local v18 = (p15 - 1) // 20

    if p14.pending[v18] then
        return
    end

    local pending = p14.pending

    pending[v18] = true
    task.spawn(function() -- line: 123
        -- upvalues: p14 (copy), v18 (copy), pending (copy), Request (copy), v13 (ref), absorb (copy)
        local InvokeServer = Request.InvokeServer
        local id = p14.id
        local v19 = v18 * 20 + 1
        local ok, result = pcall(InvokeServer, Request, id, v19, 20)

        if ok and typeof(result) == "table" and not result.busy then
            pending[v18] = nil
            absorb(p14, result)
        else
            task.delay(2, function() -- line: 129
                -- upvalues: p14 (copy), v18 (copy), pending (copy), v13 (ref)
                pending[v18] = nil
                v13(p14)
            end)
        end
    end)
end

v13 = function(p16) -- line: 134
    -- upvalues: LeaderboardBoardUI (copy), Request (copy), LocalPlayer (copy), v13 (ref), absorb (copy)
    if p16.scr == nil or p16.scr.views[p16.scr.cur] ~= p16 then
        return
    end

    local refs = p16.scr.refs
    local v21 = math.max(0, p16.loaded - 3) + (if p16.finished or not (p16.loaded >= 3) then 0 else 1)

    refs.List.CanvasSize = UDim2.fromOffset(0, v21 * LeaderboardBoardUI.Stride)

    local v24 = math.max(0, (math.floor(refs.List.CanvasPosition.Y / LeaderboardBoardUI.Stride)))

    for v25, v26 in p16.scr.pool do
        local v27 = v24 + v25 - 1

        if v27 < v21 then
            local v28 = v27 + 4

            v26.Frame.Position = UDim2.fromOffset(3, v27 * LeaderboardBoardUI.Stride + 3)
            v26.Frame.Visible = true
            v26.data = v28 <= p16.loaded and (p16.rows[v28] or p16.old[v28]) or nil
            LeaderboardBoardUI.FillRow(v26, v28, v26.data, p16.kind)

            if not p16.rows[v28] and (v28 <= p16.loaded or not p16.finished) then
                local v29 = (v28 - 1) // 20

                if not p16.pending[v29] then
                    local pending = p16.pending

                    pending[v29] = true
                    task.spawn(function() -- line: 123
                        -- upvalues: p16 (copy), v29 (copy), pending (copy), Request (copy), v13 (ref), absorb (copy)
                        local InvokeServer = Request.InvokeServer
                        local id = p16.id
                        local v30 = v29 * 20 + 1
                        local ok, result = pcall(InvokeServer, Request, id, v30, 20)

                        if ok and typeof(result) == "table" and not result.busy then
                            pending[v29] = nil
                            absorb(p16, result)
                        else
                            task.delay(2, function() -- line: 129
                                -- upvalues: p16 (copy), v29 (copy), pending (copy), v13 (ref)
                                pending[v29] = nil
                                v13(p16)
                            end)
                        end
                    end)
                end
            end

            continue
        end

        v26.Frame.Visible = false
    end

    for i = 1, 3 do
        local v31, v32

        if i <= p16.loaded then
            local v33 = p16.rows[i]

            if v33 then
                v31 = v33
                v32 = true
            else
                v33 = p16.old[i]

                if v33 then
                    v31 = v33
                    v32 = true
                else
                    v32 = false
                end
            end
        else
            v32 = false
        end

        if not v32 then
            v31 = nil
        end

        if v31 and not p16.rows[i] then
            local v34 = (i - 1) // 20

            if not p16.pending[v34] then
                local pending = p16.pending

                pending[v34] = true
                task.spawn(function() -- line: 123
                    -- upvalues: p16 (copy), v34 (copy), pending (copy), Request (copy), v13 (ref), absorb (copy)
                    local InvokeServer = Request.InvokeServer
                    local id = p16.id
                    local v35 = v34 * 20 + 1
                    local ok, result = pcall(InvokeServer, Request, id, v35, 20)

                    if ok and typeof(result) == "table" and not result.busy then
                        pending[v34] = nil
                        absorb(p16, result)
                    else
                        task.delay(2, function() -- line: 129
                            -- upvalues: p16 (copy), v34 (copy), pending (copy), v13 (ref)
                            pending[v34] = nil
                            v13(p16)
                        end)
                    end
                end)
            end
        end

        local v36 = refs.Cards[i]

        LeaderboardBoardUI.FillCard(v36, i, v31, p16.kind)

        local View = v36.View

        if v31 == nil or v36.rig == nil then
            View.Visible = false
        else
            View.Visible = v36.src:GetAttribute("UserId") == v31.u
        end
    end

    LeaderboardBoardUI.FillYou(refs.You, p16.you or {
        n = LocalPlayer.Name
    }, p16.kind)

    local v37 = if p16.status == "error" and p16.loaded == 0 then "Leaderboard unavailable right now"
        elseif p16.status == "loading" and p16.loaded == 0 then "Loading..."
        elseif p16.loaded == 0 then "No riders yet - be the first!"
        else ""

    refs.Status.Text = v37
    refs.Status.Visible = v37 ~= ""
end

local function syncRigs(p17) -- line: 168
    -- upvalues: LeaderboardBoardUI (copy), LeaderboardRigs (copy), v13 (ref)
    if p17.scr ~= nil and p17.scr.views[p17.scr.cur] == p17 then
        local v38 = LeaderboardRigs:FindFirstChild(p17.id)

        for i = 1, 3 do
            local v39 = p17.scr.refs.Cards[i]
            local child

            if v38 then
                local child2

                for _, child3 in v38:GetChildren() do
                    if child3:GetAttribute("Rank") == i then
                        child2 = child3
                    end

                    child = child2
                end
            end

            local v40 = if child then #child:GetDescendants() else nil
            local v41 = if not child or not v40 then 0 else v40

            if v39.src ~= child or child and v39.srcCount ~= v41 then
                if v39.rig then
                    v39.rig:Destroy()
                    v39.rig = nil
                end

                v39.src = child
                v39.legend = nil
                v39.srcCount = v41
                v39.joints = nil

                if child then
                    local Clone = child.Clone
                    local ok, result = pcall(Clone, child)

                    if ok and result then
                        result.Parent = v39.World
                        v39.rig = result

                        local t7 = {}

                        for _, descendant in result:GetDescendants() do
                            if descendant:IsA("Motor6D") then
                                descendant.Transform = CFrame.identity
                                table.insert(t7, {
                                    j = descendant,
                                    name = descendant.Name,
                                    base = descendant.C0
                                })
                            elseif descendant:IsA("AnimationConstraint") and descendant.Attachment0 then
                                descendant.Transform = CFrame.identity
                                table.insert(t7, {
                                    a = descendant.Attachment0,
                                    name = descendant.Name,
                                    base = descendant.Attachment0.CFrame
                                })
                            end
                        end

                        v39.joints = t7
                    end
                end
            end

            local LegendId = if child then child:GetAttribute("LegendId") else nil
            local v42 = if not child or not LegendId then "" else LegendId

            if v39.rig and v39.legend ~= v42 then
                v39.legend = v42

                local FrameRig = LeaderboardBoardUI.FrameRig
                local rig = v39.rig

                pcall(FrameRig, v39, rig, v42)
            end
        end

        v13(p17)
    end
end

local function header(p18) -- line: 210
    -- upvalues: LeaderboardBoardUI (copy)
    if p18.scr == nil or p18.scr.views[p18.scr.cur] ~= p18 then
        return
    end

    local src = p18.src
    local v43 = src:GetAttribute("LeaderboardSubtitle") or ""
    local LeaderboardResetAt = src:GetAttribute("LeaderboardResetAt")

    if typeof(LeaderboardResetAt) == "number" then
        local v46 = math.max(0, (math.floor(LeaderboardResetAt - workspace:GetServerTimeNow())))
        local v47 = v46 // 86400
        local v48 = v46 // 3600 % 24
        local v49 = v46 // 60 % 60
        local v50 = v46 % 60
        local v51 = v47 > 0 and string.format("%dD %02dH %02dM", v47, v48, v49) or string.format("%02dH %02dM %02dS", v48, v49, v50)

        v43 = (v43 ~= "" and v43 .. "  ·  " or "") .. "RESETS IN " .. v51
    end

    LeaderboardBoardUI.SetHeader(p18.scr.refs, src:GetAttribute("LeaderboardTitle") or "", src:GetAttribute("LeaderboardFlag") or "", v43, src:GetAttribute("LeaderboardWeather") or "")
end

local function viewSources(p19) -- line: 225
    local t10 = {}
    local LeaderboardViews = p19:FindFirstChild("LeaderboardViews")

    if LeaderboardViews then
        for _, child in LeaderboardViews:GetChildren() do
            if child:GetAttribute("LeaderboardId") then
                table.insert(t10, child)
            end
        end
    end

    table.sort(t10, function(p20, p21) -- line: 229
        return (p20:GetAttribute("Order") or 0) < (p21:GetAttribute("Order") or 0)
    end)

    if #t10 == 0 then
        t10 = { p19 }
    end

    return t10
end

local function showView(p22, p23) -- line: 234
    -- upvalues: Request (copy), v13 (ref), absorb (copy), syncRigs (copy), header (copy)
    local v52 = #p22.views

    if v52 == 0 then
        return
    end

    p22.cur = (p23 - 1) % v52 + 1

    local v53 = p22.views[p22.cur]

    p22.refs.Prev.Visible = v52 > 1
    p22.refs.Next.Visible = v52 > 1
    p22.refs.List.CanvasPosition = Vector2.zero

    if p22.closeSupport then
        p22.closeSupport()
    end

    for _, v54 in p22.pool do
        v54.data = nil
    end

    header(v53)
    syncRigs(v53)
    v13(v53)

    if v53.rows[1] or v53.pending[0] then
        return
    end

    local pending = v53.pending

    pending[0] = true

    local spawn = task.spawn
    local n1 = 0

    spawn(function() -- line: 123
        -- upvalues: v53 (copy), pending (copy), n1 (copy), Request (copy), v13 (ref), absorb (copy)
        local InvokeServer = Request.InvokeServer
        local id = v53.id
        local v55 = n1 * 20 + 1
        local ok, result = pcall(InvokeServer, Request, id, v55, 20)

        if ok and typeof(result) == "table" and not result.busy then
            pending[n1] = nil
            absorb(v53, result)
        else
            task.delay(2, function() -- line: 129
                -- upvalues: v53 (copy), pending (copy), n1 (copy), v13 (ref)
                pending[n1] = nil
                v13(v53)
            end)
        end
    end)
end

local function addView(p24, p25) -- line: 247
    -- upvalues: LeaderboardRigs (copy), t2 (copy), syncRigs (copy), header (copy), showView (copy)
    local LeaderboardId = p25:GetAttribute("LeaderboardId")
    local t11, v56

    if not LeaderboardId or t2[LeaderboardId] then
        return
    else
        t11 = {
            version = -1,
            loaded = 0,
            finished = false,
            status = "loading",
            id = LeaderboardId,
            src = p25,
            scr = p24,
            kind = p25:GetAttribute("LeaderboardKind") or "points",
            rows = {},
            old = {},
            pending = {}
        }
        t2[LeaderboardId] = t11

        local AttributeChanged = p25.AttributeChanged
        local t12 = t11

        AttributeChanged:Connect(function() -- line: 253
            -- upvalues: p25 (copy), t12 (copy), header (copy)
            t12.kind = p25:GetAttribute("LeaderboardKind") or t12.kind
            header(t12)
        end)
        task.spawn(function() -- line: 255
            -- upvalues: LeaderboardId (copy), t12 (copy), LeaderboardRigs (copy), syncRigs (copy)
            local v58 = LeaderboardRigs:WaitForChild(LeaderboardId, 60)

            if not v58 then
                return
            end

            v58.ChildAdded:Connect(function(p26) -- line: 258
                -- upvalues: t12 (copy), syncRigs (copy)
                p26.AttributeChanged:Connect(function() -- line: 258
                    -- upvalues: t12 (copy), syncRigs (copy)
                    syncRigs(t12)
                end)
                syncRigs(t12)
            end)
            v58.ChildRemoved:Connect(function() -- line: 259
                -- upvalues: t12 (copy), syncRigs (copy)
                syncRigs(t12)
            end)

            local v59 = false

            v58.DescendantAdded:Connect(function() -- line: 261
                -- upvalues: v59 (ref), t12 (copy), syncRigs (copy)
                if not v59 then
                    v59 = true
                    task.delay(0.5, function() -- line: 263
                        -- upvalues: v59 (ref), t12 (copy), syncRigs (copy)
                        v59 = false
                        syncRigs(t12)
                    end)
                end
            end)

            for _, child in v58:GetChildren() do
                child.AttributeChanged:Connect(function() -- line: 265
                    -- upvalues: t12 (copy), syncRigs (copy)
                    syncRigs(t12)
                end)
            end
        end)

        local v60 = p24.views[p24.cur]

        table.insert(p24.views, t11)
        table.sort(p24.views, function(p27, p28) -- line: 271
            return (p27.src:GetAttribute("Order") or 0) < (p28.src:GetAttribute("Order") or 0)
        end)
        v56 = v60 and table.find(p24.views, v60) or 1
    end

    p24.cur = v56
    p24.refs.Prev.Visible = #p24.views > 1
    p24.refs.Next.Visible = #p24.views > 1

    if t11.scr ~= nil and t11.scr.views[t11.scr.cur] == t11 then
        showView(p24, p24.cur)
    end
end

local function wireArrow(p29, p30, p31) -- line: 277
    -- upvalues: UserInputService (copy), TweenService (copy), showView (copy)
    local Rim = p29:FindFirstChild("Rim")

    p29.MouseEnter:Connect(function() -- line: 279
        -- upvalues: p29 (copy), Rim (copy), UserInputService (copy), TweenService (copy)
        UserInputService.MouseIcon = "rbxasset://SystemCursors/PointingHand"
        TweenService:Create(p29, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(220, 35, 45)
        }):Play()

        if Rim then
            TweenService:Create(Rim, TweenInfo.new(0.12), {
                Transparency = 0
            }):Play()
        end
    end)
    p29.MouseLeave:Connect(function() -- line: 284
        -- upvalues: p29 (copy), Rim (copy), UserInputService (copy), TweenService (copy)
        UserInputService.MouseIcon = ""
        TweenService:Create(p29, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(14, 14, 16)
        }):Play()

        if Rim then
            TweenService:Create(Rim, TweenInfo.new(0.15), {
                Transparency = 0.65
            }):Play()
        end
    end)
    p29.Activated:Connect(function() -- line: 289
        -- upvalues: p30 (copy), p31 (copy), showView (copy)
        showView(p31, p31.cur + p30)
    end)
end

local t13 = {
    WeeklyLapLeaderboard = 1,
    PointsLeaderboard = 0,
    DonationLeaderboard = -1
}

t1[1] = nil

local function pitHome(p32) -- line: 300
    -- upvalues: LocalPlayer (copy), t3 (copy), t13 (copy), t1 (copy)
    local v61 = t13[p32.model.Name]

    if v61 == nil then
        return nil
    end

    local PitboxIndex = LocalPlayer:GetAttribute("PitboxIndex")

    if not PitboxIndex then
        return nil
    end

    if not (t1[1] and t1[1].Parent) then
        t1[1] = workspace:FindFirstChild("PlayerPitboxes", true)
    end

    local v64 = t1[1] and t1[1]:FindFirstChild("Pitbox_" .. PitboxIndex)

    if not v64 or t1[1]:GetAttribute("Layout") == "Single" then
        return nil
    end

    if v61 == -1 then
        local v65 = tonumber(v64:GetAttribute("RoomBack"))

        if not v65 then
            v65 = tonumber(t1[1]:GetAttribute("RoomBack")) or 73.3
        end

        local v67 = tonumber(v64:GetAttribute("RearBack"))

        if not v67 then
            v67 = tonumber(t1[1]:GetAttribute("RearBack")) or 14.6
        end

        local v69 = v65 - v67

        return v64.CFrame * CFrame.new(0, 8.9, v69 - 0.5), 1
    end

    local v70 = tonumber(v64:GetAttribute("RoomHalf"))

    if not v70 then
        v70 = tonumber(t1[1]:GetAttribute("RoomHalf")) or 28.62
    end

    local v72 = tonumber(v64:GetAttribute("SideZ"))

    if not v72 then
        v72 = tonumber(t1[1]:GetAttribute("SideZ")) or 17.7
    end

    local v74 = v72 - 0.6
    local v77 = math.max(0.1, (math.min(0.6, v74 - -15.1 - 31)))
    local v78 = (-15.1 + v74) / 2 + (if v61 == 1 then 1 else -1) * (v77 + 15.5) / 2
    local v79 = -(v70 - 0.25) + 0.6

    if p32.wallFor == v64 and p32.wallX then
        v79 = p32.wallX
    else
        local v80 = RaycastParams.new()

        v80.FilterType = Enum.RaycastFilterType.Exclude

        local t14 = {}

        if LocalPlayer.Character then
            table.insert(t14, LocalPlayer.Character)
        end

        for _, v81 in t3 do
            table.insert(t14, v81.anchor)

            if v81.backing then
                table.insert(t14, v81.backing)
            end
        end

        v80.FilterDescendantsInstances = t14

        local n2 = (-1e999)

        for i = -7.25, 7.25, 3.625 do
            for _, v82 in { -6.5, 0, 6.5 } do
                local Position = (v64.CFrame * CFrame.new(-(v70 - 8), 8.9 + v82, v78 + i)).Position
                local v83 = v64.CFrame:VectorToWorldSpace((Vector3.new(-14, 0, 0)))

                for _ = 1, 4 do
                    local v84 = workspace:Raycast(Position, v83, v80)

                    if not v84 then
                        break
                    end

                    if v84.Instance.Transparency < 0.99 and (v84.Instance.CanCollide or v84.Instance.Name:find("Wall")) then
                        n2 = math.max(n2, v64.CFrame:PointToObjectSpace(v84.Position).X)
                        break
                    end

                    v80:AddToFilter(v84.Instance)
                end
            end
        end

        if n2 > (-1e999) and v79 < n2 + 0.6 then
            v79 = n2 + 0.6
        end

        if n2 > (-1e999) then
            p32.wallFor = v64
            p32.wallX = v79
        end
    end

    return v64.CFrame * CFrame.new(v79, 8.9, v78) * CFrame.Angles(0, -1.5707963267948966, 0), 1
end

local function placeScreen(p33) -- line: 349
    -- upvalues: t13 (copy), pitHome (copy)
    local v85, v86 = pitHome(p33)
    local v87 = v85 and p33.sb.Size * Vector3.new(v86, v86, 1) or p33.sb.Size

    p33.home = v85

    if p33.anchor.Size ~= v87 then
        p33.anchor.Size = v87
    end

    local v88 = p33.home or p33.sb.CFrame

    if p33.anchor.CFrame ~= v88 then
        p33.anchor.CFrame = v88
    end

    if not p33.backing then
        local Part = Instance.new("Part")

        Part.Name = "LeaderboardBacking"
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.Material = Enum.Material.SmoothPlastic
        Part.Color = Color3.fromRGB(16, 16, 20)
        Part.TopSurface = Enum.SurfaceType.Smooth
        Part.BottomSurface = Enum.SurfaceType.Smooth
        p33.backing = Part
    end

    if v85 then
        local Size = p33.anchor.Size
        local v91 = Vector3.new(Size.X + 0.4, Size.Y + 0.4, 0.12)
        local v92 = p33.anchor.CFrame * CFrame.new(0, 0, Size.Z / 2 + 0.08)

        if p33.backing.Size ~= v91 then
            p33.backing.Size = v91
        end

        if p33.backing.CFrame ~= v92 then
            p33.backing.CFrame = v92
        end

        if p33.backing.Parent ~= workspace then
            p33.backing.Parent = workspace
        end
    else
        p33.backing.Parent = nil
    end

    if t13[p33.model.Name] == nil then
        return
    end

    p33.gui.Enabled = v85 ~= nil

    local Credits = p33.sb:FindFirstChild("Credits")

    if Credits and Credits:IsA("SurfaceGui") then
        Credits.Enabled = false
    end
end

LocalPlayer:GetAttributeChangedSignal("PitboxIndex"):Connect(function() -- line: 379
    -- upvalues: t3 (copy), placeScreen (copy)
    for _, v93 in t3 do
        placeScreen(v93)
    end
end)
task.spawn(function() -- line: 380
    -- upvalues: t3 (copy), placeScreen (copy)
    while true do
        task.wait(3)

        for _, v94 in t3 do
            placeScreen(v94)
        end
    end
end)

local t15 = {}
local v95
local v96 = {}

local function restore() -- line: 389
    -- upvalues: t15 (copy)
    for v97 in t15 do
        if v97.Parent then
            v97.CanQuery = true
        end
    end

    table.clear(t15)
end

local function riding() -- line: 390
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid == nil or Humanoid.SeatPart == nil then
        return false
    end

    return Humanoid.SeatPart.Name == "RiderSeat"
end

local function roomParts(p34) -- line: 394
    -- upvalues: t1 (copy)
    local v98 = tonumber(p34:GetAttribute("RoomHalf"))

    if not v98 then
        v98 = tonumber(t1[1]:GetAttribute("RoomHalf")) or 28.62
    end

    local v100 = v98 + 1
    local v101 = tonumber(p34:GetAttribute("RoomBack"))

    if not v101 then
        v101 = tonumber(t1[1]:GetAttribute("RoomBack")) or 73.3
    end

    local v103 = v101 + 1
    local t16 = {}

    local function v104() -- line: 399
        return require(game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends"):WaitForChild("Config"))
    end

    local ok, result = pcall(v104)
    local v105 = workspace:FindFirstChild(ok and result.Track or "")

    local function consider(p35) -- line: 401
        -- upvalues: p34 (copy), v100 (copy), v103 (copy), t16 (copy)
        if p35:IsA("BasePart") and p35.Transparency >= 0.99 and not p35.CanCollide and p35.CanQuery then
            local v106 = p34.CFrame:ToObjectSpace(p35.CFrame)
            local v107 = p35.Size / 2
            local v110 = math.abs(v106.RightVector.X) * v107.X + math.abs(v106.UpVector.X) * v107.Y + math.abs(v106.LookVector.X) * v107.Z
            local v113 = math.abs(v106.RightVector.Y) * v107.X + math.abs(v106.UpVector.Y) * v107.Y + math.abs(v106.LookVector.Y) * v107.Z
            local v116 = math.abs(v106.RightVector.Z) * v107.X + math.abs(v106.UpVector.Z) * v107.Y + math.abs(v106.LookVector.Z) * v107.Z
            local Position = v106.Position

            if Position.X + v110 > -v100 and Position.X - v110 < v100 and Position.Y + v113 > 0 and Position.Y - v113 < 24 and Position.Z + v116 > -18 and Position.Z - v116 < v103 then
                table.insert(t16, p35)
            end
        end
    end

    local RaceCollision = v105 and v105:FindFirstChild("RaceCollision")
    local v117 = OverlapParams.new()

    v117.FilterType = Enum.RaycastFilterType.Include
    v117.FilterDescendantsInstances = {
        RaceCollision,
        t1[1]
    }

    local v118 = (v103 - 18) / 2
    local v119 = p34.CFrame * CFrame.new(0, 12, v118)
    local _workspace = workspace
    local v120 = v100 * 2
    local v121 = v103 + 18

    for _, v122 in _workspace:GetPartBoundsInBox(v119, Vector3.new(v120, 24, v121), v117) do
        if not v122:IsDescendantOf(t1[1]) or v122.Name == "PitboxLamp" then
            consider(v122)
        end
    end

    return t16
end

task.spawn(function() -- line: 423
    -- upvalues: LocalPlayer (copy), t1 (copy), t15 (copy), v95 (ref), v96 (ref), roomParts (copy)
    while true do
        task.wait(0.5)

        local PitboxIndex = LocalPlayer:GetAttribute("PitboxIndex")
        local v123 = PitboxIndex

        if PitboxIndex then
            v123 = t1[1]
            v123 = v123 and t1[1].Parent and t1[1]:FindFirstChild("Pitbox_" .. PitboxIndex)
        end

        local v124 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local v125 = false

        if v123 and v124 then
            local Character = LocalPlayer.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

            if Humanoid ~= nil and Humanoid.SeatPart ~= nil and Humanoid.SeatPart.Name == "RiderSeat" then
            else
                local v126 = v123.CFrame:PointToObjectSpace(v124.Position)
                local v127 = tonumber(v123:GetAttribute("RoomHalf"))

                if not v127 then
                    v127 = tonumber(t1[1]:GetAttribute("RoomHalf")) or 28.62
                end

                local v129 = tonumber(v123:GetAttribute("RoomBack"))

                if not v129 then
                    v129 = tonumber(t1[1]:GetAttribute("RoomBack")) or 73.3
                end

                v125 = math.abs(v126.X) < v127 + 2 and v126.Z > -22 and v126.Z < v129 + 2 and v126.Y > -6 and v126.Y < 30
            end
        end

        if v125 then
            if v95 ~= v123 then
                for v131 in t15 do
                    if v131.Parent then
                        v131.CanQuery = true
                    end
                end

                table.clear(t15)
                v95 = v123
                v96 = roomParts(v123)
            end

            for _, v132 in v96 do
                if v132.Parent and v132.CanQuery then
                    v132.CanQuery = false
                    t15[v132] = true
                end
            end
        elseif next(t15) then
            for v133 in t15 do
                if v133.Parent then
                    v133.CanQuery = true
                end
            end

            table.clear(t15)
        end
    end
end)

local function setup(p36) -- line: 443
    -- upvalues: LeaderboardBoardUI (copy), LocalPlayer (copy), PlayerGui (copy), t3 (copy), UserInputService (copy), TweenService (copy), wire (copy), v13 (ref), syncRigs (copy), header (copy), viewSources (copy), showView (copy), addView (copy), wireArrow (copy), placeScreen (copy)
    local LeaderboardId = p36:GetAttribute("LeaderboardId")

    while not LeaderboardId do
        p36:GetAttributeChangedSignal("LeaderboardId"):Wait()
        LeaderboardId = p36:GetAttribute("LeaderboardId")
    end

    if t3[p36] then
        return
    end

    local ScoreBlock = p36:WaitForChild("ScoreBlock")
    local v134, v135 = LeaderboardBoardUI.Build()

    v134.Name = "CircuitLeaderboard_" .. LeaderboardId

    local Part = Instance.new("Part")

    Part.Name = "LeaderboardFloat_" .. LeaderboardId
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = true
    Part.Transparency = 1
    Part.CastShadow = false
    Part.Size = ScoreBlock.Size
    Part.CFrame = ScoreBlock.CFrame
    Part.Parent = workspace
    v134.Adornee = Part
    v134.Parent = PlayerGui

    local n3 = 0

    for _ in t3 do
        n3 += 1
    end

    local t17 = {
        cur = 1,
        model = p36,
        sb = ScoreBlock,
        anchor = Part,
        phase = (n3 + 1) * 1.3 + #LeaderboardId % 5,
        gui = v134,
        refs = v135,
        pool = {},
        views = {}
    }

    t3[p36] = t17
    placeScreen(t17)

    local function cur() -- line: 462
        -- upvalues: t17 (copy)
        return t17.views[t17.cur]
    end

    local MarketplaceService = game:GetService("MarketplaceService")
    local v136 = LeaderboardBoardUI.BuildSupport(v135)

    local function progress() -- line: 469
        -- upvalues: v135 (copy), LeaderboardBoardUI (copy), LocalPlayer (copy)
        LeaderboardBoardUI.SetSupportProgress(v135, LocalPlayer:GetAttribute("RobuxDonated") or 0)
    end

    LocalPlayer:GetAttributeChangedSignal("RobuxDonated"):Connect(progress)
    LeaderboardBoardUI.SetSupportProgress(v135, LocalPlayer:GetAttribute("RobuxDonated") or 0)

    local function setOpen(p37) -- line: 471
        -- upvalues: v135 (copy), t17 (copy), v136 (copy), LeaderboardBoardUI (copy), LocalPlayer (copy)
        local v137 = t17.views[t17.cur]
        local v138 = p37 and v137 ~= nil and v137.kind == "robux"

        if v138 then
            LeaderboardBoardUI.SetSupportProgress(v135, LocalPlayer:GetAttribute("RobuxDonated") or 0)
        end

        v136.Visible = v138
        v135.You.Support.Text = v138 and "CLOSE" or "SUPPORT"
    end

    t17.closeSupport = function() -- line: 476
        -- upvalues: v135 (copy), t17 (copy), v136 (copy)
        local _ = t17.views[t17.cur]
        local v139 = false

        v136.Visible = v139
        v135.You.Support.Text = v139 and "CLOSE" or "SUPPORT"
    end

    local Support = v135.You.Support

    Support.MouseEnter:Connect(function() -- line: 478
        -- upvalues: Support (copy), UserInputService (copy), TweenService (copy)
        UserInputService.MouseIcon = "rbxasset://SystemCursors/PointingHand"
        TweenService:Create(Support, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(255, 214, 90)
        }):Play()
    end)
    Support.MouseLeave:Connect(function() -- line: 479
        -- upvalues: Support (copy), UserInputService (copy), TweenService (copy)
        UserInputService.MouseIcon = ""
        TweenService:Create(Support, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.new(1, 1, 1)
        }):Play()
    end)
    Support.Activated:Connect(function() -- line: 480
        -- upvalues: v135 (copy), t17 (copy), v136 (copy), LeaderboardBoardUI (copy), LocalPlayer (copy)
        local v140 = not v136.Visible
        local v141 = t17.views[t17.cur]

        if v140 then
            v140 = v141 ~= nil and v141.kind == "robux"
        end

        if v140 then
            LeaderboardBoardUI.SetSupportProgress(v135, LocalPlayer:GetAttribute("RobuxDonated") or 0)
        end

        v136.Visible = v140
        v135.You.Support.Text = v140 and "CLOSE" or "SUPPORT"
    end)

    local SupportBack = v135.SupportBack

    SupportBack.MouseEnter:Connect(function() -- line: 482
        -- upvalues: SupportBack (copy), UserInputService (copy), TweenService (copy)
        UserInputService.MouseIcon = "rbxasset://SystemCursors/PointingHand"
        TweenService:Create(SupportBack, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(220, 35, 45)
        }):Play()
    end)
    SupportBack.MouseLeave:Connect(function() -- line: 483
        -- upvalues: SupportBack (copy), UserInputService (copy), TweenService (copy)
        UserInputService.MouseIcon = ""
        TweenService:Create(SupportBack, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(14, 14, 16)
        }):Play()
    end)
    SupportBack.Activated:Connect(function() -- line: 484
        -- upvalues: v135 (copy), t17 (copy), v136 (copy)
        local _ = t17.views[t17.cur]
        local v142 = false

        v136.Visible = v142
        v135.You.Support.Text = v142 and "CLOSE" or "SUPPORT"
    end)

    for _, v143 in v135.SupportRows do
        local Hover = v143.button:FindFirstChild("Hover")
        local Press = v143.button:FindFirstChild("Press")

        v143.button.MouseEnter:Connect(function() -- line: 487
            -- upvalues: v143 (copy), Hover (copy), UserInputService (copy), TweenService (copy)
            UserInputService.MouseIcon = "rbxasset://SystemCursors/PointingHand"
            TweenService:Create(Hover, TweenInfo.new(0.12), {
                Transparency = 0
            }):Play()
            TweenService:Create(v143.button, TweenInfo.new(0.12), {
                BackgroundColor3 = Color3.fromRGB(34, 34, 38)
            }):Play()
            TweenService:Create(v143.pill, TweenInfo.new(0.12), {
                BackgroundColor3 = Color3.fromRGB(220, 35, 45)
            }):Play()
            TweenService:Create(v143.pillText, TweenInfo.new(0.12), {
                TextColor3 = Color3.new(1, 1, 1)
            }):Play()
        end)
        v143.button.MouseLeave:Connect(function() -- line: 492
            -- upvalues: v143 (copy), Hover (copy), Press (copy), UserInputService (copy), TweenService (copy)
            UserInputService.MouseIcon = ""
            TweenService:Create(Hover, TweenInfo.new(0.15), {
                Transparency = 1
            }):Play()
            TweenService:Create(v143.button, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(12, 12, 14)
            }):Play()
            TweenService:Create(v143.pill, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.new(1, 1, 1)
            }):Play()
            TweenService:Create(v143.pillText, TweenInfo.new(0.15), {
                TextColor3 = Color3.fromRGB(14, 14, 16)
            }):Play()

            if Press then
                TweenService:Create(Press, TweenInfo.new(0.12), {
                    Scale = 1
                }):Play()
            end
        end)
        v143.button.MouseButton1Down:Connect(function() -- line: 498
            -- upvalues: Press (copy), TweenService (copy)
            if Press then
                TweenService:Create(Press, TweenInfo.new(0.08), {
                    Scale = 0.97
                }):Play()
            end
        end)
        v143.button.MouseButton1Up:Connect(function() -- line: 499
            -- upvalues: Press (copy), TweenService (copy)
            if Press then
                TweenService:Create(Press, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
                    Scale = 1
                }):Play()
            end
        end)
        v143.button.Activated:Connect(function() -- line: 500
            -- upvalues: MarketplaceService (copy), v143 (copy), LocalPlayer (copy)
            local PromptProductPurchase = MarketplaceService.PromptProductPurchase
            local product = v143.product

            pcall(PromptProductPurchase, MarketplaceService, LocalPlayer, product)
        end)
    end

    local function kind() -- line: 503
        -- upvalues: t17 (copy)
        local v144 = t17.views[t17.cur]

        return v144 and v144.kind or "points"
    end

    for i = 1, math.ceil(LeaderboardBoardUI.ListH / LeaderboardBoardUI.Stride) + 2 do
        local v146 = LeaderboardBoardUI.MakeRow(v135.List)

        t17.pool[i] = v146
        wire(v146.Hit, function() -- line: 506
            -- upvalues: v146 (copy)
            return v146.data
        end, kind, {
            stroke = v146.Hover,
            bar = v146.Frame,
            scale = v146.Scale
        })
    end

    for i = 1, 3 do
        local v147 = v135.Cards[i]

        wire(v147.Hit, function() -- line: 510
            -- upvalues: t17 (copy), i (copy)
            local v148 = t17.views[t17.cur]
            local v149, v150

            if v148 and i <= v148.loaded then
                local v151 = v148.rows[i]

                if v151 then
                    v149 = v151
                    v150 = true
                else
                    v151 = v148.old[i]

                    if v151 then
                        v149 = v151
                        v150 = true
                    else
                        v150 = false
                    end
                end
            else
                v150 = false
            end

            if not v150 then
                v149 = nil
            end

            return v149
        end, kind, {
            stroke = v147.Hover
        })
    end

    wire(v135.You.Hit, function() -- line: 512
        -- upvalues: t17 (copy), LocalPlayer (copy)
        local v152 = t17.views[t17.cur]
        local you = v152 and v152.you or {}

        return {
            u = LocalPlayer.UserId,
            n = LocalPlayer.Name,
            d = LocalPlayer.DisplayName,
            c = you.c or "",
            b = you.b or "",
            v = you.v
        }
    end, kind, {
        stroke = v135.You.Hover,
        scale = v135.You.Scale
    })
    wireArrow(v135.Prev, -1, t17)
    wireArrow(v135.Next, 1, t17)
    v135.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 517
        -- upvalues: t17 (copy), v13 (ref)
        local v153 = t17.views[t17.cur]

        if v153 then
            v13(v153)
        end
    end)

    for _, v154 in viewSources(p36) do
        addView(t17, v154)
    end

    local function watchFolder(p38) -- line: 519
        -- upvalues: t17 (copy), addView (copy)
        p38.ChildAdded:Connect(function(p39) -- line: 520
            -- upvalues: t17 (copy), addView (copy)
            if not p39:GetAttribute("LeaderboardId") then
                p39:GetAttributeChangedSignal("LeaderboardId"):Wait()
            end

            addView(t17, p39)
        end)
    end

    local LeaderboardViews = p36:FindFirstChild("LeaderboardViews")

    if LeaderboardViews then
        LeaderboardViews.ChildAdded:Connect(function(p40) -- line: 520
            -- upvalues: t17 (copy), addView (copy)
            if not p40:GetAttribute("LeaderboardId") then
                p40:GetAttributeChangedSignal("LeaderboardId"):Wait()
            end

            addView(t17, p40)
        end)
    else
        p36.ChildAdded:Connect(function(p41) -- line: 527
            -- upvalues: t17 (copy), addView (copy)
            if p41.Name == "LeaderboardViews" then
                p41.ChildAdded:Connect(function(p42) -- line: 520
                    -- upvalues: t17 (copy), addView (copy)
                    if not p42:GetAttribute("LeaderboardId") then
                        p42:GetAttributeChangedSignal("LeaderboardId"):Wait()
                    end

                    addView(t17, p42)
                end)

                for _, child in p41:GetChildren() do
                    if child:GetAttribute("LeaderboardId") then
                        addView(t17, child)
                    end
                end
            end
        end)
    end

    task.spawn(function() -- line: 533
        -- upvalues: v134 (copy), t17 (copy), header (copy)
        while v134.Parent do
            local v155 = t17.views[t17.cur]

            if v155 then
                header(v155)
            end

            task.wait(1)
        end
    end)
    task.spawn(function() -- line: 534
        -- upvalues: v134 (copy), t17 (copy), syncRigs (copy)
        while v134.Parent do
            local v156 = t17.views[t17.cur]

            if v156 then
                syncRigs(v156)
            end

            task.wait(3)
        end
    end)
    showView(t17, t17.cur)
end

Updated.OnClientEvent:Connect(function(p43, p44) -- line: 538
    -- upvalues: t2 (copy), absorb (copy)
    local v157 = t2[p43]

    if v157 and typeof(p44) == "table" then
        absorb(v157, {
            v = p44.v,
            loaded = p44.loaded,
            finished = p44.finished,
            status = p44.status,
            top = p44.top,
            you = p44.you
        })
    end
end)
CollectionService:GetInstanceAddedSignal("CircuitLeaderboard"):Connect(function(p45) -- line: 543
    -- upvalues: setup (copy)
    task.spawn(setup, p45)
end)

for _, v158 in CollectionService:GetTagged("CircuitLeaderboard") do
    task.spawn(setup, v158)
end

local function poseCard(p46, p47, p48) -- line: 548
    -- upvalues: LegendRig (copy)
    local v159 = LegendRig.JointRotations(p47, p48)

    if v159 and p46.joints then
        for _, v160 in p46.joints do
            local v161 = v159[v160.name]

            if v161 then
                local v162 = CFrame.new(v160.base.Position) * v161 * v160.base.Rotation

                if v160.j then
                    v160.j.C0 = v162
                else
                    v160.a.CFrame = v162
                end
            end
        end
    end
end

local function onScreen(p49, p50) -- line: 559
    local v163 = p49:WorldToViewportPoint(p50)

    if v163.Z <= 0 then
        return false
    end

    local ViewportSize = p49.ViewportSize
    local v164 = math.max(ViewportSize.X, ViewportSize.Y) * 0.6

    if v163.X > -v164 and v163.X < ViewportSize.X + v164 and v163.Y > -v164 then
        return v163.Y < ViewportSize.Y + v164
    end

    return false
end

task.spawn(function() -- line: 571
    -- upvalues: t3 (copy), poseCard (copy)
    while true do
        task.wait(0.5)

        for _, v165 in t3 do
            for i = 1, 3 do
                local v166 = v165.refs.Cards[i]

                if v166.rig and v166.joints then
                    local v167 = v166.legend and v166.legend ~= "" and v166.legend or "Standing"
                    local v168 = tostring(v166.rig) .. "|" .. v167

                    if v166.posedKey ~= v168 then
                        v166.posedKey = v168
                        poseCard(v166, v167, 0)
                    end
                end
            end
        end
    end
end)
