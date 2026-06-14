# Matriz de riesgos (Fase 24)

| # | Riesgo | Severidad | Hallazgo(s) | Mitigación recomendada |
|---|---|---|---|---|
| 1 | El juego no arranca limpio HOY (5 scripts rotos en cadena) | CRÍTICO | 0001-0005 | 5 micro-fixes (2 líneas class_name + 3 anotaciones de tipo) |
| 2 | Sin guardado/carga mientras dure la cascada | CRÍTICO | 0003 | igual que #1 |
| 3 | Recurrencia sistémica del patrón class_name+autoload (3 veces ya) | ALTO | 0035 | validador automático pre-commit/arranque que compare [autoload] vs class_name |
| 4 | Trabajo paralelo de agentes pisándose (el boot pasó de limpio a roto en horas) | ALTO | 0033 | gate de integración: boot headless obligatorio antes de cada push |
| 5 | Partidas largas pierden ejércitos (posición no persistida) | ALTO | 0009 | serializar province_id/is_moving en LeaderManager |
| 6 | MVP sin fuerzas iniciales reales | ALTO | 0006, 0007 | consumidor de starting_forces |
| 7 | Mapa 87% invisible | ALTO | 0008 | geometría restante o recorte del mapa al teatro |
| 8 | IA sin economía → sin desafío a medio plazo | ALTO | 0012 | stockpile por nación o gasto de _ai_income |
| 9 | Carpeta residual editable por error | ALTO | 0011 | archivar y eliminar epochs-of-ascendancy (probado subconjunto) |
| 10 | No reproducibilidad (RNG sin semilla) | MEDIO | 0014 | seed por partida guardada en el save |
| 11 | Saves futuros incompatibles sin migración | MEDIO | 0023 | implementar _migrate_save_data con versionado |
| 12 | Combate insensible a producción/equipo | MEDIO | 0024 | ligar formaciones a plantillas de división con stats |
| 13 | Monolitos (LeaderManager 2700+, MapRenderer 2300+, ProvinceInsight 3800+) | MEDIO | — | extraer submódulos al crecer; no urgente |
| 14 | Señales sin listener ocultan sistemas funcionando a ciegas | MEDIO | 0021 | priorizar UI de producción/espionaje |
| 15 | UI bilingüe inconsistente | MEDIO | 0013 | migrar .text a claves de localización |
| 16 | Autosave único sobrescribible | BAJO | 0026 | rotación de 3 autosaves |
| 17 | Fugas al salir / UID inválido / warnings | BAJO | 0028, 0029 | higiene al final del MVP |
| 18 | Deriva de calendario sin bisiestos | BAJO | 0031 | aceptar para MVP; documentado |
