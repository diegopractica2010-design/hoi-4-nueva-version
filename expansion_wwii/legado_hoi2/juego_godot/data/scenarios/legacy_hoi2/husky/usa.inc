province = {
	id = 939
	anti_air = 1
	naval_base = {
		size = 8
		current_size = 8
	}
	air_base = {
		size = 10
		current_size = 10
	}
}

province = {
	id = 940
	anti_air = 1

	air_base = {
		size = 10
		current_size = 10
	}
}


province = {
	id = 937
	anti_air = 1

	air_base = {
		size = 10
		current_size = 10
	}
}


country = {
    tag = USA

	ai = "husky_usa.ai"

	# Resource Reserves

energy	 =	90000
metal	 =	90000
rare_materials 	 =	90000
oil 	 =	90000
supplies =	90000
money	 =	90000
consumer = 0.12
supply = 0.68
production = 0.00
reinforcement = 0.20


free = {
	oil = 15
	supplies = 50
	ic = 50
	}


	manpower = 1280

	extra_TC = 100


	transports = 40


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

steal_leader = 60294 #Patton
steal_leader = 60057 #Bradley
steal_leader = 60098 #Clark
steal_leader = 60249 #Lucas
steal_leader = 60352 #Truscott
steal_leader = 60231 #Keyes
steal_leader = 24101 #Juin (FRA)
steal_leader = 60319 #Ryder
steal_leader = 60360 #Walker
steal_leader = 60140 #Eagles
steal_leader = 24023 #Brosset (FRA)
steal_leader = 24087 #Monsabert
steal_leader = 60196 #Harmon
steal_leader = 60348 #Taylor
steal_leader = 60311 #Ridgway
steal_leader = 60114 #Crittenberger
steal_leader = 60286 #O'Daniel
steal_leader = 60419 #Hewitt
steal_leader = 60413 #Hall
steal_leader = 60489 #Brereton
steal_leader = 60557 #Spaatz
steal_leader = 60505 #Doolittle
steal_leader = 60089 #Cannon
steal_leader = 60560 #Twinning
steal_leader = 60506 #Eaker
steal_leader = 60427 #Kirk
steal_leader = 60543 #Norstad
steal_leader = 60548 #Quesada
steal_leader = 60503 #Davis jr
steal_leader = 60260 #McAuliffe
steal_leader = 60425 #King
steal_leader = 31036 #Mascarenhas (BRA)



	capital = 939

    ownedprovinces =      {
		940 939 937
	 }
    controlledprovinces = {
939 940 937
  }
    nationalprovinces =   {
	940 939 937
	  }

	techapps               = { 12100 12110 12120 6070  4060  4010  4020  4030  4040  4050  4120  4130  4140  4150  4190  4220  4230  4250  4260  2150 
                             2160  2010  2020  2030  2040  2050  2030  2070  2290  2300  2310  2320  2330  2340  2400  2410  2450  2460  2470  2510 
                             2520  1010  1020  1030  1190  1200  1210  1220  1230  1150  1160  1310  1340  5010  5020  5030  5050  5060  5070  5080 
                             5090  5100  5110  5120  5130  5140  5150  5160  5180  5190  5200  5210  5220  5230  5310  5320  5330  5350  5360  5370 
                             5380  5410  5420  5430  5440  5470  5480  5490  5500  9010  9020  9030  9040  9050  9060  9070  9080  9090  9100  9110 
                             9120  9130  9140  9190  9210  9220  9230  9240  9250  9350  6010  6020  6040  6050  6060  8010  8020  8030  8040  8050 
                             8060  8090  8100  8110  8160  8180  3010  3020  3030  3070  3080  3090  3100  3130  3140  3150  3190  3200  3210  3220 
                             3250  3260  3270  3280  3320  3330  3340  3350  3360  3400  3410  3420  3430  14000 14010 14020
                           }


landunit = { location = 939 name = "II Corps" id = { type = 13000 id = 1 } leader = 60057 #Bradley

division = { id = { type = 13000 id = 2 } name = "1st 'Big Red One' Division" strength = 100 type = mechanized model = 1 extra = sp_artillery brigade_model = 2 experience = 10 }
division = { id = { type = 13000 id = 3 } name = "45th Infantry Division" type = motorized model = 1  strength = 100  extra = anti_air brigade_model =1  }
division = { id = { type = 13000 id = 4 } name = "2nd Armored 'Hell on Wheels' Div." strength = 100 type = armor model = 3 extra = sp_artillery brigade_model = 2  experience = 10 }
division = { id = { type = 13000 id = 5 } name = "3rd  Infantry Division" type = motorized model = 1  strength = 100  extra = anti_air brigade_model = 1 }
}

landunit = { location = 939 name = "US Airborne Command" id = { type = 13000 id = 133 } leader = 60311 #Ridgway

division = { id = { type = 13000 id = 107 } name = "82nd Airborne 'All American' Division" strength = 100 type = paratrooper model = 1 }
}

airunit = { location = 939 base = 939 name = "XII Bomber Command" id = { type = 13000 id = 7 } leader = 60557 #Spaatz

division = { id = { type = 13000 id = 8 } name = "12 Bombardement Group" strength = 100 type = tactical_bomber model = 1 }
division = { id = { type = 13000 id = 9 } name = "57 Bombardment Group" strength = 100 type = tactical_bomber model = 2 }
division = { id = { type = 13000 id = 10 } name = "340 Bombardment Goup" strength = 100 type = tactical_bomber model = 2 }
}


airunit = { location = 939 base = 939 name = "XII Tactical Air Command" id = { type = 13000 id = 11 } leader = 60489 #Brereton

division = { id = { type = 13000 id = 12 } name = "57 Fighter Group" strength = 100 type = multi_role model = 2 }
division = { id = { type = 13000 id = 13 } name = "79 Fighter Group" strength = 100 type = multi_role model = 2 }
division = { id = { type = 13000 id = 14 } name = "27 Fighter Group" strength = 100 type =  cas model = 2 }
division = { id = { type = 13000 id = 15 } name = "86 Fighter Group" strength = 100 type = cas model = 2 }
}


airunit = { location = 940 base = 940 name = "XXII Tactical Air Command" id = { type = 13000 id = 16 } leader = 60505 #Doolittle

division = { id = { type = 13000 id = 17 } name = "350 Fighter Group" strength = 100 type = multi_role model = 2 }
division = { id = { type = 13000 id = 18 } name = "81 Fighter Group" strength = 100 type = multi_role model = 2 }
division = { id = { type = 13000 id = 19 } name = "33 Fighter" strength = 100 type =  cas model = 2 }
division = { id = { type = 13000 id = 20 } name = "31 Fighter Group" strength = 100 type = cas model = 2 }
division = { id = { type = 13000 id = 21 } name = "324 Fighter Group" strength = 100 type = multi_role model = 2 }
}

airunit = { location = 939 base = 939 name = "52nd Air Transport Group" id = { type = 13000 id = 131 }

division = { id = { type = 13000 id = 132 } name = "52nd Air Transport Wing" strength = 100 type = transport_plane model = 1 }
}



navalunit = { location = 2440 base = 939 name = "US Mediterrenean Fleet" id = { type = 13000 id = 22 } leader = 60419 #Hewitt
division = { id = { type = 13000 id = 23 } name = "Boise" strength = 100 type = light_cruiser model = 1 experience = 50 }
division = { id = { type = 13000 id = 24 } name = "Brooklyn" strength = 100 type = light_cruiser model = 2 experience = 50 }
division = { id = { type = 13000 id = 25 } name = "Savannah" strength = 100 type = light_cruiser model = 1 }
division = { id = { type = 13000 id = 26 } name = "Philadelphia" strength = 100 type = light_cruiser model = 1 experience = 50 }
division = { id = { type = 13000 id = 27 } name = "Shubrick" strength = 100 type = light_cruiser model = 1 experience = 50 }
division = { id = { type = 13000 id = 28 } name = "Jeffers" strength = 100 type = light_cruiser model = 1 experience = 50 }
division = { id = { type = 13000 id = 29 } name = "Med. Squadron No. 1-6" strength = 100 type = destroyer model = 1 experience = 50 }
division = { id = { type = 13000 id = 30 } name = "Med. Squadron No. 7-9" strength = 50 type = destroyer model = 1 experience = 50 }
division = { id = { type = 13000 id = 31 } name = "1. Med. Transport Flottilla" strength = 100 type = transport }
division = { id = { type = 13000 id = 32 } name = "2. Med. Transport Flottilla" strength = 100 type = transport }
division = { id = { type = 13000 id = 33 } name = "3. Med. Transport Flottilla" strength = 100 type = transport }
division = { id = { type = 13000 id = 34 } name = "4. Med. Transport Flottilla" strength = 100 type = transport }
division = { id = { type = 13000 id = 35 } name = "5. Med. Transport Flottilla" strength = 100 type = transport }
division = { id = { type = 13000 id = 36 } name = "6. Med. Transport Flottilla" strength = 100 type = transport }
division = { id = { type = 13000 id = 37 } name = "7. Med. Transport Flottilla" strength = 100 type = transport }
}

landunit = { location = 939 name = "7. US Army" id = { type = 13000 id = 38 } leader = 60294 #Patton
division = { id = { type = 13000 id = 39 } name = "7th US Army" strength = 100 type = hq model = 1  }
}

###Reinforcements:---through August and September
airdivision = { dormant = yes id = { type = 13000 id = 100 } name = "312 Bombardment Group" strength = 100 type =tactical_bomber model = 2 }
airdivision = { dormant = yes id = { type = 13000 id = 101 } name = "310 Bombardment Group" strength = 100 type =tactical_bomber model = 2 }
airdivision = { dormant = yes id = { type = 13000 id = 102 } name = "319 Bombardment Group" strength = 100 type =tactical_bomber model = 2 }
airdivision = { dormant = yes id = { type = 13000 id = 103 } name = "17 Bombardment Group" strength = 100 type =tactical_bomber model = 2 }
airdivision = { dormant = yes id = { type = 13000 id = 104 } name = "320 Bombardment Group" strength = 100 type =tactical_bomber model = 2 }
airdivision = { dormant = yes id = { type = 13000 id = 105 } name = "350 Fighter Group" strength = 100 type = multi_role model = 2 }


###after beachhead is secured
landdivision = { dormant = yes id = { type = 13000 id = 106 } name = "9th 'Old Reliables' Division" strength =  100 type = mechanized model = 1 extra = sp_artillery brigade_model = 2  }


###avalanche
landdivision = { dormant = yes  id = { type = 13000 id = 108 } name = "36th Infantry Division" strength =  100 type = mechanized model = 1 extra = sp_artillery brigade_model = 2  }


####French Expeditionary force (Juin)----October 43
landdivision = { dormant = yes id = { type = 13000 id = 109 } name = "3rd FF Algerian Division" strength =  100 type = bergsjaeger model = 1  }
landdivision = { dormant = yes id = { type = 13000 id = 110 } name = "2nd FF Moroccan Division" strength =  100 type = bergsjaeger model = 1  }

####Jan 44-Additional FF units
landdivision = { dormant = yes id = { type = 13000 id = 126 } name = "9th FF Colonial Division" strength = 100 type = infantry model = 1 }
landdivision = { dormant = yes id = { type = 13000 id = 127 } name = "1st FF Mountain Bde" strength = 30 max_strength = 30 type = bergsjaeger model = 1 }
landdivision = { dormant = yes id = { type = 13000 id = 128 } name = "2nd FF Mountain Bde" strength = 30 max_strength = 30 type = bergsjaeger model = 1 }
landdivision = { dormant = yes id = { type = 13000 id = 129 } name = "3rd FF Mountain Bde" strength = 30 max_strength = 30 type = bergsjaeger model = 1 }
landdivision = { dormant = yes id = { type = 13000 id = 130 } name = "4th FF Mountain Bde" strength = 30 max_strength = 30 type = bergsjaeger model = 1 }

####september 43
landdivision = { dormant = yes id = { type = 13000 id = 111 } name = "34th Infantry Division" strength =  100 type = mechanized model = 1 extra = sp_artillery brigade_model = 2  }
####nov 43
landdivision = { dormant = yes id = { type = 13000 id = 112 } name = "1st Armored Div." strength = 100 type = armor model = 3 extra = sp_artillery brigade_model = 2  }

###feb 44
landdivision = { dormant = yes id = { type = 13000 id = 113 } name = "4th FF Moroccan Division" strength =  100 type = bergsjaeger model = 1  }
landdivision = { dormant = yes id = { type = 13000 id = 114 } name = "88th Infantry Division" strength =  100 type = mechanized model = 1 extra = sp_artillery brigade_model = 2  }
landdivision = { dormant = yes id = { type = 13000 id = 115 } name = "85th Infantry Division" strength =  100 type = mechanized model = 1 extra = sp_artillery brigade_model = 2  }
landdivision = { dormant = yes id = { type = 13000 id = 116 } name = "1st FF Motorized Division" strength =  100 type = mechanized model = 1   }

####november 43
landdivision = { dormant = yes id = { type = 13000 id = 117 } name = "1st Special Service Force" strength = 40 max_strength = 40 type = marine model = 2 } #Marine is best way to represent commandos


####noveber 44 (Brazillians)
landdivision = { dormant = yes id = { type = 13000 id = 118 } name = "F.E.B. 1 DIE (BRAZ)" strength = 100 type = infantry model = 2 }
airdivision = { dormant = yes id = { type = 13000 id = 119 } name = "1st Fighter Sqdrn Braz." strength = 50 max_strength = 50 type = multi_role model = 2 }

###Units withdrawn that return to theatre
landdivision = { dormant = yes id = { type = 13000 id = 120 } name = "1st Infantry 'Big Red One'" strength = 100 type = mechanized model = 2 extra = sp_artillery brigade_model = 2 } #returns September 43
landdivision = { dormant = yes id = { type = 13000 id = 121 } name = "3rd  Infantry Division" type = motorized model = 2  strength = 100  extra = anti_air brigade_model = 2  } #returns september 43
landdivision = { dormant = yes id = { type = 13000 id = 122 } name = "9th 'Old Reliables' Division" strength =  100 type = mechanized model = 2 extra = sp_artillery brigade_model = 2  } #returns september 43

####July 44
landdivision = { dormant = yes id = { type = 13000 id = 123 } name = "91st Infantry Division" strength = 100 type = infantry model = 2 }
landdivision = { dormant = yes id = { type = 13000 id = 124 } name = "92nd Infantry Division" strength = 100 type = infantry model = 2 } #Nov 44

####Jan 45
landdivision = { dormant = yes id = { type = 13000 id = 125 } name = "10th Mountain Division" strength = 100 type = bergsjaeger model = 2 } #Jan 45


###HQ units
landdivision = { dormant = yes id = { type = 13000 id = 134 } name = "5th Army HQ" strength = 100 type = hq model = 2 }

landdivision = { dormant = yes id = { type = 13000 id = 135 } name = "Free French HQ" strength = 100 type = hq model = 1 }

landdivision = { dormant = yes id = { type = 13000 id = 136 } name = "VI Corps HQ" strength = 100 type = hq model = 1 }

}#EOF