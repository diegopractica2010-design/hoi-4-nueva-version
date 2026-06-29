# Project Maturity Report

Scores reflect the current executable revision, not intended scope or file volume.

| Area | Score /10 | Evidence |
|---|---:|---|
| Gameplay | 1 | no end-to-end gameplay flow validated; main startup is broken |
| Architecture | 2 | 12 product God objects, 26 mutual manager-reference pairs, 12 failed autoloads |
| Maintainability | 2 | 25 affected compile files, high central coupling, 688 print sites |
| Testing | 2 | 131 declared cases but only 2 currently pass; both runners exit 1 |
| Performance | 2 | cannot profile gameplay; cold texture/cache and large-startup risks remain |
| AI | 1 | AI economy and advanced AI autoloads fail parsing |
| UX | 2 | PackedScenes instantiate shallowly, but no UI flow is functionally validated; TradeScreen parser fails |
| Content | 5 | 2,183 valid JSON files and 20 historical events, but event contract is incompatible |
| Stability | 0 | compilation/startup/test gates all fail |

Overall score: **1.9/10** (17/90, arithmetic mean rounded to one decimal).

Classification: **Prototype**.

Evidence command set: exact inventory/JSON parse; Godot editor scan; main startup; both runner executions; scene validator. Paths/classes/methods are detailed in the corresponding audit reports. “Pre-Alpha” would require at least a repeatable executable gameplay slice; current evidence does not establish one.
