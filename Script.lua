--[[
    ROCKET MM2 CHIT v2.0 (Ultra Compact)
    Полная функциональность, оптимизированная структура.
    Адаптив, исправлены все ошибки.
]]

local Players, RS, UIS, VIM, Camera, Debris = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("VirtualInputManager"), workspace.CurrentCamera, game:GetService("Debris")
local player, mouse = Players.LocalPlayer, Players.LocalPlayer:GetMouse()
local gui = Instance.new("ScreenGui"); gui.Name = "RocketWayGUI"; gui.Parent = player.PlayerGui; gui.ResetOnSpawn = false

-- Вспомогательные функции создания элементов
local function new(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function newToggle(parent, posY, labelText, default, onChange)
    local frame = new("Frame", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, posY), BackgroundTransparency = 1}, parent)
    new("TextLabel", {Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), Text = labelText, TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextScaled = true}, frame)
    local btn = new("ImageButton", {Size = UDim2.new(0, 50, 0, 25), Position = UDim2.new(0.8, 0, 0, 2), BackgroundColor3 = default and Color3.fromRGB(0,255,0) or Color3.fromRGB(100,100,100), BorderSizePixel = 0}, frame)
    local state = default or false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(100,100,100)
        if onChange then onChange(state) end
    end)
    return {btn = btn, get = function() return state end}
end

-- Кнопка открытия
local toggleBtn = new("ImageButton", {Size = UDim2.new(0, 70, 0, 70), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, Image = "rbxassetid://86784400948439"}, gui)

-- Главное окно
local mainFrame = new("Frame", {Size = UDim2.new(0.8, 0, 0.7, 0), Position = UDim2.new(0.1, 0, 0.15, 0), BackgroundColor3 = Color3.fromRGB(25,25,35), BorderSizePixel = 0, Visible = false}, gui)
new("TextLabel", {Size = UDim2.new(1,0,0,40), Text = "ROCKET MM2", TextColor3 = Color3.new(1,1,1), BackgroundColor3 = Color3.fromRGB(50,50,60), Font = Enum.Font.GothamBold, TextScaled = true}, mainFrame)
local closeBtn = new("ImageButton", {Size = UDim2.new(0,35,0,35), Position = UDim2.new(1,-45,0,5), Image = "rbxassetid://1537999474", BackgroundTransparency = 1}, mainFrame)
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- Вкладки
local tabFrame = new("Frame", {Size = UDim2.new(1,0,0,40), Position = UDim2.new(0,0,0,40), BackgroundTransparency = 1}, mainFrame)
local tabAmbient = new("TextButton", {Size = UDim2.new(0.5,0,1,0), Text = "Ambient", BackgroundColor3 = Color3.fromRGB(60,60,70), BorderSizePixel = 0, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamMedium}, tabFrame)
local tabEsp = new("TextButton", {Size = UDim2.new(0.5,0,1,0), Position = UDim2.new(0.5,0,0,0), Text = "Esp", BackgroundColor3 = Color3.fromRGB(60,60,70), BorderSizePixel = 0, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamMedium}, tabFrame)

local ambientFrame = new("Frame", {Size = UDim2.new(1,0,1,-80), Position = UDim2.new(0,0,0,80), BackgroundTransparency = 1}, mainFrame)
local espFrame = new("Frame", {Size = UDim2.new(1,0,1,-80), Position = UDim2.new(0,0,0,80), BackgroundTransparency = 1}, mainFrame)
espFrame.Visible = false
tabAmbient.MouseButton1Click:Connect(function() ambientFrame.Visible = true; espFrame.Visible = false end)
tabEsp.MouseButton1Click:Connect(function() ambientFrame.Visible = false; espFrame.Visible = true end)

-- Ambient вкладка
local sheriffFrame = new("Frame", {Size = UDim2.new(1,0,0,80), Position = UDim2.new(0,0,0,5), BackgroundTransparency = 1}, ambientFrame)
new("TextLabel", {Size = UDim2.new(0.8,0,0,25), Position = UDim2.new(0,10,0,0), Text = "Sheriff", TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextScaled = true}, sheriffFrame)
local camToggleData = newToggle(sheriffFrame, 30, "Наводить камеру на убийцу", false, function(state)
    if state then startAim() else stopAim() end
end)

local buttonsFrame = new("Frame", {Size = UDim2.new(1,0,0,90), Position = UDim2.new(0,0,0,90), BackgroundTransparency = 1}, ambientFrame)
new("TextLabel", {Size = UDim2.new(0.8,0,0,25), Position = UDim2.new(0,10,0,0), Text = "Кнопки", TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextScaled = true}, buttonsFrame)
local shootToggleData = newToggle(buttonsFrame, 30, "Кнопка выстрела в убийцу", false, function(state)
    shootBtn.Visible = state
end)
local shootBtn = new("TextButton", {Size = UDim2.new(0,100,0,100), Position = UDim2.new(0.5,-50,0.85,-50), BackgroundColor3 = Color3.fromRGB(255,50,50), Text = "🔫", TextScaled = true, TextColor3 = Color3.new(1,1,1), Visible = false}, gui)
shootBtn.MouseButton1Click:Connect(function() shootMurderer() end)

-- Esp вкладка
local espSection = new("Frame", {Size = UDim2.new(1,0,0,200), Position = UDim2.new(0,0,0,5), BackgroundTransparency = 1}, espFrame)
new("TextLabel", {Size = UDim2.new(0.8,0,0,25), Position = UDim2.new(0,10,0,0), Text = "Esp", TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextScaled = true}, espSection)
local roles = {{"Мирные", Color3.fromRGB(0,255,0), "innocent"}, {"Герой", Color3.fromRGB(255,255,0), "hero"}, {"Шериф", Color3.fromRGB(0,0,255), "sheriff"}, {"Убийца", Color3.fromRGB(255,0,0), "murderer"}}
local espToggles = {}
for i, r in ipairs(roles) do
    local data = newToggle(espSection, 30 + (i-1)*30, "Отображать " .. r[1], false, function(state)
        espToggles[r[3]] = state
        updateESP()
    end)
    espToggles[r[3]] = false
end

local otherFrame = new("Frame", {Size = UDim2.new(1,0,0,70), Position = UDim2.new(0,0,0,210), BackgroundTransparency = 1}, espFrame)
new("TextLabel", {Size = UDim2.new(0.8,0,0,25), Position = UDim2.new(0,10,0,0), Text = "Другое", TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextScaled = true}, otherFrame)
local distToggleData = newToggle(otherFrame, 30, "Отображать расстояние", false, function(state)
    distToggleState = state
    updateDistances()
end)
local distToggleState = false

-- Глобальные данные
local highlights, distanceLabels = {}, {}
local aimConnection = nil

-- Определение роли
function getRole(plr)
    local char = plr.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local n = tool.Name:lower()
            if n:find("knife") or n:find("нож") or n:find("murder") then return "murderer"
            elseif n:find("gun") or n:find("pistol") or n:find("пистолет") then return "sheriff"
            elseif n:find("hero") then return "hero" end
        end
        local bp = plr:FindFirstChild("Backpack")
        if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("knife") or n:find("нож") or n:find("murder") then return "murderer"
            elseif n:find("gun") or n:find("pistol") or n:find("пистолет") then return "sheriff"
            elseif n:find("hero") then return "hero" end
        end end end
    end
    return "innocent"
end

function colorForRole(r) return ({innocent=Color3.fromRGB(0,255,0), hero=Color3.fromRGB(255,255,0), sheriff=Color3.fromRGB(0,0,255), murderer=Color3.fromRGB(255,0,0)})[r] or Color3.new(1,1,1) end

function updateESP()
    for _, hl in pairs(highlights) do if hl and hl.Parent then hl:Destroy() end end
    highlights = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local role = getRole(plr)
            if espToggles[role] and plr.Character then
                local hl = Instance.new("Highlight")
                hl.Parent = plr.Character
                hl.FillColor = colorForRole(role)
                hl.FillTransparency = 0.4
                hl.OutlineTransparency = 0
                hl.OutlineColor = colorForRole(role)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlights[plr] = hl
            end
        end
    end
end

function updateDistances()
    for _, bill in pairs(distanceLabels) do if bill and bill.Parent then bill:Destroy() end end
    distanceLabels = {}
    if not distToggleState then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local role = getRole(plr)
            local bill = Instance.new("BillboardGui")
            bill.Size = UDim2.new(0,150,0,40)
            bill.Adornee = plr.Character.Head
            bill.AlwaysOnTop = true
            bill.Parent = plr.Character.Head
            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1,0,1,0)
            txt.BackgroundTransparency = 1
            txt.TextColor3 = colorForRole(role)
            txt.TextStrokeTransparency = 0
            txt.TextScaled = true
            txt.Font = Enum.Font.GothamBold
            txt.Text = "0"
            txt.Parent = bill
            distanceLabels[plr] = bill
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
                local txt = bill:FindFirstChildOfClass("TextLabel")
                if txt then txt.Text = string.format("%.1f м", dist) end
            else
                bill:Destroy(); distanceLabels[plr] = nil
            end
        end
    end
end

-- Камера
function startAim()
    if aimConnection then aimConnection:Disconnect() end
    aimConnection = RS.RenderStepped:Connect(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and getRole(plr) == "murderer" and plr.Character and plr.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, plr.Character.Head.Position)
                break
            end
        end
    end)
end
function stopAim() if aimConnection then aimConnection:Disconnect(); aimConnection = nil end end

-- Выстрел
function shootMurderer()
    if getRole(player) ~= "sheriff" then return showNotif("Ты не шериф!", Color3.fromRGB(255,0,0)) end
    local char = player.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or not (tool.Name:lower():find("gun") or tool.Name:lower():find("pistol") or tool.Name:lower():find("пистолет")) then
        return showNotif("Пистолет не в руке!", Color3.fromRGB(255,0,0))
    end
    local target = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and getRole(plr) == "murderer" and plr.Character and plr.Character:FindFirstChild("Head") then
            target = plr.Character; break
        end
    end
    if not target then return showNotif("Убийца не найден!", Color3.fromRGB(255,0,0)) end
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Head.Position)
    VIM:SendMouseButtonEvent(0,0,0,true); task.wait(0.05); VIM:SendMouseButtonEvent(0,0,0,false)
    showNotif("Выстрел в убийцу!", Color3.fromRGB(0,255,0))
end

function showNotif(text, color)
    local n = Instance.new("TextLabel")
    n.Size = UDim2.new(0.6,0,0.1,0); n.Position = UDim2.new(0.2,0,0.45,0)
    n.BackgroundColor3 = Color3.fromRGB(20,20,30); n.Text = text; n.TextColor3 = color or Color3.new(1,1,1)
    n.TextScaled = true; n.Font = Enum.Font.GothamBold; n.BorderSizePixel = 0; n.Parent = gui
    Debris:AddItem(n, 2)
end

-- События игроков
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() updateESP(); updateDistances() end)
end)
Players.PlayerRemoving:Connect(function(plr)
    if highlights[plr] then highlights[plr]:Destroy(); highlights[plr] = nil end
    if distanceLabels[plr] then distanceLabels[plr]:Destroy(); distanceLabels[plr] = nil end
end)

-- Фоновый апдейт
task.spawn(function()
    while true do
        task.wait(2)
        local any = false
        for _, v in pairs(espToggles) do if v then any = true; break end end
        if any then updateESP() end
        updateDistanceTexts()
    end
end)

-- Открытие/закрытие
toggleBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

-- Инициализация
task.wait(0.5); updateESP(); updateDistances()
print("ROCKET MM2 v2.0 OPTIMIZED LOADED")