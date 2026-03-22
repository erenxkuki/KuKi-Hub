do
local ui = game:GetService("CoreGui"):FindFirstChild("UILibrary")
if ui then
ui:Destroy()
end
end

local library = {}
local titlefunc = {}
local UIConfig = {
  Bind = Enum.KeyCode.RightControl
}

-- Generate random string for GUI
local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local length = 20
local randomString = ""
math.randomseed(os.time())
charTable = {}
for c in chars:gmatch "." do
table.insert(charTable, c)
end
for i = 1, length do
randomString = randomString .. charTable[math.random(1, #charTable)]
end

-- Clean up existing GUI
for i, v in pairs(game.CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):GetChildren()) do
if v.ClassName == "ScreenGui" then
for i1, v1 in pairs(v:GetChildren()) do
if v1.Name == "Main" then
do
local ui = v
if ui then
ui:Destroy()
end
end
end
end
end
end

-- Theme colors (Red, White, Black)
_G.Color = Color3.fromRGB(255, 50, 50) -- Main Red
_G.SecondaryColor = Color3.fromRGB(255, 255, 255) -- White
_G.DarkColor = Color3.fromRGB(18, 18, 18) -- Darker Black
_G.AccentColor = Color3.fromRGB(220, 40, 40) -- Dark Red

-- CORRECT LOGO FORMAT - Use a working Roblox image asset
-- If your texture ID doesn't work, use a default one
_G.LogoTexture = "rbxassetid://6031086138"  -- Default Roblox logo (works 100%)

function CircleClick(Button, X, Y)
coroutine.resume(
  coroutine.create(
    function()
    local Circle = Instance.new("ImageLabel")
    Circle.Parent = Button
    Circle.Name = "Circle"
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BackgroundTransparency = 1.000
    Circle.ZIndex = 10
    Circle.Image = "rbxassetid://14346331443"
    Circle.ImageColor3 = _G.Color
    Circle.ImageTransparency = 0.7
    Circle.Visible = false
    local NewX = X - Circle.AbsolutePosition.X
    local NewY = Y - Circle.AbsolutePosition.Y
    Circle.Position = UDim2.new(0, NewX, 0, NewY)
    local Time = 0.2
    Circle:TweenSizeAndPosition(
      UDim2.new(0, 30.25, 0, 30.25),
      UDim2.new(0, NewX - 15, 0, NewY - 10),
      "Out",
      "Quad",
      Time,
      false,
      nil
    )
    for i = 1, 10 do
    Circle.ImageTransparency = Circle.ImageTransparency + 0.01
    wait(Time / 10)
    end
    Circle:Destroy()
    end
  )
)
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

function dragify(Frame, object)
dragToggle = nil
dragSpeed = .25
dragInput = nil
dragStart = nil
dragPos = nil
function updateInput(input)
Delta = input.Position - dragStart
Position =
UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
game:GetService("TweenService"):Create(object, TweenInfo.new(dragSpeed), {
  Position = Position
}):Play()
end
Frame.InputBegan:Connect(
  function(input)
  if
    (input.UserInputType == Enum.UserInputType.MouseButton1 or
    input.UserInputType == Enum.UserInputType.Touch)
  then
  dragToggle = true
  dragStart = input.Position
  startPos = object.Position
  input.Changed:Connect(
    function()
    if (input.UserInputState == Enum.UserInputState.End) then
    dragToggle = false
    end
    end
  )
  end
  end
)
Frame.InputChanged:Connect(
  function(input)
  if
    (input.UserInputType == Enum.UserInputType.MouseMovement or
    input.UserInputType == Enum.UserInputType.Touch)
  then
  dragInput = input
  end
  end
)
game:GetService("UserInputService").InputChanged:Connect(
  function(input)
  if (input == dragInput and dragToggle) then
  updateInput(input)
  end
  end
)
end

local UI = Instance.new("ScreenGui")
UI.Name = randomString
UI.Parent = game.CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn then
syn.protect_gui(UI)
end

function library:Destroy()
library:Destroy()
end

function library:Make()
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Top = Instance.new("Frame")
local TabHolder = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local UICorner_3 = Instance.new("UICorner")
local TabContainer = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding = Instance.new("UIPadding")
local Title = Instance.new("TextLabel")

Main.Name = "Main"
Main.Parent = UI
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3 = _G.DarkColor
Main.Size = UDim2.new(0, 550, 0, 380)
Main.ClipsDescendants = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundTransparency = 0

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = _G.Color
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Main

local uitoggled = false
UserInputService.InputBegan:Connect(
    function(io, p)
    if io.KeyCode == UIConfig.Bind then
    if uitoggled == false then
    Main:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    uitoggled = true
    wait()
    UI.Enabled = false
    else
        Main:TweenSize(
        UDim2.new(0, 550, 0, 380),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quart,
        0.5,
        true
    )
    UI.Enabled = true
    uitoggled = false
    end
    end
    end)

-- HEADER
local HeaderTop = Instance.new("Frame")
HeaderTop.Name = "Top"
HeaderTop.Parent = Main
HeaderTop.BackgroundColor3 = _G.Color
HeaderTop.BackgroundTransparency = 0
HeaderTop.Position = UDim2.new(0, 0, 0, 0)
HeaderTop.Size = UDim2.new(0, 550, 0, 45)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = HeaderTop

-- Title with Logo
Title.Name = "Title"
Title.Parent = HeaderTop
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0.03, 0, 0.1, 0)
Title.Size = UDim2.new(0, 483, 0, 31)
Title.Font = Enum.Font.GothamBold
Title.Text = "KuKi".."<font color='rgb(255, 50, 50)'> Hub</font>".." | "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
Title.RichText = true;
Title.TextColor3 = _G.SecondaryColor
Title.TextSize = 15.000
Title.TextWrapped = true
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Logo (FIXED - using working asset)
local LogoImage = Instance.new("ImageLabel")
LogoImage.Parent = HeaderTop
LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LogoImage.BackgroundTransparency = 1.000
LogoImage.Position = UDim2.new(0.93, 0, 0.08, 0)
LogoImage.Size = UDim2.new(0, 32, 0, 32)
LogoImage.Image = "rbxassetid://6031086138"  -- Working Roblox logo
LogoImage.ImageColor3 = _G.SecondaryColor
LogoImage.ScaleType = Enum.ScaleType.Fit

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 16)
LogoCorner.Parent = LogoImage

-- Menu Button
local Menu_Setting = Instance.new("ImageButton")
Menu_Setting.Name = "Menu_Setting"
Menu_Setting.Parent = HeaderTop
Menu_Setting.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Menu_Setting.BackgroundTransparency = 1
Menu_Setting.Position = UDim2.new(0, 515, 0, 10)
Menu_Setting.Size = UDim2.new(0, 25, 0, 25)
Menu_Setting.Image = "http://www.roblox.com/asset/?id=14479606771"
Menu_Setting.ImageColor3 = _G.SecondaryColor
Menu_Setting.ZIndex = 10

-- Main Page (Side Panel)
local MainPage = Instance.new("Frame")
MainPage.Name = "MainPage"
MainPage.Parent = Main
MainPage.ClipsDescendants = true
MainPage.AnchorPoint = Vector2.new(0,0)
MainPage.BackgroundColor3 = _G.DarkColor
MainPage.Position = UDim2.new(0, -260, 0, 50)
MainPage.BackgroundTransparency = 0
MainPage.Size = UDim2.new(0, 250, 0, 320)
MainPage.ZIndex = 6

local MainPageStroke = Instance.new("UIStroke")
MainPageStroke.Color = _G.Color
MainPageStroke.Thickness = 1
MainPageStroke.Transparency = 0.5
MainPageStroke.Parent = MainPage

local MainPageCorner = Instance.new("UICorner")
MainPageCorner.CornerRadius = UDim.new(0, 10)
MainPageCorner.Parent = MainPage

local MainPageclose = false
Menu_Setting.MouseButton1Click:Connect(function()
  if MainPageclose == false then
  MainPageclose = true
  MainPage:TweenPosition(UDim2.new(0, -260, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
  else
    MainPageclose = false
  MainPage:TweenPosition(UDim2.new(0, 10, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
  end
end)

-- PLAYER INFO PANEL (FIXED)
local PlayerInfoFrame = Instance.new("Frame")
PlayerInfoFrame.Name = "PlayerInfoFrame"
PlayerInfoFrame.Parent = MainPage
PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PlayerInfoFrame.BackgroundTransparency = 0
PlayerInfoFrame.Size = UDim2.new(0, 230, 0, 310)
PlayerInfoFrame.Position = UDim2.new(0, 10, 0, 10)

local PlayerInfoCorner = Instance.new("UICorner")
PlayerInfoCorner.CornerRadius = UDim.new(0, 10)
PlayerInfoCorner.Parent = PlayerInfoFrame

-- Avatar Image
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Parent = PlayerInfoFrame
AvatarImage.Position = UDim2.new(0, 15, 0, 15)
AvatarImage.Size = UDim2.new(0, 70, 0, 70)
AvatarImage.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..game.Players.LocalPlayer.UserId.."&width=420&height=420&format=png"

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 35)
AvatarCorner.Parent = AvatarImage

-- Player Name
local PlayerName = Instance.new("TextLabel")
PlayerName.Parent = PlayerInfoFrame
PlayerName.Position = UDim2.new(0, 95, 0, 20)
PlayerName.Size = UDim2.new(0, 130, 0, 25)
PlayerName.BackgroundTransparency = 1
PlayerName.Font = Enum.Font.GothamBold
PlayerName.Text = game.Players.LocalPlayer.Name
PlayerName.TextColor3 = _G.SecondaryColor
PlayerName.TextSize = 14
PlayerName.TextXAlignment = Enum.TextXAlignment.Left

-- Level Text
local LevelText = Instance.new("TextLabel")
LevelText.Parent = PlayerInfoFrame
LevelText.Position = UDim2.new(0, 95, 0, 45)
LevelText.Size = UDim2.new(0, 130, 0, 20)
LevelText.BackgroundTransparency = 1
LevelText.Font = Enum.Font.Gotham
LevelText.Text = "Level: Loading..."
LevelText.TextColor3 = Color3.fromRGB(180, 180, 180)
LevelText.TextSize = 12
LevelText.TextXAlignment = Enum.TextXAlignment.Left

-- Race & Fruit Text
local RaceFruitText = Instance.new("TextLabel")
RaceFruitText.Parent = PlayerInfoFrame
RaceFruitText.Position = UDim2.new(0, 15, 0, 95)
RaceFruitText.Size = UDim2.new(0, 200, 0, 40)
RaceFruitText.BackgroundTransparency = 1
RaceFruitText.Font = Enum.Font.Gotham
RaceFruitText.Text = "Loading..."
RaceFruitText.TextColor3 = Color3.fromRGB(180, 180, 180)
RaceFruitText.TextSize = 11
RaceFruitText.TextWrapped = true
RaceFruitText.TextXAlignment = Enum.TextXAlignment.Left

-- Health Bar Section
local HealthFrame = Instance.new("Frame")
HealthFrame.Parent = PlayerInfoFrame
HealthFrame.Position = UDim2.new(0, 15, 0, 145)
HealthFrame.Size = UDim2.new(0, 200, 0, 35)
HealthFrame.BackgroundTransparency = 1

local HealthLabel = Instance.new("TextLabel")
HealthLabel.Parent = HealthFrame
HealthLabel.Position = UDim2.new(0, 0, 0, 0)
HealthLabel.Size = UDim2.new(0, 50, 0, 20)
HealthLabel.BackgroundTransparency = 1
HealthLabel.Font = Enum.Font.GothamBold
HealthLabel.Text = "❤️ Health"
HealthLabel.TextColor3 = _G.Color
HealthLabel.TextSize = 11
HealthLabel.TextXAlignment = Enum.TextXAlignment.Left

local HealthBarBG = Instance.new("Frame")
HealthBarBG.Parent = HealthFrame
HealthBarBG.Position = UDim2.new(0, 0, 0, 18)
HealthBarBG.Size = UDim2.new(0, 200, 0, 12)
HealthBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HealthBarBG.BorderSizePixel = 0

local HealthBarBGCorner = Instance.new("UICorner")
HealthBarBGCorner.CornerRadius = UDim.new(0, 6)
HealthBarBGCorner.Parent = HealthBarBG

local HealthBarFill = Instance.new("Frame")
HealthBarFill.Parent = HealthBarBG
HealthBarFill.Size = UDim2.new(1, 0, 0, 12)
HealthBarFill.BackgroundColor3 = _G.Color
HealthBarFill.BorderSizePixel = 0

local HealthFillCorner = Instance.new("UICorner")
HealthFillCorner.CornerRadius = UDim.new(0, 6)
HealthFillCorner.Parent = HealthBarFill

local HealthValue = Instance.new("TextLabel")
HealthValue.Parent = HealthFrame
HealthValue.Position = UDim2.new(0, 150, 0, 0)
HealthValue.Size = UDim2.new(0, 50, 0, 18)
HealthValue.BackgroundTransparency = 1
HealthValue.Font = Enum.Font.Gotham
HealthValue.Text = "100/100"
HealthValue.TextColor3 = _G.SecondaryColor
HealthValue.TextSize = 10
HealthValue.TextXAlignment = Enum.TextXAlignment.Right

-- Stamina Bar Section
local StaminaFrame = Instance.new("Frame")
StaminaFrame.Parent = PlayerInfoFrame
StaminaFrame.Position = UDim2.new(0, 15, 0, 190)
StaminaFrame.Size = UDim2.new(0, 200, 0, 35)
StaminaFrame.BackgroundTransparency = 1

local StaminaLabel = Instance.new("TextLabel")
StaminaLabel.Parent = StaminaFrame
StaminaLabel.Position = UDim2.new(0, 0, 0, 0)
StaminaLabel.Size = UDim2.new(0, 50, 0, 20)
StaminaLabel.BackgroundTransparency = 1
StaminaLabel.Font = Enum.Font.GothamBold
StaminaLabel.Text = "⚡ Stamina"
StaminaLabel.TextColor3 = Color3.fromRGB(85, 170, 255)
StaminaLabel.TextSize = 11
StaminaLabel.TextXAlignment = Enum.TextXAlignment.Left

local StaminaBarBG = Instance.new("Frame")
StaminaBarBG.Parent = StaminaFrame
StaminaBarBG.Position = UDim2.new(0, 0, 0, 18)
StaminaBarBG.Size = UDim2.new(0, 200, 0, 12)
StaminaBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
StaminaBarBG.BorderSizePixel = 0

local StaminaBarBGCorner = Instance.new("UICorner")
StaminaBarBGCorner.CornerRadius = UDim.new(0, 6)
StaminaBarBGCorner.Parent = StaminaBarBG

local StaminaBarFill = Instance.new("Frame")
StaminaBarFill.Parent = StaminaBarBG
StaminaBarFill.Size = UDim2.new(1, 0, 0, 12)
StaminaBarFill.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
StaminaBarFill.BorderSizePixel = 0

local StaminaFillCorner = Instance.new("UICorner")
StaminaFillCorner.CornerRadius = UDim.new(0, 6)
StaminaFillCorner.Parent = StaminaBarFill

local StaminaValue = Instance.new("TextLabel")
StaminaValue.Parent = StaminaFrame
StaminaValue.Position = UDim2.new(0, 150, 0, 0)
StaminaValue.Size = UDim2.new(0, 50, 0, 18)
StaminaValue.BackgroundTransparency = 1
StaminaValue.Font = Enum.Font.Gotham
StaminaValue.Text = "100/100"
StaminaValue.TextColor3 = _G.SecondaryColor
StaminaValue.TextSize = 10
StaminaValue.TextXAlignment = Enum.TextXAlignment.Right

-- XP Bar Section
local XpFrame = Instance.new("Frame")
XpFrame.Parent = PlayerInfoFrame
XpFrame.Position = UDim2.new(0, 15, 0, 235)
XpFrame.Size = UDim2.new(0, 200, 0, 35)
XpFrame.BackgroundTransparency = 1

local XpLabel = Instance.new("TextLabel")
XpLabel.Parent = XpFrame
XpLabel.Position = UDim2.new(0, 0, 0, 0)
XpLabel.Size = UDim2.new(0, 50, 0, 20)
XpLabel.BackgroundTransparency = 1
XpLabel.Font = Enum.Font.GothamBold
XpLabel.Text = "⭐ XP"
XpLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
XpLabel.TextSize = 11
XpLabel.TextXAlignment = Enum.TextXAlignment.Left

local XpBarBG = Instance.new("Frame")
XpBarBG.Parent = XpFrame
XpBarBG.Position = UDim2.new(0, 0, 0, 18)
XpBarBG.Size = UDim2.new(0, 200, 0, 12)
XpBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
XpBarBG.BorderSizePixel = 0

local XpBarBGCorner = Instance.new("UICorner")
XpBarBGCorner.CornerRadius = UDim.new(0, 6)
XpBarBGCorner.Parent = XpBarBG

local XpBarFill = Instance.new("Frame")
XpBarFill.Parent = XpBarBG
XpBarFill.Size = UDim2.new(0, 0, 0, 12)
XpBarFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
XpBarFill.BorderSizePixel = 0

local XpFillCorner = Instance.new("UICorner")
XpFillCorner.CornerRadius = UDim.new(0, 6)
XpFillCorner.Parent = XpBarFill

local XpValue = Instance.new("TextLabel")
XpValue.Parent = XpFrame
XpValue.Position = UDim2.new(0, 150, 0, 0)
XpValue.Size = UDim2.new(0, 50, 0, 18)
XpValue.BackgroundTransparency = 1
XpValue.Font = Enum.Font.Gotham
XpValue.Text = "0/0"
XpValue.TextColor3 = _G.SecondaryColor
XpValue.TextSize = 10
XpValue.TextXAlignment = Enum.TextXAlignment.Right

-- ========== FIXED UPDATE LOOP ==========
local function UpdateStats()
    pcall(function()
        local player = game.Players.LocalPlayer
        if player and player.Character then
            -- Update Level
            if player.Data and player.Data.Level then
                LevelText.Text = "Level: " .. player.Data.Level.Value
            end
            
            -- Update Race & Fruit
            if player.Data then
                local fruit = player.Data.DevilFruit and player.Data.DevilFruit.Value or "None"
                local race = player.Data.Race and player.Data.Race.Value or "None"
                RaceFruitText.Text = "🍎 Fruit: " .. fruit .. "\n👤 Race: " .. race
            end
            
            -- Update Health
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                local health = math.floor(humanoid.Health)
                local maxHealth = humanoid.MaxHealth
                local percent = health / maxHealth
                HealthBarFill.Size = UDim2.new(percent, 0, 0, 12)
                HealthValue.Text = math.floor(health) .. "/" .. math.floor(maxHealth)
                
                -- Change color based on health
                if percent < 0.3 then
                    HealthBarFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                elseif percent < 0.6 then
                    HealthBarFill.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
                else
                    HealthBarFill.BackgroundColor3 = _G.Color
                end
            end
            
            -- Update Stamina (if exists)
            local stamina = player.Character:FindFirstChild("Stamina")
            if stamina then
                local currentStam = stamina.Value
                local maxStam = stamina.MaxValue or 100
                local percent = currentStam / maxStam
                StaminaBarFill.Size = UDim2.new(percent, 0, 0, 12)
                StaminaValue.Text = math.floor(currentStam) .. "/" .. math.floor(maxStam)
            end
            
            -- Update XP (if in Blox Fruits)
            if player.Data and player.Data.Level then
                local currentXP = player.Data.Experience.Value or 0
                local neededXP = player.Data.Experience.Needed or 100
                local percent = currentXP / neededXP
                XpBarFill.Size = UDim2.new(percent, 0, 0, 12)
                XpValue.Text = math.floor(currentXP) .. "/" .. math.floor(neededXP)
            end
        end
    end)
end

-- Start update loop
spawn(function()
    while true do
        UpdateStats()
        wait(0.2)
    end
end)

-- ========== TAB SYSTEM ==========
local TopFrame = Instance.new("Frame")
TopFrame.Name = "TopFrame"
TopFrame.Parent = Main
TopFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopFrame.BackgroundTransparency = 0
TopFrame.Position = UDim2.new(0, 0, 0, 45)
TopFrame.Size = UDim2.new(0, 550, 0, 45)

local TabContainer2 = Instance.new("ScrollingFrame")
TabContainer2.Parent = TopFrame
TabContainer2.Position = UDim2.new(0, 10, 0, 5)
TabContainer2.Size = UDim2.new(0, 530, 0, 35)
TabContainer2.BackgroundTransparency = 1
TabContainer2.ScrollBarThickness = 0
TabContainer2.CanvasSize = UDim2.new(2, 0, 0, 0)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer2
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 10)

local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = Main
ContentFrame.Position = UDim2.new(0, 0, 0, 90)
ContentFrame.Size = UDim2.new(0, 550, 0, 290)
ContentFrame.BackgroundColor3 = _G.DarkColor
ContentFrame.BackgroundTransparency = 0

local tabs = {}
local S = false

function tabs:Tab(Name, icon)
local TabButton = Instance.new("TextButton")
TabButton.Parent = TabContainer2
TabButton.Size = UDim2.new(0, 100, 0, 30)
TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabButton.Text = Name
TabButton.TextColor3 = _G.SecondaryColor
TabButton.Font = Enum.Font.GothamBold
TabButton.TextSize = 13

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 6)
TabCorner.Parent = TabButton

local Page = Instance.new("ScrollingFrame")
Page.Parent = ContentFrame
Page.Size = UDim2.new(0, 540, 0, 280)
Page.Position = UDim2.new(0, 5, 0, 5)
Page.BackgroundTransparency = 1
Page.ScrollBarThickness = 6
Page.CanvasSize = UDim2.new(0, 0, 0, 0)
Page.Visible = false

local LeftSide = Instance.new("ScrollingFrame")
LeftSide.Parent = Page
LeftSide.Size = UDim2.new(0, 260, 0, 270)
LeftSide.Position = UDim2.new(0, 0, 0, 0)
LeftSide.BackgroundTransparency = 1
LeftSide.ScrollBarThickness = 0
LeftSide.CanvasSize = UDim2.new(0, 0, 0, 0)

local RightSide = Instance.new("ScrollingFrame")
RightSide.Parent = Page
RightSide.Size = UDim2.new(0, 260, 0, 270)
RightSide.Position = UDim2.new(0, 275, 0, 0)
RightSide.BackgroundTransparency = 1
RightSide.ScrollBarThickness = 0
RightSide.CanvasSize = UDim2.new(0, 0, 0, 0)

local LeftList = Instance.new("UIListLayout")
LeftList.Parent = LeftSide
LeftList.Padding = UDim.new(0, 8)
LeftList.SortOrder = Enum.SortOrder.LayoutOrder

local RightList = Instance.new("UIListLayout")
RightList.Parent = RightSide
RightList.Padding = UDim.new(0, 8)
RightList.SortOrder = Enum.SortOrder.LayoutOrder

LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    LeftSide.CanvasSize = UDim2.new(0, 0, 0, LeftList.AbsoluteContentSize.Y + 10)
end)

RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    RightSide.CanvasSize = UDim2.new(0, 0, 0, RightList.AbsoluteContentSize.Y + 10)
end)

if S == false then
    S = true
    Page.Visible = true
    TabButton.BackgroundColor3 = _G.Color
end

TabButton.MouseButton1Click:Connect(function()
    for _, child in pairs(TabContainer2:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end
    end
    for _, page in pairs(ContentFrame:GetChildren()) do
        if page:IsA("ScrollingFrame") then
            page.Visible = false
        end
    end
    TabButton.BackgroundColor3 = _G.Color
    Page.Visible = true
end)

local function GetSide(side)
    if side == 1 then return LeftSide
    elseif side == 2 then return RightSide
    else return LeftSide end
end

local sections = {}

function sections:CraftPage(side)
    local Section = Instance.new("Frame")
    local SectionCorner = Instance.new("UICorner")
    local SectionTitle = Instance.new("TextLabel")
    local SectionContainer = Instance.new("Frame")
    local ContainerLayout = Instance.new("UIListLayout")
    
    Section.Parent = GetSide(side)
    Section.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Section.Size = UDim2.new(0, 250, 0, 0)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionStroke = Instance.new("UIStroke")
    SectionStroke.Color = _G.Color
    SectionStroke.Thickness = 1
    SectionStroke.Transparency = 0.5
    SectionStroke.Parent = Section
    
    SectionTitle.Parent = Section
    SectionTitle.Size = UDim2.new(0, 250, 0, 30)
    SectionTitle.Position = UDim2.new(0, 0, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.Text = "Section"
    SectionTitle.TextColor3 = _G.Color
    SectionTitle.TextSize = 13
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Center
    
    SectionContainer.Parent = Section
    SectionContainer.Position = UDim2.new(0, 10, 0, 35)
    SectionContainer.Size = UDim2.new(0, 230, 0, 0)
    SectionContainer.BackgroundTransparency = 1
    SectionContainer.AutomaticSize = Enum.AutomaticSize.Y
    
    ContainerLayout.Parent = SectionContainer
    ContainerLayout.Padding = UDim.new(0, 8)
    ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local functionitem = {}
    
    function functionitem:Label(text)
        local label = Instance.new("TextLabel")
        label.Parent = SectionContainer
        label.Size = UDim2.new(0, 230, 0, 25)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = _G.SecondaryColor
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        return label
    end
    
    function functionitem:Button(text, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = SectionContainer
        btn.Size = UDim2.new(0, 230, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.Text = text
        btn.TextColor3 = _G.SecondaryColor
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            CircleClick(btn, Mouse.X, Mouse.Y)
            callback()
        end)
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end)
    end
    
    function functionitem:Toggle(text, default, callback)
        local toggled = default or false
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Parent = SectionContainer
        toggleFrame.Size = UDim2.new(0, 230, 0, 32)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleFrame
        
        local toggleText = Instance.new("TextLabel")
        toggleText.Parent = toggleFrame
        toggleText.Size = UDim2.new(0, 160, 0, 32)
        toggleText.Position = UDim2.new(0, 10, 0, 0)
        toggleText.BackgroundTransparency = 1
        toggleText.Font = Enum.Font.Gotham
        toggleText.Text = text
        toggleText.TextColor3 = _G.SecondaryColor
        toggleText.TextSize = 12
        toggleText.TextXAlignment = Enum.TextXAlignment.Left
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Parent = toggleFrame
        toggleButton.Size = UDim2.new(0, 50, 0, 26)
        toggleButton.Position = UDim2.new(0, 170, 0, 3)
        toggleButton.BackgroundColor3 = toggled and _G.Color or Color3.fromRGB(60, 60, 60)
        toggleButton.Text = toggled and "ON" or "OFF"
        toggleButton.TextColor3 = _G.SecondaryColor
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.TextSize = 11
        
        local toggleBtnCorner = Instance.new("UICorner")
        toggleBtnCorner.CornerRadius = UDim.new(0, 4)
        toggleBtnCorner.Parent = toggleButton
        
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            toggleButton.BackgroundColor3 = toggled and _G.Color or Color3.fromRGB(60, 60, 60)
            toggleButton.Text = toggled and "ON" or "OFF"
            callback(toggled)
        end)
        
        callback(toggled)
    end
    
    function functionitem:Slider(text, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = SectionContainer
        sliderFrame.Size = UDim2.new(0, 230, 0, 55)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 6)
        sliderCorner.Parent = sliderFrame
        
        local sliderText = Instance.new("TextLabel")
        sliderText.Parent = sliderFrame
        sliderText.Size = UDim2.new(0, 150, 0, 20)
        sliderText.Position = UDim2.new(0, 10, 0, 5)
        sliderText.BackgroundTransparency = 1
        sliderText.Font = Enum.Font.Gotham
        sliderText.Text = text
        sliderText.TextColor3 = _G.SecondaryColor
        sliderText.TextSize = 11
        sliderText.TextXAlignment = Enum.TextXAlignment.Left
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = sliderFrame
        valueLabel.Size = UDim2.new(0, 50, 0, 20)
        valueLabel.Position = UDim2.new(0, 170, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = _G.Color
        valueLabel.TextSize = 11
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        local sliderBar = Instance.new("Frame")
        sliderBar.Parent = sliderFrame
        sliderBar.Size = UDim2.new(0, 210, 0, 4)
        sliderBar.Position = UDim2.new(0, 10, 0, 35)
        sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        local sliderBarCorner = Instance.new("UICorner")
        sliderBarCorner.CornerRadius = UDim.new(0, 2)
        sliderBarCorner.Parent = sliderBar
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = sliderBar
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 0, 4)
        sliderFill.BackgroundColor3 = _G.Color
        
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(0, 2)
        sliderFillCorner.Parent = sliderFill
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Parent = sliderBar
        sliderButton.Size = UDim2.new(0, 12, 0, 12)
        sliderButton.Position = UDim2.new((default - min) / (max - min), -0.5, -0.4, 0)
        sliderButton.BackgroundColor3 = _G.Color
        sliderButton.Text = ""
        
        local sliderBtnCorner = Instance.new("UICorner")
        sliderBtnCorner.CornerRadius = UDim.new(0, 6)
        sliderBtnCorner.Parent = sliderButton
        
        local dragging = false
        
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            sliderFill.Size = UDim2.new(pos, 0, 0, 4)
            sliderButton.Position = UDim2.new(pos, -6, -0.4, 0)
            valueLabel.Text = tostring(value)
            callback(value)
        end
        
        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        sliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateSlider(input)
            end
        end)
        
        callback(default)
    end
    
    function functionitem:Textbox(text, placeholder, callback)
        local boxFrame = Instance.new("Frame")
        boxFrame.Parent = SectionContainer
        boxFrame.Size = UDim2.new(0, 230, 0, 55)
        boxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 6)
        boxCorner.Parent = boxFrame
        
        local boxText = Instance.new("TextLabel")
        boxText.Parent = boxFrame
        boxText.Size = UDim2.new(0, 150, 0, 20)
        boxText.Position = UDim2.new(0, 10, 0, 5)
        boxText.BackgroundTransparency = 1
        boxText.Font = Enum.Font.Gotham
        boxText.Text = text
        boxText.TextColor3 = _G.SecondaryColor
        boxText.TextSize = 11
        boxText.TextXAlignment = Enum.TextXAlignment.Left
        
        local textBox = Instance.new("TextBox")
        textBox.Parent = boxFrame
        textBox.Size = UDim2.new(0, 210, 0, 28)
        textBox.Position = UDim2.new(0, 10, 0, 25)
        textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        textBox.PlaceholderText = placeholder
        textBox.Text = ""
        textBox.TextColor3 = _G.SecondaryColor
        textBox.Font = Enum.Font.Gotham
        textBox.TextSize = 12
        
        local textBoxCorner = Instance.new("UICorner")
        textBoxCorner.CornerRadius = UDim.new(0, 4)
        textBoxCorner.Parent = textBox
        
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and textBox.Text ~= "" then
                callback(textBox.Text)
                textBox.Text = ""
            end
        end)
    end
    
    return functionitem
end

dragify(ClickFrame, Main)

return {
    Tab = tabs.Tab,
    CraftPage = sections.CraftPage
}
end

return library
