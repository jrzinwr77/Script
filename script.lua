--[[ SETTINGS ]]--
local distanceToShoot = 25 -- distância para dar auto shot

--[[ ESP + Auto Shot Script ]]--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Tabela de ESPs
local espTable = {}

-- Função para criar ESP
function createESP(player, roleColor)
    local esp = Drawing.new("Text")
    esp.Visible = true
    esp.Center = true
    esp.Outline = true
    esp.Font = 2
    esp.Size = 16
    esp.Color = roleColor
    espTable[player] = esp
end

-- Atualiza ESPs
RunService.RenderStepped:Connect(function()
    for i, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
            local esp = espTable[player]

            if not esp then
                -- Detecta função do jogador
                local role = player:GetRoleInGroup(0) -- Placeholder; MM2 detecta via armas
                local color = Color3.fromRGB(0, 255, 0) -- Inocente padrão

                if player:FindFirstChild("Backpack") then
                    if player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
                        color = Color3.fromRGB(0, 0, 255) -- Azul: Xerife
                    end
                end

                if player.Character:FindFirstChild("Knife") then
                    color = Color3.fromRGB(255, 0, 0) -- Vermelho: Murderer
                end

                createESP(player, color)
                esp = espTable[player]
                esp.Color = color
            end

            if onScreen then
                esp.Position = Vector2.new(pos.X, pos.Y)
                esp.Text = player.Name
                esp.Visible = true
            else
                esp.Visible = false
            end
        elseif espTable[player] then
            espTable[player].Visible = false
        end
    end
end)

-- Auto Shoot se você for o xerife
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Gun") then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Knife") then
            local murdererHRP = player.Character:FindFirstChild("HumanoidRootPart")
            local localHRP = char:FindFirstChild("HumanoidRootPart")
            if murdererHRP and localHRP then
                local distance = (murdererHRP.Position - localHRP.Position).Magnitude
                if distance <= distanceToShoot then
                    -- Mira e atira
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, murdererHRP.Position)
                    mouse1click() -- Clique do mouse
                    wait(0.5)
                end
            end
        end
    end
end)
