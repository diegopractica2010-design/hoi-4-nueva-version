#Singapore
province = {
	id = 1353
	anti_air = 4
	air_base = {
		size = 6
		current_size = 6
		}

	naval_base = {
		size = 7
		current_size = 7
		}

        supplypool = 300
        oilpool = 50
	}


#Hong Kong

province = {
	id = 1315
	anti_air = 2
	air_base = {
		size = 4
		current_size = 4
		}

	naval_base = {
		size = 6
		current_size = 6
		}
        supplypool = 100
	}

#Rangoon
province = {
	id = 1299
	anti_air = 2
	air_base = {
		size = 4
		current_size = 4
		}

	naval_base = {
		size = 3
		current_size = 3
		}
	}


#calcutta
province = {
	id = 1457
	anti_air = 2
	air_base = {
		size = 4
		current_size = 4
		}

	naval_base = {
		size = 8
		current_size = 8
		}
	}

province = {
	id = 1284
	anti_air = 2
	air_base = {
		size = 3
		current_size = 2
		}

}


province = {
	id = 1296
	anti_air = 2
	air_base = {
		size = 3
		current_size = 2
		}

}

province = {	id = 1353	landfort = 0 coastalfort = 5 } #Singapore
province = {	id = 1315	landfort = 5 coastalfort = 0 }#Hong Kong



country = {
    tag = ENG
	capital = 1457

	policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 10
        political_left = 2
        freedom = 10
        free_market = 8
        professional_army = 5
        defense_lobby = 5
        interventionism = 6
    }

		headofstate = { type = 9 id = 1033 }
		headofgovernment = { type = 9 id = 1038 }
  		foreignminister = { type = 9 id = 1003 }
  		armamentminister = { type = 9 id = 1062 }
  		ministerofsecurity = { type = 9 id = 1085 }
  		ministerofintelligence = { type = 9 id = 1103 }
  		chiefofstaff = { type = 9 id = 1120 }
  		chiefofarmy = { type = 9 id = 1130 }
  		chiefofnavy = { type = 9 id = 1140 } 
  		chiefofair = { type = 9 id = 1147 }


	manpower = 485

	oil 	=	400
        supplies = 650

        extra_tc = 45
	free = 		{
		oil 	=	15
		supplies =	35
                transports = 0.5
		ic = 5
	}
        transports = 80



	ownedprovinces =      {
		#GREAT BRITAIN
1284	1285    1286	1287	1288	1289	1290	1291	1292	1295	1296	1297	1298	1299	1300	1301	1302	1303	1304	1315	1346   1349	1350	1351	1352	1353	1456	1457	1518    1519    1644	1646	1647	1877	1878	1898

                }

	controlledprovinces = {
1284	1285    1286	1287	1288	1289	1290	1291	1292	1295	1296	1297	1298	1299	1300	1301	1302	1303	1304	1315	1346    1349	1350	1351	1352	1353	1456	1457	1518    1519    1644	1646	1647	1877	1878	1898

	}

	nationalprovinces =   {
         1285 1457 1456 1315 1353
	}

	techapps = {
# UK 1941 techs
#######################

12100
2220 2230 # Basic Self-Propelled Artillery

2100 # Basic Heavy Tank

2150 # Basic Armoured Car

4010 4020 4030 # Basic Interceptor (Hurricane II)

4040 4070 # Imp. Fighter (Spitfire IX)

4050 # Basic Escort Fighter

4120 4130 4140 # Basic medium bomber

4220 4230 # Imp. Strategic Bomber (Halifax)

4190 # Basic naval bomber

4250 # Basic transport (DC-3)

2010 2020 2040 2050 # Improved light tank

2030 2070 # Basic Medium (Crusader I/Matilda)

2170 2180 # Basic TD

2290 2300 2310 2320 2330 2340  # Imp. WWII artillery (120mm)

2400 2410 # Basic AT

2450 2460 2470 # Basic Static AA

2510 2520 # Imp. AA

1010 1020 1030 # Basic infantry

1190 1200 1210 1220 # Semi-moto cavalry

1110 1120 1130 1070 # Imp. Mountain/Early para

1230 # Basic motorized

1150 1160 # Basic Marine

1310 1340 # Supply/repair - basics only 

5010 5020 5030 # Agriculture (up to fertilizers)

5050 5060 5070 # Improved Machine Tools

5080 5090 5100 # Construction (up to the forts)

5110 5120 5130 5140 5160 5180 # Assembly lines (planes, tanks, small arms)

5190 5200 # Imp. oil conversion

5310 5320 5330 # Imp. Comp. machine

5350 5360 5370 5380 # Imp. encryption/Imp. decryption

5410 5420 5430 5440 # Cent. Radar

5470 5480 5490 5500 # Nuclear Tier 1

5550 # Rocket test site (Jet engines)

9010 9020 9030 9040 9050 9060 9070 9080 9090 9100 9110 9120 9130 9140 9190 9210 9220 9230 9240 9250 9350 # Doctrines (air)

6010 6030 6110 6120 # doctrine (land)


##doctrines
8010 8020 8030 8040 8050 8070 8100 8120 8130 8190 8200 8310
###navy
3010 3020 3030 #(Tribal)
3070 3080 3090 3100 #(Southampton)
3130 3140 3150 #(Surrey)
3190 3200 3210 #(Hood)
3250 3260 3270 3280 #(KGV)
3320 3330 3340 3350 3360 #(Implacable-for the CAG tech)
3400 3410 3420 #(Triton)
#hospital
14000 14010 14020
		}




		landunit = {
		location = 1349
		id = { type = 11000 id = 1 }
		name = "11th Indian Division"

			division = { experience = 35
			id = { type = 11000 id = 2 }
			name = "11th Indian Division"
			type = infantry
			strength  = 65
			model = 1
			}
			}


		landunit = {
		location = 1350
		id = { type = 11000 id = 3 }
		name = "9th Indian Division"

			division = { experience = 35
			id = { type = 11000 id = 4 }
			name = "8th Indian Brigade"
			type = infantry
			strength  = 32
			max_strength  = 32
			model = 1
			}
			}

		landunit = {
		location = 1350
		id = { type = 11000 id = 5 }
		name = "9th Indian Division"

			division = { experience = 35
			id = { type = 11000 id = 6 }
			name = "22th Indian Brigade"
			type = infantry
			strength  = 32
			max_strength  = 32
			model = 1
			}
			}

		landunit = {
		location = 1349
		id = { type = 11000 id = 7 }
		name = "III Indian Corps Reserve"

			division = { experience = 35
			id = { type = 11000 id = 8 }
			name = "28th Indian Brigade"
			type = infantry
			strength  = 32
			max_strength  = 32
			model = 1
			}
			}


		landunit = {
		location = 1352
		id = { type = 11000 id = 9 }
		name = "12th Indian Brigade"

			division = { experience = 35
			id = { type = 11000 id = 10 }
			name = "12th Indian Brigade"
			type = infantry
			strength  = 32
			max_strength  = 32
			model = 1
			}
			}


		landunit = {
		location = 1353
		id = { type = 11000 id = 11 }
		name = "Far Eastern Command"

			division = { experience = 55
			id = { type = 11000 id = 12 }
			name = "Singapore Fortress"
			type = garrison
			strength  = 35
			model = 0
			}
			}


		landunit = {
		location = 1315
		id = { type = 11000 id = 13 }
		name = "Hong Kong Command"

			division = { experience = 45
			id = { type = 11000 id = 14 }
			name = "Hong Kong Defence Force"
			type = infantry
			strength  = 20
			max_strength  = 20
			model = 2
			}
			}


		landunit = {
		location = 1457
		id = { type = 11000 id = 15 }
		name = "1st Indian Infantry"

		division = { experience = 35
			id = { type = 11000 id = 16 }
			name = "1st Indian Infantry"
			type = infantry
			strength  = 60
			model = 1
			}
			}

		landunit = {
		location = 1457
		id = { type = 11000 id = 17 }
		name = "2nd Indian Infantry"

			division = { experience = 35
			id = { type = 11000 id = 18 }
			name = "2nd Indian Infantry"
			type = infantry
			model = 1
			strength  = 40
			}
			}

		landunit = {
		location = 1457
		id = { type = 11000 id = 19 }
		name = "SEAC"

			division = { experience = 45
			id = { type = 11000 id = 20 }
			name = "SEAC"
			type = hq
			model = 1
			strength  = 40
			}
			}

		landunit = {
		name = "1st Burma Division"
		location = 1299
		id = { type = 11000 id = 21 }
		
			division = { experience = 45 
			id = { type = 11000 id = 22 } 
			name = "1st Burma Division" 
			type = infantry model= 2
 			strength = 100
			}
			}

		landunit = {
		name = "7th Gurka Regiment"
		location = 1296
		id = { type = 11000 id = 23 }
		
			division = { experience = 95 
			id = { type = 11000 id = 24 } 
			name = "7th Gurka Regiment" 
			type = bergsjaeger model = 1
 			strength = 40
 			max_strength = 40
			}
			}


	navalunit = {
	name = "Indian Ocean squadron"
	id = { type = 11000 id = 677 }
	location = 1457
	base = 1457

		division = { experience = 75 
		id = { type = 11000 id = 410 } 
		name = "HMS Royal Sovereign" 
		type = battleship
		model = 1 #Royal Sovereign class
		}

		division = { experience = 75 
		id = { type = 11000 id = 408 } 
		name = "HMS Revenge" 
		type = battleship
		model = 1 #Royal Sovereign class
		}

		division = { experience = 75 
		id = { type = 11000 id = 424 } 
		name = "HMS Hermes" 
		type = escort_carrier
		model = 0 
		}

		division = { experience = 75 
		id = { type = 11000 id = 480 } 
		name = "HMS Enterprise" 
		type = light_cruiser 
		model = 2 #E class
		}
 
		division = { experience = 75 
		id = { type = 11000 id = 459 } 
		name = "HMS Colombo (AA)" 
		type = light_cruiser 
		model = 0 #C class
		}
 
		division = { experience = 75 
		id = { type = 11000 id = 450 } 
		name = "HMS Cornwall" 
		type = heavy_cruiser 
		model = 2 #County class
		} 

		division = { experience = 75 
		id = { type = 11000 id = 541 } 
		name = "HMS Watchman Squadron" 
		type = destroyer 
		model = 0 # V/W Class
		maxspeed = 34 #34 knots
		} 	
		}

	navalunit = {
	name = "India station"
	id = { type = 11000 id = 678 }
	location = 1457
	base = 1457

		division = { experience = 75 
		id = { type = 11000 id = 406 } 
		name = "HMS Ramilles" 
		type = battleship
		model = 1 #Royal Sovereign class
		}

		division = { experience = 75 
		id = { type = 11000 id = 479 } 
		name = "HMS Emerald" 
		type = light_cruiser 
		model = 2 #E Class
		} 
	
		division = { experience = 75 
		id = { type = 11000 id = 458 } 
		name = "HMS Ceres" 
		type = light_cruiser 
		model = 0 #C class
		} 

		division = { experience = 75 
		id = { type = 11000 id = 454 } 
		name = "HMS Caledon (AA)" 
		type = light_cruiser 
		model = 0 #C class
		} 

		division = { experience = 75 
		id = { type = 11000 id = 488 } 
		name = "HMS Glasgow" 
		type = light_cruiser 
		model = 3 #Southampton class
		} 

		division = { experience = 75 
		id = { type = 11000 id = 512 } 
		name = "HMS Mauritius" 
		type = light_cruiser 
		model = 4 #Fiji class
		} 


		division = { experience = 75 
		id = { type = 11000 id =537 } 
		name = "HMS Viscount Squadron" 
		type = destroyer 
		model = 0 # V/W Class
		maxspeed = 34 #34 knots
		}
		} 

	navalunit = {
	name = "China station"
	id = { type = 11000 id = 679 }
	location = 1353
	base = 1353

		division = { experience = 75 
		id = { type = 11000 id = 473 } 
		name = "HMS Durban" 
		type = light_cruiser 
		model = 1 #D class
		}
 
		division = { experience = 75 
		id = { type = 11000 id = 467} 
		name = "HMS Danae" 
		type = light_cruiser 
		model = 1 #D class
		} 

		division = { experience = 75 
		id = { type = 11000 id = 474 } 
		name = "HMS Dragon" 
		type = light_cruiser 
		model = 1 #D class
		} 

		division = { experience = 75 
		id = { type = 11000 id = 553 } 
		name = "HMS Electra Squadron" 
		type = destroyer 
		model = 2 # E/F Class
		maxspeed = 36 #36 knots
		seaattack = 5 #8tt
		} 
		}


	navalunit = {
	name = "Force Z"
	id = { type = 11000 id = 22679 }
	location = 1353
	base = 1353

		division = { experience = 75 
		id = { type = 11000 id = 416 } 
		name = "HMS Prince of Wales" #Sunk 411210
		type = battleship 
		model = 3#King George V class
		}

		division = { experience = 75 
		id = { type = 11000 id = 418 } 
		name = "HMS Repulse" #sunk 411210
		type = Battlecruiser 
		model = 1 #Repulse class
		}

		division = { experience = 75 
		id = { type = 11000 id = 555 } 
		name = "HMS Greyhound Squadron" 
		type = destroyer 
		model = 2 # G/H Class
		maxspeed = 36 #36 knots
		#seaattack = 5 #8tt
		} 
		}


	navalunit = {
	name = "7th Transport Flotilla"
	id = { type = 11000 id =686 }
	location = 1457 #Colombo
	base = 1457
	division = { experience = 75 id = { type = 11000 id = 728 } name = "7th Transport Flotilla (A)" type = transport model = 0 }
	division = { experience = 75 id = { type = 11000 id = 729 } name = "7th Transport Flotilla (B)" type = transport model = 0 }
	division = { experience = 75 id = { type = 11000 id = 730 } name = "7th Transport Flotilla (C)" type = transport model = 0 }
	}

	airunit = {
	location = 1457
	base = 1457
	id = { type = 11000 id = 926 }
	name = "India Air Command"

		division = { experience = 45
		id = { type = 11000 id = 927 }
		name = "Indian Group"
		type = tactical_bomber
		model = 1
		strength = 100
		}
		}



	airunit = {
	location = 1353
	base = 1353
	id = { type = 11000 id = 928 }
	name = "Far East Air Command"

		division = { experience = 45
		id = { type = 11000 id = 929 }
		name = "1/Far East Group"
		type = tactical_bomber
		model = 1
		strength = 100
		}

		division = { experience = 45
		id = { type = 11000 id = 930 }
		name = "2/Far East Group"
		type = interceptor
		model = 2
		strength = 100
		}
		}









##########exp forces.

########Australia

	landunit = {
 	id = { type = 10002 id = 18 }
 	name = "22nd Brigade/8th Division"
 	location = 1351
	leader = 54029
            	control = AST
  		
		division = { experience = 62
   		id = { type = 10002 id = 19 }  
   		name = "22nd Brigade"
   		strength = 30
                max_strength = 30
   		type = infantry 
                model = 2
		}
	}


	landunit = {
 	id = { type = 10002 id = 20 }
 	name = "27th Brigade/8th Division"
 	location = 1353
	leader = 54004 
            	control = AST
  		
		division = { experience = 62
   		id = { type = 10002 id = 21 }  
   		name = "27th Brigade"
   		strength = 30
                max_strength = 30
   		type = infantry 
                model = 2
		}
	}



########Dutch East Indies

		landunit = {
	        id = { type = 10333 id = 1 }
		location = 1628
		leader = 7819
		name = "Dutch colonial army"
            	control = HOL

			division = { experience = 35 id = { type = 10333 id = 2 } name = "Ie Divisie 'Java'"	type = infantry	model = 1 }
			division = { experience = 35 id = { type = 10333 id = 3 } name = "IIe Divisie 'Java'"	type = infantry	model = 1 }
	}

	navalunit = {
	id = { type = 10333 id = 5 }
	location = 1628
	base = 1628
	name = "Dutch colonial fleet"
	leader = 7839
            	control = HOL

			division = { experience = 50 id = { type = 10333 id = 6 } name = "HNMS Tromp" type = light_cruiser model = 1 }
			division = { experience = 50 id = { type = 10333 id = 7 } name = "HNMS De Ruyter" type = light_cruiser model = 1 }
			division = { experience = 50 id = { type = 10333 id = 8 } name = "HNMS Java" type = light_cruiser model = 1 }
			division = { experience = 50 id = { type = 10333 id = 9 } name = "1e Torpedobootjager Smaldeel" type = destroyer model = 1 }
			division = { experience = 50 id = { type = 10333 id = 10 } name = "2e Torpedobootjager Smaldeel" type = destroyer model = 1 }
			division = { experience = 50 id = { type = 10333 id = 11 } name = "1e Onderzeeboot Smaldeel" type = submarine model = 1 }
			division = { experience = 50 id = { type = 10333 id = 12 } name = "2e Onderzeeboot Smaldeel" type = submarine model = 0 }
			division = { experience = 50 id = { type = 10333 id = 13 } name = "3e Onderzeeboot Smaldeel" type = submarine model = 0 }
			division = { experience = 50 id = { type = 10333 id = 14 } name = "1e Transport Smaldeel" type = transport }
			division = { experience = 50 id = { type = 10333 id = 15 } name = "2e Transport Smaldeel" type = transport }
			division = { experience = 50 id = { type = 10333 id = 16 } name = "3e Transport Smaldeel" type = transport }
			division = { experience = 50 id = { type = 10333 id = 17 } name = "4e Transport Smaldeel" type = transport }
			}


	airunit = {
	id = { type = 10333 id = 18 }
	location = 1628
	base = 1628
	name = "Dutch Colonial airforce"
	leader = 7859
            	control = HOL

		division = { experience = 35
		id = { type = 10333 id = 19 } 
		name = "1st interceptor wing" 
		type = interceptor
		model = 1 
		strength = 50
		}

		division = { experience = 35
		id = { type = 10333 id = 20 } 
		name = "1st bomber wing" 
		type = tactical_bomber
		model = 1 
		strength = 50
		}
		}


landunit = {
	        id = { type = 10333 id = 21 }
		location = 1632
		name = "Surabaja Detachement"
		leader = 7804
            	control = HOL
			division = { experience = 35 id = { type = 10333 id = 22 } name = "IIIe Divisie 'Java'"	type = infantry	model = 1 }
                }



landunit = {
	        id = { type = 10333 id = 23 }
		location = 1648
		name = "Tarakan Regiment"
		leader = 7812
            	control = HOL
			division = { experience = 35 id = { type = 10333 id = 24 } name = "Tarakan Regiment" type = infantry	model = 1 strength = 30 max_strength = 30 }
                }


landunit = {
	        id = { type = 10333 id = 25 }
		location = 1656
		name = "Ceram Regiment"
		leader = 7814
            	control = HOL
			division = { experience = 35 id = { type = 10333 id = 26 } name = "Ceram Regiment" type = infantry	model = 1 strength = 30 max_strength = 30 }
                }

landunit = {
	        id = { type = 10333 id = 27 }
		location = 1657
		name = "Timor Regiment"
		leader = 7801
            	control = HOL
			division = { experience = 35 id = { type = 10333 id = 28 } name = "Timor Regiment" type = infantry	model = 1 strength = 30 max_strength = 30 }
                }

landunit = {
	        id = { type = 10333 id = 29 }
		location = 1358
		name = "Palembang Regiment"
		leader = 7800
            	control = HOL
			division = { experience = 35 id = { type = 10333 id = 30 } name = "Ceram Regiment" type = infantry	model = 1 strength = 30 max_strength = 30 }
                }

}





#Eof




