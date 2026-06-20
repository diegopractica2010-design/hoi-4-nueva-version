#################################
# Designed by Greven and Tracid #
#################################
province = {
	id = 45
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 50
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 51
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 54
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 64
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 65
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 70
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 72
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}


country = {
    tag = ALS

	ai = "ardennes_als.ai"

	diplomacy = {

			}

	manpower = 450

	# Resource Reserves (No Production or Trade in this scenario)
	oil =	1000
	supplies =	1000
	extra_tc = 400

	#Off-Map production...
	free = {
		oil = 50 #100
		supplies = 100 #200
		ic = 80
    }


	policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 10
        political_left = 7
        freedom = 10
        free_market = 10
        professional_army = 1
        defense_lobby = 5
        interventionism = 1
    }


	headofstate = { type = 9 id = 6001 }
	headofgovernment = { type = 9 id = 6046 }
	foreignminister = { type = 9 id = 6060 }
	armamentminister = { type = 9 id = 6082 }
	ministerofsecurity = { type = 9 id = 6005 }
	ministerofintelligence = { type = 9 id = 6128 }
	chiefofstaff = { type = 9 id = 6136 }
	chiefofarmy = { type = 9 id = 6144 }
	chiefofnavy = { type = 9 id = 6163 }
	chiefofair = { type = 9 id = 6167 }

	steal_leader = 60145 #Eisenhower
	steal_leader = 60128 #Devers
	steal_leader = 1224 #Montgomery
	steal_leader = 52013 #Crerar
	steal_leader = 52019 #Foulkes
	steal_leader = 52065 #Guy G. Simonds
	steal_leader = 1099 #Dempsey
	steal_leader = 1237 #O'Connor
	steal_leader = 1265 #Ritchie
	steal_leader = 1170 #Horrocks
	steal_leader = 60057 #Bradley
	steal_leader = 60331 #Simpson
	steal_leader = 60010 #Anderson, John
	steal_leader = 60109 #Corlett
	steal_leader = 60217 #Hodges
	steal_leader = 60172 #Gerow
	steal_leader = 60501 #Collins
	steal_leader = 60271 #Middleton
	steal_leader = 60311 #Ridgway, Matthew
	steal_leader = 60294 #Patton
	steal_leader = 60273 #Millikin, John
	steal_leader = 60108 #Cook, Gilbert
	steal_leader = 60563 #Walker, Walton
	steal_leader = 60291 #Patch
	steal_leader = 60574 #Milburn, Frank
	steal_leader = 60190 #Haislip, Wade
	steal_leader = 60352 #Truscott, Lucian
	steal_leader = 24114 #de Lattre de Tassigny
	steal_leader = 24087 #De Goislard de Monsabert
	steal_leader = 24011 #Béthouart
	steal_leader = 60458 #Reeves
	steal_leader = 60566 #Weyland
	steal_leader = 60371 #Williams
	steal_leader = 1437 #Embry
	steal_leader = 1422 #Broadhurst
	steal_leader = 60575 # Anderson S.
	steal_leader = 60576 # Wilhelm
	steal_leader = 60575 # Anderson S.E.
	steal_leader = 60241 # Lee
	steal_leader = 1265 # Ritchie
	steal_leader = 60323 # Schmidt
	steal_leader = 60301 # Prickett
	steal_leader = 1115 #Erskine
	steal_leader = 1426 # Cannon
	steal_leader = 1492 # Steele

	capital = 56 #Paris

    ownedprovinces =      {
		49 45 50 51 52 65 68 69 70 66 71 73 316 317 318 72 64 63 55 54 53 44 18
		41 42 56
	 }
    controlledprovinces = {
		49 45 50 51 52 65 68 69 70 66 71 73 316 317 318 72 64 63 55 54 53 44 18
		41 42 56
	  }
    nationalprovinces =   {
		49 45 50 51 52 65 68 69 70 66 71 73 316 317 318 72 64 63 55 54 53 44 18
		41 42 56
	  }

	techapps               = { 4010  4020  4030  4040  4050  4060  4070  4080  4090  4100  4110  4120  4130  4140  4150  4160  7030  4170  4280  4180 
                             4190  4200  4210  4220  4230  4240  4250  4260  2150  2160  2010  2020  2030  2040  2050  2060  2030  2070  2080  2090 
                             2100  2110  2170  2180  2190  2220  2230  2240  2260  2270  2290  2300  2310  2320  2330  2340  2350  2360  2370  2380 
                             2400  2410  2420  2430  2450  2460  2470  2480  2490  2510  2520  2530  1010  1020  1030  1040  1050  1190  1200  1210 
                             1220  1110  1120  1130  1040  1070  1080  1090  1230  1240  1250  1260  1270  1280  1310  1320  1330  1340  1350  1360 
                             5010  5020  5030  5050  5060  5070  5080  5090  5100  5110  5120  5130  5140  5150  5160  5180  5190  5200  5210  5220 
                             5230  5310  5320  5330  5340  5350  5360  5370  5380  5390  5400  5410  5420  5430  5440  5450  5470  5480  5490  5500 
                             5510  5520  5530  7140  5550  5560  5570  9010  9020  9030  9040  9050  9060  9070  9080  9090  9100  9110  9120  9130 
                             9140  9150  9160  9170  9180  9190  9200  9210  9220  9230  9240  9250  9260  9270  9280  9290  9300  9310  9320  9330 
                             9340  9350  9360  9370  9380  9390  9400  9410  9420  9430  9440  9450  9460  6010  6020  6040  6050  6060  6070  6080 
                             6090  1150  1160  1170  1180  8010  8020  8030  8040  8050  8060  8090  8100  8110  8130  8160  8170  8180  8230  8240 
                             8310  8320  8140  8250  8270  8350  3010  3020  3030  3040  3050  3070  3080  3090  3100  3110  3130  3140  3150  3160 
                             3170  3190  3200  3210  3220  3250  3260  3270  3280  3320  3330  3340  3350  3360  3400  3410  3420  3430  3370  3230 
                             2200  2540  3290  7280  7150  7160  5540  14000 14010 14020 14030
                           }
############################
#  ALLIED OOB    	   	   #
############################

landunit = {
	control = ENG
id = { type = 10178 id = 1 }
name = "21st Army Group"
leader = 1224 #Montgomery
location = 51 #NW Belgium

division = {
	locked = yes
id = { type = 10178 id = 2 }
name = "21st Army Group HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}
###
landunit = {
	control = CAN
id = { type = 10178 id = 3 }
name = "1st Canadian Army"
leader = 52013 #Crerar
location = 45 #Coast to Antwerp

division = {
id = { type = 10178 id = 4 }
name = "1st Canadian Army HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}

division = {
id = { type = 10178 id = 5 }
name = "1st Armored Brigade"
type = armor
strength = 50
max_strength = 50
model = 3 #
}
}
###
landunit = {
	control = CAN
id = { type = 10178 id = 6 }
name = "1st Corps"
leader = 52019 #Foulkes
location = 45 #Coast to Antwerp

division = {
id = { type = 10178 id = 8 }
name = "1st Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 9 }
name = "5th Armored Div"
type = armor
strength = 100
model = 3 #
}
}
###
landunit = {
	control = CAN
id = { type = 10178 id = 10 }
name = "2nd Corps"
leader = 52065 #Guy G. Simonds
location = 50 #Coast to Antwerp

division = {
id = { type = 10178 id = 12 }
name = "2nd Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 13 }
name = "3rd Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
####################################
landunit = {
	control = ENG
id = { type = 10178 id = 14 }
name = "2nd British Army"
leader = 1099 #Dempsey
location = 50 #Antwerp-Maastricht

division = {
id = { type = 10178 id = 15 }
name = "2nd British Army HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}
###
landunit = {
	control = ENG
id = { type = 10178 id = 16 }
name = "XII Corps"
leader = 1237 #O'Connor
location = 49 #Antwerp-Maastricht

division = {
id = { type = 10178 id = 18 }
name = "51st Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 19 }
name = "15th Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
###
landunit = {
	control = ENG
id = { type = 10178 id = 20 }
name = "XIII Corps"
leader = 1115 #Erskine 
location = 49 #Antwerp-Maastricht

division = {
id = { type = 10178 id = 22 }
name = "79th Infantry Div"
type = infantry
strength = 100
model = 4 #
extra = engineer
}

division = {
id = { type = 10178 id = 23 }
name = "31st Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
###
landunit = {
	control = ENG
id = { type = 10178 id = 24 }
name = "XXX Corps"
leader = 1170 #Horrocks
location = 51 #Lüttich

division = {
id = { type = 10178 id = 26 }
name = "43rd Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 27 }
name = "53rd Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 28 }
name = "UK Guards Tank Div"
type = armor
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 29 }
name = "29th Tank Brigade"
type = armor
strength = 50
max_strength = 50
model = 3 #
}
}
####################################
landunit = {
id = { type = 10178 id = 30 }
name = "12th Army Group"
leader = 60057 #Bradley
location = 70 #Maastricht to Strassburg

division = {
	locked = yes
id = { type = 10178 id = 31 }
name = "12th Army Group HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}
####################################
landunit = {
id = { type = 10178 id = 32 }
name = "9th US Army"
leader = 60331 #Simpson
location = 65 #Maastricht to Strassburg

division = {
id = { type = 10178 id = 33 }
name = "9th US Army HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}
###
landunit = {
id = { type = 10178 id = 34 }
name = "XVI Corps"
leader = 60241 #Lee
location = 60 #Maastricht to Strassburg

division = {
id = { type = 10178 id = 36 }
name = "102nd Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 37 }
name = "84th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 38 }
name = "7th Tank Div"
type = armor
strength = 100
model = 3 #
}
}
###
landunit = {
id = { type = 10178 id = 39 }
name = "XIX Corps"
leader = 60109 #Corlett
location = 66 #Maastricht to Strassburg

division = {
id = { type = 10178 id = 41 }
name = "30th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 42 }
name = "29th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 43 }
name = "2nd Tank Div"
type = armor
strength = 100
model = 3 #
}
}
####################################
landunit = {
id = { type = 10178 id = 44 }
name = "1st US Army"
leader = 60217 #Hodges
location = 68 #Maastricht to Strassburg

division = {
id = { type = 10178 id = 45 }
name = "1st US Army HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}
###
landunit = {
id = { type = 10178 id = 46 }
name = "V Corps"
leader = 60172 #Gerow
location = 68 #Maastricht to Strassburg

division = {
id = { type = 10178 id = 48 }
name = "8th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 49 }
name = "78th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 50 }
name = "2nd Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 51 }
name = "99th Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
###
landunit = {
id = { type = 10178 id = 52 }
name = "VII Corps"
#leader = 60501 #Collins  (he's air)
location = 69 #Maastricht to Strassburg

division = {
id = { type = 10178 id = 54 }
name = "3rd Tank Div"
type = armor
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 55 }
name = "9th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 56 }
name = "104th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 57 }
name = "1st Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 58 }
name = "83rd Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 59 }
name = "5th Tank Div"
type = armor
strength = 100
model = 3 #
}
}
###
landunit = {
id = { type = 10178 id = 60 }
name = "XIII Corps"
leader = 60271 #Middleton
location = 71 #Maastricht to Strassburg


division = {
id = { type = 10178 id = 62 }
name = "4th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 63 }
name = "28th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 64 }
name = "106th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 65 }
name = "9th Tank Div"
type = armor
strength = 100
model = 3 #
}
}
###
landunit = {
id = { type = 10178 id = 66 }
name = "XVIII Airborne Corps" 		#1st US Army Reserve
leader = 60311 #Ridgway, Matthew
location = 70

division = {
id = { type = 10178 id = 68 }
name = "82nd Airborne Div"
type = paratrooper
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 69 }
name = "101st Airborne Div"
type = paratrooper
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 70 }
name = "17th Airborne Div"
type = paratrooper
strength = 100
model = 3 #
}
}
####################################
landunit = {
id = { type = 10178 id = 71 }
name = "3rd US Army"
leader = 60294 #Patton
location = 72

division = {
id = { type = 10178 id = 72 }
name = "3rd US Army HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}
###
landunit = {
id = { type = 10178 id = 73 }
name = "III Corps"
leader = 60273 #Millikin, John
location = 71

division = {
id = { type = 10178 id = 75 }
name = "6th Tank Div"
type = armor
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 76 }
name = "26th Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
###
landunit = {
id = { type = 10178 id = 77 }
name = "XII Corps"
leader = 1265 # Ritchie
location = 72

division = {
id = { type = 10178 id = 79 }
name = "4th Tank Div"
type = armor
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 80 }
name = "35th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 81 }
name = "87th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 82 }
name = "80th Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
###
landunit = {
id = { type = 10178 id = 83 }
name = "XX Corps"
#leader = 60563 #Walker, Walton (air?)
location = 72

division = {
id = { type = 10178 id = 85 }
name = "10th Tank Div"
type = armor
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 86 }
name = "95th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 87 }
name = "5th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 88 }
name = "90th Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
####################################
####################################
landunit = {
id = { type = 10178 id = 238 }
name = "6th Army Group"
leader = 60128 #Devers
location = 73

division = {
	locked = yes
id = { type = 10178 id = 239 }
name = "6th Army Group HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}
####################################
landunit = {
id = { type = 10178 id = 89 }
name = "7th US Army"
leader = 60291 #Patch
location = 73

division = {
id = { type = 10178 id = 90 }
name = "7th US Army HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}
###
landunit = {
id = { type = 10178 id = 91 }
name = "XXI Corps"
leader = 60574 #Milburn, Frank
location = 73

division = {
id = { type = 10178 id = 93 }
name = "12th Tank Div"
type = armor
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 94 }
name = "74th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 95 }
name = "3rd Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
###
landunit = {
id = { type = 10178 id = 96 }
name = "XV Corps"
leader = 60190 #Haislip, Wade
location = 73

division = {
id = { type = 10178 id = 98 }
name = "45th Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
###
landunit = {
id = { type = 10178 id = 99 }
name = "VI Corps"
leader = 60352 #Truscott, Lucian
location = 73

division = {
id = { type = 10178 id = 101 }
name = "14th Tank Div"
type = armor
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 102 }
name = "36th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 103 }
name = "79th Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
####################################
landunit = {
	control = FRA
id = { type = 10178 id = 104 }
name = "1st French Army"
leader = 24114 #de Lattre de Tassigny
location = 316

division = {
id = { type = 10178 id = 105 }
name = "1st French Army HQ"
type = hq
model = 1
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 1
}
}
###
landunit = {
	control = FRA
id = { type = 10178 id = 106 }
name = "II French Corps"
leader = 24087 #De Goislard de Monsabert
location = 317

division = {
id = { type = 10178 id = 108 }
name = "3rd Infantry 'Algerian'"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 109 }
name = "9th Infantry 'Colonial'"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 110 }
name = "1st Tank Div"
type = armor
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 111 }
name = "1st Mot.Infantry Div"
type = motorized
strength = 100
model = 2 #
}
}
###
landunit = {
	control = FRA
id = { type = 10178 id = 112 }
name = "I French Corps"
leader = 24011 #Béthouart
location = 316

division = {
id = { type = 10178 id = 114 }
name = "2nd Infantry Div 'Moroccan'"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 115 }
name = "4th Mountain Inf Div 'Moroccan'"
type = bergsjaeger
strength = 100
model = 2 #
}

division = {
id = { type = 10178 id = 116 }
name = "5th Tank Div"
type = armor
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 117 }
name = "10th Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
###################################


landunit = {
id = { type = 10178 id = 118 }
name = "SHAEF"
leader = 60145 #Eisenhower
location = 56 #Paris

division = {
	locked = yes
id = { type = 10178 id = 107 }
name = "SHAEF HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}

division = {
id = { type = 10178 id = 119 }
name = "8th Tank Div"
type = armor
strength = 100
model = 3 #
}

division = {
id = { type = 10178 id = 120 }
name = "11th Tank Div"
type = armor
strength = 100
model = 3 #
}
}
###
landunit = {
id = { type = 10178 id = 121 }
name = "TF Dunkirk"
leader = 60323 # Schmidt
location = 18

division = {
id = { type = 10178 id = 122 }
name = "76th Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}

landunit = {
id = { type = 10178 id = 123 }
name = "TF Dunkirk"
leader = 60301 # Prickett
location = 44

division = {
id = { type = 10178 id = 124 }
name = "75th Infantry Div"
type = infantry
strength = 100
model = 4 #
}

division = {
id = { type = 10178 id = 125 }
name = "94th Infantry Div"
type = infantry
strength = 100
model = 4 #
}
}
#################################
# Air Force OOB 				#
#################################

########## 9th US Air Force #################

airunit = {
location = 64 #Reims
base = 64 #Reims
id = { type = 10178 id = 200 }
name = "IX Bomber Command"
leader = 60575 # Anderson S.E.

division = {
id = { type = 10178 id = 201 }
name = "97th Combat Bombardment Wing"
strength = 100
type = tactical_bomber
model = 2 #A-20 Havoc
}

division = {
id = { type = 10178 id = 202 }
name = "98th Combat Bombardment Wing"
strength = 100
type = tactical_bomber
model = 4 #B-26 Marauder
}

division = {
id = { type = 10178 id = 203 }
name = "99th Combat Bombardment Wing"
strength = 100
type = tactical_bomber
model = 4 #B-26 Marauder
}
division = {
id = { type = 10178 id = 205 }
name = "70th Fighter Wing"
strength = 100
type = multi_role
model = 1 #P-38 Lightning
}
}

airunit = {
location = 72 #Metz
base = 72 #Metz
id = { type = 10178 id = 204 }
name = "IX Tactical Air Command"
#leader = 60458

division = {
id = { type = 10178 id = 206 }
name = "71st Fighter Wing"
strength = 100
type = multi_role
model = 1 #P-47 Thunderbolt
}

division = {
id = { type = 10178 id = 207 }
name = "84th Fighter Wing"
strength = 100
type = multi_role
model = 1 #P-47 Thunderbolt
}
}

airunit = {
location = 70 #Arlon
base = 70 #Arlon
id = { type = 10178 id = 208 }
name = "XIX Tactical Air Command"
leader = 60566 #?

division = {
id = { type = 10178 id = 209 }
name = "100th Fighter Wing"
strength = 100
type = multi_role
model = 1 #P-51 Mustang
}

division = {
id = { type = 10178 id = 210 }
name = "303rd Fighter Wing"
strength = 100
type = multi_role
model = 1 #P-47 Thunderbolt
}
}

airunit = {
location = 54 #Amiens
base = 54 #Amiens
id = { type = 10178 id = 211 }
name = "IX Troop Carrier Command"
#leader = 60371 

division = {
id = { type = 10178 id = 212 }
name = "50th Troop Carrier Wing"
strength = 100
type = transport_plane
model = 1 #C-47
}

division = {
id = { type = 10178 id = 213 }
name = "52nd Troop Carrier Wing"
strength = 100
type = transport_plane
model = 1 #C-47
}

division = {
id = { type = 10178 id = 214 }
name = "53rd Troop Carrier Wing"
strength = 100
type = transport_plane
model = 1 #C-53
}
}
###########2nd UK Tactical Air Force#########
airunit = {
	control = ENG
location = 51 #Brussels
base = 51 #Brussels
id = { type = 10178 id = 215 }
name = "RAF Group No.2"
leader = 1437 #?

division = {
id = { type = 10178 id = 216 }
name = "137th Wing"
strength = 100
type = tactical_bomber
model = 2 #Boston IIIA
}

division = {
id = { type = 10178 id = 217 }
name = "138th Wing"
strength = 100
type = tactical_bomber
model = 2 #Mosquito VI
}

division = {
id = { type = 10178 id = 218 }
name = "139th Wing"
strength = 100
type = tactical_bomber
model = 3 #Mitchell II
}

division = {
id = { type = 10178 id = 219 }
name = "140th Wing"
strength = 100
type = tactical_bomber
model = 3 #Mosquito VI
}
}
####
airunit = {
	control = ENG
location = 45 #Ghent
base = 45 #Ghent
id = { type = 10178 id = 220 }
name = "RAF Group No.83"
leader = 1422 #?

division = {
id = { type = 10178 id = 221 }
name = "39th Reconnaissance Wing"
strength = 100
type = multi_role
model = 1 #Spitfire XI
}

division = {
id = { type = 10178 id = 222 }
name = "121st Wing"
strength = 100
type = interceptor
model = 3 #Typhoon IB
}

division = {
id = { type = 10178 id = 223 }
name = "122nd Wing"
strength = 100
type = multi_role
model = 1 #Mustang III
}

division = {
id = { type = 10178 id = 224 }
name = "124th Wing"
strength = 100
type = interceptor
model = 3 #Typhoon IB
}

division = {
id = { type = 10178 id = 225 }
name = "125th Wing"
strength = 100
type = multi_role
model = 1 #Spitfire IX
}
}
####
airunit = {
	control = ENG
location = 50 #Antwerp
base = 50 #Antwerp
id = { type = 10178 id = 226 }
name = "RAF Group No.84"
leader = 1426 # Cannon

division = {
id = { type = 10178 id = 227 }
name = "35th Reconnaissance Wing"
strength = 100
type = multi_role
model = 1 #Mustang IA
}

division = {
id = { type = 10178 id = 228 }
name = "123rd Wing"
strength = 100
type = interceptor
model = 3 #Typhoon IB
}

division = {
id = { type = 10178 id = 229 }
name = "131st Wing"
strength = 100
type = multi_role
model = 1 #Spitfire IX
}

division = {
id = { type = 10178 id = 230 }
name = "132nd Wing"
strength = 100
type = multi_role
model = 1 #Spitfire IX
}

division = {
id = { type = 10178 id = 231 }
name = "133rd Wing"
strength = 100
type = multi_role
model = 1 #Mustang III
}
}
####
airunit = {
	control = ENG
	location = 65 #Namur
	base = 65 #Namur
	id = { type = 10178 id = 232 }
	name = "RAF Group No.85"
	leader = 1492 # Steele 

	division = {
		id = { type = 10178 id = 233 }
		name = "34th Reconnaissance Wing"
		strength = 100
		type = multi_role
		model = 1 #Spitfire XI
	}
	division = {
		id = { type = 10178 id = 234 }
		name = "141st Wing"
		strength = 100
		type = multi_role
		model = 2 #Spitfire XIV
	}
	division = {
		id = { type = 10178 id = 235 }
		name = "142nd Wing"
		strength = 100
		type = multi_role
		model = 1 #Mosquito XIII
	}
	division = {
		id = { type = 10178 id = 236 }
		name = "149th Wing"
		strength = 100
		type = multi_role
		model = 1 #Mosquito XIII
	}
	division = {
		id = { type = 10178 id = 237 }
		name = "150th Wing"
		strength = 100
		type = interceptor
		model = 4 #Tempest V
	}
}

}