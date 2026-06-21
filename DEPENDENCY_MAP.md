# Mapa de dependencias — Fase 0

## Orden de autoload

1. GameData
2. FactoryManager
3. ProductionManager
4. SupplyManager
5. LeaderManager
6. TimeManager
7. DesignManager
8. LeaderEventUI
9. AgentManager
10. NationalModifierManager
11. NationalSpiritManager
12. NationalIncomeManager
13. TradeManager
14. MapManager
15. TechnologyManager
16. SaveLoadManager
17. VictoryConditions
18. EventManager
19. UnitMovementSystem
20. BattleManager
21. AIManager
22. LocalizationSettings
23. LanguageManager
24. TranslationProvider
25. Localization

Todas las rutas declaradas existen. Los autoloads omiten `class_name` cuando el nombre de clase ocultaría el singleton.

## Flujos críticos

```text
StartMenu -> NationSelectScreen -> TestScenario
TestScenario -> ScenarioLoader -> ScenarioDataResolver
ScenarioLoader -> ScenarioProvinceApplier + ScenarioCountryRuntime
ScenarioLoader -> Time/Leader/Technology/Factory/Map managers
```

```text
TimeManager.game_day_advanced
  -> SupplyManager
  -> ProductionManager
  -> AgentManager
  -> VictoryConditions
  -> TradeManager
```

```text
UnitMovementSystem -> BattleManager -> CombatResolver
  -> LeaderManager + MapManager + VictoryConditions
```

```text
SaveLoadManager
  -> GameData + Time + Scenario metadata
  -> FactoryManager + ProductionManager
  -> LeaderManager + map/combat/AI state
```

## Riesgos de contrato

- `AIManager` intenta resolver `/root/ScenarioLoader`, pero `ScenarioLoader` es un nodo de escena, no un autoload.
- Las dependencias entre autoloads se resuelven mediante nombres globales y `get_node_or_null`, sin verificación central.
- `TestRunner` mezcla navegación de UI, carga de escenario y smoke tests; no es un runner aislado.
- Los tres monolitos críticos mezclan presentación, reglas y acceso global, elevando el radio de regresión.
