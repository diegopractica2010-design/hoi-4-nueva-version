
###############################
# Country definition for JAP #
##############################

province = { id = 1179 ic = 2 } # Sapporo
province = { id = 1180 ic = 3 } # Sendai
province =
{ id         = 1181
  anti_air   = 2
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Akita
province = { id = 1182 anti_air = 2 } # Fukushima
province =
{ id         = 1184
  ic         = 9
  anti_air   = 2
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Tokyo
province =
{ id         = 1185
  ic         = 5
  anti_air   = 2
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Nagoya
province =
{ id         = 1186
  anti_air   = 2
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Kanazawa
province =
{ id         = 1187
  ic         = 6
  anti_air   = 2
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Osaka
province =
{ id         = 1188
  ic         = 5
  anti_air   = 4
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Hiroshima
province = { id = 1189 ic = 7 } # Shikoku
province =
{ id         = 1190
  ic         = 4
  anti_air   = 2
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Fukuoka
province =
{ id         = 1193
  supplypool = 1000
  anti_air   = 2
  air_base   = { size = 6 current_size = 6 }
  naval_base = { size = 6 current_size = 6 }
}              # Okinawa
province =
{ id         = 1196
  supplypool = 5000
  oilpool    = 100
  anti_air   = 2
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Busan
province = { id = 1200 ic = 1 } # Wonsan
province =
{ id         = 1202
  supplypool = 500
  oilpool    = 100
  anti_air   = 3
  air_base   = { size = 7 current_size = 7 }
  naval_base = { size = 5 current_size = 5 }
}              # Dalian
province = { id = 1203 supplypool = 1000 oilpool = 100 } # Tangshan
province =
{ id         = 1322
  supplypool = 1000
  oilpool    = 100
  anti_air   = 2
  air_base   = { size = 8 current_size = 8 }
  naval_base = { size = 10 current_size = 10 }
}              # Kaohsiung
province = { id = 1323 anti_air = 2 } # Taipei
province =
{ id         = 1328
  anti_air   = 2
  air_base   = { size = 4 current_size = 4 }
  naval_base = { size = 4 current_size = 4 }
}              # Hanoi
province =
{ id         = 1337
  supplypool = 100
  oilpool    = 1
  anti_air   = 2
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Saigon
province =
{ id       = 1391
  anti_air = 2
  air_base = { size = 4 current_size = 4 }
}            # Hyesan
province = { id = 1599 supplypool = 500 } # Iwo Jima
province =
{ id         = 1601
  supplypool = 500
  anti_air   = 5
  air_base   = { size = 4 current_size = 4 }
  naval_base = { size = 2 current_size = 2 }
}              # Eniwetok
province = { id = 1605 anti_air = 3 } # Majuro
province =
{ id         = 1608
  supplypool = 2000
  anti_air   = 5
  air_base   = { size = 4 current_size = 4 }
  naval_base = { size = 2 current_size = 2 }
}              # Kwajalein
province = { id = 1610 supplypool = 500 } # Ponape
province =
{ id         = 1613
  supplypool = 500
  anti_air   = 5
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Truk
province = { id = 1618 supplypool = 500 } # Ulithi
province = { id = 1619 supplypool = 500 anti_air = 3 } # Yap
province = { id = 1621 supplypool = 500 } # Palau
province = { id = 1625 supplypool = 500 } # Rota
province = { id = 1626 supplypool = 500 } # Tinian
province = { id = 1627 supplypool = 500 anti_air = 3 } # Saipan
province = { id = 1784 anti_air = 2 } # Bonin Islands
province = { id = 1785 supplypool = 500 } # Marcus Island

#####################
# Country main data #
#####################

country =
{ tag                    = JAP
  belligerence           = 40
  capital                = 1184
  manpower               = 735
  # Resource Reserves
  energy                 = 10000
  metal                  = 10000
  rare_materials         = 5000
  oil                    = 15000
  supplies               = 5000
  money                  = 120
  transports             = 1100
  escorts                = 11
  policy =
  { date              = { year = 0 month = january day = 0 }
    democratic        = 1
    political_left    = 4
    freedom           = 3
    free_market       = 3
    professional_army = 6
    defense_lobby     = 8
    interventionism   = 10
  }
  SpyInfo                = { country = "ENG" NumberOfSpies = 2 }
  SpyInfo                = { country = "FRA" NumberOfSpies = 2 }
  SpyInfo                = { country = "SOV" NumberOfSpies = 6 }
  SpyInfo                = { country = "USA" NumberOfSpies = 4 }
  SpyInfo                = { country = "SIK" NumberOfSpies = 1 }
  SpyInfo                = { country = "TAN" NumberOfSpies = 1 }
  SpyInfo                = { country = "GER" NumberOfSpies = 2 }
  SpyInfo                = { country = "CXB" NumberOfSpies = 2 }
  SpyInfo                = { country = "CYN" NumberOfSpies = 2 }
  SpyInfo                = { country = "POR" NumberOfSpies = 1 }
  SpyInfo                = { country = "ITA" NumberOfSpies = 2 }
  SpyInfo                = { country = "CHI" NumberOfSpies = 4 }
  SpyInfo                = { country = "CGX" NumberOfSpies = 1 }
  SpyInfo                = { country = "PHI" NumberOfSpies = 2 }
  SpyInfo                = { country = "NZL" NumberOfSpies = 1 }
  SpyInfo                = { country = "AST" NumberOfSpies = 2 }
  # Taiwan
  nationalprovinces      = { 1177 1178 1179 1180 1181 1182 1183 1184 1185 1186 1187 1188 1189 1190 1191 1784 1599 1192 1193 1785 1174 1176 1175 1194
                             1195 1196 1197 1198 1199 1393 1391 1376 1392 1200 1201 1624
                           }
  ownedprovinces         = { 1203 1177 1178 1179 1180 1181 1182 1183 1184 1185 1186 1187 1188 1189 1190 1191 1784 1599 1192 1193 1785 1627 1626 1625
                             1619 1621 1620 1604 1618 1617 1616 1615 1613 1612 1610 1609 1600 1601 1602 1603 1605 1606 1607 1608 1323 1322 1324 1376
                             1391 1392 1200 1201 1199 1198 1197 1196 1195 1194 1393 1202 1338 1337 1335 1336 1334 1333 1332 1329 1328 1306 1326 1176
                             1174
                           }
  controlledprovinces    = { 1177 1178 1179 1180 1181 1182 1183 1184 1185 1186 1187 1188 1189 1190 1191 1784 1599 1192 1193 1785 1219 1627 1626 1625
                             1619 1621 1620 1604 1618 1617 1616 1615 1613 1612 1610 1609 1600 1601 1602 1603 1605 1606 1607 1608 1376 1391 1392 1393
                             1200 1201 1199 1198 1197 1196 1195 1194 1338 1337 1335 1336 1334 1333 1332 1329 1328 1306 1326 1176 1174 1202 1203 1204
                             1205 1210 1211 1212 1225 1226 1213 1214 1215 1216 1222 1223 1224 1230 1217 1220 1235 1236 1237 1218 1221 1233 1234 1238
                             1239 1240 1245 1247 1248 1313 1314 1317 1321 1232 1253 1252 1251 1322 1323 1324
                           }
  # JAP 1941 techs
  # ######################
  techapps               = { 1010  1020  1030  1040  1050  1070  1110  1120  1130  1150  1160  1190  1200  1210  12100  1220  1230  1310  1340 
                             14000 14010 2010  2020  2030  2030  2040  2050  2070  2150  2290  2300  2310  2320  2330  2400  2450  2460  2470  2510 
                             2520  3010  3020  3030  3070  3080  3090  3100  3130  3140  3150  3190  3200  3210  3250  3260  3270  3280  3310  3320 
                             3330  3340  3350  3360  3400  3410  3420  3430  4010  4020  4030  4040  4050  4120  4130  4140  4150  4170  4190  4200 
                             4250  5010  5050  5060  5070  5080  5090  5100  5110  5120  5130  5140  5190  5200  5310  5320  5350  5470  5480  5490 
                             6010  6030  6110  6120  6160  8010  8020  8030  8040  8050  8060  8090  8100  8110  8180  8230  9010  9020  9030  9040 
                             9050  9060  9070  9080  9090  9100  9110  9120  9130  9190  9200  9210  9220  9350 
                           }

blueprints = { 8310 8320 }

  diplomacy =
  { relation = { tag = AST value = -150 }
    relation = { tag = BEL value = -150 }
    relation = { tag = BUL value = 75 }
    relation = { tag = CGX value = -200 }
    relation = { tag = CHC value = -200 }
    relation = { tag = CHI value = -200 }
    relation = { tag = CHL value = 20 }
    relation = { tag = CSX value = -200 }
    relation = { tag = CXB value = -200 }
    relation = { tag = CYN value = -200 }
    relation = { tag = FIN value = 50 }
    relation =
    { tag        = GER
      value      = 135
      guaranteed = { day = 27 month = september year = 1940 }
    }
    relation = { tag = HOL value = -150 }
    relation =
    { tag        = HUN
      value      = 125
      guaranteed = { day = 20 month = november year = 1940 }
    }
    relation =
    { tag        = ITA
      value      = 125
      guaranteed = { day = 20 month = november year = 1940 }
    }
    relation = { tag = MAN value = 200 access = yes }
    relation = { tag = MEN value = 200 access = yes }
    relation =
    { tag        = ROM
      value      = 125
      guaranteed = { day = 27 month = september year = 1940 }
    }
    relation = { tag = SIA value = 150 }
    relation = { tag = VIC value = 50 }
    relation = { tag = USA value = -125 }
    relation = { tag = SIK value = -170 }
  }
  headofstate            = { type = 9 id = 5001 }
  headofgovernment       = { type = 9 id = 5042 }
  foreignminister        = { type = 9 id = 5065 }
  armamentminister       = { type = 9 id = 5091 }
  ministerofsecurity     = { type = 9 id = 5122 }
  ministerofintelligence = { type = 9 id = 5144 }
  chiefofstaff           = { type = 9 id = 5156 }
  chiefofarmy            = { type = 9 id = 5166 }
  chiefofnavy            = { type = 9 id = 5200 }
  chiefofair             = { type = 9 id = 5193 }
  dormant_ministers      = { 5002 5040 5033 5034 5041 5003 5057 5063 5053 5055 5056 5004 5005 5105 5106 5107 5115 5006 5134 5007 5008 5189 5035 5036
                             5059 5080 5090 5108 5116 5117 5118 5119 5120 5136 5142 5155 5165 5172 5185
                           }
  # China Expeditionary Army
  landunit =
  { id       = { type = 10300 id = 500 }
    name     = "China Exp Army HQ"
    location = 1240
    division =
    { experience = 25
      id         = { type = 10300 id = 501 }
      name       = "China Exp Army HQ"
      strength   = 100
      type       = hq
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 505 }
      name       = "13. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 506 }
      name       = "34. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = engineer
    }
  }
  landunit =
  { id       = { type = 10300 id = 502 }
    name     = "11. Hendan" # Hanchow, China
    location = 1238
    division =
    { experience = 25
      id         = { type = 10300 id = 503 }
      name       = "3. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = engineer
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 504 }
      name       = "6. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
  }
  landunit =
  { id       = { type = 10300 id = 3000 }
    name     = "39. Hendan" # Hanchow, China
    location = 1239
    division =
    { experience = 25
      id         = { type = 10300 id = 507 }
      name       = "39. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
    }
  }
  landunit =
  { id       = { type = 10300 id = 3001 }
    name     = "31. Hoheishidan" # Hanchow, China
    location = 1245
    division =
    { experience = 25
      id         = { type = 10300 id = 508 }
      name       = "40. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 509 }
      name       = "14. Independent Mixed Brigade"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 510 }
      name       = "18. Independent Mixed Brigade"
      strength   = 100
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 511 }
    name     = "13. Hendan" # Shanghai, China 
    location = 1234
    division =
    { experience = 25
      id         = { type = 10300 id = 512 }
      name       = "15. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 513 }
      name       = "17. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 3002 }
    name     = "43. Hendan"
    location = 1251
    division =
    { experience = 25
      id         = { type = 10300 id = 514 }
      name       = "22. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 515 }
      name       = "116. Hoheishidan"
      strength   = 100
      type       = infantry
      extra      = artillery
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 3003 }
    name     = "11. Mixed Brigade Group"
    location = 1251
    division =
    { experience = 25
      id         = { type = 10300 id = 516 }
      name       = "11. Independent Mixed Brigade"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 517 }
      name       = "12. Independent Mixed Brigade"
      strength   = 100
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 3004 }
    name     = "13. Mixed Brigade Group"
    location = 1253
    division =
    { experience = 25
      id         = { type = 10300 id = 518 }
      name       = "13. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 519 }
      name       = "17. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 520 }
      name       = "20. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 521 }
      name       = "2. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 522 }
    name     = "23. Hendan" # Canton, China
    location = 1252
    division =
    { experience = 25
      id         = { type = 10300 id = 523 }
      name       = "38. Hoheishidan"
      strength   = 100
      type       = infantry
      extra      = engineer
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 524 }
      name       = "51. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
  }
  landunit =
  { id       = { type = 10300 id = 3005 }
    name     = "104. Hoheishidan"
    location = 1232
    division =
    { experience = 25
      id         = { type = 10300 id = 525 }
      name       = "104. Hoheishidan"
      strength   = 100
      type       = infantry
      extra      = artillery
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 526 }
      name       = "19. Independent Mixed Brigade"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = anti_tank
    }
  }
  # # North China Theater Army
  landunit =
  { id       = { type = 10300 id = 527 }
    name     = "Nth China Theater Army HQ" # Peking, China
    location = 1224
    division =
    { experience = 25
      id         = { type = 10300 id = 528 }
      name       = "Nth China Theater Army HQ"
      strength   = 100
      type       = hq
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 529 }
      name       = "27. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 530 }
      name       = "35. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 531 }
      name       = "110. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 3006 }
    name     = "1. Mixed Brigade Group"
    location = 1230
    division =
    { experience = 25
      id         = { type = 10300 id = 532 }
      name       = "1. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 533 }
      name       = "7. Independent Mixed Brigade"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 534 }
      name       = "8. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 535 }
      name       = "15. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 536 }
    name     = "1. Hendan" # Taiyuan, China
    location = 1225
    division =
    { experience = 25
      id         = { type = 10300 id = 537 }
      name       = "36. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 538 }
      name       = "37. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 539 }
      name       = "41. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 540 }
      name       = "3. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 3007 }
    name     = "4. Mixed Brigade Group"
    location = 1313
    division =
    { experience = 25
      id         = { type = 10300 id = 541 }
      name       = "4. Independent Mixed Brigade"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 542 }
      name       = "9. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 543 }
      name       = "16. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 544 }
    name     = "12. Hendan" # Sainan, China
    location = 1226
    division =
    { experience = 25
      id         = { type = 10300 id = 545 }
      name       = "32. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 546 }
      name       = "5. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 547 }
      name       = "6. Independent Mixed Brigade"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 548 }
      name       = "10. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 549 }
    name     = "Mongol Army" # Changchiakou, China
    location = 1209
    division =
    { experience = 25
      id         = { type = 10300 id = 550 }
      name       = "26. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 551 }
      name       = "2. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 552 }
      name       = "1 Moukogo Kiheishidan"
      strength   = 100
      type       = cavalry
      model      = 0
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 553 }
      name       = "2 Moukogo Kiheishidan"
      strength   = 100
      type       = cavalry
      model      = 0
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 554 }
      name       = "3 Moukogo Kiheishidan"
      strength   = 100
      type       = cavalry
      model      = 0
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 555 }
      name       = "4 Moukogo Kiheishidan"
      strength   = 100
      type       = cavalry
      model      = 0
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 556 }
      name       = "5 Moukogo Kiheishidan"
      strength   = 100
      type       = cavalry
      model      = 0
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 557 }
      name       = "6 Moukogo Kiheishidan"
      strength   = 100
      type       = cavalry
      model      = 0
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 558 }
      name       = "7 Moukogo Kiheishidan"
      strength   = 100
      type       = cavalry
      model      = 0
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 559 }
      name       = "8 Moukogo Kiheishidan"
      strength   = 100
      type       = cavalry
      model      = 0
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 560 }
      name       = "9 Moukogo Kiheishidan"
      strength   = 100
      type       = cavalry
      model      = 0
    }
  }
  # Kwantung Theater Army
  landunit =
  { id       = { type = 10300 id = 561 }
    name     = "Kwantung Theater Army HQ" # Changchung, Manchuria
    location = 1396
    division =
    { experience = 25
      id         = { type = 10300 id = 562 }
      name       = "Kwantung Theater Army HQ"
      strength   = 100
      type       = hq
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 563 }
      name       = "10. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 564 }
      name       = "28. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 565 }
      name       = "29.  Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 566 }
      name       = "Kwantung Defence Command"
      strength   = 100
      type       = garrison
      model      = 1
      extra      = police
    }
  }
  landunit =
  { id       = { type = 10300 id = 567 }
    name     = "3. Hendan" # Botanko, Manchuko
    location = 1530
    division =
    { experience = 25
      id         = { type = 10300 id = 568 }
      name       = "9. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 569 }
      name       = "12. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 570 }
      name       = "57. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 571 }
      name       = "1. Senshashidan"
      strength   = 50
      type       = light_armor
      model      = 1
      extra      = sp_artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 572 }
      name       = "1. Border Guards"
      strength   = 100
      type       = garrison
      model      = 1
      extra      = anti_air
    }
  }
  landunit =
  { id       = { type = 10300 id = 573 }
    name     = "4. Hendan" # Songo, Manchuko
    location = 1381
    division =
    { experience = 25
      id         = { type = 10300 id = 574 }
      name       = "1. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 575 }
      name       = "2. Border Guards"
      strength   = 100
      type       = garrison
      model      = 2
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 576 }
      name       = "3. Border Guards"
      strength   = 100
      type       = garrison
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 577 }
    name     = "5. Hendan" # Toan, Manchuko
    location = 1374
    division =
    { experience = 25
      id         = { type = 10300 id = 578 }
      name       = "11. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 579 }
      name       = "24. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = engineer
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 580 }
      name       = "2. Senshashidan"
      strength   = 50
      type       = light_armor
      model      = 1
      extra      = engineer
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 581 }
      name       = "4. Border Guards"
      strength   = 100
      type       = garrison
      model      = 1
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 582 }
      name       = "5. Border Guards"
      strength   = 100
      type       = garrison
      model      = 1
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 583 }
      name       = "3 Manchuko Kiheishidan"
      strength   = 50
      type       = cavalry
      model      = 0
    }
  }
  landunit =
  { id       = { type = 10300 id = 584 }
    name     = "6. Hendan" # Hailar, Manchuko
    location = 1382
    division =
    { experience = 25
      id         = { type = 10300 id = 585 }
      name       = "14. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = anti_tank
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 586 }
      name       = "23. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = police
    }
  }
  landunit =
  { id       = { type = 10300 id = 587 }
    name     = "20. Hendan" # Keinei, Manchuko
    location = 1375
    division =
    { experience = 25
      id         = { type = 10300 id = 588 }
      name       = "8. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 589 }
      name       = "25. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { id       = { type = 10300 id = 590 }
      name     = "6. Border Guards"
      strength = 100
      type     = garrison
      model    = 2
      extra    = anti_tank
    }
    division =
    { id       = { type = 10300 id = 591 }
      name     = "7. Border Guards"
      strength = 100
      type     = garrison
      model    = 2
    }
  }
  # Southern Expeditionary Army
  landunit =
  { id       = { type = 10300 id = 592 }
    name     = "Southern Expeditionary Army HQ" # Saigon, Indochina
    location = 1337
    division =
    { experience = 25
      id         = { type = 10300 id = 593 }
      name       = "Southern Expeditionary Army HQ"
      strength   = 100
      type       = hq
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 594 }
      name       = "Dash Forward"
      strength   = 100
      type       = paratrooper
      model      = 1
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 595 }
      name       = "21. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 596 }
      name       = "4. Independent Mixed Regiment"
      strength   = 50
      type       = infantry
      model      = 2
      extra      = anti_air
    }
  }
  landunit =
  { id       = { type = 10300 id = 597 }
    name     = "14. Hendan" # Taiwan
    location = 1248
    division =
    { experience = 25
      id         = { type = 10300 id = 598 }
      name       = "16. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = engineer
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 599 }
      name       = "48. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 600 }
      name       = "65. Brigade"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = anti_tank
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 601 }
      name       = "4/7. Senshashidan"
      strength   = 50
      type       = light_armor
      model      = 1
    }
  }
  landunit =
  { id       = { type = 10300 id = 602 }
    name     = "15. Hendan" # Indochina/Siam border
    location = 1338
    division =
    { experience = 25
      id         = { type = 10300 id = 603 }
      name       = "33. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 604 }
      name       = "55. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 605 }
    name     = "15. Hendan" # Tokyo
    location = 1321
    division =
    { experience = 25
      id         = { type = 10300 id = 606 }
      name       = "2. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = engineer
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 607 }
      name       = "56. Brigade"
      strength   = 50
      type       = infantry
      model      = 2
      extra      = anti_air
    }
  }
  landunit =
  { id       = { type = 10300 id = 2800 }
    name     = "8. Garrison"
    location = 1306
    division =
    { experience = 25
      id         = { type = 10300 id = 2801 }
      name       = "8. Indochine Guards"
      strength   = 100
      type       = garrison
      model      = 1
      extra      = anti_air
    }
  }
  landunit =
  { id       = { type = 10300 id = 4605 }
    name     = "8. Garrison"
    location = 1326
    division =
    { experience = 25
      id         = { type = 10300 id = 3636 }
      name       = "2. Indochine Guards"
      strength   = 100
      type       = garrison
      model      = 1
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 3637 }
      name       = "1. Indochine Guards"
      strength   = 100
      type       = garrison
      model      = 1
      extra      = anti_air
    }
  }
  landunit =
  { id       = { type = 10300 id = 608 }
    name     = "25. Hendan" # Saigon
    location = 1337
    division =
    { experience = 25
      id         = { type = 10300 id = 609 }
      name       = "5. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 610 }
      name       = "18. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 611 }
      name       = "56. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = anti_tank
    }
    division =
    { experience = 35
      id         = { type = 10300 id = 612 }
      name       = "Imperial Guards"
      strength   = 100
      type       = infantry
      model      = 3
      extra      = artillery
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 613 }
      name       = "3. Senshashidan"
      strength   = 50
      type       = light_armor
      model      = 1
      extra      = sp_artillery
    }
  }
  # Imperial General Headquarters
  landunit =
  { id       = { type = 10300 id = 614 }
    name     = "Imperial General HQ" # Tokyo
    location = 1184
    division =
    { experience = 25
      id         = { type = 10300 id = 615 }
      name       = "Imperial General HQ"
      strength   = 100
      type       = hq
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 616 }
      name       = "4. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 35
      id         = { type = 10300 id = 617 }
      name       = "South Seas Detachment"
      strength   = 100
      type       = marine
      model      = 2
    }
  }
  landunit =
  { id       = { type = 10300 id = 618 }
    name     = "North Japan Army"
    location = 1181
    division =
    { id       = { type = 10300 id = 619 }
      name     = "7. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 620 }
      name     = "57. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 0
      extra    = artillery
    }
    division =
    { id       = { type = 10300 id = 621 }
      name     = "Karafuto"
      strength = 100
      type     = infantry
      model    = 0
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 622 }
      name     = "1. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
    }
    division =
    { id       = { type = 10300 id = 623 }
      name     = "2. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
    }
    division =
    { id       = { type = 10300 id = 624 }
      name     = "3. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = artillery
    }
    division =
    { id       = { type = 10300 id = 625 }
      name     = "4. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
  }
  landunit =
  { id       = { type = 10300 id = 626 }
    name     = "Central Japan Army"
    location = 1185
    division =
    { experience = 25
      id         = { type = 10300 id = 627 }
      name       = "53. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 628 }
      name       = "54. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 0
      extra      = artillery
    }
    division =
    { id       = { type = 10300 id = 629 }
      name     = "3. Depot"
      strength = 100
      type     = infantry
      model    = 0
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 630 }
      name     = "5. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 631 }
      name     = "6. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
  }
  landunit =
  { id       = { type = 10300 id = 632 }
    name     = "West Japan Army"
    location = 1187
    division =
    { id       = { type = 10300 id = 633 }
      name     = "5. Depot"
      strength = 100
      type     = infantry
      model    = 0
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 634 }
      name     = "7. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 635 }
      name     = "8. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 636 }
      name     = "9. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 637 }
      name     = "10. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 638 }
      name     = "11. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 639 }
      name     = "12. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 640 }
      name     = "13. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 641 }
      name     = "14. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
  }
  landunit =
  { id       = { type = 10300 id = 642 }
    name     = "East Japan Army"
    location = 1190
    division =
    { experience = 25
      id         = { type = 10300 id = 643 }
      name       = "52. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = anti_air
    }
    division =
    { id       = { type = 10300 id = 644 }
      name     = "15. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 645 }
      name     = "16. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 10300 id = 646 }
      name     = "17. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
  }
  landunit =
  { id       = { type = 10300 id = 647 }
    name     = "Korean Army"
    location = 1376
    division =
    { experience = 25
      id         = { type = 10300 id = 648 }
      name       = "19. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = anti_air
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 649 }
      name       = "20. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = artillery
    }
    division =
    { id       = { type = 10300 id = 650 }
      name     = "1. Korean Garrison"
      strength = 100
      type     = garrison
      model    = 1
    }
    division =
    { id       = { type = 10300 id = 651 }
      name     = "2. Korean Garrison"
      strength = 100
      type     = garrison
      model    = 1
    }
    division =
    { id       = { type = 10300 id = 652 }
      name     = "3. Korean Garrison"
      strength = 100
      type     = garrison
      model    = 1
    }
    division =
    { id       = { type = 10300 id = 653 }
      name     = "4. Korean Garrison"
      strength = 100
      type     = garrison
      model    = 1
    }
  }
  landunit =
  { id       = { type = 10300 id = 654 }
    name     = "Taiwan Army"
    location = 1322
    division =
    { id       = { type = 10300 id = 655 }
      name     = "1. Taiwan Garrison"
      strength = 100
      type     = garrison
      model    = 1
    }
    division =
    { id       = { type = 10300 id = 656 }
      name     = "2. Taiwan Garrison"
      strength = 100
      type     = garrison
      model    = 1
    }
    division =
    { id       = { type = 10300 id = 657 }
      name     = "3. Taiwan Garrison"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
  }
  landunit =
  { id       = { type = 10300 id = 1881 }
    name     = "81. Garrison"
    location = 1317
    division =
    { experience = 25
      id         = { type = 10300 id = 1882 }
      name       = "2. Defence Division"
      strength   = 100
      type       = garrison
      model      = 1
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 1883 }
      name       = "1. Defence Division"
      strength   = 100
      type       = garrison
      model      = 1
      extra      = anti_air
    }
  }
  landunit =
  { id       = { type = 10300 id = 1884 }
    name     = "3. Garrison"
    location = 1247
    division =
    { experience = 25
      id         = { type = 10300 id = 1885 }
      name       = "3. Defence Division"
      strength   = 100
      type       = garrison
      model      = 1
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 1886 }
      name       = "4. Defence Division"
      strength   = 100
      type       = garrison
      model      = 1
    }
  }
  landunit =
  { id       = { type = 10300 id = 1887 }
    name     = "5. Garrison"
    location = 1223
    division =
    { experience = 25
      id         = { type = 10300 id = 1888 }
      name       = "5. Defence Division"
      strength   = 100
      type       = garrison
      model      = 1
    }
  }
  landunit =
  { id       = { type = 10300 id = 1889 }
    name     = "1. Garrison"
    location = 1222
    division =
    { experience = 25
      id         = { type = 10300 id = 1890 }
      name       = "11. Defence Division"
      strength   = 100
      type       = garrison
      model      = 1
      extra      = anti_air
    }
  }
  # Pacific garrisons:
  landunit =
  { id       = { type = 10300 id = 658 }
    name     = "Saishu Hendan"
    location = 1177
    division =
    { id       = { type = 10300 id = 659 }
      name     = "Saishu Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 660 }
    name     = "Naha Hendan"
    location = 1193
    division =
    { id       = { type = 10300 id = 661 }
      name     = "Naha Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 662 }
    name     = "Toyohara Hendan"
    location = 1184
    division =
    { id       = { type = 10300 id = 663 }
      name     = "Toyohara Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 664 }
    name     = "Tomari Hendan"
    location = 1184
    division =
    { id       = { type = 10300 id = 665 }
      name     = "Tomari Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 667 }
    name     = "Shana Hendan"
    location = 1177
    division =
    { id       = { type = 10300 id = 668 }
      name     = "Shana Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 669 }
    name     = "Mariane Hendan"
    location = 1184
    division =
    { id       = { type = 10300 id = 670 }
      name     = "Mariane Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 671 }
    name     = "Palau Hendan"
    location = 1621
    division =
    { id       = { type = 10300 id = 672 }
      name     = "Palau Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 673 }
    name     = "Eniwetok Hendan"
    location = 1601
    division =
    { id       = { type = 10300 id = 674 }
      name     = "Eniwetok Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 675 }
    name     = "Bikini Hendan"
    location = 1600
    division =
    { id       = { type = 10300 id = 676 }
      name     = "Bikini Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 677 }
    name     = "Kwajalein Hendan"
    location = 1608
    division =
    { id       = { type = 10300 id = 678 }
      name     = "Kwajalein Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 679 }
    name     = "Saipan Hendan"
    location = 1627
    division =
    { id       = { type = 10300 id = 680 }
      name     = "Saipan Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 681 }
    name     = "Shumushushima Hendan"
    location = 1174
    division =
    { id       = { type = 10300 id = 682 }
      name     = "Shumushushima Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 683 }
    name     = "Bonin Hendan"
    location = 1599
    division =
    { id       = { type = 10300 id = 684 }
      name     = "Bonin Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 685 }
    name     = "Marcus Hendan"
    location = 1785
    division =
    { id       = { type = 10300 id = 686 }
      name     = "Marcus Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 687 }
    name     = "Ulithi Hendan"
    location = 1618
    division =
    { id       = { type = 10300 id = 688 }
      name     = "Ulithi Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 689 }
    name     = "Truk Hendan"
    location = 1613
    division =
    { id       = { type = 10300 id = 690 }
      name     = "Truk Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 691 }
    name     = "Ponape Hendan"
    location = 1610
    division =
    { id       = { type = 10300 id = 692 }
      name     = "Ponape Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 693 }
    name     = "Marshall Hendan"
    location = 1605
    division =
    { id       = { type = 10300 id = 694 }
      name     = "Marshall Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 10300 id = 695 }
    name     = "Yap Hendan"
    location = 1619
    division =
    { id       = { type = 10300 id = 696 }
      name     = "Yap Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { location = 1184
    id       = { type = 10300 id = 1200 }
    name     = "Home Army Group HQ"
    division =
    { id            = { type = 10300 id = 1201 }
      name          = "Home Army Group HQ"
      type          = hq
      model         = 1
      strength      = 100
      extra         = anti_air
      brigade_model = 1
    }
  }
  landunit =
  { location = 1391
    id       = { type = 10300 id = 1202 }
    name     = "Korean Army HQ"
    division =
    { id            = { type = 10300 id = 1203 }
      name          = "Korean Army HQ"
      type          = hq
      model         = 1
      strength      = 100
      extra         = anti_air
      brigade_model = 1
    }
  }
  landunit =
  { location = 1379
    id       = { type = 10300 id = 1204 }
    name     = "Manchurian Army Group HQ"
    division =
    { id            = { type = 10300 id = 1205 }
      name          = "Manchurian Army Group HQ"
      type          = hq
      model         = 1
      strength      = 100
      extra         = anti_air
      brigade_model = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1000 }
    name     = "Combined Fleet 1 Squadron"
    location = 1188
    base     = 1188
    division =
    { experience = 15
      id         = { type = 10300 id = 18 }
      name       = "IJN Nagato"
      type       = battleship
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 20 }
      name       = "IJN Mutsu"
      type       = battleship
      model      = 2
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1002 }
    name     = "Combined Fleet 9 Squadron"
    location = 1188
    base     = 1188
    division =
    { experience = 15
      id         = { type = 10300 id = 52 }
      name       = "IJN Kitakami"
      type       = light_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 53 }
      name       = "IJN Oi"
      type       = light_cruiser
      model      = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1003 }
    name     = "1. Fleet 2. Squadron"
    location = 1188
    base     = 1188
    division =
    { experience = 15
      id         = { type = 10300 id = 10 }
      name       = "IJN Fuso"
      type       = battleship
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 12 }
      name       = "IJN Yamashiro"
      type       = battleship
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 14 }
      name       = "IJN Ise"
      type       = battleship
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 16 }
      name       = "IJN Hyuga"
      type       = battleship
      model      = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1004 }
    name     = "1. Fleet 3. Squadron"
    location = 1188
    base     = 1188
    division =
    { experience = 15
      id         = { type = 10300 id = 2 }
      name       = "IJN Kongo"
      type       = battlecruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 4 }
      name       = "IJN Hiei"
      type       = battlecruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 6 }
      name       = "IJN Haruna"
      type       = battlecruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 8 }
      name       = "IJN Kirishima"
      type       = battlecruiser
      model      = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1005 }
    name     = "1. Fleet 6. Squadron"
    location = 1188
    base     = 1188
    division =
    { experience = 15
      id         = { type = 10300 id = 22 }
      name       = "IJN Furutaka"
      type       = heavy_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 23 }
      name       = "IJN Kako"
      type       = heavy_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 24 }
      name       = "IJN Aoba"
      type       = heavy_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 25 }
      name       = "IJN Kinugasa"
      type       = heavy_cruiser
      model      = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1006 }
    name     = "1. Fleet 3. Carrier Squadron"
    location = 1188
    base     = 1188
    division =
    { experience    = 15
      id            = { type = 10300 id = 1007 }
      name          = "IJN Zuiho"
      type          = escort_carrier
      model         = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1009 }
    name     = "1. Fleet 1&3 DD Squadrons"
    location = 1188
    base     = 1188
    division =
    { experience = 15
      id         = { type = 10300 id = 64 }
      name       = "IJN Sendai"
      type       = light_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 149 }
      name       = "40 Kuchikukantai"
      type       = destroyer
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 150 }
      name       = "41 Kuchikukantai"
      type       = destroyer
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 151 }
      name       = "42 Kuchikukantai"
      type       = destroyer
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 152 }
      name       = "43 Kuchikukantai"
      type       = destroyer
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 153 }
      name       = "44 Kuchikukantai"
      type       = destroyer
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 154 }
      name       = "45 Kuchikukantai"
      type       = destroyer
      model      = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1010 }
    name     = "2. Fleet 4. Squadron"
    location = 1321
    base     = 1321
    division =
    { experience = 15
      id         = { type = 10300 id = 34 }
      name       = "IJN Takao"
      type       = heavy_cruiser
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 35 }
      name       = "IJN Atago"
      type       = heavy_cruiser
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 36 }
      name       = "IJN Maya"
      type       = heavy_cruiser
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 37 }
      name       = "IJN Chokai"
      type       = heavy_cruiser
      model      = 2
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1011 }
    name     = "2. Fleet 5. Squadron"
    location = 1321
    base     = 1321
    division =
    { experience = 15
      id         = { type = 10300 id = 27 }
      name       = "IJN Myoko"
      type       = heavy_cruiser
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 28 }
      name       = "IJN Nachi"
      type       = heavy_cruiser
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 29 }
      name       = "IJN Haguro"
      type       = heavy_cruiser
      model      = 2
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1041 }
    name     = "2. Fleet 7. Squadron"
    location = 1321
    base     = 1321
    division =
    { experience = 15
      id         = { type = 10300 id = 39 }
      name       = "IJN Mogami"
      type       = heavy_cruiser
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 40 }
      name       = "IJN Mikuma"
      type       = heavy_cruiser
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 41 }
      name       = "IJN Suzuya"
      type       = heavy_cruiser
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 42 }
      name       = "IJN Kumano"
      type       = heavy_cruiser
      model      = 2
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1012 }
    name     = "2. Fleet 8. Squadron"
    location = 1321
    base     = 1321
    division =
    { experience = 15
      id         = { type = 10300 id = 44 }
      name       = "IJN Tone"
      type       = heavy_cruiser
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 45 }
      name       = "IJN Chikuma"
      type       = heavy_cruiser
      model      = 2
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1055 }
    name     = "2. Fleet 2&4. DD Squadron"
    location = 1321
    base     = 1321
    division =
    { experience = 15
      id         = { type = 10300 id = 65 }
      name       = "IJN Jintsu"
      type       = light_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 89 }
      name       = "1 Kuchikukantai"
      type       = destroyer
      model      = 0
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 90 }
      name       = "2 Kuchikukantai"
      type       = destroyer
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 91 }
      name       = "3 Kuchikukantai"
      type       = destroyer
      model      = 0
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 92 }
      name       = "4 Kuchikukantai"
      type       = destroyer
      model      = 0
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 93 }
      name       = "5 Kuchikukantai"
      type       = destroyer
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 94 }
      name       = "6 Kuchikukantai"
      type       = destroyer
      model      = 0
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 63 }
      name       = "IJN Naka"
      type       = light_cruiser
      model      = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1013 }
    name     = "3. Fleet 16. Squadron"
    location = 1322
    base     = 1322
    division =
    { experience = 15
      id         = { type = 10300 id = 30 }
      name       = "IJN Ashigara"
      type       = heavy_cruiser
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 50 }
      name       = "IJN Kuma"
      type       = light_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 56 }
      name       = "IJN Nagara"
      type       = light_cruiser
      model      = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1014 }
    name     = "3. Fleet 5. DD Squadron"
    location = 1322
    base     = 1322
    division =
    { experience = 15
      id         = { type = 10300 id = 59 }
      name       = "IJN Natori"
      type       = light_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 96 }
      name       = "7 Kuchikukantai"
      type       = destroyer
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 97 }
      name       = "8 Kuchikukantai"
      type       = destroyer
      model      = 0
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1015 }
    name     = "4. Fleet 18 Squadron"
    location = 1613
    base     = 1613
    division =
    { experience = 15
      id         = { type = 10300 id = 47 }
      name       = "IJN Tenryu"
      type       = light_cruiser
      model      = 0
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 48 }
      name       = "IJN Tatsuta"
      type       = light_cruiser
      model      = 0
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 68 }
      name       = "IJN Kashima"
      type       = light_cruiser
      model      = 1
      maxspeed   = 18
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 98 }
      name       = "9 Kuchikukantai"
      type       = destroyer
      model      = 0
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 99 }
      name       = "10 Kuchikukantai"
      type       = destroyer
      model      = 0
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1016 }
    name     = "5. Fleet 21 Squadron"
    location = 1337
    base     = 1337
    division =
    { experience = 15
      id         = { type = 10300 id = 51 }
      name       = "IJN Tama"
      type       = light_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 54 }
      name       = "IJN Kiso"
      type       = light_cruiser
      model      = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1017 }
    name     = "6. Fleet"
    location = 1608
    base     = 1608
    division =
    { experience = 15
      id         = { type = 10300 id = 69 }
      name       = "IJN Katori"
      type       = light_cruiser
      model      = 1
      maxspeed   = 18
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 292 }
      name       = "1 Sensuikantai"
      type       = submarine
      model      = 0
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 293 }
      name       = "2 Sensuikantai"
      type       = submarine
      model      = 0
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 294 }
      name       = "3 Sensuikantai"
      type       = submarine
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 295 }
      name       = "4 Sensuikantai"
      type       = submarine
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 297 }
      name       = "7 Sensuikantai"
      type       = submarine
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 298 }
      name       = "8 Sensuikantai"
      type       = submarine
      model      = 3
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1018 }
    name     = "1. Carrier Fleet"
    location = 1184
    base     = 1184
    division =
    { experience    = 25
      id            = { type = 10300 id = 401 }
      name          = "IJN Kaga"
      type          = carrier
      model         = 1
      extra         = cag
      brigade_model = 4
    }
    division =
    { experience    = 25
      id            = { type = 10300 id = 402 }
      name          = "IJN Agaki"
      type          = carrier
      model         = 1
      extra         = cag
      brigade_model = 4
    }
    division =
    { id    = { type = 10300 id = 403 }
      name  = "IJN Ryuho"
      type  = carrier
      model = 2
      extra = cag
      brigade_model = 4
    }
    division =
    { experience    = 25
      id            = { type = 10300 id = 404 }
      name          = "IJN Soryu"
      type          = carrier
      model         = 2
      extra         = cag
      brigade_model = 4
    }
    division =
    { experience    = 25
      id            = { type = 10300 id = 405 }
      name          = "IJN Hiryu"
      type          = carrier
      model         = 2
      extra         = cag
      brigade_model = 4
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1019 }
    name     = "IJN Reserve Fleet"
    location = 1190
    base     = 1190
    division =
    { experience = 15
      id         = { type = 10300 id = 57 }
      name       = "IJN Isuzu"
      type       = light_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 58 }
      name       = "IJN Yura"
      type       = light_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 60 }
      name       = "IJN Kinu"
      type       = light_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 61 }
      name       = "IJN Abukuma"
      type       = light_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 67 }
      name       = "IJN Yubari"
      type       = light_cruiser
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 70 }
      name       = "IJN Izumo"
      type       = heavy_cruiser
      model      = 0
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1020 }
    name     = "China Fleet"
    location = 1237
    base     = 1237
    division =
    { experience = 15
      id         = { type = 10300 id = 156 }
      name       = "46 Kuchikukantai"
      type       = destroyer
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 157 }
      name       = "47 Kuchikukantai"
      type       = destroyer
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 158 }
      name       = "48 Kuchikukantai"
      type       = destroyer
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 355 }
      name       = "1 Yuso Sentai"
      type       = transport
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 356 }
      name       = "2 Yuso Sentai"
      type       = transport
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 353 }
      name       = "3 Yuso Sentai"
      type       = transport
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 354 }
      name       = "4 Yuso Sentai"
      type       = transport
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1021 }
    name     = "Korea Fleet"
    location = 1196
    base     = 1196
    division =
    { experience = 15
      id         = { type = 10300 id = 143 }
      name       = "35 Kuchikukantai"
      type       = destroyer
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 144 }
      name       = "36 Kuchikukantai"
      type       = destroyer
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 357 }
      name       = "5 Yuso Sentai"
      type       = transport
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 358 }
      name       = "6 Yuso Sentai"
      type       = transport
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 359 }
      name       = "7 Yuso Sentai"
      type       = transport
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 360 }
      name       = "8 Yuso Sentai"
      type       = transport
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1022 }
    name     = "Southern Fleet"
    location = 1337
    base     = 1337
    division =
    { experience = 15
      id         = { type = 10300 id = 145 }
      name       = "37 Kuchikukantai"
      type       = destroyer
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 146 }
      name       = "38 Kuchikukantai"
      type       = destroyer
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 147 }
      name       = "39 Kuchikukantai"
      type       = destroyer
      model      = 1
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 361 }
      name       = "9 Yuso Sentai"
      type       = transport
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 362 }
      name       = "10 Yuso Sentai"
      type       = transport
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 363 }
      name       = "11 Yuso Sentai"
      type       = transport
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 364 }
      name       = "12 Yuso Sentai"
      type       = transport
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1065 }
    name     = "Reserve Fleet"
    location = 1186
    base     = 1186
    division =
    { experience = 15
      id         = { type = 10300 id = 365 }
      name       = "13 Yuso Sentai"
      type       = transport
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 366 }
      name       = "14 Yuso Sentai"
      type       = transport
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 285 }
      name       = "9 Sensuikantai"
      type       = submarine
      model      = 3
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 286 }
      name       = "13 Sensuikantai"
      type       = submarine
      model      = 3
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 288 }
      name       = "26 Sensuikantai"
      type       = submarine
      model      = 3
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 289 }
      name       = "27 Sensuikantai"
      type       = submarine
      model      = 3
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 290 }
      name       = "33 Sensuikantai"
      type       = submarine
      model      = 3
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 300 }
      name       = "11 Sensuikantai"
      type       = submarine
      model      = 2
    }
    division =
    { experience = 15
      id         = { type = 10300 id = 301 }
      name       = "12 Sensuikantai"
      type       = submarine
      model      = 2
    }
  }
  airunit =
  { id       = { type = 10300 id = 303 }
    name     = "17. Hikoutai"
    location = 1184
    base     = 1184
    division =
    { experience = 25
      id         = { type = 10300 id = 304 }
      name       = "5 Hikodan"
      strength   = 100
      type       = interceptor
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 305 }
      name       = "144 Hikodan"
      strength   = 100
      type       = interceptor
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 306 }
      name       = "105 Hikodan"
      strength   = 30
      type       = tactical_bomber
      model      = 1
    }
  }
  airunit =
  { id       = { type = 10300 id = 307 }
    name     = "4. Hikoutai"
    location = 1184
    base     = 1184
    division =
    { experience = 25
      id         = { type = 10300 id = 308 }
      name       = "4 Hikodan"
      strength   = 100
      type       = interceptor
      model      = 2
    }
  }
  airunit =
  { id       = { type = 10300 id = 309 }
    name     = "1. Hikoutai"
    location = 1184
    base     = 1184
    division =
    { experience = 25
      id         = { type = 10300 id = 310 }
      name       = "44 Hikodan"
      strength   = 100
      type       = naval_bomber
      model      = 1
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 311 }
      name       = "54 Hikodan"
      strength   = 100
      type       = interceptor
      model      = 2
    }
  }
  airunit =
  { id       = { type = 10300 id = 312 }
    name     = "2. Hikoutai"
    location = 1187
    base     = 1187
    division =
    { experience = 25
      id         = { type = 10300 id = 313 }
      name       = "6 Hikodan"
      strength   = 35
      type       = tactical_bomber
      model      = 1
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 314 }
      name       = "9 Hikodan"
      strength   = 40
      type       = interceptor
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 316 }
      name       = "3 Hikodan"
      strength   = 30
      type       = tactical_bomber
      model      = 1
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 317 }
      name       = "33 Hikodan"
      strength   = 40
      type       = interceptor
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 318 }
      name       = "58 Hikodan"
      strength   = 30
      type       = tactical_bomber
      model      = 1
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 319 }
      name       = "6 Hikodan"
      strength   = 30
      type       = tactical_bomber
      model      = 1
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 321 }
      name       = "70 Hikodan"
      strength   = 40
      type       = interceptor
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 322 }
      name       = "85 Hikodan"
      strength   = 40
      type       = interceptor
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 323 }
      name       = "87 Hikodan"
      strength   = 40
      type       = interceptor
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 324 }
      name       = "6 Hikodan"
      strength   = 100
      type       = naval_bomber
      model      = 1
    }
  }
  airunit =
  { id       = { type = 10300 id = 326 }
    name     = "3. Hikoutai"
    location = 1613
    base     = 1613
    division =
    { experience = 25
      id         = { type = 10300 id = 327 }
      name       = "27 Hikodan"
      strength   = 100
      type       = tactical_bomber
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 328 }
      name       = "59 Hikodan"
      strength   = 100
      type       = interceptor
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 329 }
      name       = "75 Hikodan"
      strength   = 100
      type       = tactical_bomber
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 332 }
      name       = "60 Hikodan"
      strength   = 100
      type       = tactical_bomber
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 333 }
      name       = "64 Hikodan"
      strength   = 100
      type       = interceptor
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 334 }
      name       = "98 Hikodan"
      strength   = 100
      type       = naval_bomber
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 335 }
      name       = "31 Hikodan"
      strength   = 100
      type       = naval_bomber
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 337 }
      name       = "77 Hikodan"
      strength   = 100
      type       = interceptor
      model      = 2
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 338 }
      name       = "1 Hikodan"
      strength   = 100
      type       = interceptor
      model      = 2
    }
  }
  airunit =
  { id       = { type = 10300 id = 340 }
    name     = "5. Hikoutai"
    location = 1337
    base     = 1337
    division =
    { experience = 25
      id         = { type = 10300 id = 341 }
      name       = "8 Hikodan"
      strength   = 100
      type       = tactical_bomber
      model      = 1
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 342 }
      name       = "14 Hikodan"
      strength   = 100
      type       = tactical_bomber
      model      = 1
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 343 }
      name       = "16 Hikodan"
      strength   = 100
      type       = naval_bomber
      model      = 1
    }
    division =
    { experience = 25
      id         = { type = 10300 id = 344 }
      name       = "50 Hikodan"
      strength   = 100
      type       = interceptor
      model      = 2
    }
    division =
    { id       = { type = 10300 id = 345 }
      name     = "11 Hikodan"
      strength = 100
      type     = transport_plane
    }
    division =
    { id       = { type = 10300 id = 346 }
      name     = "12 Hikodan"
      strength = 100
      type     = transport_plane
    }
  }
  division_development =
  { name  = "IJN Yamato"
    type  = battleship
    model = 6
    cost  = 12.2
    id    = { type = 10300 id = 1100 }
    date  = { year = 1941 month = december day = 12 }
  }
  division_development =
  { name  = "IJN Musashi"
    type  = battleship
    model = 6
    cost  = 12.2
    id    = { type = 10300 id = 1101 }
    date  = { year = 1942 month = august day = 5 }
  }
  division_development =
  { name  = "IJN Shokaku"
    type  = carrier
    model = 3
    cost  = 5.4
    id    = { type = 10300 id = 1102 }
    date  = { year = 1941 month = august day = 8 }
  }
  brigade_development =
  { name  = "Shokaku CAG"
    type  = cag
    model = 4
    cost  = 3.2
    id    = { type = 10300 id = 1103 }
    date  = { year = 1941 month = august day = 8 }
  }
  division_development =
  { name  = "IJN Zuikaku"
    type  = carrier
    model = 3
    cost  = 5.4
    id    = { type = 10300 id = 1104 }
    date  = { year = 1941 month = september day = 25 }
  }
  brigade_development =
  { name  = "Zuikaku CAG"
    type  = cag
    model = 4
    cost  = 3.2
    id    = { type = 10300 id = 1105 }
    date  = { year = 1941 month = september day = 25 }
  }
  division_development =
  { name  = "IJN Shoho"
    type  = escort_carrier
    model = 1
    cost  = 3.8
    id    = { type = 10300 id = 21106 }
    date  = { year = 1942 month = january day = 26 }
  }
  division_development =
  { name  = "2. Koku Sentai"
    type  = carrier
    model = 0
    cost  = 3.8
    id    = { type = 10300 id = 1106 }
    date  = { year = 1942 month = january day = 26 }
  }
  brigade_development =
  { name  = "2. Koku Sentai CAG"
    type  = cag
    model = 4
    cost  = 1.7
    id    = { type = 10300 id = 1107 }
    date  = { year = 1942 month = january day = 26 }
  }
  division_development =
  { name  = "IJN Junyo"
    type  = carrier
    model = 1
    cost  = 3.8
    id    = { type = 10300 id = 1110 }
    date  = { year = 1942 month = may day = 5 }
  }
  brigade_development =
  { name  = "Junyo CAG"
    type  = cag
    model = 4
    cost  = 1.1
    id    = { type = 10300 id = 1111 }
    date  = { year = 1942 month = may day = 5 }
  }
  division_development =
  { name  = "IJN Hiyo"
    type  = carrier
    model = 1
    cost  = 3.8
    id    = { type = 10300 id = 1112 }
    date  = { year = 1942 month = july day = 31 }
  }
  brigade_development =
  { name  = "Hiyo CAG"
    type  = cag
    model = 4
    cost  = 1.0
    id    = { type = 10300 id = 1113 }
    date  = { year = 1942 month = july day = 31 }
  }
  division_development =
  { name  = "IJN Kashii"
    type  = light_cruiser
    model = 1
    cost  = 3.2
    id    = { type = 10300 id = 1114 }
    date  = { year = 1941 month = december day = 5 }
  }
  division_development =
  { name  = "52 Kuchikukantai"
    type  = destroyer
    model = 2
    cost  = 1.6
    id    = { type = 10300 id = 1115 }
    date  = { year = 1941 month = october day = 1 }
  }
  division_development =
  { name  = "34 Sensuikantai"
    type  = submarine
    model = 2
    cost  = 1.5
    id    = { type = 10300 id = 1116 }
    date  = { year = 1941 month = august day = 1 }
  }
  division_development =
  { name  = "35 Sensuikantai"
    type  = submarine
    model = 3
    cost  = 2.3
    id    = { type = 10300 id = 1117 }
    date  = { year = 1941 month = september day = 1 }
  }
}
