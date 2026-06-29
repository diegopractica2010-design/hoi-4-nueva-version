province = {
	id = 1692 #Noumea
	anti_air = 1
	air_base = {
		size = 4
		current_size = 4
		}
	naval_base = {
		size = 4
		current_size = 4
		}
	}

province = {
	id = 1689 #Espirtu Santo
	air_base = {
		size = 1
		current_size = 2
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = {
	id = 1685 #Guadalcanal
	air_base = {
		size = 1
		current_size = 1
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = { id = 1692 oilpool = 5000 supplypool = 10000 } #Noumea
province = { id = 1689 oilpool = 1000 supplypool = 2000 } #Espirtu Santo
province = { id = 1685 oilpool = 2500 supplypool = 5000 } #Guadalcanal


country = {
	tag = ALS

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
			headofgovernment = { type = 9 id = 6044 }
  			foreignminister = { type = 9 id = 6003 }
  			armamentminister = { type = 9 id = 6077 }
  			ministerofsecurity = { type = 9 id = 6005 }
  			ministerofintelligence = { type = 9 id = 6128 }
  			chiefofstaff = { type = 9 id = 6136 }
  			chiefofarmy = { type = 9 id = 6144 }
  			chiefofnavy = { type = 9 id = 6163 }
  			chiefofair = { type = 9 id = 6167 }

	steal_leader = 60388	#Callaghan
	steal_leader = 54067	#Crutchley
	steal_leader = 60403	#Fife
	steal_leader = 60509	#Fitch
	steal_leader = 60404	#Fletcher
	steal_leader = 60516	#Geiger
	steal_leader = 60406	#Ghormley
	steal_leader = 60407	#Giffen
	steal_leader = 60414	#Halsey
	steal_leader = 60522	#Harmon
	steal_leader = 60426	#Kinkaid
	steal_leader = 60430	#Lee
	steal_leader = 60436	#McCain
	steal_leader = 60449	#Noyes
	steal_leader = 60291	#Patch
	steal_leader = 60318	#Rupertus
	steal_leader = 60462	#Scott
	steal_leader = 60463	#Sherman
	steal_leader = 60475	#Turner
	steal_leader = 60357	#Vandegrift

	capital = 1692 #Noumea

	manpower = 100

	oil = 5000
	supplies = 10000
	money = 1000

	transports = 100
	escorts = 20

	extra_tc = 100

	free = {
		supplies = 50
		oil = 25
		ic = 24

		}
	ownedprovinces = { 1614 1622 1681 1682 1683 1684 1685 1686 1688 1689 1690 
1692 }
	controlledprovinces = { 1685 1686 1688 1689 1690 1692 }
	nationalprovinces = { 1692 }

	techapps = {
# Usa 1941 techs
#######################

6070 4060

4010 4020 4030 # Basic Interceptor (P-40's)

4040 4050 # Basic MR/Basic Escort

4120 4130 4140 4150 # Imp. medium bomber

4190 # Basic naval bomber (Patrol planes)

4220 4230	#Basic and Improved STR

4250 4260 # Imp transport (C-47)

2150 2160 # Imp. Armoured Car

2010 2020 2030 2040 2050 # Improved light tank

2030 2070 # Basic Medium (Grant)

2290 2300 2310 2320 2330 2340 # Imp. WWII artillery (120mm)

2400 2410 # Basic AT

2450 2460 2470 # Basic Static AA

2510 2520 # Imp. AA

1010 1020 1030 # Basic infantry

1190 1200 1210 1220 # Semi-moto cavalry

1230 # Basic motorized

1150 1160 # Basic Marine

1310 1340 # Supply/repair - basics only 

5010 5020 5030 # Agriculture (up to fertilizers)

5050 5060 5070 # Advanced Machine Tools

5080 5090 5100 # Construction (up to the forts)

5110 5120 5130 5140 5150 5160 5180 # Assembly lines (all except rockets)

5190 5200 5210 5220 5230 # Adv. oil plant (0.75)

5310 5320 5330 # Imp. Comp. machine

5350 5360 5370 5380 # Imp. encryption/Imp. decryption

5410 5420 5430 5440 # Cent. Radar

5470 5480 5490 5500 # Nuclear Tier 1 

9010 9020 9030 9040 9050 9060 9070 9080 9090 9100 9110 9120 9130 9140 9190 9210 9220 9230 9240 9250 

9350 # Doctrines (air)

6010 6020 6040 6050 6060 # Stand off doctrine (land)


8010 8020 8030 8040 8050 8060 8090 8100 8110 8160 8180 

3010 3020 3030 #(Somers)
3070 3080 3090 3100 #(Brooklyn)
3130 3140 3150 #(New Orleans)
3190 3200 3210 3220 #(blank-one away from Alaska)
3250 3260 3270 3280 #(N.Carolina)
3320 3330 3340 3350 3360 #(Essex is in the que)
3400 3410 3420 3430 #(Perch)

#hospital
14000 14010 14020
		}

	landunit = {
		id = { type = 10200 id = 1 }
		name = "Noumea Base Force"
		location = 1692 #Noumea
		division = {
			id = { type = 10200 id = 2 }
			name = "Noumea Base Force"
			strength = 20
			max_strength = 20
			type = garrison
			model = 1
			locked = yes
			}
		}

	landunit = {
		id = { type = 10200 id = 3 }
		name = "Espirtu Santo Base Force"
		location = 1689 #Espirtu Santo
		division = {
			id = { type = 10200 id = 4 }
			name = "Espirtu Santo Base Force"
			strength = 20
			max_strength = 20
			type = garrison
			model = 1
			locked = yes
			}
		}

	landunit = {
		id = { type = 10200 id = 5 }
		name = "Efate Base Force"
		location = 1690 #Efate
		division = {
			id = { type = 10200 id = 6 }
			name = "Efate Base Force"
			strength = 20
			max_strength = 20
			type = garrison
			model = 1
			locked = yes
			}
		}

	landunit = {
		id = { type = 10200 id = 7 }
		name = "Bank Islands Base Force"
		location = 1688 #Bank Islands
		division = {
			id = { type = 10200 id = 8 }
			name = "Bank Islands Base Force"
			strength = 20
			max_strength = 20
			type = garrison
			model = 1
			locked = yes
			}
		}

	landunit = {
		id = { type = 10200 id = 9 }
		name = "Santa Cruz Base Force"
		location = 1686 #Santa Cruz Islands
		division = {
			id = { type = 10200 id = 10 }
			name = "Santa Cruz Base Force"
			strength = 20
			max_strength = 20
			type = garrison
			model = 1
			locked = yes
			}
		}

	landunit = {
		id = { type = 10200 id = 11 }
		name = "1st Marine Division"
		location = 1685 #Guadalcanal
		leader = 60357 #Vandegrift
		division = {
			id = { type = 10200 id = 12 }
			name = "1st Marine Division"
			strength = 100
			max_strength = 100
			type = marine
			model = 1
			experience = 10
			}
		}

	landunit = {
		id = { type = 10200 id = 14 }
		name = "1st Marine Raider Battalion"
		location = 1685 #Guadalcanal
		leader = 60318 #Rupertus
		division = {
			id = { type = 10200 id = 13 }
			name = "1st Marine Raider Battalion"
			strength = 20
			max_strength = 20
			type = marine
			model = 1
			experience = 10
			}
		}

	landunit = {
		id = { type = 10200 id = 15 }
		name = "Americal Division"
		location = 1692 #Noumea
		leader = 60291 #Patch
		division = {
			id = { type = 10200 id = 16 }
			name = "Americal Division"
			strength = 100
			max_strength = 100
			type = infantry
			model = 3
			}
		}

	navalunit = {
		id = { type = 10200 id = 1000 }
		name = "Task Force 61"
		location = 2115 #Off Espirtu Santo
		base = 1692 #Noumea
		leader = 60404 #Fletcher
		division = { id = { type = 10200 id = 1001 } name = "USS Saratoga" type = carrier model = 1 extra = cag brigade_model = 3 experience = 10 }
		division = { id = { type = 10200 id = 1002 } name = "USS Enterprise" type = carrier model = 2 extra = cag brigade_model = 3 experience = 10 }
		division = { id = { type = 10200 id = 1003 } name = "USS Wasp" type = carrier model = 2 extra = cag brigade_model = 3 experience = 10 }
		division = { id = { type = 10200 id = 1004 } name = "USS North Carolina" type = battleship model = 3 }
		division = { id = { type = 10200 id = 1005 } name = "USS New Orleans" type = heavy_cruiser model = 2 }
		division = { id = { type = 10200 id = 1006 } name = "USS Minneapolis" type = heavy_cruiser model = 2 }
		division = { id = { type = 10200 id = 1007 } name = "USS Atlanta" type = light_cruiser model = 2 }
		division = { id = { type = 10200 id = 1008 } name = "USS Portland" type = heavy_cruiser model = 2 }
		division = { id = { type = 10200 id = 1009 } name = "USS Salt Lake City" type = heavy_cruiser model = 2 }
		division = { id = { type = 10200 id = 1010 } name = "USS San Francisco" type = heavy_Cruiser model = 2 }
		division = { id = { type = 10200 id = 1011 } name = "1st Destroyer Division" type = destroyer model = 2 }
		division = { id = { type = 10200 id = 1012 } name = "2nd Destroyer Division" type = destroyer model = 2 }
		division = { id = { type = 10200 id = 1013 } name = "3rd Destroyer Division" type = destroyer model = 1 }
		}

	navalunit = {
		id = { type = 10200 id = 1014 }
		name = "Task Group 62.1"
		location = 2118 #Off Guadalcanal
		base = 1692 #Noumea
		leader = 60475 #Turner
		division = { id = { type = 10200 id = 1015 } name = "'Alchiba' Flotilla" type = transport }
		division = { id = { type = 10200 id = 1016 } name = "'Crescent City' Flotilla" type = transport }
		division = { id = { type = 10200 id = 1017 } name = "'George F. Elliott' Flotilla" type = transport }
		}

	navalunit = {
		id = { type = 10200 id = 1018 }
		name = "Task Group 62.2"
		location = 2118 #Off Guadalcanal
		base = 1692 #Noumea
		leader = 54067 #Crutchley
		division = { id = { type = 10200 id = 1019 } name = "HMAS Australia" type = heavy_cruiser model = 2 }
		division = { id = { type = 10200 id = 1020 } name = "HMAS Canberra" type = heavy_cruiser model = 2 }
		division = { id = { type = 10200 id = 1021 } name = "HMAS Hobart" type = light_cruiser model = 2 }
		division = { id = { type = 10200 id = 1022 } name = "USS Chicago" type = heavy_cruiser model = 2 }
		division = { id = { type = 10200 id = 1023 } name = "USS Astoria" type = heavy_cruiser model = 2 }
		division = { id = { type = 10200 id = 1024 } name = "USS Quincy" type = heavy_cruiser model = 2 }
		division = { id = { type = 10200 id = 1025 } name = "USS Vincennes" type = heavy_cruiser model = 2 }
		division = { id = { type = 10200 id = 1026 } name = "USS San Juan" type = light_cruiser model = 2 }
		division = { id = { type = 10200 id = 1027 } name = "4th Destroyer Division" type = destroyer model = 2 }
		division = { id = { type = 10200 id = 1028 } name = "5th Destroyer Division" type = destroyer model = 1 }
		division = { id = { type = 10200 id = 1029 } name = "6th Destroyer Division" type = destroyer model = 1 }
		}

	navalunit = {
		id = { type = 10200 id = 1030 }
		name = "Task Force 42"
		location = 2117 #West of the Solomons
		base = 1692 #Noumea
		leader = 60403 #Fife
		division = { id = { type = 10200 id = 1031 } name = "1st Submarine Division" type = submarine model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2000 }
		name = "347th Fighter Group"
		location = 1692 #Noumea
		base = 1692 #Noumea
		division = { id = { type = 10200 id = 2001 } name = "347th Fighter Group" strength = 38 type = multi_role model = 0 max_strength = 50 }
		}

	airunit = {
		id = { type = 10200 id = 2002 }
		name = "11th Bomber Group"
		location = 1692 #Noumea
		base = 1692 #Noumea
		leader = 60522 #Harmon
		division = { id = { type = 10200 id = 2003 } name = "11th Bomber Group" strength = 21 type = strategic_bomber model = 0 max_strength = 50 }
		}

	airunit = {
		id = { type = 10200 id = 2004 }
		name = "VMF 212"
		location = 1689 #Espirtu Santo
		base = 1689 #Espirtu Santo
		leader = 60516 #Geiger
		division = { id = { type = 10200 id = 2005 } name = "VMF 212" strength = 29 type = interceptor model = 2 max_strength = 30 }
		}

#USAAF Reinforcements
airdivision = { dormant = yes id = { type = 10200 id = 2100 } name = "5th Bomber Group" type = strategic_bomber model = 0 strength = 35 max_strength = 50 }
airdivision = { dormant = yes id = { type = 10200 id = 2101 } name = "18th Fighter Group" type = multi_role model = 0 strength = 35 max_strength = 50 }
airdivision = { dormant = yes id = { type = 10200 id = 2102 } name = "307th Bomber Group" type = strategic_bomber model = 0 strength = 35 max_strength = 50 }

#USMC Aviation Reinforcements
airdivision = { dormant = yes id = { type = 10200 id = 2103 } name = "VMF-121" type = interceptor model = 2 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2104 } name = "VMF-122" type = interceptor model = 2 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2105 } name = "VMF-123" type = interceptor model = 2 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2106 } name = "VMF-124" type = interceptor model = 2 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2107 } name = "VMSB-131" type = cas model = 1 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2108 } name = "VMSB-132" type = cas model = 1 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2109 } name = "VMSB-141" type = cas model = 1 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2110 } name = "VMSB-142" type = cas model = 1 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2111 } name = "VMF-223" type = interceptor model = 2 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2112 } name = "VMF-224" type = interceptor model = 2 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2113 } name = "VMSB-231" type = cas model = 2 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2114 } name = "VMSB-232" type = cas model = 2 strength = 20 max_strength = 30 }
airdivision = { dormant = yes id = { type = 10200 id = 2115 } name = "VMSB-233" type = cas model = 2 strength = 20 max_strength = 30 }

#USMC Reinforcements
landdivision = { dormant = yes id = { type = 10200 id = 100 } name = "2nd Marine Division" type = marine model = 1 }
navaldivision = { dormant = yes id = { type = 10200 id = 1200 } name = "1st Transport Flotilla" type = transport }
landdivision = { dormant = yes id = { type = 10200 id = 101 } name = "2nd Raider Battalion" type = marine model = 1 strength = 20 max_strength = 20 }

#US Army Reinforcements
landdivision = { dormant = yes id = { type = 10200 id = 102 } name = "25th Division" type = infantry model = 3 }
navaldivision = { dormant = yes id = { type = 10200 id = 1201 } name = "2nd Transport Flotilla" type = transport }

#USN Reinforcements
navaldivision = { dormant = yes id = { type = 10200 id = 1100 } name = "USS Boise" type = light_cruiser model = 2 }
navaldivision = { dormant = yes id = { type = 10200 id = 1101 } name = "7th Destroyer Division" type = destroyer model = 2 }
navaldivision = { dormant = yes id = { type = 10200 id = 1102 } name = "USS Hornet" type = carrier model = 2 extra = cag brigade_model = 3 experience = 10 }
navaldivision = { dormant = yes id = { type = 10200 id = 1103 } name = "USS South Dakota" type = battleship model = 3 }
navaldivision = { dormant = yes id = { type = 10200 id = 1104 } name = "USS Northampton" type = heavy_cruiser model = 2 }
navaldivision = { dormant = yes id = { type = 10200 id = 1105 } name = "USS Pensacola" type = heavy_cruiser model = 2 }
navaldivision = { dormant = yes id = { type = 10200 id = 1106 } name = "USS San Diego" type = light_cruiser model = 2 }
navaldivision = { dormant = yes id = { type = 10200 id = 1107 } name = "USS Juneau" type = light_cruiser model = 2 }
navaldivision = { dormant = yes id = { type = 10200 id = 1108 } name = "8th Destroyer Division" type = destroyer model = 1 }
navaldivision = { dormant = yes id = { type = 10200 id = 1109 } name = "USS Helena" type = light_cruiser model = 2 }
navaldivision = { dormant = yes id = { type = 10200 id = 1110 } name = "9th Destroyer Division" type = destroyer model = 2 }
navaldivision = { dormant = yes id = { type = 10200 id = 1111 } name = "USS Honolulu" type = light_cruiser model = 2 }

	}
