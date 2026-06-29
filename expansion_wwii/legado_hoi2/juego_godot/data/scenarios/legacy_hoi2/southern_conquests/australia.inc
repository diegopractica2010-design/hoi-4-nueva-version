
province = {
	id = 1679
	anti_air = 1
	naval_base = {
		size = 1
		current_size = 1
		}
	air_base = {
		size = 4
		current_size = 4
		}
        supplypool = 500
        oilpool = 80
        landfort = 1
        coastalfort = 1
	}


province = {
	id = 1693
	anti_air = 1
	air_base = {
		size = 4
		current_size = 4
		}
	}
province = {
	id = 1696
	anti_air = 1
	air_base = {
		size = 4
		current_size = 4
		}
	}
province = {
	id = 1698
	anti_air = 1
	air_base = {
		size = 4
		current_size = 4
		}
	}



province = {
	id = 1722
	anti_air = 3
	naval_base = {
		size = 8
		current_size = 8
		}
	air_base = {
		size = 5
		current_size = 5
		}
	}

country = {
    tag = AST
            	control = USA

	policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 10
        political_left = 1
        free_market = 8
        freedom = 10
        professional_army = 5
        defense_lobby = 5
        interventionism = 6
    }

		headofstate = { type = 9 id = 56031 }
		headofgovernment = { type = 9 id = 56037 }
  		foreignminister = { type = 9 id = 56047 }
  		armamentminister = { type = 9 id = 56058 }
 	 	ministerofsecurity = { type = 9 id = 56082 }
  		ministerofintelligence = { type = 9 id = 56096 }
  		chiefofstaff = { type = 9 id = 56104 }
  		chiefofarmy = { type = 9 id = 56111 }
  		chiefofnavy = { type = 9 id = 56118 } 
  		chiefofair = { type = 9 id = 56124 }

	manpower = 130
	oil 	=	2000
        supplies = 650

        extra_tc = 15
	free = 		{
		oil 	=	5
		supplies =	15
                transports = 0.2
		ic = 4
	}  

	capital = 1722






	ownedprovinces =      { 1666 1667 1672 1675 1676 1677 1678 1679 1680 1693 1696 1698 1722 }
	controlledprovinces = { 1666 1667 1672 1675 1676 1677 1678 1679 1680 1693 1696 1698 1722 }
	nationalprovinces =   { 1666 1667 1672 1675 1676 1677 1678 1679 1680 1693 1696 1698 1722 }

	
	techapps = {
# UK 1941 techs
#######################

4200

4010 4020 4030 4060 # Imp. Interceptor (Spit IX)

4040 # Basic MR (Hurricane)

4120 4130 4140 # Basic medium bomber

4220 # Basic Strategic Bomber (Wellington)

4190 # Basic naval bomber

4250 # Basic transport (DC-3)

2010 2020 2040 2050 # Improved light tank

2030 2070 # Basic Medium (Crusader I/Matilda)

2290 2300 2310 2320 2330 2340 # Imp. WWII artillery (120mm)

2400 2410 # Basic AT

2450 2460 2470 # Basic Static AA

2510 2520 # Imp. AA

1010 1020 1030 1040 # Imp. infantry

1190 1200 1210 1220 # Semi-moto cavalry

1110 1120 1130 1070 # Imp. Mountain/Early para

1230 # Basic motorized

1150 1160 # Basic Marine

1310 1340 # Supply/repair - basics only 

5010 5020 5030 # Agriculture (up to fertilizers)

5050 5060 5070 # Advanced Machine Tools

5080 5090 5100 # Construction (up to the forts)

5110 5120 5130 5140 5160 5180 # Assembly lines (planes, tanks, small arms)

5190 5200 # Imp. oil conversion


5310 5320 5330 # Imp. Comp. machine

5350 5360 5370 5380 # Imp. encryption/Imp. decryption

5410 5420 # Imp. Dec. Radar

5470 5480 # Nuclear Tier 3

5550 # Rocket test site (Jet engines)

9010 9020 9030 9040 9050 9060 9070 9080 9090 9100 9110 9120 9130 9140 9190 9210 9220 9230 9240 9250 9350 # Doctrines (air)

6010 6030 6110 6120 # doctrine (land)


##doctrines
8010 8020 8030 8040 8050 8070 8100 8120 8130 8190 8200 8310
###navy
3010 3020 3030 #Basic DD
3070 3080 3090 #Basic CL
3130 3140 #Early CA
3190 #Great War BC
#hospital
14000 14010 14020
		}

	transports = 23
	escorts = 6

    convoy = { 
        id = { type = 10007 id = 99 } 
        transports = 17 
        escorts = 0 
        rare_materials = no 
        energy = no 
        metal = no 
        oil = yes 
        supplies = yes 
        path = { 1722 2113 2116 2127 2122 1677 } 
        } 



	landunit = {
 	id = { type = 10002 id = 1 }
 	name = "30th Brigade"
 	location = 1679
	leader = 54058
  		
		division = {
   		id = { type = 10002 id = 2 }  
   		name = "30th Brigade"
   		strength = 30
                max_strength = 30
   		type = infantry 
                model = 3
		}
	}


	landunit = {
 	id = { type = 10002 id = 3 }
 	name = "Kanga Force"
 	location = 1678
	leader = 54024
  		
		division = { experience = 74
   		id = { type = 10002 id = 4 }  
   		name = "Kanga Force"
   		strength = 15
                max_strength = 15
   		type = infantry 
                model = 3
		}

	}

		landunit = {
		id = { type = 10002 id = 5 }
		name = "7th Division"
		location = 1722
		leader = 54036
		
		division = { experience = 74
			id = { type = 10002 id = 6 }
			name = "7th Division"
			strength = 100
			type = garrison
			model = 2
			extra = anti_air
                brigade_model = 1
			}
		}

	landunit = {
 	id = { type = 10002 id = 7 }
 	name = "7th Brigade"
 	location = 1693
	leader = 58031
  		
		division = { experience = 74
   		id = { type = 10002 id = 8 }  
   		name = "7th Brigade"
   		strength = 30
                max_strength = 30
   		type = garrison
                model = 2
		}

	}

	landunit = {
 	id = { type = 10002 id = 9 }
 	name = "11th Brigade"
 	location = 1696
	leader = 58004
  		
		division = { experience = 74
   		id = { type = 10002 id = 10 }  
   		name = "11th Brigade"
   		strength = 30
                max_strength = 30
   		type = garrison
                model = 2
		}

	}

	landunit = {
 	id = { type = 10002 id = 11 }
 	name = "29th Brigade"
 	location = 1698
  		
		division = { experience = 74
   		id = { type = 10002 id = 12 }  
   		name = "29th Brigade"
   		strength = 30
                max_strength = 30
   		type = garrison
                model = 2
		}

	}

	landunit = {
 	id = { type = 10002 id = 13 }
 	name = "1st mot. Brigade"
 	location = 1722
  		
		division = { experience = 74
   		id = { type = 10002 id = 14 }  
   		name = "1st mot. Brigade"
   		strength = 30
                max_strength = 30
   		type = motorized
                model = 1
		}
	}

	#Australian Squadron#
	
	navalunit = {
	id = { type = 10002 id = 100 }
	name = "HM Australian Squadron"
	location = 1722 #Sydney
	base = 1722
	leader = 54074
	
		division = { experience = 74 
		id = { type = 10002 id = 101 } 
		name = "HMAS Australia" 
		type = heavy_cruiser 
		model = 2 
		}

                division = { experience = 74 
		id = { type = 10002 id = 102 } 
		name = "HMAS Hobart" 
		type = heavy_cruiser 
		model = 1 
		}

		division = { experience = 74 
		id = { type = 10002 id = 103 } 
		name = "1st Destroyer Flotilla" 
		type = destroyer 
		model = 2 
		}
}


navalunit = {
	id = { type = 10002 id = 104 }
	name = "HM Australian Squadron"
	location = 1722
	base = 1722
	leader = 54066

		division = { experience = 74 
		id = { type = 10002 id = 105 } 
		name = "HMAS Kanimbla Flotilla" 
		type = transport 
		}

		division = { experience = 74 
		id = { type = 10002 id = 106 } 
		name = "HMAS Westralia Flotilla" 
		type = transport 
		}

}


landdivision = { experience = 74 id = { type = 10002 id = 15 }  name = "3rd Division" strength = 100 type = motorized model = 2 }
landdivision = { experience = 74 id = { type = 10002 id = 16 }  name = "3rd NZ Division" strength = 100 type = infantry model = 2 }
landdivision = { experience = 74 id = { type = 10002 id = 17 }  name = "8th NZ Brigade" strength = 50 max_strength = 50 type = infantry model = 3  }





}


