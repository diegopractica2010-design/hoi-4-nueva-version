#Anti Aircraft Batteries
province = { id = 906  anti_air = 2 } #Alexandria
province = { id = 901  anti_air = 2 } #Port Said
province = { id = 903  anti_air = 2 } #Cairo
province = { id = 900  anti_air = 2 } #Suez

country = { 
    tag = EGY

	puppet = ENG
	control = ENG 
	# Resource Reserves
	oil		= 200
	metal	= 200
	energy	= 200
	rare_materials	= 200
	money = 10

	capital = 	903

    ownedprovinces =      {
		#EGYPT
		900 901 902 903 904 905 906 907 908 909 910 911 912 913 914 915
		4 1020 1019 1021 1022 1027 1023 1026 1024 1025 1800 1801
		#SUDAN
		1065 1066 1069 1068 1067 1029 1028 1032 1031 1030 1040 1041  
	 }
    controlledprovinces = {
		#EGYPT
		900 901 902 903 904 905 906 907 908 909 910 911 912 913 914 915
		4 1020 1019 1021 1022 1027 1023 1026 1024 1025 1800 1801
		#SUDAN
		1065 1066 1069 1068 1067 1029 1028 1032 1031 1030 1040 1041  
	  }
    nationalprovinces =   {
		#EGYPT
		900 901 902 903 904 905 906 907 908 909 910 911 912 913 914 915
		4 1020 1019 1021 1022 1027 1023 1026 1024 1025 1800 1801
		#SUDAN
		1065 1066 1069 1068 1067 1029 1028 1032 1031 1030 1040 1041
	  }

techapps = {

# Group E 1939 techs
#######################

4010 # GW fighter

2150 # Basic Armoured Car

2290 # GW light artillery

1010 # GW infantry

1190 # GW Cavalry



6010 # Firepower
 }
}