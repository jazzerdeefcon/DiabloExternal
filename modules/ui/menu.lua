-- modules/ui/menu.lua
-- Menu principal de DiabloExternal

local menu = {}

function menu.init(core)
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

    -- Logo circular
    local logo = Instance.new("ImageLabel", mainFrame)
    logo.Size = UDim2.new(0, 80, 0, 80)
    logo.Position = UDim2.new(0.5, -40, 0, 20)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://120947319794902"
    logo.ScaleType = Enum.ScaleType.Fit

    -- Título del menú
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 0, 30)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "Diablo External"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansBold
    title.TextXAlignment = Enum.TextXAlignment.Left
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

    -- ===== Función auxiliar para crear botones =====
    local function createButton(name, yOffset, modulePath)
        local btnWidth, btnHeight = 120, 30
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
        btn.Position = UDim2.new(0, (mainFrame.Size.X.Offset - btnWidth)/2, 0, yOffset)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.Parent = mainFrame

        btn.MouseButton1Click:Connect(function()
            local mod = core.loadModule(modulePath)
            if mod and mod.init then
                mod.init()
            else
                warn("No se pudo cargar el módulo: " .. modulePath)
            end
        end)
    end

    -- ===== Crear botones =====
    local startY = logo.Position.Y.Offset + logo.Size.Y.Offset + 20
    local spacing = 40
    createButton("Aimbot", startY + spacing * 0, "modules/handlers/aimbot.lua")
    createButton("ESP", startY + spacing * 1, "modules/handlers/esp.lua")
    createButton("Noclip", startY + spacing * 2, "modules/handlers/noclip.lua")
    createButton("Velocidad", startY + spacing * 3, "modules/handlers/speed.lua")
    createButton("Teleport", startY + spacing * 4, "modules/handlers/teleport.lua")
    createButton("Volar", startY + spacing * 5, "modules/handlers/fly.lua")
end

return menu
