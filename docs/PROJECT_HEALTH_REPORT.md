# Reporte de Salud del Proyecto

Puntuaciones 0–10 basadas en el runtime real (Godot 4.6 headless).

| Área | Puntuación | Justificación |
|------|-----------|---------------|
| Arranque (Startup) | **4 / 10** | El proyecto arranca y la mayoría de sistemas inicializa, pero 2 autoloads caen (`DesignManager`, `TradeManager`) y hay errores de compilación en cascada y avisos al salir. |
| Arquitectura | **4 / 10** | Acoplamiento fuerte (cascada de compilación), objeto-dios `ScenarioLoader`, orden de autoloads no alineado con dependencias y fuentes de verdad parciales. |
| Localización | **9 / 10** | Validada de extremo a extremo en runtime: EN/ES, cambio en vivo, persistencia y fallback OK. Solo resta conectar la UI real (DT-03). |
| Escenario | **7 / 10** | 1879 carga con éxito (840 provincias, 9 países, 76 fábricas, 16 líderes, mapa). Penalizan: tech por fallback, geometría parcial y formaciones de prueba. |
| Tecnología | **5 / 10** | Carga 23 nodos e inicializa, pero sufre la cascada de compilación y carece de archivo de tech para 1879 (fallback mínimo). |
| Producción | **3 / 10** | `DesignManager` caído; `FactoryManager` presente pero con dependencia rota. El flujo de diseño/producción está comprometido. |
| Guardado/Carga | **6 / 10** | `SaveLoadManager` inicializa y autoguarda, pero el autosave-on-exit es riesgoso y el round-trip guardar→cargar no se validó. |
| UI | **4 / 10** | `ProvinceInsight` no compila y `TopInfoBar` mostró errores en import; `LanguageSelector` correcto. UI parcialmente rota. |

## Promedio global

Promedio simple ≈ **5.25 / 10** — proyecto **funcional pero frágil**: arranca y
carga escenario, con subsistemas críticos (producción, comercio) y UI parcialmente
rotos.

## Lectura rápida

- **Lo más sano:** Localización (9) y carga de Escenario (7).
- **Lo más débil:** Producción (3), Arranque y Arquitectura y UI (4).
- **Prioridad:** desbloquear `DesignManager` y `TradeManager` antes de avanzar a
  fases de contenido, porque condicionan producción y comercio.
