--[[ SETTINGS ]]--
local distanceToShoot = 25

--[[ SERVICES ]]--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local boxes = {}
local gunESP = nil

-- Detecta o papel do jogador com base na presença de arma/faca
function getPlayerRoleColor(player)
    local char = player.Character
    if not char then return Color3.fromRGB(0, 255, 0) end

    local backpack = player:FindFirstChild("Backpack")

    local hasKnife = (char:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife"))
    local hasGun = (char:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun"))

    if hasKnife then
        return Color3.fromRGB(255, 0, 0) -- Assassino
    elseif hasGun then
        return Color3.fromRGB(0, 0, 255) -- Xerife
    else
        return Color3.fromRGB(0, 255, 0) -- Inocente
    end
end

-- Cria ou atualiza uma caixa de ESP
function createOrUpdateBox(player, color)
    if not boxes[player] then
        local box = Drawing.new("Square")
        box.Thickness = 0
        box.Filled = true
        box.Transparency = 0.4
        box.Color = color
        box.Visible = true
        boxes[player] = box
    else
        boxes[player].Color = color
    end
end

-- Atualiza ESP dos jogadores
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            local color = getPlayerRoleColor(player)
            createOrUpdateBox(player, color)

            local box = boxes[player]
            local scaleFactor = 1000 / (Camera.CFrame.Position - hrp.Position).Magnitude
            local width = scaleFactor * 1.8
            local height = scaleFactor * 2.4

            if onScreen then
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 1.8)
                box.Visible = true
            else
                box.Visible = false
            end
        elseif boxes[player] then
            boxes[player].Visible = false
        end
    end
end)

-- Auto Shoot no assassino
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local hasGun = char and (char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")))
    if not hasGun then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char2 = player.Character
            local hasKnife = (char2:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife")))
            if hasKnife and char:FindFirstChild("HumanoidRootPart") and char2:FindFirstChild("HumanoidRootPart") then
                local dist = (char2.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                if dist <= distanceToShoot then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, char2.HumanoidRootPart.Position)
                    mouse1click()
                    wait(0.5)
                end
            end
        end
    end
end)

-- ESP da arma caída (GunDrop)
RunService.RenderStepped:Connect(function()
    local gunModel = workspace:FindFirstChild("GunDrop")

    if gunModel then
        if not gunESP then
            gunESP = Drawing.new("Circle")
            gunESP.Radius = 6
            gunESP.Filled = true
            gunESP.Color = Color3.fromRGB(255, 255, 0) -- Amarelo
            gunESP.Transparency = 1
            gunESP.Visible = true
        end

        local pos, onScreen = Camera:WorldToViewportPoint(gunModel.Position)
        if onScreen then
            gunESP.Position = Vector2.new(pos.X, pos.Y)
            gunESP.Visible = true
        else
            gunESP.Visible = false
        end
    elseif gunESP then
        gunESP.Visible = false
    end
end)
