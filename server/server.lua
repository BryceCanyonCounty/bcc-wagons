local VORPcore = {}
TriggerEvent('getCore', function(core)
    VORPcore = core
end)
local ServerRPC = exports.vorp_core:ServerRpcCall()

-- Buy New Wagons
ServerRPC.Callback.Register('bcc-wagons:BuyWagon', function(source, cb, data)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier
    local maxWagons = Config.maxWagons

    local wagons = MySQL.query.await('SELECT * FROM player_wagons WHERE charid = ?', { charid })
    if #wagons >= maxWagons then
        VORPcore.NotifyRightTip(src, _U('wagonLimit') .. maxWagons .. _U('wagons'), 4000)
        cb(false)
        return
    end
    if data.IsCash then
        if Character.money >= data.Cash then
            cb(true)
        else
            VORPcore.NotifyRightTip(src, _U('shortCash'), 4000)
            cb(false)
            return
        end
    else
        if Character.gold >= data.Gold then
            cb(true)
        else
            VORPcore.NotifyRightTip(src, _U('shortGold'), 4000)
            cb(false)
            return
        end
    end
end)

-- Save New Wagon Purchase to Database
ServerRPC.Callback.Register('bcc-wagons:SaveNewWagon', function(source, cb, wagonInfo)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    MySQL.query.await('INSERT INTO player_wagons (identifier, charid, name, model) VALUES (?, ?, ?, ?)',
        { identifier, charid, wagonInfo.name, wagonInfo.wagonData.ModelW })
    if wagonInfo.wagonData.IsCash then
        Character.removeCurrency(0, wagonInfo.wagonData.Cash)
    else
        Character.removeCurrency(1, wagonInfo.wagonData.Gold)
    end
    cb(true)
end)

-- Rename Owned Wagons
ServerRPC.Callback.Register('bcc-wagons:UpdateWagonName', function(source, cb, wagonInfo)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier

    MySQL.query.await('UPDATE player_wagons SET name = ? WHERE charid = ? AND id = ?', { wagonInfo.name, charid, wagonInfo.wagonData.WagonId })
    cb(true)
end)

RegisterServerEvent('bcc-wagons:SelectWagon', function(data)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier
    local id = tonumber(data.WagonId)

    local wagon = MySQL.query.await('SELECT * FROM player_wagons WHERE charid = ?', { charid })
    for i = 1, #wagon do
        MySQL.query.await('UPDATE player_wagons SET selected = ? WHERE charid = ? AND id = ?', { 0, charid, wagon[i].id })
        if wagon[i].id == id then
            MySQL.query.await('UPDATE player_wagons SET selected = ? WHERE charid = ? AND id = ?', { 1, charid, id })
        end
    end
end)

-- Get Selected Player Owned Wagon
ServerRPC.Callback.Register('bcc-wagons:GetWagonData', function(source, cb)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier
    local data = nil

    local wagons = MySQL.query.await('SELECT * FROM player_wagons WHERE charid = ?', { charid })
    if #wagons ~= 0 then
        for i = 1, #wagons do
            if wagons[i].selected == 1 then
                TriggerClientEvent('bcc-wagons:SpawnWagon', src, wagons[i].model, wagons[i].name, wagons[i].id)
                data = {
                    model = wagons[i].model,
                    name = wagons[i].name,
                    id = wagons[i].id
                }
                cb(data)
            end
        end
        if data == nil then
            VORPcore.NotifyRightTip(src, _U('noSelectedWagon'), 4000)
            cb(false)
        end
    else
        VORPcore.NotifyRightTip(src, _U('noOwnedWagons'), 4000)
        cb(false)
    end
end)

-- Get Player Owned Wagons
RegisterNetEvent('bcc-wagons:GetMyWagons', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier

    local wagons = MySQL.query.await('SELECT * FROM player_wagons WHERE charid = ?', { charid })
    TriggerClientEvent('bcc-wagons:WagonsData', src, wagons)
end)

-- Sell Player Owned Wagons
ServerRPC.Callback.Register('bcc-wagons:SellMyWagon', function(source, cb, data, shopId)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier
    local modelWagon = nil
    local id = tonumber(data.WagonId)

    local wagons = MySQL.query.await('SELECT * FROM player_wagons WHERE charid = ?', { charid })
    for i = 1, #wagons do
        if tonumber(wagons[i].id) == id then
            modelWagon = wagons[i].model
            MySQL.query.await('DELETE FROM player_wagons WHERE charid = ? AND id = ?', { charid, id })
        end
    end
    for _, wagonModels in pairs(Config.shops[shopId].wagons) do
        for model, wagonConfig in pairs(wagonModels['types']) do
            if model == modelWagon then
                local sellPrice = (Config.sellPrice * wagonConfig.cashPrice)
                Character.addCurrency(0, sellPrice)
                VORPcore.NotifyRightTip(src, _U('soldWagon') .. data.WagonName .. _U('frcash') .. sellPrice, 4000)
                cb(true)
            end
        end
    end
end)

-- Register Wagon Inventory
RegisterServerEvent('bcc-wagons:RegisterInventory', function(id, wagonModel)
    for model, invConfig in pairs(Config.inventory) do
        if model == wagonModel then
            local data = {
                id = 'wagon_' .. tostring(id),
                name = _U('wagonInv'),
                limit = tonumber(invConfig.slots),
                acceptWeapons = true,
                shared = false,
                ignoreItemStackLimit = true,
                whitelistItems = false,
                UsePermissions = false,
                UseBlackList = false,
                whitelistWeapons = false
            }
            exports.vorp_inventory:registerInventory(data)
        end
    end
end)

-- Open Wagon Inventory
RegisterServerEvent('bcc-wagons:OpenInventory', function(id)
    local src = source
    exports.vorp_inventory:openInventory(src, 'wagon_' .. tostring(id))
end)

-- Check if Player has Required Job
ServerRPC.Callback.Register('bcc-wagons:CheckPlayerJob', function(source, cb, shop)
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
