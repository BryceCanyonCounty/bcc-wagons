local VORPcore = exports.vorp_core:GetCore()
-- Prompts
local OpenShops, OpenReturn
local PromptGroup = GetRandomIntInRange(0, 0xffffff)
local TradeWagon
local TradeGroup = GetRandomIntInRange(0, 0xffffff)
local TargetReturn, TargetTrade = nil, nil
local PromptsStarted = false
-- Wagons
local ShopName, ShopEntity, Site
local MyEntity, MyWagonId, MyWagonName
local MyWagon = nil
local InMenu = false
local Cam = false
local HasJob = false
local IsWainwright = false
local Trading = false

CreateThread(function()
    StartPrompts()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleep = 1000
        local hour = GetClockHours()

        if InMenu or IsEntityDead(playerPed) then goto END end

        for site, siteCfg in pairs(Sites) do
            local distance = #(playerCoords - siteCfg.npc.coords)

            -- Shop Closed
            if (siteCfg.shop.hours.active and hour >= siteCfg.shop.hours.close) or (siteCfg.shop.hours.active and hour < siteCfg.shop.hours.open) then
                ManageBlip(site, true)
                RemoveNPC(site)
                if distance <= siteCfg.shop.distance then
                    sleep = 0
                    PromptSetActiveGroupThisFrame(PromptGroup, CreateVarString(10, 'LITERAL_STRING', siteCfg.shop.name .. _U('hours') ..
                    siteCfg.shop.hours.open .. _U('to') .. siteCfg.shop.hours.close .. _U('hundred')))
                    PromptSetEnabled(OpenShops, false)
                    PromptSetEnabled(OpenReturn, false)
                end

            -- Shop Open
            else
                ManageBlip(site, false)
                if distance <= siteCfg.npc.distance then
                    if siteCfg.npc.active then
                        AddNPC(site)
                    end
                else
                    RemoveNPC(site)
                end
                if distance <= siteCfg.shop.distance then
                    sleep = 0
                    PromptSetActiveGroupThisFrame(PromptGroup, CreateVarString(10, 'LITERAL_STRING', siteCfg.shop.prompt))
                    PromptSetEnabled(OpenShops, true)
                    PromptSetEnabled(OpenReturn, true)

                    if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                        CheckPlayerJob(false, site)
                        if siteCfg.shop.jobsEnabled then
                            if not HasJob then goto END end
                        end
                        OpenMenu(site)
                    elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                        if siteCfg.shop.jobsEnabled then
                            CheckPlayerJob(false, site)
                            if not HasJob then goto END end
                        end
                        ReturnWagon()
                    end
                end
            end
        end
        ::END::
        Wait(sleep)
    end
end)

function OpenMenu(site)
    DisplayRadar(false)
    InMenu = true
    Site = site
    ShopName = Sites[Site].shop.name

    ResetWagon()
    CreateCamera()

    SendNUIMessage({
        action = 'show',
        shopData = JobMatchedWagons,
        location = ShopName,
        currencyType = Config.currencyType
    })
    SetNuiFocus(true, true)
    TriggerServerEvent('bcc-wagons:GetMyWagons')
end

RegisterNetEvent('bcc-wagons:WagonsData', function(wagonsData)
    SendNUIMessage({
        action = 'updateMyWagons',
        myWagonsData = wagonsData
    })
end)

RegisterNUICallback('LoadWagon', function(data, cb)
    cb('ok')
    if MyEntity then
        DeleteEntity(MyEntity)
        MyEntity = nil
    end

    local model = joaat(data.WagonModel)
    LoadWagonModel(model, data.WagonModel)

    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end

    local siteCfg = Sites[Site]
    ShopEntity = CreateVehicle(model, siteCfg.wagon.coords, siteCfg.wagon.heading, false, false, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, ShopEntity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, ShopEntity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(model)
    if not Cam then
        Cam = true
        CameraLighting()
    end
end)

RegisterNUICallback('BuyWagon', function(data, cb)
    cb('ok')
    CheckPlayerJob(true)
    if Sites[Site].wainwrightBuy and not IsWainwright then
        VORPcore.NotifyRightTip(_U('wainwrightBuyWagon'), 4000)
        WagonMenu()
        return
    end
    if IsWainwright then
        data.isWainwright = true
    else
        data.isWainwright = false
    end
    local canBuy = VORPcore.Callback.TriggerAwait('bcc-wagons:BuyWagon', data)
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
                    local nameSaved = VORPcore.Callback.TriggerAwait('bcc-wagons:UpdateWagonName', wagonInfo)
                    if nameSaved then
                        WagonMenu()
                    end
                    return
                else
                    local wagonSaved = VORPcore.Callback.TriggerAwait('bcc-wagons:SaveNewWagon', wagonInfo)
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
            shopData = Wagons,
            location = ShopName,
            currencyType = Config.currencyType
        })
        SetNuiFocus(true, true)
        TriggerServerEvent('bcc-wagons:GetMyWagons')
    end)
end

RegisterNUICallback('RenameWagon', function(data, cb)
    cb('ok')
    SetWagonName(data, true)
end)

RegisterNUICallback('LoadMyWagon', function(data, cb)
    cb('ok')
    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end

    local model = joaat(data.WagonModel)
    LoadWagonModel(model, data.WagonModel)

    if MyEntity then
        DeleteEntity(MyEntity)
        MyEntity = nil
    end

    local siteCfg = Sites[Site]
    MyEntity = CreateVehicle(model, siteCfg.wagon.coords, siteCfg.wagon.heading, false, false, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, MyEntity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, MyEntity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(model)
    if not Cam then
        Cam = true
        CameraLighting()
    end
end)

RegisterNUICallback('SelectWagon', function(data, cb)
    cb('ok')
    TriggerServerEvent('bcc-wagons:SelectWagon', data)
end)

function GetSelectedWagon()
    local data = VORPcore.Callback.TriggerAwait('bcc-wagons:GetWagonData')
    if data then
        SpawnWagon(data.model, data.name, false, data.id)
    end
end

RegisterNUICallback('SpawnInfo', function(data, cb)
    cb('ok')
    SpawnWagon(data.WagonModel, data.WagonName, true, data.WagonId)
end)

function SpawnWagon(wagonModel, name, menuSpawn, id)
    ResetWagon()
    MyWagonName = name
    local model = joaat(wagonModel)
    LoadWagonModel(model, wagonModel)

    if menuSpawn then
        local siteCfg = Sites[Site]
        MyWagon = CreateVehicle(model, siteCfg.wagon.coords, siteCfg.wagon.heading, true, false, false, false)
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

RegisterNUICallback('SellWagon', function(data, cb)
    cb('ok')
    DeleteEntity(MyEntity)
    Cam = false
    local wagonSold = VORPcore.Callback.TriggerAwait('bcc-wagons:SellMyWagon', data, Site)
    if wagonSold then
        WagonMenu()
    end
end)

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
        shopData = Wagons,
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

AddEventHandler('bcc-wagons:WagonActions', function()
    while MyWagon do
        Wait(0)
        -- Open Wagon Inventory
        if Citizen.InvokeNative(0x580417101DDB492F, 2, Config.keys.inv) then -- IsControlJustPressed
            local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(MyWagon))
            if dist <= Config.inventory.distance then
                TriggerServerEvent('bcc-wagons:OpenInventory', MyWagonId)
            end
        end
    end
end)

-- Return Wagon Using Prompt at Shop Location
function ReturnWagon()
    if MyWagon then
        ResetWagon()
        VORPcore.NotifyRightTip(_U('wagonReturned'), 4000)
    else
        VORPcore.NotifyRightTip(_U('noWagonReturn'), 4000)
    end
end

AddEventHandler('bcc-wagons:WagonTarget', function()
    local playerPed = PlayerPedId()
    local player = PlayerId()
    local targetDist = Config.targetDist
    while MyWagon do
        local sleep = 1000
        local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(MyWagon))
        if dist > targetDist or Citizen.InvokeNative(0xEC5F66E459AF3BB2, playerPed, MyWagon) then -- IsPedOnSpecificVehicle
            Citizen.InvokeNative(0x05254BA0B44ADC16, MyWagon, false) -- SetVehicleCanBeTargetted
            goto END
        end
        Citizen.InvokeNative(0x05254BA0B44ADC16, MyWagon, true) -- SetVehicleCanBeTargetted
        if Citizen.InvokeNative(0x27F89FDC16688A7A, player, MyWagon, 0) then -- IsPlayerTargettingEntity
            sleep = 0
            local wagonGroup = Citizen.InvokeNative(0xB796970BD125FCE8, MyWagon) -- PromptGetGroupIdForTargetEntity
            TriggerEvent('bcc-wagons:TargetPrompts', wagonGroup)

            if Citizen.InvokeNative(0x580417101DDB492F, 0, Config.keys.targetRet) then -- IsControlJustPressed
                DoScreenFadeOut(500)
                Wait(500)
                ResetWagon()
                Wait(500)
                DoScreenFadeIn(500)

            elseif Citizen.InvokeNative(0x580417101DDB492F, 0, Config.keys.targetTrade) then -- IsControlJustPressed
                VORPcore.NotifyRightTip(_U('readyToTrade'), 4000)
                Trading = true
                TriggerEvent('bcc-wagons:TradeWagon')
            end
        end
        ::END::
        Wait(sleep)
    end
end)

AddEventHandler('bcc-wagons:TradeWagon', function()
    while Trading do
        local playerPed = PlayerPedId()
        local sleep = 1000

        if IsEntityDead(playerPed) then
            Trading = false
            break
        end

        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer and closestDistance <= 2.0 then
            sleep = 0
            PromptSetActiveGroupThisFrame(TradeGroup, CreateVarString(10, 'LITERAL_STRING', MyWagonName))
            PromptSetEnabled(TradeWagon, true)
            if Citizen.InvokeNative(0xE0F65F0640EF0617, TradeWagon) then  -- PromptHasHoldModeCompleted
                local serverId = GetPlayerServerId(closestPlayer)
                local tradeComplete = VORPcore.Callback.TriggerAwait('bcc-wagons:SaveWagonTrade', serverId, MyWagonId)
                if tradeComplete then
                    ResetWagon()
                end
                Trading = false
            end
        end
        Wait(sleep)
    end
end)

function GetClosestPlayer()
    local players = GetActivePlayers()
    local player = PlayerId()
    local coords = GetEntityCoords(PlayerPedId())
    local closestDistance = nil
    local closestPlayer = nil
    for i = 1, #players, 1 do
        local target = GetPlayerPed(players[i])
        if players[i] ~= player then
            local distance = #(coords - GetEntityCoords(target))
            if closestDistance == nil or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

function ResetWagon()
    if MyWagon then
        DeleteEntity(MyWagon)
        MyWagon = nil
    end
    PromptsStarted = false
    TargetReturn = nil
    TargetTrade = nil
    Trading = false
end

function LoadWagonModel(model, modelName)
    if not IsModelValid(model) then
        return print('Invalid model:', modelName)
    end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

-- Camera to View Wagons
function CreateCamera()
    local siteCfg = Sites[Site]
    local wagonCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(wagonCam, siteCfg.wagon.camera.x, siteCfg.wagon.camera.y, siteCfg.wagon.camera.z + 2.0)
    SetCamActive(wagonCam, true)
    PointCamAtCoord(wagonCam, siteCfg.wagon.coords.x, siteCfg.wagon.coords.y, siteCfg.wagon.coords.z)
    DoScreenFadeOut(500)
    Wait(500)
    DoScreenFadeIn(500)
    RenderScriptCams(true, false, 0, false, false, 0)
    Citizen.InvokeNative(0x67C540AA08E4A6F5, 'Leaderboard_Show', 'MP_Leaderboard_Sounds', true, 0) -- PlaySoundFrontend
end

function CameraLighting()
    local siteCfg = Sites[Site]
    while Cam do
        Wait(0)
        Citizen.InvokeNative(0xD2D9E04C0DF927F4, siteCfg.wagon.coords.x, siteCfg.wagon.coords.y, siteCfg.wagon.coords.z + 3, 130, 130, 85, 4.0, 15.0) -- DrawLightWithRange
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

function CheckPlayerJob(wainwright, site)
    local result = VORPcore.Callback.TriggerAwait('bcc-wagons:CheckJob', wainwright, site)
    if wainwright and result then
        IsWainwright = false
        if result[1] then
            IsWainwright = true
        end
    elseif result then
        HasJob = false
        if result[1] then
            HasJob = true
        elseif Sites[site].shop.jobsEnabled then
            VORPcore.NotifyRightTip(_U('needJob'), 4000)
        end
        JobMatchedWagons = FindWagonsByJob(result[2])
    end
end

RegisterCommand(Config.commands.wagonEnter, function()
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

RegisterCommand(Config.commands.wagonReturn, function()
    if Config.returnEnabled then
        ReturnWagon()
    else
        VORPcore.NotifyRightTip(_U('noReturn'), 4000)
    end
end)

function StartPrompts()
    OpenShops = PromptRegisterBegin()
    PromptSetControlAction(OpenShops, Config.keys.shop)
    PromptSetText(OpenShops, CreateVarString(10, 'LITERAL_STRING', _U('shopPrompt')))
    PromptSetVisible(OpenShops, true)
    PromptSetStandardMode(OpenShops, true)
    PromptSetGroup(OpenShops, PromptGroup)
    PromptRegisterEnd(OpenShops)

    OpenReturn = PromptRegisterBegin()
    PromptSetControlAction(OpenReturn, Config.keys.ret)
    PromptSetText(OpenReturn, CreateVarString(10, 'LITERAL_STRING', _U('returnPrompt')))
    PromptSetVisible(OpenReturn, true)
    PromptSetStandardMode(OpenReturn, true)
    PromptSetGroup(OpenReturn, PromptGroup)
    PromptRegisterEnd(OpenReturn)

    TradeWagon = PromptRegisterBegin()
    PromptSetControlAction(TradeWagon, Config.keys.trade)
    PromptSetText(TradeWagon, CreateVarString(10, 'LITERAL_STRING', _U('tradePrompt')))
    PromptSetVisible(TradeWagon, true)
    PromptSetHoldMode(TradeWagon, 2000)
    PromptSetGroup(TradeWagon, TradeGroup)
    PromptRegisterEnd(TradeWagon)
end

AddEventHandler('bcc-wagons:TargetPrompts', function(wagonGroup)
    if not PromptsStarted then
        TargetReturn = PromptRegisterBegin()
        PromptSetControlAction(TargetReturn, Config.keys.targetRet)
        PromptSetText(TargetReturn, CreateVarString(10, 'LITERAL_STRING', _U('returnPrompt')))
        PromptSetEnabled(TargetReturn, true)
        PromptSetVisible(TargetReturn, true)
        PromptSetStandardMode(TargetReturn, true)
        PromptSetGroup(TargetReturn, wagonGroup)
        PromptRegisterEnd(TargetReturn)

        TargetTrade = PromptRegisterBegin()
        PromptSetControlAction(TargetTrade, Config.keys.targetTrade)
        PromptSetText(TargetTrade, CreateVarString(10, 'LITERAL_STRING', _U('targetTradePrompt')))
        PromptSetEnabled(TargetTrade, true)
        PromptSetVisible(TargetTrade, true)
        PromptSetStandardMode(TargetTrade, true)
        PromptSetGroup(TargetTrade, wagonGroup)
        PromptRegisterEnd(TargetTrade)

        PromptsStarted = true
    end
end)

function ManageBlip(site, closed)
    local siteCfg = Sites[site]

    if closed and not siteCfg.blip.show.closed then
        if Sites[site].Blip then
            RemoveBlip(Sites[site].Blip)
            Sites[site].Blip = nil
        end
        return
    end

    if not Sites[site].Blip then
        siteCfg.Blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, siteCfg.npc.coords) -- BlipAddForCoords
        SetBlipSprite(siteCfg.Blip, siteCfg.blip.sprite, true)
        Citizen.InvokeNative(0x9CB1A1623062F402, siteCfg.Blip, siteCfg.blip.name) -- SetBlipNameFromPlayerString
    end

    local color = siteCfg.blip.color.open
    if siteCfg.shop.jobsEnabled then color = siteCfg.blip.color.job end
    if closed then color = siteCfg.blip.color.closed end
    Citizen.InvokeNative(0x662D364ABF16DE2F, Sites[site].Blip, joaat(Config.BlipColors[color])) -- BlipAddModifier
end

function AddNPC(site)
    local siteCfg = Sites[site]
    if not siteCfg.NPC then
        local modelName = siteCfg.npc.model
        local model = joaat(modelName)
        LoadModel(model, modelName)
        siteCfg.NPC = CreatePed(model, siteCfg.npc.coords.x, siteCfg.npc.coords.y, siteCfg.npc.coords.z - 1.0, siteCfg.npc.heading, false, false, false, false)
        Citizen.InvokeNative(0x283978A15512B2FE, siteCfg.NPC, true) -- SetRandomOutfitVariation
        SetEntityCanBeDamaged(siteCfg.NPC, false)
        SetEntityInvincible(siteCfg.NPC, true)
        Wait(500)
        FreezeEntityPosition(siteCfg.NPC, true)
        SetBlockingOfNonTemporaryEvents(siteCfg.NPC, true)
    end
end

function RemoveNPC(site)
    local siteCfg = Sites[site]
    if siteCfg.NPC then
        DeleteEntity(siteCfg.NPC)
        siteCfg.NPC = nil
    end
end

function LoadModel(model, modelName)
    if not IsModelValid(model) then
        return print('Invalid model:', modelName)
    end
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

    for _, siteCfg in pairs(Sites) do
        if siteCfg.Blip then
            RemoveBlip(siteCfg.Blip)
            siteCfg.Blip = nil
        end
        if siteCfg.NPC then
            DeleteEntity(siteCfg.NPC)
            siteCfg.NPC = nil
        end
    end
end)

-- to count length of maps
local function len(t)
    local counter = 0
    for _, _ in pairs(t) do
        counter += 1
    end
    return counter
end

--let's go fancy with an implementation that orders pairs for you using default table.sort(). Taken from a lua-users post.
local function __genOrderedIndex(t)
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert(orderedIndex, key)
    end
    table.sort(orderedIndex)
    return orderedIndex
end

local function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.
    local key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex(t)
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1, #(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i + 1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

local function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end

 function FindWagonsByJob(job)
    local matchingWagons = {}
    for _, wagonType in ipairs(Wagons) do
        local matchingModels = {}
        for wagonModel, wagonModelData in orderedPairs(wagonType.types) do
            -- using maps to break a loop, though technically making another loop, albeit simpler. Preferably you already configure jobs as a map so that you could expand
            -- perhaps when a request comes to have color accesses by job grade or similar
            local wagonJobs = {}
            for _, wagonJob in pairs(wagonModelData.job) do
                wagonJobs[wagonJob] = wagonJob
            end
            -- add matching color directly 
            if wagonJobs[job] ~= nil then
                matchingModels[wagonModel] = {
                    label = wagonModelData.label,
                    cashPrice = wagonModelData.cashPrice,
                    goldPrice = wagonModelData.goldPrice,
                    invLimit = wagonModelData.invLimit,
                    job = wagonModelData.job
                }
            end
            --handle case where there isn\t a job attached to horse color config
            if len(wagonJobs) == 0 then
                matchingModels[wagonModel] = {
                    label = wagonModelData.label,
                    cashPrice = wagonModelData.cashPrice,
                    goldPrice = wagonModelData.goldPrice,
                    invLimit = wagonModelData.invLimit,
                    job = nil
                }
            end
        end

        if len(matchingModels) > 0 then
            matchingWagons[#matchingWagons + 1] = {
                name = wagonType.name,
                types = matchingModels
            }
        end
    end
    return matchingWagons
end