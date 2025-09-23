function menu.init(loadModuleFunc, version)
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

    -- ===== Versión en la esquina superior izquierda =====
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(0, 80, 0, 20)
    versionLabel.Position = UDim2.new(0, 5, 0, 5) -- top-left
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = version or "v0.0"
    versionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    versionLabel.TextSize = 12
    versionLabel.Font = Enum.Font.SourceSansItalic
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.Parent = mainFrame
