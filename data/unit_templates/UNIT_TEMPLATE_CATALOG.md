# Unit Template Catalog

**667 templates** in `data/unit_templates/`. Loaded via `DesignDataLoader` at startup.

Regenerate:
```bash
python3 tools/generate_unit_templates.py              # core WWII (skips existing)
python3 tools/generate_late_ww2_unit_templates.py     # 1945–1955 & paper designs
python3 tools/generate_carrier_unit_templates.py    # carriers & ASW fits
python3 tools/generate_sixties_seventies_unit_templates.py  # 1960s–1970s MBTs & jets
python3 tools/generate_eighties_nineties_unit_templates.py  # 1980s–1990s
python3 tools/generate_2000s_2010s_unit_templates.py  # 2000s–2010s
python3 tools/generate_2020s_2030s_unit_templates.py  # 2020s–2030s
python3 tools/generate_space_unit_templates.py      # space rockets, satellites, stations
python3 tools/generate_carrier_aircraft_templates.py  # carrier naval aviation
python3 tools/generate_2026_naval_aviation.py         # 2026 carriers & naval air wings
python3 tools/generate_naval_helicopter_aviation.py   # naval helos & LHD/LPH 1940s–2030s
python3 tools/generate_early_helicopter_prototypes.py # pre-1940 helicopters
python3 tools/generate_submarine_aviation.py        # submarines 1910s–2030s
python3 tools/generate_surface_naval_fleet.py     # carriers, battleships, cruisers, destroyers
python3 tools/generate_naval_prototypes_designs.py # paper & cancelled ship designs
python3 tools/generate_2026_naval_fleet.py       # 2026 scenario fleet (all nations)
python3 tools/generate_1918_naval_fleet.py     # 1918 scenario fleet (all nations)
python3 tools/generate_1936_naval_fleet.py     # 1936 scenario fleet (all nations)
```

---

## WWII · Tanks & AFVs

| ID | Name | Nation | Key loadout |
|----|------|--------|-------------|
| `m3_stuart_light` | M3 Stuart | USA | 75mm M3, Continental R975 |
| `m4_sherman_medium` | M4 Sherman (105) | USA | 105mm howitzer, Sherman armor |
| `m4a3e8_sherman_medium` | M4A3E8 (76 mm) | USA | 76mm M1, Ford GAA, applique |
| `m26_pershing_heavy` | M26 Pershing | USA | 90mm M3, Ford GAA |
| `tiger_i_heavy` | Tiger I | Germany | KwK 36, Krupp armor, Maybach |
| `panzer_iii_j_medium` | Panzer III J | Germany | KwK 38, HL 120 |
| `panzer_iv_h_medium` | Panzer IV H | Germany | KwK 40, Schürzen |
| `panther_g_medium` | Panther G | Germany | KwK 42, Schürzen |
| `t34_76_medium` | T-34/76 | USSR | F-34, V-2, sloped armor |
| `t34_85_medium` | T-34/85 | USSR | 85mm D-5T, V-2 |
| `is2_heavy` | IS-2 | USSR | 122mm D-25T, IS-2 armor |
| `churchill_mk7_heavy` | Churchill Mk VII | UK | 75mm ROQF, cast armor |
| `cromwell_mk4_medium` | Cromwell Mk IV | UK | 6-pdr, Meteor |
| `chi_nu_medium` | Type 3 Chi-Nu | Japan | Type 3 75mm |
| `p40_heavy_tank` | P40 | Italy | 75mm Ansaldo |
| `somua_s35_medium` | SOMUA S35 | France | 47mm SA 37 |

---

## WWII · Aircraft

| ID | Name | Nation | Key loadout |
|----|------|--------|-------------|
| `bf109g_fighter` | Bf 109G-6 | Germany | MG 151, DB 605 |
| `fw190a_fighter` | Fw 190A-8 | Germany | MG 151, BMW 801 |
| `ju87b_stuka` | Ju 87B | Germany | SC 250, Jumo 211 |
| `spitfire_mk9_fighter` | Spitfire Mk IX | UK | Hispano, Merlin |
| `lancaster_bomber` | Lancaster | UK | 4000 lb cookie, Merlin |
| `p47d_thunderbolt` | P-47D | USA | M2, R-2800 |
| `p51d_mustang` | P-51D | USA | Packard Merlin |
| `b17g_fortress` | B-17G | USA | Norden, Browning M2s |
| `a6m_zero_fighter` | A6M5 Zero | Japan | Type 99 20mm, Sakae |
| `il2_sturmovik` | Il-2M | USSR | ShVAK, ASh-82 |

---

## WWII · Naval

| ID | Name | Nation | Key loadout |
|----|------|--------|-------------|
| `fletcher_class_destroyer` | Fletcher DD | USA | 5"/38, Mk 15 torpedo |
| `us_northampton_cruiser` | Northampton CA | USA | 8"/55, torpedoes |
| `queen_elizabeth_battleship` | Queen Elizabeth BB | UK | 15" Mk I |
| `bismarck_battleship` | Bismarck | Germany | 15" SK C/34, G7a |
| `yamato_battleship` | Yamato | Japan | 18" Type 94, Long Lance |

Naval slots use `NavalGun` for main batteries; torpedoes in `SecondaryWeapon`.

---

## WWI · 1914–1918

| ID | Name | Type |
|----|------|------|
| `renault_ft_light` | Renault FT | Light tank |
| `mark_iv_heavy` | Mark IV | Heavy tank |
| `a7v_heavy` | A7V | Heavy tank |
| `spad_xiii_fighter` | SPAD S.XIII | Fighter |
| `fokker_dvii_fighter` | Fokker D.VII | Fighter |
| `m1897_field_gun_battery` | 75 mm M1897 battery | Towed artillery |

---

## Interwar · 1920s–1939

| ID | Name | Nation |
|----|------|--------|
| `lt_vz_35_light` | LT vz. 35 | Czechoslovakia |
| `t26_light` | T-26 | USSR |
| `bt7_fast_tank` | BT-7 | USSR |
| `cv33_tankette` | L3/33 | Italy |
| `polish_7tp_light` | 7TP | Poland |
| `romanian_r2_light` | R-2 | Romania |
| `qf_25pdr_artillery` | QF 25-pdr battery | UK |

---

## Late WWII · 1945 & Axis paper designs (defeated nations)

| ID | Name | Nation | Notes |
|----|------|--------|-------|
| `maus_superheavy` | Panzer VIII Maus | Germany | Prototype only |
| `e50_medium_prototype` | E-50 (Paper) | Germany | Entwicklung series |
| `jagdtiger_heavy_td` | Jagdtiger | Germany | Built in small numbers |
| `sturmtiger_assault` | Sturmtiger | Germany | Urban assault |
| `me262a_fighter` | Me 262A | Germany | Operational jet |
| `he162_salamander` | He 162 | Germany | Volksjäger |
| `ho229_prototype` | Ho 229 | Germany | Flying wing |
| `ta183_prototype` | Ta 183 (Paper) | Germany | Never built |
| `type4_chi_to_medium` | Type 4 Chi-To | Japan | Late war |
| `type5_chi_ri_prototype` | Type 5 Chi-Ri | Japan | Prototype |
| `kikka_jet_prototype` | Kikka | Japan | Jet prototype |
| `p43_heavy_prototype` | P43 (Paper) | Italy | Cancelled 1943 |

## Cold War · 1948–1955

| ID | Name | Nation |
|----|------|--------|
| `is3_heavy` | IS-3 | USSR |
| `su100_td` | SU-100 | USSR |
| `t54_medium` | T-54 | USSR |
| `m103_heavy` | M103 | USA |
| `m48_patton_medium` | M48 Patton | USA |
| `centurion_mk3_medium` | Centurion Mk 3 | UK |
| `amx13_light` | AMX-13 | France |
| `mig15_fighter` | MiG-15bis | USSR |
| `f86_sabre` | F-86F Sabre | USA |
| `f100_super_sabre` | F-100D | USA |
| `hawker_hunter_fighter` | Hawker Hunter F.6 | UK |
| `forrest_sherman_destroyer` | Forrest Sherman DD | USA |

## Carriers & ASW (ships)

| ID | Name | Nation | Key loadout |
|----|------|--------|-------------|
| `essex_class_carrier` | Essex-class | USA | SK radar, Bofors, wooden deck |
| `yorktown_class_carrier` | Yorktown-class | USA | SG radar, Oerlikon belt |
| `illustrious_class_carrier` | Illustrious | UK | Armored flight deck |
| `akagi_carrier` | Akagi | Japan | Type 22 radar |
| `graf_zeppelin_carrier` | Graf Zeppelin | Germany | Flakvierling, unfinished |
| `casablanca_escort_carrier` | Casablanca CVE | USA | FIDO, sonar, ASW hangar |
| `fletcher_asw_destroyer` | Fletcher (ASW) | USA | Hedgehog, GDCS sonar |
| `avenger_asw_aircraft` | TBF Avenger (ASW) | USA | FIDO + Mk 9 depth charges |
| `p47d_ground_attack` | P-47D (GA) | USA | HVAR, R-2800 |

---

## Carrier aircraft · naval aviation

`base_type: Air` — fighters, dive/torpedo bombers, AEW, EW, and ASW aircraft configured for carrier ops (`carrier_operations_kit` or national equivalent).

### WWII
| ID | Name | Nation | Role |
|----|------|--------|------|
| `f4f_wildcat` / `f6f_hellcat` / `f4u_corsair_carrier` / `f8f_bearcat` | Wildcat / Hellcat / Corsair / Bearcat | USA | Fighters |
| `sbd_dauntless` / `sb2c_helldiver` / `tbf_avenger_strike` / `tbd_devastator` | SBD / SB2C / TBF / TBD | USA | Strike |
| `seafire_mk3` / `firefly_strike` / `fulmar_mk2` | Seafire / Firefly / Fulmar | UK | Fighter / strike |
| `swordfish_torpedo` / `barracuda_mk2` / `albacore_torpedo` | Swordfish / Barracuda / Albacore | UK | Torpedo / strike |
| `a6m5_zero_carrier` / `d3a_val` / `b5n_kate` / `d4y_judy` | Zero / Val / Kate / Judy | Japan | Fighter / strike |
| `a7m_reppu_proto` | A7M Reppū (Proto) | Japan | Planned fighter |
| `bf109t_carrier` / `fi167_carrier` / `me155_carrier_proto` | Bf 109T / Fi 167 / Me 155B | Germany | Graf Zeppelin air group (unfinished) |
| `b6n_jill` | B6N Jill | Japan | Late-war torpedo bomber |
| `f2a_buffalo_carrier` | F2A Buffalo | USA | Early-war carrier fighter |
| `sea_hurricane_mk1` | Sea Hurricane | UK | Catapult / MAC ship fighter |

### Cold War – 2010s
| ID | Name | Nation | Role |
|----|------|--------|------|
| `f9f_panther` / `f8e_crusader` / `a4_skyhawk` / `a6_intruder` / `a7_corsair_ii` | Panther / Crusader / Skyhawk / Intruder / A-7 | USA | Carrier jet wing |
| `f4j_phantom_naval` / `f14a_tomcat` / `fa18c_hornet` / `fa18ef_super_hornet` | F-4J / F-14 / Hornet / Super Hornet | USA | Fighter / strike |
| `e2c_hawkeye` / `ea6b_prowler` / `s3b_viking` / `av8b_harrier_ii` | E-2 / EA-6B / S-3 / AV-8B | USA | AEW / EW / ASW / STOVL |
| `phantom_fg1` / `scimitar_f1` / `buccaneer_s2` / `sea_harrier_frs1` | Phantom FG.1 / Scimitar / Buccaneer / Sea Harrier | UK | RN carrier air |
| `etendard_ivm` / `super_etendard` / `rafale_m` | Étendard / Super Étendard / Rafale M | France | CDG air wing |
| `yak38_forger` / `su33_flanker_d` / `mig29k` | Yak-38 / Su-33 / MiG-29K | USSR/Russia | Carrier fighters |
| `yak141_freestyle_proto` | Yak-141 (Proto) | Russia | STOVL prototype |
| `j15_flying_shark` / `j35_carrier_fighter` | J-15 / J-35 | China | Liaoning / Fujian wing |
| `harrier_gr1` | Harrier GR.1 | UK | Early STOVL (also land bases) |

### 2020s–2030s (planned)
| ID | Name | Nation | Role |
|----|------|--------|------|
| `f35c_lightning` / `f35b_lightning` | F-35C / F-35B | USA / UK | CATOBAR / STOVL carriers |
| `x47b_ucav_carrier` | X-47B | USA | Carrier UCAV demonstrator |
| `ngad_carrier_fighter_2030` | NGAD (Proto) | USA | Sixth-gen carrier fighter (planned) |

---

## Naval aviation · 2026 scenario

Unlock tag `naval_2026` — modern carriers, STOVL wings, and helicopter ASW for scenario nations.

### Fixed-wing carriers
| Nation | Carrier | Aircraft |
|--------|---------|----------|
| USA | `nimitz_class_carrier_2026`, `ford_class_carrier_2026` | `fa18ef_super_hornet`, `f35c_lightning`, `e2c_hawkeye` |
| UK | `queen_elizabeth_cv` | `f35b_lightning` |
| France | `charles_de_gaulle_carrier` | `rafale_m` |
| Italy | `cavour_class_carrier` | `f35b_cavour` |
| Spain | `juan_carlos_lhd` | `av8b_matador`, `f35b_spain_planned` |
| Japan | `izumo_class_carrier` | `f35b_jsdf_carrier` |
| India | `ins_vikrant_carrier`, `ins_vikramaditya_carrier` | `mig29k_indian_navy`, `tejas_n_planned` |
| China | `liaoning_carrier`, `shandong_carrier`, `fujian_carrier` | `j15_flying_shark`, `j35_carrier_fighter` |
| Russia | `admiral_kuznetsov_carrier` | `su33_flanker_d`, `mig29k` |
| Turkey | `tcg_anadolu` | Bayraktar UCAV (no fixed-wing) |

### Helicopter / LHD operators
| Nation | Platform | Aviation |
|--------|----------|----------|
| Australia | `canberra_lhd` | `mh60r_seahawk_aus` |
| Brazil | `nae_atlantica` | ASW helos |
| Egypt | `mistral_egypt` | NH90 |
| Korea | `dokdo_lph` | `aw159_korea` |
| Thailand | `chakri_naruebet_carrier` | `aw159_thailand` |
| Canada / Norway / Germany / Netherlands | Frigate wings | `ch148_cyclone_canada`, `nh90_*` |
| Israel / Saudi / Singapore | Naval helos | `mh60r_israel`, `sea_king_saudi`, `mh60r_singapore` |

---

## Naval helicopters & amphibious ships · 1940s–2030s

### Helicopters by era
| Era | Examples |
|-----|----------|
| 1940s–50s | `ho3s_dragonfly`, `hss1_seabat`, `h34_choctaw_naval` |
| 1960s–70s | `sh3_sea_king`, `sh2_seasprite`, `ch46_sea_knight`, `westland_wasp`, `ka25_hormone` |
| 1980s–90s | `sh60b_seahawk`, `lynx_has3`, `super_frelon`, `ab212_asw` |
| 2000s–2010s | `mh60r_seahawk`, `mh60s_knighthawk`, `aw101_merlin`, `ka27_helix`, `z9c_asw`, `mv22_osprey`, `ch53k_king_stallion` |
| 2030s planned | `flraa_maritime_2030`, `autonomous_naval_helo_2030`, `aw249_naval_2030` |

### Historical amphibious / helo carriers
| ID | Name | Nation |
|----|------|--------|
| `iwo_jima_lph` | Iwo Jima-class LPH | USA |
| `tarawa_lha` | Tarawa-class LHA | USA |
| `wasp_class_lhd` | Wasp-class LHD | USA |
| `america_class_lha` | America-class LHA | USA |
| `invincible_class` | Invincible-class | UK |
| `hms_ocean_lph` | HMS Ocean | UK |
| `jeanne_darc` | Jeanne d'Arc | France |
| `moskva_helo_cruiser` | Moskva-class | USSR |
| `kiev_class_carrier` | Kiev-class | USSR |
| `garibaldi_carrier` | Giuseppe Garibaldi | Italy |
| `hyuga_class_ddh` | Hyūga-class DDH | Japan |
| `mistral_class_france` | Mistral-class | France |
| `albion_class_lpd` / `rotterdam_lpd` / `san_giorgio_lpd` | LPD types | UK / Netherlands / Italy |

### 2026 amphibious & helicopter expansion
Additional `naval_2026` entries: `wasp_class_lhd_2026`, `america_class_lha_2026`, `mistral_france_2026`, `albion_class_2026`, `rotterdam_lpd_2026`, `hyuga_class_2026`, plus national helo wings for Australia (`mrh90_australia`), UK (`merlin_hm2_uk_2026`), France, Nordics, Southeast Asia, Latin America, and Africa.

---

## Pre-1940 rotary-wing prototypes

| ID | Name | Nation | Notes |
|----|------|--------|-------|
| `de_bothezat_flying_octopus` | de Bothezat (1922) | USA | Six-rotor experiment |
| `cierva_c30_autogyro` | Cierva C.30 | UK/Spain | Operational autogyro |
| `fw61_helicopter` | Fw 61 | Germany | First practical helicopter 1936 |
| `sikorsky_vs300` | VS-300 | USA | Tail rotor breakthrough 1939 |
| `breguet_dorand_gyrolab` | Breguet-Dorand | France | Gyroplane lab |
| `naval_autogyro_proto` | Naval autogyro trials | UK | Pre-helicopter ASW spotting |

### WWII German production helicopter

| ID | Name | Notes |
|----|------|-------|
| `fa223_drache` | Fa 223 Drache | First production helicopter (1940); twin 12 m rotors, Bramo 323, 1,000+ kg cargo; Channel crossing 1942 |

---

## Surface fleet · carriers, battleships, cruisers, destroyers

Generator: `tools/generate_surface_naval_fleet.py` — **69 templates** covering pre-WWI through 2030s.

| Type | Era spread | Examples |
|------|------------|----------|
| **Carriers** | 1918–2030s | `hms_argus_carrier`, `lexington_class_carrier`, `midway_class_carrier`, `enterprise_cvn65`, `cvn_x_prototype` (+ existing Essex, Ford, Vikrant, etc.) |
| **Battleships** | WWI–WWII | `iowa_class_battleship`, `tirpitz_battleship`, `richelieu_battleship`, `yamato_battleship` (core set) |
| **Cruisers** | Interwar–modern | `baltimore_class_cruiser`, `ticonderoga_class_cruiser`, `type055_cruiser`, `kirov_class_battlecruiser` |
| **Destroyers** | WWI–2030s | `fubuki_class_destroyer`, `arleigh_burke_destroyer`, `zumwalt_class_destroyer`, `type052d_destroyer` |

---

## Naval prototypes & paper designs

Unlock tags: `naval_prototype`, `paper_navy` — cancelled, incomplete, or never-built warships.

| Era | Examples |
|-----|----------|
| Interwar | `lexington_bc_1920`, `g3_battlecruiser_uk`, `joffre_class_carrier` |
| WWII paper | `montana_class_bb`, `h39_h_class_bb`, `a150_super_yamato`, `malta_class_carrier`, `h44_supercarrier_us` |
| Cold War cancelled | `uss_united_states_cvb`, `cva01_carrier`, `ulyanovsk_carrier`, `stalingrad_class_bc`, `strike_cruiser_csgn` |
| 2030s planned | `shtorm_class_carrier`, `type83_destroyer_planned`, `ddg_x_frigate_planned`, `indian_vishal_carrier` |

---

## 2026 scenario · complete naval order of battle

Generator: `tools/generate_2026_naval_fleet.py` — every nation in `data/scenarios/2026.json` has at least one `naval_2026` hull (carrier, amphib, frigate, corvette, patrol, or submarine).

| Nation tag | Capital ships | Escorts / patrol | Submarines |
|------------|---------------|------------------|------------|
| USA | `ford_class_carrier_2026`, `wasp_class_lhd_2026` | `arleigh_burke_class_2026`, `constellation_class_2026` | (Virginia in general catalog) |
| CHN | `liaoning_carrier`, `shandong_carrier`, `fujian_carrier` | `type055_class_2026`, `type052d_class_2026` | `type_093_shang` |
| RUS | `admiral_kuznetsov_carrier` | `admiral_gorshkov_2026` | `yasen_ssn`, `kilo_class_submarine` |
| ENG | `queen_elizabeth_cv` | `type45_daring_2026`, `type26_frigate_2026` | `astute_ssn` |
| FRA | `charles_de_gaulle_carrier`, `mistral_france_2026` | `fremm_frigate_2026` | `barracuda_class` |
| GER | — | `baden_wurttemberg_2026` | `type212_germany_2026` |
| JAP | `izumo_class_carrier`, `hyuga_class_2026` | `maya_class_2026` | `soryu_japan_2026` |
| IND | `ins_vikrant_carrier`, `ins_vikramaditya_carrier` | `kolkata_class_2026` | `kalvari_india_2026` |
| ISR | — | `saar6_class_2026` | `israeli_dolphin_2026` |
| KOR | `dokdo_lph` | `sejong_class_2026` | `kss3_korea_2026` |
| TUR | `tcg_anadolu` | `istanbul_class_2026` | `kilo_turkey_2026` |
| … | *(all 37 scenario tags covered)* | | |

Smaller nations use `coast_guard_patrol_minor` or export frigates: `gyurza_class_2026` (UKR), `iceland_patrol_2026` (ISL), `nigeria_patrol_2026` (NGA), etc.

---

## 1918 scenario · Great War naval order of battle

Unlock tags: `naval_1918`, `ww1_naval`, `great_war_naval` — generator `tools/generate_1918_naval_fleet.py` (**45 templates**).

| Nation | Capital / major | Escorts & patrol |
|--------|-----------------|------------------|
| ENG | `queen_elizabeth_bb_1918`, `revenge_class_bb_1918`, `hms_argus_1918` | `v_class_dd_1918` |
| GER | `bayern_class_bb_1918`, `moltke_bc_1918` | `v_torpedo_boat_1918`, `type_uboat_1918` |
| USA | `nevada_class_bb_1918` | `wickes_class_dd_1918`, `clemson_class_dd_1918` |
| FRA | `courbet_class_bb_1918` | `contre_torpilleur_1918` |
| JAP | `ise_class_bb_1918`, `kongo_bc_1918` | `fubuki_precursor_1918` |
| TUR | `yavuz_sultan_1918` | `midilli_cruiser_1918` |
| Neutrals / mandates | — | `sweden_coastal_1918`, `tromp_cruiser_1918`, `mandate_patrol_1918`, etc. |

All **30** nations in `data/scenarios/1918.json` covered (including PAL, GRL, colonial patrol).

---

## 1936 scenario · Interwar naval order of battle

Unlock tags: `naval_1936`, `interwar_naval`, `pre_ww2_naval` — generator `tools/generate_1936_naval_fleet.py` (**47 templates**).

| Nation | Capital / major | Escorts & subs |
|--------|-----------------|----------------|
| ENG | `queen_elizabeth_bb_1936`, `renown_bc_1936` | `county_class_1936`, `tribal_class_1936` |
| GER | `deutschland_class_1936`, `scharnhorst_class_1936` | `z_class_destroyer_1936`, `type_viia_uboat_1936` |
| USA | `colorado_class_1936`, `lexington_class_cv_1936` | `brooklyn_class_1936`, `fletcher_precursor_1936` |
| JAP | `fuso_class_1936`, `akagi_carrier_1936` | `mogami_class_1936`, `fubuki_class_1936` |
| FRA | `dunkerque_class_1936` | `le_fantasque_1936` |
| ITA | `vittorio_veneto_bb_1936` | `zara_class_1936` |
| POL | — | `grom_class_1936`, `orpzel_sub_1936` |

All **29** nations in `data/scenarios/1936.json` covered.

---

## Submarines · 1910s–2030s

`base_type: Submarine` — diesel-electric, nuclear, AIP, and autonomous undersea craft.

### By era
| Era | Examples |
|-----|----------|
| Pre-WWI / WWI | `holland_submarine`, `type_uboat_ww1`, `e_class_submarine`, `k_class_uk_sub` |
| WWII | `type_viic_uboat`, `type_ixc_uboat`, `type_xxi_uboat`, `gato_class_submarine`, `balao_class_submarine`, `i400_sen_toku`, `t_class_submarine` |
| Cold War | `nautilus_ssn`, `los_angeles_ssn`, `ohio_ssbn`, `typhoon_ssbn`, `kilo_class_submarine`, `foxtrot_class`, `resolution_ssbn` |
| 2000s–2020s | `virginia_ssn`, `seawolf_ssn`, `astute_ssn`, `yasen_ssn`, `type_093_shang`, `type_212_aip`, `scorpene_class`, `soryu_class`, `collins_class`, `israeli_dolphin` |
| 2030s planned | `ssnx_prototype`, `columbia_ssbn`, `type_096_ssbn`, `orcus_xluuv`, `crewless_strike_sub_2030` |

Major players: USA, Germany, UK, USSR/Russia, China, France, Japan, Sweden, Australia, India, Israel, South Korea, Italy.

---

## 1960s–1970s

| ID | Name | Nation | Key loadout |
|----|------|--------|-------------|
| `m60a1_patton` | M60A1 | USA | M68A1, APFSDS, laser rangefinder |
| `t62_medium_tank` | T-62 | USSR | 115 mm smoothbore |
| `t72_mbt` | T-72 | USSR | 125 mm 2A46, composite armor |
| `type59_mbt` | Type 59 | China | T-54 derivative |
| `amx30_mbt` | AMX-30 | France | CN-105-F1, HS-110 diesel |
| `chieftain_mk5` | Chieftain Mk 5 | UK | L11 120 mm, HESH |
| `leopard_1a4` | Leopard 1A4 | Germany | L7A3, MTU MB 838 |
| `leopard_2_proto` | Leopard 2 (Proto) | Germany | Rh-120, thermal sight |
| `merkava_mk1` | Merkava Mk I | Israel | Front-engine MBT |
| `magach_6` | Magach 6 | Israel | M60A1 upgrade |
| `f4e_phantom` | F-4E Phantom II | USA | Sparrow, Sidewinder, J79 |
| `mig21bis_fighter` | MiG-21bis | USSR | R-60, R-13 |
| `mirage_iii_fighter` | Mirage III | France | DEFA 550, Atar 9C |
| `harrier_gr1` | Harrier GR.1 | UK | Pegasus V/STOL |
| `j7_fighter` | J-7 | China | PL-2, WP-7 |
| `kfir_c2` | Kfir C.2 | Israel | Shafrir 2, J79 |
| `bmp1_ifv` | BMP-1 | USSR | 73 mm + Sagger |

## 1980s–1990s

| ID | Name | Nation | Key loadout |
|----|------|--------|-------------|
| `m1_abrams` | M1 Abrams | USA | M256, AGT-1500, Chobham |
| `m1a2_abrams` | M1A2 Abrams | USA | SEP armor, M829A1, hunter-killer FCS |
| `m2a2_bradley` | M2A2 Bradley | USA | 25 mm + TOW-2 |
| `f15c_eagle` | F-15C | USA | AMRAAM, F100 |
| `f16c_fighting_falcon` | F-16C | USA | AIM-9X, F110 |
| `ah64_apache` | AH-64 | USA | Hellfire |
| `t72b_mbt` | T-72B | USSR | Kontakt-5, 2A46M |
| `t80u_mbt` | T-80U | USSR | GTD-1000T turbine |
| `t90_mbt` | T-90 | Russia | Shtora, 3BM42 |
| `mig29_fulcrum` | MiG-29 | USSR | R-73 |
| `su27_flanker` | Su-27 | USSR | R-27, AL-31F |
| `type88_mbt` / `type96_mbt` | Type 88 / 96 | China | 105 mm / 125 mm |
| `leclerc_mbt` | Leclerc | France | CN120-26 autoloader |
| `mirage2000_fighter` | Mirage 2000 | France | Super 530D |
| `challenger1_mbt` / `challenger2_mbt` | Challenger 1/2 | UK | L30, Dorchester |
| `leopard2a4` / `leopard2a5` | Leopard 2A4/A5 | Germany | Rh-120, wedge armor |
| `merkava_mk3` | Merkava Mk III | Israel | IMI 120 mm, Spike |
| `f15i_raam` | F-15I Ra'am | Israel | Derby BVR |

## 2000s–2010s

| ID | Name | Nation | Key loadout |
|----|------|--------|-------------|
| `m1a2_sep_abrams` | M1A2 SEP | USA | SEP v2 armor, M829A2 |
| `m1a2c_abrams` | M1A2C | USA | SEP v3, Trophy, M829A3 |
| `f22a_raptor` | F-22A | USA | APG-77, AMRAAM-D |
| `f35a_lightning` | F-35A | USA | F135, AESA |
| `mq9_reaper_uav` | MQ-9 Reaper | USA | Hellfire, armed UAV |
| `t90a_mbt` | T-90A | Russia | Relikt, 2A46M-4 |
| `t72b3_mbt` | T-72B3 | Russia | Modernized T-72 |
| `t14_armata` | T-14 | Russia | 2A82, Afghanit |
| `su35s_flanker` / `su57_felon` | Su-35S / Su-57 | Russia | Flanker / Felon |
| `type99a_mbt` | Type 99A | China | ZPT-98, FY-4 armor |
| `j10c_fighter` / `j20_fighter` | J-10C / J-20 | China | PL-12 / PL-15 |
| `leclerc_xxi` | Leclerc XXI | France | Block upgrade |
| `rafale_fighter` | Rafale | France | MICA NG |
| `challenger2_tes` | Challenger 2 TES | UK | Dorchester Mk 2 |
| `typhoon_fighter` | Typhoon | UK | Meteor |
| `leopard2a6` / `leopard2a7v` | Leopard 2A6/A7V | Germany | L/55, DM63 |
| `puma_ifv` | Puma | Germany | Spike-LR2 |
| `merkava_mk4` | Merkava Mk IV | Israel | Trophy APS |
| `f35i_adir` | F-35I Adir | Israel | Custom EW package |

## 2020s–2030s

| ID | Name | Nation | Key loadout |
|----|------|--------|-------------|
| `m1a2_sep_v4_abrams` | M1A2 SEP v4 | USA | Trophy, M829A4 |
| `abramsx_prototype` | AbramsX | USA | Hybrid drive |
| `f47_ngad_proto` | F-47 NGAD (Dev) | USA | JATM, CCA wingman |
| `f47_operational` | F-47 (Ops) | USA | Sixth-gen full fit |
| `m1e3_abrams_2030` | M1E3 | USA | Planned hybrid MBT |
| `trump_class_battleship` | Trump-class BB | USA | 16-inch + VLS + laser (planned) |
| `ddgx_destroyer` | DDG(X) | USA | Next-gen destroyer |
| `b21_raider` | B-21 Raider | USA | Stealth bomber |
| `t90m_mbt` | T-90M | Russia | Relikt, 3BM69 |
| `su57_felon_serial` | Su-57 | Russia | Okhotnik UCAV |
| `type99a_phase3` | Type 99A | China | Phase III armor |
| `j20a_fighter` | J-20A | China | PL-15E |
| `fujian_carrier` | Fujian | China | EMALS carrier |
| `challenger3_mbt` | Challenger 3 | UK | L55A1 |
| `leopard2a8` | Leopard 2A8 | Germany | Trophy |
| `mgcs_prototype_2030` | MGCS | France/Germany | 140 mm planned |
| `gcas_tempest_2030` | GCAP Tempest | UK | Sixth-gen planned |
| `merkava_mk4_barak` | Merkava Mk 4 Barak | Israel | Trophy |
| `rafale_f4` | Rafale F4 | France | F4 sensors |
| `f35i_adir_block4` | F-35I Block 4 | Israel | Adir EW |

---

## Space · 1940s–2030s

`base_type: Space` — rockets, satellites, crew capsules, and orbital stations. Major programs from Germany (V-2), NASA, USSR/Russia, ESA, CNSA, SpaceX, JAXA, ISRO, and Blue Origin through near-future 2030s concepts.

| ID | Name | Nation / org | Key loadout |
|----|------|--------------|-------------|
| `a4_v2_rocket` | A4/V-2 | Germany | V-2 engine, guidance, stage |
| `redstone_jupiter` | Redstone / Jupiter-C | USA | Explorer 1 path |
| `r7_sputnik` | R-7 / Sputnik | USSR | First satellite launcher |
| `saturn_v_apollo` | Saturn V (Apollo) | USA | F-1, CSM, LM |
| `gemini_spacecraft` | Gemini | USA | Crew capsule |
| `soyuz_spacecraft_tpl` | Soyuz | USSR/Russia | R-7 lineage crew vehicle |
| `proton_launcher` | Proton | USSR/Russia | Heavy lift |
| `mir_space_station` | Mir | USSR/Russia | Core module |
| `energia_buran` | Energia / Buran | USSR | Shuttle-analog |
| `space_shuttle` | Space Shuttle | USA | SSME, orbiter |
| `hubble_spacecraft` | Hubble | USA | Space telescope |
| `gps_satellite` | GPS Block I | USA | Nav constellation |
| `ariane5_launcher` / `ariane6_launcher` | Ariane 5/6 | ESA | European launchers |
| `columbus_iss_module` | Columbus | ESA | ISS lab |
| `long_march5_launcher` | Long March 5 | China | Heavy lift |
| `shenzhou_spacecraft` | Shenzhou | China | Crewed capsule |
| `tiangong_space_station` | Tiangong / CSS | China | Station core |
| `change_lunar_mission` | Chang'e | China | Lunar lander |
| `falcon9_rocket` / `falcon_heavy_rocket` | Falcon 9 / Heavy | SpaceX | Merlin stages |
| `crew_dragon` | Crew Dragon | SpaceX | Dragon 2 |
| `starship_super_heavy` | Starship | SpaceX | Raptor, Mars fit |
| `starlink_satellite` | Starlink | SpaceX | Constellation bus |
| `iss_complex` | ISS | Multinational | Zvezda, Destiny |
| `jwst_observatory` | JWST | USA/ESA/CSA | Deep-space telescope |
| `sls_artemis` | SLS / Artemis | USA | Orion, lunar return |
| `lunar_gateway` | Lunar Gateway | USA/ESA/etc. | Cislunar station |
| `lunar_surface_hab_2030` | Lunar surface hab | Planned | 2030s |
| `h2a_launcher` | H-IIA | Japan (JAXA) | National launcher |
| `pslv_launcher` | PSLV | India (ISRO) | Light/medium lift |
| `new_glenn_rocket` / `new_glenn_2030` | New Glenn | Blue Origin | Heavy lift |
| `long_march9_2030` | Long March 9 | China | Super-heavy (planned) |
| `ross_station_2030` | ROSS | Russia | Orbital station (planned) |

Design families: `german_space_ww2`, `us_space_sixties`, `soviet_space_fifties`, `spacex_reusable`, `cnsa_space`, `esa_launchers`, `artemis_2030`, etc.

---

## Design families (for production lines)

Examples: `us_armored_ww2`, `german_paper_ww2`, `german_jet_ww2`, `japanese_paper_ww2`, `soviet_armored_cold_war`, `us_armored_cold_war`

Templates sharing a `design_family` get retooling discounts when switching production on the same line. Paper/prototype families (`*_paper_*`) pair well for alt-history production trees.
