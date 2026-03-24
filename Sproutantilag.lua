-- =========================================================================================================
-- [SCRIPT NAME] - ห้ามเปลี่ยนชื่อเด็ดขาด
-- 🍓Sprout script anti-lag🍓 (ULTRA VERSION)
-- =========================================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local SCRIPT_NAME = "🍓Sprout script anti-lag🍓"

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- =========================================================================================================
-- [Ultra Anti-Lag Engine] - เพิ่มระบบลบสิ่งของไม่จำเป็น
-- =========================================================================================================

local antiLagEnabled = false
local handledObjects = {}
local originalSettings = {}

-- ฟังก์ชันลบพวกสิ่งของจุกจิก (Decoration/Non-essential)
local function cleanUnnecessaryObjects()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = not antiLagEnabled
        elseif v:IsA("Clouds") then
            v.Enabled = not antiLagEnabled
        end
    end
    -- ปิดหญ้า (Grass)
    sethiddenproperty(workspace.Terrain, "Decoration", not antiLagEnabled)
end

local function applyUltraVisuals(obj, enabled)
    if not obj:IsA("BasePart") or (Player.Character and obj:IsDescendantOf(Player.Character)) then return end

    if enabled then
        if not handledObjects[obj] then
            handledObjects[obj] = {
                Material = obj.Material,
                Color = obj.Color,
                CanCollide = obj.CanCollide
            }
        end
        -- บังคับเป็น Plastic (เบาที่สุดใน engine) และสีเทา
        obj.Material = Enum.Material.Plastic 
        obj.Color = Color3.fromRGB(110, 110, 110)
        
        -- ลบ Texture/Decal ทั้งหมดแบบเด็ดขาด
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("Decal") or child:IsA("Texture") then
                child.Transparency = 1
            end
        end
    else
        local original = handledObjects[obj]
        if original then
            obj.Material = original.Material
            obj.Color = original.Color
            handledObjects[obj] = nil
        end
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("Decal") or child:IsA("Texture") then
                child.Transparency = 0
            end
        end
    end
end

local function setAntiLagState(enabled)
    antiLagEnabled = enabled
    
    -- --- Lighting KILL (ทำให้ลื่นสุดๆ) ---
    pcall(function()
        if enabled then
            originalSettings.GlobalShadows = Lighting.GlobalShadows
            originalSettings.Brightness = Lighting.Brightness
            
            Lighting.GlobalShadows = false
            Lighting.Brightness = 2
            Lighting.FogEnd = 9e9 -- ลบหมอกออกไปให้หมด
            settings().Rendering.QualityLevel = 1 -- บังคับ Low Quality
        else
            Lighting.GlobalShadows = originalSettings.GlobalShadows or true
            Lighting.Brightness = originalSettings.Brightness or 1
            settings().Rendering.QualityLevel = 0 -- Auto
        end
    end)

    -- --- Scan & Apply ---
    for _, obj in ipairs(workspace:GetDescendants()) do
        applyUltraVisuals(obj, enabled)
        if obj:IsA("ParticleEmitter") or obj:IsA("Sparkles") or obj:IsA("Smoke") or obj:IsA("Fire") then
            obj.Enabled = not enabled
        end
    end
    
    cleanUnnecessaryObjects()
end

-- =========================================================================================================
-- [GUI Creation] - 🍓 Strawberry Theme 🍓
-- =========================================================================================================

local function createStrawberryGui()
    if CoreGui:FindFirstChild(SCRIPT_NAME) then CoreGui[SCRIPT_NAME]:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = SCRIPT_NAME
    sg.Parent = CoreGui
    
    local STRAWBERRY_RED = Color3.fromRGB(255, 60, 100)
    local STRAWBERRY_PINK = Color3.fromRGB(255, 200, 215)
    local WHITE = Color3.fromRGB(255, 255, 255)

    -- --- DOWNLOAD SCREEN ---
    local dl = Instance.new("Frame", sg)
    dl.Size = UDim2.new(0, 320, 0, 160)
    dl.Position = UDim2.new(0.5, 0, 0.5, 0)
    dl.AnchorPoint = Vector2.new(0.5, 0.5)
    dl.BackgroundColor3 = STRAWBERRY_PINK
    Instance.new("UICorner", dl).CornerRadius = UDim.new(0, 15)

    local dlTitle = Instance.new("TextLabel", dl)
    dlTitle.Text = SCRIPT_NAME
    dlTitle.Size = UDim2.new(1, 0, 0, 50)
    dlTitle.Font = Enum.Font.FredokaOne
    dlTitle.TextColor3 = STRAWBERRY_RED
    dlTitle.TextSize = 22
    dlTitle.BackgroundTransparency = 1

    local dlMsg = Instance.new("TextLabel", dl)
    dlMsg.Text = "🍓 Loading Sprout Ultra Engine... 🍓"
    dlMsg.Position = UDim2.new(0, 0, 0.4, 0)
    dlMsg.Size = UDim2.new(1, 0, 0, 30)
    dlMsg.Font = Enum.Font.GothamBold
    dlMsg.TextColor3 = Color3.fromRGB(80, 80, 80)
    dlMsg.TextSize = 14
    dlMsg.BackgroundTransparency = 1

    local barBg = Instance.new("Frame", dl)
    barBg.Size = UDim2.new(0.8, 0, 0, 10)
    barBg.Position = UDim2.new(0.1, 0, 0.75, 0)
    barBg.BackgroundColor3 = WHITE
    Instance.new("UICorner", barBg)

    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = STRAWBERRY_RED
    Instance.new("UICorner", bar)

    -- --- MAIN SCRIPT UI ---
    local main = Instance.new("Frame", sg)
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 240, 0, 190)
    main.Position = UDim2.new(0, 15, 0.4, 0)
    main.BackgroundColor3 = STRAWBERRY_PINK
    main.Visible = false
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

    local title = Instance.new("TextLabel", main)
    title.Text = SCRIPT_NAME
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Font = Enum.Font.FredokaOne
    title.TextColor3 = STRAWBERRY_RED
    title.TextSize = 18
    title.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", main)
    btn.Text = "✅ Anti-lag: OFF"
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0.25, 0)
    btn.BackgroundColor3 = WHITE
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn)

    local fpsL = Instance.new("TextLabel", main)
    fpsL.Size = UDim2.new(1, 0, 0, 30)
    fpsL.Position = UDim2.new(0, 0, 0.5, 0)
    fpsL.Font = Enum.Font.GothamMedium
    fpsL.BackgroundTransparency = 1
    fpsL.TextSize = 16

    local aiL = Instance.new("TextLabel", main)
    aiL.Size = UDim2.new(0.9, 0, 0, 50)
    aiL.Position = UDim2.new(0.05, 0, 0.65, 0)
    aiL.Font = Enum.Font.GothamMedium
    aiL.BackgroundTransparency = 1
    aiL.TextWrapped = true
    aiL.TextSize = 14
    aiL.TextColor3 = STRAWBERRY_RED

    -- --- Logic ---
    task.spawn(function()
        TweenService:Create(bar, TweenInfo.new(2), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(2)
        dlMsg.Text = "🍓 Welcome! 🍓"
        task.wait(1)
        dl:Destroy()
        main.Visible = true
    end)

    btn.MouseButton1Click:Connect(function()
        antiLagEnabled = not antiLagEnabled
        setAntiLagState(antiLagEnabled)
        btn.Text = antiLagEnabled and "✅ Anti-lag: ON" or "✅ Anti-lag: OFF"
        btn.BackgroundColor3 = antiLagEnabled and STRAWBERRY_RED or WHITE
        btn.TextColor3 = antiLagEnabled and WHITE or Color3.fromRGB(60,60,60)
    end)

    local frameCount = 0
    local lastTime = tick()
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - lastTime >= 1 then
            local fps = math.floor(frameCount / (tick() - lastTime))
            fpsL.Text = "FPS: " .. fps
            
            if fps <= 20 then
                aiL.Text = "Your fps is so low LoL😂😂😂"
            elseif fps <= 30 then
                aiL.Text = "Nice fps but not that good LoL😂😂😂"
            elseif fps >= 60 then
                aiL.Text = "Woahhh This is good fps!"
            end
            
            frameCount = 0
            lastTime = tick()
        end
    end)
end

pcall(createStrawberryGui)
