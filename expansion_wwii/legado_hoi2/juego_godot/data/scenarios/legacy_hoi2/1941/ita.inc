province = {
	id = 919
	anti_air = 2
	naval_base = {
		size = 2
		current_size = 2
		}
	air_base = {
		size = 2
		current_size = 2
		}
	}

province = {
	id = 1033
	anti_air = 1
	naval_base = {
		size = 2
		current_size = 2
		}
	air_base = {
		size = 4
		current_size = 4
		}
	}

province = {
	id = 523
	anti_air = 1
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
	id = 515
	anti_air = 1
	air_base = {
		size = 10
		current_size = 10
		}
	}

province = {
	id = 932
	anti_air = 1
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
	id = 924
	anti_air = 1
	naval_base = {
		size = 5
		current_size = 5
		}
	air_base = {
		size = 4
		current_size = 4
		}
	}

province = {
	id = 378
	anti_air = 1
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
	id = 368
	anti_air = 1
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
	id = 369
	anti_air = 1
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
	id = 525
	anti_air = 2
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
	id = 534
	anti_air = 1
	naval_base = {
		size = 2
		current_size = 2
		}
	air_base = {
		size = 4
		current_size = 4
		}
	}

province = {
	id = 531
	anti_air = 1
	naval_base = {
		size = 2
		current_size = 2
		}
	air_base = {
		size = 4
		current_size = 4
		}
	}


province = {
	id = 1085
	anti_air = 1
	naval_base = {
		size = 2
		current_size = 2
		}
	air_base = {
		size = 4
		current_size = 4
		}
	}


province = {
	id = 1038
	anti_air = 1
	naval_base = {
		size = 2
		current_size = 2
		}
	air_base = {
		size = 4
		current_size = 4
		}
	}

province = {
	id = 370
	air_base = {
		size = 4
		current_size = 4
		}
	}

province = {
	id = 399
	air_base = {
		size = 4
		current_size = 4
		}
	}


province = {
	id = 521
	air_base = {
		size = 4
		current_size = 4
		}
	}



#Anti Aircraft Batteries
province = { id = 932   antiair = 3 } #Torino
province = { id = 933   antiair = 2 } #Genoa
province = { id = 912   antiair = 4 } #Milano
province = { id = 913   antiair = 2 } #La Spezia
province = { id = 567   antiair = 1 } #Venezia
province = { id = 910   antiair = 1 } #Parma
province = { id = 905   antiair = 1 } #Bologna
province = { id = 906   antiair = 1 } #Firenze
province = { id = 908   antiair = 4 } #Roma
province = { id = 901   antiair = 2 } #Napoli
province = { id = 893   antiair = 2 } #Taranto
province = { id = 897   antiair = 2 } #Messina
province = { id = 1085  antiair = 2 } #Tripoli
province = { id = 1097  antiair = 3 } #Tobruk
province = { id = 1098  antiair = 2 } #Benghazi

country = {
	tag = ITA
	alignment = { x = 30 y = -70 }
	ai = "Italy.ai"


	# Resource Reserves
	oil		= 1500
	steel	= 8500
	coal	= 16000
	rubber	= 1500
	supplies = 5000
	manpower = 265000

	headofstate = { type = 9 id = 3001 }
	headofgovernment = { type = 9 id = 3002 }
	foreignminister = { type = 9 id = 3003 }
	armamentminister = { type = 9 id = 3051 }
	ministerofsecurity = { type = 9 id = 3066 }
	ministerofintelligence = { type = 9 id = 3077 }
	chiefofstaff = { type = 9 id = 3085 }
	chiefofarmy = { type = 9 id = 3098 }
	chiefofnavy = { type = 9 id = 3102 }
	chiefofair = { type = 9 id = 3110 }

	capital = 908
	ownedprovinces =      {
		933 932 912 563 567 910 905 906 908 907 900 938 901 902 893 903 898 897 913 885 883 754 820
		#Libya
		1092 1094 1095 1097 1096 1089 1098 1106 1107 1105 1088 1087 1086 1085 1084
		#Yugoslav territory
		752 751 753
		#Ethiopia
		1288 1290 1293 1294 1295 1296 1297 1299 1302 1285
	}
	controlledprovinces = {
		933 932 912 563 567 910 905 906 908 907 900 938 901 902 893 903 898 897 913 885 883 754 820
		#Libya
		1092 1095 1096 1089 1098 1106 1107 1105 1088 1087 1086 1085 1084
		#Yugoslav territory
		752 751 753
		
	}
	nationalprovinces =   {
		933 932 912 563 567 910 905 906 908 907 900 938 901 902 893 903 898 897 913 885 883 896
		#Libya
		1092 1094 1095 1097 1096 1089 1098 1106 1107 1105 1088 1087 1086 1085 1084
		
	}

	### TECH ###

	techlevels = {
		# Italia tech levels 1941
		12000 12100 12200 13000 13100 11000 11100 11200 14000 14100 1000 1100 1200
		1300 1400 2000 2100 2200 2300 5000 5100 5200 5300 5400 6000 6100 6200 6300
		6400 6500 9000 9100 9200 9300 9400 9500 10000 10100 10200 10300 10400 10500
		7000 7100 7200 8000 8100 8200 8300 8400 3000 3100 3200 4000 4100 4200 4300
		4400 4500
		13200 1500 2400 4600 7300 11300 12300 13300
		14200
		14300
		14400
	}

	techapps = {
		# Italia tech apps 1941
		12001 12002 12004 12101 12102 13002 13004 13103 13104 13006 13102 11001 11002 11004 11104
		14001 14002 14003 14004 14005 14007 14008 14009 14010 14011 14012 14013 14014
		14015 14016 14101 14105 1001 1101 1102 1103 1107 1201 1202 1203 1204 1205 1301 1304
		1401 2001 2002 2003 2005 2006 2101 2102 2103 2105 2201 2202 2203 2301 2302
		2303 2305 2314 2317 5001 5002 5003 5004 5005 5101 5102 5103 5202 5204 5302 6001
		6002 6003 6004 6005 6006 6007 6008 6009 6010 6011 6012 6101 6102 6103 6104 6105 6106
		6107 6108 6109 6110 6111 6201 6202 6203 6205 6206 6401 6402 6403 6404 6406 6501
		6502 6504 6505 6507 6508 9001 9002 9003 9004 9005 9006 9101 9102 9103 9104 9105
		9106 9107 9109 9201 9202 9203 9301 9303 9401 9402 9403 9404 9405 9406 9503 9504
		9505 9506 9507 9508 9509 9511 10001 10002 10003 10004 10005 10101 10102 10103
		10104 10105 10106 10201 10202 10301 10305 10306 10401 10402 10502 10503 10504
		10505 10506 10507 7001 7002 7101 7102 7103 8401 8402 3001 3002 3003 3004 3005
		3006 3007 3101 3102 3103 3104 4001 4101 4102 4201 4202 4203 4204 4301 4302 4303
		1302 1105 1206 1207 1208 1305 1402 1403 1407 1501 1502 1503 1504 1505 2204 2208 2209 2211 2306 2307
		1303 2308 4401 4403 4503 4601 7003 7201 7202 7203 7301
		2004 14102 14103 14104 14106 14107 14201 14204 14206 14207 11003 11103 12003 9108 9204 
		6301 12201 12202 12204 12205 13003 13201 13202 13205 13302 6112 6204
		4402 4501 4502 11102 11203
		13001
		13005
		13207
		14402
		14403
		14006
	}

	### Italian OOB 1941 ####

	landunit = {

		id = { type = 10908 id = 800 }
		location = 932
		name = "1a Armata"
		#Gen. P. Pintor#

		division = {
			id = { type = 10908 id = 801 }
			name = "7a Divisione 'Lupi di Toscana'"
			type = infantry
			extra = artillery
			strength  = 100
			organisation = 30
		}

		division = {
			id = { type = 10908 id = 804 }
			name = "5a Divisione Alpina 'Pusteria'"
			type = bergsjaeger
			strength  = 70
			organisation = 30
		}
	}


	landunit = {
		id = { type = 10908 id = 806 }
		location = 933
		name = "2a Corpo d'Armata"

		division = {
			id = { type = 10908 id = 807 }
			name = "4a Divisione 'Livorno'"
			extra = artillery
			type = infantry
			strength  = 100
			organisation = 30
		}
		division = {
			id = { type = 10908 id = 809 }
			name = "36a Divisione 'Forli'"
			type = infantry
			strength  = 100
			organisation = 30
		}
	}



	landunit = {
		id = { type = 10908 id = 812 }
		location = 912
		name = "3a Corpo d'Armata"
		#Gen. M. Arisio#

		division = {
			id = { type = 10908 id = 814 }
			name = "6a Divisione 'Cueno'"
			type = infantry
			strength  = 70
			organisation = 30
		}
	}

	landunit = {
		id = { type = 10908 id = 816 }
		location = 932
		name = "15a Corpo d'Armata"
		#Gen. M. Arisio#

		division = {
			id = { type = 10908 id = 819 }
			name = "44a Divisione 'Cremona'"
			type = infantry
			strength  = 100
		}
	}



	landunit = {
		id = { type = 10908 id = 824 }
		location = 893
		name = "1a Corpo d'Armata"
		#Gen. C. Vecchiarelli#

		division = {
			id = { type = 10908 id = 825 }
			name = "1a Divisione 'Superga'"
			type = infantry
			strength  = 100
		}
		division = {
			id = { type = 10908 id = 826 }
			name = "24a Divisione 'Pinerolo'"
			type = infantry
			strength  = 100
		}
	}


	landunit = {
		id = { type = 10908 id = 832 }
		location = 913
		name = "Corpo d'Armata Alpino"

		division = {
			id = { type = 10908 id = 833 }
			name = "1a Divisione Alpina 'Taurinese'"
			type = bergsjaeger
			strength  = 100
			organisation = 30
		}
	}


	landunit = {
		id = { type = 10908 id = 837 }
		location = 567
		name = "5a Corpo d'Armata"
		#Gen. R. Balocco#

		division = {
			id = { type = 10908 id = 838 }
			name = "12a Divisione 'Sassari'"
			type = infantry
			strength  = 70
			organisation = 30
		}
		division = {
			id = { type = 10908 id = 839 }
			name = "15a Divisione 'Bergamo'"
			type = infantry
			strength  = 70
			organisation = 30
		}
		division = {
			id = { type = 10908 id = 840 }
			name = "57a Divisione 'Lombardia'"
			type = infantry
			strength  = 70
			organisation = 30
		}
	}

	landunit = {
		id = { type = 10908 id = 841 }
		location = 567
		name = "11a Corpo d'Armata"

		division = {
			id = { type = 10908 id = 842 }
			name = "13a Divisione 'Re'"
			type = infantry
			strength  = 70
			organisation = 30
		}
		division = {
			id = { type = 10908 id = 843 }
			name = "14a Divisione 'Isonzo'"
			type = infantry
			strength  = 70
			organisation = 30
		}
	}

	landunit = {

		id = { type = 10908 id = 844 }
		location = 910
		name = "Celere"
		#Gen. G. Messe#

		division = {
			id = { type = 10908 id = 845 }
			name = "1a Divisione Celere 'Eugenio di Savoia'"
			type = cavalry
			strength  = 100
			organisation = 30
		}
		division = {
			id = { type = 10908 id = 846 }
			name = "2a Divisione Celere 'Emanuele Filiberto'"
			type = cavalry
			strength  = 100
			organisation = 30
		}
	}



	landunit = {

		id = { type = 10908 id = 857 }
		location = 905
		name = "6a Corpo d'Armata"
		#Gen. E.Rossi#

		division = {
			id = { type = 10908 id = 858 }
			name = "18a Divisione 'Messina'"
			type = infantry
		}
		division = {
			id = { type = 10908 id = 859 }
			name = "49a Divisione 'Parma'"
			type = infantry
		}
	}

	#
	landunit = {
		id = { type = 10908 id = 861 }
		location = 905
		name = "14a Corpo d'Armata"
		#Gen. G.Vecchi#

		division = {
			id = { type = 10908 id = 862 }
			name = "32a Divisione 'Marche'"
			type = infantry
			strength  = 70
			organisation = 30
		}
		division = {
			id = { type = 10908 id = 863 }
			name = "38a Divisione 'Puglie'"
			type = infantry
			strength  = 70
			organisation = 30
		}
	}


	landunit = {
		#Army Group South, Emilio de Bono, Around palermo-syracuse#
		#
		id = { type = 10908 id = 864 }
		location = 898
		name = "12a Corpo d'Armata"
		#Gen. A.Rossi#

		division = {
			id = { type = 10908 id = 865 }
			name = "28a Divisione 'Aosta'"
			type = infantry
			strength  = 70
			organisation = 30
		}
		division = {
			id = { type = 10908 id = 866 }
			name = "54a Divisione 'Napoli'"
			type = infantry
			strength  = 70
			organisation = 30
		}
	}

	landunit = {
		#
		id = { type = 10908 id = 867 }
		location = 897
		name = "13a Corpo d'Armata"
		#Gen. E.Rossi#

		division = {
			id = { type = 10908 id = 868 }
			name = "30a Divisione 'Sabauda'"
			type = infantry
			strength  = 70
			organisation = 30
		}
		division = {
			id = { type = 10908 id = 869 }
			name = "31a Divisione 'Calabria'"
			type = infantry
			strength  = 70
			organisation = 30
		}
	}

	###########################################
	#Army Group North Africa
	#Gen. E.- Bastico#
	###########################################
	landunit = {
		id = { type = 10908 id = 870 }
		location = 1095
		name = "Motocorazzato"
		####bir el hakim
		division = {
			id = { type = 10908 id = 851 }
			name = "132a Divisione Corazzata 'Ariete'"
			type = panzer
			model = 15
			strength  = 55
			organisation = 30
		}

		division = {
			id = { type = 10908 id = 852 }
			name = "102a Divisione Motocorazzata 'Trento'"
			type = motorized
			strength  = 55
			organisation = 30
		}
		division = {
			id = { type = 10908 id = 853 }
			name = "101a Divisione Motocorazzata 'Trieste'"
			type = motorized
			strength  = 55
			organisation = 30
		}
	}


	#Darnah#
	landunit = {
		id = { type = 10908 id = 871 }
		location = 1096
		name = "21a Corpo d'Armata"


		division = {
			id = { type = 10908 id = 854 }
			name = "133a Divisione Corazzata'Littorio'"
			type = panzer
			model = 15
			strength  = 50
			organisation = 30
		}

		division = {
			id = { type = 10908 id = 855 }
			name = "27a Divisione 'Brescia'"
			type = infantry
			model = 0
			strength  = 55
			organisation = 30
		}

		division = {
			id = { type = 10908 id = 856 }
			name = "25a Divisione 'Bologna'"
			type = infantry
			model = 0
			strength  = 55
			organisation = 30
		}

	}


	#######Bardia, also the 90th Light german div!##########
	landunit = {
		#
		id = { type = 10908 id = 872 }
		location = 1092
		name = "20a Corpo d'Armata"

		division = {
			id = { type = 10908 id = 879 }
			name = "17a Divisione 'Pavia'"
			type = infantry
			strength  = 50
			organisation = 30
		}
		division = {
			id = { type = 10908 id = 880 }
			name = "Folgore"
			type = paratrooper
			strength  = 30
			organisation = 30
		}
	}

	landunit = {
		#
		id = { type = 10908 id = 885 }
		location = 1085
		name = "23a Corpo d'Armata"

		division = {
			id = { type = 10908 id = 886 }
			name = "63a Divisione 'Cirene'"
			type = infantry
			strength  = 70
			organisation = 30
		}
		division = {
			id = { type = 10908 id = 887 }
			name = "62a Divisione 'Marmarica'"
			type = infantry
			strength  = 70
			organisation = 30
		}
	}


	#######################

	landunit = {

		id = { type = 10908 id = 891 }
		location = 908
		name = "9a Corpo d'Armata"
		#Gen. C.Rossi#

		division = {
			id = { type = 10908 id = 892 }
			name = "29a Divisione 'Piemonte'"
			type = infantry
			strength  = 100
		}
		division = {
			id = { type = 10908 id = 894 }
			name = "48a Divisione 'Taro'"
			type = infantry
			strength  = 100
		}
	}

	##################
	landunit = {

		id = { type = 10908 id = 899 }
		location = 906
		name = "7a Corpo d'Armata"

		division = {
			id = { type = 10908 id = 900 }
			name = "41a Divisione 'Firenze'"
			type = infantry
			strength  = 100
		}
	}

	landunit = {

		id = { type = 10908 id = 902 }
		location = 902
		name = "8a Corpo d'Armata"

		division = {
			id = { type = 10908 id = 903 }
			name = "51a Divisione 'Siena'"
			type = infantry
			strength  = 100
		}
	}


	#############rhodos
	landunit = {
		#Aegan Corps, rhodos?#
		id = { type = 10908 id = 947 }
		location = 885
		name = "9a Corpo d'Armata"
		#Gen. De Vecchi di val cismon#

		division = {
			id = { type = 10908 id = 948 }
			name = "50a Divisione 'Regina'"
			type = infantry
			strength  = 70
			organisation = 30
		}
	}

	################albania
	landunit = {
	
		id = { type = 10908 id = 949 }
		location = 754
		name = "16a Corpo d'Armata"
		#Gen. S .visconti prascai#

		division = {
			id = { type = 10908 id = 950 }
			name = "19a Divisione 'Venezia'"
			type = infantry
			strength  = 100
		}
		division = {
			id = { type = 10908 id = 952 }
			name = "53a Divisione 'Arezzo'"
			type = infantry
			strength  = 100
		}
	}


	##################################
	#########Italian exp. forces/russia######
	##################################

	landunit = {
		id = { type = 10908 id = 828 }
		location = 857
		name = "3a Corpo di Spedizione"
		control = germany

		division = {
			id = { type = 10908 id = 829 }
			name = "2a Divisione 'Sforzesca'"
			type = infantry
			strength  = 55
		}
		division = {
			id = { type = 10908 id = 813 }
			name = "3a Divisione 'Ravenna'"
			type = infantry
			extra = artillery
			strength  = 55
			organisation = 30
		}

		division = {
			id = { type = 10908 id = 817 }
			name = "5a Divisione 'Cosseria'"
			type = infantry
			strength  = 55
			organisation = 30
		}

	}

	landunit = {
		id = { type = 10908 id = 848 }
		location = 857
		name = "35 Corpo di Spedizione"
		control = germany

		division = {
			id = { type = 10908 id = 849 }
			name = "9a Divisione 'Pasubio'"
			type = motorized
			strength  = 55
			organisation = 30
		}

		division = {
			id = { type = 10908 id = 850 }
			name = "52a Divisione 'Torino'"
			type = motorized
			strength  = 55
			organisation = 30
		}

		division = {
			id = { type = 10908 id = 847 }
			name = "3a Divisione 'Principe Amedeo'"
			type = cavalry
			strength  = 65
			organisation = 30
		}

	}

	landunit = {
		id = { type = 10908 id = 820 }
		location = 770
		name = "Corpo d'Armata Alpino"
		control = germany

		division = {
			id = { type = 10908 id = 823 }
			name = "2a Divisione Alpina 'Tridentina'"
			type = bergsjaeger
			strength  = 80
			organisation = 30
		}

		division = {
			id = { type = 10908 id = 953 }
			name = "3a Divisione Alpina 'Julia'"
			type = bergsjaeger
			strength  = 80
			organisation = 30
		}

		division = {
			id = { type = 10908 id = 810 }
			name = "4a Divisione Alpina 'Cuneense'"
			type = bergsjaeger
			strength  = 70
		}

	}





	############################
	############################
	airunit = {
		location = 912
		id = { type = 10908 id = 166 }
		name = "2a Comando Caccia 'Borea'"

		division = {
			id = { type = 10908 id = 167 }
			name = "2a Divisione Caccia 'Borea'"
			strength = 50
			type = fighter
			model = 1
		}
	}
	################################
	airunit = {
		location = 897
		id = { type = 10908 id = 169 }
		name = "2nd Squadra Aerea"

		division = {
			id = { type = 10908 id = 170 }
			name = "6a Divisione Caccia"
			strength = 50
			type = fighter
			model = 1
		}
	}
	airunit = {
		location = 897
		id = { type = 10908 id = 171 }
		name = "3a Comando Aerosiluranti 'Centauro'"

		division = {
			id = { type = 10908 id = 172 }
			name = "11a Stormo Aerosiluranti Wing"
			strength = 50
			type = naval_bomber
			model = 1
		}
	}
	airunit = {
		location = 897
		id = { type = 10908 id = 175 }
		name = "11a Comando Aerosiluranti 'Nibbio'"

		division = {
			id = { type = 10908 id = 176 }
			name = "30a Stormo Aerosiluranti"
			strength = 50
			type = naval_bomber
			model = 2
		}
	}
	airunit = {
		location = 897
		id = { type = 10908 id = 178 }
		name = "1a Comando Caccia 'Aquila'"

		division = {
			id = { type = 10908 id = 179 }
			name = "1a Divisione Caccia 'Aquila'"
			strength = 50
			type = fighter
			model = 4
		}
	}
	###################################
	airunit = {
		location = 906
		id = { type = 10908 id = 180 }
		name = "3rd Squadra Aerea"

		division = {
			id = { type = 10908 id = 181 }
			name = "7a Divisione Caccia"
			strength = 50
			type = fighter
			model = 4
		}
	}
	airunit = {
		location = 906
		id = { type = 10908 id = 182 }
		name = "5a Comando Aerosiluranti 'Eolo'"

		division = {
			id = { type = 10908 id = 184 }
			name = "9a Stormo Aerosiluranti"
			strength = 50
			type = naval_bomber
			model = 1
		}
	}
	airunit = {
		location = 906
		id = { type = 10908 id = 185 }
		name = "8a Comando Caccia 'Astore'"

		division = {
			id = { type = 10908 id = 186 }
			name = "8a Divisione Caccia 'Astore'"
			strength = 50
			type = fighter
			model = 1
		}
	}
	##########################################
	airunit = {
		location = 893
		id = { type = 10908 id = 188 }
		name = "4th Squadra Aerea"

		division = {
			id = { type = 10908 id = 189 }
			name = "35a Stormo Bombardieri Tattici"
			strength = 50
			type = tactical_bomber
			model = 1
		}
		division = {
			id = { type = 10908 id = 191 }
			name = "39a Divisione Trasporti"
			strength = 50
			type = transport_plane
			model = 0
		}
	}
		###############################################
		airunit = {
			location = 938
			id = { type = 10908 id = 192 }
			name = "Aeronautica Sardegna"

			division = {
				id = { type = 10908 id = 193 }
				name = "10a Stormo Aerosiluranti 'Marte' "
				strength = 30
				type = naval_bomber
				model = 1
			}
			division = {
				id = { type = 10908 id = 194 }
				name = "3a Divisione Caccia"
				strength = 30
				type = fighter
				model = 1
			}
		}
		###############################################
		airunit = {
			location = 1085
			id = { type = 10908 id = 199 }
			name = "Aeronautica Libia Ovest"

			division = {
				id = { type = 10908 id = 200 }
				name = "2a Divisione Caccia"
				strength = 50
				type = fighter
				model = 1
			}
			division = {
				id = { type = 10908 id = 202 }
				name = "15a Stormo Aerosiluranti"
				strength = 30
				type = naval_bomber
				model = 2
			}
		}
		############################################
		airunit = {
			location = 1098
			id = { type = 10908 id = 204 }
			name = "Aeronautica Libia Est"

			division = {
				id = { type = 10908 id = 205 }
				name = "14a Divisione Caccia 'Rex'"
				strength = 50
				type = fighter
				model = 1
			}
			division = {
				id = { type = 10908 id = 206 }
				name = "13a Stormo Bombardieri Tattici 'Pegaso'"
				strength = 50
				type = tactical_bomber
				model = 2
			}
		}
		#############################################
		airunit = {
			location = 1098
			id = { type = 10908 id = 208 }
			name = "Aeronautica AOI"

			division = {
				id = { type = 10908 id = 209 }
				name = "AOI Divisione Caccia"
				strength = 30
				type = fighter
				model = 1
			}
			division = {
				id = { type = 10908 id = 210 }
				name = "AOI Stormo Bombardieri Tattici"
				strength = 30
				type = tactical_bomber
				model = 2
			}
		}

		############################
		############################

		navalunit = {
			id = { type = 10908 id = 212 }
			name = "Regia Marina"
			location = 893

	 		division = { id = { type = 10908 id = 400 } name = "RM Taranto" type = cruiser model = 0 }
	 		division = { id = { type = 10908 id = 401 } name = "RM Bari" type = cruiser model = 0 }
			division = {
				id = { type = 10908 id = 213 }
				name = "2a Flottiglia Torpediniere"
				type = destroyer
				model = 1
			}
		}
		###################################

		navalunit = {
			id = { type = 10908 id = 217 }
			name = "1a Divisione/1a Squadra"
			location = 894

			division = {
				id = { type = 10908 id = 214 }
				name = "RM Vittorio Veneto"
				type = battleship
				model = 3
			}

			division = {
				id = { type = 10908 id = 219 }
				name = "RM Gorizia"
				type = cruiser
				model = 2
			}
			division = {
				id = { type = 10908 id = 221 }
				name = "9a Flottiglia Torpediniere"
				type = destroyer
				model = 1
			}
			division = {
				id = { type = 10908 id = 305 }
				name = "Flottiglia 'Tarquinia'"
				type = transport
			}
		}
		navalunit = {
			id = { type = 10908 id = 500 }
			name = "RM Littorio"
			location = 894
			division = {
				id = { type = 10908 id = 501 }
				name = "RM Littorio"
				strength = 50
				type = battleship
				model = 3 
			}
		}

		navalunit = {
			id = { type = 10908 id = 222 }
			name = "4a Divisione/1a Squadra"
			location = 894

			division = {
				id = { type = 10908 id = 223 }
				name = "RM Alberico da Barbiano"
				type = cruiser
				model = 1
   				maxspeed = 34
			}
			division = {
				id = { type = 10908 id = 224 }
				name = "RM Luigi Cadorna"
				type = cruiser
				model = 1
			}
			division = {
				id = { type = 10908 id = 225 }
				name = "RM Alberto da Guissano"
				type = cruiser
				model = 1
   				maxspeed = 34
			}
			division = {
				id = { type = 10908 id = 226 }
				name = "RM Eugena di Savoia"
				type = cruiser
				model = 1
   				maxspeed = 34
			}
			division = {
				id = { type = 10908 id = 227 }
				name = "12a Flottiglia Torpediniere"
				type = destroyer
				model = 1
			}
			division = {
				id = { type = 10908 id = 306 }
				name = "Flottiglia 'Porto di Roma'"
				type = transport
			}
		}
		navalunit = {
			id = { type = 10908 id = 228 }
			name = "5a Divisione/1a Squadra"
			location = 894

			division = {
				id = { type = 10908 id = 230 }
				name = "7a Flottiglia Torpediniere"
				type = destroyer
				model = 1
			}
			division = {
				id = { type = 10908 id = 231 }
				name = "8a Flottiglia Torpediniere"
				type = destroyer
				model = 1
			}
			division = {
				id = { type = 10908 id = 307 }
				name = "Flottiglia 'Giampaolo'"
				type = transport
			}
		}
		navalunit = {
			id = { type = 10908 id = 232 }
			name = "8a Divisione/1a Squadra"
			location = 894

			division = {
				id = { type = 10908 id = 235 }
				name = "16a Flottiglia Torpediniere"
				type = destroyer
				model = 1
			}
			division = {
				id = { type = 10908 id = 308 }
				name = "Flottiglia 'Aventino'"
				type = transport
			}
		}
		navalunit = {
			id = { type = 10908 id = 236 }
			name = "9a Divisione/1a Squadra"
			location = 894


			division = {
				id = { type = 10908 id = 239 }
				name = "14a Flottiglia Torpediniere"
				type = destroyer
				model = 1
			}
			division = {
				id = { type = 10908 id = 309 }
				name = "Flottiglia 'Puccini'"
				type = transport
			}
		}

		####################################
		navalunit = {
			id = { type = 10908 id = 241 }
			name = "2a Squadra"
			location = 933

			division = {
				id = { type = 10908 id = 242 }
				name = "RM Duca degli Abruzzi"
				type = cruiser
				model = 1
				maxspeed = 35
			}
		}
		navalunit = {
			id = { type = 10908 id = 243 }
			name = "2a Divisione/2a Squadra"
			location = 933

			division = {
				id = { type = 10908 id = 244 }
				name = "RM Bande Nere"
				type = cruiser
				model = 1
   				maxspeed = 34
			}
			division = {
				id = { type = 10908 id = 245 }
				name = "RM Guiseppe Garibaldi"
				type = cruiser
				model = 1
				maxspeed = 35
			}
			division = {
				id = { type = 10908 id = 246 }
				name = "10a Flottiglia Torpediniere"
				type = destroyer
				model = 0
			}
			division = {
				id = { type = 10908 id = 310 }
				name = "Flottiglia 'Aspromonte'"
				type = transport
			}
		}
		navalunit = {
			id = { type = 10908 id = 247 }
			name = "3a Divisione/2a Squadra"
			location = 933

			division = {
				id = { type = 10908 id = 248 }
				name = "RM Trento"
				type = cruiser
				model = 2
			}
			division = {
				id = { type = 10908 id = 249 }
				name = "RM Bolzano"
				type = cruiser
				model = 2
			}
			division = {
				id = { type = 10908 id = 250 }
				name = "RM Trieste"
				type = cruiser
				model = 2
			}
			division = {
				id = { type = 10908 id = 311 }
				name = "Flottiglia 'Maria'"
				type = transport
			}
		}
		navalunit = {
			id = { type = 10908 id = 252 }
			name = "7a Divisione/2a Squadra"
			location = 933

			division = {
				id = { type = 10908 id = 254 }
				name = "RM Duca d'Aosta"
				type = cruiser
				model = 1
   				maxspeed = 34
			}
			division = {
				id = { type = 10908 id = 255 }
				name = "RM Muzio Attendolo"
				type = cruiser
				model = 1
   				maxspeed = 34
			}
			division = {
				id = { type = 10908 id = 256 }
				name = "RM Raimondo Montecuccolio"
				type = cruiser
				model = 0
   				maxspeed = 34
			}
			division = {
				id = { type = 10908 id = 312 }
				name = "Flottiglia 'Sagittario'"
				type = transport
			}
		}

		######################################

		navalunit = {
			id = { type = 10908 id = 258 }
			name = "Flotta Sommergibili"
			location = 901

			division = {
				id = { type = 10908 id = 260 }
				name = "51a Flottiglia Sommergibili"
				type = submarine
				model = 0
			}
			division = {
				id = { type = 10908 id = 261 }
				name = "52a Flottiglia Sommergibili"
				type = submarine
				model = 0
			}
		}

		navalunit = {
			id = { type = 10908 id = 262 }
			name = "1a Flottiglia Sommergibili"
			location = 904

			division = {
				id = { type = 10908 id = 263 }
				name = "11a Flottiglia Sommergibili"
				type = submarine
				model = 0
			}
			division = {
				id = { type = 10908 id = 264 }
				name = "12a Flottiglia Sommergibili"
				type = submarine
				model = 0
			}
			division = {
				id = { type = 10908 id = 265 }
				name = "13a Flottiglia Sommergibili"
				type = submarine
				model = 0
			}
			division = {
				id = { type = 10908 id = 266 }
				name = "14a Flottiglia Sommergibili"
				type = submarine
				model = 0
			}
		}
		navalunit = {
			id = { type = 10908 id = 270 }
			name = "2a Flottiglia Sommergibili"
			location = 1002

			division = {
				id = { type = 10908 id = 271 }
				name = "21a Flottiglia Sommergibili"
				type = submarine
				model = 0
			}

			division = {
				id = { type = 10908 id = 272 }
				name = "22a Flottiglia Sommergibili"
				type = submarine
				model = 0
			}
		}
		navalunit = {
			id = { type = 10908 id = 273 }
			name = "3a Flottiglia Sommergibili"
			location = 899

			division = {
				id = { type = 10908 id = 274 }
				name = "31a Flottiglia Sommergibili"
				type = submarine
				model = 0
			}
			division = {
				id = { type = 10908 id = 275 }
				name = "33a Flottiglia Sommergibili"
				type = submarine
				model = 0
			}
			division = {
				id = { type = 10908 id = 276 }
				name = "34a Flottiglia Sommergibili"
				type = submarine
				model = 0
			}
		}
		navalunit = {
			id = { type = 10908 id = 279 }
			name = "4a Flottiglia Sommergibili"
			location = 901

			division = {
				id = { type = 10908 id = 280 }
				name = "40a Flottiglia Sommergibili"
				type = submarine
				model = 1
			}
			division = {
				id = { type = 10908 id = 281 }
				name = "41a Flottiglia Sommergibili"
				type = submarine
				model = 1
			}
		}
		######################################################
		navalunit = {
			id = { type = 10908 id = 293 }
			name = "Comando Naval Libico"
			location = 1085

			division = {
				id = { type = 10908 id = 294 }
				name = "1a Flottiglia Torpediniere"
				type = destroyer
				model = 0
			}
		}

		navalunit = {
			id = { type = 10908 id = 295 }
			name = "6a Flottiglia Sommergibili"
			location = 1085

			division = {
				id = { type = 10908 id = 283 }
				name = "61a Flottiglia Sommergibili"
				type = submarine
				model = 1
			}
		}

		########################################################
		#Warships Undergoing Major Refits and/or Repairs#

		development = {
			id = { type = 10908 id = 300 }
			name = "RM Caio Duilio"
			type = battleship
			model = 1
			cost = 0 #repair
			date = { year = 1942 month = august day = 25 } #### random repair time!
		}

		development = {
			id = { type = 10908 id = 301 }
			name = "RM Andrea Doria"
			type = battleship
			model = 1
			cost = 0 #repair
			date = { year = 1942 month = august day = 25 } #### random repair time!
		}

		development = {
			id = { type = 10908 id = 302 }
			name = "RM Guilio Cesare"
			type = battleship
			model = 1
			cost = 0 #repair
			date = { year = 1942 month = august day = 25 } #### random repair time!
		}
		development = {
			id = { type = 10908 id = 303 }
			name = "RM Roma"
			type = battleship
			model = 3
			cost = 2 #Last phase
			date = { year = 1943 month = january }
		}

		development = {
			id = { type = 10908 id = 304 }
			name = "RM Impero"
			type = battleship
			model = 3
			cost = 3 #Last phase
			date = { year = 1943 month = december }
		}
		development = {
			id = { type = 10908 id = 502 }
			name = "RM Aquila"
			type = battleship
			model = 3
			cost = 2 #Last phase
			date = { year = 1942 month = june }
		}

		########################################################

transports = 100
escorts = 32

#Supplies & Oil to Cagliari
    convoy = { 
        id = { type = 10908 id = 10001 } 
        transports = 10 
        escorts = 2 
        rubber = no 
        coal = no 
        steel = no 
        oil = yes 
        supplies = yes 
        path = { 908 909 938 } 
        } 
#Supplies & Oil to Tripoli
    convoy = { 
        id = { type = 10908 id = 10002 } 
        transports = 20 
        escorts = 5 
        rubber = no 
        coal = no 
        steel = no 
        oil = yes 
        supplies = yes 
        path = { 893 894 895 899 1085 } 
        } 
#Supplies & Oil to Rhodos
    convoy = { 
        id = { type = 10908 id = 10003 } 
        transports = 10 
        escorts = 2 
        rubber = no 
        coal = no 
        steel = no 
        oil = yes 
        supplies = yes 
        path = { 893 892 884 885 } 
        } 
#Resources from Tirana
    convoy = { 
        id = { type = 10908 id = 10004 } 
        transports = 25 
        escorts = 2 
        rubber = yes 
        coal = yes 
        steel = yes 
        oil = yes 
        supplies = no 
        path = { 754 749 893 } 
        } 
#Resources from Dodekanisos
    convoy = { 
        id = { type = 10908 id = 10005 } 
        transports = 10 
        escorts = 2 
        rubber = yes 
        coal = yes 
        steel = yes 
        oil = yes 
        supplies = no 
        path = { 883 876 892 893 } 
        } 
	}




