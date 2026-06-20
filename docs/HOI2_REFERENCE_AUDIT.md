# Auditoría de referencia local: Hearts of Iron II Collection

Fecha: 2026-06-20  
Alcance: análisis local de Hearts of Iron II, Doomsday y Armageddon como referencia para la conversión histórica de la Guerra del Pacífico de 1879.

## Resultado ejecutivo

La colección sí es útil, pero principalmente como referencia de arquitectura y diseño sistémico. No conviene importar sus datos ni su mapa directamente.

Los tres aportes de mayor valor para el proyecto actual son:

1. Un motor de eventos data-driven con condiciones compuestas, elecciones, cadenas y consecuencias diplomáticas.
2. Perfiles de IA por país y situación, separados del código, con prioridades militares, navales, tecnológicas, económicas y territoriales.
3. Un modelo diplomático explícito con relaciones, alianzas, acceso militar, garantías, paz, reclamaciones y costes políticos.

El mapa de Sudamérica de HOI2 es demasiado grueso para 1879. Incluye Antofagasta, Lima, Arequipa, La Paz, Sucre y Cobija, pero no representa Iquique, Tarapacá, Arica ni Tacna como provincias independientes. El mapa propio del proyecto es, por tanto, la base correcta.

## Material analizado

Colección original:

- Hearts of Iron II.
- Hearts of Iron II: Doomsday.
- Armageddon 1.3a como ampliación de Doomsday.
- Instalador en inglés, con tablas internas multilingües.

La extracción se realizó sin ejecutar los juegos ni sus instaladores. Se usaron extractores portátiles y se crearon tres áreas fuera del repositorio:

- `_analysis_tools`: herramientas portátiles de extracción.
- `_analysis_extracted`: contenido separado de las tres ediciones.
- `_analysis_reference_final`: superposición lógica Doomsday + Armageddon limitada a datos y reglas.

No se copiaron gráficos, audio, ejecutables ni datos de HOI2 al repositorio Godot.

## Inventario cuantitativo

La referencia final contiene:

| Área | Archivos | Tamaño aproximado |
|---|---:|---:|
| IA | 548 | 3,70 MB |
| Localización/configuración | 17 | 6,92 MB |
| Reglas y bases de datos | 740 | 8,76 MB |
| Mapa | 17 | 67,86 MB |
| Escenarios | 843 | 34,66 MB |

Contenido sistémico localizado:

- 2.295 eventos y 17.678 comandos de efecto.
- 713 eventos persistentes.
- 118 archivos de eventos.
- 439 tecnologías, divididas en 2.195 componentes de investigación.
- 1.770 efectos tecnológicos.
- 33 tipos de divisiones y 27 tipos de brigadas.
- 177 catálogos nacionales de equipos de investigación.
- 178 catálogos nacionales de líderes.
- 179 catálogos nacionales de ministros.
- 2.608 provincias en el mapa mundial.

## Hallazgos aplicables

### 1. Eventos ramificados

HOI2 separa la definición del evento de su presentación y permite:

- Fecha más ventana de comprobación (`date` + `offset`).
- Condiciones `AND`, `OR` y `NOT`.
- Estado de guerra, alianza, control territorial, pérdidas y políticas como disparadores.
- Varias elecciones por evento.
- Probabilidad distinta para la IA en cada elección.
- Eventos encadenados mediante `trigger`.
- Banderas, relaciones, transferencias territoriales, paz, acceso militar y movilización como efectos.
- Eventos persistentes o de una sola ejecución.

La campaña `platineanwar` es la referencia regional más útil. Contiene 52 eventos, 203 efectos y respuestas para Argentina, Bolivia, Brasil, Chile, Ecuador, Paraguay, Perú y Uruguay. Su valor no está en su historia ficticia, sino en el patrón: una crisis regional provoca consultas diplomáticas, decisiones nacionales, alineamientos, refuerzos, paz y finales alternativos.

Aplicación recomendada: ampliar el formato JSON actual con `conditions`, `options`, `ai_weight`, `trigger_events`, `flags`, `cooldown_days` y efectos diplomáticos.

### 2. IA data-driven

Los perfiles de IA de HOI2 permiten declarar por datos:

- Neutralidad y propensión a la guerra.
- Países amigos, protegidos, hostiles o embargados.
- Provincias objetivo y prioridades de guarnición.
- Proporción máxima de fuerzas en frente, reserva y retaguardia.
- Tolerancia para atacar según terreno, clima, fortificaciones y relación de fuerzas.
- Presupuesto de refuerzo, modernización y construcción.
- Mezcla deseada de infantería, caballería, montaña, artillería y flota.
- Prioridades y exclusiones tecnológicas.
- Uso de suministro ofensivo, redespliegue y fuerzas expedicionarias.
- Cambio de perfil mediante eventos cuando cambia la situación estratégica.

Esto encaja especialmente bien con la Guerra del Pacífico:

- Chile: ofensiva costera, superioridad naval, desembarcos y objetivos salitreros.
- Perú: defensa de puertos, conservación de la escuadra y posterior resistencia de la sierra.
- Bolivia: defensa del litoral primero y preservación del altiplano después.
- Argentina y potencias externas: perfiles diplomáticos, no necesariamente combatientes.

Aplicación recomendada: mover objetivos y ponderaciones actualmente codificados en `AIManager.gd` a archivos `data/ai/1879/*.json`, manteniendo el algoritmo de rutas en código.

### 3. Diplomacia como sistema propio

HOI2 modela explícitamente relaciones bilaterales, alianzas, garantías, acceso militar, pactos de no agresión, reclamaciones, influencia, negociaciones y tratados de paz. También asigna un coste político a cada acción.

El proyecto actual todavía muestra un panel de diplomacia de fase 0 y declara que la capa completa queda para una fase posterior. Esta es la mayor oportunidad de reutilización conceptual.

Aplicación recomendada:

- Crear un `DiplomacyManager` como fuente única del estado de guerra y relaciones.
- Representar relaciones bilaterales y tratados como datos persistentes.
- Conectar eventos, IA, comercio, agentes y UI a ese gestor.
- Añadir presión internacional, mediación, compras de armas, acceso portuario y reconocimiento de ocupaciones.
- Evitar copiar los valores numéricos de HOI2: fueron calibrados para 1936–1953, no para 1879.

### 4. Escenario compuesto

HOI2 divide cada escenario en:

- Manifiesto global.
- Archivo independiente por país.
- Orden de batalla.
- Propiedad y control de provincias.
- Reservas y recursos.
- Relaciones y políticas.
- Tecnología inicial.
- Eventos y perfiles de IA asociados.

El proyecto ya usa una arquitectura JSON data-driven compatible con esta idea. Lo aprovechable es reforzar la composición: manifiesto pequeño y paquetes separados por país, fuerzas, diplomacia, eventos y reglas de victoria.

### 5. Tecnología por componentes

Cada tecnología de HOI2 tiene año, requisitos, cinco componentes especializados, dificultad y efectos. Los equipos de investigación nacionales tienen competencias que se comparan con esos componentes.

El proyecto actual posee un catálogo tecnológico y modular mucho más extenso que HOI2. No necesita importar el árbol antiguo. Sí puede adoptar dos ideas:

- Penalización o bonificación por adecuación entre institución investigadora y componentes.
- Efectos tecnológicos expresados como comandos de datos, en vez de lógica específica por tecnología.

Para 1879 serían instituciones como arsenales, astilleros, escuelas militares, universidades, misiones extranjeras y compañías ferroviarias.

### 6. Unidades y combate

HOI2 separa estadísticas básicas del modelo, brigadas adjuntas y modificadores doctrinales. También distingue organización de moral: la primera representa preparación inmediata y la segunda velocidad de recuperación.

Ideas útiles:

- Organización y moral como variables distintas.
- Peso de transporte y consumo logístico por unidad.
- Límites de mando y penalización por exceso de unidades.
- Bonos por ataque multidireccional, cerco, suministro, fuertes, costa y apoyo naval.
- Coste y tiempo de refuerzo distintos del coste de construcción.

Los modelos y cifras concretas no son históricos para 1879 y no deben reutilizarse directamente.

### 7. Logística y control del mar

HOI2 relaciona capacidad de transporte con industria, carga de partisanos, consumo de suministros, infraestructura, convoyes y escoltas. Los buques poseen alcance, consumo, visibilidad, detección, ataque a convoyes y bombardeo costero.

El proyecto actual ya tiene una red logística más rica, con rutas, depósitos, interdicción y reposición por desgaste. Conviene conservarla. Las ideas adicionales de HOI2 que sí encajan son:

- Presupuesto nacional de transporte limitado.
- Capacidad portuaria como cuello de botella.
- Convoyes y escoltas como recursos construibles y destruibles.
- Bombardeo costero limitado y apoyo a desembarcos.
- Bloqueo que reduzca comercio, suministro, ingresos y apoyo de guerra.

Esto convierte Angamos y el dominio marítimo en cambios mecánicos reales, no solo modificadores narrativos.

### 8. Mapa y provincias

El esquema provincial antiguo combina en una fila:

- Región y continente.
- Clima y terreno.
- Infraestructura.
- Puerto y zona marítima.
- Industria, población militar y recursos.
- Coordenadas de ciudad, ejército, puerto y playa.

La idea de capas es útil, pero la geometría no. Para el teatro 1879, HOI2 solo ofrece una provincia para Antofagasta y omite Iquique, Tarapacá, Arica y Tacna. El mapa propio del proyecto ya es superior para el escenario.

### 9. Localización

HOI2 usa claves estables y columnas por idioma. El proyecto usa JSON por idioma, que es más limpio y debe mantenerse. Solo conviene adoptar la disciplina de que eventos, tecnologías, efectos y UI referencien claves estables, nunca textos históricos incrustados en scripts.

## Comparación con la implementación actual

### Capacidades actuales que deben conservarse

- Mapa histórico propio y capas de provincias.
- Suministro con rutas, depósitos, interdicción y desgaste.
- Producción modular y catálogos extensos.
- Líderes históricos 1879 y progresión propia.
- Localización JSON.
- Guardado de estado por gestores.
- Condiciones de victoria específicas del salitre y del litoral.

### Carencias que HOI2 ayuda a resolver

1. El `EventManager` solo admite `date`, `province_owner` y `date_and_condition`.
2. Los eventos actuales no ofrecen elecciones al jugador; el popup solo permite continuar.
3. `damage_unit` y `destroy_unit` actualmente registran mensajes, pero no alteran unidades reales.
4. La guerra se representa en más de un lugar: `EventManager` modifica un booleano en `LeaderManager`, mientras `AIManager` mantiene su propio mapa de pares en guerra.
5. No existe todavía un gestor diplomático que sea fuente única de relaciones, alianzas y paz.
6. La IA tiene objetivos territoriales específicos de Chile, Perú y Bolivia codificados en GDScript.
7. Solo existen seis eventos históricos 1879, todos automáticos y lineales.
8. El bloqueo, convoyes y combate naval decisivo siguen documentados como trabajo futuro.

## Prioridad recomendada

### P0 — Base necesaria

1. Crear una fuente única de estado diplomático y de guerra.
2. Hacer que los efectos de evento muten sistemas reales y tengan pruebas.
3. Añadir opciones y consecuencias diferidas al motor de eventos.

### P1 — Mayor ganancia jugable

4. Crear perfiles de IA JSON por país y fase de la guerra.
5. Implementar bloqueo, capacidad portuaria y convoyes.
6. Crear cadenas regionales para Argentina, Brasil, Estados Unidos, Reino Unido, Francia y Alemania.

### P2 — Profundidad

7. Añadir tratados negociables, mediación y paz condicional.
8. Añadir instituciones/equipos de investigación de 1879.
9. Separar organización, moral, transporte y límites de mando si aún no están modelados de extremo a extremo.

## Cadena inicial de eventos propuesta

La estructura de `platineanwar` puede reinterpretarse así, con contenido propio e históricamente investigado:

1. Impuesto boliviano a la compañía salitrera.
2. Amenaza de remate y ocupación de Antofagasta.
3. Activación del tratado secreto Perú–Bolivia.
4. Intentos de mediación peruana.
5. Declaraciones de guerra escalonadas.
6. Decisiones argentinas sobre neutralidad, frontera y presión diplomática.
7. Compras navales y de armamento en Europa.
8. Campaña naval: Iquique, correrías del Huáscar y Angamos.
9. Desembarcos condicionados por dominio marítimo y capacidad portuaria.
10. Tacna, retiro efectivo de Bolivia y defensa de Arica.
11. Ocupación de Lima, resistencia de la sierra y desgaste político.
12. Mediación, Tratado de Ancón y Pacto de Tregua con resultados alternativos.

## Restricciones legales y técnicas

- No distribuir archivos, textos, gráficos, audio, ejecutables ni mapas extraídos de HOI2.
- No copiar valores o bases de datos completas al proyecto.
- Implementar las ideas con esquemas, código, textos y recursos propios.
- Verificar históricamente todo contenido de 1879 con fuentes independientes.
- En HOI2, `PER` significa Persia y `PRU` significa Perú. El proyecto usa `PER` para Perú; cualquier importador experimental debe traducir esa etiqueta explícitamente.
- Los órdenes de batalla regionales de HOI2 corresponden a 1936 y contienen buques y unidades posteriores a la Guerra del Pacífico; solo sirven como ejemplos de formato.

## Conclusión

HOI2 sirve como un excelente libro de patrones para sistemas de gran estrategia. La mejor inversión no es trasladar su contenido, sino incorporar tres de sus ideas maduras a la arquitectura moderna del proyecto: eventos con decisiones, IA declarativa y diplomacia centralizada. El mapa, la logística detallada, la producción modular y los datos históricos deben seguir siendo propios del proyecto.
