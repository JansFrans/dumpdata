-- https://lua.expert

return {
    StudMetres = 0.23333333333333336,
    Gravity = 9.81,
    ChassisCentre = Vector3.new(0, 2.35, -0.3),
    Mass = 1865,
    CdA = 0.76,
    ClA = 0.14,
    DownforceFront = 0.45,
    AirDensity = 1.225,
    BumpTravel = 0.09,
    DroopTravel = 0.11,
    SpringFront = 46000,
    SpringRear = 50000,
    DampBump = 0.32,
    DampRebound = 0.5,
    AntiRollFront = 22000,
    AntiRollRear = 11000,
    BumpStopRange = 0.025,
    BumpStopRate = 5,
    MaxWheelLoad = 4,
    SoftStart = 0.5,
    Grip = 1.18,
    RearGrip = 1.05,
    SlipPeakFront = 0.14835298641951802,
    SlipPeakRear = 0.10471975511965978,
    LoadSensitivity = 0.15,
    SlideGrip = 0.85,
    SlideFalloffDeg = 22,
    SpinGrip = 0.82,
    RollingResistance = 0.013,
    RainGrip = 0.72,
    LooseRainGrip = 0.8,
    Surfaces = {
        Asphalt = {
            grip = 1,
            drag = 0
        },
        Kerb = {
            grip = 0.95,
            drag = 0
        },
        Grass = {
            grip = 0.62,
            drag = 0.06
        },
        Gravel = {
            grip = 0.5,
            drag = 0.22
        },
        Sand = {
            grip = 0.6,
            drag = 0.08
        }
    },
    MaterialSurface = {
        Grass = "Grass",
        LeafyGrass = "Grass",
        Ground = "Grass",
        Mud = "Grass",
        Sand = "Gravel",
        Pebble = "Gravel",
        Rock = "Gravel",
        Snow = "Gravel",
        Glacier = "Gravel",
        Ice = "Gravel"
    },
    IdleRPM = 750,
    RedlineRPM = 7200,
    LaunchRPM = 3000,
    TorqueCurve = {
        { 750, 380 },
        { 1500, 560 },
        { 1800, 750 },
        { 5600, 750 },
        { 6000, 705 },
        { 6700, 630 },
        { 7200, 560 }
    },
    EngineBrake = 110,
    Efficiency = 0.86,
    TopSpeedKph = 305,
    PitLimitKph = 60,
    Gears = { 5, 3.2, 2.143, 1.72, 1.314, 1, 0.822, 0.64 },
    ReverseGear = 3.456,
    FinalDrive = 3.154,
    FrontTorqueShare = 0.32,
    ShiftTime = 0.12,
    UpshiftRPM = 6900,
    UpshiftRPMLight = 2700,
    DownshiftRPM = 1500,
    KickdownRPM = 5300,
    ManualHold = 2,
    ReverseEngageDelay = 0.25,
    BrakeG = 1.3,
    BrakeBias = 0.64,
    HandbrakeG = 0.9,
    HandbrakeOnRate = 7,
    HandbrakeOffRate = 6,
    HandbrakeSideGrip = 0.55,
    HandbrakeSteerRef = 22,
    LockRiseRate = 80,
    ABS = true,
    ABSMinShare = 0.35,
    MaxSteerDeg = 34,
    SteerGrip = 1,
    SteerSlipDeg = 3,
    MinSteerDeg = 3,
    KeySteerRate = 4.2,
    KeyReturnRate = 7,
    PadSteerResponse = 16,
    ESC = true,
    ESCMargin = 0.12,
    ESCGrip = 1.05,
    ESCGain = 6,
    TCS = true,
    Cameras = {
        {
            name = "Chase",
            distance = 27,
            height = 8,
            look = 3.2,
            fov = 70
        },
        {
            name = "Far chase",
            distance = 38,
            height = 12.5,
            look = 3.2,
            fov = 68
        },
        {
            name = "Cockpit",
            fov = 80
        },
        {
            name = "Bonnet",
            offset = Vector3.new(0, 5.15, -4.9),
            fov = 76
        },
        {
            name = "Bumper",
            offset = Vector3.new(0, 1.95, -10.45),
            fov = 82
        }
    },
    SpeedFOV = 12,
    SpeedFOVKph = 260,
    DriverEye = Vector3.new(-1.75, 5.05, 1.05),
    PassengerEye = Vector3.new(1.75, 5.05, 1.05),
    MaxCars = 1e999,
    DriverAccess = "Owner",
    IdleDespawnSeconds = 600,
    ExitDistance = 6.2,
    TelemetryRate = 15,
    EnginePitchIdle = 0.62,
    EnginePitchRedline = 1.75
}
