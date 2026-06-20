
# anti air
province = { id = 844   anti_air = 1 } #Corrientes
province = { id = 851   anti_air = 1 } #Santa Fe


province = { 
	id = 845 
	anti_air = 2
	air_base = { 
		size = 3 
		current_size = 3 
		} 	
	} 

#Buenos Aires
province = {
	id = 667
	anti_air = 3
	naval_base = {
		size = 5
		current_size = 5
	}
	air_base = {
		size = 3
		current_size = 3
	}	
	}

#Bahia Blanca
province = { 
	id = 853 
	anti_air = 2
	naval_base = {
		size = 8
		current_size = 8
	}
	air_base = { 
		size = 3 
		current_size = 3 
		} 	
	} 


province = {
	id = 852
	anti_air = 3
	naval_base = {
		size = 7
		current_size = 7
	}
	air_base = {
		size = 2
		current_size = 2
	}	
	}

province = {
	id = 863
	anti_air = 3
	naval_base = {
		size = 2
		current_size = 2
	}
	air_base = {
		size = 2
		current_size = 2
	}	
	}




country = {
    tag = ARG

	ai = "platineanwar_ARG.ai"

	headofstate = { type = 9 id = 35033 }
	headofgovernment = { type = 9 id = 35047 }
 	foreignminister = { type = 9 id = 35061 }
 	armamentminister = { type = 9 id = 35086 }
 	ministerofsecurity = { type = 9 id = 35113 }
 	ministerofintelligence = { type = 9 id = 35136 }
 	chiefofstaff = { type = 9 id = 35157 }
 	chiefofarmy = { type = 9 id = 35178 }
 	chiefofnavy = { type = 9 id = 35201 }        
 	chiefofair = { type = 9 id = 35208 }

    policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 5
        political_left = 3
        free_market = 8
        freedom = 6
        professional_army = 6
        defense_lobby = 7
        interventionism = 3
    }


	manpower = 60
	# Resource Reserves
	
	energy		= 3500
	metal		= 3500	
	rare_materials  = 2500
	oil 		= 500
	supplies	= 500
	money 		= 100
	manpower 	= 40

	free =	{
		oil 	=	12
		supplies =	45
		}

	capital = 667

	diplomacy = {
	relation = { tag = BOL value = 20 }
	relation = { tag = BRA value = -10 }
	relation = { tag = CHL value = -20 }
	relation = { tag = ECU value = 10 }
	relation = { tag = PAR value = 20 }
	relation = { tag = PRU value = 20 }
	relation = { tag = URU value = -25 }
	}

    ownedprovinces =      {
		667 853 852 843 844 845 851 854 855 857 858 859 862 863 865 850
	}
    controlledprovinces = {
		667 853 852 843 844 845 851 854 855 857 858 859 862 863 865 850
	}
    nationalprovinces =   {
		667 853 852 843 844 845 851 854 855 857 858 859 862 863 865 850
	}

	techapps = {
# Group C 1941 techs
#######################

5070

1120 4190 3410 3090

4010 4020 4030 # Basic Fighter

4040 # Basic MR Fighter

4120 4130 4140 # Basic medium bomber

2010 2020 2030 2040 2050 # Improved light tank

2150 # Basic Armoured Car

2290 2300 2310 2320 2330 # up to the WW II basic artillery

2400 2410 # Basic AT

2450 2460 2470 # Basic Static AA

2510 2520 # Imp. AA

1010 1020 1030 # Basic infantry

1190 1200 1210 1220 # Semi-moto cavalry

1110 # Early Mountain

2330 # Basic motorized

9010 9020 9030 # Force substitution doctrine

5010 5020 # Mechanized Agriculture

5050 # Basic Machine Tools

5080 5090 5100 # Construction (up to the forts)

5110 # Supplies

5190 5200 # Imp. oil conversion

5470 # Nuclear Tier 4



6010 6020 6040 # Superior Firepower, Delay

3010 3020
3070 3080
3130 3140
3250
3400

8010 8020 8040 8050
#hospital
14000
	}

#
#Argentina OOB
#
	landunit = {
	id = { type = 10001 id = 1 }
	name = "I Cuerpo del Ejército"
	location = 667 # Buenos Aires

		division = {
		id = { type = 10001 id = 2 }
		name = "III Brigada 'Pellegrini'"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}

		division = {
		id = { type = 10001 id = 3 }
		name = "II Brigada 'San Martín'"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}

		division = {
		id = { type = 10001 id = 4 }
		name = "I Brigada 'Ing. Krausse'"
		strength = 100
		type = infantry
		model = 1
		extra = engineer
		}

		division = {
		id = { type = 10001 id = 5 }
		name = "I Brigada Blindada 'Rodríguez'"
		strength = 100
		type = armor 
		model = 1	
		}
		}


	landunit = {
	id = { type = 10001 id = 6 }
	name = "II Cuerpo del Ejército"
	location = 845 # Córdoba

			division = {
			id = { type = 10001 id = 7 }
			name = "VI Brigada de Montaña 'Villegas'"
			strength = 100
			type = bergsjaeger
			model = 1
			}

			division = {
			id = { type = 10001 id = 8 }
			name = "IV Brigada de Infantería de Montaña"
			strength = 100
			type = bergsjaeger
			model = 1
			extra = anti_air
			}
			}

	landunit = {
	# were assigned to the north of the country
	id = { type = 10001 id = 9 }
	name = "Gendarmería Nacional"
	location = 844 # Corrientes
	
		division = {
		id = { type = 10001 id = 10 }
		name = "Agrupación IV GN 'Misiones'"
		strength = 100
		type = militia
		}

		division = {
		id = { type = 10001 id = 11 }
		name = "Agrupación VI GN 'Formosa'"
		strength = 100
		type = militia
		}
		}

	landunit = { 
	# were assigned to the south of the country
	id = { type = 10001 id = 12 }
	name = "III Cuerpo del Ejército"
	location = 863 # Santa Cruz

		division = {
		id = { type = 10001 id = 13 }
		name = "XIII Brigada de Infantería"
		strength = 100
		type = infantry
		extra = engineer
		}

		division = {
		id = { type = 10001 id = 14 }
		name = "I Brigada de Caballería"
		strength = 100
		type = cavalry
		model = 1
		}
		}

	landunit = { 
	id = { type = 10001 id = 21 }
	name = "Army Reserve"
	location = 667 # Buenos Aires

		division = {
			locked = yes
		id = { type = 10001 id = 22 }
		name = "Presidential Guard"
		strength = 100
		type = infantry
		extra = engineer
		}
		}

	airunit = {
	id = { type = 10001 id = 15 }
	name = "Aviación del Ejército"
	location = 667 # Buenos Aires
	base = 667 # Buenos Aires

		division = {
		id = { type = 10001 id = 16 }
		name = "Grupo Aéreo Nro. 1"
		strength = 75
		type = interceptor
		model = 1
		}
	
		division = {
		id = { type = 10001 id = 17 }
		name = "Fuerza Aeronaval Nro. 1"
		strength = 100
		type = naval_bomber
		model = 0
		}
		}

	airunit = {
	id = { type = 10001 id = 18 }
	name = "Aviación del Ejército"
	location = 845 # Córdoba
	base = 845 # Córdoba

		division = {
		id = { type = 10001 id = 19 }
		name = "Grupo Aéreo Nro. 2"
		strength = 50
		type = interceptor
		model = 1
		}

		division = { 
		id = { type = 10001 id = 20 } 
		name = "Transporte Aéreo" 
		strength = 100 
		type = transport_plane 
		model = 0 
		}
		}
	
	navalunit = {
	name = "Fuerza Naval Nº 1"
	id = { type = 10001 id = 100 }
	location = 853 # Bahía Blanca
	base = 853 # Bahía Blanca

		division = { 
		id = { type = 10001 id = 101 } 
		name = "ARA Veinticinco De Mayo" 
		type = heavy_cruiser 
		model = 2 
		seaattack = 9 
		}
	
		division = { 
		id = { type = 10001 id = 102 } 
		name = "ARA Almirante Brown" 
		type = heavy_cruiser 
		model = 2 
		seaattack = 9 
		} 

		division = { 
		id = { type = 10001 id = 103 } 
		name = "ARA Independencia" 
		type = battlecruiser
		model = 0 
		}

		division = { 
		id = { type = 10001 id = 104 } 
		name = "ARA General Belgrano" 
		type = light_cruiser 
		model = 0  
		}
		}
	
	navalunit = {
	name = "Fuerza Naval Nº 2"
	id = { type = 10001 id = 200 }
	location = 852 # Mar del Plata
	base = 852 # Mar del Plata

		division = { 
		id = { type = 10001 id = 201 } 
		name = "ARA Moreno" 
		type = battlecruiser
		model = 1 
		} 
		
		division = { 
		id = { type = 10001 id = 202 } 
		name = "ARA Rivadavia" 
		type = battlecruiser 
		model = 1 
		}
	
		division = { 
		id = { type = 10001 id = 203 } 
		name = "ARA General Pueyrredon" 
		type = light_cruiser 
		model = 0  
		}
	
		division = { 
		id = { type = 10001 id = 205 } 
		name = "ARA Mendoza/Rioja/Tucumán" 
		type = destroyer 
		model = 0 
		}

		division = { 
		id = { type = 30050 id = 206 } 
		name = "ARA D6/D8/D10" 
		type = destroyer 
		model = 1 
		} # DD
		}
		
	navalunit = {
	name = "Fuerza Naval Nº 3"
	id = { type = 10001 id = 300 }
	location = 667 # Buenos Aires
	base = 667 # Buenos Aires

		division = { 
		id = { type = 10001 id = 301 } 
		name = "ARA Libertad" 
		type = battlecruiser 
		model = 0 
		}

		division = { 
		id = { type = 10001 id = 302 } 
		name = "ARA Argentina" 
		type = light_cruiser 
		model = 1  
		} # CL '39

		division = { 
		id = { type = 10001 id = 303 } 
		name = "ARA Cervantes/Garay" 
		type = destroyer 
		model = 1 
		}
		
		division = { 
		id = { type = 10001 id = 304 } 
		name = "ARA S.Fe/Salta/S.del Estero" 
		type = submarine 
		model = 1
		}

		division = { 
		id = { type = 10001 id = 305 } 
		name = "ARA Cabo San Diego*" 
		type = transport 
		model = 0 
		}
		}

	navalunit = {
	name = "Fuerza Naval Nº 4"
	id = { type = 10001 id = 400 }
	location = 863 # Santa Cruz
	base = 863 # Santa Cruz

		division = { 
		id = { type = 10001 id = 401 } 
		name = "ARA D7/D9/D11" 
		type = destroyer 
		model = 1 
		} # DD
		}
}