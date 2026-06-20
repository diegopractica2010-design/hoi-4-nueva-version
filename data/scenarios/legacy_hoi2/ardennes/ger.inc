#################################
# Designed by Greven and Tracid #
#################################
province = { id = 43 landfort = 8 coastalfort = 0 }#Dunkirk
province = { id = 314 landfort = 3 coastalfort = 0 }#Westwall
province = { id = 315 landfort = 3 coastalfort = 0 }#Westwall
province = { id = 74 landfort = 3 coastalfort = 0 }#Westwall
province = { id = 75 landfort = 3 coastalfort = 0 }#Westwall

province = {
	id = 47
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}

province = {
	id = 81
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}

province = {
	id = 313
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 314
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}
province = {
	id = 374
	anti_air = 6
	air_base = {
		size = 10
		current_size = 10
	}
}

#Supply pools
province = {  id = 43  oilpool = 50 supplypool = 100 } # Dunkirk

country = {
    tag = GER
	ai = "ardennes_ger.ai"

    policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 1
        political_left = 1
        free_market = 5
        freedom = 2
        professional_army = 5
        defense_lobby = 10
        interventionism = 10
    }


	headofstate = { type = 9 id = 1 }
	headofgovernment = { type = 9 id = 42 }
	foreignminister = { type = 9 id = 55 }
	armamentminister = { type = 9 id = 86 }
	ministerofsecurity = { type = 9 id = 108 }
	ministerofintelligence = { type = 9 id = 138 }
	chiefofstaff = { type = 9 id = 157 }
	chiefofarmy = { type = 9 id = 177 }
	chiefofnavy = { type = 9 id = 192 }
	chiefofair = { type = 9 id = 10 }



	steal_leader = 260 #Student
	steal_leader = 163 #Philipp Kleffel
	steal_leader = 240 #Schlemm
	steal_leader = 182 #Paul Laux
	steal_leader = 356 #v. Zangen
	steal_leader = 177 #Friedrich Köchling
	steal_leader = 21 #Günther Blumentritt
	steal_leader = 56 #Hans Felber
	steal_leader = 202 #Model
	steal_leader = 496 #Dietrich
	steal_leader = 521 #Hermann Priess
	steal_leader = 139 #Otto Hitzfeld
	steal_leader = 491 #Willi Bittrich
	steal_leader = 323 #v. Manteuffel
	steal_leader = 320 #Smilo Freiherr von Lüttwitz
	steal_leader = 512 #Walter Krüger
	steal_leader = 191 #Walther Lucht
	steal_leader = 503 #Hausser
	steal_leader = 545 #Dr. Franz Beyer
	steal_leader = 81 #Foertsch
	steal_leader = 51 #Anton Dostler
	steal_leader = 364 #Wiese
	steal_leader = 46 #Decker
	steal_leader = 446 #Huth
	steal_leader = 27 # Brandenberger 
 	steal_leader = 615 # Christiansen 
 	steal_leader = 617 # AK-Felix Schwalbe 
 	steal_leader = 618 # AK-Gustav Höhne 
 	steal_leader = 619 # AK-Carl Püchler 
 	steal_leader = 622 # AK-Erich Petersen 
 	steal_leader = 623 # AK-Hellmuth Thumm 
 	steal_leader = 621 # AK-Rothirch und Trach 
 	steal_leader = 620 # AK-Friedrich-August Schack
	steal_leader = 627 # von Falkenstein 
 	steal_leader = 930 # Ernst Kühl 
 	steal_leader = 631 # von Heinemann 
	steal_leader = 625 # Karl-Eduard Wilke
	steal_leader = 624 #Holle 
	steal_leader = 441 #Harlingshausen
	steal_leader = 119 # Harpe 
	steal_leader = 327 # von Obstfelder 
	steal_leader = 81 # Förtsch 
	steal_leader = 12 # Bayerlein 
	steal_leader = 92 # Grimmeis 
	steal_leader = 320 # von Lüttwitz 
	steal_leader = 257 # Straube 
	steal_leader = 633 # Sponheimer 
	steal_leader = 508 # Keppler 
	steal_leader = 503 # Hausser
	steal_leader = 164 #Kluge 

	capital = 86 #Hannover (enroute to Berlin)

   	manpower = 250


	# Resource Reserves (No Production or Trade in this scenario)
	oil 	=	1000
	supplies =	4000
	extra_tc = 150  

	# offmap production
	free = 		{
		oil 	=	25 #50
		supplies =	100 #170
		ic = 40
	}

    ownedprovinces =
	{
		46 47 77 78 79 83 80 81 82 76 67 75 74 84 313 314 315 374 85 86 87 43 48
	}
    controlledprovinces =
	{
		46 47 77 78 79 83 80 81 82 76 67 75 74 84 313 314 315 374 85 86 87 43 48
	}
    nationalprovinces =
	{
		46 47 77 78 79 83 80 81 82 76 67 75 74 84 313 314 315 374 85 86 87 43 48
	}
	 techapps               = { 1010  1020  1030  1040  1040  1050  1070  1080  1090  1100  1110  1120  1130  1140  1190  1200  1210  1220  1230  1240 
                             1250  1260  1270  1280  1310  1320  1330  1340  1350  1360  14000 14010 14020 2010  2020  2030  2040  2050  2060  2070 
                             2080  2090  2100  2110  2120  2150  2160  2170  2180  2190  2200  2220  2230  2240  2250  2260  2270  2280  2290  2300 
                             2310  2320  2330  2340  2350  2360  2370  2380  2390  2400  2410  2420  2430  2450  2460  2470  2480  2490  2510  2520 
                             2530  2540  3010  3020  3030  3040  3070  3080  3090  3100  3130  3140  3150  3160  3190  3200  3210  3220  3250  3260 
                             3270  3280  3290  3320  3330  3340  3400  3410  3420  3430  3440  4010  4020  4030  4040  4050  4060  4070  4080  4090 
                             4100  4110  4120  4130  4140  4150  4160  4170  4180  4190  4200  4210  4220  4230  4240  4250  4260  4270  4280  5010 
                             5020  5030  5050  5060  5070  5080  5090  5100  5110  5120  5130  5140  5150  5160  5170  5180  5190  5200  5210  5220 
                             5230  5310  5320  5330  5340  5350  5360  5370  5380  5410  5420  5430  5440  5450  5470  5480  5490  5500  5550  5560 
                             5570  5580  5590  6210  6220  6230  6240  6250  6260  6270  6290  7010  7020  7030  7040  7060  7070  7100  7110  7140 
                             7260  7280  7290  8010  8020  8030  8040  8050  8080  8090  8150  8160  8170  8210  8280  8290  9010  9020  9030  9040 
                             9050  9060  9070  9080  9090  9100  9110  9120  9130  9190  9200  9210  9220  9230  9240  9250  9260  9270  9280  9290 
                             9300  9310  9320  9330  9340  9350  9360  9370  9380  9390  9400  9410  9420 
                           }
############################
#  HEERESGRUPPE H 	   	   #
############################

landunit = {
id = { type = 10602 id = 1 }
name = "Heeresgruppe H"
leader = 260 #Student
location = 47

division = {
id = { type = 10602 id = 2 }
name = "Heeresgruppe H HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
division = {
id = { type = 10602 id = 3 }
name = "79. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
}

division = {
id = { type = 10602 id = 4 }
name = "9. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
}

division = {
id = { type = 10602 id = 5 }
name = "167. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
}
division = {
id = { type = 10602 id = 6 }
name = "257. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
}

division = {
id = { type = 10602 id = 7 }
name = "Führer-Begleit Brigade"
strength = 60
max_strength = 60
type = motorized
model = 2
}
division = {
id = { type = 10602 id = 8 }
name = "Führer-Grenadier Brigade"
strength = 45
max_strength = 45
type = mechanized
model = 1
}
}
###########################
landunit = {
id = { type = 10602 id = 9 }
name = "25. Armee"
leader = 615 #Christiansen
location = 48 #Holland

division = {
id = { type = 10602 id = 10 }
name = "25. Armee HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}

###

landunit = {
id = { type = 10602 id = 11 }
name = "LXXXVIII Armeekorps"
leader = 617 #Felix Schwalbe
location = 46 #Holland

division = {
id = { type = 10602 id = 13 }
name = "719. Infanterie-Div."
strength = 100
type = infantry
model = 4
}

division = {
id = { type = 10602 id = 14 }
name = "85. Infanterie-Div."
strength = 100
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
}

division = {
id = { type = 10602 id = 15 }
name = "84. Infanterie-Div."
strength = 40
max_strength = 40
type = infantry
model = 4
}
division = {
id = { type = 10602 id = 16 }
name = "89. Infanterie-Div."
strength = 75
max_strength = 75
type = infantry
model = 4
}
division = {
id = { type = 10602 id = 17 }
name = "6. Fallschirmjäger-Div."
strength = 100
type = paratrooper
model = 3
}
division = {
id = { type = 10602 id = 18 }
name = "176. Infanterie-Div."
strength = 100
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
}
division = {
id = { type = 10602 id = 19 }
name = "353. Infanterie-Div."
strength = 50
max_strength = 50
type = infantry
model = 4
}
}
###
landunit = {
id = { type = 10602 id = 20 }
name = "XXX Armeekorps"
leader = 163 #Philipp Kleffel
location = 48 #Holland

division = {
id = { type = 10602 id = 22 }
name = "304. Infanterie-Div."
strength = 100
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
}

division = {
id = { type = 10602 id = 23 }
name = "46. Infanterie-Div."
strength = 100
type = infantry
model = 4
}

division = {
id = { type = 10602 id = 24 }
name = "257. Infanterie-Div."
strength = 100
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
}
division = {
id = { type = 10602 id = 25 }
name = "387. Infanterie-Div."
strength = 100
type = infantry
model = 4
}
division = {
id = { type = 10602 id = 26 }
name = "16. Panzergrenadier-Div."
strength = 100
type = motorized
model = 2
extra = sp_artillery
brigade_model = 3
}
division = {
id = { type = 10602 id = 27 }
name = "306. Infanterie-Div."
strength = 100
type = infantry
model = 4
}

}
###########################
landunit = {
id = { type = 10602 id = 28 }
name = "1. Fallschirm-Armee"
leader = 240 #Schlemm
location = 76 #Ruhr

division = {
id = { type = 10602 id = 29 }
name = "1. Fallschirm-Armee HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}

###

landunit = {
id = { type = 10602 id = 30 }
name = "LXXXXVI Armeekorps"
leader = 618 #Gustav Höhne
location = 77 #Ruhr

division = {
id = { type = 10602 id = 32 }
name = "59. Infanterie-Div."
strength = 100
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 33 }
name = "712. Infanterie-Div."
strength = 100
type = infantry
model = 4
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 34 }
name = "526. Infanterie-Div."
strength = 40
max_strength = 40
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###
landunit = {
id = { type = 10602 id = 35 }
name = "II Fallschirm-Korps"
leader = 182 #Paul Laux
location = 76 #Ruhr


division = {
id = { type = 10602 id = 37 }
name = "190. Infanterie-Div."
strength = 100
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 38 }
name = "84. Infanterie-Div."
strength = 100
type = infantry
model = 4
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###########################
landunit = {
id = { type = 10602 id = 39 }
name = "15. Armee"
leader = 356 #v. Zangen
location = 67 #west of Cologne

division = {
id = { type = 10602 id = 40 }
name = "15. Armee HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}

###

landunit = {
id = { type = 10602 id = 41 }
name = "LXXXI Armeekorps"
leader = 177 #Friedrich Köchling
location = 67 #west of Cologne

division = {
id = { type = 10602 id = 43 }
name = "363. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 44 }
name = "246. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 45 }
name = "47. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###
landunit = {
id = { type = 10602 id = 46 }
name = "LXXIV Armeekorps"
leader = 619 #Carl Püchler
location = 67 #west of Cologne


division = {
id = { type = 10602 id = 48 }
name = "353. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 49 }
name = "85. Infanterie-Div."
strength = 100
type = infantry
model = 4
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
division = {
id = { type = 10602 id = 50 }
name = "344. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 51 }
name = "89. Infanterie-Div."
strength = 100
type = infantry
model = 4
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###
landunit = {
id = { type = 10602 id = 52 }
name = "XII SS-Armeekorps"
leader = 21 #Günther Blumentritt
location = 67 #west of Cologne


division = {
id = { type = 10602 id = 54 }
name = "9. Panzer-Div."
strength = 100
type = armor
model = 3
extra = sp_artillery
brigade_model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 55 }
name = "176. Infanterie-Div."
strength = 100
type = infantry
model = 4
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
division = {
id = { type = 10602 id = 56 }
name = "59. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 57 }
name = "15. Panzergrenadier-Div."
strength = 100
type = motorized
model = 2
extra = sp_artillery
brigade_model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###
landunit = {
id = { type = 10602 id = 58 }
name = "XIII Armeekorps"
leader = 56 #Hans Felber
location = 67 #west of Cologne


division = {
id = { type = 10602 id = 60 }
name = "183. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 61 }
name = "340. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
############################
#  HEERESGRUPPE B 	   	   #
############################

landunit = {
id = { type = 10602 id = 62 }
name = "Heeresgruppe B"
leader = 202 #Model
location = 82

division = {
id = { type = 10602 id = 63 }
name = "Heeresgruppe B HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###########################
landunit = {
id = { type = 10602 id = 64 }
name = "6. SS-Panzerarmee"
leader = 496 #Dietrich
location = 75 #opposite of Lüttich

division = {
id = { type = 10602 id = 65 }
name = "6. SS-Panzerarmee HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###
landunit = {
id = { type = 10602 id = 66 }
name = "I SS-Panzerkorps"
leader = 521 #Hermann Priess
location = 75 #opposite of Lüttich

division = {
id = { type = 10602 id = 68 }
name = "1. SS - Leibstandarte Adolf Hitler"
strength = 100
type = armor
model = 4
extra = sp_artillery
brigade_model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 69 }
name = "12. SS - Hitlerjugend"
strength = 100
type = armor
model = 4
extra = tank_destroyer
brigade_model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 70 }
name = "3. Fallschirm-Div."
strength = 100
type = paratrooper
model = 2
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 71 }
name = "277. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 72 }
name = "12. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}

###
landunit = {
id = { type = 10602 id = 73 }
name = "LXVII Armeekorps"
leader = 139 #Otto Hitzfeld
location = 75 #opposite of Lüttich

division = {
id = { type = 10602 id = 75 }
name = "272. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 76 }
name = "326. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}

###
landunit = {
id = { type = 10602 id = 77 }
name = "II SS-Panzerkorps"
leader = 491 #Willi Bittrich
location = 75 #opposite of Lüttich

division = {
id = { type = 10602 id = 79 }
name = "2. SS - Das Reich"
strength = 100
type = armor
model = 4
extra = heavy_armor
brigade_model = 2
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 80 }
name = "9. SS - Hohenstauffen"
strength = 100
type = armor
model = 4
extra = heavy_armor
brigade_model = 1
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###########################
landunit = {
id = { type = 10602 id = 81 }
name = "5. Panzerarmee"
leader = 323 #v. Manteuffel
location = 75 #opposite of Bastogne

division = {
id = { type = 10602 id = 82 }
name = "5. Panzerarmee HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###
landunit = {
id = { type = 10602 id = 83 }
name = "XXXXVII Panzerkorps"
leader = 320 #Smilo Freiherr von Lüttwitz
location = 75 #opposite of Bastogne

division = {
id = { type = 10602 id = 85 }
name = "26. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 86 }
name = "Panzer-Lehr Div."
strength = 100
type = armor
model = 4
extra = heavy_armor
brigade_model = 2
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 87 }
name = "2. Panzer-Div."
strength = 100
type = armor
model = 3
extra = tank_destroyer
brigade_model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###
landunit = {
id = { type = 10602 id = 88 }
name = "LVIII Panzerkorps"
leader = 512 #Walter Krüger
location = 75 #opposite of Bastogn

division = {
id = { type = 10602 id = 90 }
name = "560. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 91 }
name = "116. Panzer-Div."
strength = 100
type = armor
model = 3
extra = sp_artillery
brigade_model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###
landunit = {
id = { type = 10602 id = 92 }
name = "LXVI Panzerkorps"
leader = 191 #Walther Lucht
location = 75 #opposite of Bastogne

division = {
id = { type = 10602 id = 94 }
name = "18. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 95 }
name = "62. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
############################
#  HEERESGRUPPE G 	   	   #
############################

landunit = {
id = { type = 10602 id = 96 }
name = "Heeresgruppe G"
leader = 503 #Hausser
location = 313

division = {
id = { type = 10602 id = 97 }
name = "Heeresgruppe G HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}
###########################
landunit = {
id = { type = 10602 id = 98 }
name = "7. Armee"
leader = 27 #Brandenburger
location = 74 #opposite of Luxembourg

division = {
id = { type = 10602 id = 99 }
name = "7. Armee HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###
landunit = {
id = { type = 10602 id = 100 }
name = "LXXX Armeekorps"
leader = 545 #Dr. Franz Beyer
location = 74 #opposite of Luxembourg

division = {
id = { type = 10602 id = 102 }
name = "276. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 103 }
name = "212. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###
landunit = {
id = { type = 10602 id = 104 }
name = "LXXXV Armeekorps"
leader = 620 #Friedrich-August Schack
location = 74 #opposite of Luxembourg

division = {
id = { type = 10602 id = 106 }
name = "253. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 107 }
name = "5. Fallschirm-Div."
strength = 100
type = paratrooper
model = 2
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###########################
landunit = {
id = { type = 10602 id = 108 }
name = "1. Armee"
leader = 81 #Foertsch
location = 314 #west of Saarbrücken

division = {
id = { type = 10602 id = 109 }
name = "1. Armee HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}
###
landunit = {
id = { type = 10602 id = 110 }
name = "LIII Armeekorps"
leader = 621 #Edwin Graf von Rothirch und Trach
location = 314 #west of Saarbrücken

division = {
id = { type = 10602 id = 112 }
name = "68. Infanterie-Div."
strength = 100
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
}

division = {
id = { type = 10602 id = 113 }
name = "349. Infanterie-Div."
strength = 100
type = infantry
model = 4
}

division = {
id = { type = 10602 id = 114 }
name = "208. Infanterie-Div."
strength = 50
max_strength = 50
type = infantry
model = 4
}
}
###
landunit = {
id = { type = 10602 id = 115 }
name = "LXXII Armeekorps"
leader = 51 #Anton Dostler
location = 314 #west of Saarbrücken

division = {
id = { type = 10602 id = 117 }
name = "245. Infanterie-Div."
strength = 100
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
}

division = {
id = { type = 10602 id = 118 }
name = "256. Infanterie-Div."
strength = 100
type = infantry
model = 4
}

division = {
id = { type = 10602 id = 119 }
name = "553. Infanterie-Div."
strength = 50
max_strength = 50
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
}
}
###########################
landunit = {
id = { type = 10602 id = 120 }
name = "19. Armee"
leader = 364 #Wiese
location = 315 #Colmar

division = {
id = { type = 10602 id = 121 }
name = "19. Armee HQ"
type = hq
model = 2
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 2
}
}

landunit = {
id = { type = 10602 id = 122 }
name = "LXXXX Armeekorps"
leader = 622 #Erich Petersen
location = 315 #Colmar

division = {
id = { type = 10602 id = 124 }
name = "269. Infanterie-Div."
strength = 100
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
}

division = {
id = { type = 10602 id = 125 }
name = "16. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
}
}

###
landunit = {
id = { type = 10602 id = 126 }
name = "LXIV Armeekorps"
leader = 623 #Hellmuth Thumm
location = 315 #Colmar

division = {
id = { type = 10602 id = 128 }
name = "716. Infanterie-Div."
strength = 100
type = infantry
model = 4
extra = sp_artillery
brigade_model = 1
}

division = {
id = { type = 10602 id = 129 }
name = "708. Volksgrenadier-Div."
strength = 100
type = infantry
model = 3
}
}
########### RESERVES ############################
landunit = {
id = { type = 10602 id = 130 }
name = "XXXIX Panzerkorps"
leader = 46 #Decker
location = 82 #Near Kassel

division = {
id = { type = 10602 id = 132 }
name = "11. Panzer-Div."
strength = 100
type = armor
model = 3
extra = sp_artillery
brigade_model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 133 }
name = "10. SS - Frundsberg"
strength = 100
type = armor
model = 4
extra = heavy_armor
brigade_model = 1
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 134 }
name = "3. Panzergrenadier-Div."
strength = 100
type = motorized
model = 2
offensive = { year = 1945 month = january day = 0 hour = 0 }
}

division = {
id = { type = 10602 id = 135 }
name = "6. SS - Nord"
strength = 100
type = bergsjaeger
model = 3
offensive = { year = 1945 month = january day = 0 hour = 0 }
}
}
###
landunit = {
id = { type = 10602 id = 136 }
name = "Marineoberkommando West"
leader = 164 #Kluge
location = 43 #Dunkirk
dig_in = 10

division = {
id = { type = 10602 id = 137 }
name = "Marineoberkommando West HQ"
type = hq
model = 1
strength = 50
   max_strength = 50
extra = sp_artillery
brigade_model = 1
}

division = {
id = { type = 10602 id = 138 }
name = "226. Infanterie-Div."
strength = 50
max_strength = 50
type = infantry
model = 4
}
}
###########LUFTWAFFE##############
airunit = {
id = { type = 10602 id = 139 }
name = "14. Flieger-Division"
leader = 631 #v. Heinemann
location = 47 #Amsterdam
base = 47 #Amsterdam

division = {
id = { type = 10602 id = 140 }
name = "KG 51"
strength = 40
max_strength = 40
type = interceptor
model = 7 #Me 262A
}

division = {
id = { type = 10602 id = 141 }
name = "Lehrgeschwader 1"
strength = 100
type = tactical_bomber
model = 3 #Ju 88
}

division = {
id = { type = 10602 id = 142 }
name = "KG 53"
strength = 65
max_strength = 65
type = tactical_bomber
model = 2 #He 111
}
}
###
airunit = {
id = { type = 10602 id = 143 }
name = "15. Flieger-Division"
leader = 625 #Karl-Eduard Wilke
location = 313 #Frankfurt
base = 313 #Frankfurt

division = {
id = { type = 10602 id = 144 }
name = "KG 2"
strength = 45
max_strength = 45
type = tactical_bomber
model = 4 #Ju 188
}
}
###

airdivision = {
	dormant = yes				#1st Jan45' Dortmund #76
	id = { type = 10602 id = 145 }
	name = "Jg 53" 					#Belongs to 16. Flieger-Division
	strength = 100
	type = interceptor
	model = 3 #Me-109G
}

airdivision = {
	dormant = yes				#1st Jan45'
	id = { type = 10602 id = 146 }
	name = "Jg 54" 					#Belongs to 5. Jagddivision
	strength = 100
	type = multi_role
	model = 1 #Fw-190D
}
###
airunit = {
id = { type = 10602 id = 147 }
name = "3. Flieger-Division"
leader = 627 #v.Falkenstein
location = 81 #Münster
base = 81 #Münster

division = {
id = { type = 10602 id = 148 }
name = "Schlachtgeschwader 3"
strength = 100
type = cas
model = 2 #Henschel Hs-129
}

division = {
id = { type = 10602 id = 149 }
name = "Schlachtgeschwader 4"
strength = 100
type = cas
model = 2 #Henschel Hs-129
}
}
###
airunit = {
id = { type = 10602 id = 150 }
name = "5. Flieger-Division"
leader = 930 #Ernst Kuhl
location = 314 #Stuttgart
base = 314 #Stuttgart

division = {
id = { type = 10602 id = 151 }
name = "Jg 2"
strength = 100
type = multi_role
model = 1 #Fw-190D
}

division = {
id = { type = 10602 id = 152 }
name = "Jg 3"
strength = 100
type = interceptor
model = 3 #Me-109G
}
}
###
airunit = {
	id = { type = 10602 id = 153 }
	name = "7. Flieger-Division"
	leader = 446 #Huth
	location = 374 #Friedrichshafen
	base = 374 #Friedrichshafen

	division = {
		id = { type = 10602 id = 154 }
		name = "Jg 26"
		strength = 100
		type = multi_role
		model = 1 #Fw-190D
	}

	division = {
		id = { type = 10602 id = 155 }
		name = "Jg 27"
		strength = 100
		type = interceptor
		model = 2 #Me-109E
	}
}

}