# Indice exhaustivo de codigo (Fase 0)

Fecha: 2026-06-12

Archivos en el repositorio (N): **5067** | Archivos procesados (M): **5067**

Metodo: cada archivo fue abierto y procesado integramente por el analizador
(conteo de lineas, simbolos con linea de inicio, dependencias, validez JSON,
referencias de escenas); los archivos criticos ademas se leyeron manualmente.

## Scripts GDScript (251)

### `epochs-of-ascendancy/scripts/agents/Agent.gd` (120 lineas)
- class_name: `Agent` (linea 2)
- extends: `Resource` (linea 3)
- funciones (8): `get_skill`:41, `is_available`:57, `is_inactive`:61, `get_status_group`:65, `is_on_mission`:77, `is_compromised`:81, `add_experience`:85, `get_success_chance_for_mission`:99

### `epochs-of-ascendancy/scripts/agents/AgentGenerator.gd` (57 lineas)
- class_name: `AgentGenerator` (linea 2)
- extends: `Node` (linea 3)
- funciones (2): `generate_agent`:16, `_generate_name`:53

### `epochs-of-ascendancy/scripts/agents/AgentManager.gd` (1502 lineas)
- extends: `Node` (linea 2)
- senales: `agent_recruited`:6, `agent_assigned_to_mission`:7, `mission_completed`:8, `agent_captured`:9, `agent_killed`:10
- funciones (67): `_ready`:42, `_on_game_year_advanced`:65, `_on_game_day_advanced`:75, `_load_mission_definitions`:81, `get_agents_for_country`:99, `get_agent`:104, `recruit_agent`:112, `assign_agent_to_mission`:126, `_mission_allows_home_target`:184, `advance_missions`:188, `_resolve_mission`:204, `_apply_mission_outcome`:254, `set_current_year`:310, `get_current_year`:314, `get_available_agents`:318, `get_mission_definition`:326, `get_network`:332, `get_networks_for_country`:336, `establish_network`:345, `advance_networks`:374, `advance_networks_daily`:393, `_process_network_action`:428, `_process_network_action_daily`:471, `_apply_daily_network_province_effects`:550, `_estimate_enemy_pressure`:617, `get_supply_disruption_in_province`:625, `_handle_network_detection`:632, `get_target_countries_for`:655, `get_mission_categories`:664, `get_eligible_missions_for_agent`:679, `get_agent_screen_data`:719, `invalidate_agent_cache`:728, `get_agent_summary`:735, `_build_agent_screen_data`:742, `_agent_to_summary`:773, `_mission_row_for_agent`:839, `clear_all_agents`:860, `_reset_agent_after_mission`:866, `_handle_post_mission_risk`:876, `_set_agent_compromised`:904, `_release_expired_compromised_agents`:913, `get_recent_operations`:926, `describe_mission_outcome`:978, `_append_mission_history`:982, `_agent_fate_after_mission`:1028, `_format_history_status_line`:1036, `_status_badge_for`:1050, `_recovery_years_remaining`:1066, `_format_agent_status_detail`:1072, `get_intel_reports`:1094, `_intel_tier_label`:1115, `_apply_production_delay`:1127, `_apply_supply_disruption`:1183, `_calculate_sabotage_effect`:1212, `_apply_sabotage_production_debuff`:1246, `_apply_sabotage_supply_debuff`:1277, `_apply_stability_damage`:1307, `_apply_research_theft`:1321, `_establish_long_term_tech_intel`:1358, `_apply_intel_bonus`:1374, `_record_intelligence`:1381, `get_intel_for_country`:1394, `get_intelligence_modifier`:1405, `consume_intel`:1419, `_apply_enemy_agent_disruption`:1435, `_degrade_enemy_intel`:1483, `_apply_tech_protection`:1490
- anomalias: [TODO_FIXME] linea 458: # TODO: Apply actual province-level supply penalty here (reduce throug; [TODO_FIXME] linea 503: # TODO: Apply actual small daily province supply impact here

### `epochs-of-ascendancy/scripts/agents/AgentMissionImpact.gd` (92 lineas)
- class_name: `AgentMissionImpact` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (5): `describe_outcome_result`:8, `describe_mission_outcome`:39, `get_impact_preview`:49, `format_compact_preview`:57, `_format_effect_label`:68

### `epochs-of-ascendancy/scripts/agents/AgentNetwork.gd` (38 lineas)
- class_name: `AgentNetwork` (linea 5)
- extends: `Resource` (linea 6)
- funciones (2): `get_effectiveness`:29, `is_active`:36

### `epochs-of-ascendancy/scripts/autoload/GameData.gd` (18 lineas)
- extends: `Node` (linea 1)
- funciones (3): `_ready`:8, `create_production_line`:12, `get_production_line`:16

### `epochs-of-ascendancy/scripts/autoload/ProductionManager.gd` (1661 lineas)
- extends: `Node` (linea 1)
- senales: `line_registered`:7, `line_removed`:8, `stance_changed`:9, `modifier_registered`:10, `modifier_removed`:11, `day_advanced`:12, `family_experience_changed`:13, `production_completed`:14, `production_progress_updated`:15, `production_resource_shortage`:16, `equipment_added_to_stockpile`:17, `equipment_taken_from_stockpile`:18, `unit_reinforced`:19
- funciones (118): `_ready`:55, `_get_base_daily_points`:70, `_load_retooling_rules`:74, `get_category_similarity`:91, `get_retooling_params`:103, `_retool_group_for_design`:138, `create_line`:144, `remove_line`:160, `get_line`:168, `get_line_ids`:172, `has_line`:179, `set_line_template`:183, `advance_days`:229, `register_modifier`:248, `unregister_modifier`:256, `clear_modifiers_by_source`:263, `set_production_stance`:273, `apply_doctrine`:290, `revoke_doctrine`:299, `apply_focus`:306, `revoke_focus`:315, `get_family_units_produced`:322, `get_active_modifier_ids`:326, `set_stockpile`:333, `add_stockpile`:337, `can_afford`:342, `pay_cost`:349, `add_to_national_stockpile`:360, `take_from_national_stockpile`:369, `get_national_stockpile_amount`:383, `set_national_equipment_stockpile`:387, `get_national_equipment_stockpile`:395, `_on_production_completed`:399, `set_unit_equipment_stock`:407, `get_unit_equipment_stock`:413, `clear_unit_equipment_stock`:420, `get_division_required_equipment`:424, `get_unit_shortages`:435, `get_unit_shortage_report_with_national`:450, `get_unit_readiness_penalty`:458, `get_shortage_report`:463, `_categorize_equipment_shortages`:476, `_is_sustainment_equipment_id`:495, `_is_infantry_equipment_id`:503, `apply_equipment_shortage_modifiers`:511, `get_division_sustainment_readiness_multiplier`:523, `get_division_infantry_stats`:535, `get_division_infantry_combat_multiplier`:547, `get_division_combat_modifiers`:555, `get_division_final_combat_stats`:567, `request_equipment_for_unit`:588, `set_unit_priority_reinforcement`:597, `is_unit_priority_reinforced`:606, `auto_reinforce_unit_from_stockpile`:610, `reinforce_all_units`:638, `daily_reinforcement_tick`:666, `get_line_resource_cost_for_days`:670, `get_design_resource_preview`:680, `has_enough_resources_for_line`:692, `apply_resource_shortage`:696, `_shortage_rules`:705, `_critical_resource_set`:710, `_weighted_fill_ratio`:719, `_shortage_multipliers`:740, `_missing_resources`:761, `evaluate_line_resources`:772, `try_consume_resources_for_line`:820, `consume_resources_for_line`:824, `preview_resource_fill_ratio`:828, `get_line_reliability_profile`:838, `list_line_refinement_options`:845, `start_line_refinement`:852, `_refresh_line_modifiers`:878, `_resolve_modifiers_for_line`:882, `_compute_family_output_bonus`:913, `_compute_cross_line_synergy`:921, `_compute_time_on_design_bonus`:929, `_count_active_lines_for_family`:937, `_same_family_retool_discount`:947, `_template_design_family`:957, `_get_line_owner_tag`:962, `_get_national_production_modifiers`:971, `_on_line_unit_completed`:1001, `_load_modifier_presets`:1016, `_preset_block`:1024, `_load_json_dict`:1029, `_naval_production_allowed`:1042, `_clear_modifiers_with_tag`:1059, `get_line_efficiency`:1069, `get_lines_on_design_in_factory`:1076, `get_concentrated_production_multiplier`:1091, `assign_line_to_factory`:1105, `get_factory_efficiency`:1155, `get_factories_producing`:1161, `get_total_output_for_design`:1172, `get_all_factories_for_country`:1182, `get_factory_summary`:1193, `get_country_production_overview`:1219, `get_factories_producing_design`:1232, `get_production_screen_data`:1239, `invalidate_production_cache`:1248, `clear_all_production_caches`:1252, `clear_all_caches`:1257, `_build_production_screen_data`:1264, `_get_factory_status`:1332, `_get_factory_type`:1340, `_append_to_group`:1359, `reassign_factory`:1365, `get_concentration_bonus`:1447, `get_effective_daily_output`:1456, `get_design_production_info`:1461, `get_save_data`:1494, `apply_save_data`:1524, `daily_production_tick`:1565, `_on_game_day_advanced`:1571, `advance_production`:1575, `_complete_item`:1621, `get_line_progress_info`:1627

### `epochs-of-ascendancy/scripts/autoload/SaveLoadManager.gd` (847 lineas)
- extends: `Node` (linea 135)
- funciones (38): `_ready`:144, `_on_year_advanced_for_autosave`:153, `_notification`:164, `_ensure_save_dir`:178, `get_save_path`:184, `list_saves`:198, `_peek_metadata`:221, `save_game`:235, `load_game`:259, `_find_scenario_loader`:295, `_gather_save_data`:303, `_apply_save_data`:396, `_apply_time_state`:445, `_serialize_agent_state`:461, `_agent_to_dict`:480, `_dict_to_agent`:491, `_network_to_dict`:522, `_dict_to_network`:532, `_apply_agent_state`:552, `_serialize_map_state`:581, `_apply_map_state`:602, `_serialize_supply_state`:628, `_apply_supply_state`:645, `_apply_national_modifier_state`:663, `_apply_technology_state`:672, `quicksave`:693, `quickload`:696, `get_last_save_path`:699, `get_saved_scenario_id`:705, `check_scenario_compatibility`:711, `_apply_leader_state`:725, `_apply_factory_state`:732, `_apply_production_state`:738, `_migrate_save_data`:749, `save_game_detailed`:766, `load_game_detailed`:786, `delete_save`:817, `rename_save`:828

### `epochs-of-ascendancy/scripts/autoload/TimeManager.gd` (281 lineas)
- extends: `Node` (linea 40)
- senales: `game_year_advanced`:52, `game_month_advanced`:53, `game_day_advanced`:54
- funciones (22): `_ready`:69, `initialize_from_scenario_start_date`:74, `get_current_year`:99, `get_current_month`:102, `get_current_day`:105, `is_new_day`:110, `advance_one_day`:114, `is_new_month`:119, `advance_one_month`:124, `get_current_date`:128, `get_scenario_start_date`:136, `is_paused`:139, `set_paused`:142, `set_time_scale`:147, `advance_one_year`:152, `advance_year`:158, `sync_year_from_external`:177, `advance_days`:187, `advance_real_time`:239, `_get_days_in_month`:248, `get_save_data`:259, `apply_save_data`:269

### `epochs-of-ascendancy/scripts/combat/CombatResolver.gd` (596 lineas)
- class_name: `CombatResolver` (linea 1)
- extends: `Node` (linea 2)
- funciones (19): `get_effective_combat_power`:7, `apply_training_path_combat_bonuses`:161, `apply_training_path_modifiers`:186, `resolve_combat_experience`:239, `resolve_battle_aftermath`:250, `resolve_formation_destroyed`:313, `get_combat_width_for_battle`:319, `get_province_battle_preview`:375, `_find_scenario_loader`:381, `_get_province_safe`:395, `_get_province_casualty_multiplier`:409, `_get_effects_for_province`:429, `award_xp_from_combat`:446, `_apply_combat_xp_to_leader`:464, `_total_combat_xp_for_leader`:477, `_calculate_combat_xp`:488, `_get_defeat_learning_bonus`:524, `_normalize_battle_result`:542, `_apply_national_combat_modifiers_to_base_stats`:563

### `epochs-of-ascendancy/scripts/combat/CombatWidthCalculator.gd` (67 lineas)
- class_name: `CombatWidthCalculator` (linea 2)
- extends: `Node` (linea 3)
- funciones (8): `_ready`:10, `ensure_rules_loaded`:14, `_load_rules`:20, `get_combat_width`:36, `get_effective_combat_width`:44, `_get_infrastructure_modifier`:50, `get_terrain_width_modifier`:58, `_get_terrain_modifier`:62

### `epochs-of-ascendancy/scripts/core/DesignDataLoader.gd` (161 lineas)
- class_name: `DesignDataLoader` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (14): `load_all`:15, `load_modules`:22, `load_templates`:27, `load_production_rules`:32, `get_module`:40, `get_template`:44, `get_infantry_equipment`:48, `load_sustainment_equipment`:57, `get_sustainment_equipment`:76, `get_refinement_project_defs`:92, `get_refinement_def`:97, `_load_json_objects_from_dir`:104, `_load_json_objects_from_dir_recursive`:110, `_load_json_dict`:146

### `epochs-of-ascendancy/scripts/core/HeadlessProductionTest.gd` (13 lineas)
- extends: `SceneTree` (linea 1)
- funciones (1): `_init`:7

### `epochs-of-ascendancy/scripts/core/HeadlessSupplyTest.gd` (12 lineas)
- extends: `SceneTree` (linea 1)
- funciones (1): `_init`:4
- dependencias: `res://scripts/core/ScenarioLoader.gd`:5, `res://scripts/core/SupplyLineTest.gd`:8

### `epochs-of-ascendancy/scripts/core/HeadlessTradeTest.gd` (70 lineas)
- extends: `SceneTree` (linea 3)
- funciones (3): `_init`:8, `_fail`:19, `_run`:24
- dependencias: `res://scripts/national/TradeManager.gd`:5

### `epochs-of-ascendancy/scripts/core/ProductionLineTest.gd` (1484 lineas)
- class_name: `ProductionLineTest` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (23): `run_all`:7, `_get_production_manager`:32, `_test_production_manager`:39, `_test_data_loaded`:75, `_test_retooling_similarity`:86, `_test_production_and_tooling`:101, `_test_new_design_reliability_debuff`:119, `_test_refinement`:141, `_test_cargo_logistics`:158, `_test_armed_cargo_penalty`:185, `_test_armed_merchant_template`:220, `_test_equipment_shortages`:251, `_test_national_equipment_stockpile`:288, `_test_infantry_equipment_stats`:333, `_test_priority_reinforcement`:380, `_test_sustainment_equipment`:421, `_test_combat_resolver`:511, `_test_combat_width`:673, `_test_formation_spawner`:706, `_test_leader_manager`:766, `_test_assignment_screen_backends`:1344, `_cleanup_test_factory`:1455, `_test_refinement_tradeoffs`:1465

### `epochs-of-ascendancy/scripts/core/ScenarioLoader.gd` (671 lineas)
- class_name: `ScenarioLoader` (linea 1)
- extends: `Node` (linea 2)
- senales: `scenario_loaded`:24
- funciones (38): `get_current_scenario_name`:26, `_ready`:29, `load_province_geometry`:34, `load_province_layers`:73, `_load_json_dict`:82, `_load_adjacency_layer`:98, `_load_terrain_layer`:105, `_load_city_layer`:112, `_load_resources_layer`:119, `_load_economy_layer`:126, `_load_state_and_region_layers`:133, `_load_project_sites_layer`:160, `load_base_provinces`:176, `load_scenario`:221, `_spawn_scenario_factories`:316, `_parse_scenario_start_year`:321, `_load_scenario_leaders`:329, `_apply_scenario_starting_technology`:344, `_spawn_scenario_formations`:353, `_get_formation_spawn_countries`:368, `_get_formation_counts_for_scenario`:378, `get_country`:392, `get_map_data`:396, `_load_countries_from_scenario`:400, `_make_country_entry`:429, `_storage_tag_for_country`:446, `_parse_country_color`:455, `build_geometry_dict_for_map`:481, `_infer_port_access_for_all`:507, `_rebuild_adjacency_system`:523, `get_city_layer`:532, `get_city_count`:536, `_duplicate_province_from_base`:547, `_string_array_from_json`:570, `_merged_special_features_from`:579, `_special_level_coerce`:602, `_apply_geometry_to_province`:614, `_apply_layer_data_to_province`:642

### `epochs-of-ascendancy/scripts/core/SupplyLineTest.gd` (210 lineas)
- class_name: `SupplyLineTest` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (10): `run_all`:5, `_rules_and_adjacency`:17, `_test_hubs_built`:28, `_province_tag`:38, `_test_route_timing`:44, `_test_reroute_longer`:77, `_test_unit_supply_profile`:124, `_test_intel_from_forces`:141, `_test_multimodal_routing`:162, `_test_attrition_cargo`:201
- dependencias: `res://scripts/supply/SupplyManager.gd`:147

### `epochs-of-ascendancy/scripts/core/TestRunner.gd` (91 lineas)
- extends: `Node` (linea 2)
- funciones (5): `_ready`:11, `_resolve_player_tag`:60, `_configure_top_info_bar`:72, `_wire_factory_province_lookup`:78, `_run_production_line_tests`:87

### `epochs-of-ascendancy/scripts/data/AdjacencySystem.gd` (320 lineas)
- class_name: `AdjacencySystem` (linea 5)
- extends: `RefCounted` (linea 6)
- funciones (21): `load_adjacency`:25, `register_province`:70, `begin_bulk_registration`:78, `end_bulk_registration`:82, `get_neighbors`:88, `get_land_neighbors`:95, `get_sea_neighbors`:103, `are_adjacent`:111, `shortest_path`:119, `get_connected_component`:128, `_shortest_path_bfs`:149, `_shortest_path_dijkstra`:172, `_reconstruct_path`:205, `_edge_movement_cost`:222, `_undirected_key`:230, `_movement_neighbors_packed`:236, `_invalidate_neighbor_caches`:248, `_ensure_neighbor_caches`:254, `_packed32_to_array_int`:276, `_packed_has_neighbor`:284, `_load_straits_from_root`:292

### `epochs-of-ascendancy/scripts/data/Country.gd` (17 lineas)
- class_name: `Country` (linea 2)
- extends: `Resource` (linea 3)
- funciones (1): `get_color`:15

### `epochs-of-ascendancy/scripts/data/EquipmentModule.gd` (56 lineas)
- class_name: `EquipmentModule` (linea 1)
- extends: `Resource` (linea 2)
- funciones (3): `from_dict`:22, `_dict_from_variant`:43, `_string_array`:49

### `epochs-of-ascendancy/scripts/data/MapScenarioData.gd` (41 lineas)
- class_name: `MapScenarioData` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (3): `coerce_countries`:12, `coerce_provinces`:22, `_init`:31

### `epochs-of-ascendancy/scripts/data/Province.gd` (172 lineas)
- class_name: `Province` (linea 2)
- extends: `Resource` (linea 3)
- funciones (14): `get_movement_cost`:41, `resolve_has_port`:52, `has_feature`:67, `get_feature_level`:71, `_resolved_feature_key`:87, `get_supply_throughput_modifier`:105, `get_local_supply_generation_modifier`:110, `get_combat_width_modifier`:115, `get_organization_recovery_modifier`:121, `get_reinforcement_speed_modifier`:127, `get_attrition_modifier`:132, `get_logistics_quality`:138, `get_interdiction_resistance_modifier`:145, `_base_terrain_movement_multiplier`:152

### `epochs-of-ascendancy/scripts/data/UnitTemplate.gd` (242 lineas)
- class_name: `UnitTemplate` (linea 1)
- extends: `Resource` (linea 2)
- funciones (22): `get_module_ids`:58, `count_filled_slots`:67, `get_base_reliability`:71, `get_stat`:75, `get_fuel_consumption`:79, `get_supply_need`:83, `get_daily_supply_draw`:88, `from_dict`:93, `_parse_infantry_equipment_stats`:150, `get_required_equipment`:158, `is_infantry_equipment`:162, `get_infantry_equipment_stats`:171, `get_infantry_stats`:175, `get_infantry_generation_multiplier`:186, `get_daily_resource_cost_dict`:190, `get_production_point_cost`:196, `get_production_cost_breakdown`:203, `get_inferred_production_category`:210, `get_inferred_production_era`:216, `_dict_from_variant`:220, `_float_dict_from_variant`:226, `_string_array`:235

### `epochs-of-ascendancy/scripts/formations/Formation.gd` (76 lineas)
- class_name: `Formation` (linea 2)
- extends: `Resource` (linea 3)
- funciones (5): `has_leader`:36, `assign_leader`:40, `remove_leader`:48, `get_category`:53, `from_division_template`:65

### `epochs-of-ascendancy/scripts/formations/FormationSpawner.gd` (42 lineas)
- class_name: `FormationSpawner` (linea 2)
- extends: `Node` (linea 3)
- funciones (1): `spawn_test_formations_for_country`:15

### `epochs-of-ascendancy/scripts/leaders/Leader.gd` (243 lineas)
- class_name: `Leader` (linea 2)
- extends: `Resource` (linea 3)
- funciones (29): `add_experience`:51, `get_experience`:63, `has_enough_experience`:67, `spend_experience`:71, `add_trait_unchecked`:80, `add_trait`:88, `has_trait`:97, `is_available_for_command`:101, `is_assigned_to_training`:110, `is_in_combat_role`:114, `get_trait_level`:118, `_get_trait_effects`:124, `_effect_float`:130, `_effective_skill`:134, `get_attack_modifier`:138, `get_defense_modifier`:148, `get_organization_modifier`:154, `get_logistics_modifier`:161, `get_planning_modifier`:169, `get_initiative_modifier`:173, `get_supply_consumption_modifier`:177, `get_breakthrough_modifier`:181, `get_combat_width_modifier`:185, `get_casualties_modifier`:189, `get_terrain_modifier`:195, `has_training_path`:220, `get_training_path_level`:224, `set_training_path`:228, `clear_training_path`:241

### `epochs-of-ascendancy/scripts/leaders/LeaderGenerator.gd` (101 lineas)
- class_name: `LeaderGenerator` (linea 2)
- extends: `Node` (linea 3)
- funciones (4): `create_leader_from_data`:15, `_apply_traits_from_data`:53, `generate_leader`:72, `_generate_name`:99

### `epochs-of-ascendancy/scripts/leaders/LeaderManager.gd` (3541 lineas)
- extends: `Node` (linea 2)
- senales: `leader_died`:6, `leader_captured`:7, `leader_retirement_offered`:8, `leader_retired`:9, `leader_introduced`:10, `game_year_advanced`:11, `leader_experience_gained`:12, `trait_leveled`:13, `training_path_invested`:14, `training_path_switched`:15, `officer_training_quality_notice`:16, `leader_replacement_needed`:17, `leader_replacement_resolved`:18
- funciones (209): `_apply_national_position_cost`:69, `_ready`:189, `register_leader`:200, `assign_leader_to_army`:208, `unassign_leader_from_army`:221, `get_leader`:230, `get_leader_for_army`:234, `register_formation`:248, `get_formation`:256, `get_formations_for_country`:260, `assign_leader_to_formation`:269, `unassign_leader_from_formation`:295, `register_division_formations_for_country`:308, `clear_all_formations`:331, `get_available_formations`:336, `_unassign_leader_from_current_formation`:360, `_is_leader_valid_for_formation`:369, `_infer_division_country_tag`:383, `get_valid_leader_types_for_position`:404, `can_assign_national_position`:420, `set_country_position`:464, `get_country_position_leader`:505, `get_national_bonuses`:515, `get_national_combat_modifiers`:549, `_get_combined_national_combat_modifiers`:575, `get_leaders_for_country`:596, `get_available_leaders`:608, `get_current_year`:623, `set_current_year`:630, `get_leader_age`:638, `get_pool_leader_count`:650, `is_leader_entry_active_for_year`:662, `get_yearly_death_chance`:672, `get_yearly_retirement_chance`:684, `_base_chance_for_age`:695, `get_combat_death_chance_per_battle`:702, `get_formation_destroyed_fate_chance`:712, `roll_combat_battle_casualty`:724, `handle_formation_destroyed`:745, `_combat_casualty_trait_multiplier`:793, `_mortality_situation_multiplier`:806, `check_leader_mortality`:827, `resolve_retirement`:854, `apply_retirement_honors`:885, `get_national_prestige`:896, `get_national_unity`:900, `advance_game_year`:904, `introduce_eligible_leaders_for_year`:925, `_remove_leader`:947, `set_player_country_tag`:971, `get_player_country_tag`:977, `is_player_country`:985, `get_pending_replacement_count`:989, `get_pending_leader_replacements`:993, `_prune_stale_leader_replacement_requests`:1004, `get_leader_replacement_request`:1011, `dismiss_leader_replacement`:1018, `get_replacement_candidates`:1022, `pick_auto_replacement_leader`:1052, `apply_auto_replacement`:1056, `try_instant_player_replacement`:1067, `resolve_leader_replacement`:1084, `_enqueue_leader_replacement_requests`:1123, `_build_replacement_request`:1161, `_enqueue_formation_command_vacancy`:1187, `_push_leader_replacement_request`:1217, `_is_replacement_request_still_valid`:1233, `_auto_resolve_replacement_for_ai`:1253, `_remove_leader_replacement_request`:1260, `_pick_auto_replacement_leader_id`:1267, `_is_leader_eligible_replacement`:1285, `_score_replacement_candidate`:1307, `_valid_leader_types_for_formation`:1324, `_position_display_label`:1338, `_clear_leader_from_national_positions`:1354, `_apply_officer_training_death_debuff`:1369, `get_armies_without_leader`:1388, `get_leader_summary`:1393, `get_country_leader_overview`:1435, `get_leader_screen_data`:1453, `invalidate_leader_cache`:1462, `clear_all_leader_caches`:1466, `_build_leader_screen_data`:1470, `_get_skill_tier`:1536, `_get_leader_type_name`:1553, `_append_leader_to_group`:1567, `award_xp_to_leader`:1575, `award_xp_to_formation_leaders`:1589, `get_passive_xp_for_leader`:1598, `process_passive_xp`:1620, `calculate_combat_xp_from_result`:1628, `award_combat_xp`:1641, `process_weekly_leader_xp`:1655, `award_battle_xp_to_participants`:1680, `get_leader_id_for_army`:1695, `set_country_at_war`:1702, `award_major_victory_xp`:1708, `award_high_risk_operation_xp`:1712, `get_trait_level`:1721, `get_trait_data`:1729, `get_trait_level_cost`:1734, `can_level_trait`:1742, `level_trait`:1764, `_level_trait_once`:1773, `get_available_training_paths`:1801, `get_leader_training_path_level`:1834, `invest_xp_in_training_path`:1844, `switch_training_path`:1872, `leader_has_training_path`:1906, `get_training_path_definition`:1913, `get_training_path_max_level`:1917, `get_training_path_doctrine_requirement`:1924, `get_training_path_effects_at_level`:1929, `get_leader_training_path_effects`:1933, `get_leader_training_path_combat_modifiers`:1954, `get_leader_final_combat_stats`:1975, `get_leader_training_path_supply_modifiers`:1989, `resolve_leader_id_for_formation`:2012, `apply_supply_consumption_for_leader`:2021, `apply_attrition_for_leader`:2029, `apply_reinforcement_rate_for_leader`:2037, `apply_training_path_supply_to_stats`:2045, `get_training_path_reinforcement_multiplier`:2072, `get_training_path_data`:2076, `get_training_path_level_cost`:2080, `get_training_path_switch_cost`:2085, `can_invest_training_path`:2093, `can_switch_training_path`:2106, `get_leader_training_path_state`:2122, `get_available_training_paths_for_leader`:2133, `get_leader_training_path_summary`:2158, `_load_training_paths`:2189, `_get_training_path_data`:2219, `_get_training_path_effects`:2227, `_country_has_doctrine`:2243, `_load_training_path_definitions`:2251, `get_country_military_doctrines`:2255, `set_country_military_doctrine`:2270, `country_has_military_doctrine`:2284, `leader_meets_training_path_doctrine`:2288, `get_leader_trait_display_data`:2299, `get_potential_traits_for_leader`:2342, `_get_unlock_reason`:2366, `award_battle_experience`:2384, `award_combat_experience_for_army`:2389, `get_trait_level_up_cost`:2399, `can_spend_xp_on_trait`:2407, `spend_xp_on_trait`:2422, `get_trait_display_list`:2439, `format_trait_effects_text`:2448, `_format_effect_label`:2459, `_format_effect_value`:2517, `_check_for_trait_gain`:2529, `handle_injury_or_capture`:2540, `promote_leader`:2556, `create_and_register_new_leader`:2570, `set_officer_training_leader`:2583, `get_officer_training_leader`:2627, `clear_officer_training_leader`:2645, `get_save_data`:2664, `apply_save_data`:2680, `assign_leader_to_officer_training`:2742, `unassign_officer_training_leader`:2750, `get_officer_training_quality`:2765, `get_officer_training_months`:2770, `get_officer_training_debuff_months`:2776, `get_officer_training_cadet_prestige_cost`:2783, `get_officer_training_quality_display`:2792, `get_officer_training_status_text`:2818, `get_officer_training_suitability`:2838, `advance_officer_training_progress`:2865, `_advance_officer_training_progress_for_country`:2886, `_check_training_quality_changes`:2926, `generate_new_leader_from_training`:2949, `_get_effective_officer_training_quality`:2977, `_pick_officer_cadet_leader_type`:2985, `_country_has_naval_technology`:2999, `_country_has_air_technology`:3007, `_generate_officer_cadet_name`:3015, `_officer_cadet_rank_prefix`:3118, `_roll_officer_cadet_skills`:3130, `_apply_officer_cadet_trait_inheritance`:3162, `_get_positive_traits`:3185, `_get_negative_traits`:3197, `_is_officer_training_flaw_trait`:3209, `generate_and_register_leader_from_training`:3215, `get_trait_definition`:3237, `get_trait_max_level`:3244, `get_trait_rarity`:3251, `get_trait_effects_at_level`:3256, `get_leader_trait_effects`:3273, `count_traits_by_rarity`:3286, `traits_conflict`:3294, `can_add_trait`:3314, `try_add_trait_to_leader`:3335, `_load_trait_definitions`:3350, `_read_trait_json_file`:3356, `get_leader_roster_paths_for_scenario`:3369, `get_leaders_path_for_scenario`:3386, `load_leaders_for_scenario`:3393, `reload_leaders_from_json`:3400, `reload_leaders_from_roster_paths`:3406, `_roster_paths_are_modern_isolated`:3468, `_leader_entry_valid_for_modern_roster`:3472, `_load_leader_entries_from_path`:3482, `load_leaders_from_json`:3502, `load_historical_leaders`:3508, `_historical_leader_entries_from_data`:3515, `_leader_from_dict`:3536
- anomalias: [TODO_FIXME] linea 3000: # TODO: Replace with national naval technology/focus unlock checks whe; [TODO_FIXME] linea 3008: # TODO: Replace with national air technology/focus unlock checks when ; [TODO_FIXME] linea 3017: # TODO: Proper per-country/culture name lists for generated leaders (s

### `epochs-of-ascendancy/scripts/map/AgentNetworkLayer.gd` (396 lineas)
- class_name: `AgentNetworkLayer` (linea 4)
- extends: `Node` (linea 5)
- funciones (15): `_ready`:28, `setup`:39, `set_highlight_province`:43, `trigger_daily_pulse`:50, `is_daily_pulse_active`:57, `_process`:61, `_on_province_data_changed`:79, `_on_daily_tick`:84, `count_active_networks`:88, `_get_camera_world_rect`:107, `_draw`:127, `_enemy_pressure`:193, `_draw_pressure_status_bars`:206, `_draw_pressure_glyph`:259, `_draw_network_ring`:291

### `epochs-of-ascendancy/scripts/map/CameraController.gd` (136 lineas)
- class_name: `CameraController` (linea 3)
- extends: `Node` (linea 4)
- funciones (8): `_ready`:24, `_process`:34, `_apply_wasd`:59, `_apply_edge_pan`:74, `_input`:95, `_unhandled_input`:108, `_zoom_toward_mouse`:124, `_adjust_origin_for_uniform_zoom`:132

### `epochs-of-ascendancy/scripts/map/ConflictOverlayLayer.gd` (199 lineas)
- class_name: `ConflictOverlayLayer` (linea 5)
- extends: `Node` (linea 6)
- funciones (16): `set_highlight_province`:22, `setup`:29, `setup_with_map`:36, `_ready`:46, `_on_province_data_changed`:53, `refresh`:58, `_is_contested`:62, `count_contested`:68, `_draw`:79, `_collect_contested`:85, `_draw_contested_province`:112, `_province_node_offset`:136, `_polygon_points_for`:145, `_offset_points`:158, `_draw_polygon_hatch`:168, `_draw_centroid_hatch`:188

### `epochs-of-ascendancy/scripts/map/Factory.gd` (188 lineas)
- class_name: `Factory` (linea 2)
- extends: `Resource` (linea 3)
- funciones (17): `make_id`:40, `province_from_id`:44, `slot_from_id`:49, `apply_damage`:53, `start_repair`:58, `advance_repair`:62, `get_daily_output_estimate`:83, `get_production_efficiency`:88, `start_retooling`:92, `get_current_efficiency`:112, `advance_retooling`:126, `get_available_line_slots`:146, `can_add_more_lines`:150, `has_assigned_line`:154, `sync_production_design`:158, `_recalculate_efficiency`:162, `_get_rules`:174

### `epochs-of-ascendancy/scripts/map/MapManager.gd` (798 lineas)
- extends: `Node` (linea 12)
- senales: `scenario_map_ready`:22, `provinces_loaded`:23, `province_hovered`:24, `province_selected`:25, `province_data_changed`:26
- funciones (63): `_ready`:44, `_connect_to_scenario_loader`:53, `_on_scenario_loaded`:62, `_pull_from_loader`:67, `initialize_from_map_data`:74, `has_province_data`:98, `get_province`:101, `get_all_provinces`:104, `get_province_geometry`:107, `get_adjacency_system`:110, `get_country`:113, `get_player_country_tag_fallback`:118, `get_province_effects`:126, `get_effective_interdiction_resistance`:142, `get_effective_reinforcement_speed`:146, `get_effective_organization_recovery`:150, `get_effective_attrition_multiplier`:154, `get_effective_logistics_quality`:158, `get_province_or_null`:164, `force_initialize`:168, `get_provinces_by_owner`:176, `get_provinces_by_controller`:187, `get_adjacent_provinces`:201, `get_provinces_in_rect`:210, `get_province_centroid`:224, `get_all_centroids`:227, `get_world_bounds`:231, `get_province_at_world_pos`:239, `get_province_at_screen_pos`:256, `get_nearest_provinces`:263, `get_province_at_mouse`:282, `get_provinces_with_feature`:290, `get_provinces_by_terrain`:298, `get_centroids_in_rect`:308, `get_overlay_data_for_province`:319, `get_contested_provinces`:343, `get_agent_pressure_map`:362, `get_agent_network_overlay_data`:386, `update_province_owner`:411, `update_province_development`:436, `update_province_infrastructure`:446, `notify_province_changed`:457, `clear_daily_sabotage_effects`:466, `_on_game_day_advanced`:490, `advance_daily_infrastructure_repair`:503, `get_infrastructure_repair_breakdown`:538, `get_infrastructure_repair_rate`:598, `get_engineer_brigades_in_province`:602, `_repair_country_tag`:622, `_engineer_repair_bonus`:631, `_depot_sabotage_level`:641, `_province_under_infra_sabotage`:650, `_clear_internal_caches`:665, `_recompute_centroids_and_bounds`:677, `_aabb_from_points`:722, `_compute_centroid`:736, `_try_build_pick_grid`:763, `get_province_count`:771, `is_ready`:774, `has_pick_grid`:777, `rebuild_pick_grid`:782, `configure_picker`:788, `is_spatial_picking_available`:796

### `epochs-of-ascendancy/scripts/map/MapPickGrid.gd` (283 lineas)
- class_name: `MapPickGrid` (linea 24)
- extends: `RefCounted` (linea 25)
- funciones (18): `build`:50, `clear`:76, `is_built`:85, `get_province_at`:92, `get_nearest_provinces`:142, `_world_to_cell`:168, `_add_to_cell`:171, `_get_cells_in_radius`:176, `_update_bounds`:183, `_brute_force_best_in_candidates`:202, `_point_in_polygon`:222, `get_cell_count`:240, `get_province_count`:243, `get_cell_for_world_pos`:246, `debug_get_ids_in_cell`:249, `get_grid_stats`:253, `debug_get_candidates_around`:264, `_approx_polygon_area`:274

### `epochs-of-ascendancy/scripts/map/MapRenderer.gd` (2169 lineas)
- class_name: `MapRenderer` (linea 2)
- extends: `Node` (linea 3)
- funciones (102): `_ready`:128, `_init_legend_calendar_tracking`:157, `_connect_map_manager_signals`:165, `_on_map_province_data_changed`:172, `_connect_time_manager_signals`:181, `_on_game_day_advanced_legend`:192, `_on_time_advanced_refresh_legend`:211, `_note_time_boundary_for_legend`:216, `_try_set_map_time_pulse`:244, `_refresh_map_time_ui`:257, `_get_active_map_time_pulse_bbcode`:264, `_expire_map_time_pulse_if_needed`:272, `_setup_inspector_extras`:283, `_setup_hover_tooltip`:301, `_input`:310, `_unhandled_input`:320, `_process`:357, `_handle_camera_input`:374, `_zoom_toward_mouse`:410, `_screen_to_world`:432, `_on_close_pressed`:439, `_refresh_province_detail_visibility`:443, `initialize`:463, `render_provinces`:471, `_create_province_node`:508, `_create_or_update_province_name_label`:573, `_count_special_icons`:602, `_feature_icon_offsets_radial`:610, `_make_centroid_debug_marker`:623, `_calculate_centroid`:636, `_get_province_color`:666, `_on_province_input`:690, `_clear_selection`:707, `_select_province`:717, `_clear_hover_state`:738, `_on_mouse_entered`:752, `_on_mouse_exited`:764, `_refresh_hover_tooltip`:772, `_set_conflict_highlight`:841, `_set_agent_highlight`:847, `_is_compare_candidate`:853, `_battle_counterpart_for_hover`:859, `_hide_hover_tooltip`:869, `_update_spatial_hover`:876, `show_info_panel`:909, `hide_info_panel`:971, `add_overlay_layer`:980, `remove_overlay_layer`:990, `get_active_overlay_layers`:997, `get_overlay_layer`:1011, `_setup_conflict_layer`:1016, `setup_demo_conflict_overlay`:1035, `_setup_agent_layer`:1039, `setup_demo_agent_overlay`:1055, `_setup_supply_layer`:1068, `_ensure_supply_overlay_panel`:1082, `_player_tag`:1136, `_supply_manager`:1143, `build_supply_network`:1147, `_toggle_supply_overlay`:1159, `_refresh_supply_routes`:1182, `_handle_supply_province_click`:1191, `_show_supply_preview`:1210, `_update_supply_menu`:1219, `_on_supply_mode_changed`:1237, `_on_supply_commit`:1244, `_on_supply_clear_waypoints`:1253, `_on_supply_close_overlay`:1260, `_end_supply_reroute`:1264, `_refresh_province_fill_colors`:1271, `_province_polygon`:1292, `_province_node`:1299, `_get_province_polygon`:1305, `_apply_hover_visuals`:1314, `_hover_outline_colors`:1336, `_set_hover_outline`:1397, `_set_selection_outline`:1433, `_clear_compare_preview_outline`:1482, `_update_compare_preview_outline`:1488, `_refresh_single_province_fill`:1498, `_province_has_support_radio_benefit`:1519, `_apply_support_radio_fill_tint`:1532, `_apply_recovering_fill_tint`:1541, `_apply_agent_pressure_base_tint`:1562, `_apply_hover_fill`:1578, `_update_outline_pulse`:1639, `_refresh_compare_candidate_outlines`:1762, `_set_compare_candidate_outline`:1779, `_set_compare_preview_outline`:1805, `_supply_highlight_roles`:1824, `_apply_infra_pressure_overlay_roles`:1864, `_pulse_supply_outlines`:1899, `_pulse_amount_for_supply_role`:1925, `_refresh_supply_highlights`:1943, `_update_supply_overlay_legend`:1967, `_update_supply_legend_text`:2003, `_apply_supply_legend_time_pulse_style`:2030, `_update_compare_hint_label`:2048, `_set_supply_legend_visible`:2115, `_supply_depot_tint_color`:2126, `_on_open_national_spirits_pressed`:2134, `_get_feature_icon`:2157
- dependencias: `res://scenes/ui/NationalSpiritsScreen.tscn`:2142

### `epochs-of-ascendancy/scripts/map/MapTechnologyContext.gd` (390 lineas)
- class_name: `MapTechnologyContext` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (22): `get_map_integration_note`:16, `has_support_radio_bonuses`:33, `_support_bonus_parts`:44, `build_support_radio_glance_bbcode`:55, `build_technology_status_chip`:62, `_support_bonus_plain`:84, `build_support_radio_compact_chip`:91, `build_support_route_summary_plain`:106, `build_national_support_line_bbcode`:124, `build_support_recovery_hint_bbcode`:136, `build_support_supply_effect_bbcode`:145, `build_province_support_benefit_bbcode`:161, `build_support_radio_inspector_block`:182, `build_country_research_glance_bbcode`:194, `build_province_production_tech_bbcode`:208, `build_province_technology_bbcode`:240, `get_build_mode_preview`:258, `_province_owned_by`:278, `_completed_count`:286, `_build_target_placeholder`:296, `is_design_buildable_in_province`:332, `get_province_build_lock_reason`:369

### `epochs-of-ascendancy/scripts/map/MapViewInput.gd` (49 lineas)
- class_name: `MapViewInput` (linea 4)
- extends: `RefCounted` (linea 5)
- funciones (2): `motion_delta`:13, `edge_pan_blocked_by_gui`:26

### `epochs-of-ascendancy/scripts/map/ProvinceEffects.gd` (89 lineas)
- class_name: `ProvinceEffects` (linea 7)
- extends: `RefCounted` (linea 8)
- funciones (10): `_init`:13, `get_effective_throughput_multiplier`:18, `get_effective_local_supply_generation`:23, `get_effective_combat_width_multiplier`:29, `get_effective_organization_recovery`:34, `get_effective_attrition_multiplier`:39, `get_effective_logistics_quality`:46, `get_effective_reinforcement_speed`:51, `get_effective_interdiction_resistance`:57, `for_country_province`:64

### `epochs-of-ascendancy/scripts/map/ProvinceFactoryComponent.gd` (61 lineas)
- class_name: `ProvinceFactoryComponent` (linea 8)
- extends: `Node` (linea 9)
- funciones (6): `_ready`:17, `add_factory`:22, `get_factories`:36, `get_active_factories`:40, `capture_all_factories`:44, `_factory_manager`:59

### `epochs-of-ascendancy/scripts/map/ProvinceHoverTooltip.gd` (336 lineas)
- class_name: `ProvinceHoverTooltip` (linea 1)
- extends: `PanelContainer` (linea 2)
- funciones (14): `_ready`:24, `set_supply_accent`:49, `set_compare_accent`:56, `set_selected_accent`:63, `set_candidate_accent`:70, `set_conflict_accent`:77, `set_agent_accent`:84, `set_tech_accent`:91, `set_support_accent`:98, `set_agent_activity_accent`:105, `set_agent_pressure_kind`:112, `_apply_panel_style`:120, `show_text`:267, `hide_tooltip`:334

### `epochs-of-ascendancy/scripts/map/ProvinceInsight.gd` (3814 lineas)
- class_name: `ProvinceInsight` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (158): `build_hover_tooltip`:45, `build_inspector_text`:93, `build_inspector_full_bbcode`:100, `get_province_effects_for`:184, `build_at_a_glance_logistics`:200, `build_at_a_glance_combat`:213, `build_combat_summary_for_inspector`:225, `build_national_rollup_bbcode`:265, `build_routes_through_province_bbcode`:285, `_bbcode_inner`:339, `build_tooltip_mode_chip_for_state`:350, `_supply_role_label`:563, `build_supply_role_hint_bbcode`:587, `_supply_role_icon`:593, `build_inspector_conflict_section`:617, `build_overlay_layers_summary_bbcode`:629, `province_benefits_country`:659, `build_layers_symbol_key_bbcode`:663, `build_compact_layers_summary_bbcode`:690, `build_compact_layers_counts_line`:729, `build_supply_multi_overlay_block_bbcode`:747, `build_map_supply_mode_hint_plain`:771, `build_inspector_technology_section`:798, `build_province_situation_tags`:818, `_province_matches_country`:860, `build_compare_situation_note`:869, `_compare_production_tech_note`:885, `count_dual_situation_provinces`:900, `build_supply_overlay_quick_key_bbcode`:912, `build_supply_legend_bbcode`:940, `build_map_compare_hint_plain`:1116, `build_supply_overlay_bbcode`:1145, `build_info_logistics_text`:1212, `build_info_combat_text`:1225, `build_national_effects_bbcode`:1244, `build_route_modifier_lines`:1262, `depot_fill_ratio`:1303, `is_province_contested`:1313, `get_active_agent_network`:1321, `has_active_agent_network`:1333, `count_agent_networks`:1337, `agent_applies_daily_pressure`:1355, `get_agent_pressure_fill_tint`:1362, `agent_has_today_pressure_tick`:1380, `get_agent_pressure_fill_strength`:1387, `_infra_repair_breakdown`:1410, `build_infra_sabotage_source_bbcode`:1416, `build_supply_disruption_source_bbcode`:1430, `estimate_daily_infra_chip_damage`:1444, `build_infra_progress_meter_bbcode`:1455, `_daily_infra_duel_winner`:1481, `_duel_winner_headline`:1493, `build_repair_contributions_glance_bbcode`:1512, `build_repair_contributions_glance_for_province`:1534, `daily_infra_duel_winner`:1552, `build_sabotage_repair_duel_bbcode`:1557, `build_repair_boost_highlight_bbcode`:1613, `build_pressure_status_chip_row_bbcode`:1620, `_pressure_outcome_plain`:1658, `build_infra_net_trend_bbcode`:1692, `build_pressure_trend_chip_bbcode`:1720, `build_pressure_outcome_headline_bbcode`:1741, `build_net_daily_infra_bbcode`:1759, `build_net_daily_compact_chip_bbcode`:1808, `build_net_daily_short_bbcode`:1838, `build_sabotage_verdict_inline_bbcode`:1869, `build_sabotage_verdict_block_bbcode`:1907, `build_sabotage_action_hint_bbcode`:1937, `build_pressure_outcome_bbcode`:1963, `_pressure_status_label`:1973, `build_infra_repair_breakdown_bbcode`:1987, `build_province_infrastructure_card_bbcode`:2024, `build_province_infra_repair_bbcode`:2150, `province_needs_infrastructure_ui`:2154, `build_province_infrastructure_section_bbcode`:2168, `build_supply_pressure_recovery_bbcode`:2172, `build_province_pressure_recovery_bbcode`:2193, `build_province_pressure_recovery_compact`:2207, `build_agent_pressure_headline_bbcode`:2232, `build_province_pressure_section_bbcode`:2245, `pressure_agent_section_redundant_with_card`:2275, `build_province_radio_overlay_line_bbcode`:2309, `agent_pressure_focus_kind`:2327, `agent_has_daily_activity`:2340, `count_agent_pressure_networks`:2349, `estimate_agent_map_pressure`:2374, `_agent_daily_note_label`:2389, `build_agent_ongoing_pressure_bbcode`:2409, `build_agent_daily_effect_detail_bbcode`:2428, `build_agent_daily_activity_bbcode`:2451, `build_agent_glance_bbcode`:2477, `build_agent_pressure_legend_fragment`:2499, `build_agent_legend_line`:2511, `build_inspector_agent_section`:2530, `count_contested_provinces`:2561, `build_conflict_status_bbcode`:2572, `build_control_glance_bbcode`:2583, `build_province_glance_bbcode`:2595, `build_province_glance_compact`:2660, `build_dual_situation_glance_bbcode`:2672, `build_inspector_situation_section`:2707, `build_conflict_map_hint_plain`:2743, `build_conflict_legend_line`:2752, `country_tag_for_province`:2764, `build_province_report`:2772, `format_report_tooltip`:2798, `format_report_inspector`:2928, `_logistics_rows`:2937, `_combat_rows`:2947, `_make_mult_row`:2955, `_make_add_row`:2976, `_make_score_row`:2998, `_national_delta_text`:3018, `_is_improved`:3027, `_modifier_legend_bbcode`:3033, `_stat_column_legend_bbcode`:3040, `build_tooltip_context_banner`:3047, `build_non_adjacent_compare_hint`:3087, `_adjacent_province_names`:3097, `build_inspector_national_section`:3117, `build_supply_logistics_one_liner`:3147, `build_national_situation_one_liner`:3165, `build_national_impact_compact`:3188, `build_compact_effective_summary`:3214, `build_national_sources_badge`:3229, `build_national_sources_grouped_compact`:3248, `build_national_sources_compact_limited`:3276, `_top_impact_rows`:3300, `build_national_sources_compact`:3321, `build_inspector_compare_header`:3340, `build_supply_map_hint_bbcode`:3355, `_bbcode_stat_line_layered`:3378, `_format_base_value`:3407, `_format_effective_value`:3419, `_format_national_value`:3431, `_depot_bbcode_line`:3439, `_province_short_name`:3474, `_bbcode_stat_line`:3481, `_plain_stat_line`:3511, `_nat_suffix`:3533, `_nat_suffix_plain`:3539, `_owner_controller_bbcode`:3545, `_battle_block_for`:3553, `_national_spirit_lines`:3565, `_temporary_effect_lines`:3582, `_extract_relevant_modifiers`:3600, `_modifier_key_affects_provinces`:3613, `_agent_network_line`:3621, `get_battle_preview`:3637, `_local_battle_block`:3669, `_battle_preview_block`:3686, `_format_preview_header`:3712, `_terrain_width_line`:3745, `_depot_summary_line`:3752, `_resolve_battle_counterpart`:3768, `_province_by_id`:3788, `_supply_manager`:3798, `_scenario_loader`:3805

### `epochs-of-ascendancy/scripts/map/ProvinceMapVisuals.gd` (278 lineas)
- class_name: `ProvinceMapVisuals` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (9): `make_closed_outline`:77, `ensure_outline`:91, `ensure_polished_outline`:114, `hide_outline`:135, `hide_polished_outline`:141, `get_outline_line`:146, `apply_pulse_to_line`:151, `apply_pulse_to_polished`:169, `get_supply_outline_style`:195

### `epochs-of-ascendancy/scripts/map/SupplyMenuPanel.gd` (83 lineas)
- class_name: `SupplyMenuPanel` (linea 1)
- extends: `SupplyOverlayPanel` (linea 2)
- funciones (6): `_ready`:13, `setup_mode_selector`:19, `get_selected_routing_mode`:33, `show_supply_state`:39, `set_mode_callback`:76, `_on_mode_item_selected`:80

### `epochs-of-ascendancy/scripts/map/SupplyOverlayPanel.gd` (82 lineas)
- class_name: `SupplyOverlayPanel` (linea 1)
- extends: `Panel` (linea 2)
- funciones (7): `_ready`:17, `show_plan`:27, `hide_panel`:59, `set_callbacks`:63, `_emit_commit`:69, `_emit_clear`:74, `_emit_close`:79

### `epochs-of-ascendancy/scripts/national/NationalModifierDisplay.gd` (102 lineas)
- class_name: `NationalModifierDisplay` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (8): `modifier_help`:24, `modifier_lines_detailed`:31, `build_spirit_tooltip`:45, `build_effect_tooltip`:60, `duration_progress`:82, `_modifier_key_label`:87, `_format_modifier_value`:91, `_is_positive_modifier`:97

### `epochs-of-ascendancy/scripts/national/NationalModifierManager.gd` (330 lineas)
- extends: `Node` (linea 2)
- senales: `national_modifier_applied`:9, `national_modifier_expired`:10
- funciones (15): `_ready`:18, `_on_game_year_advanced`:32, `_on_game_month_advanced`:40, `set_current_year`:46, `apply_national_effect`:63, `tick_modifiers`:98, `get_national_modifier`:122, `get_active_effects`:137, `remove_effect`:145, `clear_country_modifiers`:162, `clear_all_modifiers`:169, `get_production_modifiers`:175, `get_combat_modifiers`:225, `get_supply_modifiers`:262, `apply_influence_effect`:301

### `epochs-of-ascendancy/scripts/national/NationalSpiritManager.gd` (337 lineas)
- extends: `Node` (linea 2)
- senales: `spirits_initialized`:6
- funciones (21): `_ready`:14, `_on_modifier_changed`:21, `_load_spirit_definitions`:30, `ensure_country_spirits`:43, `get_spirits_screen_data`:59, `_collect_categories`:79, `_collect_effect_sources`:92, `get_temporary_effect_rows`:105, `get_national_effects_snippet`:123, `_spirit_row`:131, `_temporary_effect_row`:151, `_format_modifier_lines`:179, `_modifier_key_label`:187, `_format_modifier_value`:191, `_source_display_name`:197, `get_spirit_production_modifiers`:212, `get_total_supply_consumption_modifier`:244, `get_total_attrition_reduction_modifier`:257, `get_total_interdiction_resistance_modifier`:268, `get_spirit_supply_modifiers`:280, `get_spirit_combat_modifiers`:309

### `epochs-of-ascendancy/scripts/national/TradeManager.gd` (1245 lineas)
- extends: `Node` (linea 2)
- senales: `offer_created`:320, `deal_accepted`:321, `deal_rejected`:322, `offer_expired`:323
- funciones (23): `_ready`:347, `_on_game_year_advanced`:354, `create_offer`:365, `evaluate_fairness`:406, `accept_offer`:497, `_is_abstract_trade_party`:526, `_country_can_supply_items`:532, `_expire_offers_past_deadline`:584, `_get_player_country_tag`:597, `_uses_player_stockpile`:605, `reject_offer`:610, `expire_offer`:621, `get_active_offers_for_country`:631, `get_public_offers`:641, `get_offers_for_country`:649, `generate_black_market_opportunity`:678, `generate_public_market_offers`:873, `_norm_tag`:1032, `_generate_id`:1035, `_index_offer`:1038, `_clean_indexes`:1044, `_calculate_item_value`:1050, `_execute_transfer`:1112

### `epochs-of-ascendancy/scripts/production/DesignLineState.gd` (39 lineas)
- class_name: `DesignLineState` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `get_refinement_completions`:19, `record_refinement_completion`:23, `duplicate_state`:27

### `epochs-of-ascendancy/scripts/production/DesignManager.gd` (1003 lineas)
- extends: `Node` (linea 51)
- funciones (63): `_ready`:120, `_on_game_year_advanced`:126, `get_current_year`:131, `mark_design_used`:139, `has_used_design`:153, `get_design_status`:161, `get_active_designs`:166, `get_previously_used_designs`:170, `get_obsolete_designs`:174, `get_designs_for_picker`:178, `get_tech_eligible_design_ids`:233, `get_unlock_year`:237, `get_lifecycle_role`:248, `get_design_domain`:261, `is_only_design_in_role`:272, `get_design_nation_tag`:284, `get_design_ownership`:296, `is_design_domestic_for`:308, `is_design_foreign_for`:313, `country_may_use_design`:317, `has_acquired_design`:321, `get_acquisition_kind`:340, `grant_acquired_design`:348, `revoke_acquired_design`:378, `acquisition_kind_label`:389, `acquisition_icon`:401, `format_origin_badge`:414, `format_origin_tooltip`:427, `acquisition_row_color`:440, `_format_foreign_badge`:454, `try_grant_captured_designs_from_factory`:474, `_try_grant_design_list`:493, `try_grant_from_captured_province`:515, `_fire_acquisition_toast`:527, `design_row_search_blob`:551, `sort_design_ids_for_display`:571, `get_save_data`:579, `apply_save_data`:590, `mark_design_acquired`:613, `domain_from_filter_index`:622, `is_design_factory_compatible`:638, `_filter_ids_by_status`:649, `_classify_design`:665, `_eligible_design_ids`:721, `_buildable_design_ids`:725, `_catalog_design_ids`:733, `_country_may_use_design`:752, `_ownership_bucket_key`:762, `_empty_picker_buckets`:768, `_push_locked_design`:785, `_merge_ids`:792, `_infer_nation_from_template`:803, `_infer_nation_from_id`:810, `_nation_from_family_token`:838, `_is_design_in_active_production`:866, `_is_tech_buildable`:881, `_matches_domain`:887, `_infer_domain_from_template`:894, `_is_space_template`:916, `_era_to_year`:960, `_year_from_id`:983, `_sort_design_ids`:991, `_norm_tag`:1001

### `epochs-of-ascendancy/scripts/production/EquipmentShortageTracker.gd` (35 lineas)
- class_name: `EquipmentShortageTracker` (linea 2)
- extends: `Node` (linea 3)
- funciones (2): `calculate_shortages`:7, `get_readiness_from_shortages`:18

### `epochs-of-ascendancy/scripts/production/FactoryManager.gd` (370 lineas)
- extends: `Node` (linea 3)
- senales: `factory_captured`:5, `factory_repaired`:6, `factory_damaged`:7
- funciones (25): `_ready`:18, `set_province_lookup`:22, `get_province`:26, `province_has_port`:33, `_load_rules`:38, `register_factory`:53, `get_factory`:66, `get_factories_in_province`:70, `apply_damage_to_factory`:81, `capture_province_factories`:93, `reconcile_factory_owners_with_map`:122, `advance_repair_for_province`:140, `get_factory_efficiency`:154, `advance_retooling_for_province`:161, `assign_production_line_to_factory`:174, `get_default_max_lines_for_type`:190, `create_factory_for_province`:197, `create_shipyard_for_province`:230, `convert_factory_to_shipyard`:241, `get_or_create_province_component`:272, `register_factories_for_province`:282, `_allocate_factory_id`:291, `_invalidate_production_cache_for_owner`:304, `get_save_data`:315, `apply_save_data`:328

### `epochs-of-ascendancy/scripts/production/LogisticsCalculator.gd` (155 lineas)
- class_name: `LogisticsCalculator` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (8): `applies_logistics`:15, `resolve_loadout`:23, `compute`:36, `_cargo_module_multiplier`:84, `_weapon_slot_penalty_product`:96, `_count_weapon_slots`:109, `_compute_supply_demand`:117, `_aggregate_combat_stats`:136

### `epochs-of-ascendancy/scripts/production/ProductionCostCalculator.gd` (402 lineas)
- class_name: `ProductionCostCalculator` (linea 3)
- extends: `RefCounted` (linea 4)
- funciones (23): `get_rules`:12, `get_base_daily_points`:17, `calculate_production_cost`:22, `resolve_cost`:38, `resolve_cost_breakdown`:47, `_compute_total`:88, `infer_category`:110, `infer_era`:114, `estimate_build_days`:118, `_template_to_dict`:126, `_infer_category_from_dict`:143, `_infer_era_from_dict`:189, `_extract_module_ids_from_dict`:242, `_collect_module_ids`:265, `_get_module`:272, `_module_production_cost`:278, `_infer_module_cost_key`:289, `_infer_module_cost_key_from_id`:295, `_complexity_penalty_additive`:338, `_normalize_category`:346, `resolve_daily_resource_cost`:353, `resolve_daily_resource_cost_from_dict`:362, `_load_rules`:389

### `epochs-of-ascendancy/scripts/production/ProductionLine.gd` (493 lineas)
- class_name: `ProductionLine` (linea 9)
- extends: `RefCounted` (linea 10)
- senales: `template_changed`:12, `unit_completed`:13, `refinement_started`:14, `refinement_completed`:15
- funciones (45): `_init`:42, `reset_progress`:48, `add_progress`:52, `refresh_design_production_cost`:58, `refresh_required_progress`:71, `get_progress_percent`:75, `set_modifier_resolver`:81, `set_runtime_modifiers`:85, `set_template`:89, `get_current_template`:136, `get_current_state`:142, `get_tooling_efficiency`:146, `get_output_multiplier`:154, `_base_output_multiplier`:159, `get_effective_loadout`:176, `_effective_module_ids`:183, `set_slot_module`:192, `clear_slot_module`:197, `clear_custom_loadout`:202, `get_reliability_profile`:207, `get_effective_reliability`:224, `list_refinement_options`:228, `can_start_refinement`:261, `get_days_per_unit`:269, `get_production_cost`:281, `start_refinement`:294, `cancel_refinement`:305, `advance_days`:309, `_complete_unit`:350, `_advance_refinement`:367, `_persist_current_state`:378, `_ensure_design_state`:386, `_apply_refinement_completion`:397, `_refinement_eligibility`:408, `_merge_cost`:423, `apply_retooling_adjustment`:428, `get_retooling_days_remaining`:435, `_active_modifiers`:439, `_scaled_cost`:445, `get_assigned_factory`:454, `get_factory_efficiency`:463, `get_effective_daily_rate`:472, `_sync_factory_production_design`:476, `_factory_manager`:484, `get_daily_resource_cost`:491

### `epochs-of-ascendancy/scripts/production/ProductionModifier.gd` (40 lineas)
- class_name: `ProductionModifier` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (2): `from_dict`:18, `_string_array`:33

### `epochs-of-ascendancy/scripts/production/ProductionModifiers.gd` (41 lineas)
- class_name: `ProductionModifiers` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `reset`:17, `absorb`:29, `get_total_output_multiplier`:39

### `epochs-of-ascendancy/scripts/production/ProductionNavalRules.gd` (97 lineas)
- class_name: `ProductionNavalRules` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (5): `is_naval_category`:43, `is_naval_template`:52, `is_naval_design`:82, `factory_can_build_naval`:89, `province_allows_shipyard`:95

### `epochs-of-ascendancy/scripts/production/RefinementProject.gd` (56 lineas)
- class_name: `RefinementProject` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (5): `from_def`:20, `advance`:38, `is_complete`:42, `progress_ratio`:46, `_dict_from_variant`:52

### `epochs-of-ascendancy/scripts/production/ReliabilityCalculator.gd` (173 lineas)
- class_name: `ReliabilityCalculator` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (7): `compute_profile`:7, `recompute_design_maturity`:90, `_compute_maintenance_index`:100, `_compute_supply_multiplier`:120, `_compute_combat_readiness`:126, `_compute_breakdown_risk`:142, `_module_reliability_delta`:158

### `epochs-of-ascendancy/scripts/production/ReliabilityProfile.gd` (44 lineas)
- class_name: `ReliabilityProfile` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `has_cargo_role`:34, `is_immature`:38, `is_field_ready`:42

### `epochs-of-ascendancy/scripts/production/RetoolingCalculator.gd` (64 lineas)
- class_name: `RetoolingCalculator` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `compute_similarity`:7, `compute_retooling_days`:33, `_shared_module_ratio`:41

### `epochs-of-ascendancy/scripts/production/RetoolingSimilarityTable.gd` (96 lineas)
- class_name: `RetoolingSimilarityTable` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (6): `get_data`:11, `get_similarity`:16, `map_production_category_to_group`:26, `category_group_for_design`:49, `compute_retool_plan`:58, `_load`:83

### `epochs-of-ascendancy/scripts/scenarios/ScenarioFactorySpawner.gd` (177 lineas)
- class_name: `ScenarioFactorySpawner` (linea 2)
- extends: `Node` (linea 3)
- funciones (9): `spawn_factories_for_scenario`:15, `_iter_countries`:95, `_resolve_key_provinces`:114, `_base_factory_count`:130, `_shipyard_levels_for_country`:140, `_default_major_power`:148, `_default_naval_power`:152, `_province_has_port`:156, `_factory_manager`:172

### `epochs-of-ascendancy/scripts/supply/AttritionReplenishmentLedger.gd` (90 lineas)
- class_name: `AttritionReplenishmentLedger` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (7): `record_manpower_loss`:10, `record_equipment_loss`:19, `clear`:26, `get_primary_leader_id`:31, `get_leader_id_for_formation`:39, `calculate_attrition`:44, `compute_replenishment_cargo`:57

### `epochs-of-ascendancy/scripts/supply/CombatPresenceRegistry.gd` (92 lineas)
- class_name: `CombatPresenceRegistry` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (11): `clear`:9, `get_report`:13, `add_land_presence`:19, `add_air_presence`:24, `add_naval_presence`:29, `add_engineer_presence`:34, `register_division_presence`:39, `add_unit`:56, `_brigade_weight`:74, `set_report`:86, `all_province_ids`:90

### `epochs-of-ascendancy/scripts/supply/DivisionTemplate.gd` (448 lineas)
- class_name: `DivisionTemplate` (linea 1)
- extends: `Resource` (linea 2)
- funciones (26): `from_dict`:23, `resolve_subunits`:48, `get_aggregated_infantry_stats`:83, `get_average_generation`:117, `get_resolved_subunits`:130, `get_sustainment_equipment_template`:138, `get_sustainment_stats`:142, `get_sustainment_consumption_multiplier`:161, `get_sustainment_readiness_bonus`:165, `get_sustainment_reliability_impact`:169, `get_total_infantry_headcount`:173, `count_engineer_brigade_equivalent`:187, `get_specialized_sustainment_demand`:202, `get_combined_combat_modifiers`:232, `get_final_combat_stats`:249, `_shortages_affect_infantry`:282, `_shortages_affect_sustainment`:297, `get_required_equipment`:312, `_build_required_equipment`:319, `_append_subunit_sustainment_packages`:362, `_subunit_type_key`:379, `_infantry_template_id_for_equipment_entry`:397, `_apply_infantry_template_to_subunit`:406, `_resolve_design_data`:422, `_default_infantry_stats`:430, `_dict_from_variant`:441

### `epochs-of-ascendancy/scripts/supply/DivisionTemplateLoader.gd` (41 lineas)
- class_name: `DivisionTemplateLoader` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `load_all`:9, `get_division`:31, `get_all_division_ids`:35

### `epochs-of-ascendancy/scripts/supply/ProvinceDepotState.gd` (48 lineas)
- class_name: `ProvinceDepotState` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (4): `_init`:18, `apply_inflow`:25, `pull_outflow`:33, `fill_ratio`:44

### `epochs-of-ascendancy/scripts/supply/ProvinceForceReport.gd` (51 lineas)
- class_name: `ProvinceForceReport` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (9): `_init`:13, `add_land`:17, `add_air`:21, `add_naval`:25, `total_land`:31, `total_air`:35, `total_naval_at_port`:39, `add_engineers`:43, `total_engineers`:49

### `epochs-of-ascendancy/scripts/supply/ProvinceSupplyHub.gd` (31 lineas)
- class_name: `ProvinceSupplyHub` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (2): `has_kind`:19, `hub_score`:23

### `epochs-of-ascendancy/scripts/supply/SupplyCargoProfile.gd` (37 lineas)
- class_name: `SupplyCargoProfile` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (2): `from_template`:10, `general_supplies`:32

### `epochs-of-ascendancy/scripts/supply/SupplyIntelBridge.gd` (94 lineas)
- class_name: `SupplyIntelBridge` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `refresh_manager`:7, `_presence_for_province`:35, `_ctrl`:90

### `epochs-of-ascendancy/scripts/supply/SupplyInterdictionEstimator.gd` (89 lineas)
- class_name: `SupplyInterdictionEstimator` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (1): `estimate`:7

### `epochs-of-ascendancy/scripts/supply/SupplyManager.gd` (706 lineas)
- extends: `Node` (linea 1)
- senales: `network_rebuilt`:5, `route_updated`:6, `overlay_toggled`:7, `depot_stock_changed`:8
- funciones (47): `_get_effects_safe`:33, `_ready`:55, `build_network`:66, `_init_depot_states`:88, `get_depot_state`:108, `get_depot_menu_lines`:112, `get_capital_hub_id`:135, `set_player_depot`:142, `set_selected_province`:151, `get_selected_province_id`:155, `set_routing_mode`:159, `set_active_cargo_from_template`:163, `set_active_cargo_tons`:167, `register_unit_presence`:171, `register_division_presence`:180, `get_engineer_brigades_in_province`:192, `register_force_report`:203, `clear_force_registry`:207, `refresh_intel_from_forces`:211, `set_enemy_presence`:216, `get_enemy_presence`:222, `_apply_agent_intelligence_modifiers`:226, `record_attrition`:259, `get_formation`:273, `_get_base_supply_consumption`:279, `calculate_daily_supply_consumption`:293, `_apply_national_supply_modifiers`:314, `get_attrition_cargo_summary`:339, `_on_game_day_advanced`:351, `advance_supply_day`:355, `begin_player_reroute`:388, `set_reroute_target`:394, `add_reroute_waypoint`:398, `clear_reroute_waypoints`:404, `preview_player_route`:408, `commit_player_route`:412, `get_route`:428, `get_all_routes`:432, `_generate_local_supply_from_development`:436, `toggle_overlay`:485, `seed_demo_engineer_presence`:490, `seed_demo_enemy_forces`:516, `_plan_route`:542, `_calculate_route_interdiction_resistance`:627, `_calculate_route_reinforcement_modifier`:655, `_rebuild_default_routes`:680, `_ctrl`:702
- anomalias: [FLOAT_EQ] linea 331: if supply_mod == 0.0:

### `epochs-of-ascendancy/scripts/supply/SupplyMapLayer.gd` (64 lineas)
- class_name: `SupplyMapLayer` (linea 1)
- extends: `Node` (linea 2)
- funciones (5): `setup`:11, `set_routes`:18, `_draw`:26, `_color_for_plan`:49, `_draw_route_nodes`:60

### `epochs-of-ascendancy/scripts/supply/SupplyMultimodalRouter.gd` (49 lineas)
- class_name: `SupplyMultimodalRouter` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (1): `find_best_route`:7

### `epochs-of-ascendancy/scripts/supply/SupplyNetworkBuilder.gd` (121 lineas)
- class_name: `SupplyNetworkBuilder` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (4): `build`:7, `_capital_by_tag`:27, `_hub_from_province`:42, `_compute_capacity`:103

### `epochs-of-ascendancy/scripts/supply/SupplyPathfinder.gd` (260 lineas)
- class_name: `SupplyPathfinder` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (9): `find_route`:7, `find_route_for_mode`:22, `_mode_dijkstra`:72, `_supply_neighbors`:115, `_edge_cost_for_mode`:164, `_edge_cost`:182, `_populate_timing`:202, `_segment_mode`:234, `_is_friendly`:254

### `epochs-of-ascendancy/scripts/supply/SupplyRoutePlan.gd` (73 lineas)
- class_name: `SupplyRoutePlan` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `path_length`:27, `primary_mode`:31, `summary_lines`:49

### `epochs-of-ascendancy/scripts/supply/SupplyRules.gd` (41 lineas)
- class_name: `SupplyRules` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (5): `load_from_path`:9, `get_block`:15, `get_float`:20, `consumption_rate`:24, `_load_json`:29

### `epochs-of-ascendancy/scripts/supply/UnitSupplyRequirements.gd` (53 lineas)
- class_name: `UnitSupplyRequirements` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (4): `from_template`:16, `daily_consumption_cargo`:35, `can_airlift`:47, `can_sealift`:51

### `epochs-of-ascendancy/scripts/technology/TechnologyManager.gd` (1531 lineas)
- extends: `Node` (linea 2)
- senales: `research_started`:6, `research_completed`:7, `technology_unlocked`:8, `research_state_changed`:9, `agent_tech_state_changed`:10
- funciones (90): `_ready`:63, `_on_game_year_advanced`:88, `set_current_year`:96, `get_current_year`:100, `_load_all_trees`:106, `_merge_tree_file`:125, `_rebuild_unlock_indices`:143, `_template_ids_from_unlock`:162, `_ensure_country`:174, `_migrate_legacy_state`:202, `get_country_state`:232, `is_tech_completed`:237, `is_doctrine_key_unlocked`:242, `get_doctrine_xp`:255, `get_era_swimlane_labels`:259, `get_era_swimlane_keys`:266, `has_division_capability`:273, `get_unlocked_factory_types`:280, `get_technology_modifiers`:289, `get_effective_planning_speed`:297, `get_effective_reconnaissance`:304, `has_tech_unlock`:321, `get_design_availability`:343, `is_unit_design_available`:370, `factory_can_build_design`:374, `has_rule_flag`:402, `is_factory_type_unlocked`:407, `can_convert_factory_to_shipyard`:414, `_on_research_completed_toast`:418, `_has_unlocked_design`:434, `_has_unlocked_category`:439, `_is_category_gated_for_template`:445, `_category_source_tech`:450, `_template_production_category`:458, `_factory_matches_type`:467, `_lock_info_for_tech`:479, `get_tech_display_name`:489, `_tech_display_name`:493, `get_research_slots_max`:502, `get_active_research_count`:506, `get_daily_rp`:510, `get_effective_cost_days`:520, `get_node_status`:531, `_is_research_blocked`:550, `can_research`:563, `start_research`:573, `cancel_research`:595, `advance_research`:608, `_tick_country_research`:615, `_complete_research`:636, `_sync_doctrine_keys_to_leader_manager`:659, `get_technology_screen_data`:670, `get_doctrine_training_entries`:746, `_tech_id_for_doctrine_key`:774, `_pick_leader_for_training_paths`:789, `_build_graph_layout`:803, `_node_matches_era_filter`:834, `_build_active_summaries`:840, `_node_to_summary`:867, `_build_inspector`:916, `_format_unlock_line`:971, `_node_matches_domain_filter`:999, `_domains_with_nodes`:1008, `get_domain_tab_labels`:1030, `get_domain_tab_ids`:1042, `is_tech_compromised`:1048, `has_theft_protection`:1057, `is_theft_target`:1062, `get_stealable_tech_targets`:1069, `mission_requires_tech_target`:1094, `apply_research_theft_from_mission`:1101, `apply_tech_intel_bonus`:1160, `apply_tech_theft_protection`:1173, `get_agent_tech_summary`:1189, `get_tech_agent_inspector_lines`:1232, `_best_steal_target_for_actor`:1282, `_add_research_progress_days`:1295, `_steal_progress_from_victim`:1312, `_set_tech_compromised`:1331, `_log_agent_tech_operation`:1347, `reset_for_scenario`:1360, `apply_scenario_starting_tech`:1364, `_load_starting_pack`:1399, `_merge_starting_entry`:1414, `get_save_data`:1433, `apply_save_data`:1441, `_apply_country_starting_entry`:1454, `_apply_completed_techs_in_order`:1479, `_starting_prerequisites_met`:1511, `_grant_completed_tech_silent`:1522

### `epochs-of-ascendancy/scripts/technology/TechnologyUnlockRegistry.gd` (110 lineas)
- class_name: `TechnologyUnlockRegistry` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (7): `apply_unlocks`:8, `apply_unlock`:26, `_apply_modifier_unlock`:59, `_apply_unit_design_unlock`:69, `_apply_production_category_unlock`:80, `_append_unique`:93, `_store_deferred_unlock`:103

### `epochs-of-ascendancy/scripts/ui/AgentAssignmentScreen.gd` (1290 lineas)
- class_name: `AgentAssignmentScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (55): `_ready`:105, `_apply_content_margins`:127, `_on_close_pressed`:137, `_apply_screen_theme`:141, `_setup_roster_filter`:192, `_setup_agent_headers`:204, `_connect_agent_signals`:222, `_exit_tree`:238, `_on_agent_state_changed`:252, `_on_roster_filter_changed`:258, `_on_mission_category_changed`:262, `refresh_screen`:266, `_sync_mission_category_filter`:283, `_selected_mission_category_filter`:308, `_update_summary_bar`:315, `_update_feedback_hint`:334, `_apply_title_attention`:363, `_populate_agents`:380, `_compare_agent_summaries`:415, `_passes_roster_filter`:425, `_create_agent_row`:440, `_badge_label`:517, `_status_label`:535, `_format_status`:546, `_populate_targets`:550, `_update_intel_column_titles`:570, `_populate_intel_reports`:585, `_create_intel_report_row`:608, `_populate_national_effects`:640, `_on_open_national_spirits_pressed`:667, `_open_national_spirits_screen`:671, `_populate_recent_operations`:688, `_create_national_effect_chip`:710, `_create_operation_log_row`:738, `_resolve_agent_id_from_op`:824, `_find_agent_id_by_name`:831, `_outcome_badge`:842, `_update_detail_panel`:860, `_clear_detail_progress_bar`:959, `_add_detail_mission_progress`:965, `_populate_mission_history`:987, `_update_agent_state_banner`:1003, `_unavailable_mission_message`:1058, `_create_history_row`:1074, `_build_agent_row_tooltip`:1112, `_build_operation_tooltip`:1131, `_create_mission_preview`:1147, `_detection_risk_label`:1195, `_colorize_outcome_label`:1210, `_on_agent_selected`:1224, `_on_target_selected`:1229, `_on_recruit_pressed`:1235, `_on_open_technology_pressed`:1251, `_on_assign_mission_pressed`:1269, `_row_label`:1283
- dependencias: `res://scenes/ui/NationalSpiritsScreen.tscn`:677, `res://scenes/ui/TechnologyScreen.tscn`:1257

### `epochs-of-ascendancy/scripts/ui/DesignPickerPopup.gd` (813 lineas)
- class_name: `DesignPickerPopup` (linea 2)
- extends: `Window` (linea 3)
- funciones (38): `_ready`:52, `_legend_key_text`:93, `_update_legend_visibility`:100, `_clamp_window_to_viewport`:109, `_setup_domain_filter`:121, `_get_factory`:135, `_rebuild_list`:141, `_header_entry`:280, `_list_has_design_rows`:284, `_update_summary_hint`:293, `_domain_filter_label`:328, `_append_tier_header`:338, `_append_active_tier_hint`:346, `_append_archive_tier_hint`:353, `_append_locked_tier_hint`:360, `_append_foreign_empty_block`:367, `_append_section_divider`:383, `_append_design_section`:390, `_design_row_tooltip`:452, `_matches_search`:484, `_fetch_catalog`:501, `_section_subtitle`:518, `_truncate_list_label`:549, `_design_list_label`:555, `_lock_prefix`:616, `_lock_suffix`:620, `_apply_row_color`:630, `_sync_list_scroll_size`:682, `_scroll_list_to_top`:691, `_is_design_selectable`:695, `_on_search_changed`:709, `_on_filters_changed`:714, `_update_filter_labels`:719, `_update_default_lock_hint`:730, `_update_lock_hint`:736, `_on_design_selected`:775, `_on_confirm_pressed`:795, `_on_cancel_pressed`:811
- dependencias: `res://scenes/ui/RetoolingWarningPopup.tscn`:798

### `epochs-of-ascendancy/scripts/ui/DraggablePanel.gd` (33 lineas)
- class_name: `DraggablePanel` (linea 2)
- extends: `Control` (linea 3)
- funciones (2): `_ready`:13, `_on_drag_input`:22

### `epochs-of-ascendancy/scripts/ui/FormationPickerPopup.gd` (129 lineas)
- class_name: `FormationPickerPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `formation_assigned`:5
- funciones (9): `_ready`:22, `_present_popup`:44, `_update_title`:51, `_load_available_formations`:60, `_refresh_list`:68, `_on_search_changed`:83, `_on_formation_selected`:104, `_on_assign_pressed`:113, `_on_cancel_pressed`:127

### `epochs-of-ascendancy/scripts/ui/GameDateDisplay.gd` (282 lineas)
- class_name: `GameDateDisplay` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (16): `has_time_manager`:28, `get_current_date_dict`:32, `format_calendar_date`:38, `format_iso_date_readable`:45, `days_since_scenario_start`:54, `_days_in_month`:89, `months_since_scenario_start`:99, `format_elapsed_suffix`:113, `format_top_bar_line`:123, `format_top_bar_tooltip`:140, `format_map_date_plain`:173, `build_map_time_pulse_bbcode`:195, `time_pulse_priority`:224, `build_map_date_glance_bbcode`:236, `build_map_date_footer_bbcode`:251, `format_map_date_compact`:269

### `epochs-of-ascendancy/scripts/ui/LeaderAssignmentScreen.gd` (788 lineas)
- class_name: `LeaderAssignmentScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (39): `_ready`:67, `_apply_content_margins`:82, `_on_close_pressed`:92, `_apply_screen_theme`:96, `_setup_detail_panel`:116, `_setup_headers`:125, `refresh_screen`:153, `_setup_national_spirits_button`:162, `_on_national_spirits_pressed`:175, `_setup_pending_replacements_badge`:192, `_connect_leader_replacement_signals`:208, `_exit_tree`:217, `_on_leader_replacement_queue_changed`:226, `_update_pending_replacements_badge`:240, `_apply_screen_title`:258, `_on_pending_replacements_pressed`:274, `_update_summary_bar`:285, `_populate_national_positions`:306, `_create_officer_training_card`:321, `_on_generate_cadet_pressed`:402, `_on_assign_officer_training_pressed`:418, `_create_national_position_card`:427, `_on_national_position_details_pressed`:478, `_on_change_national_position`:485, `_populate_available_leaders`:499, `_populate_unassigned_formations`:514, `_create_leader_row`:545, `_style_leader_name_button`:614, `_leader_has_level_up_option`:622, `_on_leader_name_pressed`:631, `_open_leader_detail_screen`:635, `_row_label`:647, `_format_leader_status`:656, `_format_traits_row`:671, `_on_details_pressed`:688, `_populate_trait_detail`:694, `_on_level_trait_pressed`:748, `_on_assign_pressed`:761, `_position_display_name`:783
- dependencias: `res://scenes/ui/NationalSpiritsScreen.tscn`:181, `res://scenes/ui/FormationPickerPopup.tscn`:766

### `epochs-of-ascendancy/scripts/ui/LeaderDetailScreen.gd` (587 lineas)
- class_name: `LeaderDetailScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (31): `open`:43, `_ready`:57, `_exit_tree`:87, `_on_close_pressed`:98, `_on_trait_leveled`:102, `_on_training_path_invested`:107, `_on_training_path_switched`:112, `_on_training_paths_pressed`:117, `refresh_screen`:121, `_apply_theme`:135, `_style_section_header`:151, `_style_level_up_section`:156, `_update_training_button_visibility`:168, `_update_training_path_indicator`:175, `_update_training_path_bonuses`:195, `_get_training_path_bonuses_container`:245, `_get_training_path_indicator`:273, `_update_header`:296, `_populate_current_traits`:328, `_populate_level_up_options`:363, `_create_level_up_row`:393, `_populate_potential_traits`:457, `_on_level_up_pressed`:489, `_get_rarity_tag`:496, `_clear_children`:504, `_add_note_label`:509, `_build_level_up_tooltip`:517, `_get_next_level_effects`:528, `_format_trait_effects_clean`:534, `_format_single_effect`:547, `_format_trait_effects`:585
- dependencias: `res://scenes/ui/LeaderDetailScreen.tscn`:44

### `epochs-of-ascendancy/scripts/ui/LeaderEventUI.gd` (290 lineas)
- extends: `Node` (linea 2)
- senales: `news_posted`:6
- funciones (19): `_ready`:20, `_connect_leader_signals`:25, `_ensure_toast_layer`:36, `post_news`:55, `get_recent_news`:70, `_show_toast`:77, `_dismiss_toast`:126, `_on_toast_timer_expired`:131, `_on_retirement_offered`:135, `_try_show_next_retirement`:143, `_on_retirement_popup_completed`:158, `_on_leader_replacement_needed`:181, `_try_show_next_replacement`:192, `_on_replacement_popup_completed`:213, `_on_leader_died`:236, `_on_leader_captured`:246, `_on_leader_introduced`:255, `_on_officer_training_quality_notice`:265, `_leader_display_name`:285

### `epochs-of-ascendancy/scripts/ui/LeaderPickerPopup.gd` (251 lineas)
- class_name: `LeaderPickerPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `leader_selected`:5
- funciones (11): `_ready`:22, `_update_title`:48, `_present_popup`:61, `open_picker`:68, `_load_leaders`:87, `_populate_list`:142, `_on_search_changed`:188, `_on_leader_selected`:192, `_on_confirm_pressed`:211, `_refresh_leader_screen`:243, `_on_cancel_pressed`:249
- dependencias: `res://scenes/ui/LeaderPickerPopup.tscn`:69

### `epochs-of-ascendancy/scripts/ui/LeaderReplacementPickerPopup.gd` (202 lineas)
- class_name: `LeaderReplacementPickerPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `replacement_completed`:5
- funciones (14): `_ready`:24, `_present_popup`:61, `open_for_request`:68, `_build_header`:85, `_load_candidates`:106, `_populate_list`:113, `_on_search_changed`:146, `_on_leader_selected`:150, `_on_auto_pressed`:165, `_on_confirm_pressed`:175, `_on_vacant_pressed`:182, `_on_later_pressed`:187, `_finish`:192, `_refresh_leader_screen`:198
- dependencias: `res://scenes/ui/LeaderReplacementPickerPopup.tscn`:69

### `epochs-of-ascendancy/scripts/ui/MainMenu.gd` (301 lineas)
- class_name: `MainMenu` (linea 37)
- extends: `Window` (linea 38)
- senales: `menu_closed`:43
- funciones (13): `_ready`:55, `_clamp_to_viewport`:76, `_build_menu_options`:81, `_make_menu_button`:95, `_build_save_manager_view`:115, `_populate_save_list`:134, `_handle_menu_option`:196, `_on_close_requested`:219, `_pause_game`:225, `_get_resume_speed`:250, `_sync_top_bar_after_menu_close`:257, `_style_dynamic_controls`:278, `_refresh_save_list`:290
- dependencias: `res://scenes/ui/MainMenu.tscn`:30

### `epochs-of-ascendancy/scripts/ui/MissionPickerPopup.gd` (315 lineas)
- class_name: `MissionPickerPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `mission_assigned`:5
- funciones (17): `_ready`:29, `_update_title`:60, `_present_popup`:73, `open_picker`:80, `_setup_category_filter`:99, `_active_category_filter`:118, `_load_missions`:124, `_on_category_filter_changed`:131, `_populate_list`:135, `_on_search_changed`:171, `_on_mission_selected`:191, `_update_detail_for_mission`:209, `_on_confirm_pressed`:247, `_on_tech_target_picked`:274, `_finalize_mission_assignment`:278, `_refresh_agent_screen`:307, `_on_cancel_pressed`:313
- dependencias: `res://scenes/ui/MissionPickerPopup.tscn`:81

### `epochs-of-ascendancy/scripts/ui/NationalSpiritsScreen.gd` (486 lineas)
- class_name: `NationalSpiritsScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (27): `_ready`:35, `_setup_filters`:46, `_apply_screen_theme`:59, `_connect_signals`:83, `_exit_tree`:98, `_on_modifiers_changed`:107, `_on_filter_changed`:112, `_on_close_pressed`:116, `refresh_screen`:120, `_sync_category_filter`:140, `_count_debuffs`:159, `_update_filter_status`:169, `_count_agent_mission_effects`:186, `_populate_lists`:196, `_populate_permanent`:207, `_populate_temporary`:220, `_filtered_permanent_rows`:239, `_filtered_temporary_rows`:259, `_passes_view_filter`:278, `_selected_category_filter`:292, `_matches_search`:298, `_empty_message_permanent`:319, `_empty_message_temporary`:327, `_create_entry_panel`:339, `_create_modifier_grid`:435, `_on_entry_selected`:473, `_empty_label`:479

### `epochs-of-ascendancy/scripts/ui/ProductionAssignmentScreen.gd` (322 lineas)
- class_name: `ProductionAssignmentScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (21): `_ready`:50, `_exit_tree`:66, `_on_close_pressed`:71, `_apply_screen_theme`:75, `_setup_headers`:91, `_setup_filters`:111, `_on_day_advanced`:127, `refresh_screen`:131, `_update_summary_bar`:137, `_apply_filters`:154, `_matches_status_filter`:176, `_matches_type_filter`:184, `_matches_search`:190, `_populate_factory_list`:196, `_create_factory_row`:204, `_row_label`:249, `_format_design_label`:258, `_efficiency_color`:267, `_on_details_pressed`:275, `_on_change_pressed`:304, `_on_filter_changed`:320
- dependencias: `res://scenes/ui/DesignPickerPopup.tscn`:305

### `epochs-of-ascendancy/scripts/ui/RetirementOfferPopup.gd` (117 lineas)
- class_name: `RetirementOfferPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `retirement_completed`:7
- funciones (7): `_ready`:21, `_on_close_blocked`:47, `_present_popup`:51, `_setup_ui`:58, `_on_retire_pressed`:83, `_on_stay_pressed`:89, `open_for_leader`:100
- dependencias: `res://scenes/ui/RetirementOfferPopup.tscn`:101

### `epochs-of-ascendancy/scripts/ui/RetoolingWarningPopup.gd` (83 lineas)
- class_name: `RetoolingWarningPopup` (linea 2)
- extends: `Window` (linea 3)
- funciones (4): `_ready`:14, `_update_warning_text`:30, `_on_confirm_pressed`:70, `_on_cancel_pressed`:81

### `epochs-of-ascendancy/scripts/ui/RetrowaveTheme.gd` (186 lineas)
- class_name: `RetrowaveTheme` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (24): `style_top_info_bar`:16, `style_info_bar_label`:22, `style_nav_button`:27, `style_speed_button`:32, `style_production_screen`:39, `style_summary_metric`:45, `style_column_header`:50, `style_row_label`:55, `style_detail_panel`:60, `style_detail_label`:64, `style_filter_option`:69, `style_popup_root`:74, `style_title`:90, `style_body_label`:95, `style_rich_text`:100, `style_search`:105, `style_item_list`:113, `style_primary_button`:120, `style_secondary_button`:128, `style_danger_button`:136, `_panel_style`:144, `_selected_style`:155, `_input_style`:162, `_button_style`:175

### `epochs-of-ascendancy/scripts/ui/TechnologyGraphEdgeLayer.gd` (8 lineas)
- extends: `Control` (linea 2)
- funciones (1): `_draw`:4

### `epochs-of-ascendancy/scripts/ui/TechnologyGraphView.gd` (255 lineas)
- class_name: `TechnologyGraphView` (linea 2)
- extends: `Control` (linea 3)
- senales: `node_selected`:7
- funciones (15): `_ready`:32, `_gui_input`:42, `set_graph_data`:62, `reset_view`:80, `_apply_zoom`:86, `_apply_transform`:97, `_node_position`:106, `_graph_canvas_size`:115, `_center_on_graph`:125, `_rebuild_nodes`:140, `_create_node_panel`:163, `_apply_node_style`:207, `_on_node_gui_input`:222, `paint_edges`:231, `_notification`:252
- dependencias: `res://scripts/ui/TechnologyGraphEdgeLayer.gd`:37

### `epochs-of-ascendancy/scripts/ui/TechnologyMissionTargetPopup.gd` (124 lineas)
- class_name: `TechnologyMissionTargetPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `target_selected`:5
- funciones (7): `_ready`:23, `open_picker`:43, `_present_popup`:59, `_load_targets`:65, `_on_target_selected`:90, `_on_confirm_pressed`:115, `_on_cancel_pressed`:122
- dependencias: `res://scenes/ui/TechnologyMissionTargetPopup.tscn`:44

### `epochs-of-ascendancy/scripts/ui/TechnologyScreen.gd` (806 lineas)
- class_name: `TechnologyScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (36): `_ready`:72, `_exit_tree`:95, `_connect_manager_signals`:104, `_on_research_state_changed`:113, `_setup_view_mode_filter`:118, `_setup_era_slider`:131, `_setup_domain_filter`:140, `_rebuild_domain_filter`:144, `_apply_screen_theme`:180, `_on_close_pressed`:210, `_on_domain_changed`:214, `_on_view_mode_changed`:220, `_on_era_slider_changed`:227, `_on_reset_view_pressed`:237, `_on_graph_node_selected`:242, `_on_open_agents_pressed`:247, `_populate_agent_bar`:265, `_apply_filter_tooltips`:289, `_apply_map_integration_hint`:299, `_strip_bbcode_tags`:317, `_count_entries_by_domain`:321, `_domain_has_active_research`:346, `_domain_filter_tooltip_line`:360, `_on_open_training_pressed`:381, `_on_research_pressed`:387, `_on_cancel_pressed`:394, `refresh_screen`:401, `_apply_view_visibility`:464, `_populate_active_bar`:485, `_populate_research_list`:515, `_populate_graph`:538, `_populate_doctrine_panel`:548, `_create_doctrine_row`:580, `_create_research_row`:625, `_on_row_gui_input`:710, `_update_inspector`:719
- dependencias: `res://scenes/ui/AgentAssignmentScreen.tscn`:253

### `epochs-of-ascendancy/scripts/ui/TopInfoBar.gd` (604 lineas)
- class_name: `TopInfoBar` (linea 2)
- extends: `Control` (linea 3)
- senales: `menu_option_selected`:363
- funciones (34): `_ready`:36, `_apply_theme`:58, `_connect_buttons`:78, `_on_tick`:98, `_set_game_speed`:107, `_update_speed_buttons`:116, `_on_pause_pressed`:126, `_on_game_year_advanced`:134, `_on_game_month_advanced`:138, `_on_game_day_advanced`:143, `_sync_pause_from_time_manager`:147, `_sync_time_manager_controls`:153, `_pause_for_menu`:162, `_update_date_time`:194, `_update_resources`:206, `_close_overlay_screens`:214, `_on_production_pressed`:222, `_on_leaders_pressed`:235, `_on_technology_pressed`:250, `_on_diplomacy_pressed`:262, `_on_agents_pressed`:266, `_on_map_pressed`:281, `_close_screen`:285, `_toggle_screen`:291, `_on_save_pressed`:310, `_on_load_pressed`:314, `_on_menu_pressed`:318, `_on_settings_pressed`:346, `_on_help_pressed`:350, `_show_main_menu_popup_fallback`:365, `_add_menu_button`:411, `_show_save_manager_popup`:443, `_unhandled_input`:521, `_populate_save_list`:543
- dependencias: `res://scenes/ui/MainMenu.tscn`:330
- anomalias: [TODO_FIXME] linea 263: print("Open Diplomacy Screen (TODO)"); [TODO_FIXME] linea 351: print("Open Help (TODO)"); [TODO_FIXME] linea 424: print("TODO: Return to Main Menu (emit signal for scene change)")

### `epochs-of-ascendancy/scripts/ui/TrainingPathScreen.gd` (338 lineas)
- class_name: `TrainingPathScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (21): `open`:35, `_ready`:50, `_exit_tree`:77, `_unhandled_input`:86, `_on_close_pressed`:92, `_on_training_path_invested`:96, `_on_training_path_switched`:101, `refresh_screen`:106, `_apply_theme`:119, `_update_current_path_header`:136, `_style_content_panel`:153, `_populate_available_paths`:165, `_sort_training_path_rows`:186, `_create_path_row`:194, `_append_path_header`:235, `_append_path_description`:252, `_append_path_effect_line`:261, `_build_path_action_button`:275, `_format_effects`:317, `_on_invest_pressed`:326, `_on_switch_pressed`:333
- dependencias: `res://scenes/ui/TrainingPathScreen.tscn`:36

### `epochs-of-ascendancy/scripts/ui_data/AgentScreenData.gd` (19 lineas)
- class_name: `AgentScreenData` (linea 2)
- extends: `Resource` (linea 3)

### `epochs-of-ascendancy/scripts/ui_data/LeaderScreenData.gd` (29 lineas)
- class_name: `LeaderScreenData` (linea 2)
- extends: `Resource` (linea 3)

### `epochs-of-ascendancy/scripts/ui_data/NationalSpiritsScreenData.gd` (12 lineas)
- class_name: `NationalSpiritsScreenData` (linea 2)
- extends: `Resource` (linea 3)

### `epochs-of-ascendancy/scripts/ui_data/ProductionScreenData.gd` (27 lineas)
- class_name: `ProductionScreenData` (linea 2)
- extends: `Resource` (linea 3)

### `epochs-of-ascendancy/scripts/ui_data/TechnologyScreenData.gd` (44 lineas)
- class_name: `TechnologyScreenData` (linea 2)
- extends: `Resource` (linea 3)

### `hoi-4-nueva-version/scripts/agents/Agent.gd` (120 lineas)
- class_name: `Agent` (linea 2)
- extends: `Resource` (linea 3)
- funciones (8): `get_skill`:41, `is_available`:57, `is_inactive`:61, `get_status_group`:65, `is_on_mission`:77, `is_compromised`:81, `add_experience`:85, `get_success_chance_for_mission`:99

### `hoi-4-nueva-version/scripts/agents/AgentGenerator.gd` (57 lineas)
- class_name: `AgentGenerator` (linea 2)
- extends: `Node` (linea 3)
- funciones (2): `generate_agent`:16, `_generate_name`:53

### `hoi-4-nueva-version/scripts/agents/AgentManager.gd` (1502 lineas)
- extends: `Node` (linea 2)
- senales: `agent_recruited`:6, `agent_assigned_to_mission`:7, `mission_completed`:8, `agent_captured`:9, `agent_killed`:10
- funciones (67): `_ready`:42, `_on_game_year_advanced`:65, `_on_game_day_advanced`:75, `_load_mission_definitions`:81, `get_agents_for_country`:99, `get_agent`:104, `recruit_agent`:112, `assign_agent_to_mission`:126, `_mission_allows_home_target`:184, `advance_missions`:188, `_resolve_mission`:204, `_apply_mission_outcome`:254, `set_current_year`:310, `get_current_year`:314, `get_available_agents`:318, `get_mission_definition`:326, `get_network`:332, `get_networks_for_country`:336, `establish_network`:345, `advance_networks`:374, `advance_networks_daily`:393, `_process_network_action`:428, `_process_network_action_daily`:471, `_apply_daily_network_province_effects`:550, `_estimate_enemy_pressure`:617, `get_supply_disruption_in_province`:625, `_handle_network_detection`:632, `get_target_countries_for`:655, `get_mission_categories`:664, `get_eligible_missions_for_agent`:679, `get_agent_screen_data`:719, `invalidate_agent_cache`:728, `get_agent_summary`:735, `_build_agent_screen_data`:742, `_agent_to_summary`:773, `_mission_row_for_agent`:839, `clear_all_agents`:860, `_reset_agent_after_mission`:866, `_handle_post_mission_risk`:876, `_set_agent_compromised`:904, `_release_expired_compromised_agents`:913, `get_recent_operations`:926, `describe_mission_outcome`:978, `_append_mission_history`:982, `_agent_fate_after_mission`:1028, `_format_history_status_line`:1036, `_status_badge_for`:1050, `_recovery_years_remaining`:1066, `_format_agent_status_detail`:1072, `get_intel_reports`:1094, `_intel_tier_label`:1115, `_apply_production_delay`:1127, `_apply_supply_disruption`:1183, `_calculate_sabotage_effect`:1212, `_apply_sabotage_production_debuff`:1246, `_apply_sabotage_supply_debuff`:1277, `_apply_stability_damage`:1307, `_apply_research_theft`:1321, `_establish_long_term_tech_intel`:1358, `_apply_intel_bonus`:1374, `_record_intelligence`:1381, `get_intel_for_country`:1394, `get_intelligence_modifier`:1405, `consume_intel`:1419, `_apply_enemy_agent_disruption`:1435, `_degrade_enemy_intel`:1483, `_apply_tech_protection`:1490
- anomalias: [TODO_FIXME] linea 458: # TODO: Apply actual province-level supply penalty here (reduce throug; [TODO_FIXME] linea 503: # TODO: Apply actual small daily province supply impact here

### `hoi-4-nueva-version/scripts/agents/AgentMissionImpact.gd` (92 lineas)
- class_name: `AgentMissionImpact` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (5): `describe_outcome_result`:8, `describe_mission_outcome`:39, `get_impact_preview`:49, `format_compact_preview`:57, `_format_effect_label`:68

### `hoi-4-nueva-version/scripts/agents/AgentNetwork.gd` (38 lineas)
- class_name: `AgentNetwork` (linea 5)
- extends: `Resource` (linea 6)
- funciones (2): `get_effectiveness`:29, `is_active`:36

### `hoi-4-nueva-version/scripts/ai/AIManager.gd` (492 lineas)
- class_name: `AIManager` (linea 1)
- extends: `Node` (linea 2)
- funciones (36): `_ready`:20, `_initialize_ai_tags`:39, `set_player_tag`:50, `_on_game_day_advanced`:58, `_evaluate_all_ai`:65, `_is_active_belligerent`:71, `_evaluate_nation_ai`:75, `_get_ai_formations`:90, `_get_strategic_objectives`:110, `_issue_ai_orders`:135, `_find_best_move_toward`:160, `_check_historical_triggers`:181, `_has_triggered`:201, `_mark_triggered`:205, `_is_at_war_with`:210, `_on_scenario_loaded`:226, `_sync_player_tag`:232, `_load_adjacency`:239, `_load_1879_scenario_state`:265, `_parse_war_state`:283, `_add_war_pair`:299, `_scenario_country_tags`:314, `_tag_array`:337, `_next_objective_for_formation`:348, `_first_unowned_objectives`:360, `_first_owned_by_objectives`:372, `_has_chile_taken_saltpeter_province`:381, `_province_owner`:388, `_is_valid_ai_move`:394, `_is_bolivia_defensive_target`:414, `get_save_data`:421, `load_save_data`:429, `get_ai_status`:438, `_has_friendly_formation_in_province`:452, `_formation_id_from_data`:462, `_province_graph_distance`:469

### `hoi-4-nueva-version/scripts/autoload/GameData.gd` (18 lineas)
- extends: `Node` (linea 1)
- funciones (3): `_ready`:8, `create_production_line`:12, `get_production_line`:16

### `hoi-4-nueva-version/scripts/autoload/ProductionManager.gd` (1661 lineas)
- extends: `Node` (linea 1)
- senales: `line_registered`:7, `line_removed`:8, `stance_changed`:9, `modifier_registered`:10, `modifier_removed`:11, `day_advanced`:12, `family_experience_changed`:13, `production_completed`:14, `production_progress_updated`:15, `production_resource_shortage`:16, `equipment_added_to_stockpile`:17, `equipment_taken_from_stockpile`:18, `unit_reinforced`:19
- funciones (118): `_ready`:55, `_get_base_daily_points`:70, `_load_retooling_rules`:74, `get_category_similarity`:91, `get_retooling_params`:103, `_retool_group_for_design`:138, `create_line`:144, `remove_line`:160, `get_line`:168, `get_line_ids`:172, `has_line`:179, `set_line_template`:183, `advance_days`:229, `register_modifier`:248, `unregister_modifier`:256, `clear_modifiers_by_source`:263, `set_production_stance`:273, `apply_doctrine`:290, `revoke_doctrine`:299, `apply_focus`:306, `revoke_focus`:315, `get_family_units_produced`:322, `get_active_modifier_ids`:326, `set_stockpile`:333, `add_stockpile`:337, `can_afford`:342, `pay_cost`:349, `add_to_national_stockpile`:360, `take_from_national_stockpile`:369, `get_national_stockpile_amount`:383, `set_national_equipment_stockpile`:387, `get_national_equipment_stockpile`:395, `_on_production_completed`:399, `set_unit_equipment_stock`:407, `get_unit_equipment_stock`:413, `clear_unit_equipment_stock`:420, `get_division_required_equipment`:424, `get_unit_shortages`:435, `get_unit_shortage_report_with_national`:450, `get_unit_readiness_penalty`:458, `get_shortage_report`:463, `_categorize_equipment_shortages`:476, `_is_sustainment_equipment_id`:495, `_is_infantry_equipment_id`:503, `apply_equipment_shortage_modifiers`:511, `get_division_sustainment_readiness_multiplier`:523, `get_division_infantry_stats`:535, `get_division_infantry_combat_multiplier`:547, `get_division_combat_modifiers`:555, `get_division_final_combat_stats`:567, `request_equipment_for_unit`:588, `set_unit_priority_reinforcement`:597, `is_unit_priority_reinforced`:606, `auto_reinforce_unit_from_stockpile`:610, `reinforce_all_units`:638, `daily_reinforcement_tick`:666, `get_line_resource_cost_for_days`:670, `get_design_resource_preview`:680, `has_enough_resources_for_line`:692, `apply_resource_shortage`:696, `_shortage_rules`:705, `_critical_resource_set`:710, `_weighted_fill_ratio`:719, `_shortage_multipliers`:740, `_missing_resources`:761, `evaluate_line_resources`:772, `try_consume_resources_for_line`:820, `consume_resources_for_line`:824, `preview_resource_fill_ratio`:828, `get_line_reliability_profile`:838, `list_line_refinement_options`:845, `start_line_refinement`:852, `_refresh_line_modifiers`:878, `_resolve_modifiers_for_line`:882, `_compute_family_output_bonus`:913, `_compute_cross_line_synergy`:921, `_compute_time_on_design_bonus`:929, `_count_active_lines_for_family`:937, `_same_family_retool_discount`:947, `_template_design_family`:957, `_get_line_owner_tag`:962, `_get_national_production_modifiers`:971, `_on_line_unit_completed`:1001, `_load_modifier_presets`:1016, `_preset_block`:1024, `_load_json_dict`:1029, `_naval_production_allowed`:1042, `_clear_modifiers_with_tag`:1059, `get_line_efficiency`:1069, `get_lines_on_design_in_factory`:1076, `get_concentrated_production_multiplier`:1091, `assign_line_to_factory`:1105, `get_factory_efficiency`:1155, `get_factories_producing`:1161, `get_total_output_for_design`:1172, `get_all_factories_for_country`:1182, `get_factory_summary`:1193, `get_country_production_overview`:1219, `get_factories_producing_design`:1232, `get_production_screen_data`:1239, `invalidate_production_cache`:1248, `clear_all_production_caches`:1252, `clear_all_caches`:1257, `_build_production_screen_data`:1264, `_get_factory_status`:1332, `_get_factory_type`:1340, `_append_to_group`:1359, `reassign_factory`:1365, `get_concentration_bonus`:1447, `get_effective_daily_output`:1456, `get_design_production_info`:1461, `get_save_data`:1494, `apply_save_data`:1524, `daily_production_tick`:1565, `_on_game_day_advanced`:1571, `advance_production`:1575, `_complete_item`:1621, `get_line_progress_info`:1627

### `hoi-4-nueva-version/scripts/autoload/SaveLoadManager.gd` (875 lineas)
- extends: `Node` (linea 135)
- funciones (39): `set_player_tag`:148, `_ready`:153, `_on_year_advanced_for_autosave`:162, `_notification`:173, `_ensure_save_dir`:187, `get_save_path`:193, `list_saves`:207, `_peek_metadata`:230, `save_game`:244, `load_game`:268, `_find_scenario_loader`:304, `_gather_save_data`:312, `_apply_save_data`:414, `_apply_time_state`:473, `_serialize_agent_state`:489, `_agent_to_dict`:508, `_dict_to_agent`:519, `_network_to_dict`:550, `_dict_to_network`:560, `_apply_agent_state`:580, `_serialize_map_state`:609, `_apply_map_state`:630, `_serialize_supply_state`:656, `_apply_supply_state`:673, `_apply_national_modifier_state`:691, `_apply_technology_state`:700, `quicksave`:721, `quickload`:724, `get_last_save_path`:727, `get_saved_scenario_id`:733, `check_scenario_compatibility`:739, `_apply_leader_state`:753, `_apply_factory_state`:760, `_apply_production_state`:766, `_migrate_save_data`:777, `save_game_detailed`:794, `load_game_detailed`:814, `delete_save`:845, `rename_save`:856

### `hoi-4-nueva-version/scripts/autoload/TimeManager.gd` (281 lineas)
- extends: `Node` (linea 40)
- senales: `game_year_advanced`:52, `game_month_advanced`:53, `game_day_advanced`:54
- funciones (22): `_ready`:69, `initialize_from_scenario_start_date`:74, `get_current_year`:99, `get_current_month`:102, `get_current_day`:105, `is_new_day`:110, `advance_one_day`:114, `is_new_month`:119, `advance_one_month`:124, `get_current_date`:128, `get_scenario_start_date`:136, `is_paused`:139, `set_paused`:142, `set_time_scale`:147, `advance_one_year`:152, `advance_year`:158, `sync_year_from_external`:177, `advance_days`:187, `advance_real_time`:239, `_get_days_in_month`:248, `get_save_data`:259, `apply_save_data`:269

### `hoi-4-nueva-version/scripts/combat/CombatResolver.gd` (596 lineas)
- class_name: `CombatResolver` (linea 1)
- extends: `Node` (linea 2)
- funciones (19): `get_effective_combat_power`:7, `apply_training_path_combat_bonuses`:161, `apply_training_path_modifiers`:186, `resolve_combat_experience`:239, `resolve_battle_aftermath`:250, `resolve_formation_destroyed`:313, `get_combat_width_for_battle`:319, `get_province_battle_preview`:375, `_find_scenario_loader`:381, `_get_province_safe`:395, `_get_province_casualty_multiplier`:409, `_get_effects_for_province`:429, `award_xp_from_combat`:446, `_apply_combat_xp_to_leader`:464, `_total_combat_xp_for_leader`:477, `_calculate_combat_xp`:488, `_get_defeat_learning_bonus`:524, `_normalize_battle_result`:542, `_apply_national_combat_modifiers_to_base_stats`:563

### `hoi-4-nueva-version/scripts/combat/CombatWidthCalculator.gd` (67 lineas)
- class_name: `CombatWidthCalculator` (linea 2)
- extends: `Node` (linea 3)
- funciones (8): `_ready`:10, `ensure_rules_loaded`:14, `_load_rules`:20, `get_combat_width`:36, `get_effective_combat_width`:44, `_get_infrastructure_modifier`:50, `get_terrain_width_modifier`:58, `_get_terrain_modifier`:62

### `hoi-4-nueva-version/scripts/core/DesignDataLoader.gd` (161 lineas)
- class_name: `DesignDataLoader` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (14): `load_all`:15, `load_modules`:22, `load_templates`:27, `load_production_rules`:32, `get_module`:40, `get_template`:44, `get_infantry_equipment`:48, `load_sustainment_equipment`:57, `get_sustainment_equipment`:76, `get_refinement_project_defs`:92, `get_refinement_def`:97, `_load_json_objects_from_dir`:104, `_load_json_objects_from_dir_recursive`:110, `_load_json_dict`:146

### `hoi-4-nueva-version/scripts/core/HeadlessProductionTest.gd` (13 lineas)
- extends: `SceneTree` (linea 1)
- funciones (1): `_init`:7

### `hoi-4-nueva-version/scripts/core/HeadlessSupplyTest.gd` (12 lineas)
- extends: `SceneTree` (linea 1)
- funciones (1): `_init`:4
- dependencias: `res://scripts/core/ScenarioLoader.gd`:5, `res://scripts/core/SupplyLineTest.gd`:8

### `hoi-4-nueva-version/scripts/core/HeadlessTradeTest.gd` (70 lineas)
- extends: `SceneTree` (linea 3)
- funciones (3): `_init`:8, `_fail`:19, `_run`:24
- dependencias: `res://scripts/national/TradeManager.gd`:5

### `hoi-4-nueva-version/scripts/core/ProductionLineTest.gd` (1484 lineas)
- class_name: `ProductionLineTest` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (23): `run_all`:7, `_get_production_manager`:32, `_test_production_manager`:39, `_test_data_loaded`:75, `_test_retooling_similarity`:86, `_test_production_and_tooling`:101, `_test_new_design_reliability_debuff`:119, `_test_refinement`:141, `_test_cargo_logistics`:158, `_test_armed_cargo_penalty`:185, `_test_armed_merchant_template`:220, `_test_equipment_shortages`:251, `_test_national_equipment_stockpile`:288, `_test_infantry_equipment_stats`:333, `_test_priority_reinforcement`:380, `_test_sustainment_equipment`:421, `_test_combat_resolver`:511, `_test_combat_width`:673, `_test_formation_spawner`:706, `_test_leader_manager`:766, `_test_assignment_screen_backends`:1344, `_cleanup_test_factory`:1455, `_test_refinement_tradeoffs`:1465

### `hoi-4-nueva-version/scripts/core/ScenarioCountryRuntime.gd` (167 lineas)
- class_name: `ScenarioCountryRuntime` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (8): `resolve_countries`:7, `parse_country_color`:28, `_entries_from_refs`:53, `_entries_from_countries_block`:66, `_entry_from_reference_or_inline`:85, `_entry_from_reference`:111, `_find_country_file_by_tag`:133, `_read_country_file`:154

### `hoi-4-nueva-version/scripts/core/ScenarioDataResolver.gd` (89 lineas)
- class_name: `ScenarioDataResolver` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (5): `load_scenario_data`:10, `_read_scenario_file`:42, `_read_json_file`:66, `_directory_for_path`:80, `_failure`:87

### `hoi-4-nueva-version/scripts/core/ScenarioFactoryBootstrap.gd` (149 lineas)
- class_name: `ScenarioFactoryBootstrap` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (9): `spawn_factories`:10, `_iter_countries`:76, `_resolve_key_provinces`:95, `_base_factory_count`:111, `_shipyard_levels_for_country`:121, `_default_major_power`:129, `_default_naval_power`:133, `_province_has_port`:137, `_factory_manager`:144

### `hoi-4-nueva-version/scripts/core/ScenarioLoader.gd` (545 lineas)
- class_name: `ScenarioLoader` (linea 1)
- extends: `Node` (linea 2)
- senales: `scenario_loaded`:24
- funciones (34): `get_current_scenario_name`:26, `_ready`:29, `load_province_geometry`:34, `load_province_layers`:73, `_load_json_dict`:82, `_load_adjacency_layer`:98, `_load_terrain_layer`:105, `_load_city_layer`:112, `_load_resources_layer`:119, `_load_economy_layer`:126, `_load_state_and_region_layers`:133, `_load_project_sites_layer`:160, `load_base_provinces`:176, `load_scenario`:221, `_spawn_scenario_factories`:270, `_parse_scenario_start_year`:274, `_load_scenario_leaders`:282, `_apply_scenario_starting_technology`:297, `_spawn_scenario_formations`:306, `_get_formation_spawn_countries`:321, `_get_formation_counts_for_scenario`:331, `get_country`:345, `get_map_data`:349, `build_geometry_dict_for_map`:355, `_infer_port_access_for_all`:381, `_rebuild_adjacency_system`:397, `get_city_layer`:406, `get_city_count`:410, `_duplicate_province_from_base`:421, `_string_array_from_json`:444, `_merged_special_features_from`:453, `_special_level_coerce`:476, `_apply_geometry_to_province`:488, `_apply_layer_data_to_province`:516

### `hoi-4-nueva-version/scripts/core/ScenarioProvinceApplier.gd` (104 lineas)
- class_name: `ScenarioProvinceApplier` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (5): `apply_overrides`:5, `_apply_province_override`:24, `_string_array_from_json`:62, `_merged_special_features_from`:71, `_special_level_coerce`:94

### `hoi-4-nueva-version/scripts/core/SupplyLineTest.gd` (210 lineas)
- class_name: `SupplyLineTest` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (10): `run_all`:5, `_rules_and_adjacency`:17, `_test_hubs_built`:28, `_province_tag`:38, `_test_route_timing`:44, `_test_reroute_longer`:77, `_test_unit_supply_profile`:124, `_test_intel_from_forces`:141, `_test_multimodal_routing`:162, `_test_attrition_cargo`:201
- dependencias: `res://scripts/supply/SupplyManager.gd`:147

### `hoi-4-nueva-version/scripts/core/TestRunner.gd` (118 lineas)
- extends: `Node` (linea 2)
- funciones (6): `_ready`:11, `_go_to_nation_select`:83, `_resolve_player_tag`:87, `_configure_top_info_bar`:99, `_wire_factory_province_lookup`:105, `_run_production_line_tests`:114

### `hoi-4-nueva-version/scripts/core/VictoryConditions.gd` (273 lineas)
- extends: `Node` (linea 1)
- senales: `victory_achieved`:22
- funciones (17): `_ready`:56, `_try_connect_loader`:71, `_on_scenario_loaded`:81, `_is_1879_scenario`:87, `_on_game_day_advanced`:95, `_on_province_captured`:116, `_check_victory_conditions`:120, `_evaluate_victory_conditions`:135, `_trigger_victory`:191, `get_victory_status`:201, `_holder_of`:214, `_controls`:227, `_saltpeter_count_controlled_by`:232, `_date_value`:243, `_current_date_value`:252, `_days_until_deadline`:263, `_is_war_active`:269

### `hoi-4-nueva-version/scripts/data/AdjacencySystem.gd` (320 lineas)
- class_name: `AdjacencySystem` (linea 5)
- extends: `RefCounted` (linea 6)
- funciones (21): `load_adjacency`:25, `register_province`:70, `begin_bulk_registration`:78, `end_bulk_registration`:82, `get_neighbors`:88, `get_land_neighbors`:95, `get_sea_neighbors`:103, `are_adjacent`:111, `shortest_path`:119, `get_connected_component`:128, `_shortest_path_bfs`:149, `_shortest_path_dijkstra`:172, `_reconstruct_path`:205, `_edge_movement_cost`:222, `_undirected_key`:230, `_movement_neighbors_packed`:236, `_invalidate_neighbor_caches`:248, `_ensure_neighbor_caches`:254, `_packed32_to_array_int`:276, `_packed_has_neighbor`:284, `_load_straits_from_root`:292

### `hoi-4-nueva-version/scripts/data/Country.gd` (17 lineas)
- class_name: `Country` (linea 2)
- extends: `Resource` (linea 3)
- funciones (1): `get_color`:15

### `hoi-4-nueva-version/scripts/data/EquipmentModule.gd` (56 lineas)
- class_name: `EquipmentModule` (linea 1)
- extends: `Resource` (linea 2)
- funciones (3): `from_dict`:22, `_dict_from_variant`:43, `_string_array`:49

### `hoi-4-nueva-version/scripts/data/MapScenarioData.gd` (41 lineas)
- class_name: `MapScenarioData` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (3): `coerce_countries`:12, `coerce_provinces`:22, `_init`:31

### `hoi-4-nueva-version/scripts/data/Province.gd` (172 lineas)
- class_name: `Province` (linea 2)
- extends: `Resource` (linea 3)
- funciones (14): `get_movement_cost`:41, `resolve_has_port`:52, `has_feature`:67, `get_feature_level`:71, `_resolved_feature_key`:87, `get_supply_throughput_modifier`:105, `get_local_supply_generation_modifier`:110, `get_combat_width_modifier`:115, `get_organization_recovery_modifier`:121, `get_reinforcement_speed_modifier`:127, `get_attrition_modifier`:132, `get_logistics_quality`:138, `get_interdiction_resistance_modifier`:145, `_base_terrain_movement_multiplier`:152

### `hoi-4-nueva-version/scripts/data/UnitTemplate.gd` (242 lineas)
- class_name: `UnitTemplate` (linea 1)
- extends: `Resource` (linea 2)
- funciones (22): `get_module_ids`:58, `count_filled_slots`:67, `get_base_reliability`:71, `get_stat`:75, `get_fuel_consumption`:79, `get_supply_need`:83, `get_daily_supply_draw`:88, `from_dict`:93, `_parse_infantry_equipment_stats`:150, `get_required_equipment`:158, `is_infantry_equipment`:162, `get_infantry_equipment_stats`:171, `get_infantry_stats`:175, `get_infantry_generation_multiplier`:186, `get_daily_resource_cost_dict`:190, `get_production_point_cost`:196, `get_production_cost_breakdown`:203, `get_inferred_production_category`:210, `get_inferred_production_era`:216, `_dict_from_variant`:220, `_float_dict_from_variant`:226, `_string_array`:235

### `hoi-4-nueva-version/scripts/events/EventManager.gd` (227 lineas)
- class_name: `EventManager` (linea 1)
- extends: `Node` (linea 2)
- senales: `event_triggered`:4, `event_effect_applied`:5
- funciones (12): `_ready`:12, `_load_all_events`:19, `_load_event_file`:38, `_on_game_day_advanced`:60, `_evaluate_all_events`:64, `_check_trigger`:79, `_check_date_trigger`:109, `_fire_event`:125, `_apply_effect`:139, `_modifiers_are_debuff`:212, `get_save_data`:219, `load_save_data`:225

### `hoi-4-nueva-version/scripts/formations/Formation.gd` (81 lineas)
- class_name: `Formation` (linea 2)
- extends: `Resource` (linea 3)
- funciones (5): `has_leader`:41, `assign_leader`:45, `remove_leader`:53, `get_category`:58, `from_division_template`:70

### `hoi-4-nueva-version/scripts/formations/FormationSpawner.gd` (42 lineas)
- class_name: `FormationSpawner` (linea 2)
- extends: `Node` (linea 3)
- funciones (1): `spawn_test_formations_for_country`:15

### `hoi-4-nueva-version/scripts/leaders/Leader.gd` (243 lineas)
- class_name: `Leader` (linea 2)
- extends: `Resource` (linea 3)
- funciones (29): `add_experience`:51, `get_experience`:63, `has_enough_experience`:67, `spend_experience`:71, `add_trait_unchecked`:80, `add_trait`:88, `has_trait`:97, `is_available_for_command`:101, `is_assigned_to_training`:110, `is_in_combat_role`:114, `get_trait_level`:118, `_get_trait_effects`:124, `_effect_float`:130, `_effective_skill`:134, `get_attack_modifier`:138, `get_defense_modifier`:148, `get_organization_modifier`:154, `get_logistics_modifier`:161, `get_planning_modifier`:169, `get_initiative_modifier`:173, `get_supply_consumption_modifier`:177, `get_breakthrough_modifier`:181, `get_combat_width_modifier`:185, `get_casualties_modifier`:189, `get_terrain_modifier`:195, `has_training_path`:220, `get_training_path_level`:224, `set_training_path`:228, `clear_training_path`:241

### `hoi-4-nueva-version/scripts/leaders/LeaderGenerator.gd` (101 lineas)
- class_name: `LeaderGenerator` (linea 2)
- extends: `Node` (linea 3)
- funciones (4): `create_leader_from_data`:15, `_apply_traits_from_data`:53, `generate_leader`:72, `_generate_name`:99

### `hoi-4-nueva-version/scripts/leaders/LeaderManager.gd` (3541 lineas)
- extends: `Node` (linea 2)
- senales: `leader_died`:6, `leader_captured`:7, `leader_retirement_offered`:8, `leader_retired`:9, `leader_introduced`:10, `game_year_advanced`:11, `leader_experience_gained`:12, `trait_leveled`:13, `training_path_invested`:14, `training_path_switched`:15, `officer_training_quality_notice`:16, `leader_replacement_needed`:17, `leader_replacement_resolved`:18
- funciones (209): `_apply_national_position_cost`:69, `_ready`:189, `register_leader`:200, `assign_leader_to_army`:208, `unassign_leader_from_army`:221, `get_leader`:230, `get_leader_for_army`:234, `register_formation`:248, `get_formation`:256, `get_formations_for_country`:260, `assign_leader_to_formation`:269, `unassign_leader_from_formation`:295, `register_division_formations_for_country`:308, `clear_all_formations`:331, `get_available_formations`:336, `_unassign_leader_from_current_formation`:360, `_is_leader_valid_for_formation`:369, `_infer_division_country_tag`:383, `get_valid_leader_types_for_position`:404, `can_assign_national_position`:420, `set_country_position`:464, `get_country_position_leader`:505, `get_national_bonuses`:515, `get_national_combat_modifiers`:549, `_get_combined_national_combat_modifiers`:575, `get_leaders_for_country`:596, `get_available_leaders`:608, `get_current_year`:623, `set_current_year`:630, `get_leader_age`:638, `get_pool_leader_count`:650, `is_leader_entry_active_for_year`:662, `get_yearly_death_chance`:672, `get_yearly_retirement_chance`:684, `_base_chance_for_age`:695, `get_combat_death_chance_per_battle`:702, `get_formation_destroyed_fate_chance`:712, `roll_combat_battle_casualty`:724, `handle_formation_destroyed`:745, `_combat_casualty_trait_multiplier`:793, `_mortality_situation_multiplier`:806, `check_leader_mortality`:827, `resolve_retirement`:854, `apply_retirement_honors`:885, `get_national_prestige`:896, `get_national_unity`:900, `advance_game_year`:904, `introduce_eligible_leaders_for_year`:925, `_remove_leader`:947, `set_player_country_tag`:971, `get_player_country_tag`:977, `is_player_country`:985, `get_pending_replacement_count`:989, `get_pending_leader_replacements`:993, `_prune_stale_leader_replacement_requests`:1004, `get_leader_replacement_request`:1011, `dismiss_leader_replacement`:1018, `get_replacement_candidates`:1022, `pick_auto_replacement_leader`:1052, `apply_auto_replacement`:1056, `try_instant_player_replacement`:1067, `resolve_leader_replacement`:1084, `_enqueue_leader_replacement_requests`:1123, `_build_replacement_request`:1161, `_enqueue_formation_command_vacancy`:1187, `_push_leader_replacement_request`:1217, `_is_replacement_request_still_valid`:1233, `_auto_resolve_replacement_for_ai`:1253, `_remove_leader_replacement_request`:1260, `_pick_auto_replacement_leader_id`:1267, `_is_leader_eligible_replacement`:1285, `_score_replacement_candidate`:1307, `_valid_leader_types_for_formation`:1324, `_position_display_label`:1338, `_clear_leader_from_national_positions`:1354, `_apply_officer_training_death_debuff`:1369, `get_armies_without_leader`:1388, `get_leader_summary`:1393, `get_country_leader_overview`:1435, `get_leader_screen_data`:1453, `invalidate_leader_cache`:1462, `clear_all_leader_caches`:1466, `_build_leader_screen_data`:1470, `_get_skill_tier`:1536, `_get_leader_type_name`:1553, `_append_leader_to_group`:1567, `award_xp_to_leader`:1575, `award_xp_to_formation_leaders`:1589, `get_passive_xp_for_leader`:1598, `process_passive_xp`:1620, `calculate_combat_xp_from_result`:1628, `award_combat_xp`:1641, `process_weekly_leader_xp`:1655, `award_battle_xp_to_participants`:1680, `get_leader_id_for_army`:1695, `set_country_at_war`:1702, `award_major_victory_xp`:1708, `award_high_risk_operation_xp`:1712, `get_trait_level`:1721, `get_trait_data`:1729, `get_trait_level_cost`:1734, `can_level_trait`:1742, `level_trait`:1764, `_level_trait_once`:1773, `get_available_training_paths`:1801, `get_leader_training_path_level`:1834, `invest_xp_in_training_path`:1844, `switch_training_path`:1872, `leader_has_training_path`:1906, `get_training_path_definition`:1913, `get_training_path_max_level`:1917, `get_training_path_doctrine_requirement`:1924, `get_training_path_effects_at_level`:1929, `get_leader_training_path_effects`:1933, `get_leader_training_path_combat_modifiers`:1954, `get_leader_final_combat_stats`:1975, `get_leader_training_path_supply_modifiers`:1989, `resolve_leader_id_for_formation`:2012, `apply_supply_consumption_for_leader`:2021, `apply_attrition_for_leader`:2029, `apply_reinforcement_rate_for_leader`:2037, `apply_training_path_supply_to_stats`:2045, `get_training_path_reinforcement_multiplier`:2072, `get_training_path_data`:2076, `get_training_path_level_cost`:2080, `get_training_path_switch_cost`:2085, `can_invest_training_path`:2093, `can_switch_training_path`:2106, `get_leader_training_path_state`:2122, `get_available_training_paths_for_leader`:2133, `get_leader_training_path_summary`:2158, `_load_training_paths`:2189, `_get_training_path_data`:2219, `_get_training_path_effects`:2227, `_country_has_doctrine`:2243, `_load_training_path_definitions`:2251, `get_country_military_doctrines`:2255, `set_country_military_doctrine`:2270, `country_has_military_doctrine`:2284, `leader_meets_training_path_doctrine`:2288, `get_leader_trait_display_data`:2299, `get_potential_traits_for_leader`:2342, `_get_unlock_reason`:2366, `award_battle_experience`:2384, `award_combat_experience_for_army`:2389, `get_trait_level_up_cost`:2399, `can_spend_xp_on_trait`:2407, `spend_xp_on_trait`:2422, `get_trait_display_list`:2439, `format_trait_effects_text`:2448, `_format_effect_label`:2459, `_format_effect_value`:2517, `_check_for_trait_gain`:2529, `handle_injury_or_capture`:2540, `promote_leader`:2556, `create_and_register_new_leader`:2570, `set_officer_training_leader`:2583, `get_officer_training_leader`:2627, `clear_officer_training_leader`:2645, `get_save_data`:2664, `apply_save_data`:2680, `assign_leader_to_officer_training`:2742, `unassign_officer_training_leader`:2750, `get_officer_training_quality`:2765, `get_officer_training_months`:2770, `get_officer_training_debuff_months`:2776, `get_officer_training_cadet_prestige_cost`:2783, `get_officer_training_quality_display`:2792, `get_officer_training_status_text`:2818, `get_officer_training_suitability`:2838, `advance_officer_training_progress`:2865, `_advance_officer_training_progress_for_country`:2886, `_check_training_quality_changes`:2926, `generate_new_leader_from_training`:2949, `_get_effective_officer_training_quality`:2977, `_pick_officer_cadet_leader_type`:2985, `_country_has_naval_technology`:2999, `_country_has_air_technology`:3007, `_generate_officer_cadet_name`:3015, `_officer_cadet_rank_prefix`:3118, `_roll_officer_cadet_skills`:3130, `_apply_officer_cadet_trait_inheritance`:3162, `_get_positive_traits`:3185, `_get_negative_traits`:3197, `_is_officer_training_flaw_trait`:3209, `generate_and_register_leader_from_training`:3215, `get_trait_definition`:3237, `get_trait_max_level`:3244, `get_trait_rarity`:3251, `get_trait_effects_at_level`:3256, `get_leader_trait_effects`:3273, `count_traits_by_rarity`:3286, `traits_conflict`:3294, `can_add_trait`:3314, `try_add_trait_to_leader`:3335, `_load_trait_definitions`:3350, `_read_trait_json_file`:3356, `get_leader_roster_paths_for_scenario`:3369, `get_leaders_path_for_scenario`:3386, `load_leaders_for_scenario`:3393, `reload_leaders_from_json`:3400, `reload_leaders_from_roster_paths`:3406, `_roster_paths_are_modern_isolated`:3468, `_leader_entry_valid_for_modern_roster`:3472, `_load_leader_entries_from_path`:3482, `load_leaders_from_json`:3502, `load_historical_leaders`:3508, `_historical_leader_entries_from_data`:3515, `_leader_from_dict`:3536
- anomalias: [TODO_FIXME] linea 3000: # TODO: Replace with national naval technology/focus unlock checks whe; [TODO_FIXME] linea 3008: # TODO: Replace with national air technology/focus unlock checks when ; [TODO_FIXME] linea 3017: # TODO: Proper per-country/culture name lists for generated leaders (s

### `hoi-4-nueva-version/scripts/localization/LanguageManager.gd` (92 lineas)
- extends: `Node` (linea 26)
- senales: `language_changed`:33
- funciones (8): `_ready`:35, `get_current_language`:40, `set_language`:43, `get_available_languages`:56, `get_language_display_name`:65, `get_fallback_language`:74, `_load_saved_language`:77, `_save_language_preference`:88

### `hoi-4-nueva-version/scripts/localization/Localization.gd` (59 lineas)
- extends: `Node` (linea 24)
- senales: `language_changed`:26
- funciones (7): `_ready`:28, `get_text`:32, `get_current_language`:37, `set_language`:42, `get_available_languages`:47, `get_language_display_name`:52, `_on_language_changed`:57

### `hoi-4-nueva-version/scripts/localization/LocalizationSettings.gd` (62 lineas)
- extends: `Node` (linea 25)
- funciones (2): `save_language_preference`:31, `load_language_preference`:49

### `hoi-4-nueva-version/scripts/localization/TranslationProvider.gd` (115 lineas)
- extends: `Node` (linea 27)
- funciones (11): `_ready`:34, `get_text`:40, `reload_language`:51, `get_missing_keys`:55, `_load_all_languages`:58, `_load_language`:69, `_load_language_file`:77, `_get_translation`:96, `_interpolate_parameters`:101, `_register_missing_key`:108, `_on_language_changed`:112

### `hoi-4-nueva-version/scripts/map/AgentNetworkLayer.gd` (396 lineas)
- class_name: `AgentNetworkLayer` (linea 4)
- extends: `Node` (linea 5)
- funciones (15): `_ready`:28, `setup`:39, `set_highlight_province`:43, `trigger_daily_pulse`:50, `is_daily_pulse_active`:57, `_process`:61, `_on_province_data_changed`:79, `_on_daily_tick`:84, `count_active_networks`:88, `_get_camera_world_rect`:107, `_draw`:127, `_enemy_pressure`:193, `_draw_pressure_status_bars`:206, `_draw_pressure_glyph`:259, `_draw_network_ring`:291

### `hoi-4-nueva-version/scripts/map/CameraController.gd` (136 lineas)
- class_name: `CameraController` (linea 3)
- extends: `Node` (linea 4)
- funciones (8): `_ready`:24, `_process`:34, `_apply_wasd`:59, `_apply_edge_pan`:74, `_input`:95, `_unhandled_input`:108, `_zoom_toward_mouse`:124, `_adjust_origin_for_uniform_zoom`:132

### `hoi-4-nueva-version/scripts/map/ConflictOverlayLayer.gd` (199 lineas)
- class_name: `ConflictOverlayLayer` (linea 5)
- extends: `Node` (linea 6)
- funciones (16): `set_highlight_province`:22, `setup`:29, `setup_with_map`:36, `_ready`:46, `_on_province_data_changed`:53, `refresh`:58, `_is_contested`:62, `count_contested`:68, `_draw`:79, `_collect_contested`:85, `_draw_contested_province`:112, `_province_node_offset`:136, `_polygon_points_for`:145, `_offset_points`:158, `_draw_polygon_hatch`:168, `_draw_centroid_hatch`:188

### `hoi-4-nueva-version/scripts/map/Factory.gd` (188 lineas)
- class_name: `Factory` (linea 2)
- extends: `Resource` (linea 3)
- funciones (17): `make_id`:40, `province_from_id`:44, `slot_from_id`:49, `apply_damage`:53, `start_repair`:58, `advance_repair`:62, `get_daily_output_estimate`:83, `get_production_efficiency`:88, `start_retooling`:92, `get_current_efficiency`:112, `advance_retooling`:126, `get_available_line_slots`:146, `can_add_more_lines`:150, `has_assigned_line`:154, `sync_production_design`:158, `_recalculate_efficiency`:162, `_get_rules`:174

### `hoi-4-nueva-version/scripts/map/MapDataValidator.gd` (355 lineas)
- class_name: `MapDataValidator` (linea 15)
- extends: `RefCounted` (linea 16)
- funciones (10): `validate_all`:46, `format_report`:85, `_add`:120, `_load_dict`:124, `_validate_base`:141, `_validate_geometry`:174, `_validate_adjacency`:212, `_validate_layer_keys`:252, `_validate_grouping`:277, `_validate_project_sites`:339

### `hoi-4-nueva-version/scripts/map/MapManager.gd` (818 lineas)
- extends: `Node` (linea 12)
- senales: `scenario_map_ready`:22, `provinces_loaded`:23, `province_hovered`:24, `province_selected`:25, `province_owner_changed`:26, `province_data_changed`:27
- funciones (65): `_ready`:45, `_connect_to_scenario_loader`:54, `_on_scenario_loaded`:63, `_pull_from_loader`:68, `initialize_from_map_data`:75, `has_province_data`:99, `get_province`:102, `get_all_provinces`:105, `get_province_geometry`:108, `get_adjacency_system`:111, `get_country`:114, `get_player_country_tag_fallback`:119, `get_province_effects`:127, `get_effective_interdiction_resistance`:143, `get_effective_reinforcement_speed`:147, `get_effective_organization_recovery`:151, `get_effective_attrition_multiplier`:155, `get_effective_logistics_quality`:159, `get_province_or_null`:165, `force_initialize`:169, `get_provinces_by_owner`:177, `get_province_owner`:188, `get_provinces_by_controller`:194, `get_adjacent_provinces`:208, `get_provinces_in_rect`:217, `get_province_centroid`:231, `get_all_centroids`:234, `get_world_bounds`:238, `get_province_at_world_pos`:246, `get_province_at_screen_pos`:263, `get_nearest_provinces`:270, `get_province_at_mouse`:289, `get_provinces_with_feature`:297, `get_provinces_by_terrain`:305, `get_centroids_in_rect`:315, `get_overlay_data_for_province`:326, `get_contested_provinces`:350, `get_agent_pressure_map`:369, `get_agent_network_overlay_data`:393, `set_province_owner`:416, `update_province_owner`:428, `update_province_development`:456, `update_province_infrastructure`:466, `notify_province_changed`:477, `clear_daily_sabotage_effects`:486, `_on_game_day_advanced`:510, `advance_daily_infrastructure_repair`:523, `get_infrastructure_repair_breakdown`:558, `get_infrastructure_repair_rate`:618, `get_engineer_brigades_in_province`:622, `_repair_country_tag`:642, `_engineer_repair_bonus`:651, `_depot_sabotage_level`:661, `_province_under_infra_sabotage`:670, `_clear_internal_caches`:685, `_recompute_centroids_and_bounds`:697, `_aabb_from_points`:742, `_compute_centroid`:756, `_try_build_pick_grid`:783, `get_province_count`:791, `is_ready`:794, `has_pick_grid`:797, `rebuild_pick_grid`:802, `configure_picker`:808, `is_spatial_picking_available`:816

### `hoi-4-nueva-version/scripts/map/MapPickGrid.gd` (283 lineas)
- class_name: `MapPickGrid` (linea 24)
- extends: `RefCounted` (linea 25)
- funciones (18): `build`:50, `clear`:76, `is_built`:85, `get_province_at`:92, `get_nearest_provinces`:142, `_world_to_cell`:168, `_add_to_cell`:171, `_get_cells_in_radius`:176, `_update_bounds`:183, `_brute_force_best_in_candidates`:202, `_point_in_polygon`:222, `get_cell_count`:240, `get_province_count`:243, `get_cell_for_world_pos`:246, `debug_get_ids_in_cell`:249, `get_grid_stats`:253, `debug_get_candidates_around`:264, `_approx_polygon_area`:274

### `hoi-4-nueva-version/scripts/map/MapRenderer.gd` (2362 lineas)
- class_name: `MapRenderer` (linea 2)
- extends: `Node` (linea 3)
- funciones (118): `_ready`:128, `_init_legend_calendar_tracking`:159, `_connect_map_manager_signals`:167, `_on_map_province_data_changed`:174, `_connect_battle_manager_signals`:183, `_on_province_captured`:192, `_on_battle_resolved`:196, `_connect_time_manager_signals`:208, `_on_game_day_advanced_legend`:219, `_on_time_advanced_refresh_legend`:238, `_note_time_boundary_for_legend`:243, `_try_set_map_time_pulse`:271, `_refresh_map_time_ui`:284, `_get_active_map_time_pulse_bbcode`:291, `_expire_map_time_pulse_if_needed`:299, `_setup_inspector_extras`:310, `_setup_hover_tooltip`:328, `_input`:337, `_unhandled_input`:347, `_process`:386, `_handle_camera_input`:403, `_zoom_toward_mouse`:439, `_screen_to_world`:461, `_on_close_pressed`:468, `_refresh_province_detail_visibility`:472, `initialize`:492, `render_provinces`:500, `_create_province_node`:538, `_create_or_update_province_name_label`:603, `_count_special_icons`:632, `_feature_icon_offsets_radial`:640, `_make_centroid_debug_marker`:653, `_calculate_centroid`:666, `_get_province_color`:696, `_on_province_clicked`:735, `_connect_unit_movement_signals`:741, `_on_formation_selected`:752, `_on_move_completed`:759, `_on_movement_invalid`:766, `highlight_selected_province`:771, `clear_province_highlight`:784, `highlight_valid_move_targets`:793, `clear_move_highlights`:808, `_province_points`:816, `draw_unit_icons`:824, `_nation_color`:854, `_on_province_input`:877, `_clear_selection`:894, `_select_province`:904, `_clear_hover_state`:925, `_on_mouse_entered`:939, `_on_mouse_exited`:951, `_refresh_hover_tooltip`:959, `_set_conflict_highlight`:1028, `_set_agent_highlight`:1034, `_is_compare_candidate`:1040, `_battle_counterpart_for_hover`:1046, `_hide_hover_tooltip`:1056, `_update_spatial_hover`:1063, `show_info_panel`:1096, `hide_info_panel`:1158, `add_overlay_layer`:1167, `remove_overlay_layer`:1177, `get_active_overlay_layers`:1184, `get_overlay_layer`:1198, `_setup_conflict_layer`:1203, `setup_demo_conflict_overlay`:1222, `_setup_agent_layer`:1226, `setup_demo_agent_overlay`:1242, `_setup_supply_layer`:1255, `_ensure_supply_overlay_panel`:1269, `_player_tag`:1323, `_supply_manager`:1330, `build_supply_network`:1334, `_toggle_supply_overlay`:1346, `_refresh_supply_routes`:1369, `_handle_supply_province_click`:1378, `_show_supply_preview`:1397, `_update_supply_menu`:1406, `_on_supply_mode_changed`:1424, `_on_supply_commit`:1431, `_on_supply_clear_waypoints`:1440, `_on_supply_close_overlay`:1447, `_end_supply_reroute`:1451, `_refresh_province_fill_colors`:1458, `_province_polygon`:1479, `_province_node`:1486, `_get_province_polygon`:1492, `_apply_hover_visuals`:1501, `_hover_outline_colors`:1523, `_set_hover_outline`:1584, `_set_selection_outline`:1620, `_clear_compare_preview_outline`:1669, `_update_compare_preview_outline`:1675, `refresh_province_color`:1685, `_refresh_single_province_fill`:1691, `_province_has_support_radio_benefit`:1712, `_apply_support_radio_fill_tint`:1725, `_apply_recovering_fill_tint`:1734, `_apply_agent_pressure_base_tint`:1755, `_apply_hover_fill`:1771, `_update_outline_pulse`:1832, `_refresh_compare_candidate_outlines`:1955, `_set_compare_candidate_outline`:1972, `_set_compare_preview_outline`:1998, `_supply_highlight_roles`:2017, `_apply_infra_pressure_overlay_roles`:2057, `_pulse_supply_outlines`:2092, `_pulse_amount_for_supply_role`:2118, `_refresh_supply_highlights`:2136, `_update_supply_overlay_legend`:2160, `_update_supply_legend_text`:2196, `_apply_supply_legend_time_pulse_style`:2223, `_update_compare_hint_label`:2241, `_set_supply_legend_visible`:2308, `_supply_depot_tint_color`:2319, `_on_open_national_spirits_pressed`:2327, `_get_feature_icon`:2350
- dependencias: `res://scenes/ui/NationalSpiritsScreen.tscn`:2335

### `hoi-4-nueva-version/scripts/map/MapTechnologyContext.gd` (390 lineas)
- class_name: `MapTechnologyContext` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (22): `get_map_integration_note`:16, `has_support_radio_bonuses`:33, `_support_bonus_parts`:44, `build_support_radio_glance_bbcode`:55, `build_technology_status_chip`:62, `_support_bonus_plain`:84, `build_support_radio_compact_chip`:91, `build_support_route_summary_plain`:106, `build_national_support_line_bbcode`:124, `build_support_recovery_hint_bbcode`:136, `build_support_supply_effect_bbcode`:145, `build_province_support_benefit_bbcode`:161, `build_support_radio_inspector_block`:182, `build_country_research_glance_bbcode`:194, `build_province_production_tech_bbcode`:208, `build_province_technology_bbcode`:240, `get_build_mode_preview`:258, `_province_owned_by`:278, `_completed_count`:286, `_build_target_placeholder`:296, `is_design_buildable_in_province`:332, `get_province_build_lock_reason`:369

### `hoi-4-nueva-version/scripts/map/MapViewInput.gd` (49 lineas)
- class_name: `MapViewInput` (linea 4)
- extends: `RefCounted` (linea 5)
- funciones (2): `motion_delta`:13, `edge_pan_blocked_by_gui`:26

### `hoi-4-nueva-version/scripts/map/ProvinceEffects.gd` (89 lineas)
- class_name: `ProvinceEffects` (linea 7)
- extends: `RefCounted` (linea 8)
- funciones (10): `_init`:13, `get_effective_throughput_multiplier`:18, `get_effective_local_supply_generation`:23, `get_effective_combat_width_multiplier`:29, `get_effective_organization_recovery`:34, `get_effective_attrition_multiplier`:39, `get_effective_logistics_quality`:46, `get_effective_reinforcement_speed`:51, `get_effective_interdiction_resistance`:57, `for_country_province`:64

### `hoi-4-nueva-version/scripts/map/ProvinceFactoryComponent.gd` (61 lineas)
- class_name: `ProvinceFactoryComponent` (linea 8)
- extends: `Node` (linea 9)
- funciones (6): `_ready`:17, `add_factory`:22, `get_factories`:36, `get_active_factories`:40, `capture_all_factories`:44, `_factory_manager`:59

### `hoi-4-nueva-version/scripts/map/ProvinceHoverTooltip.gd` (336 lineas)
- class_name: `ProvinceHoverTooltip` (linea 1)
- extends: `PanelContainer` (linea 2)
- funciones (14): `_ready`:24, `set_supply_accent`:49, `set_compare_accent`:56, `set_selected_accent`:63, `set_candidate_accent`:70, `set_conflict_accent`:77, `set_agent_accent`:84, `set_tech_accent`:91, `set_support_accent`:98, `set_agent_activity_accent`:105, `set_agent_pressure_kind`:112, `_apply_panel_style`:120, `show_text`:267, `hide_tooltip`:334

### `hoi-4-nueva-version/scripts/map/ProvinceInsight.gd` (3814 lineas)
- class_name: `ProvinceInsight` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (158): `build_hover_tooltip`:45, `build_inspector_text`:93, `build_inspector_full_bbcode`:100, `get_province_effects_for`:184, `build_at_a_glance_logistics`:200, `build_at_a_glance_combat`:213, `build_combat_summary_for_inspector`:225, `build_national_rollup_bbcode`:265, `build_routes_through_province_bbcode`:285, `_bbcode_inner`:339, `build_tooltip_mode_chip_for_state`:350, `_supply_role_label`:563, `build_supply_role_hint_bbcode`:587, `_supply_role_icon`:593, `build_inspector_conflict_section`:617, `build_overlay_layers_summary_bbcode`:629, `province_benefits_country`:659, `build_layers_symbol_key_bbcode`:663, `build_compact_layers_summary_bbcode`:690, `build_compact_layers_counts_line`:729, `build_supply_multi_overlay_block_bbcode`:747, `build_map_supply_mode_hint_plain`:771, `build_inspector_technology_section`:798, `build_province_situation_tags`:818, `_province_matches_country`:860, `build_compare_situation_note`:869, `_compare_production_tech_note`:885, `count_dual_situation_provinces`:900, `build_supply_overlay_quick_key_bbcode`:912, `build_supply_legend_bbcode`:940, `build_map_compare_hint_plain`:1116, `build_supply_overlay_bbcode`:1145, `build_info_logistics_text`:1212, `build_info_combat_text`:1225, `build_national_effects_bbcode`:1244, `build_route_modifier_lines`:1262, `depot_fill_ratio`:1303, `is_province_contested`:1313, `get_active_agent_network`:1321, `has_active_agent_network`:1333, `count_agent_networks`:1337, `agent_applies_daily_pressure`:1355, `get_agent_pressure_fill_tint`:1362, `agent_has_today_pressure_tick`:1380, `get_agent_pressure_fill_strength`:1387, `_infra_repair_breakdown`:1410, `build_infra_sabotage_source_bbcode`:1416, `build_supply_disruption_source_bbcode`:1430, `estimate_daily_infra_chip_damage`:1444, `build_infra_progress_meter_bbcode`:1455, `_daily_infra_duel_winner`:1481, `_duel_winner_headline`:1493, `build_repair_contributions_glance_bbcode`:1512, `build_repair_contributions_glance_for_province`:1534, `daily_infra_duel_winner`:1552, `build_sabotage_repair_duel_bbcode`:1557, `build_repair_boost_highlight_bbcode`:1613, `build_pressure_status_chip_row_bbcode`:1620, `_pressure_outcome_plain`:1658, `build_infra_net_trend_bbcode`:1692, `build_pressure_trend_chip_bbcode`:1720, `build_pressure_outcome_headline_bbcode`:1741, `build_net_daily_infra_bbcode`:1759, `build_net_daily_compact_chip_bbcode`:1808, `build_net_daily_short_bbcode`:1838, `build_sabotage_verdict_inline_bbcode`:1869, `build_sabotage_verdict_block_bbcode`:1907, `build_sabotage_action_hint_bbcode`:1937, `build_pressure_outcome_bbcode`:1963, `_pressure_status_label`:1973, `build_infra_repair_breakdown_bbcode`:1987, `build_province_infrastructure_card_bbcode`:2024, `build_province_infra_repair_bbcode`:2150, `province_needs_infrastructure_ui`:2154, `build_province_infrastructure_section_bbcode`:2168, `build_supply_pressure_recovery_bbcode`:2172, `build_province_pressure_recovery_bbcode`:2193, `build_province_pressure_recovery_compact`:2207, `build_agent_pressure_headline_bbcode`:2232, `build_province_pressure_section_bbcode`:2245, `pressure_agent_section_redundant_with_card`:2275, `build_province_radio_overlay_line_bbcode`:2309, `agent_pressure_focus_kind`:2327, `agent_has_daily_activity`:2340, `count_agent_pressure_networks`:2349, `estimate_agent_map_pressure`:2374, `_agent_daily_note_label`:2389, `build_agent_ongoing_pressure_bbcode`:2409, `build_agent_daily_effect_detail_bbcode`:2428, `build_agent_daily_activity_bbcode`:2451, `build_agent_glance_bbcode`:2477, `build_agent_pressure_legend_fragment`:2499, `build_agent_legend_line`:2511, `build_inspector_agent_section`:2530, `count_contested_provinces`:2561, `build_conflict_status_bbcode`:2572, `build_control_glance_bbcode`:2583, `build_province_glance_bbcode`:2595, `build_province_glance_compact`:2660, `build_dual_situation_glance_bbcode`:2672, `build_inspector_situation_section`:2707, `build_conflict_map_hint_plain`:2743, `build_conflict_legend_line`:2752, `country_tag_for_province`:2764, `build_province_report`:2772, `format_report_tooltip`:2798, `format_report_inspector`:2928, `_logistics_rows`:2937, `_combat_rows`:2947, `_make_mult_row`:2955, `_make_add_row`:2976, `_make_score_row`:2998, `_national_delta_text`:3018, `_is_improved`:3027, `_modifier_legend_bbcode`:3033, `_stat_column_legend_bbcode`:3040, `build_tooltip_context_banner`:3047, `build_non_adjacent_compare_hint`:3087, `_adjacent_province_names`:3097, `build_inspector_national_section`:3117, `build_supply_logistics_one_liner`:3147, `build_national_situation_one_liner`:3165, `build_national_impact_compact`:3188, `build_compact_effective_summary`:3214, `build_national_sources_badge`:3229, `build_national_sources_grouped_compact`:3248, `build_national_sources_compact_limited`:3276, `_top_impact_rows`:3300, `build_national_sources_compact`:3321, `build_inspector_compare_header`:3340, `build_supply_map_hint_bbcode`:3355, `_bbcode_stat_line_layered`:3378, `_format_base_value`:3407, `_format_effective_value`:3419, `_format_national_value`:3431, `_depot_bbcode_line`:3439, `_province_short_name`:3474, `_bbcode_stat_line`:3481, `_plain_stat_line`:3511, `_nat_suffix`:3533, `_nat_suffix_plain`:3539, `_owner_controller_bbcode`:3545, `_battle_block_for`:3553, `_national_spirit_lines`:3565, `_temporary_effect_lines`:3582, `_extract_relevant_modifiers`:3600, `_modifier_key_affects_provinces`:3613, `_agent_network_line`:3621, `get_battle_preview`:3637, `_local_battle_block`:3669, `_battle_preview_block`:3686, `_format_preview_header`:3712, `_terrain_width_line`:3745, `_depot_summary_line`:3752, `_resolve_battle_counterpart`:3768, `_province_by_id`:3788, `_supply_manager`:3798, `_scenario_loader`:3805

### `hoi-4-nueva-version/scripts/map/ProvinceMapVisuals.gd` (278 lineas)
- class_name: `ProvinceMapVisuals` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (9): `make_closed_outline`:77, `ensure_outline`:91, `ensure_polished_outline`:114, `hide_outline`:135, `hide_polished_outline`:141, `get_outline_line`:146, `apply_pulse_to_line`:151, `apply_pulse_to_polished`:169, `get_supply_outline_style`:195

### `hoi-4-nueva-version/scripts/map/SupplyMenuPanel.gd` (83 lineas)
- class_name: `SupplyMenuPanel` (linea 1)
- extends: `SupplyOverlayPanel` (linea 2)
- funciones (6): `_ready`:13, `setup_mode_selector`:19, `get_selected_routing_mode`:33, `show_supply_state`:39, `set_mode_callback`:76, `_on_mode_item_selected`:80

### `hoi-4-nueva-version/scripts/map/SupplyOverlayPanel.gd` (82 lineas)
- class_name: `SupplyOverlayPanel` (linea 1)
- extends: `Panel` (linea 2)
- funciones (7): `_ready`:17, `show_plan`:27, `hide_panel`:59, `set_callbacks`:63, `_emit_commit`:69, `_emit_clear`:74, `_emit_close`:79

### `hoi-4-nueva-version/scripts/map/_vis_check.gd` (35 lineas)
- extends: `Node` (linea 1)
- funciones (1): `_ready`:3
- dependencias: `res://scenes/WorldMap.tscn`:10

### `hoi-4-nueva-version/scripts/military/BattleManager.gd` (264 lineas)
- extends: `Node` (linea 1)
- senales: `battle_started`:12, `battle_resolved`:13, `province_captured`:14
- funciones (10): `_ready`:25, `_on_formation_moved`:41, `_resolve_battle`:69, `_capture_province`:143, `get_battle_history`:164, `_combat_power`:173, `_retreat_formation`:217, `_get_province`:233, `_holder_of`:245, `_sum_casualties`:255

### `hoi-4-nueva-version/scripts/military/UnitMovementSystem.gd` (210 lineas)
- extends: `Node` (linea 1)
- senales: `formation_selected`:15, `move_order_issued`:16, `move_completed`:17, `movement_invalid`:18
- funciones (12): `_ready`:30, `_load_adjacency`:51, `on_province_clicked`:80, `is_province_adjacent`:121, `can_move_to`:128, `execute_move`:147, `get_movable_formations`:165, `get_adjacent_provinces`:176, `set_player_tag`:181, `_first_friendly_formation_in`:190, `_highlight_province`:202, `_clear_selection`:207

### `hoi-4-nueva-version/scripts/military/_battle_check.gd` (41 lineas)
- extends: `Node` (linea 1)
- funciones (1): `_ready`:3

### `hoi-4-nueva-version/scripts/military/_move_check.gd` (47 lineas)
- extends: `Node` (linea 1)
- funciones (1): `_ready`:3

### `hoi-4-nueva-version/scripts/national/NationalIncomeManager.gd` (193 lineas)
- extends: `Node` (linea 1)
- funciones (12): `_ready`:38, `_load_income_rules`:50, `_on_game_day_advanced`:73, `_process_monthly_income`:81, `_get_income_rate`:121, `get_nation_monthly_income`:132, `get_ai_accumulated_income`:150, `get_save_data`:156, `load_save_data`:160, `_get_all_provinces`:167, `_holder_of`:177, `_resolve_player_tag`:187

### `hoi-4-nueva-version/scripts/national/NationalModifierDisplay.gd` (102 lineas)
- class_name: `NationalModifierDisplay` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (8): `modifier_help`:24, `modifier_lines_detailed`:31, `build_spirit_tooltip`:45, `build_effect_tooltip`:60, `duration_progress`:82, `_modifier_key_label`:87, `_format_modifier_value`:91, `_is_positive_modifier`:97

### `hoi-4-nueva-version/scripts/national/NationalModifierManager.gd` (330 lineas)
- extends: `Node` (linea 2)
- senales: `national_modifier_applied`:9, `national_modifier_expired`:10
- funciones (15): `_ready`:18, `_on_game_year_advanced`:32, `_on_game_month_advanced`:40, `set_current_year`:46, `apply_national_effect`:63, `tick_modifiers`:98, `get_national_modifier`:122, `get_active_effects`:137, `remove_effect`:145, `clear_country_modifiers`:162, `clear_all_modifiers`:169, `get_production_modifiers`:175, `get_combat_modifiers`:225, `get_supply_modifiers`:262, `apply_influence_effect`:301

### `hoi-4-nueva-version/scripts/national/NationalSpiritManager.gd` (337 lineas)
- extends: `Node` (linea 2)
- senales: `spirits_initialized`:6
- funciones (21): `_ready`:14, `_on_modifier_changed`:21, `_load_spirit_definitions`:30, `ensure_country_spirits`:43, `get_spirits_screen_data`:59, `_collect_categories`:79, `_collect_effect_sources`:92, `get_temporary_effect_rows`:105, `get_national_effects_snippet`:123, `_spirit_row`:131, `_temporary_effect_row`:151, `_format_modifier_lines`:179, `_modifier_key_label`:187, `_format_modifier_value`:191, `_source_display_name`:197, `get_spirit_production_modifiers`:212, `get_total_supply_consumption_modifier`:244, `get_total_attrition_reduction_modifier`:257, `get_total_interdiction_resistance_modifier`:268, `get_spirit_supply_modifiers`:280, `get_spirit_combat_modifiers`:309

### `hoi-4-nueva-version/scripts/national/TradeManager.gd` (1245 lineas)
- extends: `Node` (linea 2)
- senales: `offer_created`:320, `deal_accepted`:321, `deal_rejected`:322, `offer_expired`:323
- funciones (23): `_ready`:347, `_on_game_year_advanced`:354, `create_offer`:365, `evaluate_fairness`:406, `accept_offer`:497, `_is_abstract_trade_party`:526, `_country_can_supply_items`:532, `_expire_offers_past_deadline`:584, `_get_player_country_tag`:597, `_uses_player_stockpile`:605, `reject_offer`:610, `expire_offer`:621, `get_active_offers_for_country`:631, `get_public_offers`:641, `get_offers_for_country`:649, `generate_black_market_opportunity`:678, `generate_public_market_offers`:873, `_norm_tag`:1032, `_generate_id`:1035, `_index_offer`:1038, `_clean_indexes`:1044, `_calculate_item_value`:1050, `_execute_transfer`:1112

### `hoi-4-nueva-version/scripts/production/DesignLineState.gd` (39 lineas)
- class_name: `DesignLineState` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `get_refinement_completions`:19, `record_refinement_completion`:23, `duplicate_state`:27

### `hoi-4-nueva-version/scripts/production/DesignManager.gd` (1003 lineas)
- extends: `Node` (linea 51)
- funciones (63): `_ready`:120, `_on_game_year_advanced`:126, `get_current_year`:131, `mark_design_used`:139, `has_used_design`:153, `get_design_status`:161, `get_active_designs`:166, `get_previously_used_designs`:170, `get_obsolete_designs`:174, `get_designs_for_picker`:178, `get_tech_eligible_design_ids`:233, `get_unlock_year`:237, `get_lifecycle_role`:248, `get_design_domain`:261, `is_only_design_in_role`:272, `get_design_nation_tag`:284, `get_design_ownership`:296, `is_design_domestic_for`:308, `is_design_foreign_for`:313, `country_may_use_design`:317, `has_acquired_design`:321, `get_acquisition_kind`:340, `grant_acquired_design`:348, `revoke_acquired_design`:378, `acquisition_kind_label`:389, `acquisition_icon`:401, `format_origin_badge`:414, `format_origin_tooltip`:427, `acquisition_row_color`:440, `_format_foreign_badge`:454, `try_grant_captured_designs_from_factory`:474, `_try_grant_design_list`:493, `try_grant_from_captured_province`:515, `_fire_acquisition_toast`:527, `design_row_search_blob`:551, `sort_design_ids_for_display`:571, `get_save_data`:579, `apply_save_data`:590, `mark_design_acquired`:613, `domain_from_filter_index`:622, `is_design_factory_compatible`:638, `_filter_ids_by_status`:649, `_classify_design`:665, `_eligible_design_ids`:721, `_buildable_design_ids`:725, `_catalog_design_ids`:733, `_country_may_use_design`:752, `_ownership_bucket_key`:762, `_empty_picker_buckets`:768, `_push_locked_design`:785, `_merge_ids`:792, `_infer_nation_from_template`:803, `_infer_nation_from_id`:810, `_nation_from_family_token`:838, `_is_design_in_active_production`:866, `_is_tech_buildable`:881, `_matches_domain`:887, `_infer_domain_from_template`:894, `_is_space_template`:916, `_era_to_year`:960, `_year_from_id`:983, `_sort_design_ids`:991, `_norm_tag`:1001

### `hoi-4-nueva-version/scripts/production/EquipmentShortageTracker.gd` (35 lineas)
- class_name: `EquipmentShortageTracker` (linea 2)
- extends: `Node` (linea 3)
- funciones (2): `calculate_shortages`:7, `get_readiness_from_shortages`:18

### `hoi-4-nueva-version/scripts/production/FactoryManager.gd` (370 lineas)
- extends: `Node` (linea 3)
- senales: `factory_captured`:5, `factory_repaired`:6, `factory_damaged`:7
- funciones (25): `_ready`:18, `set_province_lookup`:22, `get_province`:26, `province_has_port`:33, `_load_rules`:38, `register_factory`:53, `get_factory`:66, `get_factories_in_province`:70, `apply_damage_to_factory`:81, `capture_province_factories`:93, `reconcile_factory_owners_with_map`:122, `advance_repair_for_province`:140, `get_factory_efficiency`:154, `advance_retooling_for_province`:161, `assign_production_line_to_factory`:174, `get_default_max_lines_for_type`:190, `create_factory_for_province`:197, `create_shipyard_for_province`:230, `convert_factory_to_shipyard`:241, `get_or_create_province_component`:272, `register_factories_for_province`:282, `_allocate_factory_id`:291, `_invalidate_production_cache_for_owner`:304, `get_save_data`:315, `apply_save_data`:328

### `hoi-4-nueva-version/scripts/production/LogisticsCalculator.gd` (155 lineas)
- class_name: `LogisticsCalculator` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (8): `applies_logistics`:15, `resolve_loadout`:23, `compute`:36, `_cargo_module_multiplier`:84, `_weapon_slot_penalty_product`:96, `_count_weapon_slots`:109, `_compute_supply_demand`:117, `_aggregate_combat_stats`:136

### `hoi-4-nueva-version/scripts/production/ProductionCostCalculator.gd` (402 lineas)
- class_name: `ProductionCostCalculator` (linea 3)
- extends: `RefCounted` (linea 4)
- funciones (23): `get_rules`:12, `get_base_daily_points`:17, `calculate_production_cost`:22, `resolve_cost`:38, `resolve_cost_breakdown`:47, `_compute_total`:88, `infer_category`:110, `infer_era`:114, `estimate_build_days`:118, `_template_to_dict`:126, `_infer_category_from_dict`:143, `_infer_era_from_dict`:189, `_extract_module_ids_from_dict`:242, `_collect_module_ids`:265, `_get_module`:272, `_module_production_cost`:278, `_infer_module_cost_key`:289, `_infer_module_cost_key_from_id`:295, `_complexity_penalty_additive`:338, `_normalize_category`:346, `resolve_daily_resource_cost`:353, `resolve_daily_resource_cost_from_dict`:362, `_load_rules`:389

### `hoi-4-nueva-version/scripts/production/ProductionLine.gd` (493 lineas)
- class_name: `ProductionLine` (linea 9)
- extends: `RefCounted` (linea 10)
- senales: `template_changed`:12, `unit_completed`:13, `refinement_started`:14, `refinement_completed`:15
- funciones (45): `_init`:42, `reset_progress`:48, `add_progress`:52, `refresh_design_production_cost`:58, `refresh_required_progress`:71, `get_progress_percent`:75, `set_modifier_resolver`:81, `set_runtime_modifiers`:85, `set_template`:89, `get_current_template`:136, `get_current_state`:142, `get_tooling_efficiency`:146, `get_output_multiplier`:154, `_base_output_multiplier`:159, `get_effective_loadout`:176, `_effective_module_ids`:183, `set_slot_module`:192, `clear_slot_module`:197, `clear_custom_loadout`:202, `get_reliability_profile`:207, `get_effective_reliability`:224, `list_refinement_options`:228, `can_start_refinement`:261, `get_days_per_unit`:269, `get_production_cost`:281, `start_refinement`:294, `cancel_refinement`:305, `advance_days`:309, `_complete_unit`:350, `_advance_refinement`:367, `_persist_current_state`:378, `_ensure_design_state`:386, `_apply_refinement_completion`:397, `_refinement_eligibility`:408, `_merge_cost`:423, `apply_retooling_adjustment`:428, `get_retooling_days_remaining`:435, `_active_modifiers`:439, `_scaled_cost`:445, `get_assigned_factory`:454, `get_factory_efficiency`:463, `get_effective_daily_rate`:472, `_sync_factory_production_design`:476, `_factory_manager`:484, `get_daily_resource_cost`:491

### `hoi-4-nueva-version/scripts/production/ProductionModifier.gd` (40 lineas)
- class_name: `ProductionModifier` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (2): `from_dict`:18, `_string_array`:33

### `hoi-4-nueva-version/scripts/production/ProductionModifiers.gd` (41 lineas)
- class_name: `ProductionModifiers` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `reset`:17, `absorb`:29, `get_total_output_multiplier`:39

### `hoi-4-nueva-version/scripts/production/ProductionNavalRules.gd` (97 lineas)
- class_name: `ProductionNavalRules` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (5): `is_naval_category`:43, `is_naval_template`:52, `is_naval_design`:82, `factory_can_build_naval`:89, `province_allows_shipyard`:95

### `hoi-4-nueva-version/scripts/production/RefinementProject.gd` (56 lineas)
- class_name: `RefinementProject` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (5): `from_def`:20, `advance`:38, `is_complete`:42, `progress_ratio`:46, `_dict_from_variant`:52

### `hoi-4-nueva-version/scripts/production/ReliabilityCalculator.gd` (173 lineas)
- class_name: `ReliabilityCalculator` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (7): `compute_profile`:7, `recompute_design_maturity`:90, `_compute_maintenance_index`:100, `_compute_supply_multiplier`:120, `_compute_combat_readiness`:126, `_compute_breakdown_risk`:142, `_module_reliability_delta`:158

### `hoi-4-nueva-version/scripts/production/ReliabilityProfile.gd` (44 lineas)
- class_name: `ReliabilityProfile` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `has_cargo_role`:34, `is_immature`:38, `is_field_ready`:42

### `hoi-4-nueva-version/scripts/production/RetoolingCalculator.gd` (64 lineas)
- class_name: `RetoolingCalculator` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `compute_similarity`:7, `compute_retooling_days`:33, `_shared_module_ratio`:41

### `hoi-4-nueva-version/scripts/production/RetoolingSimilarityTable.gd` (96 lineas)
- class_name: `RetoolingSimilarityTable` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (6): `get_data`:11, `get_similarity`:16, `map_production_category_to_group`:26, `category_group_for_design`:49, `compute_retool_plan`:58, `_load`:83

### `hoi-4-nueva-version/scripts/scenarios/ScenarioFactorySpawner.gd` (177 lineas)
- class_name: `ScenarioFactorySpawner` (linea 2)
- extends: `Node` (linea 3)
- funciones (9): `spawn_factories_for_scenario`:15, `_iter_countries`:95, `_resolve_key_provinces`:114, `_base_factory_count`:130, `_shipyard_levels_for_country`:140, `_default_major_power`:148, `_default_naval_power`:152, `_province_has_port`:156, `_factory_manager`:172

### `hoi-4-nueva-version/scripts/supply/AttritionReplenishmentLedger.gd` (90 lineas)
- class_name: `AttritionReplenishmentLedger` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (7): `record_manpower_loss`:10, `record_equipment_loss`:19, `clear`:26, `get_primary_leader_id`:31, `get_leader_id_for_formation`:39, `calculate_attrition`:44, `compute_replenishment_cargo`:57

### `hoi-4-nueva-version/scripts/supply/CombatPresenceRegistry.gd` (92 lineas)
- class_name: `CombatPresenceRegistry` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (11): `clear`:9, `get_report`:13, `add_land_presence`:19, `add_air_presence`:24, `add_naval_presence`:29, `add_engineer_presence`:34, `register_division_presence`:39, `add_unit`:56, `_brigade_weight`:74, `set_report`:86, `all_province_ids`:90

### `hoi-4-nueva-version/scripts/supply/DivisionTemplate.gd` (448 lineas)
- class_name: `DivisionTemplate` (linea 1)
- extends: `Resource` (linea 2)
- funciones (26): `from_dict`:23, `resolve_subunits`:48, `get_aggregated_infantry_stats`:83, `get_average_generation`:117, `get_resolved_subunits`:130, `get_sustainment_equipment_template`:138, `get_sustainment_stats`:142, `get_sustainment_consumption_multiplier`:161, `get_sustainment_readiness_bonus`:165, `get_sustainment_reliability_impact`:169, `get_total_infantry_headcount`:173, `count_engineer_brigade_equivalent`:187, `get_specialized_sustainment_demand`:202, `get_combined_combat_modifiers`:232, `get_final_combat_stats`:249, `_shortages_affect_infantry`:282, `_shortages_affect_sustainment`:297, `get_required_equipment`:312, `_build_required_equipment`:319, `_append_subunit_sustainment_packages`:362, `_subunit_type_key`:379, `_infantry_template_id_for_equipment_entry`:397, `_apply_infantry_template_to_subunit`:406, `_resolve_design_data`:422, `_default_infantry_stats`:430, `_dict_from_variant`:441

### `hoi-4-nueva-version/scripts/supply/DivisionTemplateLoader.gd` (41 lineas)
- class_name: `DivisionTemplateLoader` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `load_all`:9, `get_division`:31, `get_all_division_ids`:35

### `hoi-4-nueva-version/scripts/supply/ProvinceDepotState.gd` (48 lineas)
- class_name: `ProvinceDepotState` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (4): `_init`:18, `apply_inflow`:25, `pull_outflow`:33, `fill_ratio`:44

### `hoi-4-nueva-version/scripts/supply/ProvinceForceReport.gd` (51 lineas)
- class_name: `ProvinceForceReport` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (9): `_init`:13, `add_land`:17, `add_air`:21, `add_naval`:25, `total_land`:31, `total_air`:35, `total_naval_at_port`:39, `add_engineers`:43, `total_engineers`:49

### `hoi-4-nueva-version/scripts/supply/ProvinceSupplyHub.gd` (31 lineas)
- class_name: `ProvinceSupplyHub` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (2): `has_kind`:19, `hub_score`:23

### `hoi-4-nueva-version/scripts/supply/SupplyCargoProfile.gd` (37 lineas)
- class_name: `SupplyCargoProfile` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (2): `from_template`:10, `general_supplies`:32

### `hoi-4-nueva-version/scripts/supply/SupplyIntelBridge.gd` (94 lineas)
- class_name: `SupplyIntelBridge` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `refresh_manager`:7, `_presence_for_province`:35, `_ctrl`:90

### `hoi-4-nueva-version/scripts/supply/SupplyInterdictionEstimator.gd` (89 lineas)
- class_name: `SupplyInterdictionEstimator` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (1): `estimate`:7

### `hoi-4-nueva-version/scripts/supply/SupplyManager.gd` (706 lineas)
- extends: `Node` (linea 1)
- senales: `network_rebuilt`:5, `route_updated`:6, `overlay_toggled`:7, `depot_stock_changed`:8
- funciones (47): `_get_effects_safe`:33, `_ready`:55, `build_network`:66, `_init_depot_states`:88, `get_depot_state`:108, `get_depot_menu_lines`:112, `get_capital_hub_id`:135, `set_player_depot`:142, `set_selected_province`:151, `get_selected_province_id`:155, `set_routing_mode`:159, `set_active_cargo_from_template`:163, `set_active_cargo_tons`:167, `register_unit_presence`:171, `register_division_presence`:180, `get_engineer_brigades_in_province`:192, `register_force_report`:203, `clear_force_registry`:207, `refresh_intel_from_forces`:211, `set_enemy_presence`:216, `get_enemy_presence`:222, `_apply_agent_intelligence_modifiers`:226, `record_attrition`:259, `get_formation`:273, `_get_base_supply_consumption`:279, `calculate_daily_supply_consumption`:293, `_apply_national_supply_modifiers`:314, `get_attrition_cargo_summary`:339, `_on_game_day_advanced`:351, `advance_supply_day`:355, `begin_player_reroute`:388, `set_reroute_target`:394, `add_reroute_waypoint`:398, `clear_reroute_waypoints`:404, `preview_player_route`:408, `commit_player_route`:412, `get_route`:428, `get_all_routes`:432, `_generate_local_supply_from_development`:436, `toggle_overlay`:485, `seed_demo_engineer_presence`:490, `seed_demo_enemy_forces`:516, `_plan_route`:542, `_calculate_route_interdiction_resistance`:627, `_calculate_route_reinforcement_modifier`:655, `_rebuild_default_routes`:680, `_ctrl`:702
- anomalias: [FLOAT_EQ] linea 331: if supply_mod == 0.0:

### `hoi-4-nueva-version/scripts/supply/SupplyMapLayer.gd` (64 lineas)
- class_name: `SupplyMapLayer` (linea 1)
- extends: `Node` (linea 2)
- funciones (5): `setup`:11, `set_routes`:18, `_draw`:26, `_color_for_plan`:49, `_draw_route_nodes`:60

### `hoi-4-nueva-version/scripts/supply/SupplyMultimodalRouter.gd` (49 lineas)
- class_name: `SupplyMultimodalRouter` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (1): `find_best_route`:7

### `hoi-4-nueva-version/scripts/supply/SupplyNetworkBuilder.gd` (121 lineas)
- class_name: `SupplyNetworkBuilder` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (4): `build`:7, `_capital_by_tag`:27, `_hub_from_province`:42, `_compute_capacity`:103

### `hoi-4-nueva-version/scripts/supply/SupplyPathfinder.gd` (260 lineas)
- class_name: `SupplyPathfinder` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (9): `find_route`:7, `find_route_for_mode`:22, `_mode_dijkstra`:72, `_supply_neighbors`:115, `_edge_cost_for_mode`:164, `_edge_cost`:182, `_populate_timing`:202, `_segment_mode`:234, `_is_friendly`:254

### `hoi-4-nueva-version/scripts/supply/SupplyRoutePlan.gd` (73 lineas)
- class_name: `SupplyRoutePlan` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (3): `path_length`:27, `primary_mode`:31, `summary_lines`:49

### `hoi-4-nueva-version/scripts/supply/SupplyRules.gd` (41 lineas)
- class_name: `SupplyRules` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (5): `load_from_path`:9, `get_block`:15, `get_float`:20, `consumption_rate`:24, `_load_json`:29

### `hoi-4-nueva-version/scripts/supply/UnitSupplyRequirements.gd` (53 lineas)
- class_name: `UnitSupplyRequirements` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (4): `from_template`:16, `daily_consumption_cargo`:35, `can_airlift`:47, `can_sealift`:51

### `hoi-4-nueva-version/scripts/technology/TechnologyManager.gd` (1531 lineas)
- extends: `Node` (linea 2)
- senales: `research_started`:6, `research_completed`:7, `technology_unlocked`:8, `research_state_changed`:9, `agent_tech_state_changed`:10
- funciones (90): `_ready`:63, `_on_game_year_advanced`:88, `set_current_year`:96, `get_current_year`:100, `_load_all_trees`:106, `_merge_tree_file`:125, `_rebuild_unlock_indices`:143, `_template_ids_from_unlock`:162, `_ensure_country`:174, `_migrate_legacy_state`:202, `get_country_state`:232, `is_tech_completed`:237, `is_doctrine_key_unlocked`:242, `get_doctrine_xp`:255, `get_era_swimlane_labels`:259, `get_era_swimlane_keys`:266, `has_division_capability`:273, `get_unlocked_factory_types`:280, `get_technology_modifiers`:289, `get_effective_planning_speed`:297, `get_effective_reconnaissance`:304, `has_tech_unlock`:321, `get_design_availability`:343, `is_unit_design_available`:370, `factory_can_build_design`:374, `has_rule_flag`:402, `is_factory_type_unlocked`:407, `can_convert_factory_to_shipyard`:414, `_on_research_completed_toast`:418, `_has_unlocked_design`:434, `_has_unlocked_category`:439, `_is_category_gated_for_template`:445, `_category_source_tech`:450, `_template_production_category`:458, `_factory_matches_type`:467, `_lock_info_for_tech`:479, `get_tech_display_name`:489, `_tech_display_name`:493, `get_research_slots_max`:502, `get_active_research_count`:506, `get_daily_rp`:510, `get_effective_cost_days`:520, `get_node_status`:531, `_is_research_blocked`:550, `can_research`:563, `start_research`:573, `cancel_research`:595, `advance_research`:608, `_tick_country_research`:615, `_complete_research`:636, `_sync_doctrine_keys_to_leader_manager`:659, `get_technology_screen_data`:670, `get_doctrine_training_entries`:746, `_tech_id_for_doctrine_key`:774, `_pick_leader_for_training_paths`:789, `_build_graph_layout`:803, `_node_matches_era_filter`:834, `_build_active_summaries`:840, `_node_to_summary`:867, `_build_inspector`:916, `_format_unlock_line`:971, `_node_matches_domain_filter`:999, `_domains_with_nodes`:1008, `get_domain_tab_labels`:1030, `get_domain_tab_ids`:1042, `is_tech_compromised`:1048, `has_theft_protection`:1057, `is_theft_target`:1062, `get_stealable_tech_targets`:1069, `mission_requires_tech_target`:1094, `apply_research_theft_from_mission`:1101, `apply_tech_intel_bonus`:1160, `apply_tech_theft_protection`:1173, `get_agent_tech_summary`:1189, `get_tech_agent_inspector_lines`:1232, `_best_steal_target_for_actor`:1282, `_add_research_progress_days`:1295, `_steal_progress_from_victim`:1312, `_set_tech_compromised`:1331, `_log_agent_tech_operation`:1347, `reset_for_scenario`:1360, `apply_scenario_starting_tech`:1364, `_load_starting_pack`:1399, `_merge_starting_entry`:1414, `get_save_data`:1433, `apply_save_data`:1441, `_apply_country_starting_entry`:1454, `_apply_completed_techs_in_order`:1479, `_starting_prerequisites_met`:1511, `_grant_completed_tech_silent`:1522

### `hoi-4-nueva-version/scripts/technology/TechnologyUnlockRegistry.gd` (110 lineas)
- class_name: `TechnologyUnlockRegistry` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (7): `apply_unlocks`:8, `apply_unlock`:26, `_apply_modifier_unlock`:59, `_apply_unit_design_unlock`:69, `_apply_production_category_unlock`:80, `_append_unique`:93, `_store_deferred_unlock`:103

### `hoi-4-nueva-version/scripts/ui/AgentAssignmentScreen.gd` (1290 lineas)
- class_name: `AgentAssignmentScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (55): `_ready`:105, `_apply_content_margins`:127, `_on_close_pressed`:137, `_apply_screen_theme`:141, `_setup_roster_filter`:192, `_setup_agent_headers`:204, `_connect_agent_signals`:222, `_exit_tree`:238, `_on_agent_state_changed`:252, `_on_roster_filter_changed`:258, `_on_mission_category_changed`:262, `refresh_screen`:266, `_sync_mission_category_filter`:283, `_selected_mission_category_filter`:308, `_update_summary_bar`:315, `_update_feedback_hint`:334, `_apply_title_attention`:363, `_populate_agents`:380, `_compare_agent_summaries`:415, `_passes_roster_filter`:425, `_create_agent_row`:440, `_badge_label`:517, `_status_label`:535, `_format_status`:546, `_populate_targets`:550, `_update_intel_column_titles`:570, `_populate_intel_reports`:585, `_create_intel_report_row`:608, `_populate_national_effects`:640, `_on_open_national_spirits_pressed`:667, `_open_national_spirits_screen`:671, `_populate_recent_operations`:688, `_create_national_effect_chip`:710, `_create_operation_log_row`:738, `_resolve_agent_id_from_op`:824, `_find_agent_id_by_name`:831, `_outcome_badge`:842, `_update_detail_panel`:860, `_clear_detail_progress_bar`:959, `_add_detail_mission_progress`:965, `_populate_mission_history`:987, `_update_agent_state_banner`:1003, `_unavailable_mission_message`:1058, `_create_history_row`:1074, `_build_agent_row_tooltip`:1112, `_build_operation_tooltip`:1131, `_create_mission_preview`:1147, `_detection_risk_label`:1195, `_colorize_outcome_label`:1210, `_on_agent_selected`:1224, `_on_target_selected`:1229, `_on_recruit_pressed`:1235, `_on_open_technology_pressed`:1251, `_on_assign_mission_pressed`:1269, `_row_label`:1283
- dependencias: `res://scenes/ui/NationalSpiritsScreen.tscn`:677, `res://scenes/ui/TechnologyScreen.tscn`:1257

### `hoi-4-nueva-version/scripts/ui/BattleResultPopup.gd` (71 lineas)
- class_name: `BattleResultPopup` (linea 1)
- extends: `Control` (linea 2)
- funciones (5): `_ready`:22, `_on_battle_resolved`:29, `_process`:56, `_dismiss`:65, `_on_continue_pressed`:70

### `hoi-4-nueva-version/scripts/ui/DesignPickerPopup.gd` (813 lineas)
- class_name: `DesignPickerPopup` (linea 2)
- extends: `Window` (linea 3)
- funciones (38): `_ready`:52, `_legend_key_text`:93, `_update_legend_visibility`:100, `_clamp_window_to_viewport`:109, `_setup_domain_filter`:121, `_get_factory`:135, `_rebuild_list`:141, `_header_entry`:280, `_list_has_design_rows`:284, `_update_summary_hint`:293, `_domain_filter_label`:328, `_append_tier_header`:338, `_append_active_tier_hint`:346, `_append_archive_tier_hint`:353, `_append_locked_tier_hint`:360, `_append_foreign_empty_block`:367, `_append_section_divider`:383, `_append_design_section`:390, `_design_row_tooltip`:452, `_matches_search`:484, `_fetch_catalog`:501, `_section_subtitle`:518, `_truncate_list_label`:549, `_design_list_label`:555, `_lock_prefix`:616, `_lock_suffix`:620, `_apply_row_color`:630, `_sync_list_scroll_size`:682, `_scroll_list_to_top`:691, `_is_design_selectable`:695, `_on_search_changed`:709, `_on_filters_changed`:714, `_update_filter_labels`:719, `_update_default_lock_hint`:730, `_update_lock_hint`:736, `_on_design_selected`:775, `_on_confirm_pressed`:795, `_on_cancel_pressed`:811
- dependencias: `res://scenes/ui/RetoolingWarningPopup.tscn`:798

### `hoi-4-nueva-version/scripts/ui/DraggablePanel.gd` (33 lineas)
- class_name: `DraggablePanel` (linea 2)
- extends: `Control` (linea 3)
- funciones (2): `_ready`:13, `_on_drag_input`:22

### `hoi-4-nueva-version/scripts/ui/EventPopup.gd` (73 lineas)
- class_name: `EventPopup` (linea 1)
- extends: `Control` (linea 2)
- funciones (5): `_ready`:12, `_on_event_triggered`:19, `_show_next_event`:25, `_build_effects_text`:46, `_on_continue_pressed`:71

### `hoi-4-nueva-version/scripts/ui/FormationPickerPopup.gd` (129 lineas)
- class_name: `FormationPickerPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `formation_assigned`:5
- funciones (9): `_ready`:22, `_present_popup`:44, `_update_title`:51, `_load_available_formations`:60, `_refresh_list`:68, `_on_search_changed`:83, `_on_formation_selected`:104, `_on_assign_pressed`:113, `_on_cancel_pressed`:127

### `hoi-4-nueva-version/scripts/ui/GameDateDisplay.gd` (282 lineas)
- class_name: `GameDateDisplay` (linea 1)
- extends: `RefCounted` (linea 2)
- funciones (16): `has_time_manager`:28, `get_current_date_dict`:32, `format_calendar_date`:38, `format_iso_date_readable`:45, `days_since_scenario_start`:54, `_days_in_month`:89, `months_since_scenario_start`:99, `format_elapsed_suffix`:113, `format_top_bar_line`:123, `format_top_bar_tooltip`:140, `format_map_date_plain`:173, `build_map_time_pulse_bbcode`:195, `time_pulse_priority`:224, `build_map_date_glance_bbcode`:236, `build_map_date_footer_bbcode`:251, `format_map_date_compact`:269

### `hoi-4-nueva-version/scripts/ui/LanguageSelector.gd` (84 lineas)
- class_name: `LanguageSelector` (linea 18)
- extends: `OptionButton` (linea 19)
- funciones (10): `_ready`:21, `_populate_languages`:27, `_select_current_language`:34, `_on_item_selected`:41, `_on_language_changed`:47, `_connect_language_changed`:50, `_get_available_languages`:58, `_get_current_language`:65, `_get_display_name`:72, `_set_language`:79

### `hoi-4-nueva-version/scripts/ui/LeaderAssignmentScreen.gd` (788 lineas)
- class_name: `LeaderAssignmentScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (39): `_ready`:67, `_apply_content_margins`:82, `_on_close_pressed`:92, `_apply_screen_theme`:96, `_setup_detail_panel`:116, `_setup_headers`:125, `refresh_screen`:153, `_setup_national_spirits_button`:162, `_on_national_spirits_pressed`:175, `_setup_pending_replacements_badge`:192, `_connect_leader_replacement_signals`:208, `_exit_tree`:217, `_on_leader_replacement_queue_changed`:226, `_update_pending_replacements_badge`:240, `_apply_screen_title`:258, `_on_pending_replacements_pressed`:274, `_update_summary_bar`:285, `_populate_national_positions`:306, `_create_officer_training_card`:321, `_on_generate_cadet_pressed`:402, `_on_assign_officer_training_pressed`:418, `_create_national_position_card`:427, `_on_national_position_details_pressed`:478, `_on_change_national_position`:485, `_populate_available_leaders`:499, `_populate_unassigned_formations`:514, `_create_leader_row`:545, `_style_leader_name_button`:614, `_leader_has_level_up_option`:622, `_on_leader_name_pressed`:631, `_open_leader_detail_screen`:635, `_row_label`:647, `_format_leader_status`:656, `_format_traits_row`:671, `_on_details_pressed`:688, `_populate_trait_detail`:694, `_on_level_trait_pressed`:748, `_on_assign_pressed`:761, `_position_display_name`:783
- dependencias: `res://scenes/ui/NationalSpiritsScreen.tscn`:181, `res://scenes/ui/FormationPickerPopup.tscn`:766

### `hoi-4-nueva-version/scripts/ui/LeaderDetailScreen.gd` (587 lineas)
- class_name: `LeaderDetailScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (31): `open`:43, `_ready`:57, `_exit_tree`:87, `_on_close_pressed`:98, `_on_trait_leveled`:102, `_on_training_path_invested`:107, `_on_training_path_switched`:112, `_on_training_paths_pressed`:117, `refresh_screen`:121, `_apply_theme`:135, `_style_section_header`:151, `_style_level_up_section`:156, `_update_training_button_visibility`:168, `_update_training_path_indicator`:175, `_update_training_path_bonuses`:195, `_get_training_path_bonuses_container`:245, `_get_training_path_indicator`:273, `_update_header`:296, `_populate_current_traits`:328, `_populate_level_up_options`:363, `_create_level_up_row`:393, `_populate_potential_traits`:457, `_on_level_up_pressed`:489, `_get_rarity_tag`:496, `_clear_children`:504, `_add_note_label`:509, `_build_level_up_tooltip`:517, `_get_next_level_effects`:528, `_format_trait_effects_clean`:534, `_format_single_effect`:547, `_format_trait_effects`:585
- dependencias: `res://scenes/ui/LeaderDetailScreen.tscn`:44

### `hoi-4-nueva-version/scripts/ui/LeaderEventUI.gd` (290 lineas)
- extends: `Node` (linea 2)
- senales: `news_posted`:6
- funciones (19): `_ready`:20, `_connect_leader_signals`:25, `_ensure_toast_layer`:36, `post_news`:55, `get_recent_news`:70, `_show_toast`:77, `_dismiss_toast`:126, `_on_toast_timer_expired`:131, `_on_retirement_offered`:135, `_try_show_next_retirement`:143, `_on_retirement_popup_completed`:158, `_on_leader_replacement_needed`:181, `_try_show_next_replacement`:192, `_on_replacement_popup_completed`:213, `_on_leader_died`:236, `_on_leader_captured`:246, `_on_leader_introduced`:255, `_on_officer_training_quality_notice`:265, `_leader_display_name`:285

### `hoi-4-nueva-version/scripts/ui/LeaderPickerPopup.gd` (251 lineas)
- class_name: `LeaderPickerPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `leader_selected`:5
- funciones (11): `_ready`:22, `_update_title`:48, `_present_popup`:61, `open_picker`:68, `_load_leaders`:87, `_populate_list`:142, `_on_search_changed`:188, `_on_leader_selected`:192, `_on_confirm_pressed`:211, `_refresh_leader_screen`:243, `_on_cancel_pressed`:249
- dependencias: `res://scenes/ui/LeaderPickerPopup.tscn`:69

### `hoi-4-nueva-version/scripts/ui/LeaderReplacementPickerPopup.gd` (202 lineas)
- class_name: `LeaderReplacementPickerPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `replacement_completed`:5
- funciones (14): `_ready`:24, `_present_popup`:61, `open_for_request`:68, `_build_header`:85, `_load_candidates`:106, `_populate_list`:113, `_on_search_changed`:146, `_on_leader_selected`:150, `_on_auto_pressed`:165, `_on_confirm_pressed`:175, `_on_vacant_pressed`:182, `_on_later_pressed`:187, `_finish`:192, `_refresh_leader_screen`:198
- dependencias: `res://scenes/ui/LeaderReplacementPickerPopup.tscn`:69

### `hoi-4-nueva-version/scripts/ui/MainMenu.gd` (308 lineas)
- class_name: `MainMenu` (linea 37)
- extends: `Window` (linea 38)
- senales: `menu_closed`:43
- funciones (13): `_ready`:55, `_clamp_to_viewport`:76, `_build_menu_options`:81, `_make_menu_button`:96, `_build_save_manager_view`:116, `_populate_save_list`:135, `_handle_menu_option`:197, `_on_close_requested`:226, `_pause_game`:232, `_get_resume_speed`:257, `_sync_top_bar_after_menu_close`:264, `_style_dynamic_controls`:285, `_refresh_save_list`:297
- dependencias: `res://scenes/ui/MainMenu.tscn`:30

### `hoi-4-nueva-version/scripts/ui/MissionPickerPopup.gd` (315 lineas)
- class_name: `MissionPickerPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `mission_assigned`:5
- funciones (17): `_ready`:29, `_update_title`:60, `_present_popup`:73, `open_picker`:80, `_setup_category_filter`:99, `_active_category_filter`:118, `_load_missions`:124, `_on_category_filter_changed`:131, `_populate_list`:135, `_on_search_changed`:171, `_on_mission_selected`:191, `_update_detail_for_mission`:209, `_on_confirm_pressed`:247, `_on_tech_target_picked`:274, `_finalize_mission_assignment`:278, `_refresh_agent_screen`:307, `_on_cancel_pressed`:313
- dependencias: `res://scenes/ui/MissionPickerPopup.tscn`:81

### `hoi-4-nueva-version/scripts/ui/NationSelectScreen.gd` (148 lineas)
- class_name: `NationSelectScreen` (linea 1)
- extends: `Control` (linea 2)
- senales: `nation_selected`:14
- funciones (6): `_ready`:45, `_build_ui`:49, `_make_nation_button`:106, `_nation_style`:129, `_on_nation_pressed`:138, `_on_back_pressed`:146

### `hoi-4-nueva-version/scripts/ui/NationalSpiritsScreen.gd` (486 lineas)
- class_name: `NationalSpiritsScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (27): `_ready`:35, `_setup_filters`:46, `_apply_screen_theme`:59, `_connect_signals`:83, `_exit_tree`:98, `_on_modifiers_changed`:107, `_on_filter_changed`:112, `_on_close_pressed`:116, `refresh_screen`:120, `_sync_category_filter`:140, `_count_debuffs`:159, `_update_filter_status`:169, `_count_agent_mission_effects`:186, `_populate_lists`:196, `_populate_permanent`:207, `_populate_temporary`:220, `_filtered_permanent_rows`:239, `_filtered_temporary_rows`:259, `_passes_view_filter`:278, `_selected_category_filter`:292, `_matches_search`:298, `_empty_message_permanent`:319, `_empty_message_temporary`:327, `_create_entry_panel`:339, `_create_modifier_grid`:435, `_on_entry_selected`:473, `_empty_label`:479

### `hoi-4-nueva-version/scripts/ui/ProductionAssignmentScreen.gd` (322 lineas)
- class_name: `ProductionAssignmentScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (21): `_ready`:50, `_exit_tree`:66, `_on_close_pressed`:71, `_apply_screen_theme`:75, `_setup_headers`:91, `_setup_filters`:111, `_on_day_advanced`:127, `refresh_screen`:131, `_update_summary_bar`:137, `_apply_filters`:154, `_matches_status_filter`:176, `_matches_type_filter`:184, `_matches_search`:190, `_populate_factory_list`:196, `_create_factory_row`:204, `_row_label`:249, `_format_design_label`:258, `_efficiency_color`:267, `_on_details_pressed`:275, `_on_change_pressed`:304, `_on_filter_changed`:320
- dependencias: `res://scenes/ui/DesignPickerPopup.tscn`:305

### `hoi-4-nueva-version/scripts/ui/RetirementOfferPopup.gd` (117 lineas)
- class_name: `RetirementOfferPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `retirement_completed`:7
- funciones (7): `_ready`:21, `_on_close_blocked`:47, `_present_popup`:51, `_setup_ui`:58, `_on_retire_pressed`:83, `_on_stay_pressed`:89, `open_for_leader`:100
- dependencias: `res://scenes/ui/RetirementOfferPopup.tscn`:101

### `hoi-4-nueva-version/scripts/ui/RetoolingWarningPopup.gd` (83 lineas)
- class_name: `RetoolingWarningPopup` (linea 2)
- extends: `Window` (linea 3)
- funciones (4): `_ready`:14, `_update_warning_text`:30, `_on_confirm_pressed`:70, `_on_cancel_pressed`:81

### `hoi-4-nueva-version/scripts/ui/RetrowaveTheme.gd` (186 lineas)
- class_name: `RetrowaveTheme` (linea 2)
- extends: `RefCounted` (linea 3)
- funciones (24): `style_top_info_bar`:16, `style_info_bar_label`:22, `style_nav_button`:27, `style_speed_button`:32, `style_production_screen`:39, `style_summary_metric`:45, `style_column_header`:50, `style_row_label`:55, `style_detail_panel`:60, `style_detail_label`:64, `style_filter_option`:69, `style_popup_root`:74, `style_title`:90, `style_body_label`:95, `style_rich_text`:100, `style_search`:105, `style_item_list`:113, `style_primary_button`:120, `style_secondary_button`:128, `style_danger_button`:136, `_panel_style`:144, `_selected_style`:155, `_input_style`:162, `_button_style`:175

### `hoi-4-nueva-version/scripts/ui/TechnologyGraphEdgeLayer.gd` (8 lineas)
- extends: `Control` (linea 2)
- funciones (1): `_draw`:4

### `hoi-4-nueva-version/scripts/ui/TechnologyGraphView.gd` (255 lineas)
- class_name: `TechnologyGraphView` (linea 2)
- extends: `Control` (linea 3)
- senales: `node_selected`:7
- funciones (15): `_ready`:32, `_gui_input`:42, `set_graph_data`:62, `reset_view`:80, `_apply_zoom`:86, `_apply_transform`:97, `_node_position`:106, `_graph_canvas_size`:115, `_center_on_graph`:125, `_rebuild_nodes`:140, `_create_node_panel`:163, `_apply_node_style`:207, `_on_node_gui_input`:222, `paint_edges`:231, `_notification`:252
- dependencias: `res://scripts/ui/TechnologyGraphEdgeLayer.gd`:37

### `hoi-4-nueva-version/scripts/ui/TechnologyMissionTargetPopup.gd` (124 lineas)
- class_name: `TechnologyMissionTargetPopup` (linea 2)
- extends: `Window` (linea 3)
- senales: `target_selected`:5
- funciones (7): `_ready`:23, `open_picker`:43, `_present_popup`:59, `_load_targets`:65, `_on_target_selected`:90, `_on_confirm_pressed`:115, `_on_cancel_pressed`:122
- dependencias: `res://scenes/ui/TechnologyMissionTargetPopup.tscn`:44

### `hoi-4-nueva-version/scripts/ui/TechnologyScreen.gd` (806 lineas)
- class_name: `TechnologyScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (36): `_ready`:72, `_exit_tree`:95, `_connect_manager_signals`:104, `_on_research_state_changed`:113, `_setup_view_mode_filter`:118, `_setup_era_slider`:131, `_setup_domain_filter`:140, `_rebuild_domain_filter`:144, `_apply_screen_theme`:180, `_on_close_pressed`:210, `_on_domain_changed`:214, `_on_view_mode_changed`:220, `_on_era_slider_changed`:227, `_on_reset_view_pressed`:237, `_on_graph_node_selected`:242, `_on_open_agents_pressed`:247, `_populate_agent_bar`:265, `_apply_filter_tooltips`:289, `_apply_map_integration_hint`:299, `_strip_bbcode_tags`:317, `_count_entries_by_domain`:321, `_domain_has_active_research`:346, `_domain_filter_tooltip_line`:360, `_on_open_training_pressed`:381, `_on_research_pressed`:387, `_on_cancel_pressed`:394, `refresh_screen`:401, `_apply_view_visibility`:464, `_populate_active_bar`:485, `_populate_research_list`:515, `_populate_graph`:538, `_populate_doctrine_panel`:548, `_create_doctrine_row`:580, `_create_research_row`:625, `_on_row_gui_input`:710, `_update_inspector`:719
- dependencias: `res://scenes/ui/AgentAssignmentScreen.tscn`:253

### `hoi-4-nueva-version/scripts/ui/TopInfoBar.gd` (672 lineas)
- class_name: `TopInfoBar` (linea 2)
- extends: `Control` (linea 3)
- senales: `menu_option_selected`:427
- funciones (37): `_ready`:43, `_apply_theme`:75, `_connect_buttons`:95, `_on_tick`:115, `_set_game_speed`:124, `_update_speed_buttons`:133, `_on_pause_pressed`:143, `_on_game_year_advanced`:151, `_on_game_month_advanced`:155, `_on_game_day_advanced`:160, `_sync_pause_from_time_manager`:166, `_sync_time_manager_controls`:172, `_pause_for_menu`:181, `_update_date_time`:213, `_update_resources`:225, `_on_victory_achieved`:233, `_on_province_captured`:237, `_update_war_status`:241, `_close_overlay_screens`:278, `_on_production_pressed`:286, `_on_leaders_pressed`:299, `_on_technology_pressed`:314, `_on_diplomacy_pressed`:326, `_on_agents_pressed`:330, `_on_map_pressed`:345, `_close_screen`:349, `_toggle_screen`:355, `_on_save_pressed`:374, `_on_load_pressed`:378, `_on_menu_pressed`:382, `_on_settings_pressed`:410, `_on_help_pressed`:414, `_show_main_menu_popup_fallback`:429, `_add_menu_button`:479, `_show_save_manager_popup`:511, `_unhandled_input`:589, `_populate_save_list`:611
- dependencias: `res://scenes/ui/MainMenu.tscn`:394
- anomalias: [TODO_FIXME] linea 327: print("Open Diplomacy Screen (TODO)"); [TODO_FIXME] linea 415: print("Open Help (TODO)"); [TODO_FIXME] linea 492: print("TODO: Return to Main Menu (emit signal for scene change)")

### `hoi-4-nueva-version/scripts/ui/TrainingPathScreen.gd` (338 lineas)
- class_name: `TrainingPathScreen` (linea 2)
- extends: `DraggablePanel` (linea 3)
- funciones (21): `open`:35, `_ready`:50, `_exit_tree`:77, `_unhandled_input`:86, `_on_close_pressed`:92, `_on_training_path_invested`:96, `_on_training_path_switched`:101, `refresh_screen`:106, `_apply_theme`:119, `_update_current_path_header`:136, `_style_content_panel`:153, `_populate_available_paths`:165, `_sort_training_path_rows`:186, `_create_path_row`:194, `_append_path_header`:235, `_append_path_description`:252, `_append_path_effect_line`:261, `_build_path_action_button`:275, `_format_effects`:317, `_on_invest_pressed`:326, `_on_switch_pressed`:333
- dependencias: `res://scenes/ui/TrainingPathScreen.tscn`:36

### `hoi-4-nueva-version/scripts/ui/VictoryScreen.gd` (57 lineas)
- class_name: `VictoryScreen` (linea 1)
- extends: `Control` (linea 2)
- funciones (3): `_ready`:8, `_on_victory_achieved`:15, `_on_main_menu_pressed`:54

### `hoi-4-nueva-version/scripts/ui_data/AgentScreenData.gd` (19 lineas)
- class_name: `AgentScreenData` (linea 2)
- extends: `Resource` (linea 3)

### `hoi-4-nueva-version/scripts/ui_data/LeaderScreenData.gd` (29 lineas)
- class_name: `LeaderScreenData` (linea 2)
- extends: `Resource` (linea 3)

### `hoi-4-nueva-version/scripts/ui_data/NationalSpiritsScreenData.gd` (12 lineas)
- class_name: `NationalSpiritsScreenData` (linea 2)
- extends: `Resource` (linea 3)

### `hoi-4-nueva-version/scripts/ui_data/ProductionScreenData.gd` (27 lineas)
- class_name: `ProductionScreenData` (linea 2)
- extends: `Resource` (linea 3)

### `hoi-4-nueva-version/scripts/ui_data/TechnologyScreenData.gd` (44 lineas)
- class_name: `TechnologyScreenData` (linea 2)
- extends: `Resource` (linea 3)

## Escenas .tscn (48)

- `epochs-of-ascendancy/scenes/TestScenario.tscn` (recursos externos: 4)
- `epochs-of-ascendancy/scenes/WorldMap.tscn` (recursos externos: 3)
- `epochs-of-ascendancy/scenes/ui/AgentAssignmentScreen.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/DesignPickerPopup.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/FormationPickerPopup.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/LeaderAssignmentScreen.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/LeaderDetailScreen.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/LeaderPickerPopup.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/LeaderReplacementPickerPopup.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/MainMenu.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/MissionPickerPopup.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/NationalSpiritsScreen.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/ProductionAssignmentScreen.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/RetirementOfferPopup.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/RetoolingWarningPopup.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/TechnologyGraphView.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/TechnologyMissionTargetPopup.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/TechnologyScreen.tscn` (recursos externos: 2)
- `epochs-of-ascendancy/scenes/ui/TopInfoBar.tscn` (recursos externos: 1)
- `epochs-of-ascendancy/scenes/ui/TrainingPathScreen.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/TestScenario.tscn` (recursos externos: 7)
- `hoi-4-nueva-version/scenes/WorldMap.tscn` (recursos externos: 3)
- `hoi-4-nueva-version/scenes/ui/AgentAssignmentScreen.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/BattleResultPopup.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/DesignPickerPopup.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/EventPopup.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/FormationPickerPopup.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/LeaderAssignmentScreen.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/LeaderDetailScreen.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/LeaderPickerPopup.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/LeaderReplacementPickerPopup.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/MainMenu.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/MissionPickerPopup.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/NationSelectScreen.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/NationalSpiritsScreen.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/ProductionAssignmentScreen.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/RetirementOfferPopup.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/RetoolingWarningPopup.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/TechnologyGraphView.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/TechnologyMissionTargetPopup.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/TechnologyScreen.tscn` (recursos externos: 2)
- `hoi-4-nueva-version/scenes/ui/TopInfoBar.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/TrainingPathScreen.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scenes/ui/VictoryScreen.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scripts/map/_vis_check.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scripts/military/_battle_check.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scripts/military/_move_check.tscn` (recursos externos: 1)
- `hoi-4-nueva-version/scripts/ui/LanguageSelector.tscn` (recursos externos: 1)

## Datos JSON (4322 archivos; todos parsean validos; 0 IDs duplicados)

- `epochs-of-ascendancy/data/agents/`: 1 archivos
- `epochs-of-ascendancy/data/combat/`: 1 archivos
- `epochs-of-ascendancy/data/formations/`: 1 archivos
- `epochs-of-ascendancy/data/leaders/`: 6 archivos
- `epochs-of-ascendancy/data/modules/`: 1082 archivos
- `epochs-of-ascendancy/data/national/`: 1 archivos
- `epochs-of-ascendancy/data/production/`: 5 archivos
- `epochs-of-ascendancy/data/provinces/`: 10 archivos
- `epochs-of-ascendancy/data/scenarios/`: 3 archivos
- `epochs-of-ascendancy/data/supply/`: 1 archivos
- `epochs-of-ascendancy/data/technology/`: 12 archivos
- `epochs-of-ascendancy/data/unit_templates/`: 1022 archivos
- `hoi-4-nueva-version/data/agents/`: 1 archivos
- `hoi-4-nueva-version/data/combat/`: 1 archivos
- `hoi-4-nueva-version/data/countries/`: 9 archivos
- `hoi-4-nueva-version/data/economy/`: 1 archivos
- `hoi-4-nueva-version/data/events/`: 6 archivos
- `hoi-4-nueva-version/data/formations/`: 1 archivos
- `hoi-4-nueva-version/data/leaders/`: 7 archivos
- `hoi-4-nueva-version/data/localization/`: 2 archivos
- `hoi-4-nueva-version/data/modules/`: 1082 archivos
- `hoi-4-nueva-version/data/national/`: 1 archivos
- `hoi-4-nueva-version/data/production/`: 5 archivos
- `hoi-4-nueva-version/data/provinces/`: 10 archivos
- `hoi-4-nueva-version/data/scenarios/`: 6 archivos
- `hoi-4-nueva-version/data/supply/`: 1 archivos
- `hoi-4-nueva-version/data/technology/`: 13 archivos
- `hoi-4-nueva-version/data/unit_templates/`: 1031 archivos

## Otros archivos

- `(sin ext)`: 8
- `.godot`: 2
- `.import`: 4
- `.log`: 6
- `.md`: 109
- `.png`: 3
- `.py`: 74
- `.sh`: 2
- `.svg`: 2
- `.uid`: 236
