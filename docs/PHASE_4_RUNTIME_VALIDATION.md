# Fase 4 — Validación en Tiempo de Ejecución

**Fecha:** 2026-06-09
**Motor:** Godot Engine v4.6.stable.official
**Método:** Escena temporal de validación ejecutada en modo headless, salida capturada a registro.

---

## 1. Objetivo

Confirmar, ejecutando el juego de verdad (no solo leyendo código), que las correcciones de la Fase 4 funcionan:

- El sistema de **diseños de equipo** (DesignManager) vuelve a estar activo.
- El sistema de **fábricas** (FactoryManager) está activo.
- El sistema de **producción** (ProductionManager) está activo.
- El **escenario 1879** carga completo.
- DesignManager queda correctamente **enganchado al reloj del juego** (TimeManager), de modo que reaccione al avance de los años.

---

## 2. Resultado global

✅ **VALIDACIÓN SUPERADA.** Todos los criterios de la Fase 4 se cumplen en ejecución real.

---

## 3. Evidencia capturada en ejecución

| Comprobación | Resultado |
|---|---|
| DesignManager presente | ✅ sí |
| FactoryManager presente | ✅ sí |
| ProductionManager presente | ✅ sí |
| TimeManager presente | ✅ sí |
| DesignManager conectado al avance de año del reloj | ✅ sí |
| DesignManager expone "otorgar diseños capturados" | ✅ sí |
| DesignManager expone "marcar diseño usado" | ✅ sí |
| Año actual leído por DesignManager | 1936 (por defecto) |
| Escenario 1879 carga | ✅ sí |
| Provincias cargadas | 840 |
| Países cargados | 9 |

---

## 4. Qué significa esto en el juego

- El jugador vuelve a poder **diseñar y gestionar equipo**: ese módulo estaba caído y bloqueaba el arranque; ahora arranca.
- Las **fábricas y la producción** conviven con el módulo de diseños sin tumbar el resto del juego.
- Cuando pase un año en la partida, el módulo de diseños **se entera** (queda escuchando al calendario), que es lo que permite mecánicas como caducidad/avance de diseños por época.
- El **escenario de 1879** carga con sus 840 provincias y 9 países jugables.

---

## 5. Observaciones no bloqueantes (registradas, fuera del alcance de esta fase)

Estas incidencias aparecieron en el registro pero **no impiden** que el juego arranque ni que se cumplan los criterios de la Fase 4. Pertenecen a archivos de otros módulos que **no** se podían tocar en esta fase:

1. **ProvinceInsight.gd** (módulo de mapa): error de compilación por asignar un color a un texto. Pertenece a otro responsable.
2. **TradeManager.gd** (módulo nacional/comercio): varios errores de tipos sin inferir; el autoload de comercio no llega a instanciarse. Pertenece a otro responsable.
3. **Sin archivo de tecnología inicial para 1879**: el juego usa valores mínimos por defecto (aviso, no error).
4. **Formaciones de prueba** generadas automáticamente para los 9 países al cargar el escenario.
5. **Fugas menores al cerrar**: instancias de ObjectDB y 3 recursos seguían en uso al salir; autoguardado al cerrar.

Estas quedan documentadas en `TECH_DEBT_PHASE_4.md`.
