local obj = {
	TweenService = game:GetService("TweenService"),
	player = game.Players.LocalPlayer,
	WS = workspace,
	plrGUI = game:WaitForChild("CoreGui"),
	UserInputService = game:GetService("UserInputService"),
	Mouse = game.Players.LocalPlayer:GetMouse(),
	ViewportSize = workspace.CurrentCamera.ViewportSize,
	Stepped = game:GetService("RunService").Stepped
}
local OldMouse = obj.Mouse.Icon
obj.TweenObject = function(cf)
	cf.Object = cf.Object or cf[1]
	cf.Time = cf.Time or cf[2]
	cf.OldValue = cf.OldValue or cf[3]
	cf.NewValue = cf.NewValue or cf[4]
	local Info = TweenInfo.new(cf.Time, Enum.EasingStyle.Quint)
	local tween = obj.TweenService:Create(cf.Object, Info, {[cf.OldValue] = cf.NewValue})
	tween:Play()
	return tween
end
obj.Click = function(Obj, callback)
	Obj.Activated:Connect(function()
		callback()
	end)
end
obj.Find = function(Object,Name)
	for _,v in next, Object:GetChildren() do
		if v.Name == Name then
			return v
		end
	end
end
obj.Mouseto = function(Obj,Callback, Callback2)
	Obj.MouseEnter:Connect(function()
		Callback()
	end)
	Obj.MouseLeave:Connect(function()
		Callback2()
	end)
end
obj.MakeDraggable = function(object,top)
	local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local newPos = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
		object.Position = newPos
    end
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    obj.UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            UpdatePos(input)
        end
    end)
end
obj.CustomSize = function(object)
    local Dragging = false
    local DragInput = nil
    local DragStart = nil
    local StartSize = nil
    local maxSizeX = object.Size.X.Offset
    local maxSizeY = object.Size.Y.Offset
    object.Size = UDim2.new(0, maxSizeX, 0, maxSizeY)
    local changesizeobject = Instance.new("Frame");
    changesizeobject.AnchorPoint = Vector2.new(1, 1)
    changesizeobject.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    changesizeobject.BackgroundTransparency = 0.9990000128746033
    changesizeobject.BorderColor3 = Color3.fromRGB(0, 0, 0)
    changesizeobject.BorderSizePixel = 0
    changesizeobject.Position = UDim2.new(1, 20, 1, 20)
    changesizeobject.Size = UDim2.new(0, 40, 0, 40)
    changesizeobject.Name = "changesizeobject"
    changesizeobject.Parent = object
	obj.Mouseto(changesizeobject, function()
		obj.Mouse.Icon = "rbxassetid://97880490001888"
	end,function()
		obj.Mouse.Icon = OldMouse
	end)
    local function UpdateSize(input)
        local Delta = input.Position - DragStart
        local newWidth = StartSize.X.Offset + Delta.X
        local newHeight = StartSize.Y.Offset + Delta.Y
        newWidth = math.max(newWidth, maxSizeX)
        newHeight = math.max(newHeight, maxSizeY)
        object.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
    changesizeobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartSize = object.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    changesizeobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    obj.UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            UpdateSize(input)
        end
    end)
end
function GetMidPos(mainFrame)
    return UDim2.new(0, (obj.ViewportSize.X/2-mainFrame.Size.X.Offset/ 2), 0, (obj.ViewportSize.Y/2-mainFrame.Size.Y.Offset/2))
end
function obj:Notify(ConfigNotify)
	ConfigNotify = ConfigNotify or {}
	ConfigNotify.Title = ConfigNotify.Title or "God Hub"
	ConfigNotify.Content = ConfigNotify.Content or "..."
	ConfigNotify.Description = ConfigNotify.Description or "By Shinichi"
	ConfigNotify.Duration = ConfigNotify.Duration or 5
	spawn(function()
		if not obj.plrGUI.Window:FindFirstChild("NotifyLayout") then
			local NotifyLayout = Instance.new("Frame");
			NotifyLayout.Name = "NotifyLayout"
			NotifyLayout.Parent = obj.plrGUI.Window
			NotifyLayout.AnchorPoint = Vector2.new(0, 1)
			NotifyLayout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotifyLayout.BackgroundTransparency = 0.999
			NotifyLayout.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NotifyLayout.BorderSizePixel = 0
			NotifyLayout.Position = UDim2.new(1.5, -30, 1, -30)
			NotifyLayout.Size = UDim2.new(0, 280, 0, -105)
			NotifyLayout.ZIndex = 5
			local Counts = 0
			obj.plrGUI.Window.NotifyLayout.ChildRemoved:Connect(function()
				Counts = 0
				for r,v in pairs(obj.plrGUI.Window.NotifyLayout:GetChildren()) do
					if v.ClassName ~= "UICorner" then
						obj.TweenObject({v, 0.6,"Position",UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 15)*Counts))})
						Counts = Counts + 1
					end
				end
			end)
		end
		local NotifyPosHeigh = 0
		for _, v in pairs(obj.plrGUI.Window.NotifyLayout:GetChildren()) do
			NotifyPosHeigh = -(v.Position.Y.Offset) + v.Size.Y.Offset + 15
		end		
		local NotifyFrame = Instance.new("Frame")
		local NotifyFrameReal = Instance.new("Frame")
		local NotifyTop = Instance.new("Frame")
		local NotifyTopTitle = Instance.new("TextLabel")
		local NotifyCloseButton = Instance.new("TextButton")
		local NotifyCloseImage = Instance.new("ImageLabel")
		local UICorner_60 = Instance.new("UICorner")
		local DropShadowHolder_3 = Instance.new("Frame")
		local DropShadow_3 = Instance.new("ImageLabel")
		local NotifyUnderContent = Instance.new("TextLabel")
		local NotifyUnderContent_2 = Instance.new("TextLabel")
		local UIStroke_27 = Instance.new("UIStroke")
		NotifyFrame.Name = "NotifyFrame"
		NotifyFrame.Parent = obj.plrGUI.Window:FindFirstChild("NotifyLayout")
		NotifyFrame.AnchorPoint = Vector2.new(0, 1)
		NotifyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyFrame.BackgroundTransparency = 0.999
		NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.Position = UDim2.new(0, 0, 1, -(NotifyPosHeigh))
		NotifyFrame.Size = UDim2.new(1, 0, 0, 84)
		NotifyFrameReal.Name = "NotifyFrameReal"
		NotifyFrameReal.Parent = NotifyFrame
		NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		NotifyFrameReal.BackgroundTransparency = 0.150
		NotifyFrameReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrameReal.BorderSizePixel = 0
		NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
		NotifyTop.Name = "NotifyTop"
		NotifyTop.Parent = NotifyFrameReal
		NotifyTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyTop.BackgroundTransparency = 0.999
		NotifyTop.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyTop.BorderSizePixel = 0
		NotifyTop.Size = UDim2.new(1, 0, 0, 43)
		NotifyTop.ZIndex = 2
		NotifyTopTitle.Name = "NotifyTopTitle"
		NotifyTopTitle.Parent = NotifyTop
		NotifyTopTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyTopTitle.BackgroundTransparency = 0.999
		NotifyTopTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyTopTitle.BorderSizePixel = 0
		NotifyTopTitle.Position = UDim2.new(0, 15, 0, 15)
		NotifyTopTitle.Size = UDim2.new(0, 86, 0, 13)
		NotifyTopTitle.Font = Enum.Font.GothamBold
		NotifyTopTitle.Text = ConfigNotify.Title
		NotifyTopTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
		NotifyTopTitle.TextSize = 13.000
		NotifyTopTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotifyCloseButton.Name = "NotifyCloseButton"
		NotifyCloseButton.Parent = NotifyTop
		NotifyCloseButton.AnchorPoint = Vector2.new(1, 0)
		NotifyCloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyCloseButton.BackgroundTransparency = 0.999
		NotifyCloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyCloseButton.BorderSizePixel = 0
		NotifyCloseButton.Position = UDim2.new(1, -2, 0, 0)
		NotifyCloseButton.Size = UDim2.new(0, 43, 0, 43)
		NotifyCloseButton.Font = Enum.Font.SourceSans
		NotifyCloseButton.Text = ""
		NotifyCloseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		NotifyCloseButton.TextSize = 14.000
		NotifyCloseImage.Name = "NotifyCloseImage"
		NotifyCloseImage.Parent = NotifyCloseButton
		NotifyCloseImage.AnchorPoint = Vector2.new(0.5, 0.5)
		NotifyCloseImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyCloseImage.BackgroundTransparency = 0.999
		NotifyCloseImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyCloseImage.BorderSizePixel = 0
		NotifyCloseImage.Position = UDim2.new(0.5, 0, 0.5, 0)
		NotifyCloseImage.Size = UDim2.new(1, -25, 1, -25)
		NotifyCloseImage.Image = "rbxassetid://18556800637"
		NotifyCloseImage.ImageColor3 = Color3.fromRGB(230, 230, 230)
		UICorner_60.CornerRadius = UDim.new(0, 5)
		UICorner_60.Parent = NotifyFrameReal
		DropShadowHolder_3.Name = "DropShadowHolder"
		DropShadowHolder_3.Parent = NotifyFrameReal
		DropShadowHolder_3.BackgroundTransparency = 1.000
		DropShadowHolder_3.BorderSizePixel = 0
		DropShadowHolder_3.Size = UDim2.new(1, 0, 1, 0)
		DropShadowHolder_3.ZIndex = 0
		DropShadow_3.Name = "DropShadow"
		DropShadow_3.Parent = DropShadowHolder_3
		DropShadow_3.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShadow_3.BackgroundTransparency = 1.000
		DropShadow_3.BorderSizePixel = 0
		DropShadow_3.Position = UDim2.new(0.496874988, 0, 0.5, 0)
		DropShadow_3.Size = UDim2.new(1, 47, 1, 47)
		DropShadow_3.ZIndex = 0
		DropShadow_3.Image = "rbxassetid://6015897843"
		DropShadow_3.ImageColor3 = Color3.fromRGB(0, 0, 0)
		DropShadow_3.ImageTransparency = 0.500
		DropShadow_3.ScaleType = Enum.ScaleType.Slice
		DropShadow_3.SliceCenter = Rect.new(49, 49, 450, 450)
		NotifyUnderContent.Name = "NotifyUnderContent"
		NotifyUnderContent.Parent = NotifyFrameReal
		NotifyUnderContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyUnderContent.BackgroundTransparency = 0.999
		NotifyUnderContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyUnderContent.BorderSizePixel = 0
		NotifyUnderContent.Position = UDim2.new(0, 15, 0, 30)
		NotifyUnderContent.Size = UDim2.new(1, -30, 0, 35)
		NotifyUnderContent.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		NotifyUnderContent.Text = ConfigNotify.Content
		NotifyUnderContent.TextColor3 = Color3.fromRGB(230, 230, 230)
		NotifyUnderContent.TextSize = 12.000
		NotifyUnderContent.TextWrapped = true
		NotifyUnderContent.TextXAlignment = Enum.TextXAlignment.Left
		NotifyUnderContent.TextYAlignment = Enum.TextYAlignment.Top
		NotifyUnderContent_2.Name = "NotifyUnderContent"
		NotifyUnderContent_2.Parent = NotifyFrameReal
		NotifyUnderContent_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyUnderContent_2.BackgroundTransparency = 0.999
		NotifyUnderContent_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyUnderContent_2.BorderSizePixel = 0
		NotifyUnderContent_2.Position = UDim2.new(0, 15, 0, 55)
		NotifyUnderContent_2.Size = UDim2.new(1, -30, 0, 12)
		NotifyUnderContent_2.Font = Enum.Font.GothamMedium
		NotifyUnderContent_2.Text = ConfigNotify.Description
		NotifyUnderContent_2.TextColor3 = Color3.fromRGB(230, 230, 230)
		NotifyUnderContent_2.TextSize = 12.000
		NotifyUnderContent_2.TextTransparency = 0.600
		NotifyUnderContent_2.TextXAlignment = Enum.TextXAlignment.Left
		NotifyUnderContent_2.Position = UDim2.new(0, 15, 0, 55 + NotifyUnderContent.TextBounds.Y / 2.35)
		UIStroke_27.Parent = NotifyFrameReal
		UIStroke_27.Thickness = 2.500
		obj.TweenObject({NotifyFrameReal, 0.7, "Position",UDim2.new(0,-880,0,-85)})
		NotifyCloseButton.Activated:Connect(function()
			obj.TweenObject({NotifyFrameReal, 0.7, "Position",UDim2.new(0,0,0,-85)})
			task.wait(ConfigNotify.Duration / 1.2)
			Counts = Counts - 1
			NotifyFrame:Destroy()
		end)
		task.wait(ConfigNotify.Duration)
		obj.TweenObject({NotifyFrameReal, 0.7, "Position",UDim2.new(0,0,0,-85)})
		task.wait(ConfigNotify.Duration / 1.2)
		Counts = Counts - 1
		NotifyFrame:Destroy()
	end)
end
function obj:Window(cfw)
	cfw = cfw or {}
	cfw.Title = cfw.Title or "Window 11"
	cfw.Description = cfw.Description or "by Shinichi"
	cfw.User = cfw.User or "_ng.shinichi"
	cfw.IconUser = cfw.IconUser or ""
	cfw.UseAcrylic = cfw.UseAcrylic or false
	cfw.Size = cfw.Size or UDim2.new(0, 600,0, 420)
	cfw.DiscordStatus = cfw.DiscordStatus or "love you hipp"
	cfw.DisplayNameDiscord = cfw.DisplayNameDiscord or "@real_shinichi"
	cfw.DiscordDescription = cfw.DiscordDescription or ""
	cfw.KeyCode = cfw.KeyCode or Enum.KeyCode.RightControl
	local Window = Instance.new("ScreenGui")
	local Window11 = Instance.new("Frame")
	local DropShadowHolder = Instance.new("Frame")
	local DropShadow = Instance.new("ImageLabel")
	local Top = Instance.new("Frame")
	local TopTitle = Instance.new("TextLabel")
	local TopDescription = Instance.new("TextLabel")
	local CloseButton = Instance.new("TextButton")
	local CloseImage = Instance.new("ImageLabel")
	local FrameBiNgu = Instance.new("Frame")
	local FrameOc = Instance.new("Frame")
	local MaxButton = Instance.new("TextButton")
	local MaxImage = Instance.new("ImageLabel")
	local HideButton = Instance.new("TextButton")
	local HideImage = Instance.new("ImageLabel")
	local DecideFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local LayersTab = Instance.new("Frame")
	local Info = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local NamePlayer = Instance.new("TextLabel")
	local LogoFrame = Instance.new("Frame")
	local LogoPlayer = Instance.new("ImageLabel")
	local UICorner_3 = Instance.new("UICorner")
	local UICorner_4 = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DescriptionPlayer = Instance.new("TextLabel")
	local InfoButton = Instance.new("TextButton")
	local SearchFrame = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local SearchImage = Instance.new("ImageLabel")
	local SearchDecide = Instance.new("Frame")
	local UICorner_6 = Instance.new("UICorner")
	local SearchDecide_2 = Instance.new("Frame")
	local UICorner_7 = Instance.new("UICorner")
	local RealLayers = Instance.new("Frame")
	local UIStroke_2 = Instance.new("UIStroke")
	local UIStroke_3 = Instance.new("UIStroke")
	local SearchBoxFrame = Instance.new("Frame")
	local SearchBox = Instance.new("TextBox")
	local ScrollTab = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local UICorner_59 = Instance.new("UICorner")
	local UIStroke_26 = Instance.new("UIStroke")
	local Layers = Instance.new("Frame")
	local AnotherFrame = Instance.new("Frame")
	local DropShadowHolder_2 = Instance.new("Frame")
	local DropShadow_2 = Instance.new("ImageLabel")
	local LogFrame = Instance.new("Frame")
	local UICorner_42 = Instance.new("UICorner")
	local UIStroke_17 = Instance.new("UIStroke")
	local LogTitle = Instance.new("TextLabel")
	local LogContent = Instance.new("TextLabel")
	local LogUnder = Instance.new("Frame")
	local UICorner_43 = Instance.new("UICorner")
	local ConfirmFrame = Instance.new("Frame")
	local UICorner_44 = Instance.new("UICorner")
	local ConfirmButton = Instance.new("TextButton")
	local CancelFrame = Instance.new("Frame")
	local UICorner_45 = Instance.new("UICorner")
	local CancelButton = Instance.new("TextButton")
	local DiscordFrame = Instance.new("Frame")
	local UICorner_46 = Instance.new("UICorner")
	local DiscordUnder = Instance.new("Frame")
	local UICorner_47 = Instance.new("UICorner")
	local NamePlayer_2 = Instance.new("TextLabel")
	local DescriptionPlayer_2 = Instance.new("TextLabel")
	local DiscordUnderUnder = Instance.new("Frame")
	local UICorner_48 = Instance.new("UICorner")
	local DiscordUnderUnderTop = Instance.new("Frame")
	local DiscordTab = Instance.new("Frame")
	local DiscordButtonTab = Instance.new("TextButton")
	local ChoosingFrameDiscord = Instance.new("Frame")
	local UIStroke_18 = Instance.new("UIStroke")
	local UICorner_49 = Instance.new("UICorner")
	local DiscordTab_2 = Instance.new("Frame")
	local DiscordButtonTab_2 = Instance.new("TextButton")
	local ChoosingFrameDiscord_2 = Instance.new("Frame")
	local UIStroke_19 = Instance.new("UIStroke")
	local UICorner_50 = Instance.new("UICorner")
	local DiscordTabLayout = Instance.new("UIListLayout")
	local DiscordAboutMe = Instance.new("TextLabel")
	local DiscordMemberSince = Instance.new("TextLabel")
	local DiscordMemberSinceReal = Instance.new("TextLabel")
	local RealLogoFrame = Instance.new("Frame")
	local UIStroke_20 = Instance.new("UIStroke")
	local LogoInfo = Instance.new("ImageLabel")
	local UICorner_51 = Instance.new("UICorner")
	local StatusFrame = Instance.new("Frame")
	local UICorner_52 = Instance.new("UICorner")
	local UIStroke_21 = Instance.new("UIStroke")
	local StatusImage = Instance.new("ImageLabel")
	local UICorner_53 = Instance.new("UICorner")
	local LayersFolder = Instance.new("Folder")
	local UICorner_54 = Instance.new("UICorner")
	local UIStroke_22 = Instance.new("UIStroke")
	local DiscordStatus = Instance.new("Frame")
	local Frame = Instance.new("Frame")
	local UICorner_55 = Instance.new("UICorner")
	local UIStroke_23 = Instance.new("UIStroke")
	local Frame_2 = Instance.new("Frame")
	local UICorner_56 = Instance.new("UICorner")
	local UIStroke_24 = Instance.new("UIStroke")
	local Frame_3 = Instance.new("Frame")
	local UICorner_57 = Instance.new("UICorner")
	local UIStroke_25 = Instance.new("UIStroke")
	local Frame_4 = Instance.new("Frame")
	local UICorner_58 = Instance.new("UICorner")
	local DescriptionPlayer_3 = Instance.new("TextLabel")
	local AnotherButton = Instance.new("TextButton")
	local SkidderTop1VN = Instance.new("UICorner")
	Window.Name = "Window"
	Window.Parent = obj.plrGUI
	Window.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Window11.Name = "Window11"
	Window11.Parent = Window
	Window11.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Window11.BackgroundTransparency = 0.150
	Window11.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Window11.BorderSizePixel = 0
	Window11.Size = cfw.Size
	Window11.Position = GetMidPos(Window11)
	UICorner_59.Parent = Window11
	UIStroke_26.Parent = Window11
	UIStroke_26.Thickness = 2.600
	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.Parent = Window11
	DropShadowHolder.BackgroundTransparency = 1.000
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
	DropShadowHolder.ZIndex = 0
	DropShadow.Name = "DropShadow"
	DropShadow.Parent = DropShadowHolder
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 0
	DropShadow.Image = "rbxassetid://6015897843"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.500
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	Top.Name = "Top"
	Top.Parent = Window11
	Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Top.BackgroundTransparency = 0.999
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 43)
	Top.ZIndex = 2
	TopTitle.Name = "TopTitle"
	TopTitle.Parent = Top
	TopTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TopTitle.BackgroundTransparency = 0.999
	TopTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TopTitle.BorderSizePixel = 0
	TopTitle.Position = UDim2.new(0, 15, 0, 15)
	TopTitle.Size = UDim2.new(0, 50, 0, 13)
	TopTitle.Font = Enum.Font.GothamBold
	TopTitle.Text = cfw.Title
	TopTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
	TopTitle.TextSize = 13.000
	TopTitle.TextXAlignment = Enum.TextXAlignment.Left
	TopDescription.Name = "TopDescription"
	TopDescription.Parent = Top
	TopDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TopDescription.BackgroundTransparency = 0.999
	TopDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TopDescription.BorderSizePixel = 0
	TopDescription.Position = UDim2.new(0,0, 0, 15)
	TopDescription.Size = UDim2.new(0, 42, 0, 13)
	TopDescription.Font = Enum.Font.Gotham
	TopDescription.Text = cfw.Description
	TopDescription.TextColor3 = Color3.fromRGB(230, 230, 230)
	TopDescription.TextSize = 13.000
	TopDescription.TextTransparency = 0.600
	TopDescription.TextXAlignment = Enum.TextXAlignment.Left
	CloseButton.Name = "CloseButton"
	CloseButton.Parent = Top
	CloseButton.AnchorPoint = Vector2.new(1, 0)
	CloseButton.BackgroundTransparency = 1.000
	CloseButton.BackgroundColor3 = Color3.fromRGB(199, 0, 0)
	CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CloseButton.BorderSizePixel = 0
	CloseButton.Position = UDim2.new(1, 0, 0, 0)
	CloseButton.Size = UDim2.new(0, 43, 0, 43)
	CloseButton.Font = Enum.Font.SourceSans
	CloseButton.AutoButtonColor = false
	CloseButton.Text = ""
	CloseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	CloseButton.TextSize = 14.000
	obj.Mouseto(CloseButton, function()
		CloseButton.BackgroundTransparency = 0
		FrameBiNgu.BackgroundTransparency = 0
		FrameOc.BackgroundTransparency = 0
	end,function()
		CloseButton.BackgroundTransparency = 1.000
		FrameBiNgu.BackgroundTransparency = 1.000
		FrameOc.BackgroundTransparency = 1.000
	end)
	obj.Click(CloseButton, function()
		Window:Destroy()
	end)
	SkidderTop1VN.Parent = CloseButton
	CloseImage.Name = "CloseImage"
	CloseImage.Parent = CloseButton
	CloseImage.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CloseImage.BackgroundTransparency = 0.999
	CloseImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CloseImage.BorderSizePixel = 0
	CloseImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseImage.Size = UDim2.new(1, -25, 1, -25)
	CloseImage.Image = "rbxassetid://18556800637"
	CloseImage.ImageColor3 = Color3.fromRGB(230, 230, 230)
	UICorner.Parent = CloseButton
	FrameBiNgu.Parent = CloseButton
	FrameBiNgu.BackgroundColor3 = Color3.fromRGB(199, 0, 0)
	FrameBiNgu.BorderColor3 = Color3.fromRGB(0, 0, 0)
	FrameBiNgu.BorderSizePixel = 0
	FrameBiNgu.Size = UDim2.new(0, 7, 1, 0)
	FrameBiNgu.BackgroundTransparency = 1.000
	FrameOc.Parent = CloseButton
	FrameOc.BackgroundColor3 = Color3.fromRGB(199, 0, 0)
	FrameOc.BorderColor3 = Color3.fromRGB(0, 0, 0)
	FrameOc.BorderSizePixel = 0
	FrameOc.BackgroundTransparency = 1.000
	FrameOc.Position = UDim2.new(0, 0, 1, -5)
	FrameOc.Size = UDim2.new(1, 0, 0, 5)
	MaxButton.Name = "MaxButton"
	MaxButton.Parent = Top
	MaxButton.AutoButtonColor = false
	MaxButton.AnchorPoint = Vector2.new(1, 0)
	MaxButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MaxButton.BackgroundTransparency = 0.999
	MaxButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MaxButton.BorderSizePixel = 0
	MaxButton.Position = UDim2.new(1, -42, 0, 0)
	MaxButton.Size = UDim2.new(0, 43, 0, 43)
	MaxButton.Font = Enum.Font.SourceSans
	MaxButton.Text = ""
	MaxButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	MaxButton.TextSize = 14.000
	obj.Click(MaxButton,function()
		if Window11.Size.Y.Scale < 1 then
			OldPos = Window11.Position
			OldSize = Window11.Size
			obj.TweenObject({Window11, 0.5, "Size", UDim2.new(1,0,1,0)})
			obj.TweenObject({Window11, 0.5, "Position", UDim2.new(0,0,0,0)})
		else
			obj.TweenObject({Window11, 0.5, "Size", OldSize})
			obj.TweenObject({Window11, 0.5, "Position", OldPos})
		end
	end)
	obj.Mouseto(MaxButton, function()
		MaxButton.BackgroundTransparency = 0.970
	end,function()
		MaxButton.BackgroundTransparency = 0.999
	end)
	MaxImage.Name = "MaxImage"
	MaxImage.Parent = MaxButton
	MaxImage.AnchorPoint = Vector2.new(0.5, 0.5)
	MaxImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MaxImage.BackgroundTransparency = 0.999
	MaxImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MaxImage.BorderSizePixel = 0
	MaxImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	MaxImage.Size = UDim2.new(1, -26, 1, -26)
	MaxImage.Image = "rbxassetid://9886659406"
	MaxImage.ImageColor3 = Color3.fromRGB(230, 230, 230)
	HideButton.Name = "HideButton"
	HideButton.Parent = Top
	HideButton.AutoButtonColor = false
	HideButton.AnchorPoint = Vector2.new(1, 0)
	HideButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HideButton.BackgroundTransparency = 0.999
	HideButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HideButton.BorderSizePixel = 0
	HideButton.Position = UDim2.new(1, -83, 0, 0)
	HideButton.Size = UDim2.new(0, 43, 0, 43)
	HideButton.Font = Enum.Font.SourceSans
	HideButton.Text = ""
	HideButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	HideButton.TextSize = 14.000
	obj.Mouseto(HideButton, function()
		HideButton.BackgroundTransparency = 0.970
	end,function()
		HideButton.BackgroundTransparency = 0.999
	end)
	obj.Click(HideButton,function()
		Window11.Visible = false
	end)
	HideImage.Name = "HideImage"
	HideImage.Parent = HideButton
	HideImage.AnchorPoint = Vector2.new(0.5, 0.5)
	HideImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HideImage.BackgroundTransparency = 0.999
	HideImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HideImage.BorderSizePixel = 0
	HideImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	HideImage.Size = UDim2.new(1, -26, 1, -26)
	HideImage.Image = "rbxassetid://18556824827"
	HideImage.ImageColor3 = Color3.fromRGB(230, 230, 230)
	DecideFrame.Name = "DecideFrame"
	DecideFrame.Parent = Top
	DecideFrame.AnchorPoint = Vector2.new(0.5, 1)
	DecideFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	DecideFrame.BackgroundTransparency = 0.935
	DecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DecideFrame.BorderSizePixel = 0
	DecideFrame.Position = UDim2.new(0.5, 0, 1, 2)
	DecideFrame.Size = UDim2.new(1, -14, 0, 2)
	UICorner.CornerRadius = UDim.new(0, 100)
	UICorner.Parent = DecideFrame
	LayersTab.Name = "LayersTab"
	LayersTab.Parent = Window11
	LayersTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LayersTab.BackgroundTransparency = 0.999
	LayersTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LayersTab.BorderSizePixel = 0
	LayersTab.Position = UDim2.new(0, 12, 0, 52)
	LayersTab.Size = UDim2.new(0, 180, 1, -64)
	Info.Name = "Info"
	Info.Parent = LayersTab
	Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Info.BackgroundTransparency = 1.000
	Info.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Info.BorderSizePixel = 0
	Info.Size = UDim2.new(1, 0, 0, 50)
	obj.Mouseto(Info, function()
		Info.BackgroundTransparency = 0.970
	end,function()
		Info.BackgroundTransparency = 1.000
	end)
	UICorner_2.CornerRadius = UDim.new(0, 4)
	UICorner_2.Parent = Info
	NamePlayer.Name = "NamePlayer"
	NamePlayer.Parent = Info
	NamePlayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NamePlayer.BackgroundTransparency = 0.999
	NamePlayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NamePlayer.BorderSizePixel = 0
	NamePlayer.Position = UDim2.new(0, 52, 0, 14)
	NamePlayer.Size = UDim2.new(1, -60, 0, 12)
	NamePlayer.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	NamePlayer.Text = "_ng.shinchi"
	NamePlayer.TextColor3 = Color3.fromRGB(230, 230, 230)
	NamePlayer.TextSize = 13.000
	NamePlayer.TextWrapped = true
	NamePlayer.TextXAlignment = Enum.TextXAlignment.Left
	LogoFrame.Name = "LogoFrame"
	LogoFrame.Parent = Info
	LogoFrame.AnchorPoint = Vector2.new(0, 0.5)
	LogoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoFrame.BackgroundTransparency = 0.950
	LogoFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoFrame.BorderSizePixel = 0
	LogoFrame.Position = UDim2.new(0, 2, 0.5, 0)
	LogoFrame.Size = UDim2.new(0, 40, 0, 40)
	LogoPlayer.Name = "LogoPlayer"
	LogoPlayer.Parent = LogoFrame
	LogoPlayer.AnchorPoint = Vector2.new(0.5, 0.5)
	LogoPlayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoPlayer.BackgroundTransparency = 0.999
	LogoPlayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoPlayer.BorderSizePixel = 0
	LogoPlayer.Position = UDim2.new(0.5, 0, 0.5, 0)
	LogoPlayer.Size = UDim2.new(1, 0, 1, 0)
	LogoPlayer.Image = "rbxassetid://73406218797433"
	UICorner_3.CornerRadius = UDim.new(0, 1000)
	UICorner_3.Parent = LogoPlayer
	UICorner_4.CornerRadius = UDim.new(0, 1000)
	UICorner_4.Parent = LogoFrame
	UIStroke.Parent = LogoFrame
	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Transparency = 0.950
	UIStroke.Thickness = 2.000
	DescriptionPlayer.Name = "DescriptionPlayer"
	DescriptionPlayer.Parent = Info
	DescriptionPlayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DescriptionPlayer.BackgroundTransparency = 0.999
	DescriptionPlayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DescriptionPlayer.BorderSizePixel = 0
	DescriptionPlayer.Position = UDim2.new(0, 52, 0, 25)
	DescriptionPlayer.Size = UDim2.new(1, -60, 0, 11)
	DescriptionPlayer.Font = Enum.Font.GothamMedium
	DescriptionPlayer.Text = "Local Info"
	DescriptionPlayer.TextColor3 = Color3.fromRGB(230, 230, 230)
	DescriptionPlayer.TextSize = 11.000
	DescriptionPlayer.TextTransparency = 0.600
	DescriptionPlayer.TextWrapped = true
	DescriptionPlayer.TextXAlignment = Enum.TextXAlignment.Left
	InfoButton.Name = "InfoButton"
	InfoButton.Parent = Info
	InfoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	InfoButton.BackgroundTransparency = 0.999
	InfoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	InfoButton.BorderSizePixel = 0
	InfoButton.Size = UDim2.new(1, 0, 1, 0)
	InfoButton.Font = Enum.Font.SourceSans
	InfoButton.Text = ""
	InfoButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	InfoButton.TextSize = 14.000
	obj.Click(InfoButton, function()
		DiscordFrame.Size = UDim2.new(0, 300, 0, 400)
		obj.TweenObject({DiscordFrame, 0.5, "Size",UDim2.new(0, 350, 0, 450)})
		AnotherFrame.Visible = true
	end)
	SearchFrame.Name = "SearchFrame"
	SearchFrame.Parent = LayersTab
	SearchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchFrame.BackgroundTransparency = 0.960
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.ClipsDescendants = true
	SearchFrame.Position = UDim2.new(0, 0, 0, 60)
	SearchFrame.Size = UDim2.new(1, 0, 0, 25)
	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = SearchFrame
	SearchImage.Name = "SearchImage"
	SearchImage.Parent = SearchFrame
	SearchImage.AnchorPoint = Vector2.new(1, 0)
	SearchImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchImage.BackgroundTransparency = 0.999
	SearchImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchImage.BorderSizePixel = 0
	SearchImage.Position = UDim2.new(1, -6, 0, 6)
	SearchImage.Size = UDim2.new(0, 13, 0, 13)
	SearchImage.Image = "rbxassetid://18557078698"
	SearchImage.ImageColor3 = Color3.fromRGB(204, 205, 206)
	SearchDecide.Name = "SearchDecide"
	SearchDecide.Parent = SearchFrame
	SearchDecide.AnchorPoint = Vector2.new(0.5, 1)
	SearchDecide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchDecide.BackgroundTransparency = 0.950
	SearchDecide.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchDecide.BorderSizePixel = 0
	SearchDecide.Position = UDim2.new(0.5, 0, 1, 0)
	SearchDecide.Size = UDim2.new(1, -2, 0, 1)
	UICorner_6.CornerRadius = UDim.new(0, 5)
	UICorner_6.Parent = SearchDecide
	SearchDecide_2.Name = "SearchDecide"
	SearchDecide_2.Parent = SearchDecide
	SearchDecide_2.AnchorPoint = Vector2.new(0.5, 1)
	SearchDecide_2.BackgroundColor3 = Color3.fromRGB(1, 131, 252)
	SearchDecide_2.BackgroundTransparency = 0.999
	SearchDecide_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchDecide_2.BorderSizePixel = 0
	SearchDecide_2.Position = UDim2.new(0.5, 0, 1, 0)
	SearchDecide_2.Size = UDim2.new(1, -4, 0, 1)
	UICorner_7.CornerRadius = UDim.new(0, 5)
	UICorner_7.Parent = SearchDecide_2
	UIStroke_2.Parent = SearchDecide_2
	UIStroke_2.Color = Color3.fromRGB(1, 131, 252)
	UIStroke_2.Transparency = 0.999
	UIStroke_2.Thickness = 0.600
	UIStroke_3.Parent = SearchDecide
	UIStroke_3.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_3.Transparency = 0.950
	UIStroke_3.Thickness = 0.600
	SearchBoxFrame.Name = "SearchBoxFrame"
	SearchBoxFrame.Parent = SearchFrame
	SearchBoxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchBoxFrame.BackgroundTransparency = 0.999
	SearchBoxFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchBoxFrame.BorderSizePixel = 0
	SearchBoxFrame.ClipsDescendants = true
	SearchBoxFrame.Position = UDim2.new(0, 6, 0, 0)
	SearchBoxFrame.Size = UDim2.new(1, -31, 0, 24)
	SearchBox.Name = "SearchBox"
	SearchBox.Parent = SearchBoxFrame
	SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.BackgroundTransparency = 0.999
	SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchBox.BorderSizePixel = 0
	SearchBox.Position = UDim2.new(0, 1, 0, 0)
	SearchBox.Size = UDim2.new(1, -1, 1, 0)
	SearchBox.Font = Enum.Font.GothamMedium
	SearchBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
	SearchBox.PlaceholderText = "Find a setting"
	SearchBox.Text = ""
	SearchBox.TextColor3 = Color3.fromRGB(230, 230, 230)
	SearchBox.TextSize = 11.000
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = LayersTab
	ScrollTab.Active = true
	ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollTab.BackgroundTransparency = 0.999
	ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollTab.BorderSizePixel = 0
	ScrollTab.Position = UDim2.new(0, 0, 0, 95)
	ScrollTab.Size = UDim2.new(1, 0, 1, -95)
	ScrollTab.ZIndex = 0
	ScrollTab.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 220)
    ScrollTab.ScrollBarImageTransparency = 0.850
	ScrollTab.ScrollBarThickness = 0
	obj.Stepped:Connect(function()
		ScrollTab.CanvasSize = UDim2.new(0, 0,0,UIListLayout.AbsoluteContentSize.Y + 15)
	end)
	UIListLayout.Parent = ScrollTab
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 1)
	AnotherFrame.Name = "AnotherFrame"
	AnotherFrame.Parent = Window11
	AnotherFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	AnotherFrame.BackgroundTransparency = 0.999
	AnotherFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AnotherFrame.BorderSizePixel = 0
	AnotherFrame.Size = UDim2.new(1, 0, 1, 0)
	AnotherFrame.Visible = false
	AnotherFrame.ZIndex = 5
	DropShadowHolder_2.Name = "DropShadowHolder"
	DropShadowHolder_2.Parent = AnotherFrame
	DropShadowHolder_2.BackgroundTransparency = 1.000
	DropShadowHolder_2.BorderSizePixel = 0
	DropShadowHolder_2.Size = UDim2.new(1, 0, 1, 0)
	DropShadowHolder_2.ZIndex = 0
	DropShadow_2.Name = "DropShadow"
	DropShadow_2.Parent = DropShadowHolder_2
	DropShadow_2.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow_2.BackgroundTransparency = 1.000
	DropShadow_2.BorderSizePixel = 0
	DropShadow_2.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow_2.Size = UDim2.new(1, 47, 1, 47)
	DropShadow_2.ZIndex = 0
	DropShadow_2.Image = "rbxassetid://6015897843"
	DropShadow_2.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow_2.ImageTransparency = 0.500
	DropShadow_2.ScaleType = Enum.ScaleType.Slice
	DropShadow_2.SliceCenter = Rect.new(49, 49, 450, 450)
	LogFrame.Name = "LogFrame"
	LogFrame.Parent = DropShadow_2
	LogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LogFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	LogFrame.BackgroundTransparency = 0.050
	LogFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogFrame.BorderSizePixel = 0
	LogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	LogFrame.Size = UDim2.new(0, 220, 0, 114)
	LogFrame.Visible = false
	UICorner_42.CornerRadius = UDim.new(0, 5)
	UICorner_42.Parent = LogFrame
	UIStroke_17.Parent = LogFrame
	UIStroke_17.Color = Color3.fromRGB(35, 35, 35)
	LogTitle.Name = "LogTitle"
	LogTitle.Parent = LogFrame
	LogTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogTitle.BackgroundTransparency = 0.999
	LogTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogTitle.BorderSizePixel = 0
	LogTitle.Position = UDim2.new(0, 18, 0, 18)
	LogTitle.Size = UDim2.new(0, 36, 0, 18)
	LogTitle.Font = Enum.Font.GothamBold
	LogTitle.Text = "Title"
	LogTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
	LogTitle.TextSize = 16.000
	LogTitle.TextXAlignment = Enum.TextXAlignment.Left
	LogContent.Name = "LogContent"
	LogContent.Parent = LogFrame
	LogContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogContent.BackgroundTransparency = 0.999
	LogContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogContent.BorderSizePixel = 0
	LogContent.Position = UDim2.new(0, 18, 0, 35)
	LogContent.Size = UDim2.new(0, 82, 0, 12)
	LogContent.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	LogContent.Text = "This is a dialog "
	LogContent.TextColor3 = Color3.fromRGB(230, 230, 230)
	LogContent.TextSize = 12.000
	LogContent.TextTransparency = 0.700
	LogContent.TextXAlignment = Enum.TextXAlignment.Left
	LogUnder.Name = "LogUnder"
	LogUnder.Parent = LogFrame
	LogUnder.AnchorPoint = Vector2.new(0, 1)
	LogUnder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	LogUnder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogUnder.BorderSizePixel = 0
	LogUnder.Position = UDim2.new(0, 0, 1, 0)
	LogUnder.Size = UDim2.new(1, 0, 1, -64)
	UICorner_43.CornerRadius = UDim.new(0, 5)
	UICorner_43.Parent = LogUnder
	ConfirmFrame.Name = "ConfirmFrame"
	ConfirmFrame.Parent = LogUnder
	ConfirmFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	ConfirmFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfirmFrame.BorderSizePixel = 0
	ConfirmFrame.Position = UDim2.new(0, 15, 0, 12)
	ConfirmFrame.Size = UDim2.new(0, 91, 0, 25)
	UICorner_44.CornerRadius = UDim.new(0, 3)
	UICorner_44.Parent = ConfirmFrame
	ConfirmButton.Name = "ConfirmButton"
	ConfirmButton.Parent = ConfirmFrame
	ConfirmButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfirmButton.BackgroundTransparency = 0.999
	ConfirmButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfirmButton.BorderSizePixel = 0
	ConfirmButton.Size = UDim2.new(1, 0, 1, 0)
	ConfirmButton.Font = Enum.Font.GothamBold
	ConfirmButton.Text = "confirm"
	ConfirmButton.TextColor3 = Color3.fromRGB(230, 230, 230)
	ConfirmButton.TextSize = 12.000
	CancelFrame.Name = "CancelFrame"
	CancelFrame.Parent = LogUnder
	CancelFrame.AnchorPoint = Vector2.new(1, 0)
	CancelFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	CancelFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CancelFrame.BorderSizePixel = 0
	CancelFrame.Position = UDim2.new(1, -15, 0, 12)
	CancelFrame.Size = UDim2.new(0, 91, 0, 25)
	UICorner_45.CornerRadius = UDim.new(0, 3)
	UICorner_45.Parent = CancelFrame
	CancelButton.Name = "CancelButton"
	CancelButton.Parent = CancelFrame
	CancelButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CancelButton.BackgroundTransparency = 0.999
	CancelButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CancelButton.BorderSizePixel = 0
	CancelButton.Size = UDim2.new(1, 0, 1, 0)
	CancelButton.Font = Enum.Font.GothamBold
	CancelButton.Text = "cancel"
	CancelButton.TextColor3 = Color3.fromRGB(230, 230, 230)
	CancelButton.TextSize = 12.000
	DiscordFrame.Name = "DiscordFrame"
	DiscordFrame.Parent = DropShadow_2
	DiscordFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	DiscordFrame.BackgroundColor3 = Color3.fromRGB(255, 5, 9)
	DiscordFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordFrame.BorderSizePixel = 0
	DiscordFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	DiscordFrame.Size = UDim2.new(0, 350, 0, 450)
	DiscordFrame.ZIndex = 3
	UICorner_46.CornerRadius = UDim.new(0, 5)
	UICorner_46.Parent = DiscordFrame
	DiscordUnder.Name = "DiscordUnder"
	DiscordUnder.Parent = DiscordFrame
	DiscordUnder.BackgroundColor3 = Color3.fromRGB(16, 18, 21)
	DiscordUnder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordUnder.BorderSizePixel = 0
	DiscordUnder.Position = UDim2.new(0, 0, 0, 80)
	DiscordUnder.Size = UDim2.new(1, 0, 1, -80)
	DiscordUnder.ZIndex = 3
	UICorner_47.CornerRadius = UDim.new(0, 3)
	UICorner_47.Parent = DiscordUnder
	NamePlayer_2.Name = "NamePlayer"
	NamePlayer_2.Parent = DiscordUnder
	NamePlayer_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NamePlayer_2.BackgroundTransparency = 0.999
	NamePlayer_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NamePlayer_2.BorderSizePixel = 0
	NamePlayer_2.Position = UDim2.new(0, 15, 0, 54)
	NamePlayer_2.Size = UDim2.new(1, -30, 0, 16)
	NamePlayer_2.ZIndex = 3
	NamePlayer_2.Font = Enum.Font.GothamBold
	NamePlayer_2.Text = "_ng.shinichi"
	NamePlayer_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	NamePlayer_2.TextSize = 18.000
	NamePlayer_2.TextXAlignment = Enum.TextXAlignment.Left
	DescriptionPlayer_2.Name = "DescriptionPlayer"
	DescriptionPlayer_2.Parent = DiscordUnder
	DescriptionPlayer_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DescriptionPlayer_2.BackgroundTransparency = 0.999
	DescriptionPlayer_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DescriptionPlayer_2.BorderSizePixel = 0
	DescriptionPlayer_2.Position = UDim2.new(0, 15, 0, 70)
	DescriptionPlayer_2.Size = UDim2.new(1, -30, 0, 14)
	DescriptionPlayer_2.ZIndex = 3
	DescriptionPlayer_2.Font = Enum.Font.GothamBold
	DescriptionPlayer_2.Text = "@real_shinichi"
	DescriptionPlayer_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	DescriptionPlayer_2.TextSize = 12.000
	DescriptionPlayer_2.TextTransparency = 0.600
	DescriptionPlayer_2.TextXAlignment = Enum.TextXAlignment.Left
	DiscordUnderUnder.Name = "DiscordUnderUnder"
	DiscordUnderUnder.Parent = DiscordUnder
	DiscordUnderUnder.AnchorPoint = Vector2.new(0.5, 0)
	DiscordUnderUnder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DiscordUnderUnder.BackgroundTransparency = 0.950
	DiscordUnderUnder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordUnderUnder.BorderSizePixel = 0
	DiscordUnderUnder.Position = UDim2.new(0.5, 0, 0, 100)
	DiscordUnderUnder.Size = UDim2.new(1, -30, 1, -115)
	DiscordUnderUnder.ZIndex = 3
	UICorner_48.CornerRadius = UDim.new(0, 5)
	UICorner_48.Parent = DiscordUnderUnder
	DiscordUnderUnderTop.Name = "DiscordUnderUnderTop"
	DiscordUnderUnderTop.Parent = DiscordUnderUnder
	DiscordUnderUnderTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DiscordUnderUnderTop.BackgroundTransparency = 0.999
	DiscordUnderUnderTop.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordUnderUnderTop.BorderSizePixel = 0
	DiscordUnderUnderTop.Position = UDim2.new(0, 12, 0, 4)
	DiscordUnderUnderTop.Size = UDim2.new(1, -24, 0, 25)
	DiscordTab.Name = "DiscordTab"
	DiscordTab.Parent = DiscordUnderUnderTop
	DiscordTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DiscordTab.BackgroundTransparency = 0.999
	DiscordTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordTab.BorderSizePixel = 0
	DiscordTab.Size = UDim2.new(0, 40, 1, 0)
	DiscordButtonTab.Name = "DiscordButtonTab"
	DiscordButtonTab.Parent = DiscordTab
	DiscordButtonTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DiscordButtonTab.BackgroundTransparency = 0.999
	DiscordButtonTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordButtonTab.BorderSizePixel = 0
	DiscordButtonTab.Size = UDim2.new(1, 0, 1, 0)
	DiscordButtonTab.Font = Enum.Font.GothamBold
	DiscordButtonTab.Text = "Activity"
	DiscordButtonTab.TextColor3 = Color3.fromRGB(255, 255, 255)
	DiscordButtonTab.TextSize = 11.000
	DiscordButtonTab.TextTransparency = 0.600
	ChoosingFrameDiscord.Name = "ChoosingFrameDiscord"
	ChoosingFrameDiscord.Parent = DiscordTab
	ChoosingFrameDiscord.AnchorPoint = Vector2.new(0.5, 1)
	ChoosingFrameDiscord.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ChoosingFrameDiscord.BackgroundTransparency = 0.999
	ChoosingFrameDiscord.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ChoosingFrameDiscord.BorderSizePixel = 0
	ChoosingFrameDiscord.Position = UDim2.new(0.5, 0, 1, 0)
	ChoosingFrameDiscord.Size = UDim2.new(1, -14, 0, 1)
	UIStroke_18.Parent = ChoosingFrameDiscord
	UIStroke_18.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_18.Transparency = 0.999
	UIStroke_18.Thickness = 0.600
	UICorner_49.CornerRadius = UDim.new(0, 100)
	UICorner_49.Parent = ChoosingFrameDiscord
	DiscordTab_2.Name = "DiscordTab"
	DiscordTab_2.Parent = DiscordUnderUnderTop
	DiscordTab_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DiscordTab_2.BackgroundTransparency = 0.999
	DiscordTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordTab_2.BorderSizePixel = 0
	DiscordTab_2.Size = UDim2.new(0, 50, 1, 0)
	DiscordButtonTab_2.Name = "DiscordButtonTab"
	DiscordButtonTab_2.Parent = DiscordTab_2
	DiscordButtonTab_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DiscordButtonTab_2.BackgroundTransparency = 0.999
	DiscordButtonTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordButtonTab_2.BorderSizePixel = 0
	DiscordButtonTab_2.Size = UDim2.new(1, 0, 1, 0)
	DiscordButtonTab_2.Font = Enum.Font.GothamBold
	DiscordButtonTab_2.Text = "About Me"
	DiscordButtonTab_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	DiscordButtonTab_2.TextSize = 11.000
	ChoosingFrameDiscord_2.Name = "ChoosingFrameDiscord"
	ChoosingFrameDiscord_2.Parent = DiscordTab_2
	ChoosingFrameDiscord_2.AnchorPoint = Vector2.new(0.5, 1)
	ChoosingFrameDiscord_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ChoosingFrameDiscord_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ChoosingFrameDiscord_2.BorderSizePixel = 0
	ChoosingFrameDiscord_2.Position = UDim2.new(0.5, 0, 1, 0)
	ChoosingFrameDiscord_2.Size = UDim2.new(1, -14, 0, 1)
	UIStroke_19.Parent = ChoosingFrameDiscord_2
	UIStroke_19.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_19.Thickness = 0.600
	UICorner_50.CornerRadius = UDim.new(0, 100)
	UICorner_50.Parent = ChoosingFrameDiscord_2
	DiscordTabLayout.Name = "DiscordTabLayout"
	DiscordTabLayout.Parent = DiscordUnderUnderTop
	DiscordTabLayout.FillDirection = Enum.FillDirection.Horizontal
	DiscordTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	DiscordTabLayout.Padding = UDim.new(0, 12)
	DiscordAboutMe.Name = "DiscordAboutMe"
	DiscordAboutMe.Parent = DiscordUnderUnder
	DiscordAboutMe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DiscordAboutMe.BackgroundTransparency = 0.999
	DiscordAboutMe.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordAboutMe.BorderSizePixel = 0
	DiscordAboutMe.ClipsDescendants = true
	DiscordAboutMe.RichText = true
	DiscordAboutMe.Position = UDim2.new(0, 15, 0, 45)
	DiscordAboutMe.Size = UDim2.new(1, -30, 0, 70)
	DiscordAboutMe.Font = Enum.Font.GothamMedium
	DiscordAboutMe.Text = "coding and sleeping\n<font color='rgb(0, 128, 255)'>anh chi yêu minh em</font>"
	DiscordAboutMe.TextColor3 = Color3.fromRGB(255, 255, 255)
	DiscordAboutMe.TextSize = 11.000
	DiscordAboutMe.TextWrapped = true
	DiscordAboutMe.TextXAlignment = Enum.TextXAlignment.Left
	DiscordAboutMe.TextYAlignment = Enum.TextYAlignment.Top
	DiscordMemberSince.Name = "DiscordMemberSince"
	DiscordMemberSince.Parent = DiscordUnderUnder
	DiscordMemberSince.AnchorPoint = Vector2.new(0, 1)
	DiscordMemberSince.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DiscordMemberSince.BackgroundTransparency = 0.999
	DiscordMemberSince.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordMemberSince.BorderSizePixel = 0
	DiscordMemberSince.Position = UDim2.new(0, 15, 0, 95)
	DiscordMemberSince.Size = UDim2.new(1, -30, 0, 15)
	DiscordMemberSince.Font = Enum.Font.GothamBold
	DiscordMemberSince.Text = "Member Since"
	DiscordMemberSince.TextColor3 = Color3.fromRGB(255, 255, 255)
	DiscordMemberSince.TextSize = 11.000
	DiscordMemberSince.TextTransparency = 0.500
	DiscordMemberSince.TextXAlignment = Enum.TextXAlignment.Left
	DiscordMemberSinceReal.Name = "DiscordMemberSinceReal"
	DiscordMemberSinceReal.Parent = DiscordUnderUnder
	DiscordMemberSinceReal.AnchorPoint = Vector2.new(0, 1)
	DiscordMemberSinceReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DiscordMemberSinceReal.BackgroundTransparency = 0.999
	DiscordMemberSinceReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordMemberSinceReal.BorderSizePixel = 0
	DiscordMemberSinceReal.Position = UDim2.new(0, 15, 0, 115)
	DiscordMemberSinceReal.Size = UDim2.new(1, -30, 0, 15)
	DiscordMemberSinceReal.Font = Enum.Font.GothamMedium
	DiscordMemberSinceReal.Text = "23 September 2024"
	DiscordMemberSinceReal.TextColor3 = Color3.fromRGB(255, 255, 255)
	DiscordMemberSinceReal.TextSize = 12.000
	DiscordMemberSinceReal.TextWrapped = true
	DiscordMemberSinceReal.TextXAlignment = Enum.TextXAlignment.Left
	RealLogoFrame.Name = "RealLogoFrame"
	RealLogoFrame.Parent = DiscordFrame
	RealLogoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	RealLogoFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RealLogoFrame.BorderSizePixel = 0
	RealLogoFrame.Position = UDim2.new(0, 15, 0, 40)
	RealLogoFrame.Size = UDim2.new(0, 80, 0, 80)
	RealLogoFrame.ZIndex = 3
	UIStroke_20.Parent = RealLogoFrame
	UIStroke_20.Color = Color3.fromRGB(16, 18, 21)
	UIStroke_20.Thickness = 4.000
	LogoInfo.Name = "LogoInfo"
	LogoInfo.Parent = RealLogoFrame
	LogoInfo.AnchorPoint = Vector2.new(0.5, 0.5)
	LogoInfo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	LogoInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoInfo.BorderSizePixel = 0
	LogoInfo.Position = UDim2.new(0.5, 0, 0.5, 0)
	LogoInfo.Size = UDim2.new(1, 0, 1, 0)
	LogoInfo.ZIndex = 3
	LogoInfo.Image = "rbxassetid://129781592728096"
	UICorner_51.CornerRadius = UDim.new(0, 100)
	UICorner_51.Parent = LogoInfo
	StatusFrame.Name = "StatusFrame"
	StatusFrame.Parent = RealLogoFrame
	StatusFrame.AnchorPoint = Vector2.new(1, 1)
	StatusFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 21)
	StatusFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	StatusFrame.BorderSizePixel = 0
	StatusFrame.Position = UDim2.new(1, -5, 1, -5)
	StatusFrame.Size = UDim2.new(0, 15, 0, 15)
	StatusFrame.ZIndex = 3
	UICorner_52.CornerRadius = UDim.new(0, 100)
	UICorner_52.Parent = StatusFrame
	UIStroke_21.Parent = StatusFrame
	UIStroke_21.Color = Color3.fromRGB(16, 18, 21)
	UIStroke_21.Thickness = 4.000
	StatusImage.Name = "StatusImage"
	StatusImage.Parent = StatusFrame
	StatusImage.BackgroundColor3 = Color3.fromRGB(16, 18, 21)
	StatusImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	StatusImage.BorderSizePixel = 0
	StatusImage.Size = UDim2.new(1, 0, 1, 0)
	StatusImage.Image = "rbxassetid://99751366504614"
	UICorner_53.CornerRadius = UDim.new(0, 100)
	UICorner_53.Parent = StatusImage
	UICorner_54.CornerRadius = UDim.new(0, 100)
	UICorner_54.Parent = RealLogoFrame
	UIStroke_22.Parent = DiscordFrame
	UIStroke_22.Thickness = 2.600
	DiscordStatus.Name = "DiscordStatus"
	DiscordStatus.Parent = DiscordFrame
	DiscordStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DiscordStatus.BackgroundTransparency = 0.999
	DiscordStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DiscordStatus.BorderSizePixel = 0
	DiscordStatus.Position = UDim2.new(0, 106, 0, 64)
	DiscordStatus.Size = UDim2.new(0, 110, 0, 40)
	DiscordStatus.ZIndex = 3
	Frame.Parent = DiscordStatus
	Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(0, 6, 0, 6)
	Frame.ZIndex = 3
	UICorner_55.CornerRadius = UDim.new(0, 100)
	UICorner_55.Parent = Frame
	UIStroke_23.Parent = Frame
	UIStroke_23.Color = Color3.fromRGB(45, 45, 45)
	Frame_2.Parent = DiscordStatus
	Frame_2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_2.BorderSizePixel = 0
	Frame_2.Position = UDim2.new(0, 0, 0, 10)
	Frame_2.Size = UDim2.new(0, 120, 0, 28)
	Frame_2.ZIndex = 3
	UICorner_56.CornerRadius = UDim.new(0, 12)
	UICorner_56.Parent = Frame_2
	UIStroke_24.Parent = Frame_2
	UIStroke_24.Color = Color3.fromRGB(45, 45, 45)
	Frame_3.Parent = Frame_2
	Frame_3.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Frame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_3.BorderSizePixel = 0
	Frame_3.Position = UDim2.new(0, 10, 0, -5)
	Frame_3.Size = UDim2.new(0, 10, 0, 10)
	Frame_3.ZIndex = 0
	UICorner_57.CornerRadius = UDim.new(0, 100)
	UICorner_57.Parent = Frame_3
	UIStroke_25.Parent = Frame_3
	UIStroke_25.Color = Color3.fromRGB(45, 45, 45)
	Frame_4.Parent = Frame_2
	Frame_4.BackgroundColor3 = Color3.fromRGB(26, 29, 33)
	Frame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_4.BorderSizePixel = 0
	Frame_4.Size = UDim2.new(1, 0, 1, 0)
	UICorner_58.CornerRadius = UDim.new(0, 100)
	UICorner_58.Parent = Frame_4
	DescriptionPlayer_3.Name = "DescriptionPlayer"
	DescriptionPlayer_3.Parent = Frame_4
	DescriptionPlayer_3.AnchorPoint = Vector2.new(0, 0.5)
	DescriptionPlayer_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DescriptionPlayer_3.BackgroundTransparency = 0.999
	DescriptionPlayer_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DescriptionPlayer_3.BorderSizePixel = 0
	DescriptionPlayer_3.Position = UDim2.new(0, 8, 0.5, 0)
	DescriptionPlayer_3.Size = UDim2.new(1, -20, 0, 14)
	DescriptionPlayer_3.Font = Enum.Font.GothamBold
	DescriptionPlayer_3.Text = "Time to make script"
	DescriptionPlayer_3.TextColor3 = Color3.fromRGB(255, 255, 255)
	DescriptionPlayer_3.TextSize = 11.000
	DescriptionPlayer_3.TextXAlignment = Enum.TextXAlignment.Left
	AnotherButton.Name = "AnotherButton"
	AnotherButton.Parent = DropShadowHolder_2
	AnotherButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AnotherButton.BackgroundTransparency = 0.999
	AnotherButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AnotherButton.BorderSizePixel = 0
	AnotherButton.Size = UDim2.new(1, 0, 1, 0)
	AnotherButton.Font = Enum.Font.SourceSans
	AnotherButton.Text = ""
	AnotherButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	AnotherButton.TextSize = 14.000
	--- Layers --
	local Layers = Instance.new("Frame")
	local TopLayers = Instance.new("Frame")
	local NameBack = Instance.new("Frame")
	local BackButton = Instance.new("TextButton")
	local NameBack_2 = Instance.new("Frame")
	local ForwardImage = Instance.new("ImageLabel")
	local BackButton_2 = Instance.new("TextButton")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local LayersPageLayout = Instance.new("UIPageLayout")
	Layers.Name = "Layers"
	Layers.Parent = Window11
	Layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Layers.BackgroundTransparency = 0.999
	Layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Layers.BorderSizePixel = 0
	Layers.Position = UDim2.new(0, 204, 0, 52)
	Layers.Size = UDim2.new(1, -208, 1, -60)
	Layers.ZIndex = 3
	TopLayers.Name = "TopLayers"
	TopLayers.Parent = Layers
	TopLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TopLayers.BackgroundTransparency = 0.999
	TopLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TopLayers.BorderSizePixel = 0
	TopLayers.ClipsDescendants = true
	TopLayers.Size = UDim2.new(1, 0, 0, 30)
	NameBack.Name = "NameBack"
	NameBack.Parent = TopLayers
	NameBack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameBack.BackgroundTransparency = 0.999
	NameBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NameBack.BorderSizePixel = 0
	NameBack.Size = UDim2.new(0, 42, 1, 0)
	BackButton.Name = "BackButton"
	BackButton.Parent = NameBack
	BackButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BackButton.BackgroundTransparency = 0.999
	BackButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BackButton.BorderSizePixel = 0
	BackButton.Size = UDim2.new(1, 0, 1, 0)
	BackButton.Font = Enum.Font.GothamBold
	BackButton.Text = ""
	BackButton.LayoutOrder = 0
	BackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	BackButton.TextSize = 20.000
	BackButton.TextTransparency = 0
	BackButton.TextXAlignment = Enum.TextXAlignment.Left
	NameBack_2.Name = "NameBack"
	NameBack_2.Parent = TopLayers
	NameBack_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameBack_2.BackgroundTransparency = 0.999
	NameBack_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NameBack_2.BorderSizePixel = 0
	NameBack_2.Position = UDim2.new(0, 95, 0, 0)
	NameBack_2.Size = UDim2.new(0, 96, 1, 0)
	ForwardImage.Name = "ForwardImage"
	ForwardImage.Parent = NameBack_2
	ForwardImage.AnchorPoint = Vector2.new(0, 0.5)
	ForwardImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ForwardImage.BackgroundTransparency = 0.999
	ForwardImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ForwardImage.BorderSizePixel = 0
	ForwardImage.Position = UDim2.new(0, 8, 0.54, 0)
	ForwardImage.Size = UDim2.new(0, 16, 0, 16)
	ForwardImage.Image = "rbxassetid://18558566660"
	ForwardImage.ImageColor3 = Color3.fromRGB(230, 230, 230)
	ForwardImage.ImageTransparency = 1.000
	BackButton_2.Name = "BackButton"
	BackButton_2.Parent = NameBack_2
	BackButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BackButton_2.BackgroundTransparency = 0.999
	BackButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BackButton_2.BorderSizePixel = 0
	BackButton_2.Position = UDim2.new(0, 30, 0, 0)
	BackButton_2.Size = UDim2.new(0, 66, 1, 0)
	BackButton_2.Font = Enum.Font.GothamBold
	BackButton_2.Text = ""
	BackButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	BackButton_2.TextSize = 20.000
	BackButton_2.TextTransparency = 0.600
	BackButton_2.TextXAlignment = Enum.TextXAlignment.Left
	UIListLayout_2.Parent = TopLayers
	UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	RealLayers.Name = "RealLayers"
	RealLayers.Parent = Layers
	RealLayers.AnchorPoint = Vector2.new(1, 1)
	RealLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	RealLayers.BackgroundTransparency = 0.999
	RealLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RealLayers.BorderSizePixel = 0
	RealLayers.ClipsDescendants = true
	RealLayers.Position = UDim2.new(1, 0, 1, 0)
	RealLayers.Size = UDim2.new(1, 0, 1, -30)
	RealLayers.ZIndex = 2
	LayersFolder.Name = "LayersFolder"
	LayersFolder.Parent = RealLayers
	LayersPageLayout.Name = "LayersPageLayout"
	LayersPageLayout.Parent = LayersFolder
	LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
	LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad
	LayersPageLayout.GamepadInputEnabled = false
	LayersPageLayout.ScrollWheelInputEnabled = false
	LayersPageLayout.TouchInputEnabled = false
	LayersPageLayout.TweenTime = 0.300
	TopDescription.Position = UDim2.new(0, TopTitle.TextBounds.X + 19, 0, 15)
	obj.Click(AnotherButton, function()
		obj.TweenObject({DiscordFrame, 0.3, "Size",UDim2.new(0, 300, 0, 400)})
		wait(0.03)
		AnotherFrame.Visible = false
	end)
	obj.MakeDraggable(Window11,Top)
	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		for r,v in next, LayersFolder:GetChildren() do
			for con, cu in next, v:GetChildren() do
				if cu:IsA("Frame") then
					local RealSearch = cu.Name:lower():gsub(" ", "")
					local InputText = SearchBox.Text:lower():gsub(" ", "")
					if SearchBox.Text == "" or string.find(RealSearch, InputText) then
						cu.Visible = true
					else
						cu.Visible = false
					end
				end
			end
		end
	end)
	local UITab = {}
	local Counts = 0
	function JumpTo(TabOder, Name)
		warn(TabOder)
		BackButton.LayoutOrder = TabOder
		BackButton.Text = Name
		LayersPageLayout:JumpToIndex(BackButton.LayoutOrder)
		obj.TweenObject({BackButton, 0.4, "TextTransparency", 0})
		obj.TweenObject({BackButton_2, 0.4, "TextTransparency", 0.999})
		obj.TweenObject({ForwardImage, 0.4, "ImageTransparency", 1.000})
		BackButton.Size = UDim2.new(0, BackButton.TextBounds.X + 3, 1, 0)
        NameBack.Size = UDim2.new(0, BackButton.Size.X.Offset, 1, 0)
        NameBack_2.Position = UDim2.new(0, NameBack.Size.X.Offset, 0, 0)
        NameBack_2.Size = UDim2.new(1,-(NameBack_2.Position.X.Offset), 1, 0)
	end
	obj.CustomSize(Window11)
	BackButton.Activated:Connect(function()
		JumpTo(BackButton.LayoutOrder, BackButton.Text)
	end)
	obj.UserInputService.InputBegan:Connect(function(v)
		if v.KeyCode == Enum.KeyCode.LeftControl then
			if Window11.Visible then
				Window11.Visible = false
			else
				Window11.Visible = true
			end
		end
	end)
	function UITab:AddTab(cftab)
		cftab = cftab or {}
		cftab.Title = cftab.Title or "Tab 1"
		cftab.Icon = cftab.Icon or ""
		cftab.TaskbarIcon = cftab.TaskbarIcon or ""
		local Tab = Instance.new("Frame")
		local UICorner_8 = Instance.new("UICorner")
		local TabImage = Instance.new("ImageLabel")
		local TabButton = Instance.new("TextButton")
		local TabName = Instance.new("TextLabel")
		local ScrollLayers = Instance.new("ScrollingFrame")
		local UIListLayout_5 = Instance.new("UIListLayout")
		Tab.Name = "Tab"
		Tab.Parent = ScrollTab
		Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab.BackgroundTransparency = 0.999
		Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BorderSizePixel = 0
		Tab.Size = UDim2.new(1, 0, 0, 32)
		UICorner_8.CornerRadius = UDim.new(0, 4)
		UICorner_8.Parent = Tab
		TabImage.Name = "TabImage"
		TabImage.Parent = Tab
		TabImage.AnchorPoint = Vector2.new(0, 0.5)
		TabImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabImage.BackgroundTransparency = 0.999
		TabImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabImage.BorderSizePixel = 0
		TabImage.Position = UDim2.new(0, 9, 0.5, 0)
		TabImage.Size = UDim2.new(0, 16, 0, 16)
		TabImage.Image = cftab.Icon
		TabImage.ImageTransparency = 0.600
		TabImage.ImageColor3 = Color3.fromRGB(230, 230, 230)
		TabButton.Name = "TabButton"
		TabButton.Parent = Tab
		TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.BackgroundTransparency = 0.999
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 1, 0)
		TabButton.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
		TabButton.Text = ""
		TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.TextSize = 14.000
		TabName.Name = "TabName"
		TabName.Parent = Tab
		TabName.AnchorPoint = Vector2.new(0, 0.5)
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 0.999
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Position = UDim2.new(0, 35, 0.5, 0)
		TabName.Size = UDim2.new(1, -48, 0, 12)
		TabName.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
		TabName.Text = cftab.Title
		TabName.TextColor3 = Color3.fromRGB(230, 230, 230)
		TabName.TextSize = 12.000
		TabName.TextTransparency = 0.600
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		ScrollLayers.Name = "ScrollLayers"
		ScrollLayers.Parent = LayersFolder
		ScrollLayers.Active = true
		ScrollLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollLayers.BackgroundTransparency = 0.999
		ScrollLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrollLayers.BorderSizePixel = 0
		ScrollLayers.Size = UDim2.new(1, 0, 1, 0)
		ScrollLayers.ScrollBarImageColor3 = Color3.fromRGB(230, 230, 230)
		ScrollLayers.CanvasSize = UDim2.new(0, 0, 1.39999998, 0)
        ScrollLayers.ScrollBarImageTransparency = 0.850
		ScrollLayers.ScrollBarThickness = 3
		ScrollLayers.LayoutOrder = Counts
		obj.Stepped:Connect(function()
			ScrollLayers.CanvasSize = UDim2.new(0, 0,0,UIListLayout_5.AbsoluteContentSize.Y + 15)
		end)
		UIListLayout_5.Parent = ScrollLayers
		UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_5.Padding = UDim.new(0, 4)
		if Counts == 0 then
			local ChoosingFrame = Instance.new("Frame")
			local UICorner_9 = Instance.new("UICorner")
			local UIStroke_4 = Instance.new("UIStroke")
			ChoosingFrame.Name = "ChoosingFrame"
			ChoosingFrame.Parent = Tab
			ChoosingFrame.BackgroundColor3 = Color3.fromRGB(93, 197, 248)
			ChoosingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ChoosingFrame.BorderSizePixel = 0
			ChoosingFrame.Position = UDim2.new(0, 1, 0, 10)
			ChoosingFrame.Size = UDim2.new(0, 2, 0, 12)
			UICorner_9.Parent = ChoosingFrame
			UIStroke_4.Parent = ChoosingFrame
			UIStroke_4.Color = Color3.fromRGB(93, 197, 248)
			UIStroke_4.Thickness = 0.600
		end
		if Counts == 0 then
			LayersPageLayout:JumpToIndex(0)
			BackButton.Text = TabName.Text
			TabImage.ImageTransparency = 0
			Tab.BackgroundTransparency = 0.970
			TabName.TextTransparency = 0
			BackButton.LayoutOrder = 0
			BackButton.TextColor3 = Color3.fromRGB(255,255,255)
		end
		if LayersPageLayout.CurrentPage ~= ScrollLayers then
            obj.Mouseto(Tab, function()
                Tab.BackgroundTransparency = 0.960
            end,function()
                Tab.BackgroundTransparency = 0.999
            end)
        end
		TabButton.Activated:Connect(function()
			local RealChooseFrame
			for _,v in next, Tab.Parent:GetChildren() do
				for r, frame in next, v:GetChildren() do
					if frame.Name == "ChoosingFrame" then
						RealChooseFrame = frame
						break
					end
				end
			end
			if RealChooseFrame ~= nil and LayersPageLayout.CurrentPage ~= ScrollLayers then
				for r,v in next, Tab.Parent:GetChildren() do
					if v.ClassName ~= "UIListLayout" then
						obj.TweenObject({v, 0.5, "BackgroundTransparency", 0.999})
						obj.TweenObject({v.TabImage, 0.5, "ImageTransparency", 0.600})
						obj.TweenObject({v.TabName, 0.5, "TextTransparency", 0.600})
					end
				end
				obj.TweenObject({Tab, 0.5, "BackgroundTransparency", 0.970})
				obj.TweenObject({TabImage, 0.5, "ImageTransparency", 0})
				obj.TweenObject({TabName, 0.5, "TextTransparency", 0})
				obj.TweenObject({RealChooseFrame, 0.5, "Position", UDim2.new(0, 1, 0, 11 + (33*ScrollLayers.LayoutOrder))})
				BackButton.Text = TabName.Text
				JumpTo(ScrollLayers.LayoutOrder, TabName.Text)
			end
		end)
		local Sec = {}
		--[[function Sec:AddSecion(ConfigSelection)
			ConfigSelection = ConfigSelection or {}
			ConfigSelection.Title = ConfigSelection.Title or "Section"
			ConfigSelection.Description = ConfigSelection.Description or ""
			ConfigSelection.Icon = ConfigSelection.Icon or ""
			local Section = Instance.new("Frame")
			local SectionTitle = Instance.new("TextLabel")
			local UICorner_36 = Instance.new("UICorner")
			local SectionContent = Instance.new("TextLabel")
			local UIStroke_13 = Instance.new("UIStroke")
			local SectionButton = Instance.new("TextButton")
			local SectionClickImage = Instance.new("ImageLabel")
			local SectionImage = Instance.new("ImageLabel")
			local ScrollLayers = Instance.new("ScrollingFrame")
			local UIListLayout_99 = Instance.new("UIListLayout")
			Section.Name = ConfigSelection.Title
			Section.Parent = ScrollLayers
			Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Section.BackgroundTransparency = 0.950
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.Size = UDim2.new(1, -8, 0, 45)
            obj.Mouseto(Section,function()
                Section.BackgroundTransparency = 0.930
            end,function()
                Section.BackgroundTransparency = 0.950
            end)
			SectionTitle.Name = "SectionTitle"
			SectionTitle.Parent = Section
			SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.BackgroundTransparency = 0.999
			SectionTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionTitle.BorderSizePixel = 0
			SectionTitle.Position = UDim2.new(0, 40, 0, 11)
			SectionTitle.Size = UDim2.new(1, -52, 0, 12)
			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.Text = ConfigSelection.Title
			SectionTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
			SectionTitle.TextSize = 12.000
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			UICorner_36.CornerRadius = UDim.new(0, 4)
			UICorner_36.Parent = Section
			SectionContent.Name = "SectionContent"
			SectionContent.Parent = Section
			SectionContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionContent.BackgroundTransparency = 0.999
			SectionContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionContent.BorderSizePixel = 0
			SectionContent.Position = UDim2.new(0, 40, 0, 21)
			SectionContent.Size = UDim2.new(1, -52, 0, 11)
			SectionContent.Font = Enum.Font.Gotham
			SectionContent.Text = ConfigSelection.Description
			SectionContent.TextColor3 = Color3.fromRGB(230, 230, 230)
			SectionContent.TextSize = 11.000
			SectionContent.TextWrapped = true
			SectionContent.TextTransparency = 0.700
			SectionContent.TextYAlignment = Enum.TextYAlignment.Top
			SectionContent.TextXAlignment = Enum.TextXAlignment.Left
			UIStroke_13.Parent = SectionContent
			UIStroke_13.Color = Color3.fromRGB(230, 230, 230)
			UIStroke_13.Transparency = 0.700
			UIStroke_13.Thickness = 0.300
			SectionButton.Name = "SectionButton"
			SectionButton.Parent = Section
			SectionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionButton.BackgroundTransparency = 0.999
			SectionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionButton.BorderSizePixel = 0
			SectionButton.Size = UDim2.new(1, 0, 1, 0)
			SectionButton.Font = Enum.Font.SourceSans
			SectionButton.Text = ""
			SectionButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			SectionButton.TextSize = 14.000
			SectionClickImage.Name = "SectionClickImage"
			SectionClickImage.Parent = Section
			SectionClickImage.AnchorPoint = Vector2.new(1, 0.5)
			SectionClickImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionClickImage.BackgroundTransparency = 0.999
			SectionClickImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionClickImage.BorderSizePixel = 0
			SectionClickImage.Position = UDim2.new(1, -13, 0.5, 0)
			SectionClickImage.Size = UDim2.new(0, 18, 0, 18)
			SectionClickImage.Image = "rbxassetid://18559403278"
			SectionClickImage.ImageColor3 = Color3.fromRGB(230, 230, 230)
			SectionClickImage.ImageTransparency = 0.500
			SectionImage.Name = "SectionImage"
			SectionImage.Parent = Section
			SectionImage.AnchorPoint = Vector2.new(0, 0.5)
			SectionImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionImage.BackgroundTransparency = 0.999
			SectionImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionImage.BorderSizePixel = 0
			SectionImage.Position = UDim2.new(0, 12, 0.5, 0)
			SectionImage.Size = UDim2.new(0, 16, 0, 16)
			SectionImage.Image = ConfigSelection.Icon
			ScrollLayers.Name = "ScrollLayers"
			ScrollLayers.Parent = LayersFolder
			ScrollLayers.Active = true
			ScrollLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ScrollLayers.BackgroundTransparency = 0.999
			ScrollLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ScrollLayers.BorderSizePixel = 0
			ScrollLayers.Size = UDim2.new(1, 0, 1, 0)
			ScrollLayers.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
			ScrollLayers.CanvasSize = UDim2.new(0, 0, 1.20000005, 0)
			ScrollLayers.ScrollBarThickness = 0
            ScrollLayers.ScrollBarImageTransparency = 0.850
			ScrollLayers.LayoutOrder = Counts
			obj.Stepped:Connect(function()
				ScrollLayers.CanvasSize = UDim2.new(0, 0,0,UIListLayout_99.AbsoluteContentSize.Y + 15)
			end)
			UIListLayout_99.Parent = ScrollLayers
			UIListLayout_99.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_99.Padding = UDim.new(0, 4)
			SectionButton.Activated:Connect(function()
				BackButton_2.Text = SectionTitle.Text
				obj.TweenObject({BackButton, 0.4, "TextTransparency", 0.600})
				obj.TweenObject({BackButton_2, 0.4, "TextTransparency", 0})
				obj.TweenObject({ForwardImage, 0.4, "ImageTransparency", 0})
				LayersPageLayout:JumpToIndex(ScrollLayers.LayoutOrder)
			end)
            if SectionContent.Text == "" then
                SectionTitle.Position = UDim2.new(0, 40, 0, 0)
                SectionTitle.Size = UDim2.new(1, -52, 1, 0)
            end
			obj.Stepped:Connect(function()
				local gay = math.max(SectionContent.TextBounds.Y + 10, 30)
				Section.Size = UDim2.new(1,-8,0, gay + 18)
				SectionContent.Size = UDim2.new(1, -52, 0, gay + 10)
			end)
            SectionButton.Activated:Connect(function()
                Section.BackgroundTransparency = 0.980
                wait(.1)
                Section.BackgroundTransparency = 0.950
            end)]]
			function Sec:AddButton(ConfigButton)
				ConfigButton = ConfigButton or {}
				ConfigButton.Title = ConfigButton.Title or "Button"
				ConfigButton.Icon = ConfigButton.Icon or cftab.Icon
				ConfigButton.ClickName = ConfigButton.ClickName or "Click"
				ConfigButton.Description = ConfigButton.Description or ""
				ConfigButton.Callback = ConfigButton.Callback or function() end
				local Button = Instance.new("Frame")
				local UICorner_18 = Instance.new("UICorner")
				local ButtonContent = Instance.new("TextLabel")
				local ButtonImage = Instance.new("ImageLabel")
				local ButtonTitle = Instance.new("TextLabel")
				local ButtonFrame = Instance.new("Frame")
				local UICorner_19 = Instance.new("UICorner")
				local ButtonButton = Instance.new("TextButton")
				Button.Name = ConfigButton.Title
				Button.Parent = ScrollLayers
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.BackgroundTransparency = 0.970
				Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Button.BorderSizePixel = 0
				Button.Size = UDim2.new(1, -8, 0, 45)
				UICorner_18.CornerRadius = UDim.new(0, 4)
				UICorner_18.Parent = Button
				ButtonContent.Name = "ButtonContent"
				ButtonContent.Parent = Button
				ButtonContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonContent.BackgroundTransparency = 0.999
				ButtonContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonContent.BorderSizePixel = 0
				ButtonContent.Position = UDim2.new(0, 40, 0, 21)
				ButtonContent.Size = UDim2.new(1, -190, 0, 11)
				ButtonContent.Font = Enum.Font.GothamMedium
				ButtonContent.Text = ConfigButton.Description
				ButtonContent.TextColor3 = Color3.fromRGB(255, 255, 255)
				ButtonContent.TextSize = 11.000
				ButtonContent.TextTransparency = 0.600
				ButtonContent.TextWrapped = true
				ButtonContent.TextYAlignment = Enum.TextYAlignment.Top
				ButtonContent.TextXAlignment = Enum.TextXAlignment.Left
				ButtonImage.Name = "ButtonImage"
				ButtonImage.Parent = Button
				ButtonImage.AnchorPoint = Vector2.new(0, 0.5)
				ButtonImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonImage.BackgroundTransparency = 0.999
				ButtonImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonImage.BorderSizePixel = 0
				ButtonImage.Position = UDim2.new(0, 12, 0.5, 0)
				ButtonImage.Size = UDim2.new(0, 16, 0, 16)
				ButtonImage.Image = ConfigButton.Icon
				ButtonTitle.Name = "ButtonTitle"
				ButtonTitle.Parent = Button
				ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonTitle.BackgroundTransparency = 0.999
				ButtonTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonTitle.BorderSizePixel = 0
				ButtonTitle.Position = UDim2.new(0, 40, 0, 11)
				ButtonTitle.Size = UDim2.new(1, -190, 0, 12)
				ButtonTitle.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				ButtonTitle.Text = ConfigButton.Title
				ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				ButtonTitle.TextSize = 12.000
				ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
				ButtonFrame.Name = "ButtonFrame"
				ButtonFrame.Parent = Button
				ButtonFrame.AnchorPoint = Vector2.new(1, 0.5)
				ButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonFrame.BackgroundTransparency = 0.960
				ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonFrame.BorderSizePixel = 0
				ButtonFrame.Position = UDim2.new(1, -9, 0.5, 0)
				ButtonFrame.Size = UDim2.new(0, 125, 0, 26)
                obj.Mouseto(ButtonFrame,function()
                    ButtonFrame.BackgroundTransparency = 0.940
                end,function()
                    ButtonFrame.BackgroundTransparency = 0.960
                end)
				obj.Stepped:Connect(function()
					local gay = math.max(ButtonContent.TextBounds.Y + 10, 30)
					Button.Size = UDim2.new(1,-8,0, gay + 18)
					ButtonContent.Size = UDim2.new(1, -190, 0, gay + 10)
				end)
				UICorner_19.CornerRadius = UDim.new(0, 4)
				UICorner_19.Parent = ButtonFrame
				ButtonButton.Name = "ButtonButton"
				ButtonButton.Parent = ButtonFrame
				ButtonButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonButton.BackgroundTransparency = 0.999
				ButtonButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonButton.BorderSizePixel = 0
				ButtonButton.Size = UDim2.new(1, 0, 1, 0)
				ButtonButton.Font = Enum.Font.GothamMedium
				ButtonButton.TextColor3 = Color3.fromRGB(178, 178, 178)
				ButtonButton.TextSize = 11.000
				ButtonButton.Text = ConfigButton.ClickName
                if ButtonContent.Text == "" then
                    ButtonTitle.Position = UDim2.new(0, 40, 0, 0)
                    ButtonTitle.Size = UDim2.new(1, -190, 1, 0)
                end
				obj.Click(ButtonButton,function()
					ButtonFrame.BackgroundTransparency = 0.850
					obj.TweenObject({ButtonFrame, 0.9, "BackgroundTransparency", 0.960})
					ConfigButton.Callback()
				end)
			end
			function Sec:AddToggle(ConfigToggles)
				ConfigToggles = ConfigToggles or {}
				ConfigToggles.Title = ConfigToggles.Title or "Toggle"
				ConfigToggles.Description = ConfigToggles.Description or ""
				ConfigToggles.IconToggle = ConfigToggles.IconToggle or cftab.Icon
				ConfigToggles.Default = ConfigToggles.Default or false
				ConfigToggles.Callback = ConfigToggles.Callback or function() end
				local Toggle = Instance.new("Frame")
				local ToggleTitle = Instance.new("TextLabel")
				local UICorner_12 = Instance.new("UICorner")
				local ToggleContent = Instance.new("TextLabel")
				local ToggleImage = Instance.new("ImageLabel")
				local ToggleSwitch = Instance.new("Frame")
				local UICorner_13 = Instance.new("UICorner")
				local ToggleCircle = Instance.new("Frame")
				local UICorner_14 = Instance.new("UICorner")
				local UIStroke_6 = Instance.new("UIStroke")
				local ToggleButton = Instance.new("TextButton")
				local ToggleOnOff = Instance.new("TextLabel")
				local ToggleFunc = {Enabled = ConfigToggles.Default}
				Toggle.Name = ConfigToggles.Title
				Toggle.Parent = ScrollLayers
				Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.BackgroundTransparency = 0.970
				Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Toggle.BorderSizePixel = 0
				Toggle.Size = UDim2.new(1, -8, 0, 45)
                obj.Mouseto(Toggle,function()
                    Toggle.BackgroundTransparency = 0.950
                end,function()
                    Toggle.BackgroundTransparency = 0.970
                end)
				ToggleTitle.Name = "ToggleTitle"
				ToggleTitle.Parent = Toggle
				ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleTitle.BackgroundTransparency = 0.999
				ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleTitle.BorderSizePixel = 0
				ToggleTitle.Position = UDim2.new(0, 40, 0, 11)
				ToggleTitle.Size = UDim2.new(1, -158, 0, 12)
				ToggleTitle.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				ToggleTitle.Text = ConfigToggles.Title
				ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				ToggleTitle.TextSize = 12.000
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				UICorner_12.CornerRadius = UDim.new(0, 4)
				UICorner_12.Parent = Toggle
				ToggleContent.Name = "ToggleContent"
				ToggleContent.Parent = Toggle
				ToggleContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleContent.BackgroundTransparency = 0.999
				ToggleContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleContent.BorderSizePixel = 0
				ToggleContent.Position = UDim2.new(0, 40, 0, 21)
				ToggleContent.Size = UDim2.new(1, -158, 0, 11)
				ToggleContent.Font = Enum.Font.GothamMedium
				ToggleContent.Text = ConfigToggles.Description
				ToggleContent.TextWrapped = true
				ToggleContent.TextYAlignment = Enum.TextYAlignment.Top
				ToggleContent.TextColor3 = Color3.fromRGB(255, 255, 255)
				ToggleContent.TextSize = 11.000
				ToggleContent.TextTransparency = 0.600
				ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
				ToggleImage.Name = "ToggleImage"
				ToggleImage.Parent = Toggle
				ToggleImage.AnchorPoint = Vector2.new(0, 0.5)
				ToggleImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleImage.BackgroundTransparency = 0.999
				ToggleImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleImage.BorderSizePixel = 0
				ToggleImage.Position = UDim2.new(0, 12, 0.5, 0)
				ToggleImage.Size = UDim2.new(0, 16, 0, 16)
				ToggleImage.Image = ConfigToggles.IconToggle
				ToggleSwitch.Name = "ToggleSwitch"
				ToggleSwitch.Parent = Toggle
				ToggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
				ToggleSwitch.BackgroundColor3 = Color3.fromRGB(93, 197, 248)
				ToggleSwitch.BackgroundTransparency = 0.999
				ToggleSwitch.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleSwitch.BorderSizePixel = 0
				ToggleSwitch.Position = UDim2.new(1, -25, 0.5, 0)
				ToggleSwitch.Size = UDim2.new(0, 32, 0, 16)
				UICorner_13.Parent = ToggleSwitch
				ToggleCircle.Name = "ToggleCircle"
				ToggleCircle.Parent = ToggleSwitch
				ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
				ToggleCircle.BackgroundColor3 = Color3.fromRGB(113, 111, 112)
				ToggleCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleCircle.BorderSizePixel = 0
				ToggleCircle.Position = UDim2.new(0, 2, 0.5, 0)
				ToggleCircle.Size = UDim2.new(0, 12, 0, 12)
				UICorner_14.CornerRadius = UDim.new(0, 15)
				UICorner_14.Parent = ToggleCircle
				UIStroke_6.Parent = ToggleSwitch
				UIStroke_6.Color = Color3.fromRGB(113, 111, 112)
				ToggleButton.Name = "ToggleButton"
				ToggleButton.Parent = Toggle
				ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleButton.BackgroundTransparency = 0.999
				ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.BorderSizePixel = 0
				ToggleButton.Size = UDim2.new(1, 0, 1, 0)
				ToggleButton.Font = Enum.Font.SourceSans
				ToggleButton.Text = ""
				ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.TextSize = 14.000
				ToggleOnOff.Name = "ToggleOnOff"
				ToggleOnOff.Parent = Toggle
				ToggleOnOff.AnchorPoint = Vector2.new(1, 0.5)
				ToggleOnOff.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleOnOff.BackgroundTransparency = 0.999
				ToggleOnOff.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleOnOff.BorderSizePixel = 0
				ToggleOnOff.Position = UDim2.new(1, -70, 0.5, 0)
				ToggleOnOff.Size = UDim2.new(0, 30, 0, 12)
				ToggleOnOff.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
				ToggleOnOff.Text = (ConfigToggles.Default == false and "Off" or "On")
				ToggleOnOff.TextColor3 = Color3.fromRGB(255, 255, 255)
				ToggleOnOff.TextSize = 12.000
				ToggleOnOff.TextXAlignment = Enum.TextXAlignment.Right
                if ToggleContent.Text == "" then
                    ToggleTitle.Position = UDim2.new(0, 40, 0, 0)
				    ToggleTitle.Size = UDim2.new(1, -158, 1, 0)
                end
				obj.Stepped:Connect(function()
					local gay = math.max(ToggleContent.TextBounds.Y + 10, 30)
					Toggle.Size = UDim2.new(1,-8,0, gay + 18)
					ToggleContent.Size = UDim2.new(1, -158, 0, gay + 10)
				end)
				function ToggleFunc:SetValue(boolean)
					if boolean then
						obj.TweenObject({ToggleSwitch, 0.5, "BackgroundTransparency", 0})
						obj.TweenObject({ToggleCircle, 0.5, "BackgroundColor3", Color3.fromRGB(4, 3, 1)})
						obj.TweenObject({ToggleCircle, 0.5, "Position", UDim2.new(0, 17, 0.5, 0)})
						obj.TweenObject({UIStroke_6, 0.5, "Color", Color3.fromRGB(93, 197, 248)})
						ToggleOnOff.Text = "On"
					else
						obj.TweenObject({ToggleSwitch, 0.5, "BackgroundTransparency", 0.999})
						obj.TweenObject({ToggleCircle, 0.5, "BackgroundColor3", Color3.fromRGB(113, 111, 112)})
						obj.TweenObject({ToggleCircle, 0.5, "Position", UDim2.new(0, 2, 0.5, 0)})
						obj.TweenObject({UIStroke_6, 0.5, "Color", Color3.fromRGB(113, 111, 112)}) -- 
						ToggleOnOff.Text = "Off"
					end
					ToggleFunc.Enabled = boolean
					ConfigToggles.Callback(ToggleFunc.Enabled)
				end
				ToggleButton.Activated:Connect(function()
					ToggleFunc:SetValue(not ToggleFunc.Enabled)
				end)
                ToggleButton.Activated:Connect(function()
					Toggle.BackgroundTransparency = 0.985
                    wait(.1)
                    Toggle.BackgroundTransparency = 0.970
				end)
				ToggleFunc:SetValue(ToggleFunc.Enabled)
				return ToggleFunc
			end
            function Sec:AddDropdown(ConfigDropdown)
                ConfigDropdown = ConfigDropdown or {}
                ConfigDropdown.Title = ConfigDropdown.Title or "Dropdown"
                ConfigDropdown.Description = ConfigDropdown.Description or ""
                ConfigDropdown.IconDrop = ConfigDropdown.IconDrop or cftab.Icon
                ConfigDropdown.Values = ConfigDropdown.Values or {}
                ConfigDropdown.Multi = ConfigDropdown.Multi or false
                ConfigDropdown.Callback = ConfigDropdown.Callback or function() end
                local Dropdown = Instance.new("Frame")
                local DropdownTitle = Instance.new("TextLabel")
                local UICorner_27 = Instance.new("UICorner")
                local DropdownContent = Instance.new("TextLabel")
                local DropdownImage = Instance.new("ImageLabel")
                local SelectOptionsFrame = Instance.new("Frame")
                local UICorner_28 = Instance.new("UICorner")
                local OptionSelecting = Instance.new("TextLabel")
                local OptionImg = Instance.new("ImageLabel")
                local DropMore = Instance.new("Frame")
                local DropButton = Instance.new("TextButton")
                local DropdownSelectReal = Instance.new("Frame")
                local DropFrame = Instance.new("Frame")
                local DropdownFolder = Instance.new("Folder")
                local DropdownButton = Instance.new("TextButton")
                local UICorner_41 = Instance.new("UICorner")
                local UIStroke_16 = Instance.new("UIStroke")
                local ScrollSelect = Instance.new("ScrollingFrame")
                local UIListLayout_6 = Instance.new("UIListLayout")
                local DropFunc = {List = ConfigDropdown.Values, Value = ConfigDropdown.Default}
                DropMore.Name = "DropMore"
                DropMore.Parent = Layers
                DropMore.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropMore.BackgroundTransparency = 0.999
                DropMore.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DropMore.BorderSizePixel = 0
                DropMore.Position = UDim2.new(0, 0, 0, 30)
                DropMore.Size = UDim2.new(1, 0, 1, -30)
                DropMore.Visible = false
                DropMore.ClipsDescendants = true
                DropMore.ZIndex = 3
                DropButton.Name = "DropButton"
                DropButton.Parent = DropMore
                DropButton.AnchorPoint = Vector2.new(1, 1)
                DropButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropButton.BackgroundTransparency = 0.999
                DropButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DropButton.BorderSizePixel = 0
                DropButton.Position = UDim2.new(0.6, 0,1, 10)
                DropButton.Size = UDim2.new(1, 50,1, 94)
                DropButton.Font = Enum.Font.SourceSans
                DropButton.Text = ""
                DropButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                DropButton.TextSize = 14.000
                DropdownSelectReal.Name = "DropdownSelectReal"
                DropdownSelectReal.Parent = DropMore
                DropdownSelectReal.AnchorPoint = Vector2.new(1, 0)
                DropdownSelectReal.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                DropdownSelectReal.BackgroundTransparency = 0.100
                DropdownSelectReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DropdownSelectReal.BorderSizePixel = 0
                DropdownSelectReal.ClipsDescendants = true
                DropdownSelectReal.Position = UDim2.new(1.42, -17, 0, 7)
                DropdownSelectReal.Size = UDim2.new(0, 134, 1, 0)
                DropFrame.Name = "DropFrame"
                DropFrame.Parent = DropdownSelectReal
                DropFrame.AnchorPoint = Vector2.new(0, 0.5)
                DropFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                DropFrame.BackgroundTransparency = 0.999
                DropFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DropFrame.BorderSizePixel = 0
                DropFrame.Position = UDim2.new(0, 5, 0.5, 0)
                DropFrame.Size = UDim2.new(1, -7, 1, -10)
                DropdownFolder.Name = "DropdownFolder"
                DropdownFolder.Parent = DropFrame
                ScrollSelect.Name = "ScrollSelect"
                ScrollSelect.Parent = DropdownFolder
                ScrollSelect.Active = true
                ScrollSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ScrollSelect.BackgroundTransparency = 0.999
                ScrollSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ScrollSelect.BorderSizePixel = 0
                ScrollSelect.ClipsDescendants = true
                ScrollSelect.Size = UDim2.new(1, 0, 1, 0)
                ScrollSelect.ScrollBarImageColor3 = Color3.fromRGB(230, 230, 230)
                ScrollSelect.CanvasSize = UDim2.new(0, 0, 1.10000002, 0)
                ScrollSelect.ScrollBarImageTransparency = 0.850
                ScrollSelect.ScrollBarThickness = 2
				obj.Stepped:Connect(function()
					ScrollSelect.CanvasSize = UDim2.new(0, 0,0,UIListLayout_6.AbsoluteContentSize.Y + 15)
				end)
                UIListLayout_6.Parent = ScrollSelect
                UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout_6.Padding = UDim.new(0, 3)
				obj.Mouseto(SelectOptionsFrame, function()
					SelectOptionsFrame.BackgroundTransparency = 0.935
				end,function()
					SelectOptionsFrame.BackgroundTransparency = 0.960
				end)
                Dropdown.Name = ConfigDropdown.Title
                Dropdown.Parent = ScrollLayers
                Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.BackgroundTransparency = 0.970
                Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Dropdown.BorderSizePixel = 0
                Dropdown.Size = UDim2.new(1, -8, 0, 45)
                DropdownTitle.Name = "DropdownTitle"
                DropdownTitle.Parent = Dropdown
                DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropdownTitle.BackgroundTransparency = 0.999
                DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DropdownTitle.BorderSizePixel = 0
                DropdownTitle.Position = UDim2.new(0, 40, 0, 11)
                DropdownTitle.Size = UDim2.new(1, -180, 0, 12)
                DropdownTitle.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                DropdownTitle.Text = ConfigDropdown.Title
                DropdownTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropdownTitle.TextSize = 12.000
                DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
                UICorner_27.CornerRadius = UDim.new(0, 4)
                UICorner_27.Parent = Dropdown
                DropdownContent.Name = "DropdownContent"
                DropdownContent.Parent = Dropdown
                DropdownContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropdownContent.BackgroundTransparency = 0.999
                DropdownContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DropdownContent.BorderSizePixel = 0
                DropdownContent.Position = UDim2.new(0, 40, 0, 21)
                DropdownContent.Size = UDim2.new(1, -180, 0, 11)
                DropdownContent.Font = Enum.Font.GothamMedium
                DropdownContent.Text = ConfigDropdown.Description
				DropdownContent.TextWrapped = true
				DropdownContent.TextYAlignment = Enum.TextYAlignment.Top
                DropdownContent.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropdownContent.TextSize = 11.000
                DropdownContent.TextTransparency = 0.600
                DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
                DropdownImage.Name = "DropdownImage"
                DropdownImage.Parent = Dropdown
                DropdownImage.AnchorPoint = Vector2.new(0, 0.5)
                DropdownImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropdownImage.BackgroundTransparency = 0.999
                DropdownImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DropdownImage.BorderSizePixel = 0
                DropdownImage.Position = UDim2.new(0, 12, 0.5, 0)
                DropdownImage.Size = UDim2.new(0, 16, 0, 16)
                DropdownImage.Image = ConfigDropdown.IconDrop
                DropdownImage.ImageColor3 = Color3.fromRGB(230, 230, 230)
                SelectOptionsFrame.Name = "SelectOptionsFrame"
                SelectOptionsFrame.Parent = Dropdown
                SelectOptionsFrame.AnchorPoint = Vector2.new(1, 0.5)
                SelectOptionsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SelectOptionsFrame.BackgroundTransparency = 0.960
                SelectOptionsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SelectOptionsFrame.BorderSizePixel = 0
                SelectOptionsFrame.Position = UDim2.new(1, -9, 0.5, 0)
                SelectOptionsFrame.Size = UDim2.new(0, 125, 0, 26)
                UICorner_28.CornerRadius = UDim.new(0, 4)
                UICorner_28.Parent = SelectOptionsFrame
                OptionSelecting.Name = "OptionSelecting"
                OptionSelecting.Parent = SelectOptionsFrame
                OptionSelecting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                OptionSelecting.BackgroundTransparency = 0.999
                OptionSelecting.BorderColor3 = Color3.fromRGB(0, 0, 0)
                OptionSelecting.BorderSizePixel = 0
                OptionSelecting.Position = UDim2.new(0, 7, 0, 0)
                OptionSelecting.Size = UDim2.new(1, -30, 1, 0)
                OptionSelecting.Font = Enum.Font.GothamMedium
                OptionSelecting.Text = ""
                OptionSelecting.TextColor3 = Color3.fromRGB(178, 178, 178)
                OptionSelecting.TextSize = 11.000
                OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
                OptionImg.Name = "OptionImg"
                OptionImg.Parent = SelectOptionsFrame
                OptionImg.AnchorPoint = Vector2.new(1, 0.5)
                OptionImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                OptionImg.BackgroundTransparency = 0.999
                OptionImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
                OptionImg.BorderSizePixel = 0
                OptionImg.Position = UDim2.new(1, -5, 0.5, 1)
                OptionImg.Rotation = 90.000
                OptionImg.Size = UDim2.new(0, 16, 0, 16)
                OptionImg.Image = "rbxassetid://18558566660"
                OptionImg.ImageColor3 = Color3.fromRGB(178, 178, 178)
                DropdownButton.Name = "DropdownButton"
                DropdownButton.Parent = SelectOptionsFrame
                DropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropdownButton.BackgroundTransparency = 1.000
                DropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                DropdownButton.Font = Enum.Font.SourceSans
                DropdownButton.Text = ""
                DropdownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                DropdownButton.TextSize = 14.000
                UICorner_41.CornerRadius = UDim.new(0, 3)
                UICorner_41.Parent = DropdownSelectReal
                UIStroke_16.Parent = DropdownSelectReal
                UIStroke_16.Color = Color3.fromRGB(10, 10, 10)
                UIStroke_16.Thickness = 2.500
				obj.Stepped:Connect(function()
					local gay = math.max(DropdownContent.TextBounds.Y + 10, 30)
					Dropdown.Size = UDim2.new(1,-8,0, gay + 18)
					DropdownContent.Size = UDim2.new(1, -180, 0, gay + 10)
				end)
				if DropdownContent.Text == '' then
					DropdownTitle.Size = UDim2.new(1, -180, 1, 0)
					DropdownTitle.Position = UDim2.new(0,40,0,0)
				end
                obj.Click(DropdownButton, function()
                    DropMore.Visible = true
                    for r,v in next, LayersFolder:GetDescendants() do
                        if v.ClassName == "TextButton" then
                            v.Active = false
                        end
                    end
                    obj.TweenObject({DropdownSelectReal, 0.5, "Position", UDim2.new(1, -17,0, 7)})
                end)
                obj.Click(DropButton, function()
                    for r,v in next, LayersFolder:GetDescendants() do
                        if v.ClassName == "TextButton" then
                            v.Active = true
                        end
                    end
                    obj.TweenObject({DropdownSelectReal, 0.5, "Position", UDim2.new(1.42, -17,0, 7)})
                    wait(.1)
                    DropMore.Visible = false
                end)
                function DropFunc:Set(Value)
                    DropFunc.Value = Value or DropFunc.Value
                    for r,v in next, ScrollSelect:GetChildren() do
                        if v.ClassName ~= "UIListLayout" and table.find(DropFunc.Value, v.OptionSelecting.Text) then
                            v.ChooseFrame.UIStroke.Enabled = true
                            obj.TweenObject({v, 0.4, "BackgroundTransparency",0.950})
                            obj.TweenObject({v.ChooseFrame, 0.4, "Size",UDim2.new(0, 1, 0, 10)})
                        elseif v.ClassName ~= "UIListLayout" and not table.find(DropFunc.Value, v.OptionSelecting.Text) then
                            obj.TweenObject({v, 0.4, "BackgroundTransparency",0.999})
                            obj.TweenObject({v.ChooseFrame, 0.4, "Size",UDim2.new(0, 1, 0, 0)})
                            v.ChooseFrame.UIStroke.Enabled = false
                        end
                    end
                    local DropdownValue = {}
					for r, v in pairs(DropFunc.Value) do
						if typeof(r) == "number" then
							table.insert(DropdownValue, v)
						elseif typeof(v) == "boolean" then
							if v then
								table.insert(DropdownValue, r)
							end
						end
					end 
                    if #DropdownValue == 0 then
                        OptionSelecting.Text = ""
                    else
                        OptionSelecting.Text = table.concat(DropdownValue, ",")
                    end
                    if ConfigDropdown.Multi then
						ConfigDropdown.Callback(DropdownValue)
					else
						ConfigDropdown.Callback(table.concat(DropdownValue, ","))
					end
                end
                local OptionCounts = 0
                function DropFunc:AddValue(NameValue)
                    local Option = Instance.new("Frame")
                    local UICorner_37 = Instance.new("UICorner")
                    local OptionSelecting_2 = Instance.new("TextLabel")
                    local OptionButton = Instance.new("TextButton")
                    Option.Name = "Option"
                    Option.Parent = ScrollSelect
                    Option.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                    Option.BackgroundTransparency = 0.999 -- 950
                    Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(1, -5, 0, 26)
                    Option.LayoutOrder = OptionCounts
                    UICorner_37.CornerRadius = UDim.new(0, 3)
                    UICorner_37.Parent = Option
                    OptionSelecting_2.Name = "OptionSelecting"
                    OptionSelecting_2.Parent = Option
                    OptionSelecting_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    OptionSelecting_2.BackgroundTransparency = 0.999
                    OptionSelecting_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    OptionSelecting_2.BorderSizePixel = 0
                    OptionSelecting_2.Position = UDim2.new(0, 10, 0, 0)
                    OptionSelecting_2.Size = UDim2.new(1, -20, 1, 0)
                    OptionSelecting_2.Font = Enum.Font.GothamBold
                    OptionSelecting_2.Text = NameValue
                    OptionSelecting_2.TextColor3 = Color3.fromRGB(230, 230, 230)
                    OptionSelecting_2.TextSize = 11.000
                    OptionSelecting_2.TextXAlignment = Enum.TextXAlignment.Left
                    OptionButton.Name = "OptionButton"
                    OptionButton.Parent = Option
                    OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    OptionButton.BackgroundTransparency = 0.999
                    OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Size = UDim2.new(1, 0, 1, 0)
                    OptionButton.Font = Enum.Font.GothamBold
                    OptionButton.Text = ""
                    OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptionButton.TextSize = 13.000
                    OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                    -- ChooseFrame --
                    local ChooseFrame = Instance.new("Frame")
                    local UIStroke_14 = Instance.new("UIStroke")
                    local UICorner_38 = Instance.new("UICorner")
                    ChooseFrame.Name = "ChooseFrame"
                    ChooseFrame.Parent = Option
                    ChooseFrame.AnchorPoint = Vector2.new(0, 0.5)
                    ChooseFrame.BackgroundColor3 = Color3.fromRGB(1, 131, 252)
                    ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    ChooseFrame.BorderSizePixel = 0
                    ChooseFrame.Position = UDim2.new(0, 2, 0.5, 0)
                    ChooseFrame.Size = UDim2.new(0, 1, 0, 0)
                    UIStroke_14.Parent = ChooseFrame
                    UIStroke_14.Color = Color3.fromRGB(1, 131, 252)
                    UIStroke_14.Thickness = 0.800
                    UIStroke_14.Enabled = false
                    UICorner_38.Parent = ChooseFrame
                    obj.Click(OptionButton,function()
                        if ConfigDropdown.Multi then
                            if Option.BackgroundTransparency >= 0.999 then
                                table.insert(DropFunc.Value, OptionSelecting_2.Text)
                                DropFunc:Set(DropFunc.Value)
                            else
                                for i,v in pairs(DropFunc.Value) do
                                    if v == OptionSelecting_2.Text then
                                        table.remove(DropFunc.Value, i)
                                        break
                                    end
                                end
                                DropFunc:Set(DropFunc.Value)
                            end
                        else
                            DropFunc.Value = {OptionSelecting_2.Text}
                            DropFunc:Set(DropFunc.Value)
                        end
                    end)
                end
                function DropFunc:Clear()
                    for r,v in next, ScrollSelect:GetChildren() do
                        if v.Name ~= "UIListLayout" then
                            DropFunc.Value = {}
                            DropFunc.List = {}
                            v:Destroy()
                        end
                    end
                end
                function DropFunc:Refresh(NewValue)
                    DropFunc:Clear()
                    for r,v in pairs(NewValue) do
                        DropFunc:AddValue(v)
                    end
                end
                DropFunc:Refresh(ConfigDropdown.Values)
                DropFunc:Set((typeof(DropFunc.Value) == "table" and DropFunc.Value or {DropFunc.Value}))
                return DropFunc
            end
			function Sec:AddSlider(ConfigSlider)
				ConfigSlider = ConfigSlider or {}
				ConfigSlider.Title = ConfigSlider.Title or "Slider"
				ConfigSlider.Description = ConfigSlider.Description or ""
				ConfigSlider.Max = ConfigSlider.Max or 50
				ConfigSlider.Min = ConfigSlider.Min or 1
				ConfigSlider.IconSlider = ConfigSlider.IconSlider or cftab.Icon
				ConfigSlider.Default = ConfigSlider.Default or ConfigSlider.Min
				ConfigSlider.Callback = ConfigSlider.Callback or function() end
				local Slider = Instance.new("Frame")
				local SliderTitle = Instance.new("TextLabel")
				local UICorner_23 = Instance.new("UICorner")
				local SliderContent = Instance.new("TextLabel")
				local SliderImage = Instance.new("ImageLabel")
				local SliderFrame = Instance.new("Frame")
				local UICorner_24 = Instance.new("UICorner")
				local SliderDrag = Instance.new("Frame")
				local UICorner_25 = Instance.new("UICorner")
				local SliderCircle = Instance.new("Frame")
				local UICorner_26 = Instance.new("UICorner")
				local UIStroke_10 = Instance.new("UIStroke")
				local SliderFrDrag = Instance.new("Frame")
				local SliderNumber = Instance.new("TextLabel")
				local SliderFunc = {Default = ConfigSlider.Default, Values = 0}
				Slider.Name = ConfigSlider.Title
				Slider.Parent = ScrollLayers
				Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Slider.BackgroundTransparency = 0.970
				Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Slider.BorderSizePixel = 0
				Slider.Size = UDim2.new(1, -8, 0, 45)
				SliderTitle.Name = "SliderTitle"
				SliderTitle.Parent = Slider
				SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderTitle.BackgroundTransparency = 0.999
				SliderTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderTitle.BorderSizePixel = 0
				SliderTitle.Position = UDim2.new(0, 40, 0, 11)
				SliderTitle.Size = UDim2.new(1, -180, 0, 12)
				SliderTitle.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
				SliderTitle.Text = ConfigSlider.Title
				SliderTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
				SliderTitle.TextSize = 12.000
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
				UICorner_23.CornerRadius = UDim.new(0, 4)
				UICorner_23.Parent = Slider
				SliderContent.Name = "SliderContent"
				SliderContent.Parent = Slider
				SliderContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderContent.BackgroundTransparency = 0.999
				SliderContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderContent.BorderSizePixel = 0
				SliderContent.Position = UDim2.new(0, 40, 0, 21)
				SliderContent.Size = UDim2.new(1, -180, 0, 11)
				SliderContent.Font = Enum.Font.GothamMedium
				SliderContent.Text = ConfigSlider.Description
				SliderContent.TextWrapped = true
				SliderContent.TextYAlignment = Enum.TextYAlignment.Top
				SliderContent.TextColor3 = Color3.fromRGB(230, 230, 230)
				SliderContent.TextSize = 11.000
				SliderContent.TextTransparency = 0.600
				SliderContent.TextXAlignment = Enum.TextXAlignment.Left
				SliderImage.Name = "SliderImage"
				SliderImage.Parent = Slider
				SliderImage.AnchorPoint = Vector2.new(0, 0.5)
				SliderImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderImage.BackgroundTransparency = 0.999
				SliderImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderImage.BorderSizePixel = 0
				SliderImage.Position = UDim2.new(0, 12, 0.5, 0)
				SliderImage.Size = UDim2.new(0, 16, 0, 16)
				SliderImage.Image = ConfigSlider.IconSlider
				SliderFrame.Name = "SliderFrame"
				SliderFrame.Parent = Slider
				SliderFrame.AnchorPoint = Vector2.new(1, 0.5)
				SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderFrame.BackgroundTransparency = 0.800
				SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderFrame.BorderSizePixel = 0
				SliderFrame.Position = UDim2.new(1, -12, 0.5, 0)
				SliderFrame.Size = UDim2.new(0, 100, 0, 2)
				UICorner_24.Parent = SliderFrame
				SliderDrag.Name = "SliderDrag"
				SliderDrag.Parent = SliderFrame
				SliderDrag.AnchorPoint = Vector2.new(0, 0.5)
				SliderDrag.BackgroundColor3 = Color3.fromRGB(93, 197, 248)
				SliderDrag.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderDrag.BorderSizePixel = 0
				SliderDrag.Position = UDim2.new(0, 0, 0.5, 0)
				SliderDrag.Size = UDim2.new(0.899999976, 0, 0, 2)
				UICorner_25.Parent = SliderDrag
				SliderCircle.Name = "SliderCircle"
				SliderCircle.Parent = SliderDrag
				SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
				SliderCircle.BackgroundColor3 = Color3.fromRGB(93, 197, 248)
				SliderCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderCircle.BorderSizePixel = 0
				SliderCircle.Position = UDim2.new(1, 0, 0.5, 0)
				SliderCircle.Size = UDim2.new(0, 8, 0, 8)
				UICorner_26.Parent = SliderCircle
				UIStroke_10.Parent = SliderCircle
				UIStroke_10.Color = Color3.fromRGB(93, 197, 248)
				SliderFrDrag.Name = "SliderFrDrag"
				SliderFrDrag.Parent = SliderFrame
				SliderFrDrag.AnchorPoint = Vector2.new(0, 0.5)
				SliderFrDrag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderFrDrag.BackgroundTransparency = 0.999
				SliderFrDrag.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderFrDrag.BorderSizePixel = 0
				SliderFrDrag.Position = UDim2.new(0, 0, 0.5, 0)
				SliderFrDrag.Size = UDim2.new(1, 0, 0, 45)
				SliderNumber.Name = "SliderNumber"
				SliderNumber.Parent = Slider
				SliderNumber.AnchorPoint = Vector2.new(1, 0.5)
				SliderNumber.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderNumber.BackgroundTransparency = 0.999
				SliderNumber.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderNumber.BorderSizePixel = 0
				SliderNumber.Position = UDim2.new(1, -117, 0.5, 0)
				SliderNumber.Size = UDim2.new(0, 30, 0, 13)
				SliderNumber.Font = Enum.Font.GothamBold
				SliderNumber.Text = ConfigSlider.Default
				SliderNumber.TextColor3 = Color3.fromRGB(230, 230, 230)
				SliderNumber.TextSize = 12.000
				SliderNumber.TextXAlignment = Enum.TextXAlignment.Right
				if SliderContent.Text == '' then
					SliderTitle.Size = UDim2.new(1, -190, 1, 0)
					SliderTitle.Position = UDim2.new(0,40,0,0)
				end
				obj.Stepped:Connect(function()
					local gay = math.max(SliderContent.TextBounds.Y + 10, 30)
					Slider.Size = UDim2.new(1,-8,0, gay + 18)
					SliderContent.Size = UDim2.new(1, -180, 0, gay + 10)
				end)
				local dragging = false
				local function Round(Number, Factor)
					local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
					if Result < 0 then Result = Result + Factor end
					return Result
				end
				function SliderFunc:Set(Value)
					Value = math.clamp(Round(Value, 1), ConfigSlider.Min, ConfigSlider.Max)
					SliderFunc.Values = Value
					SliderNumber.Text = tostring(Value)
					ConfigSlider.Callback(SliderFunc.Values)
					obj.TweenObject({SliderDrag, 0.3, "Size", UDim2.fromScale((Value - ConfigSlider.Min) / (ConfigSlider.Max - ConfigSlider.Min), 1)})
				end
				SliderFrame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
					end
				end)
				obj.UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)            
				obj.UserInputService.InputChanged:Connect(function(input)
					if dragging then
						local SizeScale = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
						SliderFunc:Set(ConfigSlider.Min + ((ConfigSlider.Max - ConfigSlider.Min) * SizeScale)) 
					end
				end)        
				SliderNumber:GetPropertyChangedSignal("Text"):Connect(function()
					local Valid = SliderNumber.Text:gsub("[^%d]", "")
					if Valid ~= "" then
						local ValidNumber = math.min(tonumber(Valid), ConfigSlider.Max)
						SliderNumber.Text = tostring(ValidNumber)
					else
						SliderNumber.Text = tostring(Valid)
					end
				end)
				SliderFunc:Set(ConfigSlider.Default)
				return SliderFunc
			end
			function Sec:AddInput(ConfigInput)
				ConfigInput = ConfigInput or {}
				ConfigInput.Title = ConfigInput.Title or "Input"
				ConfigInput.Description = ConfigInput.Description or ""
				ConfigInput.IconInput = ConfigInput.IconInput or cftab.Icon
				ConfigInput.PlaceHolder = ConfigInput.PlaceHolder or ""
				ConfigInput.Default = ConfigInput.Default or ""
				ConfigInput.Callback = ConfigInput.Callback or function() end
				local TextInput = Instance.new("Frame")
				local InputTitle = Instance.new("TextLabel")
				local UICorner_20 = Instance.new("UICorner")
				local InputContent = Instance.new("TextLabel")
				local InputImage = Instance.new("ImageLabel")
				local InputFrame = Instance.new("Frame")
				local UICorner_21 = Instance.new("UICorner")
				local InputDecide = Instance.new("Frame")
				local UICorner_22 = Instance.new("UICorner")
				local UIStroke_9 = Instance.new("UIStroke")
				local InputBoxFrame = Instance.new("Frame")
				local InputBox = Instance.new("TextBox")
				TextInput.Name = "TextInput"
				TextInput.Parent = ScrollLayers
				TextInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextInput.BackgroundTransparency = 0.970
				TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextInput.BorderSizePixel = 0
				TextInput.Size = UDim2.new(1, -8, 0, 45)
				InputTitle.Name = "InputTitle"
				InputTitle.Parent = TextInput
				InputTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputTitle.BackgroundTransparency = 0.999
				InputTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputTitle.BorderSizePixel = 0
				InputTitle.Position = UDim2.new(0, 40, 0, 11)
				InputTitle.Size = UDim2.new(1, -190, 0, 12)
				InputTitle.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
				InputTitle.Text = ConfigInput.Title
				InputTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				InputTitle.TextSize = 12.000
				InputTitle.TextXAlignment = Enum.TextXAlignment.Left
				UICorner_20.CornerRadius = UDim.new(0, 4)
				UICorner_20.Parent = TextInput
				InputContent.Name = "InputContent"
				InputContent.Parent = TextInput
				InputContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputContent.BackgroundTransparency = 0.999
				InputContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputContent.BorderSizePixel = 0
				InputContent.Position = UDim2.new(0, 40, 0, 21)
				InputContent.Size = UDim2.new(1, -190, 0, 11)
				InputContent.Font = Enum.Font.GothamMedium
				InputContent.Text = ConfigInput.Description
				InputContent.TextColor3 = Color3.fromRGB(255, 255, 255)
				InputContent.TextSize = 11.000
				InputContent.TextWrapped = true
				InputContent.TextYAlignment = Enum.TextYAlignment.Top
				InputContent.TextTransparency = 0.600
				InputContent.TextXAlignment = Enum.TextXAlignment.Left
				InputImage.Name = "InputImage"
				InputImage.Parent = TextInput
				InputImage.AnchorPoint = Vector2.new(0, 0.5)
				InputImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputImage.BackgroundTransparency = 0.999
				InputImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputImage.BorderSizePixel = 0
				InputImage.Position = UDim2.new(0, 12, 0.5, 0)
				InputImage.Size = UDim2.new(0, 16, 0, 16)
				InputImage.Image = ConfigInput.IconInput
				InputFrame.Name = "InputFrame"
				InputFrame.Parent = TextInput
				InputFrame.AnchorPoint = Vector2.new(1, 0.5)
				InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputFrame.BackgroundTransparency = 0.960
				InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputFrame.BorderSizePixel = 0
				InputFrame.ClipsDescendants = true
				InputFrame.Position = UDim2.new(1, -9, 0.5, 0)
				InputFrame.Size = UDim2.new(0, 125, 0, 26)
				UICorner_21.CornerRadius = UDim.new(0, 3)
				UICorner_21.Parent = InputFrame
				InputDecide.Name = "InputDecide"
				InputDecide.Parent = InputFrame
				InputDecide.AnchorPoint = Vector2.new(0.5, 1)
				InputDecide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputDecide.BackgroundTransparency = 0.950
				InputDecide.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputDecide.BorderSizePixel = 0
				InputDecide.Position = UDim2.new(0.5, 0, 1, 0)
				InputDecide.Size = UDim2.new(1, -2, 0, 1)
				UICorner_22.CornerRadius = UDim.new(0, 5)
				UICorner_22.Parent = InputDecide
				UIStroke_9.Parent = InputDecide
				UIStroke_9.Color = Color3.fromRGB(255, 255, 255)
				UIStroke_9.Transparency = 0.950
				UIStroke_9.Thickness = 0.600
				InputBoxFrame.Name = "InputBoxFrame"
				InputBoxFrame.Parent = InputFrame
				InputBoxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputBoxFrame.BackgroundTransparency = 0.999
				InputBoxFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputBoxFrame.BorderSizePixel = 0
				InputBoxFrame.ClipsDescendants = true
				InputBoxFrame.Position = UDim2.new(0, 6, 0, 0)
				InputBoxFrame.Size = UDim2.new(1, -12, 0, 24)
				InputBox.Name = "InputBox"
				InputBox.Parent = InputBoxFrame
				InputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputBox.BackgroundTransparency = 0.999
				InputBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputBox.BorderSizePixel = 0
				InputBox.Position = UDim2.new(0, 1, 0, 0)
				InputBox.Size = UDim2.new(1, -1, 1, 0)
				InputBox.Font = Enum.Font.GothamMedium
				InputBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
				InputBox.PlaceholderText = ConfigInput.PlaceHolder
				InputBox.Text = ConfigInput.Default
				InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
				InputBox.TextSize = 11.000
				InputBox.TextXAlignment = Enum.TextXAlignment.Left
				InputBox.FocusLost:Connect(function()
					ConfigInput.Callback(InputBox.Text)
				end)
				if InputContent.Text == '' then
					InputTitle.Size = UDim2.new(1, -190, 1, 0)
					InputTitle.Position = UDim2.new(0,40,0,0)
				end
				obj.Stepped:Connect(function()
					local gay = math.max(InputContent.TextBounds.Y + 10, 30)
					TextInput.Size = UDim2.new(1,-8,0, gay + 18)
					InputContent.Size = UDim2.new(1, -190, 0, gay + 10)
				end)
			end
			function Sec:AddParagraph(ConfigParagraph)
				ConfigParagraph = ConfigParagraph or {}
				ConfigParagraph.Title = ConfigParagraph.Title or "Paragraph"
				ConfigParagraph.Content = ConfigParagraph.Content or ""
				ConfigParagraph.IconLabel = ConfigParagraph.IconLabel or cftab.Icon
				local Paragraph = Instance.new("Frame")
				local ParagraphTitle = Instance.new("TextLabel")
				local UICorner_11 = Instance.new("UICorner")
				local ParagraphContent = Instance.new("TextLabel")
				local ParagraphImage = Instance.new("ImageLabel")
				local ParagraphFunc = {Title = ConfigParagraph.Title, Desc = ConfigParagraph.Content}
				Paragraph.Name = ConfigParagraph.Title
				Paragraph.Parent = ScrollLayers
				Paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Paragraph.BackgroundTransparency = 0.970
				Paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Paragraph.BorderSizePixel = 0
				Paragraph.Size = UDim2.new(1, -8, 0, 45)
				ParagraphTitle.Name = "ParagraphTitle"
				ParagraphTitle.Parent = Paragraph
				ParagraphTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ParagraphTitle.BackgroundTransparency = 0.999
				ParagraphTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ParagraphTitle.BorderSizePixel = 0
				ParagraphTitle.Position = UDim2.new(0, 40, 0, 11)
				ParagraphTitle.Size = UDim2.new(1, -52, 0, 12)
				ParagraphTitle.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
				ParagraphTitle.Text = ConfigParagraph.Title
				ParagraphTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				ParagraphTitle.TextSize = 12.000
				ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
				UICorner_11.CornerRadius = UDim.new(0, 4)
				UICorner_11.Parent = Paragraph
				ParagraphContent.Name = "ParagraphContent"
				ParagraphContent.Parent = Paragraph
				ParagraphContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ParagraphContent.BackgroundTransparency = 0.999
				ParagraphContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ParagraphContent.BorderSizePixel = 0
				ParagraphContent.Position = UDim2.new(0, 40, 0, 21)
				ParagraphContent.Size = UDim2.new(1, -52, 0, 11)
				ParagraphContent.Font = Enum.Font.GothamMedium
				ParagraphContent.Text = ConfigParagraph.Content
				ParagraphContent.TextColor3 = Color3.fromRGB(255, 255, 255)
				ParagraphContent.TextSize = 11.000
				ParagraphContent.TextTransparency = 0.600
				ParagraphContent.TextWrapped = true
				ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
				ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
				ParagraphImage.Name = "ParagraphImage"
				ParagraphImage.Parent = Paragraph
				ParagraphImage.AnchorPoint = Vector2.new(0, 0.5)
				ParagraphImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ParagraphImage.BackgroundTransparency = 0.999
				ParagraphImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ParagraphImage.BorderSizePixel = 0
				ParagraphImage.Position = UDim2.new(0, 12, 0.5, 0)
				ParagraphImage.Size = UDim2.new(0, 16, 0, 16)
				ParagraphImage.Image = ConfigParagraph.IconLabel
				obj.Stepped:Connect(function()
					local gay = math.max(ParagraphContent.TextBounds.Y + 10, 30)
					Paragraph.Size = UDim2.new(1,-8,0, gay + 18)
					ParagraphContent.Size = UDim2.new(1, -52, 0, gay + 10)
				end)
				function ParagraphFunc:SetTitle(L)
					ParagraphTitle.Text = L
				end
				function ParagraphFunc:SetDesc(L)
					ParagraphContent.Text = L
				end
				return ParagraphFunc
			end
			function Sec:AddSeperator(Text)
				local Seperator = Instance.new("Frame")
				local Seperator_2 = Instance.new("TextLabel")
				Seperator.Name = Text
				Seperator.Parent = ScrollLayers
				Seperator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Seperator.BackgroundTransparency = 0.999
				Seperator.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Seperator.BorderSizePixel = 0
				Seperator.Size = UDim2.new(1, -8, 0, 16)
				Seperator_2.Name = "Seperator"
				Seperator_2.Parent = Seperator
				Seperator_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Seperator_2.BackgroundTransparency = 0.999
				Seperator_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Seperator_2.BorderSizePixel = 0
				Seperator_2.Position = UDim2.new(0, 1, 0, 0)
				Seperator_2.Size = UDim2.new(1, -2, 1, 0)
				Seperator_2.Text = Text
				Seperator_2.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
				Seperator_2.TextColor3 = Color3.fromRGB(255, 255, 255)
				Seperator_2.TextSize = 14.000
				Seperator_2.TextXAlignment = Enum.TextXAlignment.Left
			end
		Counts = Counts + 1
		return Sec
	end
	return UITab
end
return obj
