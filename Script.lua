-- Загрузка WindUI
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

-- Переменные для настроек
local settings = {
    walkSpeed = 16,
    noclip = false,
    farmSpeed = 10, -- задержка в миллисекундах между телепортами
    farmEnabled = false,
    espInnocents = false,
    espHero = false,
    espMurderer = false,
    espSheriff = false,
    espDistance = false,
    aimAtMurderer = false,
    killSheriff = false,
    killAll = false,
    trailColor = Color3.new(1,1,1),
    trailEnabled = false,
    screenColor = Color3.new(1,0,0),
    screenEnabled = false,
    theme = "RedBlack"
}

-- Функция для получения роли игрока (упрощённо)
local function getPlayerRole(plr)
    if not plr.Character then return nil end
    local backpack = plr:FindFirstChild("Backpack")
    if not backpack then return nil end
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            if tool.Name == "Knife" then
                return "Murderer"
            elseif tool.Name == "Gun" then
                -- Проверяем, может быть Sheriff или Hero с пистолетом? Обычно Sheriff имеет "Gun"
                -- В MM2 Sheriff имеет Gun, Hero тоже может иметь? Лучше поискать другие признаки.
                -- Для простоты: если есть Gun и игрок не является Murderer (у него нет Knife), то Sheriff.
                -- Но могут быть оба? В MM2 обычно только одно оружие.
                -- Плюс, есть роль Hero - у него тоже может быть Gun? Нет, Hero обычно с ножом.
                -- Так что считаем, что Gun - Sheriff, Knife - Murderer, остальные - Innocent.
                return "Sheriff"
            end
        end
    end
    -- Проверяем наличие специального тега "Hero" (некоторые читы используют)
    if plr:FindFirstChild("HeroTag") then
        return "Hero"
    end
    return "Innocent"
end

-- Функция для обновления ESP (вызывается в цикле)
local espLoopRunning = false
local function espLoop()
    if espLoopRunning then return end
    espLoopRunning = true
    spawn(function()
        while settings.espInnocents or settings.espHero or settings.espMurderer or settings.espSheriff or settings.espDistance do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr == LP or not plr.Character or not plr.Character:FindFirstChild("Head") then continue end
                local role = getPlayerRole(plr)
                local color = nil
                if role == "Innocent" and settings.espInnocents then
                    color = Color3.new(0,1,0) -- зелёный
                elseif role == "Hero" and settings.espHero then
                    color = Color3.new(1,1,0) -- жёлтый
                elseif role == "Murderer" and settings.espMurderer then
                    color = Color3.new(1,0,0) -- красный
                elseif role == "Sheriff" and settings.espSheriff then
                    color = Color3.new(0,0,1) -- синий
                end
                if color then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Size = Vector3.new(4, 6, 2)
                    box.Adornee = plr.Character.Head
                    box.ZIndex = 0
                    box.Color3 = color
                    box.Transparency = 0.5
                    box.Parent = plr.Character.Head
                    game:GetService("Debris"):AddItem(box, 0.1)
                end
                -- Расстояние
                if settings.espDistance and plr.Character and plr.Character:FindFirstChild("Head") and LP.Character and LP.Character:FindFirstChild("Head") then
                    local dist = (LP.Character.Head.Position - plr.Character.Head.Position).magnitude
                    local text = Instance.new("BillboardGui")
                    text.Size = UDim2.new(0, 50, 0, 20)
                    text.Adornee = plr.Character.Head
                    text.Parent = plr.Character.Head
                    local label = Instance.new("TextLabel", text)
                    label.Size = UDim2.new(1,0,1,0)
                    label.BackgroundTransparency = 1
                    label.Text = tostring(math.floor(dist))
                    label.TextColor3 = Color3.new(1,1,1)
                    label.TextScaled = true
                    game:GetService("Debris"):AddItem(text, 0.1)
                end
            end
            task.wait(0.05) -- обновление каждые 50 мс
        end
        espLoopRunning = false
    end)
end

-- Функция для Aimbot: смотреть на убийцу
local aimLoopRunning = false
local function aimLoop()
    if aimLoopRunning then return end
    aimLoopRunning = true
    spawn(function()
        while settings.aimAtMurderer do
            local target = nil
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
                    local role = getPlayerRole(plr)
                    if role == "Murderer" then
                        target = plr
                        break
                    end
                end
            end
            if target and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = CFrame.new(LP.Character.HumanoidRootPart.Position, target.Character.Head.Position)
            end
            task.wait()
        end
        aimLoopRunning = false
    end)
end

-- Функция для убийства шерифа
local function killSheriff()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            local role = getPlayerRole(plr)
            if role == "Sheriff" then
                pcall(function()
                    plr.Character.Humanoid.Health = 0
                end)
            end
        end
    end
end

-- Функция для убийства всех
local function killAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            pcall(function()
                plr.Character.Humanoid.Health = 0
            end)
        end
    end
end

-- Функция для AutoFarm
local farmRunning = false
local function farmLoop()
    if farmRunning then return end
    farmRunning = true
    spawn(function()
        while settings.farmEnabled do
            local coins = {}
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("Tool") and obj.Name == "Coin" and obj:FindFirstChild("Handle") then
                    table.insert(coins, obj)
                end
            end
            for _, coin in pairs(coins) do
                if not settings.farmEnabled then break end
                if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character.HumanoidRootPart.CFrame = coin.Handle.CFrame
                end
                task.wait(settings.farmSpeed / 1000) -- переводим миллисекунды в секунды
            end
            task.wait()
        end
        farmRunning = false
    end)
end

-- Функция для трейла (полоски)
local trailPart = nil
local function toggleTrail(state)
    if state then
        if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
        local att = Instance.new("Attachment")
        att.Parent = LP.Character.HumanoidRootPart
        local trail = Instance.new("Trail")
        trail.Parent = LP.Character.HumanoidRootPart
        trail.Attachment0 = att
        trail.Color = ColorSequence.new(settings.trailColor)
        trail.Lifetime = 2
        trail.MinLength = 0.5
        trail.Enabled = true
        trailPart = trail
    else
        if trailPart then trailPart:Destroy() end
        trailPart = nil
    end
end

-- Функция для изменения цвета экрана
local screenEffect = nil
local function toggleScreenColor(state)
    if state then
        if not screenEffect then
            screenEffect = Instance.new("ColorCorrectionEffect")
            screenEffect.Parent = Lighting
        end
        screenEffect.TintColor = settings.screenColor
        screenEffect.Enabled = true
    else
        if screenEffect then
            screenEffect.Enabled = false
        end
    end
end

-- Основное окно
local Window = WindUI:CreateWindow({
    Title = "MM2 Kolan Hub",
    Author = "by Nikilos",
    Folder = "KolanHub",
    Theme = "RedBlack" -- по умолчанию
})

-- Вкладка Player
local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user"
})

PlayerTab:Slider({
    Title = "WalkSpeed",
    Step = 1,
    Value = { Min = 16, Max = 250, Default = 16 },
    Callback = function(v)
        settings.walkSpeed = v
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = v
        end
        -- Обход античита: постоянно устанавливаем скорость в цикле
        spawn(function()
            while true do
                if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                    LP.Character.Humanoid.WalkSpeed = settings.walkSpeed
                end
                task.wait(0.5)
            end
        end)
    end
})

PlayerTab:Toggle({
    Title = "Noclip",
    Value = false,
    Callback = function(v)
        settings.noclip = v
        if v then
            spawn(function()
                while settings.noclip do
                    if LP.Character then
                        for _, part in pairs(LP.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    task.wait()
                end
            end)
        else
            if LP.Character then
                for _, part in pairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

-- Вкладка ESP
local EspTab = Window:Tab({
    Title = "Esp",
    Icon = "eye"
})

EspTab:Toggle({
    Title = "Отображать мирных",
    Value = false,
    Callback = function(v)
        settings.espInnocents = v
        if v or settings.espHero or settings.espMurderer or settings.espSheriff or settings.espDistance then
            espLoop()
        end
    end
})

EspTab:Toggle({
    Title = "Отображать героя",
    Value = false,
    Callback = function(v)
        settings.espHero = v
        if v or settings.espInnocents or settings.espMurderer or settings.espSheriff or settings.espDistance then
            espLoop()
        end
    end
})

EspTab:Toggle({
    Title = "Отображать убийцу",
    Value = false,
    Callback = function(v)
        settings.espMurderer = v
        if v or settings.espInnocents or settings.espHero or settings.espSheriff or settings.espDistance then
            espLoop()
        end
    end
})

EspTab:Toggle({
    Title = "Отображать шерифа",
    Value = false,
    Callback = function(v)
        settings.espSheriff = v
        if v or settings.espInnocents or settings.espHero or settings.espMurderer or settings.espDistance then
            espLoop()
        end
    end
})

EspTab:Toggle({
    Title = "Отображать расстояние",
    Value = false,
    Callback = function(v)
        settings.espDistance = v
        if v or settings.espInnocents or settings.espHero or settings.espMurderer or settings.espSheriff then
            espLoop()
        end
    end
})

-- Вкладка Aimbot
local AimbotTab = Window:Tab({
    Title = "Aimbot",
    Icon = "crosshair"
})

-- Заголовок Sheriff (просто текст)
AimbotTab:Label({
    Title = "Sheriff",
    Color = Color3.new(0,0,1)
})

AimbotTab:Toggle({
    Title = "Смотреть на убийцу",
    Value = false,
    Callback = function(v)
        settings.aimAtMurderer = v
        if v then aimLoop() end
    end
})

AimbotTab:Label({
    Title = "Murder",
    Color = Color3.new(1,0,0)
})

AimbotTab:Button({
    Title = "Убить шерифа",
    Icon = "skull",
    Callback = function()
        killSheriff()
    end
})

AimbotTab:Button({
    Title = "Убить всех",
    Icon = "zap",
    Callback = function()
        killAll()
    end
})

-- Вкладка AutoFarm
local FarmTab = Window:Tab({
    Title = "AutoFarm",
    Icon = "dollar-sign"
})

FarmTab:Slider({
    Title = "Скорость фарма монеток (мс)",
    Step = 1,
    Value = { Min = 0, Max = 40, Default = 10 },
    Callback = function(v)
        settings.farmSpeed = v
    end
})

FarmTab:Toggle({
    Title = "Фарм монеток",
    Value = false,
    Callback = function(v)
        settings.farmEnabled = v
        if v then farmLoop() end
    end
})

-- Вкладка Visuals
local VisualsTab = Window:Tab({
    Title = "Visuals",
    Icon = "palette"
})

-- Полоска
VisualsTab:Label({
    Title = "Strip",
    Color = Color3.new(1,1,1)
})

VisualsTab:Dropdown({
    Title = "Цвет полоски",
    Values = {"Red", "Blue", "Green", "White", "Purple", "Black", "Rainbow"},
    Default = 1, -- индекс
    Callback = function(choice)
        local colors = {
            Red = Color3.new(1,0,0),
            Blue = Color3.new(0,0,1),
            Green = Color3.new(0,1,0),
            White = Color3.new(1,1,1),
            Purple = Color3.new(0.5,0,0.5),
            Black = Color3.new(0,0,0),
            Rainbow = nil -- не реализовано, просто оставим белый
        }
        settings.trailColor = colors[choice] or Color3.new(1,1,1)
        if settings.trailEnabled then
            toggleTrail(false)
            toggleTrail(true)
        end
    end
})

VisualsTab:Toggle({
    Title = "Включить полоску",
    Value = false,
    Callback = function(v)
        settings.trailEnabled = v
        toggleTrail(v)
    end
})

-- Lighting
VisualsTab:Label({
    Title = "Lighting",
    Color = Color3.new(1,1,1)
})

VisualsTab:Dropdown({
    Title = "Цвет экрана",
    Values = {"Red", "Blue", "Black", "White", "Purple", "Green"},
    Default = 1,
    Callback = function(choice)
        local colors = {
            Red = Color3.new(1,0,0),
            Blue = Color3.new(0,0,1),
            Black = Color3.new(0,0,0),
            White = Color3.new(1,1,1),
            Purple = Color3.new(0.5,0,0.5),
            Green = Color3.new(0,1,0)
        }
        settings.screenColor = colors[choice] or Color3.new(1,0,0)
        if settings.screenEnabled then
            toggleScreenColor(true)
        end
    end
})

VisualsTab:Toggle({
    Title = "Включить цвет экрана",
    Value = false,
    Callback = function(v)
        settings.screenEnabled = v
        toggleScreenColor(v)
    end
})

-- Вкладка Settings
local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings"
})

SettingsTab:Dropdown({
    Title = "Theme",
    Values = {"Red Black", "Green White", "Purple White", "Blue Black"},
    Default = 1,
    Callback = function(choice)
        -- Преобразуем в названия тем WindUI (возможно, надо убрать пробелы или оставить как есть)
        local themeMap = {
            ["Red Black"] = "RedBlack",
            ["Green White"] = "GreenWhite",
            ["Purple White"] = "PurpleWhite",
            ["Blue Black"] = "BlueBlack"
        }
        local themeName = themeMap[choice] or "RedBlack"
        settings.theme = themeName
        -- Применяем тему к окну
        WindUI:SetTheme(themeName)
    end
})

-- Инициализация тем (первоначально Red Black)
WindUI:SetTheme("RedBlack")

-- Дополнительно: обработка перезагрузки персонажа
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = settings.walkSpeed
    end
    if settings.noclip then
        -- повторно включим ноклип
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    if settings.trailEnabled then
        toggleTrail(false)
        toggleTrail(true)
    end
end)

-- Уведомление о загрузке
WindUI:Notify({
    Title = "Kolan Hub",
    Content = "Загружен, Играй.",
    Duration = 3
})
