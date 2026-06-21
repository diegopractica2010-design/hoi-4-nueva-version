# DEPENDENCY MAP — Phase 0

## Autoload Initialization Order (from project.godot)
```
 1. GameData
 2. FactoryManager
 3. ProductionManager        ← depends on FactoryManager (lazy accessor)
 4. SupplyManager
 5. LeaderManager            ← depends on SupplyManager
 6. TimeManager
 7. DesignManager
 8. LeaderEventUI
 9. AgentManager             ← depends on TimeManager, LeaderManager
10. NationalModifierManager
11. NationalSpiritManager
12. NationalIncomeManager
13. TradeManager             ← depends on TimeManager, DesignManager, ProductionManager
14. MapManager
15. TechnologyManager
16. SaveLoadManager
17. VictoryConditions        ← depends on TimeManager, BattleManager, MapManager
18. EventManager
19. UnitMovementSystem
20. BattleManager            ← depends on LeaderManager
21. AIManager                ← depends on ScenarioLoader
22. LocalizationSettings
23. LanguageManager
24. TranslationProvider
25. Localization             ← depends on LanguageManager, TranslationProvider
```

## Critical Dependency Chains

### Scenario Loading Chain
```
ScenarioLoader.load_scenario()
  → ScenarioDataResolver.load_scenario_data()
  → ScenarioProvinceApplier.apply_overrides()
  → ScenarioCountryRuntime.resolve_countries()
  → TimeManager.initialize_from_scenario_start_date()
  → LeaderManager.load_leaders_for_scenario()
  → TechnologyManager (apply starting tech)
  → MapManager.initialize_from_map_data()
```

### Game Tick Chain
```
TimeManager.game_day_advanced
  → SupplyManager (auto-advance supply)
  → VictoryConditions._on_game_day_advanced()
  → AgentManager (daily network advancement)
  → TradeManager (expire offers)
```

### Combat Chain
```
UnitMovementSystem.move_formation()
  → BattleManager._resolve_battle()
  → CombatResolver.resolve_battle_aftermath()
  → LeaderManager (leader XP)
  → MapManager (province ownership changes)
```

## Cross-autoload Access Pattern
All autoloads use `typeof(X) != TYPE_NIL` defensive pattern before accessing.
7 autoloads omit `class_name` to avoid Godot 4 singleton hiding error (see DT-02).
