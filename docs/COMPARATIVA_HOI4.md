# Comparativa Completa: Proyecto "Guerra del Pacífico 1879" vs. Hearts of Iron 4 (Paradox)

> Hardware: AMD FX-6350, 16 GB RAM, Radeon R7 360 (2 GB), OpenGL (`gl_compatibility`)
> Fecha: Junio 2026 | Godot 4.6

---

## 1. 🗺️ MAPA / RENDERIZACIÓN

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Base visual** | Polígonos 2D sueltos (`Polygon2D`) sobre fondo negro. La `world_map.png` (4096×2048, textura satelital) existe pero **se oculta** (`visible = false`) | Imagen satelital equirectangular del mundo real como base. El render superpone colores políticos y niebla de guerra con shaders |
| **Provincias** | ~107 con geometría real (Europa, WWII). 847 IDs cargados pero la mayoría sin puntos → no se ven | ~15,000 provincias con forma geográfica real, más 1,500 marítimas |
| **Coordenadas** | 4096×2048, ancladas a "background_pixels". Nota interna: *"Starter 90 provinces focused on Europe + major powers"* | Coordenadas mundiales proyectadas (Mercator), con textura satelital de 4096×2048 |
| **Renderizado** | `Polygon2D` coloreado en `Node2D` simple. Sin shaders, sin textura base, sin relieve | Shader GLSL personalizado que mezcla: textura base + color político + relieve + niebla + border glow |
| **Modos de mapa** | No hay selector de modo | 6+: Político, Terreno, Recursos, Suministro, Resistencia, Inteligencia |
| **Bordes de provincia** | `Line2D` outlines + pulso animado | Bordes con glow animado, grosor variable por zoom |
| **Niebla de guerra** | ❌ No existe | Provincias no exploradas se ven grises/oscurecidas |
| **Relieve / Terreno** | `terrain_modifiers` existen en datos pero no se renderizan | Shader mezcla textura de terreno con el color base |
| **Íconos de provincia** | Features (capital⭐, etc.) renderizados como emojis en `Label` | Sprites/texturas de recursos, edificios y terrain features |
| **Tooltip de provincia** | `ProvinceHoverTooltip` sigue al mouse | Tooltip contextual con info detallada: recursos, edificios, terreno |
| **Panel de info** | `InfoPanel` con ~10 labels (nombre, owner, población, etc.) | Panel expandible con pestañas, datos detallados, decisiones |
| **Etiquetas de nombre** | Labels sobre el centroide, visibles al zoom | Nombres de estado/región estratégica, visibles por zoom |
| **Zoom dinámico** | `min_zoom=0.15, max_zoom=8.0` | Rango similar, con LOD en provincias |
| **MapPickGrid** | Spatial picking grid para detección de click/hover | Sistema interno de picking con colisión contra polígonos |

### 🐞 Errores del mapa
- **E23**: Mapa oscuro y plano → Color de océano cambiado a azul profundo, saturación de países aumentada vía `_saturate_color()` (manual, Godot 4.6 no tiene `.saturated()`)
- **E8**: Provincias WWII (ids 2/4/5/6) eliminadas → eliminadas del `scenario.json`
- **E17**: Antofagasta (841) owner/controller incorrecto → corregido a BOL en escenario + evento de transferencia
- **⚠️ Activo**: Mapa se ve "como figuras geométricas de colores" — falta textura satelital base, provincias en Europa

---

## 2. 🎮 CÁMARA / VIEWPORT

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Scroll** | Edge pan + WASD + flechas + middle-mouse drag | Edge pan + middle-mouse drag + teclas WASD/flechas |
| **Zoom** | Rueda del mouse → hacia el mouse | Rueda del mouse → hacia el mouse (suave + instantáneo) |
| **Sistema** | **DOS sistemas activos simultáneamente**: `CameraController.gd` (mueve `ProvinceContainers`) + `MapRenderer._handle_camera_input()` (mueve `MapCamera`/Camera2D) | Sistema único de cámara: un solo `Camera2D` controlado por un solo controlador |
| **Límites** | Sin límite de mapa (la cámara puede salir al vacío gris) | Borde del mapa detiene la cámara |
| **Drag con botón central** | Sí, en ambos sistemas | Sí, movimiento fluido |
| **Drag con botón izquierdo** | Tap detection (no arrastre) | Solo selección |
| **Táctil** | Touch + pinch zoom implementado | No aplica |
| **Smooth zoom** | Lerp hacia target | Lerp hacia target |
| **Bloqueo en UI** | `MapViewInput.gui_blocks_map_input()` | Mouse sobre UI bloquea scroll/zoom |

### 🐞 Errores de cámara
- **⚠️ Activo**: "Cámara se vuelve loca al mover el mouse" → 2 sistemas de cámara respondiendo a los mismos inputs, moviendo diferentes nodos (multiplica el movimiento)
- **⚠️ Activo**: No hay límite de mapa → cámara se va al vacío gris

---

## 3. 🖥️ UI / INTERFAZ

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Top Bar** | `TopInfoBar.gd`: fecha, recursos (Salitre/Guano/Plata/Cobre/Carbón) | Fecha, poder político, estabilidad, apoyo bélico, recursos, líder nacional, war score |
| **Sidebar (izquierda)** | ❌ No existe | Construcción, investigación, diplomacia, árbol de focos, decisiones, logística |
| **Bottom Bar** | ❌ No existe | Ejército, marina, aire, intel, suministro |
| **Menú principal** | `StartMenu.gd`: fondo desierto-mar, botones (New Game, Load, Settings, Quit) | Menú con play, tutorial, DLC, configuración, mods |
| **Selección de país** | `NationSelectScreen.gd`: 3 tarjetas (CHL/PER/BOL) con banderas, stats, estrellas | Selector de país con mapa global + info de país + foco histórico |
| **Popups** | `EventPopup`, `BattleResultPopup`, `VictoryScreen`, `TutorialPopup` | Múltiples popups modales anclados al centro de la pantalla |
| **Tooltips** | `ProvinceHoverTooltip` + tooltips de botón estándar | Tooltips ricos con BBCode, tablas, íconos, colores |
| **Info de provincia** | `InfoPanel` lateral (oculto, se muestra al click) | Panel expandible con solapas y estadísticas |
| **Pausa** | `TimeManager.Paused` toggle vía TopInfoBar | Barra espaciadora pausa/reanuda |
| **Velocidad** | 4 velocidades en TopInfoBar | 5 velocidades (pausa, 1-5) |
| **Settings** | `SettingsPopup.tscn` | Ventana completa de opciones |
| **Fonts** | Tema por defecto de Godot | Fonts personalizados por Paradox |
| **Mapa UI** | `CanvasLayer` layer 20 para UI sobre mapa | Capas de UI separadas del viewport del mapa |
| **NPC / Diálogos** | ❌ No existe | Ventanas de eventos con opciones narrativas |
| **Tutorial** | `TutorialPopup` simple | Sistema de tutorial interactivo |

### 🐞 Errores de UI
- **E19**: Pantalla selección sin diseño → Rediseñada con banderas, estrellas, stats, descripciones ✅
- **E20**: Tildes mal en StartMenu/NationSelect/TopInfoBar → Corregidas ✅
- **E21**: Recursos incorrectos en TopInfoBar → Cambiados a 1879 ✅
- **⚠️ Activo**: Barras de stats (Ejército/Marina/Economía) en NationSelect aparecen vacías — bug de layout
- **⚠️ Activo**: Espacio vacío enorme bajo "▶ JUGAR" en cada tarjeta
- **⚠️ Activo**: Paneles de agente/diplomacia aparecen fuera del mapa en zona gris (posicionados en coordenadas del mundo, no de la pantalla)

---

## 4. 🕹️ INPUT / CONTROLES

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Mouse LMB** | Tap: selecciona provincia + info panel + movimiento de unidad | Selección, orden de movimiento, ataque |
| **Mouse RMB** | ❌ No hay acción | Deseleccionar, menú contextual |
| **Mouse MMB** | Arrastre de cámara | Arrastre de cámara |
| **WASD** | Mueve cámara | Mueve cámara |
| **Flechas** | Mueve cámara | Mueve cámara |
| **Rueda** | Zoom hacia mouse | Zoom hacia mouse |
| **Tecla L** | Toggle supply overlay | No existe |
| **Tecla Espacio** | ❌ No conectado | Pausa/Reanuda |
| **Números 1-5** | ❌ No existe | Velocidad del juego |
| **Bloqueo en UI** | `gui_blocks_map_input()` | Mouse sobre UI bloquea input del mapa |

---

## 5. 🏛️ DIPLOMACIA

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Relaciones** | -200 a +200 | -200 a +200 |
| **Declarar guerra** | Sí, vía eventos | Sí, vía casus belli o sin él |
| **Paz** | Eventos disparan paz inmediata | Conferencias de paz con puntos de victoria |
| **Alianzas** | ❌ No implementado | Alianzas, facciones (Eje, Aliados, Comintern, etc.) |
| **Garantías** | ❌ No implementado | Garantizar independencia de otro país |
| **No-ataque** | ❌ No implementado | Pactos de no agresión |
| **Títeres** | ❌ No implementado | Anexión, liberación, títeres |
| **Concesiones** | ❌ No implementado | Concesiones territoriales y diplomáticas |
| **Pantalla de diplomacia** | ❌ No existe | Ventana con pestañas por país |
| **Facciones** | ❌ No existe | Sistema completo de facciones (Aliados 1879: PER+BOL) |
| **Casus belli** | ❌ No existe (guerra directa) | Sistema formal de CB |

### 🐞 Errores diplomáticos
- **E9**: Tag "ENG" inconsistente → Verificado y consistente ✅
- **E3**: Eventos navales no funcionaban → `_find_formation()` añadido ✅

---

## 6. ⚔️ COMBATE TERRESTRE

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Unidades** | `Formation` con `template_id`, líder, stats básicas | Divisiones con plantillas de hasta 25 batallones (5×5) |
| **Plantillas** | JSON templates simples con stats | Editor visual de plantillas con drag & drop |
| **Stats** | Ataque, defensa (simplificado) | Soft Attack, Hard Attack, Defense, Breakthrough, HP, etc. |
| **Movimiento** | Salto entre provincias adyacentes (instantáneo) | Movimiento progresivo con ETA visible |
| **Combate** | `BattleManager` + `CombatResolver`: width + stacking penalty + stats | Sistema completo: fases (día/noche), apoyo, planeamiento, reservas |
| **Ancho de combate** | 80 llano, 40 montaña, etc. | 80 base + 40 por flanco adicional |
| **Penalización por stacking** | 1% por extra | Progresiva, máxima 70% |
| **Terreno** | Modificadores attack/defense por tipo | Modificadores detallados por terreno + clima + fortificaciones |
| **Clima** | `weather_change` cada 30 días | Clima dinámico por zona estratégica |
| **Atrincheramiento** | Hasta nivel 5, gana 1/7 días quieto | Hasta nivel 10, bonificación a defensa |
| **Refuerzos** | Cola evaluada cada 7 días | Refuerzos continuos con prioridad |
| **Planeamiento** | ❌ No existe | Planning bonus hasta +30% al atacar |
| **Fortificaciones** | ❌ No existe | Niveles de fortificación con defensa adicional |
| **Reservas** | ❌ No explícito | Divisiones en reserva entran al combate |
| **Frente / Línea** | ❌ No existe | Battle plans con front line, spearhead, offensive line |
| **Pérdidas** | Registro en SupplyManager | Bajas detalladas: equipo, manpower, experiencia |

### 🐞 Errores de combate
- **E4**: `_deploy_starting_forces` no usaba plantillas → Reescribir creando formaciones desde JSON ✅
- **E16**: Falta plantilla de caballería chilena → `chl_cavalry_1879` añadida ✅

---

## 7. ⚓ COMBATE NAVAL

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Sistema** | ❌ Solo eventos históricos (Iquique, Angamos) + Formaciones navales | Flotas completas con almirantes, misiones, doctrinas |
| **Buques** | Templates navales en data (armstrong_battleship, etc.) pero sin sistema de flota | 7 clases: BB, BC, CA, CL, DD, SS, CV |
| **Misiones** | ❌ No existe | Patrulla, strike force, convoy escort, convoy raid, minelaying, etc. |
| **Combate naval** | ❌ Solo eventos disparan batallas | Combate en fases: deteción → posicionamiento → combate → retirada |
| **Doctrinas** | ❌ No implementado | Doctrinas navales: Fleet in Being, Trade Interdiction, etc. |
| **Bloqueo** | ❌ No existe | Bloqueo naval y blockaderunning |
| **Convoys** | ❌ No existe | Rutas de convoy con escoltas y raiders |

### 🐞 Errores navales
- **E3**: Batallas navales no se disparaban (Iquique, Angamos) → Arreglado con `_find_formation()` ✅

---

## 8. ✈️ SISTEMA AÉREO

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Alas aéreas** | ❌ No existen | Misiones aéreas con wing de aviones |
| **Misiones** | ❌ No existe | Superioridad aérea, CAS, bombardeo estratégico, interceptación, reconocimiento |
| **Aeropuertos** | ❌ No existe | Capacidad de aeropuerto por provincia |
| **Diseños** | `air_equipment.json` con diseños, pero sin sistema de uso | Diseñador de aviones con alas, motores, armamento |
| **Combate aéreo** | ❌ No existe | Combate aéreo con fase de detección, combate, pérdidas |
| **Doctrinas** | ❌ No existe | Doctrinas aéreas (Strategic Destruction, etc.) |

---

## 9. 💰 ECONOMÍA / PRODUCCIÓN

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Recursos** | Nitrates, Guano, Silver, Copper, Coal, Gold, Tin | 12 recursos: acero, aluminio, goma, tungsteno, petróleo, cromo, etc. |
| **Fábricas** | `FactoryManager` con 80 factories, 5 shipyards | Civiles (construcción), Militares (equipo), Astilleros (barcos) |
| **Construcción** | ❌ No hay UI ni sistema de construcción | Cola de construcción con tiempo y costo |
| **Líneas de producción** | `ProductionLine.gd`, `ProductionManager` | Líneas de producción con eficiencia, retooling, daño |
| **Diseñadores** | `DesignManager` + `DesignDataLoader` (1031 templates) | Diseñador modular: tanques, barcos, aviones, infantería |
| **Equipamiento** | 1082 módulos, 1031 plantillas, 4 sustainment | Centenares de equipos con stats detalladas |
| **Comercio** | `TradeManager`: ofertas de mercado, trueque (salitre→carbón) | Mercado global, rutas de convoy, bloqueo |
| **Eficiencia** | `ProductionModifier`, `RetoolingCalculator` | Eficiencia de línea (max 100%), retooling con penalización |
| **Shortage** | `EquipmentShortageTracker` | Déficit de equipo penaliza stats de división |
| **Mercado negro** | `TradeManager` con soporte | ❌ No existe en HOI4 vanilla |

### 🐞 Errores económicos
- **E7-Trade**: Recursos desactualizados → Cambiados a 1879. Ofertas históricas añadidas ✅
- **E7-Supply**: Stubs de migración → Remplazados con lógica real v0→v1→v2 ✅

---

## 10. 🔬 TECNOLOGÍA / INVESTIGACIÓN

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Árbol** | 23 nodos de tecnología, era 1879 | 1000+ nodos en árbol con 5 ramas: infantería, blindados, naval, aéreo, doctrinas |
| **Slots** | 2 slots de investigación | 3-5 slots según país |
| **RP/Día** | 1.0 RP base/día | Variable por país y año |
| **Doctrinas** | ❌ No implementado | Ramas separadas: terrestre, naval, aérea |
| **Requisitos** | Nodos con dependencias | Árbol con prerequisitos y eras |
| **Variantes** | Soporte en datos | Variantes de equipos con cañón, blindaje, motor mejorados |
| **Investigación de bonificación** | ❌ No existe | Bonus de investigación por diseño, espionaje, focos |
| **ERA_SWIMLANES** | Definidas: pre_war (1900-1918) a far_future (2040-2050+) | Eras históricas con años de inicio |
| **Aplicación** | `_gated_unit_designs`, `_gated_production_categories` | Desbloqueo de diseños y módulos |

---

## 11. 🕵️ ESPIONAJE / INTELIGENCIA

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Agentes** | 12 espías históricos (Lynch, Candamo, Montero, etc.) | Agentes reclutables con nombres aleatorios |
| **Misiones** | 11 misiones: supply_disruption, sabotage_infrastructure, etc. | Docenas: sabotaje, diplomacia, contrainteligencia, operaciones |
| **Redes** | Red de sabotaje con efectividad diaria | Red de inteligencia con cobertura pasiva + operaciones |
| **Sabotaje** | Conectado a `SupplyManager.apply_supply_disruption()` | Daño a edificios, reducción de producción, ataque a recursos |
| **Diplomático** | ❌ No implementado | Mejorar/dañar relaciones, fabricar casus belli |
| **Contrainteligencia** | ❌ No implementado | Protección contra espionaje enemigo |
| **Mercado negro** | Conectado a TradeManager | ❌ No existe en HOI4 vanilla |
| **Targets** | CHL, PER, BOL, ARG, BRA, ENG, FRA, USA | Cualquier país |

### 🐞 Errores de espionaje
- **E7-Agents**: Históricos incorrectos (Daza era presidente) → Corregido. Targets actualizados a 1879 ✅

---

## 12. 🎯 POLÍTICA / IDEOLOGÍA

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Ideologías** | ❌ No existen | Fascismo, Democracia, Comunismo, No-alineados |
| **Apoyo popular** | ❌ No existe | % de apoyo por ideología, sublevaciones |
| **Poder político (PP)** | ❌ No existe | Moneda para decisiones, consultor, focos |
| **Elecciones** | ❌ No existe | Elecciones periódicas en democracias |
| **Estabilidad** | ❌ Solo modificadores `peace_pressure+5` | Sistema formal 0-100% con efectos |
| **Apoyo bélico** | ❌ Solo `war_support+10` | Sistema formal 0-100% con efectos |
| **Espíritus nacionales** | `NationalSpiritManager` + `spirit_definitions.json` | Espíritus persistentes con efectos |
| **Focos nacionales** | ❌ No existe | Árbol de focos por país (30-150 focos) |
| **Decisiones** | ❌ No existe | Decisiones políticas con coste de PP |
| **Consultor** | ❌ No existe | Asesores políticos con bonificaciones |

---

## 13. 📜 EVENTOS / NARRATIVA

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Eventos** | 26 eventos históricos cargados desde JSON | Centenares de eventos históricos + aleatorios |
| **Condiciones** | `evaluate_conditions()` | Sistema complejo de triggers con AND/OR/NOT |
| **Efectos** | Modificadores, guerra, paz, transferencia de provincia | Modificadores, guerra, paz, claims, anexión, etc. |
| **Cadenas** | Eventos secuenciales | Árbol de eventos con opciones y consecuencias |
| **Frecuencia** | Cada día evalúa todos | Eventos disparados por condiciones, no por polling diario |
| **Formatos** | JSON con triggers + effects | Scripted triggers + effects en lenguaje propio de Paradox |

### 🐞 Errores de eventos
- **E3**: Eventos navales no encontraban formaciones → `_find_formation()` añadido ✅
- **E17**: Antofagasta no se transfería → Evento `guerra_inicio.json` corregido ✅

---

## 14. 📋 OCUPACIÓN / RESISTENCIA

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Resistencia** | ❌ Solo `occupation_cost+8` como modificador | Sistema completo con resistencia, compliance, guarniciones |
| **Políticas** | ❌ No existe | Políticas de ocupación: duro → blando |
| **Guarniciones** | ❌ No existe | Tropas asignadas a control de resistencia |
| **Compliance** | ❌ No existe | Nivel de colaboración (0-100%) |

---

## 15. 🧠 IA

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Económica** | `AIEconomyManager` inicializado | IA construye fábricas, comercia, investiga |
| **Militar** | ❌ No implementado | IA mueve ejércitos, planea ofensivas, refuerza |
| **Diplomática** | ❌ No implementado | IA evalúa alianzas, garantías, declaraciones |
| **Nacional** | ❌ `AIManager` existe en autoloads pero no implementado | IA por país con personalidad (agresiva, defensiva, etc.) |
| **Avanzada** | `AdvancedAIManager` inicializado vacío | Estrategia global por facción |

---

## 16. 🧑‍✈️ LÍDERES / COMANDANTES

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Líderes** | 16 líderes históricos de 1879 | Líderes históricos + generados |
| **Stats** | Skills básicos | 4 stats: ataque, defensa, planeamiento, logística |
| **Rangos** | Asignación a posiciones (chief_of_army, etc.) | General, FM, almirante, etc. |
| **Experiencia** | Sistema de training con decaimiento | XP ganada en combate y training |
| **Traits** | Nivelables | 50+ traits con efectos |
| **Reemplazo** | Automático: `REPLACEMENT_INSTANT_SINGLE_CANDIDATE` | Reemplazo desde pool |
| **Captura/Muerte** | Señales `leader_died`, `leader_captured` | Líderes pueden morir o ser capturados en combate |

---

## 17. 💾 SAVE / LOAD

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Formato** | JSON v1 | Binario comprimido `.hoi4` |
| **Migración** | v0→v1→v2 (resources renombrados) | No aplica (versión única por patch) |
| **Slots** | Múltiples slots vía `list_saves()` | Slots con nombre + autosave |
| **Metadata** | Player tag, fecha, país | Miniatura, fecha, versión, mods |
| **Escenario** | Escenario 1879 hardcodeado | Selección de fecha histórica |
| **Save en pausa** | `pending_load_slot` para deferred load | Save durante pausa |

### 🐞 Errores de save/load
- **E7-SaveLoad**: Stub de migración vacío → Reemplazado con lógica real v0→v1 y v1→v2 ✅

---

## 18. 🎬 MENÚS / FLUJO DEL JUEGO

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Inicio** | `StartMenu.tscn` → estilo histórico desierto-mar | Menú principal con animación de fondo |
| **Selección de país** | `NationSelectScreen.tscn` → 3 tarjetas | Mapa global interactivo + info de país |
| **Carga de partida** | `_on_load_game()` → carga escenario + saves | Lista de saves con preview |
| **Settings** | `SettingsPopup` | Menú completo de opciones |
| **Tutorial** | `TutorialPopup` | Tutorial interactivo |

### 🐞 Errores de menú
- **E11**: Nombre del proyecto incorrecto → "Guerra del Pacifico 1879" ✅
- **E12**: Menús duplicados → Pendiente de decisión de diseño
- **E13**: Archivo de escenario en ubicación incorrecta → Eliminado ✅
- **E15**: 40+ archivos `.md` en carpeta equivocada → Archivados a `docs/auditoria/` ✅

---

## 19. 🎨 FORMACIONES / UNIDADES

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Tipo** | Formation (Flota/División) | Divisiones, flotas, alas aéreas |
| **Stats** | Stats base desde template | Soft/Hard Attack, Defense, Breakthrough, HP, Organization, etc. |
| **Template** | JSON con estructura simple | Editor con 5x10 slots + batallones de apoyo |
| **Equipamiento** | Template refiere a diseño | División consume equipo real de las reservas |
| **Experiencia** | ❌ No en formaciones (solo líderes) | Veterania: Trained → Regular → Seasoned → Veteran |
| **Organización** | ❌ No existe | Org se recupera en reposo, se pierde en combate |
| **Suministro** | `SupplyManager` con depósitos | Consumo de suministro basado en peso de la división |

---

## 20. ⏱️ TIEMPO / CALENDARIO

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Tick** | TimeManager impulsado por TopInfoBar (`advance_real_time`) | Tick cada hora de juego |
| **Señales** | `game_day_advanced`, `game_month_advanced`, `game_year_advanced` | Señales similares por tick |
| **Pausa** | `Paused = true/false` | Barra espaciadora toggle |
| **Velocidad** | 4 niveles (1-4) | 5 niveles (pausa, 1-5) |
| **Fecha inicio** | 1879-02-14 | 1936-01-01 (por defecto) |
| **Fecha** | Día, mes, año | Día, mes, año, hora |

### 🐞 Errores de tiempo
- **E10**: Clock no avanza → Verificado: avanza correctamente ✅

---

## 21. 🌍 LOCALIZACIÓN / TRADUCCIÓN

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Sistema** | `LocalizationSettings`, `LanguageManager`, `TranslationProvider` | Sistema de localización interno |
| **Idiomas** | Español (por ahora) | 10+ idiomas |
| **Textos** | `Localization.get_text("menu.main.new_game")` | Archivos YAML de localización |

---

## 22. 🏗️ CONSTRUCCIÓN / INFRAESTRUCTURA

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Infraestructura** | Datos en `province_economy_layer.json` | Niveles de infra (0-5) afectan movimiento y suministro |
| **Fábricas** | Datos de fábricas por provincia | Construcción de civiles/mils/astilleros |
| **Edificios** | ❌ No hay sistema de construcción | Base naval, aeropuerto, radar, silo, fortificaciones |
| **Mejora** | ❌ No implementado | Inversión para mejorar infraestructura |

---

## 23. 🚂 SUMINISTRO / LOGÍSTICA

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Red** | Depósitos desde datos de provincia | Nodos de suministro con ferrocarriles |
| **Rutas** | Multimodales (tierra/mar) | Rutas terrestres + marítimas + aéreas |
| **Interdicción** | `supply_disruption` de agentes | Bombardeo de rutas y puertos |
| **Attrition** | Registro de bajas | Pérdidas por clima, terreno, falta de suministro |
| **Depósitos** | Desde datos de provincia | Depósitos con niveles y alcance |
| **Hub** | ❌ No explicitado | `SupplyHub` con radio de acción |

---

## 24. ✅ QA / TESTING

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Tests** | Headless con `TestScenario.tscn` y `--qa-smoke` | Suite interna de Paradox |
| **Validación** | Supply test, infantería, producción | Tests automatizados por sistema |
| **Headless** | `--quit-after 400` | Modo de prueba interno |

### 🐞 Errores de testing
- **E6**: Tests con rutas y escenario incorrectos → Corregidos ✅

---

## 25. 🔧 HERRAMIENTAS / DEBUG

| Aspecto | Tu proyecto | HOI4 real |
|---------|-------------|-----------|
| **Logger** | `Logger.gd` con niveles (INFO, WARN, ERROR) | Sistema de logging interno |
| **Debug** | `debug_draw_province_centroids`, etc. | Consola de debug (tilda ~) |
| **Editor** | Godot 4.6 editor | Editor interno de Paradox |

---

## Resumen de errores por estado

### ✅ Corregidos (22)
E3, E4, E6, E7-Trade, E7-Agents, E7-SaveLoad, E8, E9, E10, E11, E13, E15, E16, E17, E19, E20, E21, E23, compilation fixes (MapRenderer saturated→_saturate_color, TradeManager stray `})`, SaveLoadManager/ScenarioLoader inferencia de tipo, NationSelectScreen type inference + missing var)

### ⚠️ Activos (7)
1. **Cámara dual** → 2 sistemas de movimiento simultáneos
2. **Paneles fuera de pantalla** → posicionados en world space
3. **Mapa sin textura base** → polígonos flotantes en negro
4. **Provincias en Europa** → coordenadas de mapa europeo WWII
5. **Barras de stats vacías** en NationSelect
6. **Espacio vacío bajo botón Jugar** en tarjetas
7. **Cámara sin límites** → se va al vacío gris

### ❌ Pendientes de diseño (2)
- **E12**: Menús duplicados de StartMenu
- **E22**: Panel de provincia tooltip (técnico)

---

## Brechas de funcionalidad vs HOI4 real (capas faltantes)

| # | Capa | Prioridad |
|---|------|-----------|
| 1 | 🌳 **Árbol de Focos Nacionales** (National Focuses) | Alta |
| 2 | 📋 **Decisiones políticas** (con coste de PP) | Alta |
| 3 | 🏛️ **Ideología / Política interna** | Media |
| 4 | 📊 **Estabilidad / Apoyo bélico** | Media |
| 5 | ⛓️ **Ocupación / Resistencia** | Media |
| 6 | ⚓ **Combate naval real** (misiones, flotas) | Media |
| 7 | ✈️ **Sistema aéreo** (alas, misiones) | Baja (1879) |
| 8 | 🚢 **Convoys / Comercio naval** | Baja (1879) |
| 9 | 🎯 **Poder de mando / Planes de batalla** | Baja |
| 10 | 🔭 **Inteligencia pasiva** | Baja |
| 11 | 🏗️ **Construcción de edificios** | Media |
| 12 | 🧠 **IA militar y diplomática** | Alta |
| 13 | 🖥️ **Sidebar / Bottom bar (HOI4-style UI)** | Alta |
