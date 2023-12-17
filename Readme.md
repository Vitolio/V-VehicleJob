# V-VehicleJob By Vitolio

ONLY WORK FOR QBCORE

![image](https://media.discordapp.net/attachments/280323312952016897/1185932948466307112/image.png)


![image](https://media.discordapp.net/attachments/280323312952016897/1185932949149986937/image.png)


![image](https://media.discordapp.net/attachments/280323312952016897/1185932949821083739/image.png)


# HOW IT WORK ?: 
You can Sell/Buy vehicles to enterprise, and even take out vehicles from depot if you work for this enterprise.
Enterprise can now have control over their own vehicles and they can buy new one from players.
The main goal of this is to create real enterprise vehicle, it is more of an adding to qb-garages that is working pretty strangely by himself

# INSTALLATION SETTINGS
1 - Open the 'vehicleJob.sql' file</br>
2-  Paste the content of this file in your database (this script will create the 'Job' column in your player_vehicles table)</br>
3 - Go to qb-garages/client/main.lua and find the followed function : 'MenuGarage(type, garage, indexgarage)'</br>
4 - Replace this entire function with this new one :</br>
local function MenuGarage(type, garage, indexgarage)
    local header
    local leave
    if type == "house" then
        header = Lang:t("menu.header." .. type .. "_car", { value = garage.label })
        leave = Lang:t("menu.leave.car")
    else
        header = Lang:t("menu.header." .. type .. "_" .. garage.vehicle, { value = garage.label })
        leave = Lang:t("menu.leave." .. garage.vehicle)
    end

    local optionMenu = 
    {
       {
            header = header,
            isMenuHeader = true
        },
    }

    local optionList = 
    {
        header = Lang:t("menu.header.vehicles"),
        txt = Lang:t("menu.text.vehicles"),
        params = {
            event = "qb-garages:client:VehicleList",
            args = {
                type = type,
                garage = garage,
                index = indexgarage,
            }
        }
    }
    
    table.insert(optionMenu,optionList)

    if type == 'depot' then
        local optionDepotJob = 
         {
            header = 'Job Depot',
            txt = Lang:t("menu.text.vehicles"),
            params = {
                event = "v-vehicleJob:client:showVehicleDepotMenu",
                args = {
                    type = type,
                    garage = garage,
                    index = indexgarage,
                }
            }
        }
        
        table.insert(optionMenu,optionDepotJob)
    end

    local footerMenu = 
    {
        header = leave,
        txt = "",
        params = {
            event = "qb-menu:closeMenu"
        }
    }


    table.insert(optionMenu,footerMenu)

    exports['qb-menu']:openMenu(optionMenu)
end

It will create a new menu option table in the depot garage

5- Go to qb-garages/server/main.lua and find the followed callback: 'QBCore.Functions.CreateCallback("qb-garage:server:GetGarageVehicles", function(source, cb, garage, type, category)'</br>
6 - Find the line where it is written this:
MySQL.query('SELECT * FROM player_vehicles WHERE citizenid = ? AND (state = ?)', {pData.PlayerData.citizenid, 0}, function(result)

and replace it with this one
MySQL.query('SELECT * FROM player_vehicles WHERE job IS NULL AND citizenid = ? AND state = ? or state = ? ', {pData.PlayerData.citizenid, 0 , 2}, function(result)


7 - Go to your server.cfg file and ensure the 'V-VehicleJob' folder after all the other ressources</br>


# LANGUAGE SETTINGS</br>
8-> If you want to switch the language of  the resource to english, then go to the 'fxmanifest.lua' file and change 'locales/fr.lua' to 'locales/en.lua'</br>
9-> If you want to create your own translation, go to the'locales' folder and duplicate 'en.lua' to another language file. Then translate variables inside and declare the new file in the 'fxmanifest.lua'</br>

