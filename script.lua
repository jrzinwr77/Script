-- Kaitun Hub - Blox Fruits (com GUI OrionLib)
-- Autor: ChatGPT (OpenAI) – versão 2025‑07
-- [SCRIPT COMPLETO]

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Kaitun Hub - Blox Fruits", HidePremium = false, SaveConfig = true, ConfigFolder = "KaitunBF"})

local player = game.Players.LocalPlayer
local replicated = game:GetService("ReplicatedStorage")
local workspaceEnemies = workspace:WaitForChild("Enemies")
local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart") or player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

local Toggles = {
    AutoFarm = false,
    AutoBoss = false,
    FastAttack = false,
    Hitbox = false,
    AutoFruit = false,
    AutoHaki = false,
    AutoSea = false
}

-- Função de voo
local function FlyTo(pos)
    if hrp then
        local goal = {CFrame = CFrame.new(pos + Vector3.new(0,100,0))}
        local time = (hrp.Position - pos).Magnitude / 300
        local tween = tweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), goal)
        tween:Play()
        tween.Completed:Wait()
    end
end

-- Função de quest/mob por nível
local function GetQuestAndMob()
    local level = player.Data.Level.Value
    -- (mesma função completa que enviei anteriormente)
    if level <= 9 then return "BanditQuest1","Bandit",CFrame.new(1060,17,1547) end
    if level <= 14 then return "BanditQuest2","Monkey",CFrame.new(-1602,7,152) end
    if level <= 29 then return "BanditQuest2","Gorilla",CFrame.new(-1322,7,-521) end
    if level <= 39 then return "BuggyQuest1","Pirate",CFrame.new(-4950,20,4037) end
    if level <= 59 then return "BuggyQuest1","Brute",CFrame.new(-4950,20,4037) end
    if level <= 74 then return "BuggyQuest2","Bobby",CFrame.new(-4950,20,4037) end
    if level <= 89 then return "DesertQuest","Desert Bandit",CFrame.new(931,7,4484) end
    if level <= 99 then return "DesertQuest","Desert Officer",CFrame.new(1572,10,4373) end
    if level <= 119 then return "SnowQuest","Snow Bandit",CFrame.new(1389,87,-1296) end
    if level <= 149 then return "SnowQuest","Snowman",CFrame.new(1247,137,-1477) end
    if level <= 174 then return "MarineQuest","Chief Petty Officer",CFrame.new(-4505,20,4260) end
    if level <= 199 then return "SkyQuest","Sky Bandit",CFrame.new(-4961,295,-2892) end
    if level <= 224 then return "SkyQuest","Dark Master",CFrame.new(-5251,389,-2272) end
    if level <= 274 then return "ColosseumQuest","Toga Warrior",CFrame.new(-1576,7,-2987) end
    if level <= 299 then return "ColosseumQuest","Gladiator",CFrame.new(-1255,7,-3147) end
    if level <= 324 then return "MagmaQuest","Military Soldier",CFrame.new(-5310,12,8515) end
    if level <= 374 then return "MagmaQuest","Military Spy",CFrame.new(-5812,12,8825) end
    if level <= 399 then return "FishmanQuest","Fishman Warrior",CFrame.new(61123,19,1569) end
    if level <= 449 then return "FishmanQuest","Fishman Commando",CFrame.new(61892,19,1569) end
    if level <= 474 then return "SkyExp1Quest","God's Guard",CFrame.new(-4637,872,-1935) end
    if level <= 524 then return "SkyExp1Quest","Shanda",CFrame.new(-7895,5546,-2216) end
    if level <= 549 then return "SkyExp2Quest","Royal Squad",CFrame.new(-7685,5607,-2327) end
    if level <= 624 then return "SkyExp2Quest","Royal Soldier",CFrame.new(-7901,5636,-2475) end
    if level <= 649 then return "FountainQuest","Galley Pirate",CFrame.new(5531,29,3997) end
    if level <= 700 then return "FountainQuest","Galley Captain",CFrame.new(5700,42,4960) end
    if level <= 724 then return "Area1Quest","Raider",CFrame.new(-427,400,2064) end
    if level <= 774 then return "Area1Quest","Mercenary",CFrame.new(-728,400,2369) end
    if level <= 799 then return "Area2Quest","Swan Pirate",CFrame.new(878,122,1237) end
    if level <= 874 then return "Area2Quest","Factory Staff",CFrame.new(295,73,1427) end
    if level <= 899 then return "Area3Quest","Marine Lieutenant",CFrame.new(-2841,12,1513) end
    if level <= 949 then return "Area3Quest","Marine Captain",CFrame.new(-2872,12,1517) end
    if level <= 974 then return "ZombieQuest","Zombie",CFrame.new(-5626,100,-717) end
    if level <= 999 then return "ZombieQuest","Vampire",CFrame.new(-5800,100,-775) end
    if level <= 1024 then return "GraveyardQuest","Living Zombie",CFrame.new(-9519,142,5926) end
    if level <= 1049 then return "GraveyardQuest","Demonic Soul",CFrame.new(-9500,142,6042) end
    if level <= 1099 then return "SnowMountainQuest","Arctic Warrior",CFrame.new(563,402,-6572) end
    if level <= 1124 then return "SnowMountainQuest","Snow Lurker",CFrame.new(619,402,-6770) end
    if level <= 1174 then return "HotIslandQuest","Magma Ninja",CFrame.new(5564,402,-4926) end
    if level <= 1199 then return "HotIslandQuest","Lava Pirate",CFrame.new(5800,402,-4813) end
    if level <= 1249 then return "PiratePortQuest","Pirate Millionaire",CFrame.new(-288,44,5587) end
    if level <= 1274 then return "PiratePortQuest","Pistol Billionaire",CFrame.new(-237,44,5913) end
    if level <= 1299 then return "MansionQuest","Dragon Crew Warrior",CFrame.new(-3952,331,-2786) end
    if level <= 1324 then return "MansionQuest","Dragon Crew Archer",CFrame.new(-4320,380,-2772) end
    if level <= 1349 then return "TikiQuest","Isle Outlaw",CFrame.new(-16500,400,-1500) end
    return "TikiQuest","Isle Champion",CFrame.new(-16600,400,-1200)
end

-- Lista de bosses com níveis e posições
local Bosses = {
    {Name="Gorilla King",Level=20,Pos=CFrame.new(-1123,40,-525)},
    {Name="Bobby",Level=55,Pos=CFrame.new(-4566,16,4438)},
    {Name="Yeti",Level=105,Pos=CFrame.new(1123,130,-1354)},
    {Name="Mob Leader",Level=120,Pos=CFrame.new(-2850,7,5354)},
    {Name="Vice Admiral",Level=130,Pos=CFrame.new(-6500,7,5600)},
    {Name="Warden",Level=230,Pos=CFrame.new(5093,0,4741)},
    {Name="Chief Warden",Level=240,Pos=CFrame.new(5155,0,4724)},
    {Name="Swan",Level=250,Pos=CFrame.new(2064,17,884)},
    {Name="Magma Admiral",Level=350,Pos=CFrame.new(-5836,80,8800)},
    {Name="Fishman Lord",Level=425,Pos=CFrame.new(61150,10,1570)},
    {Name="Wysper",Level=500,Pos=CFrame.new(-4100,690,-2750)},
    {Name="Thunder God",Level=575,Pos=CFrame.new(-5000,900,-3000)},
    {Name="Cyborg",Level=675,Pos=CFrame.new(6050,40,4500)},
    {Name="Jeremy",Level=850,Pos=CFrame.new(225,70,1250)},
    {Name="Fajita",Level=925,Pos=CFrame.new(-5500,40,-400)},
    {Name="Don Swan",Level=1000,Pos=CFrame.new(2285,15,690)},
    {Name="Smokey",Level=1050,Pos=CFrame.new(-4655,340,-870)},
    {Name="Awakened Ice Admiral",Level=1350,Pos=CFrame.new(1100,10,-6500)},
    {Name="Stone",Level=1550,Pos=CFrame.new(-300,40,5500)},
    {Name="Island Empress",Level=1675,Pos=CFrame.new(5400,100,4800)},
    {Name="Kilo Admiral",Level=1750,Pos=CFrame.new(6100,120,-2600)},
    {Name="Captain Elephant",Level=1875,Pos=CFrame.new(-13200,300,-7700)},
    {Name="Beautiful Pirate",Level=1950,Pos=CFrame.new(5200,600,-2000)},
    {Name="rip_indra",Level=2100,Pos=CFrame.new(-5400,300,-2900)}
}

-- SISTEMAS AUTOMATIZADOS
spawn(function()
    while true do wait(1)
        if Toggles.AutoHaki then
            pcall(function()
                if not player.Character:FindFirstChild("HasBuso") then
                    replicated.CommF_:InvokeServer("Buso")
                end
            end)
        end
        if Toggles.FastAttack then
            pcall(function()
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    replicated.CommF_:InvokeServer("WeaponChange", tool.Name)
                    replicated.CommF_:InvokeServer("Combat", tool)
                end
            end)
        end
    end
end)

spawn(function()
    while true do wait(2)
        if Toggles.Hitbox then
            pcall(function()
                for _, mob in pairs(workspaceEnemies:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") then
                        mob.HumanoidRootPart.Size = Vector3.new(60,60,60)
                        mob.HumanoidRootPart.Transparency = 1
                        mob.HumanoidRootPart.CanCollide = false
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while true do wait(1)
        if Toggles.AutoFruit then
            pcall(function()
                replicated.CommF_:InvokeServer("BuyRandomFruit")
                wait(1)
                local tool = player.Backpack:FindFirstChildOfClass("Tool")
                if tool then
                    replicated.CommF_:InvokeServer("StoreFruit", tool.Name)
                end
            end)
        end
    end
end)

spawn(function()
    while true do wait(1)
        if Toggles.AutoFarm then
            pcall(function()
                local questName, mobName, pos = GetQuestAndMob()
                FlyTo(pos.Position and pos.Position or pos)
                replicated.CommF_:InvokeServer("StartQuest", questName, 1)
                for _, mob in pairs(workspaceEnemies:GetChildren()) do
                    if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        repeat
                            wait(0.2)
                            FlyTo(mob.HumanoidRootPart.Position)
                        until not mob.Parent or mob.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while true do wait(5)
        if Toggles.AutoBoss then
            local lvl = player.Data.Level.Value
            for _, boss in pairs(Bosses) do
                if lvl >= boss.Level then
                    for _, mob in pairs(workspaceEnemies:GetChildren()) do
                        if mob.Name == boss.Name and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            FlyTo(boss.Pos.Position and boss.Pos.Position or boss.Pos)
                            repeat
                                wait(0.3)
                                FlyTo(mob.HumanoidRootPart.Position + Vector3.new(0,20,0))
                            until not mob.Parent or mob.Humanoid.Health <= 0
                        end
                    end
                end
            end
        end
    end
end)

spawn(function()
    while true do wait(5)
        if Toggles.AutoSea then
            local lvl = player.Data.Level.Value
            local pid = game.PlaceId
            if lvl >= 700 and pid == 2753915549 then
                replicated.CommF_:InvokeServer("TravelDressrosa")
            elseif lvl >= 1500 and pid == 4442272183 then
                replicated.CommF_:InvokeServer("TravelZou")
            end
        end
    end
end)

-- GUI: adicionar toggles
local tab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998"})
for name, bool in pairs(Toggles) do
    tab:AddToggle({
        Name = name,
        Default = false,
        Callback = function(val) Toggles[name] = val end
    })
end

OrionLib:Init()
