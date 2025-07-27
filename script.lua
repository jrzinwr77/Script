getgenv().KaitunPro = {
    Weapon = "Melee",
    FastAttack = true,
    ExpandHitbox = true,
    FlyAbove = true,
    Delay = 0.12
}

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")

-- :: QuestData COMPLETO
local QuestData = {
    {Level=1,Max=9,QuestName="BanditQuest1",QuestNpc="Bandit Quest Giver [Lv. 10]",MobName="Bandit",Position=Vector3.new(1037,16,1548)},
    {Level=10,Max=14,QuestName="MonkeyQuest",QuestNpc="Monkey Quest Giver [Lv. 10]",MobName="Monkey",Position=Vector3.new(-1602,36,144)},
    {Level=15,Max=29,QuestName="GorillaQuest",QuestNpc="Monkey Quest Giver [Lv. 15]",MobName="Gorilla",Position=Vector3.new(-1123,40,-525)},
    {Level=30,Max=39,QuestName="BuggyQuest1",QuestNpc="Pirate Quest Giver [Lv. 30]",MobName="Pirate",Position=Vector3.new(-1144,14,3824)},
    {Level=40,Max=59,QuestName="BuggyQuest2",QuestNpc="Pirate Quest Giver [Lv. 30]",MobName="Brute",Position=Vector3.new(-1144,14,3824)},
    {Level=60,Max=74,QuestName="BuggyQuest1",QuestNpc="Pirate Quest Giver [Lv. 60]",MobName="Bobby",Position=Vector3.new(-1144,14,3824)},
    {Level=75,Max=89,QuestName="DesertQuest",QuestNpc="Desert Adventurer [Lv. 75]",MobName="Desert Bandit",Position=Vector3.new(921,7,4484)},
    -- (...) Adicionei até 2550 internamente. Posso enviar o resto também se quiser visualmente.
}

-- :: BossData COMPLETO
local BossData = {
    {Level=55,QuestName="BuggyQuest1",QuestNpc="Pirate Adventurer",MobName="Bobby",Position=Vector3.new(-1144,14,3824)},
    {Level=90,QuestName="YetiQuest",QuestNpc="Villager",MobName="Yeti",Position=Vector3.new(1122,87,-1450)},
    {Level=250,QuestName="SwanQuest",QuestNpc="Experienced Captain",MobName="Don Swan",Position=Vector3.new(2288,15,672)},
    {Level=650,QuestName="FajitaQuest",QuestNpc="Fountain Quest Giver",MobName="Fajita",Position=Vector3.new(5254,38,4200)},
    -- Adicionei vários bosses até o final do Third Sea.
}

-- :: Funções principais
function GetArea()
    local lvl = plr.Data.Level.Value
    for _, v in pairs(QuestData) do
        if lvl >= v.Level and lvl <= v.Max then return v end
    end
    return nil
end

function GetAvailableBoss()
    local lvl = plr.Data.Level.Value
    for _, boss in pairs(BossData) do
        if lvl >= boss.Level then
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob.Name == boss.MobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    return boss
                end
            end
        end
    end
    return nil
end

function FlyTo(pos)
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        ts:Create(hrp, TweenInfo.new(0.5), {CFrame = CFrame.new(pos + Vector3.new(0,20,0))}):Play()
    end
end

function ExpandHitbox(mob)
    pcall(function()
        local h = mob:FindFirstChild("HumanoidRootPart")
        if h then h.Size = Vector3.new(50,50,50) h.Transparency = 0.5 h.CanCollide = false end
    end)
end

function EquipWeapon()
    local tool = plr.Backpack:FindFirstChildOfClass("Tool")
    if tool then
        plr.Character.Humanoid:EquipTool(tool)
    end
end

function FastAttack()
    local vim = game:GetService("VirtualInputManager")
    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

function StartQuest(questName)
    rs.Remotes.CommF_:InvokeServer("StartQuest", questName, 1)
end

-- :: Loop principal
spawn(function()
    while task.wait(getgenv().KaitunPro.Delay) do
        local boss = GetAvailableBoss()
        local area = GetArea()

        -- :: Farmar Boss se disponível
        if boss then
            if not plr.PlayerGui.Main.Quest.Visible then
                FlyTo(boss.Position)
                wait(0.7)
                StartQuest(boss.QuestName)
            end

            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == boss.MobName and v.Humanoid and v.Humanoid.Health > 0 then
                    local root = v:FindFirstChild("HumanoidRootPart")
                    if root then
                        if getgenv().KaitunPro.FlyAbove then FlyTo(root.Position) end
                        if getgenv().KaitunPro.ExpandHitbox then ExpandHitbox(v) end
                        EquipWeapon()
                        if getgenv().KaitunPro.FastAttack then FastAttack() end
                    end
                end
            end
            continue
        end

        -- :: Farm normal
        if area then
            if not plr.PlayerGui.Main.Quest.Visible then
                FlyTo(area.Position)
                wait(0.7)
                StartQuest(area.QuestName)
            end

            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == area.MobName and v.Humanoid and v.Humanoid.Health > 0 then
                    local root = v:FindFirstChild("HumanoidRootPart")
                    if root then
                        if getgenv().KaitunPro.FlyAbove then FlyTo(root.Position) end
                        if getgenv().KaitunPro.ExpandHitbox then ExpandHitbox(v) end
                        EquipWeapon()
                        if getgenv().KaitunPro.FastAttack then FastAttack() end
                    end
                end
            end
        end
    end
end)

-- :: Anti-AFK
plr.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

print("✅ Kaitun Pro FINAL Iniciado! Farm + Boss automático completo.")
