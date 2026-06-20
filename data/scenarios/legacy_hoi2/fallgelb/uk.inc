#The Empire's Forts
province = {	id = 20		landfort = 0 coastalfort = 3 }#Dover
province = {
	id = 20
	anti_air = 1
	naval_base = {
		size = 5
		current_size = 5
	}
	air_base = {
		size = 10
		current_size = 10
	}
	radar_station = {
		size = 4
		current_size = 4
	}
}


country = {
    tag = ENG
	capital = 20
	ai = "fallgelb_eng.ai"

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
 		ministerofsecurity = { type = 9 id = 1083 }
  		ministerofintelligence = { type = 9 id = 1103 }
  		chiefofstaff = { type = 9 id = 1120 }
  		chiefofarmy = { type = 9 id = 1129 }
  		chiefofnavy = { type = 9 id = 1140 } 
  		chiefofair = { type = 9 id = 1147 }

	manpower = 485

	# Resource Reserves
	oil 	=	200
	supplies =	200


        extra_tc = 25

	free = 		{
		oil 	=	15
		supplies =	50
		ic = 10
	}



	ownedprovinces =      {
		#GREAT BRITAIN
                20	
                }

	controlledprovinces = {
		#GREAT BRITAIN
                20
	}

	nationalprovinces =   {
		#GREAT BRITAIN
                20
	}

	# Commonwealth Tech '36
	techapps = {
		1010 1020 1190 1200 1210 1310
		2010 2020 2150 2290 2300 2310 2400 2450
		3010 3020 3070 3080 3130 3140 3190 3200 3250 3260 3320 3400
		4010 4020 4120 4130
		5010 5020 5050 5080 5190 5310 5470 5480 5490
		8010 8020 8030 8040 8050
		9010 9020 9030
1030 1240 6010 4170
1230 1220
	}

##RAF in France
airunit = { location = 53 id = { type = 11000 id = 1 } name = "Air Component of Field Forces"
division = { id = { type = 11000 id = 2 } name = "60th (fighter) Wing" strength = 100 experience = 65 type = multi_role model = 1 }
division = { id = { type = 11000 id = 3 } name = "61st (fighter) Wing" strength = 100 experience = 65 type = multi_role model = 1 }
}
airunit = { location = 53 id = { type = 11000 id = 5 } name = "Advanced Air Striking Force"
division = { id = { type = 11000 id = 6 } name = "67th Wing" strength = 100 experience = 65 type = multi_role model = 1 }
division = { id = { type = 11000 id = 7 } name = "1/71st Wing" strength = 100 experience = 65 type = cas model = 0 }
division = { id = { type = 11000 id = 8 } name = "2/71st Wing" strength = 100 experience = 65 type = tactical_bomber model = 1 }
division = { id = { type = 11000 id = 9 } name = "75th Wing" strength = 100 experience = 65 type = cas model = 0 }
division = { id = { type = 11000 id = 10 } name = "76th Wing" strength = 100 experience = 65 type = cas model = 0 }
}
airunit = { location = 20 id = { type = 11000 id = 12 } name = "2nd Bomber Group"
division = { id = { type = 11000 id = 13 } name = "15th Sqn, 21st Sqn, 40th Sqn" strength = 100 experience = 65 type = tactical_bomber model = 1 }
division = { id = { type = 11000 id = 14 } name = "82th Sqn, 101st Sqn" strength = 100 experience = 65 type = tactical_bomber model = 1 }
division = { id = { type = 11000 id = 15 } name = "107th Sqn, 110th Sqn" strength = 100 experience = 65 type = tactical_bomber model = 1 }
}

landunit = { name = "Southern Command" location = 20 id = { type = 11000 id = 16 } 
division = { id = { type = 11000 id = 17 } name = "Dover Garrison" type = garrison strength = 60 max_strength = 60 model = 1  }
	}



landunit = { location = 44 id = { type = 11000 id = 19 } name = "BEF/I.Corps"
leader = 1023 #M.G.H. Barker

division = { id = { type = 11000 id = 20 } 
	name = "1st Infantry Division" 
	strength = 100 experience = 65 
	type = infantry model = 2 }

division = { id = { type = 11000 id = 21 } 
	name = "2nd Infantry Division" 
	strength = 100 experience = 65 
	type = infantry model = 2 }

division = { id = { type = 11000 id = 27 } 
	name = "48th (South Midland) Infantry Division" 
	strength = 100 experience = 65 
	type = cavalry model = 3 }

}

landunit = { location = 44 id = { type = 11000 id = 39 } name = "BEF/II.Corps"
leader = 1005 #A.F. Brooke

division = { id = { type = 11000 id = 22 } 
	name = "3rd Infantry Division" 
	strength = 100 experience = 65 
	type = infantry model = 2 }

division = { id = { type = 11000 id = 23 } 
	name = "4th Infantry Division" 
	strength = 100 experience = 65 
	type = infantry model = 2 }

division = { id = { type = 11000 id = 24 } 
	name = "50th (Northumbrian) Infantry Division" 
	strength = 100 experience = 65 
	type = infantry model = 2 }

}

landunit = { location = 44 id = { type = 11000 id = 40 } name = "BEF/III.Corps"
leader = 1001 #Sir R. F. Adam

division = { id = { type = 11000 id = 25 } 
	name = "42nd (East Lancashire) Infantry Division" 
	strength = 100 experience = 65 
	type = cavalry model = 3  }

division = { id = { type = 11000 id = 26 } 
	name = "44th (Home Counties) Infantry Division" 
	strength = 100 experience = 65 
	type = cavalry model = 3 }

}

landunit = { location = 44 id = { type = 11000 id = 41 } name = "BEF/Reserve Corps"
leader = 1127 #H. E. Franklyn

division = { id = { type = 11000 id = 36 } 
	name = "5th Infantry Division" 
	strength = 100 experience = 65 
	type = infantry model = 2 }

division = { id = { type = 11000 id = 29 } 
	name = "23rd (Northern) Infantry Division" 
	strength = 70  
	type = infantry model = 2  }

division = { id = { type = 11000 id = 37 } 
	name = "52nd Infantry Division" 
	strength = 100 experience = 65 
	type = cavalry model = 3 }

}
landunit = { location = 72 id = { type = 11000 id = 32 } name = "CAC"
leader = 1124 #V. M. Fortune

division = { id = { type = 11000 id = 33 } 
	name = "51st (Highland) Infantry Division" 
	strength = 100 experience = 65 
	type = cavalry model = 3 }
}


landunit = { location = 44 id = { type = 11000 id = 34 } name = "BEF/GHQ"
leader = 1138 #Lord J.Gort

division = { id = { type = 11000 id = 35 } 
	name = "BEF HQ" 
	strength = 100 experience = 80 
	type = hq model = 0 }

division = { id = { type = 11000 id = 28 } 
	name = "12th (Eastern) Infantry Division" 
	strength = 70 
	type = infantry model = 2 }

division = { id = { type = 11000 id = 30 } 
	name = "46th (North Midland) Infantry Division" 
	strength = 70
	type = infantry model = 2 }

division = { id = { type = 11000 id = 38 } 
	name = "1st Armored Division" 
	strength = 100 experience = 65 
	type = armor model = 1 }

}


}





