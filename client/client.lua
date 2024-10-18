Core = exports.vorp_core:GetCore()
-- Prompts
local ShopPrompt, ReturnPrompt
local ShopGroup = GetRandomIntInRange(0, 0xffffff)
local TradePrompt
local TradeGroup = GetRandomIntInRange(0, 0xffffff)
local LootPrompt
local LootGroup = GetRandomIntInRange(0, 0xffffff)
local WagonMenuPrompt, BrakePrompt
local WagonGroup = GetRandomIntInRange(0, 0xffffff)
local ActionPrompt
local ActionGroup = GetRandomIntInRange(0, 0xffffff)
local PromptsStarted = false
-- Wagons
local MyEntity, ShopName, ShopEntity, Site, Speed, Format
local InMenu = false
local Cam = false
local HasJob = false
local IsWainwright = false
MyWagon, MyWagonId, MyWagonName, MyWagonModel = 0, nil, nil, nil
WagonCfg, RepairLevel = {}, 0
IsWagonDamaged, IsBrakeSet, Trading = false, false, false

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
                    PromptSetActiveGroupThisFrame(ShopGroup, CreateVarString(10, 'LITERAL_STRING', siteCfg.shop.name .. _U('hours') ..
                    siteCfg.shop.hours.open .. _U('to') .. siteCfg.shop.hours.close .. _U('hundred')))
                    PromptSetEnabled(ShopPrompt, false)
                    PromptSetEnabled(ReturnPrompt, false)
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
                    PromptSetActiveGroupThisFrame(ShopGroup, CreateVarString(10, 'LITERAL_STRING', siteCfg.shop.prompt))
                    PromptSetEnabled(ShopPrompt, true)
                    PromptSetEnabled(ReturnPrompt, true)

                    if Citizen.InvokeNative(0xC92AC953F0A982AE, ShopPrompt) then -- UiPromptHasStandardModeCompleted
                        CheckPlayerJob(false, site)
                        if siteCfg.shop.jobsEnabled then
                            if not HasJob then goto END end
                        end
                        OpenMenu(site)
                    elseif Citizen.InvokeNative(0xC92AC953F0A982AE, ReturnPrompt) then -- UiPromptHasStandardModeCompleted
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

    local model = data.WagonModel
    local hash = joaat(model)
    LoadModel(hash, model)

    -- local seats = Citizen.InvokeNative(0x9A578736FF3A17C3, hash) -- GetVehicleModelNumberOfSeats
    -- if seats >= 1 then
    --     Core.NotifyRightTip('Seats: ' .. tostring(seats), 4000)
    -- end

    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end

    local siteCfg = Sites[Site]
    ShopEntity = CreateVehicle(hash, siteCfg.wagon.coords, siteCfg.wagon.heading, false, false, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, ShopEntity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, ShopEntity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(hash)
    if not Cam then
        Cam = true
        CameraLighting()
    end

    -- local passengers = Citizen.InvokeNative(0xA9C55F1C15E62E06, ShopEntity) -- GetVehicleMaxNumberOfPassengers
    -- if passengers >= 1 then
    --     Core.NotifyRightTip('Passengers: ' .. tostring(passengers), 4000)
    -- end

end)

RegisterNUICallback('BuyWagon', function(data, cb)
    cb('ok')
    CheckPlayerJob(true)
    if Sites[Site].wainwrightBuy and not IsWainwright then
        Core.NotifyRightTip(_U('wainwrightBuyWagon'), 4000)
        WagonMenu()
        return
    end
    if IsWainwright then
        data.isWainwright = true
    else
        data.isWainwright = false
    end
    local canBuy = Core.Callback.TriggerAwait('bcc-wagons:BuyWagon', data)
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
                    local nameSaved = Core.Callback.TriggerAwait('bcc-wagons:UpdateWagonName', wagonInfo)
                    if nameSaved then
                        WagonMenu()
                    end
                    return
                else
                    local wagonSaved = Core.Callback.TriggerAwait('bcc-wagons:SaveNewWagon', wagonInfo)
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

    local model = data.WagonModel
    local hash = joaat(model)
    LoadModel(hash, model)

    if MyEntity then
        DeleteEntity(MyEntity)
        MyEntity = nil
    end

    local siteCfg = Sites[Site]
    MyEntity = CreateVehicle(hash, siteCfg.wagon.coords, siteCfg.wagon.heading, false, false, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, MyEntity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, MyEntity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(hash)
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
    local data = Core.Callback.TriggerAwait('bcc-wagons:GetWagonData')
    if data then
        SpawnWagon(data.model, data.name, false, data.id)
    end
end

local function SetWagonDamaged()
    if MyWagon == 0 then return end
    IsWagonDamaged = true
    Core.NotifyRightTip(_U('needRepairs'), 4000)
    Citizen.InvokeNative(0x260BE8F09E326A20, MyWagon, 10.0, 2000, true) -- BringVehicleToHalt
    IsBrakeSet = true
    PromptSetText(BrakePrompt, CreateVarString(10, 'LITERAL_STRING', _U('brakeOff')))
end

RegisterNUICallback('SpawnInfo', function(data, cb)
    cb('ok')
    SpawnWagon(data.WagonModel, data.WagonName, true, data.WagonId)
end)

function SpawnWagon(wagonModel, wagonName, menuSpawn, wagonId)
    ResetWagon()

    for _, wagonModels in pairs(Wagons) do
        for model, wagonConfig in pairs(wagonModels.types) do
            if model == wagonModel then
                WagonCfg = wagonConfig
                break
            end
        end
    end

    MyWagonModel = wagonModel
    MyWagonName = wagonName
    MyWagonId = wagonId
    local hash = joaat(wagonModel)
    LoadModel(hash, wagonModel)

    if menuSpawn then
        local siteCfg = Sites[Site]
        MyWagon = CreateVehicle(hash, siteCfg.wagon.coords, siteCfg.wagon.heading, true, false, false, false)
        Citizen.InvokeNative(0x7263332501E07F52, MyWagon, true) -- SetVehicleOnGroundProperly
        SetModelAsNoLongerNeeded(hash)
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
        MyWagon = CreateVehicle(hash, node, heading, true, false, false, false)
        Citizen.InvokeNative(0x7263332501E07F52, MyWagon, true) -- SetVehicleOnGroundProperly
        SetModelAsNoLongerNeeded(hash)
    end

    Citizen.InvokeNative(0xD0E02AA618020D17, PlayerId(), MyWagon) -- SetPlayerOwnsVehicle
    Citizen.InvokeNative(0xE2487779957FE897, MyWagon, 528) -- SetTransportUsageFlags

    if WagonCfg.inventory.enabled then
        TriggerServerEvent('bcc-wagons:RegisterInventory', MyWagonId, wagonModel)
        if WagonCfg.inventory.shared then
            Entity(MyWagon).state:set('myWagonId', MyWagonId, true)
        end
    end

    if WagonCfg.gamerTag.enabled then
        TriggerEvent('bcc-wagons:WagonTag')
    end

    if WagonCfg.blip.enabled then
        TriggerEvent('bcc-wagons:WagonBlip')
    end

    if WagonCfg.brakeSet then
        Citizen.InvokeNative(0x260BE8F09E326A20, MyWagon, 0.0, 2000, true) -- BringVehicleToHalt
        IsBrakeSet = true
    end

    if WagonCfg.condition.enabled then
        RepairLevel = GetCondition()
        if RepairLevel < WagonCfg.condition.decreaseValue then
            SetWagonDamaged()
        end
        TriggerEvent('bcc-wagons:RepairMonitor')
    end

    TriggerEvent('bcc-wagons:SpeedMonitor')

    TriggerEvent('bcc-wagons:WagonPrompts')
end

-- Loot Players Wagon Inventory
CreateThread(function()
    while true do
        local vehicle, wagonId, owner = nil, nil, nil
        local isWagon = false
        local playerPed = PlayerPedId()
        local coords = (GetEntityCoords(playerPed))
        local sleep = 1000

        if (IsEntityDead(playerPed)) or (not IsPedOnFoot(playerPed)) then goto END end

        vehicle = Citizen.InvokeNative(0x52F45D033645181B, coords.x, coords.y, coords.z, 3.0, 0, 70, Citizen.ResultAsInteger()) -- GetClosestVehicle
        if (vehicle == 0) or (vehicle == MyWagon) then goto END end

        isWagon = Citizen.InvokeNative(0xEA44E97849E9F3DD, vehicle) -- IsDraftVehicle
        if not isWagon then goto END end

        owner = Citizen.InvokeNative(0x7C803BDC8343228D, vehicle) -- GetPlayerOwnerOfVehicle
        if owner == 255 then goto END end

        sleep = 0
        PromptSetActiveGroupThisFrame(LootGroup, CreateVarString(10, 'LITERAL_STRING', _U('lootInventory')), 1, 0, 0, 0)
        if Citizen.InvokeNative(0xC92AC953F0A982AE, LootPrompt) then  -- PromptHasStandardModeCompleted
            wagonId = Entity(vehicle).state.myWagonId
            TriggerServerEvent('bcc-wagons:OpenInventory', wagonId)
        end
        ::END::
        Wait(sleep)
    end
end)

AddEventHandler('bcc-wagons:RepairMonitor', function()
    local decreaseTime = (WagonCfg.condition.decreaseTime * 1000)
    local decreaseValue = WagonCfg.condition.decreaseValue
    if not IsWagonDamaged then
        Wait(decreaseTime) -- Wait after spawning wagon
    end
    while MyWagon ~= 0 do
        if RepairLevel >= decreaseValue then
            IsWagonDamaged = false
            local newLevel = Core.Callback.TriggerAwait('bcc-wagons:UpdateRepairLevel', MyWagonId, MyWagonModel)
            if newLevel then
                RepairLevel = newLevel
            end
        end
        if IsWagonDamaged then goto END end
        if RepairLevel < decreaseValue then
            SetWagonDamaged()
        end
        ::END::
        Wait(decreaseTime) -- Interval to decrease condition
    end
end)

function GetCondition()
    local condition = Core.Callback.TriggerAwait('bcc-wagons:GetRepairLevel', MyWagonId, MyWagonModel)
    if condition then
        return condition
    elseif condition == nil then
        return 0
    end
end

AddEventHandler('bcc-wagons:SpeedMonitor', function()
    local multiplier
    if Config.speed == 1 then
        multiplier = 2.23694 -- Meters per Second to Miles per Hour
        Format = '~s~mph'
    elseif Config.speed == 2 then
        multiplier = 3.6 -- Meters per Second to Kilometers per Hour
        Format = '~s~kph'
    end

    while MyWagon ~= 0 do
        Wait(1000)
        local entitySpeed = Citizen.InvokeNative(0xFB6BA510A533DF81, MyWagon, Citizen.ResultAsFloat()) -- GetEntitySpeed / Meters per Second
        Speed = math.floor(entitySpeed * multiplier)
    end
end)

AddEventHandler('bcc-wagons:WagonPrompts', function()
    StartWagonPrompts()
    local promptDist = WagonCfg.distance

    while MyWagon ~= 0 do
        local playerPed = PlayerPedId()
        local distance = #(GetEntityCoords(playerPed) - GetEntityCoords(MyWagon))
        local sleep = 1000

        if distance > promptDist then goto END end

        if IsPedInVehicle(playerPed, MyWagon, false) then
            sleep = 0

            local wagonStats = 'speed: ~o~' .. tostring(Speed) .. Format .. ' | condition: ~o~' .. tostring(RepairLevel)
            PromptSetActiveGroupThisFrame(WagonGroup, CreateVarString(10, 'LITERAL_STRING', wagonStats), 1, 0, 0, 0)

            if Citizen.InvokeNative(0xC92AC953F0A982AE, WagonMenuPrompt) then  -- PromptHasStandardModeCompleted
                OpenWagonMenu()
            end

            if Citizen.InvokeNative(0xC92AC953F0A982AE, BrakePrompt) then  -- PromptHasStandardModeCompleted
                if IsWagonDamaged then goto END end

                if not IsBrakeSet then
                    Citizen.InvokeNative(0x260BE8F09E326A20, MyWagon, 10.0, 2000, true) -- BringVehicleToHalt
                    IsBrakeSet = true
                    PromptSetText(BrakePrompt, CreateVarString(10, 'LITERAL_STRING', _U('brakeOff')))
                else
                    Citizen.InvokeNative(0x7C06330BFDDA182E, MyWagon) -- StopBringingVehicleToHalt
                    IsBrakeSet = false
                    PromptSetText(BrakePrompt, CreateVarString(10, 'LITERAL_STRING', _U('brakeOn')))
                end
            end

        else
            sleep = 0

            PromptSetActiveGroupThisFrame(ActionGroup, CreateVarString(10, 'LITERAL_STRING', MyWagonName), 1, 0, 0, 0)
            if Citizen.InvokeNative(0xC92AC953F0A982AE, ActionPrompt) then  -- PromptHasStandardModeCompleted
                OpenWagonMenu()
            end
        end
        ::END::
        Wait(sleep)
    end
end)

-- Set Wagon Name Above Wagon
AddEventHandler('bcc-wagons:WagonTag', function()
    local playerPed = PlayerPedId()
    local tagDist = WagonCfg.gamerTag.distance
    local gamerTagId = Citizen.InvokeNative(0xE961BF23EAB76B12, MyWagon, MyWagonName) -- CreateMpGamerTagOnEntity
    while MyWagon ~= 0 do
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
    while MyWagon ~= 0 do
        Wait(1000)
        if Citizen.InvokeNative(0xEC5F66E459AF3BB2, playerPed, MyWagon) then -- IsPedOnSpecificVehicle
            if wagonBlip then
                RemoveBlip(wagonBlip)
                wagonBlip = nil
            end
        else
            if not wagonBlip then
                wagonBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1749618580, MyWagon) -- BlipAddForEntity
                SetBlipSprite(wagonBlip, joaat(WagonCfg.blip.sprite), true)
                Citizen.InvokeNative(0x9CB1A1623062F402, wagonBlip, MyWagonName) -- SetBlipName
            end
        end
    end
end)

RegisterNUICallback('SellWagon', function(data, cb)
    cb('ok')
    DeleteEntity(MyEntity)
    Cam = false
    local wagonSold = Core.Callback.TriggerAwait('bcc-wagons:SellMyWagon', data)
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
                if MyWagon ~= 0 then
                    local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(MyWagon))
                    if dist >= Config.callDist then
                        GetSelectedWagon()
                    else
                        Core.NotifyRightTip(_U('tooClose'), 5000)
                    end
                else
                    GetSelectedWagon()
                end
            end
        end
    end
end)

-- Return Wagon Using Prompt at Shop Location
function ReturnWagon()
    if MyWagon ~= 0 then
        ResetWagon()
        Core.NotifyRightTip(_U('wagonReturned'), 4000)
    else
        Core.NotifyRightTip(_U('noWagonReturn'), 4000)
    end
end

AddEventHandler('bcc-wagons:TradeWagon', function()
    while Trading do
        local playerPed = PlayerPedId()
        local sleep = 1000

        if IsEntityDead(playerPed) or IsPedOnSpecificVehicle(playerPed, MyWagon) then
            Trading = false
            PromptDelete(TradePrompt)
            break
        end

        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer and closestDistance <= 2.0 then
            sleep = 0
            PromptSetActiveGroupThisFrame(TradeGroup, CreateVarString(10, 'LITERAL_STRING', MyWagonName))
            if Citizen.InvokeNative(0xE0F65F0640EF0617, TradePrompt) then  -- PromptHasHoldModeCompleted
                local serverId = GetPlayerServerId(closestPlayer)
                local tradeComplete = Core.Callback.TriggerAwait('bcc-wagons:SaveWagonTrade', serverId, MyWagonId)
                if tradeComplete then
                    ResetWagon()
                end
                Trading = false
                PromptDelete(TradePrompt)
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

local function GetControlOfWagon()
    while not NetworkHasControlOfEntity(MyWagon) do
        NetworkRequestControlOfEntity(MyWagon)
        Wait(10)
    end
end

function ResetWagon()
    if MyWagon ~= 0 then
        GetControlOfWagon()
        DeleteEntity(MyWagon)
        MyWagon = 0
    end
    PromptDelete(WagonMenuPrompt)
    PromptDelete(ActionPrompt)
    PromptDelete(BrakePrompt)
    PromptDelete(TradePrompt)
    PromptsStarted = false
    Trading = false
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
    local result = Core.Callback.TriggerAwait('bcc-wagons:CheckJob', wainwright, site)
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
            Core.NotifyRightTip(_U('needJob'), 4000)
        end
        JobMatchedWagons = FindWagonsByJob(result[2])
    end
end

RegisterCommand(Config.commands.wagonEnter, function()
    if MyWagon ~= 0 then
        DoScreenFadeOut(500)
        Wait(500)
        SetPedIntoVehicle(PlayerPedId(), MyWagon, -1)
        Wait(500)
        DoScreenFadeIn(500)
    else
        Core.NotifyRightTip(_U('noWagon'), 4000)
    end
end, false)

RegisterCommand(Config.commands.wagonReturn, function()
    if Config.returnEnabled then
        ReturnWagon()
    else
        Core.NotifyRightTip(_U('noReturn'), 4000)
    end
end, false)

function StartPrompts()
    ShopPrompt = PromptRegisterBegin()
    PromptSetControlAction(ShopPrompt, Config.keys.shop)
    PromptSetText(ShopPrompt, CreateVarString(10, 'LITERAL_STRING', _U('shopPrompt')))
    PromptSetVisible(ShopPrompt, true)
    PromptSetStandardMode(ShopPrompt, true)
    PromptSetGroup(ShopPrompt, ShopGroup, 0)
    PromptRegisterEnd(ShopPrompt)

    ReturnPrompt = PromptRegisterBegin()
    PromptSetControlAction(ReturnPrompt, Config.keys.ret)
    PromptSetText(ReturnPrompt, CreateVarString(10, 'LITERAL_STRING', _U('returnPrompt')))
    PromptSetVisible(ReturnPrompt, true)
    PromptSetStandardMode(ReturnPrompt, true)
    PromptSetGroup(ReturnPrompt, ShopGroup, 0)
    PromptRegisterEnd(ReturnPrompt)

    LootPrompt = PromptRegisterBegin()
    PromptSetControlAction(LootPrompt, Config.keys.loot)
    PromptSetText(LootPrompt, CreateVarString(10, 'LITERAL_STRING', _U('lootWagonPrompt')))
    PromptSetVisible(LootPrompt, true)
    PromptSetEnabled(LootPrompt, true)
    PromptSetStandardMode(LootPrompt)
    PromptSetGroup(LootPrompt, LootGroup, 0)
    PromptRegisterEnd(LootPrompt)
end

function StartWagonPrompts()
    WagonMenuPrompt = PromptRegisterBegin()
    PromptSetControlAction(WagonMenuPrompt, Config.keys.menu)
    PromptSetText(WagonMenuPrompt, CreateVarString(10, 'LITERAL_STRING', _U('wagonMenuPrompt')))
    PromptSetEnabled(WagonMenuPrompt, true)
    PromptSetVisible(WagonMenuPrompt, true)
    PromptSetStandardMode(WagonMenuPrompt, true)
    PromptSetGroup(WagonMenuPrompt, WagonGroup, 0)
    PromptRegisterEnd(WagonMenuPrompt)

    BrakePrompt = PromptRegisterBegin()
    PromptSetControlAction(BrakePrompt, Config.keys.brake)
    if WagonCfg.brakeSet then
        PromptSetText(BrakePrompt, CreateVarString(10, 'LITERAL_STRING', _U('brakeOff')))
    else
        PromptSetText(BrakePrompt, CreateVarString(10, 'LITERAL_STRING', _U('brakeOn')))
    end
    PromptSetEnabled(BrakePrompt, true)
    PromptSetVisible(BrakePrompt, true)
    PromptSetStandardMode(BrakePrompt, true)
    PromptSetGroup(BrakePrompt, WagonGroup, 0)
    PromptRegisterEnd(BrakePrompt)

    ActionPrompt = PromptRegisterBegin()
    PromptSetControlAction(ActionPrompt, Config.keys.action)
    PromptSetText(ActionPrompt, CreateVarString(10, 'LITERAL_STRING', _U('wagonMenuPrompt')))
    PromptSetEnabled(ActionPrompt, true)
    PromptSetVisible(ActionPrompt, true)
    PromptSetStandardMode(ActionPrompt, true)
    PromptSetGroup(ActionPrompt, ActionGroup, 0)
    PromptRegisterEnd(ActionPrompt)
end

function StartTradePrompts()
    if not PromptsStarted then
        TradePrompt = PromptRegisterBegin()
        PromptSetControlAction(TradePrompt, Config.keys.trade)
        PromptSetText(TradePrompt, CreateVarString(10, 'LITERAL_STRING', _U('tradePrompt')))
        PromptSetEnabled(TradePrompt, true)
        PromptSetVisible(TradePrompt, true)
        PromptSetHoldMode(TradePrompt, 2000)
        PromptSetGroup(TradePrompt, TradeGroup, 0)
        PromptRegisterEnd(TradePrompt)

        PromptsStarted = true
    end
end

function ManageBlip(site, closed)
    local siteCfg = Sites[site]

    if (closed and not siteCfg.blip.show.closed) or (not siteCfg.blip.show.open) then
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
        local model = siteCfg.npc.model
        local hash = joaat(model)
        LoadModel(hash, model)
        siteCfg.NPC = CreatePed(hash, siteCfg.npc.coords.x, siteCfg.npc.coords.y, siteCfg.npc.coords.z - 1.0, siteCfg.npc.heading, false, false, false, false)
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

function LoadModel(hash, model)
    if not IsModelValid(hash) then
        return print('Invalid model:', model)
    end
    RequestModel(hash, false)
    while not HasModelLoaded(hash) do
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
    if MyWagon ~= 0 then
        DeleteEntity(MyWagon)
        MyWagon = 0
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
    for _, wagonModels in ipairs(Wagons) do
        local matchingModels = {}
        for wagonModel, wagonModelData in orderedPairs(wagonModels.types) do
            -- using maps to break a loop, though technically making another loop, albeit simpler. Preferably you already configure jobs as a map so that you could expand
            -- perhaps when a request comes to have model accesses by job grade or similar
            local wagonJobs = {}
            for _, wagonJob in pairs(wagonModelData.job) do
                wagonJobs[wagonJob] = wagonJob
            end
            -- add matching model directly 
            if wagonJobs[job] ~= nil then
                matchingModels[wagonModel] = {
                    label = wagonModelData.label,
                    cashPrice = wagonModelData.cashPrice,
                    goldPrice = wagonModelData.goldPrice,
                    invLimit = wagonModelData.inventory.limit,
                    job = wagonModelData.job
                }
            end
            --handle case where there isn\t a job attached to wagon model config
            if len(wagonJobs) == 0 then
                matchingModels[wagonModel] = {
                    label = wagonModelData.label,
                    cashPrice = wagonModelData.cashPrice,
                    goldPrice = wagonModelData.goldPrice,
                    invLimit = wagonModelData.inventory.limit,
                    job = nil
                }
            end
        end

        if len(matchingModels) > 0 then
            matchingWagons[#matchingWagons + 1] = {
                name = wagonModels.name,
                types = matchingModels
            }
        end
    end
    return matchingWagons
end