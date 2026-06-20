 province = {
	id = 815
	anti_air = 1
	air_base = {
		size = 2
		current_size = 2
		}

	naval_base = {
		size = 4
		current_size = 4
		}
	}
country = {
    tag = ECU

	ai = "platineanwar_ECU.ai"

	headofstate = { type = 9 id = 40040 }
	headofgovernment = { type = 9 id = 40058 }
 	foreignminister = { type = 9 id = 40078 }
 	armamentminister = { type = 9 id = 40094 }
 	ministerofsecurity = { type = 9 id = 40107 }
 	ministerofintelligence = { type = 9 id = 40121 }
 	chiefofstaff = { type = 9 id = 40135 }
 	chiefofarmy = { type = 9 id = 40165 }
 	chiefofnavy = { type = 9 id = 40156 }        
 	chiefofair = { type = 9 id = 40162 }

    policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 4
        political_left = 5
        free_market = 8
        freedom = 5
        professional_army = 3
        defense_lobby = 5
        interventionism = 1
    }

	# Resource Reserves
	
energy		= 500   
metal		= 500	
rare_materials 		= 200	
oil 		= 100	
supplies 	= 100
money 		= 100

	free = 		{
		oil 	=	6
		supplies =	20
	}

	capital = 815
	manpower = 25

diplomacy = {
	relation = { tag = ARG value = 10 }
	relation = { tag = BRA value = 10 }
	}

    ownedprovinces =      {
		814 815 817 818
	}
    controlledprovinces = {
		814 815 817 818
	}
    nationalprovinces =   {
		814 815 817 818
	}

	techapps = {
# Group D 1941 techs
#######################

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

6010 6020 # Superior Firepower

# No Nuclear Research (Tier 5)
#hospital
14000
 
	}

	landunit = {
	id = { type = 29000 id = 50 }
	name = "Ejercito de Ecuador"
	location = 815

			division = {
			id = { type = 29000 id = 5000 }
			name = "1a Brigada de Infantería"
			strength = 100
			type = infantry
                        model = 0
			}
			}

     	navalunit = {
	name = "Armada de Eduador"
        id = { type = 29000 id = 1 }
	location = 815
	base = 815
		
		division = { 
		id = { type = 29000 id = 2 } 
		name = "1a Escuadron de Fragatas"	
		type = destroyer 
		model = 0 
		}
		}
	landunit = { 
	
	id = { type = 29000 id = 3 }
	name = "Reserva del Ejército"
	location = 815 # 

		division = {
		locked = yes
		id = { type = 29000 id = 4 }
		name = "Guardia Presidencial"
		strength = 100
		type = infantry
		extra = engineer
		}
		}
} 