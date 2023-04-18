local VORPcore = {}
local VORPInv = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

VORPInv = exports.vorp_inventory:vorp_inventoryApi()

-- Buy New Wagons
RegisterServerEvent('oss_wagons:BuyWagon')
AddEventHandler('oss_wagons:BuyWagon', function(data)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local maxWagons = Config.maxWagons

    MySQL.Async.fetchAll('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(wagons)
        if #wagons >= maxWagons then
            VORPcore.NotifyRightTip(_source, _U("wagonLimit") .. maxWagons .. _U("wagons"), 5000)
            TriggerClientEvent('oss_wagons:WagonMenu', _source)
            return
        end
        if data.IsCash then
            local charCash = Character.money
            local cashPrice = data.Cash

            if charCash >= cashPrice then
                Character.removeCurrency(0, cashPrice)
            else
                VORPcore.NotifyRightTip(_source, _U("shortCash"), 5000)
                TriggerClientEvent('oss_wagons:WagonMenu', _source)
                return
            end
        else
            local charGold = Character.gold
            local goldPrice = data.Gold

            if charGold >= goldPrice then
                Character.removeCurrency(1, goldPrice)
            else
                VORPcore.NotifyRightTip(_source, _U("shortGold"), 5000)
                TriggerClientEvent('oss_wagons:WagonMenu', _source)
                return
            end
        end
        local action = "newWagon"
        TriggerClientEvent('oss_wagons:SetWagonName', _source, data, action)
    end)
end)

-- Save New Wagon Purchase to Database
RegisterServerEvent('oss_wagons:SaveNewWagon')
AddEventHandler('oss_wagons:SaveNewWagon', function(data, name)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    MySQL.Async.execute('INSERT INTO player_wagons (identifier, charid, name, model) VALUES (?, ?, ?, ?)', {identifier, charid, tostring(name), data.ModelW},
        function(done)
    end)
end)

-- Rename Owned Wagons
RegisterServerEvent('oss_wagons:UpdateWagonName')
AddEventHandler('oss_wagons:UpdateWagonName', function(data, name)
    local wagonId = data.WagonId

    MySQL.Async.execute('UPDATE player_wagons SET name = ? WHERE id = ?', {name, wagonId},
    function(done)
    end)
end)

RegisterServerEvent('oss_wagons:SelectWagon')
AddEventHandler('oss_wagons:SelectWagon', function(id)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    MySQL.Async.fetchAll('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(wagon)
        for i = 1, #wagon do
            local wagonId = wagon[i].id
            MySQL.Async.execute('UPDATE player_wagons SET selected = ? WHERE identifier = ? AND charid = ? AND id = ?', {0, identifier, charid, wagonId},
            function(done)
            end)

            Wait(300)

            if wagon[i].id == id then
                MySQL.Async.execute('UPDATE player_wagons SET selected = ? WHERE identifier = ? AND charid = ? AND id = ?', {1, identifier, charid, id},
                function(done)
                end)
            end
        end
    end)
end)

-- Get Selected Player Owned Wagon
RegisterServerEvent('oss_wagons:GetSelectedWagon')
AddEventHandler('oss_wagons:GetSelectedWagon', function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    print("GetSelectedWagon")
    MySQL.Async.fetchAll('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(wagons)
        if #wagons ~= 0 then
            for i = 1, #wagons do
                if wagons[i].selected == 1 then
                    local menuSpawn = false
                    TriggerClientEvent('oss_wagons:SetWagonInfo', _source, wagons[i].model, wagons[i].name, menuSpawn, wagons[i].id)
                    print("SetWagonInfo")
                end
            end
        else
            VORPcore.NotifyRightTip(_source, _U("noOwnedWagons"), 5000)
        end
    end)
end)

-- Get Player Owned Wagons
RegisterServerEvent('oss_wagons:GetMyWagons')
AddEventHandler('oss_wagons:GetMyWagons', function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    MySQL.Async.fetchAll('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(wagons)
        TriggerClientEvent('oss_wagons:ReceiveWagonsData', _source, wagons)
    end)
end)

-- Sell Player Owned Wagons
RegisterServerEvent('oss_wagons:SellWagon')
AddEventHandler('oss_wagons:SellWagon', function(wagonId, wagonName, shopId)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local modelWagon = nil

    MySQL.Async.fetchAll('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(wagons)
        for i = 1, #wagons do
            if tonumber(wagons[i].id) == tonumber(wagonId) then
                modelWagon = wagons[i].model
                MySQL.Async.execute('DELETE FROM player_wagons WHERE identifier = ? AND charid = ? AND id = ?', {identifier, charid, wagonId},
                function(done)
                end)
            end
        end

        for _,wagonModels in pairs(Config.wagonShops[shopId].wagons) do
            for model,wagonConfig in pairs(wagonModels) do
                if model ~= "wagonType" then
                    if model == modelWagon then
                        local sellPrice = wagonConfig.sellPrice
                        Character.addCurrency(0, sellPrice)
                        VORPcore.NotifyRightTip(_source, _U("soldWagon") .. wagonName .. _U("frcash") .. sellPrice, 5000)
                    end
                end
            end
        end
        TriggerClientEvent('oss_wagons:WagonMenu', _source)
    end)
end)

-- Register Wagon Inventory
RegisterServerEvent('oss_wagons:RegisterInventory')
AddEventHandler('oss_wagons:RegisterInventory', function(id)

    VORPInv.registerInventory("wagon_" .. tostring(id), _U("wagonInv"), tonumber(Config.invLimit))
end)

-- Open Wagon Inventory
RegisterServerEvent('oss_wagons:OpenInventory')
AddEventHandler('oss_wagons:OpenInventory', function(id)
    local _source = source

    VORPInv.OpenInv(_source, "wagon_" .. tostring(id))
end)

-- Check Player Job and Job Grade
RegisterServerEvent('oss_wagons:getPlayerJob')
AddEventHandler('oss_wagons:getPlayerJob', function()
    local _source = source
    if _source then
        local Character = VORPcore.getUser(_source).getUsedCharacter
        local CharacterJob = Character.job
        local CharacterGrade = Character.jobGrade
        TriggerClientEvent('oss_wagons:sendPlayerJob', _source, CharacterJob, CharacterGrade)
    end
end)
