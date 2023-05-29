local VORPcore = {}
local VORPInv = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

VORPInv = exports.vorp_inventory:vorp_inventoryApi()

-- Buy New Wagons
RegisterNetEvent('bcc-wagons:BuyWagon', function(data)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local maxWagons = Config.maxWagons

    MySQL.Async.fetchAll('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', { identifier, charid },
        function(wagons)
            if #wagons >= maxWagons then
                VORPcore.NotifyRightTip(_source, _U("wagonLimit") .. maxWagons .. _U("wagons"), 5000)
                TriggerClientEvent('bcc-wagons:WagonMenu', _source)
                return
            end
            if data.IsCash then
                local charCash = Character.money
                local cashPrice = data.Cash

                if charCash >= cashPrice then
                    Character.removeCurrency(0, cashPrice)
                else
                    VORPcore.NotifyRightTip(_source, _U("shortCash"), 5000)
                    TriggerClientEvent('bcc-wagons:WagonMenu', _source)
                    return
                end
            else
                local charGold = Character.gold
                local goldPrice = data.Gold

                if charGold >= goldPrice then
                    Character.removeCurrency(1, goldPrice)
                else
                    VORPcore.NotifyRightTip(_source, _U("shortGold"), 5000)
                    TriggerClientEvent('bcc-wagons:WagonMenu', _source)
                    return
                end
            end
            local rename = false
            TriggerClientEvent('bcc-wagons:SetWagonName', _source, data, rename)
        end)
end)

-- Save New Wagon Purchase to Database
RegisterNetEvent('bcc-wagons:SaveNewWagon', function(data, name)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    MySQL.Async.execute('INSERT INTO player_wagons (identifier, charid, name, model) VALUES (?, ?, ?, ?)',
        { identifier, charid, name, data.ModelW },
        function(done)
        end)
end)

-- Rename Owned Wagons
RegisterNetEvent('bcc-wagons:UpdateWagonName', function(data, name)
    MySQL.Async.execute('UPDATE player_wagons SET name = ? WHERE id = ?', { name, data.WagonId },
        function(done)
        end)
end)

RegisterNetEvent('bcc-wagons:SelectWagon', function(data)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local id = tonumber(data.WagonId)

    MySQL.Async.fetchAll('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', { identifier, charid },
        function(wagon)
            for i = 1, #wagon do
                MySQL.Async.execute(
                    'UPDATE player_wagons SET selected = ? WHERE identifier = ? AND charid = ? AND id = ?',
                    { 0, identifier, charid, wagon[i].id },
                    function(done)
                        if wagon[i].id == id then
                            MySQL.Async.execute(
                                'UPDATE player_wagons SET selected = ? WHERE identifier = ? AND charid = ? AND id = ?',
                                { 1, identifier, charid, id },
                                function(done)
                                end)
                        end
                    end)
            end
        end)
end)

-- Get Selected Player Owned Wagon
RegisterNetEvent('bcc-wagons:GetSelectedWagon', function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    MySQL.Async.fetchAll('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', { identifier, charid },
        function(wagons)
            if #wagons ~= 0 then
                for i = 1, #wagons do
                    if wagons[i].selected == 1 then
                        local menuSpawn = false
                        TriggerClientEvent('bcc-wagons:SpawnWagon', _source, wagons[i].model, wagons[i].name, menuSpawn,
                            wagons[i].id)
                    end
                end
            else
                VORPcore.NotifyRightTip(_source, _U("noOwnedWagons"), 5000)
            end
        end)
end)

-- Get Player Owned Wagons
RegisterNetEvent('bcc-wagons:GetMyWagons', function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    MySQL.Async.fetchAll('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', { identifier, charid },
        function(wagons)
            TriggerClientEvent('bcc-wagons:WagonsData', _source, wagons)
        end)
end)

-- Sell Player Owned Wagons
RegisterNetEvent('bcc-wagons:SellWagon', function(data, shopId)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local modelWagon = nil
    local wagonId = tonumber(data.WagonId)

    MySQL.Async.fetchAll('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', { identifier, charid },
        function(wagons)
            for i = 1, #wagons do
                if tonumber(wagons[i].id) == wagonId then
                    modelWagon = wagons[i].model
                    MySQL.Async.execute('DELETE FROM player_wagons WHERE identifier = ? AND charid = ? AND id = ?',
                        { identifier, charid, wagonId },
                        function(done)
                            for _, wagonModels in pairs(Config.wagonShops[shopId].wagons) do
                                for model, wagonConfig in pairs(wagonModels["types"]) do
                                    if model == modelWagon then
                                        local sellPrice = wagonConfig.sellPrice
                                        Character.addCurrency(0, sellPrice)
                                        VORPcore.NotifyRightTip(_source,
                                            _U("soldWagon") .. data.WagonName .. _U("frcash") .. sellPrice, 5000)
                                    end
                                end
                            end
                        end)
                end
            end
            TriggerClientEvent('bcc-wagons:WagonMenu', _source)
        end)
end)

-- Register Wagon Inventory
RegisterNetEvent('bcc-wagons:RegisterInventory', function(id, wagonModel, shopId)
    for _, wagonModels in pairs(Config.wagonShops[shopId].wagons) do
        for model, wagonConfig in pairs(wagonModels) do
            if model ~= "wagonType" then
                if model == wagonModel then
                    VORPInv.registerInventory("wagon_" .. tostring(id), _U("wagonInv"), tonumber(wagonConfig.invLimit))
                end
            end
        end
    end
end)

-- Open Wagon Inventory
RegisterNetEvent('bcc-wagons:OpenInventory', function(id)
    local _source = source
    VORPInv.OpenInv(_source, "wagon_" .. tostring(id))
end)

-- Check Player Job and Job Grade
RegisterNetEvent('bcc-wagons:getPlayerJob', function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local CharacterJob = Character.job
    local CharacterGrade = Character.jobGrade
    TriggerClientEvent('bcc-wagons:sendPlayerJob', _source, CharacterJob, CharacterGrade)
end)
