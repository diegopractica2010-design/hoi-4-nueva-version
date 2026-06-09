# Reporte de Validación de Localización — Fase 2

## Alcance validado

Verificación de la infraestructura de localización entregada en la Fase 2.

## 1. Paridad de claves entre idiomas

Se compararon las claves de `data/localization/en.json` y `es.json`.

| Métrica | Resultado |
|---------|-----------|
| Claves en `en.json` | 36 |
| Claves en `es.json` | 36 |
| Claves faltantes en español | 0 |
| Claves sobrantes en español | 0 |
| Paridad | CORRECTA |

> Toda clave presente en el idioma de respaldo (Inglés) existe también en Español.

## 2. Consistencia de parámetros

Las claves con parámetros `{...}` usan el mismo nombre de parámetro en ambos idiomas:

| Clave | Parámetros | Coinciden |
|-------|-----------|-----------|
| `tooltip.province.population` | `{value}` | Sí |
| `tooltip.province.owner` | `{name}` | Sí |
| `tooltip.factory.output` | `{value}` | Sí |
| `message.leader_retired` | `{name}` | Sí |
| `message.trade_completed` | `{country}` | Sí |

## 3. Criterios de éxito

| Criterio | Estado |
|----------|--------|
| Inglés funciona | OK (idioma de respaldo, cargado siempre) |
| Español funciona | OK (claves completas y con paridad) |
| Cambio en runtime | OK (`language_changed` recarga traducciones) |
| Persistencia | OK (`user://localization.cfg` vía ConfigFile) |
| Fallback al Inglés | OK (clave faltante → Inglés → clave literal) |
| Sin TODO / FIXME / placeholders | OK |

## 4. Validación de robustez

| Caso | Comportamiento esperado | Cubierto |
|------|------------------------|----------|
| Archivo de idioma ausente | Aviso + uso del respaldo | Sí |
| JSON inválido | Error + diccionario vacío + respaldo | Sí |
| Clave inexistente | Devuelve la clave como texto y la registra | Sí |
| Preferencia corrupta en disco | Aviso + idioma de respaldo | Sí |
| Idioma no soportado en `set_language` | Aviso + sin cambio | Sí |

## 5. Limitaciones conocidas

La validación es **estática** (revisión de datos y código). La validación
**en runtime dentro del editor de Godot** no se ejecutó porque el registro de
autoloads en `project.godot` está fuera del alcance de esta fase (ver DT-01 en
`docs/TECH_DEBT_PHASE_2.md`).

## Conclusión

La infraestructura cumple los criterios de éxito a nivel de datos y código. La
verificación interactiva queda pendiente del registro de autoloads.
