-- [[ 🍓Sprout Script Scan🍓 ]] --
-- [[ 🍓 ANTI-BUG & UI LAYER FIXED 🍓 ]] --

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if game.CoreGui:FindFirstChild("SproutAntiBug") then game.CoreGui.SproutAntiBug:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SproutAntiBug"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999 -- ให้ UI ทั้งหมดอยู่ชั้นบนสุดของจอ

-- [[ 🛠️ Variable ]]
local Target = nil
local Following = false
local FollowConnection

-- [[ 🛠️ Drag Logic ]]
local function MakeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() dragging = false end)
end

-- [[ 🍓 Mini Icon (ปุ่มขยาย) - แยกตำแหน่งให้กดง่าย ]]
local MiniIcon = Instance.new("TextButton", ScreenGui)
MiniIcon.Name = "MiniIcon"
MiniIcon.Size = UDim2.new(0, 65, 0, 65)
MiniIcon.Position = UDim2.new(0, 50, 0, 50) -- ไว้มุมซ้ายบนเพื่อไม่ให้ทับกับหน้าต่างหลัก
MiniIcon.Text = "🍓"; MiniIcon.TextSize = 45; MiniIcon.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
MiniIcon.ZIndex = 100 -- ลอยสูงสุด
MiniIcon.Visible = false
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)
MakeDraggable(MiniIcon)

-- [[ Main Frame (420x390) ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 390)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -195)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
MainFrame.ZIndex = 10
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
MakeDraggable(MainFrame)

-- [[ Header ]]
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 45); Header.BackgroundColor3 = Color3.fromRGB(255, 105, 180); Header.ZIndex = 11
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 20)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.ZIndex = 12
Title.Text = "🍓Sprout Script Scan🍓"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = 4; Title.TextSize = 14; Title.TextXAlignment = 0; Title.BackgroundTransparency = 1

local MiniBtn = Instance.new("TextButton", Header) -- ปุ่มย่อ
MiniBtn.Size = UDim2.new(0, 32, 0, 32); MiniBtn.Position = UDim2.new(1, -75, 0, 6); MiniBtn.ZIndex = 13
MiniBtn.Text = "-"; MiniBtn.BackgroundColor3 = Color3.fromRGB(255, 192, 203); MiniBtn.TextColor3 = Color3.fromRGB(200, 80, 150)
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 32, 0, 32); CloseBtn.Position = UDim2.new(1, -38, 0, 6); CloseBtn.ZIndex = 13
CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 40); CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- [[ Toggle Logic - แก้ไขการสลับ ]]
MiniBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MiniIcon.Visible = true end)
MiniIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true; MiniIcon.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- [[ Pages ]]
local ScanPage = Instance.new("Frame", MainFrame)
ScanPage.Size = UDim2.new(1, 0, 1, -45); ScanPage.Position = UDim2.new(0, 0, 0, 45); ScanPage.BackgroundTransparency = 1; ScanPage.ZIndex = 10

local AiPage = Instance.new("Frame", MainFrame)
AiPage.Size = UDim2.new(1, 0, 1, -45); AiPage.Position = UDim2.new(0, 0, 0, 45); AiPage.BackgroundTransparency = 1; AiPage.Visible = false; AiPage.ZIndex = 10

-- [[ AI Intelligence: Mega Update ]]
local function GeminiThink(msg)
    if not Target then return "🍓 Please select a player first!" end
    local dict = {
        ["What are you doing?"] = "Scanning @"..Target.Name.." and finding secrets! 🍓🕵️",
        ["Fuck you / Shut up"] = "What up bitch? 🍓💅",
        ["Others script good?"] = "They are okay, but Sprout Script is your favorite! 🍓✨",
        ["I love you 💖"] = "Love you too! Let's win together! 🍓💖",
        ["Goodnight / Bye"] = "Bye! Sprout AI is going to sleep now. 🍓😴",
        ["Kill him? 🗡️"] = "Target is in range. Ready when you are! 🗡️",
        ["Roblox?"] = "The best world for the best scripter! 🍓🎮"
    }
    return dict[msg] or "Error in Sprout System."
end

-- AI UI
local ChatLog = Instance.new("ScrollingFrame", AiPage)
ChatLog.Size = UDim2.new(0.94, 0, 0.4, 0); ChatLog.Position = UDim2.new(0.03, 0, 0.02, 0); ChatLog.BackgroundColor3 = Color3.new(1,1,1); ChatLog.BackgroundTransparency = 0.8; ChatLog.ZIndex = 11; Instance.new("UIListLayout", ChatLog).Padding = UDim.new(0, 5)

local QuestionFrame = Instance.new("ScrollingFrame", AiPage)
QuestionFrame.Size = UDim2.new(0.94, 0, 0.42, 0); QuestionFrame.Position = UDim2.new(0.03, 0, 0.45, 0); QuestionFrame.BackgroundTransparency = 1; QuestionFrame.ZIndex = 11; Instance.new("UIGridLayout", QuestionFrame).CellSize = UDim2.new(0, 185, 0, 30)

local function addQ(txt)
    local b = Instance.new("TextButton", QuestionFrame); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(255, 182, 193); b.TextSize = 10; b.ZIndex = 12; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        local l = Instance.new("TextLabel", ChatLog); l.Size = UDim2.new(1,0,0,20); l.Text = "You: "..txt; l.BackgroundTransparency = 1; l.TextSize = 11; l.ZIndex = 12
        local r = Instance.new("TextLabel", ChatLog); r.Size = UDim2.new(1,0,0,20); r.Text = "Gemini: "..GeminiThink(txt); r.TextColor3 = Color3.fromRGB(255, 20, 147); r.BackgroundTransparency = 1; r.TextSize = 11; r.ZIndex = 12
        ChatLog.CanvasSize = UDim2.new(0,0,0, ChatLog.UIListLayout.AbsoluteContentSize.Y)
    end)
end
local qs = {"What are you doing?", "Fuck you / Shut up", "Others script good?", "I love you 💖", "Goodnight / Bye", "Kill him? 🗡️", "Roblox?"}
for _, q in pairs(qs) do addQ(q) end

local BackBtn = Instance.new("TextButton", AiPage); BackBtn.Size = UDim2.new(1, -20, 0, 30); BackBtn.Position = UDim2.new(0, 10, 1, -35); BackBtn.Text = "BACK"; BackBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180); BackBtn.TextColor3 = Color3.new(1,1,1); BackBtn.ZIndex = 12; Instance.new("UICorner", BackBtn); BackBtn.MouseButton1Click:Connect(function() ScanPage.Visible = true; AiPage.Visible = false end)

-- [[ Scan Page UI (Restore Stats) ]]
local List = Instance.new("ScrollingFrame", ScanPage); List.Size = UDim2.new(0.44, 0, 0.92, 0); List.Position = UDim2.new(0.03, 0, 0.04, 0); List.BackgroundTransparency = 0.95; List.ZIndex = 11; Instance.new("UIListLayout", List).Padding = UDim.new(0, 8)
local InfoSide = Instance.new("Frame", ScanPage); InfoSide.Size = UDim2.new(0.48, 0, 0.95, 0); InfoSide.Position = UDim2.new(0.5, 0, 0.02, 0); InfoSide.BackgroundTransparency = 1; InfoSide.ZIndex = 11
local Avatar = Instance.new("ImageLabel", InfoSide); Avatar.Size = UDim2.new(0, 85, 0, 85); Avatar.Position = UDim2.new(0.5, -42, 0, 5); Avatar.BackgroundTransparency = 1; Avatar.ZIndex = 12; Instance.new("UICorner", Avatar)
local InfoTxt = Instance.new("TextLabel", InfoSide); InfoTxt.Size = UDim2.new(1, 0, 0, 130); InfoTxt.Position = UDim2.new(0, 0, 0, 95); InfoTxt.Text = "🍓 Select Player"; InfoTxt.TextSize = 11; InfoTxt.TextWrapped = true; InfoTxt.BackgroundTransparency = 1; InfoTxt.ZIndex = 12

local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", InfoSide); b.Size = UDim2.new(1, 0, 0, 30); b.Position = pos; b.Text = txt; b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1,1,1); b.Visible = false; b.ZIndex = 12; Instance.new("UICorner", b); return b
end

local FolBtn = createBtn("FOLLOW 🍓", UDim2.new(0,0,1,-130), Color3.fromRGB(255, 105, 180))
local TpBtn = createBtn("TELEPORT", UDim2.new(0,0,1,-95), Color3.fromRGB(255, 182, 193))
local StopBtn = createBtn("STOP ALL", UDim2.new(0,0,1,-60), Color3.fromRGB(200, 50, 50))
local AiBtn = createBtn("AI SELECTION 🍓", UDim2.new(0,0,1,-25), Color3.fromRGB(105, 180, 255))

-- [[ Movement Core ]]
TpBtn.MouseButton1Click:Connect(function()
    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

FolBtn.MouseButton1Click:Connect(function()
    Following = not Following
    FolBtn.Text = Following and "FOLLOWING..." or "FOLLOW 🍓"
    if Following then
        FollowConnection = RunService.Heartbeat:Connect(function()
            if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.Humanoid:MoveTo(Target.Character.HumanoidRootPart.Position)
            end
        end)
    else
        if FollowConnection then FollowConnection:Disconnect() end
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    Following = false
    if FollowConnection then FollowConnection:Disconnect() end
    Camera.CameraSubject = LocalPlayer.Character
end)

AiBtn.MouseButton1Click:Connect(function() ScanPage.Visible = false; AiPage.Visible = true end)

local function Refresh()
    for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local b = Instance.new("TextButton", List); b.Size = UDim2.new(1, -8, 0, 35); b.Text = p.DisplayName; b.BackgroundColor3 = Color3.fromRGB(255, 215, 230); b.TextSize = 12; b.ZIndex = 12; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Target = p; Avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..p.UserId.."&w=150&h=150"
            Camera.CameraSubject = p.Character or p
            local dev = UserInputService.TouchEnabled and "Mobile" or "PC"
            InfoTxt.Text = "Name: "..p.Name.."\nNick: "..p.DisplayName.."\nAge: "..p.AccountAge.." days\nDevice: "..dev.."\nHP: "..(p.Character and p.Character:FindFirstChild("Humanoid") and math.floor(p.Character.Humanoid.Health) or "0")
            FolBtn.Visible, TpBtn.Visible, StopBtn.Visible, AiBtn.Visible = true, true, true, true
        end)
    end
end
Players.PlayerAdded:Connect(Refresh); Players.PlayerRemoving:Connect(Refresh); Refresh()
