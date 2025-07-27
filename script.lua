--[[ SETTINGS ]]--
local distanceToShoot = 25 -- Distância máxima para auto shoot

--[[ SERVICES ]]--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Tabela de ESPs
local boxes = {}

-- Função para criar caixa
function createBox(player, color)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Transparency = 1
    box.Color = color
    box.Filled = false
    box.Visible = true
    boxes[player] = box
end

-- Função para detectar a função do jogador e definir a cor da caixa
function getPlayerRoleColor(player)
    if player.Character then
        local char = player.Character
        if char:FindFirstChild("Knife") then
            return Color3.fromRGB(255, 0, 0) -- Assassino (vermelho)
        elseif char:FindFirstChild("Gun") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Gun")) then
            return Color3.fromRGB(0, 0, 255) -- Xerife (azul)
        end
    end
    return Color3.fromRGB(0, 255, 0) -- Inocente (verde)
end

-- Atualiza as caixas constantemente
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if not boxes[player] then
                createBox(player, getPlayerRoleColor(player))
            end

            local box = boxes[player]
            local size = 3.5  -- Ajuste conforme necessário
            local scaleFactor = 1000 / (Camera.CFrame.Position - hrp.Position).Magnitude
            local width = scaleFactor * size
            local height = scaleFactor * size * 1.8

            if onscreen then
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                box.Color = getPlayerRoleColor(player)
                box.Visible = true
            else
                box.Visible = false
            end
        elseif boxes[player] then
            boxes[player].Visible = false
        end
    end
end)

-- Auto Shoot se você for o Xerife
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
                    -- Mira no Murderer e atira
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, murdererHRP.Position)
                    mouse1click()
                    wait(0.5)
                end
            end
        end
    end
end)
