province = {
	id = 1191 #Kagoshima
	air_base = {
		size = 10
		current_size = 10
		}
	naval_base = {
		size = 5
		current_size = 5
		}
	}

province = {
	id = 1190 #Fukuoka
	air_base = {
		size = 10
		current_size = 10
		}
	naval_base = {
		size = 3
		current_size = 3
		}
	}

province = {
	id = 1189 #Shikoku
	air_base = {
		size = 5
		current_size = 5
		}
	naval_base = {
		size = 3
		current_size = 3
		}
	}

province = {
	id = 1188 #Hiroshima
	air_base = {
		size = 8
		current_size = 8
		}
	naval_base = {
		size = 5
		current_size = 5
		}
	}

province = {
	id = 1187 #Osaka
	air_base = {
		size = 10
		current_size = 10
		}
	naval_base = {
		size = 8
		current_size = 8
		}
	}

province = {
	id = 1186 #Kanozawa
	air_base = {
		size = 3
		current_size = 3
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = {
	id = 1185 #Nagoya
	air_base = {
		size = 8
		current_size = 8
		}
	naval_base = {
		size = 5
		current_size = 5
		}
	}

province = {
	id = 1184 #Tokyo
	air_base = {
		size = 10
		current_size = 10
		}
	naval_base = {
		size = 8
		current_size = 8
		}
	}

province = {
	id = 1183 #Niigata
	air_base = {
		size = 5
		current_size = 5
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = {
	id = 1182 #Fukushima
	air_base = {
		size = 5
		current_size = 5
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = {
	id = 1181 #Akita
	air_base = {
		size = 3
		current_size = 3
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = {
	id = 1180 #Sendai
	air_base = {
		size = 3
		current_size = 3
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = {
	id = 1179 #Sapporo
	air_base = {
		size = 2
		current_size = 2
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = {
	id = 1178 #Asuhikawa
	air_base = {
		size = 2
		current_size = 2
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = {
	id = 1324 #Taiwan
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = {
	id = 1196 #Busan
	air_base = {
		size = 1
		current_size = 1
		}
	naval_base = {
		size = 2
		current_size = 2
		}
	oilpool = 1000
	supplypool = 10000 
	}

province = {
	id = 1199 #Seoul
	air_base = {
		size = 6
		current_size = 6
		}
	naval_base = {
		size = 2
		current_size = 2
		}
	}
province = {
	id = 1323 #Taibei
	air_base = {
		size = 2
		current_size = 2
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	supplypool = 10000
	} 



country = {
	tag = JAP

	capital = 1184

	policy = {
		date = { year = 0 month = january day = 0 }
		democratic = 3
		political_left = 3
		freedom = 3
		free_market = 3
		professional_army = 3
		defense_lobby = 8
		interventionism = 8
		}


	headofstate = { type = 9 id = 5001 }
	headofgovernment = { type = 9 id = 5043 }
	foreignminister = { type = 9 id = 5067 }
	armamentminister = { type = 9 id = 5094 }
	ministerofsecurity = { type = 9 id = 5125 }
	ministerofintelligence = { type = 9 id = 5145 }
	chiefofstaff = { type = 9 id = 5157 }
	chiefofarmy = { type = 9 id = 5167 }
	chiefofnavy = { type = 9 id = 5201 }
	chiefofair = { type = 9 id = 5196 }

	manpower = 1000

	oil = 1000
	supplies = 5000

	transports = 100
	escorts = 10

	extra_tc = 80

	free = {
		supplies = 100
		oil = 10
#		ic = 45
		}

	ownedprovinces = {
	1191 1190 1189 1188 1187 1186 1185 1184 1183 1182 1181 1180 1179 1178
	1177 1176 1174
	1194 1195 1196 1197 1198 1199
	1322 1323 1324
	1201 1200 1393 1391 1392 1376
	1193 1599
	1626 1627
	}
	controlledprovinces = {
	1191 1190 1189 1188 1187 1186 1185 1184 1183 1182 1181 1180 1179 1178
	1194 1195 1196 1197 1198 1199
	1322 1323 1324
	}
	nationalprovinces = {
	1191 1190 1189 1188 1187 1186 1185 1184 1183 1182 1181 1180 1179 1178
	1177 1176 1174
	}

	techapps = {
# JAP 1944 techs
#######################

4010 4020 4030 4040 4050 4060 4070 4080 4090 4100 4110 # All advanced fighter models

4120 4130 4140 4150 4160 # Adv. medium bomber

4190 4200 4210 # Adv. naval bomber

4250 # Basic transport

4220 4230 # Imp. strategic bomber (Shinzan)

2150 # Basic Armoured Car

2010 2020 2030 2040 2050 # Imp. light tank

2030 2070 2080 # Imp. medium tanks

2170 2180 # Basic tank destroyer

2220 # Early SP guns

2290 2300 2310 2320 2330 # Medium artillery

2400 2410 # Basic AT

2450 2460 2470 2480 # Imp. Static AA

2510 2520 # Imp AA

1010 1020 1030 1040 # Imp. infantry

1190 1200 1210 1220 # Semi-mot Cavalry

1110 1120 1070 # Basic Mountain/Early. para

1230 1240 # Imp. motorized

1150 1160 # Basic Marine

1310 1320 1340 1350 # supply/repair techs - 1

5010 # Agriculture (basic)

5050 5060 # Improved Machine Tools

5080 5090 5100 # Construction (up to the forts)

5110 5120 5130 5140 5150 # Assembly lines (planes, ships)

5190 5200 # Imp. oil conversion

5350 5360 # Basic encryption/decryption

5410 5420 # Imp. Dec. Radar

5470 # Nukes I

5550 5560 5570 # Jet and rocket engines (from Germans)

9010 9020 9030 9040 9050 9060 9080 9090 9100 9110 9120 9130 9190 9200 9210 9220 9230 9240 9250 9260 9270 9280 9290 9300 9310 9320 9330 9340 9350 9360 9370 9380 9390 9400 9410 9420 # Doctrines (air)

6010 6030 6110 6120 6130 6160 # doctrines (land)

8010 8020 8030 8040 8050 8060 8090 8100 8110 8180 8230 8320 8140 8250

3010 3020 3030 3040 3050
3070 3080 3090 3100
3130 3140 3150
3190 3200 3210
3250 3260 3270 3280
3320 3330 3340 3350 3360 3370
3400 3410 3420 3430

1050 4280 4170 9070 5070 5310 5320
14000 14000 14020 # Hospital Techs
12100 12110 12120 # EscortCarrier Techs
}


	landunit = {
		id = { type = 10200 id = 1 }
		name = "56th Army"
		location = 1190 #Fukuoka
		division = { id = { type = 10200 id = 2 } name = "57th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 3 } name = "145th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 4 } name = "312nd Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 5 } name = "351st Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 6 } name = "4th Independent Tank Brigade" strength = 50 max_strength = 50 type = armor model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 7 }
		name = "40th Army"
		location = 1191 #Kagoshima
		division = { id = { type = 10200 id = 8 } name = "77th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 9 } name = "146th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 10 } name = "206th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 11 } name = "216th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 12 } name = "303rd Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 13 }
		name = "57th Army"
		location = 1191 #Kagoshima
		division = { id = { type = 10200 id = 14 } name = "25th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 15 } name = "86th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 16 } name = "154th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 17 } name = "156th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 18 } name = "212th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 19 } name = "5th Independent Tank Brigade" strength = 50 max_strength = 50 type = armor model = 3 }
		division = { id = { type = 10200 id = 20 } name = "6th Independent Tank Brigade" strength = 50 max_strength = 50 type = armor model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 21 }
		name = "1st Army"
		location = 1184 #Tokyo
		division = { id = { type = 10200 id = 22 } name = "1st Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 23 } name = "2nd Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 24 } name = "3rd Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 25 } name = "4th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 26 } name = "5th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 27 } name = "6th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 28 } name = "1st Independent Tank Brigade" strength = 50 max_strength = 50 type = armor model = 3 }
		division = { id = { type = 10200 id = 29 } name = "2nd Independent Tank Brigade" strength = 50 max_strength = 50 type = armor model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 30 }
		name = "2nd Army"
		location = 1187 #Osaka
		division = { id = { type = 10200 id = 31 } name = "7th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 32 } name = "8th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 33 } name = "9th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 34 } name = "10th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 35 } name = "3rd Independent Tank Brigade" strength = 50 max_strength = 50 type = armor model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 36 }
		name = "3rd Army"
		location = 1182 #Fukushima
		division = { id = { type = 10200 id = 37 } name = "11th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 38 } name = "12th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 39 } name = "13th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 40 } name = "14th Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 41 }
		name = "4th Army"
		location = 1183 #Niigata
		division = { id = { type = 10200 id = 42 } name = "15th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 43 } name = "16th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 44 } name = "17th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 45 } name = "18th Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 46 }
		name = "5th Army"
		location = 1185 #Nagoya
		division = { id = { type = 10200 id = 47 } name = "19th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 48 } name = "20th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 49 } name = "21st Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 50 } name = "22nd Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 51 }
		name = "6th Army"
		location = 1188 #Hiroshima
		division = { id = { type = 10200 id = 52 } name = "23rd Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 53 } name = "24th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 54 } name = "26th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 55 } name = "27th Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 56 }
		name = "7th Army"
		location = 1180 #Sendai
		division = { id = { type = 10200 id = 57 } name = "28th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 58 } name = "29th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 59 } name = "30th Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 60 }
		name = "8th Army"
		location = 1189 #Shikoku
		division = { id = { type = 10200 id = 61 } name = "31st Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 62 } name = "32nd Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 63 } name = "33rd Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 64 } name = "34th Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 65 }
		name = "9th Army"
		location = 1186 #Kanozawa
		division = { id = { type = 10200 id = 66 } name = "35th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 67 } name = "36th Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 68 }
		name = "10th Army"
		location = 1181 #Akita
		division = { id = { type = 10200 id = 69 } name = "37th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 70 } name = "38th Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 71 }
		name = "11th Army"
		location = 1179 #Sapporo
		division = { id = { type = 10200 id = 72 } name = "39th Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 73 }
		name = "12th Army"
		location = 1178 #Asahikawa
		division = { id = { type = 10200 id = 74 } name = "40th Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 75 }
		name = "30th Army"
		location = 1199 #Seoul
		division = { id = { type = 10200 id = 76 } name = "41st Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 77 } name = "42nd Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 78 } name = "43rd Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 79 } name = "44th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 80 } name = "45th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 81 } name = "46th Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 82 }
		name = "34th Army"
		location = 1198 #Chunchon
		division = { id = { type = 10200 id = 83 } name = "47th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 84 } name = "48th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 85 } name = "49th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 86 } name = "50th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 87 } name = "51st Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 88 } name = "52nd Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 89 }
		name = "13th Army"
		location = 1323 #Taibei
		division = { id = { type = 10200 id = 90 } name = "53rd Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 91 } name = "54th Infantry Division" strength = 100 type = infantry model = 3 }
		division = { id = { type = 10200 id = 92 } name = "55th Infantry Division" strength = 100 type = infantry model = 3 }
		}

	landunit = {
		id = { type = 10200 id = 93 }
		name = "Gaoxiong Garrison"
		location = 1322 #Gaoxiong
		division = { id = { type = 10200 id = 94 } name = "Gaoxiong Garrison" strength = 100 type = garrison model = 2 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 95 }
		name = "Taibei Garrison"
		location = 1323 #Taibei
		division = { id = { type = 10200 id = 96 } name = "Taibei Garrison" strength = 100 type = garrison model = 2 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 97 }
		name = "Hualian Garrison"
		location = 1324 #Hualian
		division = { id = { type = 10200 id = 98 } name = "Hualian Garrison" strength = 100 type = garrison model = 2 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 105 }
		name = "1st Special Guard Corps"
		location = 1191 #Kagoshima
		division = { id = { type = 10200 id = 106 } name = "1st Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 107 } name = "2nd Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 108 } name = "3rd Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 109 } name = "4th Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 110 }
		name = "2nd Special Guard Corps"
		location = 1190 #Fukuoka
		division = { id = { type = 10200 id = 111 } name = "5th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 112 } name = "6th Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 113 }
		name = "3rd Special Guard Corps"
		location = 1184 #Tokyo
		division = { id = { type = 10200 id = 114 } name = "7th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 115 } name = "8th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 116 } name = "9th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 117 } name = "10th Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 118 }
		name = "4th Special Guard Corps"
		location = 1187 #Osaka
		division = { id = { type = 10200 id = 119 } name = "11th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 120 } name = "12th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 121 } name = "13th Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 122 }
		name = "5th Special Guard Corps"
		location = 1182 #Fukushima
		division = { id = { type = 10200 id = 123 } name = "14th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 124 } name = "15th Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 125 }
		name = "6th Special Guard Corps"
		location = 1183 #Niigata
		division = { id = { type = 10200 id = 126 } name = "16th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 127 } name = "17th Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 128 }
		name = "7th Special Guard Corps"
		location = 1185 #Nagoya
		division = { id = { type = 10200 id = 129 } name = "18th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 130 } name = "19th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 131 } name = "20th Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 132 }
		name = "8th Special Guard Corps"
		location = 1188 #Hiroshima
		division = { id = { type = 10200 id = 133 } name = "21st Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 134 } name = "22nd Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 135 }
		name = "9th Special Guard Corps"
		location = 1180 #Sendai
		division = { id = { type = 10200 id = 136 } name = "23rd Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 137 } name = "24th Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 138 }
		name = "10th Special Guard Corps"
		location = 1189 #Shikoku
		division = { id = { type = 10200 id = 139 } name = "25th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 140 } name = "26th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 141 } name = "27th Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 142 }
		name = "11th Special Guard Corps"
		location = 1186 #Kanozawa
		division = { id = { type = 10200 id = 143 } name = "28th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 144 } name = "29th Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 145 }
		name = "12th Special Guard Corps"
		location = 1181 #Akita
		division = { id = { type = 10200 id = 146 } name = "30th Special Guard Division" strength = 100 type = garrison model = 1 }
		division = { id = { type = 10200 id = 147 } name = "31st Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 148 }
		name = "13th Special Guard Corps"
		location = 1179 #Sapporo
		division = { id = { type = 10200 id = 149 } name = "32nd Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 150 }
		name = "14th Special Guard Corps"
		location = 1178 #Asahikawa
		division = { id = { type = 10200 id = 151 } name = "33rd Special Guard Division" strength = 100 type = garrison model = 1 }
		}

	landunit = {
		id = { type = 10200 id = 152 }
		name = "1st Civilian Volunteer Corps"
		location = 1191 #Kagoshima
		division = { id = { type = 10200 id = 153 } name = "1st Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 154 } name = "2nd Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 155 } name = "3rd Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 156 } name = "4th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 157 }
		name = "2nd Civilian Volunteer Corps"
		location = 1190 #Fukuoka
		division = { id = { type = 10200 id = 158 } name = "5th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 159 } name = "6th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 160 }
		name = "3rd Civilian Volunteer Corps"
		location = 1184 #Tokyo
		division = { id = { type = 10200 id = 161 } name = "7th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 162 } name = "8th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 163 } name = "9th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 164 } name = "10th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 165 }
		name = "4th Civilian Volunteer Corps"
		location = 1187 #Osaka
		division = { id = { type = 10200 id = 166 } name = "11th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 167 } name = "12th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 168 } name = "13th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 169 }
		name = "5th Civilian Volunteer Corps"
		location = 1182 #Fukushima
		division = { id = { type = 10200 id = 170 } name = "14th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 171 } name = "15th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 172 }
		name = "6th Civilian Volunteer Corps"
		location = 1183 #Niigata
		division = { id = { type = 10200 id = 173 } name = "16th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 174 } name = "17th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 175 }
		name = "7th Civilian Volunteer Corps"
		location = 1185 #Nagoya
		division = { id = { type = 10200 id = 176 } name = "18th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 177 } name = "19th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 178 } name = "20th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 179 }
		name = "8th Civilian Volunteer Corps"
		location = 1188 #Hiroshima
		division = { id = { type = 10200 id = 180 } name = "21st Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 181 } name = "22nd Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 182 }
		name = "9th Civilian Volunteer Corps"
		location = 1180 #Sendai
		division = { id = { type = 10200 id = 183 } name = "23rd Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 184 } name = "24th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 185 }
		name = "10th Civilian Volunteer Corps"
		location = 1189 #Shikoku
		division = { id = { type = 10200 id = 186 } name = "25th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 187 } name = "26th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 188 } name = "27th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 189 }
		name = "11th Civilian Volunteer Corps"
		location = 1186 #Kanozawa
		division = { id = { type = 10200 id = 190 } name = "28th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 191 } name = "29th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 192 }
		name = "12th Civilian Volunteer Corps"
		location = 1181 #Akita
		division = { id = { type = 10200 id = 193 } name = "30th Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		division = { id = { type = 10200 id = 194 } name = "31st Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 195 }
		name = "13th Civilian Volunteer Corps"
		location = 1179 #Sapporo
		division = { id = { type = 10200 id = 196 } name = "32nd Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 197 }
		name = "14th Civilian Volunteer Corps"
		location = 1178 #Asahikawa
		division = { id = { type = 10200 id = 198 } name = "33rd Civilian Volunteer Division" strength = 100 type = militia model = 0 locked = yes }
		}

	landunit = {
		id = { type = 10200 id = 199 }
		name = "16th Army"
		location = 1191 #Kagoshima
		division = { id = { type = 10200 id = 200 } name = "16th Army" strength = 100 type = hq model = 2 }
		}

	landunit = {
		id = { type = 10200 id = 201 }
		name = "15th Army"
		location = 1187 #Osaka
		division = { id = { type = 10200 id = 202 } name = "15th Army" strength = 100 type = hq model = 2 }
		}

	landunit = {
		id = { type = 10200 id = 203 }
		name = "13th Army"
		location = 1185 #Nagoya
		division = { id = { type = 10200 id = 204 } name = "13th Army" strength = 100 type = hq model = 2 }
		}

	landunit = {
		id = { type = 10200 id = 205 }
		name = "12th Army"
		location = 1184 #Tokyo
		division = { id = { type = 10200 id = 206 } name = "12th Army" strength = 100 type = hq model = 2 }
		}

	landunit = {
		id = { type = 10200 id = 207 }
		name = "11th Army"
		location = 1180 #Sendai
		division = { id = { type = 10200 id = 208 } name = "11th Army" strength = 100 type = hq model = 2 }
		}

	landunit = {
		id = { type = 10200 id = 209 }
		name = "17th Army"
		location = 1197 #Daegu
		division = { id = { type = 10200 id = 210 } name = "17th Army" strength = 100 type = hq model = 2 }
		}

	navalunit = {
		id = { type = 10200 id = 1000 }
		name = "1st Destroyer Flotilla"
		location = 1188 #Hiroshima
		division = { id = { type = 10200 id = 1001 } name = "1st Destroyer Flotilla" strength = 100 type = destroyer model = 2 }
		}

	navalunit = {
		id = { type = 10200 id = 1002 }
		name = "2nd Destroyer Flotilla"
		location = 1187 #Osaka
		division = { id = { type = 10200 id = 1003 } name = "2nd Destroyer Flotilla" strength = 100 type = destroyer model = 2 }
		}

	navalunit = {
		id = { type = 10200 id = 1004 }
		name = "3rd Destroyer Flotilla"
		location = 1184 #Tokyo
		division = { id = { type = 10200 id = 1005 } name = "3rd Destroyer Flotilla" strength = 100 type = destroyer model = 2 }
		}

	navalunit = {
		id = { type = 10200 id = 1006 }
		name = "1st Submarine Flotilla"
		location = 1188 #Hiroshima
		division = { id = { type = 10200 id = 1007 } name = "1st Submarine Flotilla" strength = 100 type = submarine model = 2 }
		}

	navalunit = {
		id = { type = 10200 id = 1008 }
		name = "2nd Submarine Flotilla"
		location = 1187 #Osaka
		division = { id = { type = 10200 id = 1009 } name = "2nd Submarine Flotilla" strength = 100 type = submarine model = 2 }
		}

	navalunit = {
		id = { type = 10200 id = 1010 }
		name = "3rd Submarine Flotilla"
		location = 1185 #Nagoya
		division = { id = { type = 10200 id = 1011 } name = "3rd Submarine Flotilla" strength = 100 type = submarine model = 2 }
		}

	navalunit = {
		id = { type = 10200 id = 1012 }
		name = "4th Submarine Flotilla"
		location = 1184 #Tokyo
		division = { id = { type = 10200 id = 1013 } name = "4th Submarine Flotilla" strength = 100 type = submarine model = 2 }
		}

	navalunit = {
		id = { type = 10200 id = 1014 }
		name = "1st Transport Squadron"
		location = 1187 #Osaka
		division = { id = { type = 10200 id = 1015 } name = "1st Transport Flotilla" strength = 100 type = transport }
		division = { id = { type = 10200 id = 1016 } name = "2nd Transport Flotilla" strength = 100 type = transport }
		}

	navalunit = {
		id = { type = 10200 id = 1017 }
		name = "2nd Transport Squadron"
		location = 1185 #Nagoya
		division = { id = { type = 10200 id = 1018 } name = "3rd Transport Flotilla" strength = 100 type = transport }
		division = { id = { type = 10200 id = 1019 } name = "4th Transport Flotilla" strength = 100 type = transport }
		}

	airunit = {
		id = { type = 10200 id = 2000 }
		name = "1st Mixed Air Group"
		location = 1191 #Kagoshima
		division = { id = { type = 10200 id = 2001 } name = "1st Fighter Wing" strength = 50 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2002 } name = "2nd Fighter Wing" strength = 50 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2003 } name = "1st CAS Wing" strength = 50 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2004 } name = "2nd CAS Wing" strength = 50 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2005 } name = "3rd CAS Wing" strength = 50 max_strength = 100 type = cas model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2006 }
		name = "2nd Mixed Air Group"
		location = 1190 #Fukuoka
		division = { id = { type = 10200 id = 2007 } name = "3rd Fighter Wing" strength = 50 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2008 } name = "4th Fighter Wing" strength = 50 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2009 } name = "4th CAS Wing" strength = 50 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2010 } name = "5th CAS Wing" strength = 50 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2011 } name = "6th CAS Wing" strength = 50 max_strength = 100 type = cas model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2012 }
		name = "3rd Mixed Air Group"
		location = 1188 #Hiroshima
		division = { id = { type = 10200 id = 2013 } name = "5th Fighter Wing" strength = 80 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2014 } name = "6th Fighter Wing" strength = 80 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2015 } name = "7th CAS Wing" strength = 80 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2016 } name = "8th CAS Wing" strength = 80 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2017 } name = "9th CAS Wing" strength = 80 max_strength = 100 type = cas model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2018 }
		name = "4th Mixed Air Group"
		location = 1187 #Osaka
		division = { id = { type = 10200 id = 2019 } name = "7th Fighter Wing" strength = 80 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2020 } name = "8th Fighter Wing" strength = 80 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2021 } name = "10th CAS Wing" strength = 80 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2022 } name = "11th CAS Wing" strength = 80 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2023 } name = "12th CAS Wing" strength = 80 max_strength = 100 type = cas model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2024 }
		name = "5th Mixed Air Group"
		location = 1184 #Tokyo
		division = { id = { type = 10200 id = 2025 } name = "9th Fighter Wing" strength = 80 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2026 } name = "10th Fighter Wing" strength = 80 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2027 } name = "13th CAS Wing" strength = 80 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2028 } name = "14th CAS Wing" strength = 80 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2029 } name = "15th CAS Wing" strength = 80 max_strength = 100 type = cas model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2030 }
		name = "1st Fighter Group"
		location = 1191 #Kagoshima
		division = { id = { type = 10200 id = 2031 } name = "11th Fighter Wing" strength = 50 max_strength = 100 type = interceptor model = 3 }
		division = { id = { type = 10200 id = 2032 } name = "12th Fighter Wing" strength = 50 max_strength = 100 type = interceptor model = 3 }
		}

	airunit = {
		id = { type = 10200 id = 2033 }
		name = "2nd Fighter Group"
		location = 1190 #Fukuoka
		division = { id = { type = 10200 id = 2034 } name = "13th Fighter Wing" strength = 50 max_strength = 100 type = interceptor model = 3 }
		division = { id = { type = 10200 id = 2035 } name = "14th Fighter Wing" strength = 50 max_strength = 100 type = interceptor model = 3 }
		}

	airunit = {
		id = { type = 10200 id = 2036 }
		name = "3rd Fighter Group"
		location = 1185 #Nagoya
		division = { id = { type = 10200 id = 2037 } name = "15th Fighter Wing" strength = 80 max_strength = 100 type = interceptor model = 3 }
		division = { id = { type = 10200 id = 2038 } name = "16th Fighter Wing" strength = 80 max_strength = 100 type = interceptor model = 3 }
		}

	airunit = {
		id = { type = 10200 id = 2039 }
		name = "4th Fighter Group"
		location = 1188 #Hiroshima
		division = { id = { type = 10200 id = 2040 } name = "17th Fighter Wing" strength = 80 max_strength = 100 type = multi_role model = 1 }
		division = { id = { type = 10200 id = 2041 } name = "18th Fighter Wing" strength = 80 max_strength = 100 type = multi_role model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2042 }
		name = "5th Fighter Group"
		location = 1187 #Osaka
		division = { id = { type = 10200 id = 2043 } name = "19th Fighter Wing" strength = 80 max_strength = 100 type = multi_role model = 1 }
		division = { id = { type = 10200 id = 2044 } name = "20th Fighter Wing" strength = 80 max_strength = 100 type = multi_role model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2045 }
		name = "6th Fighter Group"
		location = 1184 #Tokyo
		division = { id = { type = 10200 id = 2046 } name = "21st Fighter Wing" strength = 80 max_strength = 100 type = multi_role model = 1 }
		division = { id = { type = 10200 id = 2047 } name = "22nd Fighter Wing" strength = 80 max_strength = 100 type = multi_role model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2048 }
		name = "1st Naval Bomber Group"
		location = 1191 #Kagoshima
		division = { id = { type = 10200 id = 2049 } name = "1st Naval Bomber Wing" strength = 50 max_strength = 100 type = naval_bomber model = 1 }
		division = { id = { type = 10200 id = 2050 } name = "2nd Naval Bomber Wing" strength = 50 max_strength = 100 type = naval_bomber model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2051 }
		name = "2nd Naval Bomber Group"
		location = 1189 #Shikoku
		division = { id = { type = 10200 id = 2052 } name = "3rd Naval Bomber Wing" strength = 80 max_strength = 100 type = naval_bomber model = 1 }
		division = { id = { type = 10200 id = 2053 } name = "4th Naval Bomber Wing" strength = 80 max_strength = 100 type = naval_bomber model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2054 }
		name = "3rd Naval Bomber Group"
		location = 1187 #Osaka
		division = { id = { type = 10200 id = 2055 } name = "5th Naval Bomber Wing" strength = 80 max_strength = 100 type = naval_bomber model = 1 }
		division = { id = { type = 10200 id = 2056 } name = "6th Naval Bomber Wing" strength = 80 max_strength = 100 type = naval_bomber model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2057 }
		name = "4th Naval Bomber Group"
		location = 1184 #Tokyo
		division = { id = { type = 10200 id = 2058 } name = "7th Naval Bomber Wing" strength = 80 max_strength = 100 type = naval_bomber model = 1 }
		division = { id = { type = 10200 id = 2059 } name = "8th Naval Bomber Wing" strength = 80 max_strength = 100 type = naval_bomber model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2060 }
		name = "1st Tactical Group"
		location = 1190 #Fukuoka
		division = { id = { type = 10200 id = 2061 } name = "1st Tactical Wing" strength = 80 max_strength = 100 type = tactical_bomber model = 1 }
		division = { id = { type = 10200 id = 2062 } name = "2nd Tactical Wing" strength = 80 max_strength = 100 type = tactical_bomber model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2063 }
		name = "2nd Tactical Group"
		location = 1187 #Osaka
		division = { id = { type = 10200 id = 2064 } name = "3rd Tactical Wing" strength = 80 max_strength = 100 type = tactical_bomber model = 1 }
		division = { id = { type = 10200 id = 2065 } name = "4th Tactical Wing" strength = 80 max_strength = 100 type = tactical_bomber model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2066 }
		name = "3rd Tactical Group"
		location = 1184 #Tokyo
		division = { id = { type = 10200 id = 2067 } name = "5th Tactical Wing" strength = 80 max_strength = 100 type = tactical_bomber model = 1 }
		division = { id = { type = 10200 id = 2068 } name = "6th Tactical Wing" strength = 80 max_strength = 100 type = tactical_bomber model = 1 }
		}

	airunit = {
		id = { type = 10200 id = 2069 }
		name = "Korea Air Group"
		location = 1199 #Seoul
		division = { id = { type = 10200 id = 2070 } name = "23rd Fighter Wing" strength = 80 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2071 } name = "24th Fighter Wing" strength = 80 max_strength = 100 type = interceptor model = 2 }
		division = { id = { type = 10200 id = 2072 } name = "16th CAS Wing" strength = 80 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2073 } name = "17th CAS Wing" strength = 80 max_strength = 100 type = cas model = 1 }
		division = { id = { type = 10200 id = 2075 } name = "7th Tactical Wing" strength = 80 max_strength = 100 type = tactical_bomber model = 1 }
		}


	}