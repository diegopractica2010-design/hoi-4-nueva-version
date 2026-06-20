province = {
	id = 849
	anti_air = 1
	air_base = {
		size = 1
		current_size = 1
		}

	naval_base = {
		size = 6
		current_size = 6
		}
	}

country = {
    tag = URU

	ai = "platineanwar_URU.ai"

	headofstate = { type = 9 id = 41031 }
	headofgovernment = { type = 9 id = 41037 }
 	foreignminister = { type = 9 id = 41043 }
 	armamentminister = { type = 9 id = 41054 }
 	ministerofsecurity = { type = 9 id = 41061 }
 	ministerofintelligence = { type = 9 id = 41070 }
 	chiefofstaff = { type = 9 id = 41007 }
 	chiefofarmy = { type = 9 id = 41081 }
 	chiefofnavy = { type = 9 id = 41009 }        
 	chiefofair = { type = 9 id = 41093 }

	# Resource Reserves
	oil		= 100
	metal		= 500
	energy		= 500
	rare_materials		= 500
        supplies 	= 100
	money 		= 100


	free = 		{
		oil 	=	6
		supplies =	20
	}

	policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 4
        political_left = 5
        freedom = 5
        free_market = 5
        professional_army = 2
        defense_lobby = 4
        interventionism = 1
    }

	capital = 849
	manpower = 20

diplomacy = {
	relation = { tag = ARG value = -25 }
	relation = { tag = BRA value = 50 }
	}

    ownedprovinces =      {
		849
	}
    controlledprovinces = {
		849
	}
    nationalprovinces =   {
		849
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

5470 # Nuclear Tier 4

6010 6020 # Superior Firepower
 
#hospital
14000
	}

	landunit = {
	id = { type = 13700 id = 40 }
	name = "Ejercito de Uruguay"
	location = 849
		
		division = {
		id = { type = 13700 id = 4000 }
		name = "4a Brigada de Inf. 'Don Claudio'"
		strength = 100
		type = infantry
		model = 0
		extra = artillery
		}
		}

	navalunit = {
		id = { type = 13700 id = 20 }
		name = "Armada de Uruguay"
		location = 849
		base = 849

		# Build date unknown, but definitely prior to 1936.
		division = { id = { type = 13700 id = 2000 } name = "ARO Uruguay" type = heavy_cruiser model = 0 seaattack = 4 }
	}
	landunit = { 	
	id = { type = 13700 id = 41 }
	name = "Reserva del Ejército"
	location = 849 # 

		division = {
		locked = yes
		id = { type = 13700 id = 42 }
		name = "Guardia Presidencial"
		strength = 100
		type = infantry
		extra = engineer
		}
		}
}
