# Paraguay

country = {
    tag = PAR


	ai = "platineanwar_PAR.ai"

	# Resource Reserves
	energy	=	500  
	metal	=	500	
	rare_materials 	=	200	
	oil 	=	100	
	supplies =	100
	money =		100

	free = 		{
		oil 	=	6
		supplies =	20
	}	

	capital = 837
	manpower = 10

	headofstate = { type = 9 id = 42064 }
	headofgovernment = { type = 9 id = 42068 }
 	foreignminister = { type = 9 id = 42078 }
 	armamentminister = { type = 9 id = 42088 }
 	ministerofsecurity = { type = 9 id = 42094 }
 	ministerofintelligence = { type = 9 id = 42100 }
 	chiefofstaff = { type = 9 id = 42105 }
 	chiefofarmy = { type = 9 id = 42112 }
 	chiefofnavy = { type = 9 id = 42118 }        
 	chiefofair = { type = 9 id = 42122 }

	policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 4
        political_left = 4
        freedom = 3
        free_market = 5
        professional_army = 5
        defense_lobby = 8
        interventionism = 8
    }

diplomacy = {
	relation = { tag = ARG value = 20 }
	relation = { tag = BRA value = 10 }
	}

    ownedprovinces =      {
 		837 846
	}
    controlledprovinces = {
 		837 846
	}
    nationalprovinces =   {
 		837 846
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
		id = { type = 10016 id = 1 }
		name = "Ejercito de Paraguay"
		location = 837
		
			division = {
			id = { type = 10016 id = 2 }
			name = "I División de Infantería"
			strength = 100
			type = infantry
			model = 1
                        extra = anti_air
			}

			division = {
			id = { type = 10016 id = 3 }
			name = "CVI Brigada de Policia Nacional"
			strength = 100
			type = militia
			}
			}
	landunit = { 	
	id = { type = 10016 id = 4 }
	name = "Reserva del Ejército"
	location = 837 # 

		division = {
		locked = yes
		id = { type = 10016 id = 5 }
		name = "Guardia Presidencial"
		strength = 100
		type = infantry
		extra = engineer
		}
		}
}

