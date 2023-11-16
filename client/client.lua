local VORPcore = {}
TriggerEvent('getCore', function(core)
    VORPcore = core
end)
local ClientRPC = exports.vorp_core:ClientRpcCall()
-- Prompts
local OpenShops
local OpenReturn
local PromptGroup = GetRandomIntInRange(0, 0xffffff)
-- Wagons
local ShopName
local ShopEntity
local MyEntity
local MyWagon = nil
local MyWagonId
local MyWagonName
local Shop
local InMenu = false
local Cam = false
local HasJob = nil
-- Start Wagons
CreateThread(function()
    StartPrompts()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local pCoords = GetEntityCoords(playerPed)
        local sleep = true
        local hour = GetClockHours()
        if not InMenu and not IsEntityDead(playerPed) then
            for shop, shopCfg in pairs(Config.shops) do
                if shopCfg.shopHours then
                    -- Using Shop Hours - Shop Closed
                    if hour >= shopCfg.shopClose or hour < shopCfg.shopOpen then
                        if shopCfg.blipOn and Config.blipOnClosed then
                            if not Config.shops[shop].Blip then
                                AddBlip(shop)
                            end
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipClosed])) -- BlipAddModifier
                        else
                            if Config.shops[shop].Blip then
                                RemoveBlip(Config.shops[shop].Blip)
                                Config.shops[shop].Blip = nil
                            end
                        end
                        if shopCfg.NPC then
                            DeleteEntity(shopCfg.NPC)
                            shopCfg.NPC = nil
                        end
                        local sDist = #(pCoords - shopCfg.npcPos)
                        if sDist <= shopCfg.sDistance then
                            sleep = false
                            local shopClosed = CreateVarString(10, 'LITERAL_STRING', shopCfg.shopName .. _U('hours') .. shopCfg.shopOpen .. _U('to') .. shopCfg.shopClose .. _U('hundred'))
                            PromptSetActiveGroupThisFrame(PromptGroup, shopClosed)
                            PromptSetEnabled(OpenShops, 0)
                            PromptSetEnabled(OpenReturn, 0)
                        end
                    elseif hour >= shopCfg.shopOpen then
                        -- Using Shop Hours - Shop Open
                        if shopCfg.blipOn and not Config.shops[shop].Blip then
                            AddBlip(shop)
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipOpen])) -- BlipAddModifier
                        end
                        if not next(shopCfg.allowedJobs) then
                            local sDist = #(pCoords - shopCfg.npcPos)
                            if shopCfg.npcOn then
                                if sDist <= shopCfg.nDistance then
                                    if not shopCfg.NPC then
                                        AddNPC(shop)
                                    end
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
                                PromptSetActiveGroupThisFrame(PromptGroup, shopOpen)
                                PromptSetEnabled(OpenShops, 1)
                                PromptSetEnabled(OpenReturn, 1)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
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
                            local sDist = #(pCoords - shopCfg.npcPos)
                            if shopCfg.npcOn then
                                if sDist <= shopCfg.nDistance then
                                    if not shopCfg.NPC then
                                        AddNPC(shop)
                                    end
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
                                PromptSetActiveGroupThisFrame(PromptGroup, shopOpen)
                                PromptSetEnabled(OpenShops, 1)
                                PromptSetEnabled(OpenReturn, 1)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                    local result = ClientRPC.Callback.TriggerAwait('bcc-wagons:CheckPlayerJob', shop)
                                    if result then
                                        OpenMenu(shop)
                                    else
                                        return
                                    end
                                elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                    local result = ClientRPC.Callback.TriggerAwait('bcc-wagons:CheckPlayerJob', shop)
                                    if result then
                                        ReturnWagon()
                                    else
                                        return
                                    end
                                end
                            end
                        end
                    end
                else
                    -- Not Using Shop Hours - Shop Always Open
                    if shopCfg.blipOn and not Config.shops[shop].Blip then
                        AddBlip(shop)
                        Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipOpen])) -- BlipAddModifier
                    end
                    if not next(shopCfg.allowedJobs) then
                        local sDist = #(pCoords - shopCfg.npcPos)
                        if shopCfg.npcOn then
                            if sDist <= shopCfg.nDistance then
                                if not shopCfg.NPC then
                                    AddNPC(shop)
                                end
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
                            PromptSetActiveGroupThisFrame(PromptGroup, shopOpen)
                            PromptSetEnabled(OpenShops, 1)
                            PromptSetEnabled(OpenReturn, 1)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
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
                        local sDist = #(pCoords - shopCfg.npcPos)
                        if shopCfg.npcOn then
                            if sDist <= shopCfg.nDistance then
                                if not shopCfg.NPC then
                                    AddNPC(shop)
                                end
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
                            PromptSetActiveGroupThisFrame(PromptGroup, shopOpen)
                            PromptSetEnabled(OpenShops, 1)
                            PromptSetEnabled(OpenReturn, 1)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                local result = ClientRPC.Callback.TriggerAwait('bcc-wagons:CheckPlayerJob', shop)
                                if result then
                                    OpenMenu(shop)
                                else
                                    return
                                end
                            elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                local result = ClientRPC.Callback.TriggerAwait('bcc-wagons:CheckPlayerJob', shop)
                                if result then
                                    ReturnWagon()
                                else
                                    return
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
    DisplayRadar(false)
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
    ShopEntity = CreateVehicle(model, shopCfg.spawnPos, shopCfg.spawnHeading, false, false, false, false)
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
    local canBuy = ClientRPC.Callback.TriggerAwait('bcc-wagons:BuyWagon', data)
    if canBuy then
        SetWagonName(data, false)
    else
        WagonMenu()
    end
end)

function SetWagonName(data, rename)
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
                local wagonInfo = {wagonData = data, name = wagonName}
                if rename then
                    local nameSaved = ClientRPC.Callback.TriggerAwait('bcc-wagons:UpdateWagonName', wagonInfo)
                    if nameSaved then
                        WagonMenu()
                    end
                    return
                else
                    local wagonSaved = ClientRPC.Callback.TriggerAwait('bcc-wagons:SaveNewWagon', wagonInfo)
                    if wagonSaved then
                        WagonMenu()
                    end
                    return
                end
            else
                SetWagonName(data, rename)
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
end

-- Rename Owned Wagon
RegisterNUICallback('RenameWagon', function(data, cb)
    cb('ok')
    SetWagonName(data, true)
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
    MyEntity = CreateVehicle(model, shopCfg.spawnPos, shopCfg.spawnHeading, false, false, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, MyEntity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, MyEntity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(model)
    if not Cam then
        Cam = true
        CameraLighting()
    end
end)

-- Select Active Wagon
RegisterNUICallback('SelectWagon', function(data, cb)
    cb('ok')
    TriggerServerEvent('bcc-wagons:SelectWagon', data)
end)

function GetSelectedWagon()
    local data = ClientRPC.Callback.TriggerAwait('bcc-wagons:GetWagonData')
    if data then
        MyWagonId = data.invDist
        SpawnWagon(data.model, data.name, false, data.id)
    end
end

-- Spawn Player Owned Wagons
RegisterNUICallback('SpawnInfo', function(data, cb)
    cb('ok')
    SpawnWagon(data.WagonModel, data.WagonName, true, data.WagonId)
end)

function SpawnWagon(wagonModel, name, menuSpawn, id)
    if MyWagon then
        DeleteEntity(MyWagon)
        MyWagon = nil
    end

    MyWagonName = name
    local model = joaat(wagonModel)
    LoadWagonModel(model)

    if menuSpawn then
        local shopCfg = Config.shops[Shop]
        MyWagon = CreateVehicle(model, shopCfg.spawnPos, shopCfg.spawnHeading, true, false, false, false)
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
        local _, node, heading = GetClosestVehicleNodeWithHeading(pCoords.x, pCoords.y, pCoords.z, 1, 3.0, 0)
        local index = 0
        while index <= 25 do
            local nodeCheck, _node, _heading = GetNthClosestVehicleNodeWithHeading(pCoords.x, pCoords.y, pCoords.z, index, 9, 3.0, 2.5)
            if nodeCheck  then
                node = _node
                heading = _heading
                break
            else
                index = index + 3
            end
        end
        MyWagon = CreateVehicle(model, node, heading, true, false, false, false)
        Citizen.InvokeNative(0x7263332501E07F52, MyWagon, true) -- SetVehicleOnGroundProperly
        SetModelAsNoLongerNeeded(model)
    end

    MyWagonId = id
    TriggerServerEvent('bcc-wagons:RegisterInventory', MyWagonId, wagonModel)

    if Config.wagonTag then
        TriggerEvent('bcc-wagons:WagonTag')
    end
    if Config.wagonBlip then
        TriggerEvent('bcc-wagons:WagonBlip')
    end
    if Config.returnEnabled then
        TriggerEvent('bcc-wagons:WagonTarget')
    end
    TriggerEvent('bcc-wagons:WagonActions')
end

-- Set Wagon Name Above Wagon
AddEventHandler('bcc-wagons:WagonTag', function()
    local playerPed = PlayerPedId()
    local tagDist = Config.tagDistance
    local gamerTagId = Citizen.InvokeNative(0xE961BF23EAB76B12, MyWagon, MyWagonName) -- CreateMpGamerTagOnEntity
    while MyWagon do
        Wait(1000)
        local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(MyWagon))
        if dist <= tagDist and not Citizen.InvokeNative(0xEC5F66E459AF3BB2, playerPed, MyWagon) then -- IsPedOnSpecificVehicle
            Citizen.InvokeNative(0x93171DDDAB274EB8, gamerTagId, 3) -- SetMpGamerTagVisibility
        else
            if Citizen.InvokeNative(0x502E1591A504F843, gamerTagId, MyWagon) then -- IsMpGamerTagActiveOnEntity
                Citizen.InvokeNative(0x93171DDDAB274EB8, gamerTagId, 0) -- SetMpGamerTagVisibility
            end
        end
    end
    Citizen.InvokeNative(0x839BFD7D7E49FE09, Citizen.PointerValueIntInitialized(gamerTagId)) -- RemoveMpGamerTag
end)

-- Set Blip on Spawned Wagon when Empty
AddEventHandler('bcc-wagons:WagonBlip', function()
    local playerPed = PlayerPedId()
    local wagonBlip
    while MyWagon do
        Wait(1000)
        if Citizen.InvokeNative(0xEC5F66E459AF3BB2, playerPed, MyWagon) then -- IsPedOnSpecificVehicle
            if wagonBlip then
                RemoveBlip(wagonBlip)
                wagonBlip = nil
            end
        else
            if not wagonBlip then
                wagonBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1749618580, MyWagon) -- BlipAddForEntity
                SetBlipSprite(wagonBlip, joaat(Config.wagonBlipSprite), true)
                Citizen.InvokeNative(0x9CB1A1623062F402, wagonBlip, MyWagonName) -- SetBlipNameFromPlayerString
            end
        end
    end
end)

-- Sell Player Owned Wagons
RegisterNUICallback('SellWagon', function(data, cb)
    cb('ok')
    DeleteEntity(MyEntity)
    Cam = false
    local wagonSold = ClientRPC.Callback.TriggerAwait('bcc-wagons:SellMyWagon', data, Shop)
    if wagonSold then
        WagonMenu()
    end
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
function WagonMenu()
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
end

-- Call Selected Wagon
CreateThread(function()
    if Config.callEnabled then
        local callKey = Config.keys.call
        while true do
            Wait(0)
            if Citizen.InvokeNative(0x580417101DDB492F, 2, callKey) then -- IsControlJustPressed
                if MyWagon then
                    local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(MyWagon))
                    if dist >= Config.callDist then
                        GetSelectedWagon()
                    else
                        VORPcore.NotifyRightTip(_U('tooClose'), 5000)
                    end
                else
                    GetSelectedWagon()
                end
            end
        end
    end
end)

-- Wagon Actions
AddEventHandler('bcc-wagons:WagonActions', function()
    local invKey = Config.keys.inv
    while MyWagon do
        Wait(0)
        -- Open Wagon Inventory
        if Citizen.InvokeNative(0x580417101DDB492F, 2, invKey) then -- IsControlJustPressed
            local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(MyWagon))
            if dist <= Config.invDist then
                TriggerServerEvent('bcc-wagons:OpenInventory', MyWagonId)
            end
        end
    end
end)

-- Return Wagon Using Prompt at Shop Location
function ReturnWagon()
    if MyWagon then
        DeleteEntity(MyWagon)
        MyWagon = nil
        VORPcore.NotifyRightTip(_U('wagonReturned'), 4000)
    else
        VORPcore.NotifyRightTip(_U('noWagonReturn'), 4000)
    end
end

-- Target Menu Wagon Return
AddEventHandler('bcc-wagons:WagonTarget', function()
    local playerPed = PlayerPedId()
    local player = PlayerId()
    local returnDist = Config.returnDist
    while MyWagon do
        local sleep = 1000
        local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(MyWagon))
        if dist <= returnDist then
            Citizen.InvokeNative(0x05254BA0B44ADC16, MyWagon, true) -- SetVehicleCanBeTargetted
            if not Citizen.InvokeNative(0xEC5F66E459AF3BB2, playerPed, MyWagon) then -- IsPedOnSpecificVehicle
                local _, targetEntity = GetPlayerTargetEntity(player)
                if Citizen.InvokeNative(0x27F89FDC16688A7A, player, MyWagon, 0) then -- IsPlayerTargettingEntity
                    sleep = 0
                    local wagonGroup = Citizen.InvokeNative(0xB796970BD125FCE8, targetEntity) -- PromptGetGroupIdForTargetEntity
                    TriggerEvent('bcc-wagons:TargetReturn', wagonGroup)
                    if Citizen.InvokeNative(0x580417101DDB492F, 2, Config.keys.targetRet) then -- IsControlJustPressed
                        DoScreenFadeOut(100)
                        Wait(100)
                        DeleteEntity(MyWagon)
                        MyWagon = nil
                        Wait(100)
                        DoScreenFadeIn(100)
                    end
                end
            end
        else
            Citizen.InvokeNative(0x05254BA0B44ADC16, MyWagon, false) -- SetVehicleCanBeTargetted
        end
        Wait(sleep)
    end
end)

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
    PointCamAtCoord(wagonCam, shopCfg.spawnPos.x, shopCfg.spawnPos.y, shopCfg.spawnPos.z)
    DoScreenFadeOut(500)
    Wait(500)
    DoScreenFadeIn(500)
    RenderScriptCams(true, false, 0, false, false, 0)
    Citizen.InvokeNative(0x67C540AA08E4A6F5, 'Leaderboard_Show', 'MP_Leaderboard_Sounds', true, 0) -- PlaySoundFrontend
end

function CameraLighting()
    local shopCfg = Config.shops[Shop]
    while Cam do
        Wait(0)
        Citizen.InvokeNative(0xD2D9E04C0DF927F4, shopCfg.spawnPos.x, shopCfg.spawnPos.y, shopCfg.spawnPos.z + 3, 130, 130, 85, 4.0, 15.0) -- DrawLightWithRange
    end
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

RegisterCommand('wagonEnter', function()
    if MyWagon then
        DoScreenFadeOut(500)
        Wait(500)
        SetPedIntoVehicle(PlayerPedId(), MyWagon, -1)
        Wait(500)
        DoScreenFadeIn(500)
    else
        VORPcore.NotifyRightTip(_U('noWagon'), 4000)
    end
end, false)

RegisterCommand('wagonReturn', function()
    if Config.returnEnabled then
        ReturnWagon()
    else
        VORPcore.NotifyRightTip(_U('noReturn'), 4000)
    end
end)

-- Menu Prompts
function StartPrompts()
    local shopStr = CreateVarString(10, 'LITERAL_STRING', _U('shopPrompt'))
    OpenShops = PromptRegisterBegin()
    PromptSetControlAction(OpenShops, Config.keys.shop)
    PromptSetText(OpenShops, shopStr)
    PromptSetVisible(OpenShops, 1)
    PromptSetStandardMode(OpenShops, 1)
    PromptSetGroup(OpenShops, PromptGroup)
    PromptRegisterEnd(OpenShops)

    local returnStr = CreateVarString(10, 'LITERAL_STRING', _U('returnPrompt'))
    OpenReturn = PromptRegisterBegin()
    PromptSetControlAction(OpenReturn, Config.keys.ret)
    PromptSetText(OpenReturn, returnStr)
    PromptSetVisible(OpenReturn, 1)
    PromptSetStandardMode(OpenReturn, 1)
    PromptSetGroup(OpenReturn, PromptGroup)
    PromptRegisterEnd(OpenReturn)
end

AddEventHandler('bcc-wagons:TargetReturn', function(wagonGroup)
    local str = CreateVarString(10, 'LITERAL_STRING', _U('returnPrompt'))
    local targetReturn = PromptRegisterBegin()
    PromptSetControlAction(targetReturn, Config.keys.targetRet)
    PromptSetText(targetReturn, str)
    PromptSetEnabled(targetReturn, 1)
    PromptSetVisible(targetReturn, 1)
    PromptSetHoldMode(targetReturn, 1)
    PromptSetGroup(targetReturn, wagonGroup)
    PromptRegisterEnd(targetReturn)
end)

-- Blips
function AddBlip(shop)
    local shopCfg = Config.shops[shop]
    shopCfg.Blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, shopCfg.npcPos) -- BlipAddForCoords
    SetBlipSprite(shopCfg.Blip, shopCfg.blipSprite, true)
    SetBlipScale(shopCfg.Blip, 0.2)
    Citizen.InvokeNative(0x9CB1A1623062F402, shopCfg.Blip, shopCfg.blipName) -- SetBlipName
end

-- NPCs
function AddNPC(shop)
    local shopCfg = Config.shops[shop]
    LoadModel(shopCfg.npcModel)
    shopCfg.NPC = CreatePed(shopCfg.npcModel, shopCfg.npcPos.x, shopCfg.npcPos.y, shopCfg.npcPos.z - 1.0, shopCfg.npcHeading, false, true, true, true)
    Citizen.InvokeNative(0x283978A15512B2FE, shopCfg.NPC, true) -- SetRandomOutfitVariation
    SetEntityCanBeDamaged(shopCfg.NPC, false)
    SetEntityInvincible(shopCfg.NPC, true)
    Wait(500)
    FreezeEntityPosition(shopCfg.NPC, true)
    SetBlockingOfNonTemporaryEvents(shopCfg.NPC, true)
end

function LoadModel(npcModel)
    local model = joaat(npcModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if InMenu then
        SendNUIMessage({
            action = 'hide'
        })
        SetNuiFocus(false, false)
    end
    ClearPedTasksImmediately(PlayerPedId())
    DestroyAllCams(true)
    DisplayRadar(true)

    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end
    if MyWagon then
        DeleteEntity(MyWagon)
        MyWagon = nil
    end

    for _, shopCfg in pairs(Config.shops) do
        if shopCfg.Blip then
            RemoveBlip(shopCfg.Blip)
            shopCfg.Blip = nil
        end
        if shopCfg.NPC then
            DeleteEntity(shopCfg.NPC)
            shopCfg.NPC = nil
        end
    end
end)
