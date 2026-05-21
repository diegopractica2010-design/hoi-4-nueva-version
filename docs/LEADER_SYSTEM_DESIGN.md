# Epochs of Ascendancy — Leader System Design Document

**Version:** 1.0 (First Pass — Ambitious Foundation)  
**Date:** May 21, 2026  
**Status:** Design Phase — Ready for phased implementation

---

## 1. Vision & Philosophy

The leader system in *Epochs of Ascendancy* should feel **alive, earned, and consequential**.

- Leaders are not just stat sticks. They are **characters** who grow, specialize, develop flaws, and can become legends — or liabilities.
- The system should feel **familiar to Hearts of Iron players** in structure (skills + traits + assignment), but **deeper and more dynamic** in execution.
- Leaders should be shaped by **war, doctrine, national choices, and personal experience**.
- Some traits should feel **rare and prestigious**. Others should feel like natural consequences of how you use a leader.
- The player should have **meaningful choice** in how a leader develops, while still being constrained by realism and circumstance.

**Core Principle:**
> "Great leaders are not born fully formed. They are forged — and sometimes broken — by war, responsibility, and the choices of their nation."

---

## 2. Core Skills (Foundation)

All leaders have **5 core skills** on a **0–10 scale**.

| Skill       | Description                                      | Primary Impact                          | Notes |
|-------------|--------------------------------------------------|-----------------------------------------|-------|
| **Attack**      | Offensive effectiveness & breakthrough           | Damage, breakthrough, initiative in attack | — |
| **Defense**     | Defensive strength & holding power               | Organization recovery, entrenchment     | — |
| **Logistics**   | Supply efficiency & reduced attrition            | Lower supply consumption, better endurance | Very important for long campaigns |
| **Planning**    | Preparation, coordination, and foresight         | Planning bonus, multi-formation coordination | Critical for Field Marshals |
| **Initiative**  | Reaction speed, adaptability, and surprise       | Flanking, counter-attack, night operations | New skill — very powerful in mobile warfare |

These skills form the **base layer**. Traits then modify and specialize them.

---

## 3. Trait System

### 3.1 Trait Structure

Every trait contains:

- `id`
- `name`
- `category`
- `max_level` (usually 3, sometimes 2 or 4)
- `rarity` (Common / Notable / Rare / Legendary)
- `acquisition` (earned, doctrine, focus, event, personality)
- `exclusive_with` (array of mutually exclusive trait IDs)
- `effects_by_level` (dictionary of modifiers per level)
- `description` (flavor + mechanical explanation)

### 3.2 Trait Categories

| Category                    | Description                                      | Rarity Range     | Levelable? | Examples |
|----------------------------|--------------------------------------------------|------------------|----------|----------|
| **Combat Style**           | How the leader approaches battle                 | Common–Notable   | Yes      | Aggressive, Cautious, Bold, Methodical, Reckless |
| **Terrain Mastery**        | Specialized in specific environments             | Notable–Rare     | Yes      | Desert Fox, Arctic Bear, Jungle Panther, Night Operator |
| **Specialist**             | Deep expertise in certain unit types or methods  | Notable–Rare     | Yes      | Tank Leader, Artillery Expert, Combined Arms Master, Logistics Wizard |
| **Command Scope**          | Ability to command at higher levels              | Rare             | Yes      | Army Group Commander, Greater Combat Width |
| **Naval Specialist**       | Naval-specific expertise                         | Notable–Rare     | Yes      | Blockade Runner, Carrier Admiral, Submarine Raider |
| **Earned / Legendary**     | Extremely rare traits gained through exceptional deeds | Rare–Legendary | Limited  | Invincible, Ghost, Reformer, Butcher, The Fox, Iron Will |
| **Doctrine / National**    | Tied to national military philosophy             | Notable–Rare     | No       | Blitzkrieg Advocate, Deep Battle Theorist, Fortress Breaker |
| **Personality / Flaw**     | Character traits (positive and negative)         | Common–Notable   | Limited  | Charismatic, Visionary, Arrogant, Overconfident, Political Liability, Micromanager |

### 3.3 Trait Cap & Exclusivity

**Trait Cap (Recommended):**
- Maximum **6 traits** total per leader.
- Maximum **2 Legendary** traits at any time.
- This prevents "god generals" while still allowing high-experience leaders to become very powerful.

**Mutually Exclusive Traits (Hard Exclusions):**

| Trait A              | Trait B                  | Reason |
|----------------------|--------------------------|--------|
| Aggressive           | Cautious                 | Polar opposite philosophies |
| Bold                 | Methodical               | Risk vs deliberate planning |
| Butcher              | Morale Builder           | One maximizes casualties, the other minimizes them |
| Reckless             | Cautious                 | — |
| Arrogant             | Charismatic              | Personality conflict |
| Political Liability  | Political General        | Direct contradiction |

Some exclusions are **soft** (high XP cost to have both) rather than hard blocks.

### 3.4 Modeling Top WW2 Generals (The Target for Maxed Leaders)

To set the quality bar, we analyzed what top-tier, high-experience leaders should look like:

**Erwin Rommel (Desert Fox)**
- High **Attack** + **Initiative**
- **Desert Fox III**
- **Bold** or **Aggressive**
- **Tank Leader II**
- High Logistics (despite historical supply issues — represents personal skill)
- Charismatic personality

**George S. Patton**
- Very high **Attack** + **Initiative**
- **Tank Leader III**
- **Aggressive**
- **Bold**
- **Combined Arms Master**
- High **Planning** (surprisingly good at operational planning)
- **Ruthless** or **Political Liability** (controversial personality)

**Erich von Manstein**
- Exceptional **Planning**
- **Methodical**
- **Defense** specialist (elastic defense)
- **Superior Coordination**
- High **Logistics**
- Visionary

**Georgy Zhukov**
- High **Attack**
- **Ruthless**
- Excellent **Planning** and **Logistics**
- **Butcher** (willing to accept high casualties)
- High organizational ability
- **Political General** (strong political reliability)

These examples show that even the best leaders have **flaws** and **specializations**. No one should be maxed in everything.

---

## 4. Experience (XP) System

### 4.1 How XP is Gained

| Situation                              | XP Rate      | Multiplier | Notes |
|----------------------------------------|--------------|----------|-------|
| Assigned to a formation (idle)         | Very Slow    | 0.1×     | Passive leadership growth |
| Unit is training                       | Slow         | 0.4×     | Good for peacetime development |
| Nation is at war (not in combat)       | Medium       | 1.0×     | Baseline during wartime |
| Formation is in active combat          | High         | 2.5–3.0× | Primary source of rapid growth |
| Major victory / successful operation   | Very High    | 4.0–6.0× | Breakthroughs, encirclements, successful raids |
| High-risk / difficult missions         | Bonus        | +50–100% | Recon deep behind lines, holding against heavy odds, night operations |
| Unassigned                             | **None**     | 0×       | As requested — drives players to assign leaders |

**Design Rule:** "Higher risk, higher reward." Combat and difficult missions should give significantly more XP than passive assignment.

### 4.2 How XP is Spent

Leaders can spend XP on:

1. **Leveling existing traits** (most common use)
2. **Unlocking new traits** (especially Rare/Legendary ones — gated by circumstances)
3. **Removing negative traits** (expensive — 2–3× the cost of a positive level-up)
4. **Branching specialization** at high levels (e.g. Tank Leader III → "Breakthrough Specialist" or "Armored Defense Expert")

**Player Choice + Gating:**
- Some traits are **unlocked as options** after certain conditions (e.g. 200+ days commanding armor → Tank Leader becomes available to purchase/upgrade).
- Some traits are **automatically offered** after major events (e.g. surviving an impossible defense → Iron Will offered).
- Doctrine and National Focuses can **unlock or heavily discount** certain traits.

---

## 5. Field Marshals & Command Hierarchy

**Yes** — Field Marshals should exist as a distinct, higher tier.

**Rules:**
- **Generals** can command **one formation** (Division, Brigade, Garrison, Task Force, etc.).
- **Field Marshals** can command **multiple formations** (Army, Army Group, Front).
- Field Marshals give **passive bonuses** to all subordinate formations under their command, even when not directly present in every battle.
- Promotion to Field Marshal requires: high XP + high Planning skill + specific trait (e.g. *Army Group Commander*) + national approval (or event).

This creates a meaningful promotion fantasy and strategic layer.

---

## 6. Earned vs Doctrine/Focus Traits

**Earned Traits** (Primarily through gameplay):
- Desert Fox, Arctic Bear, Jungle Panther, Mountain Specialist, Night Operator
- Tank Leader, Artillery Expert, Combined Arms Master, Logistics Wizard
- Invincible, Ghost, Reformer, Butcher, The Fox, Iron Will
- Blockade Runner

**Doctrine / Focus Granted Traits** (National choices heavily influence):
- Blitzkrieg Advocate
- Deep Battle Theorist
- Fortress Breaker
- Carrier Admiral
- Strategic Air Proponent
- Political General
- Total War Advocate

**Hybrid Approach (Recommended):**
Doctrine does **not** give traits for free. Instead, it creates **strong synergy**:
- "Mobile Warfare" doctrine → +200% XP gain toward *Tank Leader* and *Blitzkrieg Advocate* while using mobile divisions.
- "Mass Assault" doctrine → easier to gain *Butcher* and *Greater Combat Width*.

This makes national choices feel meaningful without removing player agency.

---

## 7. Negative Traits & Personality

Negative traits should feel like **real consequences**, not random punishment.

**Examples:**
- **Reckless** — Higher casualties, faster organization loss
- **Arrogant** — Penalty to coordination with other formations
- **Overconfident** — Reduced defensive bonuses
- **Political Liability** — Small national stability penalty
- **Micromanager** — Slower planning and reinforcement speed
- **Butcher** (can be negative in some contexts) — High casualties

**Removal:**
- Expensive with XP (2–3× a normal level-up)
- Sometimes only removable via national focus ("Political Purge") or specific events (injury recovery, scandal, etc.)

Personality traits (Charismatic, Visionary, Arrogant, etc.) are usually set at generation or gained through major events. They are harder to change.

---

## 7b. Retirement & Mortality Flow (Implemented)

The live game uses a **probability chart**, not fixed historical death dates. Leaders are gated by `start_year` / optional `end_year` and held in `leader_pool` until introduced.

### Yearly checks (`check_leader_mortality`)

| Age | Death / year | Retirement / year |
|-----|--------------|-------------------|
| Under 50 | 0.3% | 0.5% |
| 50–59 | 0.8% | 2.0% |
| 60–64 | 1.8% | 5.0% |
| 65–69 | 3.5% | 12.0% |
| 70–74 | 6.5% | 22.0% |
| 75–79 | 11.0% | 30.0% |
| 80+ | 18%+ | 35% |

Modifiers: duty post (`training` / `rear_area`), traits (`iron_will`, `reckless`, etc.), high experience, injury, `stayed_past_retirement`.

### Combat (separate from yearly natural death)

- **0.03%** leader death per battle while formation survives.
- **~30%** death or capture when the formation is destroyed (~45% of those outcomes are death).

### Retirement player choice (`RetirementOfferPopup`)

When a leader fails the yearly retirement roll, the player sees:

- **Retire with Honors** — leader leaves; nation gains prestige/unity stub bonuses.
- **Your Country Still Needs You…** — ~65% chance they serve one more year; refusal retires them with honors; staying increases next year’s personal risk.

Signals and UI: `LeaderEventUI` autoload, `leader_retirement_offered`, news toasts. See `docs/LEADER_TIMELINE_AND_MORTALITY.md`.

### Replacement (planned)

Hybrid model: automatic interim commander, then player picks a permanent replacement from eligible leaders (HOI4-style, type-filtered).

### Officer Training Program (planned)

National position: assign a veteran to train officers — bonus XP for new leaders, chance to pass one trait at level I to mentees.

---

## 8. Integration with Existing Systems

Traits should modify real gameplay systems you already have:

- **CombatResolver** — Attack, Defense, Initiative modifiers
- **CombatWidthCalculator** — Greater Combat Width trait
- **ProductionManager / EquipmentShortageTracker** — Logistics Wizard reduces shortage penalties
- **Supply system** — Logistics Wizard + Supply Chain Master reduce consumption
- **DivisionTemplate** — Reformer slowly improves average generation/reliability of units under command
- **Formation hierarchy** — Field Marshals give planning bonus to child formations

---

## 9. Phased Implementation Roadmap

| Phase | Focus                                      | Player-Visible Win                              | Priority |
|-------|--------------------------------------------|--------------------------------------------------|----------|
| A     | Trait schema v2 + levels + exclusivity     | Tooltips show real numbers                       | High     |
| B     | XP gain rules + basic spending             | Leaders visibly grow after combat                | High     |
| C     | Earned trait triggers (terrain + template) | Desert Fox appears after North Africa campaign   | High     |
| D     | Doctrine/Focus gates + 8–10 linked traits  | National identity meaningfully affects leaders   | Medium   |
| E     | Field Marshal type + passive aura          | Promotion fantasy + army group command           | Medium   |
| F     | Negative traits + removal                  | Risk/reward leadership                           | Medium   |
| G     | Full integration (combat width, supply, reformer) | Traits feel systemic, not just UI             | Medium   |

---

## 10. Starter Trait List (First Pass)

**Combat Style:** Aggressive (I–III), Cautious (I–III), Bold, Methodical, Reckless (−), Ruthless

**Terrain:** Desert Fox (I–III), Arctic Bear (I–III), Jungle Panther (I–III), Mountain Specialist (I–III), Night Operator (I–II), Urban Fighter

**Specialist:** Tank Leader (I–III), Artillery Expert (I–III), Combined Arms Master (I–III), Logistics Wizard (I–III), Engineer Specialist, Supply Chain Master, Morale Builder

**Command Scope (FM):** Army Group Commander, Greater Combat Width (I–II), Superior Coordination

**Naval:** Blockade Runner (I–II), Carrier Admiral, Submarine Raider, Fleet Tactician

**Legendary Earned:** Invincible, Ghost, Reformer, Butcher, The Fox, Iron Will

**Doctrine/Focus:** Blitzkrieg Advocate, Deep Battle Theorist, Fortress Breaker, Strategic Air Proponent, Political General, Total War Advocate

**Personality/Flaw:** Charismatic, Visionary, Arrogant (−), Overconfident (−), Political Liability (−), Micromanager (−)

---

## 11. Open Questions & Future Expansion

- Should some Legendary traits have **unique visual effects** or special events tied to them?
- Do we want a small number of **Leader Abilities** (active cooldown abilities) in addition to passive traits? (Phase 3+)
- How should **Space Force** leaders and traits work in the future?
- Should there be a "Chief of Staff" type national position that gives planning bonuses without field command?

---

**Document Status:** Ready for implementation.  
This is a living document. We can (and should) revise it as we build and playtest.

---

*End of Leader System Design Document v1.0*