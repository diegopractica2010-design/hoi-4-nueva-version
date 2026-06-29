# Auditoría del repositorio — Fase 0

Fecha: 2026-06-20  
Línea base: `68f36ef47bf4b605ed9ddb3bc2539c705986cd69` más los cambios preparados y modificados existentes.  
Política: no se restauró, descartó ni reescribió ningún cambio previo.

## Inventario verificable

- Motor: Godot 4.6, GDScript, renderer `gl_compatibility`.
- Escena principal: `res://scenes/ui/StartMenu.tscn`.
- Archivos del repositorio, excluyendo `.godot`: 4.004.
- Scripts `.gd`: 138.
- Escenas `.tscn`: 28.
- Archivos bajo `data/`: 3.679.
- JSON bajo `data/`: 2.177; errores de parseo: 0.
- Autoloads: 25; las 25 rutas existen.
- Pruebas automatizadas existentes: tres entrypoints headless y dos colecciones estáticas, sin runner seleccionable por suite.

## Estado de la limpieza anterior

El commit base eliminó 585 archivos: 549 perfiles AI heredados de HOI2 y 36 logs. No se encontraron referencias vivas a `data/ai/legacy_hoi2` ni a archivos `.ai`. Esta eliminación forma parte de la línea base autorizada.

## Hallazgos de entrada

- Crítico: el estado modificado aún no ha superado parser/importación/startup.
- Crítico: no existe un arnés capaz de ejecutar las pruebas nominales, producir JSON o terminar campañas headless.
- Crítico arquitectónico: `ProvinceInsight.gd`, `LeaderManager.gd` y `MapRenderer.gd` superan 2.000 líneas.
- Alto: 25 autoloads forman una cadena de inicialización implícita.
- Alto: guardado, IA y simulación no tienen pruebas deterministas ni de corrupción.
- Medio: solo 36 claves localizadas por idioma frente a numerosas cadenas UI directas.

Los 25 ítems congelados y su criterio de cierre están en `CRITICAL_FIX_LEDGER.md`.
