# Fase 6 — Validación en Tiempo de Ejecución

**Fecha:** 2026-06-09
**Motor:** Godot Engine v4.6.stable.official
**Método:** escena temporal de validación ejecutada en headless; integridad de datos + flujo de mapa en runtime. Salida capturada a registro. Archivos temporales ya eliminados.

---

## 1. Resultado global

✅ **VALIDACIÓN SUPERADA.** El validador de datos pasa (0 errores) y el flujo de mapa en runtime funciona de extremo a extremo.

> Nota de procedimiento: la primera ejecución falló por una cascada de compilación. La causa raíz dentro de mi propiedad (`scripts/map/ProvinceInsight.gd`, error de tipo Color→texto) **se corrigió en esta fase**. Tras forzar una reimportación del proyecto, la validación corre limpia.

---

## 2. Validación de arranque

| Comprobación | Resultado |
|---|---|
| Módulos de equipo / plantillas cargados | ✅ |
| `TimeManager` inicializado | ✅ |
| `MapManager` autoload presente | ✅ |
| Validador de datos del mapa | ✅ ok=true, 0 errores, 1 advertencia |

---

## 3. Validación de runtime / integración del mapa

| Comprobación | Resultado |
|---|---|
| `ScenarioLoader.load_scenario('1879')` | ✅ ok=true |
| Provincias cargadas | 847 |
| Países cargados | 9 |
| Estados cargados en `ScenarioLoader` | 847 (cobertura total) |
| Regiones cargadas en `ScenarioLoader` | 847 (cobertura total) |
| `MapManager` inicializado | ✅ true |
| `MapManager` nº de provincias | 847 |
| Picker espacial (`MapPickGrid`) activo | ✅ true |
| Límites del mundo (`world_bounds`) | (0,0) → (4036.5, 1517.9) |

---

## 4. Validación de geometría / renderizado

- Geometría cargada: **107 de 847** provincias.
- El picker espacial se construyó correctamente y `MapManager` quedó listo (`is_ready()=true`).
- **Limitación conocida:** 740 provincias sin polígono no se dibujan. El renderizado visual no puede comprobarse en headless (sin ventana); se valida la inicialización del renderizador y del picker, no el pixelado.

---

## 5. Errores encontrados

- **Ninguno dentro del alcance de Track A tras la corrección.**
- Error corregido en esta fase: `ProvinceInsight.gd` líneas 1469/1471 asignaban un `Color` a una variable de texto BBCode; corregido a cadenas `"[color=#...]"` (archivo de mi propiedad esta fase).

## 6. Advertencias encontradas (no bloqueantes)

1. **GEO_COVERAGE:** 740/847 provincias sin geometría (datos, otro track).
2. **TechnologyManager:** sin archivo de tecnología inicial para 1879 → usa valores mínimos por defecto.
3. **Formaciones de prueba** generadas por país al cargar el escenario.
4. **Fugas menores al cerrar** (ObjectDB / recursos en uso) y autoguardado al salir.

## 7. Bloqueos por propiedad ajena (no corregidos)

- **`scripts/national/TradeManager.gd`** (errores de tipo en líneas 412/502/503/1168/1181) impide instanciar su autoload y contamina la cadena de compilación global del proyecto. **No pertenece a Track A.** Para validar el mapa fue necesario aislar la prueba con `preload` por ruta y forzar reimportación. Ver `CROSS_PHASE_FINDINGS.md` (BLOCKED_BY_OWNERSHIP).

---

## 8. Limitaciones conocidas

- El renderizado gráfico real no se valida en headless.
- La validación de runtime del mapa se ejecutó de forma aislada porque el arranque completo del juego sigue afectado por `TradeManager.gd` (propiedad ajena).
- Estados y regiones se cargan pero aún no se exponen a `MapManager`/`Province` (DT-P6-01).
