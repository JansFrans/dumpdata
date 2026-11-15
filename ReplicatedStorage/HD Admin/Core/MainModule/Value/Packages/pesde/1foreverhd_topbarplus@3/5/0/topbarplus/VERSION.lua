-- https://lua.expert

local t1 = {
    appVersion = "v3.5.0",
    latestVersion = nil
}

function t1.getLatestVersion() -- line: 14
    -- upvalues: t1 (copy)
    local latestVersion = t1.latestVersion

    if latestVersion then
        return latestVersion
    end

    local result

    while true do
        local function v1() -- line: 22
            return game:GetService("MarketplaceService"):GetProductInfoAsync(117501901079852)
        end

        local ok

        ok, result = pcall(v1)

        if not ok then
            task.wait(1)
            continue
        end

        if result then
            break
        end

        task.wait(1)
    end

    local Name = result.Name
    local v2 = string.match(Name, "(%d+%.%d+%.%d+)")
    local v3 = if v2 then "v" .. v2 else nil

    t1.latestVersion = v3

    return v3
end

function t1.getAppVersion() -- line: 38
    -- upvalues: t1 (copy)
    return t1.appVersion
end

function t1.isUpToDate() -- line: 42
    -- upvalues: t1 (copy)
    local v4 = t1.getLatestVersion()
    local v5 = t1.getAppVersion()

    return v4 ~= nil and v4 == v5
end

return t1
