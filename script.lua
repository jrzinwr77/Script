-- Configurações do script
getgenv().AutoConfig = {
    AutoFarm = true,
    AutoQuest = true,
    AutoHaki = true,
    AutoAttack = true,
    AutoEquip = "Melee", -- opções: "Melee", "Sword", "Gun"
    SafeMode = false,
    ServerHop = false,
    AutoFruit = false, -- coleta frutas pelo mapa
    FrutaDesejada = {"Dragon-Dragon", "Dough-Dough"},
}

-- Função de Ativar Haki (se tiver)
function AtivarHaki()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if char and not char:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

-- Função para atacar com click automático
function AutoClick()
    local VirtualUser = game:service('VirtualUser')
    game:service('Players').LocalPlayer.Idled:connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end

-- Função para equipar arma
function EquiparArma(nome)
    local plr = game.Players.LocalPlayer
    local mochila = plr.Backpack
    if mochila:FindFirstChild(nome) then
        plr.Character.Humanoid:EquipTool(mochila[nome])
    end
end

-- Loop principal
spawn(function()
    while wait(1) do
        if not AutoConfig.AutoFarm then return end

        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local pos = char.HumanoidRootPart.Position

        -- Ativa Haki
        if AutoConfig.AutoHaki then
            AtivarHaki()
        end

        -- Ativa ataque
        if AutoConfig.AutoAttack then
            pcall(function()
                local hum = char:FindFirstChildOfClass("Humanoid")
                hum:ChangeState(11)
                mouse1click()
            end)
        end

        -- Auto Equip
        if AutoConfig.AutoEquip then
            EquiparArma(AutoConfig.AutoEquip)
        end

        -- Você pode adicionar aqui sua lógica de buscar missão ou inimigos
    end
end)

-- Anti-AFK ativado
AutoClick()

print("💻 Kaitun Script Inicializado (sem Key)")
