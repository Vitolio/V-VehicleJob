local QBCore = exports['qb-core']:GetCoreObject()

local function configureBlip()
  for k, v in pairs(Config.pedLocations) do
    if v.blip then
        if v.blipBackground then
            local blipR2 = AddBlipForCoord(v.coordinates.x, v.coordinates.y, v.coordinates.z)

            SetBlipColour(blipR2,v.blipBackgroundColour)
            SetBlipSprite(blipR2, 1)
            SetBlipScale(blipR2, v.blipBackgroundSize)
            SetBlipAsFriendly(blipR2, true)
            if v.proximityBlipOnly then
              SetBlipDisplay(blipR2, 9)         
            else
              SetBlipDisplay(blipR2, 6)
            end
            SetBlipAsShortRange(blipR2, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.bliplabel)
            EndTextCommandSetBlipName(blipR2)
        end
        local blipR = AddBlipForCoord(v.coordinates.x, v.coordinates.y, v.coordinates.z)
        SetBlipColour(blipR,v.blipColour)
        SetBlipSprite(blipR, v.blipSprite)
        SetBlipScale(blipR, v.blipSize)
        SetBlipAsFriendly(blipR, true)
        if v.proximityBlipOnly then
          SetBlipDisplay(blipR, 9)         
        else
          SetBlipDisplay(blipR, 6)
        end
        SetBlipAsShortRange(blipR, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.bliplabel)
        EndTextCommandSetBlipName(blipR)
    end
  end
end

-- Display pnj Blips
Citizen.CreateThread(function()
    configureBlip()
    while true do
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    local i = 0

    for k, v in pairs(Config.pedLocations) do  
        i += 1
        --Make the ped appear
        RequestModel(GetHashKey(v.npc))
        while not HasModelLoaded(GetHashKey(v.npc)) do
            Wait(1)
        end
        ped =  CreatePed(4, v.npc, v.coordinates[1], v.coordinates[2], v.coordinates[3], v.coordinates[4], false, true)
        SetEntityHeading(ped, v.coordinates[4])
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        if v.customScenario == true  then   
            TaskStartScenarioInPlace(ped, v.scenario, 0, true)
        else
            TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        end

        local options = {}

        --Insert the option to talk to the ped
        local option = {
            type = "client",
            event = "v-vehicleJob:client:showvehicleshopMenu",
            icon = "fa-dollar-sign",
            label = Lang:t("ped.talkto"),
        }
        table.insert(options,option) 

        --Create the zone for talking to him
        exports["qb-target"]:AddBoxZone("vehiclesaleshop"..i, vector3(v.coordinates[1], v.coordinates[2], v.coordinates[3]), 1.2, 1.5, {
            name = "vehiclesaleshop"..i,
            heading = v.coordinates[4],
            debugPoly = Config.Debug,
            minZ = v.coordinates[3]-2,
            maxZ = v.coordinates[3]+2,
        }, {
            options = options,
        distance = 2.5
        })
    end
end)

RegisterNetEvent('v-vehicleJob:client:showvehicleshopMenu',function()
  local optionMenu = 
    {
        {
          header = Lang:t("menu.header"),
          isMenuHeader = true,  
        },
    }
    if Config.AllowSellingMenu then
        local convrtMenu =  {
            header = Lang:t("menu.sellvehicle"),
            icon = 'fa-solid fa-file-invoice-dollar',
            txt = '',
            params = {
              event = 'v-vehicleJob:client:showListMenuToBuySell',
                args = {
                    typeofEvent = 'Sell'
                }
            }
        }
        table.insert(optionMenu,convrtMenu)
    end

    if Config.AllowBuyingMenu then
        local buyingMenu =    
        {
            header =Lang:t("menu.buyVehicle"),
            icon = 'fa-solid fa-money-check-dollar',
            txt ='',
            params = {
              event = 'v-vehicleJob:client:showListMenuToBuySell',
              args = {
                typeofEvent = 'Buy'
              }
            }
        }
        table.insert(optionMenu,buyingMenu)
    end
  
    local footerMenu = 
    {
        header = Lang:t("menu.goodBye"),
        icon = 'fa-solid fa-cancel',
        txt = '',
        params = {
            event = exports['qb-menu']:closeMenu(),
        }
    }
    table.insert(optionMenu,footerMenu)
    exports['qb-menu']:openMenu(optionMenu)
end)

RegisterNetEvent('v-vehicleJob:client:showVehicleDepotMenu',function(data)
    local type = data.type
    local garage = data.garage
    local indexgarage = data.index

    local playerJobLevel = QBCore.Functions.GetPlayerData().job.grade.level

    local optionMenuToGetImpoundedJobs = {
        {
          header = Lang:t("menu.getVehicleFromImpound"),
          isMenuHeader = true,  
        },
    }

    if playerJobLevel >= Config.MinimumGradeToSeeImpoundedVehicles  then
        QBCore.Functions.TriggerCallback('v-vehicleJob:server:listOfVehicles', function(result)
            for k, v in pairs(result) do

                if v.state == 0 then
                    v.state = Lang:t("status.out")
                elseif v.state == 1 then
                    v.state = Lang:t("status.garaged")
                elseif v.state == 2 then
                    v.state = Lang:t("status.impound")
                end

                local optMenuToGetImpoundedJobs = {     
                    header = v.vehicle.." [ $ "..v.depotprice.." ]",
                    icon = '',
                    txt = Lang:t('menu.depot', { value = v.plate, value2 = v.fuel, value3 = v.engine, value4 = v.body }),
                    params = {        
                        event = 'qb-garages:client:TakeOutDepot',
                        args = {
                            vehicle = v,
                            type = type,
                            garage = garage,
                            index = indexgarage,
                        }
                    }                
                }
                table.insert(optionMenuToGetImpoundedJobs,optMenuToGetImpoundedJobs)
            end
            local footerMenuToGetImpoundedJobs = {           
                header = Lang:t("menu.goodByeGarage"),
                icon = 'fa-solid fa-left-long',
                txt = '',
                params = {
                    event = exports['qb-menu']:closeMenu(),
                }       
            }
            table.insert(optionMenuToGetImpoundedJobs,footerMenuToGetImpoundedJobs)
            exports['qb-menu']:openMenu(optionMenuToGetImpoundedJobs)
        end,'GetImpoundedJobs')
    else
    QBCore.Functions.Notify(Lang:t("error.notEnoughHighRank"),'error') 
    end    
end)

RegisterNetEvent('v-vehicleJob:client:showListMenuToBuySell',function(data)
    local header = ''
    if data.typeofEvent == 'Buy' then
        header = Lang:t("menu.buyVehicle")
    else
        header = Lang:t("menu.sellvehicle")
    end

    local optionMenuSellBuy = {
        {
          header = header,
          isMenuHeader = true,  
        },
    }

    QBCore.Functions.TriggerCallback('v-vehicleJob:server:listOfVehicles', function(result)
        for k, v in pairs(result) do
  
            local optMenuToSellBuy = {     
                header = v.vehicle.."[ "..v.plate.." ]",
                icon = 'fa-solid fa-file-invoice-dollar',
                txt = Lang:t("menu.sellPrice")..QBCore.Shared.Vehicles[v.vehicle]["price"],
                params = {        
                    event = 'v-vehicleJob:client:SellBuyAction',
                    args = {
                        vehicle = v.vehicle,
                        plate = v.plate,
                        typeOfEvent = data.typeofEvent
                    }
                }                
            }
            table.insert(optionMenuSellBuy,optMenuToSellBuy)
        end
        local footerMenuSellBuy = {           
            header = Lang:t("menu.goBackward"),
            icon = 'fa-solid fa-backward',
            txt = '',
            params = {
                event = 'v-vehicleJob:client:showvehicleshopMenu',
            }       
        }
        table.insert(optionMenuSellBuy,footerMenuSellBuy)
        exports['qb-menu']:openMenu(optionMenuSellBuy)
    end,data.typeofEvent) 
end)

RegisterNetEvent('v-vehicleJob:client:SellBuyAction',function(data)
    local playerJobName = QBCore.Functions.GetPlayerData().job.name
    local playerJobLevel = QBCore.Functions.GetPlayerData().job.grade.level

    if data.typeOfEvent == 'Buy' then
        if playerJobLevel >= Config.MinimumGradeToBuyVehicleForJob  then
            TriggerServerEvent("v-vehicleJob:server:BuyAction", data.vehicle , data.plate)
        else
            QBCore.Functions.Notify(Lang:t("error.notEnoughHighRank"),'error') 
        end      
    else
        if playerJobLevel >= Config.MinimumGradeToSellVehicleJob then
            TriggerServerEvent("v-vehicleJob:server:SellAction", data.vehicle , data.plate)
        else
            QBCore.Functions.Notify(Lang:t("error.notEnoughHighRank"),'error') 
        end
    end
end)