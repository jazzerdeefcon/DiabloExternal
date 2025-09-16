--  licenciaValida = "123"

local aimbotMode = nil -- "head" o "body"
local espMode = nil -- "top" o "bottom"
local noclipActive = false -- Variable para controlar el estado del noclip
local flyActive = false -- Variable para controlar el estado del vuelo
local teleportTarget = nil -- Variable para controlar el objetivo de teleport

-- Crear UI
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DiabloExternal"
gui.ResetOnSpawn = false

-- Variables para control
local currentContent = nil
local dragging = false
local dragInput, dragStart, startPos

-- Crear el contenedor principal (único)
local mainContainer = Instance.new("Frame", gui)
mainContainer.Size = UDim2.new(0, 300, 0, 400)
mainContainer.Position = UDim2.new(0.5, -150, 0.5, -200)
mainContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainContainer.BorderSizePixel = 2
mainContainer.BorderColor3 = Color3.fromRGB(106, 13, 173)
mainContainer.Visible = true
mainContainer.Name = "MainContainer"

-- Función para hacer arrastrable el menú
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
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(mainContainer)

-- Función para actualizar el estado de los botones de aimbot
local function updateAimbotButtons(headBtn, bodyBtn)
    if aimbotMode == "head" then
        headBtn.BackgroundColor3 = Color3.fromRGB(13, 173, 106) -- Verde cuando está activo
        bodyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Rojo cuando está inactivo
    elseif aimbotMode == "body" then
        headBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Rojo cuando está inactivo
        bodyBtn.BackgroundColor3 = Color3.fromRGB(13, 173, 106) -- Verde cuando está activo
    else
        headBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Rojo cuando está inactivo
        bodyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Rojo cuando está inactivo
    end
end

-- Función para actualizar el estado de los botones de ESP
local function updateEspButtons(topBtn, bottomBtn)
    if espMode == "top" then
        topBtn.BackgroundColor3 = Color3.fromRGB(13, 173, 106) -- Verde cuando está activo
        bottomBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Rojo cuando está inactivo
    elseif espMode == "bottom" then
        topBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Rojo cuando está inactivo
        bottomBtn.BackgroundColor3 = Color3.fromRGB(13, 173, 106) -- Verde cuando está activo
    else
        topBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Rojo cuando está inactivo
        bottomBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Rojo cuando está inactivo
    end
end

-- Función para mostrar la lista de jugadores (VERSIÓN CORREGIDA)
local function showPlayerList()
    -- Limpiar el contenedor
    for _, child in ipairs(mainContainer:GetChildren()) do
        if child.Name ~= "Title" then
            child:Destroy()
        end
    end

    -- Título (movido a la derecha)
    mainContainer.Title.Text = "   LISTA DE JUGADORES" -- Espacios añadidos para moverlo a la derecha
    mainContainer.Title.Position = UDim2.new(0, 20, 0, 10) -- Posición ajustada

    -- Botón de volver (FUNCIONAL)
    local backBtn = Instance.new("TextButton", mainContainer)
    backBtn.Size = UDim2.new(0, 80, 0, 30)
    backBtn.Position = UDim2.new(0, 10, 0, 10)
    backBtn.Text = "← Volver"
    backBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
    backBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
    backBtn.Font = Enum.Font.GothamBold
    
    backBtn.MouseButton1Click:Connect(function()
        showContent("TELEPORT") -- Ahora redirige correctamente
    end)

    -- Lista de jugadores (AJUSTADA PARA NO TAPAR EL BOTÓN)
    local players = game:GetService("Players"):GetPlayers()
    local scrollFrame = Instance.new("ScrollingFrame", mainContainer)
    scrollFrame.Size = UDim2.new(1, -50, 1, -120) -- Ajustado el ancho
    scrollFrame.Position = UDim2.new(0, 30, 0, 60) -- Movido a la derecha
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #players * 40)

    for i, plr in ipairs(players) do
        if plr ~= player then
            local playerBtn = Instance.new("TextButton", scrollFrame)
            playerBtn.Size = UDim2.new(1, 0, 0, 35)
            playerBtn.Position = UDim2.new(0, 0, 0, (i-1)*40)
            playerBtn.Text = plr.Name
            playerBtn.Font = Enum.Font.Gotham
            playerBtn.TextSize = 14
            playerBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
            playerBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
            playerBtn.BackgroundTransparency = 0.7
            
            playerBtn.MouseButton1Click:Connect(function()
                -- Teleportar al jugador
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character:MoveTo(plr.Character.HumanoidRootPart.Position)
                    print("Teletransportado a "..plr.Name)
                end
            end)
        end
    end
end

-- Función para mostrar contenido
local function showContent(contentName)
    -- Limpiar el contenedor
    for _, child in ipairs(mainContainer:GetChildren()) do
        if child.Name ~= "Title" then
            child:Destroy()
        end
    end

    -- Título (lo creamos una sola vez)
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
        mainContainer.Title.Position = UDim2.new(0, 0, 0, 10) -- Restablecer posición por defecto
    end

    -- Contenido específico
    if contentName == "Main" then
        -- Botones principales
        local buttons = {
            {"AIMBOT", 0},
            {"ESP", 50},
            {"NOCLIP", 100},
            {"VELOCIDAD", 150},
            {"TELEPORT", 200},
            {"VOLAR", 250}
        }

        for i, buttonData in ipairs(buttons) do
            local btn = Instance.new("TextButton", mainContainer)
            btn.Size = UDim2.new(1, -40, 0, 40)
            btn.Position = UDim2.new(0, 20, 0, 60 + buttonData[2])
            btn.Text = buttonData[1]
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 16
            btn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
            btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
            
            btn.MouseButton1Click:Connect(function()
                showContent(buttonData[1])
            end)
        end
    elseif contentName == "AIMBOT" then
        -- Botón de volver
        local backBtn = Instance.new("TextButton", mainContainer)
        backBtn.Size = UDim2.new(0, 80, 0, 30)
        backBtn.Position = UDim2.new(0, 10, 0, 10)
        backBtn.Text = "← Volver"
        backBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        backBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
        backBtn.Font = Enum.Font.GothamBold
        
        backBtn.MouseButton1Click:Connect(function()
            showContent("Main")
        end)

        -- Botón Aimbot a la cabeza
        local headBtn = Instance.new("TextButton", mainContainer)
        headBtn.Size = UDim2.new(1, -40, 0, 40)
        headBtn.Position = UDim2.new(0, 20, 0, 100)
        headBtn.Text = "AIMBOT A LA CABEZA"
        headBtn.Font = Enum.Font.GothamBold
        headBtn.TextSize = 16
        headBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        headBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
        headBtn.Name = "HeadBtn"
        
        -- Botón Aimbot al cuerpo
        local bodyBtn = Instance.new("TextButton", mainContainer)
        bodyBtn.Size = UDim2.new(1, -40, 0, 40)
        bodyBtn.Position = UDim2.new(0, 20, 0, 160)
        bodyBtn.Text = "AIMBOT AL CUERPO"
        bodyBtn.Font = Enum.Font.GothamBold
        bodyBtn.TextSize = 16
        bodyBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        bodyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
        bodyBtn.Name = "BodyBtn"

        -- Actualizar estado inicial de los botones
        updateAimbotButtons(headBtn, bodyBtn)

        -- Conexión de los botones
        headBtn.MouseButton1Click:Connect(function()
            if aimbotMode == "head" then
                aimbotMode = nil -- Desactivar si ya estaba activo
                print("Aimbot desactivado")
            else
                aimbotMode = "head" -- Activar aimbot a la cabeza
                print("Aimbot a la cabeza activado")
            end
            updateAimbotButtons(headBtn, bodyBtn)
        end)

        bodyBtn.MouseButton1Click:Connect(function()
            if aimbotMode == "body" then
                aimbotMode = nil -- Desactivar si ya estaba activo
                print("Aimbot desactivado")
            else
                aimbotMode = "body" -- Activar aimbot al cuerpo
                print("Aimbot al cuerpo activado")
            end
            updateAimbotButtons(headBtn, bodyBtn)
        end)

        -- Texto descriptivo
        local infoLabel = Instance.new("TextLabel", mainContainer)
        infoLabel.Size = UDim2.new(1, -40, 0, 60)
        infoLabel.Position = UDim2.new(0, 20, 0, 220)
        infoLabel.Text = "Selecciona el tipo de aimbot\n(Verde = Activado)"
        infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        infoLabel.Font = Enum.Font.Gotham
        infoLabel.TextSize = 14
        infoLabel.TextWrapped = true
        infoLabel.BackgroundTransparency = 1
    elseif contentName == "ESP" then
        -- Botón de volver
        local backBtn = Instance.new("TextButton", mainContainer)
        backBtn.Size = UDim2.new(0, 80, 0, 30)
        backBtn.Position = UDim2.new(0, 10, 0, 10)
        backBtn.Text = "← Volver"
        backBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        backBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
        backBtn.Font = Enum.Font.GothamBold
        
        backBtn.MouseButton1Click:Connect(function()
            showContent("Main")
        end)

        -- Botón ESP Arriba
        local topBtn = Instance.new("TextButton", mainContainer)
        topBtn.Size = UDim2.new(1, -40, 0, 40)
        topBtn.Position = UDim2.new(0, 20, 0, 100)
        topBtn.Text = "ESP ARRIBA"
        topBtn.Font = Enum.Font.GothamBold
        topBtn.TextSize = 16
        topBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        topBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
        topBtn.Name = "TopBtn"
        
        -- Botón ESP Abajo
        local bottomBtn = Instance.new("TextButton", mainContainer)
        bottomBtn.Size = UDim2.new(1, -40, 0, 40)
        bottomBtn.Position = UDim2.new(0, 20, 0, 160)
        bottomBtn.Text = "ESP ABAJO"
        bottomBtn.Font = Enum.Font.GothamBold
        bottomBtn.TextSize = 16
        bottomBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        bottomBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
        bottomBtn.Name = "BottomBtn"

        -- Actualizar estado inicial de los botones
        updateEspButtons(topBtn, bottomBtn)

        -- Conexión de los botones
        topBtn.MouseButton1Click:Connect(function()
            if espMode == "top" then
                espMode = nil -- Desactivar si ya estaba activo
                print("ESP desactivado")
            else
                espMode = "top" -- Activar ESP arriba
                print("ESP arriba activado")
            end
            updateEspButtons(topBtn, bottomBtn)
        end)

        bottomBtn.MouseButton1Click:Connect(function()
            if espMode == "bottom" then
                espMode = nil -- Desactivar si ya estaba activo
                print("ESP desactivado")
            else
                espMode = "bottom" -- Activar ESP abajo
                print("ESP abajo activado")
            end
            updateEspButtons(topBtn, bottomBtn)
        end)

        -- Texto descriptivo
        local infoLabel = Instance.new("TextLabel", mainContainer)
        infoLabel.Size = UDim2.new(1, -40, 0, 60)
        infoLabel.Position = UDim2.new(0, 20, 0, 220)
        infoLabel.Text = "Selecciona la posición del ESP\n(Verde = Activado)"
        infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        infoLabel.Font = Enum.Font.Gotham
        infoLabel.TextSize = 14
        infoLabel.TextWrapped = true
        infoLabel.BackgroundTransparency = 1
    elseif contentName == "NOCLIP" then
        -- Botón de volver
        local backBtn = Instance.new("TextButton", mainContainer)
        backBtn.Size = UDim2.new(0, 80, 0, 30)
        backBtn.Position = UDim2.new(0, 10, 0, 10)
        backBtn.Text = "← Volver"
        backBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        backBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
        backBtn.Font = Enum.Font.GothamBold
        
        backBtn.MouseButton1Click:Connect(function()
            showContent("Main")
        end)

        -- Botón Activar Noclip
        local noclipBtn = Instance.new("TextButton", mainContainer)
        noclipBtn.Size = UDim2.new(1, -40, 0, 40)
        noclipBtn.Position = UDim2.new(0, 20, 0, 100)
        noclipBtn.Text = "ACTIVAR NOCLIP"
        noclipBtn.Font = Enum.Font.GothamBold
        noclipBtn.TextSize = 16
        noclipBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        noclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(13, 173, 106) or Color3.fromRGB(200, 0, 0) -- Fondo rojo
        
        noclipBtn.MouseButton1Click:Connect(function()
            noclipActive = not noclipActive
            noclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(13, 173, 106) or Color3.fromRGB(200, 0, 0) -- Fondo rojo
            print("Noclip " .. (noclipActive and "activado" or "desactivado"))
        end)
    elseif contentName == "VOLAR" then
        -- Botón de volver
        local backBtn = Instance.new("TextButton", mainContainer)
        backBtn.Size = UDim2.new(0, 80, 0, 30)
        backBtn.Position = UDim2.new(0, 10, 0, 10)
        backBtn.Text = "← Volver"
        backBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        backBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
        backBtn.Font = Enum.Font.GothamBold
        
        backBtn.MouseButton1Click:Connect(function()
            showContent("Main")
        end)

        -- Botón Activar Vuelo
        local flyBtn = Instance.new("TextButton", mainContainer)
        flyBtn.Size = UDim2.new(1, -40, 0, 40)
        flyBtn.Position = UDim2.new(0, 20, 0, 100)
        flyBtn.Text = "ACTIVAR VUELO"
        flyBtn.Font = Enum.Font.GothamBold
        flyBtn.TextSize = 16
        flyBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        flyBtn.BackgroundColor3 = flyActive and Color3.fromRGB(13, 173, 106) or Color3.fromRGB(200, 0, 0) -- Fondo rojo
        
        flyBtn.MouseButton1Click:Connect(function()
            flyActive = not flyActive
            flyBtn.BackgroundColor3 = flyActive and Color3.fromRGB(13, 173, 106) or Color3.fromRGB(200, 0, 0) -- Fondo rojo
            print("Vuelo " .. (flyActive and "activado" or "desactivado"))
        end)
    elseif contentName == "TELEPORT" then
        -- Botón de volver
        local backBtn = Instance.new("TextButton", mainContainer)
        backBtn.Size = UDim2.new(0, 80, 0, 30)
        backBtn.Position = UDim2.new(0, 10, 0, 10)
        backBtn.Text = "← Volver"
        backBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        backBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
        backBtn.Font = Enum.Font.GothamBold
        
        backBtn.MouseButton1Click:Connect(function()
            showContent("Main")
        end)

        -- Botón Enemigo cercano
        local enemyBtn = Instance.new("TextButton", mainContainer)
        enemyBtn.Size = UDim2.new(1, -40, 0, 40)
        enemyBtn.Position = UDim2.new(0, 20, 0, 100)
        enemyBtn.Text = "ENEMIGO CERCANO"
        enemyBtn.Font = Enum.Font.GothamBold
        enemyBtn.TextSize = 16
        enemyBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        enemyBtn.BackgroundColor3 = (teleportTarget == "enemy" and Color3.fromRGB(13, 173, 106)) or Color3.fromRGB(200, 0, 0) -- Fondo rojo
        
        enemyBtn.MouseButton1Click:Connect(function()
            teleportTarget = "enemy"
            enemyBtn.BackgroundColor3 = Color3.fromRGB(13, 173, 106)
            print("Modo Enemigo cercano activado")
        end)

        -- Botón Lista de jugadores
        local playersBtn = Instance.new("TextButton", mainContainer)
        playersBtn.Size = UDim2.new(1, -40, 0, 40)
        playersBtn.Position = UDim2.new(0, 20, 0, 160)
        playersBtn.Text = "LISTA DE JUGADORES"
        playersBtn.Font = Enum.Font.GothamBold
        playersBtn.TextSize = 16
        playersBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        playersBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
        
        playersBtn.MouseButton1Click:Connect(function()
            showPlayerList()
        end)
    else
        -- Contenido por defecto para otras categorías
        local backBtn = Instance.new("TextButton", mainContainer)
        backBtn.Size = UDim2.new(0, 80, 0, 30)
        backBtn.Position = UDim2.new(0, 10, 0, 10)
        backBtn.Text = "← Volver"
        backBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
        backBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo
        backBtn.Font = Enum.Font.GothamBold
        
        backBtn.MouseButton1Click:Connect(function()
            showContent("Main")
        end)

        local label = Instance.new("TextLabel", mainContainer)
        label.Size = UDim2.new(1, -40, 0, 40)
        label.Position = UDim2.new(0, 20, 0, 120)
        label.Text = "CONTENIDO DE "..contentName
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.BackgroundTransparency = 1
    end
end

-- Crear página de licencia
--local licensePage = Instance.new("Frame", gui)
--licensePage.Size = UDim2.new(0, 300, 0, 200)
--licensePage.Position = UDim2.new(0.5, -150, 0.5, -100)
--licensePage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
--licensePage.BorderSizePixel = 2
--licensePage.BorderColor3 = Color3.fromRGB(106, 13, 173)
--licensePage.Visible = true

-- Contenido página de licencia
--local titulo = Instance.new("TextLabel", licensePage)
--titulo.Size = UDim2.new(1, 0, 0, 50)
--titulo.Position = UDim2.new(0, 0, 0, 0)
--titulo.Text = "👹Diablo External👹"
--titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
--titulo.Font = Enum.Font.GothamBold
--titulo.TextSize = 20
--titulo.BackgroundTransparency = 1

--local input = Instance.new("TextBox", licensePage)
--input.Size = UDim2.new(1, -40, 0, 30)
--input.Position = UDim2.new(0, 20, 0, 80)
--input.PlaceholderText = "Ingrese su licencia"
--input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
--input.TextColor3 = Color3.fromRGB(255, 255, 255)
--input.Font = Enum.Font.Gotham

--local verificarBtn = Instance.new("TextButton", licensePage)
--verificarBtn.Size = UDim2.new(1, -40, 0, 35)
--verificarBtn.Position = UDim2.new(0, 20, 0, 130)
--verificarBtn.Text = "VERIFICAR"
--verificarBtn.Font = Enum.Font.GothamBold
--verificarBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
--verificarBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Fondo rojo

-- Verificación de licencia
--verificarBtn.MouseButton1Click:Connect(function()
--    if input.Text == licenciaValida then
--        licensePage.Visible = false
--        mainContainer.Visible = true
--        showContent("Main")
--    else
--        local errorMsg = Instance.new("TextLabel", licensePage)
--        errorMsg.Text = "LICENCIA INCORRECTA"
--        errorMsg.TextColor3 = Color3.fromRGB(255, 50, 50)
--        errorMsg.Size = UDim2.new(1, -40, 0, 20)
--        errorMsg.Position = UDim2.new(0, 20, 0, 170)
--        errorMsg.Font = Enum.Font.GothamBold
--        task.delay(2, function() errorMsg:Destroy() end)
--    end
--end)

-- Control de teclado
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightShift and not licensePage.Visible then
            mainContainer.Visible = not mainContainer.Visible
        elseif input.KeyCode == Enum.KeyCode.H and not licensePage.Visible then
            mainContainer.Visible = not mainContainer.Visible
        end
    end
end)