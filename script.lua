local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

local Toggles = {
    AutoFarm = false,
    AutoBoss = false,
    FastAttack = false,
    Hitbox = false,
    AutoFruit = false,
    AutoHaki = false,
    AutoSea = false
}

local Window = OrionLib:MakeWindow({Name = "Kaitun Hub - Blox Fruits", HidePremium = false, SaveConfig = true, ConfigFolder = "KaitunBF"})

local MainTab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})
MainTab:AddToggle({Name = "Auto Farm (com Quest)", Default = false, Callback = function(Value) Toggles.AutoFarm = Value end})
MainTab:AddToggle({Name = "Auto Boss", Default = false, Callback = function(Value) Toggles.AutoBoss = Value end})
MainTab:AddToggle({Name = "Fast Attack", Default = false, Callback = function(Value) Toggles.FastAttack = Value end})
MainTab:AddToggle({Name = "Hitbox Aumentada", Default = false, Callback = function(Value) Toggles.Hitbox = Value end})
MainTab:AddToggle({Name = "Auto Haki", Default = false, Callback = function(Value) Toggles.AutoHaki = Value end})
MainTab:AddToggle({Name = "Auto Buy & Store Fruit", Default = false, Callback = function(Value) Toggles.AutoFruit = Value end})
MainTab:AddToggle({Name = "Trocar Mar Automaticamente", Default = false, Callback = function(Value) Toggles.AutoSea = Value end})

OrionLib:Init()

function FlyTo(pos)
    local chr = player.Character
    if not chr or not chr:FindFirstChild("HumanoidRootPart") then return end
    local hrp = chr.HumanoidRootPart
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 25, 0))
end

spawn(function()
    while wait(1) do
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
    while wait(5) do
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
    while wait(5) do
        if Toggles.AutoBoss then
            pcall(function()
                local level = player.Data.Level.Value
                for _, boss in pairs(Bosses) do
                    if level >= boss.Level then
                        for _, mob in pairs(workspace.Enemies:GetChildren()) do
                            if mob.Name == boss.Name and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                                FlyTo(boss.Position.Position)
                                repeat wait(0.2)
                                    FlyTo(mob.HumanoidRootPart.Position + Vector3.new(0, 20, 0))
                                until mob.Humanoid.Health <= 0 or not mob.Parent
                            end
                        end
                    end
                end
            end)
        end
    end
end)
