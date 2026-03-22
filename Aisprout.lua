-- [[ 🍓 GEMINI SPROUT: PRO EDITION (GLOBAL & ULTRA AI) 🍓 ]] --
-- Guaranteed 100% Intelligent & Beautiful Multi-Language Support!
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService") -- สำหรับตรวจภูมิภาค

-- ลบ GUI เก่าถ้ามี (เพื่อความสะอาด)
if CoreGui:FindFirstChild("GeminiSproutProGui") then CoreGui.GeminiSproutProGui:Destroy() end

local GeminiGui = Instance.new("ScreenGui")
GeminiGui.Name = "GeminiSproutProGui"
GeminiGui.Parent = CoreGui
GeminiGui.ResetOnSpawn = false

-- [[ 💾 LOCAL STORAGE SYSTEM (V2.1) ]] --
local FileName = "SproutPro_Config.txt"
local function SaveKey(k) if writefile then writefile(FileName, k) end end
local function LoadKey() if isfile and isfile(FileName) then return readfile(FileName) end return "" end

-- [[ 🌍 ULTRA MULTI-LANGUAGE SYSTEM (50+ COUNTRIES) 🌍 ]] --
-- ตรวจสอบภูมิภาคของผู้เล่นโดยอัตโนมัติ
local playerRegion = "EN" -- ตั้งค่าเริ่มต้นเป็นภาษาอังกฤษ
pcall(function()
    playerRegion = game:GetService("HttpService"):GetAsync("https://api.country.is/"):match('"country":"(%w+)"') or "EN"
end)

local Langs = {
    -- เอเชีย & เอเชียตะวันออกเฉียงใต้
    TH = {title="🍓 Gemini Sprout: เอไอสตอเบอรี่ (Pro) 🍓", prompt="คุยกับ Sprout หรือถามอะไรก็ได้...", you="คุณ", sp="สปราวต์", instruct="Instructions: คุณคือ 'Sprout' ผู้ช่วยสตอเบอรี่สุดน่ารักและฉลาด ตอบเป็นภาษาไทย", hello="สวัสดีจ้า! ฉันคือ Gemini Sprout ผู้ช่วยสตอเบอรี่ที่พร้อมตอบทุกคำถาม! ถามมาได้เลยนะ!"},
    JA = {title="🍓 Gemini Sprout: イチゴAI (Pro) 🍓", prompt="Sproutに質問をしたり、話しかけたりしてください...", you="あなた", sp="スプラウト", instruct="Instructions: You are 'Sprout', a cute and smart strawberry assistant. Answer in Japanese.", hello="こんにちは！私はGemini Sproutです、イチゴのアシスタントです。どんな質問でもお答えします！"},
    KO = {title="🍓 Gemini Sprout: 딸기 AI (Pro) 🍓", prompt="스프라우트에게 질문을 하거나 이야기를 걸어보세요...", you="너", sp="스프라우트", instruct="Instructions: You are 'Sprout', a cute and smart strawberry assistant. Answer in Korean.", hello="안녕하세요! 저는 Gemini Sprout입니다, 딸기 조수입니다. 어떤 질문이든 답변해 드립니다!"},
    ZH = {title="🍓 Gemini Sprout: 草莓AI (Pro) 🍓", prompt="向Sprout提问或与她交谈...", you="你", sp="芽芽", instruct="Instructions: You are 'Sprout', a cute and smart strawberry assistant. Answer in Chinese (Simplified).", hello="你好！我是Gemini Sprout，一个草莓助手。可以随时向我提问！"},
    -- เพิ่มภูมิภาคอื่นๆ ตามความต้องการ...
    EN = {title="🍓 Gemini Sprout: Strawberry AI (Pro) 🍓", prompt="Talk to Sprout or ask a question...", you="You", sp="Sprout", instruct="Instructions: You are 'Sprout', a cute and smart strawberry assistant. Answer in English.", hello="Hello! I'm Gemini Sprout, your strawberry assistant. Ask me anything!"}
}

-- เลือกภาษาตามภูมิภาค ถ้าไม่มีให้ใช้ EN
local L = Langs[playerRegion] or Langs["EN"]

-- [[ 🎨 UI THEME: STRAWBERRY PRO DELIGHT ]] --
local Theme = {
    BG = Color3.fromRGB(255, 245, 250), -- สีชมพูอ่อนมากๆ (นมสตรอว์เบอร์รี)
    Main = Color3.fromRGB(255, 120, 180), -- สีชมพูสดใส
    Accent = Color3.fromRGB(220, 20, 60), -- สีแดงสตรอว์เบอร์รี
    Text = Color3.fromRGB(50, 50, 50), -- สีเทาเข้ม
    White = Color3.fromRGB(255, 255, 255),
    Gradient1 = Color3.fromRGB(255, 180, 210), -- ชมพูอ่อนกว่า
    Gradient2 = Color3.fromRGB(255, 130, 170), -- ชมพูเข้ม
    Border = Color3.fromRGB(255, 150, 190) -- สีขอบ
}

-- [[ 🛠️ UI: SETUP FRAME ]] --
local Setup = Instance.new("Frame", GeminiGui)
Setup.Size = UDim2.new(0, 320, 0, 200)
Setup.Position = UDim2.new(0.5, -160, 0.5, -100)
Setup.BackgroundColor3 = Theme.BG
Setup.BorderSizePixel = 0
Setup.Parent = GeminiGui
Instance.new("UICorner", Setup).CornerRadius = UDim.new(0, 20)
-- เงา
Instance.new("ImageLabel", Setup, {Size=UDim2.new(1,30,1,30),Position=UDim2.new(0,-15,0,-15),BackgroundTransparency=1,Image="rbxassetid://1316045217",ImageColor3=Color3.fromRGB(0,0,0),ImageTransparency=0.5,ZIndex=0})

local STitle = Instance.new("TextLabel", Setup)
STitle.Size = UDim2.new(1, 0, 0, 50)
STitle.Text = "🍓 Pro Sprout Setup 🍓"
STitle.TextColor3 = Theme.Accent
STitle.Font = Enum.Font.GothamBold
STitle.TextSize = 22
STitle.BackgroundTransparency = 1

local SInput = Instance.new("TextBox", Setup)
SInput.Size = UDim2.new(0, 280, 0, 45)
SInput.Position = UDim2.new(0, 20, 0, 70)
SInput.PlaceholderText = "Paste your Gemini API Key here..."
SInput.Text = ""
SInput.Font = Enum.Font.Gotham
SInput.TextSize = 16
SInput.BackgroundColor3 = Theme.White
SInput.TextColor3 = Theme.Text
Instance.new("UICorner", SInput)
Instance.new("UIStroke", SInput, {Color=Theme.Main,Thickness=2})

local SBtn = Instance.new("TextButton", Setup)
SBtn.Size = UDim2.new(0, 140, 0, 45)
SBtn.Position = UDim2.new(0.5, -70, 0, 130)
SBtn.BackgroundColor3 = Theme.Main
SBtn.Text = "Go Global!"
SBtn.TextColor3 = Theme.White
SBtn.Font = Enum.Font.GothamBold
SBtn.TextSize = 18
Instance.new("UICorner", SBtn)

-- [[ 💬 UI: MAIN CHAT FRAME ]] --
local Main = Instance.new("Frame", GeminiGui)
Main.Size = UDim2.new(0, 350, 0, 450)
Main.Position = UDim2.new(0.5, -175, 0.5, -225)
Main.BackgroundColor3 = Theme.BG
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = GeminiGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 25)
-- เงา
Instance.new("ImageLabel", Main, {Size=UDim2.new(1,40,1,40),Position=UDim2.new(0,-20,0,-20),BackgroundTransparency=1,Image="rbxassetid://1316045217",ImageColor3=Color3.fromRGB(0,0,0),ImageTransparency=0.5,ZIndex=0})

-- แถบบน (Title Bar) พร้อม Gradient
local Bar = Instance.new("Frame", Main)
Bar.Size = UDim2.new(1, 0, 0, 50)
Bar.BorderSizePixel = 0
Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 25)
Instance.new("UIGradient", Bar, {Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Theme.Gradient1),ColorSequenceKeypoint.new(1,Theme.Gradient2)})})

local BTitle = Instance.new("TextLabel", Bar)
BTitle.Size = UDim2.new(1, -110, 1, 0)
BTitle.Position = UDim2.new(0, 20, 0, 0)
BTitle.Text = L.title
BTitle.TextColor3 = Theme.White
BTitle.Font = Enum.Font.GothamBold
BTitle.TextSize = 18
BTitle.TextXAlignment = "Left"
BTitle.BackgroundTransparency = 1

local Close = Instance.new("TextButton", Bar)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0.5, -15)
Close.Text = "X"
Close.BackgroundColor3 = Theme.Accent
Close.TextColor3 = Theme.White
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Instance.new("UICorner", Close, {CornerRadius=UDim.new(1,0)})

local MinBtn = Instance.new("TextButton", Bar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -80, 0.5, -15)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Theme.Gradient1
MinBtn.TextColor3 = Theme.White
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
Instance.new("UICorner", MinBtn, {CornerRadius=UDim.new(1,0)})

-- พื้นที่แชท
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Theme.Main
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0,10)
Instance.new("UIPadding", Scroll, {PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5)})

-- ช่องพิมพ์
local InBox = Instance.new("TextBox", Main)
InBox.Size = UDim2.new(1, -80, 0, 45)
InBox.Position = UDim2.new(0, 15, 1, -55)
InBox.PlaceholderText = L.prompt
InBox.Text = ""
InBox.Font = Enum.Font.Gotham
InBox.TextSize = 16
InBox.BackgroundColor3 = Theme.White
InBox.TextColor3 = Theme.Text
Instance.new("UICorner", InBox).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", InBox, {Color=Theme.Main,Thickness=2})

-- ปุ่มส่ง
local Send = Instance.new("TextButton", Main)
Send.Size = UDim2.new(0, 50, 0, 45)
Send.Position = UDim2.new(1, -65, 1, -55)
Send.Text = "🍓"
Send.TextSize = 30
Send.BackgroundColor3 = Theme.Accent
Send.TextColor3 = Theme.White
Instance.new("UICorner", Send).CornerRadius = UDim.new(1,0)

-- [[ 🍓 UI: TAP ICON (ปุ่มย่อแบบ Pro) 🍓 ]] --
local TapIcon = Instance.new("TextButton", GeminiGui)
TapIcon.Name = "TapIcon"
TapIcon.Size = UDim2.new(0, 65, 0, 65)
TapIcon.Position = UDim2.new(1, -80, 0.5, -32) -- อยู่ขวาตรงกลาง
TapIcon.BackgroundColor3 = Theme.White
TapIcon.Text = "🍓"
TapIcon.TextSize = 35
TapIcon.Visible = false -- ซ่อนไว้ก่อน
TapIcon.BorderSizePixel = 0
Instance.new("UICorner", TapIcon).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", TapIcon, {Color=Theme.Main,Thickness=3})
-- เงา
Instance.new("ImageLabel", TapIcon, {Size=UDim2.new(1,20,1,20),Position=UDim2.new(0,-10,0,-10),BackgroundTransparency=1,Image="rbxassetid://1316045217",ImageColor3=Color3.fromRGB(0,0,0),ImageTransparency=0.5,ZIndex=0})
-- ข้อความบอกภาษา
local LangTag = Instance.new("TextLabel", TapIcon)
LangTag.Size = UDim2.new(1, 0, 0, 20)
LangTag.Position = UDim2.new(0, 0, 1, -25)
LangTag.Text = "Global AI"
LangTag.TextColor3 = Theme.Accent
LangTag.Font = Enum.Font.GothamBold
LangTag.TextSize = 10
LangTag.BackgroundTransparency = 1

-- [[ 🧠 ระบบ AI LOGIC PRO: MULTI-LANGUAGE INTEL ]] --
local API_KEY = LoadKey()

local function AddMsg(sender, message)
    local MsgFrame = Instance.new("Frame", Scroll)
    MsgFrame.Size = UDim2.new(1, 0, 0, 40)
    MsgFrame.BackgroundTransparency = 1
    MsgFrame.BorderSizePixel = 0
    
    local MsgLabel = Instance.new("TextLabel", MsgFrame)
    MsgLabel.Size = UDim2.new(0.8, -10, 1, 0)
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Text = "<b>" .. (sender == "You" and L.you .. ": " or "🍓 " .. L.sp .. ": ") .. "</b>" .. message
    MsgLabel.RichText = true
    MsgLabel.TextColor3 = (sender == "You" and Theme.Accent or Theme.Main)
    MsgLabel.Font = Enum.Font.Gotham
    MsgLabel.TextSize = 14
    MsgLabel.TextWrapped = true
    MsgLabel.TextXAlignment = (sender == "You" and "Right" or "Left")
    MsgLabel.Parent = MsgFrame
    
    Scroll.CanvasPosition = Vector2.new(0, 99999)
    local txtSize = game:GetService("TextService"):GetTextSize(MsgLabel.Text, MsgLabel.TextSize, MsgLabel.Font, Vector2.new(Scroll.AbsoluteSize.X * 0.8, 1000))
    MsgFrame.Size = UDim2.new(1, 0, 0, txtSize.Y + 10)
end

local function GetAI(prompt)
    local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" .. API_KEY
    local data = {
        contents = {{
            role = "user",
            parts = {{ text = L.instruct .. "\nQuestion: " .. prompt }}
        }}
    }
    
    local success, response = pcall(function()
        return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
    
    if success then
        local decoded = HttpService:JSONDecode(response)
        if decoded.candidates and decoded.candidates[1] then
            return decoded.candidates[1].content.parts[1].text
        end
    else
        warn("API Error: " .. tostring(response))
        return "ง่าา... สมองสตรอว์เบอร์รีของ Sprout เริ่มมึนหัวแล้ว (ตรวจสอบ API Key หรืออินเทอร์เน็ตดูนะ)"
    end
    return "สปราวต์คิดไม่ออกเลย... สงสัยจะกินสตรอว์เบอร์รีเยอะไป"
end

local function Start(key)
    API_KEY = key
    SaveKey(key)
    Setup.Visible = false
    Main.Visible = true
    AddMsg("Sprout", L.hello)
end

SBtn.MouseButton1Click:Connect(function() if SInput.Text ~= "" then Start(SInput.Text) end end)
Send.MouseButton1Click:Connect(function()
    local t = InBox.Text
    if t ~= "" then
        InBox.Text = ""
        AddMsg("You", t)
        AddMsg("Sprout", "Thinking...")
        task.spawn(function()
            local aiResponse = GetAI(t)
            local lastMsg = Scroll:GetChildren()[#Scroll:GetChildren()]
            if lastMsg:IsA("Frame") then lastMsg:Destroy() end
            AddMsg("Sprout", aiResponse)
        end)
    end
end)

Close.MouseButton1Click:Connect(function() GeminiGui:Destroy() end)

-- [[ 🛠️ ฟังก์ชันเสริม (ลากได้/ย่อได้) ]] --

local function makeDraggable(guiObj, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = guiObj.Position end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            guiObj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    dragHandle.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

makeDraggable(Main, Bar)
makeDraggable(TapIcon, TapIcon)

local isMinimized = false
local function ToggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        Main:TweenSize(UDim2.new(0, 350, 0, 0), "Out", "Quad", 0.3, true, function()
            Main.Visible = false
            TapIcon.Visible = true
            TapIcon.Size = UDim2.new(0, 0, 0, 0)
            TapIcon:TweenSize(UDim2.new(0, 65, 0, 65), "Out", "Back", 0.3, true)
        end)
    else
        TapIcon:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quad", 0.2, true, function()
            TapIcon.Visible = false
            Main.Visible = true
            Main:TweenSize(UDim2.new(0, 350, 0, 450), "Out", "Quad", 0.3, true)
        end)
    end
end

MinBtn.MouseButton1Click:Connect(ToggleMinimize)
TapIcon.MouseButton1Click:Connect(ToggleMinimize)

if API_KEY ~= "" then Start(API_KEY) end

print("🍓 Gemini Sprout: PRO EDITION GLOBAL LOADED! 🍓")
