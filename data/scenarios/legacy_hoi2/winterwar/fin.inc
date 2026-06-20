#NOTES FINNISH OOB
#1) It seems Finnish Divs was renamed in early Jan 1940. We use the elder naming convention.
#2) All Finnish Divs are overstrengthed to simulate both the vast numbers of seperate battalions and the SISSU doctrine.
#3) In reality the Finnish Divs had Divisional Artillery, but they have been removed to simulate both Soviet superiority in number of barrels and the advantage in ammunition.
#4) All Finnish infantry has been changed into bergsjaeger to simulate superiority in hills and especially Snow.
#5) Finnish Reinforcements and Replacements has been estimated to about 100k men. Split 50% regulars (manpower), 30% reserves (militia units), and 20% bottom-of-the-barrels (garrison units)



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

	ai = "winterwar_fin.ai"
    policy = {
        date = { year = 1939 month = november day = 29 }
        democratic = 9
        political_left = 1
        free_market = 9
        freedom = 7
        professional_army = 5
        defense_lobby = 9
        interventionism = 4
    }

		headofstate = { type = 9 id = 29043 }
		headofgovernment = { type = 9 id = 29058 }
  		foreignminister = { type = 9 id = 29068 }
  		armamentminister = { type = 9 id = 29093 }
  		ministerofsecurity = { type = 9 id = 29102 }
  		ministerofintelligence = { type = 9 id = 29126 }
  		chiefofstaff = { type = 9 id = 29136 }
  		chiefofarmy = { type = 9 id = 29144 }
  		chiefofnavy = { type = 9 id = 29148 } 
  		chiefofair = { type = 9 id = 29155 }

	# Resource Reserves
	# will not be used in this scenario

	capital = 142
	manpower = 10		#replacements added through events
	supplies = 1000
	oil = 500
	extra_tc = 25


	free = 		{
		oil 	=	1
		supplies =	30
		ic = 12
	}


    ownedprovinces =      {
	103 141 142 140 143 138 139 137 131 130 132 136 148 147 144 145 146 149
	 }
    controlledprovinces = {
	103 141 142 140 143 138 139 137 131 130 132 136 148 147 144 145 146 149
	  }
    nationalprovinces =   {
	103 141 142 140 143 138 139 137 131 130 132 136 148 147 144 145 146 149
	}

# Western Minor Tech '36
techapps = {
# Group C 1939 techs
#######################

4010 4020 # Early Fighter

4120 4130 # Early Bomber

2150 # Basic Armoured Car

2010 2020 2030 2040 # Basic light tank

2290 2300 2310 2320 # up to WWII early artillery

2330 2400 # Basic AT

2450 2460 # Early Static AA

2510 # Basic AA

1010 1020 1030 # Basic infantry

1190 1200 # Early Cavalry

1110 1120 # Basic Mountain

1310 # Rear area supply dumps so industry can afford needed OOB

9010 9020 # Flying Circus doctrine
9030

5010 # Agriculture 
5050 #Basic Machine Tools
5080 5090 5100 # Construction (up to the forts)
5190 5200 # Imp. oil conversion

6010 6030 6120 # Trench War

6130 #Pre-planned defence (Winter War speciality)

3010
3130
3400 3410

8020 8040 8050
#hospital
14000 14010

}

	landunit = {
		location = 103 # Åland
	#	leader = X #Os.Hanell
		name = "Åland Group"
		id = { type = 30038 id = 1 }
		dig_in = 10

		division = {
			id = { type = 30038 id = 2 }
			type = bergsjaeger
			model = 1
			name = "22. Inf Reg	"
			strength = 35
			max_strength = 40
		}
	}
	####################
	#   Ishtmus Army   #
	####################
	landunit = {
		location = 145 # Mannerheim Line
		leader = 9756 #LtG H.Österman
		name = "Ishtmus Army"
		id = { type = 30038 id = 3 }
		dig_in = 10

		division = {
			id = { type = 30038 id = 4 }
			type = hq
			strength = 30
			max_strength = 30
			name = "HQ Ishtmus Army"
			extra = artillery
			brigade_model = 1
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		leader = 9720 #MjG T.Laatikainen
		name = "1. Inf Div"
		id = { type = 30038 id = 5 }
		dig_in = 10

		division = {
			id = { type = 30038 id = 6 }
			type = bergsjaeger
			model = 1
			name = "1. Reserve Brigade"
			strength = 30
			max_strength = 40
		}
		division = {
			id = { type = 30038 id = 7 }
			type = bergsjaeger
			model = 1
			name = "2. Reserve Brigade"
			strength = 30
			max_strength = 40
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		leader = 9755 #LtG H.Öhquist
		name = "II Corps"
		id = { type = 30038 id = 8 }
		dig_in = 10

		division = {
			id = { type = 30038 id = 9 }
			type = hq
			strength = 30
			max_strength = 30
			name = "HQ II Corps"
			extra = artillery
			brigade_model = 1
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		name = "4. Inf Div"					#subunit of II Corps
		leader = 9702 #Col. Johan Arajuuri (not verified)
		id = { type = 30038 id = 10 }
		dig_in = 10

		division = {
			id = { type = 30038 id = 11 }
			type = bergsjaeger
			model = 1
			name = "10. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 12 }
			type = bergsjaeger
			model = 1
			name = "11. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 13 }
			type = bergsjaeger
			model = 1
			name = "12. Inf Reg"
			strength = 35
			max_strength = 40
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		name = "5. Inf Div"					#subunit of II Corps
		leader = 9716 #Selim Isaksson (not verified)
		id = { type = 30038 id = 14 }
		dig_in = 10

		division = {
			id = { type = 30038 id = 15 }
			type = bergsjaeger
			model = 1
			name = "13. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 16 }
			type = bergsjaeger
			model = 1
			name = "14. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 17 }
			type = bergsjaeger
			model = 1
			name = "15. Inf Reg"
			strength = 35
			max_strength = 40
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		name = "11. Inf Div"				#subunit of II Corps
		id = { type = 30038 id = 18 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 19 }
			type = bergsjaeger
			model = 1
			name = "31. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 20 }
			type = bergsjaeger
			model = 1
			name = "32. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 21 }
			type = bergsjaeger
			model = 1
			name = "33. Inf Reg"
			strength = 35
			max_strength = 40
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		name = "U-Group"					#subunit of II Corps
		leader = 9733 #MjG G.Palmroth
		id = { type = 30038 id = 22 }

		division = {
			id = { type = 30038 id = 23 }
			type = cavalry
			model = 1
			name = "Uusimaa Dragoon Reg"
			strength = 30
			max_strength = 35
		}

		division = {
			id = { type = 30038 id = 24 }
			type = cavalry
			model = 1
			name = "Häme Cavalry Reg"
			strength = 30
			max_strength = 35
		}
		division = {
			id = { type = 30038 id = 25 }
			type = bergsjaeger
			model = 1
			name = "Er.P 3./Er.P 7./JP 1."
			strength = 35
			max_strength = 40
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		name = "M-Group"					#subunit of II Corps
		id = { type = 30038 id = 26 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 27 }
			type = bergsjaeger
			model = 1
			name = "Er.P 1./Er.P 4./JP 3."
			strength = 35
			max_strength = 40
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		name = "L-Group"					#subunit of II Corps
		id = { type = 30038 id = 28 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 29 }
			type = bergsjaeger
			model = 1
			name = "Er.P 2./Er.P 5./JP 2."
			strength = 35
			max_strength = 40
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		leader = 9710 #MjG A.E.Heinrichs
		name = "III Corps"
		id = { type = 30038 id = 30 }
		dig_in = 10

		division = {
			id = { type = 30038 id = 31 }
			type = hq
			strength = 30
			max_strength = 30
			name = "HQ III Corps"
			extra = artillery
			brigade_model = 1
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		name = "8. Inf Div"					#subunit of III Corps
		id = { type = 30038 id = 32 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 33 }
			type = bergsjaeger
			model = 1
			name = "23. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 34 }
			type = bergsjaeger
			model = 1
			name = "24. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 35 }
			type = bergsjaeger
			model = 1
			name = "26. Inf Reg"
			strength = 35
			max_strength = 40
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		name = "10. Inf Div"				#subunit of III Corps
	#	leader = X # Col. Viljo Kauppila
		id = { type = 30038 id = 36 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 37 }
			type = bergsjaeger
			model = 1
			name = "28. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 38 }
			type = bergsjaeger
			model = 1
			name = "29. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 39 }
			type = bergsjaeger
			model = 1
			name = "30. Inf Reg"
			strength = 35
			max_strength = 40
		}
	}
	landunit = {
		location = 145 # Mannerheim Line
		name = "R-Group"					#subunit of III Corps
		id = { type = 30038 id = 40 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 41 }
			type = bergsjaeger
			model = 1
			name = "Er.P 6./M-Os/JP 4."
			strength = 35
			max_strength = 40
		}
	}
	#######################
	#  Commander in Chief #
	#######################
	landunit = {
		location = 144 # Mikkeli
		leader = 9750 #Gen G.Mannerheim
		name = "CiC Reserves"
		id = { type = 30038 id = 42 }
		dig_in = 10

		division = {
			id = { type = 30038 id = 43 }
			type = hq
			strength = 30
			max_strength = 30
			name = "Supreme HQ"
			extra = artillery
			brigade_model = 1
		}
	}
	landunit = {
		location = 144 # Mikkeli
		name = "6. Inf Div"
		leader = 9731 #Col. P.Paalu
		id = { type = 30038 id = 44 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 45 }
			type = bergsjaeger
			model = 1
			name = "16. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 46 }
			type = bergsjaeger
			model = 1
			name = "17. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 47 }
			type = bergsjaeger
			model = 1
			name = "18. Inf Reg"
			strength = 35
			max_strength = 40
		}
	}
	landunit = {
		location = 144 # Mikkeli
		leader = 9739 # Col. Hjalmar Siilasvuo	(not verified) in reality = C of 27.infreg
		name = "9. Inf Div"
		id = { type = 30038 id = 48 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 49 }
			type = bergsjaeger
			model = 1
			name = "25. Inf Reg"
			strength = 35
			max_strength = 40
		}

		division = {
			id = { type = 30038 id = 50 }
			type = bergsjaeger
			model = 1
			name = "27. Inf Reg"
			strength = 35
			max_strength = 40
		}
	}
	landunit = {
		location = 144 # Mikkeli
		name = "KT-Pr Replacement Brigade"
		id = { type = 30038 id = 51 }

		division = {
			locked = yes
			id = { type = 30038 id = 52 }
			type = garrison
			name = "KT-Pr Replacement Brigade"
			strength = 30
			max_strength = 30
		}
	}
	#########################
	#    Karelian Corps		#
	#########################
	landunit = {

		location = 146 # Sortavala
		leader = 9714 #MjG J.Hägglund
		name = "IV Corps"
		id = { type = 30038 id = 53 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 54 }
			type = hq
			strength = 30
			max_strength = 30
			name = "IV Corps HQ"
			extra = artillery
			brigade_model = 1

		}
	}
	landunit = {

		location = 146 # Sortavala
		name = "12. Inf Div"			#subunit of IV Corps
	#	leader = X #Col.  Lauri Tiainen (later Antero Svensson)
		id = { type = 30038 id = 55 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 56 }
			type = bergsjaeger
			model = 1
			name = "34. Inf Reg"
			strength = 35
			max_strength = 40
		}
		division = {
			id = { type = 30038 id = 57 }
			type = bergsjaeger
			model = 1
			name = "35. Inf Reg"
			strength = 35
			max_strength = 40
		}
		division = {
			id = { type = 30038 id = 58 }
			type = bergsjaeger
			model = 1
			name = "36. Inf Reg"
			strength = 35
			max_strength = 40
		}
	}
	landunit = {

		location = 146 # Sortavala
		name = "TF Räsänen"			#subunit of IV Corps
		id = { type = 30038 id = 59 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 60 }
			type = bergsjaeger
			model = 1
			name = "TF Räsänen"
			strength = 35
			max_strength = 40
		}
	}

	landunit = {
		location = 149 # Joensuu
		name = "13. Inf Div"			#subunit of IV Corps
		leader = 9709 # Col. H.Hannuksela
		id = { type = 30038 id = 61 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 62 }
			type = bergsjaeger
			model = 1
			name = "37. Inf Reg"
			strength = 35
			max_strength = 40
		}
		division = {
			id = { type = 30038 id = 63 }
			type = bergsjaeger
			model = 1
			name = "38. Inf Reg"
			strength = 35
			max_strength = 40
		}
		division = {
			id = { type = 30038 id = 64 }
			type = bergsjaeger
			model = 1
			name = "39. Inf Reg"
			strength = 35
			max_strength = 40
		}
	}
	#########################
	#        P-SR		    #
	#########################
	landunit = {
		location = 136 # Kajaani
		leader = 9746 #MjG V.Tuompo
		name = "P-SR"
		id = { type = 30038 id = 65 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 66 }
			type = hq
			name = "P-SR HQ"
			strength = 30
			max_strength = 30
			extra = artillery
			brigade_model = 1
		}

		division = {
			id = { type = 30038 id = 67 }
			type = bergsjaeger
			model = 1
			name = "12./13./14. Er.P"
			strength = 35
			max_strength = 40
		}
		division = {
			id = { type = 30038 id = 68 }
			type = bergsjaeger
			model = 1
			name = "15./16. Er.P"
			strength = 25
			max_strength = 35
		}
	}
	landunit = {
		location = 130 # Petsamo
		name = "LR"
		id = { type = 30038 id = 69 }
		dig_in = 5

		division = {
			id = { type = 30038 id = 70 }
			type = bergsjaeger
			model = 1
			name = "17./25./26. Er.P"
			strength = 15				#25.& 26. has not yet arrived
			max_strength = 40
		}
	}
	##################################
	landunit = {
		location = 142 # Helsinki
		name = "21. Replacement Div"
		id = { type = 30038 id = 71 }

		division = {
			id = { type = 30038 id = 72 }
			locked = yes
			type = garrison
			name = "61. Replacement Reg"
			strength = 30
			max_strength = 30
		}
		division = {
			id = { type = 30038 id = 73 }
			locked = yes
			type = garrison
			name = "62. Replacement Reg"
			strength = 30
			max_strength = 30
		}
		division = {
			id = { type = 30038 id = 74 }
			locked = yes
			type = garrison
			name = "63. Replacement Reg"
			strength = 30
			max_strength = 30
		}
	}
	##################################
	landunit = {
		location = 141 # Turku
		name = "23. Replacement Div"
		leader = 9730 #Col. Woldemar Oinonen
		id = { type = 30038 id = 75 }

		division = {
			id = { type = 30038 id = 76 }
			locked = yes
			type = garrison
			name = "67. Replacement Reg"
			strength = 30
			max_strength = 30
		}
		division = {
			id = { type = 30038 id = 77 }
			locked = yes
			type = garrison
			name = "68. Replacement Reg"
			strength = 30
			max_strength = 30
		}
		division = {
			id = { type = 30038 id = 78 }
			locked = yes
			type = garrison
			name = "69. Replacement Reg"
			strength = 30
			max_strength = 30
		}
	}

#####################################################
	navalunit = {
		id = { type = 30038 id = 79 }
		name = "Suomen Merivoimat"
		leader = 9760 #Horala
		location = 141 #Turku

		division = {
			id = { type = 30038 id = 80 }
			name = "Ilmarinen"
			type = battlecruiser
			model = 0
		}
		division = {
			id = { type = 30038 id = 81 }
			name = "Väinämöinen"
			type = battlecruiser
			model = 0
		}
		division = {
			id = { type = 30038 id = 82 }
			name = "1. Sukellusvenelaivue"
			type = submarine
			strength = 100
			model = 1
		}
		division = {
			id = { type = 30038 id = 83 }
			name = "1. Rannikkolaivue"
			type = destroyer
			model = 1
			strength = 100
		}
		division = {
			id = { type = 30038 id = 84 }
			name = "2. Rannikkolaivue"
			type = destroyer
			model = 1
			strength = 100
		}
	}

#####################################################
	airunit = {
		id = { type = 30038 id = 85 }
		name = "Southern Air Command"
		leader = 9773 #Lundqvist
		location = 143 #Tampere

		division = {
			id = { type = 30038 id = 86 }
			name = "1. Fighter"
			type = interceptor
			model = 1
			strength = 20
		}
		division = {
			id = { type = 30038 id = 87 }
			name = "1. Bomber"
			type = tactical_bomber
			model = 0
			strength = 15
		}
	}
	airunit = {
		id = { type = 30038 id = 88 }
		name = "Northern Air Command"
		leader = 9777 #Sarko
		location = 137 #Oulo

		division = {
		id = { type = 30038 id = 89 }
		name = "2. Fighter"
		type = interceptor
		model =  0
		strength = 6
		}
		division = {
			id = { type = 30038 id = 90 }
			name = "2. Bomber"
			type = tactical_bomber
			model = 0
			strength = 2
		}
	}
##############################
# Army Reinforcements ########
##############################
#1st DEC 1939


	landdivision = {
		dormant = yes
		id = { type = 30038 id = 91 }
		type = bergsjaeger
		model = 1
		name = "40. Inf Reg"		#Belong to 9. Div
		strength = 35
		max_strength = 40
	}

#19th DEC 1939

	landdivision = {
		dormant = yes
		id = { type = 30038 id = 92 }
		type = bergsjaeger
		model = 1
		name = "61. Inf Reg"		#Belong to 21. Div
		strength = 15
		max_strength = 40
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 93 }
		type = bergsjaeger
		model = 1
		name = "62. Inf Reg"		#Belong to 21. Div
		strength = 15
		max_strength = 40
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 99 }
		type = bergsjaeger
		model = 1
		name = "63. Inf Reg"		#Belong to 21. Div
		strength = 15
		max_strength = 40
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 100 }
		type = bergsjaeger
		model = 1
		name = "67. Inf Reg"		#Belong to 23. Div
		strength = 15
		max_strength = 40
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 101 }
		type = bergsjaeger
		model = 1
		name = "68. Inf Reg"		#Belong to 23. Div
		strength = 15
		max_strength = 40
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 102 }
		type = bergsjaeger
		model = 1
		name = "69. Inf Reg"		#Belong to 23. Div
		strength = 15
		max_strength = 40
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 127 }
		type = bergsjaeger
		model = 1
		name = "KT-Pr Inf Brig."
		strength = 15
		max_strength = 40
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 103 }
		type = bergsjaeger
		model = 1
		name = "1. Reg/SVK"		#Belong to Swedish Volunteer Corps
		strength = 30
		max_strength = 40
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 104 }
		type = bergsjaeger
		model = 1
		name = "2. Reg/SVK"		#Belong to Swedish Volunteer Corps
		strength = 30
		max_strength = 40
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 105 }
		type = bergsjaeger
		model = 1
		name = "3. Reg/SVK"		#Belong to Swedish Volunteer Corps
		strength = 30
		max_strength = 40
	}
##############################
# Home Guards Reinforcements #
##############################


#JAN 1940

	landdivision = {
		dormant = yes
		id = { type = 30038 id = 106 }
		type = militia
		name = "1. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 107 }
		type = militia
		name = "2. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 108 }
		type = militia
		name = "3. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 109 }
		type = garrison
		name = "4. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 110 }
		type = garrison
		name = "5. Home Guard Reg"
		strength = 30
		max_strength = 30
	}


#FEB 1940

	landdivision = {
		dormant = yes
		id = { type = 30038 id = 111 }
		type = militia
		name = "6. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 112 }
		type = militia
		name = "7. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 113 }
		type = militia
		name = "8. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 114 }
		type = militia
		name = "9. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 115 }
		type = garrison
		name = "10. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 116 }
		type = garrison
		name = "11. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 117 }
		type = garrison
		name = "12. Home Guard Reg"
		strength = 30
		max_strength = 30
	}

#MARCH 1940

	landdivision = {
		dormant = yes
		id = { type = 30038 id = 118 }
		type = militia
		name = "13. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 119 }
		type = militia
		name = "14. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 120 }
		type = militia
		name = "15. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 121 }
		type = garrison
		name = "16. Home Guard Reg"
		strength = 30
		max_strength = 30
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 122 }
		type = garrison
		name = "17. Home Guard Reg"
		strength = 30
		max_strength = 30
	}

##############################
# Air Force Reinforcements ###
##############################


#1st DEC 1939

	airdivision = {
		dormant = yes
		id = { type = 30038 id = 123 }
		name = "Gloster Gladiator Squadron (Sw.)" 	#F19 Swedish Flying Corps
		type = interceptor
		model = 1
		strength = 12
	}

#15th FEB 1940

	airdivision = {
		dormant = yes
		id = { type = 30038 id = 124 }
		name = "Gloster Gladiator Squadron (Fin.)"
		type = interceptor
		model = 1
		strength = 15
	}


#15th MARCH 1940

	airdivision = {
		dormant = yes
		id = { type = 30038 id = 125 }
		name = "Saulnier Squadron"
		type = multi_role
		model = 1
		strength = 15
	}

	airdivision = {
		dormant = yes
		id = { type = 30038 id = 126 }
		name = "Hurricane Squadron"
		type = multi_role
		model = 1
		strength = 10
	}
##############################
# Allied Expeditionary Force #
##############################
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 128 }
		type = infantry
		name = "British Exp. Force"
	}
	landdivision = {
		dormant = yes
		id = { type = 30038 id = 129 }
		type = infantry
		name = "French Exp. Force"
	}
}