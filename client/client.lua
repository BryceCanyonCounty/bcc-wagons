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
local Showroom_entity = nil
local MyWagon_entity = nil
local MyWagon = nil
local MyWagonId
local WagonCam
local ShopId
local ShopName
local InMenu = false

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

-- Start Wagons
Citizen.CreateThread(function()
    ShopOpen()
    ShopClosed()
    ReturnOpen()

    while true do
        Citizen.Wait(0)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local sleep = true
        local dead = IsEntityDead(player)
        local hour = GetClockHours()

        if InMenu == false and not dead then
            for shopId, shopConfig in pairs(Config.wagonShops) do
                if shopConfig.shopHours then
                    -- Using Shop Hours - Shop Closed
                    if hour >= shopConfig.shopClose or hour < shopConfig.shopOpen then
                        if Config.blipAllowedClosed then
                            if not Config.wagonShops[shopId].BlipHandle and shopConfig.blipAllowed then
                                AddBlip(shopId)
                            end
                        else
                            if Config.wagonShops[shopId].BlipHandle then
                                RemoveBlip(Config.wagonShops[shopId].BlipHandle)
                                Config.wagonShops[shopId].BlipHandle = nil
                            end
                        end
                        if Config.wagonShops[shopId].BlipHandle then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.wagonShops[shopId].BlipHandle, joaat(shopConfig.blipColorClosed)) -- BlipAddModifier
                        end
                        if shopConfig.NPC then
                            DeleteEntity(shopConfig.NPC)
                            DeletePed(shopConfig.NPC)
                            SetEntityAsNoLongerNeeded(shopConfig.NPC)
                            shopConfig.NPC = nil
                        end
                        local coordsDist = vector3(coords.x, coords.y, coords.z)
                        local coordsShop = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                        local distanceShop = #(coordsDist - coordsShop)

                        if (distanceShop <= shopConfig.distanceShop) then
                            sleep = false
                            local shopClosed = CreateVarString(10, 'LITERAL_STRING', shopConfig.shopName .. _U("closed"))
                            PromptSetActiveGroupThisFrame(ClosedGroup, shopClosed)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, CloseShops) then -- UiPromptHasStandardModeCompleted
                                Wait(100)
                                VORPcore.NotifyRightTip(shopConfig.shopName .. _U("hours") .. shopConfig.shopOpen .. _U("to") .. shopConfig.shopClose .. _U("hundred"), 4000)
                            end
                        end
                    elseif hour >= shopConfig.shopOpen then
                        -- Using Shop Hours - Shop Open
                        if not Config.wagonShops[shopId].BlipHandle and shopConfig.blipAllowed then
                            AddBlip(shopId)
                        end
                        if not shopConfig.NPC and shopConfig.npcAllowed then
                            SpawnNPC(shopId)
                        end
                        if not next(shopConfig.allowedJobs) then
                            if Config.wagonShops[shopId].BlipHandle then
                                Citizen.InvokeNative(0x662D364ABF16DE2F, Config.wagonShops[shopId].BlipHandle, joaat(shopConfig.blipColorOpen)) -- BlipAddModifier
                            end
                            local coordsDist = vector3(coords.x, coords.y, coords.z)
                            local coordsShop = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                            local distanceShop = #(coordsDist - coordsShop)

                            if (distanceShop <= shopConfig.distanceShop) then
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
                            if Config.wagonShops[shopId].BlipHandle then
                                Citizen.InvokeNative(0x662D364ABF16DE2F, Config.wagonShops[shopId].BlipHandle, joaat(shopConfig.blipColorJob)) -- BlipAddModifier
                            end
                            local coordsDist = vector3(coords.x, coords.y, coords.z)
                            local coordsShop = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                            local distanceShop = #(coordsDist - coordsShop)

                            if (distanceShop <= shopConfig.distanceShop) then
                                sleep = false
                                local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                                PromptSetActiveGroupThisFrame(OpenGroup, shopOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                    TriggerServerEvent("oss_wagons:GetPlayerJob")
                                    Wait(200)
                                    if PlayerJob then
                                        if CheckJob(shopConfig.allowedJobs, PlayerJob) then
                                            if tonumber(shopConfig.jobGrade) <= tonumber(JobGrade) then
                                                DisplayRadar(false)
                                                OpenMenu(shopId)
                                            else
                                                VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                            end
                                        else
                                            VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                    end
                                elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted

                                    TriggerServerEvent("oss_wagons:GetPlayerJob")
                                    Wait(200)
                                    if PlayerJob then
                                        if CheckJob(shopConfig.allowedJobs, PlayerJob) then
                                            if tonumber(shopConfig.jobGrade) <= tonumber(JobGrade) then
                                                ReturnWagon()
                                            else
                                                VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                            end
                                        else
                                            VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                    end
                                end
                            end
                        end
                    end
                else
                    -- Not Using Shop Hours - Shop Always Open
                    if not Config.wagonShops[shopId].BlipHandle and shopConfig.blipAllowed then
                        AddBlip(shopId)
                    end
                    if not shopConfig.NPC and shopConfig.npcAllowed then
                        SpawnNPC(shopId)
                    end
                    if not next(shopConfig.allowedJobs) then
                        if Config.wagonShops[shopId].BlipHandle then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.wagonShops[shopId].BlipHandle, joaat(shopConfig.blipColorOpen)) -- BlipAddModifier
                        end
                        local coordsDist = vector3(coords.x, coords.y, coords.z)
                        local coordsShop = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                        local distanceShop = #(coordsDist - coordsShop)

                        if (distanceShop <= shopConfig.distanceShop) then
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
                        if Config.wagonShops[shopId].BlipHandle then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.wagonShops[shopId].BlipHandle, joaat(shopConfig.blipColorJob)) -- BlipAddModifier
                        end
                        local coordsDist = vector3(coords.x, coords.y, coords.z)
                        local coordsShop = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                        local distanceShop = #(coordsDist - coordsShop)

                        if (distanceShop <= shopConfig.distanceShop) then
                            sleep = false
                            local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                            PromptSetActiveGroupThisFrame(OpenGroup, shopOpen)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                TriggerServerEvent("oss_wagons:GetPlayerJob")
                                Wait(200)
                                if PlayerJob then
                                    if CheckJob(shopConfig.allowedJobs, PlayerJob) then
                                        if tonumber(shopConfig.jobGrade) <= tonumber(JobGrade) then
                                            DisplayRadar(false)
                                            OpenMenu(shopId)
                                        else
                                            VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                    end
                                else
                                    VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                end
                            elseif Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted

                                TriggerServerEvent("oss_wagons:GetPlayerJob")
                                Wait(200)
                                if PlayerJob then
                                    if CheckJob(shopConfig.allowedJobs, PlayerJob) then
                                        if tonumber(shopConfig.jobGrade) <= tonumber(JobGrade) then
                                            ReturnWagon()
                                        else
                                            VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                    end
                                else
                                    VORPcore.NotifyRightTip(_U("needJob") .. JobName .. " " .. shopConfig.jobGrade, 5000)
                                end
                            end
                        end
                    end
                end
            end
        end
        if sleep then
            Citizen.Wait(1000)
        end
    end
end)

-- Open Wagon Shop Menu
function OpenMenu(shopId)
    InMenu = true
    ShopId = shopId
    ShopName = Config.wagonShops[shopId].shopName

    if MyWagon ~= nil then
        DeleteEntity(MyWagon)
        MyWagon = nil
    end

    CreateCamera()

    TriggerServerEvent('oss_wagons:GetMyWagons')
end

-- Get Wagon Data for Players Wagons
RegisterNetEvent('oss_wagons:WagonsData')
AddEventHandler('oss_wagons:WagonsData', function(data)

    SendNUIMessage({
        action = "show",
        shopWagons = GetShopWagons(),
        location = ShopName,
        myWagons = data
    })
    SetNuiFocus(true, true)
end)

-- Get Wagon Data for Purchases
function GetShopWagons()
    local shopWagonData = Config.wagonShops[ShopId].wagons
    return shopWagonData
end

-- View Wagons for Purchase
RegisterNUICallback("LoadWagon", function(data)
    if MyWagon_entity ~= nil then
        DeleteEntity(MyWagon_entity)
        MyWagon_entity = nil
    end

    local model = joaat(data.WagonModel)
    LoadWagonModel(model)

    if Showroom_entity ~= nil then
        DeleteEntity(Showroom_entity)
        Showroom_entity = nil
    end

    local shopConfig = Config.wagonShops[ShopId]
    Showroom_entity = CreateVehicle(model, shopConfig.spawn.x, shopConfig.spawn.y, shopConfig.spawn.z, shopConfig.spawn.h, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, Showroom_entity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, Showroom_entity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(model)
end)

-- Buy New Wagons
RegisterNUICallback("BuyWagon", function(data)

    TriggerServerEvent('oss_wagons:BuyWagon', data)
end)

-- Name Wagons
RegisterNetEvent('oss_wagons:SetWagonName')
AddEventHandler('oss_wagons:SetWagonName', function(data, rename)
    HideMenu()
    Wait(200)

    local wagonName = ""
	Citizen.CreateThread(function()
		AddTextEntry('FMMC_MPM_NA', _U("nameWagon"))
		DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
		while (UpdateOnscreenKeyboard() == 0) do
			DisableAllControlActions(0)
			Citizen.Wait(0)
		end
		if (GetOnscreenKeyboardResult()) then
            wagonName = GetOnscreenKeyboardResult()
            if not rename then
                TriggerServerEvent('oss_wagons:SaveNewWagon', data, wagonName)
            else
                TriggerServerEvent('oss_wagons:UpdateWagonName', data, wagonName)
            end
		end
    end)
end)

-- Rename Owned Wagon
RegisterNUICallback("RenameWagon", function(data)
    local rename = true
    TriggerEvent('oss_wagons:SetWagonName', data, rename)
end)

-- Select Active Wagon
RegisterNUICallback("SelectWagon", function(data)
    TriggerServerEvent('oss_wagons:SelectWagon', tonumber(data.WagonId))
end)

-- View Player Owned Wagons
RegisterNUICallback("LoadMyWagon", function(data)
    if Showroom_entity ~= nil then
        DeleteEntity(Showroom_entity)
        Showroom_entity = nil
    end

    local model = joaat(data.WagonModel)
    LoadWagonModel(model)

    if MyWagon_entity ~= nil then
        DeleteEntity(MyWagon_entity)
        MyWagon_entity = nil
    end

    local shopConfig = Config.wagonShops[ShopId]
    MyWagon_entity = CreateVehicle(model, shopConfig.spawn.x, shopConfig.spawn.y, shopConfig.spawn.z, shopConfig.spawn.h, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, MyWagon_entity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, MyWagon_entity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(model)
end)

-- Spawn Player Owned Wagons
RegisterNUICallback("SpawnInfo", function(data)
    local wagonModel = data.WagonModel
    local wagonName = data.WagonName
    local menuSpawn = true
    local wagonId = data.WagonId
    CloseMenu()
    TriggerEvent('oss_wagons:SpawnWagon', wagonModel, wagonName, menuSpawn, wagonId)
end)

RegisterNetEvent('oss_wagons:SpawnWagon')
AddEventHandler('oss_wagons:SpawnWagon', function(wagonModel, name, menuSpawn, id)
    local player = PlayerPedId()
    MyWagonId = id

    if MyWagon ~= nil then
        DeleteEntity(MyWagon)
        MyWagon = nil
    end

    local model = joaat(wagonModel)
    LoadWagonModel(model)

    if menuSpawn then
        local shopConfig = Config.wagonShops[ShopId]
        MyWagon = CreateVehicle(model, shopConfig.spawn.x, shopConfig.spawn.y, shopConfig.spawn.z, shopConfig.spawn.h, true, false)
        SetVehicleOnGroundProperly(MyWagon)
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

        MyWagon = CreateVehicle(model, spawnPosition, GetEntityHeading(player), true, false)
        SetVehicleOnGroundProperly(MyWagon)
        SetModelAsNoLongerNeeded(model)

    end
    TriggerServerEvent('oss_wagons:RegisterInventory', MyWagonId)

    local wagonBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1749618580, MyWagon) -- BlipAddForEntity
    SetBlipSprite(wagonBlip, joaat("blip_mp_player_wagon"), true)
    Citizen.InvokeNative(0x9CB1A1623062F402, wagonBlip, name) -- SetBlipName
end)

-- Sell Player Owned Wagons
RegisterNUICallback("SellWagon", function(data)
    local wagonId = data.WagonId
    local wagonName = data.WagonName
    DeleteEntity(MyWagon_entity)
    HideMenu()
    TriggerServerEvent('oss_wagons:SellWagon', wagonId, wagonName, ShopId)
end)

-- Close Wagon Shop Menu
RegisterNUICallback("CloseMenu", function()
   CloseMenu()
end)

function CloseMenu()
    HideMenu()

    if Showroom_entity ~= nil then
        DeleteEntity(Showroom_entity)
    end
    Showroom_entity = nil

    if MyWagon_entity ~= nil then
        DeleteEntity(MyWagon_entity)
    end
    MyWagon_entity = nil

    DestroyAllCams(true)
    DisplayRadar(true)
    InMenu = false
    ClearPedTasksImmediately(PlayerPedId())
end

function HideMenu()
    SendNUIMessage({ action = "hide" })
    SetNuiFocus(false, false)
end

function LoadWagonModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(100)
    end
end
-- Reopen Menu After Sell or Failed Purchase
RegisterNetEvent('oss_wagons:WagonMenu')
AddEventHandler('oss_wagons:WagonMenu', function()
    if Showroom_entity ~= nil then
        DeleteEntity(Showroom_entity)
        Showroom_entity = nil
    end
    TriggerServerEvent('oss_wagons:GetMyWagons')
end)

-- Wagon Actions
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        -- Call Wagon (key: J)
        if Citizen.InvokeNative(0x580417101DDB492F, 2, 0xF3830D8E) then -- IsControlJustPressed
            CallWagon()
        end
        -- Open Inventory (key: U)
        if Citizen.InvokeNative(0x580417101DDB492F, 2, 0xD8F73058) then -- IsControlJustPressed
            OpenInventory()
        end
    end
end)

-- Call Selected Wagon
function CallWagon()
    if MyWagon ~= nil then
        local pcoords = GetEntityCoords(PlayerPedId())
        local wcoords = GetEntityCoords(MyWagon)
        local callDist = #(pcoords - wcoords)
        if callDist >= 100 then
            DeleteEntity(MyWagon)
            Wait(1000)
            TriggerServerEvent('oss_wagons:GetSelectedWagon')
        else
            VORPcore.NotifyRightTip(_U("tooClose"), 5000)
        end
    else
        TriggerServerEvent('oss_wagons:GetSelectedWagon')
    end
end

-- Open Wagon Inventory
function OpenInventory()
    local pcoords = GetEntityCoords(PlayerPedId())
    local hcoords = GetEntityCoords(MyWagon)
    local invDist = #(pcoords - hcoords)
    if invDist <= 2.0 then
        TriggerServerEvent('oss_wagons:OpenInventory', MyWagonId)
    end
end

-- Return Wagon Using Prompt at Shop Location
function ReturnWagon()
    if MyWagon ~= nil then
        DeleteEntity(MyWagon)
        MyWagon = nil
        VORPcore.NotifyRightTip(_U("wagonReturned"), 5000)
    else
        VORPcore.NotifyRightTip(_U("noWagon"), 5000)
    end
end

-- Camera to View Wagons
function CreateCamera()
    local shopConfig = Config.wagonShops[ShopId]
    WagonCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(WagonCam, shopConfig.wagonCam.x, shopConfig.wagonCam.y, shopConfig.wagonCam.z + 2.0 )
    SetCamActive(WagonCam, true)
    PointCamAtCoord(WagonCam, shopConfig.spawn.x, shopConfig.spawn.y, shopConfig.spawn.z)
    DoScreenFadeOut(500)
    Wait(500)
    DoScreenFadeIn(500)
    RenderScriptCams(true, false, 0, 0, 0)
end

-- Rotate Wagons while Viewing
RegisterNUICallback("Rotate", function(data)
    local direction = data.RotateWagon
    if direction == "left" then
        Rotation(20)
    elseif direction == "right" then
        Rotation(-20)
    end
end)

function Rotation(dir)
    if MyWagon_entity then
        local ownedRot = GetEntityHeading(MyWagon_entity) + dir
        SetEntityHeading(MyWagon_entity, ownedRot % 360)

    elseif Showroom_entity then
        local shopRot = GetEntityHeading(Showroom_entity) + dir
        SetEntityHeading(Showroom_entity, shopRot % 360)
    end
end

-- Command Will Bypass Distance Check and Respawn Wagon
RegisterCommand('wagonRespawn', function(source, args, rawCommand)

    TriggerServerEvent('oss_wagons:GetSelectedWagon')
end)

-- Command Will Return Wagon When Away from a Shop
RegisterCommand('wagonReturn', function(source, args, rawCommand)

    ReturnWagon()
end)

-- Menu Prompts
function ShopOpen()
    local str = _U("shopPrompt")
    OpenShops = PromptRegisterBegin()
    PromptSetControlAction(OpenShops, Config.shopKey)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(OpenShops, str)
    PromptSetEnabled(OpenShops, 1)
    PromptSetVisible(OpenShops, 1)
    PromptSetStandardMode(OpenShops, 1)
    PromptSetGroup(OpenShops, OpenGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, OpenShops, true) -- UiPromptSetUrgentPulsingEnabled
    PromptRegisterEnd(OpenShops)
end

function ShopClosed()
    local str = _U("shopPrompt")
    CloseShops = PromptRegisterBegin()
    PromptSetControlAction(CloseShops, Config.shopKey)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(CloseShops, str)
    PromptSetEnabled(CloseShops, 1)
    PromptSetVisible(CloseShops, 1)
    PromptSetStandardMode(CloseShops, 1)
    PromptSetGroup(CloseShops, ClosedGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, CloseShops, true) -- UiPromptSetUrgentPulsingEnabled
    PromptRegisterEnd(CloseShops)
end

function ReturnOpen()
    local str = _U("returnPrompt")
    OpenReturn = PromptRegisterBegin()
    PromptSetControlAction(OpenReturn, Config.returnKey)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(OpenReturn, str)
    PromptSetEnabled(OpenReturn, 1)
    PromptSetVisible(OpenReturn, 1)
    PromptSetStandardMode(OpenReturn, 1)
    PromptSetGroup(OpenReturn, OpenGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, OpenReturn, true) -- UiPromptSetUrgentPulsingEnabled
    PromptRegisterEnd(OpenReturn)
end

-- Blips
function AddBlip(shopId)
    local shopConfig = Config.wagonShops[shopId]
    if shopConfig.blipAllowed then
        shopConfig.BlipHandle = N_0x554d9d53f696d002(1664425300, shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z) -- BlipAddForCoords
        SetBlipSprite(shopConfig.BlipHandle, shopConfig.blipSprite, 1)
        SetBlipScale(shopConfig.BlipHandle, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, shopConfig.BlipHandle, shopConfig.blipName) -- SetBlipName
    end
end

-- NPCs
function SpawnNPC(shopId)
    local shopConfig = Config.wagonShops[shopId]
    LoadModel(shopConfig.npcModel)
    if shopConfig.npcAllowed then
        local npc = CreatePed(shopConfig.npcModel, shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z - 1.0, shopConfig.npc.h, false, true, true, true)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true) -- SetRandomOutfitVariation
        SetEntityCanBeDamaged(npc, false)
        SetEntityInvincible(npc, true)
        Wait(500)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        Config.wagonShops[shopId].NPC = npc
    end
end

function LoadModel(npcModel)
    local model = joaat(npcModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(100)
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

RegisterNetEvent("oss_wagons:sendPlayerJob")
AddEventHandler("oss_wagons:sendPlayerJob", function(Job, grade)
    PlayerJob = Job
    JobGrade = grade
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if InMenu == true then
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "hide" })
    end
    ClearPedTasksImmediately(PlayerPedId())
    PromptDelete(OpenShops)
    PromptDelete(CloseShops)
    PromptDelete(OpenReturn)

    if MyWagon ~= nil then
        DeleteEntity(MyWagon)
        MyWagon = nil
    end

    for _, shopConfig in pairs(Config.wagonShops) do
        if shopConfig.BlipHandle then
            RemoveBlip(shopConfig.BlipHandle)
        end
        if shopConfig.NPC then
            DeleteEntity(shopConfig.NPC)
            DeletePed(shopConfig.NPC)
            SetEntityAsNoLongerNeeded(shopConfig.NPC)
        end
    end
end)
