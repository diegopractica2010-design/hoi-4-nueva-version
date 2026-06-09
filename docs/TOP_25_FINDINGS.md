# Top 25 Hallazgos de la Auditoría Runtime

Ordenados por importancia (1 = más importante). Basado en Godot 4.6 real.

| # | Descripción | Impacto | Urgencia | Fase recomendada |
|---|-------------|---------|----------|------------------|
| 1 | `DesignManager` no compila (sintaxis `:=` en argumento) → autoload caído | Crítico: producción de diseños inactiva | Alta | Estabilización (pre-3) |
| 2 | `TradeManager` no compila (inferencia de tipos) → autoload caído | Crítico: comercio/diplomacia inactivos | Alta | Estabilización (pre-3) |
| 3 | Acoplamiento por cascada: 1 error tumba ~12 scripts | Alto: fragilidad sistémica | Alta | Refactor (3+) |
| 4 | `ProvinceInsight` no compila (Color vs String) | Alto: UI de provincia rota | Alta | Estabilización |
| 5 | Geometría parcial 100/840 provincias | Alto: mapa visualmente incompleto | Media | Contenido mapa (3+) |
| 6 | `FactoryManager` presente con `DesignManager` ausente | Alto: integración producción rota | Alta | Estabilización |
| 7 | `ScenarioLoader` como objeto-dios | Alto: mantenibilidad | Media | Refactor (3+) |
| 8 | Sin archivo de tecnología para 1879 (fallback mínimo) | Medio: escenario sin tech histórica | Media | Contenido (3+) |
| 9 | Formaciones de prueba en `load_scenario()` | Medio: placeholder en producción | Media | Contenido militar (3+) |
| 10 | Autosave automático al salir (riesgo de sobrescritura) | Medio: datos del jugador | Media | Estabilización guardado |
| 11 | Round-trip guardar→cargar no validado | Medio: integridad de partidas | Media | Estabilización |
| 12 | Orden de autoloads no alineado con dependencias | Medio: init prematura | Media | Estabilización |
| 13 | Fechas/años hardcodeados (1936-01-01) | Medio: supuestos embebidos | Baja | Refactor config |
| 14 | UID inválido en `WorldMap.tscn` | Medio: fragilidad de referencias | Baja | Estabilización |
| 15 | Colores como String (fuente de verdad inconsistente) | Medio: estilo frágil | Baja | Refactor |
| 16 | Inicialización dependiente del escenario (TimeManager/MapManager) | Medio: orden temporal | Media | Refactor |
| 17 | Fallback de tecnología silencioso (degrada contenido) | Medio: calidad silenciosa | Media | Contenido (3+) |
| 18 | Fugas de ObjectDB al salir | Bajo: memoria | Baja | Pulido técnico |
| 19 | 3 recursos en uso al salir | Bajo: ciclo de vida | Baja | Pulido técnico |
| 20 | Suministro no confirmado como inicializado en 1879 | Medio: estado de suministro | Media | Verificación (3) |
| 21 | Textos de UI aún no usan claves de localización (DT-03) | Medio: localización no conectada | Media | Migración textos (3+) |
| 22 | Cobertura de claves de traducción limitada (DT-05) | Bajo: ampliable por datos | Baja | Contenido (3+) |
| 23 | **POSITIVO:** Localización validada de extremo a extremo en runtime | Alto positivo: subsistema sólido | — | Listo |
| 24 | **POSITIVO:** Escenario 1879 carga pese a 2 autoloads caídos | Alto positivo: resiliencia de carga | — | Listo |
| 25 | **POSITIVO:** 17/19 autoloads activos; datos base cargan (1082 módulos, 1022 plantillas) | Medio positivo: base funcional | — | Listo |

## Notas

- Los puntos 1, 2, 4 y 6 son los **bloqueantes reales** para avanzar.
- Los positivos (23–25) muestran que el núcleo de carga y la localización son
  sólidos; el problema está en producción/comercio/UI y en el acoplamiento.
