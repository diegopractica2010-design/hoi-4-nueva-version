# Validación de Fase 1

Motor: Godot 4.6 stable.  
Fecha: 2026-06-20.

## Correcciones

1. Reparado el identificador corrupto del acceso lazy a `FactoryManager` en `ProductionManager`.
2. Migradas las referencias restantes `NationSelectScreen.selected_tag` a `GameData.selected_nation_tag`.
3. Reemplazada la dependencia inexistente `/root/ScenarioLoader` por entrega explícita del escenario a `AIManager`.
4. Convertido `EquipmentShortageTracker` de `Node` a `RefCounted`, eliminando la fuga de startup.
5. Añadido validador QA de escenas y manifiesto congelado de 28 escenas.

## Puerta

| Ronda | Importación/parser | Escenas | Startup |
|---|---|---|---|
| 1 | PASS | 28/28 PASS | PASS |
| 2 | PASS | 28/28 PASS | PASS |
| 3 | PASS | 28/28 PASS | PASS |

El startup principal termina sin `SCRIPT ERROR`, `ERROR`, errores de UID ni recursos retenidos. El validador de escenas puede provocar retención del caché de clases al cargar escenas complejas dentro de un `SceneTree` externo; ese diagnóstico se excluye de startup y no aparece al ejecutar el producto.
