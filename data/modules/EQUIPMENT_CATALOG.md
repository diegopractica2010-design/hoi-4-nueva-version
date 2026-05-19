# Equipment Module Catalog (WWI · WWII · Naval · Cold War)

**1071+ modules** in `data/modules/`.  
All load automatically via `DesignDataLoader` on startup.

### Land missiles · MLRS · SAM · modular transports

**Modeling conventions:**
| Slot | Use |
|------|-----|
| `MainWeapon` | Rocket pods, SRBM/IRBM/ICBM rounds, ATACMS/GMLRS (on launcher chassis or truck `MainWeapon`) |
| `AntiAir` | Patriot, Iron Dome, THAAD, Hawk, S-300/HQ-9 batteries |
| `Cargo` | Truck beds / merchant holds; `standard_truck_cargo_bed` vs `merchant_armed_cargo_hold` (reduced payload) |
| `SecondaryWeapon` | Naval deck missiles/guns on armed merchants |

**Launcher vehicles** (`visual_archetype`: `rocket_launcher`, `sam_battery`, `icbm_launcher`): tracked/wheeled TEL with open weapon slots.  
**Land transports** (`visual_archetype`: `transport`): `Cargo` + optional `MainWeapon` — fit any module flagged `mountable_on_transport` (e.g. `bm13_katyusha_rack`, `gmlrs_rocket_pod`).  
**Cargo ships** (`visual_archetype`: `cargo_ship`): `cargo_capacity` in `base_stats`; armed variants use lower capacity + `SecondaryWeapon`/`AntiAir`.

Key modules: `bm13_katyusha_rack`, `bm21_grad_122mm`, `m270_mlrs`, `m142_himars_system`, `gmlrs_rocket_pod`, `scud_b_srbm`, `minuteman_3_icbm`, `df41_icbm`, `rs24_yars_icbm`, `mim104_patriot`, `mim104e_patriot_pac3`, `iron_dome_interceptor`, `thaad_interceptor`, `arrow3_interceptor`, `iskander_srbm`, `prsm_precision_strike`.

Regenerate batches:
```bash
python3 tools/generate_missile_launcher_systems.py   # missiles + mobile launchers
python3 tools/generate_transport_cargo_naval.py    # trucks + modular cargo ships
python3 tools/generate_scenario_frigates.py          # per-nation frigates 1918/1936/2026
python3 tools/generate_scenario_forces.py            # land/air per scenario nation
python3 tools/generate_ww2_modules.py           # WWII land/air (skips existing)
python3 tools/generate_ww1_naval_modules.py      # WWI, minors, naval (skips existing)
python3 tools/generate_late_ww2_cold_war_modules.py  # 1945–1955 & Axis prototypes
python3 tools/generate_specialized_equipment_modules.py  # ASW, radar, night vision, carriers
python3 tools/generate_carrier_unit_templates.py  # Carrier & ASW unit templates
python3 tools/generate_sixties_seventies_modules.py  # 1960s–1970s (US, USSR, China, FR, UK, DE, IL)
python3 tools/generate_sixties_seventies_unit_templates.py
python3 tools/generate_eighties_nineties_modules.py       # 1980s–1990s
python3 tools/generate_eighties_nineties_unit_templates.py
python3 tools/generate_2000s_2010s_modules.py
python3 tools/generate_2000s_2010s_unit_templates.py
python3 tools/generate_2020s_2030s_modules.py
python3 tools/generate_2020s_2030s_unit_templates.py
python3 tools/generate_space_modules.py          # space rockets, satellites, stations
python3 tools/generate_space_unit_templates.py
python3 tools/generate_carrier_aircraft_modules.py   # carrier naval aviation
python3 tools/generate_carrier_aircraft_templates.py
python3 tools/generate_2026_naval_aviation.py       # 2026 carriers, STOVL, Indian Navy, LHD
python3 tools/generate_naval_helicopter_aviation.py # naval helos & LHD/LPH 1940s–2030s
python3 tools/generate_early_helicopter_prototypes.py  # pre-1940 autogyros & helicopters
python3 tools/generate_submarine_aviation.py         # submarines pre-WWI–2030s
python3 tools/generate_surface_naval_fleet.py       # carriers, BB, CA, DD pre-WWI–2030s
python3 tools/generate_naval_prototypes_designs.py  # paper ships & cancelled designs
python3 tools/generate_2026_naval_fleet.py          # 2026 scenario frigates & patrol
python3 tools/generate_1918_naval_fleet.py          # 1918 Great War scenario fleet
python3 tools/generate_1936_naval_fleet.py          # 1936 interwar scenario fleet
```

### 1960s–1970s
Key entries: `m68a1_105mm_gun`, `d81_125mm_gun`, `rh120_120mm_smoothbore`, `l11a5_120mm_rifled`, `cn105f1_105mm_gun`, `merkava_mk1_105mm`, `tow_atgm`, `milan_atgm`, `sa6_gainful_sam`, `exocet_mm38`, `chobham_armor_uk`, `kontakt1_era`, `type59_100mm_gun`, `harpoon_anti_ship`, `phalanx_ciws`.
```

### ASW · depth charges · sonar · homing torpedoes
`depth_charge_mk6`, `depth_charge_mk9`, `k_gun_launcher`, `hedgehog_sprengbombe`, `squid_asw_mortar`, `limbo_asw_mortar`, `sonar_qcba`, `sonar_type144`, `mk24_fido_torpedo`, `weapon_alpha_asw`, and more.

### Radar · night vision
`sk_surface_radar`, `ai_mk4_radar`, `fu_g_220_lichtenstein_sn2`, `m3_sniperscope`, `vampir_infantry_package`, etc.

### Aircraft ordnance · guns
`napalm_m47`, `tallboy_earthquake_bomb`, `grand_slam_bomb`, `hvar_rocket`, `browning_an_m3_gun`, `defa_30mm_cannon`, etc.

### Carrier systems
`carrier_armored_flight_deck`, `carrier_hydraulic_catapult`, `carrier_cic_director`, `escort_carrier_hanger`, `angled_deck_prototype`, etc.

### 1980s–1990s
**USA:** `m1a2_sep_armor`, `m829a1_apfsds`, `aim120c_amraam`, `javelin_atgm`, `ah64_hellfire`, `aegis_spy1_radar`, `tomahawk_cruise_missile`  
**USSR/Russia:** `t72b_kontakt5`, `2a46m5_125mm_gun`, `r73_archer_missile`, `s300_pmu_sam`, `t90_armor_package`, `r77_adder_missile`  
**China:** `type96_125mm_gun`, `hq9_sam_proto`, `pl11_air_missile`, `ws10_proto_turbofan`  
**France:** `cn120_26_leclerc_gun`, `leclerc_armor`, `mica_air_missile`, `exocet_block2`  
**UK:** `l30_120mm_rifled`, `challenger2_armor`, `asraam_missile`, `eurofighter_ef2000_engine`  
**Germany:** `leopard2a5_wedge_armor`, `rh120_l44_gun`, `dm43_apfsds`, `gepard_spaag_system` (see also 60s)  
**Israel:** `merkava_mk3_armor`, `imi_120mm_gun`, `spike_atgm`, `derby_bvr_missile`, `python4_missile`

### 2000s–2010s
**USA:** `m1a2c_sep_v3_armor`, `m829a3_apfsds`, `f35a_package`, `trophy_aps_usa`, `aim120d_amraam`, `mq9_reaper_package`  
**Russia:** `t90a_armor_package`, `t14_armata_package`, `afghanit_aps`, `su57_package`, `s400_triumf`, `kalibr_cruise_missile`  
**China:** `type99a_armor`, `j20_package`, `pl15_air_missile`, `df21d_asbm`, `hq9b_sam`  
**France:** `leclerc_xei_armor`, `rafale_package`, `mica_ng_missile`, `scalp_cruise_missile`  
**UK:** `meteor_missile`, `challenger2_dorchester_mk2`, `eurofighter_typhoon`, `brimstone_missile`  
**Germany:** `leopard2a6_armor`, `leopard2a7_package`, `puma_ifv_package`, `rh120_l55_gun`  
**Israel:** `merkava_mk4_armor`, `trophy_aps_israel`, `iron_dome_interceptor`, `f35i_adir_package`

### 2020s–2030s (in service & planned)
**USA:** `f47_ngad_package`, `trump_class_hull`, `trump_class_16inch_modern`, `m1a2_sep_v4_armor`, `aim260_jatm`, `b21_raider_package`, `cca_loyal_wingman`, `m1e3_abrams_package`  
**Russia:** `t90m_armor_package`, `zircon_hypersonic`, `s500_prometey`, `su57_serial_package`, `okhotnik_ucav`  
**China:** `j20a_operational`, `j35_carrier_fighter`, `fujian_emals_carrier`, `pl21_missile`, `type100_mbt_proto`, `h20_bomber_package`  
**France/Germany:** `mgcs_main_gun`, `fcas_ngf_proto`, `rafale_f4_package`, `leopard2a8_package`  
**UK:** `challenger3_package`, `gcas_tempest_engine`, `spear3_missile`  
**Israel:** `merkava_mk4_barak`, `iron_beam_laser`, `arrow4_interceptor`

### Carrier aircraft · naval aviation (WWII–2030s)
**Common:** `carrier_operations_kit`, `mk13_aerial_torpedo`, `type91_aerial_torpedo`, `mk12_aerial_torpedo_uk`  
**USA WWII:** `f6f_gun_battery`, `pratt_r2800_hellcat`, `sbd_dive_bomb_package`, `sb2c_bomb_torpedo_load`, `tbf_strike_torpedo_load`  
**UK WWII:** `bristol_pegasus_swordfish`, `firefly_strike_load`, `bristol_hercules_barracuda`  
**Japan WWII:** `d3a_val_dive_bomb`, `b5n_kate_torpedo_load`, `a7m_reppu_proto_engine`  
**Germany (Graf Zeppelin):** `bf109t_carrier_package`, `fi167_carrier_scout`, `me155_carrier_proto`  
**USA modern:** `tf30_f14_engine`, `ge_f404_hornet`, `ge_f414_super_hornet`, `e2c_hawkeye_radar`, `f35c_carrier_package`, `ngad_carrier_proto_2030`  
**UK/France/Russia/China:** `sea_harrier_frs_package`, `super_etendard_strike`, `rafale_m_carrier_package`, `al31fp_su33`, `rd33mk_mig29k`, `ws10j_j15_engine`, `j35_carrier_fighter`  
**WWII follow-ups:** `b6n_jill_torpedo_load`, `f2a_buffalo_gun_battery`, `sea_hurricane_catapult_kit`

### Naval aviation · 2026 scenario
**Carriers:** `nimitz_class_core`, `ford_class_core`, `queen_elizabeth_cv_core`, `charles_de_gaulle_core`, `cavour_stovl_deck`, `izumo_stovl_upgrade`, `ins_vikrant_carrier_core`, `liaoning_carrier_core`, `shandong_carrier_core`  
**India:** `mig29k_india_avionics`, `brahmos_air_launched`, `tejas_naval_proto_package`, `astra_mk1_missile`, `barak8_sam`  
**SAM / UAV:** `aster30_sam`, `sea_viper_sam`, `bayraktar_tb2_package`  
**Helos:** `mh60r_asw_helo_suite`, `nh90_nato_naval_helo`, `ka27_helix_asw_suite`, `z18f_asw_helo_suite`

### Naval helicopters & amphibious ships · 1940s–2030s
**USA:** `ho3s_dragonfly_suite`, `sh3_sea_king_asw`, `sh60b_seahawk_asw`, `mh60s_knighthawk_suite`, `ch53k_king_stallion`, `osprey_mv22_package`  
**UK:** `westland_wasp_asw`, `lynx_has3_asw`, `aw101_merlin_asw`, `sea_skua_asm`  
**France/USSR/China:** `super_frelon_asw`, `ka25_hormone_asw`, `z20f_asw_suite`, `harbin_z9c_asw`  
**LHD/LPH:** `iwo_jima_lph_core`, `tarawa_lha_core`, `wasp_lhd_core`, `america_lha_core`, `invincible_class_core`, `mistral_class_lhd_france`  
**2030s:** `flraa_maritime_proto`, `autonomous_naval_helo_2030`, `aw249_naval_proto`

### Pre-1940 rotary-wing prototypes
`de_bothezat_rotor_system`, `cierva_autogyro_c30`, `fw61_twin_intermeshing_rotor`, `vs300_sikorsky_single_rotor`, `henri_coanda_rotor_blower`

### WWII German helicopters
`bramo_323_drache_engine`, `fa223_transverse_twin_rotor`, `fa223_transport_cabin` — Fa 223 Drache (1940)

### Surface fleet · carriers & escorts
`westinghouse_a4w_carrier_reactor`, `midway_class_flight_deck`, `forrestal_supercarrier_deck`, `cvn_x_carrier_proto`, `mk41_vls_destroyer`, `type055_cruiser_vls`

### Naval prototypes & paper designs
`montana_class_bb_design`, `h39_h_class_bb_design`, `a150_super_yamato_design`, `malta_class_carrier_design`, `shtorm_carrier_2030`, `type83_destroyer_planned`

### 2026 scenario naval combatants
`fremm_frigate_suite`, `maya_class_aegis_japan`, `sejong_kdx3_aegis`, `saar6_corvette`, `kolkata_class_destroyer`, `gyurza_patrol_ukr`

### Submarines · pre-WWI–2030s
**WWI/WWII:** `g7a_torpedo_sub`, `g7es_acoustic_homing`, `mk14_torpedo_us`, `type95_sub_torpedo`, `snorkel_fitting`, `type21_hydrodynamic_hull`  
**Cold War:** `westinghouse_s5w_reactor`, `polaris_a3_slbm`, `trident_d5_slbm`, `spearfish_torpedo_uk`, `va111_shkval_supercavitating`  
**Modern:** `ge_s9g_reactor`, `fuel_cell_aip_212`, `stirling_aip_engine`, `optronic_mast`, `kalibr_vls_sub`, `jl3_slbm_china`  
**2030s:** `ssnx_reactor_proto`, `crewless_submarine_2030`, `lockheed_martin_orca_uuv`

### Space · 1940s–2030s (rockets, satellites, stations)
**Germany:** `a4_v2_engine`, `v2_guidance_package`, `aggregat4_stage`  
**USA / NASA:** `redstone_engine`, `f1_saturn_engine`, `apollo_csm_capsule`, `ssme_shuttle_engine`, `hubble_space_telescope`, `gps_block1_payload`, `sls_block2_booster`, `orion_spacecraft`, `jwst_telescope`, `gateway_lunar_station`  
**USSR / Russia:** `r7_soyuz_engine`, `sputnik1_bus`, `soyuz_spacecraft_bus`, `mir_core_module`, `energia_booster`, `buran_orbiter`, `glonass_payload`, `russian_oren_space_station` (planned)  
**ESA:** `ariane1_first_stage`, `ariane5_core_stage`, `ariane6_launcher`, `columbus_lab_module`, `rosetta_comet_probe`, `vega_light_launcher`  
**China:** `long_march2_engine`, `long_march5_heavy`, `shenzhou_capsule`, `tiangong_space_station_core`, `change_lunar_lander`, `beidou_navigation_payload`, `long_march9_superheavy` (planned)  
**SpaceX:** `merlin1d_engine`, `falcon9_stage_package`, `dragon2_capsule`, `starship_raptor_engine`, `starship_vehicle_package`, `starlink_bus`, `starship_mars_lander_fit`  
**Other:** `h2a_launch_vehicle` (JAXA), `pslv_launcher` (ISRO), `new_glenn_stage` / `blue_moon_lander` (Blue Origin)  
**2030s planned:** `lunar_gateway_hab`, `on_orbit_refueling_depot`, `space_tug_nuclear_thermal`, `mega_constellation_asat`, `lasercom_interplanetary`

Stat scale reference:
- **WWI field gun**: soft ~50–65, piercing ~15–25  
- **WWII medium tank gun**: piercing ~72–82  
- **WWII heavy AT**: piercing ~115–135  
- **Destroyer 5" DP**: anti_ship ~35, anti_air ~20  
- **Battleship 16"**: piercing ~125–138, anti_ship ~105–115  
- **Yamato 18"**: piercing 145, anti_ship 125  

Naval modules use `anti_ship` and `anti_air` fields (see `EquipmentModule.gd`).

---

---

## United States (15 modules)

| ID | Name | Category | Notes |
|----|------|----------|-------|
| `37mm_m6_gun` | 37mm M6 Gun | MainWeapon | Stuart light tank |
| `75mm_m3_gun` | 75mm M3 Gun | MainWeapon | Early Sherman |
| `76mm_m1_gun` | 76mm M1 Gun | MainWeapon | Sherman 76 mm |
| `90mm_m3_gun` | 90mm M3 Gun | MainWeapon | Pershing / M36 |
| `105mm_howitzer` | 105mm Howitzer | MainWeapon | Sherman 105 |
| `continental_r975_engine` | Continental R975 | Engine | Radial tank engine |
| `ford_gaa_v8_engine` | Ford GAA V-8 | Engine | Sherman powerplant |
| `chrysler_multibank_engine` | Chrysler A57 Multibank | Engine | M4A4 (unreliable) |
| `sherman_armor_plate` | Sherman Armor Package | Armor | Medium tank |
| `m4_applique_armor` | M4 Appliqué Armor | Armor | Field upgrade |
| `scr_508_radio` | SCR-508 Tank Radio | Communications | Armor platoon |
| `scr_522_radio` | SCR-522 Command Radio | Communications | Bomber formation |
| `m2_browning_gun_pod` | M2 Browning Gun Pod | MainWeapon | Fighter / bomber |
| `anm2_20mm_cannon` | AN/M2 20mm Cannon | MainWeapon | P-39 etc. |
| `browning_m2_defensive_battery` | Browning M2 Battery | SecondaryWeapon | B-17 defense |
| `allison_v1710_engine` | Allison V-1710 | Engine | P-38, P-39, P-51 |
| `pratt_whitney_r2800` | Pratt & Whitney R-2800 | Engine | P-47 |
| `wright_r1820_cyclone` | Wright R-1820 Cyclone | Engine | B-17 |
| `us_1000lb_bomb_load` | 1,000 lb Bomb Load | MainWeapon | Tactical bombing |
| `us_4000lb_bomb_load` | 4,000 lb Bomb Load | MainWeapon | B-17 strategic |
| `norden_bombsight` | Norden Bombsight | Sensors | Precision bombing |
| `us_mark_iii_sight` | Mark III Gyro Sight | Sensors | Fighter aiming |
| `high_altitude_life_support` | High Altitude Life Support | LifeSupport | Bomber / high alt |

---

## United Kingdom (14 modules)

| ID | Name | Category | Notes |
|----|------|----------|-------|
| `qf_2pdr_gun` | QF 2-pdr | MainWeapon | Early cruiser tanks |
| `qf_6pdr_gun` | QF 6-pdr Mk III | MainWeapon | Crusader, Churchill |
| `qf_17pdr_gun` | QF 17-pdr | MainWeapon | Firefly Sherman |
| `qf_25pdr_gun` | QF 25-pdr | MainWeapon | Artillery / CS tanks |
| `rolls_royce_meteor` | Rolls-Royce Meteor | Engine | Cromwell, Comet |
| `bedford_twin_six_engine` | Bedford Twin-Six | Engine | Churchill |
| `churchill_cast_armor` | Churchill Cast Armor | Armor | Heavy infantry tank |
| `wireless_set_no19` | Wireless Set No. 19 | Communications | Tank brigade |
| `hispano_mk2_cannon` | Hispano Mk II | MainWeapon | Spitfire, Typhoon |
| `browning_303_battery` | .303 Browning Battery | SecondaryWeapon | Early fighters |
| `merlin_xx_engine` | Rolls-Royce Merlin XX | Engine | Spitfire, Lancaster |
| `griffon_engine` | Rolls-Royce Griffon | Engine | Late Spitfire |
| `uk_4000lb_bomb_load` | 4,000 lb Cookie Load | MainWeapon | Lancaster |
| `mk14_gyro_sight` | Mk XIV Gyro Gunsight | Sensors | Fighter lead |

---

## Germany (18 modules)

| ID | Name | Category | Notes |
|----|------|----------|-------|
| `kwk_38_50mm_gun` | 5 cm KwK 38 L/42 | MainWeapon | Panzer III |
| `kwk_40_75mm_gun` | 7.5 cm KwK 40 L/48 | MainWeapon | Panzer IV |
| `kwk_36_88mm_gun` | 8.8 cm KwK 36 L/56 | MainWeapon | Tiger I |
| `kwk_43_88mm_gun` | 8.8 cm KwK 43 L/71 | MainWeapon | Tiger II |
| `maybach_hl230_engine` | Maybach HL230 P45 | Engine | Tiger I |
| `man_maybach_600_engine` | Maybach HL 230 (Panther) | Engine | Panther |
| `krupp_tiger_armor` | Krupp Tiger Armor | Armor | Tiger I |
| `schurzen_armor_skirts` | Schürzen Side Skirts | Armor | AT rifle / HEAT |
| `fug_16_zyf_radio` | FuG 16 ZY Radio | Communications | Luftwaffe |
| `mg151_20_cannon` | MG 151/20 | MainWeapon | Bf 109, Fw 190 |
| `mg17_machine_gun` | MG 17 | SecondaryWeapon | Supplement |
| `mk108_30mm_cannon` | MK 108 30mm | MainWeapon | Bomber killer |
| `db_605a_engine` | Daimler-Benz DB 605A | Engine | Bf 109G |
| `bmw_801_radial_engine` | BMW 801 D-2 | Engine | Fw 190 |
| `jumo_211_engine` | Junkers Jumo 211J | Engine | Ju 87, He 111 |
| `sc250_bomb_rack` | SC 250 Bomb Rack | MainWeapon | Stuka |
| `sc1000_bomb_rack` | SC 1000 Bomb Rack | MainWeapon | Ju 88 |

---

## Soviet Union (14 modules)

| ID | Name | Category | Notes |
|----|------|----------|-------|
| `45mm_m1937_gun` | 45 mm M1937 | MainWeapon | BT-7, T-26 |
| `76mm_f34_gun` | 76.2 mm F-34 | MainWeapon | T-34/76 |
| `85mm_d5t_gun` | 85 mm D-5T | MainWeapon | T-34/85 |
| `122mm_d25t_gun` | 122 mm D-25T | MainWeapon | IS-2 |
| `v2_diesel_engine` | V-2-34 Diesel | Engine | T-34 |
| `mikulin_v12_engine` | Mikulin V-12 | Engine | IS, KV |
| `t34_sloped_armor` | T-34 Sloped Armor | Armor | Sloped plates |
| `is2_heavy_armor` | IS-2 Heavy Armor | Armor | Heavy tank |
| `radio_71tk1` | 71-TK-1 Radio | Communications | Tank brigade |
| `shvak_20mm_cannon` | ShVAK 20mm | MainWeapon | La-5, Il-2 |
| `berezin_ub_gun` | Berezin UB | SecondaryWeapon | 12.7 mm |
| `klimov_m105_engine` | Klimov M-105 | Engine | Yak, MiG |
| `ash82_radial_engine` | Shvetsov ASh-82 | Engine | La-5/7 |
| `fab250_bomb_load` | FAB-250 Bomb Load | MainWeapon | Tactical |
| `fab500_bomb_load` | FAB-500 Bomb Load | MainWeapon | Heavy tactical |

---

## Japan (14 modules)

| ID | Name | Category | Notes |
|----|------|----------|-------|
| `type97_57mm_gun` | Type 97 57 mm | MainWeapon | Chi-Ha |
| `type1_47mm_gun` | Type 1 47 mm | MainWeapon | Chi-Ha Kai |
| `type3_75mm_gun` | Type 3 75 mm | MainWeapon | Chi-Nu |
| `type99_88mm_gun` | Type 99 88 mm | MainWeapon | Chi-Ri II |
| `mitsubishi_al_engine` | Mitsubishi AL Type | Engine | Chi-Ha diesel |
| `japanese_riveted_armor` | Japanese Riveted Armor | Armor | Light/medium |
| `type3_ku_radio` | Type 3 Ku Radio | Communications | IJA tanks |
| `type99_mk2_cannon` | Type 99 Mk II 20mm | MainWeapon | Zero |
| `type97_7_7mm_gun` | Type 97 7.7 mm | SecondaryWeapon | Early fighters |
| `sakae_radial_engine` | Sakae 21 Radial | Engine | A6M Zero |
| `kinsei_radial_engine` | Kinsei 51 Radial | Engine | Ki-61, D3A |
| `type99_800kg_bomb` | Type 99 800 kg Bomb | MainWeapon | Kate, Val |

---

## Italy (11 modules)

| ID | Name | Category | Notes |
|----|------|----------|-------|
| `47mm_ansaldo_gun` | 47 mm Ansaldo | MainWeapon | M13/40 |
| `75mm_ansaldo_l34_gun` | 75 mm Ansaldo L/34 | MainWeapon | P40 |
| `90mm_ansaldo_gun` | 90 mm Ansaldo L/53 | MainWeapon | P43 |
| `spa_diesel_v8_engine` | SPA 8T Diesel V-8 | Engine | M13/40 |
| `italian_riveted_armor` | Italian Riveted Armor | Armor | Thin plates |
| `rf2ca_radio` | RF 2CA Radio | Communications | Basic |
| `breda_safat_12_7mm` | Breda-SAFAT 12.7 mm | MainWeapon | C.200, SM.79 |
| `mauser_mg151_italy` | Mauser MG 151/20 (license) | MainWeapon | C.202/205 |
| `alfa_romeo_ra1000` | Alfa Romeo RA.1000 | Engine | C.202 Folgore |
| `ap50_bomb_load` | AP 50 Bomb Load | MainWeapon | Light tactical |

---

## France (10 modules)

| ID | Name | Category | Notes |
|----|------|----------|-------|
| `47mm_sa37_gun` | 47 mm SA 37 | MainWeapon | S35, B1 bis |
| `75mm_sa35_gun` | 75 mm SA 35 | MainWeapon | B1 hull howitzer |
| `75mm_sa44_gun` | 75 mm SA 44 | MainWeapon | Late medium |
| `renault_v6_engine` | Renault V-6 | Engine | B1, R35 |
| `french_cast_armor` | French Cast Armor | Armor | 1940 heavies |
| `er538_radio` | ER 538 Radio | Communications | 1940 standard |
| `hs404_20mm_cannon` | Hispano-Suiza HS.404 | MainWeapon | D.520 |
| `gnome_rhone_14n` | Gnome-Rhône 14N | Engine | D.520 |
| `french_250kg_bomb` | 250 kg Bomb Load | MainWeapon | LeO 451 |

---

## Multi-nation / utility (5 modules)

| ID | Name | Category | Notes |
|----|------|----------|-------|
| `coaxial_mg_mount` | Coaxial MG Mount | SecondaryWeapon | Generic tank |
| `hull_mg_mount` | Hull MG Mount | SecondaryWeapon | Bow MG |
| `extra_fuel_tanks` | Extra Fuel Tanks | ExtraFuel | Range vs fire risk |
| `nbc_protection_kit` | NBC Protection Kit | NBC_Protection | Late / alt scenarios |
| `recon_drone_pod` | Recon Drone Pod | DroneAttachment | Modern/alt (existing) |

---

## WWI · Major powers (land & air)

| Nation | Key module IDs |
|--------|----------------|
| **USA** | `m1897_75mm_field_gun`, `m1916_37mm_tank_gun`, `liberty_l12_engine`, `lewis_gun_mount` |
| **UK** | `qf_18pdr_field_gun`, `qf_13pdr_tank_gun`, `vickers_machine_gun`, `rolls_royce_eagle_engine` |
| **France** | `canet_75mm_coastal`, `sa_18_37mm_tank_gun`, `hispano_suiza_8a_engine` |
| **Germany** | `fk_96_77mm_field_gun`, `kwk_57mm_a7v_gun`, `mg08_machine_gun`, `spandau_lmg_08`, `mercedes_diii_engine` |
| **Russia** | `m1902_76mm_field_gun`, `m1910_122mm_howitzer` |
| **Austria-Hungary** | `skoda_75mm_m15`, `skoda_100mm_m14` |
| **Italy** | `ansaldo_65mm_mountain`, `fiat_revelli_mg` |
| **Belgium / Serbia** | `cockerill_47mm_gun`, `serbian_m1904_75mm` |
| **Ottoman** | `ottoman_mauser_rifle` |

---

## Minor & smaller nations (surplus / licensed tech)

| Nation | Key module IDs | Era |
|--------|----------------|-----|
| **Czechoslovakia** | `skoda_37mm_a7` | Interwar export |
| **Poland** | `polish_wz35_at`, `bofors_37mm_at` | 1939 |
| **Finland** | `finnish_20mm_l39` | Winter War |
| **Hungary** | `hungarian_40mm_zf2`, `fiat_spa_cv33_engine` | License |
| **Romania** | `romanian_r2_tank_gun`, `vz24_rifle_system` | Czech license |
| **Bulgaria** | `bulgarian_76mm_m1902` | WWI surplus |
| **Greece** | `greek_65mm_mountain` | Interwar |
| **Spain** | `spanish_47mm_saonica` | Civil War stock |
| **Portugal** | `portuguese_75mm_m1917` | Neutral |
| **Netherlands** | `dutch_47mm_kni`, `bofors_37mm_at` | 1940 |
| **Norway** | `norwegian_75mm_krupp` | Captured stocks |
| **Sweden** | `swedish_37mm_bofors_tank` | Neutral |
| **China** | `chinese_hanyang_rifle`, `vz24_rifle_system` | Warlord / export |

---

## Naval guns & systems

### Destroyer / escort (3–5 inch)
`ww1_4inch_qf_mk4`, `uk_4_7inch_qf`, `ger_10_5cm_tb`, `ijn_12_7cm_type89`, `us_5inch_38_gun`

### Light / heavy cruiser (6–8 inch)
`uk_6inch_bl_mk12`, `us_6inch_47_gun`, `uk_8inch_mk8`, `us_8inch_55_gun`, `ijn_8inch_type3`, `ger_15cm_tb`

### Battleship main (12–18 inch)
| Era | Guns |
|-----|------|
| **WWI** | `uk_12inch_mk10`, `uk_13_5inch_mk5`, `us_14inch_45_gun`, `ita_12inch_m1914` |
| **WWII** | `uk_14inch_mk7`, `uk_15inch_mk1`, `us_16inch_45_gun`, `us_16inch_50_gun`, `ger_11inch_skc34`, `ger_15inch_skc34`, `ijn_14inch_type94`, `ijn_18inch_type94`, `fra_13_4inch_m1934` |

### Torpedoes, ASW, fire control, armor
`mk15_torpedo_tube`, `type93_long_lance`, `g7a_torpedo`, `ww1_18inch_torpedo`, `submarine_torpedo_tube`, `depth_charge_rail`, `naval_fire_control_mk37`, `naval_radar_type22`, `naval_belt_armor_scheme`, `naval_deck_armor_scheme`

---

## Late WWII · Axis prototypes (defeated powers)

Germany paper/build-limited: `kwk_44_128mm_gun`, `maus_superheavy_armor`, `e50_standard_armor`, `kwk_43_l71_88_extended`, `hes_011_jet_prototype`, `ho229_flying_wing_airframe`, `wasserfall_sam_prototype`, `fg1250_infrared_scope`, `fritz_x_guided_bomb`

Japan late/paper: `type4_75mm_gun`, `type5_75mm_l70_gun`, `type5_chi_ri_armor`, `ne20_jet_engine`, `ohka_baka_bomb`, `i400_submarine_tube`

Italy paper: `p43_90mm_prototype`, `campini_caproni_motorjet`

## Cold War · 1948–1955

Tanks: `d10t_100mm_gun`, `t54_100mm_d10t2s`, `m58_120mm_gun`, `m68_105mm_gun`, `l7_105mm_rifled`, `qf_20pdr_gun`

Jets: `jumo_004_jet_engine`, `vk1_jet_engine`, `pratt_whitney_j57`, `m61_vulcan_pod`, `aden_30mm_revolver`

Naval: `us_5inch_54_mk42`, `mk35_torpedo`, `regulus_cruise_missile`, `us_3inch_70_mk26`

Electronics: `gun_stabilizer_m3`, `an_tps1_radar`, `reactive_armor_prototype`, `mark7_nuclear_gun`

---

## Unit templates

See **`data/unit_templates/UNIT_TEMPLATE_CATALOG.md`** for all 68 unit designs (WWII, WWI, interwar, naval, paper Axis, early Cold War).

Suggested pairings from the original design pass are now implemented as JSON templates.
