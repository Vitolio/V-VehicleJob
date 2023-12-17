Config = {}
Config.Debug = false

--Allow everyActions
Config.AllowBuyingMenu = true
Config.AllowSellingMenu = true

--Minimum required grade to sell/buy vehicle
Config.MinimumGradeToBuyVehicleForJob =  3
Config.MinimumGradeToSellVehicleJob =  3

Config.MinimumGradeToSeeImpoundedVehicles =  1

Config.pedLocations = { 
    {
        coordinates =vector4(1223.31, 2727.19, 37.0, 210.44),
        npc = 'a_m_y_business_03',
        customScenario = true,
        scenario = "WORLD_HUMAN_CLIPBOARD_FACILITY",
        blip = false,
        blipBackground = false,
        proximityBlipOnly = false,
        bliplabel = 'Fonderie',
        blipSprite = 365,
        blipColour = 25,
        blipSize = 1.0,
        blipBackgroundColour = 52,
        blipBackgroundSize = 1.6,
    },    
}
