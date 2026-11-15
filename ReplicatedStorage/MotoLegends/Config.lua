-- https://lua.expert

local t1 = {
    Bike = "Ducati",
    StudMetres = 0.28,
    WorldGravity = 196.2,
    Gravity = 35.035714285714285,
    VisualScale = 1.07,
    OfftrackDrag = {
        Grass = 0.16,
        Gravel = 0.24
    },
    SkidSound = "rbxassetid://73429750798250",
    SkidMarkSeconds = 50,
    LapReward = 1000,
    PassiveReward = 250,
    PassiveRewardSeconds = 60,
    AFKReward = 500,
    CrashTVCameraDelay = 1.25,
    CrashTVCameraPanResponse = 2.2,
    CrashTVCameraMinFov = 12,
    ChaseFOVFromKph = 48,
    ChaseFOVFullKph = 300,
    ChaseBaseFOV = 58,
    ChaseSpeedFOV = 24,
    FirstPersonFOVScale = 0.85,
    CameraSway = 2.4,
    ChaseDistance = 12.6,
    ChaseSpeedDistance = 3,
    ChaseCameraPitch = 0.16580627893946132,
    ChaseFOVKeepSize = 0,
    ChasePitchSlowDeg = 3,
    ChasePitchFastDeg = 2,
    ChasePitchFullKph = 300,
    ChaseBrakeTiltDeg = 1.5,
    ChaseBrakeTiltIn = 2.5,
    ChaseBrakeTiltOut = 1.5,
    ChaseMaxZoom = 1.3,
    ChaseMinZoom = 0.95,
    ChaseZoomStep = 0.05,
    HighChasePitchDeg = 6,
    HighChaseDistanceScale = 1.2,
    ChaseShakeFromKph = 300,
    ChaseShakeFullKph = 408,
    ChaseShakeDegrees = 0.35,
    ChaseShakeFrequency = 11,
    CrashRecoverySeconds = 2.5,
    StartLightSeconds = 5,
    StartCooldownSeconds = 10,
    MinLapSeconds = 12,
    Grid = {},
    Gates = {},
    DisplayKphScale = 0.8333333333333334,
    MusicIds = {},
    RecoveryMinYawDeg = 8,
    RecoveryMaxYawDeg = 25,
    RecoveryAsphaltLook = 22,
    Championship = {
        GridForceSeconds = 15,
        MarshalClearSeconds = 8,
        SlowRetireKph = 10,
        SlowRetireSeconds = 30,
        MinPlayers = 6,
        MaxRiders = 22,
        QualifyingSeconds = 600,
        QualifyingFinishSeconds = 90,
        ResultsSeconds = 10,
        GridSeconds = 20,
        LightSeconds = 5,
        LightHoldMin = 1,
        LightHoldMax = 2.5,
        RaceLaps = 3,
        DynamicRaceLaps = 5,
        FinishSeconds = 90,
        RaceSafetySeconds = 1800,
        WarningCooldown = 3,
        UnservedLongLapSeconds = 10,
        WeatherRewardMultiplier = {
            Sunny = 1,
            Cloudy = 1.2,
            Rainy = 1.5,
            Dynamic = 1.8
        },
        Rewards = {
            30000, 20000, 10000, 5000, 4000, 3000, 2000, 1000,
            500, 250
        },
        Points = {
            12, 9, 7, 6, 5, 4, 3, 2,
            1
        }
    }
}
local Track = workspace:GetAttribute("Track")
local elapsed = os.clock()

while typeof(Track) ~= "string" and os.clock() - elapsed < 10 do
    task.wait()
    Track = workspace:GetAttribute("Track")
end

assert(typeof(Track) == "string" and Track ~= "", "Set atribut string 'Track' di Workspace (mis. Jerez / Lusail)")
t1.Track = Track

local Parent = script.Parent

for v2, v3 in require(Parent:WaitForChild("Bikes"):WaitForChild(t1.Bike):WaitForChild("Config")) do
    t1[v2] = v3
end

t1.KerbEdgeLeanDry = 55
t1.KerbEdgeLeanWet = 50
require(Parent:WaitForChild("Tracks"):WaitForChild(t1.Track):WaitForChild("Config"))(t1)

return t1
