-- init.lua
-- Punto de entrada público con fecha de expiración embebida
-- Muestra mensajes visuales en pantalla para verificar estado

-- ======================
-- Configuración
-- ======================
local EXPIRATION_DATE = "2025-09-30" -- AAAA-MM-DD

-- ======================
-- Función para parsear fecha
-- ======================
local function parseDate(str)
    local y, m, d = string.match(str, "(%d+)%-(%d+)%-(%d+)")
    return os.time({year = y, month = m, day = d, hour = 0})
end

-- ======================
-- Función para mostrar mensaje en pantalla temporalmente
-- ======================
local function showMessage(msg, color, duration)
    duration = duration or 3 -- duración por defecto en segundos
    local player = game:GetService("Players").LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "DiabloMessage"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local label = Instance.new("TextLabel")
    label.BackgroundColor3 = color or Color3.fromRGB(25, 25, 25)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = msg
    label.TextSize = 18
    label.Font = Enum.Font.SourceSansBold
    label.TextWrapped = true
    label.TextScaled = false
    label.AutomaticSize = Enum.AutomaticSize.XY -- Se ajusta automáticamente en X e Y
    label.Position = UDim2.new(0.5, 0, 0, 100)
    label.AnchorPoint = Vector2.new(0.5, 0) -- centra el label horizontalmente

    -- Agregar padding interno
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.Parent = label

    label.Parent = gui

    -- Destruir el mensaje automáticamente después de duration segundos
    task.delay(duration, function()
        if gui and gui.Parent then
            gui:Destroy()
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
        warn("Error al cargar módulo: " .. path, result)
        showMessage("⚠ Error cargando módulo: " .. path, Color3.fromRGB(255,100,0), 3)
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
