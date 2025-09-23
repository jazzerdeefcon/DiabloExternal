-- init.lua
-- ======================
-- Función para mostrar mensaje en pantalla temporalmente
-- ======================
local messageQueue = {} -- Cola de mensajes activos

local function showMessage(msg, color, duration)
    duration = duration or 3
    local player = game:GetService("Players").LocalPlayer
    local gui = player:FindFirstChild("DiabloMessageGui")

    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "DiabloMessageGui"
        gui.ResetOnSpawn = false
        gui.Parent = player:WaitForChild("PlayerGui")
    end

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
    label.TextTransparency = 1
    table.insert(messageQueue, label)

    for i, msgLabel in ipairs(messageQueue) do
        local targetY = 100 + (i-1)*(msgLabel.Size.Y.Offset + 5)
        msgLabel:TweenPosition(UDim2.new(0.5, 0, 0, targetY), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    end

    for i = 0, 1, 0.1 do
        task.wait(0.02)
        label.TextTransparency = 1 - i
    end

    task.delay(duration, function()
        for i = 0, 1, 0.1 do
            task.wait(0.02)
            label.TextTransparency = i
        end

        for i, v in ipairs(messageQueue) do
            if v == label then
                table.remove(messageQueue, i)
                break
            end
        end
        label:Destroy()

        for i, msgLabel in ipairs(messageQueue) do
            local targetY = 100 + (i-1)*(msgLabel.Size.Y.Offset + 5)
            msgLabel:TweenPosition(UDim2.new(0.5, 0, 0, targetY), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
    end)
end

-- ======================
-- Función Init expuesta
-- ======================
local function init(loadModule, version)
    print("Init.lua recibido versión:", version) -- depuración
    showMessage("✅ Licencia válida. Cargando módulos... " .. (version or ""), Color3.fromRGB(0,200,0), 2)

    local menu = loadModule("modules/ui/menu.lua")
    if menu and menu.init then
        print("Inicializando menu.lua con versión:", version) -- depuración
        menu.init(loadModule, version)
        showMessage("✅ Menú cargado correctamente", Color3.fromRGB(0,200,0), 2)
    else
        warn("El menú no se pudo inicializar")
        showMessage("⚠ El menú no se pudo inicializar", Color3.fromRGB(255,100,0), 3)
    end
end

-- ======================
-- Exportar init
-- ======================
return {
    init = init
}
