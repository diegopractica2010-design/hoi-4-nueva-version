province = { id = 475   anti_air = 2 } #Slavkov/Brno
province = { id = 476   anti_air = 1 } #Bratislava 
  country = { 
    tag = SLO
	
	
	control = GER
	puppet = GER

	# Resource Reserves
	energy	=	0   metal	=	0	rare_materials =	0	oil =	300	supplies =	2500
	manpower = 10

	capital = 477

	free = {
		ic =4
	supplies = 10
	oil = 1
	}

    	
	techapps               = { 1010 1020 1030 1070 1080 1110 1120 1190 1200 1210 1220 1230 1310 1340 2010 2020 2030 2040 2050 2070 2150 2290 2300 2310
                             2320 2330 2400 2410 2450 2460 2510 4010 4020 4030 4040 4050 4120 4130 4140 4150 4170 4190 4200 4220 4250 5010 5020 5030
                             5050 5060 5070 5080 5090 5100 5110 5190 5200 5210 5220 5310 5320 5350 5360 5410 5550 6210 6220 6230 6240 6250 6260 9010
                             9020 9030 9040 9050 9060 9070 9080 9090 9100 9110 9120 9140 9190 9200 9270 9290
                           }

policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 2
        political_left = 3
        free_market = 3
        freedom = 3
        professional_army = 6
        defense_lobby = 9
        interventionism = 7
    }



#Ruling Cabinet
  headofstate = { type = 9 id = 31031 }
  headofgovernment = { type = 9 id = 31034 }
  foreignminister = { type = 9 id = 31037 }
  armamentminister = { type = 9 id = 31042 }
  ministerofsecurity = { type = 9 id = 31048 }
  ministerofintelligence = { type = 9 id = 31055 }
  chiefofstaff = { type = 9 id = 31060 }
  chiefofarmy = { type = 9 id = 31063 }
  chiefofnavy = { type = 9 id = 31066 } 
  chiefofair = { type = 9 id = 31069 }

    ownedprovinces =      {
		475 478 477 490 476
	}
    controlledprovinces = {
		475 478 477 490 476
	}
    nationalprovinces =   {
		475 478 477 490 476
	}

landunit = {
 id = { type = 30011 id = 1 }
 name = "Slovak Combat Group"
 location = 477

  division = {
   id = { type = 30011 id = 2 }
   name = "1. Pesi divize"
   strength = 100
   type = infantry
             }

  division = {
   id = { type = 30011 id = 3 }
   name = "2. Pesi divize"
   strength = 100
   type = infantry
             }
	}
}