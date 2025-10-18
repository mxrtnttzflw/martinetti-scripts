-- Script en Lua para un GUI estilo C00LKID en Roblox
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

-- Crear el ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoolkidGui"
screenGui.Parent = Player.PlayerGui
screenGui.ResetOnSpawn = false

-- Crear el Frame principal (arrastrable)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Fondo negro por defecto
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Borde rojo por defecto
frame.Parent = screenGui

-- Estilo C00LKID: Añadir un efecto de brillo (UIStroke) rojo por defecto
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(255, 0, 0) -- Borde rojo por defecto
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = frame

-- Título del GUI
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Martinetti's Scripts :)" -- Título por defecto
title.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco por defecto
title.TextStrokeColor3 = Color3.fromRGB(255, 0, 0) -- Contorno rojo por defecto
title.TextStrokeTransparency = 0
title.Font = Enum.Font.Code
title.TextSize = 24
title.Parent = frame

-- Texto "Tiktok: m4rt1n3tt1" en la esquina inferior derecha
local tiktokText = Instance.new("TextLabel")
tiktokText.Size = UDim2.new(0, 100, 0, 20)
tiktokText.Position = UDim2.new(0.85, -100, 0.9, 0)
tiktokText.BackgroundTransparency = 1
tiktokText.Text = "Tiktok: m4rt1n3tt1"
tiktokText.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco por defecto
tiktokText.TextStrokeColor3 = Color3.fromRGB(255, 0, 0) -- Contorno rojo por defecto
tiktokText.TextStrokeTransparency = 0
tiktokText.Font = Enum.Font.Code
tiktokText.TextSize = 12
tiktokText.Parent = frame

-- Campo de entrada de texto
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0, 30)
textBox.Position = UDim2.new(0.1, 0, 0.3, 0)
textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Fondo negro por defecto
textBox.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco por defecto
textBox.PlaceholderText = "Enter h4ck code..."
textBox.PlaceholderColor3 = Color3.fromRGB(255, 0, 0) -- Placeholder rojo por defecto
textBox.Font = Enum.Font.Code
textBox.TextSize = 18
textBox.Parent = frame

-- Estilo neón para el TextBox (borde rojo por defecto)
local textBoxStroke = Instance.new("UIStroke")
textBoxStroke.Thickness = 1
textBoxStroke.Color = Color3.fromRGB(255, 0, 0) -- Borde rojo por defecto
textBoxStroke.Parent = textBox

-- Botón de minimizar "_" en la esquina superior derecha
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Position = UDim2.new(0.95, -20, 0, 0)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco por defecto
minimizeButton.TextStrokeColor3 = Color3.fromRGB(255, 0, 0) -- Contorno rojo por defecto
minimizeButton.TextStrokeTransparency = 0
minimizeButton.Font = Enum.Font.Code
minimizeButton.TextSize = 16
minimizeButton.Parent = frame

local isMinimized = false

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        textBox.Visible = false
        tiktokText.Visible = false
        frame.Size = UDim2.new(0, 300, 0, 50) -- Solo muestra el título
    else
        textBox.Visible = true
        tiktokText.Visible = true
        frame.Size = UDim2.new(0, 300, 0, 200) -- Restaura el tamaño completo
    end
end)

-- Variable para rastrear si el hack está activo y el modo rosa
local hackEnabled = false
local pinkMode = false
local espEnabled = false
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP"
espFolder.Parent = game.CoreGui
local originalWalkSpeed = Player.Character and Player.Character.Humanoid.WalkSpeed or 16
local originalJumpPower = Player.Character and Player.Character.Humanoid.JumpPower or 50
local infiniteJumpConnection = nil

-- Función para activar/desactivar saltos infinitos
local function toggleInfiniteJump(enabled)
    if infiniteJumpConnection then
        infiniteJumpConnection:Disconnect()
        infiniteJumpConnection = nil
    end
    if enabled and Player.Character then
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if Player.Character and Player.Character.Humanoid then
                Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- Función para activar/desactivar ESP
local function toggleESP(enabled)
    espEnabled = enabled
    for _, child in pairs(espFolder:GetChildren()) do
        child:Destroy()
    end
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
                -- Hitbox rojo (Highlight)
                local highlight = Instance.new("Highlight")
                highlight.Parent = espFolder
                highlight.Adornee = player.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0

                -- Username y distancia en rojo (BillboardGui)
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Parent = espFolder
                billboardGui.Adornee = player.Character.Head
                billboardGui.Size = UDim2.new(0, 200, 0, 50)
                billboardGui.StudsOffset = Vector3.new(0, 2, 0)
                billboardGui.AlwaysOnTop = true

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Parent = billboardGui
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                nameLabel.TextStrokeTransparency = 0
                nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                nameLabel.Font = Enum.Font.Code
                nameLabel.TextSize = 18

                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.Parent = billboardGui
                distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
                distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                distanceLabel.TextStrokeTransparency = 0
                distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                distanceLabel.Font = Enum.Font.Code
                distanceLabel.TextSize = 14

                -- Actualizar distancia cada frame
                local connection
                connection = RunService.Heartbeat:Connect(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = math.floor((player.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude)
                        distanceLabel.Text = distance .. " studs"
                    else
                        connection:Disconnect()
                    end
                end)
            end
        end
    end
end

-- Función para cambiar al modo rosa
local function setPinkMode(enabled)
    pinkMode = enabled
    local pinkColor = Color3.fromRGB(255, 105, 180) -- Rosa suave
    if enabled then
        frame.BackgroundColor3 = pinkColor
        frame.BorderColor3 = pinkColor
        uiStroke.Color = pinkColor
        title.Text = "Te amo Anabella :3"
        title.TextColor3 = pinkColor
        title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255) -- Contorno blanco para contraste
        tiktokText.TextColor3 = pinkColor
        tiktokText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        textBox.BackgroundColor3 = pinkColor
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
        textBoxStroke.Color = pinkColor
        minimizeButton.TextColor3 = pinkColor
        minimizeButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    else
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        uiStroke.Color = Color3.fromRGB(255, 0, 0)
        title.Text = "Martinetti's Scripts :)"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
        tiktokText.TextColor3 = Color3.fromRGB(255, 255, 255)
        tiktokText.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
        textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.PlaceholderColor3 = Color3.fromRGB(255, 0, 0)
        textBoxStroke.Color = Color3.fromRGB(255, 0, 0)
        minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        minimizeButton.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
    end
end

-- Lógica para el campo de texto
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local input = textBox.Text
        local lowerInput = input:lower()
        if input == "ESP" then
            toggleESP(true)
            textBox.Text = ""
            StarterGui:SetCore("SendNotification", {
                Title = "Esp highlight activado!",
                Text = "Disfruta :)",
                Duration = 3
            })
        elseif input == "UNESP" and espEnabled then
            toggleESP(false)
            textBox.Text = ""
            StarterGui:SetCore("SendNotification", {
                Title = "Esp highlight desactivado",
                Text = "Chau esp pipipi",
                Duration = 3
            })
        elseif lowerInput == "martinetti" and not hackEnabled then
            hackEnabled = true
            if Player.Character and Player.Character.Humanoid then
                Player.Character.Humanoid.WalkSpeed = 20
                Player.Character.Humanoid.JumpPower = 50
                toggleInfiniteJump(true)
            end
            textBox.Text = ""
            StarterGui:SetCore("SendNotification", {
                Title = "H4CK activado :)",
                Text = "20 speed + infjump",
                Duration = 3
            })
        elseif lowerInput == "desactivar hack" and hackEnabled then
            hackEnabled = false
            if Player.Character and Player.Character.Humanoid then
                Player.Character.Humanoid.WalkSpeed = originalWalkSpeed
                Player.Character.Humanoid.JumpPower = originalJumpPower
                toggleInfiniteJump(false)
                setPinkMode(false) -- Revertir a colores originales al desactivar
            end
            textBox.Text = ""
            StarterGui:SetCore("SendNotification", {
                Title = "H4CK DEACTIVATED",
                Text = "Hack desactivated :( 16 speed + no infjump",
                Duration = 3
            })
        elseif lowerInput == "gui kawai" then
            setPinkMode(true)
            textBox.Text = ""
            StarterGui:SetCore("SendNotification", {
                Title = "Te sientes muy onichan?",
                Text = "GUI en rosa activado xd",
                Duration = 3
            })
        elseif lowerInput == "gui normal" then
            setPinkMode(false) -- Volver a la normalidad
            textBox.Text = ""
            StarterGui:SetCore("SendNotification", {
                Title = "GUI normal activada",
                Text = "Pongase serio siervo",
                Duration = 3
            })
        else
            textBox.Text = ""
            StarterGui:SetCore("SendNotification", {
                Title = "ERROR",
                Text = "Invalid h4ck code!",
                Duration = 3
            })
        end
    end
end)

-- Manejar nuevos jugadores para ESP
Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        player.CharacterAdded:Connect(function()
            wait(1) -- Esperar a que el personaje cargue completamente
            toggleESP(false) -- Limpiar y reactivar para incluir al nuevo jugador
            toggleESP(true)
        end)
    end
end)

-- Lógica para arrastrar el GUI
local dragging
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Guardar la velocidad original del jugador cuando el personaje se carga
Player.CharacterAdded:Connect(function(character)
    originalWalkSpeed = character.Humanoid.WalkSpeed
    originalJumpPower = character.Humanoid.JumpPower
end)