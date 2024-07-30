ESX = exports["es_extended"]:getSharedObject()
ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        cb({
            group = xPlayer.getGroup()
        })
    else
        cb(nil)
    end
end)
RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
    local xPlayer = ESX.GetPlayerFromId(target)

    if xPlayer then
        TriggerClientEvent('esx_ambulancejob:revive', target)
    end
end)

RegisterServerEvent('esx_ambulancejob:healAndRestore')
AddEventHandler('esx_ambulancejob:healAndRestore', function(target)
    local xPlayer = ESX.GetPlayerFromId(target)

    if xPlayer then
        
        TriggerClientEvent('esx_ambulancejob:heal', target, 'big')

        
        TriggerClientEvent('esx_status:set', target, 'hunger', 1000000)
        TriggerClientEvent('esx_status:set', target, 'thirst', 1000000)
    end
end)
RegisterServerEvent('example:getPlayerMoney')
AddEventHandler('example:getPlayerMoney', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash = xPlayer.getMoney()
    local bank = xPlayer.getAccount('bank').money
    local dirty = xPlayer.getAccount('black_money').money

    TriggerClientEvent('example:setPlayerMoney', source, cash, bank, dirty)
end)

ESX.RegisterServerCallback('example:getPlayerInfo', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local employees = {}

    if xPlayer.job.grade_name == 'boss' then
        exports.oxmysql:execute('SELECT identifier, firstname, lastname, job, job_grade FROM users WHERE job = ?', {xPlayer.job.name}, function(result)
            for i=1, #result, 1 do
                table.insert(employees, {
                    name = result[i].firstname .. " " .. result[i].lastname,
                    identifier = result[i].identifier,
                    job = {
                        name = result[i].job,
                        grade = result[i].job_grade
                    }
                })
            end

            local playerInfo = {
                name = xPlayer.getName(),
                job = xPlayer.job,
                job2 = xPlayer.job2,
                isBoss = xPlayer.job.grade_name == 'boss',
                employees = employees
            }
            cb(playerInfo)
        end)
    else
        local playerInfo = {
            name = xPlayer.getName(),
            job = xPlayer.job,
            job2 = xPlayer.job2,
            isBoss = false,
            employees = employees
        }
        cb(playerInfo)
    end
end)

ESX.RegisterServerCallback('example:getEmployees', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local employees = {}

    if xPlayer.job.grade_name == 'boss' then
        exports.oxmysql:execute('SELECT identifier, firstname, lastname, job, job_grade FROM users WHERE job = ?', {xPlayer.job.name}, function(result)
            for i=1, #result, 1 do
                table.insert(employees, {
                    name = result[i].firstname .. " " .. result[i].lastname,
                    identifier = result[i].identifier,
                    job = {
                        name = result[i].job,
                        grade = result[i].job_grade
                    }
                })
            end
            cb(employees)
        end)
    else
        cb(employees)
    end
end)

RegisterServerEvent('example:hirePlayer')
AddEventHandler('example:hirePlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.job.grade_name == 'boss' then
        xTarget.setJob(xPlayer.job.name, 0)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez embauché ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été embauché par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:firePlayer')
AddEventHandler('example:firePlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.job.grade_name == 'boss' then
        xTarget.setJob('unemployed', 0)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez licencié ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été licencié par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:promotePlayer')
AddEventHandler('example:promotePlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.job.grade_name == 'boss' then
        local newGrade = xTarget.job.grade + 1
        xTarget.setJob(xPlayer.job.name, newGrade)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez promu ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été promu par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:demotePlayer')
AddEventHandler('example:demotePlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.job.grade_name == 'boss' then
        local newGrade = xTarget.job.grade - 1
        if newGrade >= 0 then
            xTarget.setJob(xPlayer.job.name, newGrade)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez rétrogradé ~b~" .. xTarget.getName())
            TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été rétrogradé par ~b~" .. xPlayer.getName())
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Impossible de rétrograder davantage.")
        end
    end
end)

-- Gestion des organisations

ESX.RegisterServerCallback('example:getOrganizationInfo', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local members = {}

    if xPlayer.job2.grade_name == 'boss' then
        exports.oxmysql:execute('SELECT identifier, firstname, lastname, job2, job2_grade FROM users WHERE job2 = ?', {xPlayer.job2.name}, function(result)
            for i=1, #result, 1 do
                table.insert(members, {
                    name = result[i].firstname .. " " .. result[i].lastname,
                    identifier = result[i].identifier,
                    job2 = {
                        name = result[i].job2,
                        grade = result[i].job2_grade
                    }
                })
            end

            local orgInfo = {
                name = xPlayer.getName(),
                job2 = xPlayer.job2,
                isBoss = xPlayer.job2.grade_name == 'boss',
                members = members
            }
            cb(orgInfo)
        end)
    else
        local orgInfo = {
            name = xPlayer.getName(),
            job2 = xPlayer.job2,
            isBoss = false,
            members = members
        }
        cb(orgInfo)
    end
end)

ESX.RegisterServerCallback('example:getOrganizationMembers', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local members = {}

    if xPlayer.job2.grade_name == 'boss' then
        exports.oxmysql:execute('SELECT identifier, firstname, lastname, job2, job2_grade FROM users WHERE job2 = ?', {xPlayer.job2.name}, function(result)
            for i=1, #result, 1 do
                table.insert(members, {
                    name = result[i].firstname .. " " .. result[i].lastname,
                    identifier = result[i].identifier,
                    job2 = {
                        name = result[i].job2,
                        grade = result[i].job2_grade
                    }
                })
            end
            cb(members)
        end)
    else
        cb(members)
    end
end)

RegisterServerEvent('example:hireOrganizationMember')
AddEventHandler('example:hireOrganizationMember', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.job2.grade_name == 'boss' then
        xTarget.setJob2(xPlayer.job2.name, 0)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez embauché ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été embauché par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:fireOrganizationMember')
AddEventHandler('example:fireOrganizationMember', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.job2.grade_name == 'boss' then
        xTarget.setJob2('unemployed', 0)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez licencié ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été licencié par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:promoteOrganizationMember')
AddEventHandler('example:promoteOrganizationMember', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.job2.grade_name == 'boss' then
        local newGrade = xTarget.job2.grade + 1
        xTarget.setJob2(xPlayer.job2.name, newGrade)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez promu ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été promu par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:demoteOrganizationMember')
AddEventHandler('example:demoteOrganizationMember', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.job2.grade_name == 'boss' then
        local newGrade = xTarget.job2.grade - 1
        if newGrade >= 0 then
            xTarget.setJob2(xPlayer.job2.name, newGrade)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez rétrogradé ~b~" .. xTarget.getName())
            TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été rétrogradé par ~b~" .. xPlayer.getName())
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Impossible de rétrograder davantage.")
        end
    end
end)

ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('esx:getPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        cb({
            items = xPlayer.inventory,
            weapons = xPlayer.loadout,
            money = xPlayer.getMoney()
        })
    else
        cb(nil)
    end
end)


RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(itemType, itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if itemType == 'item_standard' then
        xPlayer.removeInventoryItem(itemName, count)
    elseif itemType == 'item_money' then
        xPlayer.removeMoney(count)
    elseif itemType == 'item_account' then
        xPlayer.removeAccountMoney(itemName, count)
    elseif itemType == 'item_weapon' then
        xPlayer.removeWeapon(itemName)
    end
end)

RegisterNetEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(target, itemType, itemName, count)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(target)

    if targetPlayer then
        if itemType == 'item_standard' then
            local sourceItem = sourcePlayer.getInventoryItem(itemName)
            if sourceItem.count >= count then
                sourcePlayer.removeInventoryItem(itemName, count)
                targetPlayer.addInventoryItem(itemName, count)
            end
        elseif itemType == 'item_money' then
            if sourcePlayer.getMoney() >= count then
                sourcePlayer.removeMoney(count)
                targetPlayer.addMoney(count)
            end
        elseif itemType == 'item_account' then
            if sourcePlayer.getAccount(itemName).money >= count then
                sourcePlayer.removeAccountMoney(itemName, count)
                targetPlayer.addAccountMoney(itemName, count)
            end
        elseif itemType == 'item_weapon' then
            if sourcePlayer.hasWeapon(itemName) then
                sourcePlayer.removeWeapon(itemName)
                targetPlayer.addWeapon(itemName, count)
            end
        end
    end
end)

Config = Config or {}

RegisterServerEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemName)

    if item.count > 0 then
        -- Vérifier si l'objet est utilisable
        if Config.UsableItems[itemName] then
            -- Appeler la fonction d'utilisation de l'objet depuis ESX
            ESX.UseItem(xPlayer.source, itemName)
           
        else
            TriggerClientEvent('esx:showNotification', source, 'Cet objet n\'est pas utilisable.')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas cet objet.')
    end
end)

