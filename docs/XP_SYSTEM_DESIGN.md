# XP System Design – Epochs of Ascendancy

**Status:** Draft v2 (May 22, 2026)  
**Goal:** Create a living, meaningful progression system for leaders that rewards long-term use, playstyle expression, and strategic decisions while tying into doctrines, politics, personality, and the broader “Hidden Enemy” theme of the game.

---

## 1. Vision

Leaders should feel like **real people** who grow, specialize, develop flaws, and can be shaped (or corrupted) by war, doctrine, national choices, and personal decisions.  
The XP system is the primary mechanism through which players invest in and develop their commanders over the course of a campaign that can span from 1918 into the modern era.

Key pillars:
- Meaningful long-term progression
- Playstyle expression through doctrine-locked paths
- Personality, flaws, and political alignment that feel alive
- Strategic trade-offs (frontline vs training, investment vs risk)
- Thematic connection to the game’s “good vs evil / Hidden Enemy” narrative

---

## 2. XP Gain System

### Core Philosophy
XP should feel **earned** and scale with risk and impact. A leader who sits in a rear-area training command should progress slower than one leading troops in heavy combat.

### XP Gain Rates (Locked In)

| Situation                              | XP per Week | Notes |
|----------------------------------------|-------------|-------|
| **Unassigned**                         | 0           | As requested. No free XP. |
| **Assigned to a formation (idle)**     | 1           | Very slow passive leadership experience |
| **Formation is in training**           | 4           | Good peacetime development path |
| **Nation is at war**                   | +2          | Baseline bump while country is fighting |
| **Formation is in active combat**      | 12          | Primary source of meaningful progression |
| **Major Victory / Heroic Defense**     | +50 to +150 | One-time bonus. Scaled by battle size/impact |
| **High-Risk Successful Operation**     | +30 to +80  | Raids, deep strikes, holding against overwhelming odds |

**Victory Scaling Idea (to be implemented later):**
- Small engagement: +30–50 XP
- Division-level victory: +60–90 XP
- Army-level or strategically important victory: +100–150 XP
- “300-style” last stands or impossible defenses: Bonus multiplier or special event

This keeps progression **meaningful but not trivial**. A leader who sees consistent frontline combat over 1–2 years should be able to meaningfully improve traits.

---

## 3. XP Spending

Leaders can spend XP on the following (in rough order of commonality):

1. **Leveling existing traits** (most common use)
2. **Unlocking new traits** (especially doctrine-gated or rare ones)
3. **Mitigating (but rarely removing) negative traits** — Expensive
4. **Entering specialized training paths** (see Section 4)

**Agency Principle:**
Players should have **meaningful choice** in how a leader develops. Certain traits can be earned through time in terrain or doctrine, while others are unlocked via focus or event. Personality and flaws should feel like part of the leader’s story rather than pure optimization.

---

## 4. Doctrine-Locked Training Paths

In addition to powerful rare/legendary traits, we will offer **incremental, accessible training paths** that every leader can invest in. These represent specialized military schooling.

### Core Paths (Mutually Exclusive at Higher Levels)

| Doctrine Family          | Training Path                    | Focus                              | Example Bonuses                          | Switching Cost |
|--------------------------|----------------------------------|------------------------------------|------------------------------------------|----------------|
| **Maneuver Warfare**     | School of Maneuver               | Speed, initiative, exploitation    | +Attack, +Initiative, faster movement    | High           |
| **Attrition / Defense**  | School of Layered Defense        | Resilience, organization, supply   | +Defense, better org recovery, lower supply use when defending | High |
| **Combined Arms**        | Combined Arms School             | Flexibility across unit types      | Small bonuses to multiple unit types     | High           |
| **Fortification**        | Fortification & Defense School   | Static defense, entrenchment       | Bonus when defending, better fortification | High |

**WW1 Doctrines (1918 start):**
- Trench Warfare / Attrition
- Infiltration Tactics (Hutier-style)
- Stormtrooper Doctrine (German)
- Combined Arms (early versions)

These paths should be **locked behind doctrines** and have a **high cost to switch** once a leader has invested significantly in one direction. Switching should feel like a major doctrinal or philosophical shift for that commander.

---

## 5. Political Alignment & Personality / Flaw System

This is a core part of making leaders feel **alive** and ties directly into the game’s “Hidden Enemy” narrative.

### Political Leaning
Every leader can have a **Political Alignment** (or at least key flags):
- Anti-Communist
- Globalist Skeptic
- Loyalist / Establishment
- Opportunist
- Nationalist / Traditionalist
- etc.

**Visibility Rule:**
- Political Alignment is **fully hidden** by default.
- It can be revealed through **Agent missions** (espionage, investigation, etc.).
- Misalignment with the current government can cause:
  - Increased retirement pressure
  - Reduced effectiveness
  - Vulnerability to agent operations (smear campaigns, “accidents”, forced retirement)
  - Event chains (inspired by historical examples like Patton being sidelined or McCarthy being targeted)

### Personality & Flaws (7 Deadly Sins Theme)

Negative traits should feel thematic and have real mechanical weight. Many flaws should tie into the game’s “Hidden Enemy / spiritual warfare” narrative (greed, pride, lust, etc. as tools used to corrupt and divide).

**Proposed Flaw Naming Direction:**

| Sin          | Example Trait Names                     | Mechanical Effect                          | Mitigation Cost | Removable? |
|--------------|-----------------------------------------|--------------------------------------------|-----------------|------------|
| **Pride**    | Arrogant, Glory Hound                   | Penalty to cooperation with other formations | High            | Mitigable  |
| **Greed**    | Resource Hog, Profiteer                 | Increased supply/fuel consumption          | High            | Mitigable  |
| **Sloth**    | Slow Planner, Complacent, Hard-Headed   | Slower planning speed, resistant to change | Medium-High     | Difficult  |
| **Wrath**    | Reckless, Butcher                       | Higher casualties                          | High            | Mitigable  |
| **Lust**     | Womanizer, Hedonist                     | Morale issues, potential scandal events    | High            | Mitigable  |
| **Gluttony** | Supply Glutton, Wasteful                | Higher supply use                          | Medium          | Mitigable  |
| **Envy**     | Political Rival, Resentful              | Can trigger internal conflict events       | High            | Difficult  |

**Key Rules:**
- Some negative traits are **impossible to fully remove** — they can only be mitigated (expensive).
- Negative traits can be **passed on** through the Officer Training system (risk/reward).
- Flaws should create interesting narrative and strategic moments.

---

## 6. Officer Training Command (Expanded)

This national position is a major strategic lever with real risk and reward.

### Core Effects
- New officers generated while a leader is assigned here start with **slightly higher base XP**.
- There is a chance that a new leader **inherits one trait at level I** from the assigned commander (mentorship).
- The chance increases if the assigned leader has **Mentor**, **Reformer**, or high **Planning** skill.
- The assigned leader still gains some XP (counts as training duty).

### Risk & Depth
- If the assigned leader has strong **negative traits or political misalignment**, there is a chance they pass on flaws to new officers.
- Focuses and technologies can improve the effectiveness of the Officer Training Command (better facilities, better curriculum, reduced risk of passing flaws, etc.).
- Some leaders will have special **Mentor** or training-related traits that make them exceptionally good (or dangerous) in this role.

**Strategic Decision:**
Do you assign your best, most experienced general to the front lines, or do you “park” them in training to build the next generation — accepting the risk that they might pass on both strengths *and* flaws?

---

## 7. Trait Color Coding (Rarity / Impact)

To help players quickly understand the weight of a trait:

- **White / Gray** — Common
- **Green** — Notable / Special
- **Blue** — Rare
- **Purple** — Legendary / High Impact

Negative traits should use a distinct color (Red / Dark Red) so they are immediately visible.

---

## 8. Phased Implementation Roadmap (Updated)

| Phase | Focus | Priority | Status |
|-------|-------|----------|--------|
| **Phase A** | Core XP gain + spending on trait leveling | High | Next |
| **Phase B** | Doctrine-locked training paths + expensive switching cost | High | Soon |
| **Phase C** | Political Alignment + Personality/Flaw system (hidden + agent reveal) | Medium-High | After B |
| **Phase D** | Officer Training Command (mentorship + flaw inheritance risk) | Medium-High | After B |
| **Phase E** | Color coding + UI display of trait levels & effects | Medium | Parallel |
| **Phase F** | Deeper integration with CombatResolver | Medium | After core XP |
| **Phase G** | Retirement Popup UI + notifications | Lower | Can be done in parallel with E |

---

## Open Questions

1. Should some training path choices become **semi-permanent** once heavily invested in (high switching cost), or always allow expensive switching?
2. How should we handle **Hard-Headed / Slow Learning** type traits that make doctrine switching even harder for certain leaders?
3. Should Political Alignment have mechanical effects even while hidden (subtle penalties), or only kick in once revealed?

---

**End of Document v2**