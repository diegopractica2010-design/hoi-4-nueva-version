# COMBAT PHILOSOPHY — Epochs of Ascendancy

**Last Updated:** May 2026

## Core Principles
- Grand strategy first. Combat should feel meaningful and layered without becoming a tactical wargame.
- Equipment quality (Infantry + Sustainment) matters.
- **Readiness** and **Organization** are the two primary "health" stats.
- Logistics, preparation, terrain, and leadership should matter more than raw numbers.
- Prevent pure doomstacking through meaningful limits.

## Key Stats
- **Manpower / Crew**: Actual soldiers present.
- **Infantry Equipment**: Rifles, SMGs, assault rifles, machine guns.
- **Sustainment Equipment**: Uniforms, basic ammo, grenades, tools, medical supplies.
- **Readiness**: How combat-ready the unit currently is.
- **Organization (Org)**: Cohesion and ability to stay in combat / maneuver.
- **Soft Attack**: Damage vs infantry and soft targets.
- **Hard Attack**: Damage vs vehicles, tanks, fortifications, gun crews.

## Supply Modeling
- Supply is an **abstracted resource** produced by provinces.
- The **capital** is the main source.
- Large population/industrial provinces can produce limited local supply.
- Small islands or low-population areas produce almost nothing.
- Surrounded units can survive for a time on local production + stockpiles + airdrops.

## Combat Width & Doomstack Prevention
- Primarily driven by **Infrastructure** level of the province.
- Terrain (jungle, mountains, urban, etc.) applies strong modifiers.
- Doctrine, leader traits, and infrastructure investment can increase effective combat width.
- Only a limited number of units can effectively engage at once. Excess units act as reserves.

## Major Combat Modifiers
- **Terrain**: Strong defensive bonuses in jungle, forest, mountains, urban.
- **River Crossing / Amphibious / Paradrop**: Significant penalties to attacker.
- **Engineers**: Reduce penalties, speed up digging in, enable fort repair and basic construction.
- **Night Attacks**: Moderate penalty (not crippling). Some surprise is possible.
- **Recon (Ground + Air + Satellites)**: Reduces fog of war and improves planning.
- **Shore Bombardment**: Strong attacker bonus vs coastal targets.
- **Air Support / Interdiction**: Affects soft/hard attack and enemy organization/supply.
- **Leaders, Doctrines, Focuses**: National and army-level multipliers.
- **Being Surrounded**: Blocks external reinforcements and supply (unless local production exists).

## Unit Display (Planned)
- NATO symbol on map.
- Offense / Defense / Movement values shown.
- Readiness (left of symbol) / Organization (right of symbol).
- Recon and espionage can show estimated enemy combat power.

## Intelligence Sources
- Locals in owned or formerly owned provinces.
- Physical adjacency + open borders / trade.
- Naval observation.
- Air reconnaissance.
- Satellites + AI (late game).

## Future Expansion
- Full combat resolver using `get_final_combat_stats()`.
- Combined arms bonuses.
- Fortification levels and engineer construction.
- Weather and day/night cycles.
- Leader traits and doctrine effects.
