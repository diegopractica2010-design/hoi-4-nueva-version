province = {
	id = 840
	anti_air = 2
	naval_base = {
		size = 8
		current_size = 8
		}
	air_base = {
		size = 4
		current_size = 4
		}
	}
country = {
    tag = CHL

	ai = "platineanwar_CHL.ai"

	headofstate = { type = 9 id = 44032 }
	headofgovernment = { type = 9 id = 44041 }
 	foreignminister = { type = 9 id = 44056 }
 	armamentminister = { type = 9 id = 44073 }
 	ministerofsecurity = { type = 9 id = 44093 }
 	ministerofintelligence = { type = 9 id = 44109 }
 	chiefofstaff = { type = 9 id = 44121 }
 	chiefofarmy = { type = 9 id = 44130 }
 	chiefofnavy = { type = 9 id = 44138 }        
 	chiefofair = { type = 9 id = 44146 }

    policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 8
        political_left = 8
        free_market = 8
        freedom = 7
        professional_army = 3
        defense_lobby = 5
        interventionism = 2
    }

	# Resource Reserves
energy		= 1500  
metal		= 1500
rare_materials	 	= 1000
oil 		= 200
supplies 	= 200
money 		= 40

	free = 		{
		oil 	=	8
		supplies =	30
	}

	capital = 840
	manpower = 45

diplomacy = {
	relation = { tag = ARG value = -20 }
	relation = { tag = BRA value = 10 }
	}

    ownedprovinces =      {
		864 861 860 856 840 839
		841 842
	}
    controlledprovinces = {
		864 861 860 856 840 839
		841 842
	}
    nationalprovinces =   {
		864 861 860 856 840 839
		841 842
	}

	techapps = {
# Group D 1941 techs
#######################

3020 3260 3410

4010 4020 4030 # Basic Fighter

4120 4130 # Early bomber

2010 2020 2030 2040 2050 # Improved light tank

2150 # Basic Armoured Car

2290 2300 2310 2320 # up to the WW II light artillery

1010 1020 1030 # Basic infantry

1190 1200 1210 # Basic Cavalry

1110 # Early Mountain

2330 # Basic motorized

2400 # Early AT artillery

2450 2460 2470 # Basic Static AA

2510 # Basic AA

9010 # Air superiority

5010 # Modern Agriculture

5050 # Basic Machine Tools

5080 5090 5100 # Construction (up to the forts)

5190 # Basic oil conversion

5470 # Nuclear Tier 4


6010 6020 # Superior Firepower

3010
3070
3130
3250
3400
8020 8040 8050
#hospital
14000

	}

	
	landunit = {
	id = { type = 12500 id = 1 }
	name = "Ejercito de Chile"
	location = 840
	
		division = {
		id = { type = 12500 id = 2 }
		name = "1. Brigada de Infantería"
		strength = 100
		type = infantry
		extra = artillery
		model = 0
		}

		division = {
		id = { type = 12500 id = 3 }
		name = "2. Brigada de Infantería"
		strength = 100
		type = infantry
		model = 0
		}

		division = {
		id = { type = 12500 id = 4 }
		name = "1. Brigada de Montaña de Chile"
		strength = 100
		type = bergsjaeger
		model = 0
		}

		division = {
		id = { type = 12500 id = 5 }
		name = "Brigada Caballería nro. 1"
		strength = 100
		type = cavalry
                extra = artillery
		model = 0
		}
		}

	navalunit = {
	id = { type = 12500 id = 6 }
	name = "Armada de Chile"
	location = 840
	base = 840

		# These have five DDs each:
		division = { id = { type = 12500 id = 7 } name = "Flotilla des Destructores nro. 1" type = destroyer model = 0 }
		division = { id = { type = 12500 id = 8 } name = "Flotilla des Destructores nro. 2" type = destroyer model = 1 }

		# Built 1915
		division = { id = { type = 12500 id = 9 } name = "ARC Almirante Latorre" type = battleship model = 1 }

		# Gunboat built 1930
		division = { id = { type = 12500 id = 10 } name = "ARC Blanco Encalada" type = heavy_cruiser model = 0 }
		division = { id = { type = 12500 id = 11 } name = "ARC Chacabuco" type = heavy_cruiser model = 0 }

		division = { id = { type = 12500 id = 12 } name = "Flotilla des Submarinos nro. 1" type = submarine model = 0 }
	}
	landunit = { 
	id = { type = 12500 id = 13 }
	name = "Reserva del Ejército"
	location = 840 # Santiago

		division = {
		locked = yes
		id = { type = 12500 id = 14 }
		name = "Guardia Presidencial"
		strength = 100
		type = infantry
		extra = engineer
		}
		}
} 