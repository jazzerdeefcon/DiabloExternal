-- modules/ui/menu.lua
-- Menu principal de DiabloExternal

local menu = {}

function menu.init(loadModuleFunc)
    local player = game:GetService("Players").LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "DiabloMenu"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Marco principal (fondo negro semitransparente)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui

    -- Bordes redondeados y borde rojo
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 10)
    uicorner.Parent = mainFrame

    local uistroke = Instance.new("UIStroke")
    uistroke.Thickness = 2
    uistroke.Color = Color3.fromRGB(255, 0, 0)
    uistroke.Parent = mainFrame

    -- Variable para controlar visibilidad
    local isVisible = true

    -- Función para alternar visibilidad
    local function toggleMenu()
        isVisible = not isVisible
        mainFrame.Visible = isVisible
    end

    -- Conexión al teclado
    local UserInputService = game:GetService("UserInputService")
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.H then
            toggleMenu()
        end
    end)

    -- Logo circular
    local logo = Instance.new("ImageLabel", mainFrame)
    logo.Size = UDim2.new(0, 80, 0, 80)
    logo.Position = UDim2.new(0.5, -40, 0, 20)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://120947319794902"
    logo.ScaleType = Enum.ScaleType.Fit

    -- Título del menú (centrado en la parte inferior)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 1, -35)
    title.BackgroundTransparency = 1
    title.Text = "Diablo External"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextTransparency = 0.4
    title.TextSize = 16
    title.Font = Enum.Font.GothamSemibold
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.Parent = mainFrame

    -- Botón cerrar (X)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 5)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = mainFrame
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

   -- ===== Función auxiliar para crear botones estilizados =====
local function createButton(name, yOffset, modulePath, parentFrame, loadFunc)
    local btnWidth, btnHeight = 240, 30

    -- Botón principal (TextButton con fondo transparente)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
    btn.Position = UDim2.new(0.5, -btnWidth/2, 0, yOffset)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255) -- texto blanco
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.BackgroundTransparency = 1 -- fondo transparente
    btn.BorderSizePixel = 0
    btn.Parent = parentFrame

    -- Frame hijo para el fondo y efectos
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    bg.BorderSizePixel = 0
    bg.Parent = btn

    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = bg

    -- Borde rojo
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Parent = bg

    -- Degradado de fondo
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0))
    }
    gradient.Rotation = 45
    gradient.Parent = bg

    -- Efecto hover
    btn.MouseEnter:Connect(function()
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
        }
    end)

    btn.MouseLeave:Connect(function()
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0))
        }
    end)

    -- Conectar botón al módulo
    btn.MouseButton1Click:Connect(function()
        local mod = loadFunc(modulePath)
        if mod and mod.init then
            mod.init()
        else
            warn("No se pudo cargar el módulo: " .. modulePath)
        end
    end)
end


    -- ===== Crear botones debajo del logo =====
    local startY = logo.Position.Y.Offset + logo.Size.Y.Offset + 20
    local spacing = 40
    createButton("Aimbot", startY + spacing * 0, "modules/handlers/aimbot.lua", mainFrame, loadModuleFunc)
    createButton("ESP", startY + spacing * 1, "modules/handlers/esp.lua", mainFrame, loadModuleFunc)
    createButton("Noclip", startY + spacing * 2, "modules/handlers/noclip.lua", mainFrame, loadModuleFunc)
    createButton("Velocidad", startY + spacing * 3, "modules/handlers/speed.lua", mainFrame, loadModuleFunc)
    createButton("Teleport", startY + spacing * 4, "modules/handlers/teleport.lua", mainFrame, loadModuleFunc)
    createButton("Volar", startY + spacing * 5, "modules/handlers/fly.lua", mainFrame, loadModuleFunc)
end

return menu
