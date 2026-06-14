# Matriz de capacidades (implementadas y faltantes)

## A. Capacidades IMPLEMENTADAS (con evidencia de ejecución)

| Capacidad | Estado de la evidencia |
|---|---|
| Cargar escenario 1879 (847 provincias, 9 países, fecha 1879-02-14) | Verificado en runtime repetidamente |
| Reloj de juego día/mes/año con pausa y velocidad | Verificado (ingresos dispararon al cruzar mes) |
| Mapa interactivo: hover, clic, picking espacial, overlays | Verificado (107 provincias dibujables) |
| Seleccionar y mover unidades entre provincias adyacentes | Verificado headless (mover 90→47, rechazo no-adyacente) |
| Batalla al chocar ejércitos + captura de provincia + retirada | Verificado headless (PER 22.8 vs CHL 16.9) |
| Captura de fábricas al cambiar de dueño | Conectado (BattleManager→FactoryManager) |
| Ingreso mensual por recursos provinciales (oro) | Verificado (+291 CHL, +720.5 PER) — roto HOY por cascada |
| Condiciones de victoria de la Guerra del Pacífico (5) | Implementadas y evaluadas a diario |
| Selección de nación (CHL/PER/BOL) antes de jugar | Verificado (redirección en arranque) |
| Producción/diseños/módulos (1031 plantillas, 1082 módulos) | Carga verificada en cada boot |
| Líderes históricos 1879 (16) con asignación a formaciones | Carga verificada |
| Tecnología inicial por escenario | Aplicada a 9 países (boot log) |
| Guardado/carga JSON de 13 secciones | Funcionaba; roto HOY (H-0003) |
| Motor de eventos con 7 tipos de efecto | Escrito completo; muerto (H-0001) |
| IA con objetivos y órdenes de movimiento | Escrita; muerta (H-0002) |
| Localización en/es (infraestructura) | Funcional; sin adopción en UI |

## B. Capacidades FALTANTES (no existen en ningún archivo)

| Capacidad faltante | Bloquea | Hallazgo |
|---|---|---|
| Despliegue de fuerzas iniciales (consumir starting_forces) | jugar de verdad | H-0006 |
| Persistir posición de unidades | partidas largas | H-0009 |
| Estados/regiones consultables en runtime + anexión por estado | Tratado de Ancón | H-0010 |
| Gasto económico de la IA | desafío real | H-0012 |
| Plantillas de división con equipo para 1879 ligadas a formaciones | combate con stats reales | H-0024 |
| Diplomacia (alianzas, paz negociada, neutralidad ARG/BRA/potencias) | profundidad estratégica | — |
| Combate naval diferenciado (el mar decide la guerra real) | fidelidad histórica | — |
| Geometría de las 740 provincias restantes (o recorte del mapa al teatro) | mapa completo | H-0008 |
| Árbol tecnológico de época 1879 | progresión creíble | H-0019 |
| Pantalla de derrota / fin de partida completa | cierre de partida | H-0005 |
| Tutorial / onboarding | jugador nuevo | — |
| Tests automatizados + CI | estabilidad sostenida | H-0016 |
| Audio (no existe ningún sistema ni asset de sonido) | versión final | — |
| Arte propio (assets: 3 png + 2 svg en todo el repo) | versión final | — |
