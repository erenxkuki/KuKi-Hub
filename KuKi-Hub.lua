--[[
    KuKi Hub | True V2
    Full Blox Fruits Script - Part 1: Foundation + Info + Status
]]

-- ========================================
-- UI LIBRARY SETUP
-- ========================================
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/ZenHub/refs/heads/main/UiZenMake.lua",true))()
local Window = library:Make({Name = "KuKi Hub | True V2"})

-- ========================================
-- SERVICES SETUP
-- ========================================
local Services = setmetatable({}, {
    __index = function(self, serviceName)
        local service = game:GetService(serviceName)
        rawset(self, serviceName, service)
        return service
    end
})

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
local UserInputService = Services.UserInputService
local StarterGui = Services.StarterGui

local plr = Players.LocalPlayer

-- ========================================
-- REMOTES SETUP
-- ========================================
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local commE = Remotes:WaitForChild("CommE")
local commF = Remotes:WaitForChild("CommF_")
local redeemRemote = Remotes:FindFirstChild("Redeem")

-- ========================================
-- SAVE/LOAD SYSTEM
-- ========================================
local FolderName = "KuKi Hub"
local FileName = "Settings.json"
local FullPath = FolderName .. "/" .. FileName

if makefolder and not isfolder(FolderName) then
    makefolder(FolderName)
end

_G.SaveData = _G.SaveData or {}

function SaveSettings()
    if not writefile then return false end
    local success = pcall(function()
        local json = HttpService:JSONEncode(_G.SaveData)
        writefile(FullPath, json)
    end)
    return success
end

function LoadSettings()
    if not (isfile and isfile(FullPath)) then return false end
    local success, result = pcall(function()
        local content = readfile(FullPath)
        return HttpService:JSONDecode(content)
    end)
    if success and result then
        _G.SaveData = result
        return true
    end
    return false
end

function GetSetting(name, default)
    return _G.SaveData[name] ~= nil and _G.SaveData[name] or default
end

LoadSettings()

-- ========================================
-- WORLD DETECTION
-- ========================================
local placeId = game.PlaceId
local World1 = (placeId == 2753915549 or placeId == 85211729168715)
local World2 = (placeId == 4442272183 or placeId == 79091703265657)
local World3 = (placeId == 7449423635 or placeId == 100117331123089)

local Sea = World1 and "First Sea" or World2 and "Second Sea" or World3 and "Third Sea" or "Unknown"

-- ========================================
-- GLOBAL VARIABLES
-- ========================================
getgenv().TweenSpeedFar = GetSetting("TweenSpeedFar", 300)
getgenv().TweenSpeedNear = GetSetting("TweenSpeedNear", 900)

_G.AutoKen = GetSetting("AutoKen", true)
_G.AntiAFK = GetSetting("AntiAFK", true)
_G.FullBright = GetSetting("FullBright", false)

-- ========================================
-- TWEEN PART SETUP
-- ========================================
local TweenPart = Instance.new("Part")
TweenPart.Name = "KuKi_TweenPart"
TweenPart.Size = Vector3.new(1, 1, 1)
TweenPart.Anchored = true
TweenPart.CanCollide = false
TweenPart.CanTouch = false
TweenPart.Transparency = 1
TweenPart.Parent = Workspace

function _tp(targetCFrame)
    local char = plr.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local distance = (targetCFrame.Position - hrp.Position).Magnitude
    local speed = distance <= 90 and getgenv().TweenSpeedNear or getgenv().TweenSpeedFar
    
    local tweenInfo = TweenInfo.new(
        distance / speed,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(TweenPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    repeat
        task.wait()
    until tween.PlaybackState == Enum.PlaybackState.Completed
end

function notween(targetCFrame)
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = targetCFrame
    end
end

-- ========================================
-- HELPER FUNCTIONS
-- ========================================
function Hop()
    pcall(function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"
        local _place = game.PlaceId
        local _servers = Api .. _place .. "/servers/Public?sortOrder=Asc&limit=100"
        
        local function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor=" .. cursor) or ""))
            return Http:JSONDecode(Raw)
        end
        
        local Server, Next
        repeat
            local Servers = ListServers(Next)
            Server = Servers.data[1]
            Next = Servers.nextPageCursor
        until Server
        
        TPS:TeleportToPlaceInstance(_place, Server.id, plr)
    end)
end

function GetTeam()
    return plr.Team and plr.Team.Name or "None"
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

-- ========================================
-- AUTO OBSERVATION HAKI (KEN)
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
        VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
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
-- WAIT FOR GAME LOAD
-- ========================================
repeat
    task.wait()
until game:IsLoaded() and plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

-- ========================================
-- TABS CREATION
-- ========================================
local Tab0 = Window:Tab("Info", 14477284625)        -- Info Tab
local Tab1 = Window:Tab("Status", 7040410130)       -- Status/Server Tab
local Tab2 = Window:Tab("Farming", 10709769508)     -- Auto Farm Tab
local Tab3 = Window:Tab("Quests", 10734943448)      -- Quests/Items Tab
local Tab4 = Window:Tab("Settings", 10734950020)    -- Farm Settings Tab
local Tab5 = Window:Tab("Fishing", 127664059821666) -- Auto Fishing Tab
local Tab6 = Window:Tab("Sea Event", 10747376931)   -- Sea Event Tab
local Tab7 = Window:Tab("Volcano", 10734897956)     -- Volcano/Dojo Tab
local Tab8 = Window:Tab("Mirage", 10734920149)      -- Mirage/Race Tab
local Tab9 = Window:Tab("Fruits", 10709790875)      -- Fruits/Stock Tab
local Tab10 = Window:Tab("Raid", 10723404337)       -- Raid/Dungeon Tab
local Tab11 = Window:Tab("Teleport", 10734906975)   -- Teleport/World Tab
local Tab12 = Window:Tab("PvP", 10734975692)        -- PvP/Player Tab
local Tab13 = Window:Tab("ESP", 10723346959)        -- Esp/Stats Tab
local Tab14 = Window:Tab("Shop", 10734952479)       -- Shop Tab
local Tab15 = Window:Tab("Misc", 10734950309)       -- Misc Settings Tab

-- ========================================
-- TAB 0: INFO TAB
-- ========================================
Tab0:AddSection({"Profile Information"})

Tab0:AddProfile({
    Name = "KuKi Hub | True V2",
    Bio = "Premium Blox Fruits Script\nMade with ❤️ for the community",
    Avatar = "rbxassetid://75089236463451",
    Cover = "rbxassetid://113942234405258",
    Verified = true
})

Tab0:AddParagraph({
    Title = "📋 Script Information",
    Desc = "• KuKi Hub | True V2\n• Version: 2.0.0\n• Created: 2026\n• Last Updated: " .. os.date("%d/%m/%Y") .. "\n• Current Sea: " .. Sea
})

Tab0:AddParagraph({
    Title = "👤 Player Information",
    Desc = "• Name: " .. plr.Name .. "\n• Display Name: " .. plr.DisplayName .. "\n• UserId: " .. plr.UserId .. "\n• Account Age: " .. plr.AccountAge .. " days"
})

local statsPara = Tab0:AddParagraph({
    Title = "📊 Player Stats",
    Desc = "Loading..."
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            statsPara:SetDesc(string.format(
                "• Level: %d\n• Beli: $%s\n• Fragments: %s\n• Race: %s\n• Team: %s",
                GetLevel(),
                tostring(GetBeli()):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""),
                tostring(GetFragments()):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""),
                GetRace(),
                GetTeam()
            ))
        end)
    end
end)

Tab0:AddSection({"Announcements"})

Tab0:AddParagraph({
    Title = "🔔 Notice",
    Desc = "• Script is fully automated\n• Use at your own risk\n• Join our Discord for updates\n• Report bugs in our server"
})

Tab0:AddSingleDiscordCard({
    Title = "Join Our Discord",
    Description = "Get updates, support, and chat with the community!",
    Logo = "rbxassetid://134852113716171",
    Banner = "rbxassetid://123427419242741",
    Members = 5000,
    Online = 1500,
    Invite = "https://discord.gg/kuKihub"
})

Tab0:AddButton({
    Name = "Copy Discord Invite",
    Callback = function()
        setclipboard("https://discord.gg/kuKihub")
        library:Notification({
            Title = "KuKi Hub",
            Message = "Discord invite copied to clipboard!",
            Duration = 3
        })
    end
})

-- ========================================
-- TAB 1: STATUS TAB
-- ========================================
Tab1:AddSection({"⏰ Time & Date"})

local timeDisplay = Tab1:AddParagraph({
    Title = "Current Time",
    Desc = "Loading..."
})

local gameTimeDisplay = Tab1:AddParagraph({
    Title = "In-Game Time",
    Desc = "Loading..."
})

task.spawn(function()
    while task.wait(0.5) do
        -- Real Time
        local date = os.date("*t")
        local ampm = date.hour >= 12 and "PM" or "AM"
        local hour12 = date.hour % 12
        if hour12 == 0 then hour12 = 12 end
        local timeStr = string.format("%02d:%02d:%02d %s - %02d/%02d/%04d", 
            hour12, date.min, date.sec, ampm, date.day, date.month, date.year)
        timeDisplay:SetDesc(timeStr)
        
        -- Game Time
        pcall(function()
            local gameTime = math.floor(Workspace.DistributedGameTime + 0.5)
            local hour = math.floor(gameTime / 3600) % 24
            local minute = math.floor(gameTime / 60) % 60
            local second = gameTime % 60
            gameTimeDisplay:SetDesc(string.format("%02d:%02d:%02d (24h Format)", hour, minute, second))
        end)
    end
end)

Tab1:AddSection({"🌍 Server Information"})

local serverInfo = Tab1:AddParagraph({
    Title = "Server Info",
    Desc = "Loading..."
})

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local playerCount = #Players:GetPlayers()
            local maxPlayers = Players.MaxPlayers
            local jobId = game.JobId
            local placeVersion = game.PlaceVersion
            
            serverInfo:SetDesc(string.format(
                "• Place ID: %d\n• Job ID: %s\n• Version: %d\n• Players: %d/%d\n• Ping: %d ms",
                placeId,
                jobId:sub(1, 8) .. "...",
                placeVersion,
                playerCount,
                maxPlayers,
                math.floor(plr:GetNetworkPing() * 1000)
            ))
        end)
    end
end)

Tab1:AddButton({
    Name = "Copy Job ID",
    Callback = function()
        setclipboard(game.JobId)
        library:Notification({
            Title = "Server",
            Message = "Job ID copied!",
            Duration = 2
        })
    end
})

Tab1:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, plr)
    end
})

Tab1:AddButton({
    Name = "Hop Server",
    Callback = function()
        Hop()
        library:Notification({
            Title = "Server Hop",
            Message = "Searching for new server...",
            Duration = 3
        })
    end
})

Tab1:AddButton({
    Name = "Hop to Low Player Server",
    Callback = function()
        Hop()
        library:Notification({
            Title = "Server Hop",
            Message = "Looking for server with fewer players...",
            Duration = 3
        })
    end
})

Tab1:AddSection({"🏝️ Island Status"})

local mirageStatus = Tab1:AddParagraph({
    Title = "Mirage Island",
    Desc = "Checking..."
})

local kitsuneStatus = Tab1:AddParagraph({
    Title = "Kitsune Island",
    Desc = "Checking..."
})

local prehistoricStatus = Tab1:AddParagraph({
    Title = "Prehistoric Island",
    Desc = "Checking..."
})

local frozenStatus = Tab1:AddParagraph({
    Title = "Frozen Dimension",
    Desc = "Checking..."
})

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            -- Mirage Island
            local hasMirage = Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") ~= nil
            mirageStatus:SetDesc(hasMirage and "✅ Spawned" or "❌ Not Spawned")
            
            -- Kitsune Island
            local hasKitsune = Workspace.Map:FindFirstChild("KitsuneIsland") ~= nil or 
                              Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") ~= nil
            kitsuneStatus:SetDesc(hasKitsune and "✅ Spawned" or "❌ Not Spawned")
            
            -- Prehistoric Island
            local hasPrehistoric = Workspace.Map:FindFirstChild("PrehistoricIsland") ~= nil or 
                                   Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") ~= nil
            prehistoricStatus:SetDesc(hasPrehistoric and "✅ Spawned" or "❌ Not Spawned")
            
            -- Frozen Dimension
            local hasFrozen = Workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") ~= nil
            frozenStatus:SetDesc(hasFrozen and "✅ Spawned" or "❌ Not Spawned")
        end)
    end
end)

Tab1:AddSection({"🌙 Moon Phase"})

local moonPhase = Tab1:AddParagraph({
    Title = "Current Moon",
    Desc = "Checking..."
})

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local moonId = ""
            if World1 or World2 then
                moonId = Lighting.FantasySky and Lighting.FantasySky.MoonTextureId or ""
            elseif World3 then
                moonId = Lighting.Sky and Lighting.Sky.MoonTextureId or ""
            end
            
            local phase = "0/8 (New Moon)"
            if moonId:find("9709139597") then phase = "1/8"
            elseif moonId:find("9709143733") then phase = "2/8"
            elseif moonId:find("9709149052") then phase = "3/8"
            elseif moonId:find("9709149431") then phase = "4/8 (Full Moon) 🌕"
            elseif moonId:find("9709149680") then phase = "5/8"
            elseif moonId:find("9709150086") then phase = "6/8"
            elseif moonId:find("9709150401") then phase = "7/8"
            elseif moonId:find("9709135895") then phase = "0/8 (New Moon)"
            end
            
            moonPhase:SetDesc(phase)
        end)
    end
end)

Tab1:AddSection({"👑 Boss Status"})

local doughKingStatus = Tab1:AddParagraph({
    Title = "Dough King",
    Desc = "Checking..."
})

local ripIndraStatus = Tab1:AddParagraph({
    Title = "Rip Indra",
    Desc = "Checking..."
})

local cakePrinceStatus = Tab1:AddParagraph({
    Title = "Cake Prince",
    Desc = "Checking..."
})

task.spawn(function()
    while task.wait(3) do
        pcall(function()
            -- Dough King
            local hasDough = ReplicatedStorage:FindFirstChild("Dough King") ~= nil or
                            Workspace.Enemies:FindFirstChild("Dough King") ~= nil
            doughKingStatus:SetDesc(hasDough and "✅ Spawned" or "❌ Not Spawned")
            
            -- Rip Indra
            local hasIndra = ReplicatedStorage:FindFirstChild("rip_indra True Form") ~= nil or
                            Workspace.Enemies:FindFirstChild("rip_indra") ~= nil
            ripIndraStatus:SetDesc(hasIndra and "✅ Spawned" or "❌ Not Spawned")
            
            -- Cake Prince
            local princeSpawned = Workspace.Enemies:FindFirstChild("Cake Prince") ~= nil
            cakePrinceStatus:SetDesc(princeSpawned and "✅ Spawned" or "❌ Not Spawned")
        end)
    end
end)

Tab1:AddSection({"⚔️ Elite Hunter"})

local eliteStatus = Tab1:AddParagraph({
    Title = "Elite Hunter Progress",
    Desc = "Checking..."
})

task.spawn(function()
    while task.wait(5) do
        pcall(function()
            local progress = commF:InvokeServer("EliteHunter", "Progress")
            local hasElite = ReplicatedStorage:FindFirstChild("Diablo") or 
                            ReplicatedStorage:FindFirstChild("Deandre") or 
                            ReplicatedStorage:FindFirstChild("Urban") or
                            Workspace.Enemies:FindFirstChild("Diablo") or
                            Workspace.Enemies:FindFirstChild("Deandre") or
                            Workspace.Enemies:FindFirstChild("Urban")
            
            eliteStatus:SetDesc(string.format("Killed: %d/30 | %s", 
                progress or 0, 
                hasElite and "✅ Boss Spawned" or "❌ No Boss"
            ))
        end)
    end
end)

Tab1:AddSection({"🎣 Sea Events"})

local seaBeastStatus = Tab1:AddParagraph({
    Title = "Sea Beast",
    Desc = "Checking..."
})

local terrorSharkStatus = Tab1:AddParagraph({
    Title = "Terror Shark",
    Desc = "Checking..."
})

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local hasSeaBeast = Workspace.SeaBeasts:FindFirstChild("SeaBeast1") ~= nil
            seaBeastStatus:SetDesc(hasSeaBeast and "✅ Spawned" or "❌ Not Spawned")
            
            local hasTerror = Workspace.Enemies:FindFirstChild("Terrorshark") ~= nil
            terrorSharkStatus:SetDesc(hasTerror and "✅ Spawned" or "❌ Not Spawned")
        end)
    end
end)

print("========================================")
print("KuKi Hub | True V2 - Part 1 Loaded!")
print("Info Tab + Status Tab Complete!")
print("========================================")

--[[
    KuKi Hub | True V2
    Part 2: Farming Tab - Complete Auto Farm System
]]

-- ========================================
-- FARMING TAB SETUP
-- ========================================
local FarmMain = Tab2:CraftPage(1)
local FarmSettings = Tab2:CraftPage(2)
local FarmBoss = Tab2:CraftPage(3)
local FarmMastery = Tab2:CraftPage(4)

-- ========================================
-- GLOBAL FARM VARIABLES
-- ========================================
_G.ChooseWP = GetSetting("ChooseWP", "Melee")
_G.SelectWeapon = "Melee"
_G.SelectedFarmMode = GetSetting("SelectedFarmMode", "Level")
_G.StartFarm = false

-- Farm Toggles
_G.Level = false
_G.AutoFarm_Bone = false
_G.AutoFarm_Cake = false
_G.AutoMaterial = false
_G.AutoFarmNear = false
_G.AutoTyrant = false

-- Settings
_G.AcceptQuest = GetSetting("AcceptQuest", false)
_G.MobHeight = GetSetting("MobHeight", 20)
_G.BringRange = GetSetting("BringRange", 235)
_G.MaxFarmDistance = GetSetting("MaxFarmDistance", 325)
_G.MaxBringMobs = GetSetting("MaxBringMobs", 3)

-- Boss Farm
_G.AutoBoss = false
_G.FarmAllBoss = false
_G.FindBoss = Boss[1] or "The Gorilla King"
_G.AutoAcceptQuestBoss = false

-- Material Farm
getgenv().SelectMaterial = MaterialList[1]
getgenv().AutoMaterial = false

-- Mastery Farm
_G.FarmMastery_Dev = false
_G.FarmMastery_G = false
_G.FarmMastery_S = false
_G.SelectedIsland = GetSetting("SelectedIsland", "Cake")

-- ========================================
-- HELPER FUNCTIONS FOR FARMING
-- ========================================
function EquipWeapon(toolName)
    if not toolName then return end
    local char = plr.Character
    if not char then return end
    local tool = plr.Backpack:FindFirstChild(toolName) or char:FindFirstChild(toolName)
    if tool and char:FindFirstChild("Humanoid") then
        char.Humanoid:EquipTool(tool)
    end
end

function weaponSc(toolTip)
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == toolTip then
            EquipWeapon(tool.Name)
            return true
        end
    end
    return false
end

function GetBP(itemName)
    return plr.Backpack:FindFirstChild(itemName) or plr.Character:FindFirstChild(itemName)
end

function GetConnectionEnemies(target)
    if typeof(target) == "table" then
        for _, name in ipairs(target) do
            for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                if enemy.Name == name and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    return enemy
                end
            end
        end
    else
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            if enemy.Name == target and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                return enemy
            end
        end
    end
    return nil
end

local G = {}
G.Alive = function(mob)
    if not mob then return false end
    local hum = mob:FindFirstChild("Humanoid")
    return hum and hum.Health > 0
end

G.Kill = function(mob, enabled)
    if not mob or not enabled then return end
    local hrp = mob:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not mob:GetAttribute("Locked") then
        mob:SetAttribute("Locked", hrp.CFrame)
    end
    
    EquipWeapon(_G.SelectWeapon)
    _tp(hrp.CFrame * CFrame.new(0, _G.MobHeight, 0))
end

-- Bring Mobs System
local BringConnections = {}
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
                        
                        local tween = TweenService:Create(root, 
                            TweenInfo.new(0.45, Enum.EasingStyle.Linear), 
                            {CFrame = CFrame.new(PosMon)}
                        )
                        tween:Play()
                        tween.Completed:Once(function()
                            if root then root:SetAttribute("Tweening", false) end
                        end)
                    end
                end
            end
        end
    end)
end

function FarmAtivo()
    return _G.StartFarm and (
        _G.Level or 
        _G.AutoFarm_Bone or 
        _G.AutoFarm_Cake or 
        _G.AutoMaterial or
        _G.AutoFarmNear or
        _G.AutoTyrant or
        _G.FarmMastery_Dev or
        _G.FarmMastery_G or
        _G.FarmMastery_S
    )
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
-- QUEST SYSTEM
-- ========================================
local QuestData = {
    -- World 1 Quests
    ["Bandit"] = {Name = "BanditQuest1", Level = 1, QuestPos = CFrame.new(1059.96, 16.5, 1550.82), MobPos = CFrame.new(1045.96, 27, 1560.82)},
    ["Monkey"] = {Name = "JungleQuest", Level = 2, QuestPos = CFrame.new(-1601.65, 36.85, 153.38), MobPos = CFrame.new(-1448.51, 67.85, 11.46)},
    ["Gorilla"] = {Name = "JungleQuest", Level = 3, QuestPos = CFrame.new(-1601.65, 36.85, 153.38), MobPos = CFrame.new(-1129.88, 40.46, -525.42)},
    ["Pirate"] = {Name = "BuggyQuest1", Level = 1, QuestPos = CFrame.new(-1140.17, 4.75, 3827.40), MobPos = CFrame.new(-1103.51, 13.75, 3896.09)},
    ["Brute"] = {Name = "BuggyQuest1", Level = 2, QuestPos = CFrame.new(-1140.17, 4.75, 3827.40), MobPos = CFrame.new(-1140.08, 14.80, 4322.92)},
    ["Desert Bandit"] = {Name = "DesertQuest", Level = 1, QuestPos = CFrame.new(894.48, 5.14, 4392.43), MobPos = CFrame.new(924.79, 6.44, 4481.58)},
    ["Desert Officer"] = {Name = "DesertQuest", Level = 2, QuestPos = CFrame.new(894.48, 5.14, 4392.43), MobPos = CFrame.new(1608.28, 8.61, 4371.00)},
    ["Snow Bandit"] = {Name = "SnowQuest", Level = 1, QuestPos = CFrame.new(1386.80, 87.27, -1298.35), MobPos = CFrame.new(1354.34, 87.27, -1393.94)},
    ["Snowman"] = {Name = "SnowQuest", Level = 2, QuestPos = CFrame.new(1386.80, 87.27, -1298.35), MobPos = CFrame.new(1201.64, 144.57, -1550.06)},
    ["Chief Petty Officer"] = {Name = "MarineQuest2", Level = 1, QuestPos = CFrame.new(-5036.24, 28.67, 4324.56), MobPos = CFrame.new(-4881.23, 22.65, 4273.75)},
    ["Sky Bandit"] = {Name = "SkyQuest", Level = 1, QuestPos = CFrame.new(-4839.53, 716.36, -2619.44), MobPos = CFrame.new(-4953.20, 295.74, -2899.22)},
    ["Dark Master"] = {Name = "SkyQuest", Level = 2, QuestPos = CFrame.new(-4839.53, 716.36, -2619.44), MobPos = CFrame.new(-5259.84, 391.39, -2229.03)},
    ["Prisoner"] = {Name = "PrisonerQuest", Level = 1, QuestPos = CFrame.new(5308.93, 1.65, 475.12), MobPos = CFrame.new(5098.97, -0.32, 474.23)},
    ["Dangerous Prisoner"] = {Name = "PrisonerQuest", Level = 2, QuestPos = CFrame.new(5308.93, 1.65, 475.12), MobPos = CFrame.new(5654.56, 15.63, 866.29)},
    ["Toga Warrior"] = {Name = "ColosseumQuest", Level = 1, QuestPos = CFrame.new(-1580.04, 6.35, -2986.47), MobPos = CFrame.new(-1820.21, 51.68, -2740.66)},
    ["Gladiator"] = {Name = "ColosseumQuest", Level = 2, QuestPos = CFrame.new(-1580.04, 6.35, -2986.47), MobPos = CFrame.new(-1292.83, 56.38, -3339.03)},
    ["Military Soldier"] = {Name = "MagmaQuest", Level = 1, QuestPos = CFrame.new(-5314.62, 12.26, 8517.27), MobPos = CFrame.new(-5411.16, 11.08, 8454.29)},
    ["Military Spy"] = {Name = "MagmaQuest", Level = 2, QuestPos = CFrame.new(-5314.62, 12.26, 8517.27), MobPos = CFrame.new(-5802.86, 86.26, 8828.85)},
    ["Fishman Warrior"] = {Name = "FishmanQuest", Level = 1, QuestPos = CFrame.new(61122.65, 18.49, 1569.39), MobPos = CFrame.new(60878.30, 18.48, 1543.75)},
    ["Fishman Commando"] = {Name = "FishmanQuest", Level = 2, QuestPos = CFrame.new(61122.65, 18.49, 1569.39), MobPos = CFrame.new(61922.63, 18.48, 1493.93)},
    ["God's Guard"] = {Name = "SkyExp1Quest", Level = 1, QuestPos = CFrame.new(-7861.94, 5545.51, -379.85), MobPos = CFrame.new(-4710.04, 845.27, -1927.30)},
    ["Shanda"] = {Name = "SkyExp1Quest", Level = 2, QuestPos = CFrame.new(-7861.94, 5545.51, -379.85), MobPos = CFrame.new(-7678.48, 5566.40, -497.21)},
    ["Royal Squad"] = {Name = "SkyExp2Quest", Level = 1, QuestPos = CFrame.new(-7903.38, 5635.98, -1410.92), MobPos = CFrame.new(-7624.25, 5658.13, -1467.35)},
    ["Royal Soldier"] = {Name = "SkyExp2Quest", Level = 2, QuestPos = CFrame.new(-7903.38, 5635.98, -1410.92), MobPos = CFrame.new(-7836.75, 5645.66, -1790.62)},
    ["Galley Pirate"] = {Name = "FountainQuest", Level = 1, QuestPos = CFrame.new(5258.27, 38.52, 4050.04), MobPos = CFrame.new(5551.02, 78.90, 3930.41)},
    ["Galley Captain"] = {Name = "FountainQuest", Level = 2, QuestPos = CFrame.new(5258.27, 38.52, 4050.04), MobPos = CFrame.new(5441.95, 42.50, 4950.09)},
    
    -- World 2 Quests
    ["Raider"] = {Name = "Area1Quest", Level = 1, QuestPos = CFrame.new(-427.56, 73.31, 1835.42), MobPos = CFrame.new(-728.32, 52.77, 2345.77)},
    ["Mercenary"] = {Name = "Area1Quest", Level = 2, QuestPos = CFrame.new(-427.56, 73.31, 1835.42), MobPos = CFrame.new(-1004.32, 80.15, 1424.61)},
    ["Swan Pirate"] = {Name = "Area2Quest", Level = 1, QuestPos = CFrame.new(636.79, 73.41, 918.00), MobPos = CFrame.new(1068.66, 137.61, 1322.10)},
    ["Factory Staff"] = {Name = "Area2Quest", Level = 2, QuestPos = CFrame.new(636.79, 73.41, 918.00), MobPos = CFrame.new(73.07, 81.86, -27.47)},
    ["Marine Lieutenant"] = {Name = "MarineQuest3", Level = 1, QuestPos = CFrame.new(-2441.98, 73.35, -3217.53), MobPos = CFrame.new(-2821.37, 75.89, -3070.08)},
    ["Marine Captain"] = {Name = "MarineQuest3", Level = 2, QuestPos = CFrame.new(-2441.98, 73.35, -3217.53), MobPos = CFrame.new(-1861.23, 80.17, -3254.69)},
    ["Zombie"] = {Name = "ZombieQuest", Level = 1, QuestPos = CFrame.new(-5497.06, 47.59, -795.23), MobPos = CFrame.new(-5657.77, 78.96, -928.68)},
    ["Vampire"] = {Name = "ZombieQuest", Level = 2, QuestPos = CFrame.new(-5497.06, 47.59, -795.23), MobPos = CFrame.new(-6037.66, 32.18, -1340.65)},
    ["Snow Trooper"] = {Name = "SnowMountainQuest", Level = 1, QuestPos = CFrame.new(609.85, 400.11, -5372.25), MobPos = CFrame.new(549.14, 427.38, -5563.69)},
    ["Winter Warrior"] = {Name = "SnowMountainQuest", Level = 2, QuestPos = CFrame.new(609.85, 400.11, -5372.25), MobPos = CFrame.new(1142.74, 475.63, -5199.41)},
    ["Lab Subordinate"] = {Name = "IceSideQuest", Level = 1, QuestPos = CFrame.new(-6064.06, 15.24, -4902.97), MobPos = CFrame.new(-5707.47, 15.95, -4513.39)},
    ["Horned Warrior"] = {Name = "IceSideQuest", Level = 2, QuestPos = CFrame.new(-6064.06, 15.24, -4902.97), MobPos = CFrame.new(-6341.36, 15.95, -5723.16)},
    ["Magma Ninja"] = {Name = "FireSideQuest", Level = 1, QuestPos = CFrame.new(-5429.04, 15.97, -5297.96), MobPos = CFrame.new(-5449.67, 76.65, -5808.20)},
    ["Lava Pirate"] = {Name = "FireSideQuest", Level = 2, QuestPos = CFrame.new(-5429.04, 15.97, -5297.96), MobPos = CFrame.new(-5213.33, 49.73, -4701.45)},
    ["Ship Deckhand"] = {Name = "ShipQuest1", Level = 1, QuestPos = CFrame.new(1037.80, 125.09, 32911.60), MobPos = CFrame.new(1212.01, 150.79, 33059.24)},
    ["Ship Engineer"] = {Name = "ShipQuest1", Level = 2, QuestPos = CFrame.new(1037.80, 125.09, 32911.60), MobPos = CFrame.new(919.47, 43.54, 32779.96)},
    ["Ship Steward"] = {Name = "ShipQuest2", Level = 1, QuestPos = CFrame.new(968.80, 125.09, 33244.12), MobPos = CFrame.new(919.43, 129.55, 33436.03)},
    ["Ship Officer"] = {Name = "ShipQuest2", Level = 2, QuestPos = CFrame.new(968.80, 125.09, 33244.12), MobPos = CFrame.new(1036.01, 181.43, 33315.72)},
    ["Arctic Warrior"] = {Name = "FrostQuest", Level = 1, QuestPos = CFrame.new(5668.97, 28.51, -6483.35), MobPos = CFrame.new(5966.24, 62.97, -6179.38)},
    ["Snow Lurker"] = {Name = "FrostQuest", Level = 2, QuestPos = CFrame.new(5668.97, 28.51, -6483.35), MobPos = CFrame.new(5407.07, 69.19, -6880.88)},
    ["Sea Soldier"] = {Name = "ForgottenQuest", Level = 1, QuestPos = CFrame.new(-3053.98, 237.18, -10145.03), MobPos = CFrame.new(-3028.22, 64.67, -9775.42)},
    ["Water Fighter"] = {Name = "ForgottenQuest", Level = 2, QuestPos = CFrame.new(-3053.98, 237.18, -10145.03), MobPos = CFrame.new(-3352.90, 285.01, -10534.84)},
    
    -- World 3 Quests
    ["Pirate Millionaire"] = {Name = "PiratePortQuest", Level = 1, QuestPos = CFrame.new(-289.76, 43.81, 5579.93), MobPos = CFrame.new(-246.00, 47.31, 5584.10)},
    ["Pistol Billionaire"] = {Name = "PiratePortQuest", Level = 2, QuestPos = CFrame.new(-289.76, 43.81, 5579.93), MobPos = CFrame.new(-187.33, 86.24, 6013.51)},
    ["Dragon Crew Warrior"] = {Name = "DragonCrewQuest", Level = 1, QuestPos = CFrame.new(6737.06, 127.41, -712.30), MobPos = CFrame.new(6709.76, 52.34, -1139.02)},
    ["Dragon Crew Archer"] = {Name = "DragonCrewQuest", Level = 2, QuestPos = CFrame.new(6737.06, 127.41, -712.30), MobPos = CFrame.new(6668.76, 481.37, 329.12)},
    ["Female Islander"] = {Name = "AmazonQuest1", Level = 1, QuestPos = CFrame.new(4692.79, 797.97, 858.84), MobPos = CFrame.new(4692.79, 797.97, 858.84)},
    ["Giant Islander"] = {Name = "AmazonQuest1", Level = 2, QuestPos = CFrame.new(4692.79, 797.97, 858.84), MobPos = CFrame.new(4692.79, 797.97, 858.84)},
    ["Marine Commodore"] = {Name = "MarineTreeIsland", Level = 1, QuestPos = CFrame.new(2180.54, 27.81, -6741.54), MobPos = CFrame.new(2286.00, 73.13, -7159.80)},
    ["Marine Rear Admiral"] = {Name = "MarineTreeIsland", Level = 2, QuestPos = CFrame.new(2180.54, 27.81, -6741.54), MobPos = CFrame.new(3656.77, 160.52, -7001.59)},
    ["Fishman Raider"] = {Name = "DeepForestIsland3", Level = 1, QuestPos = CFrame.new(-10581.65, 330.87, -8761.18), MobPos = CFrame.new(-10407.52, 331.76, -8368.51)},
    ["Fishman Captain"] = {Name = "DeepForestIsland3", Level = 2, QuestPos = CFrame.new(-10581.65, 330.87, -8761.18), MobPos = CFrame.new(-10994.70, 352.38, -9002.11)},
    ["Forest Pirate"] = {Name = "DeepForestIsland", Level = 1, QuestPos = CFrame.new(-13234.04, 331.48, -7625.40), MobPos = CFrame.new(-13274.47, 332.37, -7769.58)},
    ["Mythological Pirate"] = {Name = "DeepForestIsland", Level = 2, QuestPos = CFrame.new(-13234.04, 331.48, -7625.40), MobPos = CFrame.new(-13680.60, 501.08, -6991.18)},
    ["Jungle Pirate"] = {Name = "DeepForestIsland2", Level = 1, QuestPos = CFrame.new(-12682.09, 390.88, -9902.12), MobPos = CFrame.new(-12256.16, 331.73, -10485.83)},
    ["Musketeer Pirate"] = {Name = "DeepForestIsland2", Level = 2, QuestPos = CFrame.new(-12682.09, 390.88, -9902.12), MobPos = CFrame.new(-13457.90, 391.54, -9859.17)},
    ["Reborn Skeleton"] = {Name = "HauntedQuest1", Level = 1, QuestPos = CFrame.new(-9479.21, 141.21, 5566.09), MobPos = CFrame.new(-8763.72, 165.72, 6159.86)},
    ["Living Zombie"] = {Name = "HauntedQuest1", Level = 2, QuestPos = CFrame.new(-9479.21, 141.21, 5566.09), MobPos = CFrame.new(-10144.13, 138.62, 5838.08)},
    ["Demonic Soul"] = {Name = "HauntedQuest2", Level = 1, QuestPos = CFrame.new(-9516.99, 172.01, 6078.46), MobPos = CFrame.new(-9505.87, 172.10, 6158.99)},
    ["Posessed Mummy"] = {Name = "HauntedQuest2", Level = 2, QuestPos = CFrame.new(-9516.99, 172.01, 6078.46), MobPos = CFrame.new(-9582.02, 6.25, 6205.47)},
    ["Peanut Scout"] = {Name = "NutsIslandQuest", Level = 1, QuestPos = CFrame.new(-2104.39, 38.10, -10194.21), MobPos = CFrame.new(-2143.24, 47.72, -10029.99)},
    ["Peanut President"] = {Name = "NutsIslandQuest", Level = 2, QuestPos = CFrame.new(-2104.39, 38.10, -10194.21), MobPos = CFrame.new(-1859.35, 38.10, -10422.42)},
    ["Ice Cream Chef"] = {Name = "IceCreamIslandQuest", Level = 1, QuestPos = CFrame.new(-819.37, 64.92, -10967.28), MobPos = CFrame.new(-872.24, 65.81, -10919.95)},
    ["Ice Cream Commander"] = {Name = "IceCreamIslandQuest", Level = 2, QuestPos = CFrame.new(-819.37, 64.92, -10967.28), MobPos = CFrame.new(-558.06, 112.04, -11290.77)},
    ["Cookie Crafter"] = {Name = "CakeQuest1", Level = 1, QuestPos = CFrame.new(-2021.32, 37.79, -12028.72), MobPos = CFrame.new(-2374.13, 37.79, -12125.30)},
    ["Cake Guard"] = {Name = "CakeQuest1", Level = 2, QuestPos = CFrame.new(-2021.32, 37.79, -12028.72), MobPos = CFrame.new(-1598.30, 43.77, -12244.58)},
    ["Baking Staff"] = {Name = "CakeQuest2", Level = 1, QuestPos = CFrame.new(-1927.91, 37.79, -12842.53), MobPos = CFrame.new(-1887.80, 77.61, -12998.35)},
    ["Head Baker"] = {Name = "CakeQuest2", Level = 2, QuestPos = CFrame.new(-1927.91, 37.79, -12842.53), MobPos = CFrame.new(-2216.18, 82.88, -12869.29)},
    ["Cocoa Warrior"] = {Name = "ChocQuest1", Level = 1, QuestPos = CFrame.new(233.22, 29.87, -12201.23), MobPos = CFrame.new(-21.55, 80.57, -12352.38)},
    ["Chocolate Bar Battler"] = {Name = "ChocQuest1", Level = 2, QuestPos = CFrame.new(233.22, 29.87, -12201.23), MobPos = CFrame.new(582.59, 77.18, -12463.16)},
    ["Sweet Thief"] = {Name = "ChocQuest2", Level = 1, QuestPos = CFrame.new(150.50, 30.69, -12774.50), MobPos = CFrame.new(165.18, 76.05, -12600.83)},
    ["Candy Rebel"] = {Name = "ChocQuest2", Level = 2, QuestPos = CFrame.new(150.50, 30.69, -12774.50), MobPos = CFrame.new(134.86, 77.24, -12876.54)},
}

function GetCurrentQuest()
    local level = GetLevel()
    local questList = {}
    
    for mobName, data in pairs(QuestData) do
        table.insert(questList, {Name = mobName, Data = data})
    end
    
    table.sort(questList, function(a, b)
        return math.abs(level - a.Data.Level) < math.abs(level - b.Data.Level)
    end)
    
    return questList[1]
end

function GetNearestMob(mobName)
    local char = plr.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest, minDist = nil, math.huge
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        if mob.Name == mobName and G.Alive(mob) and mob:FindFirstChild("HumanoidRootPart") then
            local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = mob
            end
        end
    end
    return closest
end

-- ========================================
-- FARM MAIN PAGE (PAGE 1)
-- ========================================
FarmMain:Seperator("⚔️ Main Farm Settings")

FarmMain:Dropdown({
    Name = "Select Weapon",
    Options = {"Melee", "Sword", "Blox Fruit", "Gun"},
    Default = GetSetting("ChooseWP", "Melee"),
    Callback = function(value)
        _G.ChooseWP = value
        _G.SaveData["ChooseWP"] = value
        SaveSettings()
    end
})

FarmMain:Dropdown({
    Name = "Select Farm Mode",
    Options = {"Level", "Bone", "Cake Prince", "Material"},
    Default = GetSetting("SelectedFarmMode", "Level"),
    Callback = function(value)
        _G.SelectedFarmMode = value
        _G.SaveData["SelectedFarmMode"] = value
        SaveSettings()
    end
})

FarmMain:Toggle({
    Name = "Start Farm",
    Default = false,
    Callback = function(value)
        _G.StartFarm = value
        _G.Level = false
        _G.AutoFarm_Bone = false
        _G.AutoFarm_Cake = false
        _G.AutoMaterial = false
        
        if value then
            if _G.SelectedFarmMode == "Level" then
                _G.Level = true
            elseif _G.SelectedFarmMode == "Bone" then
                _G.AutoFarm_Bone = true
            elseif _G.SelectedFarmMode == "Cake Prince" then
                _G.AutoFarm_Cake = true
            elseif _G.SelectedFarmMode == "Material" then
                _G.AutoMaterial = true
            end
        end
    end
})

FarmMain:Toggle({
    Name = "Accept Quests",
    Default = GetSetting("AcceptQuest", false),
    Callback = function(value)
        _G.AcceptQuest = value
        _G.SaveData["AcceptQuest"] = value
        SaveSettings()
    end
})

FarmMain:Seperator("📊 Farm Status")

local farmStatusLabel = FarmMain:Label("Farm Status: Inactive")
local currentMobLabel = FarmMain:Label("Current Mob: None")
local questStatusLabel = FarmMain:Label("Quest: None")

task.spawn(function()
    while task.wait(1) do
        local status = "Inactive"
        local mobName = "None"
        local questName = "None"
        
        if _G.StartFarm then
            if _G.Level then
                status = "Level Farming"
                local quest = GetCurrentQuest()
                if quest then
                    questName = quest.Name
                    mobName = quest.Name
                end
            elseif _G.AutoFarm_Bone then
                status = "Bone Farming"
                mobName = "Skeletons/Zombies"
            elseif _G.AutoFarm_Cake then
                status = "Cake Prince Farming"
                mobName = "Cake Mobs"
            elseif _G.AutoMaterial then
                status = "Material Farming"
                mobName = getgenv().SelectMaterial or "Unknown"
            end
        end
        
        farmStatusLabel:Set("Farm Status: " .. status)
        currentMobLabel:Set("Current Mob: " .. mobName)
        questStatusLabel:Set("Quest: " .. questName)
    end
end)

FarmMain:Seperator("🎯 Additional Farms")

FarmMain:Toggle({
    Name = "Kill Mobs Nearest",
    Default = GetSetting("AutoFarmNear", false),
    Callback = function(value)
        _G.AutoFarmNear = value
        _G.SaveData["AutoFarmNear"] = value
        SaveSettings()
    end
})

if World2 then
    FarmMain:Toggle({
        Name = "Auto Factory Raid",
        Default = GetSetting("AutoFactory", false),
        Callback = function(value)
            _G.AutoFactory = value
            _G.SaveData["AutoFactory"] = value
            SaveSettings()
        end
    })
end

if World3 then
    FarmMain:Toggle({
        Name = "Auto Pirate Raid",
        Default = GetSetting("AutoRaidCastle", false),
        Callback = function(value)
            _G.AutoRaidCastle = value
            _G.SaveData["AutoRaidCastle"] = value
            SaveSettings()
        end
    })
    
    FarmMain:Toggle({
        Name = "Auto Tyrant of the Skies",
        Default = GetSetting("AutoTyrant", false),
        Callback = function(value)
            _G.AutoTyrant = value
            _G.SaveData["AutoTyrant"] = value
            SaveSettings()
        end
    })
end

FarmMain:Seperator("📦 Collect")

FarmMain:Toggle({
    Name = "Auto Collect Chest",
    Default = GetSetting("AutoFarmChest", false),
    Callback = function(value)
        _G.AutoFarmChest = value
        _G.SaveData["AutoFarmChest"] = value
        SaveSettings()
    end
})

FarmMain:Toggle({
    Name = "Auto Collect Berry",
    Default = GetSetting("AutoBerry", false),
    Callback = function(value)
        _G.AutoBerry = value
        _G.SaveData["AutoBerry"] = value
        SaveSettings()
    end
})

-- ========================================
-- FARM SETTINGS PAGE (PAGE 2)
-- ========================================
FarmSettings:Seperator("⚙️ Farm Configuration")

FarmSettings:Slider({
    Name = "Distance Near Farm",
    Min = 0,
    Max = 5000,
    Default = GetSetting("MaxFarmDistance", 325),
    Callback = function(value)
        _G.MaxFarmDistance = value
        _G.SaveData["MaxFarmDistance"] = value
        SaveSettings()
    end
})

FarmSettings:Slider({
    Name = "Mob Height",
    Min = 5,
    Max = 100,
    Default = GetSetting("MobHeight", 20),
    Callback = function(value)
        _G.MobHeight = value
        _G.SaveData["MobHeight"] = value
        SaveSettings()
    end
})

FarmSettings:Slider({
    Name = "Bring Range",
    Min = 50,
    Max = 500,
    Default = GetSetting("BringRange", 235),
    Callback = function(value)
        _G.BringRange = value
        _G.SaveData["BringRange"] = value
        SaveSettings()
    end
})

FarmSettings:TextBox({
    Name = "Max Bring Mobs",
    Placeholder = "3",
    Default = tostring(GetSetting("MaxBringMobs", 3)),
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            _G.MaxBringMobs = num
            _G.SaveData["MaxBringMobs"] = num
            SaveSettings()
        end
    end
})

FarmSettings:TextBox({
    Name = "Tween Speed",
    Placeholder = "300",
    Default = tostring(GetSetting("TweenSpeedFar", 300)),
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            getgenv().TweenSpeedFar = num
            _G.SaveData["TweenSpeedFar"] = num
            SaveSettings()
        end
    end
})

FarmSettings:Seperator("⚡ Fast Attack Settings")

local AttackModes = {"Normal Attack", "Fast Attack", "Super Attack", "Bear Attack", "Super Bear Attack"}
local AttackDelays = {
    ["Normal Attack"] = 0.25,
    ["Fast Attack"] = 0.15,
    ["Super Attack"] = 0.05,
    ["Bear Attack"] = 0.1,
    ["Super Bear Attack"] = 0.01,
}

FarmSettings:Dropdown({
    Name = "Select Attack Mode",
    Options = AttackModes,
    Default = GetSetting("FastAttackMode", "Fast Attack"),
    Callback = function(value)
        _G.FastAttackMode = value
        _G.SaveData["FastAttackMode"] = value
        SaveSettings()
    end
})

FarmSettings:Toggle({
    Name = "Enable Fast Attack",
    Default = GetSetting("FastAttack", true),
    Callback = function(value)
        _G.FastAttack = value
        _G.SaveData["FastAttack"] = value
        SaveSettings()
    end
})

FarmSettings:Toggle({
    Name = "Enable Auto Click",
    Default = GetSetting("AutoClick", false),
    Callback = function(value)
        _G.AutoClick = value
        _G.SaveData["AutoClick"] = value
        SaveSettings()
    end
})

FarmSettings:Seperator("🛡️ Auto Skills")

FarmSettings:Toggle({
    Name = "Auto Active Haki",
    Default = GetSetting("AutoHaki", true),
    Callback = function(value)
        _G.AutoHaki = value
        _G.SaveData["AutoHaki"] = value
        SaveSettings()
    end
})

FarmSettings:Toggle({
    Name = "Auto Active V3",
    Default = GetSetting("AutoV3", false),
    Callback = function(value)
        _G.AutoV3 = value
        _G.SaveData["AutoV3"] = value
        SaveSettings()
    end
})

FarmSettings:Toggle({
    Name = "Auto Active V4",
    Default = GetSetting("AutoV4", false),
    Callback = function(value)
        _G.AutoV4 = value
        _G.SaveData["AutoV4"] = value
        SaveSettings()
    end
})

-- ========================================
-- BOSS FARM PAGE (PAGE 3)
-- ========================================
FarmBoss:Seperator("👑 Boss Farm")

local bossStatusPara = FarmBoss:AddParagraph({
    Title = "Boss Status",
    Desc = "No boss selected"
})

FarmBoss:Dropdown({
    Name = "Select Boss",
    Options = Boss,
    Default = _G.FindBoss,
    Callback = function(value)
        _G.FindBoss = value
        _G.SaveData["FindBoss"] = value
        SaveSettings()
    end
})

FarmBoss:Button({
    Name = "Refresh Boss List",
    Callback = function()
        local liveBosses = {}
        for _, boss in ipairs(Boss) do
            local found = Workspace.Enemies:FindFirstChild(boss) or ReplicatedStorage:FindFirstChild(boss)
            if found then
                table.insert(liveBosses, boss)
            end
        end
        if #liveBosses > 0 then
            bossStatusPara:SetDesc("Spawned: " .. table.concat(liveBosses, ", "))
        else
            bossStatusPara:SetDesc("No bosses currently spawned")
        end
    end
})

FarmBoss:Toggle({
    Name = "Auto Farm Boss Select",
    Default = GetSetting("AutoBoss", false),
    Callback = function(value)
        _G.AutoBoss = value
        _G.SaveData["AutoBoss"] = value
        SaveSettings()
        if value then _G.FarmAllBoss = false end
    end
})

FarmBoss:Toggle({
    Name = "Accept Quest Boss",
    Default = GetSetting("AutoAcceptQuestBoss", false),
    Callback = function(value)
        _G.AutoAcceptQuestBoss = value
        _G.SaveData["AutoAcceptQuestBoss"] = value
        SaveSettings()
    end
})

FarmBoss:Toggle({
    Name = "Farm All Bosses",
    Default = GetSetting("FarmAllBoss", false),
    Callback = function(value)
        _G.FarmAllBoss = value
        _G.SaveData["FarmAllBoss"] = value
        SaveSettings()
        if value then _G.AutoBoss = false end
    end
})

-- ========================================
-- MASTERY FARM PAGE (PAGE 4)
-- ========================================
if World3 then
    FarmMastery:Seperator("📈 Mastery Farm")
    
    local CAKE_MOBS = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}
    local BONE_MOBS = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}
    
    FarmMastery:Dropdown({
        Name = "Select Island For Mastery",
        Options = {"Cake", "Bone"},
        Default = GetSetting("SelectedIsland", "Cake"),
        Callback = function(value)
            _G.SelectedIsland = value
            _G.SaveData["SelectedIsland"] = value
            SaveSettings()
        end
    })
    
    FarmMastery:Toggle({
        Name = "Auto Farm Mastery Fruit",
        Default = GetSetting("FarmMastery_Dev", false),
        Callback = function(value)
            _G.FarmMastery_Dev = value
            _G.SaveData["FarmMastery_Dev"] = value
            SaveSettings()
        end
    })
    
    -- Fruit Skills
    _G.FruitSkills = _G.FruitSkills or {Z = false, X = false, C = false, V = false, F = false}
    
    FarmMastery:Toggle({Name = "Use Skill Z (Fruit)", Default = false, Callback = function(v) _G.FruitSkills.Z = v end})
    FarmMastery:Toggle({Name = "Use Skill X (Fruit)", Default = false, Callback = function(v) _G.FruitSkills.X = v end})
    FarmMastery:Toggle({Name = "Use Skill C (Fruit)", Default = false, Callback = function(v) _G.FruitSkills.C = v end})
    FarmMastery:Toggle({Name = "Use Skill V (Fruit)", Default = false, Callback = function(v) _G.FruitSkills.V = v end})
    FarmMastery:Toggle({Name = "Use Skill F (Fruit)", Default = false, Callback = function(v) _G.FruitSkills.F = v end})
    
    FarmMastery:Toggle({
        Name = "Auto Farm Mastery Gun",
        Default = GetSetting("FarmMastery_G", false),
        Callback = function(value)
            _G.FarmMastery_G = value
            _G.SaveData["FarmMastery_G"] = value
            SaveSettings()
        end
    })
    
    FarmMastery:Toggle({
        Name = "Auto Farm Mastery All Sword",
        Default = GetSetting("FarmMastery_S", false),
        Callback = function(value)
            _G.FarmMastery_S = value
            _G.SaveData["FarmMastery_S"] = value
            SaveSettings()
        end
    })
end

-- ========================================
-- FARM LOGIC LOOPS
-- ========================================

-- Weapon Auto-Select
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.ChooseWP then
                for _, tool in pairs(plr.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == _G.ChooseWP then
                        _G.SelectWeapon = tool.Name
                        break
                    end
                end
            end
        end)
    end
end)

-- Level Farm Logic
task.spawn(function()
    local currentMob = nil
    
    while task.wait() do
        if _G.Level and _G.StartFarm then
            pcall(function()
                local quest = GetCurrentQuest()
                if not quest then return end
                
                local questUI = plr.PlayerGui.Main.Quest
                
                -- Accept Quest
                if _G.AcceptQuest and not questUI.Visible then
                    _tp(quest.Data.QuestPos)
                    if (plr.Character.HumanoidRootPart.Position - quest.Data.QuestPos.Position).Magnitude <= 10 then
                        task.wait(0.5)
                        commF:InvokeServer("StartQuest", quest.Data.Name, quest.Data.Level)
                    end
                    return
                end
                
                -- Kill Mob
                if currentMob and G.Alive(currentMob) then
                    G.Kill(currentMob, true)
                else
                    currentMob = GetNearestMob(quest.Name)
                    if not currentMob then
                        _tp(quest.Data.MobPos)
                    end
                end
            end)
        else
            currentMob = nil
        end
    end
end)

-- Kill Nearest Logic
task.spawn(function()
    while task.wait() do
        if _G.AutoFarmNear then
            pcall(function()
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local closest, minDist = nil, math.huge
                for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                    if G.Alive(mob) and mob:FindFirstChild("HumanoidRootPart") then
                        local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < minDist and dist <= _G.MaxFarmDistance then
                            minDist = dist
                            closest = mob
                        end
                    end
                end
                
                if closest then
                    G.Kill(closest, true)
                end
            end)
        end
    end
end)

-- Bone Farm Logic (World 3)
if World3 then
    local BONE_MOBS = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}
    local boneNPC = CFrame.new(-9516.99, 172.01, 6078.46)
    local boneFarmPos = CFrame.new(-9495.68, 453.58, 5977.34)
    
    task.spawn(function()
        while task.wait() do
            if _G.AutoFarm_Bone and _G.StartFarm then
                pcall(function()
                    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    
                    local questUI = plr.PlayerGui.Main.Quest
                    
                    if _G.AcceptQuest and not questUI.Visible then
                        _tp(boneNPC)
                        if (hrp.Position - boneNPC.Position).Magnitude <= 5 then
                            task.wait(0.5)
                            local quests = {{"StartQuest","HauntedQuest1",1}, {"StartQuest","HauntedQuest1",2}, {"StartQuest","HauntedQuest2",1}, {"StartQuest","HauntedQuest2",2}}
                            commF:InvokeServer(unpack(quests[math.random(1, #quests)]))
                        end
                        return
                    end
                    
                    local closest = nil
                    local minDist = math.huge
                    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                        if table.find(BONE_MOBS, mob.Name) and G.Alive(mob) then
                            local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                closest = mob
                            end
                        end
                    end
                    
                    if closest then
                        G.Kill(closest, true)
                    else
                        _tp(boneFarmPos)
                    end
                end)
            end
        end
    end)
end

-- Cake Prince Farm Logic (World 3)
if World3 then
    local CAKE_MOBS = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}
    local cakeNPC = CFrame.new(-1927.92, 37.80, -12842.54)
    
    task.spawn(function()
        while task.wait() do
            if _G.AutoFarm_Cake and _G.StartFarm then
                pcall(function()
                    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    
                    local boss = Workspace.Enemies:FindFirstChild("Cake Prince") or Workspace.Enemies:FindFirstChild("Dough King")
                    local mirror = Workspace.Map:FindFirstChild("CakeLoaf") and Workspace.Map.CakeLoaf:FindFirstChild("BigMirror")
                    local portalOpen = mirror and mirror:FindFirstChild("Other") and mirror.Other.Transparency == 0
                    
                    if boss then
                        G.Kill(boss, true)
                        return
                    end
                    
                    if portalOpen then
                        _tp(CFrame.new(-2151.82, 149.32, -12404.91))
                        return
                    end
                    
                    local questUI = plr.PlayerGui.Main.Quest
                    if _G.AcceptQuest and not questUI.Visible then
                        _tp(cakeNPC)
                        if (hrp.Position - cakeNPC.Position).Magnitude <= 5 then
                            task.wait(0.5)
                            local quests = {{"StartQuest","CakeQuest2",2}, {"StartQuest","CakeQuest2",1}, {"StartQuest","CakeQuest1",1}, {"StartQuest","CakeQuest1",2}}
                            commF:InvokeServer(unpack(quests[math.random(1, 4)]))
                        end
                        return
                    end
                    
                    local closest = nil
                    local minDist = math.huge
                    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                        if table.find(CAKE_MOBS, mob.Name) and G.Alive(mob) then
                            local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                closest = mob
                            end
                        end
                    end
                    
                    if closest then
                        G.Kill(closest, true)
                    else
                        _tp(cakeNPC)
                    end
                end)
            end
        end
    end)
end

-- Auto Haki Loop
task.spawn(function()
    while task.wait(1) do
        if _G.AutoHaki then
            pcall(function()
                if plr.Character and not plr.Character:FindFirstChild("HasBuso") then
                    commF:InvokeServer("Buso")
                end
            end)
        end
    end
end)

-- Auto V3 Loop
task.spawn(function()
    while task.wait(30) do
        if _G.AutoV3 then
            pcall(function()
                commE:FireServer("ActivateAbility")
            end)
        end
    end
end)

-- Auto V4 Loop
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoV4 then
            pcall(function()
                local raceEnergy = plr.Character and plr.Character:FindFirstChild("RaceEnergy")
                if raceEnergy and raceEnergy.Value == 1 then
                    VirtualInputManager:SendKeyEvent(true, "Y", false, game)
                    VirtualInputManager:SendKeyEvent(false, "Y", false, game)
                end
            end)
        end
    end
end)

-- Boss Farm Logic
task.spawn(function()
    while task.wait() do
        if _G.AutoBoss and _G.FindBoss then
            pcall(function()
                local boss = Workspace.Enemies:FindFirstChild(_G.FindBoss) or ReplicatedStorage:FindFirstChild(_G.FindBoss)
                if boss and G.Alive(boss) then
                    G.Kill(boss, true)
                end
            end)
        end
    end
end)

-- Farm All Bosses Logic
task.spawn(function()
    while task.wait() do
        if _G.FarmAllBoss then
            pcall(function()
                for _, bossName in ipairs(Boss) do
                    local boss = Workspace.Enemies:FindFirstChild(bossName)
                    if boss and G.Alive(boss) then
                        G.Kill(boss, true)
                        break
                    end
                end
            end)
        end
    end
end)

-- Auto Collect Chest
task.spawn(function()
    while task.wait(1) do
        if _G.AutoFarmChest then
            pcall(function()
                local chests = CollectionService:GetTagged("_ChestTagged")
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local closest, minDist = nil, math.huge
                for _, chest in ipairs(chests) do
                    if not chest:GetAttribute("IsDisabled") then
                        local dist = (chest:GetPivot().Position - hrp.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = chest
                        end
                    end
                end
                
                if closest then
                    _tp(closest:GetPivot())
                end
            end)
        end
    end
end)

-- Auto Collect Berry
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoBerry then
            pcall(function()
                local bushes = CollectionService:GetTagged("BerryBush")
                for _, bush in ipairs(bushes) do
                    for _, child in pairs(bush.Parent:GetChildren()) do
                        if child:IsA("ProximityPrompt") then
                            _tp(child.Parent:GetPivot())
                            fireproximityprompt(child)
                        end
                    end
                end
            end)
        end
    end
end)

-- Fast Attack Logic
local function IsAlive(char)
    return char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0
end

task.spawn(function()
    while task.wait(0.1) do
        if _G.FastAttack then
            pcall(function()
                local char = plr.Character
                if char and IsAlive(char) then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        if _G.AutoClick then
                            VirtualUser:CaptureController()
                            VirtualUser:Button1Down(Vector2.new(1280, 672))
                        end
                    end
                end
            end)
        end
    end
end)

-- Material Farm Logic
task.spawn(function()
    while task.wait() do
        if getgenv().AutoMaterial and getgenv().SelectMaterial then
            pcall(function()
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local closest, minDist = nil, math.huge
                for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                    if G.Alive(mob) then
                        local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = mob
                        end
                    end
                end
                
                if closest then
                    G.Kill(closest, true)
                end
            end)
        end
    end
end)

print("========================================")
print("KuKi Hub | True V2 - Part 2 Loaded!")
print("Farming Tab Complete!")
print("========================================")

--[[
    KuKi Hub | True V2
    Part 3: Quests/Items Tab - Quest Automation & Item Farming
]]

-- ========================================
-- QUESTS TAB SETUP
-- ========================================
local QuestMain = Tab3:CraftPage(1)      -- Main Quests
local QuestTravel = Tab3:CraftPage(2)    -- Travel Quests
local QuestItems = Tab3:CraftPage(3)     -- Item Farming
local QuestSwords = Tab3:CraftPage(4)    -- Sword Quests

-- ========================================
-- GLOBAL QUEST VARIABLES
-- ========================================
_G.TravelDres = false
_G.AutoZou = false
_G.obsFarm = false
_G.AutoKenVTWO = false
_G.FarmEliteHunt = false
_G.StopWhenChalice = false
_G.Auto_Tushita = false
_G.Auto_Yama = false
_G.CitizenQuest = false
_G.Auto_Rainbow_Haki = false
_G.GetQFast = false

-- Item Farms
_G.AutoSaw = false
_G.SwanCoat = false
_G.MarinesCoat = false
_G.WardenBoss = false
_G.AutoColShad = false
_G.AutoEcBoss = false
_G.IceBossRen = false
_G.KeysRen = false
_G.AutoPoleV2 = false
_G.Greybeard = false
_G.Auto_SwanGG = false
_G.Auto_Cavender = false
_G.AutoBigmom = false
_G.DummyMan = false
_G.AutoTridentW2 = false
_G.Auto_Soul_Guitar = false

-- CDK Variables
_G.CDK_YM = false
_G.CDK_TS = false
_G.CDK = false

-- Toggles
_G.Tp_MasterA = false
_G.Tp_LgS = false

-- ========================================
-- QUEST MAIN PAGE (PAGE 1)
-- ========================================
QuestMain:Seperator("📋 Main Quests")

-- Auto Farm Observation Haki
QuestMain:Toggle({
    Name = "Auto Farm Observation Haki",
    Default = GetSetting("obsFarm", false),
    Callback = function(value)
        _G.obsFarm = value
        _G.SaveData["obsFarm"] = value
        SaveSettings()
    end
})

-- Auto Observation V2 (World 3 only)
if World3 then
    QuestMain:Toggle({
        Name = "Auto Observation V2",
        Default = GetSetting("AutoKenVTWO", false),
        Callback = function(value)
            _G.AutoKenVTWO = value
            _G.SaveData["AutoKenVTWO"] = value
            SaveSettings()
        end
    })
    
    -- Auto Citizen Quest
    QuestMain:Toggle({
        Name = "Auto Citizen Quest",
        Default = GetSetting("CitizenQuest", false),
        Callback = function(value)
            _G.CitizenQuest = value
            _G.SaveData["CitizenQuest"] = value
            SaveSettings()
        end
    })
end

-- Auto Elite Quest (World 3)
if World3 then
    QuestMain:Seperator("🏆 Elite Hunter")
    
    local eliteProgressPara = QuestMain:AddParagraph({
        Title = "Elite Progress",
        Desc = "Loading..."
    })
    
    task.spawn(function()
        while task.wait(2) do
            pcall(function()
                local progress = commF:InvokeServer("EliteHunter", "Progress")
                eliteProgressPara:SetDesc("Killed: " .. tostring(progress) .. " / 30")
            end)
        end
    end)
    
    QuestMain:Toggle({
        Name = "Auto Elite Quest",
        Default = GetSetting("FarmEliteHunt", false),
        Callback = function(value)
            _G.FarmEliteHunt = value
            _G.SaveData["FarmEliteHunt"] = value
            SaveSettings()
        end
    })
    
    QuestMain:Toggle({
        Name = "Stop when got God's Chalice",
        Default = GetSetting("StopWhenChalice", true),
        Callback = function(value)
            _G.StopWhenChalice = value
            _G.SaveData["StopWhenChalice"] = value
            SaveSettings()
        end
    })
end

-- Rainbow Haki (World 3)
if World3 then
    QuestMain:Seperator("🌈 Rainbow Haki")
    
    QuestMain:Toggle({
        Name = "Auto Rainbow Haki",
        Default = GetSetting("Auto_Rainbow_Haki", false),
        Callback = function(value)
            _G.Auto_Rainbow_Haki = value
            _G.SaveData["Auto_Rainbow_Haki"] = value
            SaveSettings()
        end
    })
end

-- Accept Quest Bypass
QuestMain:Seperator("⚡ Quest Bypass")

QuestMain:Toggle({
    Name = "Accept Quest Bypass [Risk]",
    Default = GetSetting("GetQFast", false),
    Callback = function(value)
        _G.GetQFast = value
        _G.SaveData["GetQFast"] = value
        SaveSettings()
    end
})

-- ========================================
-- QUEST TRAVEL PAGE (PAGE 2)
-- ========================================
QuestTravel:Seperator("🚢 Travel Quests")

-- Travel to Sea 2 (World 1 only)
if World1 then
    QuestTravel:Toggle({
        Name = "Auto Quest Sea 2",
        Default = GetSetting("TravelDres", false),
        Callback = function(value)
            _G.TravelDres = value
            _G.SaveData["TravelDres"] = value
            SaveSettings()
        end
    })
end

-- Travel to Sea 3 (World 2 only)
if World2 then
    QuestTravel:Toggle({
        Name = "Auto Quest Sea 3",
        Default = GetSetting("AutoZou", false),
        Callback = function(value)
            _G.AutoZou = value
            _G.SaveData["AutoZou"] = value
            SaveSettings()
        end
    })
end

-- ========================================
-- QUEST ITEMS PAGE (PAGE 3)
-- ========================================
QuestItems:Seperator("🎁 Item Farming")

-- Auto Saw Sword (World 1)
if World1 then
    QuestItems:Toggle({
        Name = "Auto Saw Sword",
        Default = GetSetting("AutoSaw", false),
        Callback = function(value)
            _G.AutoSaw = value
            _G.SaveData["AutoSaw"] = value
            SaveSettings()
        end
    })
end

-- Auto Marine Coat (World 1)
if World1 then
    QuestItems:Toggle({
        Name = "Auto Marine Coat",
        Default = GetSetting("MarinesCoat", false),
        Callback = function(value)
            _G.MarinesCoat = value
            _G.SaveData["MarinesCoat"] = value
            SaveSettings()
        end
    })
end

-- Auto Warden Sword (World 1)
if World1 then
    QuestItems:Toggle({
        Name = "Auto Warden Sword",
        Default = GetSetting("WardenBoss", false),
        Callback = function(value)
            _G.WardenBoss = value
            _G.SaveData["WardenBoss"] = value
            SaveSettings()
        end
    })
end

-- Auto Cyborg Sword (World 1)
if World1 then
    QuestItems:Toggle({
        Name = "Auto Cyborg Sword",
        Default = GetSetting("AutoColShad", false),
        Callback = function(value)
            _G.AutoColShad = value
            _G.SaveData["AutoColShad"] = value
            SaveSettings()
        end
    })
end

-- Auto Swan Coat (World 2)
if World2 then
    QuestItems:Toggle({
        Name = "Auto Swan Coat",
        Default = GetSetting("SwanCoat", false),
        Callback = function(value)
            _G.SwanCoat = value
            _G.SaveData["SwanCoat"] = value
            SaveSettings()
        end
    })
end

-- Auto Dragon Trident (World 2)
if World2 then
    QuestItems:Toggle({
        Name = "Auto Dragon Trident",
        Default = GetSetting("AutoTridentW2", false),
        Callback = function(value)
            _G.AutoTridentW2 = value
            _G.SaveData["AutoTridentW2"] = value
            SaveSettings()
        end
    })
end

-- Auto Midnight Blade (World 2)
if World2 then
    QuestItems:Toggle({
        Name = "Auto Midnight Blade",
        Default = GetSetting("AutoEcBoss", false),
        Callback = function(value)
            _G.AutoEcBoss = value
            _G.SaveData["AutoEcBoss"] = value
            SaveSettings()
        end
    })
end

-- Auto Rengoku (World 2)
if World2 then
    QuestItems:Toggle({
        Name = "Auto Rengoku Sword",
        Default = GetSetting("IceBossRen", false),
        Callback = function(value)
            _G.IceBossRen = value
            _G.SaveData["IceBossRen"] = value
            SaveSettings()
        end
    })
    
    QuestItems:Toggle({
        Name = "Auto Rengoku Key",
        Default = GetSetting("KeysRen", false),
        Callback = function(value)
            _G.KeysRen = value
            _G.SaveData["KeysRen"] = value
            SaveSettings()
        end
    })
end

-- Auto Pole V2 (World 2/3)
if World2 or World3 then
    QuestItems:Toggle({
        Name = "Auto Pole V2 [Beta]",
        Default = GetSetting("AutoPoleV2", false),
        Callback = function(value)
            _G.AutoPoleV2 = value
            _G.SaveData["AutoPoleV2"] = value
            SaveSettings()
        end
    })
end

-- Auto Bisento V2 (World 1)
if World1 then
    QuestItems:Toggle({
        Name = "Auto Bisento V2",
        Default = GetSetting("Greybeard", false),
        Callback = function(value)
            _G.Greybeard = value
            _G.SaveData["Greybeard"] = value
            SaveSettings()
        end
    })
end

-- Auto Swan Glasses (World 2)
if World2 then
    QuestItems:Toggle({
        Name = "Auto Swan Glasses",
        Default = GetSetting("Auto_SwanGG", false),
        Callback = function(value)
            _G.Auto_SwanGG = value
            _G.SaveData["Auto_SwanGG"] = value
            SaveSettings()
        end
    })
end

-- Auto Canvendish Sword (World 3)
if World3 then
    QuestItems:Toggle({
        Name = "Auto Canvendish Sword",
        Default = GetSetting("Auto_Cavender", false),
        Callback = function(value)
            _G.Auto_Cavender = value
            _G.SaveData["Auto_Cavender"] = value
            SaveSettings()
        end
    })
end

-- Auto Bigmom (World 3)
if World3 then
    QuestItems:Toggle({
        Name = "Auto Bigmom (Cake Queen)",
        Default = GetSetting("AutoBigmom", false),
        Callback = function(value)
            _G.AutoBigmom = value
            _G.SaveData["AutoBigmom"] = value
            SaveSettings()
        end
    })
end

-- Auto Training Dummy (World 3)
if World3 then
    QuestItems:Toggle({
        Name = "Auto Training Dummy",
        Default = GetSetting("DummyMan", false),
        Callback = function(value)
            _G.DummyMan = value
            _G.SaveData["DummyMan"] = value
            SaveSettings()
        end
    })
end

-- Auto Skull Guitar (World 3)
if World3 then
    QuestItems:Seperator("🎸 Skull Guitar")
    
    local soulGuitarStatus = QuestItems:AddParagraph({
        Title = "Quest Status",
        Desc = "Inactive"
    })
    
    QuestItems:Toggle({
        Name = "Auto Skull Guitar",
        Default = GetSetting("Auto_Soul_Guitar", false),
        Callback = function(value)
            _G.Auto_Soul_Guitar = value
            _G.SaveData["Auto_Soul_Guitar"] = value
            SaveSettings()
        end
    })
    
    task.spawn(function()
        while task.wait(2) do
            if _G.Auto_Soul_Guitar then
                pcall(function()
                    local questStatus = commF:InvokeServer("GuitarPuzzleProgress", "Check")
                    local status = "Unknown"
                    if questStatus then
                        if questStatus.Swamp == false then status = "Quest 1: Swamp"
                        elseif questStatus.Gravestones == false then status = "Quest 2: Gravestones"
                        elseif questStatus.Ghost == false then status = "Quest 3: Ghost"
                        elseif questStatus.Trophies == false then status = "Quest 4: Trophies"
                        elseif questStatus.Pipes == false then status = "Quest 5: Pipes"
                        else status = "Final Step" end
                    end
                    soulGuitarStatus:SetDesc(status)
                end)
            else
                soulGuitarStatus:SetDesc("Disabled")
            end
        end
    end)
end

-- ========================================
-- QUEST SWORDS PAGE (PAGE 4)
-- ========================================
QuestSwords:Seperator("⚔️ Cursed Swords")

if World3 then
    -- Yama Sword
    QuestSwords:Toggle({
        Name = "Auto Yama Sword",
        Default = GetSetting("Auto_Yama", false),
        Callback = function(value)
            _G.Auto_Yama = value
            _G.SaveData["Auto_Yama"] = value
            SaveSettings()
        end
    })
    
    -- Tushita Sword
    QuestSwords:Toggle({
        Name = "Auto Tushita Sword",
        Default = GetSetting("Auto_Tushita", false),
        Callback = function(value)
            _G.Auto_Tushita = value
            _G.SaveData["Auto_Tushita"] = value
            SaveSettings()
        end
    })
    
    -- CDK Section
    QuestSwords:Seperator("🔥 Cursed Dual Katana")
    
    local cdkProgress = QuestSwords:AddParagraph({
        Title = "CDK Progress",
        Desc = "Loading..."
    })
    
    task.spawn(function()
        while task.wait(3) do
            pcall(function()
                local progress = commF:InvokeServer("CDKQuest", "Progress")
                if progress and type(progress) == "table" then
                    cdkProgress:SetDesc(string.format("Good: %s | Evil: %s", 
                        tostring(progress.Good or 0), tostring(progress.Evil or 0)))
                end
            end)
        end
    end)
    
    QuestSwords:Toggle({
        Name = "Auto Yama CDK",
        Default = GetSetting("CDK_YM", false),
        Callback = function(value)
            _G.CDK_YM = value
            _G.SaveData["CDK_YM"] = value
            SaveSettings()
        end
    })
    
    QuestSwords:Toggle({
        Name = "Auto Tushita CDK",
        Default = GetSetting("CDK_TS", false),
        Callback = function(value)
            _G.CDK_TS = value
            _G.SaveData["CDK_TS"] = value
            SaveSettings()
        end
    })
    
    QuestSwords:Toggle({
        Name = "Auto Kill Cursed Skeleton Boss",
        Default = GetSetting("CDK", false),
        Callback = function(value)
            _G.CDK = value
            _G.SaveData["CDK"] = value
            SaveSettings()
        end
    })
    
    -- True Triple Katana
    QuestSwords:Seperator("🗡️ True Triple Katana")
    
    QuestSwords:Button({
        Name = "Buy Legendary Sword",
        Callback = function()
            commF:InvokeServer("LegendarySwordDealer", "1")
            commF:InvokeServer("LegendarySwordDealer", "2")
            commF:InvokeServer("LegendarySwordDealer", "3")
            library:Notification({
                Title = "Shop",
                Message = "Bought all 3 Legendary Swords!",
                Duration = 3
            })
        end
    })
    
    QuestSwords:Button({
        Name = "Buy True Triple Katana",
        Callback = function()
            commF:InvokeServer("MysteriousMan", "2")
            library:Notification({
                Title = "Shop",
                Message = "Bought True Triple Katana!",
                Duration = 3
            })
        end
    })
    
    QuestSwords:Toggle({
        Name = "Teleport to Legendary Sword Dealer",
        Default = GetSetting("Tp_LgS", false),
        Callback = function(value)
            _G.Tp_LgS = value
            _G.SaveData["Tp_LgS"] = value
            SaveSettings()
        end
    })
end

-- Aura Colours (World 2 & 3)
if World2 or World3 then
    QuestSwords:Seperator("🎨 Buso Colors")
    
    QuestSwords:Toggle({
        Name = "Teleport Barista Haki",
        Default = GetSetting("Tp_MasterA", false),
        Callback = function(value)
            _G.Tp_MasterA = value
            _G.SaveData["Tp_MasterA"] = value
            SaveSettings()
        end
    })
    
    QuestSwords:Button({
        Name = "Buy Buso Colors",
        Callback = function()
            commF:InvokeServer("ColorsDealer", "2")
            library:Notification({
                Title = "Shop",
                Message = "Bought Buso Colors!",
                Duration = 3
            })
        end
    })
end

-- ========================================
-- QUEST LOGIC LOOPS
-- ========================================

-- Travel to Sea 2 Logic (World 1)
if World1 then
    task.spawn(function()
        while task.wait(1) do
            if _G.TravelDres then
                pcall(function()
                    if GetLevel() >= 700 then
                        local iceDoor = Workspace.Map and Workspace.Map:FindFirstChild("Ice") and Workspace.Map.Ice:FindFirstChild("Door")
                        if iceDoor then
                            if iceDoor.CanCollide == true and iceDoor.Transparency == 0 then
                                commF:InvokeServer("DressrosaQuestProgress", "Detective")
                                EquipWeapon("Key")
                                _tp(CFrame.new(1347.71, 37.37, -1325.64))
                            elseif iceDoor.CanCollide == false and iceDoor.Transparency == 1 then
                                local boss = Workspace.Enemies:FindFirstChild("Ice Admiral")
                                if boss and G.Alive(boss) then
                                    G.Kill(boss, true)
                                else
                                    _tp(CFrame.new(1347.71, 37.37, -1325.64))
                                end
                            else
                                commF:InvokeServer("TravelDressrosa")
                            end
                        end
                    end
                end)
            end
        end
    end)
end

-- Travel to Sea 3 Logic (World 2)
if World2 then
    task.spawn(function()
        while task.wait(1) do
            if _G.AutoZou then
                pcall(function()
                    if GetLevel() >= 1500 then
                        local bartiloProgress = commF:InvokeServer("BartiloQuestProgress", "Bartilo")
                        
                        if bartiloProgress == 0 then
                            local questUI = plr.PlayerGui.Main.Quest
                            if not questUI.Visible then
                                _tp(CFrame.new(-456.28, 73.02, 299.89))
                                if (plr.Character.HumanoidRootPart.Position - CFrame.new(-456.28, 73.02, 299.89).Position).Magnitude <= 5 then
                                    task.wait(1)
                                    commF:InvokeServer("StartQuest", "BartiloQuest", 1)
                                end
                            else
                                local mob = GetConnectionEnemies("Swan Pirate")
                                if mob then
                                    G.Kill(mob, true)
                                else
                                    _tp(CFrame.new(1057.92, 137.61, 1242.08))
                                end
                            end
                        elseif bartiloProgress == 1 then
                            local mob = GetConnectionEnemies("Jeremy")
                            if mob then
                                G.Kill(mob, true)
                            else
                                _tp(CFrame.new(2099.88, 448.93, 648.99))
                            end
                        elseif bartiloProgress == 2 then
                            _tp(CFrame.new(-1836, 11, 1714))
                            if (plr.Character.HumanoidRootPart.Position - CFrame.new(-1836, 11, 1714).Position).Magnitude <= 10 then
                                task.wait(0.5)
                                notween(CFrame.new(-1850.49, 13.17, 1750.89))
                                task.wait(0.1)
                                notween(CFrame.new(-1858.87, 19.37, 1712.01))
                                task.wait(0.1)
                                notween(CFrame.new(-1803.94, 16.57, 1750.89))
                                task.wait(0.1)
                                notween(CFrame.new(-1858.55, 16.86, 1724.79))
                                task.wait(0.1)
                                notween(CFrame.new(-1869.54, 15.98, 1681.00))
                                task.wait(0.1)
                                notween(CFrame.new(-1800.09, 16.49, 1684.52))
                                task.wait(0.1)
                                notween(CFrame.new(-1819.26, 14.79, 1717.90))
                                task.wait(0.1)
                                notween(CFrame.new(-1813.51, 14.86, 1724.79))
                            end
                        else
                            local unlockables = commF:InvokeServer("GetUnlockables")
                            if unlockables and unlockables.FlamingoAccess == nil then
                                commF:InvokeServer("F_", "TalkTrevor", "1")
                                task.wait(0.1)
                                commF:InvokeServer("F_", "TalkTrevor", "2")
                                task.wait(0.1)
                                commF:InvokeServer("F_", "TalkTrevor", "3")
                            else
                                commF:InvokeServer("F_", "TravelZou")
                            end
                        end
                    end
                end)
            end
        end
    end)
end

-- Auto Observation Haki Logic
task.spawn(function()
    while task.wait(0.5) do
        if _G.obsFarm then
            pcall(function()
                commE:FireServer("Ken", true)
                
                local dodgesLeft = plr:GetAttribute("KenDodgesLeft")
                local kenTest = dodgesLeft and dodgesLeft > 0
                
                local targetEnemy = nil
                local farmPos = nil
                
                if World1 then
                    targetEnemy = Workspace.Enemies:FindFirstChild("Galley Captain")
                    farmPos = CFrame.new(5533.29, 88.10, 4852.39)
                elseif World2 then
                    targetEnemy = Workspace.Enemies:FindFirstChild("Lava Pirate")
                    farmPos = CFrame.new(-5478.39, 15.97, -5246.91)
                elseif World3 then
                    targetEnemy = Workspace.Enemies:FindFirstChild("Venomous Assailant")
                    farmPos = CFrame.new(4530.35, 656.75, -131.60)
                end
                
                if targetEnemy then
                    if kenTest then
                        _tp(targetEnemy.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0))
                    else
                        _tp(targetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0))
                    end
                elseif farmPos then
                    _tp(farmPos)
                end
            end)
        end
    end
end)

-- Auto Observation V2 Logic (World 3)
if World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.AutoKenVTWO then
                pcall(function()
                    local questUI = plr.PlayerGui.Main.Quest
                    
                    if questUI.Visible and string.find(questUI.Container.QuestTitle.Title.Text, "Defeat 50 Forest Pirates") then
                        local mob = GetConnectionEnemies("Forest Pirate")
                        if mob then
                            G.Kill(mob, true)
                        else
                            _tp(CFrame.new(-13277.56, 370.34, -7821.15))
                        end
                    elseif questUI.Visible then
                        local mob = GetConnectionEnemies("Captain Elephant")
                        if mob then
                            G.Kill(mob, true)
                        else
                            _tp(CFrame.new(-13493.12, 318.89, -8373.79))
                        end
                    else
                        commF:InvokeServer("CitizenQuestProgress", "Citizen")
                        task.wait(0.1)
                        commF:InvokeServer("StartQuest", "CitizenQuest", 1)
                    end
                    
                    if commF:InvokeServer("CitizenQuestProgress", "Citizen") == 2 then
                        _tp(CFrame.new(-12513.51, 340.11, -9873.04))
                    end
                end)
            end
        end
    end)
end

-- Auto Elite Quest Logic (World 3)
if World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.FarmEliteHunt then
                pcall(function()
                    if _G.StopWhenChalice and (GetBP("God's Chalice") or GetBP("Sweet Chalice") or GetBP("Fist of Darkness")) then
                        _G.FarmEliteHunt = false
                        return
                    end
                    
                    local questUI = plr.PlayerGui.Main.Quest
                    if questUI.Visible then
                        local elites = {"Diablo", "Urban", "Deandre"}
                        for _, name in ipairs(elites) do
                            local mob = GetConnectionEnemies(name)
                            if mob then
                                G.Kill(mob, true)
                                break
                            end
                        end
                    else
                        commF:InvokeServer("EliteHunter")
                    end
                end)
            end
        end
    end)
end

-- Auto Citizen Quest Logic (World 3)
if World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.CitizenQuest then
                pcall(function()
                    if GetLevel() >= 1800 then
                        local progress = commF:InvokeServer("CitizenQuestProgress")
                        local questUI = plr.PlayerGui.Main.Quest
                        
                        if progress.KilledBandits == false then
                            if questUI.Visible and string.find(questUI.Container.QuestTitle.Title.Text, "Forest Pirate") then
                                local mob = GetConnectionEnemies("Forest Pirate")
                                if mob then
                                    G.Kill(mob, true)
                                else
                                    _tp(CFrame.new(-13206.45, 425.89, -7964.55))
                                end
                            else
                                _tp(CFrame.new(-12443.86, 332.40, -7675.48))
                                if (plr.Character.HumanoidRootPart.Position - CFrame.new(-12443.86, 332.40, -7675.48).Position).Magnitude <= 30 then
                                    task.wait(1.5)
                                    commF:InvokeServer("StartQuest", "CitizenQuest", 1)
                                end
                            end
                        elseif progress.KilledBoss == false then
                            if questUI.Visible and string.find(questUI.Container.QuestTitle.Title.Text, "Captain Elephant") then
                                local mob = GetConnectionEnemies("Captain Elephant")
                                if mob then
                                    G.Kill(mob, true)
                                else
                                    _tp(CFrame.new(-13374.88, 421.27, -8225.20))
                                end
                            else
                                _tp(CFrame.new(-12443.86, 332.40, -7675.48))
                                if (plr.Character.HumanoidRootPart.Position - CFrame.new(-12443.86, 332.40, -7675.48).Position).Magnitude <= 4 then
                                    task.wait(1.5)
                                    commF:InvokeServer("CitizenQuestProgress", "Citizen")
                                end
                            end
                        elseif progress == 2 then
                            _tp(CFrame.new(-12512.13, 340.39, -9872.82))
                        end
                    end
                end)
            end
        end
    end)
end

-- Auto Yama Logic (World 3)
if World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.Auto_Yama then
                pcall(function()
                    if commF:InvokeServer("EliteHunter", "Progress") < 30 then
                        _G.FarmEliteHunt = true
                    else
                        _G.FarmEliteHunt = false
                        local sealedKatana = Workspace.Map.Waterfall.SealedKatana
                        if sealedKatana and (sealedKatana.Handle.Position - plr.Character.HumanoidRootPart.Position).Magnitude >= 20 then
                            _tp(sealedKatana.Handle.CFrame)
                            local ghost = GetConnectionEnemies("Ghost")
                            if ghost then
                                G.Kill(ghost, true)
                                fireclickdetector(sealedKatana.Handle.ClickDetector)
                            end
                        end
                    end
                end)
            end
        end
    end)
end

-- Auto Tushita Logic (World 3)
if World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.Auto_Tushita then
                pcall(function()
                    if Workspace.Map.Turtle:FindFirstChild("TushitaGate") then
                        if not GetBP("Holy Torch") then
                            _tp(CFrame.new(5148.03, 162.35, 910.54))
                        else
                            EquipWeapon("Holy Torch")
                            task.wait(1)
                            local positions = {
                                CFrame.new(-10752, 417, -9366),
                                CFrame.new(-11672, 334, -9474),
                                CFrame.new(-12132, 521, -10655),
                                CFrame.new(-13336, 486, -6985),
                                CFrame.new(-13489, 332, -7925)
                            }
                            for _, pos in ipairs(positions) do
                                repeat
                                    task.wait()
                                    _tp(pos)
                                until not _G.Auto_Tushita or (pos.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
                            end
                        end
                    else
                        local longma = GetConnectionEnemies("Longma")
                        if longma then
                            G.Kill(longma, true)
                        end
                    end
                end)
            end
        end
    end)
end

-- Auto CDK Boss Logic (World 3)
if World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.CDK then
                pcall(function()
                    local boss = GetConnectionEnemies("Cursed Skeleton Boss")
                    if boss then
                        if GetBP("Yama") or GetBP("Tushita") then
                            EquipWeapon(GetBP("Yama") and "Yama" or "Tushita")
                        end
                        _tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                        G.Kill(boss, true)
                    else
                        _tp(CFrame.new(-12318.19, 601.95, -6538.66))
                        task.wait(0.5)
                        _tp(Workspace.Map.Turtle.Cursed.BossDoor.CFrame)
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Saw Sword (World 1)
if World1 then
    task.spawn(function()
        while task.wait(0.5) do
            if _G.AutoSaw then
                pcall(function()
                    local boss = GetConnectionEnemies("The Saw")
                    if boss then
                        G.Kill(boss, true)
                    else
                        _tp(CFrame.new(-784.89, 72.42, 1603.58))
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Marine Coat (World 1)
if World1 then
    task.spawn(function()
        while task.wait(0.5) do
            if _G.MarinesCoat then
                pcall(function()
                    local boss = GetConnectionEnemies("Vice Admiral")
                    if boss then
                        G.Kill(boss, true)
                    else
                        _tp(CFrame.new(-5006.54, 88.03, 4353.16))
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Warden Sword (World 1)
if World1 then
    task.spawn(function()
        while task.wait(0.5) do
            if _G.WardenBoss then
                pcall(function()
                    local boss = GetConnectionEnemies("Chief Warden")
                    if boss then
                        G.Kill(boss, true)
                    else
                        _tp(CFrame.new(5206.92, 0.99, 814.97))
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Cyborg Sword (World 1)
if World1 then
    task.spawn(function()
        while task.wait(0.5) do
            if _G.AutoColShad then
                pcall(function()
                    local boss = GetConnectionEnemies("Cyborg")
                    if boss then
                        G.Kill(boss, true)
                    else
                        _tp(CFrame.new(6094.02, 73.77, 3825.73))
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Swan Coat (World 2)
if World2 then
    task.spawn(function()
        while task.wait(0.5) do
            if _G.SwanCoat then
                pcall(function()
                    local boss = GetConnectionEnemies("Swan")
                    if boss then
                        G.Kill(boss, true)
                    else
                        _tp(CFrame.new(5325.09, 7.03, 719.57))
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Dragon Trident (World 2)
if World2 then
    task.spawn(function()
        while task.wait(1) do
            if _G.AutoTridentW2 then
                pcall(function()
                    local boss = GetConnectionEnemies("Tide Keeper")
                    if boss then
                        G.Kill(boss, true)
                    else
                        _tp(CFrame.new(-3795.64, 105.88, -11421.30))
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Midnight Blade (World 2)
if World2 then
    task.spawn(function()
        while task.wait(1) do
            if _G.AutoEcBoss then
                pcall(function()
                    if GetM("Ectoplasm") >= 99 then
                        commF:InvokeServer("Ectoplasm", "Buy", 3)
                    else
                        local boss = GetConnectionEnemies("Cursed Captain")
                        if boss then
                            G.Kill(boss, true)
                        else
                            local entrance = Vector3.new(923.21, 126.97, 32852.83)
                            if (plr.Character.HumanoidRootPart.Position - entrance).Magnitude > 500 then
                                commF:InvokeServer("requestEntrance", entrance)
                            end
                            task.wait(0.5)
                            _tp(CFrame.new(916.92, 181.09, 33422))
                        end
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Rengoku (World 2)
if World2 then
    task.spawn(function()
        while task.wait(0.5) do
            if _G.IceBossRen then
                pcall(function()
                    local boss = GetConnectionEnemies("Awakened Ice Admiral")
                    if boss then
                        G.Kill(boss, true)
                    else
                        _tp(CFrame.new(5668.97, 28.51, -6483.35))
                    end
                end)
            end
        end
    end)
    
    task.spawn(function()
        while task.wait(0.5) do
            if _G.KeysRen then
                pcall(function()
                    if GetBP("Hidden Key") then
                        EquipWeapon("Hidden Key")
                        task.wait(0.1)
                        _tp(CFrame.new(6571.12, 299.23, -6967.84))
                    else
                        local mobs = {"Snow Lurker", "Arctic Warrior", "Awakened Ice Admiral"}
                        local mob = GetConnectionEnemies(mobs)
                        if mob then
                            G.Kill(mob, true)
                        else
                            _tp(CFrame.new(5439.71, 84.42, -6715.16))
                        end
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Swan Glasses (World 2)
if World2 then
    task.spawn(function()
        while task.wait(0.5) do
            if _G.Auto_SwanGG then
                pcall(function()
                    local boss = GetConnectionEnemies("Don Swan")
                    if boss then
                        G.Kill(boss, true)
                    else
                        _tp(CFrame.new(2286.20, 15.17, 863.83))
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Canvendish Sword (World 3)
if World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.Auto_Cavender then
                pcall(function()
                    local boss = GetConnectionEnemies("Beautiful Pirate")
                    if boss then
                        G.Kill(boss, true)
                    else
                        _tp(CFrame.new(5283.60, 22.56, -110.78))
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Bigmom (World 3)
if World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.AutoBigmom then
                pcall(function()
                    local boss = GetConnectionEnemies("Cake Queen")
                    if boss then
                        G.Kill(boss, true)
                    else
                        _tp(CFrame.new(-709.31, 381.60, -11011.39))
                    end
                end)
            end
        end
    end)
end

-- Item Farm: Training Dummy (World 3)
if World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.DummyMan then
                pcall(function()
                    if not plr.PlayerGui.Main.Quest.Visible then
                        commF:InvokeServer("ArenaTrainer")
                    else
                        local dummy = GetConnectionEnemies("Training Dummy")
                        if dummy then
                            G.Kill(dummy, true)
                        else
                            _tp(CFrame.new(3688.00, 12.74, 170.20))
                        end
                    end
                end)
            end
        end
    end)
end

-- Teleport Barista Haki (World 2/3)
if World2 or World3 then
    task.spawn(function()
        while task.wait(0.5) do
            if _G.Tp_MasterA then
                pcall(function()
                    for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                        if npc.Name == "Barista Cousin" then
                            _tp(npc.HumanoidRootPart.CFrame)
                            break
                        end
                    end
                end)
            end
        end
    end)
end

-- Teleport Legendary Sword Dealer (World 3)
if World3 then
    task.spawn(function()
        while task.wait(0.5) do
            if _G.Tp_LgS then
                pcall(function()
                    for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                        if npc.Name == "Legendary Sword Dealer" then
                            _tp(npc.HumanoidRootPart.CFrame)
                            break
                        end
                    end
                end)
            end
        end
    end)
end

-- Auto Pole V2 Logic (World 2/3)
if World2 or World3 then
    task.spawn(function()
        while task.wait(1) do
            if _G.AutoPoleV2 then
                pcall(function()
                    if not GetBP("Pole (1st Form)") then
                        commF:InvokeServer("LoadItem", "Pole (1st Form)")
                    end
                    if not GetBP("Pole (2nd Form)") then
                        commF:InvokeServer("LoadItem", "Pole (2nd Form)")
                    end
                    
                    if GetBP("Pole (1st Form)") and GetBP("Pole (1st Form)"):FindFirstChild("Level") then
                        if GetBP("Pole (1st Form)").Level.Value < 180 then
                            _G.StartFarm = true
                            _G.Level = true
                        else
                            _G.Level = false
                            _G.StartFarm = false
                        end
                    end
                end)
            end
        end
    end)
end

-- Auto Bisento V2 Logic (World 1)
if World1 then
    task.spawn(function()
        while task.wait(1) do
            if _G.Greybeard then
                pcall(function()
                    if not GetBP("Bisento") then
                        commF:InvokeServer("BuyItem", "Bisento")
                    else
                        local boss = GetConnectionEnemies("Greybeard")
                        if boss then
                            G.Kill(boss, true)
                        else
                            _tp(CFrame.new(-5023.38, 28.65, 4332.38))
                        end
                    end
                end)
            end
        end
    end)
end

print("========================================")
print("KuKi Hub | True V2 - Part 3 Loaded!")
print("Quests/Items Tab Complete!")
print("========================================")

--[[
    KuKi Hub | True V2
    Part 4: Sea Event Tab - Boat Controls, Sea Beasts, Kitsune, Frozen Dimension
]]

-- ========================================
-- SEA EVENT TAB SETUP
-- ========================================
local SeaMain = Tab6:CraftPage(1)        -- Main Sea Events
local SeaBoat = Tab6:CraftPage(2)        -- Boat Settings
local SeaKitsune = Tab6:CraftPage(3)     -- Kitsune Island
local SeaFrozen = Tab6:CraftPage(4)      -- Frozen Dimension

-- ========================================
-- GLOBAL SEA EVENT VARIABLES
-- ========================================
_G.SailBoats = false
_G.SeaBeast1 = false
_G.PGB = false
_G.Shark = false
_G.Piranha = false
_G.TerrorShark = false
_G.MobCrew = false
_G.HCM = false
_G.FishBoat = false
_G.Leviathan1 = false

_G.AutoPressW = false
_G.NoClipShip = false
_G.SpeedBoat = false
_G.SetSpeedBoat = 300

_G.AutofindKitIs = false
_G.tweenShrine = false
_G.Collect_Ember = false
_G.Trade_Ember = false

_G.FrozenTP = false

_G.SelectedBoat = "Guardian"
_G.DangerSc = "Lv 1"

-- Boat List
local BoatList = {
    "Guardian",
    "PirateGrandBrigade",
    "MarineGrandBrigade",
    "PirateBrigade",
    "MarineBrigade",
    "PirateSloop",
    "MarineSloop",
    "Beast Hunter"
}

-- Danger Levels (World 3)
local DangerLevels = {
    "Lv 1", "Lv 2", "Lv 3", "Lv 4", "Lv 5", "Lv 6", "Lv Infinite"
}

-- ========================================
-- HELPER FUNCTIONS FOR SEA
-- ========================================
function CheckBoat()
    for _, boat in pairs(Workspace.Boats:GetChildren()) do
        if tostring(boat.Owner.Value) == plr.Name then
            return boat
        end
    end
    return nil
end

function CheckEnemiesBoat()
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if enemy.Name == "FishBoat" and enemy:FindFirstChild("Health") and enemy.Health.Value > 0 then
            return true
        end
    end
    return false
end

function CheckPirateGrandBrigade()
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if (enemy.Name == "PirateGrandBrigade" or enemy.Name == "PirateBrigade") and enemy:FindFirstChild("Health") and enemy.Health.Value > 0 then
            return true
        end
    end
    return false
end

function CheckTerrorShark()
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if enemy.Name == "Terrorshark" and G.Alive(enemy) then
            return true
        end
    end
    return false
end

function CheckShark()
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if enemy.Name == "Shark" and G.Alive(enemy) then
            return true
        end
    end
    return false
end

function CheckPiranha()
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if enemy.Name == "Piranha" and G.Alive(enemy) then
            return true
        end
    end
    return false
end

function CheckFishCrew()
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if (enemy.Name == "Fish Crew Member" or enemy.Name == "Haunted Crew Member") and G.Alive(enemy) then
            return true
        end
    end
    return false
end

function CheckHauntedCrew()
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if enemy.Name == "Haunted Crew Member" and G.Alive(enemy) then
            return true
        end
    end
    return false
end

function CheckSeaBeast()
    return Workspace.SeaBeasts:FindFirstChild("SeaBeast1") ~= nil
end

function CheckLeviathan()
    return Workspace.SeaBeasts:FindFirstChild("Leviathan") ~= nil
end

-- ========================================
-- SEA MAIN PAGE (PAGE 1)
-- ========================================
SeaMain:Seperator("🌊 Sea Event Settings")

SeaMain:Toggle({
    Name = "Auto Start Sail",
    Default = GetSetting("SailBoats", false),
    Callback = function(value)
        _G.SailBoats = value
        _G.SaveData["SailBoats"] = value
        SaveSettings()
    end
})

SeaMain:Seperator("🎯 Select Targets")

SeaMain:Toggle({
    Name = "Auto Attack Sea Beast",
    Default = GetSetting("SeaBeast1", false),
    Callback = function(value)
        _G.SeaBeast1 = value
        _G.SaveData["SeaBeast1"] = value
        SaveSettings()
    end
})

SeaMain:Toggle({
    Name = "Auto Attack Pirate GrandBrigade",
    Default = GetSetting("PGB", false),
    Callback = function(value)
        _G.PGB = value
        _G.SaveData["PGB"] = value
        SaveSettings()
    end
})

if World3 then
    SeaMain:Toggle({
        Name = "Auto Shark",
        Default = GetSetting("Shark", false),
        Callback = function(value)
            _G.Shark = value
            _G.SaveData["Shark"] = value
            SaveSettings()
        end
    })
    
    SeaMain:Toggle({
        Name = "Auto Piranha",
        Default = GetSetting("Piranha", false),
        Callback = function(value)
            _G.Piranha = value
            _G.SaveData["Piranha"] = value
            SaveSettings()
        end
    })
    
    SeaMain:Toggle({
        Name = "Auto Terror Shark",
        Default = GetSetting("TerrorShark", false),
        Callback = function(value)
            _G.TerrorShark = value
            _G.SaveData["TerrorShark"] = value
            SaveSettings()
        end
    })
    
    SeaMain:Toggle({
        Name = "Auto Fish Crew Member",
        Default = GetSetting("MobCrew", false),
        Callback = function(value)
            _G.MobCrew = value
            _G.SaveData["MobCrew"] = value
            SaveSettings()
        end
    })
    
    SeaMain:Toggle({
        Name = "Auto Haunted Crew Member",
        Default = GetSetting("HCM", false),
        Callback = function(value)
            _G.HCM = value
            _G.SaveData["HCM"] = value
            SaveSettings()
        end
    })
    
    SeaMain:Toggle({
        Name = "Auto Attack Fish Boat",
        Default = GetSetting("FishBoat", false),
        Callback = function(value)
            _G.FishBoat = value
            _G.SaveData["FishBoat"] = value
            SaveSettings()
        end
    })
end

if World1 then
    SeaMain:Label("Go to Sea 3 or Sea 2 for more options")
end

if World2 then
    SeaMain:Label("Go to Sea 3 for more options")
end

SeaMain:Seperator("⚡ Quick Actions")

SeaMain:Button({
    Name = "Remove Lighting Effect",
    Callback = function()
        pcall(function()
            if Lighting:FindFirstChild("BaseAtmosphere") then Lighting.BaseAtmosphere:Destroy() end
            if Lighting:FindFirstChild("LightingLayers") then Lighting.LightingLayers:Destroy() end
            if Lighting:FindFirstChild("SeaTerrorCC") then Lighting.SeaTerrorCC:Destroy() end
            if Lighting:FindFirstChild("FantasySky") then Lighting.FantasySky:Destroy() end
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9000000000
            Lighting.Brightness = 2
            library:Notification({
                Title = "Lighting",
                Message = "Removed fog effects",
                Duration = 3
            })
        end)
    end
})

-- ========================================
-- SEA BOAT PAGE (PAGE 2)
-- ========================================
SeaBoat:Seperator("⛵ Boat Selection")

SeaBoat:Dropdown({
    Name = "Select Boat",
    Options = BoatList,
    Default = GetSetting("SelectedBoat", "Guardian"),
    Callback = function(value)
        _G.SelectedBoat = value
        _G.SaveData["SelectedBoat"] = value
        SaveSettings()
    end
})

if World3 then
    SeaBoat:Dropdown({
        Name = "Select Danger Level",
        Options = DangerLevels,
        Default = GetSetting("DangerSc", "Lv 1"),
        Callback = function(value)
            _G.DangerSc = value
            _G.SaveData["DangerSc"] = value
            SaveSettings()
        end
    })
end

SeaBoat:Button({
    Name = "Buy Selected Boat",
    Callback = function()
        pcall(function()
            local boatDealerPos = CFrame.new(-16927.451, 9.086, 433.864)
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if (hrp.Position - boatDealerPos.Position).Magnitude > 10 then
                    _tp(boatDealerPos)
                    task.wait(1)
                end
                commF:InvokeServer("BuyBoat", _G.SelectedBoat)
                library:Notification({
                    Title = "Boat Shop",
                    Message = "Purchased: " .. _G.SelectedBoat,
                    Duration = 3
                })
            end
        end)
    end
})

SeaBoat:Seperator("🚤 Boat Controls")

SeaBoat:Toggle({
    Name = "Auto Press W (Auto Drive)",
    Default = GetSetting("AutoPressW", false),
    Callback = function(value)
        _G.AutoPressW = value
        _G.SaveData["AutoPressW"] = value
        SaveSettings()
    end
})

SeaBoat:Toggle({
    Name = "No Clip Ship",
    Default = GetSetting("NoClipShip", false),
    Callback = function(value)
        _G.NoClipShip = value
        _G.SaveData["NoClipShip"] = value
        SaveSettings()
    end
})

SeaBoat:Toggle({
    Name = "Activate Boat Speed",
    Default = GetSetting("SpeedBoat", false),
    Callback = function(value)
        _G.SpeedBoat = value
        _G.SaveData["SpeedBoat"] = value
        SaveSettings()
    end
})

SeaBoat:TextBox({
    Name = "Boat Speed Value",
    Placeholder = "300",
    Default = tostring(GetSetting("SetSpeedBoat", 300)),
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            _G.SetSpeedBoat = num
            _G.SaveData["SetSpeedBoat"] = num
            SaveSettings()
        end
    end
})

-- ========================================
-- SEA KITSUNE PAGE (PAGE 3) - World 3 Only
-- ========================================
if World3 then
    SeaKitsune:Seperator("🦊 Kitsune Island")
    
    SeaKitsune:Toggle({
        Name = "Auto Find Kitsune Island",
        Default = GetSetting("AutofindKitIs", false),
        Callback = function(value)
            _G.AutofindKitIs = value
            _G.SaveData["AutofindKitIs"] = value
            SaveSettings()
        end
    })
    
    SeaKitsune:Toggle({
        Name = "Auto Teleport to Shrine Actived",
        Default = GetSetting("tweenShrine", false),
        Callback = function(value)
            _G.tweenShrine = value
            _G.SaveData["tweenShrine"] = value
            SaveSettings()
        end
    })
    
    SeaKitsune:Toggle({
        Name = "Auto Collect Azure Ember",
        Default = GetSetting("Collect_Ember", false),
        Callback = function(value)
            _G.Collect_Ember = value
            _G.SaveData["Collect_Ember"] = value
            SaveSettings()
        end
    })
    
    SeaKitsune:Toggle({
        Name = "Auto Trade Azure Ember",
        Default = GetSetting("Trade_Ember", false),
        Callback = function(value)
            _G.Trade_Ember = value
            _G.SaveData["Trade_Ember"] = value
            SaveSettings()
        end
    })
    
    SeaKitsune:Button({
        Name = "Trade Items Azure",
        Callback = function()
            ReplicatedStorage.Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()
            library:Notification({
                Title = "Kitsune",
                Message = "Traded Azure Ember!",
                Duration = 3
            })
        end
    })
    
    SeaKitsune:Button({
        Name = "Talk with Kitsune Statue",
        Callback = function()
            ReplicatedStorage.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()
            library:Notification({
                Title = "Kitsune",
                Message = "Talked to statue!",
                Duration = 3
            })
        end
    })
end

-- ========================================
-- SEA FROZEN PAGE (PAGE 4) - World 3 Only
-- ========================================
if World3 then
    SeaFrozen:Seperator("❄️ Frozen Dimension")
    
    SeaFrozen:Button({
        Name = "Buy Spy",
        Callback = function()
            commF:InvokeServer("InfoLeviathan", "2")
            library:Notification({
                Title = "Frozen Dimension",
                Message = "Bought Spy!",
                Duration = 3
            })
        end
    })
    
    SeaFrozen:Toggle({
        Name = "Teleport Frozen Dimension",
        Default = GetSetting("FrozenTP", false),
        Callback = function(value)
            _G.FrozenTP = value
            _G.SaveData["FrozenTP"] = value
            SaveSettings()
        end
    })
    
    SeaFrozen:Toggle({
        Name = "Auto Attack Leviathan",
        Default = GetSetting("Leviathan1", false),
        Callback = function(value)
            _G.Leviathan1 = value
            _G.SaveData["Leviathan1"] = value
            SaveSettings()
        end
    })
end

-- ========================================
-- SKILL SELECTION (Moved from original)
-- ========================================
SeaMain:Seperator("⚔️ Skill Selection")

_G.SelectedSkills = _G.SelectedSkills or {
    Melee = {Z = false, X = false, C = false},
    Sword = {Z = false, X = false},
    ["Blox Fruit"] = {Z = false, X = false, C = false, V = false, F = false},
    Gun = {Z = false, X = false}
}

if _G.SaveData and _G.SaveData.SelectedSkills then
    _G.SelectedSkills = _G.SaveData.SelectedSkills
end

-- Melee Skills
SeaMain:Toggle({Name = "Melee Z", Default = _G.SelectedSkills.Melee.Z, Callback = function(v) _G.SelectedSkills.Melee.Z = v; SaveSettings() end})
SeaMain:Toggle({Name = "Melee X", Default = _G.SelectedSkills.Melee.X, Callback = function(v) _G.SelectedSkills.Melee.X = v; SaveSettings() end})
SeaMain:Toggle({Name = "Melee C", Default = _G.SelectedSkills.Melee.C, Callback = function(v) _G.SelectedSkills.Melee.C = v; SaveSettings() end})

-- Sword Skills
SeaMain:Toggle({Name = "Sword Z", Default = _G.SelectedSkills.Sword.Z, Callback = function(v) _G.SelectedSkills.Sword.Z = v; SaveSettings() end})
SeaMain:Toggle({Name = "Sword X", Default = _G.SelectedSkills.Sword.X, Callback = function(v) _G.SelectedSkills.Sword.X = v; SaveSettings() end})

-- Blox Fruit Skills
SeaMain:Toggle({Name = "Blox Fruit Z", Default = _G.SelectedSkills["Blox Fruit"].Z, Callback = function(v) _G.SelectedSkills["Blox Fruit"].Z = v; _G.FruitSkills = _G.SelectedSkills["Blox Fruit"]; SaveSettings() end})
SeaMain:Toggle({Name = "Blox Fruit X", Default = _G.SelectedSkills["Blox Fruit"].X, Callback = function(v) _G.SelectedSkills["Blox Fruit"].X = v; _G.FruitSkills = _G.SelectedSkills["Blox Fruit"]; SaveSettings() end})
SeaMain:Toggle({Name = "Blox Fruit C", Default = _G.SelectedSkills["Blox Fruit"].C, Callback = function(v) _G.SelectedSkills["Blox Fruit"].C = v; _G.FruitSkills = _G.SelectedSkills["Blox Fruit"]; SaveSettings() end})
SeaMain:Toggle({Name = "Blox Fruit V", Default = _G.SelectedSkills["Blox Fruit"].V, Callback = function(v) _G.SelectedSkills["Blox Fruit"].V = v; _G.FruitSkills = _G.SelectedSkills["Blox Fruit"]; SaveSettings() end})
SeaMain:Toggle({Name = "Blox Fruit F", Default = _G.SelectedSkills["Blox Fruit"].F, Callback = function(v) _G.SelectedSkills["Blox Fruit"].F = v; _G.FruitSkills = _G.SelectedSkills["Blox Fruit"]; SaveSettings() end})

-- Gun Skills
SeaMain:Toggle({Name = "Gun Z", Default = _G.SelectedSkills.Gun.Z, Callback = function(v) _G.SelectedSkills.Gun.Z = v; SaveSettings() end})
SeaMain:Toggle({Name = "Gun X", Default = _G.SelectedSkills.Gun.X, Callback = function(v) _G.SelectedSkills.Gun.X = v; SaveSettings() end})

-- ========================================
-- SEA EVENT LOGIC LOOPS
-- ========================================

-- Auto Press W Loop
task.spawn(function()
    while task.wait() do
        if _G.AutoPressW then
            pcall(function()
                local char = plr.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Sit then
                    VirtualInputManager:SendKeyEvent(true, "W", false, game)
                end
            end)
        end
    end
end)

-- No Clip Ship Loop
task.spawn(function()
    while task.wait() do
        pcall(function()
            for _, boat in pairs(Workspace.Boats:GetChildren()) do
                for _, part in pairs(boat:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if _G.NoClipShip or _G.SailBoats or _G.AutofindKitIs then
                            part.CanCollide = false
                        else
                            part.CanCollide = true
                        end
                    end
                end
            end
        end)
    end
end)

-- Boat Speed Loop
task.spawn(function()
    RunService.RenderStepped:Connect(function()
        if _G.SpeedBoat then
            pcall(function()
                if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Sit then
                    for _, boat in pairs(Workspace.Boats:GetChildren()) do
                        local seat = boat:FindFirstChildWhichIsA("VehicleSeat")
                        if seat then
                            seat.MaxSpeed = _G.SetSpeedBoat
                            seat.Torque = 0.2
                            seat.TurnSpeed = 5
                        end
                    end
                end
            end)
        end
    end)
end)

-- Auto Find Kitsune Island (World 3)
if World3 then
    task.spawn(function()
        while task.wait() do
            if _G.AutofindKitIs then
                pcall(function()
                    if not Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island", true) then
                        local myBoat = CheckBoat()
                        if not myBoat then
                            local boatPos = CFrame.new(-16927.451, 9.086, 433.864)
                            _tp(boatPos)
                            if (boatPos.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                                commF:InvokeServer("BuyBoat", _G.SelectedBoat)
                            end
                        else
                            if plr.Character.Humanoid.Sit == false then
                                local seatPos = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)
                                _tp(seatPos)
                            else
                                local targetPos = CFrame.new(-10000000, 31, 37016.25)
                                repeat
                                    task.wait()
                                    if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
                                        _tp(CFrame.new(-10000000, 150, 37016.25))
                                    else
                                        _tp(CFrame.new(-10000000, 31, 37016.25))
                                    end
                                until not _G.AutofindKitIs or (targetPos.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 or Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") or plr.Character.Humanoid.Sit == false
                                plr.Character.Humanoid.Sit = false
                            end
                        end
                    else
                        _tp(Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame * CFrame.new(0, 500, 0))
                    end
                end)
            end
        end
    end)
end

-- Auto Teleport to Shrine (World 3)
if World3 then
    task.spawn(function()
        while task.wait(0.1) do
            if _G.tweenShrine then
                pcall(function()
                    local island = Workspace.Map:FindFirstChild("KitsuneIsland") or Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island")
                    local shrine = island and island:FindFirstChild("ShrineActive")
                    if shrine then
                        for _, part in pairs(shrine:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name:find("NeonShrinePart") then
                                ReplicatedStorage.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()
                                _tp(part.CFrame * CFrame.new(0, 2, 0))
                                break
                            end
                        end
                    else
                        local kitsuneLoc = Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island")
                        if kitsuneLoc then
                            _tp(kitsuneLoc.CFrame * CFrame.new(0, 500, 0))
                        end
                    end
                end)
            end
        end
    end)
end

-- Auto Collect Azure Ember (World 3)
if World3 then
    task.spawn(function()
        while task.wait(0.1) do
            if _G.Collect_Ember then
                pcall(function()
                    if Workspace:FindFirstChild("AttachedAzureEmber") or Workspace:FindFirstChild("EmberTemplate") then
                        local ember = Workspace:FindFirstChild("EmberTemplate") or Workspace:FindFirstChild("AttachedAzureEmber")
                        if ember and ember:FindFirstChild("Part") then
                            notween(ember.Part.CFrame)
                        end
                    else
                        local kitsuneLoc = Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island")
                        if kitsuneLoc then
                            _tp(kitsuneLoc.CFrame * CFrame.new(0, 500, 0))
                            ReplicatedStorage.Modules.Net["RF/KitsuneStatuePray"]:InvokeServer()
                        end
                    end
                end)
            end
        end
    end)
end

-- Auto Trade Azure Ember (World 3)
if World3 then
    task.spawn(function()
        while task.wait(0.1) do
            if _G.Trade_Ember then
                pcall(function()
                    if Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island", true) then
                        ReplicatedStorage.Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()
                    end
                end)
            end
        end
    end)
end

-- Teleport Frozen Dimension (World 3)
if World3 then
    task.spawn(function()
        while task.wait(0.1) do
            if _G.FrozenTP then
                pcall(function()
                    if Workspace.Map:FindFirstChild("LeviathanGate") then
                        _tp(Workspace.Map.LeviathanGate.CFrame)
                        commF:InvokeServer("OpenLeviathanGate")
                    end
                end)
            end
        end
    end)
end

-- Main Sea Event Farm Loop (Sea Beast, Shark, etc.)
task.spawn(function()
    while task.wait(1) do
        if _G.SailBoats then
            pcall(function()
                local char = plr.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                -- Priority targets
                local target = nil
                
                if _G.Leviathan1 then
                    target = Workspace.SeaBeasts:FindFirstChild("Leviathan")
                elseif _G.SeaBeast1 then
                    target = Workspace.SeaBeasts:FindFirstChild("SeaBeast1")
                elseif _G.TerrorShark then
                    target = Workspace.Enemies:FindFirstChild("Terrorshark")
                elseif _G.Shark then
                    target = Workspace.Enemies:FindFirstChild("Shark")
                elseif _G.Piranha then
                    target = Workspace.Enemies:FindFirstChild("Piranha")
                elseif _G.PGB then
                    target = Workspace.Enemies:FindFirstChild("PirateGrandBrigade") or Workspace.Enemies:FindFirstChild("PirateBrigade")
                elseif _G.MobCrew then
                    target = Workspace.Enemies:FindFirstChild("Fish Crew Member")
                elseif _G.HCM then
                    target = Workspace.Enemies:FindFirstChild("Haunted Crew Member")
                elseif _G.FishBoat then
                    target = Workspace.Enemies:FindFirstChild("FishBoat")
                end
                
                if target and G.Alive(target) then
                    local targetHRP = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target.PrimaryPart
                    if targetHRP then
                        _tp(targetHRP.CFrame * CFrame.new(0, _G.MobHeight, 0))
                        EquipWeapon(_G.SelectWeapon)
                        if G.Kill then
                            G.Kill(target, true)
                        end
                    end
                else
                    -- Sail to spawn area
                    if _G.DangerSc then
                        -- Use danger level position (simplified)
                        _tp(CFrame.new(-10000000, 31, 37016.25))
                    end
                end
            end)
        end
    end
end)

-- Use Skills during Sea Combat
function UseSelectedSkills()
    if _G.SelectedSkills.Melee.Z then Useskills("Melee", "Z") end
    if _G.SelectedSkills.Melee.X then Useskills("Melee", "X") end
    if _G.SelectedSkills.Melee.C then Useskills("Melee", "C") end
    if _G.SelectedSkills.Sword.Z then Useskills("Sword", "Z") end
    if _G.SelectedSkills.Sword.X then Useskills("Sword", "X") end
    if _G.SelectedSkills["Blox Fruit"].Z then Useskills("Blox Fruit", "Z") end
    if _G.SelectedSkills["Blox Fruit"].X then Useskills("Blox Fruit", "X") end
    if _G.SelectedSkills["Blox Fruit"].C then Useskills("Blox Fruit", "C") end
    if _G.SelectedSkills["Blox Fruit"].V then Useskills("Blox Fruit", "V") end
    if _G.SelectedSkills["Blox Fruit"].F then
        VirtualInputManager:SendKeyEvent(true, "F", false, game)
        VirtualInputManager:SendKeyEvent(false, "F", false, game)
    end
    if _G.SelectedSkills.Gun.Z then Useskills("Gun", "Z") end
    if _G.SelectedSkills.Gun.X then Useskills("Gun", "X") end
end

function Useskills(toolType, key)
    weaponSc(toolType)
    if key == "Z" then
        VirtualInputManager:SendKeyEvent(true, "Z", false, game)
        VirtualInputManager:SendKeyEvent(false, "Z", false, game)
    elseif key == "X" then
        VirtualInputManager:SendKeyEvent(true, "X", false, game)
        VirtualInputManager:SendKeyEvent(false, "X", false, game)
    elseif key == "C" then
        VirtualInputManager:SendKeyEvent(true, "C", false, game)
        VirtualInputManager:SendKeyEvent(false, "C", false, game)
    elseif key == "V" then
        VirtualInputManager:SendKeyEvent(true, "V", false, game)
        VirtualInputManager:SendKeyEvent(false, "V", false, game)
    end
end

print("========================================")
print("KuKi Hub | True V2 - Part 4 Loaded!")
print("Sea Event Tab Complete!")
print("========================================")

--[[
    KuKi Hub | True V2
    Part 5: Volcano/Dojo Tab - Prehistoric Island, Drago Trials, Dojo Quests
]]

-- ========================================
-- VOLCANO TAB SETUP
-- ========================================
local VolcanoPre = Tab7:CraftPage(1)      -- Prehistoric Island
local VolcanoCraft = Tab7:CraftPage(2)    -- Volcanic Crafting
local VolcanoDrago = Tab7:CraftPage(3)    -- Drago Trials
local VolcanoDojo = Tab7:CraftPage(4)     -- Dojo Quests

-- ========================================
-- GLOBAL VOLCANO VARIABLES
-- ========================================
_G.Prehis_Find = false
_G.AutoStartPrehistoric = false
_G.Prehis_Skills = false
_G.Prehis_KillGolem = false
_G.Prehis_DB = false
_G.Prehis_DE = false
_G.KillAura = false

_G.AutoCraftVolcanic = false
_G.UPGDrago = false
_G.DragoV1 = false
_G.AutoFireFlowers = false
_G.DragoV3 = false
_G.Relic123 = false
_G.TrainDrago = false
_G.TpDrago_Prehis = false
_G.BuyDrago = false
_G.DT_Uzoth = false

_G.Dojoo = false
_G.FarmBlazeEM = false

-- Prehistoric Skills
_G.PrehistoricSkills = _G.PrehistoricSkills or {
    Melee = {Z = true, X = true, C = true},
    Sword = {Z = true, X = true},
    ["Blox Fruit"] = {Z = true, X = true, C = true, V = false, F = false},
    Gun = {Z = true, X = true}
}

if _G.SaveData and _G.SaveData.PrehistoricSkills then
    _G.PrehistoricSkills = _G.SaveData.PrehistoricSkills
end

local KillAuraCounter = 0

-- ========================================
-- HELPER FUNCTIONS FOR PREHISTORIC
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

function GetHRP()
    local char = plr.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- ========================================
-- VOLCANO PREHISTORIC PAGE (PAGE 1)
-- ========================================
VolcanoPre:Seperator("🦕 Prehistoric Island")

local prehistoricStatus = VolcanoPre:AddParagraph({
    Title = "Island Status",
    Desc = "Checking..."
})

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local hasPre = Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island")
            prehistoricStatus:SetDesc(hasPre and "✅ Island Active" or "❌ Not Found")
        end)
    end
end)

VolcanoPre:Toggle({
    Name = "Auto Find Prehistoric Island",
    Default = GetSetting("Prehis_Find", false),
    Callback = function(value)
        _G.Prehis_Find = value
        _G.SaveData["Prehis_Find"] = value
        SaveSettings()
    end
})

VolcanoPre:Toggle({
    Name = "Auto Start Prehistoric Event",
    Default = GetSetting("AutoStartPrehistoric", false),
    Callback = function(value)
        _G.AutoStartPrehistoric = value
        _G.SaveData["AutoStartPrehistoric"] = value
        SaveSettings()
    end
})

VolcanoPre:Toggle({
    Name = "Auto Patch (Remove Lava)",
    Default = GetSetting("Prehis_Skills", false),
    Callback = function(value)
        _G.Prehis_Skills = value
        _G.SaveData["Prehis_Skills"] = value
        SaveSettings()
    end
})

VolcanoPre:Toggle({
    Name = "Auto Kill Lava Golem",
    Default = GetSetting("Prehis_KillGolem", false),
    Callback = function(value)
        _G.Prehis_KillGolem = value
        _G.SaveData["Prehis_KillGolem"] = value
        SaveSettings()
    end
})

VolcanoPre:Toggle({
    Name = "Auto Collect Dino Bones",
    Default = GetSetting("Prehis_DB", false),
    Callback = function(value)
        _G.Prehis_DB = value
        _G.SaveData["Prehis_DB"] = value
        SaveSettings()
    end
})

VolcanoPre:Toggle({
    Name = "Auto Collect Dragon Eggs",
    Default = GetSetting("Prehis_DE", false),
    Callback = function(value)
        _G.Prehis_DE = value
        _G.SaveData["Prehis_DE"] = value
        SaveSettings()
    end
})

VolcanoPre:Seperator("⚔️ Kill Aura")

local killAuraDisplay = VolcanoPre:AddParagraph({
    Title = "Kill Aura Stats",
    Desc = "Killed: 0"
})

task.spawn(function()
    while task.wait(1) do
        if _G.KillAura then
            killAuraDisplay:SetDesc("Killed: " .. KillAuraCounter .. " | Active")
        else
            killAuraDisplay:SetDesc("Killed: 0 | Disabled")
        end
    end
end)

VolcanoPre:Toggle({
    Name = "Kill Aura",
    Default = GetSetting("KillAura", false),
    Callback = function(value)
        _G.KillAura = value
        _G.SaveData["KillAura"] = value
        SaveSettings()
    end
})

VolcanoPre:Button({
    Name = "Reset Kill Counter",
    Callback = function()
        KillAuraCounter = 0
        killAuraDisplay:SetDesc("Killed: 0")
    end
})

-- Prehistoric Skills Selection
VolcanoPre:Seperator("🎯 Skill Selection (Prehistoric)")

VolcanoPre:Toggle({Name = "Pre - Melee Z", Default = _G.PrehistoricSkills.Melee.Z, Callback = function(v) _G.PrehistoricSkills.Melee.Z = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})
VolcanoPre:Toggle({Name = "Pre - Melee X", Default = _G.PrehistoricSkills.Melee.X, Callback = function(v) _G.PrehistoricSkills.Melee.X = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})
VolcanoPre:Toggle({Name = "Pre - Melee C", Default = _G.PrehistoricSkills.Melee.C, Callback = function(v) _G.PrehistoricSkills.Melee.C = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})

VolcanoPre:Toggle({Name = "Pre - Sword Z", Default = _G.PrehistoricSkills.Sword.Z, Callback = function(v) _G.PrehistoricSkills.Sword.Z = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})
VolcanoPre:Toggle({Name = "Pre - Sword X", Default = _G.PrehistoricSkills.Sword.X, Callback = function(v) _G.PrehistoricSkills.Sword.X = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})

VolcanoPre:Toggle({Name = "Pre - Fruit Z", Default = _G.PrehistoricSkills["Blox Fruit"].Z, Callback = function(v) _G.PrehistoricSkills["Blox Fruit"].Z = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})
VolcanoPre:Toggle({Name = "Pre - Fruit X", Default = _G.PrehistoricSkills["Blox Fruit"].X, Callback = function(v) _G.PrehistoricSkills["Blox Fruit"].X = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})
VolcanoPre:Toggle({Name = "Pre - Fruit C", Default = _G.PrehistoricSkills["Blox Fruit"].C, Callback = function(v) _G.PrehistoricSkills["Blox Fruit"].C = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})
VolcanoPre:Toggle({Name = "Pre - Fruit V", Default = _G.PrehistoricSkills["Blox Fruit"].V, Callback = function(v) _G.PrehistoricSkills["Blox Fruit"].V = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})
VolcanoPre:Toggle({Name = "Pre - Fruit F", Default = _G.PrehistoricSkills["Blox Fruit"].F, Callback = function(v) _G.PrehistoricSkills["Blox Fruit"].F = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})

VolcanoPre:Toggle({Name = "Pre - Gun Z", Default = _G.PrehistoricSkills.Gun.Z, Callback = function(v) _G.PrehistoricSkills.Gun.Z = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})
VolcanoPre:Toggle({Name = "Pre - Gun X", Default = _G.PrehistoricSkills.Gun.X, Callback = function(v) _G.PrehistoricSkills.Gun.X = v; _G.SaveData.PrehistoricSkills = _G.PrehistoricSkills; SaveSettings() end})

-- ========================================
-- VOLCANO CRAFT PAGE (PAGE 2)
-- ========================================
VolcanoCraft:Seperator("🔨 Volcanic Crafting")

VolcanoCraft:Button({
    Name = "Craft Volcanic Magnet (Manual)",
    Callback = function()
        pcall(function()
            local craftRemote = ReplicatedStorage.Modules.Net["RF/Craft"]
            craftRemote:InvokeServer("PossibleHardcode", "Volcanic Magnet")
            library:Notification({
                Title = "Crafting",
                Message = "Attempted to craft Volcanic Magnet",
                Duration = 3
            })
        end)
    end
})

VolcanoCraft:Toggle({
    Name = "Auto Craft Volcanic Magnet",
    Default = GetSetting("AutoCraftVolcanic", false),
    Callback = function(value)
        _G.AutoCraftVolcanic = value
        _G.SaveData["AutoCraftVolcanic"] = value
        SaveSettings()
    end
})

task.spawn(function()
    local craftRemote = ReplicatedStorage.Modules.Net["RF/Craft"]
    while task.wait(30) do
        if _G.AutoCraftVolcanic then
            pcall(function()
                craftRemote:InvokeServer("PossibleHardcode", "Volcanic Magnet")
            end)
        end
    end
end)

-- ========================================
-- VOLCANO DRAGO PAGE (PAGE 3)
-- ========================================
VolcanoDrago:Seperator("🐉 Drago Trials")

VolcanoDrago:Toggle({
    Name = "Tween To Upgrade Drago Trial",
    Default = GetSetting("UPGDrago", false),
    Callback = function(value)
        _G.UPGDrago = value
        _G.SaveData["UPGDrago"] = value
        SaveSettings()
    end
})

VolcanoDrago:Toggle({
    Name = "Auto Drago (V1) - Get Dragon Egg",
    Default = GetSetting("DragoV1", false),
    Callback = function(value)
        _G.DragoV1 = value
        _G.SaveData["DragoV1"] = value
        SaveSettings()
    end
})

VolcanoDrago:Toggle({
    Name = "Auto Drago (V2) - Fire Flowers",
    Default = GetSetting("AutoFireFlowers", false),
    Callback = function(value)
        _G.AutoFireFlowers = value
        _G.SaveData["AutoFireFlowers"] = value
        SaveSettings()
    end
})

VolcanoDrago:Toggle({
    Name = "Auto Drago (V3) - Terror Shark/Sea Beast",
    Default = GetSetting("DragoV3", false),
    Callback = function(value)
        _G.DragoV3 = value
        _G.SaveData["DragoV3"] = value
        SaveSettings()
    end
})

VolcanoDrago:Toggle({
    Name = "Auto Relic Drago Trial [Beta]",
    Default = GetSetting("Relic123", false),
    Callback = function(value)
        _G.Relic123 = value
        _G.SaveData["Relic123"] = value
        SaveSettings()
    end
})

VolcanoDrago:Toggle({
    Name = "Auto Train Drago v4",
    Default = GetSetting("TrainDrago", false),
    Callback = function(value)
        _G.TrainDrago = value
        _G.SaveData["TrainDrago"] = value
        SaveSettings()
    end
})

VolcanoDrago:Toggle({
    Name = "Tween to Drago Trials (Inside Volcano)",
    Default = GetSetting("TpDrago_Prehis", false),
    Callback = function(value)
        _G.TpDrago_Prehis = value
        _G.SaveData["TpDrago_Prehis"] = value
        SaveSettings()
    end
})

VolcanoDrago:Toggle({
    Name = "Swap Drago Race (Buy)",
    Default = GetSetting("BuyDrago", false),
    Callback = function(value)
        _G.BuyDrago = value
        _G.SaveData["BuyDrago"] = value
        SaveSettings()
    end
})

VolcanoDrago:Toggle({
    Name = "Upgrade Dragon Talon With Uzoth",
    Default = GetSetting("DT_Uzoth", false),
    Callback = function(value)
        _G.DT_Uzoth = value
        _G.SaveData["DT_Uzoth"] = value
        SaveSettings()
    end
})

-- ========================================
-- VOLCANO DOJO PAGE (PAGE 4)
-- ========================================
VolcanoDojo:Seperator("🥋 Dojo Quests")

VolcanoDojo:Button({
    Name = "Teleport To Dragon Dojo",
    Callback = function()
        pcall(function()
            commF:InvokeServer("requestEntrance", Vector3.new(5661.5322, 1013.0907, -334.9649))
            _tp(CFrame.new(5814.4272, 1208.3267, 884.5785))
            library:Notification({
                Title = "Dojo",
                Message = "Teleported to Dragon Dojo!",
                Duration = 3
            })
        end)
    end
})

VolcanoDojo:Toggle({
    Name = "Auto Dojo Trainer (Complete Quests)",
    Default = GetSetting("Dojoo", false),
    Callback = function(value)
        _G.Dojoo = value
        _G.SaveData["Dojoo"] = value
        SaveSettings()
    end
})

VolcanoDojo:Toggle({
    Name = "Auto Dragon Hunter (Hydra/Venomous)",
    Default = GetSetting("FarmBlazeEM", false),
    Callback = function(value)
        _G.FarmBlazeEM = value
        _G.SaveData["FarmBlazeEM"] = value
        SaveSettings()
    end
})

-- ========================================
-- LOGIC LOOPS - PREHISTORIC
-- ========================================

-- Auto Find Prehistoric Island
task.spawn(function()
    while task.wait(1) do
        if _G.Prehis_Find then
            pcall(function()
                local char = plr.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local prehistoricLoc = Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island", true)
                
                if not prehistoricLoc then
                    local myBoat = CheckBoat()
                    if not myBoat then
                        local boatPos = CFrame.new(-16927.451, 9.086, 433.864)
                        _tp(boatPos)
                        if (boatPos.Position - hrp.Position).Magnitude <= 10 then
                            commF:InvokeServer("BuyBoat", _G.SelectedBoat or "Guardian")
                        end
                        return
                    end
                    
                    if char.Humanoid.Sit == false then
                        local seatPos = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)
                        _tp(seatPos)
                        return
                    end
                    
                    local targetPos = CFrame.new(-10000000, 31, 37016.25)
                    if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
                        _tp(CFrame.new(-10000000, 150, 37016.25))
                    else
                        _tp(targetPos)
                    end
                else
                    local teleportPart = prehistoricLoc:FindFirstChild("HeadTeleport", true) or prehistoricLoc:FindFirstChild("Teleport_Head", true) or prehistoricLoc:FindFirstChild("Head", true)
                    if teleportPart then
                        local targetPos = teleportPart.CFrame.Position - teleportPart.CFrame.LookVector * 40 + Vector3.new(0, 20, 0)
                        if (targetPos - hrp.Position).Magnitude > 30 then
                            _tp(CFrame.new(targetPos))
                        end
                    else
                        local centerPos = prehistoricLoc.CFrame.Position
                        local dirToIsland = (centerPos - hrp.Position).Unit
                        local safePos = centerPos - dirToIsland * 250 + Vector3.new(0, 60, 0)
                        _tp(CFrame.new(safePos))
                    end
                end
            end)
        end
    end
end)

-- Auto Start Prehistoric Event
task.spawn(function()
    while task.wait(1) do
        if _G.AutoStartPrehistoric then
            pcall(function()
                local prehistoricLoc = Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island", true)
                if prehistoricLoc then
                    if Workspace.Map:FindFirstChild("PrehistoricIsland", true) then
                        local coreActivation = Workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt", true)
                        if coreActivation and coreActivation:FindFirstChild("ProximityPrompt") then
                            if plr:DistanceFromCharacter(coreActivation.CFrame.Position) <= 150 then
                                fireproximityprompt(coreActivation.ProximityPrompt, math.huge)
                                VirtualInputManager:SendKeyEvent(true, "E", false, game)
                                task.wait(1.5)
                                VirtualInputManager:SendKeyEvent(false, "E", false, game)
                            end
                            _tp(coreActivation.CFrame)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Patch (Remove Lava)
task.spawn(function()
    while task.wait(0.3) do
        if _G.Prehis_Skills then
            pcall(function()
                local prehistoricMap = Workspace.Map:FindFirstChild("PrehistoricIsland")
                if not prehistoricMap then return end
                
                for _, obj in pairs(prehistoricMap:GetDescendants()) do
                    if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and (obj.Name:lower()):find("lava") then
                        obj:Destroy()
                    end
                end
                
                local core = prehistoricMap:FindFirstChild("Core")
                if core then
                    local interiorLava = core:FindFirstChild("InteriorLava")
                    if interiorLava then interiorLava:Destroy() end
                end
                
                local trialTeleport = prehistoricMap:FindFirstChild("TrialTeleport")
                for _, obj in pairs(prehistoricMap:GetDescendants()) do
                    if obj.Name == "TouchInterest" and not(trialTeleport and obj:IsDescendantOf(trialTeleport)) then
                        obj.Parent:Destroy()
                    end
                end
            end)
        end
    end
end)

-- Auto Kill Lava Golem
task.spawn(function()
    while task.wait(1) do
        if _G.Prehis_KillGolem then
            pcall(function()
                local golem = GetConnectionEnemies("Lava Golem")
                if golem and golem:FindFirstChild("Humanoid") then
                    repeat
                        task.wait(0.1)
                        _tp(golem.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                        UsePrehistoricSkills()
                        golem.Humanoid:ChangeState(15)
                    until not _G.Prehis_KillGolem or not golem.Parent or golem.Humanoid.Health <= 0
                end
            end)
        end
    end
end)

-- Auto Collect Dino Bones
task.spawn(function()
    while task.wait(0.5) do
        if _G.Prehis_DB then
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name == "DinoBone" and obj:IsA("BasePart") then
                        _tp(obj.CFrame)
                    end
                end
            end)
        end
    end
end)

-- Auto Collect Dragon Eggs
task.spawn(function()
    while task.wait(1) do
        if _G.Prehis_DE then
            pcall(function()
                local prehistoricMap = Workspace.Map:FindFirstChild("PrehistoricIsland")
                if prehistoricMap then
                    local core = prehistoricMap:FindFirstChild("Core")
                    if core then
                        local eggFolder = core:FindFirstChild("SpawnedDragonEggs")
                        if eggFolder then
                            local egg = eggFolder:FindFirstChild("DragonEgg")
                            if egg and egg:FindFirstChild("Molten") then
                                _tp(egg.Molten.CFrame)
                                fireproximityprompt(egg.Molten.ProximityPrompt, 30)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Kill Aura Loop
task.spawn(function()
    while task.wait(2) do
        if _G.KillAura then
            pcall(function()
                local hrp = GetHRP()
                if not hrp then return end
                
                pcall(function()
                    sethiddenproperty(plr, "SimulationRadius", math.huge)
                end)
                
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    local hum = enemy:FindFirstChild("Humanoid")
                    local root = enemy:FindFirstChild("HumanoidRootPart")
                    
                    if hum and root and hum.Health > 0 then
                        local dist = (root.Position - hrp.Position).Magnitude
                        if dist <= 1000 then
                            hum.Health = 0
                            root.CanCollide = false
                            enemy:BreakJoints()
                            KillAuraCounter = KillAuraCounter + 1
                        end
                    end
                end
            end)
        end
    end
end)

-- ========================================
-- LOGIC LOOPS - DRAGO TRIALS
-- ========================================

-- UPGDrago Logic
task.spawn(function()
    while task.wait(1) do
        if _G.UPGDrago then
            pcall(function()
                local dojoPos = CFrame.new(5814.4272, 1208.3267, 884.5785)
                local hrp = GetHRP()
                if hrp then
                    if (dojoPos.Position - hrp.Position).Magnitude >= 300 then
                        _tp(dojoPos)
                    else
                        local args = {{NPC = "Dragon Wizard", Command = "Upgrade"}}
                        ReplicatedStorage.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
                    end
                end
            end)
        end
    end
end)

-- Drago V1 Logic
task.spawn(function()
    while task.wait(1) do
        if _G.DragoV1 then
            pcall(function()
                if GetM("Dragon Egg") <= 0 then
                    _G.Prehis_Find = true
                    _G.Prehis_Skills = true
                    _G.Prehis_DE = true
                else
                    _G.Prehis_Find = false
                    _G.Prehis_Skills = false
                    _G.Prehis_DE = false
                end
            end)
        end
    end
end)

-- Auto Fire Flowers Logic
task.spawn(function()
    while task.wait(1) do
        if _G.AutoFireFlowers then
            pcall(function()
                local fireFlowers = Workspace:FindFirstChild("FireFlowers")
                local forestPirate = GetConnectionEnemies("Forest Pirate")
                
                if forestPirate then
                    G.Kill(forestPirate, true)
                else
                    _tp(CFrame.new(-13206.45, 425.89, -7964.55))
                end
                
                if fireFlowers then
                    local hrp = GetHRP()
                    for _, flower in pairs(fireFlowers:GetChildren()) do
                        if flower:IsA("Model") and flower.PrimaryPart and hrp then
                            local dist = (flower.PrimaryPart.Position - hrp.Position).Magnitude
                            if dist <= 100 then
                                VirtualInputManager:SendKeyEvent(true, "E", false, game)
                                task.wait(1.5)
                                VirtualInputManager:SendKeyEvent(false, "E", false, game)
                            else
                                _tp(CFrame.new(flower.PrimaryPart.Position))
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Drago V3 Logic
task.spawn(function()
    while task.wait(1) do
        if _G.DragoV3 then
            pcall(function()
                _G.DangerSc = "Lv Infinite"
                _G.SailBoats = true
                _G.TerrorShark = true
            end)
        elseif not _G.DragoV3 and _G.DangerSc == "Lv Infinite" then
            _G.DangerSc = "Lv 1"
            _G.SailBoats = false
            _G.TerrorShark = false
        end
    end
end)

-- Auto Relic Logic
task.spawn(function()
    while task.wait(1) do
        if _G.Relic123 then
            pcall(function()
                local hrp = GetHRP()
                if not hrp then return end
                
                if Workspace.Map:FindFirstChild("DracoTrial") then
                    ReplicatedStorage.Remotes["DracoTrial"]:InvokeServer()
                    task.wait(0.5)
                    
                    local relicSpots = {
                        CFrame.new(-39934.97, 10685.35, 22999.34),
                        CFrame.new(-40511.25, 9376.40, 23458.37),
                        CFrame.new(-39914.65, 10685.38, 23000.17),
                        CFrame.new(-40045.83, 9376.39, 22791.28),
                        CFrame.new(-39908.50, 10685.40, 22990.04),
                        CFrame.new(-39609.50, 9376.40, 23472.94)
                    }
                    
                    for _, spot in ipairs(relicSpots) do
                        repeat
                            task.wait()
                            _tp(spot)
                        until not _G.Relic123 or (spot.Position - hrp.Position).Magnitude <= 10
                        task.wait(2.5)
                    end
                else
                    local trialTeleport = Workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")
                    if trialTeleport and trialTeleport:IsA("Part") then
                        _tp(CFrame.new(trialTeleport.Position))
                    end
                end
            end)
        end
    end
end)

-- Train Drago Logic
task.spawn(function()
    while task.wait(1) do
        if _G.TrainDrago then
            pcall(function()
                local dragonMobs = {"Venomous Assailant", "Hydra Enforcer"}
                local raceEnergy = plr.Character and plr.Character:FindFirstChild("RaceEnergy")
                
                if raceEnergy and raceEnergy.Value == 1 then
                    VirtualInputManager:SendKeyEvent(true, "Y", false, game)
                    commF:InvokeServer("UpgradeRace", "Buy", 2)
                    _tp(CFrame.new(4620.61, 1002.29, 399.08))
                elseif plr.Character:FindFirstChild("RaceTransformed") and plr.Character.RaceTransformed.Value == false then
                    local mob = GetConnectionEnemies(dragonMobs)
                    if mob then
                        G.Kill(mob, true)
                    else
                        _tp(CFrame.new(4620.61, 1002.29, 399.08))
                    end
                end
            end)
        end
    end
end)

-- TpDrago_Prehis Logic
task.spawn(function()
    while task.wait(0.5) do
        if _G.TpDrago_Prehis then
            pcall(function()
                local trialTeleport = Workspace.Map.PrehistoricIsland and Workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")
                if trialTeleport and trialTeleport:IsA("Part") then
                    _tp(CFrame.new(trialTeleport.Position))
                end
            end)
        end
    end
end)

-- BuyDrago Logic
task.spawn(function()
    while task.wait(1) do
        if _G.BuyDrago then
            pcall(function()
                local dojoPos = CFrame.new(5814.4272, 1208.3267, 884.5785)
                local hrp = GetHRP()
                if hrp then
                    if (dojoPos.Position - hrp.Position).Magnitude >= 300 then
                        _tp(dojoPos)
                    else
                        local args = {{NPC = "Dragon Wizard", Command = "DragonRace"}}
                        ReplicatedStorage.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
                    end
                end
            end)
        end
    end
end)

-- DT_Uzoth Logic
task.spawn(function()
    while task.wait(1) do
        if _G.DT_Uzoth then
            pcall(function()
                local uzothPos = CFrame.new(5661.89, 1211.31, 864.83)
                local hrp = GetHRP()
                if hrp then
                    _tp(uzothPos)
                    if (uzothPos.Position - hrp.Position).Magnitude <= 25 then
                        local args = {NPC = "Uzoth", Command = "Upgrade"}
                        ReplicatedStorage.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(args)
                    end
                end
            end)
        end
    end
end)

-- ========================================
-- LOGIC LOOPS - DOJO / DRAGON HUNTER
-- ========================================

-- Dragon Hunter Quest Check
function checkDragonHunterQuest()
    local success, result = pcall(function()
        return ReplicatedStorage.Modules.Net["RF/DragonHunter"]:InvokeServer({Context = "Check"})
    end)
    
    if success and result and result.Text then
        if string.find(result.Text, "Defeat") then
            local mobName = nil
            if string.find(result.Text, "Hydra Enforcer") then mobName = "Hydra Enforcer" end
            if string.find(result.Text, "Venomous Assailant") then mobName = "Venomous Assailant" end
            return "kill", mobName
        elseif string.find(result.Text, "Destroy") then
            return "destroy", nil
        end
    end
    return nil, nil
end

function backToDojo()
    for _, notif in pairs(plr.PlayerGui.Notifications:GetChildren()) do
        if notif.Name == "NotificationTemplate" and string.find(notif.Text, "Head back to the Dojo") then
            return true
        end
    end
    return false
end

-- Auto Dragon Hunter (Blaze EM)
task.spawn(function()
    while task.wait(1) do
        if _G.FarmBlazeEM then
            pcall(function()
                local questType, mobName = checkDragonHunterQuest()
                
                if questType and not backToDojo() then
                    if questType == "kill" and mobName then
                        local mob = GetConnectionEnemies(mobName)
                        if mob then
                            G.Kill(mob, true)
                        else
                            local spawnPos = (mobName == "Hydra Enforcer") and CFrame.new(4620.61, 1002.29, 399.08) or CFrame.new(4674.92, 1134.82, 996.30)
                            _tp(spawnPos)
                        end
                    elseif questType == "destroy" then
                        local bamboo = Workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true)
                        if bamboo then
                            _tp(bamboo.CFrame * CFrame.new(4, 0, 0))
                            local hrp = GetHRP()
                            if hrp and (bamboo.Position - hrp.Position).Magnitude <= 200 then
                                UsePrehistoricSkills()
                            end
                        end
                    end
                else
                    _tp(CFrame.new(5813, 1208, 884))
                end
            end)
        end
    end
end)

-- Auto Collect Ember for Dragon Hunter
task.spawn(function()
    while task.wait(0.5) do
        if _G.FarmBlazeEM then
            pcall(function()
                if Workspace:FindFirstChild("EmberTemplate") and Workspace.EmberTemplate:FindFirstChild("Part") then
                    _tp(Workspace.EmberTemplate.Part.CFrame)
                end
            end)
        end
    end
end)

print("========================================")
print("KuKi Hub | True V2 - Part 5 Loaded!")
print("Volcano/Dojo Tab Complete!")
print("========================================")

--[[
    KuKi Hub | True V2
    Part 6: Mirage/Race Tab - Mirage Island, Race V4, Moon, Race Upgrades
]]

-- ========================================
-- MIRAGE TAB SETUP
-- ========================================
local MirageMain = Tab8:CraftPage(1)      -- Mirage Island
local MirageRace = Tab8:CraftPage(2)      -- Race V4 / Temple
local MirageMoon = Tab8:CraftPage(3)      -- Moon / V3 V4
local MirageUpgrade = Tab8:CraftPage(4)   -- Race Upgrades V2/V3

-- ========================================
-- GLOBAL MIRAGE VARIABLES
-- ========================================
_G.FindMirage = false
_G.AutoMysticIsland = false
_G.HighestMirage = false
_G.MirageIslandESP = false
_G.FarmChestM = false
_G.can = false
_G.TPGEAR = false
_G.Addealer = false

_G.Lver = false
_G.AcientOne = false
_G.TPDoor = false
_G.Complete_Trials = false
_G.Defeating = false

_G.LookM = false
_G.LookMV3 = false

_G.Auto_Mink = false
_G.Auto_Human = false
_G.Auto_Skypiea = false
_G.Auto_Fish = false

-- ========================================
-- HELPER FUNCTIONS FOR MIRAGE
-- ========================================
function GetMoonTexture()
    if World1 or World2 then
        return Lighting.FantasySky and Lighting.FantasySky.MoonTextureId or ""
    elseif World3 then
        return Lighting.Sky and Lighting.Sky.MoonTextureId or ""
    end
    return ""
end

function MoveCamToMoon()
    local moonDir = Lighting:GetMoonDirection()
    Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, Workspace.CurrentCamera.CFrame.Position + moonDir)
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
                local dist = (beast.HumanoidRootPart.Position - trialLoc.Position).Magnitude
                if dist <= 1500 then
                    return beast
                end
            end
        end
    end
    return nil
end

-- ========================================
-- MIRAGE MAIN PAGE (PAGE 1)
-- ========================================
MirageMain:Seperator("🌫️ Mirage Island Status")

local fullMoonStatus = MirageMain:AddParagraph({
    Title = "Full Moon Status",
    Desc = "Checking..."
})

local mirageIslandStatus = MirageMain:AddParagraph({
    Title = "Mirage Island Status",
    Desc = "Checking..."
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local moonId = GetMoonTexture()
            local moonPhases = {
                ["http://www.roblox.com/asset/?id=9709135895"] = "0/8",
                ["http://www.roblox.com/asset/?id=9709139597"] = "1/8",
                ["http://www.roblox.com/asset/?id=9709143733"] = "2/8",
                ["http://www.roblox.com/asset/?id=9709149052"] = "3/8 [Next Night]",
                ["http://www.roblox.com/asset/?id=9709149431"] = "4/8 [Full Moon] 🌕",
                ["http://www.roblox.com/asset/?id=9709149680"] = "5/8 [Last Night]",
                ["http://www.roblox.com/asset/?id=9709150086"] = "6/8",
                ["http://www.roblox.com/asset/?id=9709150401"] = "7/8"
            }
            fullMoonStatus:SetDesc(moonPhases[moonId] or "0/8")
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local hasMirage = Workspace.Map:FindFirstChild("MysticIsland") or Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island")
            mirageIslandStatus:SetDesc(hasMirage and "✅ Mirage Island Active" or "❌ Not Found")
        end)
    end
end)

MirageMain:Seperator("🏝️ Mirage Island Features")

MirageMain:Toggle({
    Name = "Auto Find Mirage Island",
    Default = GetSetting("FindMirage", false),
    Callback = function(value)
        _G.FindMirage = value
        _G.SaveData["FindMirage"] = value
        SaveSettings()
    end
})

MirageMain:Toggle({
    Name = "Auto Tween To Mirage Island",
    Default = GetSetting("AutoMysticIsland", false),
    Callback = function(value)
        _G.AutoMysticIsland = value
        _G.SaveData["AutoMysticIsland"] = value
        SaveSettings()
    end
})

MirageMain:Toggle({
    Name = "Auto Tween To Highest Point",
    Default = GetSetting("HighestMirage", false),
    Callback = function(value)
        _G.HighestMirage = value
        _G.SaveData["HighestMirage"] = value
        SaveSettings()
    end
})

MirageMain:Toggle({
    Name = "Esp Mirage Island",
    Default = GetSetting("MirageIslandESP", false),
    Callback = function(value)
        _G.MirageIslandESP = value
        _G.SaveData["MirageIslandESP"] = value
        SaveSettings()
    end
})

MirageMain:Toggle({
    Name = "Auto Collect Mirage Chest",
    Default = GetSetting("FarmChestM", false),
    Callback = function(value)
        _G.FarmChestM = value
        _G.SaveData["FarmChestM"] = value
        SaveSettings()
    end
})

MirageMain:Toggle({
    Name = "Change Transparency (See Mirage)",
    Default = GetSetting("can", false),
    Callback = function(value)
        _G.can = value
        _G.SaveData["can"] = value
        SaveSettings()
    end
})

MirageMain:Toggle({
    Name = "Auto Collect Gear",
    Default = GetSetting("TPGEAR", false),
    Callback = function(value)
        _G.TPGEAR = value
        _G.SaveData["TPGEAR"] = value
        SaveSettings()
    end
})

MirageMain:Seperator("🍎 Advanced Fruit Dealer")

MirageMain:Toggle({
    Name = "Auto Tween Advanced Fruit Dealer",
    Default = GetSetting("Addealer", false),
    Callback = function(value)
        _G.Addealer = value
        _G.SaveData["Addealer"] = value
        SaveSettings()
    end
})

-- ========================================
-- MIRAGE RACE PAGE (PAGE 2) - Race V4 / Temple of Time
-- ========================================
MirageRace:Seperator("⏳ Temple of Time")

MirageRace:Button({
    Name = "Teleport to Temple of Time",
    Callback = function()
        pcall(function()
            local templePos = CFrame.new(28286.35, 14895.30, 102.62)
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = templePos
            end
            if not Workspace.Map:FindFirstChild("Temple of Time") and World3 then
                local mapStash = ReplicatedStorage:FindFirstChild("MapStash")
                if mapStash and mapStash:FindFirstChild("Temple of Time") then
                    mapStash["Temple of Time"].Parent = Workspace.Map
                end
            end
            library:Notification({Title = "Temple", Message = "Teleported to Temple of Time", Duration = 3})
        end)
    end
})

MirageRace:Button({
    Name = "Teleport to Ancient One",
    Callback = function()
        pcall(function()
            local templePos = CFrame.new(28286.35, 14895.30, 102.62)
            local ancientPos = CFrame.new(28981.55, 14888.42, -120.24)
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = templePos
            end
            if not Workspace.Map:FindFirstChild("Temple of Time") and World3 then
                local mapStash = ReplicatedStorage:FindFirstChild("MapStash")
                if mapStash and mapStash:FindFirstChild("Temple of Time") then
                    mapStash["Temple of Time"].Parent = Workspace.Map
                end
            end
            task.wait(2)
            _tp(ancientPos)
            library:Notification({Title = "Temple", Message = "Teleported to Ancient One", Duration = 3})
        end)
    end
})

MirageRace:Button({
    Name = "Teleport to Ancient Clock",
    Callback = function()
        pcall(function()
            local templePos = CFrame.new(28286.35, 14895.30, 102.62)
            local clockPos = CFrame.new(29549, 15069, -88)
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = templePos
            end
            if not Workspace.Map:FindFirstChild("Temple of Time") and World3 then
                local mapStash = ReplicatedStorage:FindFirstChild("MapStash")
                if mapStash and mapStash:FindFirstChild("Temple of Time") then
                    mapStash["Temple of Time"].Parent = Workspace.Map
                end
            end
            task.delay(2, function() _tp(clockPos) end)
            library:Notification({Title = "Temple", Message = "Teleported to Ancient Clock", Duration = 3})
        end)
    end
})

MirageRace:Button({
    Name = "Talk With Stone",
    Callback = function()
        pcall(function()
            commF:InvokeServer("RaceV4Progress", "Begin")
            commF:InvokeServer("RaceV4Progress", "Check")
            commF:InvokeServer("RaceV4Progress", "Teleport")
            commF:InvokeServer("RaceV4Progress", "Continue")
            library:Notification({Title = "Race V4", Message = "Talked with Stone", Duration = 3})
        end)
    end
})

local tiersStatus = MirageRace:AddParagraph({
    Title = "Tiers V4 Status",
    Desc = "Checking..."
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if plr.Data and plr.Data.Race and plr.Data.Race:FindFirstChild("C") then
                tiersStatus:SetDesc("Tiers - V4: " .. tostring(plr.Data.Race.C.Value))
            else
                tiersStatus:SetDesc("Tiers - V4: 0")
            end
        end)
    end
end)

MirageRace:Seperator("🧪 Trials Quest V4")

MirageRace:Toggle({
    Name = "Auto Pull Lever",
    Default = GetSetting("Lver", false),
    Callback = function(value)
        _G.Lver = value
        _G.SaveData["Lver"] = value
        SaveSettings()
    end
})

MirageRace:Toggle({
    Name = "Auto Train V4",
    Default = GetSetting("AcientOne", false),
    Callback = function(value)
        _G.AcientOne = value
        _G.SaveData["AcientOne"] = value
        SaveSettings()
    end
})

MirageRace:Toggle({
    Name = "Auto Teleport to Race Doors",
    Default = GetSetting("TPDoor", false),
    Callback = function(value)
        _G.TPDoor = value
        _G.SaveData["TPDoor"] = value
        SaveSettings()
    end
})

MirageRace:Toggle({
    Name = "Auto Complete Trials",
    Default = GetSetting("Complete_Trials", false),
    Callback = function(value)
        _G.Complete_Trials = value
        _G.SaveData["Complete_Trials"] = value
        SaveSettings()
    end
})

MirageRace:Toggle({
    Name = "Auto Kill Player After Trial",
    Default = GetSetting("Defeating", false),
    Callback = function(value)
        _G.Defeating = value
        _G.SaveData["Defeating"] = value
        SaveSettings()
    end
})

-- ========================================
-- MIRAGE MOON PAGE (PAGE 3)
-- ========================================
MirageMoon:Seperator("🌙 Moon / Race Abilities")

MirageMoon:Toggle({
    Name = "Auto Look At Moon",
    Default = GetSetting("LookM", false),
    Callback = function(value)
        _G.LookM = value
        _G.SaveData["LookM"] = value
        SaveSettings()
    end
})

MirageMoon:Toggle({
    Name = "Look Moon + Auto V3",
    Default = GetSetting("LookMV3", false),
    Callback = function(value)
        _G.LookMV3 = value
        _G.SaveData["LookMV3"] = value
        SaveSettings()
    end
})

-- ========================================
-- MIRAGE UPGRADE PAGE (PAGE 4) - Race V2/V3
-- ========================================
MirageUpgrade:Seperator("⬆️ Upgrade Races V2 And V3")

MirageUpgrade:Toggle({
    Name = "Auto Upgrade Mink",
    Default = GetSetting("Auto_Mink", false),
    Callback = function(value)
        _G.Auto_Mink = value
        _G.SaveData["Auto_Mink"] = value
        SaveSettings()
    end
})

MirageUpgrade:Toggle({
    Name = "Auto Upgrade Human",
    Default = GetSetting("Auto_Human", false),
    Callback = function(value)
        _G.Auto_Human = value
        _G.SaveData["Auto_Human"] = value
        SaveSettings()
    end
})

MirageUpgrade:Toggle({
    Name = "Auto Upgrade Angel",
    Default = GetSetting("Auto_Skypiea", false),
    Callback = function(value)
        _G.Auto_Skypiea = value
        _G.SaveData["Auto_Skypiea"] = value
        SaveSettings()
    end
})

MirageUpgrade:Toggle({
    Name = "Auto Upgrade Fishman",
    Default = GetSetting("Auto_Fish", false),
    Callback = function(value)
        _G.Auto_Fish = value
        _G.SaveData["Auto_Fish"] = value
        SaveSettings()
    end
})

-- ========================================
-- LOGIC LOOPS - MIRAGE ISLAND
-- ========================================

-- Auto Find Mirage Island
task.spawn(function()
    while task.wait() do
        if _G.FindMirage then
            pcall(function()
                if not Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island", true) then
                    local myBoat = CheckBoat()
                    if not myBoat then
                        local boatPos = CFrame.new(-16927.451, 9.086, 433.864)
                        _tp(boatPos)
                        if (boatPos.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                            commF:InvokeServer("BuyBoat", _G.SelectedBoat or "Guardian")
                        end
                    else
                        if plr.Character.Humanoid.Sit == false then
                            local seatPos = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)
                            _tp(seatPos)
                        else
                            local targetPos = CFrame.new(-10000000, 31, 37016.25)
                            repeat
                                task.wait()
                                if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
                                    _tp(CFrame.new(-10000000, 150, 37016.25))
                                else
                                    _tp(targetPos)
                                end
                            until not _G.FindMirage or (targetPos.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 or Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") or plr.Character.Humanoid.Sit == false
                            plr.Character.Humanoid.Sit = false
                        end
                    end
                else
                    _tp(Workspace.Map.MysticIsland.Center.CFrame * CFrame.new(0, 300, 0))
                end
            end)
        end
    end
end)

-- Auto Tween To Mirage Island
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoMysticIsland then
            pcall(function()
                for _, loc in pairs(Workspace._WorldOrigin.Locations:GetChildren()) do
                    if loc.Name == "Mirage Island" then
                        _tp(loc.CFrame * CFrame.new(0, 333, 0))
                    end
                end
            end)
        end
    end
end)

-- Auto Tween To Highest Point
task.spawn(function()
    while task.wait(1) do
        if _G.HighestMirage then
            pcall(function()
                if Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island", true) then
                    _tp(Workspace.Map.MysticIsland.Center.CFrame * CFrame.new(0, 400, 0))
                end
            end)
        end
    end
end)

-- Change Transparency (See Mirage)
task.spawn(function()
    while task.wait(1) do
        if _G.can then
            pcall(function()
                local mysticIsland = Workspace.Map:FindFirstChild("MysticIsland")
                if mysticIsland then
                    for _, part in pairs(mysticIsland:GetChildren()) do
                        if part.Name == "Part" then
                            if part.ClassName == "MeshPart" then
                                part.Transparency = 0
                            else
                                part.Transparency = 1
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Collect Gear
task.spawn(function()
    while task.wait(0.1) do
        if _G.TPGEAR then
            pcall(function()
                local mysticIsland = Workspace.Map:FindFirstChild("MysticIsland")
                if mysticIsland then
                    for _, part in pairs(mysticIsland:GetChildren()) do
                        if part.Name == "Part" and part.ClassName == "MeshPart" then
                            _tp(part.CFrame)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Collect Mirage Chest
task.spawn(function()
    while task.wait(0.2) do
        if _G.FarmChestM then
            pcall(function()
                local mysticIsland = Workspace.Map:FindFirstChild("MysticIsland")
                if mysticIsland and mysticIsland:FindFirstChild("Chests") then
                    if mysticIsland.Chests:FindFirstChild("DiamondChest") or mysticIsland.Chests:FindFirstChild("FragChest") then
                        local chests = CollectionService:GetTagged("_ChestTagged")
                        local minDist, nearestChest = math.huge, nil
                        local myPos = plr.Character and plr.Character:GetPivot().Position
                        if myPos then
                            for _, chest in pairs(chests) do
                                local dist = (chest:GetPivot().Position - myPos).Magnitude
                                if not chest:GetAttribute("IsDisabled") and dist < minDist then
                                    minDist = dist
                                    nearestChest = chest
                                end
                            end
                        end
                        if nearestChest then
                            _tp(nearestChest:GetPivot())
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Tween Advanced Fruit Dealer
task.spawn(function()
    while task.wait() do
        if _G.Addealer then
            pcall(function()
                for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                    if npc.Name == "Advanced Fruit Dealer" then
                        _tp(npc.HumanoidRootPart.CFrame)
                    end
                end
            end)
        end
    end
end)

-- ========================================
-- LOGIC LOOPS - RACE TRIALS
-- ========================================

-- Auto Pull Lever
task.spawn(function()
    while task.wait(0.5) do
        if _G.Lver then
            pcall(function()
                local temple = Workspace.Map:FindFirstChild("Temple of Time")
                if temple then
                    for _, obj in pairs(temple:GetDescendants()) do
                        if obj.Name == "ProximityPrompt" then
                            fireproximityprompt(obj, math.huge)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Train V4
task.spawn(function()
    while task.wait(1) do
        if _G.AcientOne then
            pcall(function()
                local boneMobs = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}
                local raceEnergy = plr.Character and plr.Character:FindFirstChild("RaceEnergy")
                local raceTransformed = plr.Character and plr.Character:FindFirstChild("RaceTransformed")
                
                if raceEnergy and raceEnergy.Value == 1 then
                    VirtualInputManager:SendKeyEvent(true, "Y", false, game)
                    commF:InvokeServer("UpgradeRace", "Buy")
                    _tp(CFrame.new(-8987.04, 215.86, 5886.71))
                elseif raceTransformed and raceTransformed.Value == false then
                    local mob = GetConnectionEnemies(boneMobs)
                    if mob then
                        G.Kill(mob, true)
                    else
                        _tp(CFrame.new(-9495.68, 453.58, 5977.34))
                    end
                end
            end)
        end
    end
end)

-- Auto Teleport to Race Doors
task.spawn(function()
    while task.wait(1) do
        if _G.TPDoor then
            pcall(function()
                local race = tostring(plr.Data.Race.Value)
                local doorPositions = {
                    Mink = CFrame.new(29020.66, 14889.42, -379.26),
                    Fishman = CFrame.new(28224.05, 14889.42, -210.58),
                    Cyborg = CFrame.new(28492.41, 14894.42, -422.11),
                    Skypiea = CFrame.new(28967.40, 14918.07, 234.31),
                    Ghoul = CFrame.new(28672.72, 14889.12, 454.59),
                    Human = CFrame.new(29237.29, 14889.42, -206.94)
                }
                if doorPositions[race] then
                    _tp(doorPositions[race])
                end
            end)
        end
    end
end)

-- Auto Complete Trials
task.spawn(function()
    while task.wait(1) do
        if _G.Complete_Trials then
            pcall(function()
                local race = tostring(plr.Data.Race.Value)
                local hrp = GetHRP()
                
                if race == "Mink" then
                    notween(Workspace.Map.MinkTrial.Ceiling.CFrame * CFrame.new(0, -20, 0))
                elseif race == "Fishman" then
                    local beast = GetSeaBeastTrial()
                    if beast then
                        _tp(CFrame.new(beast.HumanoidRootPart.Position.X, Workspace.Map["WaterBase-Plane"].Position.Y + 300, beast.HumanoidRootPart.Position.Z))
                        UsePrehistoricSkills()
                    end
                elseif race == "Cyborg" then
                    _tp(Workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0, 500, 0))
                elseif race == "Skypiea" then
                    notween(Workspace.Map.SkyTrial.Model.FinishPart.CFrame)
                elseif race == "Human" or race == "Ghoul" then
                    local mobs = {"Ancient Vampire", "Ancient Zombie"}
                    local mob = GetConnectionEnemies(mobs)
                    if mob then
                        G.Kill(mob, true)
                    end
                end
            end)
        end
    end
end)

-- Auto Kill Player After Trial
task.spawn(function()
    while task.wait(1) do
        if _G.Defeating then
            pcall(function()
                local hrp = GetHRP()
                if not hrp then return end
                for _, player in pairs(Workspace.Characters:GetChildren()) do
                    if player.Name ~= plr.Name and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 and player:FindFirstChild("HumanoidRootPart") then
                        local dist = (hrp.Position - player.HumanoidRootPart.Position).Magnitude
                        if dist <= 250 then
                            EquipWeapon(_G.SelectWeapon)
                            _tp(player.HumanoidRootPart.CFrame * CFrame.new(0, 0, 15))
                            sethiddenproperty(plr, "SimulationRadius", math.huge)
                        end
                    end
                end
            end)
        end
    end
end)

-- ========================================
-- LOGIC LOOPS - MOON
-- ========================================

-- Look At Moon
task.spawn(function()
    while task.wait(0.1) do
        if _G.LookM then
            MoveCamToMoon()
            task.wait(0.1)
            commE:FireServer("ActivateAbility")
        end
    end
end)

-- Look Moon + Auto V3
task.spawn(function()
    while task.wait(0.1) do
        if _G.LookMV3 then
            MoveCamToMoon()
            commE:FireServer("ActivateAbility")
            VirtualInputManager:SendKeyEvent(true, "T", false, game)
            task.wait(0.5)
            VirtualInputManager:SendKeyEvent(false, "T", false, game)
        end
    end
end)

-- ========================================
-- LOGIC LOOPS - RACE UPGRADES V2/V3
-- ========================================

-- Auto Upgrade Mink
task.spawn(function()
    while task.wait(1) do
        if _G.Auto_Mink then
            pcall(function()
                local alchemist = commF:InvokeServer("Alchemist", "1")
                if alchemist ~= 2 then
                    if alchemist == 0 then
                        commF:InvokeServer("Alchemist", "2")
                    elseif alchemist == 1 then
                        if not GetBP("Flower 1") then
                            _tp(Workspace.Flower1.CFrame)
                        elseif not GetBP("Flower 2") then
                            _tp(Workspace.Flower2.CFrame)
                        elseif not GetBP("Flower 3") then
                            local mob = GetConnectionEnemies("Swan Pirate")
                            if mob then G.Kill(mob, true) else _tp(CFrame.new(980.09, 121.33, 1287.20)) end
                        end
                    elseif alchemist == 2 then
                        commF:InvokeServer("Alchemist", "3")
                    end
                elseif commF:InvokeServer("Wenlocktoad", "1") == 0 then
                    commF:InvokeServer("Wenlocktoad", "2")
                elseif commF:InvokeServer("Wenlocktoad", "1") == 1 then
                    _G.AutoFarmChest = true
                else
                    _G.AutoFarmChest = false
                end
            end)
        end
    end
end)

-- Auto Upgrade Human
task.spawn(function()
    while task.wait(1) do
        if _G.Auto_Human then
            pcall(function()
                local alchemist = commF:InvokeServer("Alchemist", "1")
                if alchemist ~= -2 then
                    if alchemist == 0 then
                        commF:InvokeServer("Alchemist", "2")
                    elseif alchemist == 1 then
                        if not GetBP("Flower 1") then
                            _tp(Workspace.Flower1.CFrame)
                        elseif not GetBP("Flower 2") then
                            _tp(Workspace.Flower2.CFrame)
                        elseif not GetBP("Flower 3") then
                            local mob = GetConnectionEnemies("Swan Pirate")
                            if mob then G.Kill(mob, true) else _tp(CFrame.new(980.09, 121.33, 1287.20)) end
                        end
                    elseif alchemist == 2 then
                        commF:InvokeServer("Alchemist", "3")
                    end
                elseif commF:InvokeServer("Wenlocktoad", "1") == 0 then
                    commF:InvokeServer("Wenlocktoad", "2")
                elseif commF:InvokeServer("Wenlocktoad", "1") == 1 then
                    local bosses = {"Fajita", "Jeremy", "Diamond"}
                    for _, bossName in ipairs(bosses) do
                        local boss = GetConnectionEnemies(bossName)
                        if boss then
                            G.Kill(boss, true)
                        else
                            local pos = bossName == "Fajita" and CFrame.new(-2172.73, 103.32, -4015.02) or
                                       bossName == "Jeremy" and CFrame.new(2006.92, 448.95, 853.98) or
                                       CFrame.new(-1576.71, 198.59, 13.72)
                            _tp(pos)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Upgrade Angel (Skypiea)
task.spawn(function()
    while task.wait(1) do
        if _G.Auto_Skypiea then
            pcall(function()
                local alchemist = commF:InvokeServer("Alchemist", "1")
                if alchemist ~= -2 then
                    if alchemist == 0 then
                        commF:InvokeServer("Alchemist", "2")
                    elseif alchemist == 1 then
                        if not GetBP("Flower 1") then
                            _tp(Workspace.Flower1.CFrame)
                        elseif not GetBP("Flower 2") then
                            _tp(Workspace.Flower2.CFrame)
                        elseif not GetBP("Flower 3") then
                            local mob = GetConnectionEnemies("Swan Pirate")
                            if mob then G.Kill(mob, true) else _tp(CFrame.new(980.09, 121.33, 1287.20)) end
                        end
                    elseif alchemist == 2 then
                        commF:InvokeServer("Alchemist", "3")
                    end
                elseif commF:InvokeServer("Wenlocktoad", "1") == 0 then
                    commF:InvokeServer("Wenlocktoad", "2")
                elseif commF:InvokeServer("Wenlocktoad", "1") == 1 then
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= plr and tostring(player.Data.Race.Value) == "Skypiea" and player.Character then
                            _tp(player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(math.rad(-45), 0, 0))
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Upgrade Fishman
task.spawn(function()
    while task.wait(1) do
        if _G.Auto_Fish then
            pcall(function()
                local alchemist = commF:InvokeServer("Alchemist", "1")
                if alchemist ~= -2 then
                    if alchemist == 0 then
                        commF:InvokeServer("Alchemist", "2")
                    elseif alchemist == 1 then
                        if not GetBP("Flower 1") then
                            _tp(Workspace.Flower1.CFrame)
                        elseif not GetBP("Flower 2") then
                            _tp(Workspace.Flower2.CFrame)
                        elseif not GetBP("Flower 3") then
                            local mob = GetConnectionEnemies("Swan Pirate")
                            if mob then G.Kill(mob, true) else _tp(CFrame.new(980.09, 121.33, 1287.20)) end
                        end
                    elseif alchemist == 2 then
                        commF:InvokeServer("Alchemist", "3")
                    end
                elseif commF:InvokeServer("Wenlocktoad", "1") == 0 then
                    commF:InvokeServer("Wenlocktoad", "2")
                end
            end)
        end
    end
end)

print("========================================")
print("KuKi Hub | True V2 - Part 6 Loaded!")
print("Mirage/Race Tab Complete!")
print("========================================")

--[[
    KuKi Hub | True V2
    Part 7: Fruits/Stock Tab - Fruit Management, Stock Checker, Auto Buy
]]

-- ========================================
-- FRUITS TAB SETUP
-- ========================================
local FruitMain = Tab9:CraftPage(1)       -- Fruit Stock & Functions
local FruitSniper = Tab9:CraftPage(2)     -- Shop Sniper & Checker

-- ========================================
-- GLOBAL FRUIT VARIABLES
-- ========================================
_G.Random_Auto = false
_G.DropFruit = false
_G.StoreF = false
_G.TwFruits = false
_G.InstanceF = false

getgenv().AutoBuyFruitSniper = false
getgenv().SelectFruit = GetSetting("SelectFruit", "Dough-Dough")
_G.AutoNotifyFruit = false
_G.CheckFruit = "Dough-Dough"

-- Complete Fruit List
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
    
    local success, advancedStock = pcall(function()
        return commF:InvokeServer("GetFruits", true)
    end)
    
    if success and advancedStock then
        local hasFruit = false
        for _, fruit in pairs(advancedStock) do
            if fruit.OnSale then
                hasFruit = true
                result = result .. fruit.Name .. " - $" .. formatNumber(fruit.Price) .. "\n"
            end
        end
        if not hasFruit then
            result = result .. "- No fruit in stock.\n"
        end
    else
        result = result .. "- Error retrieving data.\n"
    end
    
    result = result .. "\nNormal Fruit Stock\n"
    
    local success2, normalStock = pcall(function()
        return commF:InvokeServer("GetFruits")
    end)
    
    if success2 and normalStock then
        local hasFruit = false
        for _, fruit in pairs(normalStock) do
            if fruit.OnSale then
                hasFruit = true
                result = result .. fruit.Name .. " - $" .. formatNumber(fruit.Price) .. "\n"
            end
        end
        if not hasFruit then
            result = result .. "- No fruit in stock.\n"
        end
    else
        result = result .. "- Error retrieving data.\n"
    end
    
    return result
end

function CheckSpecificFruit(fruitName)
    local success, stock = pcall(function()
        return commF:InvokeServer("GetFruits", true)
    end)
    
    if success and stock then
        for _, fruit in pairs(stock) do
            if fruit.Name == fruitName and fruit.OnSale then
                return true, fruit.Price
            end
        end
    end
    
    local success2, normalStock = pcall(function()
        return commF:InvokeServer("GetFruits")
    end)
    
    if success2 and normalStock then
        for _, fruit in pairs(normalStock) do
            if fruit.Name == fruitName and fruit.OnSale then
                return true, fruit.Price
            end
        end
    end
    
    return false, nil
end

function DropFruits()
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        if string.find(tool.Name, "Fruit") then
            EquipWeapon(tool.Name)
            task.wait(0.1)
            if plr.PlayerGui.Main.Dialogue.Visible then
                plr.PlayerGui.Main.Dialogue.Visible = false
            end
            tool.EatRemote:InvokeServer("Drop")
        end
    end
    for _, tool in pairs(plr.Character:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name, "Fruit") then
            EquipWeapon(tool.Name)
            task.wait(0.1)
            if plr.PlayerGui.Main.Dialogue.Visible then
                plr.PlayerGui.Main.Dialogue.Visible = false
            end
            tool.EatRemote:InvokeServer("Drop")
        end
    end
end

function StoreFruits()
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        local eatRemote = tool:FindFirstChild("EatRemote", true)
        if eatRemote then
            commF:InvokeServer("StoreFruit", tool:GetAttribute("OriginalName"), tool)
        end
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
-- FRUIT MAIN PAGE (PAGE 1)
-- ========================================
FruitMain:Seperator("📊 Fruit Stock")

local stockParagraph = FruitMain:AddParagraph({
    Title = "Current Fruit Stock",
    Desc = "Loading..."
})

task.spawn(function()
    -- Initial update
    pcall(function()
        stockParagraph:SetDesc(GetFruitStock())
    end)
    
    -- Periodic update every 60 seconds
    while task.wait(60) do
        pcall(function()
            stockParagraph:SetDesc(GetFruitStock())
        end)
    end
end)

FruitMain:Button({
    Name = "Refresh Stock Now",
    Callback = function()
        pcall(function()
            stockParagraph:SetDesc(GetFruitStock())
            library:Notification({
                Title = "Fruit Stock",
                Message = "Stock refreshed",
                Duration = 2
            })
        end)
    end
})

FruitMain:Seperator("🍎 Auto Functions")

FruitMain:Toggle({
    Name = "Auto Random Fruit",
    Default = GetSetting("Random_Auto", false),
    Callback = function(value)
        _G.Random_Auto = value
        _G.SaveData["Random_Auto"] = value
        SaveSettings()
    end
})

FruitMain:Toggle({
    Name = "Auto Drop Fruit",
    Default = GetSetting("DropFruit", false),
    Callback = function(value)
        _G.DropFruit = value
        _G.SaveData["DropFruit"] = value
        SaveSettings()
    end
})

FruitMain:Toggle({
    Name = "Auto Store Fruit",
    Default = GetSetting("StoreF", false),
    Callback = function(value)
        _G.StoreF = value
        _G.SaveData["StoreF"] = value
        SaveSettings()
    end
})

FruitMain:Toggle({
    Name = "Auto Tween to Fruit",
    Default = GetSetting("TwFruits", false),
    Callback = function(value)
        _G.TwFruits = value
        _G.SaveData["TwFruits"] = value
        SaveSettings()
    end
})

FruitMain:Toggle({
    Name = "Auto Collect Fruit (Bring)",
    Default = GetSetting("InstanceF", false),
    Callback = function(value)
        _G.InstanceF = value
        _G.SaveData["InstanceF"] = value
        SaveSettings()
    end
})

FruitMain:Seperator("📦 Fruit Actions")

FruitMain:Button({
    Name = "Random Fruit (Once)",
    Callback = function()
        pcall(function()
            commF:InvokeServer("Cousin", "Buy")
            library:Notification({Title = "Fruit", Message = "Bought random fruit!", Duration = 2})
        end)
    end
})

FruitMain:Button({
    Name = "Drop All Fruits",
    Callback = function()
        pcall(function()
            DropFruits()
            library:Notification({Title = "Fruit", Message = "Dropped all fruits!", Duration = 2})
        end)
    end
})

FruitMain:Button({
    Name = "Store All Fruits",
    Callback = function()
        pcall(function()
            StoreFruits()
            library:Notification({Title = "Fruit", Message = "Stored all fruits!", Duration = 2})
        end)
    end
})

FruitMain:Button({
    Name = "Bring Nearby Fruits",
    Callback = function()
        pcall(function()
            CollectFruits(true)
            library:Notification({Title = "Fruit", Message = "Bringing fruits to you!", Duration = 2})
            task.wait(0.5)
            CollectFruits(false)
        end)
    end
})

-- ========================================
-- FRUIT SNIPER PAGE (PAGE 2)
-- ========================================
FruitSniper:Seperator("🎯 Fruit Shop Sniper")

FruitSniper:Dropdown({
    Name = "Select Fruit to Buy",
    Options = FruitList,
    Default = GetSetting("SelectFruit", "Dough-Dough"),
    Callback = function(value)
        getgenv().SelectFruit = value
        _G.SaveData["SelectFruit"] = value
        SaveSettings()
    end
})

FruitSniper:Toggle({
    Name = "Auto Buy Fruit (Shop Sniper)",
    Default = GetSetting("AutoBuyFruitSniper", false),
    Callback = function(value)
        getgenv().AutoBuyFruitSniper = value
        _G.SaveData["AutoBuyFruitSniper"] = value
        SaveSettings()
    end
})

FruitSniper:Button({
    Name = "Buy Selected Fruit (Once)",
    Callback = function()
        pcall(function()
            if getgenv().SelectFruit then
                commF:InvokeServer("GetFruits")
                commF:InvokeServer("PurchaseRawFruit", getgenv().SelectFruit)
                library:Notification({Title = "Sniper", Message = "Attempted to buy: " .. getgenv().SelectFruit, Duration = 3})
            end
        end)
    end
})

FruitSniper:Seperator("🔍 Fruit Stock Checker")

FruitSniper:Dropdown({
    Name = "Select Fruit to Check",
    Options = FruitList,
    Default = "Dough-Dough",
    Callback = function(value)
        _G.CheckFruit = value
    end
})

local fruitCheckResult = FruitSniper:AddParagraph({
    Title = "Fruit Status",
    Desc = "Select a fruit to check"
})

FruitSniper:Button({
    Name = "Check Selected Fruit",
    Callback = function()
        if not _G.CheckFruit then
            fruitCheckResult:SetDesc("Please select a fruit first")
            return
        end
        
        pcall(function()
            local inStock, price = CheckSpecificFruit(_G.CheckFruit)
            if inStock then
                fruitCheckResult:SetDesc("✅ " .. _G.CheckFruit .. " is in stock!\nPrice: $" .. formatNumber(price))
                library:Notification({
                    Title = "Fruit Stock",
                    Message = _G.CheckFruit .. " is in stock!",
                    Duration = 5
                })
            else
                fruitCheckResult:SetDesc("❌ " .. _G.CheckFruit .. " is not in stock")
            end
        end)
    end
})

FruitSniper:Toggle({
    Name = "Auto Notify when Fruit in Stock",
    Default = GetSetting("AutoNotifyFruit", false),
    Callback = function(value)
        _G.AutoNotifyFruit = value
        _G.SaveData["AutoNotifyFruit"] = value
        SaveSettings()
    end
})

-- ========================================
-- LOGIC LOOPS
-- ========================================

-- Auto Random Fruit
task.spawn(function()
    while task.wait(1) do
        if _G.Random_Auto then
            pcall(function()
                commF:InvokeServer("Cousin", "Buy")
            end)
        end
    end
end)

-- Auto Drop Fruit
task.spawn(function()
    while task.wait(5) do
        if _G.DropFruit then
            pcall(function()
                DropFruits()
            end)
        end
    end
end)

-- Auto Store Fruit
task.spawn(function()
    while task.wait(5) do
        if _G.StoreF then
            pcall(function()
                StoreFruits()
            end)
        end
    end
end)

-- Auto Tween to Fruit
task.spawn(function()
    while task.wait(1) do
        if _G.TwFruits then
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if string.find(obj.Name, "Fruit") and obj:FindFirstChild("Handle") then
                        _tp(obj.Handle.CFrame)
                    end
                end
            end)
        end
    end
end)

-- Auto Collect Fruit (Bring to player)
task.spawn(function()
    while task.wait(0.5) do
        if _G.InstanceF then
            pcall(function()
                CollectFruits(true)
            end)
        end
    end
end)

-- Auto Buy Fruit Sniper
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoBuyFruitSniper and getgenv().SelectFruit then
            pcall(function()
                commF:InvokeServer("GetFruits")
                commF:InvokeServer("PurchaseRawFruit", getgenv().SelectFruit)
            end)
        end
    end
end)

-- Auto Notify Fruit Stock Checker
task.spawn(function()
    while task.wait(30) do
        if _G.AutoNotifyFruit and _G.CheckFruit then
            pcall(function()
                local inStock, price = CheckSpecificFruit(_G.CheckFruit)
                if inStock then
                    fruitCheckResult:SetDesc("✅ " .. _G.CheckFruit .. " is in stock!\nPrice: $" .. formatNumber(price))
                    library:Notification({
                        Title = "Fruit Stock Alert!",
                        Message = _G.CheckFruit .. " is now in stock!\nPrice: $" .. formatNumber(price),
                        Duration = 10
                    })
                end
            end)
        end
    end
end)

print("========================================")
print("KuKi Hub | True V2 - Part 7 Loaded!")
print("Fruits/Stock Tab Complete!")
print("========================================")

--[[
    KuKi Hub | True V2
    Part 8: Raid/Dungeon Tab - Raid Automation, Chip Buying, Awakening, Law Raid
]]

-- ========================================
-- RAID TAB SETUP
-- ========================================
local RaidMain = Tab10:CraftPage(1)       -- Status & Controls
local RaidChip = Tab10:CraftPage(2)       -- Chip Selection & Buy
local RaidFarm = Tab10:CraftPage(3)       -- Auto Farm Dungeon
local RaidLaw = Tab10:CraftPage(4)        -- Law/Order Raid
local RaidTele = Tab10:CraftPage(5)       -- Floor Teleports
local RaidKill = Tab10:CraftPage(6)       -- Kill Aura

-- ========================================
-- GLOBAL RAID VARIABLES
-- ========================================
_G.SelectChip = GetSetting("Raid_SelectChip", "Flame")
_G.AutoChipBeli = GetSetting("Raid_AutoChipBeli", false)
_G.AutoChipFruit = GetSetting("Raid_AutoChipFruit", false)
_G.AutoStartRaid = GetSetting("Raid_AutoStartRaid", false)
_G.AutoDungeonFarm = GetSetting("Raid_AutoDungeonFarm", false)
_G.AutoAwaken = GetSetting("Raid_AutoAwaken", false)
_G.AutoBuyLawChip = GetSetting("Raid_AutoBuyLawChip", false)
_G.AutoStartLawRaid = GetSetting("Raid_AutoStartLawRaid", false)
_G.AutoKillOrder = GetSetting("Raid_AutoKillOrder", false)
_G.TpLab = GetSetting("Raid_TpLab", false)
_G.KillAuraRaid = GetSetting("Raid_KillAura", false)
_G.KillAuraRange = GetSetting("Raid_KillAuraRange", 500)
_G.KillAuraDelay = GetSetting("Raid_KillAuraDelay", 2)

local RaidChipList = {
    "Flame", "Ice", "Quake", "Light", "Dark", "String",
    "Rumble", "Magma", "Human: Buddha", "Sand", "Bird: Phoenix", "Dough"
}

local RaidIslands = {"Island 1", "Island 2", "Island 3", "Island 4", "Island 5"}
local CurrentTargetIsland = nil
local KillAuraRaidCounter = 0

-- ========================================
-- RAID MAIN PAGE (PAGE 1)
-- ========================================
RaidMain:Seperator("📊 Raid Status")

local raidTimerStatus = RaidMain:AddParagraph({
    Title = "Raid Timer",
    Desc = "Not in raid"
})

local raidIslandStatus = RaidMain:AddParagraph({
    Title = "Current Island",
    Desc = "None"
})

local raidMobsStatus = RaidMain:AddParagraph({
    Title = "Mobs Remaining",
    Desc = "0"
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local timer = plr.PlayerGui.Main.TopHUDList.RaidTimer
            if timer and timer.Visible then
                raidTimerStatus:SetDesc("Active - " .. timer.Text)
            else
                raidTimerStatus:SetDesc("Not in raid")
            end
        end)
    end
end)

RaidMain:Seperator("⚙️ Raid Controls")

RaidMain:Toggle({
    Name = "Auto Start Raid",
    Default = _G.AutoStartRaid,
    Callback = function(value)
        _G.AutoStartRaid = value
        _G.SaveData["Raid_AutoStartRaid"] = value
        SaveSettings()
    end
})

RaidMain:Toggle({
    Name = "Auto Awakening",
    Default = _G.AutoAwaken,
    Callback = function(value)
        _G.AutoAwaken = value
        _G.SaveData["Raid_AutoAwaken"] = value
        SaveSettings()
    end
})

RaidMain:Toggle({
    Name = "Auto Teleport to Lab",
    Default = _G.TpLab,
    Callback = function(value)
        _G.TpLab = value
        _G.SaveData["Raid_TpLab"] = value
        SaveSettings()
    end
})

-- ========================================
-- RAID CHIP PAGE (PAGE 2)
-- ========================================
RaidChip:Seperator("🎫 Chip Selection")

RaidChip:Dropdown({
    Name = "Select Chip",
    Options = RaidChipList,
    Default = _G.SelectChip,
    Callback = function(value)
        _G.SelectChip = value
        _G.SaveData["Raid_SelectChip"] = value
        SaveSettings()
    end
})

RaidChip:Seperator("💰 Buy Chip")

RaidChip:Button({
    Name = "Buy Chip with Beli",
    Callback = function()
        if not GetBP("Special Microchip") and _G.SelectChip then
            pcall(function()
                commF:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                library:Notification({Title = "Raid", Message = "Bought chip with Beli!", Duration = 2})
            end)
        end
    end
})

RaidChip:Button({
    Name = "Buy Chip with Fruit",
    Callback = function()
        if GetBP("Special Microchip") then return end
        pcall(function()
            local fruits = commF:InvokeServer("GetFruits")
            for _, fruit in pairs(fruits) do
                if fruit.Price <= 490000 then
                    commF:InvokeServer("LoadFruit", fruit.Name)
                    task.wait(0.5)
                    commF:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                    library:Notification({Title = "Raid", Message = "Bought chip with fruit!", Duration = 2})
                    break
                end
            end
        end)
    end
})

RaidChip:Toggle({
    Name = "Auto Buy Chip (Beli)",
    Default = _G.AutoChipBeli,
    Callback = function(value)
        _G.AutoChipBeli = value
        _G.SaveData["Raid_AutoChipBeli"] = value
        SaveSettings()
    end
})

RaidChip:Toggle({
    Name = "Auto Buy Chip (Fruit)",
    Default = _G.AutoChipFruit,
    Callback = function(value)
        _G.AutoChipFruit = value
        _G.SaveData["Raid_AutoChipFruit"] = value
        SaveSettings()
    end
})

-- ========================================
-- RAID FARM PAGE (PAGE 3)
-- ========================================
RaidFarm:Seperator("⚔️ Auto Farm Dungeon")

RaidFarm:Toggle({
    Name = "Auto Farm Dungeon + Next Floor",
    Default = _G.AutoDungeonFarm,
    Callback = function(value)
        _G.AutoDungeonFarm = value
        _G.SaveData["Raid_AutoDungeonFarm"] = value
        SaveSettings()
        if not value then CurrentTargetIsland = nil end
    end
})

-- Helper functions for raid farm
local function GetCurrentIsland()
    local hrp = GetHRP()
    if not hrp then return nil end
    local locations = Workspace._WorldOrigin.Locations
    local closest = math.huge
    local result = nil
    for _, name in ipairs(RaidIslands) do
        local island = locations:FindFirstChild(name)
        if island then
            local dist = (hrp.Position - island.Position).Magnitude
            if dist < closest then
                closest = dist
                result = name
            end
        end
    end
    return result, closest
end

local function HasMobsInIsland(islandName)
    local island = Workspace._WorldOrigin.Locations:FindFirstChild(islandName)
    if not island then return false end
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        local hum = mob:FindFirstChild("Humanoid")
        local root = mob:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.Health > 0 then
            if (root.Position - island.Position).Magnitude < 450 then
                return true
            end
        end
    end
    return false
end

local function GetNearestRaidMob()
    local hrp = GetHRP()
    if not hrp then return nil end
    local currentIsland = GetCurrentIsland()
    if not currentIsland then return nil end
    local island = Workspace._WorldOrigin.Locations:FindFirstChild(currentIsland)
    if not island then return nil end
    local closest, closestDist = nil, math.huge
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        local hum = mob:FindFirstChild("Humanoid")
        local root = mob:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.Health > 0 then
            if (root.Position - island.Position).Magnitude < 450 then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = mob
                end
            end
        end
    end
    return closest
end

local function MoveToNextIsland()
    local current = GetCurrentIsland()
    if not current then return false end
    local idx = table.find(RaidIslands, current)
    if not idx or idx >= #RaidIslands then return false end
    local nextName = RaidIslands[idx + 1]
    local nextIsland = Workspace._WorldOrigin.Locations:FindFirstChild(nextName)
    if nextIsland then
        _tp(nextIsland.CFrame * CFrame.new(0, 45, 120))
        CurrentTargetIsland = nextName
        return true
    end
    return false
end

-- Raid Farm Status Update
task.spawn(function()
    while task.wait(0.3) do
        if not _G.AutoDungeonFarm then
            raidIslandStatus:SetDesc("None")
            raidMobsStatus:SetDesc("0")
            continue
        end
        
        pcall(function()
            local timer = plr.PlayerGui.Main.TopHUDList.RaidTimer
            if not timer or not timer.Visible then
                raidIslandStatus:SetDesc("Not in raid")
                raidMobsStatus:SetDesc("0")
                return
            end
            
            local hrp = GetHRP()
            if not hrp then return end
            
            local currentIsland, dist = GetCurrentIsland()
            if currentIsland then
                raidIslandStatus:SetDesc(currentIsland .. " (" .. math.floor(dist) .. " studs)")
            end
            
            local mobCount = 0
            for _ in pairs(Workspace.Enemies:GetChildren()) do mobCount = mobCount + 1 end
            raidMobsStatus:SetDesc(tostring(mobCount))
            
            local mob = GetNearestRaidMob()
            if mob then
                local root = mob:FindFirstChild("HumanoidRootPart")
                if root then
                    if (hrp.Position - root.Position).Magnitude > 15 then
                        _tp(root.CFrame * CFrame.new(0, 20, 0))
                    end
                    if _G.SelectWeapon then EquipWeapon(_G.SelectWeapon) end
                    if G and G.Kill then G.Kill(mob, true) end
                end
            else
                if currentIsland and not HasMobsInIsland(currentIsland) then
                    MoveToNextIsland()
                    task.wait(1)
                end
            end
        end)
    end
end)

-- ========================================
-- RAID LAW PAGE (PAGE 4)
-- ========================================
RaidLaw:Seperator("⚖️ Law/Order Raid")

RaidLaw:Button({
    Name = "Buy Law Microchip",
    Callback = function()
        commF:InvokeServer("BlackbeardReward", "Microchip", "2")
        library:Notification({Title = "Law Raid", Message = "Bought Law chip!", Duration = 2})
    end
})

RaidLaw:Button({
    Name = "Start Law Raid",
    Callback = function()
        if World2 then
            pcall(function()
                fireclickdetector(Workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
                library:Notification({Title = "Law Raid", Message = "Started Law raid!", Duration = 2})
            end)
        end
    end
})

RaidLaw:Toggle({
    Name = "Auto Buy Law Chip",
    Default = _G.AutoBuyLawChip,
    Callback = function(value)
        _G.AutoBuyLawChip = value
        _G.SaveData["Raid_AutoBuyLawChip"] = value
        SaveSettings()
    end
})

RaidLaw:Toggle({
    Name = "Auto Start Law Raid",
    Default = _G.AutoStartLawRaid,
    Callback = function(value)
        _G.AutoStartLawRaid = value
        _G.SaveData["Raid_AutoStartLawRaid"] = value
        SaveSettings()
    end
})

RaidLaw:Toggle({
    Name = "Auto Kill Order",
    Default = _G.AutoKillOrder,
    Callback = function(value)
        _G.AutoKillOrder = value
        _G.SaveData["Raid_AutoKillOrder"] = value
        SaveSettings()
    end
})

-- ========================================
-- RAID TELEPORT PAGE (PAGE 5)
-- ========================================
RaidTele:Seperator("🚪 Floor Teleports")

RaidTele:Button({
    Name = "TP to Floor 1 Start",
    Callback = function()
        if World2 then
            _tp(CFrame.new(-4995.06, 315.38, -2955.39))
        elseif World3 then
            _tp(CFrame.new(-5017.40, 314.84, -2823.01))
        end
    end
})

RaidTele:Button({
    Name = "TP to Floor 2 Start",
    Callback = function()
        if World2 then
            _tp(CFrame.new(-5134.95, 314.50, -3004.67))
        elseif World3 then
            _tp(CFrame.new(-5156.72, 313.65, -2865.62))
        end
    end
})

RaidTele:Button({
    Name = "TP to Floor 3 Start",
    Callback = function()
        if World2 then
            _tp(CFrame.new(-5271.78, 314.50, -3022.35))
        elseif World3 then
            _tp(CFrame.new(-5292.91, 313.65, -2887.93))
        end
    end
})

RaidTele:Button({
    Name = "TP to Floor 4 Start",
    Callback = function()
        if World2 then
            _tp(CFrame.new(-5407.04, 314.50, -3003.64))
        elseif World3 then
            _tp(CFrame.new(-5429.59, 313.65, -2866.41))
        end
    end
})

RaidTele:Button({
    Name = "TP to Floor 5 Start",
    Callback = function()
        if World2 then
            _tp(CFrame.new(-5528.60, 315.62, -2955.07))
        elseif World3 then
            _tp(CFrame.new(-5550.41, 314.77, -2816.70))
        end
    end
})

-- ========================================
-- RAID KILL AURA PAGE (PAGE 6)
-- ========================================
RaidKill:Seperator("💀 Kill Aura")

local killAuraRaidDisplay = RaidKill:AddParagraph({
    Title = "Kill Aura Stats",
    Desc = "Killed: 0"
})

task.spawn(function()
    while task.wait(1) do
        if _G.KillAuraRaid then
            killAuraRaidDisplay:SetDesc("Killed: " .. KillAuraRaidCounter .. " | Range: " .. _G.KillAuraRange)
        else
            killAuraRaidDisplay:SetDesc("Killed: 0 | Disabled")
        end
    end
end)

RaidKill:Toggle({
    Name = "Kill Aura",
    Default = _G.KillAuraRaid,
    Callback = function(value)
        _G.KillAuraRaid = value
        _G.SaveData["Raid_KillAura"] = value
        SaveSettings()
    end
})

RaidKill:TextBox({
    Name = "Kill Aura Range",
    Placeholder = "500",
    Default = tostring(_G.KillAuraRange),
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            _G.KillAuraRange = num
            _G.SaveData["Raid_KillAuraRange"] = num
            SaveSettings()
        end
    end
})

RaidKill:TextBox({
    Name = "Kill Aura Delay (s)",
    Placeholder = "2",
    Default = tostring(_G.KillAuraDelay),
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            _G.KillAuraDelay = num
            _G.SaveData["Raid_KillAuraDelay"] = num
            SaveSettings()
        end
    end
})

RaidKill:Button({
    Name = "Reset Kill Counter",
    Callback = function()
        KillAuraRaidCounter = 0
    end
})

-- ========================================
-- LOGIC LOOPS
-- ========================================

-- Auto Start Raid
task.spawn(function()
    while task.wait(1) do
        if _G.AutoStartRaid then
            pcall(function()
                local timer = plr.PlayerGui.Main.TopHUDList.RaidTimer
                if timer and timer.Visible then return end
                if not GetBP("Special Microchip") then return end
                
                if World2 then
                    local btn = Workspace.Map.CircleIsland.RaidSummon2.Button.Main
                    if btn then
                        if btn:FindFirstChild("ProximityPrompt") then
                            fireproximityprompt(btn.ProximityPrompt)
                        elseif btn:FindFirstChild("ClickDetector") then
                            fireclickdetector(btn.ClickDetector)
                        end
                    end
                elseif World3 then
                    local btn = Workspace.Map["Boat Castle"].RaidSummon2.Button.Main
                    if btn then
                        if btn:FindFirstChild("ProximityPrompt") then
                            fireproximityprompt(btn.ProximityPrompt)
                        elseif btn:FindFirstChild("ClickDetector") then
                            fireclickdetector(btn.ClickDetector)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Buy Chip (Beli)
task.spawn(function()
    while task.wait(5) do
        if _G.AutoChipBeli and _G.SelectChip then
            pcall(function()
                if not GetBP("Special Microchip") then
                    commF:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                end
            end)
        end
    end
end)

-- Auto Buy Chip (Fruit)
task.spawn(function()
    while task.wait(5) do
        if _G.AutoChipFruit and _G.SelectChip then
            pcall(function()
                if not GetBP("Special Microchip") then
                    local fruits = commF:InvokeServer("GetFruits")
                    for _, fruit in pairs(fruits) do
                        if fruit.Price <= 490000 then
                            commF:InvokeServer("LoadFruit", fruit.Name)
                            task.wait(0.5)
                            commF:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Awakening
task.spawn(function()
    while task.wait(2) do
        if _G.AutoAwaken then
            pcall(function()
                commF:InvokeServer("Awakener", "Check")
                commF:InvokeServer("Awakener", "Awaken")
            end)
        end
    end
end)

-- Auto Buy Law Chip
task.spawn(function()
    while task.wait(5) do
        if _G.AutoBuyLawChip then
            pcall(function()
                commF:InvokeServer("BlackbeardReward", "Microchip", "2")
            end)
        end
    end
end)

-- Auto Start Law Raid
task.spawn(function()
    while task.wait(5) do
        if _G.AutoStartLawRaid and World2 then
            pcall(function()
                fireclickdetector(Workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
            end)
        end
    end
end)

-- Auto Kill Order
task.spawn(function()
    while task.wait(1) do
        if _G.AutoKillOrder then
            pcall(function()
                local boss = GetConnectionEnemies("Order")
                if boss then
                    G.Kill(boss, true)
                else
                    _tp(CFrame.new(-6217.20, 28.04, -5053.13))
                end
            end)
        end
    end
end)

-- Teleport to Lab
task.spawn(function()
    while task.wait(0.1) do
        if _G.TpLab then
            if World2 then
                _tp(CFrame.new(-6438.73, 250.64, -4501.50))
            elseif World3 then
                _tp(CFrame.new(-5017.40, 314.84, -2823.01))
            end
        end
    end
end)

-- Kill Aura Loop
task.spawn(function()
    while task.wait(_G.KillAuraDelay) do
        if _G.KillAuraRaid then
            pcall(function()
                local hrp = GetHRP()
                if not hrp then return end
                sethiddenproperty(plr, "SimulationRadius", math.huge)
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    local hum = enemy:FindFirstChild("Humanoid")
                    local root = enemy:FindFirstChild("HumanoidRootPart")
                    if hum and root and hum.Health > 0 then
                        local dist = (root.Position - hrp.Position).Magnitude
                        if dist <= _G.KillAuraRange then
                            hum.Health = 0
                            root.CanCollide = false
                            enemy:BreakJoints()
                            KillAuraRaidCounter = KillAuraRaidCounter + 1
                        end
                    end
                end
            end)
        end
    end
end)

print("========================================")
print("KuKi Hub | True V2 - Part 8 Loaded!")
print("Raid/Dungeon Tab Complete!")
print("========================================")

--[[
    KuKi Hub | True V2
    Part 9: Teleport/World Tab - Sea Travel, Islands, Portals, NPCs
]]

-- ========================================
-- TELEPORT TAB SETUP
-- ========================================
local TeleWorld = Tab11:CraftPage(1)      -- World Travel
local TeleIsland = Tab11:CraftPage(2)     -- Island Travel
local TelePortal = Tab11:CraftPage(3)     -- Portal Travel
local TeleNPC = Tab11:CraftPage(4)        -- NPC Travel

-- ========================================
-- GLOBAL TELEPORT VARIABLES
-- ========================================
_G.Teleport = false
_G.Island = nil
_G.Island_PT = nil
_G.TPNpc = false
NPClist = nil

-- Island list from _WorldOrigin.Locations
local LocationList = {}
for _, loc in pairs(Workspace._WorldOrigin.Locations:GetChildren()) do
    table.insert(LocationList, loc.Name)
end
table.sort(LocationList)

-- Portal list per world
local PortalList = {}
if World1 then
    PortalList = { "Sky", "UnderWater" }
elseif World2 then
    PortalList = { "SwanRoom", "Cursed Ship" }
elseif World3 then
    PortalList = {
        "Castle On The Sea",
        "Mansion Cafe",
        "Hydra Teleport",
        "Canvendish Room",
        "Temple of Time",
    }
end

-- NPC list from ReplicatedStorage.NPCs
local NPCList = {}
for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
    table.insert(NPCList, npc.Name)
end
table.sort(NPCList)

-- ========================================
-- TELEPORT WORLD PAGE (PAGE 1)
-- ========================================
TeleWorld:Seperator("🌍 World Travel")

TeleWorld:Button({
    Name = "Teleport to Sea 1",
    Callback = function()
        pcall(function()
            commF:InvokeServer("TravelMain")
            library:Notification({
                Title = "Teleport",
                Message = "Traveling to First Sea...",
                Duration = 3
            })
        end)
    end
})

TeleWorld:Button({
    Name = "Teleport to Sea 2",
    Callback = function()
        pcall(function()
            commF:InvokeServer("TravelDressrosa")
            library:Notification({
                Title = "Teleport",
                Message = "Traveling to Second Sea...",
                Duration = 3
            })
        end)
    end
})

TeleWorld:Button({
    Name = "Teleport to Sea 3",
    Callback = function()
        pcall(function()
            commF:InvokeServer("TravelZou")
            library:Notification({
                Title = "Teleport",
                Message = "Traveling to Third Sea...",
                Duration = 3
            })
        end)
    end
})

TeleWorld:Seperator("⚡ Quick Teleport")

TeleWorld:Button({
    Name = "Teleport to Middle Town",
    Callback = function()
        _tp(CFrame.new(-686.66, 15.92, 1577.98))
    end
})

TeleWorld:Button({
    Name = "Teleport to Pirate Starter",
    Callback = function()
        _tp(CFrame.new(1059.96, 16.5, 1550.82))
    end
})

TeleWorld:Button({
    Name = "Teleport to Marine Starter",
    Callback = function()
        _tp(CFrame.new(-2709.68, 24.52, 2104.25))
    end
})

TeleWorld:Button({
    Name = "Teleport to Cafe (Sea 2)",
    Callback = function()
        _tp(CFrame.new(-380.5, 73.5, 317.5))
    end
})

TeleWorld:Button({
    Name = "Teleport to Mansion (Sea 3)",
    Callback = function()
        _tp(CFrame.new(-12471.17, 374.94, -7551.68))
    end
})

-- ========================================
-- TELEPORT ISLAND PAGE (PAGE 2)
-- ========================================
TeleIsland:Seperator("🏝️ Island Teleport")

TeleIsland:Dropdown({
    Name = "Select Island",
    Options = LocationList,
    Default = nil,
    Callback = function(value)
        _G.Island = value
    end
})

TeleIsland:Button({
    Name = "Teleport to Selected Island",
    Callback = function()
        if _G.Island then
            local target = Workspace._WorldOrigin.Locations:FindFirstChild(_G.Island)
            if target then
                _tp(target.CFrame * CFrame.new(0, 50, 0))
                library:Notification({
                    Title = "Teleport",
                    Message = "Teleported to " .. _G.Island,
                    Duration = 3
                })
            else
                library:Notification({
                    Title = "Error",
                    Message = "Island not found!",
                    Duration = 3
                })
            end
        else
            library:Notification({
                Title = "Error",
                Message = "Please select an island",
                Duration = 3
            })
        end
    end
})

TeleIsland:Toggle({
    Name = "Auto Travel to Island",
    Default = GetSetting("Teleport", false),
    Callback = function(value)
        _G.Teleport = value
        _G.SaveData["Teleport"] = value
        SaveSettings()
        
        if value and _G.Island then
            task.spawn(function()
                local targetIsland = Workspace._WorldOrigin.Locations:FindFirstChild(_G.Island)
                if targetIsland then
                    local hrp = GetHRP()
                    if hrp then
                        -- Rise 700 studs
                        hrp.CFrame = hrp.CFrame * CFrame.new(0, 700, 0)
                        task.wait(0.1)
                        
                        -- Travel to destination
                        local destination = targetIsland.CFrame * CFrame.new(0, 700, 0)
                        repeat
                            task.wait()
                            _tp(destination)
                        until not _G.Teleport or (hrp.Position - destination.Position).Magnitude < 10
                        
                        -- Descend to surface
                        if _G.Teleport then
                            hrp.CFrame = targetIsland.CFrame * CFrame.new(0, 5, 0)
                            _G.Teleport = false
                        end
                    end
                end
            end)
        end
    end
})

-- ========================================
-- TELEPORT PORTAL PAGE (PAGE 3)
-- ========================================
TelePortal:Seperator("🚪 Portal Teleport")

TelePortal:Dropdown({
    Name = "Select Portal",
    Options = PortalList,
    Default = nil,
    Callback = function(value)
        _G.Island_PT = value
    end
})

TelePortal:Button({
    Name = "Request Entrance",
    Callback = function()
        if not _G.Island_PT then
            library:Notification({
                Title = "Error",
                Message = "Please select a portal",
                Duration = 3
            })
            return
        end
        
        pcall(function()
            if _G.Island_PT == "Sky" then
                commF:InvokeServer("requestEntrance", Vector3.new(-7894.62, 5547.14, -380.29))
            elseif _G.Island_PT == "UnderWater" then
                commF:InvokeServer("requestEntrance", Vector3.new(61163.85, 11.68, 1819.78))
            elseif _G.Island_PT == "SwanRoom" then
                commF:InvokeServer("requestEntrance", Vector3.new(2285.20, 15.18, 905.84))
            elseif _G.Island_PT == "Cursed Ship" then
                commF:InvokeServer("requestEntrance", Vector3.new(923.21, 126.98, 32852.83))
            elseif _G.Island_PT == "Castle On The Sea" then
                commF:InvokeServer("requestEntrance", Vector3.new(-5097.93, 316.45, -3142.67))
            elseif _G.Island_PT == "Mansion Cafe" then
                commF:InvokeServer("requestEntrance", Vector3.new(-12471.17, 374.94, -7551.68))
            elseif _G.Island_PT == "Hydra Teleport" then
                commF:InvokeServer("requestEntrance", Vector3.new(5643.45, 1013.09, -340.51))
            elseif _G.Island_PT == "Canvendish Room" then
                commF:InvokeServer("requestEntrance", Vector3.new(5314.55, 22.56, -127.07))
            elseif _G.Island_PT == "Temple of Time" then
                commF:InvokeServer("requestEntrance", Vector3.new(28310.02, 14895.11, 109.46))
            end
            library:Notification({
                Title = "Portal",
                Message = "Requested entrance to " .. _G.Island_PT,
                Duration = 3
            })
        end)
    end
})

TelePortal:Button({
    Name = "Teleport to Portal Area",
    Callback = function()
        if not _G.Island_PT then return end
        
        local pos = nil
        if _G.Island_PT == "Sky" then
            pos = CFrame.new(-4839.53, 716.37, -2619.44)
        elseif _G.Island_PT == "UnderWater" then
            pos = CFrame.new(61122.65, 18.5, 1569.4)
        elseif _G.Island_PT == "SwanRoom" then
            pos = CFrame.new(2286.2, 15.18, 863.84)
        elseif _G.Island_PT == "Cursed Ship" then
            pos = CFrame.new(1037.8, 125.09, 32911.6)
        elseif _G.Island_PT == "Castle On The Sea" then
            pos = CFrame.new(-5081.35, 85.22, 4257.36)
        elseif _G.Island_PT == "Mansion Cafe" then
            pos = CFrame.new(-12471.17, 374.94, -7551.68)
        elseif _G.Island_PT == "Hydra Teleport" then
            pos = CFrame.new(5643.45, 1013.09, -340.51)
        elseif _G.Island_PT == "Canvendish Room" then
            pos = CFrame.new(5314.55, 22.56, -127.07)
        elseif _G.Island_PT == "Temple of Time" then
            pos = CFrame.new(28310.02, 14895.11, 109.46)
        end
        
        if pos then
            _tp(pos)
            library:Notification({
                Title = "Teleport",
                Message = "Arrived at " .. _G.Island_PT,
                Duration = 3
            })
        end
    end
})

-- ========================================
-- TELEPORT NPC PAGE (PAGE 4)
-- ========================================
TeleNPC:Seperator("👤 NPC Teleport")

TeleNPC:Dropdown({
    Name = "Select NPC",
    Options = NPCList,
    Default = nil,
    Callback = function(value)
        NPClist = value
    end
})

TeleNPC:Button({
    Name = "Teleport to NPC",
    Callback = function()
        if NPClist then
            for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                if npc.Name == NPClist and npc:FindFirstChild("HumanoidRootPart") then
                    _tp(npc.HumanoidRootPart.CFrame)
                    library:Notification({
                        Title = "Teleport",
                        Message = "Teleported to " .. NPClist,
                        Duration = 3
                    })
                    return
                end
            end
            library:Notification({
                Title = "Error",
                Message = "NPC not found or not loaded",
                Duration = 3
            })
        end
    end
})

TeleNPC:Toggle({
    Name = "Auto Tween to NPC",
    Default = GetSetting("TPNpc", false),
    Callback = function(value)
        _G.TPNpc = value
        _G.SaveData["TPNpc"] = value
        SaveSettings()
    end
})

TeleNPC:Seperator("⭐ Important NPCs")

TeleNPC:Button({
    Name = "Teleport to Barista (Haki Colors)",
    Callback = function()
        for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
            if npc.Name == "Barista Cousin" then
                _tp(npc.HumanoidRootPart.CFrame)
                break
            end
        end
    end
})

TeleNPC:Button({
    Name = "Teleport to Advanced Fruit Dealer",
    Callback = function()
        for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
            if npc.Name == "Advanced Fruit Dealer" then
                _tp(npc.HumanoidRootPart.CFrame)
                break
            end
        end
    end
})

TeleNPC:Button({
    Name = "Teleport to Legendary Sword Dealer",
    Callback = function()
        for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
            if npc.Name == "Legendary Sword Dealer" then
                _tp(npc.HumanoidRootPart.CFrame)
                break
            end
        end
    end
})

TeleNPC:Button({
    Name = "Teleport to Uzoth (Dragon Talon)",
    Callback = function()
        for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
            if npc.Name == "Uzoth" then
                _tp(npc.HumanoidRootPart.CFrame)
                break
            end
        end
    end
})

TeleNPC:Button({
    Name = "Teleport to Ancient Monk (Godhuman)",
    Callback = function()
        for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
            if npc.Name == "Ancient Monk" then
                _tp(npc.HumanoidRootPart.CFrame)
                break
            end
        end
    end
})

TeleNPC:Button({
    Name = "Teleport to Dragon Wizard (Dojo)",
    Callback = function()
        for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
            if npc.Name == "Dragon Wizard" then
                _tp(npc.HumanoidRootPart.CFrame)
                break
            end
        end
    end
})

-- ========================================
-- LOGIC LOOPS
-- ========================================

-- Auto Tween to NPC
task.spawn(function()
    while task.wait(0.1) do
        if _G.TPNpc and NPClist then
            pcall(function()
                for _, npc in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                    if npc.Name == NPClist and npc:FindFirstChild("HumanoidRootPart") then
                        _tp(npc.HumanoidRootPart.CFrame)
                        break
                    end
                end
            end)
        end
    end
end)

print("========================================")
print("KuKi Hub | True V2 - Part 9 Loaded!")
print("Teleport/World Tab Complete!")
print("========================================")

--[[
    KuKi Hub | True V2
    Part 10: PvP/Player Tab - Player List, Aimbot, Movement, Combat, Infinite Abilities
]]

-- ========================================
-- PVP TAB SETUP
-- ========================================
local PvPPlayer = Tab12:CraftPage(1)      -- Player List & Actions
local PvPAimbot = Tab12:CraftPage(2)      -- Aimbot Settings
local PvPMovement = Tab12:CraftPage(3)    -- Speed/Jump
local PvPCombat = Tab12:CraftPage(4)      -- Combat Settings
local PvPInf = Tab12:CraftPage(5)         -- Infinite Abilities

-- ========================================
-- GLOBAL PVP VARIABLES
-- ========================================
_G.PlayersList = nil
_G.TpPly = false
_G.SpectatePlys = false
_G.AimCam = false
_G.SilentAim = false
_G.WalkSpeedEnabled = false
_G.JumpEnabled = false
getgenv().WalkSpeedValue = GetSetting("WalkSpeedValue", 30)
getgenv().JumpValue = GetSetting("JumpValue", 50)
_G.InfAblities = false
_G.infEnergy = false
_G.InfSoru = false
_G.InfiniteObRange = false
_G.NoAimTeam = false
_G.AcceptAlly = false

-- ========================================
-- HELPER FUNCTIONS
-- ========================================
local function updatePlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= plr then
            table.insert(list, p.Name)
        end
    end
    return list
end

local function applySpeedJump()
    local char = plr.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if _G.WalkSpeedEnabled then
                hum.WalkSpeed = getgenv().WalkSpeedValue
            end
            if _G.JumpEnabled then
                hum.JumpPower = getgenv().JumpValue
            end
        end
    end
end

function getInfinity_Ability(ability, enabled)
    if ability == "Soru" and enabled then
        for _, obj in pairs(getgc()) do
            if plr.Character and plr.Character:FindFirstChild("Soru") then
                if typeof(obj) == "function" and getfenv(obj).script == plr.Character.Soru then
                    for _, upval in pairs(getupvalues(obj)) do
                        if typeof(upval) == "table" then
                            repeat
                                task.wait(0.1)
                                upval.LastUse = 0
                            until not enabled or not plr.Character or plr.Character.Humanoid.Health <= 0
                        end
                    end
                end
            end
        end
    elseif ability == "Energy" and enabled then
        plr.Character.Energy.Changed:Connect(function()
            if enabled then
                plr.Character.Energy.Value = 25000
            end
        end)
    elseif ability == "Observation" and enabled then
        plr.VisionRadius.Value = math.huge
    end
end

-- ========================================
-- PVP PLAYER PAGE (PAGE 1)
-- ========================================
PvPPlayer:Seperator("👥 Player List")

local playerDropdown = PvPPlayer:AddDropdown({
    Name = "Select Player",
    Options = updatePlayerList(),
    Default = nil,
    Callback = function(value)
        _G.PlayersList = value
        _G.SaveData["PlayersList"] = value
        SaveSettings()
    end
})

PvPPlayer:Button({
    Name = "Refresh Player List",
    Callback = function()
        playerDropdown:Refresh(updatePlayerList(), true)
        library:Notification({
            Title = "Player List",
            Message = "List refreshed!",
            Duration = 2
        })
    end
})

PvPPlayer:Seperator("🎯 Player Actions")

PvPPlayer:Toggle({
    Name = "Teleport to Player",
    Default = GetSetting("TpPly", false),
    Callback = function(value)
        _G.TpPly = value
        _G.SaveData["TpPly"] = value
        SaveSettings()
        
        task.spawn(function()
            while _G.TpPly and _G.PlayersList do
                pcall(function()
                    local target = Players:FindFirstChild(_G.PlayersList)
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        _tp(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0))
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

PvPPlayer:Toggle({
    Name = "Spectate Player",
    Default = GetSetting("SpectatePlys", false),
    Callback = function(value)
        _G.SpectatePlys = value
        _G.SaveData["SpectatePlys"] = value
        SaveSettings()
        
        task.spawn(function()
            if value and _G.PlayersList then
                local target = Players:FindFirstChild(_G.PlayersList)
                while _G.SpectatePlys and target and target.Character do
                    Workspace.Camera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
                    task.wait()
                end
                Workspace.Camera.CameraSubject = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            end
        end)
    end
})

PvPPlayer:Button({
    Name = "Bring Player to You",
    Callback = function()
        if not _G.PlayersList then
            library:Notification({Title = "Error", Message = "Select a player first", Duration = 2})
            return
        end
        pcall(function()
            local target = Players:FindFirstChild(_G.PlayersList)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = target.Character.HumanoidRootPart
                local myHrp = GetHRP()
                if myHrp then
                    hrp.CFrame = myHrp.CFrame * CFrame.new(0, 0, 5)
                    library:Notification({Title = "Player", Message = "Brought " .. target.Name, Duration = 2})
                end
            end
        end)
    end
})

-- ========================================
-- PVP AIMBOT PAGE (PAGE 2)
-- ========================================
PvPAimbot:Seperator("🎯 Aimbot")

PvPAimbot:Toggle({
    Name = "Aimbot Cam Lock",
    Default = GetSetting("AimCam", false),
    Callback = function(value)
        _G.AimCam = value
        _G.SaveData["AimCam"] = value
        SaveSettings()
        
        task.spawn(function()
            local camera = Workspace.CurrentCamera
            while _G.AimCam do
                pcall(function()
                    local closest, minDist = nil, math.huge
                    local myHead = plr.Character and plr.Character:FindFirstChild("Head")
                    if not myHead then return end
                    
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= plr and p.Character and p.Character:FindFirstChild("Head") then
                            if p.Character.Humanoid.Health > 0 then
                                local dist = (p.Character.Head.Position - myHead.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    closest = p
                                end
                            end
                        end
                    end
                    if closest and closest.Character then
                        camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Character.HumanoidRootPart.Position)
                    end
                end)
                task.wait()
            end
        end)
    end
})

PvPAimbot:Toggle({
    Name = "Aimbot Skills (Silent Aim)",
    Default = GetSetting("SilentAim", false),
    Callback = function(value)
        _G.SilentAim = value
        _G.SaveData["SilentAim"] = value
        SaveSettings()
    end
})

-- Silent Aim implementation via namecall hook
local mt = getrawmetatable(game)
local old_namecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(...)
    local method = getnamecallmethod()
    local args = {...}
    
    if _G.SilentAim then
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = tostring(args[1])
            if remoteName:find("RemoteEvent") or remoteName:find("Shoot") or remoteName:find("Attack") then
                -- Find closest player
                local closest = nil
                local minDist = math.huge
                local myHrp = GetHRP()
                if myHrp then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            if p.Character.Humanoid.Health > 0 then
                                local dist = (p.Character.HumanoidRootPart.Position - myHrp.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    closest = p.Character.HumanoidRootPart
                                end
                            end
                        end
                    end
                end
                if closest then
                    if typeof(args[2]) == "Vector3" then
                        args[2] = closest.Position
                    elseif typeof(args[3]) == "Vector3" then
                        args[3] = closest.Position
                    end
                end
            end
        end
    end
    
    return old_namecall(unpack(args))
end)

setreadonly(mt, true)

-- ========================================
-- PVP MOVEMENT PAGE (PAGE 3)
-- ========================================
PvPMovement:Seperator("🏃 Speed / Jump")

PvPMovement:Toggle({
    Name = "Set WalkSpeed",
    Default = GetSetting("SpeedToggle", false),
    Callback = function(value)
        _G.WalkSpeedEnabled = value
        _G.SaveData["SpeedToggle"] = value
        SaveSettings()
        applySpeedJump()
    end
})

PvPMovement:TextBox({
    Name = "WalkSpeed Value",
    Placeholder = "30",
    Default = tostring(getgenv().WalkSpeedValue),
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            getgenv().WalkSpeedValue = num
            _G.SaveData["WalkSpeedValue"] = num
            SaveSettings()
            applySpeedJump()
        end
    end
})

PvPMovement:Toggle({
    Name = "Set JumpPower",
    Default = GetSetting("JumpToggle", false),
    Callback = function(value)
        _G.JumpEnabled = value
        _G.SaveData["JumpToggle"] = value
        SaveSettings()
        applySpeedJump()
    end
})

PvPMovement:TextBox({
    Name = "JumpPower Value",
    Placeholder = "50",
    Default = tostring(getgenv().JumpValue),
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            getgenv().JumpValue = num
            _G.SaveData["JumpValue"] = num
            SaveSettings()
            applySpeedJump()
        end
    end
})

-- Watch for character changes
plr.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    applySpeedJump()
    char:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if _G.WalkSpeedEnabled then
            char.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
        end
    end)
end)

if plr.Character then
    applySpeedJump()
    plr.Character:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if _G.WalkSpeedEnabled then
            plr.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
        end
    end)
end

RunService.Heartbeat:Connect(applySpeedJump)

-- ========================================
-- PVP COMBAT PAGE (PAGE 4)
-- ========================================
PvPCombat:Seperator("⚔️ Combat Settings")

PvPCombat:Toggle({
    Name = "Ignore Same Teams",
    Default = GetSetting("NoAimTeam", false),
    Callback = function(value)
        _G.NoAimTeam = value
        _G.SaveData["NoAimTeam"] = value
        SaveSettings()
    end
})

PvPCombat:Toggle({
    Name = "Accept Allies",
    Default = GetSetting("AcceptAlly", false),
    Callback = function(value)
        _G.AcceptAlly = value
        _G.SaveData["AcceptAlly"] = value
        SaveSettings()
        
        task.spawn(function()
            while _G.AcceptAlly do
                pcall(function()
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= plr then
                            commF:InvokeServer("AcceptAlly", p.Name)
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
})

PvPCombat:Button({
    Name = "Accept All Allies (Once)",
    Callback = function()
        pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= plr then
                    commF:InvokeServer("AcceptAlly", p.Name)
                end
            end
            library:Notification({Title = "Allies", Message = "Accepted all ally requests", Duration = 2})
        end)
    end
})

-- ========================================
-- PVP INFINITE ABILITIES PAGE (PAGE 5)
-- ========================================
PvPInf:Seperator("♾️ Infinite Abilities")

PvPInf:Toggle({
    Name = "Infinite Mink V3 [INF]",
    Default = GetSetting("InfAblities", false),
    Callback = function(value)
        _G.InfAblities = value
        _G.SaveData["InfAblities"] = value
        SaveSettings()
        
        task.spawn(function()
            while _G.InfAblities do
                pcall(function()
                    local char = plr.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        if not char.HumanoidRootPart:FindFirstChild("Agility") then
                            local agility = ReplicatedStorage.FX.Agility:Clone()
                            agility.Name = "Agility"
                            agility.Parent = char.HumanoidRootPart
                        end
                    end
                end)
                task.wait(0.2)
            end
            
            pcall(function()
                local char = plr.Character
                if char and char.HumanoidRootPart:FindFirstChild("Agility") then
                    char.HumanoidRootPart.Agility:Destroy()
                end
            end)
        end)
    end
})

PvPInf:Toggle({
    Name = "Infinite Energy [INF]",
    Default = GetSetting("infEnergy", false),
    Callback = function(value)
        _G.infEnergy = value
        _G.SaveData["infEnergy"] = value
        SaveSettings()
        getInfinity_Ability("Energy", value)
    end
})

PvPInf:Toggle({
    Name = "Infinite Soru [INF]",
    Default = GetSetting("InfSoru", false),
    Callback = function(value)
        _G.InfSoru = value
        _G.SaveData["InfSoru"] = value
        SaveSettings()
        getInfinity_Ability("Soru", value)
    end
})

PvPInf:Toggle({
    Name = "Infinite Observation Range [INF]",
    Default = GetSetting("InfiniteObRange", false),
    Callback = function(value)
        _G.InfiniteObRange = value
        _G.SaveData["InfiniteObRange"] = value
        SaveSettings()
        getInfinity_Ability("Observation", value)
    end
})

print("========================================")
print("KuKi Hub | True V2 - Part 10 Loaded!")
print("PvP/Player Tab Complete!")
print("========================================")

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
