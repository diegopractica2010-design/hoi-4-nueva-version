province = {
	id = 1737
	anti_air = 3
	air_base = {
		size = 2
		current_size = 2
		}

	naval_base = {
		size = 10
		current_size = 10
		}
	}

province = {
	id = 1739
	anti_air = 3
	air_base = {
		size = 6
		current_size = 6
		}
}

country = {
   tag = PHI

	control = USA
	puppet = USA


	# Resource Reserves

oil 		= 200	
supplies 	= 500
manpower = 150
 
 extra_tc = 5

	free = 		{
		oil 	=	1
		supplies =	12
		ic = 6
	}


	capital = 1737


	policy = {
        date = { year = 0 month = january day = 0 }
        democratic = 7
        political_left = 6
        freedom = 4
        free_market = 5
        professional_army = 1
        defense_lobby = 3
        interventionism = 1
    }
		headofstate = { type = 9 id = 50001 }
		headofgovernment = { type = 9 id = 50002 }
  		foreignminister = { type = 9 id = 50041 }
  		armamentminister = { type = 9 id = 50051 }
  		ministerofsecurity = { type = 9 id = 50060 }
  		ministerofintelligence = { type = 9 id = 50006 }
  		chiefofstaff = { type = 9 id = 50007 }
  		chiefofarmy = { type = 9 id = 50008 }
  		chiefofnavy = { type = 9 id = 50009 } 
  		chiefofair = { type = 9 id = 50010 }

	ownedprovinces =      {
		1735 1736 1737 1738 1739 1740 1741 1742 1743 1744 1745 1746 1747 1748 1749 1750
	}
	controlledprovinces = {
		1735 1736 1737 1738 1739 1740 1741 1742 1743 1744 1745 1746 1747 1748 1749 1750
	}
	nationalprovinces =   {
		1735 1736 1737 1738 1739 1740 1741 1742 1743 1744 1745 1746 1747 1748 1749 1750
	}

	
	techapps = {
# Group E 1941 techs
#######################

2320

4010 4020 # Early Fighter

2010 2020 2030 2040 # Basic light tank

2150 # Basic Armoured Car

2290 2300 2310 # GW artillery

2330 2400 # Early AT artillery

2450 # GW Static AA

2460 2510 # Basic AA

1010 # GW infantry

1190 # GW Cavalry

6010 # Firepower

# No Nuclear Research (Tier 5)
#hospital
14000
	}

	  	landunit = {
		id = { type = 10104 id = 1 }
		location = 1740
		name = "North Luzon Army"

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 2 }
			strength = 100
			name = "11th Special Services Division"
			type = militia
			extra = artillery
			}

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 3 }
			strength = 100
			name = "21st Special Services Division"
			type = militia
			}

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 4 }
			strength = 100
			name = "31st Special Services Division"
			type = militia
			}

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 5 }
			strength = 100
			name = "71st Special Services Division"
			type = militia
                        extra = anti_air
			}

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 21 }
			strength = 32
			max_strength = 32
			name = "26th Cavalry Regiment"
			type = cavalry
                        model = 1
                         
			}
			}


		landunit = {
		id = { type = 10104 id = 6 }
		location = 1737
		name = "South Luzon Army"

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 7 }
			strength = 100
			name = "41st Special Services Division"
			type = militia
			extra = artillery
			}

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 8 }
			strength = 100
			name = "51st Special Services Division"
			type = militia
			}
			}

		landunit = {
		id = { type = 10104 id = 9 }
		location = 1749
		name = "Visayan-Mindanao Army"

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 10 }
			strength = 100
			name = "61st Special Services Division"
			type = militia
			extra = artillery
			}

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 11 }
			strength = 100
			name = "81st Special Services Division"
			type = militia
			}


			}

                navalunit = {
		id = { type = 10104 id = 13 }
		name = "Philipine Navy"
		location = 1737
		base = 1737

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 14 }
			name = "Flotille Tuguegarao"
			type = destroyer
			model = 0
			}
               	 	division = { organisation = 5 experience = 10
			id = { type = 10104 id = 15 }
			name = "1st Army Transport Flotille"
			type = transport
			model = 0
			}
        		}

		landunit = {
		id = { type = 10104 id = 16 }
		location = 1750
		name = "Davao Detachement"

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 12 }
			strength = 100
			name = "101st Special Services Division"
			type = infantry
			}
                        }



		landunit = {
		id = { type = 10104 id = 17 }
		location = 1739
		name = "Army Reserve"

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 18 }
			strength = 100
			name = "91st Special Services Division"
			type = infantry
                        model = 2
			}
                        }
		landunit = {
		id = { type = 10104 id = 19 }
		location = 1736
		name = "Mindoro Detachement"

			division = { organisation = 5 experience = 10
			id = { type = 10104 id = 20 }
			strength = 45
			name = "Mindoro Detachement"
			type = militia
			}
                    }
}