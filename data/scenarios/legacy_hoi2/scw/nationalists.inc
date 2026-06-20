country = {
    tag = SPA
    intrinsic_gov_type = fascist

	ai = "scw_spa.ai"

    policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 3
        political_left = 4
        free_market = 1
        freedom = 3
        professional_army = 6
        defense_lobby = 7
        interventionism = 10
    	}

	capital = 333 #burgos

   	manpower = 400

	transports = 60
	escorts = 14

	# Resource Reserves
	energy	=	2000
	metal	=	2000
	rare_materials  =	2000
	oil 	=	2000
	supplies =	2000
	money	=	2000

	


   headofstate = { type = 9 id = 10279 } #Sanjurjo
   headofgovernment = { type = 9 id = 10281 } #Sanjurjo
   foreignminister = { type = 9 id = 10003 } #Serrat
   armamentminister = { type = 9 id = 10090 } #Dávila
   ministerofsecurity = { type = 9 id = 10005 }
   ministerofintelligence = { type = 9 id = 10006 } #Salas
  chiefofstaff = { type = 9 id = 10188 } #Sanjurjo
  chiefofarmy = { type = 9 id = 10008 } #Mola
  chiefofnavy = { type = 9 id = 10009 } #Moreno Fdez
  chiefofair = { type = 9 id = 10010 } #Kindelán

    ownedprovinces =
	{
		334 333 340 330 329 339 338 347 954 955 957 961 962 963 964 965 535 537 967 971 972
	}
    controlledprovinces =
	{
		334 333 340 330 329 339 338 347 954 955 957 961 962 963 964 965 535 537 967 971 972
	}
    nationalprovinces =
	{
		329 330 331 332 333 334 338 339 340 341 342 343 346 347 348 349 350 351 352 353 354 355 356 357 535 536 537 954 955 957 961 962 963 964 965 967 971 972
	}
	techapps = {
		# Group C 1936 techs
#######################

4010 4020 # Early fighter

4120 # GW Bomber

2150 # Basic Armoured Car

2010 2020 2030 # GW tank and tankette

2290 2300 2310 # GW artillery

2400 # Early AT artillery

2450 2460 # Early Static AA

2510 # Basic AA

1010 # GW infantry

1190 # GW Cavalry

1110 # Early Mountain

9010 # Air Superiority doctrine

5010 5020 # Mechanized Agriculture

5050 # Basic Machine Tools

5080 5090 5100 # Construction (up to the forts)

5190 5200 # Imp. oil conversion

5470 # Nukes faculty


6010 6020 # Superior Firepower

# Naval Techs as proposed by Canuck (subject to change)

3400 # Dive Boat

3010 3020 # Early Destroyer

3070 3080 # Early Light Cruiser

3130 3140 3150 # Basic Heavy Cruiser

3250 # Great War Battleship

8010 # Decisive Battle Doctrine

8020 # Naval Firepower Doctrine

8040 # Fleet Auxiliary Submarine Doctrine

8050 # Convoy Sailing Doctrine
 1020 2040 3030
	}

#######################################################################

## UNIDADES EN CONSTRUCCIÓN (hecho)

	division_development = {
		id = { type = 9998 id = 35 }
		name = "España"
		type = battleship
		model = 1
		cost = 1
		date = { year = 1936 month = august day = 1 }

	}

	division_development = {
		id = { type = 9998 id = 36 }
		name = "Canarias"
		type = heavy_cruiser
		model = 2
		cost = 1
		date = { year = 1936 month = september day = 1 }
	}

	division_development = {
		id = { type = 9998 id = 37 }
		name = "Baleares"
		type = heavy_cruiser
		model = 2
		cost = 1
		date = { year = 1936 month = december day = 1 }
	}

	division_development = {
		id = { type = 9998 id = 38 }
		name = "Almirante Cervera"
		type = heavy_cruiser
		model = 1
		cost = 1
		date = { year = 1936 month = december day = 1 }
	}

	division_development = {
		id = { type = 9998 id = 39 }
		name = "Navarra"
		type = light_cruiser
		model = 1
		cost = 1
		date = { year = 1938 month = june day = 1 }
	}

## UNIDADES NAVALES

	navalunit = {
		location = 347 #Sevilla
		base = 347
		id = { type = 17500 id = 1 }
		name = "Base Naval Cádiz"
		leader = 3478 #Fernández en mediterraneo
		division = { id = { type = 17500 id = 21 }
			     name = "Velasco"
			     strength = 100
			     type = destroyer
			     model = 2 }
		division = { id = { type = 17500 id = 22 }
			     name = "Flotilla de Escolta"
			     strength = 100
			     type = destroyer
			     model = 1 }
		division = { id = { type = 17500 id = 23 }
			     name = "3a Flotilla de Transporte Naval"
			     strength = 100
			     type = transport }
		division = { id = { type = 17500 id = 24 }
			     name = "4a Flotilla de Transporte Naval"
			     strength = 100
			     type = transport }
		}


	navalunit = {
		location = 334 #Galicia
		base = 334
		id = { type = 17500 id = 25 }
		name = "Flota del Atlántico"
		leader = 3471 #Cervera en atlantico
		division = { id = { type = 17500 id = 26 }
		     	     name = "Flotilla de Torpederos nro. 1"
		     	     strength = 100
		             type = destroyer
		             model = 0 }
		division = { id = { type = 17500 id = 27 }
		             name = "Flotilla de Torpederos nro. 2"
		             strength = 100
		             type = destroyer
		             model = 1 }
		division = { id = { type = 17500 id = 28 }
		             name = "1a Flotilla de Transporte Naval"
		             strength = 100
		             type = transport }
		division = { id = { type = 17500 id = 29 }
		             name = "2a Flotilla de Transporte Naval"
		             strength = 100
		             type = transport }
		}

#FUERZAS AEREAS (hechas)

	airunit = {
		location = 334 #Vigo
		base = 334
		id = { type = 17500 id = 30 }
		name = "Grupo Mixto 5G5"
		leader = 3487 #Muñoz Jimenez
		division = { id = { type = 17500 id = 31 }
			     name = "1a Grupo Aéreo Táctica ARE"
			     strength = 30
			     type = tactical_bomber }
		division = { id = { type = 17500 id = 32 }
			     name = "2a Grupo Aéreo Táctica ARE"
			     strength = 30
			     type = tactical_bomber }
	}



	airunit = {
		location = 957 #Ceuta
		base = 957
		id = { type = 17500 id = 33 }
		name = "Fuerzas Aéreas de África"
		leader = 3486 #Kindelan
		division = { id = { type = 17500 id = 34 }
			     name = "Grupo Aéreo de Observación"
			     strength = 30
			     type = interceptor }
	}



## EJÉRCITOS DE TIERRA (hechos)

	landunit = {
		id = { type = 17500 id = 2 }
		location = 347 #Sevilla
		name = "Ejército Sur"
		leader = 3451 #Queipo

		division = {
			id = { type = 17500 id = 3 }
			name = "II División"
			type = infantry
			model = 1
                        extra = artillery
			}
	}

	landunit = {
		id = { type = 17500 id = 4 }
		location = 333 #Burgos
		name = "Ejército Centro-Norte"
		leader = 3443 #Mola

		division = {
			id = { type = 17500 id = 5 }
			name = "5a Zaragoza"
			type = infantry
			model = 1
		}

		division = {
			id = { type = 17500 id = 6 }
			name = "6a Burgos (Brig.Navarras M)"
			type = infantry
			model = 1
                        extra = artillery
		}

		division = {
			id = { type = 17500 id = 7 }
			name = "Volunt. Falangistas"
			type = militia
			model = 0
			}


		division = {
			id = { type = 17500 id = 8 }
			name = "7a Valladolid"
			type = infantry
			model = 1
		}

		division = {
			id = { type = 17500 id = 9 }
			name = "Cañones Krupp"
			type = light_armor
                        model = 1
			strength = 60
	}
}
	landunit = {
		id = { type = 17500 id = 10 }
		location = 330 #Zaragoza
		name = "Ejército de Navarra"
		leader = 3418 #Fidel Davila
		division = {
			id = { type = 17500 id = 11 }
			name = "Brigadas Navarras V"
			type = militia
		}

		division = {
			id = { type = 17500 id = 12 }
			name = "División Soria"
			type = bergsjaeger
			extra = anti_air
		}
}

	landunit = {
		id = { type = 17500 id = 40 }
		location = 347 # Sevilla
		name = "Cuerpo de Ejército Marroquí"
		leader = 3426 #Franco
		division = {
			id = { type = 17500 id = 13 }
			name = "13Div.Legionarios"
			type = bergsjaeger
		}

		division = {
			id = { type = 17500 id = 14 }
			name = "Tabores GFRI"
			type = infantry
			model = 1
		}

		division = {
			id = { type = 17500 id = 15 }
			name = "15 Div. Circ. Oriental"
			type = infantry
			model = 1
		}


	}

	landunit = {
		id = { type = 17500 id = 16 }
		location = 535 #Palma
		name = "Comandancia de Baleares"
		leader = 3433 #Goded

		division = {
			id = { type = 17500 id = 17 }
			name = "Cuerpo Insular"
			type = infantry
			model = 1
			strength = 30
		}
	}

}
