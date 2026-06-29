# expansion_wwii — Contenido del proyecto viejo (archivado)

Esta carpeta guarda **todo el contenido del proyecto original (Segunda Guerra Mundial / moderno y el legado HOI2)** que el juego nuevo —el MVP de la **Guerra del Pacífico 1879**— ya no usa.

**Está totalmente DESCONECTADA del juego.** Nada aquí dentro se carga ni se importa: el juego (carpeta `hoi-4-nueva-version/`) no lee esta carpeta. Se conserva, ordenada, por si en el futuro se hace una expansión.

> ⚠️ No muevas estos archivos de vuelta a `hoi-4-nueva-version/` sin reconectar el código. Hacerlo puede reintroducir el cuelgue de arranque que ya se corrigió (la simulación de generales mundiales).

## Qué hay aquí

### `contenido_2gm/`
El contenido jugable del proyecto antiguo (1ª/2ª Guerra Mundial y escenario moderno):
- `scenarios/` → `1918.json`, `1936.json`, `2026.json` (escenarios completos del juego viejo).
- `leaders/` → `historical_leaders_1918.json`, `_1936.json`, `_2026.json` (los generales mundiales: Patton, Guderian, etc. — los que aparecían por error en 1879).

### `legado_hoi2/`
Material de referencia heredado del motor antiguo HOI2 (no es del juego nuevo):
- `juego_godot/` → carpetas `legacy_hoi2/` y `reference/` que estaban sueltas dentro del proyecto Godot (eventos, líderes, provincias, escenarios, tecnología y configuración HOI2).
- `raiz_data/` → la antigua carpeta `data/` que estaba en la raíz del proyecto (CSV, TBL, EUG, etc.).

## Cómo reconectar una expansión (futuro)
1. Mover el escenario deseado (p. ej. `contenido_2gm/scenarios/1936.json`) de vuelta a `hoi-4-nueva-version/data/scenarios/`.
2. Mover su roster de generales a `hoi-4-nueva-version/data/leaders/`.
3. En `scripts/leaders/LeaderManager.gd`, las rutas y el mapeo de ese escenario ya existen (quedaron como referencia); reactivarlas.
4. Importar el proyecto en Godot y probar **siempre en headless** que el arranque no se cuelga antes de jugar.

---
_Archivado durante la limpieza del MVP 1879. El MVP usa únicamente el escenario `1879` y `historical_leaders_1879.json`._
