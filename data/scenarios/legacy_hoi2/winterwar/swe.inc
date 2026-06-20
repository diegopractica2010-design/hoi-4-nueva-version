province = {
	id = 114
	anti_air = 1
	naval_base = {
		size = 5
		current_size = 5
	}
	air_base = {
		size = 10
		current_size = 10
	}
}
country = {
    tag = SWE
	# Resource Reserves
	energy	=	35000  metal	=	35000	rare_materials =	25000

	policy = {
        date = { year = 1939 month = november day = 29 }
        democratic = 10
        political_left = 10
        freedom = 7
        free_market = 7
        professional_army = 3
        defense_lobby = 5
        interventionism = 4
    }

		headofstate = { type = 9 id = 7031 }
		headofgovernment = { type = 9 id = 7033 }
  		foreignminister = { type = 9 id = 7038 }
  		armamentminister = { type = 9 id = 7047 }
  		ministerofsecurity = { type = 9 id = 7058 }
  		ministerofintelligence = { type = 9 id = 7069 }
  		chiefofstaff = { type = 9 id = 7072 }
  	#	chiefofarmy = { type = 9 id = 7078 }
  		chiefofnavy = { type = 9 id = 7086 } 
  	#	chiefofair = { type = 9 id = 7090 }

	supplies = 1000
	oil = 1000
	extra_tc = 80
	free = {
		oil = 30
		supplies = 40
		ic = 15
	 }

	manpower = 85
	capital =  114


    ownedprovinces =      {
		114
	 }
    controlledprovinces = {
		114
	  }
	nationalprovinces =   {
		114
	}

	techapps = {
# Group C 1939 techs
#######################

5070

4170 3190 3130

4010 4020 # Early Fighter

4120 4130 # Early Bomber

2150 # Basic Armoured Car

2010 2020 2030 2040 # Basic light tank

2290 2300 2310 2320 # up to WWII early artillery

2330 2400 # Basic AT

2450 2460 # Early Static AA

2510 # Basic AA

1010 1020 # Early infantry

1190 1200 # Early Cavalry

1110 # Early Mountain

9010 9020 # Flying Circus doctrine

5010 5020 5030 # Agriculture (up to fertilizers)
5050 #Basic Machine Tools
5080 5090 5100 # Construction (up to the forts)
5110 # Supplies
5190 5200 # Imp. oil conversion
5470 # Nukes faculty

6010 6020 # Superior Firepower

3010 3020
3070 3080
3250
3400 3410

8010 8020 8040 8050
#hospital
14000

	}


###################################
###SWEDISH ARMY EXP39##############	#Also called KRIGSFALL I
###################################
landunit = {
		location = 114
		leader = 9008 # CA Ehrensvärd
        id = { type = 30027 id = 1 }
		name = "1a Armékåren"

		division = {
	        id = { type = 30027 id = 50 }
			name = "1a Armékårstaben"
			type = hq
			model = 1
			strength  = 30
			organisation = 30
			extra = artillery
			brigade_model = 2
		}

		division = {
	        id = { type = 30027 id = 2 }
			name = "III. Arméfördelningen"
			type = infantry
			model = 1
			strength  = 100
			organisation = 50
			extra = artillery
			brigade_model = 1
		}
		division = {
	        id = { type = 30027 id = 6 }
			name = "IV. Arméfördelningen"
			type = infantry
			model = 1
			strength  = 100
			organisation = 50
			extra = artillery
			brigade_model = 1
		}
		division = {
	        id = { type = 30027 id = 8 }
			name = "V. Arméfördelningen"
			type = infantry
			model = 1
			strength  = 100
			organisation = 50
			extra = engineer
		}
		division = {
	        id = { type = 30027 id = 5 }
			name = "VI. Arméfördelningen"
			type = infantry
			model = 1
			strength  = 100
			organisation = 50
			extra = artillery
			brigade_model = 1
		}
	}

landunit = {
		location = 114
        id = { type = 30027 id = 15 }
		name = "Kavalleribrigaden"
		leader = 9007 #Douglas

		division = {
	        id = { type = 30027 id = 16 }
			name = "Kavalleribrigaden"
			type = cavalry
			model = 1
			strength  = 30
			max_strength = 30
			organisation = 80
		}
	}
	landunit = {
		location = 114
        id = { type = 30027 id = 9 }
		name = "Ålandsbrigaden"
		leader = 9020 #Rappe

		division = {
	        id = { type = 30027 id = 10 }
			name = "Ålandsbrigaden"
			type = infantry
			model = 1
			strength  = 30
			max_strength = 30
			organisation = 80
		}
	}
###################################
###SWEDISH AIR FORCE OOB39#########
###################################

airunit = {
		location = 114
        id = { type = 30027 id = 17 }
		name = "1a Flygkåren"
		leader = 9040 #Nordenskiöld

		division = {
	        id = { type = 30027 id = 18 }
			name = "11./12./13. Bombskvadron"
			type = tactical_bomber	#Junkers Ju 86
			model = 1
			strength = 36
			max_strength = 36
				}
	}
airunit = {
		location = 114
        id = { type = 30027 id = 25 }
		name = "3a Flygkåren"
		leader = 9039 #Ljungdahl

		division = {
	        id = { type = 30027 id = 26 }
			name = "81./82./83. Jaktskvadron"
			type = interceptor	#Gloster Gladiator
			model = 0
			strength = 36
			max_strength = 36
				}
	}
###################################
###SWEDISH NAVY OOB39##############
###################################
navalunit = {
		name = "Kustflottan"
        id = { type = 30027 id = 29 }
		leader = 9028 #de Champs
		location = 101

		division = {
			id = { type = 30027 id = 30 }
			name = "Gustaf V"
			type = battlecruiser
			model = 0
			strength  = 100
				}
		division = {
			id = { type = 30027 id = 31 }
			name = "Drottning Victoria"
			type = battlecruiser
			model = 0
			strength  = 100
				}
		division = {
			id = { type = 30027 id = 32 }
			name = "Gotland"
			type = light_cruiser
			model = 1
			airattack = 5
			strength  = 100
				}
		division = {
			id = { type = 30027 id = 33 }
			name = "1. Jagarflottiljen"
			type = destroyer
			model = 1
			strength  = 100
				}
		division = {
			id = { type = 30027 id = 34 }
			name = "2. Jagarflottiljen"
			type = destroyer
			model = 0
			strength  = 100
				}
		division = {
			id = { type = 30027 id = 37 }
			name = "1. Expeditionsflottiljen"
			type = transport
			strength  = 100
				}
		division = {
			id = { type = 30027 id = 38 }
			name = "2. Expeditionsflottiljen"
			type = transport
			strength  = 100
				}
	}
navalunit = {
		name = "Fristående Ubåtsgruppen"
        id = { type = 30027 id = 39 }
		leader = 9034 #Strömbäck
		location = 101

		division = {
			id = { type = 30027 id = 35 }
			name = "1. Ubåtsflottiljen"
			type = submarine
			model = 1
			strength  = 100
				}
		division = {
			id = { type = 30027 id = 36 }
			name = "2. Ubåtsflottiljen"
			type = submarine
			model = 0
			strength  = 100
				}
		}
}
