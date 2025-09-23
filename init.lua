local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "D3fc0n"
gui.ResetOnSpawn = false

-- Crear Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0.5, -100, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = gui

-- Label para mostrar mensajes
local msgLabel = Instance.new("TextLabel")
msgLabel.Size = UDim2.new(1, -20, 0, 30)
msgLabel.Position = UDim2.new(0, 10, 0, 140) -- debajo de los botones
msgLabel.BackgroundTransparency = 1
msgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
msgLabel.TextScaled = true
msgLabel.Text = ""
msgLabel.Parent = frame

-- Función para crear botones
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(3, 182, 252)
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
end

-- Módulos embebidos directamente
local Button1 = {}
function Button1:Run()
    msgLabel.Text = "Este es el archivo que lanza el Botón 1"
end

local Button2 = {}
function Button2:Run()
    msgLabel.Text = "Este es el archivo que lanza el Botón 2"
end

local Button3 = {}
function Button3:Run()
    msgLabel.Text = "Este es el archivo que lanza el Botón 3"
end

-- Crear botones principales
createButton("Botón 1", 10, function() Button1:Run() end)
createButton("Botón 2", 50, function() Button2:Run() end)
createButton("Botón 3", 90, function() Button3:Run() end)

-- Botón cerrar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5) -- esquina superior derecha
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy() -- cierra todo el menú
end)
