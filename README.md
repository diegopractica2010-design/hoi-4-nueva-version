# Epochs of Ascendancy

**A grand strategy game of empire, industry, and ascendancy across the 20th and 21st centuries.**

Built in **Godot 4.6** — inspired by *Hearts of Iron IV*, *Terra Invicta*, and *Supreme Ruler*.

---

## Vision

Epochs of Ascendancy puts you in command of any nation across three pivotal starting dates:

- **1918** – Post-WWI world of empires, revolution, and fragile peace
- **1936** – Interwar rearmament, ideological struggle, and the road to global conflict
- **2026** – Modern multipolar world with great-power competition, advanced technology, and the dawn of new frontiers

Shape (or completely rewrite) history through economic mastery, technological leaps, military innovation, ideological conviction, diplomacy, trade, espionage, and bold strategic choices. Every decision ripples through the ages. Deep replayability comes from choosing any country and forging alternate histories.

The game emphasizes **player freedom in design** — from customizing divisions, tanks, planes, ships, and even spaceships/space stations, to building massive focus trees and tech trees that reflect your nation’s unique path to ascendancy.

---

## Current Features

- **Three playable start dates** (1918, 1936, 2026) with era-appropriate data
- **~100 strategic provinces** with resources, terrain, development, infrastructure, population, and victory points
- **Dynamic province system** featuring factories, special buildings (Research Centers, Ports, Shipyards, Oil Rigs, Nuclear Plants, Spaceports, etc.) with upgradeable levels
- **Country system** with ideologies, stability, war support, capitals, and colors
- **Interactive map** with country-colored provinces, capital markers, stacked special feature icons, hover effects, and detailed InfoPanel
- **Camera controls** — Scroll wheel zoom (toward mouse), WASD panning, edge scrolling, and middle-mouse drag (recently overhauled and solid for prototype use)
- **Data-driven architecture** — JSON/resources for provinces, scenarios, and countries. Highly moddable foundation

---

## Controls (Current Prototype)

- **Left Click** — Select province and open InfoPanel
- **Mouse Hover** — Highlight provinces with pop effect
- **Camera** — Zoom, pan with WASD/edge/middle drag
- **Close Panel** — X button or Escape

---

## Expanded Scope & Key Systems

### Multiplayer
Primary focus is **2–4 players** online, with support for up to **4–8 players**. Games are designed around synchronous or turn-based-friendly online sessions. Authoritative server or peer-to-peer options will be evaluated. Hotseat/local multiplayer as a secondary mode. Multiplayer considerations will influence architecture from early on (state synchronization, desync prevention, etc.).

### Customization & Unit Designers
Full design freedom for key military and advanced assets:

- **Division Designer** — Customize infantry, support companies, templates
- **Tank Designer** — Chassis, guns, armor, engines, special modules
- **Plane Designer** — Fighters, bombers, CAS, transport aircraft
- **Boat / Ship Designer** — Surface fleet, submarines, carriers
- **Spaceship & Space Station / Satellite Designer** — Future-oriented units for orbital and deep-space operations (especially relevant in 2026+ scenarios)

Production lines feed these designs. Key equipment categories include infantry gear, artillery, drones (various types), and more. Units have stats, costs, and upgrade paths.

### Technology & Focus Trees
- **Large, branching Tech Tree** — Era-spanning research with prerequisites, bonuses, and alt-history branches
- **Large Focus Trees** — National/ideological paths with mutually exclusive or timed focuses. Major powers get deep trees; minors have meaningful options too

### Espionage, Agents & Intelligence
- **Agent system** with recruitment, assignment, skills, and experience
- **Espionage missions** (sabotage, intel gathering, influence ops, tech theft, etc.)
- **Facilities** supporting covert operations
- Integration with diplomacy, tech race, and internal stability

### Economy, Production & Trade
- Province-level and national production lines
- Resource management, stockpiles, and trade routes
- **Trade** as a major diplomatic and economic lever (bilateral deals, embargoes, global markets)

### Diplomacy & AI
- Deep diplomacy system (alliances, guarantees, trade agreements, ultimatums, influence)
- Robust **AI opponents** capable of long-term planning, reacting to player actions, and pursuing their own ascendancy goals
- AI will use many of the same systems (designers, focus trees, espionage) for fairness and depth

### Replayability & Alternate History
- Play **any country**
- Decisions have lasting consequences across economic, military, technological, and diplomatic spheres
- Strong support for alt-history outcomes through flexible trees, events, and player-driven unit/strategy design
- Multiple paths to victory or dominance (economic, military, technological, ideological, or hybrid)

---

## Development & Testing (May 2026)

- **Current state:** [docs/CURRENT_STATE.md](docs/CURRENT_STATE.md)
- **Testing plan:** [docs/TESTING_PLAN.md](docs/TESTING_PLAN.md) (Time, daily agent pressure, Support/Radio, multi-overlay map)
- **Roadmap / tasks:** [TODO.md](TODO.md)

---

## Systems Overview

- **Province & Map System** — Geography, resources, special features, dynamic state
- **Country & Ideology System** — Stability, support, leadership
- **Resource, Economy & Production** — Factories, lines, output, trade
- **Technology & Focus Trees** — Research and national direction
- **Unit Designers & Production** — Highly customizable military and advanced assets
- **Espionage & Agents** — Covert operations and intelligence
- **Diplomacy & Trade** — Relations and economic interaction
- **War & Military** — Units, movement, combat (with designer-created templates)
- **Scenario System** — Multiple start dates with tailored data
- **Multiplayer Foundation** — Online play for 2–8 players
- **AI Opponents** — Capable singleplayer experience
- **Data-Driven & Moddable** — JSON-heavy for easy extension

---

## Roadmap (Updated)

### Phase 1 — Prototype (✅ Complete)
- Core data loading, province system, interactive map, InfoPanel
- Camera navigation (zoom/WASD/edge/middle-drag) — solid for current needs

### Phase 2 — Data & Core Systems Foundation
- Expand data models for TechTree, FocusTree, Equipment/Unit definitions, ProductionLines
- Basic national economy and production loop
- Infrastructure & development mechanics
- Scenario data expansion

### Phase 3 — Designers & Military Core
- Implement Division, Tank, Plane, Ship designers (UI + backend)
- Production line system feeding designers
- Basic military units, templates, and movement
- Initial focus tree framework

### Phase 4 — Advanced Gameplay
- Full tech research system
- Deep focus trees for major powers
- Espionage system + agent management + missions/facilities
- Trade routes and diplomacy mechanics
- War mechanics and combat resolution

### Phase 5 — Multiplayer, AI & Polish
- Multiplayer architecture and online play (2–4 primary, up to 4–8)
- Capable AI opponents using core systems
- UI/UX polish, tooltips, national overview screens
- Sound, visuals, camera refinements
- Save/load, replay tools

### Phase 6 — Future & Release
- Spaceship / space station / satellite designers and orbital mechanics
- 2026+ specific content (advanced tech, space race elements)
- Balance, alt-history events, Steam integration
- Mod support expansion

**Note on Map Visuals**: The current interactive province map works well. A full visual overhaul (high-res Earth background + refined province artwork) is deferred to leverage better image generation and design tools available now. Conceptual assets and icons can be prototyped immediately.

---

## Tech Stack & Development

- **Godot Engine 4.6+** + **GDScript**
- Data-driven design (JSON + Godot Resources for provinces, countries, tech, focuses, units, etc.)
- Networking: Godot built-in (ENet/WebRTC) or plugins evaluated for multiplayer
- Development aided by **Cursor** + latest **Grok / Grok Build** multi-agent coding tools for rapid iteration on complex systems

---

## How to Run (Development)

1. Clone the repository
2. Open in **Godot 4.6.2** or newer
3. Open `scenes/WorldMap.tscn`
4. Press **F5** to run

---

## Map & Visual Assets

The current province map and camera are functional. We can generate conceptual art, icons, UI mockups, or style references right here using available image tools for inspiration or prototyping. Actual in-game textures and a polished world map can be integrated once data models are firmer. Let me know if you want example generations (e.g., espionage facility concepts, designer UI mockups, or alternate province styles).

---

## Contributing

Contributions welcome from Godot devs, historians, strategy fans, UI designers, and anyone passionate about deep grand strategy with alt-history freedom.

---

## License

MIT License — see LICENSE file.

---

**Let’s build the definitive grand strategy experience of ascendancy across the ages.**
