local VORPcore = exports.vorp_core:GetCore()

VORPcore.Callback.Register('bcc-wagons:BuyWagon', function(source, cb, data)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier
    local maxWagons = Config.maxPlayerWagons
    if data.isWainwright then
        maxWagons = Config.maxWainwrightWagons
    end
    local wagons = MySQL.query.await('SELECT * FROM `player_wagons` WHERE `charid` = ?', { charid })
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
        end
    else
        if Character.gold >= data.Gold then
            cb(true)
        else
            VORPcore.NotifyRightTip(src, _U('shortGold'), 4000)
            cb(false)
        end
    end
end)

VORPcore.Callback.Register('bcc-wagons:SaveNewWagon', function(source, cb, wagonInfo)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    MySQL.query.await('INSERT INTO `player_wagons` (identifier, charid, name, model) VALUES (?, ?, ?, ?)',
        { identifier, charid, wagonInfo.name, wagonInfo.wagonData.ModelW })
    if wagonInfo.wagonData.IsCash then
        Character.removeCurrency(0, wagonInfo.wagonData.Cash)
    else
        Character.removeCurrency(1, wagonInfo.wagonData.Gold)
    end
    cb(true)
end)

VORPcore.Callback.Register('bcc-wagons:UpdateWagonName', function(source, cb, wagonInfo)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier

    MySQL.query.await('UPDATE `player_wagons` SET `name` = ? WHERE `charid` = ? AND `id` = ?', { wagonInfo.name, charid, wagonInfo.wagonData.WagonId })
    cb(true)
end)

RegisterServerEvent('bcc-wagons:SelectWagon', function(data)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier
    local id = tonumber(data.WagonId)

    local wagon = MySQL.query.await('SELECT * FROM `player_wagons` WHERE `charid` = ?', { charid })
    for i = 1, #wagon do
        MySQL.query.await('UPDATE `player_wagons` SET `selected` = ? WHERE `charid` = ? AND `id` = ?', { 0, charid, wagon[i].id })
        if wagon[i].id == id then
            MySQL.query.await('UPDATE `player_wagons` SET `selected` = ? WHERE `charid` = ? AND `id` = ?', { 1, charid, id })
        end
    end
end)

VORPcore.Callback.Register('bcc-wagons:GetWagonData', function(source, cb)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier
    local data = nil

    local wagons = MySQL.query.await('SELECT * FROM `player_wagons` WHERE `charid` = ?', { charid })
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

RegisterNetEvent('bcc-wagons:GetMyWagons', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier

    local wagons = MySQL.query.await('SELECT * FROM `player_wagons` WHERE `charid` = ?', { charid })
    TriggerClientEvent('bcc-wagons:WagonsData', src, wagons)
end)

VORPcore.Callback.Register('bcc-wagons:SellMyWagon', function(source, cb, data, site)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charid = Character.charIdentifier
    local modelWagon = nil
    local id = tonumber(data.WagonId)

    local wagons = MySQL.query.await('SELECT * FROM `player_wagons` WHERE `charid` = ?', { charid })
    for i = 1, #wagons do
        if tonumber(wagons[i].id) == id then
            modelWagon = wagons[i].model
            MySQL.query.await('DELETE FROM `player_wagons` WHERE `charid` = ? AND `id` = ?', { charid, id })
        end
    end
    for _, wagonModels in pairs(Wagons) do
        for model, wagonConfig in pairs(wagonModels.types) do
            if model == modelWagon then
                local sellPrice = (Config.sellPrice * wagonConfig.cashPrice)
                Character.addCurrency(0, sellPrice)
                VORPcore.NotifyRightTip(src, _U('soldWagon') .. data.WagonName .. _U('frcash') .. sellPrice, 4000)
                cb(true)
            end
        end
    end
end)

VORPcore.Callback.Register('bcc-wagons:SaveWagonTrade', function(source, cb, serverId, wagonId)
    -- Current Owner
    local src = source
    local curOwner = VORPcore.getUser(src).getUsedCharacter
    local curOwnerName = curOwner.firstname .. " " .. curOwner.lastname
    -- New Owner
    local newOwner = VORPcore.getUser(serverId).getUsedCharacter
    local newOwnerId = newOwner.identifier
    local newOwnerCharId = newOwner.charIdentifier
    local newOwnerName = newOwner.firstname .. " " .. newOwner.lastname
    local charJob = newOwner.job
    local jobGrade = newOwner.jobGrade

    local isWainwright = false
    isWainwright = CheckPlayerJob(charJob, jobGrade, Config.wainwrightJob)
    local maxWagons = Config.maxPlayerWagons
    if isWainwright then
        maxWagons = Config.maxWainwrightWagons
    end
    local wagons = MySQL.query.await('SELECT * FROM `player_wagons` WHERE `charid` = ?', { newOwnerCharId })
    if #wagons >= maxWagons then
        VORPcore.NotifyRightTip(src, _U('tradeFailed') .. newOwnerName .. _U('tooManyWagons'), 5000)
        cb(false)
        return
    end

    MySQL.query.await('UPDATE `player_wagons` SET `identifier` = ?, `charid` = ?, `selected` = ? WHERE `id` = ?', { newOwnerId, newOwnerCharId, 0, wagonId })

    VORPcore.NotifyRightTip(src, _U('youGave') .. newOwnerName .. _U('aWagon'), 4000)
    VORPcore.NotifyRightTip(serverId, curOwnerName .._U('gaveWagon'), 4000)
    cb(true)
end)

RegisterServerEvent('bcc-wagons:RegisterInventory', function(id, wagonModel)
    for _, wagonModels in pairs(Wagons) do
        for model, wagonConfig in pairs(wagonModels.types) do
            if model == wagonModel then
                local data = {
                    id = 'wagon_' .. tostring(id),
                    name = _U('wagonInv'),
                    limit = tonumber(wagonConfig.invLimit),
                    acceptWeapons = Config.inventory.weapons,
                    shared = Config.inventory.shared,
                    ignoreItemStackLimit = true,
                    whitelistItems = false,
                    UsePermissions = false,
                    UseBlackList = false,
                    whitelistWeapons = false
                }
                exports.vorp_inventory:registerInventory(data)
            end
        end
    end
end)

RegisterServerEvent('bcc-wagons:OpenInventory', function(id)
    local src = source
    exports.vorp_inventory:openInventory(src, 'wagon_' .. tostring(id))
end)

VORPcore.Callback.Register('bcc-wagons:CheckJob', function(source, cb, wainwright, site)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charJob = Character.job
    local jobGrade = Character.jobGrade
    if not charJob then
        cb(false)
        return
    end
    local jobConfig
    if wainwright then
        jobConfig = Config.wainwrightJob
    else
        jobConfig = Sites[site].shop.jobs
    end
    local hasJob = false
    hasJob = CheckPlayerJob(charJob, jobGrade, jobConfig)
    if hasJob then
        cb({true, charJob})
    else
        cb({false, charJob})
    end
end)

function CheckPlayerJob(charJob, jobGrade, jobConfig)
    for _, job in pairs(jobConfig) do
        if (charJob == job.name) and (tonumber(jobGrade) >= tonumber(job.grade)) then
            return true
        end
    end
end
