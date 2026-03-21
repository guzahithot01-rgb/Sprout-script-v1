
-- [[ 🍓 sprout script [ THE ULTIMATE UPDATE ] 🍓 ]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MiniBtn = Instance.new("TextButton")
local ContentFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Setup UI
ScreenGui.Name = "SproutScriptUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (Pink Style)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 192, 203)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.4, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Title
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.FredokaOne
Title.Text = "sprout script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

-- Buttons
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 30, 0, 35)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.FredokaOne

MiniBtn.Parent = MainFrame
MiniBtn.BackgroundTransparency = 1
MiniBtn.Position = UDim2.new(0.7, 0, 0, 0)
MiniBtn.Size = UDim2.new(0, 30, 0, 35)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.FredokaOne

-- Scrolling Content
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 5, 0, 45)
ContentFrame.Size = UDim2.new(1, -10, 1, -55)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 1100) -- Increased Canvas for more buttons
ContentFrame.ScrollBarThickness = 3
UIListLayout.Parent = ContentFrame
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [[ 💨 Speed System & Slider FIX ]]
local currentSpeedValue = 50
local isSpeedEnabled = false

local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(0.9, 0, 0, 45)
SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderFrame.Parent = ContentFrame
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Speed: " .. currentSpeedValue
SliderLabel.TextColor3 = Color3.fromRGB(255, 20, 147)
SliderLabel.Font = Enum.Font.SourceSansBold
SliderLabel.Parent = SliderFrame

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(0.8, 0, 0, 4)
Bar.Position = UDim2.new(0.1, 0, 0.7, 0)
Bar.BackgroundColor3 = Color3.fromRGB(255, 192, 203)
Bar.Parent = SliderFrame

local Dot = Instance.new("TextButton")
Dot.Size = UDim2.new(0, 14, 0, 14)
Dot.Position = UDim2.new(0.25, -7, -1.2, 0)
Dot.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
Dot.Text = ""
Dot.Parent = Bar
Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

local SpeedToggle = Instance.new("Frame")
SpeedToggle.Size = UDim2.new(0, 50, 0, 50)
SpeedToggle.Position = UDim2.new(0, 10, 0.5, 0)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
SpeedToggle.Visible = false
SpeedToggle.Draggable = true
SpeedToggle.Active = true
SpeedToggle.Parent = ScreenGui
Instance.new("UICorner", SpeedToggle).CornerRadius = UDim.new(1, 0)

local SBtn = Instance.new("TextButton")
SBtn.Size = UDim2.new(1, 0, 1, 0)
SBtn.BackgroundTransparency = 1
SBtn.Text = "💨"
SBtn.TextSize = 25
SBtn.Parent = SpeedToggle

SBtn.MouseButton1Click:Connect(function()
    isSpeedEnabled = not isSpeedEnabled
    if isSpeedEnabled then
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    else
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
    end
end)

local dragging = false
Dot.MouseButton1Down:Connect(function() dragging = true end)
game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

game:GetService("RunService").RenderStepped:Connect(function()
    if dragging then
        local mousePos = game:GetService("UserInputService"):GetMouseLocation().X
        local relative = math.clamp((mousePos - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Dot.Position = UDim2.new(relative, -7, -1.2, 0)
        currentSpeedValue = math.floor(relative * 200)
        SliderLabel.Text = "Speed: " .. currentSpeedValue
    end
    pcall(function()
        local hum = game.Players.LocalPlayer.Character.Humanoid
        if isSpeedEnabled then hum.WalkSpeed = currentSpeedValue end
    end)
end)

-- [[ Feature Function ]]
local function CreateFeature(name, tutorialText, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 35)
    Container.BackgroundTransparency = 1
    Container.Parent = ContentFrame

    local MainBtn = Instance.new("TextButton")
    MainBtn.Size = UDim2.new(0.85, 0, 0, 35)
    MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Text = name
    MainBtn.TextColor3 = Color3.fromRGB(255, 20, 147)
    MainBtn.Font = Enum.Font.SourceSansBold
    MainBtn.Parent = Container
    Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 8)

    local InfoBtn = Instance.new("TextButton")
    InfoBtn.Size = UDim2.new(0.12, 0, 0, 35)
    InfoBtn.Position = UDim2.new(0.88, 0, 0, 0)
    InfoBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    InfoBtn.Text = "▼"
    InfoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoBtn.Parent = Container
    Instance.new("UICorner", InfoBtn).CornerRadius = UDim.new(0, 8)

    local DescFrame = Instance.new("Frame")
    DescFrame.Size = UDim2.new(1, 0, 0, 0)
    DescFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
    DescFrame.ClipsDescendants = true
    DescFrame.Parent = ContentFrame
    Instance.new("UICorner", DescFrame).CornerRadius = UDim.new(0, 5)

    local DescText = Instance.new("TextLabel")
    DescText.Size = UDim2.new(1, -14, 1, -10)
    DescText.Position = UDim2.new(0, 7, 0, 5)
    DescText.BackgroundTransparency = 1
    DescText.Text = tutorialText
    DescText.TextColor3 = Color3.fromRGB(150, 50, 100)
    DescText.TextWrapped = true
    DescText.Font = Enum.Font.SourceSansItalic
    DescText.TextSize = 13
    DescText.TextXAlignment = Enum.TextXAlignment.Left
    DescText.Parent = DescFrame

    local isOpen = false
    InfoBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        DescFrame:TweenSize(isOpen and UDim2.new(1, 0, 0, 85) or UDim2.new(1, 0, 0, 0), "Out", "Quint", 0.3, true)
        InfoBtn.Text = isOpen and "▲" or "▼"
    end)
    MainBtn.MouseButton1Click:Connect(callback)
end

-- [[ Original Features ]]
CreateFeature("speed", "How to use 'speed':\nAdjust the speed to whatever you want and press use it", function()
    SpeedToggle.Visible = not SpeedToggle.Visible
end)

CreateFeature("Tp to generator", "How to use 'Tp to generator':\nClick it and it will teleport you to generator", function()
    pcall(function()
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        for _, v in pairs(workspace.CurrentRoom:GetDescendants()) do
            if v.Name == "Generator" and v:IsA("Model") then
                local target = v:FindFirstChildWhichIsA("BasePart") or v.PrimaryPart
                if hrp and target then hrp.CFrame = target.CFrame + Vector3.new(0, 5, 0) break end
            end
        end
    end)
end)

-- [[ NEW REQUESTED FEATURES ]]

CreateFeature("Noob killer", "How to use 'Noob killer':\nClick it, and noob will kill you", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Dandy's-World-ALPHA-Twisted-Noob-127837"))()
end)

CreateFeature("gobbydwscript", "How to use 'gobbydwscript':\nClick it, and it will have tap for setting you can use it for fly,speedhack,noclip and others!", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Dandy's-World-ALPHA-G0bbyD0llan-DW-Reupload-34146"))()
end)

CreateFeature("angel script", "How to use 'angel script':\nClick it, and it will show tap that have tp,speedhack,esp and others!", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Dandy's-World-ALPHA-Angel-Core-115426"))()
end)

CreateFeature("boxten s#x gui", "How to use 'boxten s#x gui'\nClick it, and it will loading tap That have autofarm,walktp, autoskillcheck this script is so good", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Dandy's-World-ALPHA-Dandys-World-50352"))()
end)

-- [[ Extra Features ]]
CreateFeature("Autofarm and skillcheck", "How to use 'Autofarm and skillcheck':\nClick it, and it will do auto skillcheck and click 'start' for autofarm click 'stop' when you need to stop it", function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/49070d904c420087ca216a958ed26cca.lua"))()
end)

CreateFeature("noclip and esp", "How to use 'noclip and esp':\nClick it, and it will show the esp the noclip you can off and on it", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EarthC123/FjoneScript/refs/heads/main/myscript.lua"))()
end)

-- Resize, Minimize, Close logic
local ResizeBtn = Instance.new("TextButton")
ResizeBtn.Parent = MainFrame
ResizeBtn.Size = UDim2.new(0, 20, 0, 20)
ResizeBtn.Position = UDim2.new(1, -20, 1, -20)
ResizeBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
ResizeBtn.Text = "◢"
ResizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ResizeBtn).CornerRadius = UDim.new(0, 5)

local resizing = false
ResizeBtn.MouseButton1Down:Connect(function() resizing = true end)
game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then resizing = false end end)
game:GetService("RunService").RenderStepped:Connect(function()
    if resizing then
        local mPos = game:GetService("UserInputService"):GetMouseLocation()
        local fPos = MainFrame.AbsolutePosition
        MainFrame.Size = UDim2.new(0, math.clamp(mPos.X - fPos.X, 180, 600), 0, math.clamp(mPos.Y - fPos.Y, 150, 800))
    end
end)

local minimized = false
MiniBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ContentFrame.Visible = not minimized
    ResizeBtn.Visible = not minimized
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 35) or UDim2.new(0, 250, 0, 400), "Out", "Quint", 0.3, true)
    MiniBtn.Text = minimized and "+" or "-"
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
