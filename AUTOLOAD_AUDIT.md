# Auditoría de autoloads — Fase 0

## Resultado

- Declarados: 25.
- Scripts ausentes: 0.
- Colisiones `class_name` confirmadas: 0.
- Dependencias formalmente declaradas: 0; el orden vive únicamente en `project.godot`.

## Grupos

| Grupo | Autoloads |
|---|---|
| Estado y tiempo | GameData, TimeManager, SaveLoadManager |
| Producción | FactoryManager, ProductionManager, DesignManager |
| Mapa y suministro | MapManager, SupplyManager |
| Personajes | LeaderManager, LeaderEventUI, AgentManager |
| Nación | NationalModifierManager, NationalSpiritManager, NationalIncomeManager, TradeManager |
| Guerra | UnitMovementSystem, BattleManager, AIManager, VictoryConditions |
| Contenido | TechnologyManager, EventManager |
| Localización | LocalizationSettings, LanguageManager, TranslationProvider, Localization |

## Riesgos

- Alto: una falla de parser en cualquier autoload contamina todo arranque y toda prueba.
- Alto: el orden de inicialización es un contrato público no validado automáticamente.
- Alto: no todos los autoloads ofrecen un contrato homogéneo `get_save_data/apply_save_data`.
- Medio: varios consumidores almacenan referencias o usan acceso lazy sin prueba de reinicio de escena.

## Puerta requerida

Añadir una validación que instancie el árbol con el orden real, compruebe presencia, API mínima y ausencia de errores. Debe ejecutarse tres veces antes de certificar.
