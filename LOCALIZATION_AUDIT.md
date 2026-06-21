# Auditoría de localización — Fase 0

## Arquitectura

- Idiomas de alcance: inglés y español.
- Fuentes: `data/localization/en.json` y `data/localization/es.json`.
- Claves hoja por idioma: 36.
- Fachada pública: `Localization.get_text(key, params)`.
- Autoloads relacionados: LocalizationSettings, LanguageManager, TranslationProvider y Localization.

## Cobertura

La pantalla inicial, menú principal y partes del HUD ya consumen la fachada. Persisten cadenas directas en pantallas de líderes, agentes, tecnología, eventos, espíritus nacionales y mensajes de estado.

## Riesgos

- Alto: no existe prueba automática de paridad de claves entre idiomas.
- Alto: no existe prueba del fallback cuando falta una clave o un idioma.
- Medio: cadenas inglesas y españolas aparecen directamente en scripts UI.
- Medio: textos generados desde datos no tienen política explícita de localización.

## Criterio de cierre

Las pruebas nominales deben verificar paridad ES/EN, cambio de idioma, interpolación y fallback. La certificación no exige traducir contenido histórico fuera del runtime 1879, pero sí evitar claves rotas visibles.
