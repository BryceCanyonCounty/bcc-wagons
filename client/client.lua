local VORPcore = {}
-- Prompts
local OpenShops
local CloseShops
local OpenReturn
local OpenGroup = GetRandomIntInRange(0, 0xffffff)
local ClosedGroup = GetRandomIntInRange(0, 0xffffff)
-- Jobs
local PlayerJob
local JobGrade
-- Wagons
local ShopName
local ShopEntity
local MyEntity
local MyWagon = nil
local MyWagonId
local Shop
local InMenu = false
local Cam = false

TriggerEvent('getCore', function(core)
    VORPcore = core
end)

-- Start Wagons
CreateThread(function()
    ShopOpen()
    ShopClosed()
    ReturnOpen()

    while true do
        Wait(0)
        local player = PlayerPedId()
        local pcoords = GetEntityCoords(player)
        local sleep = true
        local hour = GetClockHours()

        if not InMenu and not IsEntityDead(player) then
            for shop, shopCfg in pairs(Config.shops) do
                if shopCfg.shopHours then
                    -- Using Shop Hours - Shop Closed
                    if hour >= shopCfg.shopClose or hour < shopCfg.shopOpen then
                        if Config.blipOnClosed then
                            if not Config.shops[shop].Blip and shopCfg.blipOn then
                                AddBlip(shop)
                            end
                        else
                            if Config.shops[shop].Blip then
                                RemoveBlip(Config.shops[shop].Blip)
                                Config.shops[shop].Blip = nil
                            end
                        end
                        if Config.shops[shop].Blip then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipClosed])) -- BlipAddModifier
                        end
                        if shopCfg.NPC then
                            DeleteEntity(shopCfg.NPC)
                            shopCfg.NPC = nil
                        end
                        local sDist = #(pcoords - shopCfg.npc)
                        if sDist <= shopCfg.sDistance then
                            sleep = false
                            local shopClosed = CreateVarString(10, 'LITERAL_STRING', shopCfg.shopName .. _U('closed'))
                            PromptSetActiveGroupThisFrame(ClosedGroup, shopClosed)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, CloseShops) then -- UiPromptHasStandardModeCompleted
                                Wait(100)
                                VORPcore.NotifyRightTip(shopCfg.shopName .. _U('hours') .. shopCfg.shopOpen .. _U('to') .. shopCfg.shopClose .. _U('hundred'), 4000)
                            end
                        end
                    elseif hour >= shopCfg.shopOpen then
                        -- Using Shop Hours - Shop Open
                        if not Config.shops[shop].Blip and shopCfg.blipOn then
                            AddBlip(shop)
                        end
                        if not next(shopCfg.allowedJobs) then
                            if Config.shops[shop].Blip then
                                Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipOpen])) -- BlipAddModifier
                            end
                            local sDist = #(pcoords - shopCfg.npc)
                            if sDist <= shopCfg.nDistance then
                                if not shopCfg.NPC and shopCfg.npcOn then
                                    AddNPC(shop)
                                end
                            else
                                if shopCfg.NPC then
                                    DeleteEntity(shopCfg.NPC)
                                    shopCfg.NPC = nil
                                end
                            end
                            if sDist <= shopCfg.sDistance then
                                sleep = false
                                local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                                PromptSetActiveGroupThisFrame(OpenGroup, shopOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                    DisplayRadar(false)
                                    OpenMenu(shop)
                                elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                    ReturnWagon()
                                end
                            end
                        else
                            -- Using Shop Hours - Shop Open - Job Locked
                            if Config.shops[shop].Blip then
                                Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipJob])) -- BlipAddModifier
                            end
                            local sDist = #(pcoords - shopCfg.npc)
                            if sDist <= shopCfg.nDistance then
                                if not shopCfg.NPC and shopCfg.npcOn then
                                    AddNPC(shop)
                                end
                            else
                                if shopCfg.NPC then
                                    DeleteEntity(shopCfg.NPC)
                                    shopCfg.NPC = nil
                                end
                            end
                            if sDist <= shopCfg.sDistance then
                                sleep = false
                                local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                                PromptSetActiveGroupThisFrame(OpenGroup, shopOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                    TriggerServerEvent('bcc-wagons:GetPlayerJob')
                                    Wait(200)
                                    if PlayerJob then
                                        if CheckJob(shopCfg.allowedJobs, PlayerJob) then
                                            if tonumber(shopCfg.jobGrade) <= tonumber(JobGrade) then
                                                DisplayRadar(false)
                                                OpenMenu(shop)
                                            else
                                                VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                            end
                                        else
                                            VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                    end
                                elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                    TriggerServerEvent('bcc-wagons:GetPlayerJob')
                                    Wait(200)
                                    if PlayerJob then
                                        if CheckJob(shopCfg.allowedJobs, PlayerJob) then
                                            if tonumber(shopCfg.jobGrade) <= tonumber(JobGrade) then
                                                ReturnWagon()
                                            else
                                                VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                            end
                                        else
                                            VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                    end
                                end
                            end
                        end
                    end
                else
                    -- Not Using Shop Hours - Shop Always Open
                    if not Config.shops[shop].Blip and shopCfg.blipOn then
                        AddBlip(shop)
                    end
                    if not next(shopCfg.allowedJobs) then
                        if Config.shops[shop].Blip then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipOpen])) -- BlipAddModifier
                        end
                        local sDist = #(pcoords - shopCfg.npc)
                        if sDist <= shopCfg.nDistance then
                            if not shopCfg.NPC and shopCfg.npcOn then
                                AddNPC(shop)
                            end
                        else
                            if shopCfg.NPC then
                                DeleteEntity(shopCfg.NPC)
                                shopCfg.NPC = nil
                            end
                        end
                        if sDist <= shopCfg.sDistance then
                            sleep = false
                            local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                            PromptSetActiveGroupThisFrame(OpenGroup, shopOpen)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                DisplayRadar(false)
                                OpenMenu(shop)
                            elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                ReturnWagon()
                            end
                        end
                    else
                        -- Not Using Shop Hours - Shop Always Open - Job Locked
                        if Config.shops[shop].Blip then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipJob])) -- BlipAddModifier
                        end
                        local sDist = #(pcoords - shopCfg.npc)
                        if sDist <= shopCfg.nDistance then
                            if not shopCfg.NPC and shopCfg.npcOn then
                                AddNPC(shop)
                            end
                        else
                            if shopCfg.NPC then
                                DeleteEntity(shopCfg.NPC)
                                shopCfg.NPC = nil
                            end
                        end
                        if sDist <= shopCfg.sDistance then
                            sleep = false
                            local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                            PromptSetActiveGroupThisFrame(OpenGroup, shopOpen)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                TriggerServerEvent('bcc-wagons:GetPlayerJob')
                                Wait(200)
                                if PlayerJob then
                                    if CheckJob(shopCfg.allowedJobs, PlayerJob) then
                                        if tonumber(shopCfg.jobGrade) <= tonumber(JobGrade) then
                                            DisplayRadar(false)
                                            OpenMenu(shop)
                                        else
                                            VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                    end
                                else
                                    VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                end
                            elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                TriggerServerEvent('bcc-wagons:GetPlayerJob')
                                Wait(200)
                                if PlayerJob then
                                    if CheckJob(shopCfg.allowedJobs, PlayerJob) then
                                        if tonumber(shopCfg.jobGrade) <= tonumber(JobGrade) then
                                            ReturnWagon()
                                        else
                                            VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                    end
                                else
                                    VORPcore.NotifyRightTip(_U('needJob'), 5000)
                                end
                            end
                        end
                    end
                end
            end
        end
        if sleep then
            Wait(1000)
        end
    end
end)

-- Open Main Menu
function OpenMenu(shop)
    InMenu = true
    Shop = shop
    ShopName = Config.shops[Shop].shopName

    if MyWagon then
        DeleteEntity(MyWagon)
        MyWagon = nil
    end
    CreateCamera()

    SendNUIMessage({
        action = 'show',
        shopData = Config.shops[Shop].wagons,
        location = ShopName,
        currencyType = Config.currencyType
    })
    SetNuiFocus(true, true)
    TriggerServerEvent('bcc-wagons:GetMyWagons')
end

-- Get Wagon Data for Players Wagons
RegisterNetEvent('bcc-wagons:WagonsData', function(wagonsData)
    SendNUIMessage({
        action = 'updateMyWagons',
        myWagonsData = wagonsData
    })
end)

-- View Wagons for Purchase
RegisterNUICallback('LoadWagon', function(data, cb)
    cb('ok')
    if MyEntity then
        DeleteEntity(MyEntity)
        MyEntity = nil
    end

    local model = joaat(data.WagonModel)
    LoadWagonModel(model)

    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end

    local shopCfg = Config.shops[Shop]
    ShopEntity = CreateVehicle(model, shopCfg.spawn, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, ShopEntity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, ShopEntity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(model)
    if not Cam then
        Cam = true
        CameraLighting()
    end
end)

-- Buy and Name New Wagons
RegisterNUICallback('BuyWagon', function(data, cb)
    cb('ok')
    TriggerServerEvent('bcc-wagons:BuyWagon', data)
end)

RegisterNetEvent('bcc-wagons:SetWagonName', function(data, rename)
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)
    Wait(200)

    CreateThread(function()
        AddTextEntry('FMMC_MPM_NA', _U('nameWagon'))
        DisplayOnscreenKeyboard(1, 'FMMC_MPM_NA', '', '', '', '', '', 30)
        while UpdateOnscreenKeyboard() == 0 do
            DisableAllControlActions(0)
            Wait(0)
        end
        if GetOnscreenKeyboardResult() then
            local wagonName = GetOnscreenKeyboardResult()
            if string.len(wagonName) > 0 then
                if not rename then
                    TriggerServerEvent('bcc-wagons:SaveNewWagon', data, wagonName)
                    return
                else
                    TriggerServerEvent('bcc-wagons:UpdateWagonName', data, wagonName)
                    return
                end
            else
                TriggerEvent('bcc-wagons:SetWagonName', data, rename)
                return
            end
        end
        SendNUIMessage({
            action = 'show',
            shopData = Config.shops[Shop].wagons,
            location = ShopName,
            currencyType = Config.currencyType
        })
        SetNuiFocus(true, true)
        TriggerServerEvent('bcc-wagons:GetMyWagons')
    end)
end)

-- Rename Owned Wagon
RegisterNUICallback('RenameWagon', function(data, cb)
    cb('ok')
    TriggerEvent('bcc-wagons:SetWagonName', data, true)
end)

-- Select Active Wagon
RegisterNUICallback('SelectWagon', function(data, cb)
    cb('ok')
    TriggerServerEvent('bcc-wagons:SelectWagon', data)
end)

-- View Player Owned Wagons
RegisterNUICallback('LoadMyWagon', function(data, cb)
    cb('ok')
    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end

    local model = joaat(data.WagonModel)
    LoadWagonModel(model)

    if MyEntity then
        DeleteEntity(MyEntity)
        MyEntity = nil
    end

    local shopCfg = Config.shops[Shop]
    MyEntity = CreateVehicle(model, shopCfg.spawn, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, MyEntity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, MyEntity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(model)
    if not Cam then
        Cam = true
        CameraLighting()
    end
end)

-- Spawn Player Owned Wagons
RegisterNUICallback('SpawnInfo', function(data, cb)
    cb('ok')
    local menuSpawn = true
    TriggerEvent('bcc-wagons:SpawnWagon', data.WagonModel, data.WagonName, menuSpawn, data.WagonId)
end)

RegisterNetEvent('bcc-wagons:SpawnWagon', function(wagonModel, name, menuSpawn, id)
    if MyWagon then
        DeleteEntity(MyWagon)
        MyWagon = nil
    end

    local model = joaat(wagonModel)
    LoadWagonModel(model)

    if menuSpawn then
        local shopCfg = Config.shops[Shop]
        MyWagon = CreateVehicle(model, shopCfg.spawn, true, false)
        Citizen.InvokeNative(0x7263332501E07F52, MyWagon, true) -- SetVehicleOnGroundProperly
        SetModelAsNoLongerNeeded(model)
        if Config.seated then
            DoScreenFadeOut(500)
            Wait(500)
            SetPedIntoVehicle(PlayerPedId(), MyWagon, -1)
            Wait(500)
            DoScreenFadeIn(500)
        end
    else
        local pCoords = GetEntityCoords(PlayerPedId())
        local _, nodePosition, heading = GetClosestVehicleNodeWithHeading(pCoords.x, pCoords.y, pCoords.z, 1, 3.0, 0)
        local index = 0
        while index <= 25 do
            local _bool, _nodePosition, _heading = GetNthClosestVehicleNodeWithHeading(pCoords.x, pCoords.y, pCoords.z, index, 9, 3.0, 2.5)
            if _bool  then
                nodePosition = _nodePosition
                heading = _heading
                index = index + 3
            else
                break
            end
        end
        MyWagon = CreateVehicle(model, nodePosition, heading, true, false)
        Citizen.InvokeNative(0x7263332501E07F52, MyWagon, true) -- SetVehicleOnGroundProperly
        SetModelAsNoLongerNeeded(model)
    end

    MyWagonId = id
    TriggerServerEvent('bcc-wagons:RegisterInventory', MyWagonId, wagonModel)

    if Config.wagonTag then
        local wagonTag = Citizen.InvokeNative(0xE961BF23EAB76B12, MyWagon, name) -- CreateMpGamerTagOnEntity
        Citizen.InvokeNative(0xA0D7CE5F83259663, wagonTag) -- SetMpGamerTagBigText
        TriggerEvent('bcc-wagons:WagonTag', wagonTag)
    end
    if Config.wagonBlip then
        TriggerEvent('bcc-wagons:WagonBlip', name)
    end
    TriggerEvent('bcc-wagons:WagonActions')
end)

-- Set Wagon Name Above Wagon
AddEventHandler('bcc-wagons:WagonTag', function(wagonTag)
    while MyWagon do
        Wait(1000)
        local player = PlayerPedId()
        local dist = #(GetEntityCoords(player) - GetEntityCoords(MyWagon))
        if dist < 15 and not Citizen.InvokeNative(0xEC5F66E459AF3BB2, player, MyWagon) then -- IsPedOnSpecificVehicle
            Citizen.InvokeNative(0x93171DDDAB274EB8, wagonTag, 2) -- SetMpGamerTagVisibility
        else
            if Citizen.InvokeNative(0x502E1591A504F843, wagonTag, MyWagon) then -- IsMpGamerTagActiveOnEntity
                Citizen.InvokeNative(0x93171DDDAB274EB8, wagonTag, 0) -- SetMpGamerTagVisibility
            end
        end
    end
end)

-- Set Blip on Spawned Wagon when Empty
AddEventHandler('bcc-wagons:WagonBlip', function(name)
    local wagonBlip
    while MyWagon do
        Wait(1000)
        if Citizen.InvokeNative(0xEC5F66E459AF3BB2, PlayerPedId(), MyWagon) then -- IsPedOnSpecificVehicle
            if wagonBlip then
                RemoveBlip(wagonBlip)
                wagonBlip = nil
            end
        else
            if not wagonBlip then
                wagonBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1749618580, MyWagon) -- BlipAddForEntity
                SetBlipSprite(wagonBlip, joaat(Config.wagonBlipSprite), 1)
                Citizen.InvokeNative(0x9CB1A1623062F402, wagonBlip, name) -- SetBlipNameFromPlayerString
            end
        end
    end
end)

-- Sell Player Owned Wagons
RegisterNUICallback('SellWagon', function(data, cb)
    cb('ok')
    DeleteEntity(MyEntity)
    Cam = false
    TriggerServerEvent('bcc-wagons:SellWagon', data, Shop)
end)

-- Close Main Menu
RegisterNUICallback('CloseMenu', function(data, cb)
    cb('ok')
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)

    Citizen.InvokeNative(0x67C540AA08E4A6F5, 'Leaderboard_Hide', 'MP_Leaderboard_Sounds', true, 0) -- PlaySoundFrontend
    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end
    if MyEntity then
        DeleteEntity(MyEntity)
        MyEntity = nil
    end

    Cam = false
    DestroyAllCams(true)
    DisplayRadar(true)
    InMenu = false
    ClearPedTasksImmediately(PlayerPedId())
end)

-- Reopen Menu After Sell or Failed Purchase
RegisterNetEvent('bcc-wagons:WagonMenu', function()
    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end

    SendNUIMessage({
        action = 'show',
        shopData = Config.shops[Shop].wagons,
        location = ShopName,
        currencyType = Config.currencyType
    })
    SetNuiFocus(true, true)
    TriggerServerEvent('bcc-wagons:GetMyWagons')
end)

-- Call Selected Wagon
CreateThread(function()
    if Config.callAllowed then
        while true do
            Wait(1)
            if Citizen.InvokeNative(0x580417101DDB492F, 2, Config.keys.call) then -- IsControlJustPressed
                if Config.callAllowed then
                    CallWagon()
                end
            end
        end
    end
end)

-- Wagon Actions
AddEventHandler('bcc-wagons:WagonActions', function()
    CreateThread(function()
        while MyWagon do
            Wait(0)
            -- Open Wagon Inventory
            if Citizen.InvokeNative(0x580417101DDB492F, 2, Config.keys.inv) then -- IsControlJustPressed
                OpenInventory()
            end
        end
    end)
end)

-- Call Selected Wagon
function CallWagon()
    if MyWagon then
        local callDist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(MyWagon))
        if callDist >= Config.callDistance then
            TriggerServerEvent('bcc-wagons:GetSelectedWagon')
        else
            VORPcore.NotifyRightTip(_U('tooClose'), 5000)
        end
    else
        TriggerServerEvent('bcc-wagons:GetSelectedWagon')
    end
end

-- Open Wagon Inventory
function OpenInventory()
    if MyWagon then
        local invDist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(MyWagon))
        if invDist <= 2.0 then
            TriggerServerEvent('bcc-wagons:OpenInventory', MyWagonId)
        end
    end
end

-- Return Wagon Using Prompt at Shop Location
function ReturnWagon()
    if MyWagon then
        DeleteEntity(MyWagon)
        MyWagon = nil
        VORPcore.NotifyRightTip(_U('wagonReturned'), 5000)
    else
        VORPcore.NotifyRightTip(_U('noWagonReturn'), 5000)
    end
end

function LoadWagonModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

-- Camera to View Wagons
function CreateCamera()
    local shopCfg = Config.shops[Shop]
    local wagonCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(wagonCam, shopCfg.wagonCam.x, shopCfg.wagonCam.y, shopCfg.wagonCam.z + 2.0)
    SetCamActive(wagonCam, true)
    PointCamAtCoord(wagonCam, shopCfg.spawn.x, shopCfg.spawn.y, shopCfg.spawn.z)
    DoScreenFadeOut(500)
    Wait(500)
    DoScreenFadeIn(500)
    RenderScriptCams(true, false, 0, 0, 0)
    Citizen.InvokeNative(0x67C540AA08E4A6F5, 'Leaderboard_Show', 'MP_Leaderboard_Sounds', true, 0) -- PlaySoundFrontend
end

function CameraLighting()
    CreateThread(function()
        local shopCfg = Config.shops[Shop]
        while Cam do
            Wait(0)
            Citizen.InvokeNative(0xD2D9E04C0DF927F4, shopCfg.spawn.x, shopCfg.spawn.y, shopCfg.spawn.z + 3, 130, 130, 85, 4.0, 15.0) -- DrawLightWithRange
        end
    end)
end

-- Rotate Wagons while Viewing
RegisterNUICallback('Rotate', function(data, cb)
    cb('ok')
    local direction = data.RotateWagon
    if direction == 'left' then
        Rotation(1)
    elseif direction == 'right' then
        Rotation(-1)
    end
end)

function Rotation(dir)
    if MyEntity then
        local ownedRot = GetEntityHeading(MyEntity) + dir
        SetEntityHeading(MyEntity, ownedRot % 360)
    elseif ShopEntity then
        local shopRot = GetEntityHeading(ShopEntity) + dir
        SetEntityHeading(ShopEntity, shopRot % 360)
    end
end

RegisterCommand('wagonEnter', function(rawCommand)
    if MyWagon then
        DoScreenFadeOut(500)
        Wait(500)
        SetPedIntoVehicle(PlayerPedId(), MyWagon, -1)
        Wait(500)
        DoScreenFadeIn(500)
    else
        VORPcore.NotifyRightTip(_U('noWagon'), 5000)
    end
end)

RegisterCommand('wagonReturn', function()
    ReturnWagon()
end)

-- Menu Prompts
function ShopOpen()
    local str = _U('shopPrompt')
    OpenShops = PromptRegisterBegin()
    PromptSetControlAction(OpenShops, Config.keys.shop)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(OpenShops, str)
    PromptSetEnabled(OpenShops, 1)
    PromptSetVisible(OpenShops, 1)
    PromptSetStandardMode(OpenShops, 1)
    PromptSetGroup(OpenShops, OpenGroup)
    PromptRegisterEnd(OpenShops)
end

function ShopClosed()
    local str = _U('shopPrompt')
    CloseShops = PromptRegisterBegin()
    PromptSetControlAction(CloseShops, Config.keys.shop)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(CloseShops, str)
    PromptSetEnabled(CloseShops, 1)
    PromptSetVisible(CloseShops, 1)
    PromptSetStandardMode(CloseShops, 1)
    PromptSetGroup(CloseShops, ClosedGroup)
    PromptRegisterEnd(CloseShops)
end

function ReturnOpen()
    local str = _U('returnPrompt')
    OpenReturn = PromptRegisterBegin()
    PromptSetControlAction(OpenReturn, Config.keys.ret)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(OpenReturn, str)
    PromptSetEnabled(OpenReturn, 1)
    PromptSetVisible(OpenReturn, 1)
    PromptSetStandardMode(OpenReturn, 1)
    PromptSetGroup(OpenReturn, OpenGroup)
    PromptRegisterEnd(OpenReturn)
end

-- Blips
function AddBlip(shop)
    local shopCfg = Config.shops[shop]
    shopCfg.Blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, shopCfg.npc) -- BlipAddForCoords
    SetBlipSprite(shopCfg.Blip, shopCfg.blipSprite, 1)
    SetBlipScale(shopCfg.Blip, 0.2)
    Citizen.InvokeNative(0x9CB1A1623062F402, shopCfg.Blip, shopCfg.blipName) -- SetBlipName
end

-- NPCs
function AddNPC(shop)
    local shopCfg = Config.shops[shop]
    LoadModel(shopCfg.npcModel)
    local npc = CreatePed(shopCfg.npcModel, shopCfg.npc.x, shopCfg.npc.y, shopCfg.npc.z - 1.0, shopCfg.npcHeading, false, true, true, true)
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true) -- SetRandomOutfitVariation
    SetEntityCanBeDamaged(npc, false)
    SetEntityInvincible(npc, true)
    Wait(500)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    Config.shops[shop].NPC = npc
end

function LoadModel(npcModel)
    local model = joaat(npcModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

-- Check if Player has Job
function CheckJob(allowedJob, playerJob)
    for _, jobAllowed in pairs(allowedJob) do
        if jobAllowed == playerJob then
            return true
        end
    end
    return false
end

RegisterNetEvent('bcc-wagons:sendPlayerJob', function(Job, grade)
    PlayerJob = Job
    JobGrade = grade
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if InMenu then
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = 'hide'
        })
    end
    ClearPedTasksImmediately(PlayerPedId())
    PromptDelete(OpenShops)
    PromptDelete(CloseShops)
    PromptDelete(OpenReturn)
    DestroyAllCams(true)
    DisplayRadar(true)

    if MyWagon then
        DeleteEntity(MyWagon)
        MyWagon = nil
    end

    for _, shopCfg in pairs(Config.shops) do
        if shopCfg.Blip then
            RemoveBlip(shopCfg.Blip)
        end
        if shopCfg.NPC then
            DeleteEntity(shopCfg.NPC)
            shopCfg.NPC = nil
        end
    end
end)
