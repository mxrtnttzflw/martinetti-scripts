--[[
 Fly GUI V9 - Recolor & Credit Patch (By Nico)
 Intenta aplicar colores rojo elegante + negro y cambiar "By KIRO" -> "By Nico".
 Preserva la funcionalidad original del fly (no modifica la lógica de vuelo).
]]

-- 1) Cargar el script original (igual que antes)
pcall(function()
    loadstring(game:HttpGet("https://pastebin.com/raw/QnBuB3iq"))()
end)

-- 2) Parámetros de estilo
local ROJO = Color3.fromRGB(170, 0, 0)
local NEGRO = Color3.fromRGB(0, 0, 0)
local BLANCO = Color3.fromRGB(255, 255, 255)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local MAX_WAIT = 10 -- segundos máximo para esperar a que aparezca la GUI

-- Función que aplica estilos a un GUI (cambia colores y texto)
local function aplicarEstilo(gui)
    if not gui or not gui.Parent then return end

    -- Recolor general
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("Frame") or obj:IsA("ScrollingFrame") or obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            -- Mantener imágenes si existen; para frames forzamos fondo negro si es Colorable
            pcall(function() obj.BackgroundColor3 = NEGRO end)
            pcall(function() obj.BorderColor3 = ROJO end)
        elseif obj:IsA("TextButton") then
            pcall(function() obj.BackgroundColor3 = ROJO end)
            pcall(function() obj.TextColor3 = BLANCO end)
            pcall(function() obj.BorderColor3 = NEGRO end)
        elseif obj:IsA("TextLabel") then
            -- Si el label contiene "fly gui" lo usamos como título
            local ok, txt = pcall(function() return obj.Text end)
            if ok and type(txt) == "string" and string.find(string.lower(txt), "fly gui") then
                pcall(function() obj.Text = "Fly GUI V9 – By Nico" end)
            else
                -- Si el label parece ser el crédito (contiene KIRO) lo cambiamos
                if ok and string.find(string.lower(txt or ""), "kiro") then
                    pcall(function() obj.Text = string.gsub(txt, "[Kk][Ii][Rr][Oo]", "Nico") end)
                end
            end
            pcall(function() obj.TextColor3 = ROJO end)
            pcall(function() obj.BackgroundColor3 = NEGRO end)
            pcall(function() obj.BorderColor3 = ROJO end)
        end
    end

    -- Cambiar cualquier TextLabel/ TextButton suelto que diga "By KIRO" exactamente
    for _, obj in ipairs(gui:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextButton")) then
            pcall(function()
                if obj.Text and string.find(string.lower(obj.Text), "kiro") then
                    obj.Text = string.gsub(obj.Text, "[Kk][Ii][Rr][Oo]", "Nico")
                end
            end)
        end
    end
end

-- Busca una ScreenGui que parezca la del fly
local function esPosibleFlyGui(g)
    if not g or not g:IsA("ScreenGui") then return false end
    for _, d in ipairs(g:GetDescendants()) do
        if d:IsA("TextButton") or d:IsA("TextLabel") then
            local ok, txt = pcall(function() return d.Text end)
            if ok and type(txt) == "string" then
                local ltxt = string.lower(txt)
                if string.find(ltxt, "fly") or string.find(ltxt, "fly gui") or string.find(ltxt, "by kiro") or string.find(ltxt, "flygui") then
                    return true
                end
                -- botones comunes: "FLY", "UP", "DOWN", "+"
                if ltxt == "fly" or ltxt == "up" or ltxt == "down" or ltxt == "+" or ltxt == "-" then
                    return true
                end
            end
        end
    end
    return false
end

-- Intenta encontrar y aplicar estilo a cualquier GUI dentro de PlayerGui o CoreGui
local function buscarYAplicar()
    local found = false
    local t0 = tick()
    while tick() - t0 < MAX_WAIT do
        -- Comprobar PlayerGui
        if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
            for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
                if esPosibleFlyGui(gui) then
                    pcall(aplicarEstilo, gui)
                    -- Suscribir para futuros descendants añadidos (por si el script los recrea)
                    pcall(function()
                        gui.DescendantAdded:Connect(function()
                            pcall(function() aplicarEstilo(gui) end)
                        end)
                    end)
                    found = true
                end
            end
        end

        -- Comprobar CoreGui (algunos scripts insertan ahí)
        local coreGuiChildren = game:GetService("CoreGui"):GetChildren()
        for _, gui in ipairs(coreGuiChildren) do
            if esPosibleFlyGui(gui) then
                pcall(aplicarEstilo, gui)
                pcall(function()
                    gui.DescendantAdded:Connect(function()
                        pcall(function() aplicarEstilo(gui) end)
                    end)
                end)
                found = true
            end
        end

        if found then break end
        task.wait(0.6)
    end

    -- Intentar enviar notificación (si SetCore está disponible)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Fly GUI V9";
            Text = "By Nico";
            Duration = 5;
        })
    end)

    return found
end

-- Ejecutar búsqueda inicialmente
local ok = buscarYAplicar()

-- Si no encontró nada, suscribirse a nuevos ScreenGuis (por si se crean después)
if not ok then
    -- Observa PlayerGui creación
    if LocalPlayer then
        local pg = LocalPlayer:WaitForChild("PlayerGui")
        pg.ChildAdded:Connect(function(child)
            task.delay(0.25, function()
                if esPosibleFlyGui(child) then
                    pcall(aplicarEstilo, child)
                    pcall(function()
                        child.DescendantAdded:Connect(function()
                            pcall(function() aplicarEstilo(child) end)
                        end)
                    end)
                end
            end)
        end)
    end

    -- Observa CoreGui creación
    local cg = game:GetService("CoreGui")
    cg.ChildAdded:Connect(function(child)
        task.delay(0.25, function()
            if esPosibleFlyGui(child) then
                pcall(aplicarEstilo, child)
                pcall(function()
                    child.DescendantAdded:Connect(function()
                        pcall(function() aplicarEstilo(child) end)
                    end)
                end)
            end
        end)
    end)
end

-- Mensaje final en consola para debug
print("[Fly GUI Patch] Intento de recolor: terminado. Encontrado inicialmente:", ok)
