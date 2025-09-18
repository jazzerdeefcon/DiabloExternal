-- init.lua
-- Punto de entrada publico con fecha de expiracion embebida

-- ======================
-- Configuracion
-- ======================
local EXPIRATION_DATE = "2025-09-30" -- AAAA-MM-DD

-- ======================
-- Funcion para parsear fecha
-- ======================
local function parseDate(str)
    local y, m, d = string.match(str, "(%d+)%-(%d+)%-(%d+)")
    return os.time({year = y, month = m, day = d, hour = 0})
end

-- ======================
-- Verificacion de licencia/fecha
-- ======================
local now = os.time()
local expire = parseDate(EXPIRATION_DATE)

if now > expire then
    warn("Este script ha expirado. Contacta al desarrollador para renovar acceso.")
    return
end

-- ======================
-- Funcion para cargar modulos desde GitHub
-- ======================
local function loadModule(path)
    local url = "https://raw.githubusercontent.com/jazzerdeefcon/DiabloExternal/main/" .. path
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if not success then
        warn("Error al cargar modulo: " .. path, result)
        return nil
    end

    return result
end

-- ======================
-- Cargar menu principal
-- ======================
local menu = loadModule("modules/ui/menu.lua")

if menu and menu.init then
    menu.init()
else
    warn("El menu no se pudo inicializar")
end
