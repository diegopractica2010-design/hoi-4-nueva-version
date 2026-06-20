province = {
	id = 1613
	anti_air = 10
	air_base = {
		size = 6
		current_size = 6
		}

	naval_base = {
		size = 6
		current_size = 6
		}
        
	energy	=	18
	metal	=	10
	rare_materials =	6
	oil 	=	6

        ic = 6
	coastalfort = 3
	}

province = {
	id = 1669
        supplypool = 200
        oilpool = 50
	}
province = {
	id = 1670
	anti_air = 1
	air_base = {
		size = 4
		current_size = 4
		}

	naval_base = {
		size = 4
		current_size = 4
		}
	coastalfort = 1
        supplypool = 500
        oilpool = 250
	}
province = {
	id = 1672
	air_base = {
		size = 2
		current_size = 0
		}

	naval_base = {
		size = 1
		current_size = 1
		}
	anti_air = 1
	landfort = 1
        supplypool = 200
        oilpool = 50
	}


province = {
	id = 1683
	air_base = {
		size = 2
		current_size = 2
		}

	naval_base = {
		size = 1
		current_size = 1
		}
        supplypool = 200
        oilpool = 50
	}




country = {
	tag = JAP

	policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 2
        political_left = 3
        freedom = 3
        free_market = 3
        professional_army = 3
        defense_lobby = 8
        interventionism = 8
                 }

		headofstate = { type = 9 id = 5001 }
		headofgovernment = { type = 9 id = 5042 }
		foreignminister = { type = 9 id = 5066 }
		armamentminister = { type = 9 id = 5092 }
		ministerofsecurity = { type = 9 id = 5123 }
		ministerofintelligence = { type = 9 id = 5144 }
		chiefofstaff = { type = 9 id = 5156 }
		chiefofarmy = { type = 9 id = 5166 }
		chiefofnavy = { type = 9 id = 5200 }
		chiefofair = { type = 9 id = 5193 }

	capital = 1613

	manpower = 45

	# Resource Reserves
	energy	=	200
	metal	=	200
	rare_materials =	200
	oil 	=	2000
        supplies = 650

        extra_tc = 30  

	free = 		{
		oil 	=	5
		supplies =	15
		ic = 5
	}
      

	ownedprovinces =      { 1612 1613}
	controlledprovinces = { 1612 1613 1667 1672 1668 1669 1670 1671 1681 1682 1683 1614 1622 1684 } 
	nationalprovinces =   { 1613 }


techapps = {
# JAP 1941 techs
#######################

4010 4020 4030 # Basic Interceptor (Zeke ?)

4040 # Basic MR

4120 4130 4140 4150 # Improved medium bomber (Betty)

4190 4200 # Improved naval bomber (Betty again)

4250 # Basic transport

2150 # Basic Armoured Car

2010 2020 2030 2040 # Basic light tank

2030 2070 # Basic Medium

2290 2300 2310 2320 # Early Field Artillery

2400 # Early AT

2450 2460 2470 # Basic Static AA

2510 2520 # Imp. AA

1010 1020 1030 # Basic infantry

1190 1200 1210 1220 # Semi-moto cavalry

1110 1120 1130 1070 # Imp. Mountain/Early para

1230 # Basic motorized

1150 1160 # Basic Marine

1310 1340 # Supply/repair - basics only 

5010 # Agriculture (basic)

5050 5060 5070 # Advanced Machine Tools

5080 5090 5100 # Construction (up to the forts)

5110 5120 5130 5140 5150 # Assembly lines (planes, ships)

5190 5200 # Imp. oil conversion

5350 # Basic encryption

5470 # Nukes (level I)

9010 9020 9030 9040 9050 9060 9070 9080 9090 9100 9110 9120 9130 9190 9200 9210 9220 9350 # Doctrines (air)

6010 6030 6110 6120 6160 # doctrine (land)

8010 8020 8030 8040 8050 8060 8090 8100 8110 8160 8180 8230


3010 3020 3030 3040
3070 3080 3090 3100
3130 3140 3150
3190 3200 3210
3250 3260 3270 3280
3320 3330 3340 3350 3360
3400 3410 3420 3430
1040 2330
#hospital
14000 14010
#escort carriers
12100 12110

}

	transports = 262
	escorts = 34





	landunit = {
		id = { type = 10300 id = 1 }
		name = "Truk Base Force"
		location = 1613
		
		division = { id = { type = 10300 id = 2 } name = "Truk Base Force" strength = 40 max_strength = 40 type = garrison model = 0 }
                    }


	landunit = {
		id = { type = 10300 id = 3 }
		name = "Kavieng Base Force"
		location = 1669
		
		division = { id = { type = 10300 id = 4 } name = "Kavieng Base Force" strength = 20 max_strength = 20 type = garrison model = 0	}
                       }


	landunit = {
		id = { type = 10300 id = 5 }
		name = "Rabaul Base Force"
		location = 1670
		leader = 101051 #Hyakutake
		
			division = {
			id = { type = 10300 id = 6 }  name = "Rabaul Base Force" strength = 40 max_strength = 40 type = garrison model = 0 }
                      }


	landunit = {
		id = { type = 10300 id = 9 }
		name = "Lae Base Force"
		location = 1672
		
			division = {
			id = { type = 10300 id = 10 }
			name = "Lae Base Force"
			strength = 20
                        max_strength = 20
			type = garrison
			model = 0
                    	}
                       }

	landunit = {
		id = { type = 10300 id = 11 }
		name = "Shortland Base Force"
		location = 1683
		
			division = {
			id = { type = 10300 id = 12 }
			name = "Shortland Base Force"
			strength = 20
                        max_strength = 20
			type = garrison
			model = 0
                    	}
                       }

	landunit = {
		id = { type = 10300 id = 13 }
		name = "Kure SNLF"
		location = 1683
		
			division = {
			id = { type = 10300 id = 14 }
			name = "Kure SNLF"
			strength = 20
                        max_strength = 20
			type = marine
			model = 1
                    	}
                       }

	landunit = {
		id = { type = 10300 id = 15 }
		name = "Sasebo SNLF"
		location = 1670
		
			division = {
			id = { type = 10300 id = 16 }
			name = "Sasebo SNLF"
			strength = 20
                        max_strength = 20
			type = marine
			model = 1
                    	}
                       }

	landunit = {
		id = { type = 10300 id = 17 }
		name = "Maizuru SNLF"
		location = 1672
		leader = 101048 #Horii
		
			division = {
			id = { type = 10300 id = 18 }
			name = "Maizuru SNLF"
			strength = 20
                        max_strength = 20
			type = marine
			model = 1
                    	}
                       }

	landunit = {
		id = { type = 10300 id = 19 }
		name = "144th Regiment"
		location = 1670
		
			division = {
			id = { type = 10300 id = 20 }
			name = "144th Regiment"
			strength = 45
                        max_strength = 45
			type = infantry
			model = 3
                        extra = artillery
                        brigade_model = 4
                    	}
                       }




	navalunit = {
	id = { type = 10300 id = 51}
	name = "1. Carrier Fleet"
	location = 1613
	base = 1613
	leader = 101283 #Takagi
	division = { id = { type = 10300 id = 52 } 
		name = "Myoko" 
		type = heavy_cruiser 
		model = 2
		#seaattack = 10 #10x8" = higher than normal for class
		}
	division = { id = { type = 10300 id = 53 } 
		name = "Haguro" 
		type = heavy_cruiser 
		model = 2
		#seaattack = 10 #10x8" = higher than normal for class
		}
	division = { id = { type = 10300 id = 54 } 
		name = "Shokaku" 
        	type = carrier
		model = 3 # 84 ac
		extra = cag
                brigade_model = 4
                experience = 20
		}
	division = { id = { type = 10300 id = 55 } 
		name = "Zuikaku" 
		type = carrier
		model = 3 # 90 ac
		extra = cag
                brigade_model = 4
                experience = 20
		}
	division = { id = { type = 10300 id = 56 } name = "31 Kuchikukantai" type = destroyer model = 1 }
        }


	navalunit = {
	id = { type = 10300 id = 57}
	name = "Support Fleet"
	location = 1613
	base = 1613
	leader = 101225 #Goto

		division = { id = { type = 10300 id = 58 } 
		name = "Kako" 
		type = heavy_cruiser 
		model = 1
		#seaattack = 8 #6x8" = lower than normal for class
		}

		division = { id = { type = 10300 id = 59 } 
		name = "Aoba" 
		type = heavy_cruiser 
		model = 1
		#seaattack = 8 #6x8" = lower than normal for class
		}

		division = { id = { type = 10300 id = 60 } 
		name = "Kinugasa" 
		type = heavy_cruiser 
		model = 1
		#seaattack = 8 #6x8" = lower than normal for class
		}

		division = { id = { type = 10300 id = 61 } 
		name = "Shoho" 
		type = escort_carrier
		model = 1
		extra = cag
                brigade_model = 2
                experience = 20
		}
      }

      navalunit = {
	id = { type = 10300 id = 62 }
	name = "9 Sensuikantai"
	location = 1613
	base = 1613
		division = { id = { type = 10300 id = 63 } name = "9 Sensuikantai" type = submarine model = 1 }
		}


	navalunit = {
	id = { type = 10300 id = 64 }
	name = "1.Transport Fleet"
	location = 1670
	base = 1670
		division = { id = { type = 10300 id = 65 } name = "Yubari" type = light_cruiser model = 0 }	
		division = { id = { type = 10300 id = 66 } name = "35 Kuchikukantai" type = destroyer model = 1 }
		division = { id = { type = 10300 id = 67 } name = "7th Transport Flotilla" type = transport }
		}

	navalunit = {
	id = { type = 10300 id = 68 }
	name = "2.Transport Fleet"
	location = 1683
	base = 1683
		division = { id = { type = 10300 id = 69 } name = "27 Kuchikukantai" type = destroyer model = 1 }
		division = { id = { type = 10300 id = 70 } name = "5th Transport Flotilla" type = transport }
		}




	airunit = {
		id = { type = 10300 id = 100 }
		name = "11th Air Army"
		location = 1670
           	base = 1670
		
		division = { id = { type = 10300 id = 101 } name = "Tainan Daitai" strength = 25 type = multi_role model = 2 }
		division = { id = { type = 10300 id = 102 } name = "Genzan Daitai" strength = 62 type = naval_bomber model = 1 }
                }


#########reinforcements

###jun - aug
landdivision = { dormant = yes id = { type = 10300 id = 200 } name = "65 Independent Brigade" strength = 68 max_strength = 68 type = infantry model = 3 }
landdivision = { dormant = yes id = { type = 10300 id = 201 } name = "35 Independent Brigade" strength = 68 max_strength = 68 type = bergsjaeger model = 1 }
navaldivision = { dormant = yes id = { type = 10300 id = 202 }  name = "Mutsu" type = battleship model = 2 }
navaldivision = { dormant = yes id = { type = 10300 id = 203 } name = "Kirishima" type = battlecruiser model = 0 }
navaldivision = { dormant = yes id = { type = 10300 id = 204 } name = "Hiei" type = battlecruiser model = 0 }
navaldivision = { dormant = yes id = { type = 10300 id = 205 } name = "Atago" type = heavy_cruiser model = 3 }
navaldivision = { dormant = yes id = { type = 10300 id = 206 } name = "Maya" type = heavy_cruiser model = 3	}
navaldivision = { dormant = yes id = { type = 10300 id = 207 } name = "Chokai" type = heavy_cruiser model = 3 }
navaldivision = { dormant = yes id = { type = 10300 id = 208 } name = "Nachi" type = heavy_cruiser model = 2 }
navaldivision = { dormant = yes id = { type = 10300 id = 209 } name = "Mogami" type = heavy_cruiser model = 3 }
navaldivision = { dormant = yes id = { type = 10300 id = 210 } name = "Mikuma" type = heavy_cruiser model = 3 }  ###sunk at midway
navaldivision = { dormant = yes id = { type = 10300 id = 211 } name = "Tone" type = heavy_cruiser 	model = 3 }
navaldivision = { dormant = yes id = { type = 10300 id = 212 } name = "Chikuma" type = heavy_cruiser model = 3 }
navaldivision = { dormant = yes id = { type = 10300 id = 213 } name = "Nagara" type = light_cruiser model = 1 }
navaldivision = { dormant = yes id = { type = 10300 id = 214 } name = "Natori" type = light_cruiser model = 1 }
navaldivision = { dormant = yes id = { type = 10300 id = 215 } name = "Kashima" type = light_cruiser model = 0 maxspeed = 18 }
navaldivision = { dormant = yes id = { type = 10300 id = 216 } name = "Taiyo" type = escort_carrier model = 0 extra = cag                brigade_model = 2 }
navaldivision = { dormant = yes id = { type = 10300 id = 217 } name = "Kashii" type = light_cruiser model = 0 maxspeed = 18	}
navaldivision = { dormant = yes id = { type = 10300 id = 218 } name = "Furutaka" type = heavy_cruiser model = 1 }
navaldivision = { dormant = yes id = { type = 10300 id = 219 } name = "3rd Transport Flotilla" type = transport }
###oct
navaldivision = { dormant = yes id = { type = 10300 id = 225 } name = "Junyo" type = carrier model = 2 	extra = cag                 brigade_model = 3                 experience = 20}
navaldivision = { dormant = yes id = { type = 10300 id = 226 } name = "Hiyo" type = carrier model = 2 	extra = cag                 brigade_model = 3                experience = 20 }
navaldivision = { dormant = yes id = { type = 10300 id = 227 } name = "Zuiho" type = escort_carrier model = 1 extra = cag                 brigade_model = 2                 experience = 20 }
navaldivision = { dormant = yes id = { type = 10300 id = 228 } name = "Kongo" type = battlecruiser model = 0 }
navaldivision = { dormant = yes id = { type = 10300 id = 229 } name = "Haruna" type = battlecruiser model = 0 }
navaldivision = { dormant = yes id = { type = 10300 id = 230 } name = "40 Kuchikukantai" type = destroyer model = 2 }
landdivision = { dormant = yes id = { type = 10300 id = 231 } name = "2 Hoheishidan" strength = 100 type = infantry extra = anti_air model = 2 brigade_model = 1 }

###nov
navaldivision = { dormant = yes id = { type = 10300 id = 232 } name = "Yamato" type = battleship model = 6 } 
navaldivision = { dormant = yes id = { type = 10300 id = 233 } name = "Sendai" type = light_cruiser model = 2 }
navaldivision = { dormant = yes id = { type = 10300 id = 234 } name = "Kuma" type = light_cruiser model = 1	}
navaldivision = { dormant = yes id = { type = 10300 id = 235 } name = "41 Kuchikukantai" type = destroyer model = 1 }
navaldivision = { dormant = yes id = { type = 10300 id = 236 } name = "42 Kuchikukantai" type = destroyer model = 2 }
navaldivision = { dormant = yes id = { type = 10300 id = 237 } name = "43 Kuchikukantai" type = destroyer model = 2 }
landdivision = { dormant = yes id = { type = 10300 id = 238 } name = "38 Hoheishidan" extra = artillery type = infantry model = 2 brigade_model = 4	}

####dec
landdivision = { dormant = yes id = { type = 10300 id = 239 } name = "6 Hoheishidan" strength = 100 type = infantry model = 3 }
landdivision = { dormant = yes id = { type = 10300 id = 240 } name = "51 Hoheishidan" strength = 100 type = infantry model = 3 }

###43
###jan
landdivision = { dormant = yes id = { type = 10300 id = 241 } name = "20 Hoheishidan" strength = 100 type = infantry model = 3 }
##feb
landdivision = { dormant = yes id = { type = 10300 id = 242 } name = "41 Hoheishidan" strength = 100 type = infantry model = 3 }
##jun
navaldivision = { dormant = yes id = { type = 10300 id = 243 } name = "44 Kuchikukantai" type = destroyer model = 1 }
navaldivision = { dormant = yes id = { type = 10300 id = 244 } name = "45 Kuchikukantai" type = destroyer model = 2 }


##nov
navaldivision = { dormant = yes id = { type = 10300 id = 245 } name = "Oyoda" type = light_cruiser model = 3 }
navaldivision = { dormant = yes id = { type = 10300 id = 246 } name = "Agnano" type = light_cruiser model = 3 }

##mar 44
landdivision = { dormant = yes id = { type = 10300 id = 247 } name = "35 Hoheishidan" strength = 100 type = infantry model = 3 }


###bal.
navaldivision = { dormant = yes id = { type = 10300 id = 248 } name = "11th Transport Flotilla" type = transport }
navaldivision = { dormant = yes id = { type = 10300 id = 249 } name = "22nd Transport Flotilla" type = transport }



airdivision = { dormant = yes id = { type = 10300 id = 250 } name = "G/1st Daitai" strength = 40 max_strength = 60                    type = naval_bomber model = 1 }
airdivision = { dormant = yes id = { type = 10300 id = 251 } name = "F/1st Daitai" strength = 40 max_strength = 60                    type = multi_role model = 1 }

airdivision = { dormant = yes id = { type = 10300 id = 252 } name = "G/2nd Daitai" strength = 40 max_strength = 60                    type = naval_bomber model = 1 }
airdivision = { dormant = yes id = { type = 10300 id = 253 } name = "F/2nd Daitai" strength = 40 max_strength = 60                    type = multi_role model = 1 }

airdivision = { dormant = yes id = { type = 10300 id = 254 } name = "G/6th Daitai" strength = 40 max_strength = 60                    type = naval_bomber model = 1 }
airdivision = { dormant = yes id = { type = 10300 id = 255 } name = "F/6th Daitai" strength = 40 max_strength = 60                    type = multi_role model = 1 }

airdivision = { dormant = yes id = { type = 10300 id = 256 } name = "F/253rd Daitai" strength = 40 max_strength = 60                    type = multi_role model = 1 }

airdivision = { dormant = yes id = { type = 10300 id = 257 } name = "Kanoya Daitai" strength = 35 max_strength = 50                    type = naval_bomber model = 1 }
airdivision = { dormant = yes id = { type = 10300 id = 258 } name = "Mihoro Daitai" strength = 35 max_strength = 50                    type = naval_bomber model = 1 }
airdivision = { dormant = yes id = { type = 10300 id = 259 } name = "12/34/35 Sentai" strength = 35 max_strength = 50                    type = tactical_bomber model = 1 }
airdivision = { dormant = yes id = { type = 10300 id = 260 } name = "Chitose Daitai" strength = 35 max_strength = 50                    type = naval_bomber model = 1 }

airdivision = { dormant = yes id = { type = 10300 id = 261 } name = "B/1st Daitai" strength = 40 max_strength = 60                    type = cas model = 1 }

airdivision = { dormant = yes id = { type = 10300 id = 262 } name = "B/2nd Daitai" strength = 40 max_strength = 60                    type = cas model = 1 }
airdivision = { dormant = yes id = { type = 10300 id = 263 } name = "33/63/77 Sentai" strength = 50 max_strength = 80                    type = interceptor model = 1 }
airdivision = { dormant = yes id = { type = 10300 id = 264 } name = "61/75/208 Sentai" strength = 35 max_strength = 50                    type = tactical_bomber model = 1 }


####midway?
navaldivision = { dormant = yes id = { type = 10300 id = 265 } name = "Akagi" type = carrier model = 3 extra = cag brigade_model = 4                 experience = 20 }
navaldivision = { dormant = yes id = { type = 10300 id = 266 } name = "Kaga" type = carrier model = 3 extra = cag brigade_model = 4                 experience = 20 }
navaldivision = { dormant = yes id = { type = 10300 id = 267 } name = "Soryu" type = carrier model = 3 extra = cag brigade_model = 4                  experience = 20 }
navaldivision = { dormant = yes id = { type = 10300 id = 268 } name = "Hiryu" type = carrier model = 3 extra = cag brigade_model = 4                 experience = 20 }

}



