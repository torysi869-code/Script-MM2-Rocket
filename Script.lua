--[[
    ROCKET MM2 CHIT v1.1 (Adaptive)
    Адаптирован под ПК и мобильные устройства.
    Все размеры и позиции заданы через Scale (UDim2).
    Дата: 20.05.2026
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Создание основного GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RocketWayGUI"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

-- Кнопка открытия/закрытия окна (увеличена для пальцев)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 70, 0, 70)   -- фиксированный размер, но можно и Scale, но для кнопки лучше Offset для чёткости
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://86784400948439"
toggleBtn.Parent = screenGui

-- Основное окно (адаптивное)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.8, 0, 0.7, 0)   -- 80% ширины, 70% высоты
mainFrame.Position = UDim2.new(0.1, 0, 0.15, 0) -- центрировано по горизонтали, с отступом сверху
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ROCKET MM2"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

-- Кнопка закрытия окна
local closeBtn = Instance.new("ImageButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.Image = "rbxassetid://1537999474"
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Панель вкладок
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabAmbient = Instance.new("TextButton")
tabAmbient.Size = UDim2.new(0.5, 0, 1, 0)
tabAmbient.Text = "Ambient"
tabAmbient.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
tabAmbient.BorderSizePixel = 0
tabAmbient.TextColor3 = Color3.new(1, 1, 1)
tabAmbient.Font = Enum.Font.GothamMedium
tabAmbient.Parent = tabFrame

local tabEsp = Instance.new("TextButton")
tabEsp.Size = UDim2.new(0.5, 0, 1, 0)
tabEsp.Position = UDim2.new(0.5, 0, 0, 0)
tabEsp.Text = "Esp"
tabEsp.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
tabEsp.BorderSizePixel = 0
tabEsp.TextColor3 = Color3.new(1, 1, 1)
tabEsp.Font = Enum.Font.GothamMedium
tabEsp.Parent = tabFrame

-- Контейнеры вкладок (занимают оставшееся место)
local ambientFrame = Instance.new("Frame")
ambientFrame.Size = UDim2.new(1, 0, 1, -80)   -- вычитаем заголовок и панель вкладок
ambientFrame.Position = UDim2.new(0, 0, 0, 80)
ambientFrame.BackgroundTransparency = 1
ambientFrame.Parent = mainFrame
ambientFrame.Visible = true

local espFrame = Instance.new("Frame")
espFrame.Size = UDim2.new(1, 0, 1, -80)
espFrame.Position = UDim2.new(0, 0, 0, 80)
espFrame.BackgroundTransparency = 1
espFrame.Parent = mainFrame
espFrame.Visible = false

-- Переключение вкладок
tabAmbient.MouseButton1Click:Connect(function()
    ambientFrame.Visible = true
    espFrame.Visible = false
end)
tabEsp.MouseButton1Click:Connect(function()
    ambientFrame.Visible = false
    espFrame.Visible = true
end)

--------------------------------------------------------------------------------
-- Вкладка Ambient
--------------------------------------------------------------------------------
-- Раздел Sheriff
local sheriffSection = Instance.new("Frame")
sheriffSection.Size = UDim2.new(1, 0, 0, 80)  -- высота чуть больше для удобства
sheriffSection.Position = UDim2.new(0, 0, 0, 5)
sheriffSection.BackgroundTransparency = 1
sheriffSection.Parent = ambientFrame

local sheriffLabel = Instance.new("TextLabel")
sheriffLabel.Size = UDim2.new(0.8, 0, 0, 25)
sheriffLabel.Position = UDim2.new(0, 10, 0, 0)
sheriffLabel.Text = "Sheriff"
sheriffLabel.TextColor3 = Color3.new(1, 1, 1)
sheriffLabel.BackgroundTransparency = 1
sheriffLabel.TextXAlignment = Enum.TextXAlignment.Left
sheriffLabel.Font = Enum.Font.GothamBold
sheriffLabel.TextScaled = true
sheriffLabel.Parent = sheriffSection

-- Переключатель "Наводить камеру на убийцу"
local camToggleLabel = Instance.new("TextLabel")
camToggleLabel.Size = UDim2.new(0.7, 0, 0, 25)
camToggleLabel.Position = UDim2.new(0, 10, 0, 30)
camToggleLabel.Text = "Наводить камеру на убийцу"
camToggleLabel.TextColor3 = Color3.new(1, 1, 1)
camToggleLabel.BackgroundTransparency = 1
camToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
camToggleLabel.Font = Enum.Font.GothamMedium
camToggleLabel.TextScaled = true
camToggleLabel.Parent = sheriffSection

local camToggle = Instance.new("ImageButton")
camToggle.Size = UDim2.new(0, 50, 0, 30)   -- увеличен для мобильных
camToggle.Position = UDim2.new(0.8, 0, 0, 30)
camToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
camToggle.BorderSizePixel = 0
camToggle.Parent = sheriffSection
local camToggleState = false
camToggle.MouseButton1Click:Connect(function()
    camToggleState = not camToggleState
    camToggle.BackgroundColor3 = camToggleState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
    if camToggleState then
        startAimCamera()
    else
        stopAimCamera()
    end
end)

-- Раздел Кнопки
local buttonsSection = Instance.new("Frame")
buttonsSection.Size = UDim2.new(1, 0, 0, 90)
buttonsSection.Position = UDim2.new(0, 0, 0, 90)
buttonsSection.BackgroundTransparency = 1
buttonsSection.Parent = ambientFrame

local buttonsLabel = Instance.new("TextLabel")
buttonsLabel.Size = UDim2.new(0.8, 0, 0, 25)
buttonsLabel.Position = UDim2.new(0, 10, 0, 0)
buttonsLabel.Text = "Кнопки"
buttonsLabel.TextColor3 = Color3.new(1, 1, 1)
buttonsLabel.BackgroundTransparency = 1
buttonsLabel.TextXAlignment = Enum.TextXAlignment.Left
buttonsLabel.Font = Enum.Font.GothamBold
buttonsLabel.TextScaled = true
buttonsLabel.Parent = buttonsSection

-- Переключатель "Кнопка выстрела в убийцу"
local shootToggleLabel = Instance.new("TextLabel")
shootToggleLabel.Size = UDim2.new(0.7, 0, 0, 25)
shootToggleLabel.Position = UDim2.new(0, 10, 0, 30)
shootToggleLabel.Text = "Кнопка выстрела в убийцу"
shootToggleLabel.TextColor3 = Color3.new(1, 1, 1)
shootToggleLabel.BackgroundTransparency = 1
shootToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
shootToggleLabel.Font = Enum.Font.GothamMedium
shootToggleLabel.TextScaled = true
shootToggleLabel.Parent = buttonsSection

local shootToggle = Instance.new("ImageButton")
shootToggle.Size = UDim2.new(0, 50, 0, 30)
shootToggle.Position = UDim2.new(0.8, 0, 0, 30)
shootToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
shootToggle.BorderSizePixel = 0
shootToggle.Parent = buttonsSection
local shootToggleState = false
shootToggle.MouseButton1Click:Connect(function()
    shootToggleState = not shootToggleState
    shootToggle.BackgroundColor3 = shootToggleState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
    if shootToggleState then
        showShootButton()
    else
        hideShootButton()
    end
end)

-- Сама кнопка выстрела (крупная, внизу по центру)
local shootButton = Instance.new("ImageButton")
shootButton.Size = UDim2.new(0, 100, 0, 100)   -- удобно для тапа
shootButton.Position = UDim2.new(0.5, -50, 0.85, -50) -- центрирование
shootButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
shootButton.Image = "rbxassetid://1537999474"
shootButton.Text = "🔫"
shootButton.TextScaled = true
shootButton.TextColor3 = Color3.new(1, 1, 1)
shootButton.Visible = false
shootButton.Parent = screenGui
shootButton.MouseButton1Click:Connect(function()
    shootMurderer()
end)

function showShootButton()
    shootButton.Visible = true
end
function hideShootButton()
    shootButton.Visible = false
end

--------------------------------------------------------------------------------
-- Вкладка Esp (аналогично адаптируем)
--------------------------------------------------------------------------------
local espSection = Instance.new("Frame")
espSection.Size = UDim2.new(1, 0, 0, 200)  -- увеличим для размещения 4 переключателей
espSection.Position = UDim2.new(0, 0, 0, 5)
espSection.BackgroundTransparency = 1
espSection.Parent = espFrame

local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0.8, 0, 0, 25)
espLabel.Position = UDim2.new(0, 10, 0, 0)
espLabel.Text = "Esp"
espLabel.TextColor3 = Color3.new(1, 1, 1)
espLabel.BackgroundTransparency = 1
espLabel.TextXAlignment = Enum.TextXAlignment.Left
espLabel.Font = Enum.Font.GothamBold
espLabel.TextScaled = true
espLabel.Parent = espSection

local roles = {
    {name = "Мирные", color = Color3.fromRGB(0, 255, 0), key = "innocent"},
    {name = "Герой", color = Color3.fromRGB(255, 255, 0), key = "hero"},
    {name = "Шериф", color = Color3.fromRGB(0, 0, 255), key = "sheriff"},
    {name = "Убийца", color = Color3.fromRGB(255, 0, 0), key = "murderer"}
}
local espToggles = {}
local yOffset = 30
for i, role in ipairs(roles) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 25)
    label.Position = UDim2.new(0, 10, 0, yOffset + (i-1)*30)
    label.Text = "Отображать " .. role.name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamMedium
    label.TextScaled = true
    label.Parent = espSection

    local toggle = Instance.new("ImageButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(0.8, 0, 0, yOffset + (i-1)*30)
    toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggle.BorderSizePixel = 0
    toggle.Parent = espSection
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
        espToggles[role.key] = state
        updateESP()
    end)
    espToggles[role.key] = false
end

-- Раздел Другое
local otherSection = Instance.new("Frame")
otherSection.Size = UDim2.new(1, 0, 0, 70)
otherSection.Position = UDim2.new(0, 0, 0, 210)
otherSection.BackgroundTransparency = 1
otherSection.Parent = espFrame

local otherLabel = Instance.new("TextLabel")
otherLabel.Size = UDim2.new(0.8, 0, 0, 25)
otherLabel.Position = UDim2.new(0, 10, 0, 0)
otherLabel.Text = "Другое"
otherLabel.TextColor3 = Color3.new(1, 1, 1)
otherLabel.BackgroundTransparency = 1
otherLabel.TextXAlignment = Enum.TextXAlignment.Left
otherLabel.Font = Enum.Font.GothamBold
otherLabel.TextScaled = true
otherLabel.Parent = otherSection

-- Переключатель "Отображать расстояние"
local distToggleLabel = Instance.new("TextLabel")
distToggleLabel.Size = UDim2.new(0.7, 0, 0, 25)
distToggleLabel.Position = UDim2.new(0, 10, 0, 30)
distToggleLabel.Text = "Отображать расстояние"
distToggleLabel.TextColor3 = Color3.new(1, 1, 1)
distToggleLabel.BackgroundTransparency = 1
distToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
distToggleLabel.Font = Enum.Font.GothamMedium
distToggleLabel.TextScaled = true
distToggleLabel.Parent = otherSection

local distToggle = Instance.new("ImageButton")
distToggle.Size = UDim2.new(0, 50, 0, 25)
distToggle.Position = UDim2.new(0.8, 0, 0, 30)
distToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
distToggle.BorderSizePixel = 0
distToggle.Parent = otherSection
local distToggleState = false
distToggle.MouseButton1Click:Connect(function()
    distToggleState = not distToggleState
    distToggle.BackgroundColor3 = distToggleState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
    updateDistance()
end)

--------------------------------------------------------------------------------
-- Глобальные хранилища для ESP и расстояний
--------------------------------------------------------------------------------
local highlights = {}
local distanceLabels = {}

function getPlayerRole(plr)
    local char = plr.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local name = tool.Name:lower()
            if name:find("knife") or name:find("нож") or name:find("murder") then
                return "murderer"
            elseif name:find("gun") or name:find("pistol") or name:find("пистолет") then
                return "sheriff"
            elseif name:find("hero") then
                return "hero"
            end
        end
        local backpack = plr:FindFirstChild("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = tool.Name:lower()
                    if name:find("knife") or name:find("нож") or name:find("murder") then
                        return "murderer"
                    elseif name:find("gun") or name:find("pistol") or name:find("пистолет") then
                        return "sheriff"
                    elseif name:find("hero") then
                        return "hero"
                    end
                end
            end
        end
    end
    return "innocent"
end

function getColorForRole(role)
    if role == "innocent" then return Color3.fromRGB(0, 255, 0)
    elseif role == "hero" then return Color3.fromRGB(255, 255, 0)
    elseif role == "sheriff" then return Color3.fromRGB(0, 0, 255)
    elseif role == "murderer" then return Color3.fromRGB(255, 0, 0)
    else return Color3.new(1, 1, 1) end
end

function updateESP()
    for plr, hl in pairs(highlights) do
        if hl and hl.Parent then hl:Destroy() end
    end
    highlights = {}
    local anyEnabled = false
    for _, v in pairs(espToggles) do if v then anyEnabled = true; break end end
    if not anyEnabled then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local role = getPlayerRole(plr)
            if espToggles[role] then
                local char = plr.Character
                if char then
                    local hl = Instance.new("Highlight")
                    hl.Parent = char
                    hl.FillColor = getColorForRole(role)
                    hl.FillTransparency = 0.4
                    hl.OutlineTransparency = 0
                    hl.OutlineColor = getColorForRole(role)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlights[plr] = hl
                end
            end
        end
    end
end

function updateDistance()
    for plr, bill in pairs(distanceLabels) do
        if bill and bill.Parent then bill:Destroy() end
    end
    distanceLabels = {}
    if not distToggleState then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and char:FindFirstChild("Head") then
                local role = getPlayerRole(plr)
                local color = getColorForRole(role)

                local bill = Instance.new("BillboardGui")
                bill.Size = UDim2.new(0, 150, 0, 40)  -- немного больше
                bill.Adornee = char.Head
                bill.AlwaysOnTop = true
                bill.Parent = char.Head

                local text = Instance.new("TextLabel")
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.TextColor3 = color
                text.TextStrokeTransparency = 0
                text.TextScaled = true
                text.Font = Enum.Font.GothamBold
                text.Text = "0"
                text.Parent = bill

                distanceLabels[plr] = bill
            end
        end
    end
end

function updateDistanceTexts()
    if not distToggleState then return end
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("Head") then return end
    local myPos = myChar.Head.Position

    for plr, bill in pairs(distanceLabels) do
        if bill and bill.Parent then
            local char = plr.Character
            if char and char:FindFirstChild("Head") then
                local dist = (char.Head.Position - myPos).Magnitude
                local text = bill:FindFirstChildOfClass("TextLabel")
                if text then
                    text.Text = string.format("%.1f м", dist)
                end
            else
                bill:Destroy()
                distanceLabels[plr] = nil
            end
        end
    end
end

-- Функции камеры
local aimConnection = nil

function startAimCamera()
    if aimConnection then aimConnection:Disconnect() end
    aimConnection = RunService.RenderStepped:Connect(function()
        local murdererChar = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and getPlayerRole(plr) == "murderer" then
                local char = plr.Character
                if char and char:FindFirstChild("Head") then
                    murdererChar = char
                    break
                end
            end
        end
        if murdererChar then
            local head = murdererChar.Head
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)
        end
    end)
end

function stopAimCamera()
    if aimConnection then
        aimConnection:Disconnect()
        aimConnection = nil
    end
end

-- Выстрел в убийцу
function shootMurderer()
    if getPlayerRole(player) ~= "sheriff" then
        showNotification("Ты не шериф!", Color3.fromRGB(255, 0, 0))
        return
    end
    local char = player.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or not (tool.Name:lower():find("gun") or tool.Name:lower():find("pistol") or tool.Name:lower():find("пистолет")) then
        showNotification("Пистолет не в руке!", Color3.fromRGB(255, 0, 0))
        return
    end

    local murdererChar = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and getPlayerRole(plr) == "murderer" then
            local c = plr.Character
            if c and c:FindFirstChild("Head") then
                murdererChar = c
                break
            end
        end
    end
    if not murdererChar then
        showNotification("Убийца не найден!", Color3.fromRGB(255, 0, 0))
        return
    end

    local cam = workspace.CurrentCamera
    local headPos = murdererChar.Head.Position
    cam.CFrame = CFrame.new(cam.CFrame.Position, headPos)

    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false)

    showNotification("Выстрел в убийцу!", Color3.fromRGB(0, 255, 0))
end

function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0.6, 0, 0.1, 0)   -- адаптивно
    notif.Position = UDim2.new(0.2, 0, 0.45, 0)
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    notif.Text = text
    notif.TextColor3 = color or Color3.new(1, 1, 1)
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    notif.Parent = screenGui
    Debris:AddItem(notif, 2)
end

--------------------------------------------------------------------------------
-- Обработчики событий
--------------------------------------------------------------------------------
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        updateESP()
        updateDistance()
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    if highlights[plr] then
        highlights[plr]:Destroy()
        highlights[plr] = nil
    end
    if distanceLabels[plr] then
        distanceLabels[plr]:Destroy()
        distanceLabels[plr] = nil
    end
end)

-- Фоновый цикл для обновления ESP и расстояний (каждые 2 секунды)
task.spawn(function()
    while true do
        task.wait(2)
        local any = false
        for _, v in pairs(espToggles) do if v then any = true; break end end
        if any then updateESP() end
        updateDistanceTexts()
    end
end)

-- Открытие/закрытие главного окна по кнопке
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Инициализация при старте
task.wait(0.5)
updateESP()
updateDistance()

print("ROCKET MM2 CHIT v1.1 (Adaptive) загружен. Работает на ПК и мобильных устройствах.")
