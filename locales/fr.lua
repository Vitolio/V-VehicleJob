local Translations = {  
	menu = {
      header = "Achat/revente de véhicule professionel",
      price = "Prix : ",
      submit = "Valider",
      quantity = "Quantité",
      goodBye = 'Au revoir',
      goodByeGarage = 'Quitter le garage',
      sellvehicle = 'Vendre un véhicule à mon entreprise',
      buyVehicle = 'Acheter un véhicule à mon entreprise',
      goBackward = 'Revenir en arrière',
      sellPrice = 'Vendre pour : ',
      depot = "Plaque: %{value}<br>Réservoir: %{value2} | Moteur: %{value3} | Carrosserie: %{value4}",
      getVehicleFromImpound = "Récupérer un véhicule professionel"
    },
    ped = {
    	talkto = "Parler au revendeur",
    },
    error = {
      notEnoughHighRank = "Vous n'êtes pas autorisé par votre entreprise à faire ça",
      jobDoesntHaveEnoughMoney = "L'entreprise n'a pas asser d\'argent sur son compte",
      playerDoesntHaveEnoughMoney = "Vous n\'avez pas asser d\'argent pour acheter ce véhicule"
    },
    success = {
    	successSell = "Vente de véhicule à une entreprise",
      successBuy = "Achat de véhicule à une entreprise",
      sellVehicleCorrectly = "Votre véhicule a bien été racheté par votre entreprise !",
      buyVehicleCorrectly = "Vous avez racheté un véhicule d\'entreprise !"
    },
    status = {
        out = "Dehors",
        garaged = "Garé",
        impound = "En Fourrière par la Police",
    },
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})