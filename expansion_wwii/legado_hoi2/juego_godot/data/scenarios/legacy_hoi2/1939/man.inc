
##############################
# Country definition for MAN #
##############################

province =
{ id       = 1379
  anti_air = 2
  air_base = { size = 2 current_size = 2 }
}            # Harbin
province =
{ id       = 1397
  anti_air = 2
  air_base = { size = 2 current_size = 2 }
}            # Changde

#####################
# Country main data #
#####################

country =
{ tag                    = MAN
  puppet                 = JAP
  control                = JAP
  # Resource Reserves
  energy                 = 200
  metal                  = 200
  rare_materials         = 100
  oil                    = 200
  supplies               = 500
  money                  = 10
  manpower               = 100
  capital                = 1390
  policy =
  { date              = { year = 0 month = january day = 0 }
    democratic        = 1
    political_left    = 4
    freedom           = 3
    free_market       = 3
    professional_army = 3
    defense_lobby     = 8
    interventionism   = 8
  }
  diplomacy =
  { relation = { tag = GER value = 20 }
    relation = { tag = CHI value = -200 }
    relation = { tag = CSX value = -200 }
    relation = { tag = CXB value = -200 }
    relation = { tag = CYN value = -200 }
    relation = { tag = CGX value = -200 }
    relation = { tag = JAP value = 200 access = yes }
    relation = { tag = MEN value = 200 access = yes }
    relation = { tag = SIA value = 75 }
    relation = { tag = SIK value = -175 }
  }
  nationalprovinces      = { 1393 1389 1390 1377 1378 1375 1374 1379 1530 1380 1387 1382 1381 1394 1395 1396 1397 1388 }
  ownedprovinces         = { 1389 1390 1377 1378 1375 1374 1379 1530 1380 1387 1382 1381 1394 1395 1396 1397 1388 }
  controlledprovinces    = { 1389 1390 1377 1378 1375 1374 1379 1530 1380 1387 1382 1381 1394 1395 1396 1397 1388 }
  # Group E 1939 techs
  # ######################
  techapps               = { 1200 4010 2150 2290 1010 1190 5010 5080 5090 5190 6210 6300 }
  free                   = { energy = 14 metal = 7 rare_materials = 4 }
  headofstate            = { type = 9 id = 58001 }
  headofgovernment       = { type = 9 id = 58015 }
  foreignminister        = { type = 9 id = 58022 }
  armamentminister       = { type = 9 id = 58029 }
  ministerofsecurity     = { type = 9 id = 58036 }
  ministerofintelligence = { type = 9 id = 58043 }
  chiefofstaff           = { type = 9 id = 58050 }
  chiefofarmy            = { type = 9 id = 58056 }
  chiefofnavy            = { type = 9 id = 58062 }
  chiefofair             = { type = 9 id = 58069 }
  # Human Wave
  landunit =
  { location = 1389
    id       = { type = 28500 id = 1 }
    name     = "1 Fang'tien Jüntuan"
    division =
    { id       = { type = 28500 id = 2 }
      name     = "7 Man'chu Lü"
      type     = militia
      strength = 90
    }
  }
  landunit =
  { location = 1389
    id       = { type = 28500 id = 8 }
    name     = "2 Ji'lin Jüntuan"
    division =
    { id       = { type = 28500 id = 9 }
      name     = "8 Man'chu Lü"
      type     = militia
      strength = 60
    }
    division =
    { id       = { type = 28500 id = 13 }
      name     = "2 Man'chu Qi'Bing"
      type     = cavalry
      model    = 1
      extra    = artillery
      strength = 45
    }
  }
  landunit =
  { location = 1382
    id       = { type = 28500 id = 16 }
    name     = "3 Qiqihar Jüntuan"
    division =
    { id       = { type = 28500 id = 17 }
      name     = "9 Man'chu Lü"
      type     = militia
      strength = 75
    }
  }
  landunit =
  { location = 1379
    id       = { type = 28500 id = 23 }
    name     = "4 Harbin Jüntuan"
    division =
    { id       = { type = 28500 id = 24 }
      name     = "10 Man'chu Lü"
      type     = militia
      strength = 15
    }
  }
  landunit =
  { location = 1374
    id       = { type = 28500 id = 33 }
    name     = "5 Chengde Jüntuan"
    division =
    { id       = { type = 28500 id = 34 }
      name     = "12 Man'chu Lü"
      type     = militia
      strength = 45
    }
  }
}
