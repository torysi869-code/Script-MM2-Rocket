-- ROCKET MM2 v2.0 (Fluent Edition) — БЕЗ ОШИБКИ FIRE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer

-- ============================================================
-- БИБЛИОТЕКА FLUENT (исправленная)
-- ============================================================
local Fluent = {}
Fluent.__index = Fluent

local Theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Surface = Color3.fromRGB(45, 45, 55),
    Primary = Color3.fromRGB(0, 120, 255),
    Accent = Color3.fromRGB(0, 200, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Dim = Color3.fromRGB(100, 100, 100),
}

function Fluent:CreateWindow(title, size, position)
    local window = {}
    window.Frame = Instance.new("Frame")
    window.Frame.Size = size or UDim2.new(0.7, 0, 0.6, 0)
    window.Frame.Position = position or UDim2.new(0.15, 0, 0.2, 0)
    window.Frame.BackgroundColor3 = Theme.Background
    window.Frame.BorderSizePixel = 0
    window.Frame.Visible = true
    window.Frame.Parent = player.PlayerGui

    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Text = title or "Fluent"
    titleBar.TextColor3 = Theme.Text
    titleBar.BackgroundColor3 = Theme.Surface
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextScaled = true
    titleBar.Parent = window.Frame

    local closeBtn = Instance.new("ImageButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Image = "rbxassetid://1537999474"
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = window.Frame
    closeBtn.MouseButton1Click:Connect(function() window.Frame.Visible = false end)

    window.TabContainer = Instance.new("Frame")
    window.TabContainer.Size = UDim2.new(1, 0, 1, -35)
    window.TabContainer.Position = UDim2.new(0, 0, 0, 35)
    window.TabContainer.BackgroundTransparency = 1
    window.TabContainer.Parent = window.Frame

    window.Tabs = {}
    window.TabButtons = {}
    window.ActiveTab = nil

    function window:Tab(name)
        local tab = {}
        tab.Frame = Instance.new("Frame")
        tab.Frame.Size = UDim2.new(1, 0, 1, 0)
        tab.Frame.BackgroundTransparency = 1
        tab.Frame.Visible = false
        tab.Frame.Parent = window.TabContainer

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 0, 30)
        btn.Position = UDim2.new(0, #window.TabButtons * 85, 0, 5)
        btn.Text = name
        btn.BackgroundColor3 = Theme.Surface
        btn.TextColor3 = Theme.Text
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = window.Frame
        btn.MouseButton1Click:Connect(function()
            for _, v in pairs(window.Tabs) do v.Frame.Visible = false end
            tab.Frame.Visible = true
            window.ActiveTab = tab
        end)

        table.insert(window.TabButtons, btn)
        table.insert(window.Tabs, tab)

        -- Исправлено: активируем первую вкладку без вызова Fire
        if #window.Tabs == 1 then
            tab.Frame.Visible = true
            window.ActiveTab = tab
        end

        tab.Elements = {}

        function tab:AddToggle(label, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0.9, 0, 0, 35)
            frame.Position = UDim2.new(0.05, 0, 0, #tab.Elements * 40)
            frame.BackgroundTransparency = 1
            frame.Parent = tab.Frame

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.6, 0, 1, 0)
            lbl.Text = label
            lbl.TextColor3 = Theme.Text
            lbl.BackgroundTransparency = 1
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextScaled = true
            lbl.Parent = frame

            local btn = Instance.new("ImageButton")
            btn.Size = UDim2.new(0, 40, 0, 25)
            btn.Position = UDim2.new(0.85, 0, 0, 5)
            btn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
            btn.BorderSizePixel = 0
            btn.Parent = frame

            local state = default or false
            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
                if callback then callback(state) end
            end)

            local toggle = {}
            toggle.SetState = function(s) state = s; btn.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(100,100,100) end
            toggle.GetState = function() return state end
            table.insert(tab.Elements, frame)
            return toggle
        end

        function tab:AddButton(label, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.8, 0, 0, 35)
            btn.Position = UDim2.new(0.1, 0, 0, #tab.Elements * 40)
            btn.Text = label
            btn.BackgroundColor3 = Theme.Surface
            btn.TextColor3 = Theme.Text
            btn.BorderSizePixel = 0
            btn.Font = Enum.Font.GothamMedium
            btn.Parent = tab.Frame
            btn.MouseButton1Click:Connect(callback or function() end)
            table.insert(tab.Elements, btn)
        end

        function tab:AddLabel(text, color)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.8, 0, 0, 25)
            lbl.Position = UDim2.new(0.1, 0, 0, #tab.Elements * 40)
            lbl.Text = text
            lbl.TextColor3 = color or Theme.Text
            lbl.BackgroundTransparency = 1
            lbl.TextXAlignment = Enum.TextXAlignment.Center
            lbl.Font = Enum.Font.GothamBold
            lbl.TextScaled = true
            lbl.Parent = tab.Frame
            table.insert(tab.Elements, lbl)
        end

        return tab
    end

    return window
end

-- ============================================================
-- СОЗДАНИЕ GUI
-- ============================================================
local Window = Fluent:CreateWindow("ROCKET MM2", UDim2.new(0.75, 0, 0.65, 0), UDim2.new(0.125, 0, 0.175, 0))
local AmbientTab = Window:Tab("Ambient")
local EspTab = Window:Tab("Esp")

-- Переключатели Ambient
local camToggle = AmbientTab:AddToggle("Наводить камеру на убийцу", false, function(s)
    if s then startAim() else stopAim() end
end)
local shootToggle = AmbientTab:AddToggle("Кнопка выстрела в убийцу", false, function(s)
    shootBtn.Visible = s
end)

-- Переключатели Esp
local espToggles = {}
local roles = {"Мирные", "Герой", "Шериф", "Убийца"}
local roleKeys = {"innocent", "hero", "sheriff", "murderer"}
for i, name in ipairs(roles) do
    local toggle = EspTab:AddToggle("Отображать " .. name, false, function(s)
        espToggles[roleKeys[i]] = s
        updateESP()
    end)
    espToggles[roleKeys[i]] = false
end

local distToggle = EspTab:AddToggle("Отображать расстояние", false, function(s)
    distToggleState = s
    updateDistances()
end)
local distToggleState = false

-- Кнопка открытия/закрытия окна (отдельная)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://86784400948439"
toggleBtn.Parent = player.PlayerGui
toggleBtn.MouseButton1Click:Connect(function()
    Window.Frame.Visible = not Window.Frame.Visible
end)

-- Кнопка выстрела (плавает поверх)
local shootBtn = Instance.new("TextButton")
shootBtn.Size = UDim2.new(0, 100, 0, 100)
shootBtn.Position = UDim2.new(0.5, -50, 0.85, -50)
shootBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
shootBtn.Text = "🔫"
shootBtn.TextScaled = true
shootBtn.TextColor3 = Color3.new(1, 1, 1)
shootBtn.Visible = false
shootBtn.Parent = player.PlayerGui
shootBtn.MouseButton1Click:Connect(function() shootMurderer() end)

-- ============================================================
-- ОСНОВНАЯ ЛОГИКА
-- ============================================================
local highlights, distanceLabels = {}, {}
local aimConnection = nil

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

function colorForRole(r)
    local colors = {innocent = Color3.fromRGB(0,255,0), hero = Color3.fromRGB(255,255,0), sheriff = Color3.fromRGB(0,0,255), murderer = Color3.fromRGB(255,0,0)}
    return colors[r] or Color3.new(1,1,1)
end

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

function startAim()
    if aimConnection then aimConnection:Disconnect() end
    aimConnection = RunService.RenderStepped:Connect(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and getRole(plr) == "murderer" and plr.Character and plr.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, plr.Character.Head.Position)
                break
            end
        end
    end)
end

function stopAim()
    if aimConnection then aimConnection:Disconnect(); aimConnection = nil end
end

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
    n.Size = UDim2.new(0.5,0,0.08,0)
    n.Position = UDim2.new(0.25,0,0.46,0)
    n.BackgroundColor3 = Color3.fromRGB(20,20,30)
    n.Text = text
    n.TextColor3 = color or Color3.new(1,1,1)
    n.TextScaled = true
    n.Font = Enum.Font.GothamBold
    n.BorderSizePixel = 0
    n.Parent = player.PlayerGui
    Debris:AddItem(n, 2)
end

-- ============================================================
-- СОБЫТИЯ И ФОНОВЫЙ ЦИКЛ
-- ============================================================
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        updateESP(); updateDistances()
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    if highlights[plr] then highlights[plr]:Destroy(); highlights[plr] = nil end
    if distanceLabels[plr] then distanceLabels[plr]:Destroy(); distanceLabels[plr] = nil end
end)

task.spawn(function()
    while true do
        task.wait(2)
        local any = false
        for _, v in pairs(espToggles) do if v then any = true; break end end
        if any then updateESP() end
        updateDistanceTexts()
    end
end)

-- Первоначальный запуск
task.wait(0.5)
updateESP()
updateDistances()

print("ROCKET MM2 v2.0 (Fluent) загружен. Ошибка Fire исправлена.")