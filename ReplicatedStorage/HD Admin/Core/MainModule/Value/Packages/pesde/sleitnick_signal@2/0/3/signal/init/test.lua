-- https://lua.expert

local ServerScriptService = game:GetService("ServerScriptService")

require(ServerScriptService.TestRunner.Test)

local function AwaitCondition(p1, p2) -- line: 5
    local elapsed = os.clock()

    p2 = p2 or 10

    while not p1() do
        if p2 < os.clock() - elapsed then
            return false
        end

        task.wait()
    end

    return true
end

return function(p3) -- line: 19
    -- upvalues: AwaitCondition (copy)
    local Parent = require(script.Parent)
    local t1 = {}

    t1[1] = nil
    p3:BeforeEach(function() -- line: 29
        -- upvalues: Parent (copy), t1 (copy)
        t1[1] = Parent.new()
    end)
    p3:AfterEach(function() -- line: 33
        -- upvalues: t1 (copy)
        t1[1]:Destroy()
    end)
    p3:Describe("Constructor", function() -- line: 37
        -- upvalues: p3 (copy), Parent (copy), t1 (copy), AwaitCondition (copy)
        p3:Test("should create a new signal and fire it", function() -- line: 38
            -- upvalues: p3 (copy), Parent (copy), t1 (copy)
            p3:Expect(Parent.Is(t1[1])):ToBe(true)
            task.defer(function() -- line: 40
                -- upvalues: t1 (copy)
                t1[1]:Fire(10, 20)
            end)

            local v4, v5 = t1[1]:Wait()

            p3:Expect(v4):ToBe(10)
            p3:Expect(v5):ToBe(20)
        end)
        p3:Test("should create a proxy signal and connect to it", function() -- line: 48
            -- upvalues: p3 (copy), Parent (copy), AwaitCondition (copy)
            local v6 = Parent.Wrap(game:GetService("RunService").Heartbeat)

            p3:Expect(Parent.Is(v6)):ToBe(true)

            local v7 = false

            v6:Connect(function() -- line: 52
                -- upvalues: v7 (ref)
                v7 = true
            end)
            p3:Expect(AwaitCondition(function() -- line: 55
                -- upvalues: v7 (ref)
                return v7
            end, 2)):ToBe(true)
            v6:Destroy()
        end)
    end)
    p3:Describe("FireDeferred", function() -- line: 62
        -- upvalues: p3 (copy), t1 (copy), AwaitCondition (copy)
        p3:Test("should be able to fire primitive argument", function() -- line: 63
            -- upvalues: p3 (copy), t1 (copy), AwaitCondition (copy)
            local v8

            t1[1]:Connect(function(p4) -- line: 66
                -- upvalues: v8 (ref)
                v8 = p4
            end)
            t1[1]:FireDeferred(10)
            p3:Expect(AwaitCondition(function() -- line: 70
                -- upvalues: v8 (ref)
                return v8 == 10
            end, 1)):ToBe(true)
        end)
        p3:Test("should be able to fire a reference based argument", function() -- line: 75
            -- upvalues: p3 (copy), t1 (copy), AwaitCondition (copy)
            local t2 = {
                10, 20
            }
            local v11

            t1[1]:Connect(function(p5) -- line: 78
                -- upvalues: v11 (ref)
                v11 = p5
            end)
            t1[1]:FireDeferred(t2)
            p3:Expect(AwaitCondition(function() -- line: 82
                -- upvalues: t2 (copy), v11 (ref)
                return t2 == v11
            end, 1)):ToBe(true)
        end)
    end)
    p3:Describe("Fire", function() -- line: 88
        -- upvalues: p3 (copy), t1 (copy)
        p3:Test("should be able to fire primitive argument", function() -- line: 89
            -- upvalues: p3 (copy), t1 (copy)
            local v14

            t1[1]:Connect(function(p6) -- line: 92
                -- upvalues: v14 (ref)
                v14 = p6
            end)
            t1[1]:Fire(10)
            p3:Expect(v14):ToBe(10)
        end)
        p3:Test("should be able to fire a reference based argument", function() -- line: 99
            -- upvalues: p3 (copy), t1 (copy)
            local t3 = {
                10, 20
            }
            local v17

            t1[1]:Connect(function(p7) -- line: 102
                -- upvalues: v17 (ref)
                v17 = p7
            end)
            t1[1]:Fire(t3)
            p3:Expect(v17):ToBe(t3)
        end)
    end)
    p3:Describe("ConnectOnce", function() -- line: 110
        -- upvalues: p3 (copy), t1 (copy)
        p3:Test("should only capture first fire", function() -- line: 111
            -- upvalues: p3 (copy), t1 (copy)
            local v20
            local v21 = t1[1]:ConnectOnce(function(p8) -- line: 113
                -- upvalues: v20 (ref)
                v20 = p8
            end)

            p3:Expect(v21.Connected):ToBe(true)
            t1[1]:Fire(10)
            p3:Expect(v21.Connected):ToBe(false)
            t1[1]:Fire(20)
            p3:Expect(v20):ToBe(10)
        end)
    end)
    p3:Describe("Wait", function() -- line: 124
        -- upvalues: p3 (copy), t1 (copy)
        p3:Test("should be able to wait for a signal to fire", function() -- line: 125
            -- upvalues: p3 (copy), t1 (copy)
            task.defer(function() -- line: 126
                -- upvalues: t1 (copy)
                t1[1]:Fire(10, 20, 30)
            end)

            local v25, v26, v27 = t1[1]:Wait()

            p3:Expect(v25):ToBe(10)
            p3:Expect(v26):ToBe(20)
            p3:Expect(v27):ToBe(30)
        end)
    end)
    p3:Describe("DisconnectAll", function() -- line: 136
        -- upvalues: p3 (copy), t1 (copy)
        p3:Test("should disconnect all connections", function() -- line: 137
            -- upvalues: p3 (copy), t1 (copy)
            t1[1]:Connect(function() -- line: 138
            end)
            t1[1]:Connect(function() -- line: 139
            end)
            p3:Expect(#t1[1]:GetConnections()):ToBe(2)
            t1[1]:DisconnectAll()
            p3:Expect(#t1[1]:GetConnections()):ToBe(0)
        end)
    end)
    p3:Describe("Disconnect", function() -- line: 146
        -- upvalues: p3 (copy), t1 (copy), AwaitCondition (copy)
        p3:Test("should disconnect connection", function() -- line: 147
            -- upvalues: p3 (copy), t1 (copy)
            local connection = t1[1]:Connect(function() -- line: 148
            end)

            p3:Expect(#t1[1]:GetConnections()):ToBe(1)
            connection:Disconnect()
            p3:Expect(#t1[1]:GetConnections()):ToBe(0)
        end)
        p3:Test("should still work if connections disconnected while firing", function() -- line: 154
            -- upvalues: p3 (copy), t1 (copy)
            local n1 = 0
            local connection

            t1[1]:Connect(function() -- line: 157
                -- upvalues: n1 (ref)
                n1 += 1
            end)
            connection = t1[1]:Connect(function() -- line: 160
                -- upvalues: n1 (ref), connection (ref)
                connection:Disconnect()
                n1 += 1
            end)
            t1[1]:Connect(function() -- line: 164
                -- upvalues: n1 (ref)
                n1 += 1
            end)
            t1[1]:Fire()
            p3:Expect(n1):ToBe(3)
        end)
        p3:Test("should still work if connections disconnected while firing deferred", function() -- line: 171
            -- upvalues: p3 (copy), t1 (copy), AwaitCondition (copy)
            local n2 = 0
            local connection

            t1[1]:Connect(function() -- line: 174
                -- upvalues: n2 (ref)
                n2 += 1
            end)
            connection = t1[1]:Connect(function() -- line: 177
                -- upvalues: n2 (ref), connection (ref)
                connection:Disconnect()
                n2 += 1
            end)
            t1[1]:Connect(function() -- line: 181
                -- upvalues: n2 (ref)
                n2 += 1
            end)
            t1[1]:FireDeferred()
            p3:Expect(AwaitCondition(function() -- line: 185
                -- upvalues: n2 (ref)
                return n2 == 3
            end)):ToBe(true)
        end)
    end)
end
