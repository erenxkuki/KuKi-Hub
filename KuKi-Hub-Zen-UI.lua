do
local ui = game:GetService("CoreGui"):FindFirstChild("KuKiHub")
if ui then
ui:Destroy()
end
end

-- Theme colors (Red, White, Black)
_G.Color = Color3.fromRGB(255, 50, 50) -- Main Red
_G.SecondaryColor = Color3.fromRGB(255, 255, 255) -- White
_G.DarkColor = Color3.fromRGB(18, 18, 18) -- Darker Black
_G.AccentColor = Color3.fromRGB(220, 40, 40) -- Dark Red

-- Generate random string for GUI
local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local length = 20
local randomString = ""
math.randomseed(os.time())
local charTable = {}
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
if v1.Name == "KuKiMain" then
v1:Destroy()
end
end
end
end

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

-- Create main GUI
local UI = Instance.new("ScreenGui")
UI.Name = randomString
UI.Parent = game.CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.Name = "KuKiHub"

if syn then
syn.protect_gui(UI)
end

-- ==================== CREATE MAIN WINDOW ====================
local Main = Instance.new("Frame")
Main.Name = "KuKiMain"
Main.Parent = UI
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3 = _G.DarkColor
Main.Size = UDim2.new(0, 550, 0, 400)
Main.ClipsDescendants = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundTransparency = 0

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = _G.Color
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

-- Toggle GUI with RightControl
local uitoggled = false
UserInputService.InputBegan:Connect(
    function(io, p)
    if io.KeyCode == Enum.KeyCode.RightControl then
    if uitoggled == false then
    Main:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    uitoggled = true
    wait()
    UI.Enabled = false
    else
        Main:TweenSize(
        UDim2.new(0, 550, 0, 400),
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

-- ==================== HEADER ====================
local HeaderTop = Instance.new("Frame")
HeaderTop.Name = "Header"
HeaderTop.Parent = Main
HeaderTop.BackgroundColor3 = _G.Color
HeaderTop.BackgroundTransparency = 0
HeaderTop.Position = UDim2.new(0, 0, 0, 0)
HeaderTop.Size = UDim2.new(0, 550, 0, 45)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = HeaderTop

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = HeaderTop
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0.03, 0, 0.1, 0)
Title.Size = UDim2.new(0, 483, 0, 31)
Title.Font = Enum.Font.GothamBold
Title.Text = "KuKi".."<font color='rgb(255, 50, 50)'> Hub</font>".." | Blox Fruits"
Title.RichText = true;
Title.TextColor3 = _G.SecondaryColor
Title.TextSize = 15.000
Title.TextWrapped = true
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Logo
local LogoImage = Instance.new("ImageLabel")
LogoImage.Parent = HeaderTop
LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LogoImage.BackgroundTransparency = 1.000
LogoImage.Position = UDim2.new(0.93, 0, 0.08, 0)
LogoImage.Size = UDim2.new(0, 32, 0, 32)
LogoImage.Image = "rbxassetid://6031086138"
LogoImage.ImageColor3 = _G.SecondaryColor
LogoImage.ScaleType = Enum.ScaleType.Fit

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 16)
LogoCorner.Parent = LogoImage

-- Menu Button
local MenuButton = Instance.new("ImageButton")
MenuButton.Parent = HeaderTop
MenuButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MenuButton.BackgroundTransparency = 1
MenuButton.Position = UDim2.new(0, 515, 0, 10)
MenuButton.Size = UDim2.new(0, 25, 0, 25)
MenuButton.Image = "http://www.roblox.com/asset/?id=14479606771"
MenuButton.ImageColor3 = _G.SecondaryColor
MenuButton.ZIndex = 10

-- Click frame for dragging
local ClickFrame = Instance.new("Frame")
ClickFrame.Name = "DragFrame"
ClickFrame.Parent = Main
ClickFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ClickFrame.BackgroundTransparency = 1
ClickFrame.Position = UDim2.new(0, 0, 0, 0)
ClickFrame.Size = UDim2.new(0, 550, 0, 45)

dragify(ClickFrame, Main)

-- ==================== SIDE PANEL (Player Info) ====================
local SidePanel = Instance.new("Frame")
SidePanel.Parent = Main
SidePanel.BackgroundColor3 = _G.DarkColor
SidePanel.Position = UDim2.new(0, -260, 0, 50)
SidePanel.Size = UDim2.new(0, 250, 0, 340)
SidePanel.ZIndex = 6
SidePanel.BackgroundTransparency = 0

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = _G.Color
PanelStroke.Thickness = 1
PanelStroke.Transparency = 0.5
PanelStroke.Parent = SidePanel

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 10)
PanelCorner.Parent = SidePanel

local panelOpen = false
MenuButton.MouseButton1Click:Connect(function()
  if panelOpen == false then
    panelOpen = true
    SidePanel:TweenPosition(UDim2.new(0, 10, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
  else
    panelOpen = false
    SidePanel:TweenPosition(UDim2.new(0, -260, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
  end
end)

-- Player Info Content
local PlayerFrame = Instance.new("Frame")
PlayerFrame.Parent = SidePanel
PlayerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PlayerFrame.Size = UDim2.new(0, 230, 0, 320)
PlayerFrame.Position = UDim2.new(0, 10, 0, 10)

local PlayerCorner = Instance.new("UICorner")
PlayerCorner.CornerRadius = UDim.new(0, 10)
PlayerCorner.Parent = PlayerFrame

-- Avatar
local Avatar = Instance.new("ImageLabel")
Avatar.Parent = PlayerFrame
Avatar.Position = UDim2.new(0, 15, 0, 15)
Avatar.Size = UDim2.new(0, 70, 0, 70)
Avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..game.Players.LocalPlayer.UserId.."&width=420&height=420&format=png"

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 35)
AvatarCorner.Parent = Avatar

-- Player Name
local PlayerName = Instance.new("TextLabel")
PlayerName.Parent = PlayerFrame
PlayerName.Position = UDim2.new(0, 95, 0, 20)
PlayerName.Size = UDim2.new(0, 130, 0, 25)
PlayerName.BackgroundTransparency = 1
PlayerName.Font = Enum.Font.GothamBold
PlayerName.Text = game.Players.LocalPlayer.Name
PlayerName.TextColor3 = _G.SecondaryColor
PlayerName.TextSize = 14
PlayerName.TextXAlignment = Enum.TextXAlignment.Left

-- Level
local LevelText = Instance.new("TextLabel")
LevelText.Parent = PlayerFrame
LevelText.Position = UDim2.new(0, 95, 0, 45)
LevelText.Size = UDim2.new(0, 130, 0, 20)
LevelText.BackgroundTransparency = 1
LevelText.Font = Enum.Font.Gotham
LevelText.Text = "Level: Loading..."
LevelText.TextColor3 = Color3.fromRGB(180, 180, 180)
LevelText.TextSize = 12
LevelText.TextXAlignment = Enum.TextXAlignment.Left

-- Race & Fruit
local InfoText = Instance.new("TextLabel")
InfoText.Parent = PlayerFrame
InfoText.Position = UDim2.new(0, 15, 0, 95)
InfoText.Size = UDim2.new(0, 200, 0, 40)
InfoText.BackgroundTransparency = 1
InfoText.Font = Enum.Font.Gotham
InfoText.Text = "Loading..."
InfoText.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoText.TextSize = 11
InfoText.TextWrapped = true
InfoText.TextXAlignment = Enum.TextXAlignment.Left

-- Health Bar
local HealthFrame = Instance.new("Frame")
HealthFrame.Parent = PlayerFrame
HealthFrame.Position = UDim2.new(0, 15, 0, 145)
HealthFrame.Size = UDim2.new(0, 200, 0, 35)
HealthFrame.BackgroundTransparency = 1

local HealthLabel = Instance.new("TextLabel")
HealthLabel.Parent = HealthFrame
HealthLabel.Position = UDim2.new(0, 0, 0, 0)
HealthLabel.Size = UDim2.new(0, 60, 0, 20)
HealthLabel.BackgroundTransparency = 1
HealthLabel.Font = Enum.Font.GothamBold
HealthLabel.Text = "❤️ Health"
HealthLabel.TextColor3 = _G.Color
HealthLabel.TextSize = 11
HealthLabel.TextXAlignment = Enum.TextXAlignment.Left

local HealthBarBG = Instance.new("Frame")
HealthBarBG.Parent = HealthFrame
HealthBarBG.Position = UDim2.new(0, 0, 0, 18)
HealthBarBG.Size = UDim2.new(0, 200, 0, 10)
HealthBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local HealthBarBGCorner = Instance.new("UICorner")
HealthBarBGCorner.CornerRadius = UDim.new(0, 5)
HealthBarBGCorner.Parent = HealthBarBG

local HealthFill = Instance.new("Frame")
HealthFill.Parent = HealthBarBG
HealthFill.Size = UDim2.new(1, 0, 0, 10)
HealthFill.BackgroundColor3 = _G.Color

local HealthFillCorner = Instance.new("UICorner")
HealthFillCorner.CornerRadius = UDim.new(0, 5)
HealthFillCorner.Parent = HealthFill

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

-- Stamina Bar
local StaminaFrame = Instance.new("Frame")
StaminaFrame.Parent = PlayerFrame
StaminaFrame.Position = UDim2.new(0, 15, 0, 185)
StaminaFrame.Size = UDim2.new(0, 200, 0, 35)
StaminaFrame.BackgroundTransparency = 1

local StaminaLabel = Instance.new("TextLabel")
StaminaLabel.Parent = StaminaFrame
StaminaLabel.Position = UDim2.new(0, 0, 0, 0)
StaminaLabel.Size = UDim2.new(0, 60, 0, 20)
StaminaLabel.BackgroundTransparency = 1
StaminaLabel.Font = Enum.Font.GothamBold
StaminaLabel.Text = "⚡ Stamina"
StaminaLabel.TextColor3 = Color3.fromRGB(85, 170, 255)
StaminaLabel.TextSize = 11
StaminaLabel.TextXAlignment = Enum.TextXAlignment.Left

local StaminaBarBG = Instance.new("Frame")
StaminaBarBG.Parent = StaminaFrame
StaminaBarBG.Position = UDim2.new(0, 0, 0, 18)
StaminaBarBG.Size = UDim2.new(0, 200, 0, 10)
StaminaBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local StaminaBarBGCorner = Instance.new("UICorner")
StaminaBarBGCorner.CornerRadius = UDim.new(0, 5)
StaminaBarBGCorner.Parent = StaminaBarBG

local StaminaFill = Instance.new("Frame")
StaminaFill.Parent = StaminaBarBG
StaminaFill.Size = UDim2.new(1, 0, 0, 10)
StaminaFill.BackgroundColor3 = Color3.fromRGB(85, 170, 255)

local StaminaFillCorner = Instance.new("UICorner")
StaminaFillCorner.CornerRadius = UDim.new(0, 5)
StaminaFillCorner.Parent = StaminaFill

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

-- ==================== TAB SYSTEM ====================
local TabBar = Instance.new("Frame")
TabBar.Parent = Main
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabBar.Position = UDim2.new(0, 0, 0, 45)
TabBar.Size = UDim2.new(0, 550, 0, 40)

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Parent = TabBar
TabContainer.Position = UDim2.new(0, 10, 0, 5)
TabContainer.Size = UDim2.new(0, 530, 0, 30)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.CanvasSize = UDim2.new(2, 0, 0, 0)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)

local ContentArea = Instance.new("Frame")
ContentArea.Parent = Main
ContentArea.Position = UDim2.new(0, 0, 0, 85)
ContentArea.Size = UDim2.new(0, 550, 0, 315)
ContentArea.BackgroundColor3 = _G.DarkColor

-- ==================== FUNCTIONS ====================
local tabs = {}
local currentPage = nil

function tabs:Tab(name, icon)
    local button = Instance.new("TextButton")
    button.Parent = TabContainer
    button.Size = UDim2.new(0, 100, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.Text = name
    button.TextColor3 = _G.SecondaryColor
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button
    
    local page = Instance.new("ScrollingFrame")
    page.Parent = ContentArea
    page.Size = UDim2.new(0, 540, 0, 305)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 6
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    
    local leftSide = Instance.new("ScrollingFrame")
    leftSide.Parent = page
    leftSide.Size = UDim2.new(0, 260, 0, 295)
    leftSide.Position = UDim2.new(0, 0, 0, 0)
    leftSide.BackgroundTransparency = 1
    leftSide.ScrollBarThickness = 0
    leftSide.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local rightSide = Instance.new("ScrollingFrame")
    rightSide.Parent = page
    rightSide.Size = UDim2.new(0, 260, 0, 295)
    rightSide.Position = UDim2.new(0, 275, 0, 0)
    rightSide.BackgroundTransparency = 1
    rightSide.ScrollBarThickness = 0
    rightSide.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local leftLayout = Instance.new("UIListLayout")
    leftLayout.Parent = leftSide
    leftLayout.Padding = UDim.new(0, 8)
    leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local rightLayout = Instance.new("UIListLayout")
    rightLayout.Parent = rightSide
    rightLayout.Padding = UDim.new(0, 8)
    rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        leftSide.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 10)
    end)
    
    rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        rightSide.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 10)
    end)
    
    if currentPage == nil then
        currentPage = page
        page.Visible = true
        button.BackgroundColor3 = _G.Color
    end
    
    button.MouseButton1Click:Connect(function()
        for _, btn in pairs(TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
        end
        for _, pg in pairs(ContentArea:GetChildren()) do
            if pg:IsA("ScrollingFrame") then
                pg.Visible = false
            end
        end
        button.BackgroundColor3 = _G.Color
        page.Visible = true
    end)
    
    local function GetSide(side)
        if side == 1 then return leftSide
        elseif side == 2 then return rightSide
        else return leftSide end
    end
    
    local sections = {}
    
    function sections:CraftPage(side)
        local section = Instance.new("Frame")
        section.Parent = GetSide(side)
        section.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        section.Size = UDim2.new(0, 250, 0, 0)
        section.AutomaticSize = Enum.AutomaticSize.Y
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 8)
        sectionCorner.Parent = section
        
        local sectionStroke = Instance.new("UIStroke")
        sectionStroke.Color = _G.Color
        sectionStroke.Thickness = 1
        sectionStroke.Transparency = 0.5
        sectionStroke.Parent = section
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Parent = section
        sectionTitle.Size = UDim2.new(0, 250, 0, 30)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.Text = "Section"
        sectionTitle.TextColor3 = _G.Color
        sectionTitle.TextSize = 13
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Center
        
        local container = Instance.new("Frame")
        container.Parent = section
        container.Position = UDim2.new(0, 10, 0, 35)
        container.Size = UDim2.new(0, 230, 0, 0)
        container.BackgroundTransparency = 1
        container.AutomaticSize = Enum.AutomaticSize.Y
        
        local containerLayout = Instance.new("UIListLayout")
        containerLayout.Parent = container
        containerLayout.Padding = UDim.new(0, 8)
        containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local items = {}
        
        function items:Label(text)
            local label = Instance.new("TextLabel")
            label.Parent = container
            label.Size = UDim2.new(0, 230, 0, 25)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = text
            label.TextColor3 = _G.SecondaryColor
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            return label
        end
        
        function items:Button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Parent = container
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
        
        function items:Toggle(text, default, callback)
            local toggled = default or false
            local frame = Instance.new("Frame")
            frame.Parent = container
            frame.Size = UDim2.new(0, 230, 0, 32)
            frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(0, 160, 0, 32)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = text
            label.TextColor3 = _G.SecondaryColor
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Parent = frame
            toggleBtn.Size = UDim2.new(0, 50, 0, 26)
            toggleBtn.Position = UDim2.new(0, 170, 0, 3)
            toggleBtn.BackgroundColor3 = toggled and _G.Color or Color3.fromRGB(60, 60, 60)
            toggleBtn.Text = toggled and "ON" or "OFF"
            toggleBtn.TextColor3 = _G.SecondaryColor
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.TextSize = 11
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 4)
            toggleCorner.Parent = toggleBtn
            
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggleBtn.BackgroundColor3 = toggled and _G.Color or Color3.fromRGB(60, 60, 60)
                toggleBtn.Text = toggled and "ON" or "OFF"
                callback(toggled)
            end)
            
            callback(toggled)
        end
        
        function items:Slider(text, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Parent = container
            frame.Size = UDim2.new(0, 230, 0, 55)
            frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(0, 150, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = text
            label.TextColor3 = _G.SecondaryColor
            label.TextSize = 11
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = frame
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(0, 170, 0, 5)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = _G.Color
            valueLabel.TextSize = 11
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local barBg = Instance.new("Frame")
            barBg.Parent = frame
            barBg.Size = UDim2.new(0, 210, 0, 4)
            barBg.Position = UDim2.new(0, 10, 0, 35)
            barBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(0, 2)
            barCorner.Parent = barBg
            
            local fill = Instance.new("Frame")
            fill.Parent = barBg
            fill.Size = UDim2.new((default - min) / (max - min), 0, 0, 4)
            fill.BackgroundColor3 = _G.Color
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 2)
            fillCorner.Parent = fill
            
            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Parent = barBg
            sliderBtn.Size = UDim2.new(0, 12, 0, 12)
            sliderBtn.Position = UDim2.new((default - min) / (max - min), -0.5, -0.4, 0)
            sliderBtn.BackgroundColor3 = _G.Color
            sliderBtn.Text = ""
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = sliderBtn
            
            local dragging = false
            
            local function update(input)
                local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                fill.Size = UDim2.new(pos, 0, 0, 4)
                sliderBtn.Position = UDim2.new(pos, -6, -0.4, 0)
                valueLabel.Text = tostring(value)
                callback(value)
            end
            
            sliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            sliderBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
            
            barBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    update(input)
                end
            end)
            
            callback(default)
        end
        
        function items:Textbox(text, placeholder, callback)
            local frame = Instance.new("Frame")
            frame.Parent = container
            frame.Size = UDim2.new(0, 230, 0, 55)
            frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(0, 150, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = text
            label.TextColor3 = _G.SecondaryColor
            label.TextSize = 11
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local box = Instance.new("TextBox")
            box.Parent = frame
            box.Size = UDim2.new(0, 210, 0, 28)
            box.Position = UDim2.new(0, 10, 0, 25)
            box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            box.PlaceholderText = placeholder
            box.Text = ""
            box.TextColor3 = _G.SecondaryColor
            box.Font = Enum.Font.Gotham
            box.TextSize = 12
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 4)
            boxCorner.Parent = box
            
            box.FocusLost:Connect(function(enterPressed)
                if enterPressed and box.Text ~= "" then
                    callback(box.Text)
                    box.Text = ""
                end
            end)
        end
        
        return items
    end
    
    return sections
end

-- ==================== UPDATE LOOP ====================
local function UpdateStats()
    pcall(function()
        local player = game.Players.LocalPlayer
        if player and player.Character then
            if player.Data and player.Data.Level then
                LevelText.Text = "Level: " .. player.Data.Level.Value
            end
            
            if player.Data then
                local fruit = player.Data.DevilFruit and player.Data.DevilFruit.Value or "None"
                local race = player.Data.Race and player.Data.Race.Value or "None"
                InfoText.Text = "🍎 Fruit: " .. fruit .. "\n👤 Race: " .. race
            end
            
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                local health = math.floor(humanoid.Health)
                local maxHealth = humanoid.MaxHealth
                local percent = health / maxHealth
                HealthFill.Size = UDim2.new(percent, 0, 0, 10)
                HealthValue.Text = math.floor(health) .. "/" .. math.floor(maxHealth)
                
                if percent < 0.3 then
                    HealthFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                elseif percent < 0.6 then
                    HealthFill.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
                else
                    HealthFill.BackgroundColor3 = _G.Color
                end
            end
            
            local stamina = player.Character:FindFirstChild("Stamina")
            if stamina then
                local currentStam = stamina.Value
                local maxStam = stamina.MaxValue or 100
                local percent = currentStam / maxStam
                StaminaFill.Size = UDim2.new(percent, 0, 0, 10)
                StaminaValue.Text = math.floor(currentStam) .. "/" .. math.floor(maxStam)
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

-- ==================== EXAMPLE USAGE ====================
print("KuKi Hub Loaded! Press RightControl to toggle GUI")

-- Create tabs with features
local mainTab = tabs:Tab("Home", 0)
local combatTab = tabs:Tab("Combat", 0)
local teleportTab = tabs:Tab("Teleport", 0)

-- Home Tab Features
local homeSection = mainTab:CraftPage(1)
homeSection:Label("Welcome to KuKi Hub!")
homeSection:Label("Status: Loaded")
homeSection:Seperator("Movement")
homeSection:Slider("WalkSpeed", 16, 350, 16, function(value)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)
homeSection:Slider("JumpPower", 50, 350, 50, function(value)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

-- Combat Tab Features
local combatSection = combatTab:CraftPage(1)
combatSection:Toggle("Auto Farm", false, function(state)
    print("Auto Farm:", state)
end)
combatSection:Toggle("Auto Attack", false, function(state)
    print("Auto Attack:", state)
end)

-- Teleport Tab Features
local teleportSection = teleportTab:CraftPage(1)
teleportSection:Button("Teleport to Starter Island", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(-1195, 130, 200)
    end
end)
teleportSection:Button("Teleport to Pirate Village", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(-1200, 40, 3500)
    end
end)
teleportSection:Button("Teleport to Desert Island", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(1350, 20, -850)
    end
end)
