#Amsterdam
province = {
	id = 47
	anti_air = 2
	naval_base = {
		size = 10
		current_size = 10
	}
	air_base = {
		size = 10
		current_size = 10
	}
}

province = { id = 49   anti_air = 2 } #Eindhoven

country = {
    tag = HOL

    policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 10
        political_left = 2
        free_market = 9
        freedom = 10
        professional_army = 5
        defense_lobby = 5
        interventionism = 6
    }

		headofstate = { type = 9 id = 8001 }
		headofgovernment = { type = 9 id = 8046 }
  		foreignminister = { type = 9 id = 8064 }
  		armamentminister = { type = 9 id = 8094 }
  		ministerofsecurity = { type = 9 id = 8112 }
  		ministerofintelligence = { type = 9 id = 8133 }
  		chiefofstaff = { type = 9 id = 8007 }
  		chiefofarmy = { type = 9 id = 8156 }
  		chiefofnavy = { type = 9 id = 8009 } 
  		chiefofair = { type = 9 id = 8010 }

	capital = 47
	manpower = 85

	# Resource Reserves
	oil 	=	40000
	supplies =	65000


        extra_tc = 65

	free = 		{
		oil 	=	10
		supplies =	100
	}


    ownedprovinces =      {
		#Homeland
		46 47 48 49 77 78 79

	}
    controlledprovinces = {
		#Homeland
		46 47 48 49 77 78 79

	}
    nationalprovinces =   {
		#Homeland
		46 47 48 49 77 78 79 
	}
	# Semi-Major Tech '36
	techapps = {
# Group C 1939 techs
#######################

4010 4020 # Early Fighter

4120 4130 # Early Bomber

2150 # Basic Armoured Car

2010 2020 2030 2040 # Basic light tank

2290 2300 2310 2320 # up to WWII early artillery

2400 # Basic AT

2450 2460 # Early Static AA

2510 # Basic AA

1010 1020 # Early infantry

1190 1200 # Early Cavalry

1110 # Early Mountain

9010 9020 # Flying Circus doctrine

5010 5020 # Mechanized Agriculture

5050 # Basic Machine Tools

5080 5090 5100 # Construction (up to the forts)

5110 # Supplies

5190 5200 # Imp. oil conversion

5470 # Nukes faculty




6010 6020 # Superior Firepower
4040
	}

	transports = 150
	escorts = 21

	landunit = {
	        id = { type = 18500 id = 1 }
			location = 47
			name = "1e Legerkorps"
			division = { id = { type = 18500 id = 2 } name = "1e Divisie"	type = infantry	experience = 30 extra = artillery }
			division = { id = { type = 18500 id = 3 } name = "2e Divisie"     type = infantry experience = 30 	}
	}
	landunit = {
	        id = { type = 18500 id = 4 }
			location = 77
			name = "2e Legerkorps"
			division = { id = { type = 18500 id = 5 } name = "3e Divisie"	type = infantry	experience = 30 extra = artillery }
			division = { id = { type = 18500 id = 6 } name = "4e Divisie"	type = infantry experience = 30 	}
	}
	landunit = {
	        id = { type = 18500 id = 7 }
			location = 49
			name = "3e Legerkorps"

			division = { id = { type = 18500 id = 8 } name = "5e Divisie"	type = infantry experience = 30 	extra = artillery }
			division = { id = { type = 18500 id = 9 } name = "6e Divisie"	type = infantry experience = 30 	}
	}
	landunit = {
	        id = { type = 18500 id = 10 }
			location = 79
			name = "4e Legerkorps"

			division = { id = { type = 18500 id = 11 } name = "7e Divisie"	type = infantry	experience = 30 extra = artillery }
			division = { id = { type = 18500 id = 12 } name = "8e Divisie"	type = infantry	experience = 30 }
	}


airunit = {
		location = 47
		base = 47
		name = "1e Luchtvloot"
        	id = { type = 18500 id = 13 } 

		division = {
        		id = { type = 18500 id = 14 } 
			type = multi_role
			model = 0
			strength  = 43
			max_strength  = 50
			name = "1e Jachtvliegtuig Groep"
                        experience = 30 
				}
}



}
