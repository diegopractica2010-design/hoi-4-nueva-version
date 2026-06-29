province = {
	id = 469
	anti_air = 2
	air_base = {
		size = 3
		current_size = 3
		}
	}

province = {
	id = 476
	anti_air = 2
	air_base = {
		size = 1
		current_size = 1
		}
	}


province = {	id = 472	landfort = 8	}
province = {	id = 471	landfort = 8	}
province = {	id = 466	landfort = 8	}
province = {	id = 467	landfort = 8	}
province = {	id = 474	landfort = 8	}
province = {	id = 475	landfort = 8	}
province = {	id = 476	landfort = 8	}


#Anti Aircraft Batteries
province = { id = 470   anti_air = 2 } #Plzen
province = { id = 475   anti_air = 2 } #Slavkov/Brno

  country = {
    tag = CZE


	# Resource Reserves - just to keep TP running

	energy 			= 0
	metal 			= 0
	oil 			= 10000
	rare_materials 		= 0
	supplies 		= 25000

	free = 	{
		ic = 15
	}

	extra_tc = 40 # Balanced!

	manpower = 0

	capital = 469


    policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 9
        political_left = 5
        free_market = 9
        freedom = 8
        professional_army = 5
        defense_lobby = 9
        interventionism = 5
    	}


#Ruling Cabinet
  headofstate = { type = 9 id = 24031 }
  headofgovernment = { type = 9 id = 24045 }
  foreignminister = { type = 9 id = 24054 }
  armamentminister = { type = 9 id = 24066 }
  ministerofsecurity = { type = 9 id = 24082 }
  ministerofintelligence = { type = 9 id = 24100 }
  chiefofstaff = { type = 9 id = 24112 }
  chiefofarmy = { type = 9 id = 24123 }
  chiefofnavy = { type = 9 id = 24009 } 
  chiefofair = { type = 9 id = 24140 }

    ownedprovinces =      {
		471 472 466 467 470 469 468 474 475 478 477 490 499 476
	}
    controlledprovinces = {
		471 472 466 467 470 469 468 474 475 478 477 490 499 476
	}
    nationalprovinces =   {
		471 472 466 467 470 469 468 474 475 478 477 490 499 476
	}


techapps = {

1010 # Great War Infantry
1020 # Early Infantry
1110 # Early Mountain
1190 # Great War Cavalry Division
1200 # Early Cavalry Division
1210 # Basic Cavalry Division
1220 # Semi-motorised Cavalry
1230 # Basic Motorized
2010 # Great War Tank
2020 # Tankette
2030 # Early Tank
2040 # Basic Light Tank
2050 # Improved Light Tank
2150 # Basic Armoured Car
2290 # Great War Light Field Artillery
2300 # Great War Medium Field Artillery
2310 # Great War Heavy Field Artillery
2320 # Early Field Artillery
2330 # Basic Artillery
2400 # Basic AT
2450 # Great War Static AA
2460 # Early Static AA
2510 # Basic AA
4010 # Interwar Fighter
4020 # Early Fighter 
4120 # Interwar Bomber
4130 # Early Bomber
5010 # Modern Agriculture
5020 # Mechanized Agriculture
5050 # Basic Machine Tools
5060 # Improved Machine Tools
5080 # Basic Construction Engineering
5090 # Improved Construction Engineering
5100 # Advanced Construction Engineering
5190 # Basic Oil Refining
5200 # Improved Oil Refining
6010 # Firepower Focus Doctrine
6030 # Grand Battleplan Doctrine
6120 # Trench Warfare Doctrine
9010 # Air Superiority Doctrine
9020 # Flying Circus Doctrine
14000 # GW Medicine
14010 # Early Medicine
	}



#################################
# Czech army 1938 OOB
#
# Important: This is early version of Czechoslovakian OOB in the eve of 1938 Case Green 
# operation. Some of the units possibly should start with lower initial STR values, but 
# general number and names of units are ok. Also note, that locations so far are not 
# entered - it can be used to balance initial units dislocation (to cover all border).
#
#
# Big thanks to Halibutt for support!
#####################################

# Dictionary:
# Corps = armádní sbor
# Air Force = Vojenské letectvo
# Army = armáda
# Border Sector = Hranice Kruhová

# Fast divisions are represented by either tank division (1st) 
# or semi-moto cavalry with AT attached (rest)!


	# Reserves - VIII Corps - Moravia

	landunit = {
        id = { type = 12073 id = 1 } 
		location = 467 # Tabor
		name = "8. armádní sbor"

		division = {
	        id = { type = 12073 id = 2 } 
			name = "9. divize"
			type = infantry
			model = 1
		}
		division = {
	        id = { type = 12073 id = 3 } 
			name = "15. divize"
			type = infantry
			model = 1
		}
		division = {
	        id = { type = 12073 id = 4 } 
			name = "21. divize"
			type = infantry
			model = 1
		}
	}

	# Reserves - more

	landunit = {
        id = { type = 12073 id = 5 } 
		location = 470 # central bohemia
		name = "Celek Rezerva"

		division = {
	        id = { type = 12073 id = 6  } 
			name = "1. rychlá divize"
			type = cavalry
			model = 3
			extra = anti_tank
		}
		division = {
	        id = { type = 12073 id = 7 } 
			name = "4. divize (horska)"
			type = bergsjaeger
			model = 0
		}
		division = {
	        id = { type = 12073 id = 8 } 
			name = "12. divize (horska)"
			type = bergsjaeger
			model = 0
		}
		division = {
	        id = { type = 12073 id = 9 } 
			name = "13. divize (mot)"
			type = motorized
			model = 0
                        extra = armored_car
		}
		division = {
	        id = { type = 12073 id = 10 } 
			name = "16. divize (horska)"
			type = bergsjaeger
			model = 0
		}
		division = {
	        id = { type = 12073 id = 11 } 
			name = "22. divize"
			type = infantry
			model = 1
			extra = artillery
			brigade_model = 1 # Medium GW
		}
	}

	# 1st Army in Bohemia

	landunit = {
        id = { type = 12073 id = 12 } 
		location = 472
		name = "1. armáda"

		division = {
	        id = { type = 12073 id = 13 } 
			name = "18. divize"
			type = infantry
			model = 1
			extra = artillery
			brigade_model = 1 # Medium GW
		}
		division = {
	        id = { type = 12073 id = 14 } 
			name = "3/4 Kruhová"
			type = infantry
			model = 1
		}

		division = {
	        id = { type = 12073 id = 15 } 
			name = "XI Hranice Kruhová"
			type = infantry
			model = 1
		}

		division = {
	        id = { type = 12073 id = 16 } 
			name = "XII Hranice Kruhová"
			type = infantry
			model = 1
			extra = artillery
			brigade_model = 1 # Medium GW
		}

	}

	# I Corps Bohemia

	landunit = {
        id = { type = 12073 id = 17 } 
		location = 471 # Usti
		name = "1. armádní sbor"

		division = {
	        id = { type = 12073 id = 18 } 
			name = "2. divize"
			type = infantry
			model = 1
			extra = artillery
			brigade_model = 1 # Medium GW
		}
		division = {
	        id = { type = 12073 id = 19 } 
			name = "5. divize"
			type = infantry
			model = 1
		}
		division = {
	        id = { type = 12073 id = 20 } 
			name = "32. Hranice Kruhová"
			type = infantry
			model = 1
		}
	}

	# II Corps - Bohemia

	landunit = {
        id = { type = 12073 id = 21 } 
		location = 466 # Strakonice
		name = "2. armádní sbor"

		division = {
	        id = { type = 12073 id = 22 } 
			name = "3. divize"
			type = infantry
			model = 1
		}
		division = {
	        id = { type = 12073 id = 23 } 
			name = "17. divize (horska)"
			type = bergsjaeger
			model = 0
		}
		division = {
	        id = { type = 12073 id = 24 } 
			name = "33. Hranice Kruhová"
			type = infantry
			model = 1
			extra = artillery
			brigade_model = 1 # Medium GW
		}
	}

	# 2nd Army/4th Corps in northern Moravia 

	landunit = {
        id = { type = 12073 id = 25 } 
		location = 474 # Ostrava
		name = "2. armáda"


		division = {
	        id = { type = 12073 id = 26 } 
			name = "8. divize"
			type = infantry
			model = 1
			extra = artillery
			brigade_model = 1 # Medium GW
		}
		division = {
	        id = { type = 12073 id = 27 } 
			name = "7. divize"
			type = infantry
			model = 1
		}

		division = {
	        id = { type = 12073 id = 28 } 
			name = "XIII Hranice Kruhová"
			type = infantry
			model = 1
		}

	}

	# 3rd Army - Slovakia 

	landunit = {
        id = { type = 12073 id = 29 } 
		location = 476 # Bratislava
		name = "3. armáda"

		division = {
	        id = { type = 12073 id = 30 } 
			name = "3. rychlá divize"
			type = cavalry
			model = 3
			extra = anti_tank
		}
		division = {
	        id = { type = 12073 id = 31 } 
			name = "10. divize"
			type = infantry
			model = 1
			extra = artillery
			brigade_model = 1 # Medium GW
		}
		division = {
	        id = { type = 12073 id = 32 } 
			name = "11. divize"
			type = infantry
			model = 1
		}
		division = {
	        id = { type = 12073 id = 33 } 
			name = "XV Hranice Kruhová" # Merged with VII Corps border guards
			type = infantry
			model = 1
		}
		division = {
	        id = { type = 12073 id = 34 } 
			name = "XVI Hranice Kruhová"
			type = infantry
			model = 1
		}
	}

	# 4th Army - southern Moravia

	landunit = {
        id = { type = 12073 id = 35 } 
		location = 475 # Brno
		name = "4. armáda"

		division = {
	        id = { type = 12073 id = 36 } 
			name = "2. rychlá divize"
			type = cavalry
			model = 3
			extra = anti_tank
		}
		division = {
	        id = { type = 12073 id = 37 } 
			name = "14. divize"
			type = infantry
			model = 1
			extra = artillery
			brigade_model = 1 # Medium GW
		}
		division = {
	        id = { type = 12073 id = 38 } 
			name = "19. divize"
			type = infantry
			model = 1
			extra = artillery
			brigade_model = 1 # Medium GW
		}
		division = {
	        id = { type = 12073 id = 39 } 
			name = "39 Hranice Kruhová" # Merged with 2nd group
			type = infantry
			model = 1
		}

		division = {
	        id = { type = 12073 id = 40 } 
			name = "4. rychlá divize"
			type = light_armor
			model = 2
		}
		division = {
	        id = { type = 12073 id = 41 } 
			name = "6. divize"
			type = infantry
			model = 1
		}
		division = {
	        id = { type = 12073 id = 42 } 
			name = "20. divize"
			type = infantry
			model = 1
		}
	}



#### Czechoslovakian Air Force


	airunit = {
        id = { type = 12074 id = 1 } 
		location = 469 # Praha
		name = "Vojenské letectvo"

		division = {
	        id = { type = 12074 id = 2 } 
			name = "1. stihaci letecky pluk"
			type = interceptor
			model = 1
		}
		division = {
	        id = { type = 12074 id = 3 } 
			name = "2. stihaci letecky pluk"
			type = interceptor
			model = 1
		}
		division = {
	        id = { type = 12074 id = 4 } 
			name = "3. stihaci letecky pluk"
			type = interceptor
			model = 1
		}
		division = {
	        id = { type = 12074 id = 5 } 
			name = "5. bombardovaci letecky pluk"
			type = tactical_bomber
			model = 1
		}
		division = {
	        id = { type = 12074 id = 6 } 
			name = "6. bombardovaci letecky pluk"
			type = tactical_bomber
			model = 1
		}
	}


#################

}
