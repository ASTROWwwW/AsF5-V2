ESX = exports["es_extended"]:getSharedObject()
local playerGroup = nil
local isInvisible = false
local noClipEnabled = false
local noClipSpeed = 1.0
local maxSpeed = 10.0
local doorList = {"Avant gauche", "Avant droite", "Arrière gauche", "Arrière droite", "Capot", "Coffre"}
local selectedDoor = 1
local previousClothes = {
    top = { drawable = nil, texture = nil, palette = nil, arms = nil },
    pants = { drawable = nil, texture = nil, palette = nil },
    shoes = { drawable = nil, texture = nil, palette = nil },
    hat = { drawable = nil, texture = nil },
    glasses = { drawable = nil, texture = nil },
    accessories = { drawable = nil, texture = nil, palette = nil },
    watches = { drawable = nil, texture = nil },
    bracelets = { drawable = nil, texture = nil }
}



local windowList = {"Avant gauche", "Avant droite", "Arrière gauche", "Arrière droite"}
local selectedWindow = 1
local speedLimiterList = {"30 km/h", "50 km/h", "80 km/h", "100 km/h", "120 km/h", "Personnalisé"}
local selectedSpeedLimiter = 1
local speedLimit = nil

local minSpeed = 0.1
local isMenuOpen = false
local mainMenu = nil
local portefeuilleMenu = nil
local enterpriseMenu = nil
local organizationMenu = nil
local vehicleMenu = nil
local employeesMenu = nil
local organizationMembersMenu = nil
local miscellaneousMenu = nil
local controlsMenu = nil
local commandsMenu = nil
local visionMenu = nil
local inventoryMenu = nil
local subInventoryMenu = nil
local clothesMenu = nil
local animationsMenu = nil
local festivesMenu = nil
local salutationsMenu = nil
local travailMenu = nil
local humeursMenu = nil
local sportsMenu = nil
local diversMenu = nil
local attitudesMenu = nil
local adulteMenu = nil
local administrationMenu = nil
local sellDrugsMenu = nil

local isMinimapVisible = true
local inventoryItems = {}
local selectedItem = nil
local playerBills = {}

local playerMoney = {
    cash = 0,
    bank = 0,
    dirty = 0
}

local playerName = ""
local playerJob = ""
local playerJobGrade = ""
local playerJob2 = ""
local playerJob2Grade = ""
local playerId = GetPlayerServerId(PlayerId())
local isBoss = false
local isOrgBoss = false
local employees = {}
local organizationMembers = {}
local playerData = {
    group = nil
}

local ragdolling = false
function hasAdminPermissions()
    return playerData.group == 'admin' or playerData.group == 'owner'
end

Citizen.CreateThread(function()
    ESX.TriggerServerCallback('esx:getPlayerData', function(data)
        if data then
            playerData.group = data.group
        end
    end)
end)
-- Key Control
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, Config.MenuKey) then -- Utilisation de la clef configurée
            OpenF5Menu()
        end
    end
end)

-- Ralentir le véhicule si la vie du moteur est faible
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle ~= 0 then
            local engineHealth = GetVehicleEngineHealth(vehicle)
            if engineHealth < 1000 then -- Ralentit le véhicule si la vie du moteur est inférieure à 100%
                SetVehicleEngineTorqueMultiplier(vehicle, engineHealth / 1000) -- Réduit le couple du moteur proportionnellement à la vie du moteur
            else
                SetVehicleEngineTorqueMultiplier(vehicle, 1.0) -- Rétablit le couple du moteur à la normale
            end
        end
    end
end)

function OpenF5Menu()
    if mainMenu == nil then
        mainMenu = RageUI.CreateMenu(Config.Menus.MainMenu.title, Config.Menus.MainMenu.subtitle)
        portefeuilleMenu = RageUI.CreateSubMenu(mainMenu, Config.Menus.Portefeuille.title, Config.Menus.Portefeuille.subtitle)
        enterpriseMenu = RageUI.CreateSubMenu(mainMenu, Config.Menus.GestionEntreprise.title, Config.Menus.GestionEntreprise.subtitle)
        organizationMenu = RageUI.CreateSubMenu(mainMenu, Config.Menus.GestionOrganisation.title, Config.Menus.GestionOrganisation.subtitle)
        vehicleMenu = RageUI.CreateSubMenu(mainMenu, Config.Menus.GestionVehicule.title, Config.Menus.GestionVehicule.subtitle)
        employeesMenu = RageUI.CreateSubMenu(enterpriseMenu, Config.Menus.ListeEmployes.title, Config.Menus.ListeEmployes.subtitle)
        organizationMembersMenu = RageUI.CreateSubMenu(organizationMenu, Config.Menus.ListeMembres.title, Config.Menus.ListeMembres.subtitle)
        miscellaneousMenu = RageUI.CreateSubMenu(mainMenu, Config.Menus.Divers.title, Config.Menus.Divers.subtitle)
        controlsMenu = RageUI.CreateSubMenu(miscellaneousMenu, Config.Menus.Touches.title, Config.Menus.Touches.subtitle)
        commandsMenu = RageUI.CreateSubMenu(miscellaneousMenu, Config.Menus.Commandes.title, Config.Menus.Commandes.subtitle)
        visionMenu = RageUI.CreateSubMenu(miscellaneousMenu, Config.Menus.Vision.title, Config.Menus.Vision.subtitle)
        inventoryMenu = RageUI.CreateSubMenu(mainMenu, Config.Menus.Inventaire.title, Config.Menus.Inventaire.subtitle)
        subInventoryMenu = RageUI.CreateSubMenu(inventoryMenu, Config.Menus.Actions.title, Config.Menus.Actions.subtitle)
        clothesMenu = RageUI.CreateSubMenu(mainMenu, Config.Menus.Vetements.title, Config.Menus.Vetements.subtitle)
        animationsMenu = RageUI.CreateSubMenu(mainMenu, Config.Menus.Animations.title, Config.Menus.Animations.subtitle)
        festivesMenu = RageUI.CreateSubMenu(animationsMenu, Config.Menus.Festives.title, Config.Menus.Festives.subtitle)
        salutationsMenu = RageUI.CreateSubMenu(animationsMenu, Config.Menus.Salutations.title, Config.Menus.Salutations.subtitle)
        travailMenu = RageUI.CreateSubMenu(animationsMenu, Config.Menus.Travail.title, Config.Menus.Travail.subtitle)
        humeursMenu = RageUI.CreateSubMenu(animationsMenu, Config.Menus.Humeurs.title, Config.Menus.Humeurs.subtitle)
        sportsMenu = RageUI.CreateSubMenu(animationsMenu, Config.Menus.Sports.title, Config.Menus.Sports.subtitle)
        diversMenu = RageUI.CreateSubMenu(animationsMenu, Config.Menus.DiversAnimations.title, Config.Menus.DiversAnimations.subtitle)
        attitudesMenu = RageUI.CreateSubMenu(animationsMenu, Config.Menus.Attitudes.title, Config.Menus.Attitudes.subtitle)
        adulteMenu = RageUI.CreateSubMenu(animationsMenu, Config.Menus.Adulte.title, Config.Menus.Adulte.subtitle)
        administrationMenu = RageUI.CreateSubMenu(mainMenu, Config.Menus.Administration.title, Config.Menus.Administration.subtitle)
        

        -- Set colors for the menus
        mainMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        portefeuilleMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        enterpriseMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        organizationMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        vehicleMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        employeesMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        organizationMembersMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        miscellaneousMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        controlsMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        commandsMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        visionMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        inventoryMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        subInventoryMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        clothesMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        animationsMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        festivesMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        salutationsMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        travailMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        humeursMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        sportsMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        diversMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        attitudesMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        adulteMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)
        administrationMenu:SetRectangleBanner(Config.MenuBannerColor.r, Config.MenuBannerColor.g, Config.MenuBannerColor.b, Config.MenuBannerColor.a)

        mainMenu.Closed = function()
            isMenuOpen = false
        end
    end

    -- Fetch player data from server before opening the menu
    ESX.TriggerServerCallback('example:getPlayerInfo', function(data)
        playerName = data.name
        playerJob = data.job.label .. " - " .. data.job.grade_label
        playerJob2 = data.job2.label .. " - " .. data.job2.grade_label
        isBoss = data.isBoss
        isOrgBoss = data.isOrgBoss
        employees = data.employees
        organizationMembers = data.organizationMembers
    end)

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
    isMenuOpen = RageUI.Visible(mainMenu)

    Citizen.CreateThread(function()
        while RageUI.Visible(mainMenu) or RageUI.Visible(portefeuilleMenu) or RageUI.Visible(enterpriseMenu) or RageUI.Visible(employeesMenu) or RageUI.Visible(organizationMenu) or RageUI.Visible(organizationMembersMenu) or RageUI.Visible(vehicleMenu) or RageUI.Visible(miscellaneousMenu) or RageUI.Visible(controlsMenu) or RageUI.Visible(commandsMenu) or RageUI.Visible(visionMenu) or RageUI.Visible(inventoryMenu) or RageUI.Visible(subInventoryMenu) or RageUI.Visible(clothesMenu) or RageUI.Visible(animationsMenu) or RageUI.Visible(festivesMenu) or RageUI.Visible(salutationsMenu) or RageUI.Visible(travailMenu) or RageUI.Visible(humeursMenu) or RageUI.Visible(sportsMenu) or RageUI.Visible(diversMenu) or RageUI.Visible(attitudesMenu) or RageUI.Visible(adulteMenu) or RageUI.Visible(administrationMenu) or RageUI.Visible(sellDrugsMenu) do
            Citizen.Wait(0)

            RageUI.IsVisible(mainMenu, function()
                RageUI.Separator("~y~ID: " .. playerId)
                if Config.Buttons.Inventory then
                    RageUI.Button("Inventaire", "Voir votre inventaire", {RightLabel = "→→→"}, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback('esx:getPlayerInventory', function(inventory)
                                inventoryItems = inventory.items
                                RageUI.Visible(inventoryMenu, true)
                            end)
                        end
                    }, inventoryMenu)
                end
            
                
            
                if Config.Buttons.Portefeuille then
                    RageUI.Button("Portefeuille", "Voir votre argent", {RightLabel = "→→→"}, true, {
                        onSelected = function()
                            TriggerServerEvent('example:getPlayerMoney')
                        end
                    }, portefeuilleMenu)
                end
            
                if Config.Buttons.Vetements then
                    RageUI.Button("Vêtements", "Changer de vêtements", {RightLabel = "→→→"}, true, {}, clothesMenu)
                end
            
                if Config.Buttons.Animations then
                    RageUI.Button("Animations", "Choisissez une animation", {RightLabel = "→→→"}, true, {}, animationsMenu)
                end
            
                if isBoss and Config.Buttons.GestionEntreprise then
                    RageUI.Button("Gestion Entreprise", "Gérez votre entreprise", {RightLabel = "→→→"}, true, {}, enterpriseMenu)
                end
            
                if isOrgBoss and Config.Buttons.GestionOrganisation then
                    RageUI.Button("Gestion Organisation", "Gérez votre organisation", {RightLabel = "→→→"}, true, {}, organizationMenu)
                end
            
                if Config.Buttons.GestionVehicule then
                    RageUI.Button("Gestion Véhicule", "Gérez votre véhicule", {RightLabel = "→→→"}, true, {
                        onSelected = function()
                            local playerPed = PlayerPedId()
                            local inVehicle = IsPedInAnyVehicle(playerPed, false)
                            if not inVehicle then
                                ESX.ShowNotification("~r~Vous devez être dans un véhicule pour ouvrir ce menu.")
                            end
                        end
                    }, vehicleMenu)
                end
            
                if Config.Buttons.Divers then
                    RageUI.Button("Divers", "Options diverses", {RightLabel = "→→→"}, true, {}, miscellaneousMenu)
                end
            
                if hasAdminPermissions()  then
                    RageUI.Button("Administration", "Options administratives", {RightLabel = "→→→"}, true, {}, administrationMenu)
                end
            end)
            
            RageUI.IsVisible(inventoryMenu, function()
                for i, item in ipairs(inventoryItems) do
                    if item.count > 0 then
                        RageUI.Button(item.label .. " x" .. item.count, nil, {}, true, {
                            onSelected = function()
                                selectedItem = item
                                RageUI.Visible(inventoryMenu, false)
                                RageUI.Visible(subInventoryMenu, true)
                            end
                        })
                    end
                end
            end)

            RageUI.IsVisible(subInventoryMenu, function()
                RageUI.Button("Utiliser", nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent('esx:useItem', selectedItem.name)
                        RageUI.Visible(subInventoryMenu, false)
                        RageUI.Visible(inventoryMenu, true)
                    end
                })
                RageUI.Button("Lâcher", nil, {}, true, {
                    onSelected = function()
                        local quantity = KeyboardInput("Quantité à lâcher", "", 10)
                        if tonumber(quantity) then
                            TriggerServerEvent('esx:removeInventoryItem', 'item_standard', selectedItem.name, tonumber(quantity))
                            RageUI.Visible(subInventoryMenu, false)
                            RageUI.Visible(inventoryMenu, true)
                        else
                            ESX.ShowNotification("~r~Quantité invalide")
                        end
                    end
                })
                RageUI.Button("Donner", nil, {}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            local quantity = KeyboardInput("Quantité à donner", "", 10)
                            if tonumber(quantity) then
                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', selectedItem.name, tonumber(quantity))
                                RageUI.Visible(subInventoryMenu, false)
                                RageUI.Visible(inventoryMenu, true)
                            else
                                ESX.ShowNotification("~r~Quantité invalide")
                            end
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité")
                        end
                    end
                })
            end)

            RageUI.IsVisible(portefeuilleMenu, function()
                RageUI.Separator("~y~Informations du joueur")
                RageUI.Separator("Nom: " .. playerName)
                RageUI.Separator("Métier: " .. playerJob)
                RageUI.Separator("Deuxième métier: " .. playerJob2)

                RageUI.Separator("~y~Argent")
                RageUI.Button("Argent liquide", nil, {RightLabel = "$" .. playerMoney.cash}, true, {})
                RageUI.Button("Argent en banque", nil, {RightLabel = "$" .. playerMoney.bank}, true, {})
                RageUI.Button("Argent sale", nil, {RightLabel = "$" .. playerMoney.dirty}, true, {})

                RageUI.Separator("~y~Documents")
                RageUI.Button("Voir sa carte d'identité", nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                    end
                })
                RageUI.Button("Montrer sa carte d'identité", nil, {}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité.")
                        end
                    end
                })
                RageUI.Button("Voir son permis de conduire", nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                    end
                })
                RageUI.Button("Montrer son permis de conduire", nil, {}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité.")
                        end
                    end
                })
               
            end)

            RageUI.IsVisible(clothesMenu, function()
                RageUI.Button("Changer de haut", nil, {}, true, {
                    onSelected = function()
                        ToggleClothes('top')
                    end
                })
                RageUI.Button("Changer de bas", nil, {}, true, {
                    onSelected = function()
                        ToggleClothes('pants')
                    end
                })
                RageUI.Button("Changer de chaussures", nil, {}, true, {
                    onSelected = function()
                        ToggleClothes('shoes')
                    end
                })
                RageUI.Button("Changer de chapeau", nil, {}, true, {
                    onSelected = function()
                        ToggleClothes('hat')
                    end
                })
                RageUI.Button("Changer de lunettes", nil, {}, true, {
                    onSelected = function()
                        ToggleClothes('glasses')
                    end
                })
                RageUI.Button("Changer d'accessoires", nil, {}, true, {
                    onSelected = function()
                        ToggleClothes('accessories')
                    end
                })
                RageUI.Button("Changer de montre", nil, {}, true, {
                    onSelected = function()
                        ToggleClothes('watches')
                    end
                })
                RageUI.Button("Changer de bracelet", nil, {}, true, {
                    onSelected = function()
                        ToggleClothes('bracelets')
                    end
                })
            end)

            RageUI.IsVisible(enterpriseMenu, function()
                RageUI.Separator("~y~Gestion de l'entreprise")
                RageUI.Button("Embaucher la personne la plus proche", nil, {}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('example:hirePlayer', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité.")
                        end
                    end
                })

                RageUI.Button("Liste des employés", nil, {}, true, {
                    onSelected = function()
                        RageUI.Visible(employeesMenu, true)
                    end
                })

                RageUI.Button("Promouvoir la personne la plus proche", nil, {}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('example:promotePlayer', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité.")
                        end
                    end
                })

                RageUI.Button("Rétrograder la personne la plus proche", nil, {}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('example:demotePlayer', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité.")
                        end
                    end
                })
            end)

            RageUI.IsVisible(employeesMenu, function()
                RageUI.Separator("~y~Liste des employés")
                for i, employee in ipairs(employees) do
                    RageUI.Button(employee.name, nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent('example:firePlayer', employee.identifier)
                        end
                    })
                end
            end)

            RageUI.IsVisible(organizationMenu, function()
                RageUI.Separator("~y~Gestion de l'organisation")
                RageUI.Button("Embaucher la personne la plus proche", nil, {}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('example:hireOrganizationMember', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité.")
                        end
                    end
                })

                RageUI.Button("Liste des membres", nil, {}, true, {
                    onSelected = function()
                        RageUI.Visible(organizationMembersMenu, true)
                    end
                })

                RageUI.Button("Promouvoir la personne la plus proche", nil, {}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('example:promoteOrganizationMember', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité.")
                        end
                    end
                })

                RageUI.Button("Rétrograder la personne la plus proche", nil, {}, true, {
                    onSelected = function()
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('example:demoteOrganizationMember', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité.")
                        end
                    end
                })
            end)

            RageUI.IsVisible(organizationMembersMenu, function()
                RageUI.Separator("~y~Liste des membres")
                for i, member in ipairs(organizationMembers) do
                    RageUI.Button(member.name, nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent('example:fireOrganizationMember', member.identifier)
                        end
                    })
                end
            end)

            RageUI.IsVisible(vehicleMenu, function()
                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                if vehicle == 0 then
                    RageUI.CloseAll()
                    return
                end
            
                
                local vehicleSpeed = GetEntitySpeed(vehicle) * 3.6 -- Convert to km/h
                local vehicleFuel = exports['LegacyFuel']:GetFuel(vehicle)
                local vehiclePlate = GetVehicleNumberPlateText(vehicle)
                local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                local Vengine = GetVehicleEngineHealth(GetSourcevehicle) / 10
                RageUI.Separator("~y~Informations du véhicule")
                RageUI.Separator("Modèle: " .. vehicleModel)
                RageUI.Separator("Plaque: " .. vehiclePlate)
                RageUI.Separator("Vitesse: " .. math.floor(vehicleSpeed) .. " km/h")
                RageUI.Separator("Essence: " .. math.floor(vehicleFuel) .. " %")
                RageUI.Separator("État du moteur~s~ →~b~ " ..math.floor(Vengine) .. "%")
                RageUI.Separator("~y~Contrôle du véhicule")
                RageUI.Button("Démarrer/Éteindre le moteur", nil, {}, true, {
                    onSelected = function()
                        local engineStatus = GetIsVehicleEngineRunning(vehicle)
                        SetVehicleEngineOn(vehicle, not engineStatus, false, true)
                    end
                })
            
                RageUI.List("Portes", doorList, selectedDoor, nil, {}, true, {
                    onListChange = function(index)
                        selectedDoor = index
                    end,
                    onSelected = function(index)
                        local doorIndex = index - 1
                        local doorStatus = GetVehicleDoorAngleRatio(vehicle, doorIndex) > 0
                        if doorStatus then
                            SetVehicleDoorShut(vehicle, doorIndex, false)
                        else
                            SetVehicleDoorOpen(vehicle, doorIndex, false, false)
                        end
                    end
                })
            
                RageUI.List("Fenêtres", windowList, selectedWindow, nil, {}, true, {
                    onListChange = function(index)
                        selectedWindow = index
                    end,
                    onSelected = function(index)
                        local windowIndex = index - 1
                        local windowStatus = IsVehicleWindowIntact(vehicle, windowIndex)
                        if windowStatus then
                            RollDownWindow(vehicle, windowIndex)
                        else
                            RollUpWindow(vehicle, windowIndex)
                        end
                    end
                })
            
                RageUI.List("Limiteur de vitesse", speedLimiterList, selectedSpeedLimiter, nil, {}, true, {
                    onListChange = function(index)
                        selectedSpeedLimiter = index
                    end,
                    onSelected = function(index)
                        if speedLimiterList[index] == "Personnalisé" then
                            local customSpeed = KeyboardInput("Entrez la vitesse en km/h", "", 4)
                            customSpeed = tonumber(customSpeed)
                            if customSpeed then
                                speedLimit = customSpeed
                                SetVehicleMaxSpeed(vehicle, speedLimit / 3.6) -- Convert to m/s
                                ESX.ShowNotification("Limiteur de vitesse réglé à " .. customSpeed .. " km/h")
                            else
                                ESX.ShowNotification("~r~Entrée invalide")
                            end
                        else
                            speedLimit = tonumber(speedLimiterList[index]:match("%d+"))
                            SetVehicleMaxSpeed(vehicle, speedLimit / 3.6) -- Convert to m/s
                            ESX.ShowNotification("Limiteur de vitesse réglé à " .. speedLimiterList[index])
                        end
                    end
                })
            
                RageUI.Button("Désactiver le limiteur", nil, {}, true, {
                    onSelected = function()
                        speedLimit = nil
                        SetVehicleMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel"))
                        ESX.ShowNotification("Limiteur de vitesse désactivé")
                    end
                })
            end)
            
            RageUI.IsVisible(miscellaneousMenu, function()
                RageUI.Button("Touches", "Voir la liste des touches", {RightLabel = "→→→"}, true, {}, controlsMenu)
                RageUI.Button("Commandes", "Voir la liste des commandes disponibles", {RightLabel = "→→→"}, true, {}, commandsMenu)
            
                -- Bouton pour afficher/masquer la minimap
                RageUI.Checkbox("Voir la Minimap", "Afficher ou masquer la minimap.", isMinimapVisible, {}, {
                    onChecked = function()
                        isMinimapVisible = true
                        DisplayRadar(true)
                    end,
                    onUnChecked = function()
                        isMinimapVisible = false
                        DisplayRadar(false)
                    end,
                    onSelected = function(Index)
                    end
                })
            
                RageUI.Button("Vision", "Changer le type de vision", {RightLabel = "→→→"}, true, {}, visionMenu)
                RageUI.Button("Voir mon ID", nil, {}, true, {
                    onSelected = function()
                        ESX.ShowNotification("~b~Votre ID : " .. playerId)
                    end
                })
            
            
            
                RageUI.Button("Ragdoll", nil, {}, true, {
                    onSelected = function()
                        ragdolling = not ragdolling
                        while ragdolling do
                            Wait(0)
                            local myPed = PlayerPedId()
                            SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
                            ResetPedRagdollTimer(myPed)
                            AddTextEntry(GetCurrentResourceName(), ('Appuyez sur ~INPUT_JUMP~ pour vous ~p~Réveiller'))
                            DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
                            ResetPedRagdollTimer(myPed)
                            if IsControlJustPressed(0, 22) then 
                                break
                            end
                        end
                        ragdolling = false
                    end
                })
            end)

            RageUI.IsVisible(sellDrugsMenu, function()
                for _, drug in ipairs(Config.DrugItems) do
                    RageUI.Button(drug.label, nil, {}, true, {
                        onSelected = function()
                            SellDrug(drug)
                            RageUI.CloseAll()
                        end
                    })
                end
            end)

            RageUI.IsVisible(controlsMenu, function()
                RageUI.Separator("~y~Liste des touches")
                for i, control in ipairs(Config.ControlsList) do
                    RageUI.Button(control.label, nil, {RightLabel = control.control}, true, {})
                end
            end)

            RageUI.IsVisible(commandsMenu, function()
                RageUI.Separator("~y~Liste des commandes")
                for i, command in ipairs(Config.CommandsList) do
                    RageUI.Button(command.label, command.description, {}, true, {})
                end
            end)

            RageUI.IsVisible(visionMenu, function()
                RageUI.Button("Vision nocturne", nil, {}, true, {
                    onSelected = function()
                        ClearTimecycleModifier()
                        SetNightvision(false)
                        SetSeethrough(false)
                        SetNightvision(true)
                        ESX.ShowNotification("~g~Vision nocturne activée")
                    end
                })
                RageUI.Button("Vision thermique", nil, {}, true, {
                    onSelected = function()
                        ClearTimecycleModifier()
                        SetNightvision(false)
                        SetSeethrough(false)
                        SetSeethrough(true)
                        ESX.ShowNotification("~g~Vision thermique activée")
                    end
                })
                RageUI.Button("Vision infrarouge", nil, {}, true, {
                    onSelected = function()
                        ClearTimecycleModifier()
                        SetNightvision(false)
                        SetSeethrough(false)
                        SetTimecycleModifier("infrared")
                        ESX.ShowNotification("~g~Vision infrarouge activée")
                    end
                })
                RageUI.Button("Vision caméscope", nil, {}, true, {
                    onSelected = function()
                        ClearTimecycleModifier()
                        SetNightvision(false)
                        SetSeethrough(false)
                        SetTimecycleModifier("CAMERA_secuirity")
                        ESX.ShowNotification("~g~Vision caméscope activée")
                    end
                })
                RageUI.Button("Vision old_movie", nil, {}, true, {
                    onSelected = function()
                        ClearTimecycleModifier()
                        SetNightvision(false)
                        SetSeethrough(false)
                        SetTimecycleModifier("OldMovie")
                        ESX.ShowNotification("~g~Vision Old Movie activée")
                    end
                })
                RageUI.Button("Boost FPS", nil, {}, true, {
                    onSelected = function()
                        ClearTimecycleModifier()
                        SetNightvision(false)
                        SetSeethrough(false)
                        SetTimecycleModifier("cinema")
                        ESX.ShowNotification("~g~Boost FPS activé")
                    end
                })
                RageUI.Button("Vision de drogue", nil, {}, true, {
                    onSelected = function()
                        ClearTimecycleModifier()
                        SetNightvision(false)
                        SetSeethrough(false)
                        SetTimecycleModifier("DRUG_gas_huffin")
                        ESX.ShowNotification("~g~Vision de drogue activée")
                    end
                })
                RageUI.Button("Vision underwater", nil, {}, true, {
                    onSelected = function()
                        ClearTimecycleModifier()
                        SetNightvision(false)
                        SetSeethrough(false)
                        SetTimecycleModifier("underwater")
                        ESX.ShowNotification("~g~Vision sous l'eau activée")
                    end
                })
                RageUI.Button("Vision par défaut", nil, {}, true, {
                    onSelected = function()
                        ClearTimecycleModifier()
                        SetNightvision(false)
                        SetSeethrough(false)
                        ESX.ShowNotification("~r~Vision par défaut activée")
                    end
                })
            end)

            RageUI.IsVisible(animationsMenu, function()
                RageUI.Button("Festives", "Animations festives", {RightLabel = "→→→"}, true, {}, festivesMenu)
                RageUI.Button("Salutations", "Animations de salutations", {RightLabel = "→→→"}, true, {}, salutationsMenu)
                RageUI.Button("Travail", "Animations de travail", {RightLabel = "→→→"}, true, {}, travailMenu)
                RageUI.Button("Humeurs", "Animations d'humeurs", {RightLabel = "→→→"}, true, {}, humeursMenu)
                RageUI.Button("Sports", "Animations sportives", {RightLabel = "→→→"}, true, {}, sportsMenu)
                RageUI.Button("Divers", "Animations diverses", {RightLabel = "→→→"}, true, {}, diversMenu)
                RageUI.Button("Attitudes", "Animations d'attitudes", {RightLabel = "→→→"}, true, {}, attitudesMenu)
                RageUI.Button("Adulte +18", "Animations pour adultes", {RightLabel = "→→→"}, true, {}, adulteMenu)
            end)

            RageUI.IsVisible(festivesMenu, function()
                for i, anim in ipairs(Config.Animations.Festives) do
                    RageUI.Button(anim.label, nil, {}, true, {
                        onSelected = function()
                            PlayAnimationWithNotification(anim.animDict, anim.animName)
                        end
                    })
                end
            end)
            
            RageUI.IsVisible(salutationsMenu, function()
                for i, anim in ipairs(Config.Animations.Salutations) do
                    RageUI.Button(anim.label, nil, {}, true, {
                        onSelected = function()
                            PlayAnimationWithNotification(anim.animDict, anim.animName)
                        end
                    })
                end
            end)
            
            RageUI.IsVisible(travailMenu, function()
                for i, anim in ipairs(Config.Animations.Travail) do
                    RageUI.Button(anim.label, nil, {}, true, {
                        onSelected = function()
                            PlayAnimationWithNotification(anim.animDict, anim.animName)
                        end
                    })
                end
            end)
            
            RageUI.IsVisible(humeursMenu, function()
                for i, anim in ipairs(Config.Animations.Humeurs) do
                    RageUI.Button(anim.label, nil, {}, true, {
                        onSelected = function()
                            PlayAnimationWithNotification(anim.animDict, anim.animName)
                        end
                    })
                end
            end)
            
            RageUI.IsVisible(sportsMenu, function()
                for i, anim in ipairs(Config.Animations.Sports) do
                    RageUI.Button(anim.label, nil, {}, true, {
                        onSelected = function()
                            PlayAnimationWithNotification(anim.animDict, anim.animName)
                        end
                    })
                end
            end)
            
            RageUI.IsVisible(diversMenu, function()
                for i, anim in ipairs(Config.Animations.Divers) do
                    RageUI.Button(anim.label, nil, {}, true, {
                        onSelected = function()
                            PlayAnimationWithNotification(anim.animDict, anim.animName)
                        end
                    })
                end
            end)
            
            RageUI.IsVisible(attitudesMenu, function()
                for i, anim in ipairs(Config.Animations.Attitudes) do
                    RageUI.Button(anim.label, nil, {}, true, {
                        onSelected = function()
                            PlayAnimationWithNotification(anim.animDict, anim.animName)
                        end
                    })
                end
            end)
            
            RageUI.IsVisible(adulteMenu, function()
                for i, anim in ipairs(Config.Animations.Adulte) do
                    RageUI.Button(anim.label, nil, {}, true, {
                        onSelected = function()
                            PlayAnimationWithNotification(anim.animDict, anim.animName)
                        end
                    })
                end
            end)

            RageUI.IsVisible(administrationMenu, function()
                RageUI.Button("TP au joueur", nil, {}, true, {
                    onSelected = function()
                        local playerId = KeyboardInput("Entrez l'ID du joueur", "", 10)
                        if playerId then
                            local targetServerId = tonumber(playerId)
                            local targetPlayer = GetPlayerFromServerId(targetServerId)
                            local targetPed = GetPlayerPed(targetPlayer)
                            
                            if targetPed and targetPlayer ~= -1 then
                                local targetCoords = GetEntityCoords(targetPed)
                                local targetName = GetPlayerName(targetPlayer)
                
                                local playerPed = PlayerPedId()
                
                                if Config.BlackScreenOnTP.Enable then
                                    -- Activer l'écran noir
                                    DoScreenFadeOut(Config.BlackScreenOnTP.Time)
                                    while not IsScreenFadedOut() do
                                        Citizen.Wait(0)
                                    end
                                end
                
                                -- Téléportation du joueur
                                SetEntityCoords(playerPed, targetCoords)
                
                                if Config.BlackScreenOnTP.Enable then
                                    -- Désactiver l'écran noir après une courte pause
                                    Citizen.Wait(500)
                                    DoScreenFadeIn(Config.BlackScreenOnTP.Time)
                                end
                
                                ESX.ShowNotification("~g~Téléporté à " .. targetName .. " (ID: " .. playerId .. ")")
                            else
                                ESX.ShowNotification("~r~ID du joueur invalide.")
                            end
                        else
                            ESX.ShowNotification("~r~Aucun ID de joueur entré.")
                        end
                    end
                })
                
                RageUI.Button("Se revive", nil, {}, true, {
                    onSelected = function()
                        local playerId = PlayerId()
                        TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(playerId))
                    end
                })
                
                RageUI.Button("Heal", nil, {}, true, {
                    onSelected = function()
                        local playerId = PlayerId()
                        TriggerServerEvent('esx_ambulancejob:healAndRestore', GetPlayerServerId(playerId))
                    end
                })

                RageUI.Button("Spawn un véhicule", nil, {}, true, {
                    onSelected = function()
                        local model = KeyboardInput("Nom du modèle de véhicule", "", 50)
                        if model and IsModelInCdimage(model) then
                            RequestModel(model)
                            while not HasModelLoaded(model) do
                                Citizen.Wait(0)
                            end
                            local playerPed = PlayerPedId()
                            local playerPos = GetEntityCoords(playerPed)
                            local vehicle = CreateVehicle(model, playerPos.x, playerPos.y, playerPos.z, GetEntityHeading(playerPed), true, false)
                            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                        else
                            ESX.ShowNotification("~r~Modèle de véhicule invalide.")
                        end
                    end
                })

                RageUI.Button("Réparer", nil, {}, true, {
                    onSelected = function()
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        if vehicle ~= 0 then
                            SetVehicleFixed(vehicle)
                            SetVehicleDirtLevel(vehicle, 0)
                            ESX.ShowNotification("~g~Véhicule réparé.")
                        else
                            ESX.ShowNotification("~r~Vous devez être dans un véhicule pour utiliser cette option.")
                        end
                    end
                })

                RageUI.Button("Supprimer", nil, {}, true, {
                    onSelected = function()
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        if vehicle ~= 0 then
                            DeleteVehicle(vehicle)
                            ESX.ShowNotification("~g~Véhicule supprimé.")
                        else
                            ESX.ShowNotification("~r~Vous devez être dans un véhicule pour utiliser cette option.")
                        end
                    end
                })

                RageUI.Button("Custom au max", nil, {}, true, {
                    onSelected = function()
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        if vehicle ~= 0 then
                            SetVehicleModKit(vehicle, 0)
                            for i = 0, 49 do
                                local modCount = GetNumVehicleMods(vehicle, i)
                                if modCount > 0 then
                                    SetVehicleMod(vehicle, i, modCount - 1, false)
                                end
                            end
                            SetVehicleWindowTint(vehicle, 1)
                            SetVehicleTyresCanBurst(vehicle, false)
                            SetVehicleNumberPlateText(vehicle, "ADMIN")
                            ESX.ShowNotification("~g~Véhicule customisé au maximum.")
                        else
                            ESX.ShowNotification("~r~Vous devez être dans un véhicule pour utiliser cette option.")
                        end
                    end
                })
                RageUI.Checkbox("Invisibilité", "Activer ou désactiver l'invisibilité.", isInvisible, {}, {
                    onChecked = function()
                        ToggleInvisibility()
                    end,
                    onUnChecked = function()
                        ToggleInvisibility()
                    end
                })
            
                RageUI.Checkbox("NoClip", "Activer ou désactiver le noclip.", noClipEnabled, {}, {
                    onChecked = function()
                        ToggleNoClip(true)
                    end,
                    onUnChecked = function()
                        ToggleNoClip(false)
                    end
                })
                
            end)
        end
    end)
end

function PlayAnimationWithNotification(animDict, animName)
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
        -- Charge l'animation
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(0)
        end
        -- Joue l'animation une seule fois
        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 0, 0, false, false, false)
        -- Affiche une notification pour arrêter l'animation
        ESX.ShowNotification("Appuyez sur E pour arrêter l'animation")

        -- Boucle pour détecter la touche "E" et arrêter l'animation
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                if IsControlJustReleased(0, 38) then -- 38 est le code de la touche "E"
                    ClearPedTasks(playerPed)
                    break
                end
            end
        end)
    end
end

function ToggleClothes(component)
    local playerPed = PlayerPedId()
    if component == 'top' then
        local drawable = GetPedDrawableVariation(playerPed, 11)
        local texture = GetPedTextureVariation(playerPed, 11)
        local palette = GetPedPaletteVariation(playerPed, 11)
        local armsDrawable = GetPedDrawableVariation(playerPed, 3)
        if previousClothes.top.drawable == nil then
            previousClothes.top.drawable = drawable
            previousClothes.top.texture = texture
            previousClothes.top.palette = palette
            previousClothes.top.arms = armsDrawable
            SetPedComponentVariation(playerPed, 11, 15, 0, 2)
            SetPedComponentVariation(playerPed, 3, 15, 0, 2)
        else
            SetPedComponentVariation(playerPed, 11, previousClothes.top.drawable, previousClothes.top.texture, previousClothes.top.palette)
            SetPedComponentVariation(playerPed, 3, previousClothes.top.arms, 0, 2)
            previousClothes.top.drawable = nil
        end
    elseif component == 'pants' then
        local drawable = GetPedDrawableVariation(playerPed, 4)
        local texture = GetPedTextureVariation(playerPed, 4)
        local palette = GetPedPaletteVariation(playerPed, 4)
        if previousClothes.pants.drawable == nil then
            previousClothes.pants.drawable = drawable
            previousClothes.pants.texture = texture
            previousClothes.pants.palette = palette
            SetPedComponentVariation(playerPed, 4, 14, 0, 2)
        else
            SetPedComponentVariation(playerPed, 4, previousClothes.pants.drawable, previousClothes.pants.texture, previousClothes.pants.palette)
            previousClothes.pants.drawable = nil
        end
    elseif component == 'shoes' then
        local drawable = GetPedDrawableVariation(playerPed, 6)
        local texture = GetPedTextureVariation(playerPed, 6)
        local palette = GetPedPaletteVariation(playerPed, 6)
        if previousClothes.shoes.drawable == nil then
            previousClothes.shoes.drawable = drawable
            previousClothes.shoes.texture = texture
            previousClothes.shoes.palette = palette
            SetPedComponentVariation(playerPed, 6, 5, 0, 2)
        else
            SetPedComponentVariation(playerPed, 6, previousClothes.shoes.drawable, previousClothes.shoes.texture, previousClothes.shoes.palette)
            previousClothes.shoes.drawable = nil
        end
    elseif component == 'hat' then
        local drawable = GetPedPropIndex(playerPed, 0)
        local texture = GetPedPropTextureIndex(playerPed, 0)
        if previousClothes.hat.drawable == nil then
            previousClothes.hat.drawable = drawable
            previousClothes.hat.texture = texture
            ClearPedProp(playerPed, 0)
        else
            SetPedPropIndex(playerPed, 0, previousClothes.hat.drawable, previousClothes.hat.texture, true)
            previousClothes.hat.drawable = nil
        end
    elseif component == 'glasses' then
        local drawable = GetPedPropIndex(playerPed, 1)
        local texture = GetPedPropTextureIndex(playerPed, 1)
        if previousClothes.glasses.drawable == nil then
            previousClothes.glasses.drawable = drawable
            previousClothes.glasses.texture = texture
            ClearPedProp(playerPed, 1)
        else
            SetPedPropIndex(playerPed, 1, previousClothes.glasses.drawable, previousClothes.glasses.texture, true)
            previousClothes.glasses.drawable = nil
        end
    elseif component == 'accessories' then
        local drawable = GetPedDrawableVariation(playerPed, 7)
        local texture = GetPedTextureVariation(playerPed, 7)
        local palette = GetPedPaletteVariation(playerPed, 7)
        if previousClothes.accessories.drawable == nil then
            previousClothes.accessories.drawable = drawable
            previousClothes.accessories.texture = texture
            previousClothes.accessories.palette = palette
            SetPedComponentVariation(playerPed, 7, 0, 0, 2)
        else
            SetPedComponentVariation(playerPed, 7, previousClothes.accessories.drawable, previousClothes.accessories.texture, previousClothes.accessories.palette)
            previousClothes.accessories.drawable = nil
        end
    elseif component == 'watches' then
        local drawable = GetPedPropIndex(playerPed, 6)
        local texture = GetPedPropTextureIndex(playerPed, 6)
        if previousClothes.watches.drawable == nil then
            previousClothes.watches.drawable = drawable
            previousClothes.watches.texture = texture
            ClearPedProp(playerPed, 6)
        else
            SetPedPropIndex(playerPed, 6, previousClothes.watches.drawable, previousClothes.watches.texture, true)
            previousClothes.watches.drawable = nil
        end
    elseif component == 'bracelets' then
        local drawable = GetPedPropIndex(playerPed, 7)
        local texture = GetPedPropTextureIndex(playerPed, 7)
        if previousClothes.bracelets.drawable == nil then
            previousClothes.bracelets.drawable = drawable
            previousClothes.bracelets.texture = texture
            ClearPedProp(playerPed, 7)
        else
            SetPedPropIndex(playerPed, 7, previousClothes.bracelets.drawable, previousClothes.bracelets.texture, true)
            previousClothes.bracelets.drawable = nil
        end
    end
    PlayAnimation(playerPed)
end

function PlayAnimation(ped)
    RequestAnimDict("clothingshirt")
    while not HasAnimDictLoaded("clothingshirt") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(ped, "clothingshirt", "try_shirt_positive_a", 8.0, -8.0, 1600, 49, 0, false, false, false)
end

function SetClosestGPS(locations)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local closestDist = -1
    local closestPos = nil

    for _, loc in ipairs(locations) do
        local dist = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, loc.x, loc.y, loc.z, true)
        if closestDist == -1 or dist < closestDist then
            closestDist = dist
            closestPos = loc
        end
    end

    if closestPos then
        SetNewWaypoint(closestPos.x, closestPos.y)
        ESX.ShowNotification("~g~Point GPS mis à jour")
    else
        ESX.ShowNotification("~r~Aucune position trouvée")
    end
end

function KeyboardInput(textEntry, exampleText, maxStringLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry) -- Sets the Text above the typing field in the black square
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", exampleText, "", "", "", maxStringLength) -- Actually calls the Keyboard Input
    blockinput = true -- Blocks new input while typing if **blockinput** is used

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() -- Gets the result of the typing
        Citizen.Wait(500) -- Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
        blockinput = false -- This unblocks new Input when typing is done
        return result -- Returns the result
    else
        Citizen.Wait(500) -- Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
        blockinput = false -- This unblocks new Input when typing is done
        return nil -- Returns nil if the typing got aborted
    end
end

RegisterNetEvent('example:setPlayerMoney')
AddEventHandler('example:setPlayerMoney', function(cash, bank, dirty)
    playerMoney.cash = cash
    playerMoney.bank = bank
    playerMoney.dirty = dirty
end)
function ToggleInvisibility()
    local playerPed = PlayerPedId()
    isInvisible = not isInvisible
    SetEntityVisible(playerPed, not isInvisible, false)
    SetLocalPlayerVisibleLocally(not isInvisible)
    SetEntityAlpha(playerPed, isInvisible and 51 or 255, false)
    NetworkSetEntityInvisibleToNetwork(playerPed, isInvisible)
    if isInvisible then
        ESX.ShowNotification("~g~Invisibilité activée")
    else
        ESX.ShowNotification("~r~Invisibilité désactivée")
    end
end

function ToggleNoClip(enable)
    noClipEnabled = enable
    local ped = PlayerPedId()
    if noClipEnabled then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
        ESX.ShowNotification("Noclip ~g~activé")
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true)
        TeleportToGround()
        ESX.ShowNotification("Noclip ~r~désactivé")
    end
end

function GetPosition()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    return x, y, z
end

function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)

    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end

    return x, y, z
end

function TeleportToGround()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local groundFound, groundZ = GetGroundZFor_3dCoord(x, y, z + 1000, false)
    
    if groundFound then
        SetEntityCoords(ped, x, y, groundZ, false, false, false, true)
    else
        -- Si aucune surface n'a été trouvée, téléporte à une altitude par défaut
        SetEntityCoords(ped, x, y, z, false, false, false, true)
    end
end

Citizen.CreateThread(function()
    while true do
        local waitTime = 500
        if noClipEnabled then
            local ped = PlayerPedId()
            local x, y, z = GetPosition()
            local dx, dy, dz = GetCamDirection()
            local speed = noClipSpeed

            SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
            waitTime = 0  
            if IsControlPressed(0, 32) then -- MOVE UP
                x = x + speed * dx
                y = y + speed * dy
                z = z + speed * dz
            end

            if IsControlPressed(0, 269) then -- MOVE DOWN
                x = x - speed * dx
                y = y - speed * dy
                z = z - speed * dz
            end

            -- Utilisation de la molette de la souris pour ajuster la vitesse
            if IsControlJustPressed(1, 241) then -- Molette vers le haut
                noClipSpeed = math.min(noClipSpeed + 0.1, maxSpeed)
            end

            if IsControlJustPressed(1, 242) then -- Molette vers le bas
                noClipSpeed = math.max(noClipSpeed - 0.1, minSpeed)
            end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
        end
        Citizen.Wait(waitTime)
    end
end)



function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
