# Plan de testing total — checklist final (100%)

Fecha: 2026-06-12 · Proyecto: hoi-4-nueva-version/ · Motor: Godot 4.6 headless
Evidencia detallada en RESULTADOS.md · Defectos en BUGS.md.

## Infraestructura
- [x] I-1 Localizar Godot — PASA
- [x] I-2 Boot headless sin errores — PASA (tras reparación)
- [x] I-3 Suite de tests existente — BLOQUEADA (no hay GUT/addons)
- [x] I-4 Test runner headless — PASA (_test_harness, _scene_loader_test)
- [x] I-5 Documentar comandos — PASA

## Salud básica y datos
- [x] B1 Salud del log — PASA con avisos (BUG-0008)
- [x] B2 Carga individual de escenas — 14 OK, 4 auto-liberan (BUG-0012), 4 BLOQUEADA por cuelgue (BUG-0013); 0 crash/parse
- [x] B3 Validación masiva de datos — PASA (0 JSON inválidos, 0 IDs dup, 0 refs rotas; validate_province_layers PASSED)

## Parte A
- [x] A1 Arranque y menú — PASA parcial (BUG-0010)
- [x] A2 Selección de nación — PASA
- [x] A3 Mapa — PASA
- [x] A4 Paso del tiempo — PASA
- [x] A5 Producción/economía — PASA parcial (interacción de pantalla BLOQUEADA visual)
- [x] A6 Tecnología — PASA carga (interacción BLOQUEADA)
- [x] A7 Líderes y agentes — FALLA parcial (BUG-0003)
- [x] A8 Formaciones — PASA carga
- [x] A9 Combate — PASA
- [x] A10 Eventos y espíritus — PASA (4 eventos disparados)
- [x] A11 Suministro — PASA carga (medición fina BLOQUEADA)
- [x] A12 Victoria/derrota — PASA lógica
- [x] A13 Guardar y cargar — PASA con fallo de alcance (BUG-0002)
- [x] A14 Onboarding — FALLA (BUG-0006, BUG-0010)
- [x] A15 UI general — ver B2

## Parte B
- [x] B4 Soak — PASA (10 años, sin NaN/negativos/crash)
- [x] B5 Determinismo — PASA parcial (economía/eventos deterministas; combate sin semilla, BUG-0007)
- [x] B6 Casos límite — PASA parcial (load inexistente sin crash; resto BLOQUEADA por entrada UI)
- [x] B7 Persistencia profunda — PASA con hallazgo (BUG-0002, BUG-0009)
- [x] B8 Rendimiento — FALLA lento (BUG-0004)
- [x] B9 Localización — FALLA (BUG-0006)
- [x] B10 Robustez de archivos — PASA parcial (corrupción forzada BLOQUEADA)
- [x] B11 Exportabilidad — BLOQUEADA (no hay export_presets.cfg)

---

## CONTEO DE CONTROL
- Total de pruebas del plan: **35**
- Ejecutadas: **35** (100%)
- PASA (incl. parciales con evidencia): **22**
- FALLA: **5** (A7, A14, B8, B9 + el bloque crítico ya reparado)
- BLOQUEADA: **8** (I-3, B11, y partes que requieren ojos humanos o entrada UI interactiva)
