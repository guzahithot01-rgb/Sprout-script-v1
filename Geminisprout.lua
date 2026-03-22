-- [[ 🍓 GEMINI SPROUT: PUBLIC LOADSTRING EDITION 🍓 ]] --
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("GeminiSproutGui") then CoreGui.GeminiSproutGui:Destroy() end

local GeminiGui = Instance.new("ScreenGui")
GeminiGui.Name = "GeminiSproutGui"
GeminiGui.Parent = CoreGui
GeminiGui.ResetOnSpawn = false

-- [[ 💾 ระบบเซฟ Key ลงเครื่องผู้ใช้ ]] --
local FileName = "SproutKey_Config.txt"
local function SaveKey(k) if writefile then writefile(FileName, k) end end
local function LoadKey() if isfile and isfile(FileName) then return readfile(FileName) end return "" end

local Theme = {
    BG = Color3.fromRGB(255, 240, 245),
    Main = Color3.fromRGB(255, 105, 180),
    Accent = Color3.fromRGB(220, 20, 60),
    White = Color3.fromRGB(255, 255, 255)
}

-- [[ 🛠️ UI: SETUP FRAME ]] --
local Setup = Instance.new("Frame", GeminiGui)
Setup.Size = UDim2.new(0, 300, 0, 180)
Setup.Position = UDim2.new(0.5, -150, 0.5, -90)
Setup.BackgroundColor3 = Theme.BG
Instance.new("UICorner", Setup)

local STitle = Instance.new("TextLabel", Setup)
STitle.Size = UDim2.new(1, 0, 0, 40)
STitle.Text = "🍓 Sprout Setup 🍓"
STitle.TextColor3 = Theme.Main
STitle.Font = Enum.Font.GothamBold
STitle.BackgroundTransparency = 1

local SInput = Instance.new("TextBox", Setup)
SInput.Size = UDim2.new(0, 260, 0, 40)
SInput.Position = UDim2.new(0, 20, 0, 60)
SInput.PlaceholderText = "วาง Gemini API Key ของคุณ..."
SInput.Text = ""
Instance.new("UICorner", SInput)

local SBtn = Instance.new("TextButton", Setup)
SBtn.Size = UDim2.new(0, 120, 0, 40)
SBtn.Position = UDim2.new(0.5, -60, 0, 120)
SBtn.BackgroundColor3 = Theme.Main
SBtn.Text = "เริ่มใช้งาน!"
SBtn.TextColor3 = Theme.White
Instance.new("UICorner", SBtn)

-- [[ 💬 UI: MAIN CHAT FRAME ]] --
local Main = Instance.new("Frame", GeminiGui)
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.5, -200)
Main.BackgroundColor3 = Theme.BG
Main.Visible = false
Instance.new("UICorner", Main)

local Bar = Instance.new("Frame", Main)
Bar.Size = UDim2.new(1, 0, 0, 40)
Bar.BackgroundColor3 = Theme.Main
Instance.new("UICorner", Bar)

local BTitle = Instance.new("TextLabel", Bar)
BTitle.Size = UDim2.new(1, -60, 1, 0)
BTitle.Position = UDim2.new(0, 15, 0, 0)
BTitle.Text = "🍓 gemini sprout 🍓"
BTitle.TextColor3 = Theme.White
BTitle.Font = Enum.Font.GothamBold
BTitle.TextXAlignment = "Left"
BTitle.BackgroundTransparency = 1

local Close = Instance.new("TextButton", Bar)
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -35, 0.5, -12)
Close.Text = "X"
Close.BackgroundColor3 = Theme.Accent
Close.TextColor3 = Theme.White
Instance.new("UICorner", Close, {CornerRadius = UDim.new(1,0)})

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -100)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0,5)

local InBox = Instance.new("TextBox", Main)
InBox.Size = UDim2.new(1, -60, 0, 35)
InBox.Position = UDim2.new(0, 10, 1, -45)
InBox.PlaceholderText = "คุยกับ Sprout..."
Instance.new("UICorner", InBox)

local Send = Instance.new("TextButton", Main)
Send.Size = UDim2.new(0, 40, 0, 35)
Send.Position = UDim2.new(1, -50, 1, -45)
Send.Text = "🍓"
Send.BackgroundColor3 = Theme.Main
Instance.new("UICorner", Send)

-- [[ 🧠 LOGIC ]] --
local API_KEY = LoadKey()

local function AddMsg(s, m)
    local l = Instance.new("TextLabel", Scroll)
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Text = (s == "You" and "🔴: " or "💖: ") .. m
    l.TextColor3 = (s == "You" and Theme.Accent or Theme.Main)
    l.TextWrapped, l.BackgroundTransparency, l.Font, l.TextSize = true, 1, "Gotham", 14
    Scroll.CanvasPosition = Vector2.new(0, 9999)
end

local function GetAI(p)
    local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" .. API_KEY
    local d = {contents={{parts={{text="คุณคือ Sprout ผู้ช่วยธีมสตรอว์เบอร์รี: "..p}}}}}
    local s, r = pcall(function() return HttpService:PostAsync(url, HttpService:JSONEncode(d)) end)
    if s then return HttpService:JSONDecode(r).candidates[1].content.parts[1].text end
    return "มึนหัวจัง..."
end

local function Start(k)
    API_KEY = k
    SaveKey(k)
    Setup.Visible = false
    Main.Visible = true
end

SBtn.MouseButton1Click:Connect(function() if SInput.Text ~= "" then Start(SInput.Text) end end)
Send.MouseButton1Click:Connect(function()
    local t = InBox.Text
    if t ~= "" then
        InBox.Text = ""
        AddMsg("You", t)
        task.spawn(function() AddMsg("Sprout", GetAI(t)) end)
    end
end)
Close.MouseButton1Click:Connect(function() GeminiGui:Destroy() end)

if API_KEY ~= "" then Start(API_KEY) end
