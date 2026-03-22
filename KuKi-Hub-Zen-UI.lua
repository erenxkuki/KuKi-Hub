do
local ui = game:GetService("CoreGui"):FindFirstChild("KuKiHub")
if ui then
ui:Destroy()
end
end

-- ==================== CONFIGURATION ====================
_G.Theme = {
    MainColor = Color3.fromRGB(255, 60, 60),     -- Bright Red
    AccentColor = Color3.fromRGB(220, 40, 40),   -- Dark Red
    WhiteColor = Color3.fromRGB(255, 255, 255),  -- Pure White
    DarkColor = Color3.fromRGB(20, 20, 22),      -- Almost Black
    GrayColor = Color3.fromRGB(35, 35, 40),      -- Dark Gray
    TextColor = Color3.fromRGB(245, 245, 245),   -- Off White
    LogoAsset = "rbxassetid://129872344726942"   -- Your logo asset ID
}

local UIConfig = {
    Bind = Enum.KeyCode.RightControl,
    OpenState = false
}

-- Generate random string for GUI
local randomString = ""
local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
math.randomseed(os.time())
for i = 1, 20 do
    randomString = randomString .. chars:sub(math.random(1, #chars), math.random(1, #chars))
end

-- Clean up existing GUI
for i, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "KuKiHub" or (v.Name:find("KuKi") and v:IsA("ScreenGui")) then
        v:Destroy()
    end
end

-- Services
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==================== CREATE MAIN GUI ====================
local GUI = Instance.new("ScreenGui")
GUI.Name = "KuKiHub"
GUI.Parent = game.CoreGui
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn then syn.protect_gui(GUI) end

-- ==================== MAIN WINDOW ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = GUI
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = _G.Theme.DarkColor
MainFrame.BackgroundTransparency = 0
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = _G.Theme.MainColor
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- ==================== HEADER ====================
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = _G.Theme.MainColor

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "KuKi"
Title.TextColor3 = _G.Theme.WhiteColor
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Header
Subtitle.Size = UDim2.new(0, 200, 1, 0)
Subtitle.Position = UDim2.new(0, 85, 0, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Hub"
Subtitle.TextColor3 = _G.Theme.WhiteColor
Subtitle.TextSize = 20
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.TextTransparency = 0.3

-- Logo (Your asset ID)
local Logo = Instance.new("ImageLabel")
Logo.Parent = Header
Logo.Size = UDim2.new(0, 35, 0, 35)
Logo.Position = UDim2.new(1, -45, 0, 7.5)
Logo.BackgroundTransparency = 1
Logo.Image = _G.Theme.LogoAsset
Logo.ScaleType = Enum.ScaleType.Fit

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 8)
LogoCorner.Parent = Logo

-- Close Button
local CloseBtn = Instance.new("ImageButton")
CloseBtn.Parent = Header
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Image = "rbxassetid://6023426926"
CloseBtn.ImageColor3 = _G.Theme.WhiteColor

-- Minimize Button
local MinBtn = Instance.new("ImageButton")
MinBtn.Parent = Header
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0, 10)
MinBtn.BackgroundTransparency = 1
MinBtn.Image = "rbxassetid://6031086138"
MinBtn.ImageColor3 = _G.Theme.WhiteColor

-- Drag Handle
local DragHandle = Instance.new("Frame")
DragHandle.Parent = Header
DragHandle.Size = UDim2.new(1, -100, 1, 0)
DragHandle.Position = UDim2.new(0, 0, 0, 0)
DragHandle.BackgroundTransparency = 1

-- ==================== DRAG FUNCTION ====================
local dragging = false
local dragStart = nil
local startPos = nil

DragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ==================== SIDE PANEL (Player Info) ====================
local SidePanel = Instance.new("Frame")
SidePanel.Parent = MainFrame
SidePanel.Size = UDim2.new(0, 260, 1, -50)
SidePanel.Position = UDim2.new(0, -270, 0, 50)
SidePanel.BackgroundColor3 = _G.Theme.GrayColor
SidePanel.BackgroundTransparency = 0
SidePanel.ClipsDescendants = true

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 8)
SideCorner.Parent = SidePanel

local SideStroke = Instance.new("UIStroke")
SideStroke.Color = _G.Theme.MainColor
SideStroke.Thickness = 1
SideStroke.Transparency = 0.5
SideStroke.Parent = SidePanel

-- Menu Button (toggle side panel)
local MenuBtn = Instance.new("ImageButton")
MenuBtn.Parent = Header
MenuBtn.Size = UDim2.new(0, 30, 0, 30)
MenuBtn.Position = UDim2.new(0, 10, 0, 10)
MenuBtn.BackgroundTransparency = 1
MenuBtn.Image = "rbxassetid://14479606771"
MenuBtn.ImageColor3 = _G.Theme.WhiteColor

local panelOpen = false
MenuBtn.MouseButton1Click:Connect(function()
    panelOpen = not panelOpen
    TweenService:Create(SidePanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = panelOpen and UDim2.new(0, 10, 0, 50) or UDim2.new(0, -270, 0, 50)
    }):Play()
end)

-- ==================== PLAYER INFO PANEL ====================
local PlayerPanel = Instance.new("Frame")
PlayerPanel.Parent = SidePanel
PlayerPanel.Size = UDim2.new(1, -20, 1, -20)
PlayerPanel.Position = UDim2.new(0, 10, 0, 10)
PlayerPanel.BackgroundColor3 = _G.Theme.DarkColor

local PlayerCorner = Instance.new("UICorner")
PlayerCorner.CornerRadius = UDim.new(0, 8)
PlayerCorner.Parent = PlayerPanel

-- Avatar
local Avatar = Instance.new("ImageLabel")
Avatar.Parent = PlayerPanel
Avatar.Size = UDim2.new(0, 70, 0, 70)
Avatar.Position = UDim2.new(0, 15, 0, 15)
Avatar.BackgroundColor3 = _G.Theme.GrayColor
Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 35)
AvatarCorner.Parent = Avatar

-- Player Name
local PlayerName = Instance.new("TextLabel")
PlayerName.Parent = PlayerPanel
PlayerName.Size = UDim2.new(0, 160, 0, 25)
PlayerName.Position = UDim2.new(0, 95, 0, 20)
PlayerName.BackgroundTransparency = 1
PlayerName.Text = LocalPlayer.Name
PlayerName.TextColor3 = _G.Theme.WhiteColor
PlayerName.TextSize = 14
PlayerName.Font = Enum.Font.GothamBold
PlayerName.TextXAlignment = Enum.TextXAlignment.Left

-- Display Name
local DisplayName = Instance.new("TextLabel")
DisplayName.Parent = PlayerPanel
DisplayName.Size = UDim2.new(0, 160, 0, 18)
DisplayName.Position = UDim2.new(0, 95, 0, 45)
DisplayName.BackgroundTransparency = 1
DisplayName.Text = "@" .. LocalPlayer.DisplayName
DisplayName.TextColor3 = _G.Theme.MainColor
DisplayName.TextSize = 11
DisplayName.Font = Enum.Font.Gotham
DisplayName.TextXAlignment = Enum.TextXAlignment.Left
DisplayName.TextTransparency = 0.5

-- Level
local LevelText = Instance.new("TextLabel")
LevelText.Parent = PlayerPanel
LevelText.Size = UDim2.new(0, 220, 0, 20)
LevelText.Position = UDim2.new(0, 15, 0, 95)
LevelText.BackgroundTransparency = 1
LevelText.Text = "Level: Loading..."
LevelText.TextColor3 = _G.Theme.TextColor
LevelText.TextSize = 12
LevelText.Font = Enum.Font.Gotham
LevelText.TextXAlignment = Enum.TextXAlignment.Left

-- Race & Fruit
local InfoText = Instance.new("TextLabel")
InfoText.Parent = PlayerPanel
InfoText.Size = UDim2.new(0, 220, 0, 35)
InfoText.Position = UDim2.new(0, 15, 0, 118)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Loading..."
InfoText.TextColor3 = _G.Theme.TextColor
InfoText.TextSize = 11
InfoText.Font = Enum.Font.Gotham
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextWrapped = true

-- Health Bar
local HealthFrame = Instance.new("Frame")
HealthFrame.Parent = PlayerPanel
HealthFrame.Position = UDim2.new(0, 15, 0, 160)
HealthFrame.Size = UDim2.new(0, 220, 0, 35)
HealthFrame.BackgroundTransparency = 1

local HealthLabel = Instance.new("TextLabel")
HealthLabel.Parent = HealthFrame
HealthLabel.Size = UDim2.new(0, 60, 0, 18)
HealthLabel.BackgroundTransparency = 1
HealthLabel.Text = "❤️ Health"
HealthLabel.TextColor3 = _G.Theme.MainColor
HealthLabel.TextSize = 11
HealthLabel.Font = Enum.Font.GothamBold
HealthLabel.TextXAlignment = Enum.TextXAlignment.Left

local HealthValue = Instance.new("TextLabel")
HealthValue.Parent = HealthFrame
HealthValue.Size = UDim2.new(0, 60, 0, 18)
HealthValue.Position = UDim2.new(1, -60, 0, 0)
HealthValue.BackgroundTransparency = 1
HealthValue.Text = "100/100"
HealthValue.TextColor3 = _G.Theme.WhiteColor
HealthValue.TextSize = 11
HealthValue.Font = Enum.Font.Gotham
HealthValue.TextXAlignment = Enum.TextXAlignment.Right

local HealthBarBG = Instance.new("Frame")
HealthBarBG.Parent = HealthFrame
HealthBarBG.Position = UDim2.new(0, 0, 0, 20)
HealthBarBG.Size = UDim2.new(1, 0, 0, 8)
HealthBarBG.BackgroundColor3 = _G.Theme.GrayColor

local HealthBarBGCorner = Instance.new("UICorner")
HealthBarBGCorner.CornerRadius = UDim.new(0, 4)
HealthBarBGCorner.Parent = HealthBarBG

local HealthFill = Instance.new("Frame")
HealthFill.Parent = HealthBarBG
HealthFill.Size = UDim2.new(1, 0, 1, 0)
HealthFill.BackgroundColor3 = _G.Theme.MainColor

local HealthFillCorner = Instance.new("UICorner")
HealthFillCorner.CornerRadius = UDim.new(0, 4)
HealthFillCorner.Parent = HealthFill

-- Stamina Bar
local StaminaFrame = Instance.new("Frame")
StaminaFrame.Parent = PlayerPanel
StaminaFrame.Position = UDim2.new(0, 15, 0, 200)
StaminaFrame.Size = UDim2.new(0, 220, 0, 35)
StaminaFrame.BackgroundTransparency = 1

local StaminaLabel = Instance.new("TextLabel")
StaminaLabel.Parent = StaminaFrame
StaminaLabel.Size = UDim2.new(0, 60, 0, 18)
StaminaLabel.BackgroundTransparency = 1
StaminaLabel.Text = "⚡ Stamina"
StaminaLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
StaminaLabel.TextSize = 11
StaminaLabel.Font = Enum.Font.GothamBold
StaminaLabel.TextXAlignment = Enum.TextXAlignment.Left

local StaminaValue = Instance.new("TextLabel")
StaminaValue.Parent = StaminaFrame
StaminaValue.Size = UDim2.new(0, 60, 0, 18)
StaminaValue.Position = UDim2.new(1, -60, 0, 0)
StaminaValue.BackgroundTransparency = 1
StaminaValue.Text = "100/100"
StaminaValue.TextColor3 = _G.Theme.WhiteColor
StaminaValue.TextSize = 11
StaminaValue.Font = Enum.Font.Gotham
StaminaValue.TextXAlignment = Enum.TextXAlignment.Right

local StaminaBarBG = Instance.new("Frame")
StaminaBarBG.Parent = StaminaFrame
StaminaBarBG.Position = UDim2.new(0, 0, 0, 20)
StaminaBarBG.Size = UDim2.new(1, 0, 0, 8)
StaminaBarBG.BackgroundColor3 = _G.Theme.GrayColor

local StaminaBarBGCorner = Instance.new("UICorner")
StaminaBarBGCorner.CornerRadius = UDim.new(0, 4)
StaminaBarBGCorner.Parent = StaminaBarBG

local StaminaFill = Instance.new("Frame")
StaminaFill.Parent = StaminaBarBG
StaminaFill.Size = UDim2.new(1, 0, 1, 0)
StaminaFill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)

local StaminaFillCorner = Instance.new("UICorner")
StaminaFillCorner.CornerRadius = UDim.new(0, 4)
StaminaFillCorner.Parent = StaminaFill

-- XP Bar
local XpFrame = Instance.new("Frame")
XpFrame.Parent = PlayerPanel
XpFrame.Position = UDim2.new(0, 15, 0, 240)
XpFrame.Size = UDim2.new(0, 220, 0, 35)
XpFrame.BackgroundTransparency = 1

local XpLabel = Instance.new("TextLabel")
XpLabel.Parent = XpFrame
XpLabel.Size = UDim2.new(0, 60, 0, 18)
XpLabel.BackgroundTransparency = 1
XpLabel.Text = "⭐ XP"
XpLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
XpLabel.TextSize = 11
XpLabel.Font = Enum.Font.GothamBold
XpLabel.TextXAlignment = Enum.TextXAlignment.Left

local XpValue = Instance.new("TextLabel")
XpValue.Parent = XpFrame
XpValue.Size = UDim2.new(0, 80, 0, 18)
XpValue.Position = UDim2.new(1, -80, 0, 0)
XpValue.BackgroundTransparency = 1
XpValue.Text = "0/0"
XpValue.TextColor3 = _G.Theme.WhiteColor
XpValue.TextSize = 10
XpValue.Font = Enum.Font.Gotham
XpValue.TextXAlignment = Enum.TextXAlignment.Right

local XpBarBG = Instance.new("Frame")
XpBarBG.Parent = XpFrame
XpBarBG.Position = UDim2.new(0, 0, 0, 20)
XpBarBG.Size = UDim2.new(1, 0, 0, 8)
XpBarBG.BackgroundColor3 = _G.Theme.GrayColor

local XpBarBGCorner = Instance.new("UICorner")
XpBarBGCorner.CornerRadius = UDim.new(0, 4)
XpBarBGCorner.Parent = XpBarBG

local XpFill = Instance.new("Frame")
XpFill.Parent = XpBarBG
XpFill.Size = UDim2.new(0, 0, 1, 0)
XpFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)

local XpFillCorner = Instance.new("UICorner")
XpFillCorner.CornerRadius = UDim.new(0, 4)
XpFillCorner.Parent = XpFill

-- ==================== TAB SYSTEM ====================
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.Size = UDim2.new(1, -280, 0, 45)
TabBar.Position = UDim2.new(0, 280, 0, 50)
TabBar.BackgroundColor3 = _G.Theme.GrayColor

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabBar

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Parent = TabBar
TabContainer.Size = UDim2.new(1, -20, 1, -10)
TabContainer.Position = UDim2.new(0, 10, 0, 5)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.CanvasSize = UDim2.new(2, 0, 0, 0)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -280, 1, -105)
ContentArea.Position = UDim2.new(0, 280, 0, 100)
ContentArea.BackgroundColor3 = _G.Theme.DarkColor

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentArea

-- ==================== UPDATE LOOP ====================
local function UpdateStats()
    pcall(function()
        local player = LocalPlayer
        if player and player.Character then
            -- Level
            if player.Data and player.Data.Level then
                LevelText.Text = "📊 Level: " .. player.Data.Level.Value
            end
            
            -- Race & Fruit
            if player.Data then
                local fruit = player.Data.DevilFruit and player.Data.DevilFruit.Value or "None"
                local race = player.Data.Race and player.Data.Race.Value or "None"
                InfoText.Text = "🍎 Fruit: " .. fruit .. "\n👤 Race: " .. race
            end
            
            -- Health
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                local health = humanoid.Health
                local maxHealth = humanoid.MaxHealth
                local percent = health / maxHealth
                HealthFill.Size = UDim2.new(percent, 0, 1, 0)
                HealthValue.Text = math.floor(health) .. "/" .. math.floor(maxHealth)
                
                if percent < 0.3 then
                    HealthFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                elseif percent < 0.6 then
                    HealthFill.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
                else
                    HealthFill.BackgroundColor3 = _G.Theme.MainColor
                end
            end
            
            -- Stamina
            local stamina = player.Character:FindFirstChild("Stamina")
            if stamina then
                local current = stamina.Value
                local maxStam = stamina.MaxValue or 100
                StaminaFill.Size = UDim2.new(current / maxStam, 0, 1, 0)
                StaminaValue.Text = math.floor(current) .. "/" .. math.floor(maxStam)
            end
            
            -- XP
            if player.Data and player.Data.Experience then
                local currentXP = player.Data.Experience.Value
                local neededXP = player.Data.Experience.Needed or 100
                XpFill.Size = UDim2.new(currentXP / neededXP, 0, 1, 0)
                XpValue.Text = math.floor(currentXP) .. "/" .. math.floor(neededXP)
            end
        end
    end)
end

spawn(function()
    while true do
        UpdateStats()
        wait(0.2)
    end
end)

-- ==================== TAB SYSTEM FUNCTIONS ====================
local tabs = {}
local currentTab = nil

function tabs:Tab(name, icon)
    local button = Instance.new("TextButton")
    button.Parent = TabContainer
    button.Size = UDim2.new(0, 100, 1, 0)
    button.BackgroundColor3 = _G.Theme.DarkColor
    button.Text = name
    button.TextColor3 = _G.Theme.WhiteColor
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button
    
    local page = Instance.new("ScrollingFrame")
    page.Parent = ContentArea
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    
    local leftSide = Instance.new("ScrollingFrame")
    leftSide.Parent = page
    leftSide.Size = UDim2.new(0, 260, 1, 0)
    leftSide.BackgroundTransparency = 1
    leftSide.ScrollBarThickness = 0
    leftSide.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local rightSide = Instance.new("ScrollingFrame")
    rightSide.Parent = page
    rightSide.Size = UDim2.new(0, 260, 1, 0)
    rightSide.Position = UDim2.new(0, 275, 0, 0)
    rightSide.BackgroundTransparency = 1
    rightSide.ScrollBarThickness = 0
    rightSide.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local leftLayout = Instance.new("UIListLayout")
    leftLayout.Parent = leftSide
    leftLayout.Padding = UDim.new(0, 10)
    leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local rightLayout = Instance.new("UIListLayout")
    rightLayout.Parent = rightSide
    rightLayout.Padding = UDim.new(0, 10)
    rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        leftSide.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 10)
    end)
    
    rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        rightSide.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 10)
    end)
    
    if not currentTab then
        currentTab = page
        page.Visible = true
        button.BackgroundColor3 = _G.Theme.MainColor
    end
    
    button.MouseButton1Click:Connect(function()
        for _, btn in pairs(TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = _G.Theme.DarkColor
            end
        end
        for _, pg in pairs(ContentArea:GetChildren()) do
            if pg:IsA("ScrollingFrame") then
                pg.Visible = false
            end
        end
        button.BackgroundColor3 = _G.Theme.MainColor
        page.Visible = true
    end)
    
    local function GetSide(side)
        return side == 2 and rightSide or leftSide
    end
    
    local sections = {}
    
    function sections:CraftPage(side)
        local section = Instance.new("Frame")
        section.Parent = GetSide(side)
        section.Size = UDim2.new(1, 0, 0, 0)
        section.BackgroundColor3 = _G.Theme.GrayColor
        section.AutomaticSize = Enum.AutomaticSize.Y
        section.BackgroundTransparency = 0
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 8)
        sectionCorner.Parent = section
        
        local sectionStroke = Instance.new("UIStroke")
        sectionStroke.Color = _G.Theme.MainColor
        sectionStroke.Thickness = 1
        sectionStroke.Transparency = 0.5
        sectionStroke.Parent = section
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Parent = section
        sectionTitle.Size = UDim2.new(1, 0, 0, 35)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Text = "Section"
        sectionTitle.TextColor3 = _G.Theme.MainColor
        sectionTitle.TextSize = 14
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Center
        
        local container = Instance.new("Frame")
        container.Parent = section
        container.Position = UDim2.new(0, 12, 0, 35)
        container.Size = UDim2.new(1, -24, 0, 0)
        container.BackgroundTransparency = 1
        container.AutomaticSize = Enum.AutomaticSize.Y
        
        local containerLayout = Instance.new("UIListLayout")
        containerLayout.Parent = container
        containerLayout.Padding = UDim.new(0, 8)
        containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            section.Size = UDim2.new(1, 0, 0, containerLayout.AbsoluteContentSize.Y + 45)
        end)
        
        local items = {}
        
        function items:Label(text)
            local label = Instance.new("TextLabel")
            label.Parent = container
            label.Size = UDim2.new(1, 0, 0, 28)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = _G.Theme.TextColor
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            return label
        end
        
        function items:Seperator(text)
            local frame = Instance.new("Frame")
            frame.Parent = container
            frame.Size = UDim2.new(1, 0, 0, 30)
            frame.BackgroundTransparency = 1
            
            local leftLine = Instance.new("Frame")
            leftLine.Parent = frame
            leftLine.Size = UDim2.new(0, 80, 0, 2)
            leftLine.Position = UDim2.new(0, 0, 0.5, 0)
            leftLine.BackgroundColor3 = _G.Theme.MainColor
            leftLine.AnchorPoint = Vector2.new(0, 0.5)
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(0, 80, 0, 30)
            label.Position = UDim2.new(0.5, -40, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = _G.Theme.WhiteColor
            label.TextSize = 11
            label.Font = Enum.Font.Gotham
            
            local rightLine = Instance.new("Frame")
            rightLine.Parent = frame
            rightLine.Size = UDim2.new(0, 80, 0, 2)
            rightLine.Position = UDim2.new(1, -80, 0.5, 0)
            rightLine.BackgroundColor3 = _G.Theme.MainColor
            rightLine.AnchorPoint = Vector2.new(1, 0.5)
        end
        
        function items:Button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Parent = container
            btn.Size = UDim2.new(1, 0, 0, 38)
            btn.BackgroundColor3 = _G.Theme.DarkColor
            btn.Text = text
            btn.TextColor3 = _G.Theme.WhiteColor
            btn.TextSize = 13
            btn.Font = Enum.Font.GothamBold
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                CircleClick(btn, Mouse.X, Mouse.Y)
                callback()
            end)
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = _G.Theme.MainColor}):Play()
            end)
            
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = _G.Theme.DarkColor}):Play()
            end)
        end
        
        function items:Toggle(text, default, callback)
            local toggled = default or false
            local frame = Instance.new("Frame")
            frame.Parent = container
            frame.Size = UDim2.new(1, 0, 0, 42)
            frame.BackgroundColor3 = _G.Theme.DarkColor
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(0, 150, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = _G.Theme.WhiteColor
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Parent = frame
            toggleBtn.Size = UDim2.new(0, 60, 0, 30)
            toggleBtn.Position = UDim2.new(1, -72, 0.5, -15)
            toggleBtn.BackgroundColor3 = toggled and _G.Theme.MainColor or _G.Theme.GrayColor
            toggleBtn.Text = toggled and "ON" or "OFF"
            toggleBtn.TextColor3 = _G.Theme.WhiteColor
            toggleBtn.TextSize = 12
            toggleBtn.Font = Enum.Font.GothamBold
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 4)
            toggleCorner.Parent = toggleBtn
            
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggleBtn.BackgroundColor3 = toggled and _G.Theme.MainColor or _G.Theme.GrayColor
                toggleBtn.Text = toggled and "ON" or "OFF"
                callback(toggled)
            end)
            
            callback(toggled)
        end
        
        function items:Slider(text, min, max, default, callback)
            local value = default or min
            local frame = Instance.new("Frame")
            frame.Parent = container
            frame.Size = UDim2.new(1, 0, 0, 65)
            frame.BackgroundColor3 = _G.Theme.DarkColor
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(0, 150, 0, 25)
            label.Position = UDim2.new(0, 12, 0, 8)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = _G.Theme.WhiteColor
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = frame
            valueLabel.Size = UDim2.new(0, 50, 0, 25)
            valueLabel.Position = UDim2.new(1, -62, 0, 8)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = _G.Theme.MainColor
            valueLabel.TextSize = 12
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local barBg = Instance.new("Frame")
            barBg.Parent = frame
            barBg.Size = UDim2.new(1, -24, 0, 4)
            barBg.Position = UDim2.new(0, 12, 0, 42)
            barBg.BackgroundColor3 = _G.Theme.GrayColor
            
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(0, 2)
            barCorner.Parent = barBg
            
            local fill = Instance.new("Frame")
            fill.Parent = barBg
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = _G.Theme.MainColor
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 2)
            fillCorner.Parent = fill
            
            local handle = Instance.new("TextButton")
            handle.Parent = barBg
            handle.Size = UDim2.new(0, 14, 0, 14)
            handle.Position = UDim2.new((default - min) / (max - min), -7, -0.35, 0)
            handle.BackgroundColor3 = _G.Theme.MainColor
            handle.Text = ""
            
            local handleCorner = Instance.new("UICorner")
            handleCorner.CornerRadius = UDim.new(0, 7)
            handleCorner.Parent = handle
            
            local dragging = false
            
            local function update(pos)
                local percent = math.clamp((pos.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                local newValue = math.floor(min + (max - min) * percent)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                handle.Position = UDim2.new(percent, -7, -0.35, 0)
                valueLabel.Text = tostring(newValue)
                callback(newValue)
            end
            
            handle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            handle.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            barBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    update(input)
                end
            end)
            
            UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
            
            callback(default)
        end
        
        function items:Textbox(text, placeholder, callback)
            local frame = Instance.new("Frame")
            frame.Parent = container
            frame.Size = UDim2.new(1, 0, 0, 70)
            frame.BackgroundColor3 = _G.Theme.DarkColor
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(1, -24, 0, 25)
            label.Position = UDim2.new(0, 12, 0, 8)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = _G.Theme.WhiteColor
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local box = Instance.new("TextBox")
            box.Parent = frame
            box.Size = UDim2.new(1, -24, 0, 32)
            box.Position = UDim2.new(0, 12, 0, 35)
            box.BackgroundColor3 = _G.Theme.GrayColor
            box.PlaceholderText = placeholder
            box.Text = ""
            box.TextColor3 = _G.Theme.WhiteColor
            box.Font = Enum.Font.Gotham
            box.TextSize = 12
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 6)
            boxCorner.Parent = box
            
            box.FocusLost:Connect(function(enterPressed)
                if enterPressed and box.Text ~= "" then
                    callback(box.Text)
                    box.Text = ""
                end
            end)
        end
        
        function items:Dropdown(text, options, default, callback)
            local isOpen = false
            local selected = default or options[1]
            
            local frame = Instance.new("Frame")
            frame.Parent = container
            frame.Size = UDim2.new(1, 0, 0, 40)
            frame.BackgroundColor3 = _G.Theme.DarkColor
            frame.AutomaticSize = Enum.AutomaticSize.Y
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(0, 100, 0, 40)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text .. ":"
            label.TextColor3 = _G.Theme.WhiteColor
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local selectedBtn = Instance.new("TextButton")
            selectedBtn.Parent = frame
            selectedBtn.Size = UDim2.new(0, 120, 0, 32)
            selectedBtn.Position = UDim2.new(1, -132, 0, 4)
            selectedBtn.BackgroundColor3 = _G.Theme.GrayColor
            selectedBtn.Text = selected
            selectedBtn.TextColor3 = _G.Theme.WhiteColor
            selectedBtn.TextSize = 12
            
            local selectedCorner = Instance.new("UICorner")
            selectedCorner.CornerRadius = UDim.new(0, 6)
            selectedCorner.Parent = selectedBtn
            
            local dropdownMenu = Instance.new("ScrollingFrame")
            dropdownMenu.Parent = frame
            dropdownMenu.Size = UDim2.new(0, 120, 0, 0)
            dropdownMenu.Position = UDim2.new(1, -132, 0, 38)
            dropdownMenu.BackgroundColor3 = _G.Theme.GrayColor
            dropdownMenu.BackgroundTransparency = 1
            dropdownMenu.ScrollBarThickness = 4
            dropdownMenu.Visible = false
            dropdownMenu.CanvasSize = UDim2.new(0, 0, 0, 0)
            
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 6)
            dropdownCorner.Parent = dropdownMenu
            
            local dropdownLayout = Instance.new("UIListLayout")
            dropdownLayout.Parent = dropdownMenu
            dropdownLayout.Padding = UDim.new(0, 2)
            
            for _, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Parent = dropdownMenu
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.BackgroundColor3 = _G.Theme.DarkColor
                optBtn.Text = opt
                optBtn.TextColor3 = _G.Theme.WhiteColor
                optBtn.TextSize = 11
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 4)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    selected = opt
                    selectedBtn.Text = opt
                    callback(opt)
                    isOpen = false
                    TweenService:Create(dropdownMenu, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 0, 0)}):Play()
                    wait(0.2)
                    dropdownMenu.Visible = false
                end)
                
                optBtn.MouseEnter:Connect(function()
                    optBtn.BackgroundColor3 = _G.Theme.MainColor
                end)
                
                optBtn.MouseLeave:Connect(function()
                    optBtn.BackgroundColor3 = _G.Theme.DarkColor
                end)
            end
            
            dropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                dropdownMenu.CanvasSize = UDim2.new(0, 0, 0, dropdownLayout.AbsoluteContentSize.Y + 10)
            end)
            
            selectedBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    dropdownMenu.Visible = true
                    local height = math.min(dropdownLayout.AbsoluteContentSize.Y + 10, 150)
                    TweenService:Create(dropdownMenu, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 0, height)}):Play()
                else
                    TweenService:Create(dropdownMenu, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 0, 0)}):Play()
                    wait(0.2)
                    dropdownMenu.Visible = false
                end
            end)
            
            callback(selected)
        end
        
        return items
    end
    
    return sections
end

-- ==================== CIRCLE CLICK EFFECT ====================
function CircleClick(btn, x, y)
    local circle = Instance.new("ImageLabel")
    circle.Parent = btn
    circle.Size = UDim2.new(0, 0, 0, 0)
    circle.Position = UDim2.new(0, x - btn.AbsolutePosition.X, 0, y - btn.AbsolutePosition.Y)
    circle.BackgroundTransparency = 1
    circle.Image = "rbxassetid://14346331443"
    circle.ImageColor3 = _G.Theme.WhiteColor
    circle.ImageTransparency = 0.5
    circle.ZIndex = 10
    
    TweenService:Create(circle, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, x - btn.AbsolutePosition.X - 25, 0, y - btn.AbsolutePosition.Y - 25),
        ImageTransparency = 1
    }):Play()
    
    wait(0.3)
    circle:Destroy()
end

-- ==================== TOGGLE GUI ====================
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == UIConfig.Bind then
        UIConfig.OpenState = not UIConfig.OpenState
        if UIConfig.OpenState then
            MainFrame:TweenSize(UDim2.new(0, 800, 0, 550), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.4, true)
        else
            MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.4, true)
        end
    end
end)

-- Close button
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
    UIConfig.OpenState = false
end)

-- Minimize button
MinBtn.MouseButton1Click:Connect(function()
    MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
    UIConfig.OpenState = false
end)

-- Animate open
MainFrame:TweenSize(UDim2.new(0, 800, 0, 550), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)

-- ==================== RETURN LIBRARY ====================
local KuKiLib = {
    Tab = function(...) return tabs.Tab(...) end,
    CraftPage = function(...) 
        local tab = tabs.Tab("temp", 0)
        return tab.CraftPage(...)
    end
}

-- Auto-open side panel
wait(0.5)
panelOpen = true
SidePanel.Position = UDim2.new(0, 10, 0, 50)

print("KuKi Hub Loaded! Press RightControl to toggle GUI")

return KuKiLib
