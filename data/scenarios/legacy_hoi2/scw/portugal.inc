province = { id = 335   anti_air = 1 } #Porto


province = { id = 336   #Lissabon
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
    tag = POR

	ai = "scw_por.ai"

    policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 2
        political_left = 4
        free_market = 5
        freedom = 4
        professional_army = 4
        defense_lobby = 5
        interventionism = 3
    }

	capital = 336

   	manpower = 70

	transports = 50
	escorts = 7

	# Resource Reserves
	energy	=	5000
	metal	=	5000
	rare_materials	 =	2000
	oil 	=	2000
	supplies =	2000
	money	=	500

    ownedprovinces =
	{
		335 336 337 344 345
	}
    controlledprovinces =
	{
		335 336 337 344 345
	}
    nationalprovinces =
	{
		335 336 337 344 345
	}
	techapps = {
		# Group C 1936 techs
#######################

4010 4020 # Early fighter

4120 # GW Bomber

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

5110 # Supplies

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
3410
	}
	
############################################################
	
}
