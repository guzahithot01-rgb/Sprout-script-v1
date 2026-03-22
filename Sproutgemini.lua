-- [[ 🍓 GEMINI SPROUT V5: CONTROL EDITION 🍓 ]] --
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("GeminiSproutV5") then CoreGui.GeminiSproutV5:Destroy() end

local GeminiGui = Instance.new("ScreenGui", CoreGui)
GeminiGui.Name = "GeminiSproutV5"
GeminiGui.ResetOnSpawn = false

local API_KEY = "AIzaSyAylp7XLFej2Z6zK-qAMMPwiyHVMceGtRE"

local Languages = {
    TH = {
        title = "🍓 gemini sprout 🍓",
        placeholder = "คุยกับ Sprout หรือถามอะไรก็ได้...",
        instruction = "คุณคือ Sprout ผู้ช่วยสตรอว์เบอร์รี ตอบเป็นภาษาไทยน่ารักๆ",
        hello = "สวัสดีจ้า! Sprout พร้อมคุยเป็นภาษาไทยแล้วนะ!",
        error = "มึนหัวจัง... (เช็ค Error ด้านล่างนะ)"
    },
    EN = {
        title = "🍓 gemini sprout 🍓",
        placeholder = "Talk to Sprout or ask a question...",
        instruction = "You are Sprout, a cute strawberry assistant. Answer in English.",
        hello = "Hello! I'm Gemini Sprout, your strawberry assistant. Ready to chat!",
        error = "Sprout gets a headache... (Check Error below)"
    }
}

local L = Languages["EN"]

-- [[ 🎨 UI DESIGN ]] --
local Theme = {
    BG = Color3.fromRGB(25, 25, 25),
    Main = Color3.fromRGB(255, 120, 180),
    Accent = Color3.fromRGB(255, 20, 147),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(50, 50, 50)
}

local Main = Instance.new("Frame", GeminiGui)
Main.Size = UDim2.new(0, 360, 0, 480)
Main.Position = UDim2.new(0.5, -180, 0.5, -240)
Main.BackgroundColor3 = Theme.BG
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
Instance.new("UIStroke", Main, {Color = Theme.Main, Thickness = 2})

-- [[ 🛠️ BAR & WINDOW CONTROLS ]] --
local Bar = Instance.new("Frame", Main)
Bar.Size = UDim2.new(1, 0, 0, 50)
Bar.BackgroundTransparency = 1

local BTitle = Instance.new("TextLabel", Bar)
BTitle.Size = UDim2.new(0, 180, 1, 0)
BTitle.Position = UDim2.new(0, 15, 0, 0)
BTitle.Text = L.title
BTitle.TextColor3 = Theme.White
BTitle.Font = "GothamBold"
BTitle.TextSize = 18
BTitle.TextXAlignment = "Left"
BTitle.BackgroundTransparency = 1

-- ปุ่มควบคุม (Minimize / Close)
local Controls = Instance.new("Frame", Bar)
Controls.Size = UDim2.new(0, 100, 1, 0)
Controls.Position = UDim2.new(1, -110, 0, 0)
Controls.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Controls)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.White
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", CloseBtn)

local MiniBtn = Instance.new("TextButton", Controls)
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -70, 0.5, -15)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Theme.White
MiniBtn.BackgroundColor3 = Theme.Gray
Instance.new("UICorner", MiniBtn)

-- ปุ่มขยาย (จะโผล่มาตอนย่อ)
local MaxBtn = Instance.new("TextButton", GeminiGui)
MaxBtn.Size = UDim2.new(0, 50, 0, 50)
MaxBtn.Position = UDim2.new(0, 20, 1, -70)
MaxBtn.Text = "🍓"
MaxBtn.TextSize = 25
MaxBtn.BackgroundColor3 = Theme.Main
MaxBtn.Visible = false
Instance.new("UICorner", MaxBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", MaxBtn, {Color = Theme.White, Thickness = 2})

-- [[ 🌐 LANGUAGE BUTTONS ]] --
local Body = Instance.new("Frame", Main)
Body.Size = UDim2.new(1, 0, 1, -50)
Body.Position = UDim2.new(0, 0, 0, 50)
Body.BackgroundTransparency = 1

local LangContainer = Instance.new("Frame", Body)
LangContainer.Size = UDim2.new(1, -20, 0, 45)
LangContainer.Position = UDim2.new(0, 10, 0, 5)
LangContainer.BackgroundTransparency = 1

local BtnTH = Instance.new("TextButton", LangContainer)
BtnTH.Size = UDim2.new(0.48, 0, 1, 0)
BtnTH.BackgroundColor3 = Theme.Gray
BtnTH.Text = "Thailand"
BtnTH.TextColor3 = Theme.White
BtnTH.Font = "GothamBold"
Instance.new("UICorner", BtnTH)

local BtnEN = Instance.new("TextButton", LangContainer)
BtnEN.Size = UDim2.new(0.48, 0, 1, 0)
BtnEN.Position = UDim2.new(0.52, 0, 0, 0)
BtnEN.BackgroundColor3 = Theme.Main
BtnEN.Text = "English"
BtnEN.TextColor3 = Theme.White
BtnEN.Font = "GothamBold"
Instance.new("UICorner", BtnEN)

-- แชทและช่องพิมพ์
local Scroll = Instance.new("ScrollingFrame", Body)
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0,10)

local InBox = Instance.new("TextBox", Body)
InBox.Size = UDim2.new(1, -70, 0, 40)
InBox.Position = UDim2.new(0, 15, 1, -50)
InBox.PlaceholderText = L.placeholder
InBox.BackgroundColor3 = Theme.Gray
InBox.TextColor3 = Theme.White
InBox.Text = ""
Instance.new("UICorner", InBox)

local Send = Instance.new("TextButton", Body)
Send.Size = UDim2.new(0, 45, 0, 40)
Send.Position = UDim2.new(1, -55, 1, -50)
Send.Text = "🍓"
Send.BackgroundColor3 = Theme.Accent
Instance.new("UICorner", Send)

-- [[ 🧠 LOGIC: CONTROLS & AI ]] --
CloseBtn.MouseButton1Click:Connect(function() GeminiGui:Destroy() end)

MiniBtn.MouseButton1Click:Connect(function()
    Main:TweenPosition(UDim2.new(0.5, -180, 1, 50), "Out", "Quad", 0.5, true)
    task.wait(0.5)
    Main.Visible = false
    MaxBtn.Visible = true
end)

MaxBtn.MouseButton1Click:Connect(function()
    MaxBtn.Visible = false
    Main.Visible = true
    Main:TweenPosition(UDim2.new(0.5, -180, 0.5, -240), "Out", "Back", 0.5, true)
end)

local function AddMsg(sender, msg)
    local l = Instance.new("TextLabel", Scroll)
    l.Size = UDim2.new(1, 0, 0, 30)
    l.BackgroundTransparency = 1
    l.Text = "<b>" .. (sender == "You" and "You: " or "🍓 Sprout: ") .. "</b>" .. msg
    l.RichText = true
    l.TextColor3 = (sender == "You" and Theme.Main or Theme.White)
    l.Font = "Gotham"
    l.TextSize = 14
    l.TextWrapped = true
    l.TextXAlignment = (sender == "You" and "Right" or "Left")
    local txtSize = game:GetService("TextService"):GetTextSize(l.Text, l.TextSize, l.Font, Vector2.new(Scroll.AbsoluteSize.X, 1000))
    l.Size = UDim2.new(1, 0, 0, txtSize.Y + 5)
    Scroll.CanvasPosition = Vector2.new(0, 9999)
end

local function GetAI(prompt)
    local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" .. API_KEY
    local data = { contents = {{ parts = {{ text = L.instruction .. "\n" .. prompt }} }} }
    local success, response = pcall(function()
        return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
    if success then
        local decoded = HttpService:JSONDecode(response)
        if decoded.candidates and decoded.candidates[1] then
            return decoded.candidates[1].content.parts[1].text
        elseif decoded.error then
            return "Google Error: " .. tostring(decoded.error.message)
        end
    end
    return L.error
end

BtnTH.MouseButton1Click:Connect(function()
    L = Languages["TH"]
    BtnTH.BackgroundColor3 = Theme.Main
    BtnEN.BackgroundColor3 = Theme.Gray
    BTitle.Text = L.title
    InBox.PlaceholderText = L.placeholder
    AddMsg("Sprout", L.hello)
end)

BtnEN.MouseButton1Click:Connect(function()
    L = Languages["EN"]
    BtnEN.BackgroundColor3 = Theme.Main
    BtnTH.BackgroundColor3 = Theme.Gray
    BTitle.Text = L.title
    InBox.PlaceholderText = L.placeholder
    AddMsg("Sprout", L.hello)
end)

Send.MouseButton1Click:Connect(function()
    local t = InBox.Text
    if t ~= "" then
        InBox.Text = ""
        AddMsg("You", t)
        task.spawn(function() AddMsg("Sprout", GetAI(t)) end)
    end
end)

AddMsg("Sprout", L.hello)
