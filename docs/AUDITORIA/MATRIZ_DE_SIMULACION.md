# Matriz de simulación (Fases 9-10: ¿qué genera gameplay real?)

"Si inicio una partida hoy (tras arreglar 0001-0005), ¿qué simula de verdad?"

| Dominio | Clasificación | Evidencia |
|---|---|---|
| Tiempo (días/meses/años, pausa, velocidad) | SIMULADO REALMENTE | TimeManager + consumidores verificados |
| Economía del jugador (recursos provinciales → oro mensual) | SIMULADO REALMENTE | +291 oro CHL verificado |
| Economía de la IA | NO SIMULADO (acumula y nunca gasta) | H-0012 |
| Movimiento militar | SIMULADO REALMENTE (1 salto adyacente, instantáneo) | verificación headless |
| Combate terrestre | SIMULADO PARCIALMENTE (heurística infra/dev + azar; sin equipo real) | H-0024 |
| Combate naval | NO SIMULADO (no hay dominio del mar; lo naval es una plantilla más) | — |
| Captura territorial | SIMULADO REALMENTE (owner+controller+fábricas) | verificación headless |
| Reparación de infraestructura diaria | SIMULADO REALMENTE | MapManager.advance_daily_infrastructure_repair |
| Sabotaje/espionaje (agentes) | SIMULADO PARCIALMENTE (sin UI; efectos reales en supply) | H-0021 |
| Suministro | SIMULADO PARCIALMENTE (depósitos/sabotaje; atrición en transición) | — |
| Producción industrial | SIMULADO PARCIALMENTE (líneas/stockpile solo jugador; sin UI de feedback) | H-0012, H-0021 |
| Tecnología | SIMULADO PARCIALMENTE (estado inicial sí; investigación activa por año, árbol no de época) | H-0019 |
| Eventos históricos | ESCRITO, NO ACTIVO HOY | H-0001 |
| IA enemiga | ESCRITA, NO ACTIVA HOY | H-0002 |
| Diplomacia | NO SIMULADO | sin sistema |
| Victoria/derrota | SIMULADO REALMENTE (5 condiciones diarias) — sin pantalla | H-0005 |
| Liderazgo (rasgos, XP, bajas de líderes) | SIMULADO REALMENTE (combate otorga XP, muerte/captura) | CombatResolver.resolve_battle_aftermath |
| Población/manpower | NO SIMULADO (dato estático) | — |

## Loop de juego resultante (Fase 10)
1. HOY (con fixes 0001-0005): elegir nación → ver mapa → mover ejércitos de prueba → batallas heurísticas → capturar el litoral → victoria silenciosa. **Loop completo pero hueco**: sin fuerzas históricas, sin eventos, sin IA opositora, las decisiones casi no importan.
2. Con bloqueadores de MVP resueltos (0006/0007/0009/0024 + revivir eventos/IA): la Guerra del Pacífico mínima es jugable de punta a punta con decisiones reales (dónde concentrar, qué producir, cuándo atacar Tarapacá).
