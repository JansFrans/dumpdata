-- https://lua.expert

local t1 = {
    appVersion = "v2.1.0",
    latestVersion = nil,
    updatesUrl = "create.roblox.com/store/asset/857927023/HD",
    tryItUrl = "roblox.com/games/start?placeId=106966695720565"
}
local v1 = false

local function isV2Version(p1) -- line: 25
    if type(p1) ~= "string" then
        return false
    end

    local v2 = string.match(p1, "^v(%d+)")

    return v2 ~= nil and tonumber(v2) >= 2
end

function t1.getLatestVersion() -- line: 35
    -- upvalues: t1 (copy), v1 (ref)
    if t1.latestVersion then
        return t1.latestVersion
    end

    if v1 then
        repeat
            task.wait()
        until not v1

        return t1.latestVersion
    end

    v1 = true

    local result

    while true do
        local function v3() -- line: 50
            return game:GetService("MarketplaceService"):GetProductInfo(79941590401581)
        end

        local ok

        ok, result = pcall(v3)

        if not ok then
            task.wait(1)
            continue
        end

        if type(result) ~= "table" then
            task.wait(1)
            continue
        end

        if type(result.Name) == "string" then
            break
        end

        task.wait(1)
    end

    local Name = result.Name
    local v4 = string.match(Name, "^HD Admin%s+(.+)$")
    local v5 = v4 and v4:match("^%s*(.-)%s*$")

    t1.latestVersion = v5
    v1 = false

    return v5
end

function t1.getAppVersion() -- line: 71
    -- upvalues: t1 (copy)
    return t1.appVersion
end

function t1.isOutdatedVersion(p2) -- line: 75
    -- upvalues: t1 (copy)
    local v6 = false

    if type(p2) == "string" then
        local v7 = string.match(p2, "^v(%d+)")

        v6 = v7 ~= nil and tonumber(v7) >= 2
    end

    return v6 and p2 ~= t1.appVersion
end

function t1.isUpToDate() -- line: 79
    -- upvalues: t1 (copy)
    return not t1.isOutdatedVersion(t1.getLatestVersion())
end

function t1.getOutdatedText(p3) -- line: 83
    -- upvalues: t1 (copy)
    local v8 = p3 ~= nil and p3.autoUpdate == true
    local updateSource = if p3 then p3.updateSource else nil
    local v9 = if not v8 then "A new version of HD Admin%s is available. Set 'AutoUpdate' to 'true' on 'HD Admin' to receive the latest changes, or get a new model by clicking here." elseif updateSource == "live" then "A new version of HD Admin%s is available. Get a new model by clicking here." else "A new version of HD Admin%s is available. Updates couldn't be retrieved so you're running the built-in-copy. Get a new model by clicking here."
    local latestVersion = t1.latestVersion
    local v10 = if typeof(latestVersion) == "string" then (" (%*)"):format(latestVersion) else ""

    return string.format(v9, v10)
end

return t1
