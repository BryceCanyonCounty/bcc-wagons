local VORPcore = {}
local VORPInv = {}
TriggerEvent('getCore', function(core)
    VORPcore = core
end)
VORPInv = exports.vorp_inventory:vorp_inventoryApi()

-- Buy New Wagons
RegisterNetEvent('bcc-wagons:BuyWagon', function(data)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local maxWagons = Config.maxWagons

    local wagons = MySQL.query.await('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', { identifier, charid })
    if #wagons >= maxWagons then
        VORPcore.NotifyRightTip(src, _U('wagonLimit') .. maxWagons .. _U('wagons'), 4000)
        TriggerClientEvent('bcc-wagons:WagonMenu', src)
        return
    end
    if data.IsCash then
        if Character.money >= data.Cash then
            TriggerClientEvent('bcc-wagons:SetWagonName', src, data, false)
        else
            VORPcore.NotifyRightTip(src, _U('shortCash'), 4000)
            TriggerClientEvent('bcc-wagons:WagonMenu', src)
            return
        end
    else
        if Character.gold >= data.Gold then
            TriggerClientEvent('bcc-wagons:SetWagonName', src, data, false)
        else
            VORPcore.NotifyRightTip(src, _U('shortGold'), 4000)
            TriggerClientEvent('bcc-wagons:WagonMenu', src)
            return
        end
    end
end)

-- Save New Wagon Purchase to Database
RegisterNetEvent('bcc-wagons:SaveNewWagon', function(data, name)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    MySQL.query.await('INSERT INTO player_wagons (identifier, charid, name, model) VALUES (?, ?, ?, ?)', { identifier, charid, name, data.ModelW })
    if data.IsCash then
        Character.removeCurrency(0, data.Cash)
    else
        Character.removeCurrency(1, data.Gold)
    end
    TriggerClientEvent('bcc-wagons:WagonMenu', src)
end)

-- Rename Owned Wagons
RegisterNetEvent('bcc-wagons:UpdateWagonName', function(data, name)
    local src = source

    MySQL.query.await('UPDATE player_wagons SET name = ? WHERE id = ?', { name, data.WagonId })
    TriggerClientEvent('bcc-wagons:WagonMenu', src)
end)

RegisterNetEvent('bcc-wagons:SelectWagon', function(data)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local id = tonumber(data.WagonId)

    local wagon = MySQL.query.await('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', { identifier, charid })
    for i = 1, #wagon do
        MySQL.query.await('UPDATE player_wagons SET selected = ? WHERE identifier = ? AND charid = ? AND id = ?', { 0, identifier, charid, wagon[i].id })
        if wagon[i].id == id then
            MySQL.query.await('UPDATE player_wagons SET selected = ? WHERE identifier = ? AND charid = ? AND id = ?', { 1, identifier, charid, id })
        end
    end
end)

-- Get Selected Player Owned Wagon
RegisterNetEvent('bcc-wagons:GetSelectedWagon', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    local wagons = MySQL.query.await('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', { identifier, charid })
    if #wagons ~= 0 then
        for i = 1, #wagons do
            if wagons[i].selected == 1 then
                TriggerClientEvent('bcc-wagons:SpawnWagon', src, wagons[i].model, wagons[i].name, false, wagons[i].id)
            end
        end
    else
        VORPcore.NotifyRightTip(src, _U('noOwnedWagons'), 4000)
    end
end)

-- Get Player Owned Wagons
RegisterNetEvent('bcc-wagons:GetMyWagons', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    local wagons = MySQL.query.await('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', { identifier, charid })
    TriggerClientEvent('bcc-wagons:WagonsData', src, wagons)
end)

-- Sell Player Owned Wagons
RegisterNetEvent('bcc-wagons:SellWagon', function(data, shopId)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local modelWagon = nil
    local wagonId = tonumber(data.WagonId)

    local wagons = MySQL.query.await('SELECT * FROM player_wagons WHERE identifier = ? AND charid = ?', { identifier, charid })
    for i = 1, #wagons do
        if tonumber(wagons[i].id) == wagonId then
            modelWagon = wagons[i].model
            MySQL.query.await('DELETE FROM player_wagons WHERE identifier = ? AND charid = ? AND id = ?', { identifier, charid, wagonId })
        end
    end
    for _, wagonModels in pairs(Config.shops[shopId].wagons) do
        for model, wagonConfig in pairs(wagonModels['types']) do
            if model == modelWagon then
                local sellPrice = (Config.sellPrice * wagonConfig.cashPrice)
                Character.addCurrency(0, sellPrice)
                VORPcore.NotifyRightTip(src, _U('soldWagon') .. data.WagonName .. _U('frcash') .. sellPrice, 4000)
            end
        end
    end
    TriggerClientEvent('bcc-wagons:WagonMenu', src)
end)

-- Register Wagon Inventory
RegisterNetEvent('bcc-wagons:RegisterInventory', function(id, wagonModel)
    for model, invConfig in pairs(Config.inventory) do
        if model == wagonModel then
            VORPInv.registerInventory('wagon_' .. tostring(id), _U('wagonInv'), tonumber(invConfig.invLimit), true, false, true)
        end
    end
end)

-- Open Wagon Inventory
RegisterNetEvent('bcc-wagons:OpenInventory', function(id)
    local src = source
    VORPInv.OpenInv(src, 'wagon_' .. tostring(id))
end)

-- Check if Player has Required Job
VORPcore.addRpcCallback('CheckPlayerJob', function(source, cb, shop)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local playerJob = Character.job
    local jobGrade = Character.jobGrade

    if playerJob then
        for _, job in pairs(Config.shops[shop].allowedJobs) do
            if playerJob == job then
                if tonumber(jobGrade) >= tonumber(Config.shops[shop].jobGrade) then
                    cb(true)
                    return
                end
            end
        end
    end
    VORPcore.NotifyRightTip(src, _U('needJob'), 4000)
    cb(false)
end)
