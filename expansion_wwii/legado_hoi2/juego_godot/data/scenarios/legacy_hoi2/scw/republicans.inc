country = {
    tag = SPR
    regular_id = SPA
	intrinsic_gov_type = left_wing_radical

	ai = "scw_spr.ai"
    policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 7
        political_left = 6
        free_market = 6
        freedom = 10
        professional_army = 2
        defense_lobby = 4
        interventionism = 8
    }

	capital = 341
	dissent = 15
   	manpower = 850

	transports = 60
	escorts = 14

	# Resource Reserves
	energy	=	2000
	metal	=	2000
	rare_materials =	2000
	oil 	=	2000
	supplies =	2000
	money	=	2000 #depositos de plata republicana, ¿no?

	headofstate = { type = 9 id = 11033 } #Azaña
	headofgovernment = { type = 9 id = 11069 } #Martinez Barrio
	foreignminister = { type = 9 id = 11096 } #Barcia Trelles
	armamentminister = { type = 9 id = 11144 } #Giner de los Rios
  	ministerofsecurity = { type = 9 id = 11189 } #Azcarate
  	ministerofintelligence = { type = 9 id = 11217 } #Balboa
 	chiefofstaff = { type = 9 id = 11007 } #Miaja
	chiefofarmy = { type = 9 id = 11291 } #Miaja
 	chiefofnavy = { type = 9 id = 11309 } #Giral
 	chiefofair = { type = 9 id = 11321 } #Hidalgo de Cisneros


    ownedprovinces =
	{
		331 332 341 342 343 346 349 350 351 352 353 354 355 356 357 536
	}
    controlledprovinces =
	{
		331 332 341 342 343 346 349 350 351 352 353 354 355 356 357 536
	}
    nationalprovinces =
	{
		329 330 331 332 333 334 338 339 340 341 342 343 346 347 348 349 350 351 352 353 354 355 356 357 535 536 537 954 955 957 961 962 963 964 965 967 971 972
	}
	techapps = {
		# Group C 1936 techs
#######################

4010 4020 # Early fighter

4120 4130 # Early Bomber

2150 # Basic Armoured Car

2010 2020 # GW tank and tankette

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
1020 1310 1120 4220 3260 3030 3410
	}

############################################################
#UNIDADES EN DESARROLLO

#Ninguna

#EJERCITO DE TIERRA
	landunit = {
		id = { type = 16500 id = 1 }
		location = 331 #Bilbao
		name = "Ejército de Euskadi"
		leader = 3035 #Ulibarri
		division = {
			id = { type = 16500 id = 2 }
			name = "Zapadores GH"
			type = infantry
			model = 1
		}

		division = {
			id = { type = 16500 id = 3 }
			name = "Euzko Gudarostea"
			type = militia
			model = 0
			strength = 90
		}
	}

	landunit = {
		id = { type = 16500 id = 4 }
		location = 341 #Madrid
		name = "Ejército del Centro"
		leader = 3065 #Miaja

		division = {
			id = { type = 16500 id = 5 }
			name = "BM XII"
			type = infantry
			model = 1
			extra = engineer
		}

		division = {
			id = { type = 16500 id = 6 }
			name = "5º Regimiento MAOC"
			type = militia
			model = 0
			strength = 30
		}

		division = {
			id = { type = 16500 id = 7 }
			name = "BM 1 El Campesino"
			type = infantry
			model = 1
                        extra = artillery
		}

		division = {
			id = { type = 16500 id = 9 }
			name = "Autoametralladoras-cañon"
			type = light_armor
                        model = 0
			strength = 30
		}
	}

	landunit = {
		id = { type = 16500 id = 10 }
		location = 357 #Barcelona
		name = "Ejército del Este"
		leader = 3075 #Pozas

		division = {
			id = { type = 16500 id = 11 }
			name = "28 Div. (CNT)"
			type = infantry
			model = 1
		}

		division = {
			id = { type = 16500 id = 12 }
			name = "Milícia Durruti CNT/FAI"
			type = militia
			model = 0
			strength = 60
		}

		division = {
			id = { type = 16500 id = 13 }
			name = "Guardia de Asalto"
			type = infantry
			model = 1
			extra = engineer
		}

		division = {
			id = { type = 16500 id = 14 }
			name = "27 Div. (PSUC)"
			type = militia
			model = 0
		}

		division = {
			id = { type = 16500 id = 15 }
			name = "División Alpina"
			type = bergsjaeger
			model = 1
		}

		division = {
			id = { type = 16500 id = 16 }
			name = "Milícia Ascaso"
			type = militia
			model = 0
		}
	}

	landunit = {
		id = { type = 16500 id = 17 }
		location = 350 #Almería
		name = "Ejército del Sur"
		leader = 3056 #Monje

		division = {
			id = { type = 16500 id = 18 }
			name = "BM 73"
			type = infantry
			model = 1
                        extra = anti_air
		}

		division = {
			id = { type = 16500 id = 19 }
			name = "BM 76"
			type = infantry
			model = 1
		}
	}

		landdivision = {
		dormant = yes
			id = { type = 16500 id = 52 }
			name = "1a Brigada Internacional"
			type = militia
			model = 0
		}

		landdivision = {
		dormant = yes
			id = { type = 16500 id = 54 }
			name = "2a Brigada Internacional"
			type = militia
			model = 0
		}

		landdivision = {
		dormant = yes
			id = { type = 16500 id = 56 }
			name = "3a Brigada Internacional"
			type = militia
			model = 0
		}



#ARMADA

	navalunit = { location = 352 #murcia/cartagena
		      base = 352  #murcia/cartagena
		      id = { type = 16500 id = 21 }
		      name = "Base Naval Cartagena"
		      leader = 3094 #Buiza
		division = { id = { type = 16500 id = 22 }
			name = "Miguel de Cervantes"
			strength = 100
			type = light_cruiser
			model = 1 }
		division = { id = { type = 16500 id = 23 }
			name = "Flotilla de Escolta"
			strength = 100
			type = destroyer
			model = 1 }
	}

	navalunit = { location = 2428 #navegando enfrente de huelva
		      base = 352 #murcia/cartagena
		      id = { type = 16500 id = 51 }
		      name = "Flotilla Méndez Núñez"
		division = { id = { type = 16500 id = 24 }
			name = "ARE Méndez Núñez"
			strength = 100
			type = light_cruiser
			model = 1 }
	}

	navalunit = { location = 2429 #navegando en el estrecho de gibraltar
		      base = 352 #murcia/cartagena
		      id = { type = 16500 id = 25 }
		      name = "Armada Republicana"
		division = { id = { type = 16500 id = 26 }
			name = "ARE Jaime I"
			strength = 50
			type = battleship
			model = 1 }
		division = { id = { type = 16500 id = 27 }
			name = "ARE Libertad"
			strength = 50
			type = light_cruiser
			model = 1 }
		division = { id = { type = 16500 id = 28 }
			name = "Flotilla de Torpedeiros nro. 1"
			strength = 100
			type = destroyer
			model = 0 }
		division = { id = { type = 16500 id = 29 }
			name = "Flotilla de Torpedeiros nro. 2"
			strength = 100
			type = destroyer
			model = 1 }
		division = { id = { type = 16500 id = 30 }
			name = "1a Flotilla de Transporte Naval"
			strength = 100
			type = transport }
		division = { id = { type = 16500 id = 31 }
			name = "2a Flotilla de Transporte Naval"
			strength = 100
			type = transport }
	}

	navalunit = { location = 352 #Murcia/Cartagena
		      base = 352 #murcia/cartagena
		      id = { type = 16500 id = 32 }
		      name = "Armada de Escolta Cart."
		division = { id = { type = 16500 id = 33 }
			name = "Flotilla de Torpedeiros nro. 3"
			strength = 100
			type = destroyer
			model = 1 }
		division = { id = { type = 16500 id = 34 }
			name = "Flotilla de Torpedeiros nro. 4"
			strength = 100
			type = destroyer
			model = 2 }
		division = { id = { type = 16500 id = 35 }
			name = "3a Flotilla de Transporte Naval"
			strength = 100
			type = transport }
		division = { id = { type = 16500 id = 36 }
			name = "4a Flotilla de Transporte Naval"
			strength = 100
			type = transport }
	}

	navalunit = { location = 2431 #mar de alborán
	              base = 352 #murcia/cartagena
	              id = { type = 16500 id = 37 }
	              name = "Serie-C"
		division = { id = { type = 16500 id = 38 }
			name = "C-1"
			strength = 100
			type = submarine
			model = 0 }
		division = { id = { type = 16500 id = 39 }
			name = "C-3"
			strength = 100
			type = submarine
			model = 0 }
	}

	navalunit = { location = 2431 #mar de alborán
	              base = 352 #murcia/cartagena
		      id = { type = 16500 id = 40 }
		      name = "Serie-B"
		division = { id = { type = 16500 id = 41 }
			name = "B-1"
			strength = 75
			type = submarine
			model = 1 }
		division = { id = { type = 16500 id = 42 }
			name = "B-2"
			strength = 75
			type = submarine
			model = 1 }
	}

#EJERCITO DE AIRE

	airunit = { location = 341 #madrid
			base = 341
		    id = { type = 16500 id = 43 }
		    name = "1a Escuadra Aérea"
		division = { id = { type = 16500 id = 44 }
			name = "1a Grupo Aéreo Táctica ARE"
			strength = 30
			type = tactical_bomber }
		division = { id = { type = 16500 id = 45 }
			name = "2a Grupo Aéreo Táctica ARE"
			strength = 30
			type = tactical_bomber }
	}

	airunit = { location = 350 #almería
			base = 350
		    id = { type = 16500 id = 46 }
		    name = "2a Escuadra Aérea"
		division = { id = { type = 16500 id = 47 }
			name = "1a Grupo Aéreo de Caza ARE"
			strength = 30
			type = interceptor
			model = 0}
		division = { id = { type = 16500 id = 48 }
			name = "3a Grupo Aéreo de Caza ARE"
			strength = 30
			type = interceptor
			model = 0}
	}

	airunit = { location = 357 #lleida/barcelona
			base = 357
		    id = { type = 16500 id = 49 }
	            name = "3a Escuadra Aérea"
		division = { id = { type = 16500 id = 50 }
			name = "1a Grupo Aéreo Estratégica ARE"
			strength = 30
			type = strategic_bomber
			model = 0 }
	}

landunit = {
		id = { type = 16500 id = 57 }
		location = 346 #Huelva
		name = "1 Guardia de Asalto"
		dig_in = 10

		division = {
			id = { type = 16500 id = 58 }
			name = "1a Guardia de Asalto"
			type = garrison
			model = 0
		}
		division = {
			id = { type = 16500 id = 59 }
			name = "1b Guardia de Asalto"
			type = garrison
			model = 0
		}
}

landunit = {
		id = { type = 16500 id = 60 }
		location = 351 #Jaén
		name = "2 Guardia de Asalto"
		dig_in = 10

		division = {
			id = { type = 16500 id = 61 }
			name = "2a Guardia de Asalto"
			type = garrison
			model = 0
		}
		division = {
			id = { type = 16500 id = 62 }
			name = "2b Guardia de Asalto"
			type = garrison
			model = 0
		}
}

landunit = {
		id = { type = 16500 id = 63 }
		location = 343 #Badajoz
		name = "3 Guardia de Asalto"
		dig_in = 10

		division = {
			id = { type = 16500 id = 64 }
			name = "3a Guardia de Asalto"
			type = garrison
			model = 0
		}
		division = {
			id = { type = 16500 id = 65 }
			name = "3b Guardia de Asalto"
			type = garrison
			model = 0
		}
}

landunit = {
		id = { type = 16500 id = 66 }
		location = 356 #Taragona
		name = "4 Guardia de Asalto"
		dig_in = 10

		division = {
			id = { type = 16500 id = 67 }
			name = "4a Guardia de Asalto"
			type = garrison
			model = 0
		}
		division = {
			id = { type = 16500 id = 68 }
			name = "4b Guardia de Asalto"
			type = garrison
			model = 0
		}
}

landunit = {
		id = { type = 16500 id = 69 }
		location = 355 #Castellón
		name = "5 Guardia de Asalto"
		dig_in = 10

		division = {
			id = { type = 16500 id = 70 }
			name = "5a Guardia de Asalto"
			type = garrison
			model = 0
		}
		division = {
			id = { type = 16500 id = 71 }
			name = "5b Guardia de Asalto"
			type = garrison
			model = 0
		}

}

landunit = {
		id = { type = 16500 id = 72 }
		location = 353 #Albacete
		name = "6 Guardia de Asalto"
		dig_in = 10

		division = {
			id = { type = 16500 id = 73 }
			name = "6a Guardia de Asalto"
			type = garrison
			model = 0
		}
		division = {
			id = { type = 16500 id = 74 }
			name = "6b Guardia de Asalto"
			type = garrison
			model = 0
		}
}

}
