province = {
	id = 228
	air_base = {
		size = 5
		current_size = 5 
	}
}



province = {
	id = 218
	air_base = {
		size = 5
		current_size = 5 
	}

anti_air = 3

}


province = {
	id = 212
	air_base = {
		size = 5
		current_size = 5 
	}
}



country = {
    tag = SOV

	ai = "fallweiss_SOV.ai"

	capital = 218

	policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 1
        political_left = 10
        freedom = 1
        free_market = 1
        professional_army = 3
        defense_lobby = 6
        interventionism = 4
    }

	headofstate = { type = 9 id = 4001 }
	headofgovernment = { type = 9 id = 4002 }
  	foreignminister = { type = 9 id = 4034 }
  	armamentminister = { type = 9 id = 4004 }
  	ministerofsecurity = { type = 9 id = 4041 }
  	ministerofintelligence = { type = 9 id = 4046 }
  	chiefofstaff = { type = 9 id = 4051 }
  	chiefofarmy = { type = 9 id = 4008 }
  	chiefofnavy = { type = 9 id = 4062 } 
  	chiefofair = { type = 9 id = 4064 }

	# Resource Reserves		#No production in this scenario!
	oil =	65000	
	supplies =	65000

	manpower = 0 #1600
	dissent = 15

	free = 	{
		ic = 15
	}

	extra_tc = 110

	ownedprovinces =      {
		1874 218 212 221 225 226 227 228 231 220 272 240
	}
	controlledprovinces = {
		1874 218 212 221 225 226 227 228 231 220 272 240
	}
	nationalprovinces =   {
		1874 218 212 221 225 226 227 228 231 220 272 240
	}

	techapps = {
5550 # Rocket Test and Research Facility		
		
#Air Doctrines 1936
#################

1310 4030 4060 1230 1210 1220

9010 9020 9030 9040

# + 1939

9090

#
#Aircraft 1936
#############################

4010 4020 4120 4130

# + 1939

4170 4250
4220 # Basic Strategic Bomber


#
# Armor and artillery 1936
######################################

2010 2020 2030 2040 2150 2290 2300 2310 2320 2450

# + 1939

2050 2070 2100 2330 2400 2460 2510

#Industry, electronics, atomic, rocket 1939
############################

5010 5020 # Mechanized Agriculture
5050 #Basic Machine Tools
5080 5090 5100 # Construction (up to the forts)
5190 5200 # Imp. oil conversion
5470 #Nuclear

#Infantry 1936
############################

1010 1020 1110 1190

# + 1939

1030 1070 1200


6210 6300 6310

# + 1939




8010 8020 8030 8040 8050 8070

3010 3020 3030 #(Leningrad)
3070 3080 3090 #(blank-one away from Chapayev)
3130 3140 #(Kirov)
3190 3200 #(blank-two away from Kronshtadt)
3250 3260 3270 3280 #(blank-one away from Sovyetskiy Soyuz)
 #(blank)
3400 3410 3420 3430 #(Series XIV)


	}


###########################
# USSR OOB 1939
# http://www.geocities.com/kumbayaaa/warpolishsoviet1939.html
# General note - Soviet infantry givisions had extra artillery support (two artillery regiments 
# per division) - I give one artillery brigade per corps to represent that
##########################



landunit = {
	id = { type = 10846 id = 1 }
	name = "10a Armija"
	location = 221

	division = {	
		id = { type = 10846 id = 2 }
		name = "6. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}

	division = {
		id = { type = 10846 id = 3 }
		name = "33. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		}

	division = {
		id = { type = 10846 id = 4 }
		name = "121. Strelkovaya Diviziya"	
		strength = 100
		type = infantry		
		model = 1
		}
	}

landunit = {
	id = { type = 10846 id = 5 }
	name = "4ya Armija"
	location = 225

	division = {
		id = { type = 10846 id = 6 }
		name = "6. Strelkovaya Diviziya"	
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}

	division = {
		id = { type = 10846 id = 7 }
		name = "29. Tankovaya Brigada"	
		strength = 60
		type = light_armor
		model = 1
		}

	division = {
		id = { type = 10846 id = 8 }
		name = "32. Tankovaya Brigada"	
		strength = 60
		type = light_armor
		model = 1
		}

	}




landunit = {
	id = { type = 10846 id = 9 }
	name = "23. Samost. Strelkovyj Korps"
	location = 225

	division = {
		id = { type = 10846 id = 10 }
		name = "52. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		extra = artillery # NOTE: Dnieper Flotilla support
		}

	}


############ 1st Ukrainian Front

landunit = {
	id = { type = 10846 id = 11 }
	name = "15. Strelkovyj Korps"
	location = 226

	division = {
		id = { type = 10846 id = 12 }
		name = "60. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}
	division = {
		id = { type = 10846 id = 13 }
		name = "87. Strelkovaya Diviziya"
		strength = 50
		type = infantry
		model = 1
		}
	division = {
		id = { type = 10846 id = 14 }
		name = "87. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		}
	}

landunit = {
	id = { type = 10846 id = 15 }
	name = "8. Strelkovyj Korps"
	location = 226

	division = {
		id = { type = 10846 id = 16 }
		name = "81. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}

	division = {
		id = { type = 10846 id = 17 }
		name = "44. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		}

	division = {
		id = { type = 10846 id = 18 }
		name = "36. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		}


	}

landunit = {
	id = { type = 10846 id = 19 }
	name = "8. Strelkovyj Korps"
	location = 227

	division = {
		id = { type = 10846 id = 20 }
		name = "96. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}
	division = {
		id = { type = 10846 id = 21 }
		name = "97. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		}
	division = {
		id = { type = 10846 id = 22 }
		name = "38. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		
		}


	division = {
		id = { type = 10846 id = 23 }
		name = "10. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		
		}
	}


landunit = {
	id = { type = 10846 id = 24 }
	name = "2. Kavaleriyskij Korps"
	location = 227

	division = {
		id = { type = 10846 id = 25 }
		name = "3. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1		
		}
	division = {
		id = { type = 10846 id = 26 }
		name = "5. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}

	division = {
		id = { type = 10846 id = 27 }
		name = "14. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}


	division = {
		id = { type = 10846 id = 28 }
		name = "24. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		
		}

}

landunit = {
	id = { type = 10846 id = 29 }
	name = "13. Strelkovyj Korps"
	location = 228

	division = {
		id = { type = 10846 id = 30 }
		name = "72. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		}

	division = {
		id = { type = 10846 id = 31 }
		name = "99. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		}

	}

landunit = {
	id = { type = 10846 id = 32 }
	name = "4. Kavaleriyskij Korps"
	location = 231

	division = {
		id = { type = 10846 id = 33 }
		name = "32. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}


	division = {
		id = { type = 10846 id = 34 }
		name = "34. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}

	division = {
		id = { type = 10846 id = 35 }
		name = "26. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		
		}

	}

landunit = {
	id = { type = 10846 id = 36 }
	name = "5. Kavaleriyskij Korps"
	location = 231

	division = {
		id = { type = 10846 id = 37 }
		name = "9. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}


	division = {
		id = { type = 10846 id = 38 }
		name = "16. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}

	division = {
		id = { type = 10846 id = 39 }
		name = "23. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		
		}

}

landunit = {
		id = { type = 10846 id = 40 }
		name = "25. Tanovyj Korps"
		location = 231

	division = {
		id = { type = 10846 id = 41 }
		name = "4. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		
		}

	division = {
		id = { type = 10846 id = 42 }
		name = "5. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		
		}
	division = {
		id = { type = 10846 id = 43 }
		name = "1. Motorizovannaya Brigada"
		strength = 50
		type = motorized
		model = 1		
		}
}


# END OF 1st Ukrainian Front

landunit = {
	id = { type = 10846 id = 44 }
	name = "4. Strelkovyj Korps"
	location = 1874

	division = {
		id = { type = 10846 id = 45 }
		name = "50. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}
	division = {
		id = { type = 10846 id = 46 }
		name = "27. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		}
	}



landunit = {
	id = { type = 10846 id = 47 }
	name = "3ya Armija"
	location = 1874

	division = {
		id = { type = 10846 id = 48 }
		name = "5. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}
	division = {
		id = { type = 10846 id = 49 }
		name = "24. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}

	division = {
		id = { type = 10846 id = 50 }
		name = "22. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1	
		}

	division = {
		id = { type = 10846 id = 51 }
		name = "25. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		}
	}

landunit = {
	id = { type = 10846 id = 52 }
	name = "16. Strelkovyj Korps"
	location = 218 # Minsk

	division = {
		id = { type = 10846 id = 53 }
		name = "2. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}
	division = {
		id = { type = 10846 id = 54 }
		name = "100. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		}
	}

landunit = {
	id = { type = 10846 id = 55 }
	name = "3. Kavaleriyskij Korps"
	location = 218 # Minsk

	division = {
		id = { type = 10846 id = 56 }
		name = "7. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}


	division = {
		id = { type = 10846 id = 57 }
		name = "36. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}

	division = {
		id = { type = 10846 id = 58 }
		name = "6. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		
		}
}


# 1st Cavalry-Mechanized Group (North)

landunit = {
	id = { type = 10846 id = 59 }
	name = "5. Strelkovyj Korps"
	location = 221

	division = {
		id = { type = 10846 id = 60 }
		name = "4. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}
	division = {
		id = { type = 10846 id = 61 }
		name = "13. Strelkovaya Diviziya"
		strength = 100
		type = infantry
		model = 1
		}
	}

landunit = {
	id = { type = 10846 id = 62 }
	name = "6. Kavaleriyskij Korps"
	location = 212

	division = {
		id = { type = 10846 id = 63 }
		name = "4. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}


	division = {
		id = { type = 10846 id = 64 }
		name = "6. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}

	division = {
		id = { type = 10846 id = 65 }
		name = "11. Kavaleriyskaya Diviziya"
		strength = 100
		type = cavalry
		model = 1
		}
}

landunit = {
		id = { type = 10846 id = 66 }
		name = "25. Tanovyj Korps"
		location = 212

	division = {
		id = { type = 10846 id = 67 }
		name = "2. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		
		}

	division = {
		id = { type = 10846 id = 68 }
		name = "27. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		
		}
	division = {
		id = { type = 10846 id = 69 }
		name = "20. Motorizovannaya Brigada"
		strength = 50
		type = motorized
		model = 1		
		}
	division = {
		id = { type = 10846 id = 70 }
		name = "21. Tankovaya Brigada"
		strength = 60
		type = light_armor
		model = 1
		}
}

################################### END OF LAND FORCES


airunit = {
 id = { type = 10846 id = 71 }
 name = "Kiev Air Command"
 location = 238

  division = {
   id = { type = 10846 id = 72 }
   name = "36./44. IAD"
   strength = 100
   type = interceptor
   model = 1
             }
  division = {
   id = { type = 10846 id = 73 }
   name = "63./64. IAD"
   strength = 100
   type = interceptor
   model = 0
             }
  division = {
   id = { type = 10846 id = 74 }
   name = "19./62. BAD"
   strength = 100
   type = tactical_bomber
   model = 1
             }
  division = {
   id = { type = 10846 id = 75 }
   name = "14./15. IAD"
   strength = 100
   type = interceptor
   model = 0
             }
  division = {
   id = { type = 10846 id = 76 }
   name = "17. IAD"
   strength = 50
   type = interceptor
   model = 1
             }
          }


airunit = {
 id = { type = 10846 id = 77 }
 name = "Western Air Command"
 location = 218

  division = {
   id = { type = 10846 id = 78 }
   name = "11./184. IAD"
   strength = 100
   type = interceptor
   model = 0
             }
  division = {
   id = { type = 10846 id = 79 }
   name = "12./13. BAD"
   strength = 100
   type = tactical_bomber
   model = 1
             }
  division = {
   id = { type = 10846 id = 80 }
   name = "9./10. IAD"
   strength = 100
   type = interceptor
   model = 1
             }
        }

##########END##################
}





