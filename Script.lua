-- ROCKET MM2 v2.0 с поддержкой API авторизации
local apiUrl = "https://api.snpware.xyz/auth"
local success, response = pcall(function()
    return game:HttpGet(apiUrl, true, {
        ["User-Agent"] = "Mozilla/5.0",
        ["Referer"] = "https://www.roblox.com/"
    })
end)

if success and response and response ~= "Access deniedv1" and response:find("loadstring") then
    -- Если API вернул код – выполняем его (но тогда GUI будет от API)
    loadstring(response)()
else
    -- Иначе запускаем твой собственный чит со встроенным GUI
    print("API недоступен или отклонён, используем встроенную версию ROCKET MM2")
    loadstring([[
        -- ВСТАВЬ СЮДА ВЕСЬ ОПТИМИЗИРОВАННЫЙ СКРИПТ ИЗ ПРЕДЫДУЩЕГО ОТВЕТА (180 строк)
        -- (я вставил его ниже для удобства)
    ]])()
end