local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ws = game:GetService("Workspace")

function flyTo(pos)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 25, 0))
    end
end

function autoHaki()
    if not player.Character:FindFirstChild("HasBuso") then
        rs.Remotes.CommF_:InvokeServer("Buso")
    end
end

function getQuestForLevel(level)
    local quests = {
        {min = 1, max = 9, npc = "Bandit", pos = CFrame.new(1060, 16, 1547)},
        {min = 10, max = 14, npc = "Monkey", pos = CFrame.new(-1122, 40, -525)},
        {min = 15, max = 29, npc = "Gorilla", pos = CFrame.new(-1495, 40, -320)},
        {min = 30, max = 59, npc = "Pirate", pos = CFrame.new(-4951, 30, 4360)},
        {min = 60, max = 74, npc = "Brute", pos = CFrame.new(-5174, 30, 4950)},
        {min = 75, max = 89, npc = "Desert Bandit", pos = CFrame.new(921, 7, 4484)},
        {min = 90, max = 99, npc = "Desert Officer", pos = CFrame.new(1570, 10, 4375)},
        {min = 100, max = 119, npc = "Snow Bandit", pos = CFrame.new(1392, 87, -1297)},
        {min = 120, max = 149, npc = "Snowman", pos = CFrame.new(1211, 105, -1444)},
        {min = 150, max = 174, npc = "Chief Petty Officer", pos = CFrame.new(-4855, 20, 4300)},
        {min = 175, max = 189, npc = "Dark Master", pos = CFrame.new(-5250, 390, -2280)},
        {min = 190, max = 209, npc = "Sky Bandit", pos = CFrame.new(-4985, 278, -2875)},
        {min = 210, max = 249, npc = "Toga Warrior", pos = CFrame.new(-7875, 560, -2390)},
        {min = 250, max = 274, npc = "Gladiator", pos = CFrame.new(-7650, 560, -1550)},
        {min = 275, max = 299, npc = "Military Soldier", pos = CFrame.new(-5065, 100, 8450)},
        {min = 300, max = 324, npc = "Military Spy", pos = CFrame.new(-5200, 120, 8500)},
        {min = 325, max = 374, npc = "Fishman Warrior", pos = CFrame.new(61000, 10, 1500)},
        {min = 375, max = 399, npc = "Fishman Commando", pos = CFrame.new(61050, 10, 1800)},
        {min = 400, max = 449, npc = "God's Guard", pos = CFrame.new(-4700, 800, -1912)},
        {min = 450, max = 474, npc = "Shanda", pos = CFrame.new(-4600, 850, -2150)},
        {min = 475, max = 524, npc = "Royal Squad", pos = CFrame.new(-5500, 840, -2225)},
        {min = 525, max = 549, npc = "Royal Soldier", pos = CFrame.new(-5700, 870, -2500)}
    }
    for _, q in pairs(quests) do
        if level >= q.min and level <= q.max then
            return q
        end
    end
    return nil
end

function getNearestEnemy(name)
    for _, mob in pairs(ws.Enemies:GetChildren()) do
        if mob.Name:find(name) and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            return mob
        end
    end
    return nil
end

-- Auto Haki
spawn(function()
    while task.wait(1) do pcall(autoHaki) end
end)

-- Auto Farm com Quest
spawn(function()
    while task.wait(1) do
        local level = player.Data.Level.Value
        local quest = getQuestForLevel(level)
        if quest then
            rs.Remotes.CommF_:InvokeServer("StartQuest", quest.npc .. "Quest", 1)
            local enemy = getNearestEnemy(quest.npc)
            if enemy then
                repeat
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local pos = enemy.HumanoidRootPart.Position + Vector3.new(0, 30, 0)
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                    end

                    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end

                    wait(0.15)
                until not enemy or not enemy.Parent or enemy.Humanoid.Health <= 0
            end
        end
    end
end)

-- Trocar de mar automaticamente
spawn(function()
    while task.wait(10) do
        local level = player.Data.Level.Value
        if level >= 700 and game.PlaceId == 2753915549 then
            rs.Remotes.CommF_:InvokeServer("TravelDressrosa")
        elseif level >= 1500 and game.PlaceId == 4442272183 then
            rs.Remotes.CommF_:InvokeServer("TravelZou")
        end
    end
end)

-- Auto click
spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end)
    end
end)

-- Hitbox aumentada
spawn(function()
    while task.wait(1) do
        for _, mob in pairs(ws.Enemies:GetChildren()) do
            pcall(function()
                if mob:FindFirstChild("HumanoidRootPart") then
                    mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    mob.HumanoidRootPart.Transparency = 1
                    mob.HumanoidRootPart.CanCollide = false
                end
            end)
        end
    end
end)
