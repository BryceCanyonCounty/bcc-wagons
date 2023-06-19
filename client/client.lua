local VORPcore = {}
-- Prompts
local OpenShops
local CloseShops
local OpenReturn
local OpenGroup = GetRandomIntInRange(0, 0xffffff)
local ClosedGroup = GetRandomIntInRange(0, 0xffffff)
-- Jobs
local PlayerJob
local JobName
local JobGrade
-- Wagons
local ShopName
local ShopEntity
local MyEntity
local MyWagon = nil
local MyWagonId
local MyWagonName
local WagonCam
local ShopId
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
        local coords = GetEntityCoords(player)
        local sleep = true
        local dead = IsEntityDead(player)
        local hour = GetClockHours()

        if not InMenu and not dead then
            for shopId, shopConfig in pairs(Config.shops) do
                if shopConfig.shopHours then
                    -- Using Shop Hours - Shop Closed
                    if hour >= shopConfig.shopClose or hour < shopConfig.shopOpen then
                        if Config.blipOnClosed then
                            if not Config.shops[shopId].Blip and shopConfig.blipOn then
                                AddBlip(shopId)
                            end
                        else
                            if Config.shops[shopId].Blip then
                                RemoveBlip(Config.shops[shopId].Blip)
                                Config.shops[shopId].Blip = nil
                            end
                        end
                        if Config.shops[shopId].Blip then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shopId].Blip, joaat(Config.BlipColors[shopConfig.blipColorClosed])) -- BlipAddModifier
                        end
                        if shopConfig.NPC then
                            DeleteEntity(shopConfig.NPC)
                            shopConfig.NPC = nil
                        end
                        local pcoords = vector3(coords.x, coords.y, coords.z)
                        local scoords = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                        local sDistance = #(pcoords - scoords)

                        if sDistance <= shopConfig.sDistance then
                            sleep = false
                            local shopClosed = CreateVarString(10, 'LITERAL_STRING', shopConfig.shopName .. _U('closed'))
                            PromptSetActiveGroupThisFrame(ClosedGroup, shopClosed)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, CloseShops) then -- UiPromptHasStandardModeCompleted
                                Wait(100)
                                VORPcore.NotifyRightTip(shopConfig.shopName .. _U('hours') .. shopConfig.shopOpen .. _U('to') .. shopConfig.shopClose .. _U('hundred'), 4000)
                            end
                        end
                    elseif hour >= shopConfig.shopOpen then
                        -- Using Shop Hours - Shop Open
                        if not Config.shops[shopId].Blip and shopConfig.blipOn then
                            AddBlip(shopId)
                        end
                        if not next(shopConfig.allowedJobs) then
                            if Config.shops[shopId].Blip then
                                Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shopId].Blip, joaat(Config.BlipColors[shopConfig.blipColorOpen])) -- BlipAddModifier
                            end
                            local pcoords = vector3(coords.x, coords.y, coords.z)
                            local scoords = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                            local sDistance = #(pcoords - scoords)

                            if sDistance <= shopConfig.nDistance then
                                if not shopConfig.NPC and shopConfig.npcOn then
                                    AddNPC(shopId)
                                end
                            else
                                if shopConfig.NPC then
                                    DeleteEntity(shopConfig.NPC)
                                    shopConfig.NPC = nil
                                end
                            end
                            if sDistance <= shopConfig.sDistance then
                                sleep = false
                                local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                                PromptSetActiveGroupThisFrame(OpenGroup, shopOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                    DisplayRadar(false)
                                    OpenMenu(shopId)
                                elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                    ReturnWagon()
                                end
                            end
                        else
                            -- Using Shop Hours - Shop Open - Job Locked
                            if Config.shops[shopId].Blip then
                                Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shopId].Blip, joaat(Config.BlipColors[shopConfig.blipColorJob])) -- BlipAddModifier
                            end
                            local pcoords = vector3(coords.x, coords.y, coords.z)
                            local scoords = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                            local sDistance = #(pcoords - scoords)

                            if sDistance <= shopConfig.nDistance then
                                if not shopConfig.NPC and shopConfig.npcOn then
                                    AddNPC(shopId)
                                end
                            else
                                if shopConfig.NPC then
                                    DeleteEntity(shopConfig.NPC)
                                    shopConfig.NPC = nil
                                end
                            end
                            if sDistance <= shopConfig.sDistance then
                                sleep = false
                                local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                                PromptSetActiveGroupThisFrame(OpenGroup, shopOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                    TriggerServerEvent('bcc-wagons:GetPlayerJob')
                                    Wait(200)
                                    if PlayerJob then
                                        if CheckJob(shopConfig.allowedJobs, PlayerJob) then
                                            if tonumber(shopConfig.jobGrade) <= tonumber(JobGrade) then
                                                DisplayRadar(false)
                                                OpenMenu(shopId)
                                            else
                                                VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
                                            end
                                        else
                                            VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
                                    end
                                elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                    TriggerServerEvent('bcc-wagons:GetPlayerJob')
                                    Wait(200)
                                    if PlayerJob then
                                        if CheckJob(shopConfig.allowedJobs, PlayerJob) then
                                            if tonumber(shopConfig.jobGrade) <= tonumber(JobGrade) then
                                                ReturnWagon()
                                            else
                                                VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
                                            end
                                        else
                                            VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
                                    end
                                end
                            end
                        end
                    end
                else
                    -- Not Using Shop Hours - Shop Always Open
                    if not Config.shops[shopId].Blip and shopConfig.blipOn then
                        AddBlip(shopId)
                    end
                    if not next(shopConfig.allowedJobs) then
                        if Config.shops[shopId].Blip then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shopId].Blip, joaat(Config.BlipColors[shopConfig.blipColorOpen])) -- BlipAddModifier
                        end
                        local pcoords = vector3(coords.x, coords.y, coords.z)
                        local scoords = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                        local sDistance = #(pcoords - scoords)

                        if sDistance <= shopConfig.nDistance then
                            if not shopConfig.NPC and shopConfig.npcOn then
                                AddNPC(shopId)
                            end
                        else
                            if shopConfig.NPC then
                                DeleteEntity(shopConfig.NPC)
                                shopConfig.NPC = nil
                            end
                        end
                        if sDistance <= shopConfig.sDistance then
                            sleep = false
                            local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                            PromptSetActiveGroupThisFrame(OpenGroup, shopOpen)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                DisplayRadar(false)
                                OpenMenu(shopId)
                            elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                ReturnWagon()
                            end
                        end
                    else
                        -- Not Using Shop Hours - Shop Always Open - Job Locked
                        if Config.shops[shopId].Blip then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shopId].Blip, joaat(Config.BlipColors[shopConfig.blipColorJob])) -- BlipAddModifier
                        end
                        local pcoords = vector3(coords.x, coords.y, coords.z)
                        local scoords = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                        local sDistance = #(pcoords - scoords)

                        if sDistance <= shopConfig.nDistance then
                            if not shopConfig.NPC and shopConfig.npcOn then
                                AddNPC(shopId)
                            end
                        else
                            if shopConfig.NPC then
                                DeleteEntity(shopConfig.NPC)
                                shopConfig.NPC = nil
                            end
                        end
                        if sDistance <= shopConfig.sDistance then
                            sleep = false
                            local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                            PromptSetActiveGroupThisFrame(OpenGroup, shopOpen)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                TriggerServerEvent('bcc-wagons:GetPlayerJob')
                                Wait(200)
                                if PlayerJob then
                                    if CheckJob(shopConfig.allowedJobs, PlayerJob) then
                                        if tonumber(shopConfig.jobGrade) <= tonumber(JobGrade) then
                                            DisplayRadar(false)
                                            OpenMenu(shopId)
                                        else
                                            VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
                                    end
                                else
                                    VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
                                end
                            elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                TriggerServerEvent('bcc-wagons:GetPlayerJob')
                                Wait(200)
                                if PlayerJob then
                                    if CheckJob(shopConfig.allowedJobs, PlayerJob) then
                                        if tonumber(shopConfig.jobGrade) <= tonumber(JobGrade) then
                                            ReturnWagon()
                                        else
                                            VORPcore.NotifyRightTip(
                                                _U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
                                    end
                                else
                                    VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade, 5000)
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
function OpenMenu(shopId)
    InMenu = true
    ShopId = shopId
    ShopName = Config.shops[ShopId].shopName

    if MyWagon then
        DeleteEntity(MyWagon)
        MyWagon = nil
    end

    CreateCamera()

    SendNUIMessage({
        action = 'show',
        shopData = Config.shops[ShopId].wagons,
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

    local shopConfig = Config.shops[ShopId]
    ShopEntity = CreateVehicle(model, shopConfig.spawn.x, shopConfig.spawn.y, shopConfig.spawn.z, shopConfig.spawn.h, false, false)
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
                else
                    TriggerServerEvent('bcc-wagons:UpdateWagonName', data, wagonName)
                end
            else
                TriggerEvent('bcc-wagons:SetWagonName', data, rename)
                return
            end

            SendNUIMessage({
                action = 'show',
                shopData = Config.shops[ShopId].wagons,
                location = ShopName,
                currencyType = Config.currencyType
            })
            SetNuiFocus(true, true)
            Wait(1000)

            TriggerServerEvent('bcc-wagons:GetMyWagons')
        end
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

    local shopConfig = Config.shops[ShopId]
    MyEntity = CreateVehicle(model, shopConfig.spawn.x, shopConfig.spawn.y, shopConfig.spawn.z, shopConfig.spawn.h, false, false)
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

    local player = PlayerPedId()
    if menuSpawn then
        local shopConfig = Config.shops[ShopId]
        MyWagon = CreateVehicle(model, shopConfig.spawn.x, shopConfig.spawn.y, shopConfig.spawn.z, shopConfig.spawn.h, true, false)
        Citizen.InvokeNative(0x7263332501E07F52, MyWagon, true) -- SetVehicleOnGroundProperly
        SetModelAsNoLongerNeeded(model)
        DoScreenFadeOut(500)
        Wait(500)
        SetPedIntoVehicle(player, MyWagon, -1)
        Wait(500)
        DoScreenFadeIn(500)
    else
        local pCoords = GetEntityCoords(player)
        local spawnPosition
        local x, y, z = table.unpack(pCoords)
        local nodePosition = GetClosestVehicleNode(x, y, z, 1, 3.0, 0.0)
        local index = 0
        while index <= 25 do
            local _bool, _nodePosition = GetNthClosestVehicleNode(x, y, z, index, 1, 3.0, 2.5)
            if _bool == true or _bool == 1 then
                nodePosition = _nodePosition
                index = index + 3
            else
                break
            end
        end
        spawnPosition = nodePosition

        MyWagon = CreateVehicle(model, spawnPosition, 0.0, true, false)
        Citizen.InvokeNative(0x7263332501E07F52, MyWagon, true) -- SetVehicleOnGroundProperly
        SetModelAsNoLongerNeeded(model)
    end
    MyWagonId = id
    TriggerServerEvent('bcc-wagons:RegisterInventory', MyWagonId, wagonModel)

    MyWagonName = name
    local wagonBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1749618580, MyWagon) -- BlipAddForEntity
    SetBlipSprite(wagonBlip, joaat('blip_mp_player_wagon'), true)
    Citizen.InvokeNative(0x9CB1A1623062F402, wagonBlip, MyWagonName)                 -- SetBlipName
end)

-- Sell Player Owned Wagons
RegisterNUICallback('SellWagon', function(data, cb)
    cb('ok')
    DeleteEntity(MyEntity)
    Cam = false
    TriggerServerEvent('bcc-wagons:SellWagon', data, ShopId)
end)

-- Close Main Menu
RegisterNUICallback('CloseMenu', function(data, cb)
    cb('ok')
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)

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
        shopData = Config.shops[ShopId].wagons,
        location = ShopName,
        currencyType = Config.currencyType
    })
    TriggerServerEvent('bcc-wagons:GetMyWagons')
end)

-- Wagon Actions
CreateThread(function()
    while true do
        Wait(1)
        -- Call Wagon (key: J)
        if Citizen.InvokeNative(0x580417101DDB492F, 2, 0xF3830D8E) then -- IsControlJustPressed
            if Config.callAllowed then
                CallWagon()
            end
        end
        -- Open Inventory (key: U)
        if Citizen.InvokeNative(0x580417101DDB492F, 2, 0xD8F73058) then -- IsControlJustPressed
            OpenInventory()
        end
    end
end)

-- Call Selected Wagon
function CallWagon()
    if MyWagon then
        local pcoords = GetEntityCoords(PlayerPedId())
        local wcoords = GetEntityCoords(MyWagon)
        local callDist = #(pcoords - wcoords)
        if callDist >= 100 then
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
        local pcoords = GetEntityCoords(PlayerPedId())
        local hcoords = GetEntityCoords(MyWagon)
        local invDist = #(pcoords - hcoords)
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
        VORPcore.NotifyRightTip(MyWagonName .. _U('wagonReturned'), 5000)
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
    local shopConfig = Config.shops[ShopId]
    WagonCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(WagonCam, shopConfig.wagonCam.x, shopConfig.wagonCam.y, shopConfig.wagonCam.z + 2.0)
    SetCamActive(WagonCam, true)
    PointCamAtCoord(WagonCam, shopConfig.spawn.x, shopConfig.spawn.y, shopConfig.spawn.z)
    DoScreenFadeOut(500)
    Wait(500)
    DoScreenFadeIn(500)
    RenderScriptCams(true, false, 0, 0, 0)
end

function CameraLighting()
    CreateThread(function()
        local shopConfig = Config.shops[ShopId]
        while Cam do
            Wait(0)
            Citizen.InvokeNative(0xD2D9E04C0DF927F4, shopConfig.spawn.x, shopConfig.spawn.y, shopConfig.spawn.z + 3, 130, 130, 85, 4.0, 15.0) -- DrawLightWithRange
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
function AddBlip(shopId)
    local shopConfig = Config.shops[shopId]
    shopConfig.Blip = N_0x554d9d53f696d002(1664425300, shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z) -- BlipAddForCoords
    SetBlipSprite(shopConfig.Blip, shopConfig.blipSprite, 1)
    SetBlipScale(shopConfig.Blip, 0.2)
    Citizen.InvokeNative(0x9CB1A1623062F402, shopConfig.Blip, shopConfig.blipName) -- SetBlipName
end

-- NPCs
function AddNPC(shopId)
    local shopConfig = Config.shops[shopId]
    LoadModel(shopConfig.npcModel)
    local npc = CreatePed(shopConfig.npcModel, shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z - 1.0,
        shopConfig.npc.h, false, true, true, true)
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true) -- SetRandomOutfitVariation
    SetEntityCanBeDamaged(npc, false)
    SetEntityInvincible(npc, true)
    Wait(500)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    Config.shops[shopId].NPC = npc
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
        JobName = jobAllowed
        if JobName == playerJob then
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

    for _, shopConfig in pairs(Config.shops) do
        if shopConfig.Blip then
            RemoveBlip(shopConfig.Blip)
        end
        if shopConfig.NPC then
            DeleteEntity(shopConfig.NPC)
            shopConfig.NPC = nil
        end
    end
end)
