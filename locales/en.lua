local Translations = {  
  menu = {
      header = "Purchase/resale of professional vehicle",
      price = "Price: ",
      submit = "Validate",
      quantity = "Quantity",
      goodBye = 'Goodbye',
      goodByeGarage = 'Leave the garage',
      sellvehicle = 'Sell a vehicle to my company',
      buyVehicle = 'Buy a vehicle from my company',
      goBackward = 'Go back',
      sellPrice = 'Sell for: ',
      depot = "Plate: %{value}<br>Tank: %{value2} | Engine: %{value3} | Bodywork: %{value4}",
      getVehicleFromImpound = "Recover a professional vehicle"
    },
    ped = {
      talkto = "Talk to the dealer",
    },
    error = {
      notEnoughHighRank = "You are not authorized by your company to do this",
      jobDoesntHaveEnoughMoney = "The company does not have enough money in its account",
      playerDoesntHaveEnoughMoney = "You don\'t have enough money to buy this vehicle"
    },
    success = {
     successSell ="Vehicle sale to a company",
      successBuy = "Purchase of vehicle from a company",
      sellVehicleCorrectly = "Your vehicle has been purchased by your company!",
      buyVehicleCorrectly = "You have purchased a company vehicle!"
    },
    status = {
      out = "Outside",
      garaged = "Parked",
      impound = "Impounded by the Police",
    },
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})