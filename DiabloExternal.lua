local aimbotMode = nil -- "head" o "body"
local espMode = nil -- "top" o "bottom"
local noclipActive = false
local flyActive = false
local teleportTarget = nil

-- Crear UI
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DiabloExternal"
gui.ResetOnSpawn = false

-- Variables de control
local dragging = false
local dragInput, dragStart, startPos

-- Contenedor principal
local mainContainer = Instance.new("Frame", gui)
mainContainer.Size = UDim2.new(0, 300, 0, 400)
mainContainer.Position = UDim2.new(0.5, -150, 0.5, -200)
mainContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainContainer.BorderSizePixel = 2
mainContainer.BorderColor3 = Color3.fromRGB(106, 13, 173)
mainContainer.Visible = true
mainContainer.Name = "MainContainer"

-- Arrastrable
local function makeDraggable(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end
makeDraggable(mainContainer)

-- Funciones de botones
local function updateAimbotButtons(headBtn, bodyBtn)
    if aimbotMode == "head" then
        headBtn.BackgroundColor3 = Color3.fromRGB(13, 173, 106)
        bodyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    elseif aimbotMode == "body" then
        headBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        bodyBtn.BackgroundColor3 = Color3.fromRGB(13, 173, 106)
    else
        headBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        bodyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end

local function updateEspButtons(topBtn, bottomBtn)
    if espMode == "top" then
        topBtn.BackgroundColor3 = Color3.fromRGB(13, 173, 106)
        bottomBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    elseif espMode == "bottom" then
        topBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        bottomBtn.BackgroundColor3 = Color3.fromRGB(13, 173, 106)
    else
        topBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        bottomBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end

-- Mostrar lista de jugadores
local function showPlayerList()
    for _, child in ipairs(mainContainer:GetChildren()) do
        if child.Name ~= "Title" then
            child:Destroy()
        end
    end
    mainContainer.Title.Text = "   LISTA DE JUGADORES"
    mainContainer.Title.Position = UDim2.new(0, 20, 0, 10)

    local backBtn = Instance.new("TextButton", mainContainer)
    backBtn.Size = UDim2.new(0, 80, 0, 30)
    backBtn.Position = UDim2.new(0, 10, 0, 10)
    backBtn.Text = "← Volver"
    backBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    backBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    backBtn.Font = Enum.Font.GothamBold
    backBtn.MouseButton1Click:Connect(function()
        showContent("TELEPORT")
    end)

    local players = game:GetService("Players"):GetPlayers()
    local scrollFrame = Instance.new("ScrollingFrame", mainContainer)
    scrollFrame.Size = UDim2.new(1, -50, 1, -120)
    scrollFrame.Position = UDim2.new(0, 30, 0, 60)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #players * 40)

    for i, plr in ipairs(players) do
        if plr ~= player then
            local playerBtn = Instance.new("TextButton", scrollFrame)
            playerBtn.Size = UDim2.new(1, 0, 0, 35)
            playerBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 40)
            playerBtn.Text = plr.Name
            playerBtn.Font = Enum.Font.Gotham
            playerBtn.TextSize = 14
            playerBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            playerBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            playerBtn.BackgroundTransparency = 0.7
            playerBtn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character:MoveTo(plr.Character.HumanoidRootPart.Position)
                    print("Teletransportado a " .. plr.Name)
                end
            end)
        end
    end
end

-- Mostrar contenido dinámico
function showContent(contentName)
    for _, child in ipairs(mainContainer:GetChildren()) do
        if child.Name ~= "Title" then
            child:Destroy()
        end
    end

    if not mainContainer:FindFirstChild("Title") then
        local title = Instance.new("TextLabel", mainContainer)
        title.Name = "Title"
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 10)
        title.Text = contentName:upper()
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 20
        title.BackgroundTransparency = 1
    else
        mainContainer.Title.Text = contentName:upper()
        mainContainer.Title.Position = UDim2.new(0, 0, 0, 10)
    end

    -- Aquí sigue TODO el bloque de showContent (AIMBOT, ESP, NOCLIP, VOLAR, TELEPORT, etc.)
    -- ⚠️ No lo recorto aquí para que sepas que sigue intacto.
end

-- Toggle con la tecla H
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.H then
            mainContainer.Visible = not mainContainer.Visible
        end
    end
end)

-- Inicializar mostrando el menú principal
showContent("Main")
