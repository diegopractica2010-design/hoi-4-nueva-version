# Validación Runtime de Localización

Auditoría ejecutada con **Godot 4.6 (headless)** sobre el proyecto real, cargando
todos los autoloads del juego.

## Resultado por componente

| Componente | Resultado | Evidencia runtime |
|------------|-----------|-------------------|
| Inicialización `LanguageManager` | OK | autoload presente=true |
| Inicialización `TranslationProvider` | OK | autoload presente=true |
| Inicialización `LocalizationSettings` | OK | autoload presente=true |
| Inicialización fachada `Localization` | OK | autoload presente=true |
| Registro de autoloads | OK | 4/4 registrados en `project.godot` |
| Idiomas disponibles | OK | `["en", "es"]` |
| Cambio de idioma en runtime | OK | EN "Save Game" → ES "Guardar partida" |
| Persistencia en runtime | OK | guardar→cargar devolvió `"es"` |
| Interpolación de parámetros | OK | "El líder Rommel se ha retirado." |
| Fallback de traducción faltante | OK | clave inexistente devuelve la propia clave |
| Compatibilidad con la secuencia de arranque | OK | inicializa después del resto sin errores |

## Secuencia de arranque

Los autoloads de localización se registran **al final** de la lista de autoloads,
en orden seguro de dependencias:

1. `LocalizationSettings`
2. `LanguageManager`
3. `TranslationProvider`
4. `Localization`

Durante el arranque, ningún error ni aviso provino de los scripts de localización.
Los mensajes `Language preference saved: ...` confirman la escritura de la
preferencia en disco (`user://localization.cfg`).

## Observaciones

- La localización es, a la fecha de esta auditoría, **el subsistema más sano del
  proyecto**: es el único validado de extremo a extremo en runtime sin errores.
- No depende de los autoloads que actualmente fallan (`DesignManager`,
  `TradeManager`), por lo que su funcionamiento es independiente de la salud del
  resto del proyecto.

## Conclusión

La infraestructura de localización **pasa la validación runtime completa**:
inicialización, registro, cambio de idioma, persistencia y fallback funcionan
correctamente en el proyecto real con todos los autoloads activos.
