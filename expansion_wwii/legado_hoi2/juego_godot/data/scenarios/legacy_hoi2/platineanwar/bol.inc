# Bolivia
country = {
    tag = BOL

	ai = "platineanwar_BOL.ai"

	headofstate = { type = 9 id = 43045 }
	headofgovernment = { type = 9 id = 43062 }
 	foreignminister = { type = 9 id = 43078 }
 	armamentminister = { type = 9 id = 43108 }
 	ministerofsecurity = { type = 9 id = 43135 }
 	ministerofintelligence = { type = 9 id = 43157 }
 	chiefofstaff = { type = 9 id = 43173 }
 	chiefofarmy = { type = 9 id = 43187 }
 	chiefofnavy = { type = 9 id = 43201 }        
 	chiefofair = { type = 9 id = 43215 }

    policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 2
        political_left = 5
        free_market = 8
        freedom = 7
        professional_army = 7
        defense_lobby = 8
        interventionism = 5
    }

	manpower = 25
	# Resource Reserves
	energy		=	1500   
	metal		=	1500	
	rare_materials 		=	1000	
	oil 		=	100	
	supplies 	=	100
	money = 100

	free = 		{
		oil 	=	6
		supplies =	20
	}

	capital = 832

diplomacy = {
	relation = { tag = ARG value = 20 }
	relation = { tag = BRA value = 10 }
	}

    ownedprovinces =      {
		836 833 838 832 828 827
	}
    controlledprovinces = {
		836 833 838 832 828 827
	}
    nationalprovinces =   {
		836 833 838 832 828 827 837 822
# Claim on Chaco
		839
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
		id = { type = 10015 id = 1 }
		name = "Ejercito de Bolivia"
		location = 832

			division = {
			id = { type = 10015 id = 2 }
			name = "1. Brigada de Infantería 'Bolivar'"
			strength = 100
			type = infantry
			model = 1
			extra = artillery
			}

			division = {
			id = { type = 10015 id = 3 }
			name = "1. Brigada de Milicia de Bolivia"
			strength = 100
			type = militia
                        extra = anti_air
			}
		
			division = {
			id = { type = 10015 id = 4 }
			name = "2. Brigada de Milicia de Bolivia"
			strength = 100
			type = militia
			}
			
			division = {
			id = { type = 10015 id = 5 }
			name = "1. Brigada de Caballería 'Chaco'"
			strength = 100
			type = cavalry
			model = 1
			}
			}
	landunit = { 
	id = { type = 10015 id = 6 }
	name = "Reserva del Ejército"
	location = 832 # 

		division = {
			locked = yes
		id = { type = 10015 id = 7 }
		name = "Guardia Presidencial"
		strength = 100
		type = infantry
		extra = engineer
		}
		}
} 