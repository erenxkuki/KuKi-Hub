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
_G.DarkColor = Color3.fromRGB(20, 20, 20) -- Black/Dark
_G.AccentColor = Color3.fromRGB(200, 40, 40) -- Dark Red

-- Your logo texture ID (corrected)
_G.LogoTexture = "rbxassetid://90981445742149"  -- This is a texture ID, not asset ID

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

-- Logo IDs
_G.Logo = "rbxassetid://14288624550"  -- Default logo (use if your texture doesn't work)
_G.LogoTexture = "rbxassetid://90981445742149"  -- Your custom texture ID

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
local Imgaemain = Instance.new("ImageLabel")
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
Main.Size = UDim2.new(0, 520, 0, 350)
Main.ClipsDescendants = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundTransparency = 0

local UiToggle_UiStroke256 = Instance.new("UIStroke")
UiToggle_UiStroke256.Color = _G.Color
UiToggle_UiStroke256.Thickness = 3
UiToggle_UiStroke256.Transparency = 0.5
UiToggle_UiStroke256.Name = "UiToggle_UiStroke1"
UiToggle_UiStroke256.Parent = Main

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

local uitoggled = false
UserInputService.InputBegan:Connect(
    function(io, p)
    if io.KeyCode == UIConfig.Bind then
    if uitoggled == false then
    Main:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true)
    uitoggled = true
    wait()
    UI.Enabled = false
    else
        Main:TweenSize(
        UDim2.new(0, 520, 0, 350),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quart,
        1,
        true
    )
    UI.Enabled = true
    uitoggled = false
    end
    end
    end)

local HeaderTop = Instance.new("Frame")
HeaderTop.Name = "Top"
HeaderTop.Parent = Main
HeaderTop.BackgroundColor3 = _G.Color
HeaderTop.BackgroundTransparency = 0
HeaderTop.Position = UDim2.new(0, 0, 0, 0)
HeaderTop.Size = UDim2.new(0, 520, 0, 40)

UICorner_3.CornerRadius = UDim.new(0, 8)
UICorner_3.Parent = HeaderTop

Title.Name = "Title"
Title.Parent = HeaderTop
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0.05, 0, 0.08, 0)
Title.Size = UDim2.new(0, 483, 0, 31)
Title.Font = Enum.Font.GothamBold
Title.Text = "KuKi".."<font color='rgb(255, 50, 50)'> Hub</font>".." | "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
Title.RichText = true;
Title.TextColor3 = _G.SecondaryColor
Title.TextSize = 16.000
Title.TextWrapped = true
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Add Logo to Header (using texture ID)
local LogoImage = Instance.new("ImageLabel")
LogoImage.Parent = HeaderTop
LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LogoImage.BackgroundTransparency = 1.000
LogoImage.Position = UDim2.new(0.92, 0, 0.1, 0)
LogoImage.Size = UDim2.new(0, 30, 0, 30)
LogoImage.Image = _G.LogoTexture  -- Using your texture ID
LogoImage.ImageColor3 = _G.SecondaryColor
LogoImage.ScaleType = Enum.ScaleType.Fit

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 15)
LogoCorner.Parent = LogoImage

-- Add a background stroke for logo
local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = _G.Color
LogoStroke.Thickness = 1
LogoStroke.Transparency = 0.3
LogoStroke.Parent = LogoImage

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

Top.Name = "Top"
Top.Parent = Main
Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Top.BackgroundTransparency = 1.000
Top.Position = UDim2.new(0.021956088, 0, 0.1833337, 0)
Top.Size = UDim2.new(0, 490, 0, 39)

local ClickFrame = Instance.new("Frame")
ClickFrame.Name = "Top"
ClickFrame.Parent = Main
ClickFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ClickFrame.BackgroundTransparency = 1
ClickFrame.Position = UDim2.new(0, 0, 0, 0)
ClickFrame.Size = UDim2.new(0, 520, 0, 50)

TabHolder.Name = "TabHolder"
TabHolder.Parent = Top
TabHolder.Position = UDim2.new(-0.010309278, 6, -0.5323075824, 0)
TabHolder.Size = UDim2.new(0, 495, 0, 38)
TabHolder.BackgroundTransparency = 1

UICorner_2.CornerRadius = UDim.new(0, 3)
UICorner_2.Parent = TabHolder

TabContainer.Name = "TabContainer"
TabContainer.Parent = TabHolder
TabContainer.Active = true
TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabContainer.BackgroundTransparency = 1.000
TabContainer.Size = UDim2.new(0, 495, 0, 38)
TabContainer.CanvasSize = UDim2.new(2, 0, 0, 0)
TabContainer.ScrollBarThickness = 0
TabContainer.VerticalScrollBarInset = Enum.ScrollBarInset.Always

UIListLayout.Parent = TabContainer
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 15)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
  function()
  TabContainer.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, 0)
  end
)

UIPadding.Parent = TabContainer
UIPadding.PaddingLeft = UDim.new(0, 3)
UIPadding.PaddingTop = UDim.new(0, 3)

local Bottom = Instance.new("Frame")
Bottom.Name = "Bottom"
Bottom.Parent = Main
Bottom.BackgroundColor3 = _G.DarkColor
Bottom.BackgroundTransparency = 0.000
Bottom.Position = UDim2.new(0.0119760484, 7, 0.2416666687, 0)
Bottom.Size = UDim2.new(0, 500, 0, 250)

local Menu_Setting = Instance.new("ImageButton")
Menu_Setting.Name = "Menu_Setting"
Menu_Setting.Parent = HeaderTop
Menu_Setting.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Menu_Setting.BackgroundTransparency = 1
Menu_Setting.Position = UDim2.new(0, 485, 0, 7)
Menu_Setting.Size = UDim2.new(0, 25, 0, 25)
Menu_Setting.Image = "http://www.roblox.com/asset/?id=14479606771"
Menu_Setting.ImageColor3 = _G.SecondaryColor
Menu_Setting.ZIndex = 10

local UserImageCorner1 = Instance.new("UICorner")
UserImageCorner1.CornerRadius = UDim.new(0, 60)
UserImageCorner1.Name = "UserImageCorner"
UserImageCorner1.Parent = Menu_Setting

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Name = "BtnStroke"
BtnStroke.Parent = Menu_Setting
BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BtnStroke.Color = _G.Color
BtnStroke.LineJoinMode = Enum.LineJoinMode.Round
BtnStroke.Thickness = 0
BtnStroke.Transparency = 0
BtnStroke.Enabled = true

local MainPage = Instance.new("Frame")
MainPage.Name = "MainPage"
MainPage.Parent = Main
MainPage.ClipsDescendants = true
MainPage.AnchorPoint = Vector2.new(0,0)
MainPage.BackgroundColor3 = _G.DarkColor
MainPage.Position = UDim2.new(0, -250, 0, 50)
MainPage.BackgroundTransparency = 0
MainPage.Size = UDim2.new(0, 240, 0, 260)
MainPage.ZIndex = 6

local postog123 = Instance.new("UIStroke")
postog123.Name = "UIStroke"
postog123.Parent = MainPage
postog123.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
postog123.Color = _G.Color
postog123.LineJoinMode = Enum.LineJoinMode.Round
postog123.Thickness = 2
postog123.Transparency = 0.5
postog123.Enabled = true

local MainPageclose = false
Menu_Setting.MouseButton1Click:Connect(function()
  if MainPageclose == false then
  MainPageclose = true
  MainPage:TweenPosition(UDim2.new(0, -250, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.8, true)
  else
    MainPageclose = false
  MainPage:TweenPosition(UDim2.new(0, 10, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.8, true)
  end
end)

local StaminaBarUICorner1 = Instance.new("UICorner")
StaminaBarUICorner1.CornerRadius = UDim.new(0, 10)
StaminaBarUICorner1.Name = "StaminaBarUICorner1"
StaminaBarUICorner1.Parent = MainPage

local UserID = game.Players.LocalPlayer.UserId
local ThumbType = Enum.ThumbnailType.HeadShot
local ThumbSize = Enum.ThumbnailSize.Size420x420
local Content = game.Players:GetUserThumbnailAsync(UserID,ThumbType,ThumbSize)

local PlayerInfoFrame = Instance.new("Frame")
local PlayerInfoFrameUICorner = Instance.new("UICorner")
local ImageLabel = Instance.new("ImageLabel")
local UICorner_Player = Instance.new("UICorner")
local Name = Instance.new("TextLabel")
local Lvl = Instance.new("TextLabel")
local Fruit = Instance.new("TextLabel")

local Line = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")

Line.Name = "Line"
Line.Parent = PlayerInfoFrame
Line.AnchorPoint = Vector2.new(0.5, 0.5)
Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Line.BorderSizePixel = 0
Line.BackgroundTransparency = 1
Line.Position = UDim2.new(0.5, 0, 0.311723471, 0)
Line.Size = UDim2.new(0, 300, 0, 1)

UIGradient.Color = ColorSequence.new {
  ColorSequenceKeypoint.new(0.00, _G.DarkColor), 
  ColorSequenceKeypoint.new(0.29, _G.Color), 
  ColorSequenceKeypoint.new(0.50, _G.Color), 
  ColorSequenceKeypoint.new(0.68, _G.AccentColor), 
  ColorSequenceKeypoint.new(1.00, _G.DarkColor)}
UIGradient.Parent = Line

PlayerInfoFrame.Name = "PlayerInfoFrame"
PlayerInfoFrame.Parent = MainPage
PlayerInfoFrame.Active = true
PlayerInfoFrame.BackgroundColor3 = _G.DarkColor
PlayerInfoFrame.BackgroundTransparency = 1
PlayerInfoFrame.BorderSizePixel = 0
PlayerInfoFrame.Size = UDim2.new(0, 300, 0, 285)

PlayerInfoFrameUICorner.Name = "PlayerInfoFrameUICorner"
PlayerInfoFrameUICorner.Parent = PlayerInfoFrame

ImageLabel.Parent = PlayerInfoFrame
ImageLabel.Active = true
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0, 40, 0, 45)
ImageLabel.Size = UDim2.new(0, 70, 0, 70)
ImageLabel.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..game.Players.LocalPlayer.UserId.."&width=420&height=420&format=png"

local UserImageCorner = Instance.new("UICorner")
UserImageCorner.CornerRadius = UDim.new(0, 40)
UserImageCorner.Name = "UserImageCorner"
UserImageCorner.Parent = ImageLabel

UICorner_Player.Parent = ImageLabel

Name.Name = "Name"
Name.Parent = PlayerInfoFrame
Name.Active = true
Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Name.BackgroundTransparency = 1.000
Name.Position = UDim2.new(0.22916666, 0, 0, 0)
Name.Size = UDim2.new(0, 150, 0, 27)
Name.Font = Enum.Font.GothamBold
Name.TextColor3 = _G.SecondaryColor
Name.TextSize = 12.000
Name.Text = game.Players.LocalPlayer.Name.. " ("..game.Players.LocalPlayer.DisplayName..")"
Name.TextXAlignment = Enum.TextXAlignment.Left

Lvl.Name = "Lvl"
Lvl.Parent = PlayerInfoFrame
Lvl.Active = true
Lvl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Lvl.BackgroundTransparency = 1.000
Lvl.Position = UDim2.new(0, 85, 0.113057934, 0)
Lvl.Size = UDim2.new(0, 200, 0, 27)
Lvl.TextTransparency = 0.5
Lvl.Font = Enum.Font.GothamBold
Lvl.TextColor3 = _G.SecondaryColor
Lvl.TextSize = 10.000
Lvl.TextXAlignment = Enum.TextXAlignment.Left

Fruit.Name = "Fruit"
Fruit.Parent = PlayerInfoFrame
Fruit.Active = true
Fruit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Fruit.BackgroundTransparency = 1.000
Fruit.Position = UDim2.new(0, 85, 0.199820146, 0)
Fruit.Size = UDim2.new(0, 200, 0, 27)
Fruit.Font = Enum.Font.GothamBold
Fruit.TextTransparency = 0.5
Fruit.TextColor3 = _G.SecondaryColor
Fruit.TextSize = 10.000
Fruit.TextXAlignment = Enum.TextXAlignment.Left

local id = game.PlaceId
if id == 2753915549 or id == 4442272183 or id == 7449423635 then
  Fruit.Text = "Devil Fruit : "..game:GetService("Players").LocalPlayer.Data.DevilFruit.Value.. " / ".. "Race : " ..game:GetService("Players").LocalPlayer.Data.Race.Value
  Lvl.Text = "Level : "..game:GetService("Players").LocalPlayer.Data.Level.Value
else
  Fruit.Text = "Blox Fruits Game Detected!"
  Lvl.Text = "Loading..."
end

-- Health and stamina bars (same as before, keep them)
local HealthBar = Instance.new("Frame")
local HealthBarUICorner = Instance.new("UICorner")
local HealthText = Instance.new("TextLabel")
local Line_Health = Instance.new("Frame")
local LineHealth = Instance.new("Frame")

HealthBar.Name = "HealthBar"
HealthBar.Parent = PlayerInfoFrame
HealthBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
HealthBar.BorderSizePixel = 0
HealthBar.BackgroundTransparency = 1
HealthBar.Position = UDim2.new(0.0187500007, 0, 0.340836018, 0)
HealthBar.Size = UDim2.new(0, 150, 0, 45)

HealthBarUICorner.CornerRadius = UDim.new(0, 4)
HealthBarUICorner.Name = "HealthBarUICorner"
HealthBarUICorner.Parent = HealthBar

HealthText.Name = "HealthText"
HealthText.Parent = HealthBar
HealthText.Active = true
HealthText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HealthText.BackgroundTransparency = 1.000
HealthText.Position = UDim2.new(0.0260000005, 0, 0.100000001, 0)
HealthText.Size = UDim2.new(0, 300, 0, 22)
HealthText.Font = Enum.Font.GothamBold
HealthText.Text = "Health"
HealthText.TextColor3 = _G.Color
HealthText.TextSize = 12.000
HealthText.TextWrapped = true
HealthText.TextXAlignment = Enum.TextXAlignment.Left

Line_Health.Name = "Line"
Line_Health.Parent = HealthBar
Line_Health.AnchorPoint = Vector2.new(0.5, 0.5)
Line_Health.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Line_Health.BorderSizePixel = 0
Line_Health.Position = UDim2.new(0.498908311, 0, 0.766666651, 0)
Line_Health.Size = UDim2.new(0, 150, 0, 5)

LineHealth.Name = "LineHealth"
LineHealth.Parent = Line_Health
LineHealth.BackgroundColor3 = _G.Color
LineHealth.BorderSizePixel = 0
LineHealth.Size = UDim2.new(0, 210, 0, 5)

local StaminaBar = Instance.new("Frame")
local StaminaBarUICorner = Instance.new("UICorner")
local StaminaText = Instance.new("TextLabel")
local StaminaLine = Instance.new("Frame")
local LineStamina = Instance.new("Frame")

StaminaBar.Name = "StaminaBar"
StaminaBar.Parent = PlayerInfoFrame
StaminaBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
StaminaBar.BorderSizePixel = 0
StaminaBar.BackgroundTransparency = 1
StaminaBar.Position = UDim2.new(0.0166666675, 0, 0.50803858, 0)
StaminaBar.Size = UDim2.new(0, 150, 0, 45)

StaminaBarUICorner.CornerRadius = UDim.new(0, 4)
StaminaBarUICorner.Name = "StaminaBarUICorner"
StaminaBarUICorner.Parent = StaminaBar

StaminaText.Name = "StaminaText"
StaminaText.Parent = StaminaBar
StaminaText.Active = true
StaminaText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StaminaText.BackgroundTransparency = 1.000
StaminaText.Position = UDim2.new(0.0260000005, 0, 0.100000001, 0)
StaminaText.Size = UDim2.new(0, 300, 0, 22)
StaminaText.Font = Enum.Font.GothamBold
StaminaText.Text = "Stamina"
StaminaText.TextColor3 = Color3.fromRGB(85, 170, 255)
StaminaText.TextSize = 12.000
StaminaText.TextWrapped = true
StaminaText.TextXAlignment = Enum.TextXAlignment.Left

StaminaLine.Name = "StaminaLine"
StaminaLine.Parent = StaminaBar
StaminaLine.AnchorPoint = Vector2.new(0.5, 0.5)
StaminaLine.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StaminaLine.BorderSizePixel = 0
StaminaLine.Position = UDim2.new(0.498908311, 0, 0.766666651, 0)
StaminaLine.Size = UDim2.new(0, 150, 0, 5)

LineStamina.Name = "LineStamina"
LineStamina.Parent = StaminaLine
LineStamina.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
LineStamina.BorderSizePixel = 0
LineStamina.Size = UDim2.new(0, 200, 0, 5)

dragify(ClickFrame, Main)

local tabs = {}
local S = false

function tabs:Tab(Name, icon)
local FrameTab = Instance.new("Frame")
local Tab = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local UICorner_Tab = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")

FrameTab.Name = "FrameTab"
FrameTab.Parent = Tab
FrameTab.BackgroundColor3 = Color3.fromRGB(255,255,255)
FrameTab.Position = UDim2.new(0.3, 0, 0.9, 0)
FrameTab.Size = UDim2.new(0, 0, 0, 0)
FrameTab.BackgroundTransparency = 0
FrameTab.Visible = false

UICorner_Tab.CornerRadius = UDim.new(0, 3)
UICorner_Tab.Parent = FrameTab

Tab.Name = "Tab"
Tab.Parent = TabContainer
Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Tab.Size = UDim2.new(0, 114, 0, 30)
Tab.BackgroundTransparency = 0
Tab.Text = ""

UICorner_3.CornerRadius = UDim.new(0, 8)
UICorner_3.Parent = Tab

local UIGradient2 = Instance.new("UIGradient")
UIGradient2.Color = ColorSequence.new {
  ColorSequenceKeypoint.new(0.00, _G.DarkColor), 
  ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 30))}
UIGradient2.Parent = Tab

local ImageLabel1 = Instance.new("ImageLabel")
ImageLabel1.Name = "ImageLabel"
ImageLabel1.Parent = Tab
ImageLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel1.BackgroundTransparency = 1.000
ImageLabel1.Position = UDim2.new(0, 5, 0.2, 0)
ImageLabel1.Size = UDim2.new(0, 20, 0, 20)
ImageLabel1.Image = "rbxassetid://" .. tostring(icon)

TextLabel.Parent = Tab
TextLabel.Text = Name

local UiToggle_UiStroke901 = Instance.new("UIStroke")
UiToggle_UiStroke901.Color = _G.Color
UiToggle_UiStroke901.Thickness = 2
UiToggle_UiStroke901.Name = "UiToggle_UiStroke901"
UiToggle_UiStroke901.Parent = Tab

TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.Position = UDim2.new(0.252105269, 0, 0.100000001, 0)
TextLabel.Size = UDim2.new(0, 10, 0, 27)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextColor3 = _G.SecondaryColor
TextLabel.TextSize = 12.300
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextTransparency = 0.200
TextLabel.Text = Name

local Page = Instance.new("ScrollingFrame")
local Left = Instance.new("ScrollingFrame")
local Right = Instance.new("ScrollingFrame")
local UIListLayout_5 = Instance.new("UIListLayout")
local UIPadding_5 = Instance.new("UIPadding")

Page.Name = "Page"
Page.Parent = Bottom
Page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Page.BackgroundTransparency = 1.000
Page.Size = UDim2.new(0, 500, 0, 250)
Page.ScrollBarThickness = 0
Page.CanvasSize = UDim2.new(0, 0, 0, 0)
Page.Visible = false

Left.Name = "Left"
Left.Parent = Page
Left.Active = true
Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Left.BackgroundTransparency = 1
Left.Size = UDim2.new(0, 240, 0, 240)
Left.ScrollBarThickness = 0
Left.CanvasSize = UDim2.new(0, 0, 0, 0)

Right.Name = "Right"
Right.Parent = Page
Right.Active = true
Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Right.BackgroundTransparency = 1
Right.Size = UDim2.new(0, 240, 0, 240)
Right.ScrollBarThickness = 0
Right.CanvasSize = UDim2.new(0, 0, 0, 0)

local LeftList = Instance.new("UIListLayout")
local RightList = Instance.new("UIListLayout")

LeftList.Parent = Left
LeftList.SortOrder = Enum.SortOrder.LayoutOrder
LeftList.Padding = UDim.new(0, 5)

RightList.Parent = Right
RightList.SortOrder = Enum.SortOrder.LayoutOrder
RightList.Padding = UDim.new(0, 5)

UIListLayout_5.Parent = Page
UIListLayout_5.FillDirection = Enum.FillDirection.Horizontal
UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_5.Padding = UDim.new(0, 13)

UIPadding_5.Parent = Page

if S == false then
S = true
Page.Visible = true
TextLabel.TextColor3 = _G.Color
TextLabel.TextTransparency = 0
ImageLabel1.ImageTransparency = 0
ImageLabel1.ImageColor3 = _G.Color
FrameTab.Size = UDim2.new(0, 40, 0, 2)
FrameTab.Visible = true
end

Tab.MouseButton1Click:Connect(
  function()
  for _, x in next, TabContainer:GetChildren() do
  if x.Name == "Tab" then
  TweenService:Create(
    x.TextLabel,
    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {
      TextColor3 = _G.SecondaryColor}
  ):Play()
  TweenService:Create(
    x.TextLabel,
    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {
      TextTransparency = 0.2
    }
  ):Play()
  TweenService:Create(
    x.FrameTab,
    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {
      Size = UDim2.new(0, 0, 0, 2)}
  ):Play()
  for index, y in next, Bottom:GetChildren() do
  TweenService:Create(
    y,
    TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    {
      Position = UDim2.new(0,1500,0,0)}
  ):Play()
  y.Visible = false
  end
  x.FrameTab.Visible = false
  end
  end
  TweenService:Create(
    TextLabel,
    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {
      TextColor3 = _G.Color
    }
  ):Play()
  TweenService:Create(
    TextLabel,
    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {
      TextTransparency = 0
    }
  ):Play()
  FrameTab.Visible = true
  TweenService:Create(
    FrameTab,
    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {
      Size = UDim2.new(0, 40, 0, 2)}
  ):Play()
  Page.Position = UDim2.new(0,0,0,1500)
  TweenService:Create(
    Page,
    TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    {
      Position = UDim2.new(0,0,0,0)}
  ):Play()
  Page.Visible = true
  end
)

local function GetType(value)
if value == 1 then
return Left
elseif value == 2 then
return Right
else
  return Left
end
end

game:GetService("RunService").Stepped:Connect(function()
  pcall(function()
    Right.CanvasSize = UDim2.new(0,0,0,RightList.AbsoluteContentSize.Y + 5)
    Left.CanvasSize = UDim2.new(0,0,0,LeftList.AbsoluteContentSize.Y + 5)
    end)
  end)

local sections = {}

function sections:CraftPage(side)
if side == nil then
return Left
end

local Section = Instance.new("Frame")
local UICorner_5 = Instance.new("UICorner")
local Top_2 = Instance.new("Frame")
local Line = Instance.new("Frame")
local Sectionname = Instance.new("TextLabel")
local SectionContainer = Instance.new("Frame")
local SectionContainer_2 = Instance.new("Frame")
local UIListLayout_2 = Instance.new("UIListLayout")
local UIPadding_2 = Instance.new("UIPadding")
local UIGradient_S = Instance.new("UIGradient")

Section.Name = "Section"
Section.Parent = GetType(side)
Section.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Section.ClipsDescendants = true
Section.Size = UDim2.new(0, 240, 0, 343)
Section.BackgroundTransparency = 0

local SectionStroke = Instance.new("UIStroke")
SectionStroke.Color = _G.Color
SectionStroke.Thickness = 1
SectionStroke.Transparency = 0.7
SectionStroke.Parent = Section

UICorner_5.CornerRadius = UDim.new(0, 8)
UICorner_5.Parent = Section

Top_2.Name = "Top"
Top_2.Parent = Section
Top_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Top_2.BackgroundTransparency = 1.000
Top_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
Top_2.Size = UDim2.new(0, 238, 0, 8)

Line.Name = "Line"
Line.Parent = Top_2
Line.BackgroundColor3 = _G.Color
Line.BorderSizePixel = 0
Line.Size = UDim2.new(0, 239, 0, 1)
Line.Visible = true

SectionContainer.Name = "SectionContainer"
SectionContainer.Parent = Top_2
SectionContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SectionContainer.BackgroundTransparency = 1.000
SectionContainer.BorderSizePixel = 0
SectionContainer.Position = UDim2.new(0, 0, 0.716416223, 0)
SectionContainer.Size = UDim2.new(0, 239, 0, 200)

SectionContainer_2.Name = "SectionContainer_2"
SectionContainer_2.Parent = Top_2
SectionContainer_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SectionContainer_2.BackgroundTransparency = 1.000
SectionContainer_2.BorderSizePixel = 0
SectionContainer_2.Position = UDim2.new(0, 0, 0.716416223, 0)
SectionContainer_2.Size = UDim2.new(0, 239, 0, 230)

UIListLayout_2.Parent = SectionContainer
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.Padding = UDim.new(0, 8)

UIPadding_2.Parent = SectionContainer
UIPadding_2.PaddingLeft = UDim.new(0, 5)

UIListLayout_2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
  function()
  Section.Size = UDim2.new(1, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 40)
  end
)

local functionitem = {}

function functionitem:Label(text)
local Label = Instance.new("TextLabel")
local PaddingLabel = Instance.new("UIPadding")
local labelfunc = {}

Label.Name = "Label"
Label.Parent = SectionContainer
Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Label.BackgroundTransparency = 1.000
Label.Size = UDim2.new(0, 200, 0, 20)
Label.Font = Enum.Font.GothamSemibold
Label.TextColor3 = _G.SecondaryColor
Label.TextSize = 11.000
Label.Text = text
Label.TextXAlignment = Enum.TextXAlignment.Left

PaddingLabel.PaddingLeft = UDim.new(0,10)
PaddingLabel.Parent = Label
PaddingLabel.Name = "PaddingLabel"

function labelfunc:Set(newtext)
Label.Text = newtext
end
return labelfunc
end

function functionitem:Seperator(text)
local textas = {}
local Label = Instance.new("Frame")
local Text = Instance.new("TextLabel")

Label.Name = "Label"
Label.Parent = SectionContainer
Label.AnchorPoint = Vector2.new(0.5, 0.5)
Label.BackgroundTransparency = 1.000
Label.Size = UDim2.new(0, 240, 0, 15)

local Label22 = Instance.new("Frame")
Label22.Name = "Label22"
Label22.Parent = Label
Label22.AnchorPoint = Vector2.new(0, 0.5)
Label22.BackgroundColor3 = _G.Color
Label22.Position = UDim2.new(0,30,0.5,0)
Label22.Size = UDim2.new(0, 30, 0, 2)

local Label23 = Instance.new("Frame")
Label23.Name = "Label23"
Label23.Parent = Label
Label23.AnchorPoint = Vector2.new(0, 0.5)
Label23.BackgroundColor3 = _G.Color
Label23.Position = UDim2.new(0,180,0.5,0)
Label23.Size = UDim2.new(0, 30, 0, 2)

Text.Name = "Text"
Text.Parent = Label
Text.AnchorPoint = Vector2.new(0.5, 0.5)
Text.BackgroundColor3 = _G.Color
Text.BackgroundTransparency = 1.000
Text.Position = UDim2.new(0.5, 0, 0.5, 0)
Text.Size = UDim2.new(0, 53, 0, 150)
Text.ZIndex = 16
Text.Font = Enum.Font.GothamBold
Text.Text = text
Text.TextColor3 = _G.SecondaryColor
Text.TextSize = 11.000

function textas.Refresh(newtext)
Text.Text = newtext
end
return textas
end

function functionitem:Button(Name, callback)
local Button = Instance.new("Frame")
local UICorner_6 = Instance.new("UICorner")
local TextLabel_3 = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")

Button.Name = "Button"
Button.Parent = SectionContainer
Button.BackgroundColor3 = _G.DarkColor
Button.Size = UDim2.new(0.975000024, 0, 0, 30)
Button.ZIndex = 16
Button.BackgroundTransparency = 0

local UiToggle_UiStroke2 = Instance.new("UIStroke")
UiToggle_UiStroke2.Color = _G.Color
UiToggle_UiStroke2.Thickness = 1
UiToggle_UiStroke2.Name = "UiToggle_UiStroke1"
UiToggle_UiStroke2.Parent = Button

UICorner_6.CornerRadius = UDim.new(0, 5)
UICorner_6.Parent = Button

TextLabel_3.Parent = Button
TextLabel_3.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.BackgroundTransparency = 1.000
TextLabel_3.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel_3.Size = UDim2.new(0, 40, 0, 12)
TextLabel_3.ZIndex = 16
TextLabel_3.Font = Enum.Font.GothamBold
TextLabel_3.Text = Name
TextLabel_3.TextColor3 = _G.SecondaryColor
TextLabel_3.TextSize = 11.000

TextButton.Parent = Button
TextButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TextButton.BackgroundTransparency = 1.000
TextButton.BorderSizePixel = 0
TextButton.ClipsDescendants = true
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.ZIndex = 16
TextButton.AutoButtonColor = false
TextButton.Font = Enum.Font.Gotham
TextButton.Text = ""
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 14.000

TextButton.MouseEnter:Connect(function()
  TweenService:Create(
    Button,
    TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    {
      BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    }
  ):Play()
  end)

TextButton.MouseLeave:Connect(function()
  TweenService:Create(
    Button,
    TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    {
      BackgroundColor3 = _G.DarkColor
    }
  ):Play()
  end)

TextButton.MouseButton1Click:Connect(function()
  CircleClick(Button, Mouse.X, Mouse.Y)
  TextLabel_3.TextSize = 0
  TweenService:Create(
    TextLabel_3,
    TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    {
      TextSize = 11
    }
  ):Play()
  callback()
  end)
end

function functionitem:Toggle(Name, default, callback)
local ToglFunc = {}
local Tgo = default
local MainToggle = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Text = Instance.new("TextLabel")
local MainToggle_2 = Instance.new("ImageLabel")
local UICorner_2 = Instance.new("UICorner")
local MainToggle_3 = Instance.new("ImageLabel")
local UICorner_3 = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")

MainToggle.Name = "MainToggle"
MainToggle.Parent = SectionContainer
MainToggle.BackgroundColor3 = _G.DarkColor
MainToggle.BackgroundTransparency = 0
MainToggle.BorderSizePixel = 0
MainToggle.ClipsDescendants = true
MainToggle.Size = UDim2.new(0.975000024, 0, 0, 35)
MainToggle.ZIndex = 16

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = _G.Color
ToggleStroke.Thickness = 1
ToggleStroke.Transparency = 0.5
ToggleStroke.Parent = MainToggle

UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = MainToggle

Text.Name = "Text"
Text.Parent = MainToggle
Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Text.BackgroundTransparency = 1.000
Text.Position = UDim2.new(0, 10, 0, 10)
Text.Size = UDim2.new(0, 100, 0, 12)
Text.ZIndex = 16
Text.Font = Enum.Font.GothamBold
Text.Text = Name
Text.TextColor3 = _G.SecondaryColor
Text.TextSize = 12.000
Text.TextTransparency = 0.2
Text.TextXAlignment = Enum.TextXAlignment.Left

MainToggle_3.Name = "MainToggle"
MainToggle_3.Parent = MainToggle
MainToggle_3.AnchorPoint = Vector2.new(0.5, 0.5)
MainToggle_3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainToggle_3.ClipsDescendants = true
MainToggle_3.Position = UDim2.new(0.899999976, 0, 0.5, 0)
MainToggle_3.Size = UDim2.new(0, 20, 0, 20)
MainToggle_3.ZIndex = 16
MainToggle_3.Image = "http://www.roblox.com/asset/?id="
MainToggle_3.ImageColor3 = Color3.fromRGB(255, 255, 255)
MainToggle_3.Visible = true

UICorner_3.CornerRadius = UDim.new(0, 5)
UICorner_3.Parent = MainToggle_3

TextButton.Name = ""
TextButton.Parent = MainToggle
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 1.000
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0, 0, 0, 0)
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.ZIndex = 16
TextButton.AutoButtonColor = false
TextButton.Font = Enum.Font.Gotham
TextButton.Text = ""
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 14.000

if default == true then
  MainToggle_3.BackgroundColor3 = _G.Color
  MainToggle_3:TweenSize(UDim2.new(0, 18, 0, 18),"In","Linear",0.2,true)
  MainToggle_3.Image = "http://www.roblox.com/asset/?id=6023426926"
  UICorner_3.CornerRadius = UDim.new(0, 100)
  pcall(callback,true)
end

TextButton.MouseEnter:Connect(function()
  if Tgo == false then
    MainToggle_3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainToggle_3.Image = "http://www.roblox.com/asset/?id=00"
    MainToggle_3:TweenSize(UDim2.new(0, 20, 0, 20),"In","Linear",0.2,true)
    UICorner_3.CornerRadius = UDim.new(0, 5)
  else
    MainToggle_3.BackgroundColor3 = _G.Color
    MainToggle_3:TweenSize(UDim2.new(0, 20, 0, 20),"In","Linear",0.2,true)
    MainToggle_3.Image = "http://www.roblox.com/asset/?id=6023426926"
    UICorner_3.CornerRadius = UDim.new(0, 100)
  end
end)

TextButton.MouseLeave:Connect(function()
  if Tgo == false then
    MainToggle_3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainToggle_3.Image = "http://www.roblox.com/asset/?id=00"
    MainToggle_3:TweenSize(UDim2.new(0, 20, 0, 20),"In","Linear",0.2,true)
    UICorner_3.CornerRadius = UDim.new(0, 5)
  else
    MainToggle_3.BackgroundColor3 = _G.Color
    MainToggle_3:TweenSize(UDim2.new(0, 18, 0, 18),"In","Linear",0.2,true)
    MainToggle_3.Image = "http://www.roblox.com/asset/?id=6023426926"
    UICorner_3.CornerRadius = UDim.new(0, 100)
  end
end)

TextButton.MouseButton1Click:Connect(function()
  if Tgo == false then
    Tgo = true
    pcall(callback,true)
    MainToggle_3.BackgroundColor3 = _G.Color
    MainToggle_3.Image = "http://www.roblox.com/asset/?id=6023426926"
    UICorner_3.CornerRadius = UDim.new(0, 100)
    MainToggle_3:TweenSize(UDim2.new(0, 20, 0, 20),"In","Linear",0.2,true)
    wait(0.2)
    MainToggle_3:TweenSize(UDim2.new(0, 20, 0, 20),"In","Linear",0.2,true)
  else
    Tgo = false
    pcall(callback,false)
    MainToggle_3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainToggle_3.Image = "http://www.roblox.com/asset/?id=00"
    MainToggle_3:TweenSize(UDim2.new(0, 20, 0, 20),"In","Linear",0.2,true)
    UICorner_3.CornerRadius = UDim.new(0, 5)
    wait(0.2)
    MainToggle_3:TweenSize(UDim2.new(0, 20, 0, 20),"In","Linear",0.2,true)
  end
  wait(0.1)
  CircleClick(TextButton, Mouse.X, Mouse.Y)
end)

return ToglFunc
end

function functionitem:Textbox(Name, Placeholder, callback)
local Textbox = Instance.new("Frame")
local UICorner_16 = Instance.new("UICorner")
local Text_5 = Instance.new("TextLabel")
local TextboxHoler = Instance.new("Frame")
local UICorner_17 = Instance.new("UICorner")
local UICorner_18 = Instance.new("UICorner")
local HeadTitle = Instance.new("TextBox")

Textbox.Name = "Textbox"
Textbox.Parent = SectionContainer
Textbox.BackgroundColor3 = _G.DarkColor
Textbox.BackgroundTransparency = 0
Textbox.BorderSizePixel = 0
Textbox.ClipsDescendants = true
Textbox.Size = UDim2.new(0.975000024, 0, 0, 35)
Textbox.ZIndex = 16

local UiToggle_UiStroke23 = Instance.new("UIStroke")
UiToggle_UiStroke23.Color = _G.Color
UiToggle_UiStroke23.Thickness = 1
UiToggle_UiStroke23.Name = "UiToggle_UiStroke1"
UiToggle_UiStroke23.Parent = Textbox

UICorner_16.CornerRadius = UDim.new(0, 5)
UICorner_16.Parent = Textbox

Text_5.Name = "Text"
Text_5.Parent = Textbox
Text_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Text_5.BackgroundTransparency = 1.000
Text_5.Position = UDim2.new(0, 10, 0, 10)
Text_5.Size = UDim2.new(0, 43, 0, 12)
Text_5.ZIndex = 16
Text_5.Font = Enum.Font.GothamBold
Text_5.Text = Name
Text_5.TextColor3 = _G.SecondaryColor
Text_5.TextSize = 11.000
Text_5.TextXAlignment = Enum.TextXAlignment.Left

TextboxHoler.Name = "TextboxHoler"
TextboxHoler.Parent = Textbox
TextboxHoler.AnchorPoint = Vector2.new(0.5, 0.5)
TextboxHoler.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
TextboxHoler.BackgroundTransparency = 1.000
TextboxHoler.BorderSizePixel = 0
TextboxHoler.Position = UDim2.new(0.5, 0, 0.5, 13)
TextboxHoler.Size = UDim2.new(0.970000029, 0, 0, 30)

UICorner_17.CornerRadius = UDim.new(0, 5)
UICorner_17.Parent = TextboxHoler

HeadTitle.Name = "HeadTitle"
HeadTitle.Parent = TextboxHoler
HeadTitle.AnchorPoint = Vector2.new(0.5, 0.5)
HeadTitle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
HeadTitle.BackgroundTransparency = 0.000
HeadTitle.BorderSizePixel = 0.400
HeadTitle.ClipsDescendants = true
HeadTitle.Position = UDim2.new(0.74, 0, 0.04, 0)
HeadTitle.Size = UDim2.new(0, 100, 0, 28)
HeadTitle.ZIndex = 16
HeadTitle.Font = Enum.Font.GothamBold
HeadTitle.PlaceholderColor3 = _G.Color
HeadTitle.PlaceholderText = Placeholder
HeadTitle.Text = ""
HeadTitle.TextColor3 = _G.SecondaryColor
HeadTitle.TextSize = 13.000
HeadTitle.TextTransparency = 0
HeadTitle.TextXAlignment = Enum.TextXAlignment.Center

UICorner_18.CornerRadius = UDim.new(0, 5)
UICorner_18.Parent = HeadTitle

HeadTitle.FocusLost:Connect(
  function(ep)
  if ep then
  if #HeadTitle.Text > 0 then
  callback(HeadTitle.Text)
  HeadTitle.Text = ""
  end
  end
  end)
end

function functionitem:Slider(text,floor,min,max,de,callback)
local SliderFrame = Instance.new("Frame")
local LabelNameSlider = Instance.new("TextLabel")
local ShowValueFrame = Instance.new("Frame")
local CustomValue = Instance.new("TextBox")
local ShowValueFrameUICorner = Instance.new("UICorner")
local ValueFrame = Instance.new("Frame")
local ValueFrameUICorner = Instance.new("UICorner")
local PartValue = Instance.new("Frame")
local PartValueUICorner = Instance.new("UICorner")
local MainValue = Instance.new("Frame")
local MainValueUICorner = Instance.new("UICorner")
local sliderfunc = {}

SliderFrame.Name = "SliderFrame"
SliderFrame.Parent = SectionContainer
SliderFrame.BackgroundColor3 = _G.DarkColor
SliderFrame.Position = UDim2.new(0.109489053, 0, 0.708609283, 0)
SliderFrame.Size = UDim2.new(0.975000024, 0, 0, 45)
SliderFrame.BackgroundTransparency = 0

local UiToggle_UiStroke28 = Instance.new("UIStroke")
UiToggle_UiStroke28.Color = _G.Color
UiToggle_UiStroke28.Thickness = 1
UiToggle_UiStroke28.Name = "UiToggle_UiStroke1"
UiToggle_UiStroke28.Parent = SliderFrame

local UICorner_7 = Instance.new("UICorner")
UICorner_7.CornerRadius = UDim.new(0, 5)
UICorner_7.Parent = SliderFrame

LabelNameSlider.Name = "LabelNameSlider"
LabelNameSlider.Parent = SliderFrame
LabelNameSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LabelNameSlider.BackgroundTransparency = 1.000
LabelNameSlider.Position = UDim2.new(0.0729926974, 0, 0.0396823473, 0)
LabelNameSlider.Size = UDim2.new(0, 182, 0, 25)
LabelNameSlider.Font = Enum.Font.GothamBold
LabelNameSlider.Text = tostring(text)
LabelNameSlider.TextColor3 = _G.SecondaryColor
LabelNameSlider.TextSize = 11.000
LabelNameSlider.TextXAlignment = Enum.TextXAlignment.Left

ShowValueFrame.Name = "ShowValueFrame"
ShowValueFrame.Parent = SliderFrame
ShowValueFrame.BackgroundColor3 = _G.DarkColor
ShowValueFrame.BackgroundTransparency = 1
ShowValueFrame.Position = UDim2.new(0.733576655, 0, 0.0656082779, 0)
ShowValueFrame.Size = UDim2.new(0, 58, 0, 21)

CustomValue.Name = "CustomValue"
CustomValue.Parent = ShowValueFrame
CustomValue.AnchorPoint = Vector2.new(0.5, 0.5)
CustomValue.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CustomValue.Position = UDim2.new(0.3, 0, 0.5, 0)
CustomValue.Size = UDim2.new(0, 55, 0, 21)
CustomValue.Font = Enum.Font.GothamBold
CustomValue.Text = "50"
CustomValue.TextColor3 = _G.SecondaryColor
CustomValue.TextSize = 11.000

ShowValueFrameUICorner.CornerRadius = UDim.new(0, 5)
ShowValueFrameUICorner.Name = "ShowValueFrameUICorner"
ShowValueFrameUICorner.Parent = CustomValue

ValueFrame.Name = "ValueFrame"
ValueFrame.Parent = SliderFrame
ValueFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ValueFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ValueFrame.Position = UDim2.new(0.5, 0, 0.8, 0)
ValueFrame.Size = UDim2.new(0, 200, 0, 5)

ValueFrameUICorner.CornerRadius = UDim.new(0, 30)
ValueFrameUICorner.Name = "ValueFrameUICorner"
ValueFrameUICorner.Parent = ValueFrame

PartValue.Name = "PartValue"
PartValue.Parent = ValueFrame
PartValue.AnchorPoint = Vector2.new(0.5, 0.5)
PartValue.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PartValue.BackgroundTransparency = 1.000
PartValue.Position = UDim2.new(0.5, 0, 0.8, 0)
PartValue.Size = UDim2.new(0, 200, 0, 5)

PartValueUICorner.CornerRadius = UDim.new(0, 30)
PartValueUICorner.Name = "PartValueUICorner"
PartValueUICorner.Parent = PartValue

MainValue.Name = "MainValue"
MainValue.Parent = ValueFrame
MainValue.BackgroundColor3 = _G.Color
MainValue.Size = UDim2.new((de or 0) / max, 0, 0, 5)
MainValue.BorderSizePixel = 0

MainValueUICorner.CornerRadius = UDim.new(0, 30)
MainValueUICorner.Name = "MainValueUICorner"
MainValueUICorner.Parent = MainValue

local ConneValue = Instance.new("Frame")
ConneValue.Name = "ConneValue"
ConneValue.Parent = PartValue
ConneValue.AnchorPoint = Vector2.new(0.7, 0.7)
ConneValue.BackgroundColor3 = _G.Color
ConneValue.Position = UDim2.new((de or 0)/max, 0.5, 0.5,0, 0)
ConneValue.Size = UDim2.new(0, 10, 0, 10)
ConneValue.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = ConneValue

if floor == true then
CustomValue.Text = tostring(de and string.format((de / max) * (max - min) + min) or 0)
else
  CustomValue.Text = tostring(de and math.floor((de / max) * (max - min) + min) or 0)
end

local function move(input)
local pos =
UDim2.new(
  math.clamp((input.Position.X - ValueFrame.AbsolutePosition.X) / ValueFrame.AbsoluteSize.X, 0, 1),
  0,
  0.5,
  0
)
local pos1 =
UDim2.new(
  math.clamp((input.Position.X - ValueFrame.AbsolutePosition.X) / ValueFrame.AbsoluteSize.X, 0, 1),
  0,
  0,
  5
)
MainValue:TweenSize(pos1, "Out", "Sine", 0.2, true)
ConneValue:TweenPosition(pos, "Out", "Sine", 0.2, true)
if floor == true then
local value = string.format("%.0f",((pos.X.Scale * max) / max) * (max - min) + min)
CustomValue.Text = tostring(value)
callback(value)
else
  local value = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
CustomValue.Text = tostring(value)
callback(value)
end
end

local dragging = false
ConneValue.InputBegan:Connect(
  function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 then
  dragging = true
  end
  end)
ConneValue.InputEnded:Connect(
  function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 then
  dragging = false
  end
  end)
SliderFrame.InputBegan:Connect(
  function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 then
  dragging = true
  end
  end)
SliderFrame.InputEnded:Connect(
  function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 then
  dragging = false
  end
  end)
ValueFrame.InputBegan:Connect(
  function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 then
  dragging = true
  end
  end)
ValueFrame.InputEnded:Connect(
  function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 then
  dragging = false
  end
  end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
  if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
  move(input)
  end
  end)
CustomValue.FocusLost:Connect(function()
  if CustomValue.Text == "" then
  CustomValue.Text = de
  end
  if tonumber(CustomValue.Text) > max then
  CustomValue.Text = max
  end
  MainValue:TweenSize(UDim2.new((CustomValue.Text or 0) / max, 0, 0, 5), "Out", "Sine", 0.2, true)
  ConneValue:TweenPosition(UDim2.new((CustomValue.Text or 0)/max, 0,0.6, 0) , "Out", "Sine", 0.2, true)
  if floor == true then
  CustomValue.Text = tostring(CustomValue.Text and string.format("%.0f",(CustomValue.Text / max) * (max - min) + min))
  else
    CustomValue.Text = tostring(CustomValue.Text and math.floor((CustomValue.Text / max) * (max - min) + min))
  end
  pcall(callback, CustomValue.Text)
  end)

function sliderfunc:Update(value)
MainValue:TweenSize(UDim2.new((value or 0) / max, 0, 0, 5), "Out", "Sine", 0.2, true)
ConneValue:TweenPosition(UDim2.new((value or 0)/max, 0.5, 0.5,0, 0) , "Out", "Sine", 0.2, true)
CustomValue.Text = value
pcall(function()
  callback(value)
  end)
end
return sliderfunc
end

return functionitem
end
return sections
end
return tabs
end
return library
