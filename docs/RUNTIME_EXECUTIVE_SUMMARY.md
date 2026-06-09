# Resumen Ejecutivo — Auditoría Runtime (post Fase 2)

**Audiencia:** propietario del proyecto · **Motor:** Godot 4.6 (ejecución real)

---

## Qué se validó

Se ejecutó el proyecto real en Godot 4.6 y se inspeccionó: la infraestructura de
localización, el arranque del proyecto, los 19 autoloads, la carga del escenario
1879 y todos los errores/avisos de runtime. La auditoría fue de **solo lectura**:
se documentó todo, no se corrigió nada fuera del alcance.

## Qué funcionó (incluso mejor de lo esperado)

- **Localización: sólida.** Es el subsistema más sano del proyecto. Inglés y
  Español, cambio de idioma en vivo, persistencia y fallback funcionan al 100% en
  runtime. No depende de los sistemas que hoy fallan.
- **Carga del escenario 1879: resiliente.** Pese a tener dos autoloads caídos, el
  escenario carga con éxito: 840 provincias, 9 países, 76 fábricas + 3 astilleros,
  16 líderes históricos y el mapa inicializado con 840 provincias.
- **Base de datos del juego: presente.** Se cargan 1082 módulos de equipo, 1022
  plantillas de unidad y 23 nodos de tecnología. 17 de 19 autoloads quedan activos.

## Qué falló

- **`DesignManager` no compila** (error de sintaxis): el sistema de **diseños de
  producción** no arranca.
- **`TradeManager` no compila** (errores de tipos): el sistema de **comercio /
  diplomacia** no arranca.
- **`ProvinceInsight` no compila** (Color vs String): la **información de provincia**
  del mapa queda rota.

## Qué resultó más peligroso de lo que se creía

- **Acoplamiento por cascada:** un solo error de sintaxis en `DesignManager`
  propaga fallos de compilación a una docena de scripts. El proyecto es más frágil
  de lo que aparenta: errores pequeños pueden volverse casi globales.
- **`FactoryManager` activo pero sin su dependencia `DesignManager`:** parece
  funcionar, pero fallará al usar diseños (referencia nula latente).
- **Mapa incompleto:** solo 100 de 840 provincias tienen geometría; la lógica
  funciona pero la representación visual está a un 12%.
- **Autosave al salir:** el juego autoguarda en cada cierre, incluso en pruebas, con
  riesgo de sobrescribir partidas; el ciclo guardar→cargar no está verificado.

## Qué puede esperar

- Conectar los textos de la UI a la localización (la infraestructura ya está lista).
- Archivo de tecnología histórica para 1879 (hoy usa un fallback mínimo).
- Geometría completa del mapa y reemplazo de las "formaciones de prueba".
- Limpieza de fugas de memoria/recursos al salir (impacto bajo).

## Qué atender antes de planear las próximas fases

1. **Reparar `DesignManager`** (desbloquea producción y corta la cascada).
2. **Reparar `TradeManager`** (desbloquea comercio).
3. **Reparar `ProvinceInsight`** (restaura la UI del mapa).
4. **Verificar el ciclo guardar→cargar** y revisar el autosave-on-exit.

> Estas reparaciones caen en scripts de otros sistemas/agentes (`production`,
> `national`, `map`); esta auditoría solo las identifica y documenta.

## ¿El proyecto está suficientemente sano para continuar?

**Sí, con condiciones.** El núcleo (arranque, carga de escenario, localización) es
funcional y resiliente, lo que permite seguir trabajando. **Pero no conviene iniciar
fases de contenido nuevas hasta reparar `DesignManager` y `TradeManager`**, porque
dejan inactivos dos pilares del juego (producción y comercio) y, mientras el
acoplamiento por cascada siga, cada cambio arriesga romper el arranque completo.

**Veredicto:** salud global ≈ 5.25/10 — *funcional pero frágil*. Estabilizar antes
de expandir.
