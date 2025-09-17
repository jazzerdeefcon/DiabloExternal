--// Gui principal
local gui = Instance.new("ScreenGui")
gui.Name = "DiabloExternal"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 520)
frame.Position = UDim2.new(0.5, -200, 0.5, -260)
frame.BackgroundTransparency = 1 -- transparente
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Contenedor principal
local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(1, 0, 1, 0)
mainContainer.Position = UDim2.new(0, 0, 0, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Visible = true
mainContainer.Parent = frame

-- Título dinámico
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Diablo External"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = mainContainer

-- Contenido dinámico
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainContainer

-- Función para limpiar y mostrar botones
local function clearContent()
    for _, child in ipairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
end

local function createButton(text, callback, order)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, (order - 1) * 50 + 10)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = contentFrame
    button.MouseButton1Click:Connect(callback)
end

-- Función para mostrar contenido
function showContent(menu)
    clearContent()
    title.Text = menu

    if menu == "Main" then
        createButton("AIMBOT", function() showContent("Aimbot") end, 1)
        createButton("ESP", function() showContent("ESP") end, 2)
        createButton("NOCLIP", function() showContent("Noclip") end, 3)
        createButton("CLOSE", function() gui:Destroy() end, 4)
    elseif menu == "Aimbot" then
        createButton("Regresar", function() showContent("Main") end, 1)
    elseif menu == "ESP" then
        createButton("Regresar", function() showContent("Main") end, 1)
    elseif menu == "Noclip" then
        createButton("Regresar", function() showContent("Main") end, 1)
    end
end

-- Inicializar mostrando el menú principal
showContent("Main")

-- Toggle con tecla H
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.H then
            mainContainer.Visible = not mainContainer.Visible
        end
    end
end)
