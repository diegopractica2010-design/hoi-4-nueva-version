
##############################
# Country definition for JAP #
##############################

province = { id = 1248 supplypool = 1000 oilpool = 100 } # Shantou

province = { id = 1179 anti_air = 2 } # Sapporo
province = { id = 1180 ic = 3 } # Sendai
province =
{ id         = 1181
  anti_air   = 4
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Akita
province = { id = 1182 anti_air = 2 } # Fukushima
province = { id = 1183 anti_air = 2 } # Niigata
province =
{ id         = 1184
  ic         = 8
  anti_air   = 6
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Tokyo
province =
{ id         = 1185
  ic         = 4
  anti_air   = 5
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
  ic         = 4
  anti_air   = 6
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Osaka
province =
{ id         = 1188
  anti_air   = 4
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Hiroshima
province =
{ id         = 1189
  ic         = 4
  anti_air   = 2
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Shikoku
province =
{ id         = 1190
  anti_air   = 2
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
}              # Fukuoka
province =
{ id         = 1193
  anti_air   = 2
  air_base   = { size = 6 current_size = 6 }
  naval_base = { size = 6 current_size = 6 }
  supplypool = 1000
}              # Okinawa
province =
{ id         = 1196
  anti_air   = 2
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
  supplypool = 5000
  oilpool    = 100
}              # Busan
province =
{ id         = 1202
  anti_air   = 5
  naval_base = { size = 5 current_size = 5 }
  air_base   = { size = 7 current_size = 7 }
  supplypool = 500
  oilpool    = 100
}              # Dalian
province = { id = 1203 supplypool = 1000 oilpool = 100 } # Tangshan
province =
{ id         = 1322
  anti_air   = 2
  air_base   = { size = 8 current_size = 8 }
  naval_base = { size = 10 current_size = 10 }
  supplypool = 1000
  oilpool    = 100
}              # Kaohsiung
province = { id = 1323 anti_air = 2 } # Taipei
province =
{ id       = 1391
  anti_air = 2
  air_base = { size = 4 current_size = 4 }
}            # Hyesan
province = { id = 1599 supplypool = 500 } # Iwo Jima
province =
{ id         = 1601
  anti_air   = 7
  air_base   = { size = 4 current_size = 4 }
  naval_base = { size = 2 current_size = 2 }
  supplypool = 500
}              # Eniwetok
province = { id = 1605 anti_air = 3 } # Majuro
province =
{ id         = 1608
  anti_air   = 8
  air_base   = { size = 4 current_size = 4 }
  naval_base = { size = 2 current_size = 2 }
  supplypool = 2000
}              # Kwajalein
province = { id = 1610 supplypool = 500 } # Ponape
province =
{ id         = 1613
  anti_air   = 7
  air_base   = { size = 10 current_size = 10 }
  naval_base = { size = 10 current_size = 10 }
  supplypool = 500
}              # Truk
province = { id = 1618 supplypool = 500 } # Ulithi
province = { id = 1619 anti_air = 3 supplypool = 500 } # Yap
province = { id = 1621 supplypool = 500 } # Palau
province = { id = 1625 supplypool = 500 } # Rota
province = { id = 1626 supplypool = 500 } # Tinian
province = { id = 1627 anti_air = 3 supplypool = 500 } # Saipan
province = { id = 1784 anti_air = 2 } # Bonin Islands
province = { id = 1785 supplypool = 500 } # Marcus Island

#####################
# Country main data #
#####################

country =
{ tag                    = JAP
  capital                = 1184
  belligerence           = 15
  manpower               = 735
  # Resource Reserves
  energy                 = 1000
  metal                  = 1000
  rare_materials         = 500
  oil                    = 500
  supplies               = 500
  money                  = 100
  transports             = 1100
  escorts                = 11
  policy =
  { date              = { year = 0 month = january day = 0 }
    democratic        = 3
    political_left    = 2
    freedom           = 3
    free_market       = 3
    professional_army = 6
    defense_lobby     = 8
    interventionism   = 8
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
  nationalprovinces      = { 1177 1178 1179 1180 1181 1182 1183 1184 1185 1186 1187 1188 1189 1190 1191 1784 1599 1192 1193 1785 1174 1176 1175 1194
                             1195 1196 1197 1198 1199 1393 1391 1376 1392 1200 1201 1624
                           }
  ownedprovinces         = { 1203 1177 1178 1179 1180 1181 1182 1183 1184 1185 1186 1187 1188 1189 1190 1191 1784 1599 1192 1193 1785 1219 1627 1626
                             1625 1619 1621 1604 1620 1618 1617 1616 1615 1613 1612 1610 1609 1600 1601 1602 1603 1605 1606 1607 1608 1323 1322 1324
                             1376 1391 1392 1200 1201 1199 1198 1197 1196 1195 1194 1393 1202 1176 1174
                           }
  controlledprovinces    = { 1177 1178 1179 1180 1181 1182 1183 1184 1185 1186 1187 1188 1189 1190 1191 1784 1599 1192 1193 1785 1219 1627 1626 1625
                             1619 1621 1604 1620 1618 1617 1616 1615 1613 1612 1610 1609 1600 1601 1602 1603 1605 1606 1607 1608 1323 1322 1324 1376
                             1391 1392 1200 1201 1199 1198 1197 1196 1195 1194 1393 1202 1176 1174 1203 1204 1205 1210 1211 1212 1225 1226 1213 1214
                             1215 1216 1217 1220 1235 1236 1237 1221 1218 1223 1234 1222 1230 1233 1224 1238 1239 1321 1232 1253 1252 1251 1248
                           }
  # JAP 1939 techs
  # ######################
  techapps               = { 1010  1020  1030  1110  1120  1150  1160  1170  1190  1200  1210  12100 12110 1220  1310  1340  14000 14010 2010  2020  2030 
                             2040  2150  2290  2300  2310  2320  2330  2400  2450  2460  2510  3010  3020  3030  3070  3080  3090  3100  3130  3140 
                             3150  3190  3200  3210  3250  3260  3270  3280  3310  3320  3330  3340  3350  3400  3410  3420  3430  4010  4020  4030 
                             4040  4050  4120  4130  4140  4190  5010  5050  5080  5090  5100  5190  5200  5310  5320  5350  5470  6010  6030  6110 
                             6120  6160  8010  8020  8030  8040  8050  8060  8090  8100  8110  8180  8230  9010  9020  9030  9040  9050  9060  9070 
                             9080  9090  9100  9110  9190  9200 
                           }
  blueprints             = { 8310 8320 }
  diplomacy =
  { relation = { tag = AST value = -25 }
    relation = { tag = BEL value = -25 }
    relation = { tag = CGX value = -200 }
    relation = { tag = CHC value = -200 }
    relation = { tag = CHI value = -200 }
    relation = { tag = CHL value = 20 }
    relation = { tag = CSX value = -200 }
    relation = { tag = CXB value = -200 }
    relation = { tag = CYN value = -100 }
    relation = { tag = ENG value = -50 }
    relation = { tag = FIN value = 20 }
    relation = { tag = FRA value = -40 }
    relation = { tag = GER value = 75 }
    relation = { tag = HOL value = -50 }
    relation = { tag = MAN value = 200 access = yes }
    relation = { tag = MEN value = 200 access = yes }
    relation = { tag = SIA value = 75 }
    relation = { tag = SIK value = -170 }
    relation = { tag = USA value = 15 }
  }
  headofstate            = { type = 9 id = 5001 }
  headofgovernment       = { type = 9 id = 5035 }
  foreignminister        = { type = 9 id = 5056 }
  armamentminister       = { type = 9 id = 5082 }
  ministerofsecurity     = { type = 9 id = 5108 }
  ministerofintelligence = { type = 9 id = 5137 }
  chiefofstaff           = { type = 9 id = 5007 }
  chiefofarmy            = { type = 9 id = 5008 }
  chiefofnavy            = { type = 9 id = 5200 }
  chiefofair             = { type = 9 id = 5185 }
  dormant_ministers      = { 5002 5040 5033 5034 5041 5003 5057 5063 5053 5055 5004 5005 5105 5106 5107 5115 5006 5134 5189 }
  # Resources from Koshu
  # Resources from Taihoku
  # Resources from Haikou
  # Supplies & Oil to Koshu
  # supplies & Oil to Guangzhou
  # Supplies & Oil to Haikou
  # Supplies & Oil to Taihoku
  # Supplies & Oil to Minamitorishima
  # Supplies & Oil to Bonin Islands
  # Supplies & Oil to Truk Islands
  # Supplies & Oil to Kwajalein  
  # #################
  # ##JAPANESE OOB###
  # ######1939#######
  # #################
  landunit =
  { id       = { type = 30036 id = 4500 }
    name     = "China Exp Army HQ"
    location = 1224
    division =
    { experience = 20
      id         = { type = 30036 id = 2501 }
      name       = "China Exp Army HQ"
      strength   = 100
      type       = hq
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 2503 }
      name       = "3. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = engineer
    }
  }
  landunit =
  { id       = { type = 30036 id = 1511 }
    name     = "23. Hendan"
    location = 1226
    division =
    { experience = 20
      id         = { type = 30036 id = 505 }
      name       = "13. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = artillery
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 506 }
      name       = "34. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = engineer
    }
  }
  landunit =
  { id       = { type = 30036 id = 1521 }
    name     = "39. Hoheishidan"
    location = 1225
    division =
    { experience = 20
      id         = { type = 30036 id = 507 }
      name       = "39. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
    }
  }
  landunit =
  { id       = { type = 30036 id = 1529 }
    name     = "13. Hendan" # Shanghai, China 
    location = 1239
    division =
    { experience = 20
      id         = { type = 30036 id = 512 }
      name       = "15. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 513 }
      name       = "17. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
    }
  }
  landunit =
  { id       = { type = 30036 id = 1513 }
    name     = "7. Hendan"
    location = 1238
    division =
    { experience = 20
      id         = { type = 30036 id = 514 }
      name       = "22. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 519 }
      name       = "17. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 30036 id = 1514 }
    name     = "6. Hendan" # Shanghai, China 
    location = 1234
    division =
    { experience = 20
      id         = { type = 30036 id = 520 }
      name       = "20. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 521 }
      name       = "2. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 30036 id = 1562 }
    name     = "23. Hendan" # Canton, China
    location = 1252
    division =
    { experience = 20
      id         = { type = 30036 id = 523 }
      name       = "38. Hoheishidan"
      strength   = 100
      type       = infantry
      extra      = engineer
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 524 }
      name       = "51. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = artillery
    }
  }
  landunit =
  { id       = { type = 30036 id = 1572 }
    name     = "23. Hendan" # Canton, China
    location = 1251
    division =
    { experience = 20
      id         = { type = 30036 id = 525 }
      name       = "104. Hoheishidan"
      strength   = 100
      type       = infantry
      extra      = artillery
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 526 }
      name       = "19. Independent Mixed Brigade"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = anti_tank
    }
  }
  landunit =
  { id       = { type = 30036 id = 1577 }
    name     = "2. Hendan" # Peking, China
    location = 1208
    division =
    { experience = 20
      id         = { type = 30036 id = 529 }
      name       = "27. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 530 }
      name       = "35. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = anti_air
    }
  }
  landunit =
  { id       = { type = 30036 id = 1536 }
    name     = "1. Hendan" # Taiyuan, China
    location = 1232
    division =
    { experience = 20
      id         = { type = 30036 id = 537 }
      name       = "36. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 538 }
      name       = "37. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = artillery
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 540 }
      name       = "3. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 543 }
      name       = "16. Independent Mixed Brigade"
      strength   = 50
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 30036 id = 1544 }
    name     = "12. Hendan" # Sainan, China
    location = 1253
    division =
    { experience = 20
      id         = { type = 30036 id = 545 }
      name       = "32. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
  }
  landunit =
  { id       = { type = 30036 id = 1549 }
    name     = "Mongol Army" # Changchiakou, China
    location = 1209
    division =
    { experience = 20
      id         = { type = 30036 id = 550 }
      name       = "26. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = anti_air
    }
    division =
    { id       = { type = 30036 id = 551 }
      name     = "2. Independent Mixed Brigade"
      strength = 50
      type     = infantry
      model    = 2
    }
    division =
    { id       = { type = 30036 id = 552 }
      name     = "1 Moukogo Kiheishidan"
      strength = 100
      type     = cavalry
      model    = 0
    }
    division =
    { id       = { type = 30036 id = 553 }
      name     = "2 Moukogo Kiheishidan"
      strength = 100
      type     = cavalry
      model    = 0
    }
    division =
    { id       = { type = 30036 id = 554 }
      name     = "3 Moukogo Kiheishidan"
      strength = 100
      type     = cavalry
      model    = 0
    }
    division =
    { id       = { type = 30036 id = 555 }
      name     = "4 Moukogo Kiheishidan"
      strength = 100
      type     = cavalry
      model    = 0
    }
    division =
    { id       = { type = 30036 id = 556 }
      name     = "5 Moukogo Kiheishidan"
      strength = 100
      type     = cavalry
      model    = 0
    }
  }
  landunit =
  { id       = { type = 30036 id = 1561 }
    name     = "10. Hoheishidan"
    location = 1223
    division =
    { id       = { type = 30036 id = 563 }
      name     = "10. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
      extra    = anti_air
    }
  }
  landunit =
  { id       = { type = 30036 id = 1564 }
    name     = "29. Hoheishidan"
    location = 1222
    division =
    { experience = 20
      id         = { type = 30036 id = 565 }
      name       = "29.  Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = anti_air
    }
  }
  landunit =
  { id       = { type = 30036 id = 1569 }
    name     = "Local defence force"
    location = 1230
    division =
    { experience = 20
      id         = { type = 30036 id = 566 }
      name       = "Local Defence Command"
      strength   = 100
      type       = garrison
      model      = 1
      extra      = police
    }
  }
  landunit =
  { id       = { type = 30036 id = 1369 }
    name     = "3. Hendan" # Botanko, Manchuko
    location = 1530
    division =
    { id       = { type = 30036 id = 568 }
      name     = "9. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
      extra    = artillery
    }
    division =
    { id       = { type = 30036 id = 570 }
      name     = "57. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
      extra    = artillery
    }
    division =
    { id       = { type = 30036 id = 572 }
      name     = "1. Border Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
  }
  landunit =
  { id       = { type = 30036 id = 1273 }
    name     = "4. Hendan" # Songo, Manchuko
    location = 1381
    division =
    { id       = { type = 30036 id = 574 }
      name     = "1. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
      extra    = artillery
    }
    division =
    { id       = { type = 30036 id = 575 }
      name     = "2. Border Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 30036 id = 576 }
      name     = "3. Border Guards"
      strength = 100
      type     = garrison
      model    = 1
    }
  }
  landunit =
  { id       = { type = 30036 id = 577 }
    name     = "5. Hendan" # Toan, Manchuko
    location = 1374
    division =
    { id       = { type = 30036 id = 578 }
      name     = "11. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
      extra    = artillery
    }
    division =
    { id       = { type = 30036 id = 579 }
      name     = "24. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
    }
    division =
    { id       = { type = 30036 id = 582 }
      name     = "5. Border Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 30036 id = 583 }
      name     = "3 Manchuko Kiheishidan"
      strength = 50
      type     = cavalry
      model    = 0
    }
  }
  landunit =
  { id       = { type = 30036 id = 584 }
    name     = "6. Hendan" # Hailar, Manchuko
    location = 1382
    division =
    { id       = { type = 30036 id = 585 }
      name     = "14. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
      extra    = anti_tank
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 586 }
      name       = "23. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = police
    }
  }
  landunit =
  { id       = { type = 30036 id = 587 }
    name     = "20. Hendan" # Keinei, Manchuko
    location = 1375
    division =
    { id       = { type = 30036 id = 588 }
      name     = "8. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
      extra    = artillery
    }
    division =
    { id       = { type = 30036 id = 589 }
      name     = "25. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
      extra    = artillery
    }
    division =
    { id       = { type = 30036 id = 590 }
      name     = "6. Border Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_tank
    }
  }
  # Southern Expeditionary Army
  landunit =
  { id       = { type = 30036 id = 597 }
    name     = "14. Hendan"
    location = 1248
    division =
    { experience = 20
      id         = { type = 30036 id = 598 }
      name       = "16. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = engineer
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 599 }
      name       = "48. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = artillery
    }
  }
  landunit =
  { id       = { type = 30036 id = 2602 }
    name     = "15. Hendan"
    location = 1322
    division =
    { experience = 20
      id         = { type = 30036 id = 2603 }
      name       = "33. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 2604 }
      name       = "55. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
    }
  }
  landunit =
  { id       = { type = 30036 id = 2605 }
    name     = "15. Hendan"
    location = 1232
    division =
    { experience = 20
      id         = { type = 30036 id = 2606 }
      name       = "2. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 1
      extra      = engineer
    }
    division =
    { experience = 40
      id         = { type = 30036 id = 3612 }
      name       = "Imperial Guards"
      strength   = 100
      type       = infantry
      model      = 2
      extra      = artillery
    }
  }
  # Imperial General Headquarters
  landunit =
  { id       = { type = 30036 id = 614 }
    name     = "Imperial General HQ" # Tokyo
    location = 1184
    division =
    { id       = { type = 30036 id = 615 }
      name     = "Imperial General HQ"
      strength = 100
      type     = hq
      model    = 1
    }
    division =
    { id       = { type = 30036 id = 616 }
      name     = "4. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
    }
  }
  landunit =
  { id       = { type = 30036 id = 618 }
    name     = "North Japan Army"
    location = 1181
    division =
    { id       = { type = 30036 id = 622 }
      name     = "1. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
    }
  }
  landunit =
  { id       = { type = 30036 id = 626 }
    name     = "Central Japan Army"
    location = 1185
    division =
    { id       = { type = 30036 id = 630 }
      name     = "5. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
  }
  landunit =
  { id       = { type = 30036 id = 632 }
    name     = "West Japan Army"
    location = 1187
    division =
    { id       = { type = 30036 id = 633 }
      name     = "5. Depot"
      strength = 100
      type     = infantry
      model    = 0
      extra    = anti_air
    }
  }
  landunit =
  { id       = { type = 30036 id = 642 }
    name     = "East Japan Army"
    location = 1190
    division =
    { id       = { type = 30036 id = 645 }
      name     = "16. Home Guards"
      strength = 100
      type     = garrison
      model    = 1
      extra    = anti_air
    }
  }
  landunit =
  { id       = { type = 30036 id = 647 }
    name     = "Korean Army"
    location = 1376
    division =
    { id       = { type = 30036 id = 648 }
      name     = "19. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
      extra    = anti_air
    }
    division =
    { id       = { type = 30036 id = 649 }
      name     = "20. Hoheishidan"
      strength = 100
      type     = infantry
      model    = 1
      extra    = artillery
    }
    division =
    { id       = { type = 30036 id = 650 }
      name     = "1. Korean Garrison"
      strength = 100
      type     = garrison
      model    = 1
    }
    division =
    { id       = { type = 30036 id = 651 }
      name     = "2. Korean Garrison"
      strength = 100
      type     = garrison
      model    = 1
    }
  }
  landunit =
  { id       = { type = 30036 id = 654 }
    name     = "Taiwan Army"
    location = 1322
    division =
    { id       = { type = 30036 id = 655 }
      name     = "1. Taiwan Garrison"
      strength = 100
      type     = garrison
      model    = 1
    }
    division =
    { id       = { type = 30036 id = 656 }
      name     = "2. Taiwan Garrison"
      strength = 100
      type     = garrison
      model    = 1
    }
  }
  landunit =
  { id       = { type = 30036 id = 1654 }
    name     = "Special Taskforce"
    location = 1321
    division =
    { experience = 40
      id         = { type = 10300 id = 1616 }
      name       = "14. Hoheishidan"
      strength   = 100
      type       = infantry
      model      = 2
    }
    division =
    { experience = 40
      id         = { type = 10300 id = 1617 }
      name       = "South Seas Detachment"
      strength   = 100
      type       = marine
      model      = 2
    }
  }
  # Pacific garrisons:
  landunit =
  { id       = { type = 30036 id = 658 }
    name     = "Saishu Hendan"
    location = 1177
    division =
    { id       = { type = 30036 id = 659 }
      name     = "Saishu Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 660 }
    name     = "Naha Hendan"
    location = 1193
    division =
    { id       = { type = 30036 id = 661 }
      name     = "Naha Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 662 }
    name     = "Toyohara Hendan"
    location = 1184
    division =
    { id       = { type = 30036 id = 663 }
      name     = "Toyohara Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 664 }
    name     = "Tomari Hendan"
    location = 1184
    division =
    { id       = { type = 30036 id = 665 }
      name     = "Tomari Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 667 }
    name     = "Shana Hendan"
    location = 1176
    division =
    { id       = { type = 30036 id = 668 }
      name     = "Shana Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 669 }
    name     = "Mariane Hendan"
    location = 1184
    division =
    { id       = { type = 30036 id = 670 }
      name     = "Mariane Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 671 }
    name     = "Palau Hendan"
    location = 1621
    division =
    { id       = { type = 30036 id = 672 }
      name     = "Palau Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 673 }
    name     = "Eniwetok Hendan"
    location = 1601
    division =
    { id       = { type = 30036 id = 674 }
      name     = "Eniwetok Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 675 }
    name     = "Bikini Hendan"
    location = 1600
    division =
    { id       = { type = 30036 id = 676 }
      name     = "Bikini Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 677 }
    name     = "Kwajalein Hendan"
    location = 1608
    division =
    { id       = { type = 30036 id = 678 }
      name     = "Kwajalein Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 679 }
    name     = "Saipan Hendan"
    location = 1627
    division =
    { id       = { type = 30036 id = 680 }
      name     = "Saipan Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 681 }
    name     = "Shumushushima Hendan"
    location = 1174
    division =
    { id       = { type = 30036 id = 682 }
      name     = "Shumushushima Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 683 }
    name     = "Bonin Hendan"
    location = 1599
    division =
    { id       = { type = 30036 id = 684 }
      name     = "Bonin Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 685 }
    name     = "Marcus Hendan"
    location = 1785
    division =
    { id       = { type = 30036 id = 686 }
      name     = "Marcus Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 687 }
    name     = "Ulithi Hendan"
    location = 1618
    division =
    { id       = { type = 30036 id = 688 }
      name     = "Ulithi Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 689 }
    name     = "Truk Hendan"
    location = 1613
    division =
    { id       = { type = 30036 id = 690 }
      name     = "Truk Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 691 }
    name     = "Ponape Hendan"
    location = 1610
    division =
    { id       = { type = 30036 id = 692 }
      name     = "Ponape Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 693 }
    name     = "Marshall Hendan"
    location = 1605
    division =
    { id       = { type = 30036 id = 694 }
      name     = "Marshall Hendan"
      strength = 100
      type     = garrison
    }
  }
  landunit =
  { id       = { type = 30036 id = 695 }
    name     = "Yap Hendan"
    location = 1619
    division =
    { id       = { type = 30036 id = 696 }
      name     = "Yap Hendan"
      strength = 100
      type     = garrison
    }
  }
  # Combined Fleet
  navalunit =
  { id       = { type = 10300 id = 1000 }
    name     = "Combined Fleet 1 Squadron"
    location = 1188
    base     = 1188
    division =
    { id    = { type = 10300 id = 18 }
      name  = "IJN Nagato"
      type  = battleship
      model = 2
    }
    division =
    { id    = { type = 10300 id = 20 }
      name  = "IJN Mutsu"
      type  = battleship
      model = 2
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1002 }
    name     = "Combined Fleet 9 Squadron"
    location = 1188
    base     = 1188
    division =
    { id    = { type = 10300 id = 52 }
      name  = "IJN Kitakami"
      type  = light_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 53 }
      name  = "IJN Oi"
      type  = light_cruiser
      model = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1003 }
    name     = "1. Fleet 2. Squadron"
    location = 1188
    base     = 1188
    division =
    { id    = { type = 10300 id = 10 }
      name  = "IJN Fuso"
      type  = battleship
      model = 1
    }
    division =
    { id    = { type = 10300 id = 12 }
      name  = "IJN Yamashiro"
      type  = battleship
      model = 1
    }
    division =
    { id    = { type = 10300 id = 14 }
      name  = "IJN Ise"
      type  = battleship
      model = 1
    }
    division =
    { id    = { type = 10300 id = 16 }
      name  = "IJN Hyuga"
      type  = battleship
      model = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1004 }
    name     = "1. Fleet 3. Squadron"
    location = 1188
    base     = 1188
    division =
    { id    = { type = 10300 id = 2 }
      name  = "IJN Kongo"
      type  = battlecruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 4 }
      name  = "IJN Hiei"
      type  = battlecruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 6 }
      name  = "IJN Haruna"
      type  = battlecruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 8 }
      name  = "IJN Kirishima"
      type  = battlecruiser
      model = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1005 }
    name     = "1. Fleet 6. Squadron"
    location = 1188
    base     = 1188
    division =
    { id    = { type = 10300 id = 22 }
      name  = "IJN Furutaka"
      type  = heavy_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 23 }
      name  = "IJN Kako"
      type  = heavy_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 24 }
      name  = "IJN Aoba"
      type  = heavy_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 25 }
      name  = "IJN Kinugasa"
      type  = heavy_cruiser
      model = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1006 }
    name     = "1. Fleet 3. Carrier Squadron"
    location = 1188
    base     = 1188
    division =
    { id            = { type = 10300 id = 1007 }
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
    { id    = { type = 10300 id = 64 }
      name  = "IJN Sendai"
      type  = light_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 1001 }
      name  = "IJN Yubari"
      type  = light_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 999 }
      name  = "IJN Hirado"
      type  = light_cruiser
      model = 0
    }
    division =
    { id    = { type = 10300 id = 998 }
      name  = "IJN Yahagi"
      type  = light_cruiser
      model = 0
    }
    division =
    { id    = { type = 10300 id = 997 }
      name  = "IJN Izumo"
      type  = heavy_cruiser
      model = 0
    }
    division =
    { id    = { type = 10300 id = 149 }
      name  = "40 Kuchikukantai"
      type  = destroyer
      model = 2
    }
    division =
    { id    = { type = 10300 id = 150 }
      name  = "41 Kuchikukantai"
      type  = destroyer
      model = 1
    }
    division =
    { id    = { type = 10300 id = 151 }
      name  = "42 Kuchikukantai"
      type  = destroyer
      model = 2
    }
    division =
    { id    = { type = 10300 id = 152 }
      name  = "43 Kuchikukantai"
      type  = destroyer
      model = 2
    }
    division =
    { id    = { type = 10300 id = 154 }
      name  = "45 Kuchikukantai"
      type  = destroyer
      model = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1010 }
    name     = "2. Fleet 4. Squadron"
    location = 1321
    base     = 1321
    division =
    { id    = { type = 10300 id = 34 }
      name  = "IJN Takao"
      type  = heavy_cruiser
      model = 2
    }
    division =
    { id    = { type = 10300 id = 35 }
      name  = "IJN Atago"
      type  = heavy_cruiser
      model = 2
    }
    division =
    { id    = { type = 10300 id = 36 }
      name  = "IJN Maya"
      type  = heavy_cruiser
      model = 2
    }
    division =
    { id    = { type = 10300 id = 37 }
      name  = "IJN Chokai"
      type  = heavy_cruiser
      model = 2
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1011 }
    name     = "2. Fleet 5. Squadron"
    location = 1321
    base     = 1321
    division =
    { id    = { type = 10300 id = 27 }
      name  = "IJN Myoko"
      type  = heavy_cruiser
      model = 2
    }
    division =
    { id    = { type = 10300 id = 28 }
      name  = "IJN Nachi"
      type  = heavy_cruiser
      model = 2
    }
    division =
    { id    = { type = 10300 id = 29 }
      name  = "IJN Haguro"
      type  = heavy_cruiser
      model = 2
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1041 }
    name     = "2. Fleet 7. Squadron"
    location = 1321
    base     = 1321
    division =
    { id    = { type = 10300 id = 39 }
      name  = "IJN Mogami"
      type  = light_cruiser
      model = 3
    }
    division =
    { id    = { type = 10300 id = 40 }
      name  = "IJN Mikuma"
      type  = light_cruiser
      model = 3
    }
    division =
    { id    = { type = 10300 id = 41 }
      name  = "IJN Suzuya"
      type  = light_cruiser
      model = 3
    }
    division =
    { id    = { type = 10300 id = 42 }
      name  = "IJN Kumano"
      type  = light_cruiser
      model = 3
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1012 }
    name     = "2. Fleet 8. Squadron"
    location = 1321
    base     = 1321
    division =
    { id    = { type = 10300 id = 44 }
      name  = "IJN Tone"
      type  = heavy_cruiser
      model = 2
    }
    division =
    { id    = { type = 10300 id = 45 }
      name  = "IJN Chikuma"
      type  = heavy_cruiser
      model = 2
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1055 }
    name     = "2. Fleet 2&4. DD Squadron"
    location = 1321
    base     = 1321
    division =
    { id    = { type = 10300 id = 65 }
      name  = "IJN Jintsu"
      type  = light_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 89 }
      name  = "1 Kuchikukantai"
      type  = destroyer
      model = 0
    }
    division =
    { id    = { type = 10300 id = 90 }
      name  = "2 Kuchikukantai"
      type  = destroyer
      model = 1
    }
    division =
    { id    = { type = 10300 id = 91 }
      name  = "3 Kuchikukantai"
      type  = destroyer
      model = 0
    }
    division =
    { id    = { type = 10300 id = 92 }
      name  = "4 Kuchikukantai"
      type  = destroyer
      model = 0
    }
    division =
    { id    = { type = 10300 id = 93 }
      name  = "5 Kuchikukantai"
      type  = destroyer
      model = 1
    }
    division =
    { id    = { type = 10300 id = 94 }
      name  = "6 Kuchikukantai"
      type  = destroyer
      model = 0
    }
    division =
    { id    = { type = 10300 id = 63 }
      name  = "IJN Naka"
      type  = light_cruiser
      model = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1013 }
    name     = "3. Fleet 16. Squadron"
    location = 1322
    base     = 1322
    division =
    { id    = { type = 10300 id = 30 }
      name  = "IJN Ashigara"
      type  = heavy_cruiser
      model = 2
    }
    division =
    { id    = { type = 10300 id = 50 }
      name  = "IJN Kuma"
      type  = light_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 56 }
      name  = "IJN Nagara"
      type  = light_cruiser
      model = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1014 }
    name     = "3. Fleet 5. DD Squadron"
    location = 1322
    base     = 1322
    division =
    { id       = { type = 10300 id = 59 }
      name     = "IJN Natori"
      type     = light_cruiser
      model    = 1
      maxspeed = 36
    }
    division =
    { id    = { type = 10300 id = 96 }
      name  = "7 Kuchikukantai"
      type  = destroyer
      model = 1
    }
    division =
    { id    = { type = 10300 id = 97 }
      name  = "8 Kuchikukantai"
      type  = destroyer
      model = 0
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1015 }
    name     = "4. Fleet 18 Squadron"
    location = 1613
    base     = 1613
    division =
    { id    = { type = 10300 id = 47 }
      name  = "IJN Tenryu"
      type  = light_cruiser
      model = 0
    }
    division =
    { id    = { type = 10300 id = 48 }
      name  = "IJN Tatsuta"
      type  = light_cruiser
      model = 0
    }
    division =
    { id    = { type = 10300 id = 98 }
      name  = "9 Kuchikukantai"
      type  = destroyer
      model = 0
    }
    division =
    { id    = { type = 10300 id = 99 }
      name  = "10 Kuchikukantai"
      type  = destroyer
      model = 0
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1016 }
    name     = "5. Fleet 21 Squadron"
    location = 1237
    base     = 1237
    division =
    { id    = { type = 10300 id = 51 }
      name  = "IJN Tama"
      type  = light_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 54 }
      name  = "IJN Kiso"
      type  = light_cruiser
      model = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1017 }
    name     = "6. Fleet"
    location = 1608
    base     = 1608
    division =
    { id    = { type = 10300 id = 292 }
      name  = "1 Sensuikantai"
      type  = submarine
      model = 0
    }
    division =
    { id    = { type = 10300 id = 293 }
      name  = "2 Sensuikantai"
      type  = submarine
      model = 0
    }
    division =
    { id    = { type = 10300 id = 294 }
      name  = "3 Sensuikantai"
      type  = submarine
      model = 2
    }
    division =
    { id    = { type = 10300 id = 298 }
      name  = "8 Sensuikantai"
      type  = submarine
      model = 2
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1018 }
    name     = "1. Carrier Fleet"
    location = 1184
    base     = 1184
    division =
    { id            = { type = 10300 id = 401 }
      name          = "IJN Kaga"
      type          = carrier
      model         = 1
      extra         = cag
      brigade_model = 3
      experience    = 20
    }
    division =
    { id            = { type = 10300 id = 402 }
      name          = "IJN Agaki"
      type          = carrier
      model         = 1
      extra         = cag
      brigade_model = 3
      experience    = 20
    }
    division =
    { id    = { type = 10300 id = 403 }
      name  = "IJN Ryujo"
      type  = carrier
      model = 2
	extra = cag
	brigade_model = 3
	experience = 20
    }
    division =
    { id            = { type = 10300 id = 404 }
      name          = "IJN Soryu"
      type          = carrier
      model         = 2
      extra         = cag
      brigade_model = 3
      experience    = 20
    }
    division =
    { id            = { type = 10300 id = 405 }
      name          = "IJN Hiryu"
      type          = carrier
      model         = 2
      extra         = cag
      brigade_model = 3
      experience    = 20
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1019 }
    name     = "IJN Reserve Fleet"
    location = 1190
    base     = 1190
    division =
    { id    = { type = 10300 id = 57 }
      name  = "IJN Isuzu"
      type  = light_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 58 }
      name  = "IJN Yura"
      type  = light_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 60 }
      name  = "IJN Kinu"
      type  = light_cruiser
      model = 1
    }
    division =
    { id    = { type = 10300 id = 61 }
      name  = "IJN Abukuma"
      type  = light_cruiser
      model = 1
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1020 }
    name     = "China Fleet"
    location = 1237
    base     = 1237
    division =
    { id    = { type = 10300 id = 103 }
      name  = "13 Kuchikukantai"
      type  = destroyer
      model = 0
    }
    division =
    { id    = { type = 10300 id = 104 }
      name  = "14 Kuchikukantai"
      type  = destroyer
      model = 1
    }
    division =
    { id    = { type = 10300 id = 105 }
      name  = "15 Kuchikukantai"
      type  = destroyer
      model = 1
    }
    division =
    { id    = { type = 10300 id = 106 }
      name  = "16 Kuchikukantai"
      type  = destroyer
      model = 1
    }
    division =
    { id    = { type = 10300 id = 107 }
      name  = "17 Kuchikukantai"
      type  = destroyer
      model = 0
    }
    division =
    { id    = { type = 10300 id = 108 }
      name  = "18 Kuchikukantai"
      type  = destroyer
      model = 1
    }
    division =
    { id   = { type = 10300 id = 355 }
      name = "1 Yuso Sentai"
      type = transport
    }
    division =
    { id   = { type = 10300 id = 356 }
      name = "2 Yuso Sentai"
      type = transport
    }
    division =
    { id    = { type = 10300 id = 100 }
      name  = "11 Kuchikukantai"
      type  = destroyer
      model = 0
    }
    division =
    { id    = { type = 10300 id = 101 }
      name  = "12 Kuchikukantai"
      type  = destroyer
      model = 1
    }
    division =
    { id   = { type = 10300 id = 353 }
      name = "3 Yuso Sentai"
      type = transport
    }
    division =
    { id   = { type = 10300 id = 354 }
      name = "4 Yuso Sentai"
      type = transport
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1021 }
    name     = "Korea Fleet"
    location = 1196
    base     = 1196
    division =
    { id   = { type = 10300 id = 357 }
      name = "5 Yuso Sentai"
      type = transport
    }
    division =
    { id   = { type = 10300 id = 358 }
      name = "6 Yuso Sentai"
      type = transport
    }
    division =
    { id   = { type = 10300 id = 359 }
      name = "7 Yuso Sentai"
      type = transport
    }
    division =
    { id   = { type = 10300 id = 360 }
      name = "8 Yuso Sentai"
      type = transport
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1022 }
    name     = "Southern Fleet"
    location = 1237
    base     = 1237
    division =
    { id   = { type = 10300 id = 361 }
      name = "9 Yuso Sentai"
      type = transport
    }
    division =
    { id   = { type = 10300 id = 362 }
      name = "10 Yuso Sentai"
      type = transport
    }
    division =
    { id   = { type = 10300 id = 363 }
      name = "11 Yuso Sentai"
      type = transport
    }
    division =
    { id   = { type = 10300 id = 364 }
      name = "12 Yuso Sentai"
      type = transport
    }
  }
  navalunit =
  { id       = { type = 10300 id = 1065 }
    name     = "Reserve Fleet"
    location = 1186
    base     = 1186
    division =
    { id   = { type = 10300 id = 365 }
      name = "13 Yuso Sentai"
      type = transport
    }
    division =
    { id   = { type = 10300 id = 366 }
      name = "14 Yuso Sentai"
      type = transport
    }
    division =
    { id    = { type = 10300 id = 285 }
      name  = "9 Sensuikantai"
      type  = submarine
      model = 3
    }
    division =
    { id    = { type = 10300 id = 286 }
      name  = "13 Sensuikantai"
      type  = submarine
      model = 3
    }
    division =
    { id    = { type = 10300 id = 289 }
      name  = "27 Sensuikantai"
      type  = submarine
      model = 2
    }
    division =
    { id    = { type = 10300 id = 300 }
      name  = "11 Sensuikantai"
      type  = submarine
      model = 2
    }
    division =
    { id    = { type = 10300 id = 301 }
      name  = "12 Sensuikantai"
      type  = submarine
      model = 2
    }
  }
  navalunit =
  { id       = { type = 30036 id = 900 }
    name     = "8. Kaigun"
    location = 1190
    base     = 1190
    division =
    { experience = 20
      id         = { type = 30036 id = 601 }
      name       = "1 Sensuikantai"
      type       = submarine
      model      = 0
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 602 }
      name       = "2 Sensuikantai"
      type       = submarine
      model      = 0
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 603 }
      name       = "3 Sensuikantai"
      type       = submarine
      model      = 0
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 604 }
      name       = "4 Sensuikantai"
      type       = submarine
      model      = 0
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 605 }
      name       = "5 Sensuikantai"
      type       = submarine
      model      = 0
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 606 }
      name       = "6 Sensuikantai"
      type       = submarine
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 607 }
      name       = "7 Sensuikantai"
      type       = submarine
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 608 }
      name       = "8 Sensuikantai"
      type       = submarine
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 609 }
      name       = "9 Sensuikantai"
      type       = submarine
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 610 }
      name       = "10 Sensuikantai"
      type       = submarine
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 611 }
      name       = "11 Sensuikantai"
      type       = submarine
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 612 }
      name       = "12 Sensuikantai"
      type       = submarine
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 613 }
      name       = "13 Sensuikantai"
      type       = submarine
      model      = 2
    }
  }
  # ###################
  # ##############################
  airunit =
  { id       = { type = 30036 id = 213 }
    name     = "1 Zerosen no Hikodan"
    location = 1202
    base     = 1202
    division =
    { experience = 20
      id         = { type = 30036 id = 214 }
      name       = "1 Zerosen no Hikodan"
      strength   = 30
      type       = interceptor
      model      = 0
    }
  }
  airunit =
  { id       = { type = 30036 id = 215 }
    name     = "1. Hikoutai"
    location = 1202
    base     = 1202
    division =
    { experience = 20
      id         = { type = 30036 id = 216 }
      name       = "2 Zerosen no Hikodan"
      strength   = 30
      type       = interceptor
      model      = 0
    }
  }
  airunit =
  { id       = { type = 30036 id = 217 }
    name     = "2. Hikoutai"
    location = 1202
    base     = 1202
    division =
    { experience = 20
      id         = { type = 30036 id = 218 }
      name       = "2 Keibakugekiki no Hikodan"
      strength   = 100
      type       = tactical_bomber
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 219 }
      name       = "8 Zerosen no Hikodan"
      strength   = 100
      type       = interceptor
      model      = 2
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 220 }
      name       = "9 Keibakugekiki no Hikodan"
      strength   = 100
      type       = tactical_bomber
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 221 }
      name       = "13 Zerosen no Hikodan"
      strength   = 100
      type       = interceptor
      model      = 2
    }
  }
  airunit =
  { id       = { type = 30036 id = 222 }
    name     = "3. Hikoutai"
    location = 1322
    base     = 1322
    division =
    { experience = 20
      id         = { type = 30036 id = 223 }
      name       = "3 Keibakugekiki no Hikodan"
      strength   = 100
      type       = tactical_bomber
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 224 }
      name       = "7 Keibakugekiki no Hikodan"
      strength   = 100
      type       = tactical_bomber
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 225 }
      name       = "10 Keibakugekiki no Hikodan"
      strength   = 100
      type       = tactical_bomber
      model      = 1
    }
    division =
    { experience = 20
      id         = { type = 30036 id = 226 }
      name       = "12 Zerosen no Hikodan"
      strength   = 100
      type       = interceptor
      model      = 2
    }
  }
  # ################################################################
  division_development =
  { name  = "33 Sensuikantai"
    type  = submarine
    model = 3
    cost  = 2.3
    id    = { type = 10300 id = 503 }
    date  = { year = 1939 month = december day = 1 }
  }
}
