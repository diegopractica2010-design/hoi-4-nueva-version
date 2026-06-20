province = {
	id = 1176 #Toyohara
	air_base = {
		size = 5
		current_size = 5
		}
	naval_base = {
		size = 2
		current_size = 2
		}
	}

province = {
	id = 1177 #Etorofu
	air_base = {
		size = 1
		current_size = 1
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = {
	id = 1175 #Ocha
	air_base = {
		size = 1
		current_size = 1
		}
	naval_base = {
		size = 1
		current_size = 1
		}
	}

province = {
	id = 1372 #Vladivostok
	air_base = {
		size = 10
		current_size = 10
		}
	naval_base = {
		size = 10
		current_size = 10
		}
	}

province = {
	id = 1200 #Wonsan
	air_base = {
		size = 8
		current_size = 8
		}
	}

province = {
	id = 1201 #Pyongyang
	air_base = {
		size = 8
		current_size = 8
		}
	naval_base = {
		size = 2
		current_size = 2
		}
	}




country = {
	tag = SOV

	capital = 1372

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
	armamentminister = { type = 9 id = 4038 }
	ministerofsecurity = { type = 9 id = 4041 }
	ministerofintelligence = { type = 9 id = 4049 }
	chiefofstaff = { type = 9 id = 4056 }
	chiefofarmy = { type = 9 id = 4060 }
	chiefofnavy = { type = 9 id = 4062 }
	chiefofair = { type = 9 id = 4069 }

	oil = 10000
	supplies = 25000

	manpower = 1000

	transports = 100
	escorts = 10

	extra_tc = 150

	free = {
		supplies = 150
		oil = 50
		ic = 80
		}

	ownedprovinces = {
	1372 1373 1371 1370 1369 1367 1366 1175
	}
	controlledprovinces = {
	1177 1176 1174
	1201 1200 1393 1391 1392 1376
	1372 1373 1371 1370 1369 1367 1366 1175
	}
	nationalprovinces = {
	1372 1373 1371 1370 1369 1367 1366 1175
	}

	 techapps        = { 1010  1020  1030  1040  1070  1080  1090  1110  1120  1130  1150  1160  1190  1200  1210  1220  1230  1240  1250  1260 
                             1270  1280  1310  1320  1330  1340  1350  14000 14010 14020 2010  2020  2030  2040  2050  2060  2070  2080  2090  2100 
                             2110  2120  2120  2130  2140  2150  2160  2170  2180  2190  2200  2220  2230  2240  2260  2270  2280  2290  2300  2310 
                             2320  2330  2340  2350  2370  2380  2390  2400  2410  2420  2430  2450  2460  2470  2480  2510  2520  3010  3020  3030 
                             3040  3070  3080  3090  3130  3140  3150  3190  3200  3210  3250  3260  3270  3280  3320  3330  3400  3410  3420  3430 
                             4010  4020  4030  4040  4050  4060  4070  4080  4090  4100  4120  4130  4140  4150  4160  4170  4180  4190  4200  4220 
                             4230  4250  4260  4280  5010  5020  5050  5060  5070  5080  5090  5100  5110  5120  5130  5140  5160  5180  5190  5200 
                             5210  5220  5230  5310  5320  5330  5350  5360  5410  5470  5480  5490  5500  5510  5550  5560  6210  6300  6310  6320 
                             6330  6340  6350  6360  6370  8010  8020  8030  8040  8050  8080  8090  8150  8160  8170  8210  9010  9020  9030  9040 
                             9050  9060  9070  9080  9090  9100  9110  9120  9130  9140  9150  9160  9170  9180  9190  9200  9210  9220  9230  9240 
                             9260  9270  9280  9290  9310  9320  9330  9350  9360  9430 
                           }

	landunit = {
		id = { type = 10100 id = 1 }
		name = "1st Red Banner Army"
		location = 1200 #Wonsan
		division = { id = { type = 10100 id = 2 } name = "22nd Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 3 } name = "39th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 4 } name = "59th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 5 } name = "231st Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 6 } name = "300th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 7 } name = "365th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 8 } name = "75th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		division = { id = { type = 10100 id = 9 } name = "77th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		division = { id = { type = 10100 id = 10 } name = "257th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		}

	landunit = {
		id = { type = 10100 id = 11 }
		name = "5th Army"
		location = 1392 #Hamhung
		division = { id = { type = 10100 id = 12 } name = "63rd Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 13 } name = "97th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 14 } name = "144th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 15 } name = "157th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 16 } name = "159th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 17 } name = "184th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 18 } name = "187th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 19 } name = "190th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 20 } name = "215th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 21 } name = "277th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 22 } name = "366th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 23 } name = "371st Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 24 } name = "72nd Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		division = { id = { type = 10100 id = 25 } name = "76th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		division = { id = { type = 10100 id = 26 } name = "208th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		division = { id = { type = 10100 id = 27 } name = "210th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		division = { id = { type = 10100 id = 28 } name = "218th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		}

	landunit = {
		id = { type = 10100 id = 29 }
		name = "25th Army"
		location = 1372 #Vladivostok
		division = { id = { type = 10100 id = 30 } name = "40th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 31 } name = "384th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 32 } name = "386th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 33 } name = "393rd Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 34 } name = "259th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		}

	landunit = {
		id = { type = 10100 id = 35 }
		name = "35th Army"
		location = 1372 #Vladivostok
		division = { id = { type = 10100 id = 36 } name = "66th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 37 } name = "264th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 38 } name = "363rd Rifle Division" strength = 100 type = infantry model = 4 }
		}

	landunit = {
		id = { type = 10100 id = 39 }
		name = "2nd Red Banner Army"
		location = 1201 #Pyongyang
		division = { id = { type = 10100 id = 40 } name = "3rd Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 41 } name = "12th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 42 } name = "396th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 43 } name = "73rd Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		division = { id = { type = 10100 id = 44 } name = "74th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		division = { id = { type = 10100 id = 45 } name = "258th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		}

	landunit = {
		id = { type = 10100 id = 46 }
		name = "15th Army"
		location = 1393 #Sinuiju
		division = { id = { type = 10100 id = 47 } name = "34th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 48 } name = "255th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 49 } name = "361st Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 50 } name = "388th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 51 } name = "165th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		division = { id = { type = 10100 id = 52 } name = "171st Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		division = { id = { type = 10100 id = 53 } name = "203rd Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		}

	landunit = {
		id = { type = 10100 id = 54 }
		name = "16th Army"
		location = 1176 #Toyohara
		division = { id = { type = 10100 id = 55 } name = "2nd Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 56 } name = "79th Rifle Division" strength = 100 type = infantry model = 4 }
		division = { id = { type = 10100 id = 57 } name = "214th Tank Brigade" strength = 50 max_strength = 50 type = armor model = 4 }
		}

	landunit = {
		id = { type = 10100 id = 58 }
		name = "101st Rifle Division"
		location = 1177 #Etorofu
		division = { id = { type = 10100 id = 59 } name = "101st Rifle Division" strength = 100 type = infantry model = 4 }
		}

	landunit = {
		id = { type = 10100 id = 60 }
		name = "1st Far Eastern Front"
		location = 1393 #Sinuiju
		division = { id = { type = 10100 id = 61 } name = "1st Far Eastern Front" strength = 100 type = hq model = 2 }
		}

	landunit = {
		id = { type = 10100 id = 62 }
		name = "Far East Command"
		location = 1372 #Vladivostok
		division = { id = { type = 10100 id = 63 } name = "Far East Command" strength = 100 type = hq model = 2 }
		}

	navalunit = {
		id = { type = 10100 id = 1000 }
		name = "Pacific Fleet"
		location = 1372 #Vladivostok
		division = { id = { type = 10100 id = 1001 } name = "Kaganovich" strength = 100 type = light_cruiser model = 3 }
		division = { id = { type = 10100 id = 1002 } name = "Kalinin" strength = 100 type = light_cruiser model = 3 }
		division = { id = { type = 10100 id = 1003 } name = "1st Destroyer Flotilla" strength = 100 type = destroyer model = 3 }
		division = { id = { type = 10100 id = 1004 } name = "2nd Destroyer Flotilla" strength = 100 type = destroyer model = 2 }
		division = { id = { type = 10100 id = 1005 } name = "3rd Destroyer Flotilla" strength = 100 type = destroyer model = 2 }
		division = { id = { type = 10100 id = 1006 } name = "1st Transport Flotilla" strength = 100 type = transport }
		division = { id = { type = 10100 id = 1007 } name = "2nd Transport Flotilla" strength = 100 type = transport }
		division = { id = { type = 10100 id = 1008 } name = "3rd Transport Flotilla" strength = 100 type = transport }
		division = { id = { type = 10100 id = 1009 } name = "4th Transport Flotilla" strength = 100 type = transport }
		}

	airunit = {
		id = { type = 10100 id = 2000 }
		name = "9th Air Army"
		location = 1201 #Pyongyang
		division = { id = { type = 10100 id = 2001 } name = "32nd Wing" strength = 100 type = multi_role model = 1 }
		division = { id = { type = 10100 id = 2002 } name = "33rd Wing" strength = 100 type = tactical_bomber model = 3 }
		division = { id = { type = 10100 id = 2003 } name = "34th Wing" strength = 100 type = tactical_bomber model = 3 }
		division = { id = { type = 10100 id = 2004 } name = "55th Wing" strength = 100 type = tactical_bomber model = 3 }
		division = { id = { type = 10100 id = 2005 } name = "249th Wing" strength = 100 type = multi_role model = 1 }
		division = { id = { type = 10100 id = 2006 } name = "250th Wing" strength = 100 type = multi_role model = 1 }
		division = { id = { type = 10100 id = 2007 } name = "251st Wing" strength = 100 type = cas model = 1 }
		division = { id = { type = 10100 id = 2008 } name = "252nd Wing" strength = 100 type = cas model = 1 }
		}

	airunit = {
		id = { type = 10100 id = 2009 }
		name = "10th Air Army"
		location = 1200 #Wonsan
		division = { id = { type = 10100 id = 2010 } name = "29th Wing" strength = 100 type = multi_role model = 1 }
		division = { id = { type = 10100 id = 2011 } name = "83rd Wing" strength = 100 type = tactical_bomber model = 3 }
		division = { id = { type = 10100 id = 2012 } name = "96th Wing" strength = 100 type = tactical_bomber model = 3 }
		division = { id = { type = 10100 id = 2013 } name = "128th Wing" strength = 100 type = cas model = 1 }
		division = { id = { type = 10100 id = 2014 } name = "253rd Wing" strength = 100 type = cas model = 1 }
		division = { id = { type = 10100 id = 2015 } name = "254th Wing" strength = 100 type = multi_role model = 1 }
		division = { id = { type = 10100 id = 2016 } name = "255th Wing" strength = 100 type = cas model = 1 }
		division = { id = { type = 10100 id = 2017 } name = "296th Wing" strength = 100 type = cas model = 1 }
		}
	airunit = {
		id = { type = 10100 id = 2018 }
		name = "North Pacific Ocean Fleet Air Flotilla"
		location = 1372 #Vladivostok
		division = { id = { type = 10100 id = 2019 } name = "15th Wing" strength = 100 type = multi_role model = 1 }
		division = { id = { type = 10100 id = 2020 } name = "15th Wing" strength = 100 type = naval_bomber model = 1 }
		}

	airunit = {
		id = { type = 10100 id = 2021 }
		name = "Pacific Ocean Fleet Air Flotilla"
		location = 1176 #Toyohara
		division = { id = { type = 10100 id = 2022 } name = "2nd Wing" strength = 100 type = naval_bomber model = 1 }
		division = { id = { type = 10100 id = 2023 } name = "7th Wing" strength = 100 type = multi_role model = 1 }
		division = { id = { type = 10100 id = 2024 } name = "10th Wing" strength = 100 type = cas model = 1 }
		division = { id = { type = 10100 id = 2025 } name = "12th Wing" strength = 100 type = naval_bomber model = 1 }
		}


	}