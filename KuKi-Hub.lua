--[[
    KuKi Hub | Ture V2 - Part 1
    Foundation + Info + Status Tabs
    Library: KuKi Hub UI
]]

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/erenxkuki/KuKi-Hub/refs/heads/main/KuKi-Hub-Zen-UI.lua"))()
local Window = library:Make()

-- ========================================
-- SERVICES
-- ========================================
local Services = setmetatable({}, {__index = function(_,s) local svc = game:GetService(s); rawset(_,s,svc); return svc end})
local HttpService = Services.HttpService
local Players = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage
local TweenService = Services.TweenService
local RunService = Services.RunService
local TeleportService = Services.TeleportService
local Lighting = Services.Lighting
local CollectionService = Services.CollectionService
local VirtualInputManager = Services.VirtualInputManager
local VirtualUser = Services.VirtualUser
local Workspace = Services.Workspace
local StarterGui = Services.StarterGui

local plr = Players.LocalPlayer
local commE = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommE")
local commF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- ========================================
-- SAVE/LOAD SYSTEM
-- ========================================
local FolderName = "KuKi Hub"
local FileName = "Settings.json"
if makefolder and not isfolder(FolderName) then makefolder(FolderName) end
_G.SaveData = _G.SaveData or {}
function SaveSettings()
    if not writefile then return end
    pcall(function() writefile(FolderName .. "/" .. FileName, HttpService:JSONEncode(_G.SaveData)) end)
end
function LoadSettings()
    if not isfile or not isfile(FolderName .. "/" .. FileName) then return end
    pcall(function()
        local data = HttpService:JSONDecode(readfile(FolderName .. "/" .. FileName))
        if data then _G.SaveData = data end
    end)
end
LoadSettings()
function GetSetting(name, default)
    return _G.SaveData[name] ~= nil and _G.SaveData[name] or default
end

-- ========================================
-- WORLD DETECTION
-- ========================================
local placeId = game.PlaceId
local World1 = (placeId == 2753915549 or placeId == 85211729168715)
local World2 = (placeId == 4442272183 or placeId == 79091703265657)
local World3 = (placeId == 7449423635 or placeId == 100117331123089)
local Sea = World1 and "First Sea" or World2 and "Second Sea" or World3 and "Third Sea" or "Unknown"

-- ========================================
-- GLOBAL SETTINGS
-- ========================================
_G.AutoKen = GetSetting("AutoKen", true)
_G.AntiAFK = GetSetting("AntiAFK", true)
_G.FullBright = GetSetting("FullBright", false)

-- ========================================
-- TWEEN PART
-- ========================================
getgenv().TweenSpeedFar = GetSetting("TweenSpeedFar", 300)
getgenv().TweenSpeedNear = GetSetting("TweenSpeedNear", 900)
local TweenPart = Instance.new("Part", Workspace)
TweenPart.Name = "KuKiTween"
TweenPart.Size = Vector3.new(1, 1, 1)
TweenPart.Anchored = true
TweenPart.CanCollide = false
TweenPart.Transparency = 1

function _tp(cf)
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local d = (cf.Position - hrp.Position).Magnitude
    local s = d <= 90 and getgenv().TweenSpeedNear or getgenv().TweenSpeedFar
    local tw = TweenService:Create(TweenPart, TweenInfo.new(d/s, Enum.EasingStyle.Linear), {CFrame = cf})
    tw:Play()
    tw.Completed:Wait()
end

function notween(cf)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = cf
    end
end

function GetHRP()
    return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
end

function GetLevel()
    return plr.Data and plr.Data.Level and plr.Data.Level.Value or 0
end

function GetFragments()
    return plr.Data and plr.Data.Fragments and plr.Data.Fragments.Value or 0
end

function GetBeli()
    return plr.Data and plr.Data.Beli and plr.Data.Beli.Value or 0
end

function GetRace()
    return plr.Data and plr.Data.Race and plr.Data.Race.Value or "None"
end

function GetTeam()
    return plr.Team and plr.Team.Name or "None"
end

function Hop()
    pcall(function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local s = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        if s.data then
            for _, v in ipairs(s.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    TPS:TeleportToPlaceInstance(game.PlaceId, v.id, plr)
                    break
                end
            end
        end
    end)
end

-- ========================================
-- AUTO KEN (OBSERVATION HAKI)
-- ========================================
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoKen then
            pcall(function()
                local char = plr.Character
                if char and not CollectionService:HasTag(char, "Ken") then
                    commE:FireServer("Ken", true)
                end
            end)
        end
    end
end)

-- ========================================
-- ANTI AFK
-- ========================================
plr.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end
end)

-- ========================================
-- FULL BRIGHT
-- ========================================
local function ApplyFullBright(state)
    if state then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.FogEnd = 1e10
    else
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        Lighting.Brightness = 1
        Lighting.FogEnd = 10000
    end
end
ApplyFullBright(_G.FullBright)

-- ========================================
-- WAIT FOR LOAD
-- ========================================
repeat task.wait() until game:IsLoaded() and plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

-- ========================================
-- TABS
-- ========================================
local Tab0 = Window:Tab("Info", 14477284625)
local Tab1 = Window:Tab("Status", 7040410130)
local Tab2 = Window:Tab("Farming", 10709769508)
local Tab3 = Window:Tab("Quests", 10734943448)
local Tab4 = Window:Tab("Settings", 10734950020)
local Tab5 = Window:Tab("Fishing", 127664059821666)
local Tab6 = Window:Tab("Sea Event", 10747376931)
local Tab7 = Window:Tab("Volcano", 10734897956)
local Tab8 = Window:Tab("Mirage", 10734920149)
local Tab9 = Window:Tab("Fruits", 10709790875)
local Tab10 = Window:Tab("Raid", 10723404337)
local Tab11 = Window:Tab("Teleport", 10734906975)
local Tab12 = Window:Tab("PvP", 10734975692)
local Tab13 = Window:Tab("ESP", 10723346959)
local Tab14 = Window:Tab("Shop", 10734952479)
local Tab15 = Window:Tab("Misc", 10734950309)

-- ========================================
-- TAB 0: INFO
-- ========================================
local InfoPage1 = Tab0:CraftPage(1)

InfoPage1:Label("KuKi Hub | Ture V2")
InfoPage1:Label("Premium Blox Fruits Script")
InfoPage1:Seperator("Player Information")

local playerInfoLabel = InfoPage1:Label("Loading...")
local statsInfoLabel = InfoPage1:Label("Loading...")

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            playerInfoLabel:Set("Name: " .. plr.Name .. "\nDisplay: " .. plr.DisplayName .. "\nUser ID: " .. plr.UserId)
            statsInfoLabel:Set(string.format("Level: %d\nBeli: %s\nFragments: %s\nRace: %s\nTeam: %s",
                GetLevel(),
                tostring(GetBeli()):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,",""),
                tostring(GetFragments()):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,",""),
                GetRace(),
                GetTeam()))
        end)
    end
end)

InfoPage1:Seperator("Script Info")
InfoPage1:Label("Current Sea: " .. Sea)
InfoPage1:Label("Version: 2.0.0")
InfoPage1:Label("Created: 2026")

InfoPage1:Button("Copy Discord Invite", function()
    setclipboard("https://discord.gg/kuKihub")
end)

-- ========================================
-- TAB 1: STATUS
-- ========================================
local StatusPage1 = Tab1:CraftPage(1)
local StatusPage2 = Tab1:CraftPage(2)

StatusPage1:Seperator("Time & Date")
local timeLabel = StatusPage1:Label("Loading...")
local gameTimeLabel = StatusPage1:Label("Loading...")

task.spawn(function()
    while task.wait(0.5) do
        local date = os.date("*t")
        local ampm = date.hour >= 12 and "PM" or "AM"
        local hour12 = date.hour % 12; if hour12 == 0 then hour12 = 12 end
        timeLabel:Set(string.format("%02d:%02d:%02d %s - %02d/%02d/%04d", hour12, date.min, date.sec, ampm, date.day, date.month, date.year))
        pcall(function()
            local gt = math.floor(Workspace.DistributedGameTime + 0.5)
            gameTimeLabel:Set(string.format("%02d:%02d:%02d", math.floor(gt/3600)%24, math.floor(gt/60)%60, gt%60))
        end)
    end
end)

StatusPage1:Seperator("Server Information")
local serverInfoLabel = StatusPage1:Label("Loading...")

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            serverInfoLabel:Set(string.format("Place: %d\nJob: %s\nPlayers: %d/%d\nPing: %d ms",
                placeId, game.JobId:sub(1,8).."...", #Players:GetPlayers(), Players.MaxPlayers,
                math.floor(plr:GetNetworkPing()*1000)))
        end)
    end
end)

StatusPage1:Button("Copy Job ID", function() setclipboard(game.JobId) end)
StatusPage1:Button("Rejoin Server", function() TeleportService:Teleport(game.PlaceId, plr) end)
StatusPage1:Button("Hop Server", Hop)
StatusPage1:Button("Hop Low Players", Hop)

StatusPage1:Seperator("Island Status")
local mirageLabel = StatusPage1:Label("Mirage: Checking...")
local kitsuneLabel = StatusPage1:Label("Kitsune: Checking...")
local prehistoricLabel = StatusPage1:Label("Prehistoric: Checking...")
local frozenLabel = StatusPage1:Label("Frozen: Checking...")

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            mirageLabel:Set("Mirage: " .. (Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") and "✅" or "❌"))
            kitsuneLabel:Set("Kitsune: " .. ((Workspace.Map:FindFirstChild("KitsuneIsland") or Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island")) and "✅" or "❌"))
            prehistoricLabel:Set("Prehistoric: " .. ((Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island")) and "✅" or "❌"))
            frozenLabel:Set("Frozen: " .. (Workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") and "✅" or "❌"))
        end)
    end
end)

StatusPage2:Seperator("Moon Phase")
local moonLabel = StatusPage2:Label("Checking...")

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local moonId = World3 and Lighting.Sky and Lighting.Sky.MoonTextureId or (Lighting.FantasySky and Lighting.FantasySky.MoonTextureId) or ""
            local phase = "0/8"
            if moonId:find("9709139597") then phase = "1/8"
            elseif moonId:find("9709143733") then phase = "2/8"
            elseif moonId:find("9709149052") then phase = "3/8"
            elseif moonId:find("9709149431") then phase = "4/8 🌕"
            elseif moonId:find("9709149680") then phase = "5/8"
            elseif moonId:find("9709150086") then phase = "6/8"
            elseif moonId:find("9709150401") then phase = "7/8"
            end
            moonLabel:Set("Moon: " .. phase)
        end)
    end
end)

StatusPage2:Seperator("Boss Status")
local doughLabel = StatusPage2:Label("Dough King: Checking...")
local indraLabel = StatusPage2:Label("Rip Indra: Checking...")
local princeLabel = StatusPage2:Label("Cake Prince: Checking...")

task.spawn(function()
    while task.wait(3) do
        pcall(function()
            doughLabel:Set("Dough King: " .. ((ReplicatedStorage:FindFirstChild("Dough King") or Workspace.Enemies:FindFirstChild("Dough King")) and "✅" or "❌"))
            indraLabel:Set("Rip Indra: " .. ((ReplicatedStorage:FindFirstChild("rip_indra True Form") or Workspace.Enemies:FindFirstChild("rip_indra")) and "✅" or "❌"))
            princeLabel:Set("Cake Prince: " .. (Workspace.Enemies:FindFirstChild("Cake Prince") and "✅" or "❌"))
        end)
    end
end)

StatusPage2:Seperator("Elite Hunter")
local eliteLabel = StatusPage2:Label("Loading...")

task.spawn(function()
    while task.wait(3) do
        pcall(function()
            local progress = commF:InvokeServer("EliteHunter", "Progress")
            local hasElite = ReplicatedStorage:FindFirstChild("Diablo") or ReplicatedStorage:FindFirstChild("Deandre") or ReplicatedStorage:FindFirstChild("Urban") or Workspace.Enemies:FindFirstChild("Diablo") or Workspace.Enemies:FindFirstChild("Deandre") or Workspace.Enemies:FindFirstChild("Urban")
            eliteLabel:Set(string.format("Killed: %d/30 | %s", progress or 0, hasElite and "✅ Boss" or "❌ No Boss"))
        end)
    end
end)

StatusPage2:Seperator("Sea Events")
local sbLabel = StatusPage2:Label("Sea Beast: Checking...")
local tsLabel = StatusPage2:Label("Terror Shark: Checking...")

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            sbLabel:Set("Sea Beast: " .. (Workspace.SeaBeasts:FindFirstChild("SeaBeast1") and "✅" or "❌"))
            tsLabel:Set("Terror Shark: " .. (Workspace.Enemies:FindFirstChild("Terrorshark") and "✅" or "❌"))
        end)
    end
end)

print("Part 1 Loaded: Foundation + Info + Status")

--[[
    KuKi Hub | Ture V2 - Part 2
    Farming Tab - Auto Farm, Quest System, Fast Attack
    Library: KuKi Hub UI
]]

-- ========================================
-- FAST ATTACK LOADER (Provided)
-- ========================================
task.spawn(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    repeat task.wait() until game:IsLoaded()
    repeat task.wait() until LP and LP.Character
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/erenxkuki/KuKi-Hub/refs/heads/main/KuKi-Hub-Fast-Attack.lua"))()
    end)
    if not success then
        warn("Fast Attack load failed:", err)
    end
end)

-- ========================================
-- FARMING TAB PAGES
-- ========================================
local FarmMain = Tab2:CraftPage(1)      -- Main Farm
local FarmSettings = Tab2:CraftPage(2)  -- Farm Settings
local FarmBoss = Tab2:CraftPage(3)      -- Boss Farm
local FarmMastery = Tab2:CraftPage(4)   -- Mastery Farm (World 3)

-- ========================================
-- GLOBAL FARM VARIABLES
-- ========================================
_G.ChooseWP = GetSetting("ChooseWP", "Melee")
_G.SelectWeapon = "Melee"
_G.SelectedFarmMode = GetSetting("SelectedFarmMode", "Level")
_G.StartFarm = false

_G.Level = false
_G.AutoFarm_Bone = false
_G.AutoFarm_Cake = false
_G.AutoMaterial = false
_G.AutoFarmNear = false

_G.AcceptQuest = GetSetting("AcceptQuest", false)
_G.MobHeight = GetSetting("MobHeight", 20)
_G.BringRange = GetSetting("BringRange", 235)
_G.MaxFarmDistance = GetSetting("MaxFarmDistance", 325)
_G.MaxBringMobs = GetSetting("MaxBringMobs", 3)

_G.AutoBoss = false
_G.FarmAllBoss = false
_G.FindBoss = Boss[1] or "The Gorilla King"

getgenv().SelectMaterial = MaterialList[1]
getgenv().AutoMaterial = false

_G.FarmMastery_Dev = false
_G.FarmMastery_G = false
_G.FarmMastery_S = false
_G.SelectedIsland = GetSetting("SelectedIsland", "Cake")

-- ========================================
-- HELPER FUNCTIONS FOR FARMING
-- ========================================
function G_Alive(mob)
    local hum = mob and mob:FindFirstChild("Humanoid")
    return hum and hum.Health > 0
end

function G_Kill(mob, enabled)
    if not mob or not enabled then return end
    local hrp = mob:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    EquipWeapon(_G.SelectWeapon)
    _tp(hrp.CFrame * CFrame.new(0, _G.MobHeight, 0))
    -- Space for CFrames attack positions can be added here
end

-- Bring Mobs System
local _B = false
local PosMon = nil

function BringEnemy()
    if not _B or not PosMon then return end
    pcall(function()
        sethiddenproperty(plr, "SimulationRadius", math.huge)
        local count = 0
        for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
            if count >= _G.MaxBringMobs then break end
            local hum = mob:FindFirstChild("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                if not string.find(mob.Name:lower(), "raid") then
                    local dist = (root.Position - PosMon).Magnitude
                    if dist <= _G.BringRange and not root:GetAttribute("Tweening") then
                        count = count + 1
                        root:SetAttribute("Tweening", true)
                        local tween = TweenService:Create(root, TweenInfo.new(0.45, Enum.EasingStyle.Linear), {CFrame = CFrame.new(PosMon)})
                        tween:Play()
                        tween.Completed:Once(function() if root then root:SetAttribute("Tweening", false) end end)
                    end
                end
            end
        end
    end)
end

function FarmAtivo()
    return _G.StartFarm and (_G.Level or _G.AutoFarm_Bone or _G.AutoFarm_Cake or _G.AutoMaterial or _G.AutoFarmNear or _G.FarmMastery_Dev or _G.FarmMastery_G or _G.FarmMastery_S)
end

task.spawn(function()
    while task.wait(1) do
        if FarmAtivo() then
            _B = true
            BringEnemy()
            task.wait(3)
            _B = false
            task.wait(5)
        else
            _B = false
            task.wait(1)
        end
    end
end)

-- ========================================
-- QUEST SYSTEM (Level-Based)
-- ========================================
local questData = {
        -- World 1
    ["Bandit"] = { Name = "BanditQuest1", Level = 1, QuestPos = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, 0, 1, -0, 0.341998369, 0, 0.939700544), MobPos = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125) },
    ["Monkey"] = { Name = "JungleQuest", Level = 1, QuestPos = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0), MobPos = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209) },
    ["Gorilla"] = { Name = "JungleQuest", Level = 2, QuestPos = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0), MobPos = CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875) },
    ["Pirate"] = { Name = "BuggyQuest1", Level = 1, QuestPos = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627), MobPos = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125) },
    ["Brute"] = { Name = "BuggyQuest1", Level = 2, QuestPos = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627), MobPos = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875) },
    ["Desert Bandit"] = { Name = "DesertQuest", Level = 1, QuestPos = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693), MobPos = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375) },
    ["Desert Officer"] = { Name = "DesertQuest", Level = 2, QuestPos = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693), MobPos = CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875) },
    ["Snow Bandit"] = { Name = "SnowQuest", Level = 1, QuestPos = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685), MobPos = CFrame.new(1354.347900390625, 87.27277374267578, -1393.946533203125) },
    ["Snowman"] = { Name = "SnowQuest", Level = 2, QuestPos = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685), MobPos = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625) },
    ["Chief Petty Officer"] = { Name = "MarineQuest2", Level = 1, QuestPos = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0), MobPos = CFrame.new(-4881.23095703125, 22.65204429626465, 4273.75244140625) },
    ["Sky Bandit"] = { Name = "SkyQuest", Level = 1, QuestPos = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268), MobPos = CFrame.new(-4953.20703125, 295.74420166015625, -2899.22900390625) },
    ["Dark Master"] = { Name = "SkyQuest", Level = 2, QuestPos = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268), MobPos = CFrame.new(-5259.8447265625, 391.3976745605469, -2229.035400390625) },
    ["Prisoner"] = { Name = "PrisonerQuest", Level = 1, QuestPos = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712), MobPos = CFrame.new(5098.9736328125, -0.3204058110713959, 474.2373352050781) },
    ["Dangerous Prisoner"] = { Name = "PrisonerQuest", Level = 2, QuestPos = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712), MobPos = CFrame.new(5654.5634765625, 15.633401870727539, 866.2991943359375) },
    ["Toga Warrior"] = { Name = "ColosseumQuest", Level = 1, QuestPos = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298), MobPos = CFrame.new(-1820.21484375, 51.68385696411133, -2740.6650390625) },
    ["Gladiator"] = { Name = "ColosseumQuest", Level = 2, QuestPos = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298), MobPos = CFrame.new(-1292.838134765625, 56.380882263183594, -3339.031494140625) },
    ["Military Soldier"] = { Name = "MagmaQuest", Level = 1, QuestPos = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469), MobPos = CFrame.new(-5411.16455078125, 11.081554412841797, 8454.29296875) },
    ["Military Spy"] = { Name = "MagmaQuest", Level = 2, QuestPos = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469), MobPos = CFrame.new(-5802.8681640625, 86.26241302490234, 8828.859375) },
    ["Fishman Warrior"] = { Name = "FishmanQuest", Level = 1, QuestPos = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734), MobPos = CFrame.new(60878.30078125, 18.482830047607422, 1543.7574462890625) },
    ["Fishman Commando"] = { Name = "FishmanQuest", Level = 2, QuestPos = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734), MobPos = CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875) },
    ["God's Guard"] = { Name = "SkyExp1Quest", Level = 1, QuestPos = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, -0, -0.0871884301, 0, 1, -0, 0.0871884301, 0, 0.996191859), MobPos = CFrame.new(-4710.04296875, 845.2769775390625, -1927.3079833984375) },
    ["Shanda"] = { Name = "SkyExp1Quest", Level = 2, QuestPos = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998), MobPos = CFrame.new(-7678.48974609375, 5566.40380859375, -497.2156066894531) },
    ["Royal Squad"] = { Name = "SkyExp2Quest", Level = 1, QuestPos = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0), MobPos = CFrame.new(-7624.25244140625, 5658.13330078125, -1467.354248046875) },
    ["Royal Soldier"] = { Name = "SkyExp2Quest", Level = 2, QuestPos = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0), MobPos = CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625) },
    ["Galley Pirate"] = { Name = "FountainQuest", Level = 1, QuestPos = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381), MobPos = CFrame.new(5551.02197265625, 78.90135192871094, 3930.412841796875) },
    ["Galley Captain"] = { Name = "FountainQuest", Level = 2, QuestPos = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381), MobPos = CFrame.new(5441.95166015625, 42.50205993652344, 4950.09375) },
        -- World 2
    ["Raider"] = { Name = "Area1Quest", Level = 1, QuestPos = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985), MobPos = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125) },
    ["Mercenary"] = { Name = "Area1Quest", Level = 2, QuestPos = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985), MobPos = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625) },
    ["Swan Pirate"] = { Name = "Area2Quest", Level = 1, QuestPos = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906), MobPos = CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625) },
    ["Factory Staff"] = { Name = "Area2Quest", Level = 2, QuestPos = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369), MobPos = CFrame.new(73.07867431640625, 81.86344146728516, -27.470672607421875) },
    ["Marine Lieutenant"] = { Name = "MarineQuest3", Level = 1, QuestPos = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268), MobPos = CFrame.new(-2821.372314453125, 75.89727783203125, -3070.089111328125) },
    ["Marine Captain"] = { Name = "MarineQuest3", Level = 2, QuestPos = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268), MobPos = CFrame.new(-1861.2310791015625, 80.17658233642578, -3254.697509765625) },
    ["Zombie"] = { Name = "ZombieQuest", Level = 1, QuestPos = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146), MobPos = CFrame.new(-5657.77685546875, 78.96973419189453, -928.68701171875) },
    ["Vampire"] = { Name = "ZombieQuest", Level = 2, QuestPos = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146), MobPos = CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625) },
    ["Snow Trooper"] = { Name = "SnowMountainQuest", Level = 1, QuestPos = CFrame.new(607, 401, -5371), MobPos = CFrame.new(445, 440, -5175) },
    ["Winter Warrior"] = { Name = "SnowMountainQuest", Level = 2, QuestPos = CFrame.new(607, 401, -5371), MobPos = CFrame.new(1224, 460, -5332) },
    ["Lab Subordinate"] = { Name = "IceSideQuest", Level = 1, QuestPos = CFrame.new(-6061, 16, -4904), MobPos = CFrame.new(-5941, 50, -4322) },
    ["Horned Warrior"] = { Name = "IceSideQuest", Level = 2, QuestPos = CFrame.new(-6061, 16, -4904), MobPos = CFrame.new(-6306, 50, -5752) },
    ["Magma Ninja"] = { Name = "FireSideQuest", Level = 1, QuestPos = CFrame.new(-5430, 16, -5298), MobPos = CFrame.new(-5233, 60, -6227) },
    ["Lava Pirate"] = { Name = "FireSideQuest", Level = 2, QuestPos = CFrame.new(-5430, 16, -5298), MobPos = CFrame.new(-4955, 60, -4836) },
    ["Ship Deckhand"] = { Name = "ShipQuest1", Level = 1, QuestPos = CFrame.new(1037.80127, 125.092171, 32911.6016), MobPos = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375) },
    ["Ship Engineer"] = { Name = "ShipQuest1", Level = 2, QuestPos = CFrame.new(1037, 125, 32911), MobPos = CFrame.new(919, 43, 32779), EntrancePos = Vector3.new(923.21, 126.97, 32852.83) },
    ["Ship Steward"] = { Name = "ShipQuest2", Level = 1, QuestPos = CFrame.new(968, 125, 33244), MobPos = CFrame.new(919, 129, 33436), EntrancePos = Vector3.new(923.21, 126.97, 32852.83) },
    ["Ship Officer"] = { Name = "ShipQuest2", Level = 2, QuestPos = CFrame.new(968, 125, 33244), MobPos = CFrame.new(1036, 181, 33315), EntrancePos = Vector3.new(923.21, 126.97, 32852.83) },
    ["Arctic Warrior"] = { Name = "FrostQuest", Level = 1, QuestPos = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909), MobPos = CFrame.new(5966.24609375, 62.97002029418945, -6179.3828125) },
    ["Snow Lurker"] = { Name = "FrostQuest", Level = 2, QuestPos = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909), MobPos = CFrame.new(5407.07373046875, 69.19437408447266, -6880.88037109375) },
    ["Sea Soldier"] = { Name = "ForgottenQuest", Level = 1, QuestPos = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376), MobPos = CFrame.new(-3028.2236328125, 64.67451477050781, -9775.4267578125) },
    ["Water Fighter"] = { Name = "ForgottenQuest", Level = 2, QuestPos = CFrame.new(-3054, 240, -10146), MobPos = CFrame.new(-3291, 252, -10501) },
        -- World 3
    ["Pirate Millionaire"] = { Name = "PiratePortQuest", Level = 1, QuestPos = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627), MobPos = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375) },
    ["Pistol Billionaire"] = { Name = "PiratePortQuest", Level = 2, QuestPos = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627), MobPos = CFrame.new(-187.3301544189453, 86.23987579345703, 6013.513671875) },
    ["Dragon Crew Warrior"] = { Name = "DragonCrewQuest", Level = 1, QuestPos = CFrame.new(6738.96142578125, 127.81645965576172, -713.511474609375), MobPos = CFrame.new(6920.71435546875, 56.15597152709961, -942.5044555664062) },
    ["Dragon Crew Archer"] = { Name = "DragonCrewQuest", Level = 2, QuestPos = CFrame.new(6738.96142578125, 127.81645965576172, -713.511474609375), MobPos = CFrame.new(6817.91259765625, 484.804443359375, 513.4141235351562) },
    ["Hydra Enforcer"] = { Name = "VenomCrewQuest", Level = 1, QuestPos = CFrame.new(5213.8740234375, 1004.5042724609375, 758.6944580078125), MobPos = CFrame.new(4584.69287109375, 1002.6435546875, 705.7958984375) },
    ["Venomous Assailant"] = { Name = "VenomCrewQuest", Level = 2, QuestPos = CFrame.new(5213.8740234375, 1004.5042724609375, 758.6944580078125), MobPos = CFrame.new(4638.78564453125, 1078.94091796875, 881.8002319335938) },
    ["Marine Commodore"] = { Name = "MarineTreeIsland", Level = 1, QuestPos = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747), MobPos = CFrame.new(2286.0078125, 73.13391876220703, -7159.80908203125) },
    ["Marine Rear Admiral"] = { Name = "MarineTreeIsland", Level = 2, QuestPos = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813), MobPos = CFrame.new(3656.773681640625, 160.52406311035156, -7001.5986328125) },
    ["Fishman Raider"] = { Name = "DeepForestIsland3", Level = 1, QuestPos = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213), MobPos = CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625) },
    ["Fishman Captain"] = { Name = "DeepForestIsland3", Level = 2, QuestPos = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213), MobPos = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625) },
    ["Forest Pirate"] = { Name = "DeepForestIsland", Level = 1, QuestPos = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247), MobPos = CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625) },
    ["Mythological Pirate"] = { Name = "DeepForestIsland", Level = 2, QuestPos = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247), MobPos = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125) },
    ["Jungle Pirate"] = { Name = "DeepForestIsland2", Level = 1, QuestPos = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002), MobPos = CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625) },
    ["Musketeer Pirate"] = { Name = "DeepForestIsland2", Level = 2, QuestPos = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002), MobPos = CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375) },
    ["Reborn Skeleton"] = { Name = "HauntedQuest1", Level = 1, QuestPos = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0), MobPos = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625) },
    ["Living Zombie"] = { Name = "HauntedQuest1", Level = 2, QuestPos = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0), MobPos = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875) },
    ["Demonic Soul"] = { Name = "HauntedQuest2", Level = 1, QuestPos = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0), MobPos = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625) },
    ["Posessed Mummy"] = { Name = "HauntedQuest2", Level = 2, QuestPos = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0), MobPos = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625) },
    ["Peanut Scout"] = { Name = "NutsIslandQuest", Level = 1, QuestPos = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0), MobPos = CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875) },
    ["Peanut President"] = { Name = "NutsIslandQuest", Level = 2, QuestPos = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0), MobPos = CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875) },
    ["Ice Cream Chef"] = { Name = "IceCreamIslandQuest", Level = 1, QuestPos = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0), MobPos = CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125) },
    ["Ice Cream Commander"] = { Name = "IceCreamIslandQuest", Level = 2, QuestPos = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0), MobPos = CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625) },
    ["Cookie Crafter"] = { Name = "CakeQuest1", Level = 1, QuestPos = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931), MobPos = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375) },
    ["Cake Guard"] = { Name = "CakeQuest1", Level = 2, QuestPos = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931), MobPos = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875) },
    ["Baking Staff"] = { Name = "CakeQuest2", Level = 1, QuestPos = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446), MobPos = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375) },
    ["Head Baker"] = { Name = "CakeQuest2", Level = 2, QuestPos = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446), MobPos = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125) },
    ["Cocoa Warrior"] = { Name = "ChocQuest1", Level = 1, QuestPos = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375), MobPos = CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125) },
    ["Chocolate Bar Battler"] = { Name = "ChocQuest1", Level = 2, QuestPos = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375), MobPos = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375) },
    ["Sweet Thief"] = { Name = "ChocQuest2", Level = 1, QuestPos = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875), MobPos = CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625) },
    ["Candy Rebel"] = { Name = "ChocQuest2", Level = 2, QuestPos = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875), MobPos = CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625) },
    ["Candy Pirate"] = { Name = "CandyQuest1", Level = 1, QuestPos = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375), MobPos = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875) },
    ["Snow Demon"] = { Name = "CandyQuest1", Level = 2, QuestPos = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375), MobPos = CFrame.new(-880.2006225585938, 71.24776458740234, -14538.609375) },
    ["Isle Outlaw"] = { Name = "TikiQuest1", Level = 1, QuestPos = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812), MobPos = CFrame.new(-16442.814453125, 116.13899993896484, -264.4637756347656) },
    ["Island Boy"] = { Name = "TikiQuest1", Level = 2, QuestPos = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812), MobPos = CFrame.new(-16901.26171875, 84.06756591796875, -192.88906860351562) },
    ["Isle Champion"] = { Name = "TikiQuest2", Level = 2, QuestPos = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625), MobPos = CFrame.new(-16641.6796875, 235.7825469970703, 1031.282958984375) },
    ["Serpent Hunter"] = { Name = "TikiQuest3", Level = 1, QuestPos = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, 0, 1, -0, 0.308980465, 0, 0.951068401), MobPos = CFrame.new(-16521.0625, 106.09285, 1488.78467, 0.469467044, 0, 0.882950008, 0, 1, 0, -0.882950008, 0, 0.469467044) },
    ["Skull Slayer"] = { Name = "TikiQuest3", Level = 2, QuestPos = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, 0, 1, -0, 0.308980465, 0, 0.951068401), MobPos = CFrame.new(-16887.7305, 113.074638, 1629.97778, -0.559032857, 1.2313353e-08, -0.829145491, 1.05618814e-09, 1, 1.41385428e-08, 0.829145491, 7.02817626e-09, -0.559032857) },
    ["Reef Bandit"] = { Name = "SubmergedQuest1", Level = 1, QuestPos = CFrame.new(10778.875, -2087.72437, 9265.18359, 0.934615612, -9.33109447e-08, -0.355659455, 9.17655143e-08, 1, -2.12154276e-08, 0.355659455, -1.28090019e-08, 0.934615612), MobPos = CFrame.new(11019.1318, -2146.06812, 9342.3916, -0.719955266, -1.74275385e-08, 0.69402045, 5.76556367e-08, 1, 8.49211546e-08, -0.69402045, 1.01153624e-07, -0.719955266) },
    ["Coral Pirate"] = { Name = "SubmergedQuest1", Level = 2, QuestPos = CFrame.new(10778.875, -2087.72437, 9265.18359, 0.934615612, -9.33109447e-08, -0.355659455, 9.17655143e-08, 1, -2.12154276e-08, 0.355659455, -1.28090019e-08, 0.934615612), MobPos = CFrame.new(10808.6006, -2030.36145, 9364.2334, -0.775185347, -0.0359364748, 0.6307109, 0.0615428537, 0.989336014, 0.132010356, -0.628728986, 0.141148239, -0.764707148) },
    ["Sea Chanter"] = { Name = "SubmergedQuest2", Level = 1, QuestPos = CFrame.new(10880.6855, -2086.20044, 10032.624, -0.321384728, 9.87648434e-08, -0.946948707, 7.13271007e-08, 1, 8.00902953e-08, 0.946948707, -4.18033075e-08, -0.321384728), MobPos = CFrame.new(10671.2715, -2057.59155, 10047.2588, -0.846484065, -3.11045447e-08, 0.532414079, -5.55383117e-08, 1, -2.98785316e-08, -0.532414079, -5.48610757e-08, -0.846484065) },
    ["Ocean Prophet"] = { Name = "SubmergedQuest2", Level = 2, QuestPos = CFrame.new(10880.6855, -2086.20044, 10032.624, -0.321384728, 9.87648434e-08, -0.946948707, 7.13271007e-08, 1, 8.00902953e-08, 0.946948707, -4.18033075e-08, -0.321384728), MobPos = CFrame.new(11008.5195, -2007.72839, 10223.0791, -0.688615739, 2.33523378e-09, -0.725126445, 2.99292546e-09, 1, 3.78221315e-10, 0.725126445, -1.90980032e-09, -0.688615739) },
    ["High Disciple"] = { Name = "SubmergedQuest3", Level = 1, QuestPos = CFrame.new(9640.08789, -1992.44507, 9613.65234, -0.957327187, 4.11991223e-08, 0.289006323, 1.5775445e-08, 1, -9.02985846e-08, -0.289006323, -8.18860855e-08, -0.957327187), MobPos = CFrame.new(9750.41602, -1966.93884, 9753.36035, -0.749824047, 5.57797613e-08, -0.661637306, 2.03500754e-08, 1, 6.1243199e-08, 0.661637306, 3.24572511e-08, -0.749824047) },
    ["Grand Devotee"] = { Name = "SubmergedQuest3", Level = 2, QuestPos = CFrame.new(9640.08789, -1992.44507, 9613.65234, -0.957327187, 4.11991223e-08, 0.289006323, 1.5775445e-08, 1, -9.02985846e-08, -0.289006323, -8.18860855e-08, -0.957327187), MobPos = CFrame.new(9611.70508, -1993.47119, 9882.68848, -0.591375351, 4.14332426e-08, -0.806396425, 4.73774868e-08, 1, 1.66361875e-08, 0.806396425, -2.83668058e-08, -0.591375351) },
}
function GetCurrentQuest()
    local level = GetLevel()
    local best = nil
    local bestDiff = math.huge
    for mobName, data in pairs(QuestData) do
        local diff = math.abs(level - data.Level)
        if diff < bestDiff then
            bestDiff = diff
            best = {Name = mobName, Data = data}
        end
    end
    return best
end

function GetNearestMob(mobName)
    local hrp = GetHRP()
    if not hrp then return nil end
    local closest, minDist = nil, math.huge
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        if mob.Name == mobName and G_Alive(mob) and mob:FindFirstChild("HumanoidRootPart") then
            local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < minDist then minDist = dist; closest = mob end
        end
    end
    return closest
end

-- ========================================
-- FARM MAIN PAGE
-- ========================================
FarmMain:Seperator("Main Farm Settings")

FarmMain:Dropdown("Select Weapon", {"Melee", "Sword", "Blox Fruit", "Gun"}, GetSetting("ChooseWP", "Melee"), function(v)
    _G.ChooseWP = v
    _G.SaveData["ChooseWP"] = v
    SaveSettings()
end)

FarmMain:Dropdown("Select Farm Mode", {"Level", "Bone", "Cake Prince", "Material"}, GetSetting("SelectedFarmMode", "Level"), function(v)
    _G.SelectedFarmMode = v
    _G.SaveData["SelectedFarmMode"] = v
    SaveSettings()
end)

FarmMain:Toggle("Start Farm", false, function(v)
    _G.StartFarm = v
    _G.Level = false
    _G.AutoFarm_Bone = false
    _G.AutoFarm_Cake = false
    _G.AutoMaterial = false
    if v then
        if _G.SelectedFarmMode == "Level" then _G.Level = true
        elseif _G.SelectedFarmMode == "Bone" then _G.AutoFarm_Bone = true
        elseif _G.SelectedFarmMode == "Cake Prince" then _G.AutoFarm_Cake = true
        elseif _G.SelectedFarmMode == "Material" then _G.AutoMaterial = true
        end
    end
end)

FarmMain:Toggle("Accept Quests", GetSetting("AcceptQuest", false), function(v)
    _G.AcceptQuest = v
    _G.SaveData["AcceptQuest"] = v
    SaveSettings()
end)

FarmMain:Seperator("Farm Status")
local farmStatusLabel = FarmMain:Label("Status: Inactive")
local currentMobLabel = FarmMain:Label("Mob: None")

task.spawn(function()
    while task.wait(1) do
        local status = "Inactive"
        local mobName = "None"
        if _G.StartFarm then
            if _G.Level then status = "Level Farming"; local q = GetCurrentQuest(); if q then mobName = q.Name end
            elseif _G.AutoFarm_Bone then status = "Bone Farming"; mobName = "Skeletons/Zombies"
            elseif _G.AutoFarm_Cake then status = "Cake Prince"; mobName = "Cake Mobs"
            elseif _G.AutoMaterial then status = "Material Farming"; mobName = getgenv().SelectMaterial or "Unknown"
            end
        end
        farmStatusLabel:Set("Status: " .. status)
        currentMobLabel:Set("Mob: " .. mobName)
    end
end)

FarmMain:Seperator("Additional Farms")
FarmMain:Toggle("Kill Mobs Nearest", GetSetting("AutoFarmNear", false), function(v)
    _G.AutoFarmNear = v
    _G.SaveData["AutoFarmNear"] = v
    SaveSettings()
end)

if World2 then
    FarmMain:Toggle("Auto Factory Raid", GetSetting("AutoFactory", false), function(v) _G.AutoFactory = v; SaveSettings() end)
end
if World3 then
    FarmMain:Toggle("Auto Pirate Raid", GetSetting("AutoRaidCastle", false), function(v) _G.AutoRaidCastle = v; SaveSettings() end)
    FarmMain:Toggle("Auto Tyrant", GetSetting("AutoTyrant", false), function(v) _G.AutoTyrant = v; SaveSettings() end)
end

FarmMain:Seperator("Collect")
FarmMain:Toggle("Auto Collect Chest", GetSetting("AutoFarmChest", false), function(v) _G.AutoFarmChest = v; SaveSettings() end)
FarmMain:Toggle("Auto Collect Berry", GetSetting("AutoBerry", false), function(v) _G.AutoBerry = v; SaveSettings() end)

-- ========================================
-- FARM SETTINGS PAGE
-- ========================================
FarmSettings:Seperator("Farm Configuration")
FarmSettings:Slider("Distance Near Farm", 0, 5000, GetSetting("MaxFarmDistance", 325), function(v) _G.MaxFarmDistance = v; SaveSettings() end)
FarmSettings:Slider("Mob Height", 5, 100, GetSetting("MobHeight", 20), function(v) _G.MobHeight = v; SaveSettings() end)
FarmSettings:Slider("Bring Range", 50, 500, GetSetting("BringRange", 235), function(v) _G.BringRange = v; SaveSettings() end)
FarmSettings:Textbox("Max Bring Mobs", tostring(GetSetting("MaxBringMobs", 3)), function(v) local n=tonumber(v); if n then _G.MaxBringMobs = n; SaveSettings() end end)
FarmSettings:Textbox("Tween Speed", tostring(GetSetting("TweenSpeedFar", 300)), function(v) local n=tonumber(v); if n then getgenv().TweenSpeedFar = n; SaveSettings() end end)

FarmSettings:Seperator("Auto Skills")
FarmSettings:Toggle("Auto Active Haki", GetSetting("AutoHaki", true), function(v) _G.AutoHaki = v; SaveSettings() end)
FarmSettings:Toggle("Auto Active V3", GetSetting("AutoV3", false), function(v) _G.AutoV3 = v; SaveSettings() end)
FarmSettings:Toggle("Auto Active V4", GetSetting("AutoV4", false), function(v) _G.AutoV4 = v; SaveSettings() end)

-- ========================================
-- BOSS FARM PAGE
-- ========================================
FarmBoss:Seperator("Boss Farm")
local bossStatusPara = FarmBoss:Label("No boss selected")
FarmBoss:Dropdown("Select Boss", Boss, _G.FindBoss, function(v) _G.FindBoss = v; SaveSettings() end)
FarmBoss:Button("Refresh Boss List", function()
    local live = {}
    for _, b in ipairs(Boss) do if Workspace.Enemies:FindFirstChild(b) or ReplicatedStorage:FindFirstChild(b) then table.insert(live, b) end end
    bossStatusPara:Set(#live>0 and "Spawned: "..table.concat(live,", ") or "No bosses spawned")
end)
FarmBoss:Toggle("Auto Farm Boss Select", GetSetting("AutoBoss", false), function(v) _G.AutoBoss = v; if v then _G.FarmAllBoss = false end; SaveSettings() end)
FarmBoss:Toggle("Farm All Bosses", GetSetting("FarmAllBoss", false), function(v) _G.FarmAllBoss = v; if v then _G.AutoBoss = false end; SaveSettings() end)

-- ========================================
-- FARM LOGIC LOOPS
-- ========================================
-- Weapon Auto-Select
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.ChooseWP then
                for _, t in pairs(plr.Backpack:GetChildren()) do
                    if t:IsA("Tool") and t.ToolTip == _G.ChooseWP then _G.SelectWeapon = t.Name; break end
                end
            end
        end)
    end
end)

-- Level Farm Loop
task.spawn(function()
    local currentMob = nil
    while task.wait() do
        if _G.Level and _G.StartFarm then
            pcall(function()
                local quest = GetCurrentQuest()
                if not quest then return end
                local questUI = plr.PlayerGui.Main.Quest
                if _G.AcceptQuest and not questUI.Visible then
                    _tp(quest.Data.QuestPos)
                    if (GetHRP().Position - quest.Data.QuestPos.Position).Magnitude <= 10 then
                        task.wait(0.5)
                        commF:InvokeServer("StartQuest", quest.Data.Name, quest.Data.Level)
                    end
                    return
                end
                if currentMob and G_Alive(currentMob) then
                    G_Kill(currentMob, true)
                else
                    currentMob = GetNearestMob(quest.Name)
                    if not currentMob then _tp(quest.Data.MobPos) end
                end
            end)
        else
            currentMob = nil
        end
    end
end)

-- Kill Nearest Loop
task.spawn(function()
    while task.wait() do
        if _G.AutoFarmNear then
            pcall(function()
                local hrp = GetHRP()
                if not hrp then return end
                local closest, minDist = nil, math.huge
                for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                    if G_Alive(mob) and mob:FindFirstChild("HumanoidRootPart") then
                        local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < minDist and dist <= _G.MaxFarmDistance then
                            minDist = dist; closest = mob
                        end
                    end
                end
                if closest then G_Kill(closest, true) end
            end)
        end
    end
end)

-- Boss Farm Loop
task.spawn(function()
    while task.wait() do
        if _G.AutoBoss and _G.FindBoss then
            pcall(function()
                local boss = Workspace.Enemies:FindFirstChild(_G.FindBoss) or ReplicatedStorage:FindFirstChild(_G.FindBoss)
                if boss and G_Alive(boss) then G_Kill(boss, true) end
            end)
        end
    end
end)

-- Farm All Bosses Loop
task.spawn(function()
    while task.wait() do
        if _G.FarmAllBoss then
            pcall(function()
                for _, bossName in ipairs(Boss) do
                    local boss = Workspace.Enemies:FindFirstChild(bossName)
                    if boss and G_Alive(boss) then G_Kill(boss, true); break end
                end
            end)
        end
    end
end)

-- Auto Haki/V3/V4
task.spawn(function() while task.wait(1) do if _G.AutoHaki then pcall(function() if plr.Character and not plr.Character:FindFirstChild("HasBuso") then commF:InvokeServer("Buso") end end) end end end)
task.spawn(function() while task.wait(30) do if _G.AutoV3 then pcall(function() commE:FireServer("ActivateAbility") end) end end end)
task.spawn(function() while task.wait(0.2) do if _G.AutoV4 then pcall(function() local e=plr.Character and plr.Character:FindFirstChild("RaceEnergy"); if e and e.Value==1 then VirtualInputManager:SendKeyEvent(true,"Y",false,game); VirtualInputManager:SendKeyEvent(false,"Y",false,game) end end) end end end)

print("Part 2 Loaded: Farming Tab")

--[[
    KuKi Hub | Ture V2 - Part 3
    Quests/Items Tab - Quest Automation & Item Farming
]]

-- ========================================
-- QUESTS TAB PAGES
-- ========================================
local QuestMain = Tab3:CraftPage(1)      -- Main Quests
local QuestTravel = Tab3:CraftPage(2)    -- Travel Quests
local QuestItems = Tab3:CraftPage(3)     -- Item Farming
local QuestSwords = Tab3:CraftPage(4)    -- Sword Quests

-- ========================================
-- GLOBAL QUEST VARIABLES
-- ========================================
_G.obsFarm = GetSetting("obsFarm", false)
_G.AutoKenVTWO = GetSetting("AutoKenVTWO", false)
_G.CitizenQuest = GetSetting("CitizenQuest", false)
_G.FarmEliteHunt = GetSetting("FarmEliteHunt", false)
_G.StopWhenChalice = GetSetting("StopWhenChalice", true)
_G.Auto_Tushita = GetSetting("Auto_Tushita", false)
_G.Auto_Yama = GetSetting("Auto_Yama", false)
_G.Auto_Rainbow_Haki = GetSetting("Auto_Rainbow_Haki", false)
_G.GetQFast = GetSetting("GetQFast", false)
_G.TravelDres = GetSetting("TravelDres", false)
_G.AutoZou = GetSetting("AutoZou", false)

-- Item Farms
_G.AutoSaw = GetSetting("AutoSaw", false)
_G.SwanCoat = GetSetting("SwanCoat", false)
_G.MarinesCoat = GetSetting("MarinesCoat", false)
_G.WardenBoss = GetSetting("WardenBoss", false)
_G.AutoColShad = GetSetting("AutoColShad", false)
_G.AutoEcBoss = GetSetting("AutoEcBoss", false)
_G.IceBossRen = GetSetting("IceBossRen", false)
_G.KeysRen = GetSetting("KeysRen", false)
_G.AutoPoleV2 = GetSetting("AutoPoleV2", false)
_G.Greybeard = GetSetting("Greybeard", false)
_G.Auto_SwanGG = GetSetting("Auto_SwanGG", false)
_G.Auto_Cavender = GetSetting("Auto_Cavender", false)
_G.AutoBigmom = GetSetting("AutoBigmom", false)
_G.DummyMan = GetSetting("DummyMan", false)
_G.AutoTridentW2 = GetSetting("AutoTridentW2", false)
_G.Auto_Soul_Guitar = GetSetting("Auto_Soul_Guitar", false)

-- CDK
_G.CDK_YM = GetSetting("CDK_YM", false)
_G.CDK_TS = GetSetting("CDK_TS", false)
_G.CDK = GetSetting("CDK", false)
_G.Tp_MasterA = GetSetting("Tp_MasterA", false)
_G.Tp_LgS = GetSetting("Tp_LgS", false)

-- ========================================
-- QUEST MAIN PAGE
-- ========================================
QuestMain:Seperator("Main Quests")

QuestMain:Toggle("Auto Farm Observation Haki", _G.obsFarm, function(v)
    _G.obsFarm = v; _G.SaveData["obsFarm"] = v; SaveSettings()
end)

if World3 then
    QuestMain:Toggle("Auto Observation V2", _G.AutoKenVTWO, function(v)
        _G.AutoKenVTWO = v; _G.SaveData["AutoKenVTWO"] = v; SaveSettings()
    end)
    QuestMain:Toggle("Auto Citizen Quest", _G.CitizenQuest, function(v)
        _G.CitizenQuest = v; _G.SaveData["CitizenQuest"] = v; SaveSettings()
    end)
end

if World3 then
    QuestMain:Seperator("Elite Hunter")
    local eliteProgressLabel = QuestMain:Label("Loading...")
    task.spawn(function()
        while task.wait(2) do
            pcall(function()
                local progress = commF:InvokeServer("EliteHunter", "Progress")
                eliteProgressLabel:Set("Killed: " .. tostring(progress) .. " / 30")
            end)
        end
    end)
    QuestMain:Toggle("Auto Elite Quest", _G.FarmEliteHunt, function(v)
        _G.FarmEliteHunt = v; _G.SaveData["FarmEliteHunt"] = v; SaveSettings()
    end)
    QuestMain:Toggle("Stop when got God's Chalice", _G.StopWhenChalice, function(v)
        _G.StopWhenChalice = v; _G.SaveData["StopWhenChalice"] = v; SaveSettings()
    end)
end

if World3 then
    QuestMain:Seperator("Rainbow Haki")
    QuestMain:Toggle("Auto Rainbow Haki", _G.Auto_Rainbow_Haki, function(v)
        _G.Auto_Rainbow_Haki = v; _G.SaveData["Auto_Rainbow_Haki"] = v; SaveSettings()
    end)
end

QuestMain:Seperator("Quest Bypass")
QuestMain:Toggle("Accept Quest Bypass [Risk]", _G.GetQFast, function(v)
    _G.GetQFast = v; _G.SaveData["GetQFast"] = v; SaveSettings()
end)

-- ========================================
-- QUEST TRAVEL PAGE
-- ========================================
QuestTravel:Seperator("Travel Quests")

if World1 then
    QuestTravel:Toggle("Auto Quest Sea 2", _G.TravelDres, function(v)
        _G.TravelDres = v; _G.SaveData["TravelDres"] = v; SaveSettings()
    end)
end
if World2 then
    QuestTravel:Toggle("Auto Quest Sea 3", _G.AutoZou, function(v)
        _G.AutoZou = v; _G.SaveData["AutoZou"] = v; SaveSettings()
    end)
end

-- ========================================
-- QUEST ITEMS PAGE
-- ========================================
QuestItems:Seperator("Item Farming")

if World1 then
    QuestItems:Toggle("Auto Saw Sword", _G.AutoSaw, function(v) _G.AutoSaw = v; SaveSettings() end)
    QuestItems:Toggle("Auto Marine Coat", _G.MarinesCoat, function(v) _G.MarinesCoat = v; SaveSettings() end)
    QuestItems:Toggle("Auto Warden Sword", _G.WardenBoss, function(v) _G.WardenBoss = v; SaveSettings() end)
    QuestItems:Toggle("Auto Cyborg Sword", _G.AutoColShad, function(v) _G.AutoColShad = v; SaveSettings() end)
    QuestItems:Toggle("Auto Bisento V2", _G.Greybeard, function(v) _G.Greybeard = v; SaveSettings() end)
end
if World2 then
    QuestItems:Toggle("Auto Swan Coat", _G.SwanCoat, function(v) _G.SwanCoat = v; SaveSettings() end)
    QuestItems:Toggle("Auto Dragon Trident", _G.AutoTridentW2, function(v) _G.AutoTridentW2 = v; SaveSettings() end)
    QuestItems:Toggle("Auto Midnight Blade", _G.AutoEcBoss, function(v) _G.AutoEcBoss = v; SaveSettings() end)
    QuestItems:Toggle("Auto Rengoku Sword", _G.IceBossRen, function(v) _G.IceBossRen = v; SaveSettings() end)
    QuestItems:Toggle("Auto Rengoku Key", _G.KeysRen, function(v) _G.KeysRen = v; SaveSettings() end)
    QuestItems:Toggle("Auto Swan Glasses", _G.Auto_SwanGG, function(v) _G.Auto_SwanGG = v; SaveSettings() end)
end
if World2 or World3 then
    QuestItems:Toggle("Auto Pole V2 [Beta]", _G.AutoPoleV2, function(v) _G.AutoPoleV2 = v; SaveSettings() end)
end
if World3 then
    QuestItems:Toggle("Auto Canvendish Sword", _G.Auto_Cavender, function(v) _G.Auto_Cavender = v; SaveSettings() end)
    QuestItems:Toggle("Auto Bigmom (Cake Queen)", _G.AutoBigmom, function(v) _G.AutoBigmom = v; SaveSettings() end)
    QuestItems:Toggle("Auto Training Dummy", _G.DummyMan, function(v) _G.DummyMan = v; SaveSettings() end)
end

if World3 then
    QuestItems:Seperator("Skull Guitar")
    local soulStatusLabel = QuestItems:Label("Inactive")
    QuestItems:Toggle("Auto Skull Guitar", _G.Auto_Soul_Guitar, function(v)
        _G.Auto_Soul_Guitar = v; SaveSettings()
    end)
    task.spawn(function()
        while task.wait(2) do
            if _G.Auto_Soul_Guitar then
                pcall(function()
                    local q = commF:InvokeServer("GuitarPuzzleProgress", "Check")
                    local s = "Unknown"
                    if q then
                        if q.Swamp == false then s = "Quest 1: Swamp"
                        elseif q.Gravestones == false then s = "Quest 2: Gravestones"
                        elseif q.Ghost == false then s = "Quest 3: Ghost"
                        elseif q.Trophies == false then s = "Quest 4: Trophies"
                        elseif q.Pipes == false then s = "Quest 5: Pipes"
                        else s = "Final Step" end
                    end
                    soulStatusLabel:Set(s)
                end)
            else
                soulStatusLabel:Set("Disabled")
            end
        end
    end)
end

-- ========================================
-- QUEST SWORDS PAGE
-- ========================================
QuestSwords:Seperator("Cursed Swords")

if World3 then
    QuestSwords:Toggle("Auto Yama Sword", _G.Auto_Yama, function(v) _G.Auto_Yama = v; SaveSettings() end)
    QuestSwords:Toggle("Auto Tushita Sword", _G.Auto_Tushita, function(v) _G.Auto_Tushita = v; SaveSettings() end)
    
    QuestSwords:Seperator("Cursed Dual Katana")
    local cdkLabel = QuestSwords:Label("Loading...")
    task.spawn(function()
        while task.wait(3) do
            pcall(function()
                local p = commF:InvokeServer("CDKQuest", "Progress")
                if p and type(p)=="table" then
                    cdkLabel:Set(string.format("Good: %s | Evil: %s", tostring(p.Good or 0), tostring(p.Evil or 0)))
                end
            end)
        end
    end)
    QuestSwords:Toggle("Auto Yama CDK", _G.CDK_YM, function(v) _G.CDK_YM = v; SaveSettings() end)
    QuestSwords:Toggle("Auto Tushita CDK", _G.CDK_TS, function(v) _G.CDK_TS = v; SaveSettings() end)
    QuestSwords:Toggle("Auto Kill Cursed Skeleton Boss", _G.CDK, function(v) _G.CDK = v; SaveSettings() end)
    
    QuestSwords:Seperator("True Triple Katana")
    QuestSwords:Button("Buy Legendary Sword", function()
        commF:InvokeServer("LegendarySwordDealer", "1")
        commF:InvokeServer("LegendarySwordDealer", "2")
        commF:InvokeServer("LegendarySwordDealer", "3")
    end)
    QuestSwords:Button("Buy True Triple Katana", function()
        commF:InvokeServer("MysteriousMan", "2")
    end)
    QuestSwords:Toggle("Teleport to Legendary Sword Dealer", _G.Tp_LgS, function(v) _G.Tp_LgS = v; SaveSettings() end)
end

if World2 or World3 then
    QuestSwords:Seperator("Buso Colors")
    QuestSwords:Toggle("Teleport Barista Haki", _G.Tp_MasterA, function(v) _G.Tp_MasterA = v; SaveSettings() end)
    QuestSwords:Button("Buy Buso Colors", function() commF:InvokeServer("ColorsDealer", "2") end)
end

-- ========================================
-- QUEST LOGIC LOOPS
-- ========================================

-- Travel Sea 2 (World1)
if World1 then
    task.spawn(function()
        while task.wait(1) do
            if _G.TravelDres and GetLevel() >= 700 then
                pcall(function()
                    local iceDoor = Workspace.Map and Workspace.Map:FindFirstChild("Ice") and Workspace.Map.Ice:FindFirstChild("Door")
                    if iceDoor then
                        if iceDoor.CanCollide and iceDoor.Transparency == 0 then
                            commF:InvokeServer("DressrosaQuestProgress", "Detective")
                            EquipWeapon("Key")
                            _tp(CFrame.new(1347.71, 37.37, -1325.64))
                        elseif not iceDoor.CanCollide and iceDoor.Transparency == 1 then
                            local boss = Workspace.Enemies:FindFirstChild("Ice Admiral")
                            if boss and G_Alive(boss) then G_Kill(boss, true) else _tp(CFrame.new(1347.71, 37.37, -1325.64)) end
                        else commF:InvokeServer("TravelDressrosa") end
                    end
                end)
            end
        end
    end)
end

-- Travel Sea 3 (World2)
if World2 then
    task.spawn(function()
        while task.wait(1) do
            if _G.AutoZou and GetLevel() >= 1500 then
                pcall(function()
                    local bp = commF:InvokeServer("BartiloQuestProgress", "Bartilo")
                    if bp == 0 then
                        if not plr.PlayerGui.Main.Quest.Visible then
                            _tp(CFrame.new(-456.28, 73.02, 299.89))
                            if (GetHRP().Position - CFrame.new(-456.28, 73.02, 299.89).Position).Magnitude <= 5 then
                                task.wait(1); commF:InvokeServer("StartQuest", "BartiloQuest", 1)
                            end
                        else
                            local mob = GetConnectionEnemies("Swan Pirate")
                            if mob then G_Kill(mob, true) else _tp(CFrame.new(1057.92, 137.61, 1242.08)) end
                        end
                    elseif bp == 1 then
                        local mob = GetConnectionEnemies("Jeremy")
                        if mob then G_Kill(mob, true) else _tp(CFrame.new(2099.88, 448.93, 648.99)) end
                    elseif bp == 2 then
                        _tp(CFrame.new(-1836, 11, 1714))
                        if (GetHRP().Position - CFrame.new(-1836, 11, 1714).Position).Magnitude <= 10 then
                            task.wait(0.5); notween(CFrame.new(-1850.49, 13.17, 1750.89))
                        end
                    else
                        local unlock = commF:InvokeServer("GetUnlockables")
                        if unlock and unlock.FlamingoAccess == nil then
                            commF:InvokeServer("F_", "TalkTrevor", "1"); commF:InvokeServer("F_", "TalkTrevor", "2"); commF:InvokeServer("F_", "TalkTrevor", "3")
                        else commF:InvokeServer("F_", "TravelZou") end
                    end
                end)
            end
        end
    end)
end

-- Auto Observation
task.spawn(function()
    while task.wait(0.5) do
        if _G.obsFarm then
            pcall(function()
                commE:FireServer("Ken", true)
                local dodges = plr:GetAttribute("KenDodgesLeft")
                local kenTest = dodges and dodges > 0
                local target = nil
                local pos = nil
                if World1 then target = Workspace.Enemies:FindFirstChild("Galley Captain"); pos = CFrame.new(5533.29, 88.10, 4852.39)
                elseif World2 then target = Workspace.Enemies:FindFirstChild("Lava Pirate"); pos = CFrame.new(-5478.39, 15.97, -5246.91)
                elseif World3 then target = Workspace.Enemies:FindFirstChild("Venomous Assailant"); pos = CFrame.new(4530.35, 656.75, -131.60) end
                if target then
                    if kenTest then _tp(target.HumanoidRootPart.CFrame * CFrame.new(3,0,0))
                    else _tp(target.HumanoidRootPart.CFrame * CFrame.new(0,50,0)) end
                elseif pos then _tp(pos) end
            end)
        end
    end
end)

-- Auto Elite (World3)
if World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.FarmEliteHunt then
                if _G.StopWhenChalice and (GetBP("God's Chalice") or GetBP("Sweet Chalice") or GetBP("Fist of Darkness")) then
                    _G.FarmEliteHunt = false; return
                end
                pcall(function()
                    if plr.PlayerGui.Main.Quest.Visible then
                        for _, n in ipairs({"Diablo","Urban","Deandre"}) do
                            local m = GetConnectionEnemies(n); if m then G_Kill(m, true); break end
                        end
                    else commF:InvokeServer("EliteHunter") end
                end)
            end
        end
    end)
end

-- Auto Citizen (World3)
if World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.CitizenQuest and GetLevel() >= 1800 then
                pcall(function()
                    local prog = commF:InvokeServer("CitizenQuestProgress")
                    local ui = plr.PlayerGui.Main.Quest
                    if prog.KilledBandits == false then
                        if ui.Visible and string.find(ui.Container.QuestTitle.Title.Text, "Forest Pirate") then
                            local m = GetConnectionEnemies("Forest Pirate"); if m then G_Kill(m, true) else _tp(CFrame.new(-13206.45, 425.89, -7964.55)) end
                        else
                            _tp(CFrame.new(-12443.86, 332.40, -7675.48))
                            if (GetHRP().Position - CFrame.new(-12443.86, 332.40, -7675.48).Position).Magnitude <= 30 then
                                task.wait(1.5); commF:InvokeServer("StartQuest", "CitizenQuest", 1)
                            end
                        end
                    elseif prog.KilledBoss == false then
                        if ui.Visible and string.find(ui.Container.QuestTitle.Title.Text, "Captain Elephant") then
                            local m = GetConnectionEnemies("Captain Elephant"); if m then G_Kill(m, true) else _tp(CFrame.new(-13374.88, 421.27, -8225.20)) end
                        else
                            _tp(CFrame.new(-12443.86, 332.40, -7675.48))
                            if (GetHRP().Position - CFrame.new(-12443.86, 332.40, -7675.48).Position).Magnitude <= 4 then
                                task.wait(1.5); commF:InvokeServer("CitizenQuestProgress", "Citizen")
                            end
                        end
                    elseif prog == 2 then _tp(CFrame.new(-12512.13, 340.39, -9872.82)) end
                end)
            end
        end
    end)
end

-- Item Farms - World1
if World1 then
    task.spawn(function() while task.wait(0.5) do if _G.AutoSaw then local b=GetConnectionEnemies("The Saw"); if b then G_Kill(b,true) else _tp(CFrame.new(-784.89,72.42,1603.58)) end end end end)
    task.spawn(function() while task.wait(0.5) do if _G.MarinesCoat then local b=GetConnectionEnemies("Vice Admiral"); if b then G_Kill(b,true) else _tp(CFrame.new(-5006.54,88.03,4353.16)) end end end end)
    task.spawn(function() while task.wait(0.5) do if _G.WardenBoss then local b=GetConnectionEnemies("Chief Warden"); if b then G_Kill(b,true) else _tp(CFrame.new(5206.92,0.99,814.97)) end end end end)
    task.spawn(function() while task.wait(0.5) do if _G.AutoColShad then local b=GetConnectionEnemies("Cyborg"); if b then G_Kill(b,true) else _tp(CFrame.new(6094.02,73.77,3825.73)) end end end end)
    task.spawn(function() while task.wait(1) do if _G.Greybeard then if not GetBP("Bisento") then commF:InvokeServer("BuyItem","Bisento") else local b=GetConnectionEnemies("Greybeard"); if b then G_Kill(b,true) else _tp(CFrame.new(-5023.38,28.65,4332.38)) end end end end end)
end

-- Item Farms - World2
if World2 then
    task.spawn(function() while task.wait(0.5) do if _G.SwanCoat then local b=GetConnectionEnemies("Swan"); if b then G_Kill(b,true) else _tp(CFrame.new(5325.09,7.03,719.57)) end end end end)
    task.spawn(function() while task.wait(1) do if _G.AutoTridentW2 then local b=GetConnectionEnemies("Tide Keeper"); if b then G_Kill(b,true) else _tp(CFrame.new(-3795.64,105.88,-11421.30)) end end end end)
    task.spawn(function() while task.wait(1) do if _G.AutoEcBoss then if GetM("Ectoplasm")>=99 then commF:InvokeServer("Ectoplasm","Buy",3) else local b=GetConnectionEnemies("Cursed Captain"); if b then G_Kill(b,true) else _tp(CFrame.new(916.92,181.09,33422)) end end end end end)
    task.spawn(function() while task.wait(0.5) do if _G.IceBossRen then local b=GetConnectionEnemies("Awakened Ice Admiral"); if b then G_Kill(b,true) else _tp(CFrame.new(5668.97,28.51,-6483.35)) end end end end)
    task.spawn(function() while task.wait(0.5) do if _G.KeysRen then if GetBP("Hidden Key") then EquipWeapon("Hidden Key"); _tp(CFrame.new(6571.12,299.23,-6967.84)) else local m=GetConnectionEnemies({"Snow Lurker","Arctic Warrior","Awakened Ice Admiral"}); if m then G_Kill(m,true) else _tp(CFrame.new(5439.71,84.42,-6715.16)) end end end end end)
    task.spawn(function() while task.wait(0.5) do if _G.Auto_SwanGG then local b=GetConnectionEnemies("Don Swan"); if b then G_Kill(b,true) else _tp(CFrame.new(2286.20,15.17,863.83)) end end end end)
end

-- Item Farms - World3
if World3 then
    task.spawn(function() while task.wait(1) do if _G.Auto_Cavender then local b=GetConnectionEnemies("Beautiful Pirate"); if b then G_Kill(b,true) else _tp(CFrame.new(5283.60,22.56,-110.78)) end end end end)
    task.spawn(function() while task.wait(1) do if _G.AutoBigmom then local b=GetConnectionEnemies("Cake Queen"); if b then G_Kill(b,true) else _tp(CFrame.new(-709.31,381.60,-11011.39)) end end end end)
    task.spawn(function() while task.wait(1) do if _G.DummyMan then if not plr.PlayerGui.Main.Quest.Visible then commF:InvokeServer("ArenaTrainer") else local d=GetConnectionEnemies("Training Dummy"); if d then G_Kill(d,true) else _tp(CFrame.new(3688.00,12.74,170.20)) end end end end end)
    
    -- Yama & Tushita
    task.spawn(function() while task.wait(1) do if _G.Auto_Yama then if commF:InvokeServer("EliteHunter","Progress")<30 then _G.FarmEliteHunt=true else _G.FarmEliteHunt=false; local k=Workspace.Map.Waterfall.SealedKatana; if k and (k.Handle.Position-GetHRP().Position).Magnitude>=20 then _tp(k.Handle.CFrame); local g=GetConnectionEnemies("Ghost"); if g then G_Kill(g,true); fireclickdetector(k.Handle.ClickDetector) end end end end end end)
    task.spawn(function() while task.wait(1) do if _G.Auto_Tushita then if Workspace.Map.Turtle:FindFirstChild("TushitaGate") then if not GetBP("Holy Torch") then _tp(CFrame.new(5148.03,162.35,910.54)) else EquipWeapon("Holy Torch"); for _,p in ipairs({CFrame.new(-10752,417,-9366),CFrame.new(-11672,334,-9474),CFrame.new(-12132,521,-10655),CFrame.new(-13336,486,-6985),CFrame.new(-13489,332,-7925)}) do repeat task.wait(); _tp(p) until (p.Position-GetHRP().Position).Magnitude<=10 end end else local l=GetConnectionEnemies("Longma"); if l then G_Kill(l,true) end end end end end)
    
    -- CDK Boss
    task.spawn(function() while task.wait(1) do if _G.CDK then local b=GetConnectionEnemies("Cursed Skeleton Boss"); if b then if GetBP("Yama") or GetBP("Tushita") then EquipWeapon(GetBP("Yama") and "Yama" or "Tushita") end; _tp(b.HumanoidRootPart.CFrame*CFrame.new(0,20,0)); G_Kill(b,true) else _tp(CFrame.new(-12318.19,601.95,-6538.66)); task.wait(0.5); _tp(Workspace.Map.Turtle.Cursed.BossDoor.CFrame) end end end end)
end

-- Teleport NPCs
if World2 or World3 then
    task.spawn(function() while task.wait(0.5) do if _G.Tp_MasterA then for _,n in pairs(ReplicatedStorage.NPCs:GetChildren()) do if n.Name=="Barista Cousin" then _tp(n.HumanoidRootPart.CFrame); break end end end end end)
end
if World3 then
    task.spawn(function() while task.wait(0.5) do if _G.Tp_LgS then for _,n in pairs(ReplicatedStorage.NPCs:GetChildren()) do if n.Name=="Legendary Sword Dealer" then _tp(n.HumanoidRootPart.CFrame); break end end end end end)
end

print("Part 3 Loaded: Quests/Items Tab")

--[[
    KuKi Hub | Ture V2 - Part 4
    Settings Tab - Combat, Auto Skills, Movement, Farm Config, Auto Hop
]]

-- ========================================
-- SETTINGS TAB PAGES
-- ========================================
local SettingsCombat = Tab4:CraftPage(1)    -- Combat Settings
local SettingsSkills = Tab4:CraftPage(2)    -- Auto Skills
local SettingsMove = Tab4:CraftPage(3)      -- Movement
local SettingsFarm = Tab4:CraftPage(4)      -- Farm Config
local SettingsHop = Tab4:CraftPage(5)       -- Auto Hop

-- ========================================
-- GLOBAL SETTINGS VARIABLES
-- ========================================
-- Combat
_G.FastAttack = GetSetting("FastAttack", true)
_G.FastAttackMode = GetSetting("FastAttackMode", "Fast Attack")
_G.AutoClick = GetSetting("AutoClick", false)
_G.GunAura = GetSetting("GunAura", false)
_G.GunRange = GetSetting("GunRange", 500)
_G.TargetType = GetSetting("TargetType", "All")

-- Auto Skills
_G.AutoHaki = GetSetting("AutoHaki", true)
_G.AutoV3 = GetSetting("AutoV3", false)
_G.AutoV4 = GetSetting("AutoV4", false)

-- Movement
_G.AntiAFK = GetSetting("AntiAFK", true)
_G.WalkWater = GetSetting("WalkWater", true)
_G.NoClip = GetSetting("NoClip", false)
_G.WalkSpeedEnabled = GetSetting("SpeedToggle", false)
getgenv().WalkSpeedValue = GetSetting("WalkSpeedValue", 30)
_G.JumpEnabled = GetSetting("JumpToggle", false)
getgenv().JumpValue = GetSetting("JumpValue", 50)

-- Farm Config
_G.MobHeight = GetSetting("MobHeight", 20)
_G.BringRange = GetSetting("BringRange", 235)
_G.MaxBringMobs = GetSetting("MaxBringMobs", 3)
getgenv().TweenSpeedFar = GetSetting("TweenSpeedFar", 300)

-- Auto Hop
_G.AutoHopAdmin = GetSetting("AutoHopAdmin", true)
_G.AutoHopServer = GetSetting("AutoHopServer", false)
_G.HopDelay = GetSetting("HopDelay", 30) -- minutes

-- ========================================
-- HELPER FUNCTIONS
-- ========================================
local function applySpeedJump()
    local char = plr.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if _G.WalkSpeedEnabled then hum.WalkSpeed = getgenv().WalkSpeedValue end
            if _G.JumpEnabled then hum.JumpPower = getgenv().JumpValue end
        end
    end
end

-- ========================================
-- COMBAT SETTINGS PAGE
-- ========================================
SettingsCombat:Seperator("Fast Attack")
SettingsCombat:Dropdown("Select Attack Mode", {"Normal Attack", "Fast Attack", "Super Attack"}, _G.FastAttackMode, function(v)
    _G.FastAttackMode = v; _G.SaveData["FastAttackMode"] = v; SaveSettings()
end)
SettingsCombat:Toggle("Enable Fast Attack", _G.FastAttack, function(v)
    _G.FastAttack = v; _G.SaveData["FastAttack"] = v; SaveSettings()
end)
SettingsCombat:Toggle("Enable Auto Click", _G.AutoClick, function(v)
    _G.AutoClick = v; _G.SaveData["AutoClick"] = v; SaveSettings()
end)

SettingsCombat:Seperator("Gun Aura")
SettingsCombat:Toggle("Auto Gun Aura", _G.GunAura, function(v)
    _G.GunAura = v; _G.SaveData["GunAura"] = v; SaveSettings()
end)
SettingsCombat:Slider("Gun Range", 50, 3000, _G.GunRange, function(v)
    _G.GunRange = v; _G.SaveData["GunRange"] = v; SaveSettings()
end)
SettingsCombat:Dropdown("Select Target Type", {"Player", "NPC", "All"}, _G.TargetType, function(v)
    _G.TargetType = v; _G.SaveData["TargetType"] = v; SaveSettings()
end)

-- ========================================
-- AUTO SKILLS PAGE
-- ========================================
SettingsSkills:Seperator("Auto Skills")
SettingsSkills:Toggle("Auto Active Haki", _G.AutoHaki, function(v)
    _G.AutoHaki = v; _G.SaveData["AutoHaki"] = v; SaveSettings()
end)
SettingsSkills:Toggle("Auto Active V3", _G.AutoV3, function(v)
    _G.AutoV3 = v; _G.SaveData["AutoV3"] = v; SaveSettings()
end)
SettingsSkills:Toggle("Auto Active V4", _G.AutoV4, function(v)
    _G.AutoV4 = v; _G.SaveData["AutoV4"] = v; SaveSettings()
end)

-- ========================================
-- MOVEMENT PAGE
-- ========================================
SettingsMove:Seperator("Movement")
SettingsMove:Toggle("Anti AFK", _G.AntiAFK, function(v)
    _G.AntiAFK = v; _G.SaveData["AntiAFK"] = v; SaveSettings()
end)
SettingsMove:Toggle("Walk on Water", _G.WalkWater, function(v)
    _G.WalkWater = v; _G.SaveData["WalkWater"] = v; SaveSettings()
    local water = Workspace.Map["WaterBase-Plane"]
    if water then water.Size = v and Vector3.new(1000,112,1000) or Vector3.new(1000,80,1000) end
end)
SettingsMove:Toggle("No Clip", _G.NoClip, function(v)
    _G.NoClip = v; _G.SaveData["NoClip"] = v; SaveSettings()
end)

SettingsMove:Seperator("Speed/Jump")
SettingsMove:Toggle("Set WalkSpeed", _G.WalkSpeedEnabled, function(v)
    _G.WalkSpeedEnabled = v; _G.SaveData["SpeedToggle"] = v; SaveSettings(); applySpeedJump()
end)
SettingsMove:Textbox("WalkSpeed Value", tostring(getgenv().WalkSpeedValue), function(v)
    local n = tonumber(v); if n then getgenv().WalkSpeedValue = n; _G.SaveData["WalkSpeedValue"] = n; SaveSettings(); applySpeedJump() end
end)
SettingsMove:Toggle("Set JumpPower", _G.JumpEnabled, function(v)
    _G.JumpEnabled = v; _G.SaveData["JumpToggle"] = v; SaveSettings(); applySpeedJump()
end)
SettingsMove:Textbox("JumpPower Value", tostring(getgenv().JumpValue), function(v)
    local n = tonumber(v); if n then getgenv().JumpValue = n; _G.SaveData["JumpValue"] = n; SaveSettings(); applySpeedJump() end
end)

-- Watch character for speed/jump
plr.CharacterAdded:Connect(applySpeedJump)
RunService.Heartbeat:Connect(applySpeedJump)

-- No Clip loop
task.spawn(function()
    RunService.Stepped:Connect(function()
        if _G.NoClip and plr.Character then
            for _, p in pairs(plr.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end
    end)
end)

-- ========================================
-- FARM CONFIG PAGE
-- ========================================
SettingsFarm:Seperator("Farm Configuration")
SettingsFarm:Slider("Mob Height", 5, 100, _G.MobHeight, function(v)
    _G.MobHeight = v; _G.SaveData["MobHeight"] = v; SaveSettings()
end)
SettingsFarm:Slider("Bring Range", 50, 500, _G.BringRange, function(v)
    _G.BringRange = v; _G.SaveData["BringRange"] = v; SaveSettings()
end)
SettingsFarm:Textbox("Max Bring Mobs", tostring(_G.MaxBringMobs), function(v)
    local n = tonumber(v); if n and n > 0 then _G.MaxBringMobs = n; _G.SaveData["MaxBringMobs"] = n; SaveSettings() end
end)
SettingsFarm:Textbox("Tween Speed", tostring(getgenv().TweenSpeedFar), function(v)
    local n = tonumber(v); if n and n > 0 then getgenv().TweenSpeedFar = n; _G.SaveData["TweenSpeedFar"] = n; SaveSettings() end
end)

-- ========================================
-- AUTO HOP PAGE
-- ========================================
local AdminNames = {"red_game43","rip_indra","Axiore","Polkster","wenlocktoad","Daigrock","toilamvidamme","oofficialnoobie","Uzoth","Azarth","arlthmetic","Death_King","Lunoven","TheGreateAced","rip_fud","drip_mama","layandikit12","Hingoi"}

SettingsHop:Seperator("Auto Hop")
SettingsHop:Toggle("Auto Hop when Admin Join", _G.AutoHopAdmin, function(v)
    _G.AutoHopAdmin = v; _G.SaveData["AutoHopAdmin"] = v; SaveSettings()
end)
SettingsHop:Toggle("Auto Hop Server", _G.AutoHopServer, function(v)
    _G.AutoHopServer = v; _G.SaveData["AutoHopServer"] = v; SaveSettings()
end)
SettingsHop:Slider("Hop Delay (Minutes)", 5, 120, _G.HopDelay, function(v)
    _G.HopDelay = v; _G.SaveData["HopDelay"] = v; SaveSettings()
end)
SettingsHop:Button("Hop Now", Hop)

-- Auto Hop Admin loop
task.spawn(function()
    while task.wait(3) do
        if _G.AutoHopAdmin then
            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= plr and table.find(AdminNames, p.Name) then Hop(); break end
                end
            end)
        end
    end
end)

-- Auto Hop Timer loop
task.spawn(function()
    local lastHop = tick()
    while task.wait(1) do
        if _G.AutoHopServer then
            if tick() - lastHop >= (_G.HopDelay * 60) then
                lastHop = tick()
                Hop()
            end
        end
    end
end)

-- Auto Skills loops (Haki, V3, V4) - already present from earlier parts but ensure they respect settings
task.spawn(function() while task.wait(1) do if _G.AutoHaki then pcall(function() if plr.Character and not plr.Character:FindFirstChild("HasBuso") then commF:InvokeServer("Buso") end end) end end end)
task.spawn(function() while task.wait(30) do if _G.AutoV3 then pcall(function() commE:FireServer("ActivateAbility") end) end end end)
task.spawn(function() while task.wait(0.2) do if _G.AutoV4 then pcall(function() local e=plr.Character and plr.Character:FindFirstChild("RaceEnergy"); if e and e.Value==1 then VirtualInputManager:SendKeyEvent(true,"Y",false,game); VirtualInputManager:SendKeyEvent(false,"Y",false,game) end end) end end end)

print("Part 4 Loaded: Settings Tab")

--[[
    KuKi Hub | Ture V2 - Part 5
    Fishing Tab - Auto Fishing, Rod/Bait Selection, Quest, Sell
]]

-- ========================================
-- FISHING TAB PAGES
-- ========================================
local FishMain = Tab5:CraftPage(1)      -- Main Fishing
local FishSettings = Tab5:CraftPage(2)  -- Fishing Settings

-- ========================================
-- GLOBAL FISHING VARIABLES
-- ========================================
_G.SelectedRod = GetSetting("Fish_SelectedRod", "Fishing Rod")
_G.SelectedBait = GetSetting("Fish_SelectedBait", "Basic Bait")
_G.AutoBuyBait = GetSetting("Fish_AutoBuyBait", false)
_G.AutoFishing = GetSetting("Fish_AutoFishing", false)
_G.AutoFishingQuest = GetSetting("Fish_AutoQuest", false)
_G.AutoQuestComplete = GetSetting("Fish_AutoComplete", false)
_G.AutoSellFish = GetSetting("Fish_AutoSell", false)
_G.AutoSkillZ = GetSetting("Fish_AutoSkillZ", false)

-- Fishing Constants
local RodOptions = {"Fishing Rod", "Gold Rod", "Shark Rod", "Shell Rod", "Treasure Rod"}
local BaitOptions = {"Basic Bait", "Kelp Bait", "Good Bait", "Abyssal Bait", "Frozen Bait", "Epic Bait", "Carnivore Bait"}

-- Remote references
local FishReplicated = ReplicatedStorage:FindFirstChild("FishReplicated")
local FishingRequest = FishReplicated and FishReplicated:FindFirstChild("FishingRequest")
local FishingClientConfig = FishReplicated and require(FishReplicated:WaitForChild("FishingClient"):WaitForChild("Config"))
local GetWaterHeight = require(ReplicatedStorage:WaitForChild("Util"):WaitForChild("GetWaterHeightAtLocation"))
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local CraftRemote = Net:WaitForChild("RF/Craft")
local JobsRemote = Net:WaitForChild("RF/JobsRemoteFunction")
local ToolAbilities = Net:WaitForChild("RF/JobToolAbilities")

-- ========================================
-- HELPER FUNCTIONS
-- ========================================
local function HasQuest()
    local pg = plr:FindFirstChild("PlayerGui")
    if pg then
        local qg = pg:FindFirstChild("Quest") or pg:FindFirstChild("QuestGui")
        return qg and qg:FindFirstChild("Container") and qg.Container:FindFirstChild("QuestTitle") ~= nil
    end
    return false
end

-- ========================================
-- FISH MAIN PAGE
-- ========================================
FishMain:Seperator("Fishing Controls")

FishMain:Dropdown("Select Fishing Rod", RodOptions, _G.SelectedRod, function(v)
    _G.SelectedRod = v; _G.SaveData["Fish_SelectedRod"] = v; SaveSettings()
end)

FishMain:Dropdown("Select Bait", BaitOptions, _G.SelectedBait, function(v)
    _G.SelectedBait = v; _G.SaveData["Fish_SelectedBait"] = v; SaveSettings()
    if _G.AutoBuyBait then pcall(function() CraftRemote:InvokeServer("Craft", _G.SelectedBait, {}) end) end
end)

FishMain:Toggle("Auto Buy Bait", _G.AutoBuyBait, function(v)
    _G.AutoBuyBait = v; _G.SaveData["Fish_AutoBuyBait"] = v; SaveSettings()
    if v then pcall(function() CraftRemote:InvokeServer("Craft", _G.SelectedBait, {}) end) end
end)

FishMain:Toggle("Auto Fishing", _G.AutoFishing, function(v)
    _G.AutoFishing = v; _G.SaveData["Fish_AutoFishing"] = v; SaveSettings()
end)

FishMain:Toggle("Auto Quest Fishing", _G.AutoFishingQuest, function(v)
    _G.AutoFishingQuest = v; _G.SaveData["Fish_AutoQuest"] = v; SaveSettings()
end)

FishMain:Toggle("Auto Complete Quest", _G.AutoQuestComplete, function(v)
    _G.AutoQuestComplete = v; _G.SaveData["Fish_AutoComplete"] = v; SaveSettings()
    if v then pcall(function() JobsRemote:InvokeServer("FishingNPC", "FinishQuest") end) end
end)

FishMain:Toggle("Auto Sell Fish", _G.AutoSellFish, function(v)
    _G.AutoSellFish = v; _G.SaveData["Fish_AutoSell"] = v; SaveSettings()
    if v then pcall(function() JobsRemote:InvokeServer("FishingNPC", "SellFish") end) end
end)

FishMain:Toggle("Auto use rod skill", _G.AutoSkillZ, function(v)
    _G.AutoSkillZ = v; _G.SaveData["Fish_AutoSkillZ"] = v; SaveSettings()
end)

FishMain:Seperator("Status")
local fishStatusLabel = FishMain:Label("Inactive")

-- ========================================
-- FISH SETTINGS PAGE
-- ========================================
FishSettings:Seperator("Fishing Configuration")
FishSettings:Label("Rod & Bait settings are on Main page")
FishSettings:Button("Force Cast Line", function()
    pcall(function()
        local char = plr.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and tool:GetAttribute("State") == "ReeledIn" then
                FishingRequest:InvokeServer("StartCasting")
                task.wait()
                local hrp = char.HumanoidRootPart
                local waterHeight = GetWaterHeight(hrp.Position)
                local targetPos = hrp.Position + hrp.CFrame.LookVector * 100
                FishingRequest:InvokeServer("CastLineAtLocation", Vector3.new(targetPos.X, waterHeight, targetPos.Z), 100, true)
            end
        end
    end)
end)

-- ========================================
-- FISHING LOGIC LOOPS
-- ========================================

-- Auto Buy Bait loop
task.spawn(function()
    while task.wait(2) do
        if _G.AutoBuyBait and _G.SelectedBait then
            pcall(function() CraftRemote:InvokeServer("Craft", _G.SelectedBait, {}) end)
        end
    end
end)

-- Auto Fishing loop (Cast/Catch)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoFishing then
            pcall(function()
                local char = plr.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local tool = char:FindFirstChildOfClass("Tool")
                
                -- Equip rod if needed
                if _G.SelectedRod and (not tool or tool.Name ~= _G.SelectedRod) then
                    local rod = plr.Backpack:FindFirstChild(_G.SelectedRod)
                    if rod then
                        char.Humanoid:EquipTool(rod)
                        tool = rod
                    else
                        fishStatusLabel:Set("No " .. _G.SelectedRod .. " in inventory")
                        return
                    end
                end
                
                if tool then
                    local state = tool:GetAttribute("State") or tool:GetAttribute("ServerState")
                    if state == "ReeledIn" then
                        FishingRequest:InvokeServer("StartCasting")
                        task.wait(0.1)
                        local waterHeight = GetWaterHeight(hrp.Position)
                        local castDir = hrp.CFrame.LookVector * 100
                        local targetPos = Vector3.new(hrp.Position.X + castDir.X, waterHeight, hrp.Position.Z + castDir.Z)
                        FishingRequest:InvokeServer("CastLineAtLocation", targetPos, 100, true)
                        fishStatusLabel:Set("Casting...")
                    elseif state == "Biting" then
                        FishingRequest:InvokeServer("Catching", true)
                        task.wait(0.1)
                        FishingRequest:InvokeServer("Catch", 1)
                        fishStatusLabel:Set("Caught!")
                    else
                        fishStatusLabel:Set("State: " .. tostring(state))
                    end
                end
            end)
        else
            fishStatusLabel:Set("Disabled")
        end
    end
end)

-- Auto Quest Fishing loop
task.spawn(function()
    while task.wait(1) do
        if _G.AutoFishingQuest then
            pcall(function()
                if not HasQuest() then
                    JobsRemote:InvokeServer("FishingNPC", "Angler", "AskQuest")
                end
            end)
        end
    end
end)

-- Auto Complete Quest loop
task.spawn(function()
    while task.wait(5) do
        if _G.AutoQuestComplete then
            pcall(function() JobsRemote:InvokeServer("FishingNPC", "FinishQuest") end)
        end
    end
end)

-- Auto Sell Fish loop
task.spawn(function()
    while task.wait(5) do
        if _G.AutoSellFish then
            pcall(function() JobsRemote:InvokeServer("FishingNPC", "SellFish") end)
        end
    end
end)

-- Auto Skill Z loop
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSkillZ then
            pcall(function() ToolAbilities:InvokeServer("Z", true) end)
        end
    end
end)

print("Part 5 Loaded: Fishing Tab")

--[[
    KuKi Hub | Ture V2 - Part 6
    Sea Event Tab - Boat Controls, Sea Beasts, Kitsune, Frozen Dimension
]]

-- ========================================
-- SEA EVENT TAB PAGES
-- ========================================
local SeaMain = Tab6:CraftPage(1)       -- Main Sea Events
local SeaBoat = Tab6:CraftPage(2)       -- Boat Settings
local SeaKitsune = Tab6:CraftPage(3)    -- Kitsune Island
local SeaFrozen = Tab6:CraftPage(4)     -- Frozen Dimension

-- ========================================
-- GLOBAL SEA EVENT VARIABLES
-- ========================================
_G.SailBoats = GetSetting("SailBoats", false)
_G.SeaBeast1 = GetSetting("SeaBeast1", false)
_G.PGB = GetSetting("PGB", false)
_G.Shark = GetSetting("Shark", false)
_G.Piranha = GetSetting("Piranha", false)
_G.TerrorShark = GetSetting("TerrorShark", false)
_G.MobCrew = GetSetting("MobCrew", false)
_G.HCM = GetSetting("HCM", false)
_G.FishBoat = GetSetting("FishBoat", false)
_G.Leviathan1 = GetSetting("Leviathan1", false)

_G.AutoPressW = GetSetting("AutoPressW", false)
_G.NoClipShip = GetSetting("NoClipShip", false)
_G.SpeedBoat = GetSetting("SpeedBoat", false)
_G.SetSpeedBoat = GetSetting("SetSpeedBoat", 300)

_G.AutofindKitIs = GetSetting("AutofindKitIs", false)
_G.tweenShrine = GetSetting("tweenShrine", false)
_G.Collect_Ember = GetSetting("Collect_Ember", false)
_G.Trade_Ember = GetSetting("Trade_Ember", false)

_G.FrozenTP = GetSetting("FrozenTP", false)

_G.SelectedBoat = GetSetting("SelectedBoat", "Guardian")
_G.DangerSc = GetSetting("DangerSc", "Lv 1")

local BoatList = {"Guardian","PirateGrandBrigade","MarineGrandBrigade","PirateBrigade","MarineBrigade","PirateSloop","MarineSloop","Beast Hunter"}
local DangerLevels = {"Lv 1", "Lv 2", "Lv 3", "Lv 4", "Lv 5", "Lv 6", "Lv Infinite"}

-- ========================================
-- HELPER FUNCTIONS
-- ========================================
function CheckSeaBeast() return Workspace.SeaBeasts:FindFirstChild("SeaBeast1") ~= nil end
function CheckLeviathan() return Workspace.SeaBeasts:FindFirstChild("Leviathan") ~= nil end

-- ========================================
-- SEA MAIN PAGE
-- ========================================
SeaMain:Seperator("Sea Event Settings")

SeaMain:Toggle("Auto Start Sail", _G.SailBoats, function(v)
    _G.SailBoats = v; _G.SaveData["SailBoats"] = v; SaveSettings()
end)

SeaMain:Seperator("Select Targets")

SeaMain:Toggle("Auto Attack Sea Beast", _G.SeaBeast1, function(v)
    _G.SeaBeast1 = v; _G.SaveData["SeaBeast1"] = v; SaveSettings()
end)

SeaMain:Toggle("Auto Attack Pirate GrandBrigade", _G.PGB, function(v)
    _G.PGB = v; _G.SaveData["PGB"] = v; SaveSettings()
end)

if World3 then
    SeaMain:Toggle("Auto Shark", _G.Shark, function(v) _G.Shark = v; SaveSettings() end)
    SeaMain:Toggle("Auto Piranha", _G.Piranha, function(v) _G.Piranha = v; SaveSettings() end)
    SeaMain:Toggle("Auto Terror Shark", _G.TerrorShark, function(v) _G.TerrorShark = v; SaveSettings() end)
    SeaMain:Toggle("Auto Fish Crew Member", _G.MobCrew, function(v) _G.MobCrew = v; SaveSettings() end)
    SeaMain:Toggle("Auto Haunted Crew Member", _G.HCM, function(v) _G.HCM = v; SaveSettings() end)
    SeaMain:Toggle("Auto Attack Fish Boat", _G.FishBoat, function(v) _G.FishBoat = v; SaveSettings() end)
end

if World1 then SeaMain:Label("Go to Sea 3 or Sea 2 for more options") end
if World2 then SeaMain:Label("Go to Sea 3 for more options") end

SeaMain:Seperator("Quick Actions")
SeaMain:Button("Remove Lighting Effect", function()
    pcall(function()
        if Lighting:FindFirstChild("LightingLayers") then Lighting.LightingLayers:Destroy() end
        if Lighting:FindFirstChild("SeaTerrorCC") then Lighting.SeaTerrorCC:Destroy() end
        if Lighting:FindFirstChild("FantasySky") then Lighting.FantasySky:Destroy() end
        Lighting.GlobalShadows = false; Lighting.FogEnd = 9e9; Lighting.Brightness = 2
    end)
end)

-- ========================================
-- SEA BOAT PAGE
-- ========================================
SeaBoat:Seperator("Boat Selection")
SeaBoat:Dropdown("Select Boat", BoatList, _G.SelectedBoat, function(v)
    _G.SelectedBoat = v; _G.SaveData["SelectedBoat"] = v; SaveSettings()
end)
if World3 then
    SeaBoat:Dropdown("Select Danger Level", DangerLevels, _G.DangerSc, function(v)
        _G.DangerSc = v; _G.SaveData["DangerSc"] = v; SaveSettings()
    end)
end
SeaBoat:Button("Buy Selected Boat", function()
    local pos = CFrame.new(-16927.451, 9.086, 433.864)
    if GetHRP() and (GetHRP().Position - pos.Position).Magnitude > 10 then _tp(pos); task.wait(1) end
    commF:InvokeServer("BuyBoat", _G.SelectedBoat)
end)

SeaBoat:Seperator("Boat Controls")
SeaBoat:Toggle("Auto Press W (Auto Drive)", _G.AutoPressW, function(v)
    _G.AutoPressW = v; _G.SaveData["AutoPressW"] = v; SaveSettings()
end)
SeaBoat:Toggle("No Clip Ship", _G.NoClipShip, function(v)
    _G.NoClipShip = v; _G.SaveData["NoClipShip"] = v; SaveSettings()
end)
SeaBoat:Toggle("Activate Boat Speed", _G.SpeedBoat, function(v)
    _G.SpeedBoat = v; _G.SaveData["SpeedBoat"] = v; SaveSettings()
end)
SeaBoat:Textbox("Boat Speed Value", tostring(_G.SetSpeedBoat), function(v)
    local n = tonumber(v); if n then _G.SetSpeedBoat = n; _G.SaveData["SetSpeedBoat"] = n; SaveSettings() end
end)

-- ========================================
-- SEA KITSUNE PAGE (World3 Only)
-- ========================================
if World3 then
    SeaKitsune:Seperator("Kitsune Island")
    SeaKitsune:Toggle("Auto Find Kitsune Island", _G.AutofindKitIs, function(v)
        _G.AutofindKitIs = v; SaveSettings()
    end)
    SeaKitsune:Toggle("Auto Teleport to Shrine Actived", _G.tweenShrine, function(v)
        _G.tweenShrine = v; SaveSettings()
    end)
    SeaKitsune:Toggle("Auto Collect Azure Ember", _G.Collect_Ember, function(v)
        _G.Collect_Ember = v; SaveSettings()
    end)
    SeaKitsune:Toggle("Auto Trade Azure Ember", _G.Trade_Ember, function(v)
        _G.Trade_Ember = v; SaveSettings()
    end)
    SeaKitsune:Button("Trade Items Azure", function()
        ReplicatedStorage.Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()
    end)
    SeaKitsune:Button("Talk with Kitsune Statue", function()
        ReplicatedStorage.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()
    end)
end

-- ========================================
-- SEA FROZEN PAGE (World3 Only)
-- ========================================
if World3 then
    SeaFrozen:Seperator("Frozen Dimension")
    SeaFrozen:Button("Buy Spy", function() commF:InvokeServer("InfoLeviathan", "2") end)
    SeaFrozen:Toggle("Teleport Frozen Dimension", _G.FrozenTP, function(v)
        _G.FrozenTP = v; SaveSettings()
    end)
    SeaFrozen:Toggle("Auto Attack Leviathan", _G.Leviathan1, function(v)
        _G.Leviathan1 = v; SaveSettings()
    end)
end

-- ========================================
-- SEA EVENT LOGIC LOOPS
-- ========================================
-- Auto Press W
task.spawn(function()
    while task.wait() do
        if _G.AutoPressW and plr.Character and plr.Character.Humanoid.Sit then
            VirtualInputManager:SendKeyEvent(true, "W", false, game)
        end
    end
end)

-- No Clip Ship
task.spawn(function()
    while task.wait() do
        for _, boat in pairs(Workspace.Boats:GetChildren()) do
            for _, part in pairs(boat:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not (_G.NoClipShip or _G.SailBoats or _G.AutofindKitIs)
                end
            end
        end
    end
end)

-- Boat Speed
task.spawn(function()
    RunService.RenderStepped:Connect(function()
        if _G.SpeedBoat and plr.Character and plr.Character.Humanoid.Sit then
            for _, boat in pairs(Workspace.Boats:GetChildren()) do
                local seat = boat:FindFirstChildWhichIsA("VehicleSeat")
                if seat then seat.MaxSpeed = _G.SetSpeedBoat; seat.Torque = 0.2; seat.TurnSpeed = 5 end
            end
        end
    end)
end)

-- Main Sea Farm Loop
task.spawn(function()
    while task.wait(1) do
        if _G.SailBoats then
            pcall(function()
                local target = nil
                if _G.Leviathan1 then target = Workspace.SeaBeasts:FindFirstChild("Leviathan")
                elseif _G.SeaBeast1 then target = Workspace.SeaBeasts:FindFirstChild("SeaBeast1")
                elseif _G.TerrorShark then target = Workspace.Enemies:FindFirstChild("Terrorshark")
                elseif _G.Shark then target = Workspace.Enemies:FindFirstChild("Shark")
                elseif _G.Piranha then target = Workspace.Enemies:FindFirstChild("Piranha")
                elseif _G.PGB then target = Workspace.Enemies:FindFirstChild("PirateGrandBrigade") or Workspace.Enemies:FindFirstChild("PirateBrigade")
                elseif _G.MobCrew then target = Workspace.Enemies:FindFirstChild("Fish Crew Member")
                elseif _G.HCM then target = Workspace.Enemies:FindFirstChild("Haunted Crew Member")
                elseif _G.FishBoat then target = Workspace.Enemies:FindFirstChild("FishBoat")
                end
                if target and G_Alive(target) then
                    local hrp = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
                    if hrp then _tp(hrp.CFrame * CFrame.new(0, _G.MobHeight, 0)); G_Kill(target, true) end
                else
                    _tp(CFrame.new(-10000000, 31, 37016.25))
                end
            end)
        end
    end
end)

-- Find Kitsune (World3)
if World3 then
    task.spawn(function()
        while task.wait() do
            if _G.AutofindKitIs and not Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island", true) then
                pcall(function()
                    local boat = CheckBoat()
                    if not boat then
                        local pos = CFrame.new(-16927.451, 9.086, 433.864)
                        _tp(pos); if (pos.Position - GetHRP().Position).Magnitude <= 10 then commF:InvokeServer("BuyBoat", _G.SelectedBoat) end
                    else
                        if not plr.Character.Humanoid.Sit then _tp(boat.VehicleSeat.CFrame * CFrame.new(0,1,0))
                        else _tp(CFrame.new(-10000000, CheckEnemiesBoat() and 150 or 31, 37016.25)) end
                    end
                end)
            end
        end
    end)
end

print("Part 6 Loaded: Sea Event Tab")

--[[
    KuKi Hub | Ture V2 - Part 7
    Volcano/Dojo Tab - Prehistoric Island, Drago Trials, Dojo Quests
]]

-- ========================================
-- VOLCANO TAB PAGES
-- ========================================
local VolcanoPre = Tab7:CraftPage(1)      -- Prehistoric Island
local VolcanoCraft = Tab7:CraftPage(2)    -- Volcanic Crafting
local VolcanoDrago = Tab7:CraftPage(3)    -- Drago Trials
local VolcanoDojo = Tab7:CraftPage(4)     -- Dojo Quests

-- ========================================
-- GLOBAL VOLCANO VARIABLES
-- ========================================
_G.Prehis_Find = GetSetting("Prehis_Find", false)
_G.AutoStartPrehistoric = GetSetting("AutoStartPrehistoric", false)
_G.Prehis_Skills = GetSetting("Prehis_Skills", false)
_G.Prehis_KillGolem = GetSetting("Prehis_KillGolem", false)
_G.Prehis_DB = GetSetting("Prehis_DB", false)
_G.Prehis_DE = GetSetting("Prehis_DE", false)
_G.KillAura = GetSetting("KillAura", false)

_G.AutoCraftVolcanic = GetSetting("AutoCraftVolcanic", false)
_G.UPGDrago = GetSetting("UPGDrago", false)
_G.DragoV1 = GetSetting("DragoV1", false)
_G.AutoFireFlowers = GetSetting("AutoFireFlowers", false)
_G.DragoV3 = GetSetting("DragoV3", false)
_G.Relic123 = GetSetting("Relic123", false)
_G.TrainDrago = GetSetting("TrainDrago", false)
_G.TpDrago_Prehis = GetSetting("TpDrago_Prehis", false)
_G.BuyDrago = GetSetting("BuyDrago", false)
_G.DT_Uzoth = GetSetting("DT_Uzoth", false)

_G.Dojoo = GetSetting("Dojoo", false)
_G.FarmBlazeEM = GetSetting("FarmBlazeEM", false)

-- Prehistoric Skills
_G.PrehistoricSkills = _G.PrehistoricSkills or {
    Melee = {Z = true, X = true, C = true},
    Sword = {Z = true, X = true},
    ["Blox Fruit"] = {Z = true, X = true, C = true, V = false, F = false},
    Gun = {Z = true, X = true}
}
if _G.SaveData and _G.SaveData.PrehistoricSkills then _G.PrehistoricSkills = _G.SaveData.PrehistoricSkills end

local KillAuraCounter = 0

-- ========================================
-- HELPER FUNCTIONS
-- ========================================
function UsePrehistoricSkills()
    if _G.PrehistoricSkills.Melee.Z then Useskills("Melee", "Z") end
    if _G.PrehistoricSkills.Melee.X then Useskills("Melee", "X") end
    if _G.PrehistoricSkills.Melee.C then Useskills("Melee", "C") end
    task.wait(0.2)
    if _G.PrehistoricSkills.Sword.Z then Useskills("Sword", "Z") end
    if _G.PrehistoricSkills.Sword.X then Useskills("Sword", "X") end
    task.wait(0.2)
    if _G.PrehistoricSkills["Blox Fruit"].Z then Useskills("Blox Fruit", "Z") end
    if _G.PrehistoricSkills["Blox Fruit"].X then Useskills("Blox Fruit", "X") end
    if _G.PrehistoricSkills["Blox Fruit"].C then Useskills("Blox Fruit", "C") end
    if _G.PrehistoricSkills["Blox Fruit"].V then Useskills("Blox Fruit", "V") end
    if _G.PrehistoricSkills["Blox Fruit"].F then
        VirtualInputManager:SendKeyEvent(true, "F", false, game)
        VirtualInputManager:SendKeyEvent(false, "F", false, game)
    end
    task.wait(0.2)
    if _G.PrehistoricSkills.Gun.Z then Useskills("Gun", "Z") end
    if _G.PrehistoricSkills.Gun.X then Useskills("Gun", "X") end
end

function Useskills(toolType, key)
    weaponSc(toolType)
    if key == "Z" then VirtualInputManager:SendKeyEvent(true, "Z", false, game); VirtualInputManager:SendKeyEvent(false, "Z", false, game)
    elseif key == "X" then VirtualInputManager:SendKeyEvent(true, "X", false, game); VirtualInputManager:SendKeyEvent(false, "X", false, game)
    elseif key == "C" then VirtualInputManager:SendKeyEvent(true, "C", false, game); VirtualInputManager:SendKeyEvent(false, "C", false, game)
    elseif key == "V" then VirtualInputManager:SendKeyEvent(true, "V", false, game); VirtualInputManager:SendKeyEvent(false, "V", false, game)
    end
end

-- ========================================
-- VOLCANO PREHISTORIC PAGE
-- ========================================
VolcanoPre:Seperator("Prehistoric Island")
local prehistoricStatus = VolcanoPre:Label("Checking...")
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local has = Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island")
            prehistoricStatus:Set(has and "✅ Active" or "❌ Not Found")
        end)
    end
end)

VolcanoPre:Toggle("Auto Find Prehistoric Island", _G.Prehis_Find, function(v) _G.Prehis_Find = v; SaveSettings() end)
VolcanoPre:Toggle("Auto Start Prehistoric Event", _G.AutoStartPrehistoric, function(v) _G.AutoStartPrehistoric = v; SaveSettings() end)
VolcanoPre:Toggle("Auto Patch (Remove Lava)", _G.Prehis_Skills, function(v) _G.Prehis_Skills = v; SaveSettings() end)
VolcanoPre:Toggle("Auto Kill Lava Golem", _G.Prehis_KillGolem, function(v) _G.Prehis_KillGolem = v; SaveSettings() end)
VolcanoPre:Toggle("Auto Collect Dino Bones", _G.Prehis_DB, function(v) _G.Prehis_DB = v; SaveSettings() end)
VolcanoPre:Toggle("Auto Collect Dragon Eggs", _G.Prehis_DE, function(v) _G.Prehis_DE = v; SaveSettings() end)

VolcanoPre:Seperator("Kill Aura")
local killAuraLabel = VolcanoPre:Label("Killed: 0")
task.spawn(function() while task.wait(1) do killAuraLabel:Set("Killed: " .. KillAuraCounter .. (_G.KillAura and " | Active" or " | Disabled")) end end)
VolcanoPre:Toggle("Kill Aura", _G.KillAura, function(v) _G.KillAura = v; SaveSettings() end)
VolcanoPre:Button("Reset Kill Counter", function() KillAuraCounter = 0 end)

VolcanoPre:Seperator("Skill Selection")
VolcanoPre:Toggle("Pre - Melee Z", _G.PrehistoricSkills.Melee.Z, function(v) _G.PrehistoricSkills.Melee.Z = v; SaveSettings() end)
VolcanoPre:Toggle("Pre - Melee X", _G.PrehistoricSkills.Melee.X, function(v) _G.PrehistoricSkills.Melee.X = v; SaveSettings() end)
VolcanoPre:Toggle("Pre - Melee C", _G.PrehistoricSkills.Melee.C, function(v) _G.PrehistoricSkills.Melee.C = v; SaveSettings() end)
VolcanoPre:Toggle("Pre - Sword Z", _G.PrehistoricSkills.Sword.Z, function(v) _G.PrehistoricSkills.Sword.Z = v; SaveSettings() end)
VolcanoPre:Toggle("Pre - Sword X", _G.PrehistoricSkills.Sword.X, function(v) _G.PrehistoricSkills.Sword.X = v; SaveSettings() end)
VolcanoPre:Toggle("Pre - Fruit Z", _G.PrehistoricSkills["Blox Fruit"].Z, function(v) _G.PrehistoricSkills["Blox Fruit"].Z = v; SaveSettings() end)
VolcanoPre:Toggle("Pre - Fruit X", _G.PrehistoricSkills["Blox Fruit"].X, function(v) _G.PrehistoricSkills["Blox Fruit"].X = v; SaveSettings() end)
VolcanoPre:Toggle("Pre - Fruit C", _G.PrehistoricSkills["Blox Fruit"].C, function(v) _G.PrehistoricSkills["Blox Fruit"].C = v; SaveSettings() end)
VolcanoPre:Toggle("Pre - Fruit V", _G.PrehistoricSkills["Blox Fruit"].V, function(v) _G.PrehistoricSkills["Blox Fruit"].V = v; SaveSettings() end)
VolcanoPre:Toggle("Pre - Fruit F", _G.PrehistoricSkills["Blox Fruit"].F, function(v) _G.PrehistoricSkills["Blox Fruit"].F = v; SaveSettings() end)
VolcanoPre:Toggle("Pre - Gun Z", _G.PrehistoricSkills.Gun.Z, function(v) _G.PrehistoricSkills.Gun.Z = v; SaveSettings() end)
VolcanoPre:Toggle("Pre - Gun X", _G.PrehistoricSkills.Gun.X, function(v) _G.PrehistoricSkills.Gun.X = v; SaveSettings() end)

-- ========================================
-- VOLCANO CRAFT PAGE
-- ========================================
VolcanoCraft:Seperator("Volcanic Crafting")
VolcanoCraft:Button("Craft Volcanic Magnet (Manual)", function()
    pcall(function() ReplicatedStorage.Modules.Net["RF/Craft"]:InvokeServer("PossibleHardcode", "Volcanic Magnet") end)
end)
VolcanoCraft:Toggle("Auto Craft Volcanic Magnet", _G.AutoCraftVolcanic, function(v) _G.AutoCraftVolcanic = v; SaveSettings() end)
task.spawn(function() while task.wait(30) do if _G.AutoCraftVolcanic then pcall(function() ReplicatedStorage.Modules.Net["RF/Craft"]:InvokeServer("PossibleHardcode", "Volcanic Magnet") end) end end end)

-- ========================================
-- VOLCANO DRAGO PAGE
-- ========================================
VolcanoDrago:Seperator("Drago Trials")
VolcanoDrago:Toggle("Tween To Upgrade Drago Trial", _G.UPGDrago, function(v) _G.UPGDrago = v; SaveSettings() end)
VolcanoDrago:Toggle("Auto Drago (V1) - Get Dragon Egg", _G.DragoV1, function(v) _G.DragoV1 = v; SaveSettings() end)
VolcanoDrago:Toggle("Auto Drago (V2) - Fire Flowers", _G.AutoFireFlowers, function(v) _G.AutoFireFlowers = v; SaveSettings() end)
VolcanoDrago:Toggle("Auto Drago (V3) - Terror Shark/Sea Beast", _G.DragoV3, function(v) _G.DragoV3 = v; SaveSettings() end)
VolcanoDrago:Toggle("Auto Relic Drago Trial [Beta]", _G.Relic123, function(v) _G.Relic123 = v; SaveSettings() end)
VolcanoDrago:Toggle("Auto Train Drago v4", _G.TrainDrago, function(v) _G.TrainDrago = v; SaveSettings() end)
VolcanoDrago:Toggle("Tween to Drago Trials (Inside Volcano)", _G.TpDrago_Prehis, function(v) _G.TpDrago_Prehis = v; SaveSettings() end)
VolcanoDrago:Toggle("Swap Drago Race (Buy)", _G.BuyDrago, function(v) _G.BuyDrago = v; SaveSettings() end)
VolcanoDrago:Toggle("Upgrade Dragon Talon With Uzoth", _G.DT_Uzoth, function(v) _G.DT_Uzoth = v; SaveSettings() end)

-- ========================================
-- VOLCANO DOJO PAGE
-- ========================================
VolcanoDojo:Seperator("Dojo Quests")
VolcanoDojo:Button("Teleport To Dragon Dojo", function()
    commF:InvokeServer("requestEntrance", Vector3.new(5661.5322, 1013.0907, -334.9649))
    _tp(CFrame.new(5814.4272, 1208.3267, 884.5785))
end)
VolcanoDojo:Toggle("Auto Dojo Trainer (Complete Quests)", _G.Dojoo, function(v) _G.Dojoo = v; SaveSettings() end)
VolcanoDojo:Toggle("Auto Dragon Hunter (Hydra/Venomous)", _G.FarmBlazeEM, function(v) _G.FarmBlazeEM = v; SaveSettings() end)

-- ========================================
-- LOGIC LOOPS
-- ========================================

-- Find Prehistoric Island
task.spawn(function()
    while task.wait(1) do
        if _G.Prehis_Find then
            pcall(function()
                if not Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island", true) then
                    local boat = CheckBoat()
                    if not boat then _tp(CFrame.new(-16927.451, 9.086, 433.864)); if (GetHRP().Position - Vector3.new(-16927.451, 9.086, 433.864)).Magnitude <= 10 then commF:InvokeServer("BuyBoat", _G.SelectedBoat or "Guardian") end
                    else
                        if not plr.Character.Humanoid.Sit then _tp(boat.VehicleSeat.CFrame * CFrame.new(0,1,0))
                        else _tp(CFrame.new(-10000000, CheckEnemiesBoat() and 150 or 31, 37016.25)) end
                    end
                else
                    local loc = Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island")
                    _tp(loc.CFrame * CFrame.new(0, 200, 0))
                end
            end)
        end
    end
end)

-- Auto Start Event & Patch Lava
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoStartPrehistoric then
            pcall(function()
                local core = Workspace.Map.PrehistoricIsland and Workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt", true)
                if core and core:FindFirstChild("ProximityPrompt") then
                    fireproximityprompt(core.ProximityPrompt)
                end
            end)
        end
        if _G.Prehis_Skills then
            pcall(function()
                for _, obj in pairs(Workspace.Map:GetDescendants()) do
                    if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and string.find(obj.Name:lower(), "lava") then obj:Destroy() end
                end
            end)
        end
    end
end)

-- Kill Lava Golem
task.spawn(function()
    while task.wait(1) do
        if _G.Prehis_KillGolem then
            local golem = GetConnectionEnemies("Lava Golem")
            if golem and G_Alive(golem) then G_Kill(golem, true); UsePrehistoricSkills() end
        end
    end
end)

-- Collect Dino Bones & Dragon Eggs
task.spawn(function()
    while task.wait(0.5) do
        if _G.Prehis_DB then for _, obj in pairs(Workspace:GetChildren()) do if obj.Name == "DinoBone" then _tp(obj.CFrame) end end end
        if _G.Prehis_DE then
            local egg = Workspace.Map.PrehistoricIsland and Workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg")
            if egg and egg:FindFirstChild("Molten") then _tp(egg.Molten.CFrame); fireproximityprompt(egg.Molten.ProximityPrompt) end
        end
    end
end)

-- Kill Aura
task.spawn(function()
    while task.wait(2) do
        if _G.KillAura then
            pcall(function()
                sethiddenproperty(plr, "SimulationRadius", math.huge)
                for _, e in ipairs(Workspace.Enemies:GetChildren()) do
                    if G_Alive(e) and e:FindFirstChild("HumanoidRootPart") and (e.HumanoidRootPart.Position - GetHRP().Position).Magnitude <= 1000 then
                        e.Humanoid.Health = 0; e:BreakJoints(); KillAuraCounter = KillAuraCounter + 1
                    end
                end
            end)
        end
    end
end)

-- Drago Trials Logic
task.spawn(function() while task.wait(1) do if _G.UPGDrago then _tp(CFrame.new(5814.4272, 1208.3267, 884.5785)); ReplicatedStorage.Modules.Net["RF/InteractDragonQuest"]:InvokeServer({NPC="Dragon Wizard", Command="Upgrade"}) end end end)
task.spawn(function() while task.wait(1) do if _G.DragoV1 then _G.Prehis_Find, _G.Prehis_Skills, _G.Prehis_DE = true, true, true; if GetM("Dragon Egg") > 0 then _G.Prehis_Find, _G.Prehis_Skills, _G.Prehis_DE = false, false, false end end end end)
task.spawn(function() while task.wait(1) do if _G.AutoFireFlowers then local f = Workspace:FindFirstChild("FireFlowers"); if f then for _, fl in pairs(f:GetChildren()) do if fl:IsA("Model") then _tp(fl.PrimaryPart.CFrame); VirtualInputManager:SendKeyEvent(true, "E", false, game); task.wait(1.5); VirtualInputManager:SendKeyEvent(false, "E", false, game) end end end end end end)
task.spawn(function() while task.wait(1) do if _G.DragoV3 then _G.DangerSc = "Lv Infinite"; _G.SailBoats, _G.TerrorShark = true, true else _G.DangerSc = "Lv 1"; _G.SailBoats, _G.TerrorShark = false, false end end end)
task.spawn(function() while task.wait(1) do if _G.Relic123 then for _, p in ipairs({CFrame.new(-39934,10685,22999), CFrame.new(-40511,9376,23458)}) do _tp(p); task.wait(2.5) end end end end)
task.spawn(function() while task.wait(1) do if _G.TrainDrago then local e = plr.Character and plr.Character:FindFirstChild("RaceEnergy"); if e and e.Value == 1 then VirtualInputManager:SendKeyEvent(true, "Y", false, game); commF:InvokeServer("UpgradeRace", "Buy", 2) else local m = GetConnectionEnemies({"Venomous Assailant","Hydra Enforcer"}); if m then G_Kill(m, true) else _tp(CFrame.new(4620.61,1002.29,399.08)) end end end end end)
task.spawn(function() while task.wait(0.5) do if _G.TpDrago_Prehis then local t = Workspace.Map.PrehistoricIsland and Workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport"); if t then _tp(t.CFrame) end end end end)
task.spawn(function() while task.wait(1) do if _G.BuyDrago then _tp(CFrame.new(5814.4272,1208.3267,884.5785)); ReplicatedStorage.Modules.Net["RF/InteractDragonQuest"]:InvokeServer({NPC="Dragon Wizard", Command="DragonRace"}) end end end)
task.spawn(function() while task.wait(1) do if _G.DT_Uzoth then _tp(CFrame.new(5661.89,1211.31,864.83)); ReplicatedStorage.Modules.Net["RF/InteractDragonQuest"]:InvokeServer({NPC="Uzoth", Command="Upgrade"}) end end end)

-- Dragon Hunter (Blaze EM)
task.spawn(function()
    while task.wait(1) do
        if _G.FarmBlazeEM then
            pcall(function()
                local res = ReplicatedStorage.Modules.Net["RF/DragonHunter"]:InvokeServer({Context="Check"})
                if res and res.Text then
                    if string.find(res.Text, "Defeat") then
                        local mob = string.find(res.Text, "Hydra") and "Hydra Enforcer" or "Venomous Assailant"
                        local m = GetConnectionEnemies(mob)
                        if m then G_Kill(m, true) else _tp(CFrame.new(4620.61,1002.29,399.08)) end
                    elseif string.find(res.Text, "Destroy") then
                        local b = Workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true)
                        if b then _tp(b.CFrame); UsePrehistoricSkills() end
                    end
                else _tp(CFrame.new(5813,1208,884)) end
            end)
        end
    end
end)

print("Part 7 Loaded: Volcano/Dojo Tab")

--[[
    KuKi Hub | Ture V2 - Part 8
    Mirage/Race Tab - Mirage Island, Race V4, Moon, Race Upgrades
]]

-- ========================================
-- MIRAGE TAB PAGES
-- ========================================
local MirageMain = Tab8:CraftPage(1)      -- Mirage Island
local MirageRace = Tab8:CraftPage(2)      -- Race V4 / Temple
local MirageMoon = Tab8:CraftPage(3)      -- Moon / V3 V4
local MirageUpgrade = Tab8:CraftPage(4)   -- Race Upgrades V2/V3

-- ========================================
-- GLOBAL MIRAGE VARIABLES
-- ========================================
_G.FindMirage = GetSetting("FindMirage", false)
_G.AutoMysticIsland = GetSetting("AutoMysticIsland", false)
_G.HighestMirage = GetSetting("HighestMirage", false)
_G.MirageIslandESP = GetSetting("MirageIslandESP", false)
_G.FarmChestM = GetSetting("FarmChestM", false)
_G.can = GetSetting("can", false)
_G.TPGEAR = GetSetting("TPGEAR", false)
_G.Addealer = GetSetting("Addealer", false)

_G.Lver = GetSetting("Lver", false)
_G.AcientOne = GetSetting("AcientOne", false)
_G.TPDoor = GetSetting("TPDoor", false)
_G.Complete_Trials = GetSetting("Complete_Trials", false)
_G.Defeating = GetSetting("Defeating", false)

_G.LookM = GetSetting("LookM", false)
_G.LookMV3 = GetSetting("LookMV3", false)

_G.Auto_Mink = GetSetting("Auto_Mink", false)
_G.Auto_Human = GetSetting("Auto_Human", false)
_G.Auto_Skypiea = GetSetting("Auto_Skypiea", false)
_G.Auto_Fish = GetSetting("Auto_Fish", false)

-- ========================================
-- HELPER FUNCTIONS
-- ========================================
function GetMoonTexture()
    if World1 or World2 then return Lighting.FantasySky and Lighting.FantasySky.MoonTextureId or ""
    else return Lighting.Sky and Lighting.Sky.MoonTextureId or "" end
end

function MoveCamToMoon()
    local moonDir = Lighting:GetMoonDirection()
    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + moonDir)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, plr.Character.HumanoidRootPart.Position + moonDir)
    end
end

function GetSeaBeastTrial()
    if not Workspace.Map:FindFirstChild("FishmanTrial") then return nil end
    local trialLoc = Workspace._WorldOrigin.Locations:FindFirstChild("Trial of Water")
    if trialLoc then
        for _, beast in pairs(Workspace.SeaBeasts:GetChildren()) do
            if beast:FindFirstChild("HumanoidRootPart") and beast:FindFirstChild("Health") and beast.Health.Value > 0 then
                if (beast.HumanoidRootPart.Position - trialLoc.Position).Magnitude <= 1500 then return beast end
            end
        end
    end
    return nil
end

-- ========================================
-- MIRAGE MAIN PAGE
-- ========================================
MirageMain:Seperator("Mirage Island Status")
local fullMoonStatus = MirageMain:Label("Checking...")
local mirageIslandStatus = MirageMain:Label("Checking...")

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local moonId = GetMoonTexture()
            local phase = "0/8"
            if moonId:find("9709139597") then phase = "1/8"
            elseif moonId:find("9709143733") then phase = "2/8"
            elseif moonId:find("9709149052") then phase = "3/8 [Next]"
            elseif moonId:find("9709149431") then phase = "4/8 🌕"
            elseif moonId:find("9709149680") then phase = "5/8 [Last]"
            elseif moonId:find("9709150086") then phase = "6/8"
            elseif moonId:find("9709150401") then phase = "7/8"
            end
            fullMoonStatus:Set("Moon: " .. phase)
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local has = Workspace.Map:FindFirstChild("MysticIsland") or Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island")
            mirageIslandStatus:Set(has and "✅ Active" or "❌ Not Found")
        end)
    end
end)

MirageMain:Seperator("Mirage Features")
MirageMain:Toggle("Auto Find Mirage Island", _G.FindMirage, function(v) _G.FindMirage = v; SaveSettings() end)
MirageMain:Toggle("Auto Tween To Mirage Island", _G.AutoMysticIsland, function(v) _G.AutoMysticIsland = v; SaveSettings() end)
MirageMain:Toggle("Auto Tween To Highest Point", _G.HighestMirage, function(v) _G.HighestMirage = v; SaveSettings() end)
MirageMain:Toggle("ESP Mirage Island", _G.MirageIslandESP, function(v) _G.MirageIslandESP = v; SaveSettings() end)
MirageMain:Toggle("Auto Collect Mirage Chest", _G.FarmChestM, function(v) _G.FarmChestM = v; SaveSettings() end)
MirageMain:Toggle("Change Transparency (See Mirage)", _G.can, function(v) _G.can = v; SaveSettings() end)
MirageMain:Toggle("Auto Collect Gear", _G.TPGEAR, function(v) _G.TPGEAR = v; SaveSettings() end)
MirageMain:Toggle("Auto Tween Advanced Fruit Dealer", _G.Addealer, function(v) _G.Addealer = v; SaveSettings() end)

-- ========================================
-- MIRAGE RACE PAGE (Race V4 / Temple)
-- ========================================
MirageRace:Seperator("Temple of Time")
MirageRace:Button("Teleport to Temple of Time", function()
    _tp(CFrame.new(28286.35, 14895.30, 102.62))
    if World3 and not Workspace.Map:FindFirstChild("Temple of Time") then
        local stash = ReplicatedStorage:FindFirstChild("MapStash")
        if stash and stash:FindFirstChild("Temple of Time") then stash["Temple of Time"].Parent = Workspace.Map end
    end
end)
MirageRace:Button("Teleport to Ancient One", function()
    _tp(CFrame.new(28286.35, 14895.30, 102.62)); task.wait(2); _tp(CFrame.new(28981.55, 14888.42, -120.24))
end)
MirageRace:Button("Teleport to Ancient Clock", function()
    _tp(CFrame.new(28286.35, 14895.30, 102.62)); task.delay(2, function() _tp(CFrame.new(29549, 15069, -88)) end)
end)
MirageRace:Button("Talk With Stone", function()
    commF:InvokeServer("RaceV4Progress", "Begin"); commF:InvokeServer("RaceV4Progress", "Check")
    commF:InvokeServer("RaceV4Progress", "Teleport"); commF:InvokeServer("RaceV4Progress", "Continue")
end)

local tiersLabel = MirageRace:Label("Tiers V4: 0")
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local c = plr.Data and plr.Data.Race and plr.Data.Race:FindFirstChild("C")
            tiersLabel:Set("Tiers V4: " .. (c and c.Value or 0))
        end)
    end
end)

MirageRace:Seperator("Trials Quest V4")
MirageRace:Toggle("Auto Pull Lever", _G.Lver, function(v) _G.Lver = v; SaveSettings() end)
MirageRace:Toggle("Auto Train V4", _G.AcientOne, function(v) _G.AcientOne = v; SaveSettings() end)
MirageRace:Toggle("Auto Teleport to Race Doors", _G.TPDoor, function(v) _G.TPDoor = v; SaveSettings() end)
MirageRace:Toggle("Auto Complete Trials", _G.Complete_Trials, function(v) _G.Complete_Trials = v; SaveSettings() end)
MirageRace:Toggle("Auto Kill Player After Trial", _G.Defeating, function(v) _G.Defeating = v; SaveSettings() end)

-- ========================================
-- MIRAGE MOON PAGE
-- ========================================
MirageMoon:Seperator("Moon / Race Abilities")
MirageMoon:Toggle("Auto Look At Moon", _G.LookM, function(v) _G.LookM = v; SaveSettings() end)
MirageMoon:Toggle("Look Moon + Auto V3", _G.LookMV3, function(v) _G.LookMV3 = v; SaveSettings() end)

-- ========================================
-- MIRAGE UPGRADE PAGE (Race V2/V3)
-- ========================================
MirageUpgrade:Seperator("Upgrade Races V2 And V3")
MirageUpgrade:Toggle("Auto Upgrade Mink", _G.Auto_Mink, function(v) _G.Auto_Mink = v; SaveSettings() end)
MirageUpgrade:Toggle("Auto Upgrade Human", _G.Auto_Human, function(v) _G.Auto_Human = v; SaveSettings() end)
MirageUpgrade:Toggle("Auto Upgrade Angel", _G.Auto_Skypiea, function(v) _G.Auto_Skypiea = v; SaveSettings() end)
MirageUpgrade:Toggle("Auto Upgrade Fishman", _G.Auto_Fish, function(v) _G.Auto_Fish = v; SaveSettings() end)

-- ========================================
-- LOGIC LOOPS
-- ========================================

-- Find Mirage Island
task.spawn(function()
    while task.wait() do
        if _G.FindMirage then
            pcall(function()
                if not Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island", true) then
                    local boat = CheckBoat()
                    if not boat then
                        _tp(CFrame.new(-16927.451, 9.086, 433.864))
                        if (GetHRP().Position - Vector3.new(-16927.451, 9.086, 433.864)).Magnitude <= 10 then commF:InvokeServer("BuyBoat", _G.SelectedBoat or "Guardian") end
                    else
                        if not plr.Character.Humanoid.Sit then _tp(boat.VehicleSeat.CFrame * CFrame.new(0,1,0))
                        else _tp(CFrame.new(-10000000, CheckEnemiesBoat() and 150 or 31, 37016.25)) end
                    end
                else
                    _tp(Workspace.Map.MysticIsland.Center.CFrame * CFrame.new(0, 300, 0))
                end
            end)
        end
    end
end)

-- Auto Tween to Mirage / Highest Point
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoMysticIsland then
            for _, loc in pairs(Workspace._WorldOrigin.Locations:GetChildren()) do
                if loc.Name == "Mirage Island" then _tp(loc.CFrame * CFrame.new(0, 333, 0)) end
            end
        end
        if _G.HighestMirage and Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island", true) then
            _tp(Workspace.Map.MysticIsland.Center.CFrame * CFrame.new(0, 400, 0))
        end
    end
end)

-- Transparency & Gear & Chest
task.spawn(function()
    while task.wait(0.5) do
        if _G.can then
            local mystic = Workspace.Map:FindFirstChild("MysticIsland")
            if mystic then for _, p in pairs(mystic:GetChildren()) do if p.Name == "Part" then p.Transparency = p.ClassName == "MeshPart" and 0 or 1 end end end
        end
        if _G.TPGEAR then
            local mystic = Workspace.Map:FindFirstChild("MysticIsland")
            if mystic then for _, p in pairs(mystic:GetChildren()) do if p.Name == "Part" and p.ClassName == "MeshPart" then _tp(p.CFrame) end end end
        end
        if _G.FarmChestM then
            local mystic = Workspace.Map:FindFirstChild("MysticIsland")
            if mystic and mystic:FindFirstChild("Chests") then
                local chests = CollectionService:GetTagged("_ChestTagged")
                local nearest, minDist = nil, math.huge
                for _, c in pairs(chests) do
                    if not c:GetAttribute("IsDisabled") then
                        local d = (c:GetPivot().Position - GetHRP().Position).Magnitude
                        if d < minDist then minDist = d; nearest = c end
                    end
                end
                if nearest then _tp(nearest:GetPivot()) end
            end
        end
    end
end)

-- Advanced Fruit Dealer
task.spawn(function()
    while task.wait() do
        if _G.Addealer then
            for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                if npc.Name == "Advanced Fruit Dealer" then _tp(npc.HumanoidRootPart.CFrame) end
            end
        end
    end
end)

-- Race Trials Logic
task.spawn(function()
    while task.wait(0.5) do
        if _G.Lver then
            local temple = Workspace.Map:FindFirstChild("Temple of Time")
            if temple then for _, obj in pairs(temple:GetDescendants()) do if obj.Name == "ProximityPrompt" then fireproximityprompt(obj) end end end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.AcientOne then
            local e = plr.Character and plr.Character:FindFirstChild("RaceEnergy")
            if e and e.Value == 1 then
                VirtualInputManager:SendKeyEvent(true, "Y", false, game); commF:InvokeServer("UpgradeRace", "Buy")
                _tp(CFrame.new(-8987.04, 215.86, 5886.71))
            else
                local mob = GetConnectionEnemies({"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"})
                if mob then G_Kill(mob, true) else _tp(CFrame.new(-9495.68, 453.58, 5977.34)) end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.TPDoor then
            local race = tostring(plr.Data.Race.Value)
            local doors = {Mink=CFrame.new(29020.66,14889.42,-379.26), Fishman=CFrame.new(28224.05,14889.42,-210.58), Cyborg=CFrame.new(28492.41,14894.42,-422.11), Skypiea=CFrame.new(28967.40,14918.07,234.31), Ghoul=CFrame.new(28672.72,14889.12,454.59), Human=CFrame.new(29237.29,14889.42,-206.94)}
            if doors[race] then _tp(doors[race]) end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.Complete_Trials then
            local race = tostring(plr.Data.Race.Value)
            if race == "Mink" then notween(Workspace.Map.MinkTrial.Ceiling.CFrame * CFrame.new(0, -20, 0))
            elseif race == "Fishman" then
                local beast = GetSeaBeastTrial()
                if beast then _tp(CFrame.new(beast.HumanoidRootPart.Position.X, Workspace.Map["WaterBase-Plane"].Position.Y + 300, beast.HumanoidRootPart.Position.Z)); UsePrehistoricSkills() end
            elseif race == "Cyborg" then _tp(Workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0, 500, 0))
            elseif race == "Skypiea" then notween(Workspace.Map.SkyTrial.Model.FinishPart.CFrame)
            elseif race == "Human" or race == "Ghoul" then
                local mob = GetConnectionEnemies({"Ancient Vampire","Ancient Zombie"})
                if mob then G_Kill(mob, true) end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.Defeating then
            for _, p in pairs(Workspace.Characters:GetChildren()) do
                if p.Name ~= plr.Name and p:FindFirstChild("Humanoid") and p.Humanoid.Health > 0 then
                    _tp(p.HumanoidRootPart.CFrame * CFrame.new(0, 0, 15))
                    sethiddenproperty(plr, "SimulationRadius", math.huge)
                end
            end
        end
    end
end)

-- Moon Logic
task.spawn(function()
    while task.wait(0.1) do
        if _G.LookM then MoveCamToMoon(); commE:FireServer("ActivateAbility") end
        if _G.LookMV3 then MoveCamToMoon(); commE:FireServer("ActivateAbility"); VirtualInputManager:SendKeyEvent(true, "T", false, game); task.wait(0.5); VirtualInputManager:SendKeyEvent(false, "T", false, game) end
    end
end)

-- Race Upgrade Logic
local function handleAlchemist(autoFlag)
    local alch = commF:InvokeServer("Alchemist", "1")
    if alch ~= 2 then
        if alch == 0 then commF:InvokeServer("Alchemist", "2")
        elseif alch == 1 then
            if not GetBP("Flower 1") then _tp(Workspace.Flower1.CFrame)
            elseif not GetBP("Flower 2") then _tp(Workspace.Flower2.CFrame)
            elseif not GetBP("Flower 3") then
                local mob = GetConnectionEnemies("Swan Pirate")
                if mob then G_Kill(mob, true) else _tp(CFrame.new(980.09, 121.33, 1287.20)) end
            end
        elseif alch == 2 then commF:InvokeServer("Alchemist", "3") end
    elseif commF:InvokeServer("Wenlocktoad", "1") == 0 then commF:InvokeServer("Wenlocktoad", "2")
    elseif commF:InvokeServer("Wenlocktoad", "1") == 1 then
        if autoFlag == "Mink" then _G.AutoFarmChest = true else _G.AutoFarmChest = false end
        if autoFlag == "Human" then
            for _, b in ipairs({"Fajita","Jeremy","Diamond"}) do
                local boss = GetConnectionEnemies(b)
                if boss then G_Kill(boss, true) end
            end
        elseif autoFlag == "Skypiea" then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and tostring(p.Data.Race.Value) == "Skypiea" then _tp(p.Character.HumanoidRootPart.CFrame) end
            end
        end
    end
end

task.spawn(function() while task.wait(1) do if _G.Auto_Mink then handleAlchemist("Mink") end end end)
task.spawn(function() while task.wait(1) do if _G.Auto_Human then handleAlchemist("Human") end end end)
task.spawn(function() while task.wait(1) do if _G.Auto_Skypiea then handleAlchemist("Skypiea") end end end)
task.spawn(function() while task.wait(1) do if _G.Auto_Fish then handleAlchemist("Fishman") end end end)

print("Part 8 Loaded: Mirage/Race Tab")

--[[
    KuKi Hub | Ture V2 - Part 9
    Fruits/Stock Tab - Fruit Management, Stock Checker, Auto Buy
]]

-- ========================================
-- FRUITS TAB PAGES
-- ========================================
local FruitMain = Tab9:CraftPage(1)       -- Fruit Stock & Functions
local FruitSniper = Tab9:CraftPage(2)     -- Shop Sniper & Checker

-- ========================================
-- GLOBAL FRUIT VARIABLES
-- ========================================
_G.Random_Auto = GetSetting("Random_Auto", false)
_G.DropFruit = GetSetting("DropFruit", false)
_G.StoreF = GetSetting("StoreF", false)
_G.TwFruits = GetSetting("TwFruits", false)
_G.InstanceF = GetSetting("InstanceF", false)

getgenv().AutoBuyFruitSniper = GetSetting("AutoBuyFruitSniper", false)
getgenv().SelectFruit = GetSetting("SelectFruit", "Dough-Dough")
_G.AutoNotifyFruit = GetSetting("AutoNotifyFruit", false)
_G.CheckFruit = "Dough-Dough"

local FruitList = {
    "Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring",
    "Bomb-Bomb", "Smoke-Smoke", "Spike-Spike", "Flame-Flame",
    "Ice-Ice", "Sand-Sand", "Dark-Dark", "Eagle-Eagle",
    "Diamond-Diamond", "Light-Light", "Rubber-Rubber", "Ghost-Ghost",
    "Magma-Magma", "Quake-Quake", "Buddha-Buddha", "Love-Love",
    "Creation-Creation", "Spider-Spider", "Sound-Sound",
    "Phoenix-Phoenix", "Portal-Portal", "Lightning-Lightning",
    "Pain-Pain", "Blizzard-Blizzard", "Gravity-Gravity",
    "T-Rex-T-Rex", "Mammoth-Mammoth", "Dough-Dough",
    "Shadow-Shadow", "Venom-Venom", "Gas-Gas",
    "Control-Control", "Spirit-Spirit", "Leopard-Leopard",
    "Yeti-Yeti", "Kitsune-Kitsune", "Dragon-Dragon"
}

-- ========================================
-- HELPER FUNCTIONS
-- ========================================
local function formatNumber(num)
    local formatted = tostring(num)
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    return formatted
end

function GetFruitStock()
    local result = "Advanced Fruit Stock\n"
    local success, advancedStock = pcall(function() return commF:InvokeServer("GetFruits", true) end)
    if success and advancedStock then
        local hasFruit = false
        for _, fruit in pairs(advancedStock) do
            if fruit.OnSale then
                hasFruit = true
                result = result .. fruit.Name .. " - $" .. formatNumber(fruit.Price) .. "\n"
            end
        end
        if not hasFruit then result = result .. "- No fruit in stock.\n" end
    else
        result = result .. "- Error retrieving data.\n"
    end
    result = result .. "\nNormal Fruit Stock\n"
    local success2, normalStock = pcall(function() return commF:InvokeServer("GetFruits") end)
    if success2 and normalStock then
        local hasFruit = false
        for _, fruit in pairs(normalStock) do
            if fruit.OnSale then
                hasFruit = true
                result = result .. fruit.Name .. " - $" .. formatNumber(fruit.Price) .. "\n"
            end
        end
        if not hasFruit then result = result .. "- No fruit in stock.\n" end
    else
        result = result .. "- Error retrieving data.\n"
    end
    return result
end

function CheckSpecificFruit(fruitName)
    local success, stock = pcall(function() return commF:InvokeServer("GetFruits", true) end)
    if success and stock then
        for _, fruit in pairs(stock) do
            if fruit.Name == fruitName and fruit.OnSale then return true, fruit.Price end
        end
    end
    local success2, normalStock = pcall(function() return commF:InvokeServer("GetFruits") end)
    if success2 and normalStock then
        for _, fruit in pairs(normalStock) do
            if fruit.Name == fruitName and fruit.OnSale then return true, fruit.Price end
        end
    end
    return false, nil
end

function DropFruits()
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        if string.find(tool.Name, "Fruit") then
            EquipWeapon(tool.Name)
            task.wait(0.1)
            if plr.PlayerGui.Main.Dialogue.Visible then plr.PlayerGui.Main.Dialogue.Visible = false end
            tool.EatRemote:InvokeServer("Drop")
        end
    end
    for _, tool in pairs(plr.Character:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name, "Fruit") then
            EquipWeapon(tool.Name)
            task.wait(0.1)
            if plr.PlayerGui.Main.Dialogue.Visible then plr.PlayerGui.Main.Dialogue.Visible = false end
            tool.EatRemote:InvokeServer("Drop")
        end
    end
end

function StoreFruits()
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        local eatRemote = tool:FindFirstChild("EatRemote", true)
        if eatRemote then commF:InvokeServer("StoreFruit", tool:GetAttribute("OriginalName"), tool) end
    end
end

function CollectFruits(enabled)
    if not enabled then return end
    local char = plr.Character
    if not char then return end
    for _, obj in pairs(Workspace:GetChildren()) do
        if string.find(obj.Name, "Fruit") and obj:FindFirstChild("Handle") then
            obj.Handle.CFrame = char.HumanoidRootPart.CFrame
        end
    end
end

-- ========================================
-- FRUIT MAIN PAGE
-- ========================================
FruitMain:Seperator("Fruit Stock")
local stockLabel = FruitMain:Label("Loading...")

task.spawn(function()
    pcall(function() stockLabel:Set(GetFruitStock()) end)
    while task.wait(60) do
        pcall(function() stockLabel:Set(GetFruitStock()) end)
    end
end)

FruitMain:Button("Refresh Stock Now", function()
    pcall(function() stockLabel:Set(GetFruitStock()) end)
end)

FruitMain:Seperator("Auto Functions")
FruitMain:Toggle("Auto Random Fruit", _G.Random_Auto, function(v) _G.Random_Auto = v; SaveSettings() end)
FruitMain:Toggle("Auto Drop Fruit", _G.DropFruit, function(v) _G.DropFruit = v; SaveSettings() end)
FruitMain:Toggle("Auto Store Fruit", _G.StoreF, function(v) _G.StoreF = v; SaveSettings() end)
FruitMain:Toggle("Auto Tween to Fruit", _G.TwFruits, function(v) _G.TwFruits = v; SaveSettings() end)
FruitMain:Toggle("Auto Collect Fruit (Bring)", _G.InstanceF, function(v) _G.InstanceF = v; SaveSettings() end)

FruitMain:Seperator("Manual Actions")
FruitMain:Button("Random Fruit (Once)", function() commF:InvokeServer("Cousin", "Buy") end)
FruitMain:Button("Drop All Fruits", function() DropFruits() end)
FruitMain:Button("Store All Fruits", function() StoreFruits() end)
FruitMain:Button("Bring Nearby Fruits", function() CollectFruits(true); task.wait(0.5); CollectFruits(false) end)

-- ========================================
-- FRUIT SNIPER PAGE
-- ========================================
FruitSniper:Seperator("Shop Sniper")
FruitSniper:Dropdown("Select Fruit to Buy", FruitList, getgenv().SelectFruit, function(v)
    getgenv().SelectFruit = v; _G.SaveData["SelectFruit"] = v; SaveSettings()
end)
FruitSniper:Toggle("Auto Buy Fruit (Shop Sniper)", getgenv().AutoBuyFruitSniper, function(v)
    getgenv().AutoBuyFruitSniper = v; _G.SaveData["AutoBuyFruitSniper"] = v; SaveSettings()
end)
FruitSniper:Button("Buy Selected Fruit (Once)", function()
    if getgenv().SelectFruit then
        commF:InvokeServer("GetFruits")
        commF:InvokeServer("PurchaseRawFruit", getgenv().SelectFruit)
    end
end)

FruitSniper:Seperator("Stock Checker")
FruitSniper:Dropdown("Select Fruit to Check", FruitList, "Dough-Dough", function(v) _G.CheckFruit = v end)
local checkResultLabel = FruitSniper:Label("Select a fruit to check")
FruitSniper:Button("Check Selected Fruit", function()
    if not _G.CheckFruit then checkResultLabel:Set("Select a fruit first"); return end
    local inStock, price = CheckSpecificFruit(_G.CheckFruit)
    if inStock then
        checkResultLabel:Set("✅ " .. _G.CheckFruit .. " in stock!\n$" .. formatNumber(price))
    else
        checkResultLabel:Set("❌ " .. _G.CheckFruit .. " not in stock")
    end
end)
FruitSniper:Toggle("Auto Notify when in Stock", _G.AutoNotifyFruit, function(v) _G.AutoNotifyFruit = v; SaveSettings() end)

-- ========================================
-- LOGIC LOOPS
-- ========================================
task.spawn(function() while task.wait(1) do if _G.Random_Auto then pcall(function() commF:InvokeServer("Cousin", "Buy") end) end end end)
task.spawn(function() while task.wait(5) do if _G.DropFruit then pcall(DropFruits) end end end)
task.spawn(function() while task.wait(5) do if _G.StoreF then pcall(StoreFruits) end end end)
task.spawn(function() while task.wait(1) do if _G.TwFruits then for _, obj in pairs(Workspace:GetChildren()) do if string.find(obj.Name, "Fruit") and obj:FindFirstChild("Handle") then _tp(obj.Handle.CFrame) end end end end end)
task.spawn(function() while task.wait(0.5) do if _G.InstanceF then pcall(function() CollectFruits(true) end) end end end)
task.spawn(function() while task.wait(1) do if getgenv().AutoBuyFruitSniper and getgenv().SelectFruit then pcall(function() commF:InvokeServer("GetFruits"); commF:InvokeServer("PurchaseRawFruit", getgenv().SelectFruit) end) end end end)
task.spawn(function()
    while task.wait(30) do
        if _G.AutoNotifyFruit and _G.CheckFruit then
            local inStock, price = CheckSpecificFruit(_G.CheckFruit)
            if inStock then
                checkResultLabel:Set("✅ " .. _G.CheckFruit .. " in stock!\n$" .. formatNumber(price))
                -- Optional: Add notification sound/alert here
            end
        end
    end
end)

print("Part 9 Loaded: Fruits/Stock Tab")

--[[
    KuKi Hub | True V2
    Part 11: ESP/Stats Tab - Stats Auto Upgrade, ESP Visuals (Player, Island, Fruit, Chest, etc.)
]]

-- ========================================
-- ESP/STATS TAB SETUP
-- ========================================
local StatsMain = Tab13:CraftPage(1)      -- Stats Upgrade
local ESPMain = Tab13:CraftPage(2)        -- ESP Main Toggles
local ESPAdvanced = Tab13:CraftPage(3)    -- Advanced ESP

-- ========================================
-- GLOBAL STATS/ESP VARIABLES
-- ========================================
_G.Auto_Melee = false
_G.Auto_Sword = false
_G.Auto_Gun = false
_G.Auto_DevilFruit = false
_G.Auto_Defense = false
_G.StatsValue = GetSetting("StatsValue", 10)

-- ESP Variables
local NumberESP = math.random(1, 1000000)
_G.ESP_Player = false
_G.ESP_Island = false
_G.ESP_Fruit = false
_G.ESP_Flower = false
_G.ESP_Chest = false
_G.ESP_Gear = false
_G.ESP_AdvDealer = false
_G.ESP_HakiColor = false
_G.ESP_Berry = false
_G.ESP_Mob = false
_G.ESP_NPC = false

-- ========================================
-- HELPER FUNCTIONS
-- ========================================
local function round(num)
    return math.floor(tonumber(num) + 0.5)
end

function statsSetings(stat, amount)
    if plr.Data.Points.Value ~= 0 then
        if stat == "Melee" then
            commF:InvokeServer("AddPoint", "Melee", amount)
        elseif stat == "Defense" then
            commF:InvokeServer("AddPoint", "Defense", amount)
        elseif stat == "Sword" then
            commF:InvokeServer("AddPoint", "Sword", amount)
        elseif stat == "Gun" then
            commF:InvokeServer("AddPoint", "Gun", amount)
        elseif stat == "Devil" then
            commF:InvokeServer("AddPoint", "Demon Fruit", amount)
        end
    end
end

-- ========================================
-- STATS MAIN PAGE (PAGE 1)
-- ========================================
StatsMain:Seperator("📊 Stats Information")

local statsInfo = StatsMain:AddParagraph({
    Title = "Current Stats",
    Desc = "Loading..."
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local melee = plr.Data.Level.Value
            local points = plr.Data.Points.Value
            statsInfo:SetDesc(string.format(
                "Level: %d\nStat Points: %d\nMelee: %d | Defense: %d\nSword: %d | Gun: %d | Fruit: %d",
                plr.Data.Level.Value,
                points,
                plr.Data.Melee.Value,
                plr.Data.Defense.Value,
                plr.Data.Sword.Value,
                plr.Data.Gun.Value,
                plr.Data["Demon Fruit"].Value
            ))
        end)
    end
end)

StatsMain:Seperator("⬆️ Auto Stats Upgrade")

StatsMain:Slider({
    Name = "Stats Value per Click",
    Min = 1,
    Max = 1000,
    Default = GetSetting("StatsValue", 10),
    Callback = function(value)
        _G.StatsValue = value
        _G.SaveData["StatsValue"] = value
        SaveSettings()
    end
})

StatsMain:Toggle({
    Name = "Auto Melee",
    Default = GetSetting("Auto_Melee", false),
    Callback = function(value)
        _G.Auto_Melee = value
        _G.SaveData["Auto_Melee"] = value
        SaveSettings()
    end
})

StatsMain:Toggle({
    Name = "Auto Defense",
    Default = GetSetting("Auto_Defense", false),
    Callback = function(value)
        _G.Auto_Defense = value
        _G.SaveData["Auto_Defense"] = value
        SaveSettings()
    end
})

StatsMain:Toggle({
    Name = "Auto Sword",
    Default = GetSetting("Auto_Sword", false),
    Callback = function(value)
        _G.Auto_Sword = value
        _G.SaveData["Auto_Sword"] = value
        SaveSettings()
    end
})

StatsMain:Toggle({
    Name = "Auto Gun",
    Default = GetSetting("Auto_Gun", false),
    Callback = function(value)
        _G.Auto_Gun = value
        _G.SaveData["Auto_Gun"] = value
        SaveSettings()
    end
})

StatsMain:Toggle({
    Name = "Auto Blox Fruit",
    Default = GetSetting("Auto_DevilFruit", false),
    Callback = function(value)
        _G.Auto_DevilFruit = value
        _G.SaveData["Auto_DevilFruit"] = value
        SaveSettings()
    end
})

StatsMain:Button({
    Name = "Add All Stats (Once)",
    Callback = function()
        local val = _G.StatsValue or 10
        statsSetings("Melee", val)
        statsSetings("Defense", val)
        statsSetings("Sword", val)
        statsSetings("Gun", val)
        statsSetings("Devil", val)
        library:Notification({Title = "Stats", Message = "Added " .. val .. " to all stats", Duration = 2})
    end
})

-- ========================================
-- ESP MAIN PAGE (PAGE 2)
-- ========================================
ESPMain:Seperator("👁️ ESP Toggles")

ESPMain:Toggle({
    Name = "ESP Player",
    Default = GetSetting("ESP_Player", false),
    Callback = function(value)
        _G.ESP_Player = value
        _G.SaveData["ESP_Player"] = value
        SaveSettings()
    end
})

ESPMain:Toggle({
    Name = "ESP Island",
    Default = GetSetting("ESP_Island", false),
    Callback = function(value)
        _G.ESP_Island = value
        _G.SaveData["ESP_Island"] = value
        SaveSettings()
    end
})

ESPMain:Toggle({
    Name = "ESP Fruit",
    Default = GetSetting("ESP_Fruit", false),
    Callback = function(value)
        _G.ESP_Fruit = value
        _G.SaveData["ESP_Fruit"] = value
        SaveSettings()
    end
})

ESPMain:Toggle({
    Name = "ESP Flower",
    Default = GetSetting("ESP_Flower", false),
    Callback = function(value)
        _G.ESP_Flower = value
        _G.SaveData["ESP_Flower"] = value
        SaveSettings()
    end
})

ESPMain:Toggle({
    Name = "ESP Chest",
    Default = GetSetting("ESP_Chest", false),
    Callback = function(value)
        _G.ESP_Chest = value
        _G.SaveData["ESP_Chest"] = value
        SaveSettings()
    end
})

ESPMain:Toggle({
    Name = "ESP Mob",
    Default = GetSetting("ESP_Mob", false),
    Callback = function(value)
        _G.ESP_Mob = value
        _G.SaveData["ESP_Mob"] = value
        SaveSettings()
    end
})

ESPMain:Toggle({
    Name = "ESP NPC",
    Default = GetSetting("ESP_NPC", false),
    Callback = function(value)
        _G.ESP_NPC = value
        _G.SaveData["ESP_NPC"] = value
        SaveSettings()
    end
})

-- ========================================
-- ESP ADVANCED PAGE (PAGE 3)
-- ========================================
ESPAdvanced:Seperator("🔧 Advanced ESP")

ESPAdvanced:Toggle({
    Name = "ESP Gear (Mirage)",
    Default = GetSetting("ESP_Gear", false),
    Callback = function(value)
        _G.ESP_Gear = value
        _G.SaveData["ESP_Gear"] = value
        SaveSettings()
    end
})

ESPAdvanced:Toggle({
    Name = "ESP Advanced Dealer",
    Default = GetSetting("ESP_AdvDealer", false),
    Callback = function(value)
        _G.ESP_AdvDealer = value
        _G.SaveData["ESP_AdvDealer"] = value
        SaveSettings()
    end
})

ESPAdvanced:Toggle({
    Name = "ESP Haki Color",
    Default = GetSetting("ESP_HakiColor", false),
    Callback = function(value)
        _G.ESP_HakiColor = value
        _G.SaveData["ESP_HakiColor"] = value
        SaveSettings()
    end
})

ESPAdvanced:Toggle({
    Name = "ESP Berry",
    Default = GetSetting("ESP_Berry", false),
    Callback = function(value)
        _G.ESP_Berry = value
        _G.SaveData["ESP_Berry"] = value
        SaveSettings()
    end
})

ESPAdvanced:Button({
    Name = "Clear All ESP",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BillboardGui") and obj.Name:find("ESP") then
                obj:Destroy()
            end
        end
        library:Notification({Title = "ESP", Message = "All ESP cleared", Duration = 2})
    end
})

-- ========================================
-- ESP LOGIC LOOPS
-- ========================================

-- Player ESP
task.spawn(function()
    while task.wait(0.5) do
        if _G.ESP_Player then
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= plr and player.Character and player.Character:FindFirstChild("Head") then
                        local head = player.Character.Head
                        local billboard = head:FindFirstChild("ESP_Player" .. NumberESP)
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP_Player" .. NumberESP
                            billboard.Size = UDim2.new(0, 200, 0, 40)
                            billboard.Adornee = head
                            billboard.AlwaysOnTop = true
                            billboard.Parent = head
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextStrokeTransparency = 0.5
                            label.TextWrapped = true
                            label.Font = Enum.Font.Code
                            label.TextSize = 14
                            label.Parent = billboard
                        end
                        
                        local label = billboard.TextLabel
                        local hum = player.Character:FindFirstChild("Humanoid")
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        local myHrp = GetHRP()
                        
                        if hum and hrp and myHrp then
                            local hpPercent = round((hum.Health / hum.MaxHealth) * 100)
                            local distance = round((myHrp.Position - hrp.Position).Magnitude)
                            local teamColor = player.Team == plr.Team and Color3.new(0, 0, 255) or Color3.new(255, 0, 0)
                            
                            label.Text = string.format("%s\n%d%% | %d studs", player.Name, hpPercent, distance)
                            label.TextColor3 = teamColor
                        end
                    end
                end
            end)
        else
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player.Character and player.Character:FindFirstChild("Head") then
                        local esp = player.Character.Head:FindFirstChild("ESP_Player" .. NumberESP)
                        if esp then esp:Destroy() end
                    end
                end
            end)
        end
    end
end)

-- Island ESP
task.spawn(function()
    while task.wait(0.5) do
        if _G.ESP_Island then
            pcall(function()
                for _, loc in pairs(Workspace._WorldOrigin.Locations:GetChildren()) do
                    if loc.Name ~= "Sea" then
                        local billboard = loc:FindFirstChild("ESP_Island")
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP_Island"
                            billboard.Size = UDim2.new(0, 200, 0, 30)
                            billboard.Adornee = loc
                            billboard.AlwaysOnTop = true
                            billboard.Parent = loc
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextStrokeTransparency = 0.5
                            label.Font = Enum.Font.Code
                            label.TextSize = 14
                            label.TextColor3 = Color3.fromRGB(98, 252, 252)
                            label.Parent = billboard
                        end
                        
                        local myHrp = GetHRP()
                        if myHrp then
                            local distance = round((myHrp.Position - loc.Position).Magnitude)
                            billboard.TextLabel.Text = string.format("%s\n%d studs", loc.Name, distance)
                        end
                    end
                end
            end)
        else
            pcall(function()
                for _, loc in pairs(Workspace._WorldOrigin.Locations:GetChildren()) do
                    local esp = loc:FindFirstChild("ESP_Island")
                    if esp then esp:Destroy() end
                end
            end)
        end
    end
end)

-- Fruit ESP
task.spawn(function()
    while task.wait(0.3) do
        if _G.ESP_Fruit then
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if string.find(obj.Name, "Fruit") and obj:FindFirstChild("Handle") then
                        local handle = obj.Handle
                        local billboard = handle:FindFirstChild("ESP_Fruit" .. NumberESP)
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP_Fruit" .. NumberESP
                            billboard.Size = UDim2.new(0, 200, 0, 30)
                            billboard.Adornee = handle
                            billboard.AlwaysOnTop = true
                            billboard.Parent = handle
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextStrokeTransparency = 0.5
                            label.Font = Enum.Font.Code
                            label.TextSize = 14
                            label.TextColor3 = Color3.new(1, 1, 1)
                            label.Parent = billboard
                        end
                        
                        local myHrp = GetHRP()
                        if myHrp then
                            local distance = round((myHrp.Position - handle.Position).Magnitude)
                            billboard.TextLabel.Text = string.format("%s\n%d studs", obj.Name, distance)
                        end
                    end
                end
            end)
        else
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:FindFirstChild("Handle") then
                        local esp = obj.Handle:FindFirstChild("ESP_Fruit" .. NumberESP)
                        if esp then esp:Destroy() end
                    end
                end
            end)
        end
    end
end)

-- Flower ESP
task.spawn(function()
    while task.wait(0.5) do
        if _G.ESP_Flower then
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name == "Flower1" or obj.Name == "Flower2" then
                        local billboard = obj:FindFirstChild("ESP_Flower" .. NumberESP)
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP_Flower" .. NumberESP
                            billboard.Size = UDim2.new(0, 200, 0, 30)
                            billboard.Adornee = obj
                            billboard.AlwaysOnTop = true
                            billboard.Parent = obj
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextStrokeTransparency = 0.5
                            label.Font = Enum.Font.Code
                            label.TextSize = 14
                            label.TextColor3 = Color3.fromRGB(88, 214, 252)
                            label.Parent = billboard
                        end
                        
                        local myHrp = GetHRP()
                        if myHrp then
                            local flowerName = obj.Name == "Flower1" and "Blue Flower" or "Red Flower"
                            local distance = round((myHrp.Position - obj.Position).Magnitude)
                            billboard.TextLabel.Text = string.format("%s\n%d studs", flowerName, distance)
                        end
                    end
                end
            end)
        else
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    local esp = obj:FindFirstChild("ESP_Flower" .. NumberESP)
                    if esp then esp:Destroy() end
                end
            end)
        end
    end
end)

-- Chest ESP
task.spawn(function()
    while task.wait(0.5) do
        if _G.ESP_Chest then
            pcall(function()
                local chests = CollectionService:GetTagged("_ChestTagged")
                local myHrp = GetHRP()
                if not myHrp then return end
                
                for _, chest in ipairs(chests) do
                    if not chest:GetAttribute("IsDisabled") then
                        local billboard = chest:FindFirstChild("ESP_Chest")
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP_Chest"
                            billboard.Size = UDim2.new(0, 200, 0, 30)
                            billboard.Adornee = chest
                            billboard.AlwaysOnTop = true
                            billboard.Parent = chest
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextStrokeTransparency = 0.5
                            label.Font = Enum.Font.Code
                            label.TextSize = 14
                            label.TextColor3 = Color3.fromRGB(80, 245, 245)
                            label.Parent = billboard
                        end
                        
                        local chestName = chest.Name:gsub("Label", "")
                        local distance = round((myHrp.Position - chest:GetPivot().Position).Magnitude)
                        billboard.TextLabel.Text = string.format("[%s]\n%d studs", chestName, distance)
                    end
                end
            end)
        else
            pcall(function()
                local chests = CollectionService:GetTagged("_ChestTagged")
                for _, chest in ipairs(chests) do
                    local esp = chest:FindFirstChild("ESP_Chest")
                    if esp then esp:Destroy() end
                end
            end)
        end
    end
end)

-- Mob ESP
task.spawn(function()
    while task.wait(0.3) do
        if _G.ESP_Mob then
            pcall(function()
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if G.Alive(mob) and mob:FindFirstChild("Head") then
                        local head = mob.Head
                        local billboard = head:FindFirstChild("ESP_Mob" .. NumberESP)
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP_Mob" .. NumberESP
                            billboard.Size = UDim2.new(0, 200, 0, 40)
                            billboard.Adornee = head
                            billboard.AlwaysOnTop = true
                            billboard.Parent = head
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextStrokeTransparency = 0.5
                            label.Font = Enum.Font.Code
                            label.TextSize = 12
                            label.TextColor3 = Color3.fromRGB(255, 100, 100)
                            label.Parent = billboard
                        end
                        
                        local hum = mob:FindFirstChild("Humanoid")
                        local myHrp = GetHRP()
                        if hum and myHrp then
                            local hpPercent = round((hum.Health / hum.MaxHealth) * 100)
                            local distance = round((myHrp.Position - head.Position).Magnitude)
                            billboard.TextLabel.Text = string.format("%s\n%d%% | %d studs", mob.Name, hpPercent, distance)
                        end
                    end
                end
            end)
        else
            pcall(function()
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Head") then
                        local esp = mob.Head:FindFirstChild("ESP_Mob" .. NumberESP)
                        if esp then esp:Destroy() end
                    end
                end
            end)
        end
    end
end)

-- NPC ESP
task.spawn(function()
    while task.wait(0.5) do
        if _G.ESP_NPC then
            pcall(function()
                for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                    if npc:FindFirstChild("Head") then
                        local head = npc.Head
                        local billboard = head:FindFirstChild("ESP_NPC" .. NumberESP)
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP_NPC" .. NumberESP
                            billboard.Size = UDim2.new(0, 200, 0, 30)
                            billboard.Adornee = head
                            billboard.AlwaysOnTop = true
                            billboard.Parent = head
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextStrokeTransparency = 0.5
                            label.Font = Enum.Font.Code
                            label.TextSize = 12
                            label.TextColor3 = Color3.fromRGB(100, 255, 100)
                            label.Parent = billboard
                        end
                        
                        local myHrp = GetHRP()
                        if myHrp then
                            local distance = round((myHrp.Position - head.Position).Magnitude)
                            billboard.TextLabel.Text = string.format("%s\n%d studs", npc.Name, distance)
                        end
                    end
                end
            end)
        else
            pcall(function()
                for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                    if npc:FindFirstChild("Head") then
                        local esp = npc.Head:FindFirstChild("ESP_NPC" .. NumberESP)
                        if esp then esp:Destroy() end
                    end
                end
            end)
        end
    end
end)

-- Advanced Fruit Dealer ESP
task.spawn(function()
    while task.wait(0.5) do
        if _G.ESP_AdvDealer then
            pcall(function()
                for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                    if npc.Name == "Advanced Fruit Dealer" and npc:FindFirstChild("HumanoidRootPart") then
                        local hrp = npc.HumanoidRootPart
                        local billboard = hrp:FindFirstChild("ESP_AdvDealer")
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP_AdvDealer"
                            billboard.Size = UDim2.new(0, 200, 0, 30)
                            billboard.Adornee = hrp
                            billboard.AlwaysOnTop = true
                            billboard.Parent = hrp
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextStrokeTransparency = 0.5
                            label.Font = Enum.Font.Code
                            label.TextSize = 14
                            label.TextColor3 = Color3.fromRGB(255, 215, 0)
                            label.Parent = billboard
                        end
                        
                        local myHrp = GetHRP()
                        if myHrp then
                            local distance = round((myHrp.Position - hrp.Position).Magnitude)
                            billboard.TextLabel.Text = string.format("Advanced Dealer\n%d studs", distance)
                        end
                    end
                end
            end)
        else
            pcall(function()
                for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                    if npc.Name == "Advanced Fruit Dealer" and npc:FindFirstChild("HumanoidRootPart") then
                        local esp = npc.HumanoidRootPart:FindFirstChild("ESP_AdvDealer")
                        if esp then esp:Destroy() end
                    end
                end
            end)
        end
    end
end)

-- Haki Color Dealer ESP
task.spawn(function()
    while task.wait(0.5) do
        if _G.ESP_HakiColor then
            pcall(function()
                for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                    if npc.Name == "Barista Cousin" and npc:FindFirstChild("HumanoidRootPart") then
                        local hrp = npc.HumanoidRootPart
                        local billboard = hrp:FindFirstChild("ESP_HakiColor")
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP_HakiColor"
                            billboard.Size = UDim2.new(0, 200, 0, 30)
                            billboard.Adornee = hrp
                            billboard.AlwaysOnTop = true
                            billboard.Parent = hrp
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextStrokeTransparency = 0.5
                            label.Font = Enum.Font.Code
                            label.TextSize = 14
                            label.TextColor3 = Color3.fromRGB(0, 255, 255)
                            label.Parent = billboard
                        end
                        
                        local myHrp = GetHRP()
                        if myHrp then
                            local distance = round((myHrp.Position - hrp.Position).Magnitude)
                            billboard.TextLabel.Text = string.format("Barista (Haki)\n%d studs", distance)
                        end
                    end
                end
            end)
        else
            pcall(function()
                for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                    if npc.Name == "Barista Cousin" and npc:FindFirstChild("HumanoidRootPart") then
                        local esp = npc.HumanoidRootPart:FindFirstChild("ESP_HakiColor")
                        if esp then esp:Destroy() end
                    end
                end
            end)
        end
    end
end)

-- Berry ESP
task.spawn(function()
    while task.wait(0.5) do
        if _G.ESP_Berry then
            pcall(function()
                local bushes = CollectionService:GetTagged("BerryBush")
                local myHrp = GetHRP()
                if not myHrp then return end
                
                for _, bush in ipairs(bushes) do
                    for attrName, attrValue in pairs(bush:GetAttributes()) do
                        if attrValue then
                            local pos = bush.Parent:GetPivot().Position
                            -- Check if we already have ESP for this position
                            local existing = nil
                            for _, child in pairs(Workspace:GetChildren()) do
                                if child:IsA("Part") and child.Name:find("BerryESP_") and (child.Position - pos).Magnitude < 1 then
                                    existing = child
                                    break
                                end
                            end
                            
                            if not existing then
                                local part = Instance.new("Part")
                                part.Name = "BerryESP_" .. attrValue
                                part.Size = Vector3.new(1, 1, 1)
                                part.Transparency = 1
                                part.Anchored = true
                                part.CanCollide = false
                                part.Position = pos
                                part.Parent = Workspace
                                
                                local billboard = Instance.new("BillboardGui")
                                billboard.Name = "ESP"
                                billboard.Size = UDim2.new(0, 200, 0, 30)
                                billboard.Adornee = part
                                billboard.AlwaysOnTop = true
                                billboard.Parent = part
                                
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.TextStrokeTransparency = 0.5
                                label.Font = Enum.Font.Code
                                label.TextSize = 14
                                label.TextColor3 = Color3.fromRGB(80, 245, 245)
                                label.Parent = billboard
                            end
                        end
                    end
                end
            end)
        else
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:IsA("Part") and obj.Name:find("BerryESP_") then
                        obj:Destroy()
                    end
                end
            end)
        end
    end
end)

-- Gear ESP (Mirage)
task.spawn(function()
    while task.wait(0.5) do
        if _G.ESP_Gear then
            pcall(function()
                local mysticIsland = Workspace.Map:FindFirstChild("MysticIsland")
                if mysticIsland then
                    for _, part in pairs(mysticIsland:GetDescendants()) do
                        if part.Name == "Part" and part.Material == Enum.Material.Neon then
                            local billboard = part:FindFirstChild("ESP_Gear")
                            if not billboard then
                                billboard = Instance.new("BillboardGui")
                                billboard.Name = "ESP_Gear"
                                billboard.Size = UDim2.new(0, 200, 0, 30)
                                billboard.Adornee = part
                                billboard.AlwaysOnTop = true
                                billboard.Parent = part
                                
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.TextStrokeTransparency = 0.5
                                label.Font = Enum.Font.Code
                                label.TextSize = 14
                                label.TextColor3 = Color3.fromRGB(80, 245, 245)
                                label.Parent = billboard
                            end
                            
                            local myHrp = GetHRP()
                            if myHrp then
                                local distance = round((myHrp.Position - part.Position).Magnitude)
                                billboard.TextLabel.Text = string.format("Gear\n%d studs", distance)
                            end
                        end
                    end
                end
            end)
        else
            pcall(function()
                local mysticIsland = Workspace.Map:FindFirstChild("MysticIsland")
                if mysticIsland then
                    for _, part in pairs(mysticIsland:GetDescendants()) do
                        local esp = part:FindFirstChild("ESP_Gear")
                        if esp then esp:Destroy() end
                    end
                end
            end)
        end
    end
end)

-- ========================================
-- AUTO STATS LOGIC LOOPS
-- ========================================
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local val = _G.StatsValue or 10
            if _G.Auto_Melee then statsSetings("Melee", val) end
            if _G.Auto_Defense then statsSetings("Defense", val) end
            if _G.Auto_Sword then statsSetings("Sword", val) end
            if _G.Auto_Gun then statsSetings("Gun", val) end
            if _G.Auto_DevilFruit then statsSetings("Devil", val) end
        end)
    end
end)

print("========================================")
print("KuKi Hub | True V2 - Part 11 Loaded!")
print("ESP/Stats Tab Complete!")
print("========================================")

--[[
    KuKi Hub | True V2
    Part 12: Shop Tab - Buy Melee, Haki, Swords, Guns, Accessories, Crafting, Race/Stats
]]

-- ========================================
-- SHOP TAB SETUP
-- ========================================
local ShopMelee = Tab14:CraftPage(1)      -- Melee Shop
local ShopHaki = Tab14:CraftPage(2)       -- Haki / Abilities
local ShopWeapon = Tab14:CraftPage(3)     -- Swords & Guns
local ShopAccessory = Tab14:CraftPage(4)  -- Accessories
local ShopCraft = Tab14:CraftPage(5)      -- Crafting Sea Events
local ShopRace = Tab14:CraftPage(6)       -- Race & Stats Reset

-- ========================================
-- GLOBAL SHOP VARIABLES
-- ========================================
_G.AutoBuyMelee = false
local SelectedMelee = "Dark Step (Chân Đen)"

-- Melee Data with coordinates per world
local MeleeCoords = {
    ["Dark Step (Chân Đen)"] = {
        Key = "BuyBlackLeg",
        NPC = "Dark Step Teacher",
        Pos = World1 and CFrame.new(-985, 13, 3988) 
            or World2 and CFrame.new(-4753, 35, -4850) 
            or World3 and CFrame.new(-5045, 371, -3181) 
            or nil
    },
    ["Electric (Điện)"] = {
        Key = "BuyElectro",
        NPC = "Mad Scientist",
        Pos = World1 and CFrame.new(-5384, 13, -2148) 
            or World2 and CFrame.new(-4867, 35, -4766) 
            or World3 and CFrame.new(-4995, 314, -3203) 
            or nil
    },
    ["Water Kung Fu (Võ Cá)"] = {
        Key = "BuyFishmanKarate",
        NPC = "Water Kung Fu Teacher",
        Pos = World1 and CFrame.new(61585, 18, 987) 
            or World2 and CFrame.new(-4958, 35, -4668) 
            or World3 and CFrame.new(-5023, 371, -3190) 
            or nil
    },
    ["Dragon Breath (Hơi Thở Rồng)"] = {
        Key = "BuyDragonClaw",
        NPC = "Sabi",
        Pos = World2 and CFrame.new(701, 187, 655) 
            or World3 and CFrame.new(-4981, 371, -3207) 
            or nil
    },
    ["Superhuman"] = {
        Key = "BuySuperhuman",
        NPC = "Martial Arts Master",
        Pos = World2 and CFrame.new(1374, 247, -5192) 
            or World3 and CFrame.new(-5004, 371, -3198) 
            or nil
    },
    ["Death Step (Chân Đen V2)"] = {
        Key = "BuyDeathStep",
        NPC = "Phoeyu, the Reformed",
        Pos = World2 and CFrame.new(6357, 296, -6762) 
            or World3 and CFrame.new(-4999, 314, -3221) 
            or nil
    },
    ["Sharkman Karate (Võ Cá V2)"] = {
        Key = "BuySharkmanKarate",
        NPC = "Daigrock, the Sharkman",
        Pos = World2 and CFrame.new(-2602, 238, -10316) 
            or World3 and CFrame.new(-4972, 314, -3222) 
            or nil
    },
    ["Dragon Talon (Rồng V2)"] = {
        Key = "BuyDragonTalon",
        NPC = "Uzoth",
        Pos = World3 and CFrame.new(5661, 1211, 865) or nil
    },
    ["Electric Claw (Điện V2)"] = {
        Key = "BuyElectricClaw",
        NPC = "Previous Hero",
        Pos = World3 and CFrame.new(-10371, 331, -10131) or nil
    },
    ["Godhuman"] = {
        Key = "BuyGodhuman",
        NPC = "Ancient Monk",
        Pos = World3 and CFrame.new(-13776, 334, -9879) or nil
    },
    ["Sanguine Art (Võ Quỷ)"] = {
        Key = "BuySanguineArt",
        NPC = "Shafi",
        Pos = World3 and CFrame.new(-16353, 160, 99) or nil
    }
}

local function GetAvailableMeleeOptions()
    local list = {}
    for name, data in pairs(MeleeCoords) do
        if data.Pos then table.insert(list, name) end
    end
    table.sort(list)
    return list
end

-- ========================================
-- SHOP MELEE PAGE (PAGE 1)
-- ========================================
ShopMelee:Seperator("🥋 Mua Melee")

ShopMelee:Dropdown({
    Name = "Chọn Melee Cần Mua",
    Options = GetAvailableMeleeOptions(),
    Default = "Dark Step (Chân Đen)",
    Callback = function(value)
        SelectedMelee = value
    end
})

ShopMelee:Button({
    Name = "Mua Melee (Một Lần)",
    Callback = function()
        local data = MeleeCoords[SelectedMelee]
        if not data or not data.Pos then
            library:Notification({Title = "Shop", Message = "Melee không có ở Sea này", Duration = 3})
            return
        end
        pcall(function()
            local hrp = GetHRP()
            if hrp then
                if (hrp.Position - data.Pos.Position).Magnitude > 15 then
                    _tp(data.Pos)
                    task.wait(1)
                end
                commF:InvokeServer(data.Key)
                commF:InvokeServer("BuyItem", data.Key)
                library:Notification({Title = "Shop", Message = "Đã mua: " .. SelectedMelee, Duration = 2})
            end
        end)
    end
})

ShopMelee:Toggle({
    Name = "Auto Mua Melee",
    Default = GetSetting("AutoBuyMelee", false),
    Callback = function(value)
        _G.AutoBuyMelee = value
        _G.SaveData["AutoBuyMelee"] = value
        SaveSettings()
        
        task.spawn(function()
            while _G.AutoBuyMelee do
                task.wait(1)
                if not _G.AutoBuyMelee then break end
                local data = MeleeCoords[SelectedMelee]
                if not data or not data.Pos then break end
                pcall(function()
                    local hrp = GetHRP()
                    if hrp then
                        if (hrp.Position - data.Pos.Position).Magnitude > 15 then
                            _tp(data.Pos)
                        else
                            commF:InvokeServer(data.Key)
                            commF:InvokeServer("BuyItem", data.Key)
                        end
                    end
                end)
            end
        end)
    end
})

-- ========================================
-- SHOP HAKI PAGE (PAGE 2)
-- ========================================
ShopHaki:Seperator("⚡ Mua Haki, Soru, Geppo")

ShopHaki:Button({
    Name = "Buy Geppo $10,000",
    Callback = function()
        commF:InvokeServer("BuyHaki", "Geppo")
        library:Notification({Title = "Shop", Message = "Đã mua Geppo", Duration = 2})
    end
})

ShopHaki:Button({
    Name = "Buy Buso Haki $25,000",
    Callback = function()
        commF:InvokeServer("BuyHaki", "Buso")
        library:Notification({Title = "Shop", Message = "Đã mua Buso Haki", Duration = 2})
    end
})

ShopHaki:Button({
    Name = "Buy Soru $25,000",
    Callback = function()
        commF:InvokeServer("BuyHaki", "Soru")
        library:Notification({Title = "Shop", Message = "Đã mua Soru", Duration = 2})
    end
})

ShopHaki:Button({
    Name = "Buy Observation Haki $750,000",
    Callback = function()
        commF:InvokeServer("KenTalk", "Buy")
        library:Notification({Title = "Shop", Message = "Đã mua Observation Haki", Duration = 2})
    end
})

ShopHaki:Button({
    Name = "Buy Skyjump $10,000",
    Callback = function()
        commF:InvokeServer("BuyHaki", "Skyjump")
        library:Notification({Title = "Shop", Message = "Đã mua Skyjump", Duration = 2})
    end
})

-- ========================================
-- SHOP WEAPON PAGE (PAGE 3)
-- ========================================
ShopWeapon:Seperator("⚔️ Mua Kiếm")

local swordButtons = {
    {"Cutlass $1,000", "Cutlass"},
    {"Katana $1,000", "Katana"},
    {"Iron Mace $25,000", "Iron Mace"},
    {"Dual Katana $12,000", "Duel Katana"},
    {"Triple Katana $60,000", "Triple Katana"},
    {"Pipe $100,000", "Pipe"},
    {"Dual-Headed Blade $400,000", "Dual-Headed Blade"},
    {"Bisento $1,200,000", "Bisento"},
    {"Soul Cane $750,000", "Soul Cane"},
}

for _, sword in ipairs(swordButtons) do
    ShopWeapon:Button({
        Name = sword[1],
        Callback = function()
            commF:InvokeServer("BuyItem", sword[2])
            library:Notification({Title = "Shop", Message = "Đã mua " .. sword[2], Duration = 2})
        end
    })
end

ShopWeapon:Button({
    Name = "Buy Pole V2 5,000F",
    Callback = function()
        commF:InvokeServer("ThunderGodTalk")
        library:Notification({Title = "Shop", Message = "Đã mua Pole V2", Duration = 2})
    end
})

ShopWeapon:Seperator("🔫 Mua Súng")

local gunButtons = {
    {"Slingshot $5,000", "Slingshot"},
    {"Musket $8,000", "Musket"},
    {"Flintlock $10,500", "Flintlock"},
    {"Refined Slingshot $30,000", "Refined Slingshot"},
    {"Refined Flintlock $65,000", "Refined Flintlock"},
    {"Cannon $100,000", "Cannon"},
}

for _, gun in ipairs(gunButtons) do
    ShopWeapon:Button({
        Name = gun[1],
        Callback = function()
            commF:InvokeServer("BuyItem", gun[2])
            library:Notification({Title = "Shop", Message = "Đã mua " .. gun[2], Duration = 2})
        end
    })
end

ShopWeapon:Button({
    Name = "Buy Kabucha 1,500F",
    Callback = function()
        commF:InvokeServer("BlackbeardReward", "Slingshot", "1")
        commF:InvokeServer("BlackbeardReward", "Slingshot", "2")
        library:Notification({Title = "Shop", Message = "Đã mua Kabucha", Duration = 2})
    end
})

ShopWeapon:Button({
    Name = "Buy Bizarre Rifle 250 Ectoplasm",
    Callback = function()
        commF:InvokeServer("Ectoplasm", "Buy", 1)
        library:Notification({Title = "Shop", Message = "Đã mua Bizarre Rifle", Duration = 2})
    end
})

ShopWeapon:Button({
    Name = "Buy Serpent Bow",
    Callback = function()
        if World3 then
            commF:InvokeServer("BuyItem", "Serpent Bow")
            library:Notification({Title = "Shop", Message = "Đã mua Serpent Bow", Duration = 2})
        end
    end
})

-- ========================================
-- SHOP ACCESSORY PAGE (PAGE 4)
-- ========================================
ShopAccessory:Seperator("💍 Mua Phụ Kiện")

ShopAccessory:Button({
    Name = "Buy Black Cape $50,000",
    Callback = function()
        commF:InvokeServer("BuyItem", "Black Cape")
        library:Notification({Title = "Shop", Message = "Đã mua Black Cape", Duration = 2})
    end
})

ShopAccessory:Button({
    Name = "Buy Swordsman Hat $150,000",
    Callback = function()
        commF:InvokeServer("BuyItem", "Swordsman Hat")
        library:Notification({Title = "Shop", Message = "Đã mua Swordsman Hat", Duration = 2})
    end
})

ShopAccessory:Button({
    Name = "Buy Tomoe Ring $500,000",
    Callback = function()
        commF:InvokeServer("BuyItem", "Tomoe Ring")
        library:Notification({Title = "Shop", Message = "Đã mua Tomoe Ring", Duration = 2})
    end
})

ShopAccessory:Button({
    Name = "Buy Pink Coat",
    Callback = function()
        commF:InvokeServer("BuyItem", "Pink Coat")
        library:Notification({Title = "Shop", Message = "Đã mua Pink Coat", Duration = 2})
    end
})

-- ========================================
-- SHOP CRAFT PAGE (PAGE 5)
-- ========================================
ShopCraft:Seperator("🔨 Mua Đồ Craft Sea Event")

local craftItems = {
    {"Craft Dragonheart", "Dragonheart"},
    {"Craft Dragonstorm", "Dragonstorm"},
    {"Craft DinoHood", "DinoHood"},
    {"Craft SharkTooth", "SharkTooth"},
    {"Craft TerrorJaw", "TerrorJaw"},
    {"Craft SharkAnchor", "SharkAnchor"},
    {"Craft LeviathanCrown", "LeviathanCrown"},
    {"Craft LeviathanShield", "LeviathanShield"},
    {"Craft LeviathanBoat", "LeviathanBoat"},
    {"Craft LegendaryScroll", "LegendaryScroll"},
    {"Craft MythicalScroll", "MythicalScroll"},
}

for _, item in ipairs(craftItems) do
    ShopCraft:Button({
        Name = item[1],
        Callback = function()
            commF:InvokeServer("CraftItem", "Craft", item[2])
            library:Notification({Title = "Craft", Message = "Đã craft " .. item[2], Duration = 2})
        end
    })
end

-- ========================================
-- SHOP RACE PAGE (PAGE 6)
-- ========================================
ShopRace:Seperator("🧬 Đổi Tộc")

ShopRace:Button({
    Name = "Đổi Tộc Ghoul (100 Ectoplasm)",
    Callback = function()
        commF:InvokeServer("Ectoplasm", "Change", 4)
        library:Notification({Title = "Race", Message = "Đã đổi sang Ghoul", Duration = 2})
    end
})

ShopRace:Button({
    Name = "Đổi Tộc Cyborg (2,500F)",
    Callback = function()
        commF:InvokeServer("CyborgTrainer", "Buy")
        library:Notification({Title = "Race", Message = "Đã đổi sang Cyborg", Duration = 2})
    end
})

ShopRace:Button({
    Name = "Random Race 3,000F",
    Callback = function()
        commF:InvokeServer("BlackbeardReward", "Reroll", "1")
        commF:InvokeServer("BlackbeardReward", "Reroll", "2")
        library:Notification({Title = "Race", Message = "Đã Random Race", Duration = 2})
    end
})

ShopRace:Seperator("📊 Reset Stats")

ShopRace:Button({
    Name = "Reset Stats 2,500F",
    Callback = function()
        commF:InvokeServer("BlackbeardReward", "Refund", "1")
        commF:InvokeServer("BlackbeardReward", "Refund", "2")
        library:Notification({Title = "Stats", Message = "Đã Reset Stats", Duration = 2})
    end
})

ShopRace:Button({
    Name = "Reset Stats (Free - Code)",
    Callback = function()
        commF:InvokeServer("BlackbeardReward", "Refund", "1")
        commF:InvokeServer("BlackbeardReward", "Refund", "2")
        library:Notification({Title = "Stats", Message = "Đã Reset Stats", Duration = 2})
    end
})

print("========================================")
print("KuKi Hub | True V2 - Part 12 Loaded!")
print("Shop Tab Complete!")
print("========================================")

--[[
    KuKi Hub | True V2
    Part 13: Misc/Settings Tab - Server Functions, GUI Controls, Graphics, Utilities
]]

-- ========================================
-- MISC TAB SETUP
-- ========================================
local MiscServer = Tab15:CraftPage(1)     -- Server Functions
local MiscGUI = Tab15:CraftPage(2)        -- GUI Controls
local MiscGraphics = Tab15:CraftPage(3)   -- Graphics Settings
local MiscUtils = Tab15:CraftPage(4)      -- Utilities / Fun

-- ========================================
-- GLOBAL MISC VARIABLES
-- ========================================
_G.Rechat = GetSetting("DisableChat", false)
_G.ReLeader = GetSetting("DisableLeader", false)
_G.PortalUnLock = GetSetting("PortalUnLock", false)
_G.RTXMode = GetSetting("RTXMode", false)
_G.FullBright = GetSetting("FullBright", false)
_G.AutoTime = GetSetting("AutoTime", false)
_G.SelectDN = GetSetting("SelectDN", "Day")
_G.IceWalk = GetSetting("IceWalk", false)
_G.SelectStateHaki = 0

-- ========================================
-- MISC SERVER PAGE (PAGE 1)
-- ========================================
MiscServer:Seperator("🎟️ Server Functions")

MiscServer:Button({
    Name = "Redeem All Codes",
    Callback = function()
        local Codes = {
            "LIGHTNINGABUSE", "1LOSTADMIN", "ADMINFIGHT", "GIFTING_HOURS",
            "NOMOREHACK", "BANEXPLOIT", "WildDares", "BossBuild",
            "GetPranked", "EARN_FRUITS", "SUB2GAMERROBOT_RESET1", "KITT_RESET",
            "Bignews", "CHANDLER", "Fudd10", "fudd10_v2", "Sub2UncleKizaru",
            "FIGHT4FRUIT", "kittgaming", "TRIPLEABUSE", "Sub2CaptainMaui",
            "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo",
            "Bluxxy", "SUB2GAMERROBOT_EXP1", "Sub2NoobMaster123", "Sub2Daigrock",
            "Axiore", "TantaiGaming", "StrawHatMaine", "Sub2OfficialNoobie",
            "TheGreatAce", "JULYUPDATE_RESET", "ADMINHACKED", "SEATROLLING",
            "24NOADMIN", "ADMIN_TROLL", "NEWTROLL", "SECRET_ADMIN",
            "staffbattle", "NOEXPLOIT", "NOOB2ADMIN", "CODESLIDE",
            "fruitconcepts", "krazydares"
        }
        local RedeemRemote = ReplicatedStorage.Remotes:FindFirstChild("Redeem")
        if not RedeemRemote then
            library:Notification({Title = "Error", Message = "Redeem remote not found", Duration = 3})
            return
        end
        for _, code in ipairs(Codes) do
            task.wait()
            pcall(function()
                if RedeemRemote.InvokeServer then
                    RedeemRemote:InvokeServer(code)
                else
                    RedeemRemote:FireServer(code)
                end
            end)
        end
        library:Notification({Title = "Codes", Message = "Attempted to redeem all codes", Duration = 3})
    end
})

MiscServer:Button({
    Name = "Check All Codes (Once)",
    Callback = function()
        local testCodes = {"Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "fudd10_v2", "SUB2GAMERROBOT_EXP1"}
        local RedeemRemote = ReplicatedStorage.Remotes:FindFirstChild("Redeem")
        for _, code in ipairs(testCodes) do
            pcall(function() RedeemRemote:InvokeServer(code) end)
        end
        library:Notification({Title = "Codes", Message = "Checked common codes", Duration = 2})
    end
})

-- ========================================
-- MISC GUI PAGE (PAGE 2)
-- ========================================
MiscGUI:Seperator("🖥️ Player GUI Controls")

MiscGUI:Button({
    Name = "Open Awakenings Expert",
    Callback = function()
        pcall(function()
            plr.PlayerGui.Main.AwakeningToggler.Visible = true
            library:Notification({Title = "GUI", Message = "Opened Awakenings Expert", Duration = 2})
        end)
    end
})

MiscGUI:Button({
    Name = "Open Title Selection",
    Callback = function()
        pcall(function()
            commF:InvokeServer("getTitles", true)
            plr.PlayerGui.Main.Titles.Visible = true
            library:Notification({Title = "GUI", Message = "Opened Title Selection", Duration = 2})
        end)
    end
})

MiscGUI:Toggle({
    Name = "Disable Chat GUI",
    Default = _G.Rechat,
    Callback = function(value)
        _G.Rechat = value
        _G.SaveData["DisableChat"] = value
        SaveSettings()
        pcall(function()
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, not value)
        end)
    end
})

MiscGUI:Toggle({
    Name = "Disable Leaderboard GUI",
    Default = _G.ReLeader,
    Callback = function(value)
        _G.ReLeader = value
        _G.SaveData["DisableLeader"] = value
        SaveSettings()
        pcall(function()
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, not value)
        end)
    end
})

if World3 then
    MiscGUI:Toggle({
        Name = "Unlock All Portals (WIP)",
        Default = _G.PortalUnLock,
        Callback = function(value)
            _G.PortalUnLock = value
            _G.SaveData["PortalUnLock"] = value
            SaveSettings()
        end
    })
    
    task.spawn(function()
        while task.wait(3) do
            if _G.PortalUnLock then
                pcall(function()
                    local hrp = GetHRP()
                    if hrp then
                        if (hrp.Position - CFrame.new(-5097.93, 316.44, -3142.66).Position).Magnitude < 8 then
                            commF:InvokeServer("requestEntrance", Vector3.new(-12471.16, 374.94, -7551.67))
                        elseif (hrp.Position - CFrame.new(-12471.16, 374.94, -7551.67).Position).Magnitude < 8 then
                            commF:InvokeServer("requestEntrance", Vector3.new(-5072.08, 314.54, -3151.10))
                        end
                    end
                end)
            end
        end
    end)
end

-- ========================================
-- MISC GRAPHICS PAGE (PAGE 3)
-- ========================================
MiscGraphics:Seperator("🎨 Graphics Settings")

MiscGraphics:Toggle({
    Name = "RTX Mode (Visual)",
    Default = _G.RTXMode,
    Callback = function(value)
        _G.RTXMode = value
        _G.SaveData["RTXMode"] = value
        SaveSettings()
        if value then
            task.spawn(function()
                local l = Lighting
                while _G.RTXMode do
                    l.Ambient = Color3.fromRGB(33, 33, 33)
                    l.Brightness = 0.3
                    l.FogEnd = 9e9
                    task.wait()
                end
                l.Ambient = Color3.new(0, 0, 0)
                l.Brightness = 1
                l.FogEnd = 2500
            end)
        end
    end
})

MiscGraphics:Toggle({
    Name = "Full Bright",
    Default = _G.FullBright,
    Callback = function(value)
        _G.FullBright = value
        _G.SaveData["FullBright"] = value
        SaveSettings()
        if value then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
            Lighting.ColorShift_Top = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.Brightness = 1
        end
    end
})

MiscGraphics:Button({
    Name = "Fast Mode (Low Graphics)",
    Callback = function()
        local plasticParts = {"Part", "Union", "CornerWedgePart", "TrussPart", "MeshPart"}
        for _, v in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if table.find(plasticParts, v.ClassName) then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                end
            end)
        end
        library:Notification({Title = "Graphics", Message = "Fast Mode applied", Duration = 2})
    end
})

MiscGraphics:Button({
    Name = "Low CPU Mode",
    Callback = function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        library:Notification({Title = "Optimization", Message = "Low CPU Mode enabled", Duration = 2})
    end
})

MiscGraphics:Button({
    Name = "Remove Sky Fog",
    Callback = function()
        pcall(function()
            if Lighting:FindFirstChild("LightingLayers") then Lighting.LightingLayers:Destroy() end
            if Lighting:FindFirstChild("SeaTerrorCC") then Lighting.SeaTerrorCC:Destroy() end
            if Lighting:FindFirstChild("FantasySky") then Lighting.FantasySky:Destroy() end
        end)
        library:Notification({Title = "Fog", Message = "Removed sky fog", Duration = 2})
    end
})

MiscGraphics:Button({
    Name = "Increase Boat Speed (Client)",
    Callback = function()
        pcall(function()
            for _, boat in pairs(Workspace.Boats:GetDescendants()) do
                if boat:IsA("VehicleSeat") then
                    boat.MaxSpeed = 350
                    boat.Torque = 0.2
                    boat.TurnSpeed = 5
                end
            end
        end)
        library:Notification({Title = "Boats", Message = "Client boat speed increased", Duration = 2})
    end
})

-- ========================================
-- MISC UTILS PAGE (PAGE 4)
-- ========================================
MiscUtils:Seperator("🌈 Fun / Utility")

MiscUtils:Button({
    Name = "Rain Fruits (Client)",
    Callback = function()
        task.spawn(function()
            local fruitModel = game:GetObjects("rbxassetid://14759368201")[1]
            for _, fruit in pairs(fruitModel:GetChildren()) do
                fruit.Parent = Workspace.Map
                fruit:MoveTo(plr.Character.PrimaryPart.Position + Vector3.new(math.random(-50, 50), 100, math.random(-50, 50)))
            end
        end)
        library:Notification({Title = "Fun", Message = "Raining fruits!", Duration = 2})
    end
})

MiscUtils:Seperator("⏰ Time Changer")

MiscUtils:Dropdown({
    Name = "Select Time",
    Options = {"Day", "Night"},
    Default = _G.SelectDN,
    Callback = function(value)
        _G.SelectDN = value
        _G.SaveData["SelectDN"] = value
        SaveSettings()
    end
})

MiscUtils:Toggle({
    Name = "Auto Set Time",
    Default = _G.AutoTime,
    Callback = function(value)
        _G.AutoTime = value
        _G.SaveData["AutoTime"] = value
        SaveSettings()
    end
})

task.spawn(function()
    while task.wait(1) do
        if _G.AutoTime then
            Lighting.ClockTime = (_G.SelectDN == "Day") and 12 or 0
        end
    end
end)

MiscUtils:Seperator("❄️ Ice Walk")

MiscUtils:Toggle({
    Name = "Ice Walk (Visual)",
    Default = _G.IceWalk,
    Callback = function(value)
        _G.IceWalk = value
        _G.SaveData["IceWalk"] = value
        SaveSettings()
    end
})

task.spawn(function()
    while task.wait(0.5) do
        if _G.IceWalk and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local ice = ReplicatedStorage.Assets.Models.IceSpikes4:Clone()
                ice.Parent = Workspace
                ice.Size = Vector3.new(3 + math.random(10, 12), 1.7, 3 + math.random(10, 12))
                ice.Color = Color3.fromRGB(128, 187, 219)
                ice.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position.X, -3.8, plr.Character.HumanoidRootPart.Position.Z)
                local tween = TweenService:Create(ice, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = Vector3.new(0, 0.3, 0)})
                tween.Completed:Connect(function() ice:Destroy() end)
                tween:Play()
            end)
        end
    end
end)

MiscUtils:Seperator("🎨 Haki Stage")

MiscUtils:Dropdown({
    Name = "Select Haki Stage",
    Options = {"Stage 0", "Stage 1", "Stage 2", "Stage 3", "Stage 4", "Stage 5"},
    Default = "Stage 0",
    Callback = function(value)
        _G.SelectStateHaki = tonumber(value:match("%d+")) or 0
    end
})

MiscUtils:Button({
    Name = "Apply Haki Stage",
    Callback = function()
        pcall(function()
            commF:InvokeServer("ChangeBusoStage", _G.SelectStateHaki)
            library:Notification({Title = "Haki", Message = "Changed to Stage " .. _G.SelectStateHaki, Duration = 2})
        end)
    end
})

MiscUtils:Seperator("📋 Clipboard")

MiscUtils:Button({
    Name = "Copy Discord Invite",
    Callback = function()
        setclipboard("https://discord.gg/kuKihub")
        library:Notification({Title = "Clipboard", Message = "Discord invite copied!", Duration = 2})
    end
})

print("========================================")
print("KuKi Hub | True V2 - Part 13 Loaded!")
print("Misc/Settings Tab Complete!")
print("========================================")
print("All tabs completed! Full script ready.")
