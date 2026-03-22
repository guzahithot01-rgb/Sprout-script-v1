
-- [[ 🍓 GEMINI SPROUT V2: ULTIMATE AI & STYLE 🍓 ]] --
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ลบ GUI เก่าถ้ามี (เพื่อความสะอาด)
if CoreGui:FindFirstChild("GeminiSproutGui") then CoreGui.GeminiSproutGui:Destroy() end

local GeminiGui = Instance.new("ScreenGui")
GeminiGui.Name = "GeminiSproutGui"
GeminiGui.Parent = CoreGui
GeminiGui.ResetOnSpawn = false -- สำคัญ: เพื่อไม่ให้ GUI หายเวลารีเซ็ตตัว

-- [[ 💾 ระบบเซฟ Key ลงเครื่องผู้ใช้ ]] --
local FileName = "SproutKey_V2_Config.txt"
local function SaveKey(k) if writefile then writefile(FileName, k) end end
local function LoadKey() if isfile and isfile(FileName) then return readfile(FileName) end return "" end

-- [[ 🎨 UI THEME: STRAWBERRY DELIGHT ]] --
local Theme = {
    BG = Color3.fromRGB(255, 245, 250), -- สีชมพูอ่อนมากๆ (นมสตรอว์เบอร์รี)
    Main = Color3.fromRGB(255, 120, 180), -- สีชมพูสดใส
    Accent = Color3.fromRGB(220, 20, 60), -- สีแดงสตรอว์เบอร์รี
    Text = Color3.fromRGB(50, 50, 50), -- สีเทาเข้ม (เพื่อให้อ่านง่าย)
    White = Color3.fromRGB(255, 255, 255),
    Gradient1 = Color3.fromRGB(255, 180, 210),
    Gradient2 = Color3.fromRGB(255, 130, 170)
}

-- [[ 🛠️ UI: SETUP FRAME (หน้าต่างกรอก Key) ]] --
local Setup = Instance.new("Frame", GeminiGui)
Setup.Size = UDim2.new(0, 320, 0, 200)
Setup.Position = UDim2.new(0.5, -160, 0.5, -100)
Setup.BackgroundColor3 = Theme.BG
Setup.BorderSizePixel = 0
Instance.new("UICorner", Setup).CornerRadius = UDim.new(0, 20)
-- ใส่เงาให้หน้าต่าง Setup
local SetupShadow = Instance.new("ImageLabel", Setup)
SetupShadow.Size = UDim2.new(1, 30, 1, 30)
SetupShadow.Position = UDim2.new(0, -15, 0, -15)
SetupShadow.BackgroundTransparency = 1
SetupShadow.Image = "rbxassetid://1316045217"
SetupShadow.ImageColor3 = Color3.fromRGB(0,0,0)
SetupShadow.ImageTransparency = 0.5
SetupShadow.ZIndex = 0

local STitle = Instance.new("TextLabel", Setup)
STitle.Size = UDim2.new(1, 0, 0, 50)
STitle.Text = "🍓 Sprout Setup 🍓"
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
Instance.new("UICorner", SInput)
local SInputStroke = Instance.new("UIStroke", SInput)
SInputStroke.Color = Theme.Main
SInputStroke.Thickness = 2

local SBtn = Instance.new("TextButton", Setup)
SBtn.Size = UDim2.new(0, 140, 0, 45)
SBtn.Position = UDim2.new(0.5, -70, 0, 130)
SBtn.BackgroundColor3 = Theme.Main
SBtn.Text = "Let's Sprout!"
SBtn.TextColor3 = Theme.White
SBtn.Font = Enum.Font.GothamBold
SBtn.TextSize = 18
Instance.new("UICorner", SBtn)

-- [[ 💬 UI: MAIN CHAT FRAME (หน้าต่างแชท) ]] --
local Main = Instance.new("Frame", GeminiGui)
Main.Size = UDim2.new(0, 350, 0, 450)
Main.Position = UDim2.new(0.5, -175, 0.5, -225)
Main.BackgroundColor3 = Theme.BG
Main.BorderSizePixel = 0
Main.Visible = false
Main.ClipsDescendants = true -- สำคัญสำหรับการย่อ/ขยาย
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 25)
-- ใส่เงาให้หน้าต่าง Main
local MainShadow = Instance.new("ImageLabel", Main)
MainShadow.Size = UDim2.new(1, 40, 1, 40)
MainShadow.Position = UDim2.new(0, -20, 0, -20)
MainShadow.BackgroundTransparency = 1
MainShadow.Image = "rbxassetid://1316045217"
MainShadow.ImageColor3 = Color3.fromRGB(0,0,0)
MainShadow.ImageTransparency = 0.5
MainShadow.ZIndex = 0

-- แถบบน (Title Bar) พร้อม Gradient
local Bar = Instance.new("Frame", Main)
Bar.Size = UDim2.new(1, 0, 0, 50)
Bar.BorderSizePixel = 0
Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 25)
local BarGradient = Instance.new("UIGradient", Bar)
BarGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Gradient1), ColorSequenceKeypoint.new(1, Theme.Gradient2)})

local BTitle = Instance.new("TextLabel", Bar)
BTitle.Size = UDim2.new(1, -110, 1, 0)
BTitle.Position = UDim2.new(0, 20, 0, 0)
BTitle.Text = "🍓 gemini sprout 🍓"
BTitle.TextColor3 = Theme.White
BTitle.Font = Enum.Font.GothamBold
BTitle.TextSize = 20
BTitle.TextXAlignment = "Left"
BTitle.BackgroundTransparency = 1

local Close = Instance.new("TextButton", Bar)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -45, 0.5, -15)
Close.Text = "X"
Close.BackgroundColor3 = Theme.Accent
Close.TextColor3 = Theme.White
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Instance.new("UICorner", Close, {CornerRadius = UDim.new(1,0)})

local MinBtn = Instance.new("TextButton", Bar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -85, 0.5, -15)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Theme.Gradient1
MinBtn.TextColor3 = Theme.White
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
Instance.new("UICorner", MinBtn, {CornerRadius = UDim.new(1,0)})

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
local UIPadding_Chat = Instance.new("UIPadding", Scroll)
UIPadding_Chat.PaddingLeft = UDim.new(0, 5)
UIPadding_Chat.PaddingRight = UDim.new(0, 5)

-- ช่องพิมพ์คำถาม ( Input ) พร้อมเส้นขอบ
local InBox = Instance.new("TextBox", Main)
InBox.Size = UDim2.new(1, -80, 0, 45)
InBox.Position = UDim2.new(0, 15, 1, -55)
InBox.PlaceholderText = "Talk to Sprout..."
InBox.Text = ""
InBox.Font = Enum.Font.Gotham
InBox.TextSize = 16
InBox.BackgroundColor3 = Theme.White
InBox.TextColor3 = Theme.Text
Instance.new("UICorner", InBox).CornerRadius = UDim.new(1, 0)
local InBoxStroke = Instance.new("UIStroke", InBox)
InBoxStroke.Color = Theme.Main
InBoxStroke.Thickness = 2

-- ปุ่มส่ง ( Send ) เป็นสตรอว์เบอร์รีสวยๆ
local Send = Instance.new("TextButton", Main)
Send.Size = UDim2.new(0, 50, 0, 45)
Send.Position = UDim2.new(1, -65, 1, -55)
Send.Text = "🍓"
Send.TextSize = 30
Send.BackgroundColor3 = Theme.Accent
Send.TextColor3 = Theme.White
Instance.new("UICorner", Send).CornerRadius = UDim.new(1, 0)

-- [[ 🍓 UI: TAP ICON (ปุ่มย่อสตรอว์เบอร์รี) ]] --
local TapIcon = Instance.new("TextButton", GeminiGui)
TapIcon.Name = "TapIcon"
TapIcon.Size = UDim2.new(0, 65, 0, 65)
TapIcon.Position = UDim2.new(1, -80, 0.5, -32) -- อยู่ขวาตรงกลาง
TapIcon.BackgroundColor3 = Theme.White
TapIcon.Text = "🍓"
TapIcon.TextSize = 35
TapIcon.Visible = false -- ซ่อนไว้ก่อน
Instance.new("UICorner", TapIcon).CornerRadius = UDim.new(1, 0)
local TapIconStroke = Instance.new("UIStroke", TapIcon)
TapIconStroke.Color = Theme.Main
TapIconStroke.Thickness = 3
-- ใส่เงาให้ TapIcon
local TapIconShadow = Instance.new("ImageLabel", TapIcon)
TapIconShadow.Size = UDim2.new(1, 20, 1, 20)
TapIconShadow.Position = UDim2.new(0, -10, 0, -10)
TapIconShadow.BackgroundTransparency = 1
TapIconShadow.Image = "rbxassetid://1316045217"
TapIconShadow.ImageColor3 = Color3.fromRGB(0,0,0)
TapIconShadow.ImageTransparency = 0.5
TapIconShadow.ZIndex = 0

-- [[ 🧠 ระบบ AI LOGIC V2: ฉลาดแบบ Gemini, กวนแบบ Sprout ]] --
local API_KEY = LoadKey()

local function AddMsg(sender, message)
    local MsgFrame = Instance.new("Frame", Scroll)
    MsgFrame.Size = UDim2.new(1, 0, 0, 40)
    MsgFrame.BackgroundTransparency = 1
    MsgFrame.BorderSizePixel = 0
    
    local MsgLabel = Instance.new("TextLabel", MsgFrame)
    MsgLabel.Size = UDim2.new(0.8, -10, 1, 0)
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Text = "<b>" .. (sender == "You" and "You: " or "🍓 Sprout: ") .. "</b>" .. message
    MsgLabel.RichText = true
    MsgLabel.TextColor3 = (sender == "You" and Theme.Accent or Theme.Main)
    MsgLabel.Font = Enum.Font.Gotham
    MsgLabel.TextSize = 14
    MsgLabel.TextWrapped = true
    MsgLabel.TextXAlignment = (sender == "You" and "Right" or "Left")
    MsgLabel.Parent = MsgFrame
    
    -- ปรับขนาด Scrolling ให้เลื่อนลงมาล่างสุดเสมอ
    Scroll.CanvasPosition = Vector2.new(0, 99999)
    
    -- ปรับความสูงของเฟรมตามขนาดข้อความ
    local txtSize = game:GetService("TextService"):GetTextSize(MsgLabel.Text, MsgLabel.TextSize, MsgLabel.Font, Vector2.new(Scroll.AbsoluteSize.X * 0.8, 1000))
    MsgFrame.Size = UDim2.new(1, 0, 0, txtSize.Y + 10)
end

local function GetAI(prompt)
    local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" .. API_KEY
    
    -- SYSTEM INSTRUCTION: กำหนดนิสัยให้ AI (ฉลาดแต่กวนๆ)
    local systemInstruction = [[คุณคือ 'Sprout' ผู้ช่วยสุดแสบและกวนตีนในเกม Roblox ธีมสตรอว์เบอร์รี คุณฉลาดระดับ Gemini แต่ชอบตอบกวนๆ ขี้เล่น และแอบกัดเล็กน้อย ใช้คำพูดที่เป็นมิตรแต่แฝงความแสบ จงตอบเป็นภาษาไทยเสมอ]]
    
    local data = {
        contents = {{
            role = "user",
            parts = {{ text = "Instruction: " .. systemInstruction .. "\nQuestion: " .. prompt }}
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
        return "ง่าา... สมองสตรอว์เบอร์รีของ Sprout เริ่มมึนหัวแล้ว (ตรวจสอบ API Key หรืออินเทอร์เน็ตดูนะ) ลองถามใหม่อีกทีนะจ๊ะ!"
    end
    return "สปราวต์คิดไม่ออกเลย... สงสัยจะกินสตรอว์เบอร์รีเยอะไป"
end

local function Start(key)
    API_KEY = key
    SaveKey(key)
    Setup.Visible = false
    Main.Visible = true
    AddMsg("Sprout", "🍓 Hello there! I'm Gemini Sprout, your strawberry assistant! Ask me anything, if I'm not eating strawberries... 😂")
end

SBtn.MouseButton1Click:Connect(function() if SInput.Text ~= "" then Start(SInput.Text) end end)
Send.MouseButton1Click:Connect(function()
    local t = InBox.Text
    if t ~= "" then
        InBox.Text = ""
        AddMsg("You", t)
        -- รอ AI ตอบ (ใส่ "..." รอไว้ก่อน)
        AddMsg("Sprout", "Thinking...")
        
        task.spawn(function()
            local aiResponse = GetAI(t)
            -- ลบอันล่าสุดที่บอกว่ากำลังคิด แล้วใส่คำตอบจริงลงไป
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = guiObj.Position
        end
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
        -- ย่อหน้าต่าง
        Main:TweenSize(UDim2.new(0, 350, 0, 0), "Out", "Quad", 0.3, true, function()
            Main.Visible = false
            TapIcon.Visible = true
            -- เอฟเฟกต์เด้งตอนรูป Tap ปรากฏ
            TapIcon.Size = UDim2.new(0, 0, 0, 0)
            TapIcon:TweenSize(UDim2.new(0, 65, 0, 65), "Out", "Back", 0.3, true)
        end)
    else
        -- ขยายหน้าต่าง
        TapIcon:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quad", 0.2, true, function()
            TapIcon.Visible = false
            Main.Visible = true
            Main:TweenSize(UDim2.new(0, 350, 0, 450), "Out", "Quad", 0.3, true)
        end)
    end
end

MinBtn.MouseButton1Click:Connect(ToggleMinimize)
TapIcon.MouseButton1Click:Connect(ToggleMinimize) -- กดที่รูปสตรอว์เบอร์รีเพื่อขยายคืน

if API_KEY ~= "" then Start(API_KEY) end

print("🍓 Gemini Sprout V2: ULTIMATE LOADED! 🍓")
