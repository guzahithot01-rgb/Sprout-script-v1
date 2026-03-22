-- [[ 🍓 GEMINI SPROUT V4: NO-KEY EDITION 🍓 ]] --
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("GeminiSproutV4") then CoreGui.GeminiSproutV4:Destroy() end

local GeminiGui = Instance.new("ScreenGui", CoreGui)
GeminiGui.Name = "GeminiSproutV4"
GeminiGui.ResetOnSpawn = false

-- [[ 🔑 ฝัง KEY ไว้ที่นี่เลย ไม่ต้องกรอกใหม่ ]] --
local API_KEY = "AIzaSyAylp7XLFej2Z6zK-qAMMPwiyHVMceGtRE"

-- [[ 🌍 LANGUAGE SYSTEM ]] --
local Languages = {
    TH = {
        title = "🍓 gemini sprout 🍓",
        placeholder = "คุยกับ Sprout หรือถามอะไรก็ได้...",
        instruction = "คุณคือ Sprout ผู้ช่วยสตรอว์เบอร์รี ตอบเป็นภาษาไทยน่ารักๆ",
        hello = "สวัสดีจ้า! Sprout พร้อมคุยเป็นภาษาไทยแล้วนะ!",
        error = "มึนหัวจัง... (เช็ค API Key ในโค้ดนะ!)"
    },
    EN = {
        title = "🍓 gemini sprout 🍓",
        placeholder = "Talk to Sprout or ask a question...",
        instruction = "You are Sprout, a cute strawberry assistant. Answer in English.",
        hello = "Hello! I'm Gemini Sprout, your strawberry assistant. Ready to chat!",
        error = "Sprout gets a headache... (Check API Key in Code!)"
    }
}

local L = Languages["EN"] -- เริ่มต้นที่ภาษาอังกฤษ

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
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
Instance.new("UIStroke", Main, {Color = Theme.Main, Thickness = 2})

-- Bar ด้านบน
local Bar = Instance.new("Frame", Main)
Bar.Size = UDim2.new(1, 0, 0, 50)
Bar.BackgroundTransparency = 1

local BTitle = Instance.new("TextLabel", Bar)
BTitle.Size = UDim2.new(0, 200, 1, 0)
BTitle.Position = UDim2.new(0, 15, 0, 0)
BTitle.Text = L.title
BTitle.TextColor3 = Theme.White
BTitle.Font = "GothamBold"
BTitle.TextSize = 18
BTitle.TextXAlignment = "Left"
BTitle.BackgroundTransparency = 1

-- [[ 🌐 BUTTONS: THAILAND & ENGLISH ]] --
local LangContainer = Instance.new("Frame", Main)
LangContainer.Size = UDim2.new(1, -20, 0, 45)
LangContainer.Position = UDim2.new(0, 10, 0, 55)
LangContainer.BackgroundTransparency = 1

local BtnTH = Instance.new("TextButton", LangContainer)
BtnTH.Size = UDim2.new(0.48, 0, 1, 0)
BtnTH.BackgroundColor3 = Theme.Gray
BtnTH.Text = "Thailand"
BtnTH.TextColor3 = Theme.White
BtnTH.Font = "GothamBold"
BtnTH.TextSize = 16
Instance.new("UICorner", BtnTH)

local BtnEN = Instance.new("TextButton", LangContainer)
BtnEN.Size = UDim2.new(0.48, 0, 1, 0)
BtnEN.Position = UDim2.new(0.52, 0, 0, 0)
BtnEN.BackgroundColor3 = Theme.Main
BtnEN.Text = "English"
BtnEN.TextColor3 = Theme.White
BtnEN.Font = "GothamBold"
BtnEN.TextSize = 16
Instance.new("UICorner", BtnEN)

-- พื้นที่แชท
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -180)
Scroll.Position = UDim2.new(0, 10, 0, 110)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0,10)

-- ช่องพิมพ์และปุ่มส่ง
local InBox = Instance.new("TextBox", Main)
InBox.Size = UDim2.new(1, -70, 0, 40)
InBox.Position = UDim2.new(0, 15, 1, -55)
InBox.PlaceholderText = L.placeholder
InBox.BackgroundColor3 = Theme.Gray
InBox.TextColor3 = Theme.White
InBox.Text = ""
Instance.new("UICorner", InBox)

local Send = Instance.new("TextButton", Main)
Send.Size = UDim2.new(0, 45, 0, 40)
Send.Position = UDim2.new(1, -55, 1, -55)
Send.Text = "🍓"
Send.BackgroundColor3 = Theme.Accent
Instance.new("UICorner", Send)

-- [[ 🧠 AI LOGIC ]] --
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
        if decoded.candidates and decoded.candidates[1] and decoded.candidates[1].content then
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
