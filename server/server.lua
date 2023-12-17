local QBCore = exports['qb-core']:GetCoreObject()

local function UpdateVehState(plate,newJob)
    local result = MySQL.update('UPDATE player_vehicles SET job = @newJob WHERE plate = @plate', {['@newJob'] = newJob,['@plate'] = plate})
end

local function fetchAllVehiclesOfPlayer(citizenid)
    return MySQL.Sync.fetchAll("SELECT * FROM player_vehicles WHERE job IS NULL AND citizenid = @citizenid AND balance = 0 AND paymentamount = 0 AND paymentsleft = 0 AND financetime = 0", {['@citizenid'] = citizenid})
end

local function fetchAllVehiclesofJob(jobName)
   return MySQL.Sync.fetchAll("SELECT * FROM player_vehicles WHERE job = @jobName AND balance = 0 AND paymentamount = 0 AND paymentsleft = 0 AND financetime = 0", {['@jobName'] = jobName})
end

local function fetchAllVehiclesofJobImpounded(jobName)
   return MySQL.Sync.fetchAll("SELECT * FROM player_vehicles WHERE job = @jobName AND state = 0 or state = 2", {['@jobName'] = jobName})
end

RegisterServerEvent('v-vehicleJob:server:SellAction',function(vehicle, plate) 
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local vehPrice = QBCore.Shared.Vehicles[vehicle]["price"]
    local account = exports['qb-management']:GetAccount(Player.PlayerData.job.name)

    if account >= vehPrice then
        exports['qb-management']:RemoveMoney(Player.PlayerData.job.name, vehPrice)
        Player.Functions.AddMoney('cash', vehPrice, Lang:t("success.successSell"))

        UpdateVehState(plate,Player.PlayerData.job.name)
        TriggerClientEvent('QBCore:Notify',src,Lang:t("success.sellVehicleCorrectly"), 'success')
    else
        TriggerClientEvent('QBCore:Notify',src,Lang:t("error.jobDoesntHaveEnoughMoney"), 'error')
    end
end)

RegisterServerEvent('v-vehicleJob:server:BuyAction',function(vehicle, plate) 
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local vehPrice = QBCore.Shared.Vehicles[vehicle]["price"]
    local cashOfPlayer = tonumber(Player.PlayerData.money['cash'])
    
    if(cashOfPlayer >= vehPrice) then
        Player.Functions.RemoveMoney('cash', vehPrice , Lang:t("success.successBuy"))
        exports['qb-management']:AddMoney(Player.PlayerData.job.name, vehPrice)
        UpdateVehState(plate, null)
        TriggerClientEvent('QBCore:Notify',src,Lang:t("success.buyVehicleCorrectly"), 'success')
    else
       TriggerClientEvent('QBCore:Notify',src,Lang:t("error.playerDoesntHaveEnoughMoney"), 'error')
    end   
end)

QBCore.Functions.CreateCallback('v-vehicleJob:server:listOfVehicles', function(source,cb,typeofEvent)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local allVehicles = {}
    if typeofEvent == 'Buy' then
       allVehicles = fetchAllVehiclesofJob(Player.PlayerData.job.name)
    elseif typeofEvent == 'Sell' then
        allVehicles = fetchAllVehiclesOfPlayer(Player.PlayerData.citizenid)
    elseif typeofEvent == 'GetImpoundedJobs' then
        local allCarsImpounded = fetchAllVehiclesofJobImpounded(Player.PlayerData.job.name)
        for k, v in pairs(allCarsImpounded) do 
            QBCore.Functions.TriggerCallback('qb-garage:server:IsSpawnOk',src, function(spawn)
                if spawn then
                   table.insert(allVehicles, v)
                end
            end, v.plate, 'depot')
        end
      
    end
   
    --print(QBCore.Debug(allVehicles))
    cb(allVehicles)   
end)



