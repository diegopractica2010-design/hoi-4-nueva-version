# Matriz de cobertura histórica — Guerra del Pacífico 1879-1884 (Fase 13)

| Elemento histórico | En el juego | Fidelidad | Nota |
|---|---|---|---|
| Beligerantes (Chile, Perú, Bolivia) | SÍ, jugables | ALTA | colores/capitales correctos (CHL azul #0033A0, PER rojo #D91023, BOL verde) |
| Potencias/neutrales (ENG, FRA, GER, USA, ARG, BRA) | SÍ, como actores IA diplomáticos | MEDIA | sin sistema diplomático que los haga actuar |
| Teatro: Antofagasta, Tarapacá, Iquique, Arica, Tacna, La Paz, Sucre | SÍ (provincias 841-847 con geometría, recursos, adyacencia) | ALTA | corredor costero coherente; salitre/guano/plata bien situados |
| Inicio: ocupación de Antofagasta 14-feb-1879 | SÍ (escenario: owner BOL / controller CHL; evento guerra_inicio) | ALTA | evento muerto hoy (H-0001) |
| Tratado secreto Perú-Bolivia 1873 | Texto del evento inicial | BAJA | sin mecánica de alianza |
| Batalla de Iquique / Prat (21-may-1879) | Evento con espíritu nacional + daño al Huáscar | MEDIA | por fecha fija, no emergente del combate naval |
| Angamos / captura del Huáscar (8-oct-1879) | Evento (destruye per_naval_1879, dominio del mar como modificador) | MEDIA | no existe simulación naval real |
| Campaña de Tacna y Arica (1880) | Evento por control de provincia 845 | MEDIA | requiere conquista del jugador/IA |
| Caída de Lima (ene-1881) y resistencia de Cáceres | Evento por control de provincia 71 | MEDIA | guerrilla solo como modificador |
| Tratado de Ancón (1883) + Pacto de Tregua | Evento por fecha con transferencias 841/842 | MEDIA | anexión provincia a provincia, no por estado (H-0010) |
| Líderes históricos (Prat, Grau, etc.) | 16 líderes en data/leaders/historical_leaders_1879.json | ALTA | revisión fina pendiente (Gemini) |
| Economía del salitre/guano | SÍ — ingresos: PER 720 > CHL 291 > BOL 132/mes | ALTA | refleja el premio económico real de la guerra |
| Armamento de época (Comblain, Chassepot, Krupp, monitores) | NO — proxies ww1 (Springfield, Mauser otomano, cañón 12" de 1918) | BAJA | H-0018; HISTORICAL_REVIEW_REQUIRED |
| Tecnología de época | NO — árbol 1918-2026 con proxies industriales | BAJA | H-0019 |
| Marina como factor decisivo | NO | BAJA | ausencia crítica: la guerra real se decidió en el mar |

## Ausencias críticas
1. **Simulación naval** (la guerra fue ante todo marítima).
2. **Diplomacia** (mediación de potencias, neutralidad argentina).
3. **Anexión por estado** para los tratados (H-0010).

## Simplificaciones aceptables para MVP
- Eventos por fecha en lugar de emergentes; guerrilla como modificador; manpower estático; sin bisiestos.
