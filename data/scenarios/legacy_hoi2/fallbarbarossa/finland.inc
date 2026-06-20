#Mannerheim line
province = {	id = 145	landfort = 2 } #Viipuri
province = {	id = 145	anti_air = 3 }

#Coastal forts
province = {	id = 142	coastalfort = 1 }#Helsinki
province = {    id = 103    coastalfort = 1 }#Mariehamm

province = {
	id = 141 #Turku
	anti_air = 2
	naval_base = {
		size = 5
		current_size = 5
	}
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 142 #Helsinki
	anti_air = 3
	naval_base = {
		size = 5
		current_size = 5
	}
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 143 #Tampere
	anti_air = 2
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 137 #Oulu
	air_base = {
		size = 10
		current_size = 10
	}
}
country = {
	tag = FIN

ai = "fallbarbarossa_FIN.ai"
	
	policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 8
        political_left = 1
        free_market = 9
        freedom = 7
        professional_army = 5
        defense_lobby = 9
        interventionism = 4
    }

	headofstate = { type = 9 id = 29044 }
	headofgovernment = { type = 9 id = 29059 }
 	foreignminister = { type = 9 id = 29074 }
 	armamentminister = { type = 9 id = 29094 }
 	ministerofsecurity = { type = 9 id = 29107 }
 	ministerofintelligence = { type = 9 id = 29123 }
 	chiefofstaff = { type = 9 id = 29137 }
 	chiefofarmy = { type = 9 id = 29145 }
 	chiefofnavy = { type = 9 id = 29148 }        
 	chiefofair = { type = 9 id = 29153 }

	dormant_ministers = { 29001 29036 29002 29053 29003 29071 29072 29004 29092 29005 29007 29008 29043 29162 29054 29058 29160 29073 29068 29006 }

	# German exp. leaders
	steal_leader = 49 #Dietl
	steal_leader = 694 #Feige 


	# Resource Reserves
	oil		= 500
	supplies	= 900
	manpower = 27

	free = 		{
		oil 	=	2
		supplies =	42
	ic = 10
	}





        extra_tc = 3

	capital = 142

	ownedprovinces =      {
		103 130 131 132 136 137 138 139 140 141 142 143 144 147 148 149
	}
	controlledprovinces = {
		103 130 131 132 136 137 138 139 140 141 142 143 144 147 148 149
	}
	nationalprovinces =   {
		103 130 131 132 136 137 138 139 140 141 142 143 144 145 146 147 148 149
	}



	techapps               = { 5070  5320  1120  4010  4020  4030  4040  4120  4130  4140  2010  2020  2030  2040  2050  2150  2290  2300  2310  2320 
                             2330  2400  2410  2450  2460  2470  2510  2520  1010  1020  1030  1190  1200  1210  1220  1110  2330  9010  9020  9030 
                             5010  5020  5050  5080  5090  5100  5110  5190  5200  5470  5350  5360  6010  6030  6110  6120  6160  3010  3020  3070 
                             3080  3130  3190  3400  3410  4190  8020  8040  8050  1310  1320  9040  14000 14010 14020
                           }

	####FINLAND OOB####
	#######1941########
	###################

		landunit = {
		id = { type = 10020 id = 37 } 
		name = "17. Divisioona"
		location = 141

			division = {
			id = { type = 10020 id = 38 }
			name = "17. Divisioona"
			strength = 65
          	      	organisation = 0
			type = infantry	
			model = 2
			extra = anti_air
			brigade_model = 1
			}
			}

		landunit = {
		id = { type = 10020 id = 36 } 
		name = "14. Divisioona"
		location = 149

			division = {
			id = { type = 10020 id = 16 }
			name = "14. Divisioona"
			strength = 65
			type = infantry	
			model = 2
			}
			}

		landunit = {
		id = { type = 10020 id = 1 }
		name = "VI Armeijakunta"
		location = 149
		

			division = {
			id = { type = 10020 id = 2 }
			name = "5. Divisioona"
			strength = 65
			type = infantry
			model = 2
			}

			division = {
			id = { type = 10020 id = 3 }
			name = "11. Divisioona"
			strength = 65
			type = infantry
			model = 2
			}
			division = {
			id = { type = 10020 id = 7 }
			name = "1. Divisioona"
			strength = 65
			type = infantry
			model = 2
			}
			}

		landunit = {
		id = { type = 10020 id = 4 }
		name = "VII Armeijakunta"
		location = 149
		

			division = {
			id = { type = 10020 id = 5 }
			name = "7. Divisioona"
			strength = 100
			type = infantry
			model = 2
			extra = anti_tank
			}

			division = {
			id = { type = 10020 id = 6 }
			name = "19. Divisioona"
			strength = 75
			type = infantry
			model = 2
			}
			}
	
		landunit = {
		id = { type = 10020 id = 8 }
		name = "II Armeijakunta"
		location = 144
		leader = 9700

			division = {
			id = { type = 10020 id = 9 }
			name = "2. Divisioona"
			strength = 65
			type = infantry
			model = 2
			}

			division = {
			id = { type = 10020 id = 10 }
			name = "10. Divisioona"
			strength = 65
			type = infantry
			model = 2
			}

			division = {
			id = { type = 10020 id = 11 }
			name = "15. Divisioona"
			strength = 65
			type = infantry
			model = 2
			}

			division = {
			id = { type = 10020 id = 12 }
			name = "18. Divisioona"
			strength = 65
			type = infantry
			model = 2
			}
			}

		landunit = {
		id = { type = 10020 id = 13 }
		name = "III Armeijakunta"
		location = 136

			division = {
			id = { type = 10020 id = 14 }
			name = "3. Divisioona"
			strength = 65
			type = infantry
			model = 2
			}
			division = {
			id = { type = 10020 id = 35 } 
			name = "Divisioona J"
			strength = 65
			type = infantry
			model = 2
			}
			}

		landunit = {
		id = { type = 10020 id = 17 }
		name = "IV Armeijakunta"
		location = 142
		

			division = {
			id = { type = 10020 id = 18 }
			name = "4. Divisioona"
			strength = 65
			type = infantry
			model = 2
			}

			division = {
			id = { type = 10020 id = 19 }
			name = "8. Divisioona"
			strength = 65
			type = infantry
			model = 2
			}

			division = {
			id = { type = 10020 id = 20 }
			name = "12. Divisioona"
			strength = 65
			type = infantry
			model = 2
			}
			}



	navalunit = { 
	id = { type = 10020 id = 21 } 
	name = "Suomen Merivoimat" 
	location = 142 
	base = 142

		division = { 
 		id = { type = 10020 id = 22 } 
 		name = "Ilmarinen" 
 		type = heavy_cruiser 
 		model = 1
		}	 

		division = { 
 		id = { type = 10020 id = 23 } 
 		name = "Väinämöinen" 
 		type = heavy_cruiser 
 		model = 1
  		}

		division = {
 		id = { type = 10020 id = 24 }
 		name = "1. Sukellusvenelaivue"
 		type = submarine
 		strength = 100
 		model = 1
   		}

		division = { 
		id = { type = 10020 id = 25 } 
		name = "1. Rannikkolaivue" 
		type = destroyer 
		model = 1 
		strength = 100 
		}
 
		division = { 
		id = { type = 10020 id = 26 } 
		name = "2. Rannikkolaivue" 
		type = destroyer 
		model = 0 
		strength = 100 
		} 
		}


		airunit = {
		id = { type = 10020 id = 27 }
		name = "Suomen Ilmavoimat"
		location = 142
		base = 142
		

			division = {
			id = { type = 10020 id = 28 }
			name = "Suomen Ilmavoimat"
			strength = 65
			type = interceptor
			model = 2
			}
			}


		landunit = {
			control = GER
		id = { type = 10020 id = 29 }
		name = "Gebirgskorps Norwegen" # German expedition units, other possible name "Bergs AK"
		location = 132 # Petsamo
		leader = 49 # Dietl
		

			division = {
			id = { type = 10020 id = 30 }
			name = "2. Gebirgs-Division"
			type = bergsjaeger
			model = 1
			}

			division = {
			id = { type = 10020 id = 31 }
			name = "3. Gebirgs-Division"
			type = bergsjaeger
			model = 1
			}
			}


		landunit = {
			control = GER
		id = { type = 10020 id = 32 }
		name = "XXXVI Korps" # German expedition units
		location = 136
		leader = 694 # Feige
		
			division = {
			id = { type = 10020 id = 33 }
			name = "169. Infanterie-Division"
			type = infantry
			model = 3
			}

			division = {
			id = { type = 10020 id = 34 }
			name = "SS-Division Nord "
			type = motorized
			model = 2
			}

			division = { #Finnish unit subordinated to german expeditionary force
			id = { type = 10020 id = 15 }
			name = "6. Divisioona"
			strength = 75
			type = infantry
			model = 2
			}

}

		landunit = {
		id = { type = 10020 id = 39 } 
		name = "Finnish Army"
		location = 144

			division = {
			id = { type = 10020 id = 40 }
			name = "Finnish Army HQ"
			strength = 100
			type = hq	
			model = 1
			extra = artillery
			brigade_model = 4
			}
			}

}
#Id's 1 to 40 used.