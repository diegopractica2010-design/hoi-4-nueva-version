#NOTES SOVIET OOB
#1)Red Air Force Reinforcements of JAN40 supposedly 900planes in 15 air regiments.
#2)Red Army Reinforcements are shady at best. I have added the 13. Army and a few know division of unknown orgin.
#3)Red Army Replacements are based upon causalty statistics.

province = {
	id = 187 #Leningrad
	anti_air = 4
	landfort = 5
	coastalfort = 5
	naval_base = {
		size = 10
		current_size = 10
	}
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 133 #Murmansk
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
	id = 154 #Arkhangelsk
	anti_air = 2
	naval_base = {
		size = 5
		current_size = 5
	}
	air_base = {
		size = 5
		current_size = 5
	}
}
province = {
	id = 194 #Tallinn
	anti_air = 1
	naval_base = {
		size = 5
		current_size = 5
	}
	air_base = {
		size = 5
		current_size = 5
	}
}
province = {
	id = 200 #Pskov
	anti_air = 1
	air_base = {
		size = 5
		current_size = 5
	}
}
province = {
	id = 191 #Novgorod
	anti_air = 1
	air_base = {
		size = 5
		current_size = 5
	}
}
province = {
	id = 152 #Karelia
	anti_air = 1
	air_base = {
		size = 5
		current_size = 5
	}
}



country = {
    tag = SOV

	capital = 187
	ai = "winterwar_sov.ai"

	policy = {
        date = { year = 1939 month = november day = 29 }
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

	# Resource Reserves
	supplies = 1000
	oil = 500
	extra_tc = 55

	free = 		{
		oil 	=	10
		supplies =	30
		ic = 35
	}

		#Reinforcement come by events in this scenario

	manpower = 100	#Replaces will be added by events
	dissent = 15
	diplomacy = {
   				# The Mongolian Puppet is not involved here.
	 		}

	ownedprovinces =      {
		133 134 135 150 152 151 183 185 186 187 188 192 193 195 194
		196 199 200 191 189 184 153 154 1771
	}
	controlledprovinces = {
		133 134 135 150 152 151 183 185 186 187 188 192 193 195 194
		196 199 200 191 189 184 153 154 1771
	}
	nationalprovinces =   {
		133 134 135 150 152 151 183 185 186 187 188 192 193 195 194
		196 199 200 191 189 184 153 154 1771
	}

	techapps = {
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


landunit = {
 id = { type = 30008 id = 1 }
 name = "Leningrad Military District"
 leader = 10118 # K.A. Meretskov
 location = 187

  division = {
	locked = yes
   id = { type = 30008 id = 2 }
   name = "Leningrad MD HQ"
   strength = 30
   max_strength = 30
   type = hq
   extra = artillery
   brigade_model = 2
             }
}
###############
#   7. Army   #
###############
landunit = {
 id = { type = 30008 id = 3 }
 name = "7. Army"
 leader = 9976 # V.F. Jakolev
 location = 187

  division = {
   id = { type = 30008 id = 4 }
   name = "7. Army HQ"
   strength = 30
   max_strength = 30
   type = hq
   extra = artillery
   brigade_model = 2
             }
}
###################
landunit = {
 id = { type = 30008 id = 5 }
 name = "19. Corps"				#Subunit of 7th Army
 #	leader = X # V.F. Jakolev
 location = 187

  division = {
   id = { type = 30008 id = 7 }
   name = "24. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 1
             }

  division = {
   id = { type = 30008 id = 8 }
   name = "43. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 1
             }

  division = {
   id = { type = 30008 id = 9 }
   name = "70. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 1
             }
  division = {
   id = { type = 30008 id = 10 }
   name = "123. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

  division = {
   id = { type = 30008 id = 11 }
   name = "40. Tankovaya Brig."
   strength = 35
   max_strength = 35
   type = light_armor
   model = 1
             }
          }
#####################
landunit = {
 id = { type = 30008 id = 12 }
 name = "50. Corps"				#Subunit of 7th Army
 #	leader = X # F.D. Gorolenko
 location = 188

  division = {
   id = { type = 30008 id = 14 }
   name = "49. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 1
             }

  division = {
   id = { type = 30008 id = 15 }
   name = "90. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 1
             }

  division = {
   id = { type = 30008 id = 16 }
   name = "142. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 1
             }

  division = {
   id = { type = 30008 id = 17 }
   name = "35. Tankovaya Brig."
   strength = 30
   max_strength = 30
   type = light_armor
   model = 1
             }
          }
##################
landunit = {
 id = { type = 30008 id = 18 }
 name = "7. Army Reserve"				#Subunit of 7th Army
 leader = 9878 # N.E. Chibisov #Chief of Staff/7.Army
 location = 186

  division = {
   id = { type = 30008 id = 19 }
   name = "7. Army Reserve HQ"
   strength = 30
   max_strength = 30
   type = hq
   extra = artillery
   brigade_model = 1
             }

  division = {
   id = { type = 30008 id = 20 }
   name = "138. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

  division = {
   id = { type = 30008 id = 21 }
   name = "20. Tankovaya Brig."
   strength = 30
   max_strength = 30
   type = light_armor
   model = 1
             }
}
####################
landunit = {
	id = { type = 30011 id = 18 }
	name = "Garrison"
	location = 186
	division = {
		id = { type = 30008 id = 22 }
		locked = yes
		name = "150. Replacement Div."	#150. Strelkovaya Diviziya
		strength = 30
		max_strength = 30
		type = garrison
	}
	division = {
		id = { type = 30008 id = 23 }
		locked = yes
		name = "136. Replacement Div."	#136. Strelkovaya Diviziya
		strength = 30
		type = garrison
		max_strength = 30
	}
	division = {
		id = { type = 30008 id = 42 }
		locked = yes
		name = "34. Replacement Brig."	#34. Tankovaya Brig.
		type = garrison
		strength = 30
		max_strength = 30
	}
}

####################
landunit = {
 id = { type = 30008 id = 24 }
 name = "10. Tank Corps"				#Subunit of 7th Army
 leader = 10239 # P.L. Romanenko
 location = 186

  division = {
   id = { type = 30008 id = 26 }
   name = "1. Tankovaya Brig."
   strength = 35
   max_strength = 35
   type = light_armor
   model = 1
             }

  division = {
   id = { type = 30008 id = 27 }
   name = "13. Tankovaya Brig."
   strength = 30
   max_strength = 30
   type = light_armor
   model = 1
             }
          }

###############
#   8. Army   #
###############
landunit = {
 id = { type = 30008 id = 28 }
 name = "8. Army"
 #	leader = X # I.N. Habarov
 location = 152

  division = {
   id = { type = 30008 id = 29 }
   name = "8. Army HQ"
   strength = 30
   max_strength = 30
   type = hq
   extra = artillery
   brigade_model = 2
             }
}
###################
landunit = {
 id = { type = 30008 id = 30 }
 name = "1. Corps"				#Subunit of 8th Army
 leader = 10167 # R.I. Panin
 location = 152

  division = {
   id = { type = 30008 id = 32 }
   name = "139. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

  division = {
   id = { type = 30008 id = 33 }
   name = "155. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 0
             }
          }
#####################
landunit = {
 id = { type = 30008 id = 34 }
 name = "56. Corps"				#Subunit of 8th Army
 leader = 9870 # A.I. Cherepanov
 location = 152

  division = {
   id = { type = 30008 id = 36 }
   name = "18. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 1
             }

  division = {
   id = { type = 30008 id = 37 }
   name = "56. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 2
             }

  division = {
   id = { type = 30008 id = 38 }
   name = "168. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 1
             }
          }
##################
landunit = {
 id = { type = 30008 id = 39 }
 name = "8. Army Reserve"				#Subunit of 8th Army
 #	leader = X # ??? #Unknown
 location = 152

  division = {
   id = { type = 30008 id = 41 }
   name = "75. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 1
             }
}
###############
#   9. Army   #
###############
landunit = {
 id = { type = 30008 id = 43 }
 name = "9. Army"
 #	leader = X # M.P. Duhanov
 location = 150

  division = {
   id = { type = 30008 id = 44 }
   name = "9. Army HQ"
   strength = 30
   max_strength = 30
   type = hq
   extra = artillery
   brigade_model = 2
             }
}
###################
landunit = {
 id = { type = 30008 id = 45 }
 name = "47. Corps"				#Subunit of 9th Army
 #	leader = X # I.F. Dashitshev
 location = 150

  division = {
   id = { type = 30008 id = 47 }
   name = "122. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

  division = {
   id = { type = 30008 id = 48 }
   name = "163. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }
          }
#####################
landunit = {
 id = { type = 30008 id = 49 }
 name = "Special Corps"				#Subunit of 9th Army
 #	leader = X # M.S. Shmyrov
 location = 135

 
  division = {
   id = { type = 30008 id = 51 }
   name = "54. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 0
             }
  division = {
   id = { type = 30008 id = 52 }
   name = "273./104. Mountain Diviziya"	#attached to 54.RifleDiv,parent though 104.MntDiv/14.Army
   strength = 30
   max_strength = 30
   type = bergsjaeger
   model = 1
             }
  division = {
   id = { type = 30008 id = 53 }
   name = "44. Strelkovaya Diviziya"
   strength = 40						#Still in transit
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 1
             }
          }
###############
#   14. Army   #
###############
landunit = {
 id = { type = 30008 id = 54 }
 name = "14. Army"
 #	leader = X # M.P. Duhanov
 location = 133

  division = {
   id = { type = 30008 id = 55 }
   name = "14. Army HQ"
   strength = 30
   max_strength = 30
   type = hq
   extra = artillery
   brigade_model = 2
             }
  division = {
   id = { type = 30008 id = 56 }
   name = "14. Strelkovaya Diviziya"
   strength = 60						#Understrengthed
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 0
             }
  division = {
   id = { type = 30008 id = 57 }
   name = "52. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
   extra = artillery
   brigade_model = 1
             }
}
landunit = {
 id = { type = 30008 id = 58 }
 name = "104. Mountain Diviziya"
 location = 133

  division = {
   id = { type = 30008 id = 59 }
   name = "95. Strelkovaya Reg."		#attached to 104. Mountain Diviziya
   strength = 25						#Understrengthed
   max_strength = 30
   type = infantry
	model = 2
             }
  division = {
   id = { type = 30008 id = 60 }
   name = "217./104. Mountain Diviziya"
   strength = 25						#Understrengthed
   max_strength = 30
   type = bergsjaeger
   model = 1
             }
  division = {
   id = { type = 30008 id = 61 }
   name = "242./104. Mountain Diviziya"
   strength = 25						#Understrengthed
   max_strength = 30
   type = bergsjaeger
   model = 1
            }
}
################################
# Red Army Reinforcements #
################################

# During DEC 1939

landdivision = {
	dormant = yes
   id = { type = 30008 id = 83 }
   name = "150. Strelkovaya Diviziya"	#Removes depot
   strength = 60
   type = infantry
	model = 2
             }
  landdivision = {
  	dormant = yes
   id = { type = 30008 id = 84 }
   name = "136. Strelkovaya Diviziya"	#Removes depot
   strength = 60
   type = infantry
	model = 2
             }

 landdivision = {
 	dormant = yes
   id = { type = 30008 id = 85 }
   name = "34. Tankovaya Brig."		#Removes depot
   type = light_armor
   model = 1
   strength = 30
   max_strength = 30
             }

# 25. DEC 1939 - 13. Army Reinforcements

  landdivision = {
  	dormant = yes
   id = { type = 30008 id = 62 }
   name = "13. Army HQ"
   strength = 30
   max_strength = 30
   type = hq
   extra = artillery
   brigade_model = 2
             }

  landdivision = {
  	dormant = yes
   id = { type = 30008 id = 63 }
   name = "23. Corps/Core Elem."				#Subunit of 13. Army
   strength = 80
   type = infantry
   extra = artillery
   brigade_model = 1
             }
landdivision = {
	dormant = yes
   id = { type = 30008 id = 64 }
   name = "4. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

  landdivision = {
  	dormant = yes
   id = { type = 30008 id = 65 }
   name = "15. Corps/Core Elem." 			#Subunit of 13. Army
   strength = 80
   type = infantry
   extra = artillery
   brigade_model = 1
             }
  landdivision = {
  	dormant = yes
   id = { type = 30008 id = 66 }
   name = "8. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

  landdivision = {
  	dormant = yes
   id = { type = 30008 id = 67 }
   name = "3. Tank Corps/Core Elem."				#Subunit of 13. Army
   strength = 80
   type = infantry
   extra = artillery
   brigade_model = 1
             }
  landdivision = {
  	dormant = yes
   id = { type = 30008 id = 68 }
   name = "17. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

# 1. FEB 1940 - 13. Army Reinforcements

landdivision = {
	dormant = yes
   id = { type = 30008 id = 69 }
   name = "97. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

landdivision = {
	dormant = yes
   id = { type = 30008 id = 70 }
   name = "62. Strelkovaya Diviziya"	#Belonged to 15. Corps
   strength = 80
   type = infantry
	model = 2
             }

# 1. FEB 1940 - Independent (?) Reinforcements

landdivision = {
	dormant = yes
   id = { type = 30008 id = 71 }
   name = "84. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

landdivision = {
	dormant = yes
   id = { type = 30008 id = 72 }
   name = "51. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

landdivision = {
	dormant = yes
   id = { type = 30008 id = 73 }
   name = "173. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

# During FEB 1940 - 13. Army Reinforcements

landdivision = {
	dormant = yes
   id = { type = 30008 id = 74 }
   name = "7. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

landdivision = {
	dormant = yes
   id = { type = 30008 id = 75 }
   name = "136. Strelkovaya Diviziya"		#Belonged to 15. Corps
   strength = 80
   type = infantry
	model = 2
             }

landdivision = {
	dormant = yes
   id = { type = 30008 id = 76 }
   name = "91. Strelkovaya Diviziya"		# Army Reserve
   strength = 80
   type = infantry
	model = 2
             }

landdivision = {
	dormant = yes
   id = { type = 30008 id = 77 }
   name = "95. Strelkovaya Diviziya"		# Army Reserve
   strength = 80
   type = infantry
	model = 2
             }

  landdivision = {
  	dormant = yes
   id = { type = 30008 id = 78 }
   name = "24. Tankovaya Brig."
   type = light_armor
   model = 1
   strength = 30
   max_strength = 30
             }

# 15. FEB - 5. MARCH 1940 - 13. Army (?) Reinforcements

landdivision = {
	dormant = yes
   id = { type = 30008 id = 79 }
   name = "113. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

landdivision = {
	dormant = yes
   id = { type = 30008 id = 80 }
   name = "100. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }
landdivision = {
	dormant = yes
   id = { type = 30008 id = 81 }
   name = "80. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }
landdivision = {
	dormant = yes
   id = { type = 30008 id = 82 }
   name = "86. Strelkovaya Diviziya"
   strength = 80
   type = infantry
	model = 2
             }

#############################
#		Soviet Navy			#
#############################

 
 navalunit = {
	 id = { type = 10848 id = 6 }
	 name = "Red Banner Baltic Fleet"
	 leader = 10413 # V.P.Drozd
	 location = 187 #Leningrad

  division = {   id = { type = 10849 id = 7 }   name = "Marat"  type = battleship model = 0 }
  division = {   id = { type = 10849 id = 8 }   name = "Gangut"  type = battleship model = 0 }
  division = {   id = { type = 10849 id = 9 }   name = "Kirov" type = light_cruiser model = 1 }
  division = {   id = { type = 10849 id = 10 }   name = "3. Flotiliya Esmintsev"  type = destroyer model = 0 }
  division = {   id = { type = 10849 id = 11 }   name = "4. Flotiliya Esmintsev"  type = destroyer model = 0 }
  division = {   id = { type = 10849 id = 12 }   name = "3. Flotiliya Podlodok"  type = submarine model = 1 }
  division = {   id = { type = 10849 id = 13 }   name = "4. Flotiliya Podlodok"  type = submarine model = 1 }
  division = {   id = { type = 10849 id = 14 }   name = "5. Flotiliya Podlodok"  type = submarine model = 0 }
  division = {   id = { type = 10849 id = 15 }   name = "6. Flotiliya Podlodok"  type = submarine model = 0 }
  division = {   id = { type = 10849 id = 16 }   name = "7. Flotiliya Podlodok"  type = submarine model = 0 }

 }

###############################
###############################

airunit = {
 id = { type = 30009 id = 1 }
#	leader = X #J.Puthin
 name = "Leningrad Air Command"
 location = 187

  division = {
   id = { type = 30009 id = 2 }
   name = "1. Bomber Reg"
   strength = 60
   max_strength = 60
   type = tactical_bomber
   model = 2
             }
  division = {
   id = { type = 30009 id = 3 }
   name = "2. Bomber Reg"
   strength = 60
   max_strength = 60
   type = cas
   model = 0
             }
  division = {
   id = { type = 30009 id = 4 }
   name = "1. Escort Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
  division = {
   id = { type = 30009 id = 5 }
   name = "2. Escort Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
  division = {
   id = { type = 30009 id = 6 }
   name = "1. Fighter Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
        }
airunit = {
 id = { type = 30009 id = 7 }
#	leader = X # V. Jermatsenkov
 name = "Tallinn Air Command"
 location = 194

  division = {
   id = { type = 30009 id = 8 }
   name = "3. Bomber Reg"
   strength = 40
   max_strength = 60
   type = tactical_bomber
   model = 2
             }
  division = {
   id = { type = 30009 id = 9 }
   name = "4. Bomber Reg"
   strength = 40
   max_strength = 60
   type = tactical_bomber
   model = 2
             }
  division = {
   id = { type = 30009 id = 10 }
   name = "3. Escort Reg"
   strength = 30
   max_strength = 60
   type = multi_role
   model = 0
             }
  division = {
   id = { type = 30009 id = 11 }
   name = "4. Escort Reg"
   strength = 30
   max_strength = 60
   type = multi_role
   model = 0
             }
  division = {
   id = { type = 30009 id = 12 }
   name = "2. Fighter Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
        }
  airunit = {
 id = { type = 30009 id = 13 }
leader = 10476 # I. Kopets
 name = "Karelian Air Command"
 location = 152

  division = {
   id = { type = 30009 id = 14 }
   name = "5. Bomber Reg"
   strength = 20
   max_strength = 60
   type = tactical_bomber
   model = 2
             }
  division = {
   id = { type = 30009 id = 15 }
   name = "6. Bomber Reg"
   strength = 20
   max_strength = 60
   type = tactical_bomber
   model = 2
             }
  division = {
   id = { type = 30009 id = 16 }
   name = "5. Escort Reg"
   strength = 10
   max_strength = 60
   type = multi_role
   model = 0
             }
  division = {
   id = { type = 30009 id = 17 }
   name = "6. Escort Reg"
   strength = 10
   max_strength = 60
   type = multi_role
   model = 0
             }
  division = {
   id = { type = 30009 id = 18 }
   name = "3. Fighter Reg"
   strength = 40
   max_strength = 60
   type = multi_role
   model = 0
             }
        }
 airunit = {
 id = { type = 30009 id = 19 }
 leader = 10477 # S. Krasovskij
 name = "Murmansk Air Command"
 location = 133

  division = {
   id = { type = 30009 id = 20 }
   name = "7. Bomber Reg"
   strength = 35
   max_strength = 60
   type = tactical_bomber
   model = 1
             }
  division = {
   id = { type = 30009 id = 21 }
   name = "8. Bomber Reg"
   strength = 35
   max_strength = 60
   type = tactical_bomber
   model = 1
             }
  division = {
   id = { type = 30009 id = 22 }
   name = "7. Escort Reg"
   strength = 20
   max_strength = 60
   type = multi_role
   model = 0
             }
  division = {
   id = { type = 30009 id = 23 }
   name = "8. Escort Reg"
   strength = 20
   max_strength = 60
   type = multi_role
   model = 0
             }
  division = {
   id = { type = 30009 id = 24 }
   name = "4. Fighter Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
        }

################################
# Red Air Force Reinforcements #
################################

# JAN 1940

airdivision = {
		dormant = yes
   id = { type = 30009 id = 25 }
   name = "9. Bomber Reg"
   strength = 60
   max_strength = 60
   type = tactical_bomber
   model = 1
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 26 }
   name = "10. Bomber Reg"
   strength = 60
   max_strength = 60
   type = tactical_bomber
   model = 1
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 27 }
   name = "11. Bomber Reg"
   strength = 60
   max_strength = 60
   type = tactical_bomber
   model = 1
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 28 }
   name = "12. Bomber Reg"
   strength = 60
   max_strength = 60
   type = tactical_bomber
   model = 1
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 29 }
   name = "13. Bomber Reg"
   strength = 60
   max_strength = 60
   type = tactical_bomber
   model = 1
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 30 }
   name = "14. Bomber Reg"
   strength = 60
   max_strength = 60
   type = tactical_bomber
   model = 1
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 31 }
   name = "15. Bomber Reg"
   strength = 60
   max_strength = 60
   type = tactical_bomber
   model = 1
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 32 }
   name = "9. Escort Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 33 }
   name = "10. Escort Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 34 }
   name = "11. Escort Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 35 }
   name = "12. Escort Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 36 }
   name = "5. Fighter Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 37 }
   name = "6. Fighter Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 38 }
   name = "7. Fighter Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
             }
airdivision = {
		dormant = yes
   id = { type = 30009 id = 39 }
   name = "8. Fighter Reg"
   strength = 60
   max_strength = 60
   type = multi_role
   model = 0
            }
}































                                      