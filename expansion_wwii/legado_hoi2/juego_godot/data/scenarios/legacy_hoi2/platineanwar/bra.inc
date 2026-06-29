province = {
	id = 886
	anti_air = 1
	air_base = {
		size = 4
		current_size = 4
		}
	naval_base = {
		size = 6
		current_size = 6
		}
}

province = {
	id = 848
	anti_air = 2
	air_base = {
		size = 4
		current_size = 4
		}
	naval_base = {
		size = 8
		current_size = 8
		}
}

province = { id = 883   anti_air = 2 } #Belo Horizonte
province = { id = 885   anti_air = 2 } #Rio de Janeiro
province = { id = 847   anti_air = 1 } #

# Brazil

country = {
    tag = BRA

	ai = "platineanwar_BRA.ai"

	headofstate = { type = 9 id = 34001 }
	headofgovernment = { type = 9 id = 34002 }
 	foreignminister = { type = 9 id = 34076 }
 	armamentminister = { type = 9 id = 34095 }
 	ministerofsecurity = { type = 9 id = 34121 }
 	ministerofintelligence = { type = 9 id = 34134 }
 	chiefofstaff = { type = 9 id = 34007 }
 	chiefofarmy = { type = 9 id = 34162 }
 	chiefofnavy = { type = 9 id = 34179 }        
 	chiefofair = { type = 9 id = 34010 }

    policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 6
        political_left = 9
        free_market = 8
        freedom = 7
        professional_army = 5
        defense_lobby = 6
        interventionism = 3
    }


	# Resource Reserves
	
	energy		= 3500 
	metal		= 3500
	rare_materials 	= 2500
	oil	 	= 500
	supplies 	= 500
	money 		= 100
	manpower 	= 100

	free = 		{
		oil 	=	15
		supplies =	55
	}

	capital = 883

	diplomacy = {
	relation = { tag = ARG value = -10 }
	relation = { tag = BOL value = 10 }
	relation = { tag = CHL value = 10 }
	relation = { tag = ECU value = 10 }
	relation = { tag = PAR value = 10 }
	relation = { tag = PRU value = 10 }
	relation = { tag = URU value = 50 }
	}

    ownedprovinces =      {
		848 847 835 834 825 823 822 820 872 824 826 878 876 877 879 883 887 886
		885 884 882 880 881
	}
    controlledprovinces = {
		848 847 835 834 825 823 822 820 872 824 826 878 876 877 879 883 887 886
		885 884 882 880 881
			}
    nationalprovinces =   {
		848 847 835 834 825 823 822 820 872 824 826 878 876 877 879 883 887 886
		885 884 882 880 881
		}

	techapps = {
# Group C 1941 techs
#######################

5070

3410

4010 4020 4030 # Basic Fighter

4040 # Basic MR Fighter

4120 4130 4140 # Basic medium bomber

2010 2020 2030 2040 2050 # Improved light tank

2150 # Basic Armoured Car

2290 2300 2310 2320 2330 # up to the WW II basic artillery

2400 2410 # Basic AT

2450 2460 2470 # Basic Static AA

2510 2520 # Imp. AA

1010 1020 1030 # Basic infantry

1190 1200 1210 1220 # Semi-moto cavalry

1110 # Early Mountain

2330 # Basic motorized

9010 9020 9030 # Force substitution doctrine

5010 5020 # Mechanized Agriculture

5050 # Basic Machine Tools

5080 5090 5100 # Construction (up to the forts)

5110 # Supplies

5190 5200 # Imp. oil conversion

5470 # Nuclear Tier 4



6010 6020 6040 # Superior Firepower, Delay

3010
3070
3130
3250
3400

8010 8020 8040 8050

#hospital
14000

	}

		
		landunit = {
		id = { type = 10110 id = 1 }
		name = "1o Exército do Brasil"
		location = 883

			division = {
			id = { type = 10110 id = 2 }
			name = "I Divisão de Infantaria"
			strength = 100
			type = infantry
			model = 1
			extra = artillery
			}

			division = {
			id = { type = 10110 id = 3 }
			name = "II Divisão de Infantaria"
			strength = 100
			type = infantry
			model = 1
			}

			division = {
			id = { type = 10110 id = 4 }
			name = "CCLXVIII Divisão do Guarda Civíl"
			strength = 100
			type = militia
                        extra = anti_air
			}

			division = {
			id = { type = 10110 id = 5 }
			name = "CCLXIX Divisão do Guarda Civíl"
			strength = 100
			type = militia
			}
			}

		landunit = {
		id = { type = 10110 id = 6 }
		name = "2o Exército do Brasil"
		location = 885

			division = {
			id = { type = 10110 id = 7 }
			name = "III Divisão de Infantaria"
			strength = 100
			type = infantry
			model = 1
			}

			division = {
			id = { type = 10110 id = 8 }
			name = "XCII Divisão de Cavalaria"
			strength = 100
			type = cavalry
			model = 1
			}
			}

	airunit = {
		id = { type = 10110 id = 9 }
		name = "Aereo do Brésil"
		location = 848
		base = 848

		division = {
			id = { type = 10110 id = 10 }
			name = "1. Grupo de Caças"
			strength = 100
			type = interceptor
			model = 0
		}
	}


	navalunit = {
		id = { type = 10110 id = 11 }
		location = 886
		base = 886
		name = "Navais do Transporte"
		division = { id = { type = 10110 id = 12 } name = "1. Flotilla de Navios de Transporte" type = transport }
		division = { id = { type = 10110 id = 13 } name = "2. Flotilla de Navios de Transporte" type = transport }
		division = { id = { type = 10110 id = 14 } name = "3. Flotilla de Navios de Transporte" type = transport }
		division = { id = { type = 10110 id = 15 } name = "4. Flotilla de Navios de Transporte" type = transport }
		division = { id = { type = 10110 id = 16 } name = "5. Flotilla de Navios de Transporte" type = transport }
		division = { id = { type = 10110 id = 17 } name = "6. Flotilla de Navios de Transporte" type = transport }
			}

	# BB Dreadnaught built in 1910:
	# In poor condition
	navalunit = {
		name = "NRB São Paulo"
		id = { type = 10110 id = 18 }
		location = 848
		base = 848
		division = { id = { type = 10110 id = 19 }  name = "NRB São Paulo" type = battleship model = 0 } # BB
		}

	navalunit = {
		name = "NRB Minas Gerais"
		id = { type = 10110 id = 28 }
		location = 848
		base = 848
		division = { id = { type = 10110 id = 29 }  name = "NRB Minas Gerais" type = battleship model = 0 } # BB
		}

	# heavy_cruiser/Gunboat built in 1912
		navalunit = {
		name = "NRB Bahia"
		id = { type = 10110 id = 20 }
		location = 848
		base = 848
		
		division = { id = { type = 10110 id = 21 } name = "NRB Bahia" type = heavy_cruiser model = 0 } # CA
		}

		navalunit = {
		name = "NRB Rio Grande do Sul"
		id = { type = 10110 id = 22 }
		location = 848
		base = 848
		division = { id = { type = 10110 id = 23 } name = "NRB Rio Grande do Sul" type = heavy_cruiser model = 0 }
		}

		navalunit = {
		name = "1. Armada de Contratorpedeiros"
		id = { type = 10110 id = 24 }
		location = 848
		base = 848
		division = { id = { type = 10110 id = 25 } name = "1. Flotilla de Contratorpedeiros" type = destroyer model = 0 }
		division = { id = { type = 10110 id = 30 } name = "2. Flotilla de Contratorpedeiros" type = destroyer model = 0 }
		}

		navalunit = {
		name = "1. Flotilla de Submarinos"
		id = { type = 10110 id = 26 }
		location = 848
		base = 848
		division = { id = { type = 10110 id = 27 } name = "1. Flotilla de Submarinos" type = submarine model = 0 }
		}
	landunit = { 
	
	id = { type = 10110 id = 31 }
	name = "Exército do Reserva"
	location = 883 # 

		division = {
		locked = yes
		id = { type = 10110 id = 32 }
		name = "Guarda Presidencial"
		strength = 100
		type = infantry
		extra = engineer
		}
		}
} 