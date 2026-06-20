province = {
	id = 830
	anti_air = 2
	air_base = {
		size = 4
		current_size = 4
		}

	naval_base = {
		size = 6
		current_size = 6
		}
	}

country = {
    tag = PRU

	ai = "platineanwar_PRU.ai"

	headofstate = { type = 9 id = 39032 }
	headofgovernment = { type = 9 id = 39039 }
 	foreignminister = { type = 9 id = 39051 }
 	armamentminister = { type = 9 id = 39065 }
 	ministerofsecurity = { type = 9 id = 39081 }
 	ministerofintelligence = { type = 9 id = 39091 }
 	chiefofstaff = { type = 9 id = 39102 }
 	chiefofarmy = { type = 9 id = 39111 }
 	chiefofnavy = { type = 9 id = 39121 }        
 	chiefofair = { type = 9 id = 39129 }

	# Resource Reserves
	
energy		= 500
metal		= 500
rare_materials 		= 200	
oil 		= 500	
supplies 	= 100
money 		= 100

	free = 		{
		oil 	=	6
		supplies =	20
	}

	capital = 830
	manpower = 25

	policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 6
        political_left = 5
        freedom = 4
        free_market = 4
        professional_army = 3
        defense_lobby = 5
        interventionism = 5
   	}

diplomacy = {
	relation = { tag = ARG value = 20 }
	relation = { tag = BRA value = 10 }
	}

    ownedprovinces =      {
		831 829 830 821 816
	}
    controlledprovinces = {
		831 829 830 821 816
	}
    nationalprovinces =   {
		831 829 830 821 816
#claims on Ecuador
		818
	}


	techapps = {
# Group D 1941 techs
#######################

3130 3410

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

3010
3070
3400
8020 8040 8050

# No Nuclear Research (Tier 5)

	}

	

		landunit = {
		id = { type = 17600 id = 1 }
		name = "Ejercito del Peru"
		location = 830

			division = {
			id = { type = 17600 id = 2 }
			name = "1a Div. de Inf. del Peru 'Bolognesi'"
			strength = 100
			type = infantry
			model = 1
                        extra = anti_air
			}

			division = {
			id = { type = 17600 id = 3 }
			name = "2a Div. de Infantería del Peru"
			strength = 100
			type = infantry
			model = 1
			}

			division = {
			id = { type = 17600 id = 4 }
			name = "3a Div. de Infantería del Peru"
			strength = 100
			type = infantry
			model = 1
			}
	
			division = {
			id = { type = 17600 id = 5 }
			name = "1a Brigada Fuerzas Especiales"
			strength = 100
			type = bergsjaeger
			model = 0	
			}
			}

	navalunit = {
	id = { type = 17600 id = 6 }
	name = "Marina del Guerra del Peru"
	location = 830
	base = 830
	
		# Two DDs:
		division = { id = { type = 17600 id = 7 } name = "Suliana é Flotilla" type = destroyer model = 0  }

		# Built 1907:
		division = { id = { type = 17600 id = 8 } name = "ARP Almirante Grau" type = heavy_cruiser model = 0  }
		division = { id = { type = 17600 id = 9 } name = "ARP Coronel Bolognesi" type = heavy_cruiser model = 0  }

		# Submarine division:
		division = { id = { type = 17600 id = 10 } name = "Tacna é Flotilla" type = submarine model = 1 }
		}
	landunit = { 
	
	id = { type = 17600 id = 11 }
	name = "Reserva del Ejército"
	location = 830 # 

		division = {
		locked = yes
		id = { type = 17600 id = 12 }
		name = "Guardia Presidencial"
		strength = 100
		type = infantry
		extra = engineer
		}
		}
} 