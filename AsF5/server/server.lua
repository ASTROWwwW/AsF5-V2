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
-- Fix: server-side admin check + target validation to prevent free revive by any client
RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Fix: only admins may trigger a revive; the source group is the source of truth, not the client
    if not (xPlayer and (xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'owner')) then return end

    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    -- Fix: validate the target exists before triggering anything
    if not xTarget then return end

    TriggerClientEvent('esx_ambulancejob:revive', xTarget.source)
end)

-- Fix: server-side admin check + target validation to prevent free heal/restore by any client
RegisterServerEvent('esx_ambulancejob:healAndRestore')
AddEventHandler('esx_ambulancejob:healAndRestore', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Fix: only admins may trigger heal/restore
    if not (xPlayer and (xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'owner')) then return end

    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    -- Fix: validate the target exists before triggering anything
    if not xTarget then return end

    TriggerClientEvent('esx_ambulancejob:heal', xTarget.source, 'big')

    TriggerClientEvent('esx_status:set', xTarget.source, 'hunger', 1000000)
    TriggerClientEvent('esx_status:set', xTarget.source, 'thirst', 1000000)
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
    -- Fix: guard against a missing player so the callback never dereferences nil
    if not xPlayer then return cb(nil) end

    local employees = {}
    local organizationMembers = {}
    -- Fix: the client (menu.lua) reads isOrgBoss/organizationMembers; compute org boss status here
    local isBoss = xPlayer.job and xPlayer.job.grade_name == 'boss'
    local isOrgBoss = xPlayer.job2 and xPlayer.job2.grade_name == 'boss'

    -- Fix: load org (job2) members when the player is an org boss so the Organisation menu works
    local function loadOrgMembers(done)
        if isOrgBoss then
            exports.oxmysql:execute('SELECT identifier, firstname, lastname, job2, job2_grade FROM users WHERE job2 = ?', {xPlayer.job2.name}, function(result)
                for i=1, #result, 1 do
                    table.insert(organizationMembers, {
                        name = result[i].firstname .. " " .. result[i].lastname,
                        identifier = result[i].identifier,
                        job2 = {
                            name = result[i].job2,
                            grade = result[i].job2_grade
                        }
                    })
                end
                done()
            end)
        else
            done()
        end
    end

    local function buildAndSend()
        cb({
            name = xPlayer.getName(),
            job = xPlayer.job,
            job2 = xPlayer.job2,
            isBoss = isBoss,
            -- Fix: expose isOrgBoss and organizationMembers expected by the client menu
            isOrgBoss = isOrgBoss,
            employees = employees,
            organizationMembers = organizationMembers
        })
    end

    if isBoss then
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
            loadOrgMembers(buildAndSend)
        end)
    else
        loadOrgMembers(buildAndSend)
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

-- Fix: helper to fetch the highest grade of a job from job_grades (prevents promoting above the max grade)
local function getMaxJobGrade(jobName)
    local result = exports.oxmysql:executeSync('SELECT MAX(grade) AS maxGrade FROM job_grades WHERE job_name = ?', {jobName})
    if result and result[1] and result[1].maxGrade then
        return tonumber(result[1].maxGrade)
    end
    return nil
end

RegisterServerEvent('example:hirePlayer')
AddEventHandler('example:hirePlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Fix: nil-check source and target before dereferencing to avoid a server crash
    if not xPlayer then return end
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if not xTarget then return end

    if xPlayer.job.grade_name == 'boss' then
        xTarget.setJob(xPlayer.job.name, 0)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez embauché ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été embauché par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:firePlayer')
AddEventHandler('example:firePlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Fix: nil-check source and target before dereferencing to avoid a server crash
    if not xPlayer then return end
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if not xTarget then return end

    -- Fix: only allow firing a member of the boss's own company
    if xPlayer.job.grade_name == 'boss' and xTarget.job.name == xPlayer.job.name then
        xTarget.setJob('unemployed', 0)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez licencié ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été licencié par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:promotePlayer')
AddEventHandler('example:promotePlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Fix: nil-check source and target before dereferencing to avoid a server crash
    if not xPlayer then return end
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if not xTarget then return end

    -- Fix: only a boss can promote, and only members of their own company
    if xPlayer.job.grade_name == 'boss' and xTarget.job.name == xPlayer.job.name then
        local newGrade = xTarget.job.grade + 1
        -- Fix: cap promotion at the job's max grade so a boss cannot escalate grades out of bounds
        local maxGrade = getMaxJobGrade(xPlayer.job.name)
        if maxGrade and newGrade > maxGrade then
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Grade maximum atteint.")
            return
        end
        xTarget.setJob(xPlayer.job.name, newGrade)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez promu ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été promu par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:demotePlayer')
AddEventHandler('example:demotePlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Fix: nil-check source and target before dereferencing to avoid a server crash
    if not xPlayer then return end
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if not xTarget then return end

    -- Fix: only a boss can demote, and only members of their own company
    if xPlayer.job.grade_name == 'boss' and xTarget.job.name == xPlayer.job.name then
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
    -- Fix: nil-check source and target before dereferencing to avoid a server crash
    if not xPlayer then return end
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if not xTarget then return end

    if xPlayer.job2.grade_name == 'boss' then
        xTarget.setJob2(xPlayer.job2.name, 0)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez embauché ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été embauché par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:fireOrganizationMember')
AddEventHandler('example:fireOrganizationMember', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Fix: nil-check source and target before dereferencing to avoid a server crash
    if not xPlayer then return end
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if not xTarget then return end

    -- Fix: only allow firing a member of the boss's own organization
    if xPlayer.job2.grade_name == 'boss' and xTarget.job2.name == xPlayer.job2.name then
        xTarget.setJob2('unemployed', 0)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez licencié ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été licencié par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:promoteOrganizationMember')
AddEventHandler('example:promoteOrganizationMember', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Fix: nil-check source and target before dereferencing to avoid a server crash
    if not xPlayer then return end
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if not xTarget then return end

    -- Fix: only a boss can promote, and only members of their own organization
    if xPlayer.job2.grade_name == 'boss' and xTarget.job2.name == xPlayer.job2.name then
        local newGrade = xTarget.job2.grade + 1
        -- Fix: cap promotion at the org's max grade so a boss cannot escalate grades out of bounds
        local maxGrade = getMaxJobGrade(xPlayer.job2.name)
        if maxGrade and newGrade > maxGrade then
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Grade maximum atteint.")
            return
        end
        xTarget.setJob2(xPlayer.job2.name, newGrade)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez promu ~b~" .. xTarget.getName())
        TriggerClientEvent('esx:showNotification', xTarget.source, "Vous avez été promu par ~b~" .. xPlayer.getName())
    end
end)

RegisterServerEvent('example:demoteOrganizationMember')
AddEventHandler('example:demoteOrganizationMember', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Fix: nil-check source and target before dereferencing to avoid a server crash
    if not xPlayer then return end
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if not xTarget then return end

    -- Fix: only a boss can demote, and only members of their own organization
    if xPlayer.job2.grade_name == 'boss' and xTarget.job2.name == xPlayer.job2.name then
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
    -- Fix: guard against a missing player
    if not xPlayer then return end
    -- Fix: count comes from the client; reject non-positive/non-integer values to prevent money/item dupe
    count = tonumber(count)
    if not count or count <= 0 or count % 1 ~= 0 then return end

    if itemType == 'item_standard' then
        -- Fix: verify the player actually owns at least 'count' before removing
        local item = xPlayer.getInventoryItem(itemName)
        if item and item.count >= count then
            xPlayer.removeInventoryItem(itemName, count)
        end
    elseif itemType == 'item_money' then
        -- Fix: verify the player has enough cash before removing
        if xPlayer.getMoney() >= count then
            xPlayer.removeMoney(count)
        end
    elseif itemType == 'item_account' then
        -- Fix: verify the account holds enough before removing
        local account = xPlayer.getAccount(itemName)
        if account and account.money >= count then
            xPlayer.removeAccountMoney(itemName, count)
        end
    elseif itemType == 'item_weapon' then
        xPlayer.removeWeapon(itemName)
    end
end)

RegisterNetEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(target, itemType, itemName, count)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    -- Fix: guard against a missing source player
    if not sourcePlayer then return end
    local targetPlayer = ESX.GetPlayerFromId(tonumber(target))

    -- Fix: count comes from the client; reject non-positive/non-integer values to prevent money/item dupe via negative count
    count = tonumber(count)
    if not count or count <= 0 or count % 1 ~= 0 then return end

    -- Fix: cannot give to yourself (would let the dupe round-trip)
    if targetPlayer and targetPlayer.source ~= sourcePlayer.source then
        if itemType == 'item_standard' then
            local sourceItem = sourcePlayer.getInventoryItem(itemName)
            -- Fix: nil-check the item and verify ownership before transferring
            if sourceItem and sourceItem.count >= count then
                sourcePlayer.removeInventoryItem(itemName, count)
                targetPlayer.addInventoryItem(itemName, count)
            end
        elseif itemType == 'item_money' then
            if sourcePlayer.getMoney() >= count then
                sourcePlayer.removeMoney(count)
                targetPlayer.addMoney(count)
            end
        elseif itemType == 'item_account' then
            local account = sourcePlayer.getAccount(itemName)
            -- Fix: nil-check the account before reading its balance
            if account and account.money >= count then
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
    -- Fix: guard against a missing player / unknown item before dereferencing
    if not xPlayer then return end
    local item = xPlayer.getInventoryItem(itemName)
    if not item then return end

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

