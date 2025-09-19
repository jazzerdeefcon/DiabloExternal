-- init.lua
-- Punto de entrada público con fecha de expiración embebida
-- Muestra mensajes visuales en pantalla para verificar estado

-- ======================
-- Configuración
-- ======================
--local EXPIRATION_DATE = "2025-09-30" -- AAAA-MM-DD

-- ======================
-- Función para parsear fecha
-- ======================
--local function parseDate(str)
--    local y, m, d = string.match(str, "(%d+)%-(%d+)%-(%d+)")
--   return os.time({year = y, month = m, day = d, hour = 0})
end


-- ======================
-- Función para mostrar mensaje en pantalla temporalmente
-- ======================
local messageQueue = {} -- Cola de mensajes activos

local function showMessage(msg, color, duration)
    duration = duration or 3
    local player = game:GetService("Players").LocalPlayer
    local gui = player:FindFirstChild("DiabloMessageGui")

    -- Crear ScreenGui si no existe
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "DiabloMessageGui"
        gui.ResetOnSpawn = false
        gui.Parent = player:WaitForChild("PlayerGui")
    end

    -- Crear label para el mensaje
    local label = Instance.new("TextLabel")
    label.BackgroundColor3 = color or Color3.fromRGB(25, 25, 25)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = msg
    label.TextSize = 18
    label.Font = Enum.Font.SourceSansBold
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.BackgroundTransparency = 0.2
    label.BorderSizePixel = 0
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.Position = UDim2.new(0.5, 0, 0, 0)
    label.Size = UDim2.new(0.4, 0, 0, 40)
    label.Parent = gui
    label.TextTransparency = 1 -- inicio invisible
    table.insert(messageQueue, label)

    -- Ajustar posiciones de todos los mensajes en la cola
    for i, msgLabel in ipairs(messageQueue) do
        local targetY = 100 + (i-1)*(msgLabel.Size.Y.Offset + 5)
        msgLabel:TweenPosition(UDim2.new(0.5, 0, 0, targetY), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    end

    -- Fade in
    for i = 0, 1, 0.1 do
        task.wait(0.02)
        label.TextTransparency = 1 - i
    end

    -- Destruir mensaje después de duration
    task.delay(duration, function()
        -- Fade out
        for i = 0, 1, 0.1 do
            task.wait(0.02)
            label.TextTransparency = i
        end

        -- Remover de la cola y destruir
        for i, v in ipairs(messageQueue) do
            if v == label then
                table.remove(messageQueue, i)
                break
            end
        end
        label:Destroy()

        -- Reajustar posiciones de los mensajes restantes
        for i, msgLabel in ipairs(messageQueue) do
            local targetY = 100 + (i-1)*(msgLabel.Size.Y.Offset + 5)
            msgLabel:TweenPosition(UDim2.new(0.5, 0, 0, targetY), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
    end)
end


-- ======================
-- Verificación de licencia/fecha
-- ======================
local now = os.time()
local expire = parseDate(EXPIRATION_DATE)

if now > expire then
    showMessage("❌ Este script ha expirado. Contacta al desarrollador.", Color3.fromRGB(200,0,0))
    return
else
    showMessage("✅ Licencia válida. Cargando módulos...", Color3.fromRGB(0,200,0), 2)
end

-- ======================
-- Función para cargar módulos desde GitHub
-- ======================
local function loadModule(path)
    local url = "https://raw.githubusercontent.com/jazzerdeefcon/DiabloExternal/main/" .. path
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if not success then
        warn("Error al cargar módulo: ")
        showMessage("⚠ Error al cargar el módulo", Color3.fromRGB(255,100,0), 3)
        return nil
    end

    return result
end

-- ======================
-- Cargar menú principal
-- ======================
local menu = loadModule("modules/ui/menu.lua")

if menu and menu.init then
    menu.init(loadModule) -- ✅ pasamos la función loadModule
    showMessage("✅ Menú cargado correctamente", Color3.fromRGB(0,200,0), 2)
else
    warn("El menú no se pudo inicializar")
    showMessage("⚠ El menú no se pudo inicializar", Color3.fromRGB(255,100,0), 3)
end
