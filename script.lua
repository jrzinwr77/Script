# Preparar novo script como string para o usuário copiar diretamente
script_completo = """
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local camera = game.Workspace.CurrentCamera

local Toggles = {
    AutoFarm = false,
    AutoBoss = false,
    FastAttack = false,
    Hitbox = false,
    AutoFruit = false,
    AutoHaki = false,
    AutoSea = false
}

local Window = OrionLib:MakeWindow({Name = "Kaitun Hub - Blox Fruits (Mobile)", HidePremium = false, SaveConfig = true, ConfigFolder = "KaitunBF"})

local MainTab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})
MainTab:AddToggle({Name = "Auto Farm (com Quest)", Default = false, Callback = function(v) Toggles.AutoFarm = v end})
MainTab:AddToggle({Name = "Auto Boss", Default = false, Callback = function(v) Toggles.AutoBoss = v end})
MainTab:AddToggle({Name = "Fast Attack", Default = false, Callback = function(v) Toggles.FastAttack = v end})
MainTab:AddToggle({Name = "Hitbox Aumentada", Default = false, Callback = function(v) Toggles.Hitbox = v end})
MainTab:AddToggle({Name = "Auto Haki", Default = false, Callback = function(v) Toggles.AutoHaki = v end})
MainTab:AddToggle({Name = "Auto Buy & Store Fruit", Default = false, Callback = function(v) Toggles.AutoFruit = v end})
MainTab:AddToggle({Name = "Trocar Mar Automaticamente", Default = false, Callback = function(v) Toggles.AutoSea = v end})

OrionLib:Init()

function FlyTo(pos)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character.HumanoidRootPart
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 25, 0))
end

spawn(function()
    while task.wait(1) do
        if Toggles.AutoHaki then
            pcall(function()
                if not player.Character:FindFirstChild("HasBuso") then
                    replicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(5) do
        if Toggles.AutoSea then
            pcall(function()
                local level = player.Data.Level.Value
                local placeId = game.PlaceId
                if level >= 700 and placeId == 2753915549 then
                    replicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
                    wait(10)
                elseif level >= 1500 and placeId == 4442272183 then
                    replicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
                    wait(10)
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(1) do
        if Toggles.Hitbox then
            for _,v in pairs(workspace.Enemies:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                    v.HumanoidRootPart.Transparency = 0.5
                    v.HumanoidRootPart.Material = Enum.Material.ForceField
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do
        if Toggles.FastAttack then
            pcall(function()
                local blade = player.Character:FindFirstChildOfClass("Tool")
                if blade then
                    replicatedStorage.Remotes.CommF_:InvokeServer("Attack", blade)
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(1) do
        if Toggles.AutoFruit then
            pcall(function()
                replicatedStorage.Remotes.CommF_:InvokeServer("BuyFruit", "Random")
                wait(1)
                replicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", "df")
            end)
        end
    end
end)

local function GetQuest()
    local level = player.Data.Level.Value
    if level < 10 then
        return {QuestName = "BanditQuest1", Enemy = "Bandit", Pos = Vector3.new(1150, 17, 163), QuestPos = Vector3.new(1060, 17, 154)}
    elseif level < 50 then
        return {QuestName = "MonkeyQuest", Enemy = "Monkey", Pos = Vector3.new(-1600, 20, 150), QuestPos = Vector3.new(-1599, 10, 175)}
    elseif level < 120 then
        return {QuestName = "BruteQuest", Enemy = "Brute", Pos = Vector3.new(-1140, 15, -500), QuestPos = Vector3.new(-1145, 17, -520)}
    end
end

spawn(function()
    while task.wait(1) do
        if Toggles.AutoFarm then
            pcall(function()
                local questData = GetQuest()
                if not questData then return end
                if not player.PlayerGui:FindFirstChild("QuestGUI") then
                    replicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.QuestName, 1)
                    wait(1)
                end
                for _,enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy.Name == questData.Enemy and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                        repeat task.wait()
                            FlyTo(enemy.HumanoidRootPart.Position + Vector3.new(0,20,0))
                        until enemy.Humanoid.Health <= 0 or not Toggles.AutoFarm
                    end
                end
            end)
        end
    end
end)

local Bosses = {
    {Name = "Gorilla King", Level = 20, Position = CFrame.new(-1123, 40, -525)},
    {Name = "Yeti", Level = 105, Position = CFrame.new(1123, 130, -1354)},
    {Name = "Vice Admiral", Level = 130, Position = CFrame.new(-6500, 7, 5600)},
    {Name = "Warden", Level = 230, Position = CFrame.new(5093, 0, 4741)},
    {Name = "Swan", Level = 250, Position = CFrame.new(2064, 17, 884)},
    {Name = "Magma Admiral", Level = 350, Position = CFrame.new(-5836, 80, 8800)},
    {Name = "Thunder God", Level = 575, Position = CFrame.new(-5000, 900, -3000)},
    {Name = "Cyborg", Level = 675, Position = CFrame.new(6050, 40, 4500)},
    {Name = "Fajita", Level = 925, Position = CFrame.new(-5500, 40, -400)},
    {Name = "Awakened Ice Admiral", Level = 1350, Position = CFrame.new(1100, 10, -6500)},
    {Name = "Stone", Level = 1550, Position = CFrame.new(-300, 40, 5500)},
    {Name = "Island Empress", Level = 1675, Position = CFrame.new(5400, 100, 4800)},
    {Name = "Kilo Admiral", Level = 1750, Position = CFrame.new(6100, 120, -2600)},
    {Name = "Captain Elephant", Level = 1875, Position = CFrame.new(-13200, 300, -7700)}
}

spawn(function()
    while task.wait(5) do
        if Toggles.AutoBoss then
            pcall(function()
                local level = player.Data.Level.Value
                for _, boss in pairs(Bosses) do
                    if level >= boss.Level then
                        for _, mob in pairs(workspace.Enemies:GetChildren()) do
                            if mob.Name == boss.Name and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                                FlyTo(boss.Position.Position)
                                repeat task.wait(0.2)
                                    FlyTo(mob.HumanoidRootPart.Position + Vector3.new(0, 20, 0))
                                until mob.Humanoid.Health <= 0 or not mob.Parent or not Toggles.AutoBoss
                            end
                        end
                    end
                end
            end)
        end
    end
end)
"""

# Salvar como arquivo temporário para visualização e copiar depois se necessário
with open("/mnt/data/script_completo_kaitun_mobile.lua", "w") as f:
    f.write(script_completo)

"/mnt/data/script_completo_kaitun_mobile.lua"
