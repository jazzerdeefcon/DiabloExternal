-- modules/ui/menu.lua
-- Menu principal de DiabloExternal

local menu = {}

function menu.init(core)
    local player = game:GetService("Players").LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "DiabloMenu"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Marco principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BackgroundTransparency = 0.8
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui

    -- Logo en el menu
    local logo = Instance.new("ImageLabel", mainFrame)
    logo.Size = UDim2.new(0, 80, 0, 80)                 -- tamaño del logo
    logo.Position = UDim2.new(0.5, -40, 0, 40)          -- centrado horizontal, 40px desde arriba
    --logo.BackgroundTransparency = 0.2                     -- fondo transparente
    logo.Image = "rbxassetid://130020553459788"              -- ?? reemplaza con tu assetId del logo
 

    -- Titulo
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 0, 30)
    title.Position = UDim2.new(0, 5, 0, 5)
    -- title.BackgroundTransparency = 0.2
    title.Text = "Diablo External"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = mainFrame

    -- Boton cerrar (X)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 5)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.Parent = mainFrame

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Aqui mas adelante agregaremos botones (aimbot, esp, noclip, etc.)
end

return menu