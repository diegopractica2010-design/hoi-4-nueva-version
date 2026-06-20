#Anti Aircraft Batteries
province = { id = 307   anti_air = 2 } #Poznan
province = { id = 303   anti_air = 2 } #Danzig
province = { id = 483   anti_air = 2 } #Lodz
province = { id = 479   anti_air = 2 } #Krakow
province = { id = 485   anti_air = 3 } #Warszawa
province = { id = 501   anti_air = 2 } #Lwow
province = { id = 208   anti_air = 1 } #Vilna
province = { id = 509   anti_air = 1 } #Grodno
province = { id = 305   anti_air = 1 } #Torun

# Forts
province = {	id = 305 landfort = 1 } # Mlawa defences
province = {	id = 486 landfort = 2 } # Modlin forts
province = {	id = 504 landfort = 2 } # Brest forts



#Gdansk
province = {
	id = 303
	naval_base = { size = 5	current_size = 5 }
	air_base = { size = 5 current_size = 5 }
}

province = {
	id = 485
	air_base = { size = 10 current_size = 10 }

}

province = {
	id = 501
	air_base = { size = 7 current_size = 7 }

}

province = {
	id = 487
	air_base = { size = 5 current_size = 5 }

}


province = {
	id = 479
	air_base = { size = 5 current_size = 5 }

}

province = {
	id = 208
	air_base = { size = 5 current_size = 5 }

}

province = {
	id = 307
	air_base = { size = 5 current_size = 5 }

}

country = {
    tag = POL

	ai = "fallweiss_pol.ai"

	capital = 485

	policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 6
        political_left = 2
        freedom = 4
        free_market = 5
        professional_army = 3
        defense_lobby = 8
        interventionism = 6
    }

	headofstate = { type = 9 id = 13001 }
	headofgovernment = { type = 9 id = 13002 }
  	foreignminister = { type = 9 id = 13003 }
  	armamentminister = { type = 9 id = 13004 }
  	ministerofsecurity = { type = 9 id = 13005 }
  	ministerofintelligence = { type = 9 id = 13006 }
  	chiefofstaff = { type = 9 id = 13007 }
  	chiefofarmy = { type = 9 id = 13008 }
  	chiefofnavy = { type = 9 id = 13009 } 
  	chiefofair = { type = 9 id = 13010 }

	manpower = 150	#275

	# Resource Reserves				#No production in this scenario!
	oil = 25000
	supplies = 65000
	extra_tc = 50

	free = 	{
		ic = 20
	}

	ownedprovinces =      {
		303 306 307 479 480 481 483 484 305 485 486 487 489 488 500 501
		502 503 504 505 506 507 508 509 209 208 213 211 210 222 229 562 214
	}
	controlledprovinces = {
		303 306 307 479 480 481 483 484 305 485 486 487 489 488 500 501
		502 503 504 505 506 507 508 509 209 208 213 211 210 222 229 562 214
	}
	nationalprovinces =   {
		303 306 307 479 480 481 483 484 305 485 486 487 489 488 500 501
		502 503 504 505 506 507 508 509 209 208 213 211 210 222 229 562 214
	}
	techapps = {

1120

#Air Doctrines

9010 9020

#Aircraft (early fighter, early tac. bomber)

4010 4020 4120 4130 

# Armor (up to basic light - 7TP tank), basic car, up to 150mm GW art.

2010 2020 2030 2040 2150 2290 2300 2450 2510

# Industry (all types of building, basic tools, basic conversions)

5010 # Modern Agriculture
5050 #Basic Machine Tools
5080 5090 5100 # Construction (up to the forts)
5190 # Basic oil conversion

# Infantry (early inf/berg), Cavalry (early)

1010 1020 1110 1190 1200

# Land doctrines (Firepower, Grand Battleplan)

6010 6030

3010 3020 3030
3400 3410

8040 8050

# In 1939 scenario only
###################

4140 # basic tactical bomber

2400 # Early AT, 37mm Bofors gun

2460 # 75mm modern flak cannon

2520 # 40mm AA Bofors

1030 1210 1220 # Basic cavalry, Semi-motorized cavalry

1230 # Basic motorized

2310
#hospital
14000 14010

	}

########################################################
##Polish 1939 OOB - big thanks to Halibutt for support##
########################################################

landunit = {
	id = { type = 30013 id = 1 }
	name = "SGO Narew"
	location = 509 #Suwalki
	leader = 8078 #Mlot-Fijalkowski

	division = {	
		id = { type = 30013 id = 2 }
		name = "18 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		}

	division = {
		id = { type = 30013 id = 3 }
		name = "33 Rezerwowa DP"
		strength = 70
		type = infantry
		model = 0
		}

	division = {
		id = { type = 30013 id = 4 }
		name = "Podlaska i Suwalska BK"	
		strength = 90
		type = cavalry		
		model = 2
		}
	}

landunit = {
	id = { type = 30013 id = 5 }
	name = "GO Grodno"
	location = 209 #Grodno
	leader = 8087 # Olszyna-Wilczynski

	division = {
		id = { type = 30013 id = 6 }
		name = "OW Grodno"	
		strength = 20
		type = garrison
		}
	}

landunit = {
	id = { type = 30013 id = 7 }
	name = "Armia Modlin"
	location = 305 #Torun
	leader = 8107 # Przedrzyminski-Krukowicz

	division = {
		id = { type = 30013 id = 8 }
		name = "8 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		
		}
	division = {
		id = { type = 30013 id = 9 }
		name = "20 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		
		}
	division = {
		id = { type = 30013 id = 10 }
		name = "Mazowiecka BK"
		strength = 30.000 
		type = cavalry
		model = 2
		}
	division = {
		id = { type = 30013 id = 11 }
		name = "Nowogródzka BK"
		strength = 30.000 
		type = cavalry
		model = 2
		}
	}

landunit = {
	id = { type = 30013 id = 12 }
	name = "GO Wyszków"
	location = 486 #Ostroleka
	leader = 8064 #Kowalski

	division = {
		id = { type = 30013 id = 13 }
		name = "1 DP Legionów"
		strength = 100
		type = infantry
		model = 1
		}
	division = {
		id = { type = 30013 id = 14 }
		name = "35 Rezerwowa DP"
		strength = 50
		type = infantry
		model = 0
		}
	division = {
		id = { type = 30013 id = 15 }
		name = "41 Rezerwowa DP"
		strength = 100
		type = infantry
		model = 0
		}
	}

landunit = {
	id = { type = 30013 id = 16 }
	name = "Obóz Warowny Modlin"
	location = 486 #Ostroleka
	leader = 8077 #Malinowski

	division = {
		id = { type = 30013 id = 17 }
		name = "Obóz Warowny Modlin"
		strength = 20
		type = infantry
		model = 0
		}
	}

landunit = {
	id = { type = 30013 id = 20 }
	name = "Armia Pomorze"
	location = 303 #Danzig
	leader = 8008 #Bortnowski

	division = {
		id = { type = 30013 id = 21 }
		name = "9 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		}
	division = {
		id = { type = 30013 id = 22 }
		name = "15 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		}
	division = {
		id = { type = 30013 id = 23 }
		name = "27 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		
		}
	}


landunit = {
	id = { type = 30013 id = 24 }
	name = "GO Wschód"
	location = 305 #Torun
	leader = 8006 #Boltuc

	division = {
		id = { type = 30013 id = 25 }
		name = "4 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1		
		}
	division = {
		id = { type = 30013 id = 26 }
		name = "16 Pomorska DP"
		strength = 100
		type = infantry
		model = 1
		}
}

landunit = {
	id = { type = 30013 id = 27 }
	name = "GO Czersk"
	location = 303 #Danzig
	leader = 8043 #Grzmot-Skotnicki

	division = {
		id = { type = 30013 id = 28 }
		name = "Pomorska BK"
		strength = 30.000 
		type = cavalry
		model = 2
		}
	}

landunit = {
	id = { type = 30013 id = 29 }
	name = "Ladowa Obrona Wybrzeza"
	location = 303 #Danzig
	leader = 8021 #Dabek

	division = {
		id = { type = 30013 id = 30 }
		name = "Morska Brygada ON"
		strength = 40
		type = infantry
		model = 0
		}
	}

landunit = {
	id = { type = 30013 id = 31 }
	name = "GO Kutno"
	location = 306 #Bydgoszcz
	leader = 8164 #Zulauf

	division = {
		id = { type = 30013 id = 32 }
		name = "5 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		
		}
	division = {
		id = { type = 30013 id = 33 }
		name = "24 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		
		}
}

landunit = {
		id = { type = 30013 id = 34 }
		name = "Armia Poznan"
		location = 307 #Poznan
		leader = 8070 #Kutrzeba

	division = {
		id = { type = 30013 id = 35 }
		name = "Wielkopolska BK"
		strength = 30.000 
		type = cavalry
		model = 2
		
		}
	division = {
		id = { type = 30013 id = 36 }
		name = "14 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		
		}
	division = {
		id = { type = 30013 id = 37 }
		name = "25 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		
		}
	division = {
		id = { type = 30013 id = 38 }
		name = "26 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		
		}
}

landunit = {
	id = { type = 30013 id = 39 }
	name = "17 Dywizja Piechoty"
	location = 307 #Poznan
	leader = 8081 #Mozdyniewicz

	division = {
		id = { type = 30013 id = 40 }
		name = "17 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		
		}
	}

landunit = {
	id = { type = 30013 id = 41 }
	name = "Podolska BK"
	location = 307 #Poznan
	leader = 8136 #Strzelecki

	division = {
		id = { type = 30013 id = 42 }
		name = "Podolska BK"
		strength = 30.000
		type = cavalry
		model = 2
		
		}
	}

landunit = {
	id = { type = 30013 id = 43 }
	name = "Armia Lódz"
	location = 481 #Czestochowa
	leader = 8115 #Rómmel

	division = {
		id = { type = 30013 id = 44 }
		name = "2 DP Legionów" #Joined Sept. 2nd
		strength = 90
		type = infantry
		model = 1
		
		}
	division = {
		id = { type = 30013 id = 45 }
		name = "10 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		
		}
	division = {
		id = { type = 30013 id = 46 }
		name = "28 Dywizja Piechoty" 
		strength = 100
		type = infantry
		model = 1
		
		}
	division = {
		id = { type = 30013 id = 47 }
		name = "Kresowa BK"
		strength = 30.000 
		type = cavalry
		model = 2
		
		}
	}

landunit = {
	id = { type = 30013 id = 48 }
	name = "GO Piotrków"
	location = 481 #Czestochowa
	leader = 8144 #Thommée

	division = {
		id = { type = 30013 id = 49 }
		name = "30 Dywizja Piechoty"
		strength = 30
		type = infantry
		model = 1
		extra = anti_tank
		}
	division = {
		id = { type = 30013 id = 50 }
		name = "Wolynska BK"
		strength = 30.000 
		type = cavalry
		model = 2
		
		}
	}

landunit = {
	id = { type = 30013 id = 51 }
	name = "Armia Kraków"
	location = 479 #Cieszyn
	leader = 8140 #Szylling

	division = {
		id = { type = 30013 id = 52 }
		name = "6 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		
		}
	division = {
		id = { type = 30013 id = 53 }
		name = "7 Dywizja Piechoty"
		strength = 100
		type = infantry
		model = 1
		
		}
	division = {
		id = { type = 30013 id = 54 }
		name = "45 Rezerwowa DP"
		strength = 20
		type = infantry
		model = 1
		
		}
	division = {
		id = { type = 30013 id = 55 }
		name = "Krakowska BK"
		strength = 30.000 
		type = cavalry
		model = 2
		
		}
	}

landunit = {
	id = { type = 30013 id = 56 }
	name = "10 Pancerno-Motorowa BK"
	location = 479
	leader = 8075 #Maczek

	division = {	
		id = { type = 30013 id = 57 }
		name = "10 Brygada Kawalerii"
		strength = 40.000
		type = motorized
		extra = anti_tank
		}
	}

landunit = {
	id = { type = 30013 id = 58 }
	name = "GO Bielsko"
	location = 479 #Cieszyn
	leader = 8048 #Jagmin-Sadowski

	division = {
		id = { type = 30013 id = 59 }
		name = "21 DP Górskiej"
		strength = 100
		type = bergsjaeger
		model = 1		
		}
	}

landunit = {
	id = { type = 30013 id = 60 }
	name = "GO Slask"
	location = 479 #Cieszyn
	leader = 8009 #Boruta-Spiechowicz

	division = {
		id = { type = 30013 id = 61 }
		name = "23 Górnoslaska DP"
		strength = 100
		type = infantry
		model = 1
		extra = artillery
		}
	division = {
		id = { type = 30013 id = 62 }
		name = "55 Rezerwowa DP"
		strength = 100
		type = infantry
		model = 0
		}
	}

landunit = {
	id = { type = 30013 id = 63 }
	name = "Armia Karpaty"
	location = 489 #Przemysl
	leader = 8033 #Fabrycy

	division = {
		id = { type = 30013 id = 64 }
		name = "1,2,3. Brygada Górska"	
		strength = 100	
		type = bergsjaeger
		model = 1
		}
	division = {
		id = { type = 30013 id = 65 }
		name = "11 Karpacka DP"
		strength = 80
		type = infantry
		model = 1
		
		}
	}

landunit = {
	id = { type = 30013 id = 66 }
	name = "GO Tarnów"
	location = 489 #Przemysl
	leader = 8031 #Engel-Ragis

	division = {
		id = { type = 30013 id = 67 }
		name = "22 DP Górskiej"
		strength = 100
		type = bergsjaeger
		model = 1
		}
	division = {
		id = { type = 30013 id = 68 }
		name = "38 Rezerwowa DP"
		strength = 70
		type = infantry
		model = 1
		extra = artillery
		}
	}

landunit = {
	id = { type = 30013 id = 69 }
	name = "Armia Prusy - Pln"
	location = 487 #Lublin
	leader = 8020 #Dab-Biernacki

	division = {
		id = { type = 30013 id = 70 }
		name = "13 Dywizja Piechoty"
		strength = 70	
		type = infantry
		model = 1
		extra = anti_tank
		}
	division = {
		id = { type = 30013 id = 71 }
		name = "19 Dywizja Piechoty"
		strength = 70
		type = infantry
		model = 1
		}
	division = {
		id = { type = 30013 id = 72 }
		name = "29 Dywizja Piechoty"
		strength = 70
		type = infantry
		model = 1
		}
	division = {
		id = { type = 30013 id = 73 }
		name = "Wilenska BK"
		strength = 30.000 
		type = cavalry
		model = 2
		}
	}

landunit = {
	id = { type = 30013 id = 74 }
	name = "Armia Prusy - Pld"
	location = 484 #Radom
	leader = 8066 #Kruszewski

	division = {
		id = { type = 30013 id = 75 }
		name = "3 DP Legionów"
		strength = 40 #combat-ready on Sept 7th
		type = infantry
		model = 1
		}
	division = {
		id = { type = 30013 id = 76 }
		name = "12 Dywizja Piechoty"
		strength = 40
		type = infantry
		model = 1
		}
	division = {
		id = { type = 30013 id = 77 }
		name = "36 Rezerwowa DP"
		strength = 40
		type = infantry
		model = 0
		}
}

landunit = {
	id = { type = 30013 id = 78 }
	name = "Armia Lublin"
	location = 487 #Lublin
	leader = 8098 #Piskor

	division = {
		id = { type = 30013 id = 79 }
		name = "39 Rezerwowa DP"
		strength = 70
		type = infantry
		model = 0
		}
	}

landunit = {
	id = { type = 30013 id = 80 }
	name = "Warszawska Brygada Panc-Mot"
	location = 487 #Lublin
	leader = 8042 #Grot-Rowecki

	division = {
		id = { type = 30013 id = 81 }
		name = "Warszawska Brygada Panc-Mot"
		strength = 45
		type = light_armor
		model = 1 #Basic Light
		}
}

landunit = {
	id = { type = 30013 id = 82 }
	name = "Garnizon Warszawy"
	location = 485 #Warsaw
	leader = 8018 #Czuma

	division = {
		id = { type = 30013 id = 83 }
		name = "Garnizon Warszawy"
		strength = 90
		type = militia
		}
	}

landunit = {
	id = { type = 30013 id = 84 }
	name = "SGO Polesie" #entered fight on Sept. 14th
	location = 504 #Brzesc
	leader = 8057 #Kleeberg

	division = {
		id = { type = 30013 id = 85 }
		name = "50 Dywizja Piechoty"
		strength = 20 #Brzesc fortress garrison
		type = infantry
		model = 1
		
		}
	division = {
		id = { type = 30013 id = 86 }
		name = "Grupa KOP"
		strength = 70
		type = infantry
		model = 0
		}
	}



landunit = { 
	id = { type = 30013 id = 87 } 
	name = "OW KOP 'Wilno'" 
	location = 208 #Wilno 
#	leader = ? # ?

	division = { 
		id = { type = 30013 id = 88 }
		name = "KOP 'Wilno'"
		type = garrison
		strength = 20.000
		} 
	} 

landunit = { 
	id = { type = 30013 id = 89 } 
	name = "KOP 'Polesie'" 
	location = 503 # Pinsk 
	leader = 8090 #Orlik-Rueckemann

	division = { 
		id = { type = 30013 id = 90 } 
		name = "BKOP 'Polesie'" 
		type = infantry 
		 # KOP
		strength = 33.000 
		} 
	} 

landunit = { 
	id = { type = 30013 id = 91 } 
	name = "KOP 'Równe'" 
	location = 562 #Równe 
	leader = 8002 #Anders

	division = { 
		id = { type = 30013 id = 92 } 
		name = "KOP 'Wilno'" 
		type = garrison 
		strength = 20.000 
		} 
	} 

########################
# Polish 1939 air OOB 
#	
########################

airunit = {
	location = 485 # Warszawa
	id = { type = 30013 id = 93 }
	name = "Brygada Poscigowa"
	leader = 8196 #Zajac

	division = {
		id = { type = 30013 id = 94 }
		name = "1 pulk Brygady Poscigowej"
		type = interceptor
		model = 1
		strength  = 50
		}
	division = {
		id = { type = 30013 id = 95 }
		name = "Jednostki Dyspozycyjne Sztabów"
		type = interceptor
		strength = 20
		}
	}

airunit = {
	id = { type = 30013 id = 96 }
	name = "Brygada Bombowa"
	location = 485 # Warszawa
	leader = 8190 #Pawlikowski

	division = {
		id = { type = 30013 id = 97 }
		name = "1 pulk Brygady Bombowej"
		type = tactical_bomber
		model = 1
		strength = 45 #45 planes in the first line on Sept 1st
		}
	division = {
		id = { type = 30013 id = 98 }
		name = "2 pulk Brygady Bombowej"
		type = tactical_bomber
		model = 0
		strength = 46
		}
	}

airunit = {
	id = { type = 30013 id = 99 }
	name = "Lotnictwo Armii Poznan"
	location = 307 #Poznan
	leader = 8187 #Kuzminski

	division = {
		id = { type = 30013 id = 100 }
		name = "Lotnictwo Armii Poznan"
		type = interceptor
		model = 1
		strength = 36
		}
	}


airunit = {
	id = { type = 30013 id = 101 }
	name = "Lotnictwo Armii Lódz"
	location = 307 #Czestochowa
	leader = 8180 #Iwaszkiewicz

	division = {
		id = { type = 30013 id = 102 }
		name = "Lotnictwo Armii Lódz"
		type = interceptor
		strength = 34
		}
	}

airunit = {
	id = { type = 30013 id = 103 }
	name = "Lotnictwo Armii Kraków"
	location = 479 #Cieszyn
	leader = 8188 #Lewandowski

	division = {
		id = { type = 30013 id = 104 }
		name = "Lotnictwo Armii Kraków"
		type = interceptor
		model = 1
		strength = 33
		}
	}

airunit = {
	id = { type = 30013 id = 105 }
	name = "Lotnictwo Armii Karpaty"
	location = 489 #Przemysl
	leader = 8195 #Tuskiewicz

	division = {
		id = { type = 30013 id = 106 }
		name = "Lotnictwo Armii Karpaty"
		type = interceptor
		model = 0
		strength = 22
		}
	}

airunit = {
	id = { type = 30013 id = 107 }
	name = "Lotnictwo Armii Pomorze"
	location = 303 #Danzig
	leader = 8194 #Stachon

	division = {
		id = { type = 30013 id = 108 }
		name = "Lotnictwo Armii Pomorze"
		type = interceptor
		model = 1
		strength = 30
		}
	}

airunit = {
	id = { type = 30013 id = 109 }
	name = "Lotnictwo Armii Modlin"
	location = 305 #Torun
	leader = 8192 #Prauss

	division = {
		id = { type = 30013 id = 110 }
		name = "Lotnictwo Armii Modlin"
		type = interceptor
		model = 0
		strength = 20
		}
	}

airunit = {
	id = { type = 30013 id = 111 }
	name = "Lotnictwo SGO Narew"
	location = 509 #Suwalki
	leader = 8189 #Nazarkiewicz

	division = {
		id = { type = 30013 id = 112 }
		name = "Lotnictwo SGO Narew"
		type = interceptor
		model = 0
		strength = 20
		}
	}


################################
# Polish Naval OOB
################################

navalunit = {
	id = { type = 30013 id = 114 }
	name = "Marynarka Wojenna"
	location = 303 #Danzig
	base = 303
	leader = 8175 #Unrug

	division = {
		id = { type = 30013 id = 115 }
		name = "ORP Wicher"
		type = destroyer
		model = 1 #Wicher-class
		strength = 20.000 
		}
	division = {
		id = { type = 30013 id = 116 }
		name = "ORP Gryf"
		type = destroyer
		model = 0 #Gryf-class
		strength = 25.000
		}
	}

navalunit = {
	id = { type = 30013 id = 117 }
	name = "Dywizjon Minowców"
	location = 303 #Danzig
	base = 303
	leader = 8170 #Korytowski

	division = {
		id = { type = 30013 id = 118 }
		name = "ORP Jaskólka"
		type = destroyer
		model = 0
		strength = 100.000 
		}
}


navalunit = {
	id = { type = 30013 id = 119 }
	name = "1 Dywizjon OP"
	location = 303 #Danzig
	base = 303
	leader = 8173 #Swirski

	division = {
		id = { type = 30013 id = 120 }
		name = "ORP Zbik"
		strength = 40.000 		
		type = submarine 
		model = 1
		}
	division = {
		id = { type = 30013 id = 121 }
		name = "ORP Orzel"
		strength = 40.000 
		type = submarine
		model = 2 #Orzel-class

		}
}

#############END#################
}
