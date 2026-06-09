# Convenciones de Claves de Localización

Este documento define cómo se nombran las claves de traducción para mantener
consistencia entre idiomas y facilitar el mantenimiento.

## Formato general

```
<sección>.<subsección>.<identificador>
```

- Solo minúsculas.
- Palabras separadas por guion bajo (`snake_case`) dentro de cada segmento.
- Segmentos separados por punto (`.`).
- Sin espacios, sin acentos, sin mayúsculas.

Ejemplos válidos:

```
menu.main.new_game
menu.settings.language
common.cancel
hud.political_power
message.leader_retired
```

## Secciones estándar

| Sección | Uso |
|---------|-----|
| `menu` | Textos de menús (principal, configuración, etc.) |
| `common` | Textos reutilizables (Sí, No, Aceptar, Cancelar…) |
| `hud` | Interfaz dentro de la partida (fecha, recursos…) |
| `tooltip` | Textos emergentes informativos |
| `message` | Mensajes/eventos mostrados al jugador |
| `language` | Nombres de los idiomas |

## Parámetros (interpolación)

Los valores dinámicos se marcan con llaves `{nombre}` y se sustituyen en runtime:

```json
"message.leader_retired": "El líder {name} se ha retirado."
```

```gdscript
Localization.get_text("message.leader_retired", {"name": "Rommel"})
```

Reglas:

- El nombre del parámetro debe ser idéntico en todos los idiomas.
- Un parámetro puede aparecer cero o varias veces en el texto.
- Si falta un parámetro en la llamada, el marcador `{nombre}` se deja literal
  (comportamiento seguro, sin error).

## Paridad entre idiomas

- **Todo** archivo de idioma debe contener **exactamente las mismas claves** que
  `en.json` (idioma de respaldo).
- Si una clave falta en un idioma, el sistema usa el texto en Inglés (fallback).
- Las claves nunca se traducen: solo se traduce el valor.

## Buenas prácticas

- Nombrar la clave por su **función**, no por su texto (`menu.main.quit`, no
  `menu.main.salir`).
- Reutilizar claves de `common` antes de crear nuevas.
- No concatenar fragmentos traducidos; usar una sola clave con parámetros.
