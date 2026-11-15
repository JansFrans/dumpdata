-- https://lua.expert

return function() -- line: 1
    local Parent = require(script.Parent)

    describe("Copy (Deep)", function() -- line: 4
        -- upvalues: Parent (copy)
        it("should create a deep table copy", function() -- line: 5
            -- upvalues: Parent (copy)
            local t1 = {
                a = {
                    b = {
                        c = {
                            d = 32
                        }
                    }
                }
            }
            local v1 = Parent.Copy(t1, true)

            expect(t1).never.to.equal(v1)
            expect(t1.a).never.to.equal(v1.a)
            expect(v1.a.b.c.d).to.equal(t1.a.b.c.d)
        end)
    end)
    describe("Copy (Shallow)", function() -- line: 14
        -- upvalues: Parent (copy)
        it("should create a shallow dictionary copy", function() -- line: 15
            -- upvalues: Parent (copy)
            local t2 = {
                a = {
                    b = {
                        c = {
                            d = 32
                        }
                    }
                }
            }
            local v2 = Parent.Copy(t2)

            expect(v2).never.to.equal(t2)
            expect(v2.a).to.equal(t2.a)
            expect(v2.a.b.c.d).to.equal(t2.a.b.c.d)
        end)
        it("should create a shallow array copy", function() -- line: 23
            -- upvalues: Parent (copy)
            local t3 = {
                10, 20, 30, 40
            }
            local v3 = Parent.Copy(t3)

            expect(v3).never.to.equal(t3)

            for v4, v5 in ipairs(t3) do
                expect(v3[v4]).to.equal(v5)
            end
        end)
    end)
    describe("Sync", function() -- line: 33
        -- upvalues: Parent (copy)
        it("should sync tables", function() -- line: 34
            -- upvalues: Parent (copy)
            local t4 = {
                a = 32,
                b = 64,
                c = 128,
                e = {
                    h = 1
                }
            }
            local t5 = {
                a = 32,
                b = 10,
                d = 1,
                e = {
                    h = 2,
                    n = 2
                },
                f = {
                    x = 10
                }
            }
            local v6 = Parent.Sync(t5, t4)

            expect(v6.a).to.equal(t4.a)
            expect(v6.b).to.equal(10)
            expect(v6.c).to.equal(t4.c)
            expect(v6.d).never.to.be.ok()
            expect(v6.e.h).to.equal(2)
            expect(v6.e.n).never.to.be.ok()
            expect(v6.f).never.to.be.ok()
        end)
    end)
    describe("Reconcile", function() -- line: 48
        -- upvalues: Parent (copy)
        it("should reconcile table", function() -- line: 49
            -- upvalues: Parent (copy)
            local t6 = {
                kills = 0,
                deaths = 0,
                xp = 10,
                stuff2 = "abc",
                stuff = {},
                stuff3 = { "data" }
            }
            local t7 = {
                kills = 10,
                deaths = 4,
                extra = 5,
                stuff3 = true,
                stuff = { "abc", "xyz" },
                stuff2 = {
                    abc = 10
                }
            }
            local v7 = Parent.Reconcile(t7, t6)

            expect(v7).never.to.equal(t7)
            expect(v7).never.to.equal(t6)
            expect(v7.kills).to.equal(10)
            expect(v7.deaths).to.equal(4)
            expect(v7.xp).to.equal(10)
            expect(v7.stuff[1]).to.equal("abc")
            expect(v7.stuff[2]).to.equal("xyz")
            expect(v7.extra).to.equal(5)
            expect((type(v7.stuff2))).to.equal("table")
            expect(v7.stuff2).never.to.equal(t7.stuff2)
            expect(v7.stuff2.abc).to.equal(10)
            expect((type(v7.stuff3))).to.equal("boolean")
            expect(v7.stuff3).to.equal(true)
        end)
    end)
    describe("SwapRemove", function() -- line: 70
        -- upvalues: Parent (copy)
        it("should swap remove index", function() -- line: 71
            -- upvalues: Parent (copy)
            local t8 = {
                1, 2, 3, 4, 5
            }

            Parent.SwapRemove(t8, 3)
            expect(#t8).to.equal(4)
            expect(t8[3]).to.equal(5)
        end)
    end)
    describe("SwapRemoveFirstValue", function() -- line: 79
        -- upvalues: Parent (copy)
        it("should swap remove first value given", function() -- line: 80
            -- upvalues: Parent (copy)
            local t9 = {
                "hello",
                "world",
                "goodbye",
                "planet"
            }

            Parent.SwapRemoveFirstValue(t9, "world")
            expect(#t9).to.equal(3)
            expect(t9[2]).to.equal("planet")
        end)
    end)
    describe("Map", function() -- line: 88
        -- upvalues: Parent (copy)
        it("should map table", function() -- line: 89
            -- upvalues: Parent (copy)
            local t10 = {
                {
                    FirstName = "John",
                    LastName = "Doe"
                },
                {
                    FirstName = "Jane",
                    LastName = "Smith"
                }
            }
            local v8 = Parent.Map(t10, function(p1) -- line: 94
                return p1.FirstName .. " " .. p1.LastName
            end)

            expect(v8[1]).to.equal("John Doe")
            expect(v8[2]).to.equal("Jane Smith")
        end)
    end)
    describe("Filter", function() -- line: 102
        -- upvalues: Parent (copy)
        it("should filter table", function() -- line: 103
            -- upvalues: Parent (copy)
            local t11 = {
                10, 20, 30, 40, 50, 60, 70, 80,
                90
            }
            local v9 = Parent.Filter(t11, function(p2) -- line: 105
                if p2 >= 30 then
                    return p2 <= 60
                end

                return false
            end)

            expect(#v9).to.equal(4)
            expect(v9[1]).to.equal(30)
            expect(v9[#v9]).to.equal(60)
        end)
    end)
    describe("Reduce", function() -- line: 114
        -- upvalues: Parent (copy)
        it("should reduce table with numbers", function() -- line: 115
            -- upvalues: Parent (copy)
            local t12 = {
                1, 2, 3, 4, 5
            }
            local v10 = Parent.Reduce(t12, function(p3, p4) -- line: 117
                return p3 + p4
            end)

            expect(v10).to.equal(15)
        end)
        it("should reduce table", function() -- line: 123
            -- upvalues: Parent (copy)
            local t13 = {
                {
                    Score = 10
                },
                {
                    Score = 20
                },
                {
                    Score = 30
                }
            }
            local v11 = Parent.Reduce(t13, function(p5, p6) -- line: 125
                return p5 + p6.Score
            end, 0)

            expect(v11).to.equal(60)
        end)
        it("should reduce table with initial value", function() -- line: 131
            -- upvalues: Parent (copy)
            local t14 = {
                {
                    Score = 10
                },
                {
                    Score = 20
                },
                {
                    Score = 30
                }
            }
            local v12 = Parent.Reduce(t14, function(p7, p8) -- line: 133
                return p7 + p8.Score
            end, 40)

            expect(v12).to.equal(100)
        end)
        it("should reduce functions", function() -- line: 139
            -- upvalues: Parent (copy)
            local function Square(p9) -- line: 140
                return p9 * p9
            end

            local function Double(p10) -- line: 143
                return p10 * 2
            end

            local v13 = Parent.Reduce({
                Square,
                Double
            }, function(p11, p12) -- line: 146
                return function(p13) -- line: 147
                    -- upvalues: p11 (copy), p12 (copy)
                    return p11(p12(p13))
                end
            end)(10)

            expect(v13).to.equal(400)
        end)
    end)
    describe("Assign", function() -- line: 156
        -- upvalues: Parent (copy)
        it("should assign tables", function() -- line: 157
            -- upvalues: Parent (copy)
            local t15 = {
                a = 32,
                x = 100
            }
            local t16 = {
                b = 64,
                c = 128
            }
            local t17 = {
                a = 10,
                c = 100,
                d = 200
            }
            local v14 = Parent.Assign(t15, t16, t17)

            expect(v14.a).to.equal(10)
            expect(v14.b).to.equal(64)
            expect(v14.c).to.equal(100)
            expect(v14.d).to.equal(200)
            expect(v14.x).to.equal(100)
        end)
    end)
    describe("Extend", function() -- line: 170
        -- upvalues: Parent (copy)
        it("should extend tables", function() -- line: 171
            -- upvalues: Parent (copy)
            local t18 = {
                "a",
                "b",
                "c"
            }
            local t19 = {
                "d",
                "e",
                "f"
            }
            local v15 = Parent.Extend(t18, t19)

            expect(table.concat(v15)).to.equal("abcdef")
        end)
    end)
    describe("Reverse", function() -- line: 179
        -- upvalues: Parent (copy)
        it("should create a table in reverse", function() -- line: 180
            -- upvalues: Parent (copy)
            local t20 = {
                1, 2, 3
            }
            local v16 = Parent.Reverse(t20)

            expect(table.concat(v16)).to.equal("321")
        end)
    end)
    describe("Shuffle", function() -- line: 187
        -- upvalues: Parent (copy)
        it("should shuffle a table", function() -- line: 188
            -- upvalues: Parent (copy)
            local t21 = {
                1, 2, 3, 4, 5
            }

            expect(function() -- line: 190
                -- upvalues: t21 (copy), Parent (copy)
                Parent.Shuffle(t21)
            end).never.to.throw()
        end)
    end)
    describe("Sample", function() -- line: 196
        -- upvalues: Parent (copy)
        it("should sample a table", function() -- line: 197
            -- upvalues: Parent (copy)
            local t22 = {
                1, 2, 3, 4, 5
            }
            local v17 = Parent.Sample(t22, 3)

            expect(#v17).to.equal(3)
        end)
    end)
    describe("Flat", function() -- line: 204
        -- upvalues: Parent (copy)
        it("should flatten table", function() -- line: 205
            -- upvalues: Parent (copy)
            local t23 = {
                1, 2, 3,
                {
                    4, 5,
                    { 6, 7 }
                }
            }
            local v18 = Parent.Flat(t23, 3)

            expect(table.concat(v18)).to.equal("1234567")
        end)
    end)
    describe("FlatMap", function() -- line: 212
        -- upvalues: Parent (copy)
        it("should map and flatten table", function() -- line: 213
            -- upvalues: Parent (copy)
            local t24 = {
                1, 2, 3, 4, 5, 6, 7
            }
            local v19 = Parent.FlatMap(t24, function(p14) -- line: 215
                return {
                    p14,
                    p14 * 2
                }
            end)

            expect(table.concat(v19)).to.equal("12243648510612714")
        end)
    end)
    describe("Keys", function() -- line: 222
        -- upvalues: Parent (copy)
        it("should give all keys of table", function() -- line: 223
            -- upvalues: Parent (copy)
            local t25 = {
                a = 1,
                b = 2,
                c = 3
            }
            local v20 = Parent.Keys(t25)

            expect(#v20).to.equal(3)
            expect(table.find(v20, "a")).to.be.ok()
            expect(table.find(v20, "b")).to.be.ok()
            expect(table.find(v20, "c")).to.be.ok()
        end)
    end)
    describe("Values", function() -- line: 233
        -- upvalues: Parent (copy)
        it("should give all values of table", function() -- line: 234
            -- upvalues: Parent (copy)
            local t26 = {
                a = 1,
                b = 2,
                c = 3
            }
            local v21 = Parent.Values(t26)

            expect(#v21).to.equal(3)
            expect(table.find(v21, 1)).to.be.ok()
            expect(table.find(v21, 2)).to.be.ok()
            expect(table.find(v21, 3)).to.be.ok()
        end)
    end)
    describe("Find", function() -- line: 244
        -- upvalues: Parent (copy)
        it("should find item in array", function() -- line: 245
            -- upvalues: Parent (copy)
            local t27 = {
                10, 20, 30
            }
            local v22, v23 = Parent.Find(t27, function(p15) -- line: 247
                return p15 == 20
            end)

            expect(v22).to.be.ok()
            expect(v23).to.equal(2)
            expect(v22).to.equal(20)
        end)
        it("should find item in dictionary", function() -- line: 255
            -- upvalues: Parent (copy)
            local t28 = {
                {
                    Score = 10
                },
                {
                    Score = 20
                },
                {
                    Score = 30
                }
            }
            local v24, v25 = Parent.Find(t28, function(p16) -- line: 257
                return p16.Score == 20
            end)

            expect(v24).to.be.ok()
            expect(v25).to.equal(2)
            expect(v24.Score).to.equal(20)
        end)
    end)
    describe("Every", function() -- line: 266
        -- upvalues: Parent (copy)
        it("should see every value is above 20", function() -- line: 267
            -- upvalues: Parent (copy)
            local t29 = {
                21, 40, 200
            }
            local v26 = Parent.Every(t29, function(p17) -- line: 269
                return p17 > 20
            end)

            expect(v26).to.equal(true)
        end)
        it("should see every value is not above 20", function() -- line: 275
            -- upvalues: Parent (copy)
            local t30 = {
                20, 40, 200
            }
            local v27 = Parent.Every(t30, function(p18) -- line: 277
                return p18 > 20
            end)

            expect(v27).never.to.equal(true)
        end)
    end)
    describe("Some", function() -- line: 284
        -- upvalues: Parent (copy)
        it("should see some value is above 20", function() -- line: 285
            -- upvalues: Parent (copy)
            local t31 = {
                5, 40, 1
            }
            local v28 = Parent.Some(t31, function(p19) -- line: 287
                return p19 > 20
            end)

            expect(v28).to.equal(true)
        end)
        it("should see some value is not above 20", function() -- line: 293
            -- upvalues: Parent (copy)
            local t32 = {
                5, 15, 1
            }
            local v29 = Parent.Some(t32, function(p20) -- line: 295
                return p20 > 20
            end)

            expect(v29).never.to.equal(true)
        end)
    end)
    describe("Truncate", function() -- line: 302
        -- upvalues: Parent (copy)
        it("should truncate an array", function() -- line: 303
            -- upvalues: Parent (copy)
            local t33 = {
                1, 2, 3, 4, 5
            }
            local v30 = Parent.Truncate(t33, 3)

            expect(#v30).to.equal(3)
            expect(v30[1]).to.equal(t33[1])
            expect(v30[2]).to.equal(t33[2])
            expect(v30[3]).to.equal(t33[3])
        end)
        it("should truncate an array with out of bounds sizes", function() -- line: 312
            -- upvalues: Parent (copy)
            local t34 = {
                1, 2, 3, 4, 5
            }

            expect(function() -- line: 314
                -- upvalues: t34 (copy), Parent (copy)
                Parent.Truncate(t34, -1)
            end).to.never.throw()
            expect(function() -- line: 317
                -- upvalues: t34 (copy), Parent (copy)
                Parent.Truncate(t34, #t34 + 1)
            end).to.never.throw()

            local v31 = Parent.Truncate(t34, #t34 + 10)

            expect(#v31).to.equal(#t34)
            expect(v31).to.never.equal(t34)
        end)
    end)
    describe("Lock", function() -- line: 326
        -- upvalues: Parent (copy)
        it("should lock a table", function() -- line: 327
            -- upvalues: Parent (copy)
            local t35 = {
                abc = {
                    xyz = {
                        num = 32
                    }
                }
            }

            expect(function() -- line: 329
                -- upvalues: t35 (copy)
                t35.abc.xyz.num = 64
            end).never.to.throw()

            local v32 = Parent.Lock(t35)

            expect(t35.abc.xyz.num).to.equal(64)
            expect(t35).to.equal(v32)
            expect(function() -- line: 335
                -- upvalues: t35 (copy)
                t35.abc.xyz.num = 10
            end).to.throw()
        end)
    end)
    describe("Zip", function() -- line: 341
        -- upvalues: Parent (copy)
        it("should zip arrays together", function() -- line: 342
            -- upvalues: Parent (copy)
            local t36 = {
                1, 2, 3, 4, 5
            }
            local t37 = {
                9, 8, 7, 6, 5
            }
            local t38 = {
                1, 1, 1, 1, 1
            }
            local n1 = 0

            for v33, v34 in Parent.Zip(t36, t37, t38) do
                n1 = v33
                expect(v34[1]).to.equal(t36[v33])
                expect(v34[2]).to.equal(t37[v33])
                expect(v34[3]).to.equal(t38[v33])
            end

            expect(n1).to.equal((math.min(#t36, #t37, #t38)))
        end)
        it("should zip arrays of different lengths together", function() -- line: 356
            -- upvalues: Parent (copy)
            local t39 = {
                1, 2, 3, 4, 5
            }
            local t40 = {
                9, 8, 7, 6
            }
            local t41 = {
                1, 1, 1
            }
            local n2 = 0

            for v38, v39 in Parent.Zip(t39, t40, t41) do
                n2 = v38
                expect(v39[1]).to.equal(t39[v38])
                expect(v39[2]).to.equal(t40[v38])
                expect(v39[3]).to.equal(t41[v38])
            end

            expect(n2).to.equal((math.min(#t39, #t40, #t41)))
        end)
        it("should zip maps together", function() -- line: 370
            -- upvalues: Parent (copy)
            local t42 = {
                a = 10,
                b = 20,
                c = 30
            }
            local t43 = {
                a = 100,
                b = 200,
                c = 300
            }
            local t44 = {
                a = 3000,
                b = 2000,
                c = 3000
            }

            for v43, v44 in Parent.Zip(t42, t43, t44) do
                expect(v44[1]).to.equal(t42[v43])
                expect(v44[2]).to.equal(t43[v43])
                expect(v44[3]).to.equal(t44[v43])
            end
        end)
        it("should zip maps of different keys together", function() -- line: 381
            -- upvalues: Parent (copy)
            local t45 = {
                a = 10,
                b = 20,
                c = 30,
                d = 40
            }
            local t46 = {
                a = 100,
                b = 200,
                c = 300,
                z = 10
            }
            local t47 = {
                a = 3000,
                b = 2000,
                c = 3000,
                x = 0
            }

            for v45, v46 in Parent.Zip(t45, t46, t47) do
                expect(v46[1]).to.equal(t45[v45])
                expect(v46[2]).to.equal(t46[v45])
                expect(v46[3]).to.equal(t47[v45])
            end
        end)
    end)
    describe("IsEmpty", function() -- line: 393
        -- upvalues: Parent (copy)
        it("should detect that table is empty", function() -- line: 394
            -- upvalues: Parent (copy)
            local t48 = {}
            local v47 = Parent.IsEmpty(t48)

            expect(v47).to.equal(true)
        end)
        it("should detect that array is not empty", function() -- line: 400
            -- upvalues: Parent (copy)
            local t49 = {
                10, 20, 30
            }
            local v48 = Parent.IsEmpty(t49)

            expect(v48).to.equal(false)
        end)
        it("should detect that dictionary is not empty", function() -- line: 406
            -- upvalues: Parent (copy)
            local t50 = {
                a = 10,
                b = 20,
                c = 30
            }
            local v49 = Parent.IsEmpty(t50)

            expect(v49).to.equal(false)
        end)
    end)
    describe("JSON", function() -- line: 413
        -- upvalues: Parent (copy)
        it("should encode json", function() -- line: 414
            -- upvalues: Parent (copy)
            local t51 = {
                hello = "world"
            }
            local v50 = Parent.EncodeJSON(t51)

            expect(v50).to.equal("{\"hello\":\"world\"}")
        end)
        it("should decode json", function() -- line: 420
            -- upvalues: Parent (copy)
            local v51 = Parent.DecodeJSON("{\"hello\":\"world\"}")

            expect(v51).to.be.a("table")
            expect(v51.hello).to.equal("world")
        end)
    end)
end
