--[[
    Ryzu Hub | True V2
    Theme: Purple (#8A2BE2) / Black / White
    Features: Tabs, Sections, Buttons, Toggles, Sliders, Dropdowns, Textboxes, MultiDropdowns
    Toggle Button: Always visible (Purple cube)
--]]

do
    local ui = game:GetService("CoreGui"):FindFirstChild("UILibrary")
    if ui then ui:Destroy() end
end

local library = {}
local UIConfig = { Bind = Enum.KeyCode.RightControl }
local randomString = ""
local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
math.randomseed(os.time())
local charTable = {}
for c in chars:gmatch "." do table.insert(charTable, c) end
for i = 1, 20 do randomString = randomString .. charTable[math.random(1, #charTable)] end

-- Clean up any existing UI
for i, v in pairs(game.CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):GetChildren()) do
    if v.ClassName == "ScreenGui" then
        for _, v1 in pairs(v:GetChildren()) do
            if v1.Name == "Main" then v:Destroy() end
        end
    end
end

-- ██████ RYZU HUB THEME (Purple) ██████
_G.Color = Color3.fromRGB(138, 43, 226)  -- Purple (BlueViolet)

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

function CircleClick(Button, X, Y)
    coroutine.wrap(function()
        local Circle = Instance.new("ImageLabel")
        Circle.Parent = Button
        Circle.Name = "Circle"
        Circle.BackgroundColor3 = Color3.new(1,1,1)
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Image = "rbxassetid://14346331443"
        Circle.ImageColor3 = Color3.new(1,1,1)
        Circle.ImageTransparency = 0.7
        Circle.Visible = false
        local NewX = X - Circle.AbsolutePosition.X
        local NewY = Y - Circle.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        local Time = 0.2
        Circle:TweenSizeAndPosition(UDim2.new(0,30.25,0,30.25), UDim2.new(0,NewX-15,0,NewY-10), "Out", "Quad", Time, false, nil)
        for i = 1,10 do Circle.ImageTransparency += 0.01; task.wait(Time/10) end
        Circle:Destroy()
    end)()
end

function dragify(Frame, object)
    local dragToggle, dragStart, startPos, dragInput
    local function updateInput(input)
        local Delta = input.Position - dragStart
        TweenService:Create(object, TweenInfo.new(0.25), { Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y) }):Play()
    end
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
        end
    end)
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then updateInput(input) end
    end)
end

local UI = Instance.new("ScreenGui")
UI.Name = randomString
UI.Parent = game.CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.Enabled = true
if syn then syn.protect_gui(UI) end

function library:Make()
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local HeaderTop = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabHolder = Instance.new("Frame")
    local TabContainer = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local Bottom = Instance.new("Frame")

    Main.Name = "Main"
    Main.Parent = UI
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)   -- Black
    Main.Size = UDim2.new(0, 520, 0, 350)
    Main.ClipsDescendants = true
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundTransparency = 0
    Main.Visible = true

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = _G.Color
    MainStroke.Thickness = 3
    MainStroke.Transparency = 0.3
    MainStroke.Parent = Main

    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Main

    -- ██████ TOGGLE BUTTON (always visible) ██████
    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Parent = UI
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(0, 10, 0.5, -25)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Image = "rbxassetid://129872344726942"  -- You can replace with your own asset
    ToggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.ZIndex = 20
    ToggleButton.AutoButtonColor = false

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = _G.Color
    ToggleStroke.Thickness = 2
    ToggleStroke.Transparency = 0.5
    ToggleStroke.Parent = ToggleButton

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleButton

    local guiVisible = true
    ToggleButton.MouseButton1Click:Connect(function()
        CircleClick(ToggleButton, Mouse.X, Mouse.Y)
        guiVisible = not guiVisible
        Main.Visible = guiVisible
        ToggleButton.ImageColor3 = guiVisible and Color3.fromRGB(255,255,255) or _G.Color
    end)

    -- Keybind toggle (RightControl)
    local uitoggled = false
    UserInputService.InputBegan:Connect(function(io, p)
        if io.KeyCode == UIConfig.Bind then
            if uitoggled then
                Main:TweenSize(UDim2.new(0,520,0,350), "Out", "Quart", 0.8, true)
                Main.Visible = true
                uitoggled = false
                ToggleButton.ImageColor3 = Color3.fromRGB(255,255,255)
            else
                Main:TweenSize(UDim2.new(0,0,0,0), "Out", "Quart", 0.8, true)
                task.wait(0.1)
                Main.Visible = false
                uitoggled = true
                ToggleButton.ImageColor3 = _G.Color
            end
        end
    end)

    HeaderTop.Name = "Top"
    HeaderTop.Parent = Main
    HeaderTop.BackgroundColor3 = Color3.fromRGB(15, 15, 15)  -- Darker black
    HeaderTop.Size = UDim2.new(1, 0, 0, 35)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 3)
    HeaderCorner.Parent = HeaderTop

    Title.Name = "Title"
    Title.Parent = HeaderTop
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.05, 0, 0, 5)
    Title.Size = UDim2.new(0, 450, 0, 25)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Ryzu Hub" .. "<font color='rgb(138,43,226)'> | True V2</font>  •  " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    Title.RichText = true
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left

    dragify(HeaderTop, Main)

    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.Position = UDim2.new(0, 6, 0, 40)
    TabHolder.Size = UDim2.new(0, 508, 0, 38)
    TabHolder.BackgroundTransparency = 1

    TabContainer.Name = "TabContainer"
    TabContainer.Parent = TabHolder
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.CanvasSize = UDim2.new(2, 0, 0, 0)
    TabContainer.ScrollBarThickness = 0
    TabContainer.VerticalScrollBarInset = Enum.ScrollBarInset.Always

    UIListLayout.Parent = TabContainer
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 15)
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, 0)
    end)

    UIPadding.Parent = TabContainer
    UIPadding.PaddingLeft = UDim.new(0, 3)
    UIPadding.PaddingTop = UDim.new(0, 3)

    Bottom.Name = "Bottom"
    Bottom.Parent = Main
    Bottom.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Bottom.BackgroundTransparency = 1
    Bottom.Position = UDim2.new(0, 10, 0, 85)
    Bottom.Size = UDim2.new(0, 500, 0, 250)

    -- Optional settings gear
    local Menu_Setting = Instance.new("ImageButton")
    Menu_Setting.Parent = HeaderTop
    Menu_Setting.BackgroundTransparency = 1
    Menu_Setting.Position = UDim2.new(1, -30, 0.5, -11)
    Menu_Setting.Size = UDim2.new(0, 22, 0, 22)
    Menu_Setting.Image = "http://www.roblox.com/asset/?id=14479606771"
    Menu_Setting.ImageColor3 = Color3.fromRGB(200,200,200)

    local tabs = {}
    local firstTab = true
    function tabs:Tab(Name, icon)
        local FrameTab = Instance.new("Frame")
        local Tab = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local TextLabel = Instance.new("TextLabel")
        local ImageLabel = Instance.new("ImageLabel")

        FrameTab.Name = "FrameTab"
        FrameTab.Parent = Tab
        FrameTab.BackgroundColor3 = _G.Color
        FrameTab.Position = UDim2.new(0.3, 0, 0.9, 0)
        FrameTab.Size = UDim2.new(0, 0, 0, 2)
        FrameTab.Visible = false
        Instance.new("UICorner", FrameTab).CornerRadius = UDim.new(0, 3)

        Tab.Name = "Tab"
        Tab.Parent = TabContainer
        Tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Tab.Size = UDim2.new(0, 114, 0, 30)
        Tab.Text = ""

        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = Tab

        ImageLabel.Parent = Tab
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Position = UDim2.new(0, 5, 0.2, 0)
        ImageLabel.Size = UDim2.new(0, 20, 0, 20)
        ImageLabel.Image = "rbxassetid://" .. tostring(icon)

        TextLabel.Parent = Tab
        TextLabel.Text = Name
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.new(0.25, 0, 0, 0)
        TextLabel.Size = UDim2.new(0, 80, 1, 0)
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
        TextLabel.TextTransparency = 0.2
        TextLabel.TextSize = 12
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = _G.Color
        TabStroke.Thickness = 2
        TabStroke.Parent = Tab

        local Page = Instance.new("ScrollingFrame")
        Page.Name = "Page"
        Page.Parent = Bottom
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 0
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = false

        local Left = Instance.new("ScrollingFrame")
        Left.Name = "Left"
        Left.Parent = Page
        Left.BackgroundTransparency = 1
        Left.Size = UDim2.new(0, 240, 1, 0)
        Left.ScrollBarThickness = 0
        local Right = Instance.new("ScrollingFrame")
        Right.Name = "Right"
        Right.Parent = Page
        Right.BackgroundTransparency = 1
        Right.Size = UDim2.new(0, 240, 1, 0)
        Right.ScrollBarThickness = 0

        local LeftList = Instance.new("UIListLayout")
        LeftList.Parent = Left
        LeftList.SortOrder = Enum.SortOrder.LayoutOrder
        LeftList.Padding = UDim.new(0, 5)
        local RightList = Instance.new("UIListLayout")
        RightList.Parent = Right
        RightList.SortOrder = Enum.SortOrder.LayoutOrder
        RightList.Padding = UDim.new(0, 5)

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.FillDirection = Enum.FillDirection.Horizontal
        PageLayout.Padding = UDim.new(0, 13)
        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = Page

        if firstTab then
            firstTab = false
            Page.Visible = true
            TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
            TextLabel.TextTransparency = 0
            FrameTab.Size = UDim2.new(0, 40, 0, 2)
            FrameTab.Visible = true
        end

        Tab.MouseButton1Click:Connect(function()
            for _, x in pairs(TabContainer:GetChildren()) do
                if x:IsA("TextButton") then
                    TweenService:Create(x.TextLabel, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(255,255,255), TextTransparency = 0.2 }):Play()
                    TweenService:Create(x.FrameTab, TweenInfo.new(0.2), { Size = UDim2.new(0,0,0,2) }):Play()
                    x.FrameTab.Visible = false
                end
            end
            for _, p in pairs(Bottom:GetChildren()) do
                if p:IsA("ScrollingFrame") then
                    p.Visible = false
                    TweenService:Create(p, TweenInfo.new(0.2), { Position = UDim2.new(0,1500,0,0) }):Play()
                end
            end
            TweenService:Create(TextLabel, TweenInfo.new(0.2), { TextColor3 = _G.Color, TextTransparency = 0 }):Play()
            FrameTab.Visible = true
            TweenService:Create(FrameTab, TweenInfo.new(0.2), { Size = UDim2.new(0,40,0,2) }):Play()
            Page.Visible = true
            Page.Position = UDim2.new(0,0,0,1500)
            TweenService:Create(Page, TweenInfo.new(0.2), { Position = UDim2.new(0,0,0,0) }):Play()
        end)

        RunService.Stepped:Connect(function()
            pcall(function()
                Left.CanvasSize = UDim2.new(0,0,0,LeftList.AbsoluteContentSize.Y + 5)
                Right.CanvasSize = UDim2.new(0,0,0,RightList.AbsoluteContentSize.Y + 5)
            end)
        end)

        local sections = {}
        function sections:CraftPage(side)
            side = side or 1
            local target = (side == 1 and Left or Right)

            local Section = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionContainer = Instance.new("Frame")
            local UIListLayout = Instance.new("UIListLayout")
            local UIPadding = Instance.new("UIPadding")

            Section.Name = "Section"
            Section.Parent = target
            Section.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Section.Size = UDim2.new(1, 0, 0, 100)
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = Section

            SectionContainer.Name = "SectionContainer"
            SectionContainer.Parent = Section
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.Position = UDim2.new(0, 5, 0, 10)
            SectionContainer.Size = UDim2.new(1, -10, 1, -20)

            UIListLayout.Parent = SectionContainer
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 8)
            UIPadding.Parent = SectionContainer
            UIPadding.PaddingTop = UDim.new(0, 5)

            UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + 25)
            end)

            local functionitem = {}

            function functionitem:Label(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = SectionContainer
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.Font = Enum.Font.GothamSemibold
                Label.TextColor3 = Color3.fromRGB(225,225,225)
                Label.TextSize = 10
                Label.Text = text
                Label.TextXAlignment = Enum.TextXAlignment.Left
                local func = {}
                function func:Set(newtext) Label.Text = newtext end
                return func
            end

            function functionitem:Seperator(text)
                local Frame = Instance.new("Frame")
                Frame.Parent = SectionContainer
                Frame.Size = UDim2.new(1, 0, 0, 15)
                Frame.BackgroundTransparency = 1
                local LineL = Instance.new("Frame")
                LineL.Parent = Frame
                LineL.BackgroundColor3 = _G.Color
                LineL.Size = UDim2.new(0, 30, 0, 2)
                LineL.Position = UDim2.new(0, 10, 0.5, -1)
                local LineR = LineL:Clone()
                LineR.Parent = Frame
                LineR.Position = UDim2.new(1, -40, 0.5, -1)
                local Text = Instance.new("TextLabel")
                Text.Parent = Frame
                Text.BackgroundTransparency = 1
                Text.Size = UDim2.new(1, -80, 1, 0)
                Text.Position = UDim2.new(0, 40, 0, 0)
                Text.Font = Enum.Font.GothamBold
                Text.Text = text
                Text.TextColor3 = Color3.fromRGB(255,255,255)
                Text.TextSize = 12
                local func = {}
                function func:Refresh(newtext) Text.Text = newtext end
                return func
            end

            function functionitem:Button(Name, callback)
                local Button = Instance.new("Frame")
                Button.Parent = SectionContainer
                Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Button.Size = UDim2.new(1, 0, 0, 30)
                Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
                local Stroke = Instance.new("UIStroke")
                Stroke.Color = Color3.fromRGB(60,60,60)
                Stroke.Thickness = 1
                Stroke.Parent = Button
                local TextLabel = Instance.new("TextLabel")
                TextLabel.Parent = Button
                TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                TextLabel.BackgroundTransparency = 1
                TextLabel.Font = Enum.Font.GothamBold
                TextLabel.Text = Name
                TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
                TextLabel.TextSize = 10
                local TextButton = Instance.new("TextButton")
                TextButton.Parent = Button
                TextButton.BackgroundTransparency = 1
                TextButton.Size = UDim2.new(1, 0, 1, 0)
                TextButton.Text = ""
                TextButton.MouseEnter:Connect(function() TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play() end)
                TextButton.MouseLeave:Connect(function() TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play() end)
                TextButton.MouseButton1Click:Connect(function()
                    CircleClick(Button, Mouse.X, Mouse.Y)
                    callback()
                end)
            end

            function functionitem:Toggle(Name, default, callback)
                local Tgo = default
                local MainToggle = Instance.new("Frame")
                MainToggle.Parent = SectionContainer
                MainToggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
                MainToggle.Size = UDim2.new(1, 0, 0, 35)
                Instance.new("UICorner", MainToggle).CornerRadius = UDim.new(0, 4)
                local Text = Instance.new("TextLabel")
                Text.Parent = MainToggle
                Text.BackgroundTransparency = 1
                Text.Position = UDim2.new(0, 10, 0, 10)
                Text.Size = UDim2.new(0, 100, 0, 12)
                Text.Font = Enum.Font.GothamBold
                Text.Text = Name
                Text.TextColor3 = Color3.fromRGB(255,255,255)
                Text.TextSize = 14
                Text.TextXAlignment = Enum.TextXAlignment.Left
                local ToggleCircle = Instance.new("ImageLabel")
                ToggleCircle.Parent = MainToggle
                ToggleCircle.AnchorPoint = Vector2.new(0.5,0.5)
                ToggleCircle.Position = UDim2.new(0.9, 0, 0.5, 0)
                ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
                ToggleCircle.BackgroundColor3 = default and _G.Color or Color3.fromRGB(20,20,20)
                ToggleCircle.Image = default and "rbxassetid://6023426926" or ""
                ToggleCircle.ImageColor3 = Color3.fromRGB(255,255,255)
                Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(0, default and 100 or 5)
                local TextButton = Instance.new("TextButton")
                TextButton.Parent = MainToggle
                TextButton.BackgroundTransparency = 1
                TextButton.Size = UDim2.new(1,0,1,0)
                TextButton.Text = ""
                TextButton.MouseButton1Click:Connect(function()
                    Tgo = not Tgo
                    callback(Tgo)
                    ToggleCircle.BackgroundColor3 = Tgo and _G.Color or Color3.fromRGB(20,20,20)
                    ToggleCircle.Image = Tgo and "rbxassetid://6023426926" or ""
                    ToggleCircle.UICorner.CornerRadius = UDim.new(0, Tgo and 100 or 5)
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Size = UDim2.new(0,20,0,20)}):Play()
                    CircleClick(TextButton, Mouse.X, Mouse.Y)
                end)
                if default then callback(default) end
                return {}
            end

            function functionitem:Slider(text, floor, min, max, de, callback)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Parent = SectionContainer
                SliderFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
                SliderFrame.Size = UDim2.new(1, 0, 0, 45)
                Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0,4)
                local Label = Instance.new("TextLabel")
                Label.Parent = SliderFrame
                Label.BackgroundTransparency = 1
                Label.Position = UDim2.new(0.07, 0, 0.04, 0)
                Label.Size = UDim2.new(0, 180, 0, 25)
                Label.Font = Enum.Font.GothamBold
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(255,255,255)
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                local ValueBox = Instance.new("TextBox")
                ValueBox.Parent = SliderFrame
                ValueBox.AnchorPoint = Vector2.new(0.5,0.5)
                ValueBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
                ValueBox.Position = UDim2.new(0.85, 0, 0.5, 0)
                ValueBox.Size = UDim2.new(0, 45, 0, 21)
                ValueBox.Font = Enum.Font.GothamBold
                ValueBox.Text = tostring(de)
                ValueBox.TextColor3 = Color3.fromRGB(255,255,255)
                ValueBox.TextSize = 11
                Instance.new("UICorner", ValueBox).CornerRadius = UDim.new(0,4)
                local Bar = Instance.new("Frame")
                Bar.Parent = SliderFrame
                Bar.AnchorPoint = Vector2.new(0.5,0.5)
                Bar.BackgroundColor3 = Color3.fromRGB(20,20,20)
                Bar.Position = UDim2.new(0.5, 0, 0.8, 0)
                Bar.Size = UDim2.new(0, 180, 0, 5)
                Instance.new("UICorner", Bar).CornerRadius = UDim.new(0,30)
                local Fill = Instance.new("Frame")
                Fill.Parent = Bar
                Fill.BackgroundColor3 = _G.Color
                Fill.Size = UDim2.new((de or 0)/max, 0, 1, 0)
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(0,30)
                local Knob = Instance.new("Frame")
                Knob.Parent = Bar
                Knob.AnchorPoint = Vector2.new(0.7,0.7)
                Knob.BackgroundColor3 = _G.Color
                Knob.Position = UDim2.new((de or 0)/max, 0, 0.5, 0)
                Knob.Size = UDim2.new(0, 10, 0, 10)
                Instance.new("UICorner", Knob).CornerRadius = UDim.new(0,10)
                local dragging = false
                local function move(input)
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    Fill:TweenSize(UDim2.new(pos, 0, 1, 0), "Out", "Sine", 0.1, true)
                    Knob:TweenPosition(UDim2.new(pos, 0, 0.5, 0), "Out", "Sine", 0.1, true)
                    local val = floor and math.floor(pos * (max - min) + min) or math.floor(pos * (max - min) + min + 0.5)
                    ValueBox.Text = tostring(val)
                    callback(val)
                end
                Knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
                Knob.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
                Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true move(i) end end)
                UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then move(i) end end)
                ValueBox.FocusLost:Connect(function()
                    local val = tonumber(ValueBox.Text) or min
                    val = math.clamp(val, min, max)
                    ValueBox.Text = tostring(val)
                    Fill:TweenSize(UDim2.new(val/max, 0, 1, 0), "Out", "Sine", 0.2, true)
                    Knob:TweenPosition(UDim2.new(val/max, 0, 0.5, 0), "Out", "Sine", 0.2, true)
                    callback(val)
                end)
                return {}
            end

            function functionitem:Dropdown(Name, options, default, callback)
                local isOpen = false
                local Dropdown = Instance.new("Frame")
                Dropdown.Parent = SectionContainer
                Dropdown.BackgroundColor3 = Color3.fromRGB(30,30,30)
                Dropdown.Size = UDim2.new(1, 0, 0, 30)
                Dropdown.ClipsDescendants = true
                Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0,2)
                local Title = Instance.new("TextLabel")
                Title.Parent = Dropdown
                Title.BackgroundTransparency = 1
                Title.Size = UDim2.new(1, -25, 1, 0)
                Title.Position = UDim2.new(0, 8, 0, 0)
                Title.Font = Enum.Font.GothamBold
                Title.Text = Name .. " : " .. (default or "")
                Title.TextColor3 = Color3.fromRGB(225,225,225)
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left
                local Arrow = Instance.new("ImageLabel")
                Arrow.Parent = Dropdown
                Arrow.BackgroundTransparency = 1
                Arrow.Position = UDim2.new(1, -22, 0, 6)
                Arrow.Size = UDim2.new(0, 16, 0, 16)
                Arrow.Image = "rbxassetid://7072706663"
                Arrow.Rotation = 180
                local Scroll = Instance.new("ScrollingFrame")
                Scroll.Parent = Dropdown
                Scroll.Position = UDim2.new(0,0,1,0)
                Scroll.Size = UDim2.new(1,0,0,100)
                Scroll.BackgroundTransparency = 1
                Scroll.CanvasSize = UDim2.new(0,0,0,0)
                Scroll.ScrollBarThickness = 2
                local List = Instance.new("UIListLayout")
                List.Parent = Scroll
                List.Padding = UDim.new(0,3)
                local Btn = Instance.new("TextButton")
                Btn.Parent = Dropdown
                Btn.BackgroundTransparency = 1
                Btn.Size = UDim2.new(1,0,1,0)
                Btn.Text = ""
                Btn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    Dropdown:TweenSize(UDim2.new(1,0,0, isOpen and 131 or 30), "Out", "Quad", 0.3, true)
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = isOpen and 0 or 180}):Play()
                end)
                local function addOption(opt)
                    local Item = Instance.new("TextButton")
                    Item.Parent = Scroll
                    Item.BackgroundColor3 = Color3.fromRGB(30,30,30)
                    Item.Size = UDim2.new(1,-6,0,20)
                    Item.Font = Enum.Font.GothamBold
                    Item.Text = opt
                    Item.TextColor3 = Color3.fromRGB(225,225,225)
                    Item.TextSize = 13
                    Instance.new("UICorner", Item).CornerRadius = UDim.new(0,4)
                    Item.MouseButton1Click:Connect(function()
                        Title.Text = Name .. " : " .. opt
                        callback(opt)
                        isOpen = false
                        Dropdown:TweenSize(UDim2.new(1,0,0,30), "Out", "Quad", 0.3, true)
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
                    end)
                end
                for _, opt in ipairs(options) do addOption(opt) end
                List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Scroll.CanvasSize = UDim2.new(0,0,0,List.AbsoluteContentSize.Y + 10)
                end)
                if default then callback(default) end
                return {}
            end

            function functionitem:MultiDropdown(Name, list, default, callback)
                local Dropfunc = {}
                local MainDropDown = Instance.new("Frame")
                MainDropDown.Parent = SectionContainer
                MainDropDown.BackgroundColor3 = Color3.fromRGB(30,30,30)
                MainDropDown.Size = UDim2.new(1, 0, 0, 30)
                MainDropDown.ClipsDescendants = true
                Instance.new("UICorner", MainDropDown).CornerRadius = UDim.new(0,3)
                local Title = Instance.new("TextLabel")
                Title.Parent = MainDropDown
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0,8,0,0)
                Title.Size = UDim2.new(1,-30,1,0)
                Title.Font = Enum.Font.GothamBold
                Title.Text = Name .. " : " .. (default and table.concat(default, ", ") or "")
                Title.TextColor3 = Color3.fromRGB(225,225,225)
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left
                local Arrow = Instance.new("ImageLabel")
                Arrow.Parent = MainDropDown
                Arrow.BackgroundTransparency = 1
                Arrow.Position = UDim2.new(1,-22,0,6)
                Arrow.Size = UDim2.new(0,16,0,16)
                Arrow.Image = "rbxassetid://7072706663"
                Arrow.Rotation = 180
                local Scroll = Instance.new("ScrollingFrame")
                Scroll.Parent = MainDropDown
                Scroll.Position = UDim2.new(0,0,1,0)
                Scroll.Size = UDim2.new(1,0,0,100)
                Scroll.BackgroundTransparency = 1
                Scroll.CanvasSize = UDim2.new(0,0,0,0)
                Scroll.ScrollBarThickness = 2
                local List = Instance.new("UIListLayout")
                List.Parent = Scroll
                List.Padding = UDim.new(0,3)
                local Btn = Instance.new("TextButton")
                Btn.Parent = MainDropDown
                Btn.BackgroundTransparency = 1
                Btn.Size = UDim2.new(1,0,1,0)
                Btn.Text = ""
                local selected = default or {}
                local isOpen = false
                Btn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    MainDropDown:TweenSize(UDim2.new(1,0,0, isOpen and 131 or 30), "Out", "Quad", 0.3, true)
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = isOpen and 0 or 180}):Play()
                end)
                local function addOption(opt)
                    local Item = Instance.new("TextButton")
                    Item.Parent = Scroll
                    Item.BackgroundColor3 = Color3.fromRGB(30,30,30)
                    Item.Size = UDim2.new(1,-6,0,20)
                    Item.Font = Enum.Font.GothamBold
                    Item.Text = opt
                    Item.TextColor3 = Color3.fromRGB(225,225,225)
                    Item.TextSize = 13
                    Instance.new("UICorner", Item).CornerRadius = UDim.new(0,4)
                    Item.MouseButton1Click:Connect(function()
                        if table.find(selected, opt) then
                            table.remove(selected, table.find(selected, opt))
                        else
                            table.insert(selected, opt)
                        end
                        Title.Text = Name .. " : " .. table.concat(selected, ", ")
                        callback(selected, opt)
                    end)
                end
                for _, opt in ipairs(list) do addOption(opt) end
                List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Scroll.CanvasSize = UDim2.new(0,0,0,List.AbsoluteContentSize.Y + 10)
                end)
                return Dropfunc
            end

            function functionitem:Textbox(Name, Placeholder, callback)
                local Textbox = Instance.new("Frame")
                Textbox.Parent = SectionContainer
                Textbox.BackgroundColor3 = Color3.fromRGB(30,30,30)
                Textbox.Size = UDim2.new(1, 0, 0, 35)
                Instance.new("UICorner", Textbox).CornerRadius = UDim.new(0,4)
                local Label = Instance.new("TextLabel")
                Label.Parent = Textbox
                Label.BackgroundTransparency = 1
                Label.Position = UDim2.new(0,10,0,10)
                Label.Size = UDim2.new(0,100,0,12)
                Label.Font = Enum.Font.GothamBold
                Label.Text = Name
                Label.TextColor3 = Color3.fromRGB(255,255,255)
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                local Box = Instance.new("TextBox")
                Box.Parent = Textbox
                Box.AnchorPoint = Vector2.new(0.5,0.5)
                Box.BackgroundColor3 = Color3.fromRGB(20,20,20)
                Box.Position = UDim2.new(0.8, 0, 0.5, 0)
                Box.Size = UDim2.new(0, 80, 0, 25)
                Box.Font = Enum.Font.GothamBold
                Box.PlaceholderText = Placeholder
                Box.PlaceholderColor3 = Color3.fromRGB(150,150,150)
                Box.Text = ""
                Box.TextColor3 = Color3.fromRGB(255,255,255)
                Box.TextSize = 12
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0,4)
                Box.FocusLost:Connect(function(ep)
                    if ep and #Box.Text > 0 then
                        callback(Box.Text)
                        Box.Text = ""
                    end
                end)
            end

            return functionitem
        end
        return sections
    end
    return tabs
end
return library
