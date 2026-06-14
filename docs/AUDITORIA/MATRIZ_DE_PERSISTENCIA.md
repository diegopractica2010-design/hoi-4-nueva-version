# Matriz de persistencia (SaveLoadManager)

NOTA CRITICA: hoy SaveLoadManager NO COMPILA (cascada de EventManager/AIManager,
referencias en SaveLoadManager.gd:407,409,461-465). Mientras no se arregle, NO HAY guardado/carga.

| Sistema | Se guarda | Donde | Riesgo |
|---|---|---|---|
| Calendario (TimeManager) | SI | seccion time | OK |
| Tecnologia | SI | seccion technology | OK |
| Agentes/redes | SI | seccion agents (serializacion manual) | fragil ante cambios de esquema |
| Mapa (owner/controller/dev/infra) | SI | seccion map | OK |
| Suministro (depositos) | SI | seccion supply | OK |
| Modificadores nacionales | SI | seccion national_modifiers | OK |
| Lideres | SI | seccion leaders | OK |
| Produccion + fabricas + disenos | SI | production / factories / design_lifecycle | OK |
| Ingreso nacional | SI (solo last_month) | seccion national_income | _ai_income NO se guarda: la IA pierde su oro al cargar |
| Eventos disparados | SI en codigo | seccion event_manager | muerto hoy (autoload no carga) |
| Estado de la IA | SI en codigo | seccion ai_manager | muerto hoy |
| POSICION DE FORMACIONES (province_id) | NO | leaders no serializa province_id/is_moving | ALTO: al cargar, las unidades pierden su posicion en el mapa |
| player_tag | SI | metadata.player_tag (dinamico) | OK |

## Robustez verificada

- Guardado corrupto/ausente: rutas con FileAccess + chequeo de parseo; devuelve error sin crash.
- Migracion de versiones: stub _migrate_save_data sin migraciones reales (compatibilidad futura no resuelta).
- Autosave al salir sobrescribe autosave.json en cada cierre (puede pisar una partida valiosa).
- Guardar en mitad de combate: el combate es instantaneo (BattleManager resuelve en el mismo frame), no hay estado intermedio persistente.
