local QBCore = exports['qb-core']:GetCoreObject()
local isUIOpen = false

local function OpenUI()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.isboss then
        if not isUIOpen then
            TriggerEvent('animations:client:EmoteCommandStart', {'tablet'}) 
            isUIOpen = true
            SetNuiFocus(true, true)
            TriggerServerEvent('bossmenu:server:GetEmployees')
            SendNUIMessage({
                action = "openUI"
            })
        end
    else
        Notify("You are not authorized to access the boss menu.", "error")
    end
end

local function CloseUI()
    if isUIOpen then
        TriggerEvent('animations:client:EmoteCommandStart', {'c'}) 
        isUIOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = "closeUI"
        })
    end
end

RegisterNetEvent('bossmenu:client:RefreshEmployees')
AddEventHandler('bossmenu:client:RefreshEmployees', function(employees, grades, salaries)
    SendNUIMessage({
        action = "refreshEmployees",
        employees = employees,
        grades = grades,
        salaries = salaries
    })
end)

RegisterNUICallback('closeUI', function(data, cb)
    CloseUI()
    cb('ok')
end)

exports('OpenBossMenu', OpenUI)

RegisterCommand('openbossmenu', function()
    OpenUI()
end, false)
