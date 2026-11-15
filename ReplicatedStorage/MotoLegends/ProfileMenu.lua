-- https://lua.expert

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Parent = script.Parent
local RaceIcons = require(Parent:WaitForChild("RaceIcons"))
local UIArt = require(Parent:WaitForChild("UIArt"))
local LegendsCatalog = require(Parent:WaitForChild("LegendsCatalog"))
local LegendRig = require(Parent:WaitForChild("LegendRig"))
local BikeCatalog = require(Parent:WaitForChild("BikeCatalog"))
local NumberFormat = require(Parent:WaitForChild("NumberFormat"))
local _require = require
local ok, result = pcall(_require, Parent:WaitForChild("Config"))
local VisualScale = ok and result.VisualScale or 1
local t1 = {}
local v1 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
local v2 = Color3.new(1, 1, 1)
local v3 = Color3.new(0, 0, 0)
local v4 = Color3.fromRGB(231, 0, 0)
local v5 = Color3.fromRGB(178, 178, 182)
local v6 = Color3.fromRGB(196, 196, 200)
local Left, Center = Enum.TextXAlignment.Left, Enum.TextXAlignment.Center
local _ = {
    Jerez = "JEREZ",
    Lusail = "LUSAIL",
    Mandalika = "MANDALIKA",
    Mugello = "MUGELLO",
    Sepang = "SEPANG"
}
local t2 = {
    {
        name = "Gold",
        fill = Color3.fromRGB(247, 186, 26),
        ring = Color3.fromRGB(214, 140, 10),
        ink = Color3.fromRGB(255, 240, 190)
    },
    {
        name = "Silver",
        fill = Color3.fromRGB(196, 198, 204),
        ring = Color3.fromRGB(150, 152, 160),
        ink = Color3.fromRGB(245, 245, 248)
    },
    {
        name = "Bronze",
        fill = Color3.fromRGB(222, 130, 92),
        ring = Color3.fromRGB(176, 90, 58),
        ink = Color3.fromRGB(255, 215, 195)
    }
}
local t3 = {
    Jerez = {
        aspect = 0.9966,
        pts = "472,275;462,252;451,225;439,198;428,171;417,144;406,117;394,91;383,64;378,36;392,11;415,2;444,1;473,1;503,0;532,0;561,0;590,0;617,9;627,35;612,59;588,76;568,91;551,114;542,142;542,171;544,200;545,229;547,258;550,287;558,315;573,340;593,361;615,374;643,384;671,388;700,392;729,396;758,400;787,404;816,408;845,412;874,416;899,419;928,424;955,435;978,453;993,478;999,507;998,536;989,563;974,588;952,608;929,625;909,641;886,659;864,678;841,696;818,714;795,732;773,751;750,769;727,787;704,805;682,824;662,840;639,858;616,876;593,895;571,913;548,931;525,949;502,968;480,986;454,999;430,992;420,966;430,939;444,913;457,887;470,861;484,835;497,809;510,783;517,755;516,726;508,702;492,677;474,654;456,631;438,608;420,586;402,563;384,540;363,520;336,509;307,506;282,512;256,525;234,544;217,568;206,595;196,622;187,650;177,677;167,704;158,732;148,756;130,777;102,782;76,770;52,753;28,735;7,716;0,689;12,662;24,636;37,610;49,587;61,561;74,534;87,508;100,482;114,456;130,433;153,415;181,405;210,403;239,406;264,408;294,411;323,413;352,417;376,433;395,455;413,478;432,500;450,523;468,546;484,565;503,588;521,611;539,633;558,656;580,674;608,672;623,649;618,621;606,594;594,567;585,544;573,517;562,490;551,463;540,436;528,410;517,383;506,356;494,329;483,302"
    },
    Lusail = {
        aspect = 0.8524,
        pts = "209,657;196,638;184,618;170,598;158,578;144,557;131,538;118,517;105,498;92,477;79,458;66,437;53,417;39,397;27,377;13,356;2,336;1,313;14,294;38,282;64,283;88,294;111,306;134,318;156,330;180,343;204,350;230,347;250,331;257,310;258,286;257,264;257,240;257,218;263,195;277,176;295,158;313,142;332,125;349,108;368,91;386,74;404,57;422,40;441,23;459,7;485,0;510,5;532,20;551,35;570,52;578,73;571,96;555,113;538,130;519,147;501,163;482,181;465,197;449,217;455,237;480,242;505,235;531,226;555,218;581,209;605,201;631,192;655,184;681,175;706,170;733,176;750,192;755,215;745,235;725,252;707,267;690,286;677,305;667,327;660,349;654,370;638,389;615,399;588,405;563,410;536,415;510,420;489,435;483,456;496,477;514,493;535,508;557,520;581,531;606,540;632,547;658,551;686,552;712,552;739,550;765,547;793,544;819,541;846,538;872,536;900,535;925,542;945,556;960,575;973,595;987,615;997,636;997,659;986,679;971,699;957,718;942,738;927,756;903,768;877,769;850,764;825,759;797,755;772,750;744,746;719,741;692,737;666,738;643,751;629,770;616,791;604,810;592,832;580,851;568,871;555,892;543,912;530,933;518,953;505,974;489,991;463,999;438,995;418,979;405,959;392,938;379,919;366,898;353,879;340,858;327,839;314,818;301,798;287,778;275,758;261,737;249,718;235,697;222,678"
    },
    Mandalika = {
        aspect = 0.7732,
        pts = "427,100;453,95;482,88;508,82;537,76;563,70;592,63;618,58;647,51;673,45;702,39;728,33;757,26;783,21;812,14;839,8;869,2;897,1;924,12;939,31;942,54;943,77;944,98;945,121;946,143;947,166;948,187;946,210;931,227;902,234;875,234;850,246;836,264;829,286;839,306;857,324;876,340;897,356;919,369;942,383;966,397;985,412;995,433;997,455;997,478;998,499;998,522;999,543;999,566;998,587;989,609;972,626;953,643;935,659;915,677;897,693;878,710;859,726;836,740;809,745;780,745;750,746;723,750;695,759;672,771;650,786;633,802;616,821;599,838;576,853;554,865;528,877;504,887;478,898;454,909;428,920;404,930;378,941;354,951;327,962;301,973;277,983;251,994;225,999;198,990;186,971;185,948;187,927;188,904;190,883;192,860;194,839;195,816;198,795;202,772;215,754;241,742;267,735;295,726;320,719;348,711;375,701;396,687;410,667;416,646;416,623;413,602;411,579;408,558;405,535;403,514;400,491;397,470;393,447;385,427;367,408;343,399;313,397;286,396;257,391;229,383;205,373;181,359;162,344;144,325;128,308;111,289;96,271;79,252;64,235;47,216;32,198;18,178;8,158;1,136;0,114;3,91;9,71;19,49;32,31;52,13;80,12;98,27;102,50;99,71;94,94;90,115;87,138;96,158;123,165;150,162;178,156;205,150;233,144;260,138;288,132;315,126;343,119;370,113;398,107"
    },
    Mugello = {
        aspect = 0.7086,
        pts = "472,520;486,498;500,476;515,451;530,429;544,407;560,383;576,362;592,341;611,317;629,297;649,274;666,253;682,232;699,208;714,186;728,164;742,139;755,117;769,92;781,69;793,47;807,22;831,5;864,0;897,12;913,33;916,57;910,83;903,107;895,133;893,157;912,177;944,190;973,203;994,222;999,248;987,271;966,293;947,313;928,333;907,355;888,375;869,395;848,418;829,438;810,458;790,480;783,504;797,528;812,550;817,574;803,598;781,617;760,635;735,656;714,675;690,695;668,714;646,732;622,753;600,772;570,782;532,783;498,782;464,782;428,789;399,802;378,824;365,846;354,869;342,895;331,917;319,940;302,964;279,981;246,994;212,999;179,997;143,988;112,978;82,967;49,954;22,939;6,918;0,891;3,867;10,841;16,817;23,793;30,767;36,743;43,720;50,693;57,670;80,649;112,643;147,643;184,641;213,628;229,607;240,582;249,558;258,535;269,509;278,486;289,460;298,437;308,414;318,388;330,366;352,347;387,338;420,343;446,362;455,385;448,408;430,432;409,451;388,470;365,491;352,513;351,537;351,564;341,587;319,608;298,627;278,647;255,668;235,688;215,707;192,729;172,748;149,770;129,789;108,808;87,830;73,852;70,876;85,901;110,916;143,923;180,918;209,905;234,885;252,864;266,843;282,818;296,796;310,774;326,750;340,728;356,703;370,681;383,659;399,635;413,613;427,591;442,566;456,544"
    },
    Sepang = {
        aspect = 1.2256,
        pts = "402,531;375,534;345,537;314,540;284,543;254,546;224,548;194,551;164,554;134,557;107,560;77,563;47,566;17,563;0,534;10,501;38,492;67,504;91,490;86,458;68,429;53,397;48,360;48,324;50,287;58,251;72,218;91,190;115,167;139,152;168,140;196,129;225,117;254,105;282,93;310,79;338,65;366,51;391,38;418,23;446,6;474,3;486,36;491,72;497,108;503,145;508,181;514,218;519,250;531,284;551,312;576,332;605,342;635,342;664,332;689,311;709,283;731,264;760,254;790,257;817,272;840,296;859,324;879,352;899,380;919,408;937,433;957,460;977,488;996,517;994,552;982,586;970,620;945,637;915,638;885,641;857,643;827,645;797,649;767,653;737,657;707,662;677,666;647,671;617,675;590,679;561,685;555,714;581,734;607,753;628,779;639,813;641,850;637,887;629,922;617,952;601,983;575,999;548,983;525,959;502,936;478,912;455,889;432,866;411,845;387,821;362,801;332,799;305,813;278,831;251,846;221,855;191,854;165,847;138,832;114,808;98,778;97,742;121,722;151,716;181,709;210,703;240,696;267,690;297,684;326,678;356,671;386,665;415,658;445,652;475,645;505,639;531,633;561,626;591,620;620,613;650,606;680,600;710,593;739,588;769,581;799,574;825,568;853,555;866,523;849,494;820,490;790,493;760,496;730,499;700,502;672,505;642,508;612,511;582,514;552,516;522,519;492,522;462,525;432,528"
    }
}

local function lapText(p1) -- line: 43
    if typeof(p1) ~= "number" or p1 <= 0 then
        return "-:--.---"
    end

    local v8 = math.floor(p1 * 1000 + 0.5)

    return string.format("%d:%02d.%03d", math.floor(v8 / 60000), math.floor(v8 / 1000) % 60, v8 % 1000)
end

local function playText(p2) -- line: 45
    local v12 = typeof(p2) == "number" and math.floor(p2) or 0
    local v14 = math.floor(v12 / 3600)
    local v16 = math.floor(v12 % 3600 / 60)

    if v14 > 0 then
        return v14 .. "H " .. v16 .. "M"
    end

    return v16 .. "M"
end

local function flagText(p3) -- line: 48
    if typeof(p3) ~= "string" or #p3 ~= 2 then
        return utf8.char(127937)
    end

    local v17 = p3:upper()
    local v18 = v17:byte(1)
    local v19 = v17:byte(2)

    if not (v18 < 65) and not (v18 > 90) and not (v19 < 65) and not (v19 > 90) then
        return utf8.char(127462 + v18 - 65, 127462 + v19 - 65)
    end

    return utf8.char(127937)
end

function t1.New(p4) -- line: 55
    -- upvalues: TweenService (copy), UserInputService (copy), RunService (copy), Parent (copy), RaceIcons (copy), UIArt (copy), LegendsCatalog (copy), LegendRig (copy), BikeCatalog (copy), NumberFormat (copy), ok (copy), result (copy), VisualScale (copy), t1 (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), Left (copy), Center (copy), t2 (copy), t3 (copy), flagText (copy)
    local t4 = {}
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "ProfileHUD"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 35
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Enabled = false
    ScreenGui.Archivable = false
    ScreenGui.Parent = p4

    local Frame = Instance.new("Frame")

    Frame.Name = "Root"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = ScreenGui

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "ReferenceCanvas"
    Frame2.BackgroundTransparency = 1
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Position = UDim2.fromScale(0.5, 0.5)
    Frame2.Size = UDim2.fromOffset(2000, 1125)
    Frame2.Parent = Frame

    local UIScale = Instance.new("UIScale", Frame2)
    local t5 = {}

    local function fit() -- line: 64
        -- upvalues: Frame (copy), UIScale (copy), t5 (copy)
        local AbsoluteSize = Frame.AbsoluteSize

        if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
            AbsoluteSize = workspace.CurrentCamera.ViewportSize
        end

        UIScale.Scale = math.min(AbsoluteSize.X / 2000, AbsoluteSize.Y / 1125)

        for _, v22 in t5 do
            v22.Thickness = math.max(1.5, 5 * UIScale.Scale)
        end
    end

    Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)

    local function text(p5, p6, p7, p8, p9, p10, p11, p12, p13) -- line: 70
        -- upvalues: v1 (copy), v2 (copy), Left (copy)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = p6
        TextLabel.Text = p7
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.fromOffset(p8, p9)
        TextLabel.Size = UDim2.fromOffset(p10, p11)
        TextLabel.TextColor3 = p13 or v2
        TextLabel.FontFace = v1
        TextLabel.TextSize = p12
        TextLabel.TextXAlignment = Left
        TextLabel.ZIndex = 5
        TextLabel.AutoLocalize = false
        TextLabel.Parent = p5

        return TextLabel
    end

    local function frame(p14, p15, p16, p17, p18, p19, p20, p21) -- line: 74
        -- upvalues: v2 (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = p15
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = p20 or v2
        Frame.Position = UDim2.fromOffset(p16, p17)
        Frame.Size = UDim2.fromOffset(p18, p19)
        Frame.ZIndex = p21 or 5
        Frame.Parent = p14

        return Frame
    end

    local function round(p22, p23) -- line: 77
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, p23)
        UICorner.Parent = p22

        return UICorner
    end

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "ProfilePanel"
    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = v3 or v2
    Frame3.Position = UDim2.fromOffset(240, 147)
    Frame3.Size = UDim2.fromOffset(1520, 832)
    Frame3.ZIndex = 1
    Frame3.Parent = Frame2
    Frame3.Active = true
    Frame3.ClipsDescendants = true

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 26)
    UICorner.Parent = Frame3
    UICorner = Instance.new("ImageLabel")
    UICorner.Name = "Halftone"
    UICorner.BackgroundTransparency = 1
    UICorner.Position = UDim2.fromOffset(45, 40)
    UICorner.Size = UDim2.fromOffset(750, 775)
    UICorner.ZIndex = 1
    UICorner.Parent = Frame3
    UIArt.Apply(UICorner, "LegendsDots")

    local Frame4 = Color3.fromRGB(26, 26, 30)
    local Frame5 = Instance.new("Frame")

    Frame5.Name = "HeaderBar"
    Frame5.BorderSizePixel = 0
    Frame5.BackgroundColor3 = Frame4 or v2
    Frame5.Position = UDim2.fromOffset(760, 24)
    Frame5.Size = UDim2.fromOffset(0, 70)
    Frame5.ZIndex = 6
    Frame5.Parent = Frame3
    Frame5.AnchorPoint = Vector2.new(0.5, 0)
    Frame5.AutomaticSize = Enum.AutomaticSize.X
    Frame5.ClipsDescendants = false
    Frame4 = Instance.new("UICorner")
    Frame4.CornerRadius = UDim.new(0, 14)
    Frame4.Parent = Frame5
    Frame4 = Instance.new("Frame")
    Frame4.Name = "Row"
    Frame4.BackgroundTransparency = 1
    Frame4.Size = UDim2.fromOffset(0, 70)
    Frame4.AutomaticSize = Enum.AutomaticSize.X
    Frame4.ZIndex = 8
    Frame4.Parent = Frame5

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 18)
    UIListLayout.Parent = Frame4
    UIListLayout = Instance.new("UIPadding")
    UIListLayout.PaddingLeft = UDim.new(0, 10)
    UIListLayout.PaddingRight = UDim.new(0, 28)
    UIListLayout.Parent = Frame4

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Avatar"
    ImageLabel.LayoutOrder = 1
    ImageLabel.Size = UDim2.fromOffset(52, 52)
    ImageLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
    ImageLabel.BorderSizePixel = 0
    ImageLabel.ZIndex = 8
    ImageLabel.Parent = Frame4

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0, 26)
    UICorner2.Parent = ImageLabel
    UICorner2 = Instance.new("UIStroke")
    UICorner2.Color = v2
    UICorner2.Thickness = 3
    UICorner2.Parent = ImageLabel

    local v24 = text(Frame4, "Title", "", 0, 0, 0, 70, 36)

    v24.LayoutOrder = 2
    v24.AutomaticSize = Enum.AutomaticSize.X
    v24.ZIndex = 8

    local t6 = {}
    local t7 = {}

    t7[1] = nil

    local function setHeaderRole(p24) -- line: 99
        -- upvalues: Frame5 (copy), v24 (copy), t6 (copy), t7 (copy), Parent (copy), v2 (copy), v3 (copy)
        local _require = require
        local ok, result = pcall(_require, Parent:WaitForChild("RaceNametags"))
        local v25, v26

        if ok then
            local v27 = result.RoleStyles[typeof(p24) == "string" and p24:lower() or ""]

            if v27 then
                v25 = v27
                v26 = true
            else
                v26 = false
            end
        else
            v26 = false
        end

        if not v26 then
            v25 = nil
        end

        Frame5.BackgroundColor3 = v25 and v25.color or Color3.fromRGB(26, 26, 30)
        Frame5.BackgroundTransparency = v25 and math.min(v25.transp or 0, 0.15) or 0
        v24.TextColor3 = v25 and v25.text or v2

        for _, child in Frame5:GetChildren() do
            if child.Name == "RoleShine" or child.Name == "RoleGlow" then
                child:Destroy()
            end
        end

        table.clear(t6)

        local t8, v30

        if ok then
            if result.ApplyBar then
                result.ApplyBar(Frame5, v25, v24)
                t6.bar = Frame5:FindFirstChild("RoleBar")
                t6.text = v24:FindFirstChild("RoleText")
            end

            if result.ApplyFlag then
                local v31 = result.ApplyFlag(Frame5, v25, 2, false, 14)

                t8 = t6
                v30 = v31 and v31:GetAttribute("Wave") and result.StepFlag or nil
                t8.flag = v30
            end
        end

        local v32, v33

        if ok and result.BuildFx then
            local v35 = result.BuildFx(Frame5, v25 and v25.particles or nil, 2, {
                crownK = 2.6
            })

            if v35 then
                v32 = v35
                v33 = true
            else
                v33 = false
            end
        else
            v33 = false
        end

        t6.fx = if not v33 then nil else v32
        t6.step = ok and result.StepFx or nil

        if t6.fx then
            t6.fx.holder.ZIndex = 9
        end

        if v25 and v25.shine then
            local v36 = v25.shineColor or v2
            local Frame = Instance.new("Frame")

            Frame.Name = "RoleShine"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v36 or v2
            Frame.Position = UDim2.fromOffset(0, 0)
            Frame.Size = UDim2.fromOffset(0, 0)
            Frame.ZIndex = 7
            Frame.Parent = Frame5
            Frame.Size = UDim2.fromScale(1, 1)

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0, 14)
            UICorner.Parent = Frame

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Rotation = 15
            UIGradient.Offset = Vector2.new(-1.2, 0)
            UIGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.34, 1),
                NumberSequenceKeypoint.new(0.5, v25.shine),
                NumberSequenceKeypoint.new(0.66, 1),
                NumberSequenceKeypoint.new(1, 1)
            })
            UIGradient.Parent = Frame
            t6.shine = UIGradient
        end

        if v25 and (v25.glow or v25.rim == "checker") then
            local UIStroke = Instance.new("UIStroke")

            UIStroke.Name = "RoleGlow"
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Thickness = 5
            UIStroke.Parent = Frame5

            if v25.glow == "blackhole" then
                UIStroke.Color = v2

                local UIGradient = Instance.new("UIGradient")

                UIGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 96, 8)),
                    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 190, 30)),
                    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(255, 248, 205)),
                    ColorSequenceKeypoint.new(0.44, Color3.fromRGB(255, 190, 30)),
                    ColorSequenceKeypoint.new(0.62, Color3.fromRGB(255, 110, 10)),
                    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 210, 60)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 96, 8))
                })
                UIGradient.Parent = UIStroke
                t6.disk = UIGradient
            elseif v25.glow == "pulse" then
                t6.pulse = UIStroke
            elseif v25.glow == "outline" then
                UIStroke.Color = v25.outline or v2
                t6.outline = UIStroke
            elseif not (result.DiskFor and result.DiskFor(v25)) then
                if not t7[1] then
                    t7[1] = {}

                    for i = 0, 23 do
                        local v37 = i % 2 == 0
                        local v38 = if v37 then v2 else nil
                        local v39 = if not v37 or not v38 then v3 else v38

                        table.insert(t7[1], ColorSequenceKeypoint.new(i / 24, v39))
                        table.insert(t7[1], ColorSequenceKeypoint.new(math.min(1, (i + 1) / 24 - 5E-04), v39))
                    end

                    t7[1][#t7[1]] = ColorSequenceKeypoint.new(1, t7[1][#t7[1]].Value)
                end

                UIStroke.Color = v2
                UIStroke.Thickness = 6

                local UIGradient = Instance.new("UIGradient")

                UIGradient.Color = ColorSequence.new(t7[1])
                UIGradient.Parent = UIStroke
            else
                UIStroke.Color = v2

                local UIGradient = Instance.new("UIGradient")

                UIGradient.Color = result.DiskFor(v25)
                UIGradient.Parent = UIStroke
                t6.disk = UIGradient
                t6.spin = v25.spin or 200

                if v25.glow == "mythic" then
                    t6.mythic = UIStroke
                end
            end
        end
    end

    RunService.RenderStepped:Connect(function() -- line: 145
        -- upvalues: ScreenGui (copy), Frame5 (copy), t6 (copy)
        if ScreenGui.Enabled then
            local elapsed = os.clock()

            if t6.shine then
                local v46 = elapsed % 3
                local v47 = v46 < 1.8 and (1 - math.cos(v46 / 1.8 * 3.141592653589793)) / 2 or 1

                t6.shine.Offset = Vector2.new(-1.2 + 2.4 * v47, 0)
            end

            if t6.disk then
                t6.disk.Rotation = elapsed * (t6.spin or 140) % 360
            end

            if t6.mythic then
                t6.mythic.Thickness = (math.sin(elapsed * 3.2) + 1) / 2 * 2.5 + 5
            end

            if t6.bar and t6.bar.Parent then
                t6.bar.Offset = Vector2.new(math.sin(elapsed * 0.6) * 0.35, 0)
            end

            if t6.text and t6.text.Parent then
                t6.text.Offset = Vector2.new(elapsed * 0.25 % 2 - 1, 0)
            end

            if t6.outline then
                t6.outline.Thickness = (math.sin(elapsed * 3.2) + 1) / 2 * 2 + 4
            end

            if t6.fx and t6.step then
                t6.step(t6.fx, elapsed, 1)
            end

            if t6.flag then
                t6.flag(Frame5, elapsed)
            end

            if not t6.pulse then
                return
            end

            local v53 = (math.sin(elapsed * 4) + 1) / 2

            t6.pulse.Thickness = v53 * 3 + 3
            t6.pulse.Color = Color3.fromRGB(255, 70, 70):Lerp(Color3.fromRGB(255, 190, 170), v53)
        end
    end)

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Close"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.AutoButtonColor = false
    TextButton:SetAttribute("NoHover", true)
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.Position = UDim2.fromOffset(1439, 56)
    TextButton.Size = UDim2.fromOffset(94, 50)
    TextButton.ZIndex = 20
    TextButton.Parent = Frame3

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.Name = "ClosePlate"
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Size = UDim2.fromScale(1, 1)
    ImageLabel2.ImageColor3 = v2
    ImageLabel2.ZIndex = 20
    ImageLabel2.Parent = TextButton

    local v54 = RaceIcons.Get("ref_top_plate")

    if v54 then
        ImageLabel2.ImageContent = v54
    else
        ImageLabel2.BackgroundTransparency = 0
        ImageLabel2.BackgroundColor3 = v2
    end

    local v55 = text(TextButton, "X", "X", 0, 0, 94, 50, 31, v3)

    v55.TextXAlignment = Center
    v55.ZIndex = 21

    local UIScale2 = Instance.new("UIScale", TextButton)
    local t9 = {}

    local function play(p25, p26, p27) -- line: 168
        -- upvalues: t9 (copy), TweenService (copy)
        if t9[p25] then
            t9[p25]:Cancel()
        end

        local tween = TweenService:Create(p25, p26, p27)

        t9[p25] = tween
        tween:Play()
    end

    local function hover(p28) -- line: 169
        -- upvalues: ImageLabel2 (copy), v55 (copy), t9 (copy), TweenService (copy), v2 (copy), v3 (copy), v4 (copy)
        local v56 = TweenInfo.new(0.18)
        local t10 = {
            ImageColor3 = p28 and v4 or v2
        }

        if t9[ImageLabel2] then
            t9[ImageLabel2]:Cancel()
        end

        local tween = TweenService:Create(ImageLabel2, v56, t10)

        t9[ImageLabel2] = tween
        tween:Play()

        local v57 = TweenInfo.new(0.18)
        local t11 = {
            TextColor3 = p28 and v2 or v3
        }

        if t9[v55] then
            t9[v55]:Cancel()
        end

        local tween2 = TweenService:Create(v55, v57, t11)

        t9[v55] = tween2
        tween2:Play()
    end

    TextButton.MouseEnter:Connect(function() -- line: 170
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.MouseLeave:Connect(function() -- line: 170
        -- upvalues: UIScale2 (copy), t9 (copy), hover (copy), TweenService (copy)
        hover(false)

        local v58 = TweenInfo.new(0.12)
        local t12 = {
            Scale = 1
        }

        if t9[UIScale2] then
            t9[UIScale2]:Cancel()
        end

        local tween = TweenService:Create(UIScale2, v58, t12)

        t9[UIScale2] = tween
        tween:Play()
    end)
    TextButton.SelectionGained:Connect(function() -- line: 171
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.SelectionLost:Connect(function() -- line: 171
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.MouseButton1Down:Connect(function() -- line: 172
        -- upvalues: UIScale2 (copy), t9 (copy), TweenService (copy)
        local v59 = TweenInfo.new(0.08)
        local t13 = {
            Scale = 0.94
        }

        if t9[UIScale2] then
            t9[UIScale2]:Cancel()
        end

        local tween = TweenService:Create(UIScale2, v59, t13)

        t9[UIScale2] = tween
        tween:Play()
    end)
    TextButton.MouseButton1Up:Connect(function() -- line: 173
        -- upvalues: UIScale2 (copy), t9 (copy), TweenService (copy)
        local v60 = TweenInfo.new(0.16, Enum.EasingStyle.Back)
        local t14 = {
            Scale = 1
        }

        if t9[UIScale2] then
            t9[UIScale2]:Cancel()
        end

        local tween = TweenService:Create(UIScale2, v60, t14)

        t9[UIScale2] = tween
        tween:Play()
    end)

    local function v61() -- line: 174
        -- upvalues: ImageLabel2 (copy), v55 (copy), UIScale2 (copy), t9 (copy), v2 (copy), v3 (copy)
        for _, v62 in t9 do
            v62:Cancel()
        end

        table.clear(t9)
        ImageLabel2.ImageColor3 = v2
        v55.TextColor3 = v3
        UIScale2.Scale = 1
    end

    local Frame6 = Instance.new("Frame")

    Frame6.Name = "LegendCard"
    Frame6.BackgroundTransparency = 1
    Frame6.Position = UDim2.fromOffset(104, 135)
    Frame6.Size = UDim2.fromOffset(209, 265)
    Frame6.ZIndex = 8
    Frame6.Parent = Frame3
    Instance.new("UIScale", Frame6).Scale = 0.818

    local Frame7 = Instance.new("Frame")

    Frame7.Name = "Card"
    Frame7.BorderSizePixel = 0
    Frame7.BackgroundColor3 = v2 or v2
    Frame7.Position = UDim2.fromOffset(0, 0)
    Frame7.Size = UDim2.fromOffset(209, 265)
    Frame7.ZIndex = 8
    Frame7.Parent = Frame6

    local UICorner3 = Instance.new("UICorner")

    UICorner3.CornerRadius = UDim.new(0, 18)
    UICorner3.Parent = Frame7

    local Frame8 = Instance.new("Frame")

    Frame8.Name = "SolidLegendColor"
    Frame8.BorderSizePixel = 0
    Frame8.BackgroundColor3 = v4 or v2
    Frame8.Position = UDim2.fromOffset(8, 8)
    Frame8.Size = UDim2.fromOffset(193, 249)
    Frame8.ZIndex = 9
    Frame8.Parent = Frame6
    Frame8.ClipsDescendants = true
    UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 12)
    UICorner3.Parent = Frame8

    local Frame9 = Instance.new("Frame")

    Frame9.Name = "Empty"
    Frame9.BorderSizePixel = 0
    Frame9.BackgroundColor3 = v3 or v2
    Frame9.Position = UDim2.fromOffset(8, 8)
    Frame9.Size = UDim2.fromOffset(193, 249)
    Frame9.ZIndex = 9
    Frame9.Parent = Frame6
    Frame7 = Instance.new("UICorner")
    Frame7.CornerRadius = UDim.new(0, 12)
    Frame7.Parent = Frame9
    Frame7 = text(Frame9, "Mark", "?", 0, 0, 193, 249, 120, Color3.fromRGB(75, 75, 75))
    Frame7.TextXAlignment = Center
    Frame7.ZIndex = 10

    local Frame10 = Instance.new("Frame")

    Frame10.Name = "Portrait"
    Frame10.BorderSizePixel = 0
    Frame10.BackgroundColor3 = v2 or v2
    Frame10.Position = UDim2.fromOffset(9, 9)
    Frame10.Size = UDim2.fromOffset(191, 247)
    Frame10.ZIndex = 10
    Frame10.Parent = Frame6
    Frame10.BackgroundTransparency = 1
    Frame10.ClipsDescendants = true

    local MouseLeave = Instance.new("UICorner")

    MouseLeave.CornerRadius = UDim.new(0, 12)
    MouseLeave.Parent = Frame10

    local ImageLabel3 = Instance.new("ImageLabel")

    ImageLabel3.Name = "Rider"
    ImageLabel3.BackgroundTransparency = 1
    ImageLabel3.Position = UDim2.fromOffset(-47, 17)
    ImageLabel3.Size = UDim2.fromOffset(279, 349)
    ImageLabel3.ZIndex = 10
    ImageLabel3.Parent = Frame10

    local Frame11 = Instance.new("Frame")

    Frame11.Name = "RigClip"
    Frame11.BackgroundTransparency = 1
    Frame11.BorderSizePixel = 0
    Frame11.ClipsDescendants = true
    Frame11.Position = UDim2.fromOffset(-191, -391)
    Frame11.Size = UDim2.fromOffset(591, 647)
    Frame11.ZIndex = 10
    Frame11.Visible = false
    Frame11.Parent = Frame6

    local function rigLayout(p29) -- line: 196
        p29.AnchorPoint = Vector2.new(0.5, 0.5)
        p29.Position = UDim2.fromOffset(295.5, 523.5)
        p29.Size = UDim2.fromOffset(362.9, 469.29999999999995)
    end

    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "Legend3DOutline"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ViewportFrame.Position = UDim2.fromOffset(295.5, 523.5)
    ViewportFrame.Size = UDim2.fromOffset(362.9, 469.29999999999995)
    ViewportFrame.ZIndex = 10
    ViewportFrame.Ambient = Color3.new(1, 1, 1)
    ViewportFrame.LightColor = Color3.new(0, 0, 0)
    ViewportFrame.Parent = Frame11

    local ViewportFrame2 = Instance.new("ViewportFrame")

    ViewportFrame2.Name = "Legend3D"
    ViewportFrame2.BackgroundTransparency = 1
    ViewportFrame2.AnchorPoint = Vector2.new(0.5, 0.5)
    ViewportFrame2.Position = UDim2.fromOffset(295.5, 523.5)
    ViewportFrame2.Size = UDim2.fromOffset(362.9, 469.29999999999995)
    ViewportFrame2.ZIndex = 11
    ViewportFrame2.Ambient = Color3.fromRGB(165, 150, 145)
    ViewportFrame2.LightColor = Color3.fromRGB(255, 246, 236)
    ViewportFrame2.LightDirection = Vector3.new(0.55, -0.6, -0.6)
    ViewportFrame2.Parent = Frame11

    local Camera = Instance.new("Camera")

    Camera.Parent = ViewportFrame2
    ViewportFrame2.CurrentCamera = Camera

    local Camera2 = Instance.new("Camera")

    Camera2.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera2

    local ImageLabel4 = Instance.new("ImageLabel")

    ImageLabel4.Name = "Number"
    ImageLabel4.BackgroundTransparency = 1
    ImageLabel4.AnchorPoint = Vector2.new(1, 1)
    ImageLabel4.Position = UDim2.fromOffset(204, 261)
    ImageLabel4.ZIndex = 12
    ImageLabel4.Parent = Frame6

    local t15 = {
        id = nil,
        model = nil,
        outline = nil
    }
    local elapsed = os.clock()

    local function setLegend(p30) -- line: 207
        -- upvalues: Frame8 (copy), Frame9 (copy), Frame10 (copy), ImageLabel3 (copy), Frame11 (copy), ViewportFrame (copy), ViewportFrame2 (copy), Camera (copy), Camera2 (copy), ImageLabel4 (copy), t15 (copy), Parent (copy), UIArt (copy), LegendsCatalog (copy), LegendRig (copy), v4 (copy)
        local v63, v64

        if typeof(p30) ~= "string" or p30 == "" then
            v64 = false
        else
            local v65 = LegendsCatalog.Legends[p30]

            if v65 then
                v63 = v65
                v64 = true
            else
                v64 = false
            end
        end

        if not v64 then
            v63 = nil
        end

        Frame8.Visible = v63 ~= nil
        Frame10.Visible = v63 ~= nil
        Frame11.Visible = v63 ~= nil
        Frame9.Visible = v63 == nil
        ImageLabel4.Visible = false

        if not v63 then
            return
        end

        Frame8.BackgroundColor3 = v63.Color or v4

        local Rig = v63.Rig
        local LegendRigs = Parent:FindFirstChild("LegendRigs")
        local v66 = Rig and LegendRigs and LegendRigs:FindFirstChild(Rig)
        local v67 = false
        local v68 = false
        local v69 = false
        local v70 = false

        if v66 then
            v67 = true
        else
            v70 = true
        end

        if v67 then
            if t15.id == Rig then
                v70 = false
            else
                v68 = true
            end
        end

        v67 = false

        if v68 then
            if t15.model then
                v67 = true
            else
                v69 = true
            end
        end

        v68 = false

        if v67 then
            v69 = true
            t15.model:Destroy()
        end

        v67 = false

        if v69 then
            if t15.outline then
                v67 = true
            else
                v68 = true
            end
        end

        v69 = false

        if v67 then
            v68 = true
            t15.outline:Destroy()
        end

        v67 = false

        local v71, v72

        if v68 then
            t15.id = Rig
            t15.model = v66:Clone()
            t15.outline = LegendRig.MakeOutline(v66)
            v71 = LegendRig.Cameras[Rig]

            if v71 then
                v67 = true
            else
                v72 = v71
                v69 = true
            end
        end

        v68 = false

        if v67 then
            v72 = v71.Slot
            v69 = true
        end

        v67 = false

        if v69 then
            if v72 then
                v67 = true
            else
                v68 = true
            end
        end

        if v67 then
            local v76 = math.deg(math.atan(math.tan(math.rad(v72.Fov) / 2) * 1.9) * 2)

            Camera.FieldOfView = v76
            Camera.CFrame = CFrame.lookAt(v72.Pos, v72.Look)
            Camera2.FieldOfView = v76
            v68 = true
            Camera2.CFrame = Camera.CFrame
        end

        if v68 then
            LegendRig.Apply(t15.model, Rig, CFrame.identity, 0)
            LegendRig.Apply(t15.outline, Rig, CFrame.identity, 0)
            t15.model.Parent = ViewportFrame2
            v70 = false
            t15.outline.Parent = ViewportFrame
        end

        if v70 then
            if t15.model then
                t15.model:Destroy()
                t15.model = nil
            end

            if t15.outline then
                t15.outline:Destroy()
                t15.outline = nil
            end

            t15.id = nil
            ViewportFrame2.Visible = false
            ViewportFrame.Visible = false
            ImageLabel3.Visible = true

            if v63.Art then
                UIArt.Apply(ImageLabel3, v63.Art)
            end
        else
            ViewportFrame2.Visible = true
            ViewportFrame.Visible = true
            ImageLabel3.Visible = false
        end

        local v77 = v63.Number and Parent.UIArt:FindFirstChild(v63.Number)

        if not v77 then
            return
        end

        local v78 = v77:GetAttribute("W") or 2
        local v79 = v77:GetAttribute("H") or 1
        local v81 = math.min(54, 104 * v79 / v78)

        ImageLabel4.Size = UDim2.fromOffset(math.floor(v81 * v78 / v79 + 0.5), (math.floor(v81 + 0.5)))
        ImageLabel4.ImageContent = Content.none
        UIArt.Apply(ImageLabel4, v63.Number)
        ImageLabel4.Visible = true
    end

    local v85 = text(Frame3, "Flag", "", 334, 126, 70, 48, 46)

    v85.FontFace = Font.fromEnum(Enum.Font.BuilderSans)

    local v86 = text(Frame3, "Points", "0 PTS", 338, 182, 400, 34, 27)
    local v87 = text(Frame3, "Wins", "0 WINS", 339, 220, 400, 22, 18)
    local Frame12 = Instance.new("Frame")

    Frame12.Name = "DeviceIcon"
    Frame12.BorderSizePixel = 0
    Frame12.BackgroundColor3 = v2 or v2
    Frame12.Position = UDim2.fromOffset(339, 260)
    Frame12.Size = UDim2.fromOffset(60, 54)
    Frame12.ZIndex = 6
    Frame12.Parent = Frame3
    Frame12.BackgroundTransparency = 1

    local function setDevice(p31) -- line: 245
        -- upvalues: Frame12 (copy), v2 (copy), v3 (copy)
        Frame12:ClearAllChildren()

        local function shape(p32, p33, p34, p35, p36, p37, p38) -- line: 247
            -- upvalues: Frame12 (copy), v2 (copy)
            p37 = p37 or v2

            local Frame = Instance.new("Frame")

            Frame.Name = p32
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = p37 or v2
            Frame.Position = UDim2.fromOffset(0, 0)
            Frame.Size = UDim2.fromOffset(0, 0)
            Frame.ZIndex = 6
            Frame.Parent = Frame12
            Frame.Position = UDim2.fromScale(p33, p34)
            Frame.Size = UDim2.fromScale(p35, p36)

            if p38 then
                local UICorner = Instance.new("UICorner")

                UICorner.CornerRadius = UDim.new(0, p38)
                UICorner.Parent = Frame
            end

            return Frame
        end

        local function outline(p39) -- line: 251
            -- upvalues: v2 (copy)
            p39.BackgroundTransparency = 1

            local UIStroke = Instance.new("UIStroke", p39)

            UIStroke.Color = v2
            UIStroke.Thickness = 4
        end

        if p31 == "Controller" then
            shape("Body", 0.04, 0.25, 0.92, 0.5, v2, 10)
            shape("LeftGrip", 0.04, 0.47, 0.26, 0.37, v2, 8)
            shape("RightGrip", 0.7, 0.47, 0.26, 0.37, v2, 8)

            local v89 = v3 or v2
            local Frame = Instance.new("Frame")

            Frame.Name = "DpadH"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v89 or v2
            Frame.Position = UDim2.fromOffset(0, 0)
            Frame.Size = UDim2.fromOffset(0, 0)
            Frame.ZIndex = 6
            Frame.Parent = Frame12
            Frame.Position = UDim2.fromScale(0.16, 0.45)
            Frame.Size = UDim2.fromScale(0.25, 0.08)

            local v90 = v3 or v2
            local Frame2 = Instance.new("Frame")

            Frame2.Name = "DpadV"
            Frame2.BorderSizePixel = 0
            Frame2.BackgroundColor3 = v90 or v2
            Frame2.Position = UDim2.fromOffset(0, 0)
            Frame2.Size = UDim2.fromOffset(0, 0)
            Frame2.ZIndex = 6
            Frame2.Parent = Frame12
            Frame2.Position = UDim2.fromScale(0.245, 0.365)
            Frame2.Size = UDim2.fromScale(0.08, 0.25)
            shape("ButtonA", 0.65, 0.47, 0.1, 0.1, v3, 4)
            shape("ButtonB", 0.78, 0.36, 0.1, 0.1, v3, 4)
        elseif p31 == "Mobile" then
            local v91 = shape("Phone", 0.25, 0.03, 0.5, 0.94, v2, 6)

            v91.BackgroundTransparency = 1

            local UIStroke = Instance.new("UIStroke", v91)

            UIStroke.Color = v2
            UIStroke.Thickness = 4

            local v92 = v2 or v2
            local Frame = Instance.new("Frame")

            Frame.Name = "Speaker"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v92 or v2
            Frame.Position = UDim2.fromOffset(0, 0)
            Frame.Size = UDim2.fromOffset(0, 0)
            Frame.ZIndex = 6
            Frame.Parent = Frame12
            Frame.Position = UDim2.fromScale(0.4, 0.12)
            Frame.Size = UDim2.fromScale(0.2, 0.05)
            shape("Home", 0.45, 0.82, 0.1, 0.06, v2, 2)
        else
            local v93 = shape("Monitor", 0.03, 0.06, 0.94, 0.64, v2, 3)

            v93.BackgroundTransparency = 1

            local UIStroke = Instance.new("UIStroke", v93)

            UIStroke.Color = v2
            UIStroke.Thickness = 4

            local v94 = v2 or v2
            local Frame = Instance.new("Frame")

            Frame.Name = "Stand"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v94 or v2
            Frame.Position = UDim2.fromOffset(0, 0)
            Frame.Size = UDim2.fromOffset(0, 0)
            Frame.ZIndex = 6
            Frame.Parent = Frame12
            Frame.Position = UDim2.fromScale(0.45, 0.72)
            Frame.Size = UDim2.fromScale(0.1, 0.14)

            local v95 = v2 or v2
            local Frame2 = Instance.new("Frame")

            Frame2.Name = "Base"
            Frame2.BorderSizePixel = 0
            Frame2.BackgroundColor3 = v95 or v2
            Frame2.Position = UDim2.fromOffset(0, 0)
            Frame2.Size = UDim2.fromOffset(0, 0)
            Frame2.ZIndex = 6
            Frame2.Parent = Frame12
            Frame2.Position = UDim2.fromScale(0.24, 0.86)
            Frame2.Size = UDim2.fromScale(0.52, 0.1)
        end
    end

    local ViewportFrame3 = Instance.new("ViewportFrame")

    ViewportFrame3.Name = "Bike3D"
    ViewportFrame3.BackgroundTransparency = 1
    ViewportFrame3.Position = UDim2.fromOffset(105, 318)
    ViewportFrame3.Size = UDim2.fromOffset(520, 400)
    ViewportFrame3.ZIndex = 4
    ViewportFrame3.LightDirection = Vector3.new(-0.4, -0.6, -0.7)
    ViewportFrame3.Parent = Frame3

    local WorldModel = Instance.new("WorldModel")

    WorldModel.Parent = ViewportFrame3

    local Camera3 = Instance.new("Camera")

    Camera3.FieldOfView = 30
    Camera3.Parent = ViewportFrame3
    ViewportFrame3.CurrentCamera = Camera3

    local clone, v96, v97
    local v99 = Vector3.new(-1.05, -(ok and result.RideHeight or 1.331) + 2.6, 0.45)

    t1.BikeYaw = 0.9075712110370514
    t1.BikePitch = 0.12217304763960307
    t1.BikeFill = 0.96
    t1.BikeTight = 0.9

    local t16

    local function frameBike() -- line: 284
        -- upvalues: ViewportFrame3 (copy), Camera3 (copy), clone (ref), v99 (copy), t16 (ref), t1 (copy)
        if not clone then
            return
        end

        local BikeYaw, BikePitch = t1.BikeYaw, t1.BikePitch
        local v103 = v99 + Vector3.new(-math.sin(BikeYaw) * math.cos(BikePitch), math.sin(BikePitch), -math.cos(BikeYaw) * math.cos(BikePitch)) * 24.735685585049538

        if not t16 then
            t16 = {}

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                    local CFrame = descendant.CFrame
                    local v104 = descendant.Size / 2

                    for _, v105 in { -1, 1 } do
                        for _, v106 in { -1, 1 } do
                            for _, v107 in { -1, 1 } do
                                local t17 = t16

                                table.insert(t17, CFrame * Vector3.new(v105 * v104.X, v106 * v104.Y, v107 * v104.Z))
                            end
                        end
                    end
                end
            end
        end

        if #t16 == 0 then
            return
        end

        local function extents(p40) -- line: 298
            -- upvalues: t16 (ref)
            local n1 = 1e999
            local n2 = (-1e999)
            local n3 = 1e999
            local n4 = (-1e999)

            for _, v112 in t16 do
                local v113 = p40:PointToObjectSpace(v112)
                local v115 = math.max(-v113.Z, 0.05)
                local v116 = v113.X / v115
                local v117 = v113.Y / v115

                if v116 < n1 then
                    n1 = v116
                end

                if n2 < v116 then
                    n2 = v116
                end

                if v117 < n3 then
                    n3 = v117
                end

                if n4 < v117 then
                    n4 = v117
                end
            end

            return n1, n2, n3, n4
        end

        local v118 = CFrame.lookAt(v103, clone:GetBoundingBox().Position)

        for _ = 1, 2 do
            local v119, v120, v121, v122 = extents(v118)

            v118 = CFrame.lookAt(v103, v103 + v118:VectorToWorldSpace((Vector3.new((v119 + v120) / 2, (v121 + v122) / 2, -1))))
        end

        local v125, v126, v127, v128 = extents(v118)
        local AbsoluteSize = ViewportFrame3.AbsoluteSize
        local v129, v130

        if AbsoluteSize.X > 1 and AbsoluteSize.Y > 1 then
            local v131 = AbsoluteSize.X / AbsoluteSize.Y

            if v131 then
                v129 = v131
                v130 = true
            else
                v130 = false
            end
        else
            v130 = false
        end

        if not v130 then
            v129 = 1.1818181818181819
        end

        Camera3.FieldOfView = math.clamp(math.deg(math.atan(math.max((v128 - v127) / 2, (v126 - v125) / 2 / v129) * t1.BikeTight / t1.BikeFill) * 2), 1, 70)
        Camera3.CFrame = v118
        ViewportFrame3.LightDirection = v118:VectorToWorldSpace((Vector3.new(-0.12, -0.5, -1))).Unit
    end

    ViewportFrame3:GetPropertyChangedSignal("AbsoluteSize"):Connect(frameBike)

    local function setBike(p41) -- line: 321
        -- upvalues: WorldModel (copy), clone (ref), v96 (ref), v97 (ref), t16 (ref), frameBike (copy), Parent (copy), BikeCatalog (copy), VisualScale (copy)
        local v137

        if typeof(p41) == "string" then
            local v138

            for _, v139 in BikeCatalog.Order do
                if v139:upper() == p41:upper() then
                    v138 = v139
                end

                v137 = v138
            end
        end

        local v140 = v137 or BikeCatalog.Order[1]

        if v140 == v96 and (clone or v97) then
            return
        end

        if clone then
            clone:Destroy()
            clone = nil
        end

        v96 = v140

        local v141 = Parent:FindFirstChild(v140 .. "Display")

        if not v141 then
            return
        end

        v97 = true

        local function v142() -- line: 330
            -- upvalues: v141 (copy)
            game:GetService("ContentProvider"):PreloadAsync({
                v141
            })
        end

        pcall(v142)
        v97 = false

        if v96 == v140 and not clone then
            local clone2 = v141:Clone()

            clone2.Name = "ProfileBike"

            local function v143() -- line: 334
                -- upvalues: v141 (copy), clone2 (copy), VisualScale (copy)
                clone2:ScaleTo(v141:GetScale() * VisualScale)
            end

            pcall(v143)
            clone2:PivotTo(CFrame.new())

            for _, descendant in clone2:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanTouch = false
                    descendant.CanQuery = false
                elseif descendant:IsA("BaseScript") or descendant:IsA("Sound") then
                    descendant:Destroy()
                end
            end

            local function v144() -- line: 341
                -- upvalues: clone2 (copy), Parent (copy)
                require(Parent:WaitForChild("PaddockStandPose")).Apply(clone2)
            end

            pcall(v144)

            local BoundingBox = clone2:GetBoundingBox()

            clone2:PivotTo(clone2:GetPivot() + (Vector3.new(0.059, 1.217, 0.498) - BoundingBox.Position))
            clone2.Parent = WorldModel
            clone = clone2
            t16 = nil
            frameBike()
        end
    end

    t4.FrameBike = frameBike

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "Circuits"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(669, 131)
    ScrollingFrame.Size = UDim2.fromOffset(851, 641)
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.ScrollBarImageTransparency = 1
    ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.ZIndex = 6
    ScrollingFrame.Parent = Frame3

    local UIListLayout2 = Instance.new("UIListLayout")

    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout2.Padding = UDim.new(0, 28)
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Parent = ScrollingFrame
    UIListLayout2 = Instance.new("UIPadding", ScrollingFrame)
    UIListLayout2.PaddingLeft = UDim.new(0, 5)
    UIListLayout2.PaddingTop = UDim.new(0, 5)
    UIListLayout2.PaddingRight = UDim.new(0, 40)

    local v145 = Color3.fromRGB(28, 28, 32)
    local Frame13 = Instance.new("Frame")

    Frame13.Name = "SliderTrack"
    Frame13.BorderSizePixel = 0
    Frame13.BackgroundColor3 = v145 or v2
    Frame13.Position = UDim2.fromOffset(678, 795)
    Frame13.Size = UDim2.fromOffset(842, 4)
    Frame13.ZIndex = 6
    Frame13.Parent = Frame3
    v145 = Instance.new("UICorner")
    v145.CornerRadius = UDim.new(0, 2)
    v145.Parent = Frame13

    local Frame14 = Instance.new("Frame")

    Frame14.Name = "SliderThumb"
    Frame14.BorderSizePixel = 0
    Frame14.BackgroundColor3 = v2 or v2
    Frame14.Position = UDim2.fromOffset(678, 795)
    Frame14.Size = UDim2.fromOffset(300, 4)
    Frame14.ZIndex = 7
    Frame14.Parent = Frame3

    local UICorner4 = Instance.new("UICorner")

    UICorner4.CornerRadius = UDim.new(0, 2)
    UICorner4.Parent = Frame14
    Frame14.Active = true
    UICorner4 = Instance.new("UIStroke")
    UICorner4.Color = Color3.fromRGB(58, 58, 64)
    UICorner4.Thickness = 3
    UICorner4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UICorner4.Parent = Frame14

    local function maxScroll() -- line: 358
        -- upvalues: ScrollingFrame (copy)
        return (math.max(0, ScrollingFrame.AbsoluteCanvasSize.X - ScrollingFrame.AbsoluteWindowSize.X))
    end

    local function updateThumb() -- line: 359
        -- upvalues: ScrollingFrame (copy), Frame13 (copy), Frame14 (copy)
        local X = ScrollingFrame.AbsoluteCanvasSize.X
        local X2 = ScrollingFrame.AbsoluteWindowSize.X
        local v150 = math.floor(842 * (X > 0 and math.clamp(X2 / X, 0.15, 1) or 1))
        local v152 = math.max(0, ScrollingFrame.AbsoluteCanvasSize.X - ScrollingFrame.AbsoluteWindowSize.X)
        local v153 = v152 > 0 and math.clamp(ScrollingFrame.CanvasPosition.X / v152, 0, 1) or 0

        Frame14.Size = UDim2.fromOffset(v150, 4)
        Frame14.Position = UDim2.fromOffset(math.floor((842 - v150) * v153) + 678, 795)
        Frame14.Visible = v152 > 0
        Frame13.Visible = v152 > 0
    end

    ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(updateThumb)
    ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateThumb)
    ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateThumb)

    local n5 = 0
    local v156 = false

    local function scrollTo(p42) -- line: 372
        -- upvalues: ScrollingFrame (copy), n5 (ref), v156 (ref)
        n5 = math.clamp(p42, 0, (math.max(0, ScrollingFrame.AbsoluteCanvasSize.X - ScrollingFrame.AbsoluteWindowSize.X)))
        v156 = true
    end

    RunService.RenderStepped:Connect(function(p43) -- line: 375
        -- upvalues: ScrollingFrame (copy), n5 (ref), v156 (ref)
        if not v156 then
            return
        end

        local X = ScrollingFrame.CanvasPosition.X
        local v161 = X + (n5 - X) * (1 - math.exp(-p43 * 14))

        if math.abs(n5 - v161) < 0.5 then
            v161 = n5
            v156 = false
        end

        ScrollingFrame.CanvasPosition = Vector2.new(v161, 0)
    end)
    UserInputService.InputChanged:Connect(function(p44) -- line: 382
        -- upvalues: ScreenGui (copy), UIScale (copy), Frame3 (copy), ScrollingFrame (copy), n5 (ref), v156 (ref), UserInputService (copy)
        if ScreenGui.Enabled and p44.UserInputType == Enum.UserInputType.MouseWheel then
            local MouseLocation = UserInputService:GetMouseLocation()
            local AbsolutePosition, AbsoluteSize = Frame3.AbsolutePosition, Frame3.AbsoluteSize

            if MouseLocation.X < AbsolutePosition.X or MouseLocation.Y < AbsolutePosition.Y or MouseLocation.X > AbsolutePosition.X + AbsoluteSize.X or MouseLocation.Y > AbsolutePosition.Y + AbsoluteSize.Y then
                return
            end

            local v163 = v156 and n5 or ScrollingFrame.CanvasPosition.X
            local v164 = 324 * UIScale.Scale

            n5 = math.clamp(v163 - p44.Position.Z * v164, 0, (math.max(0, ScrollingFrame.AbsoluteCanvasSize.X - ScrollingFrame.AbsoluteWindowSize.X)))
            v156 = true
        end
    end)

    local v168, X, X2

    Frame14.InputBegan:Connect(function(p45) -- line: 392
        -- upvalues: ScrollingFrame (copy), v156 (ref), v168 (ref), X (ref), X2 (ref)
        if p45.UserInputType ~= Enum.UserInputType.MouseButton1 and p45.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        v168 = p45
        X = p45.Position.X
        X2 = ScrollingFrame.CanvasPosition.X
        v156 = false
    end)
    Frame13.Active = true
    Frame13.InputBegan:Connect(function(p46) -- line: 398
        -- upvalues: ScrollingFrame (copy), Frame13 (copy), n5 (ref), v156 (ref)
        if p46.UserInputType ~= Enum.UserInputType.MouseButton1 and p46.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        n5 = math.clamp(math.clamp((p46.Position.X - Frame13.AbsolutePosition.X) / math.max(1, Frame13.AbsoluteSize.X), 0, 1) * math.max(0, ScrollingFrame.AbsoluteCanvasSize.X - ScrollingFrame.AbsoluteWindowSize.X), 0, (math.max(0, ScrollingFrame.AbsoluteCanvasSize.X - ScrollingFrame.AbsoluteWindowSize.X)))
        v156 = true
    end)
    UserInputService.InputChanged:Connect(function(p47) -- line: 403
        -- upvalues: ScrollingFrame (copy), Frame13 (copy), Frame14 (copy), v168 (ref), X (ref), X2 (ref)
        if v168 and (p47.UserInputType == Enum.UserInputType.MouseMovement or p47 == v168) then
            local v177 = math.max(1, Frame13.AbsoluteSize.X - Frame14.AbsoluteSize.X)
            local v180 = X2 + (p47.Position.X - X) / v177 * math.max(0, ScrollingFrame.AbsoluteCanvasSize.X - ScrollingFrame.AbsoluteWindowSize.X)

            ScrollingFrame.CanvasPosition = Vector2.new(math.clamp(v180, 0, (math.max(0, ScrollingFrame.AbsoluteCanvasSize.X - ScrollingFrame.AbsoluteWindowSize.X))), 0)
        end
    end)
    UserInputService.InputEnded:Connect(function(p48) -- line: 411
        -- upvalues: v168 (ref)
        if v168 and (p48 == v168 or p48.UserInputType == Enum.UserInputType.MouseButton1) then
            v168 = nil
        end
    end)

    local function medal(p49, p50, p51, p52) -- line: 416
        -- upvalues: text (copy), v2 (copy), Center (copy), t2 (copy)
        local v183 = t2[p50]
        local Frame = Instance.new("Frame")

        Frame.Name = v183.name .. "Medal"
        Frame.BackgroundTransparency = 1
        Frame.AnchorPoint = Vector2.new(0.5, 0)
        Frame.Position = UDim2.fromOffset(p51, p52)
        Frame.Size = UDim2.fromOffset(36, 42)
        Frame.ZIndex = 7
        Frame.Parent = p49

        for v184, v185 in { -20, 20 } do
            local v186 = "Ribbon" .. v184
            local v187 = Color3.fromRGB(176, 14, 24)
            local Frame2 = Instance.new("Frame")

            Frame2.Name = v186
            Frame2.BorderSizePixel = 0
            Frame2.BackgroundColor3 = v187 or v2
            Frame2.Position = UDim2.fromOffset(0, 0)
            Frame2.Size = UDim2.fromOffset(0, 0)
            Frame2.ZIndex = 7
            Frame2.Parent = Frame
            Frame2.AnchorPoint = Vector2.new(0.5, 0)
            Frame2.Position = UDim2.fromOffset(18 + (v184 == 1 and -6 or 6), 20)
            Frame2.Size = UDim2.fromOffset(9, 22)
            Frame2.Rotation = v185
        end

        local fill = v183.fill
        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Coin"
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = fill or v2
        Frame2.Position = UDim2.fromOffset(3, 0)
        Frame2.Size = UDim2.fromOffset(30, 30)
        Frame2.ZIndex = 8
        Frame2.Parent = Frame

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, 15)
        UICorner.Parent = Frame2

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = v183.ring
        UIStroke.Thickness = 2
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = Frame2

        local v188 = text(Frame2, "Rank", tostring(p50), 0, 0, 30, 30, 18, v183.ink)

        v188.TextXAlignment = Center
        v188.ZIndex = 9

        local v189 = text(p49, v183.name .. "Count", "0", p51 - 40, p52 + 46, 80, 22, 17)

        v189.TextXAlignment = Center
        v189.ZIndex = 7

        return v189
    end

    local v190 = medal(Frame3, 1, 150, 722)
    local v191 = medal(Frame3, 2, 236, 722)
    local v192 = medal(Frame3, 3, 322, 722)

    text(Frame3, "DistanceLabel", "DISTANCE", 400, 718, 240, 30, 24, v5).ZIndex = 7

    local v193 = text(Frame3, "Distance", "0 KM", 400, 752, 240, 36, 30)

    v193.ZIndex = 7

    local function kmText(p53) -- line: 434
        local v194 = (tonumber(p53) or 0) / 1000

        if v194 < 100 then
            return string.format("%.1f KM", math.floor(v194 * 10) / 10)
        end

        local v197 = tostring((math.floor(v194))):reverse():gsub("(%d%d%d)", "%1."):reverse()

        if v197:sub(1, 1) == "." then
            v197 = v197:sub(2)
        end

        return v197 .. " KM"
    end

    local function outlineInto(p54, p55) -- line: 440
        -- upvalues: t5 (copy), v2 (copy), t3 (copy)
        local v198 = t3[p55]

        if not v198 then
            return
        end

        local Offset = p54.Size.X.Offset
        local Offset2 = p54.Size.Y.Offset
        local v199 = Offset - 12
        local v200 = Offset2 - 12

        if v199 / v200 > v198.aspect then
            v199 = v200 * v198.aspect
        else
            v200 = v199 / v198.aspect
        end

        local v201 = (Offset - v199) / 2
        local v202 = (Offset2 - v200) / 2
        local t18 = {}

        for match, v203 in v198.pts:gmatch("(%d+),(%d+)") do
            table.insert(t18, Vector2.new(v201 + tonumber(match) / 999 * v199, v202 + tonumber(v203) / 999 * v200))
        end

        local v206 = #t18

        if v206 < 3 then
            return
        end

        local function cp(p56) -- line: 449
            -- upvalues: Offset (copy), Offset2 (copy), t18 (copy), v206 (copy)
            local v207 = t18[(p56 - 1) % v206 + 1]
            local v208 = (t18[p56 % v206 + 1] - t18[(p56 - 2) % v206 + 1]) / 6

            return Path2DControlPoint.new(UDim2.fromScale(v207.X / Offset, v207.Y / Offset2), UDim2.fromScale(-v208.X / Offset, -v208.Y / Offset2), UDim2.fromScale(v208.X / Offset, v208.Y / Offset2))
        end

        local n6 = 1

        while true do
            local v211 = math.min(n6 + 90, v206 + 1)
            local t19 = {}

            for i = n6, v211 do
                table.insert(t19, cp(i))
            end

            local Path2D = Instance.new("Path2D")

            Path2D.Name = "TrackLine"
            Path2D.Color3 = v2
            Path2D.Thickness = 5
            Path2D.ZIndex = 7
            Path2D:SetControlPoints(t19)
            Path2D.Parent = p54
            table.insert(t5, Path2D)

            if v206 < v211 then
                break
            end

            n6 = v211
        end
    end

    local t20 = {}
    local t21 = {
        "Jerez",
        "Lusail",
        "Mandalika",
        "Mugello",
        "Sepang"
    }
    local v212

    for _, child in Parent.Tracks:GetChildren() do
        if not table.find(t21, child.Name) then
            v212 = child.Name
            table.insert(t21, v212)
        end
    end

    for _, v213 in t21 do
        v212 = "Circuit_" .. v213

        local Frame = Instance.new("Frame")

        Frame.Name = v212
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = v3 or v2
        Frame.Position = UDim2.fromOffset(0, 0)
        Frame.Size = UDim2.fromOffset(296, 625)
        Frame.ZIndex = 6
        Frame.Parent = ScrollingFrame

        local UIStroke = Instance.new("UICorner")

        UIStroke.CornerRadius = UDim.new(0, 28)
        UIStroke.Parent = Frame
        UIStroke = Instance.new("UIStroke")
        UIStroke.Color = v6
        UIStroke.Thickness = 5
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = Frame

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Outline"
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = v3 or v2
        Frame2.Position = UDim2.fromOffset(30, 58)
        Frame2.Size = UDim2.fromOffset(236, 200)
        Frame2.ZIndex = 7
        Frame2.Parent = Frame
        Frame2.BackgroundTransparency = 1
        pcall(outlineInto, Frame2, v213)
        v212 = {
            card = Frame,
            border = UIStroke
        }
        v212.gold = medal(Frame, 1, 69, 298)
        v212.silver = medal(Frame, 2, 146, 298)
        v212.bronze = medal(Frame, 3, 223, 298)
        text(Frame, "BestLapLabel", "BEST LAP", 40, 380, 240, 32, 25, v5).ZIndex = 7
        v212.best = text(Frame, "BestLap", "-:--.---", 40, 416, 240, 22, 18)
        v212.best.ZIndex = 7
        text(Frame, "LapsLabel", "LAPS", 40, 454, 240, 32, 25, v5).ZIndex = 7
        v212.laps = text(Frame, "Laps", "0", 40, 490, 240, 22, 18)
        v212.laps.ZIndex = 7
        text(Frame, "PlaytimeLabel", "PLAYTIME", 40, 528, 240, 32, 25, v5).ZIndex = 7
        v212.play = text(Frame, "Playtime", "0M", 40, 564, 240, 22, 18)
        v212.play.ZIndex = 7
        t20[v213] = v212
    end

    local userId

    RunService.RenderStepped:Connect(function() -- line: 485
        -- upvalues: ScreenGui (copy), t15 (copy), elapsed (copy), LegendRig (copy)
        if not (ScreenGui.Enabled and t15.model and t15.id) then
            return
        end

        local v214 = os.clock() - elapsed

        LegendRig.Apply(t15.model, t15.id, CFrame.identity, v214)
        LegendRig.Apply(t15.outline, t15.id, CFrame.identity, v214)
    end)

    local t22 = {
        ProfileHUD = true,
        TouchGui = true,
        ExitTeleportCover = true,
        WeatherVote = true
    }

    t1.KeepGuis = t22

    local t23 = {}
    local v215

    local function hideGui(p57) -- line: 498
        -- upvalues: ScreenGui (copy), t22 (copy), t23 (copy)
        if p57 == ScreenGui or not p57:IsA("ScreenGui") or t22[p57.Name] or t23[p57] then
            return
        end

        local t24 = {
            own = 0,
            wanted = p57.Enabled
        }

        t23[p57] = t24

        local function off() -- line: 502
            -- upvalues: p57 (copy), t24 (copy)
            if p57.Enabled then
                t24.own += 1
                p57.Enabled = false
            end
        end

        t24.conn = p57:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 503
            -- upvalues: p57 (copy), t24 (copy)
            local Enabled = p57.Enabled
            local Enabled2

            if Enabled then
                t24.wanted = true
                Enabled2 = p57.Enabled
            else
                if t24.own > 0 then
                    t24.own -= 1

                    return
                end

                t24.wanted = false
            end

            if (not Enabled or Enabled2) and Enabled then
                t24.own += 1
                p57.Enabled = false
            end
        end)

        if p57.Enabled then
            t24.own += 1
            p57.Enabled = false
        end
    end

    local function hideGuis() -- line: 510
        -- upvalues: p4 (copy), v215 (ref), hideGui (copy)
        for _, child in p4:GetChildren() do
            hideGui(child)
        end

        v215 = v215 or p4.ChildAdded:Connect(hideGui)
    end

    local function restoreGuis() -- line: 514
        -- upvalues: t23 (copy), v215 (ref)
        if v215 then
            v215:Disconnect()
            v215 = nil
        end

        for v216, v217 in t23 do
            v217.conn:Disconnect()

            if v216.Parent and v217.wanted then
                v216.Enabled = true
            end
        end

        table.clear(t23)
    end

    t1.BlurSize = 20

    local BlurEffect

    local function setBlur(p58) -- line: 521
        -- upvalues: BlurEffect (ref), TweenService (copy), t1 (copy)
        if p58 then
            local CurrentCamera = workspace.CurrentCamera

            if not (BlurEffect and BlurEffect.Parent) then
                BlurEffect = Instance.new("BlurEffect")
                BlurEffect.Name = "ProfileBlur"
                BlurEffect.Size = 0
                BlurEffect.Parent = CurrentCamera
            end

            TweenService:Create(BlurEffect, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = t1.BlurSize
            }):Play()
        elseif BlurEffect then
            local BlurEffect2 = BlurEffect

            BlurEffect = nil

            local tween = TweenService:Create(BlurEffect2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = 0
            })

            tween.Completed:Connect(function() -- line: 529
                -- upvalues: BlurEffect2 (copy)
                BlurEffect2:Destroy()
            end)
            tween:Play()
        end
    end

    local function flagOpen(p59) -- line: 532
        -- upvalues: p4 (copy)
        local JerezRaceHUD = p4:FindFirstChild("JerezRaceHUD")

        if JerezRaceHUD then
            JerezRaceHUD:SetAttribute("ProfileOpen", p59)
        end
    end

    function t4.Show(p60, p61) -- line: 535
        -- upvalues: p4 (copy), ScreenGui (copy), fit (copy), ImageLabel (copy), v24 (copy), setHeaderRole (copy), v61 (copy), setLegend (copy), v85 (copy), v86 (copy), v87 (copy), setDevice (copy), frameBike (copy), setBike (copy), ScrollingFrame (copy), updateThumb (copy), n5 (ref), v156 (ref), v190 (copy), v191 (copy), v192 (copy), v193 (copy), kmText (copy), t20 (copy), t21 (copy), userId (ref), v215 (ref), hideGui (copy), BlurEffect (ref), TweenService (copy), NumberFormat (copy), t1 (copy), flagText (copy)
        p60 = p60 or {}
        userId = p60.userId
        v24.Text = string.upper((tostring(p60.name or ""))) .. (string.upper((tostring(p60.name or ""))):sub(-1) == "S" and "' PROFILE" or "'S PROFILE")
        v85.Text = flagText(p60.country)
        v86.Text = NumberFormat.Short(tonumber(p60.pts) or 0):upper() .. " PTS"

        local v222, v223

        if p60.wins then
            local v224 = tostring(p60.wins) .. (if p60.wins == 1 then " WIN" else " WINS")

            if v224 then
                v222 = v224
                v223 = true
            else
                v223 = false
            end
        else
            v223 = false
        end

        v87.Text = if not v223 then "- WINS" else v222
        setDevice(p60.device)
        setLegend(p60.legend)
        task.spawn(setBike, p60.bike)
        v24.TextSize = math.clamp(math.floor(1050 / math.max(1, (utf8.len(v24.Text) or #v24.Text) * 0.8)), 20, 36)
        ImageLabel.Image = typeof(p60.userId) == "number" and ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(p60.userId) or ""
        setHeaderRole(p60.role)

        local n7 = 0
        local n8 = 0
        local n9 = 0
        local n10 = 0

        for _, v229 in p60.tracks or {} do
            n7 += tonumber(v229.gold) or 0
            n8 += tonumber(v229.silver) or 0
            n9 += tonumber(v229.bronze) or 0
            n10 += tonumber(v229.meters) or 0
        end

        local v230 = p60.tracks ~= nil

        v190.Text = v230 and tostring(n7) or "-"
        v191.Text = v230 and tostring(n8) or "-"
        v192.Text = v230 and tostring(n9) or "-"
        v193.Text = v230 and kmText(n10) or "-"

        for _, v235 in t21 do
            local v236 = t20[v235]
            local v237 = p60.tracks and p60.tracks[v235]

            v236.card.LayoutOrder = v235 == p60.current and 0 or 1

            local gold = v236.gold

            if v237 then
                gold.Text = tostring(v237.gold or 0) or "-"
            else
                gold.Text = "-"
            end

            local silver = v236.silver

            if v237 then
                silver.Text = tostring(v237.silver or 0) or "-"
            else
                silver.Text = "-"
            end

            local bronze = v236.bronze

            if v237 then
                bronze.Text = tostring(v237.bronze or 0) or "-"
            else
                bronze.Text = "-"
            end

            local best = v236.best

            if v237 then
                local best2 = v237.best
                local v241 = "-:--.---"

                if typeof(best2) == "number" then
                    if best2 <= 0 then
                        v241 = "-:--.---"
                    else
                        local v243 = math.floor(best2 * 1000 + 0.5)

                        v241 = string.format("%d:%02d.%03d", math.floor(v243 / 60000), math.floor(v243 / 1000) % 60, v243 % 1000)
                    end
                end

                best.Text = v241 or "-"
            else
                best.Text = "-"
            end

            v236.laps.Text = v237 and NumberFormat.Short(v237.laps or 0):upper() or "-"

            local play = v236.play

            if v237 then
                local seconds = v237.seconds
                local v247 = typeof(seconds) == "number" and math.floor(seconds) or 0
                local v249 = math.floor(v247 / 3600)
                local v251 = math.floor(v247 % 3600 / 60)

                play.Text = (if v249 > 0 then v249 .. "H " .. v251 .. "M" else v251 .. "M") or "-"
                continue
            end

            play.Text = "-"
        end

        if p61 then
            return
        end

        fit()
        ScrollingFrame.CanvasPosition = Vector2.zero
        n5 = 0
        v156 = false
        v61()

        if not ScreenGui.Enabled then
            for _, child in p4:GetChildren() do
                hideGui(child)
            end

            v215 = v215 or p4.ChildAdded:Connect(hideGui)

            local CurrentCamera = workspace.CurrentCamera

            if not (BlurEffect and BlurEffect.Parent) then
                BlurEffect = Instance.new("BlurEffect")
                BlurEffect.Name = "ProfileBlur"
                BlurEffect.Size = 0
                BlurEffect.Parent = CurrentCamera
            end

            TweenService:Create(BlurEffect, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = t1.BlurSize
            }):Play()

            local JerezRaceHUD = p4:FindFirstChild("JerezRaceHUD")

            if JerezRaceHUD then
                JerezRaceHUD:SetAttribute("ProfileOpen", true)
            end
        end

        ScreenGui.Enabled = true
        task.defer(function() -- line: 567
            -- upvalues: frameBike (copy), updateThumb (copy)
            frameBike()
            updateThumb()
        end)
    end

    function t4.Close() -- line: 570
        -- upvalues: p4 (copy), ScreenGui (copy), v61 (copy), userId (ref), t23 (copy), restoreGuis (copy), BlurEffect (ref), TweenService (copy)
        local Enabled = ScreenGui.Enabled

        ScreenGui.Enabled = false
        userId = nil
        v61()

        if not (Enabled or next(t23)) then
            return
        end

        restoreGuis()

        if BlurEffect then
            local BlurEffect2 = BlurEffect

            BlurEffect = nil

            local tween = TweenService:Create(BlurEffect2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = 0
            })

            tween.Completed:Connect(function() -- line: 529
                -- upvalues: BlurEffect2 (copy)
                BlurEffect2:Destroy()
            end)
            tween:Play()
        end

        local JerezRaceHUD = p4:FindFirstChild("JerezRaceHUD")

        if JerezRaceHUD then
            JerezRaceHUD:SetAttribute("ProfileOpen", false)
        end
    end

    function t4.IsOpen() -- line: 575
        -- upvalues: ScreenGui (copy)
        return ScreenGui.Enabled
    end

    function t4.UserId() -- line: 576
        -- upvalues: userId (ref)
        return userId
    end

    TextButton.Activated:Connect(function() -- line: 577
        -- upvalues: t4 (copy)
        t4.Close()
    end)
    UserInputService.InputBegan:Connect(function(p62) -- line: 578
        -- upvalues: t4 (copy), ScreenGui (copy)
        if ScreenGui.Enabled and p62.KeyCode == Enum.KeyCode.ButtonB then
            t4.Close()
        end
    end)
    t4.Gui = ScreenGui
    fit()

    return t4
end

return t1
