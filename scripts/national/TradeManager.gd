# scripts/national/TradeManager.gd
extends Node

## Trade System Foundation — Public Market + Black Market Architecture
##
## This is the central, lightweight backend for all trade mechanics in Epochs of Ascendancy.
## It is deliberately backend-first: no UI, no heavy AI, no full persistence in v1.
## The goal is a clean, extensible system that makes nation-specific designs (and other
## strategic assets) feel alive the moment a deal is struck.
##
## =============================================================================
## CURRENT SCOPE (v1 — this session)
## =============================================================================
## - Core data model: TradeItem (with quality_modifier for designs), TradeOffer, enums.
## - create_offer(...) between two countries.
## - evaluate_fairness(offer_id, for_country) — simple weighted, well-documented, easy to extend.
##   Returns rich dict with score, values, reason, recommendation, breakdown, visibility, is_from.
## - accept_offer(offer_id) — full execution with validation:
##     • Validates offerer has offered items and accepter can pay requested items.
##     • DESIGNS: grant_acquired_design on accepter/receiver pass only (knowledge copy, not revoked from seller).
##       → the design immediately becomes visible in DesignPickerPopup "Foreign Acquired"
##         section and passes _country_may_use_design / MapTechnologyContext build checks.
##     • RESOURCE/EQUIPMENT: ProductionManager stockpile (player country only; AI/abstract parties skip).
##     • EQUIPMENT: take_from_national_stockpile / add_to_national_stockpile on player tag only.
## - Offer management:
##     • reject_offer(offer_id) — safe rejection for PROPOSED offers only.
##     • expire_offer(offer_id) — mark as EXPIRED (for time-based or forced expiry).
##     • get_active_offers_for_country(country_tag, visibility_filter) — only PROPOSED offers.
##     • get_public_offers() — convenience for the open diplomatic market (populated by generate_public_market_offers + player/AI activity).
##     • get_offers_for_country(...) — full query with visibility filter.
## - Market generation:
##     • generate_public_market_offers(country_tag, count) — further expanded with more recurring everyday diplomatic flavor (agricultural/construction surplus pairs, joint training EQUIPMENT + TECH_SHARE packages, plus prior civilian surplus, naval docking+TECH_SHARE cooperation, resource mixes, older design licenses, docking rights, SUPPLY credits, and mixed SUPPLY+DESIGN offers). Feels like ongoing, natural nation-to-nation trade activity over game time.
##     • generate_black_market_opportunity(country_tag, risk) — further strengthened with ultra high-stakes combinations: PROVINCE + detailed INTEL (territorial concessions traded for enemy agent networks), rare triple DESIGN + EQUIPMENT + INTEL packages, plus all prior mixed EQUIPMENT+DESIGN, INTEL+DESIGN, hot designs, PROVINCE concessions, and high-risk intel/resource bundles. exposure_risk is now dynamically higher for territory trades and complex multi-item offers (0.35–0.95 range). Stronger rewards with clearer, escalating downside.
##     • AgentManager integration points significantly expanded: smuggling/underworld missions can call the generator with high risk_level (3–5) for the new PROVINCE+INTEL or triple packages; counter-intel sweeps on high exposure_risk BLACK offers can trigger scandals or spawn concrete missions ("Disrupt Black Market Deal", "Seize Smuggled Equipment", "Expose Province Concession", "Counter Black Market Design Leak", "Infiltrate Territorial Smuggling Ring", etc.).
## - TradeVisibility: PUBLIC vs BLACK (architectural only in v1; BLACK offers are still stored
##   but can be filtered or hidden from normal diplomacy views).
## - Internal per-country indexes for fast lookup.
## - Signals for future UI / AI / agent reactivity (offer_created, deal_accepted, deal_rejected, offer_expired).
##
## WHAT IS NOT IMPLEMENTED YET (explicit stubs / future work):
## - No UI (DesignPickerPopup, new Trade/Deal screen, diplomacy screen integration).
## - No automatic AI proposal / counter-offer logic (only the fairness evaluator is provided; market generators help simulate activity).
## - No full enforcement of "exportable" flag or owner_countries on create_offer (future: optional check).
## - TECH_SHARE, DOCKING_RIGHTS, INTEL, PROVINCE, and SUPPLY now have full (lightweight) execution paths (PROVINCE via MapManager.update_province_owner in receiver path; downstream factory/design capture relies on MapManager hooks).
## - Public market generation (generate_public_market_offers) expanded for recurring diplomatic churn (resources, designs, docking, mixed packages).
## - Black market generation further strengthened with ultra high-stakes PROVINCE+INTEL and triple DESIGN+EQUIPMENT+INTEL bundles, dynamic territory-aware exposure_risk scaling, and expanded AgentManager generation/detection hooks (new missions like "Infiltrate Territorial Smuggling Ring").
## - No SaveLoad get/apply (add later; active offers are valuable persistent state).
## - No relation/opinion/prestige effects from deals (future hook into NationalModifierManager + diplomacy layer).
## - Full province trade restrictions (is_core, population opinion, plebiscite) and pre-accept diplomacy veto hooks remain future extension points in validate/execute.
##
## =============================================================================
## DATA MODEL
## =============================================================================
## TradeItemType (what can be offered/requested):
##   DESIGN           — a UnitTemplate id. Supports quality_modifier (0.85 = budget export version,
##                      1.05 = premium licensed copy). On accept → DesignManager.grant_acquired_design.
##   EQUIPMENT        — finished equipment_id from national_equipment_stockpile.
##   RESOURCE         — key from national_stockpile (steel, fuel, rubber, etc.).
##   SUPPLY           — abstract "supply credits" or direct supply goods (future).
##   TECH_SHARE       — research progress / tech id. Execution: TechnologyManager.apply_tech_intel_bonus (RP share to recipient).
##   INTEL            — intel report. Execution: temporary NationalModifier via NationalModifierManager (recon/visibility).
##   PROVINCE         — province_id; accept path calls MapManager.update_province_owner + factory capture.
##   DOCKING_RIGHTS   — access to ports/airfields. Execution: temporary NationalModifier (supply/naval bonuses, duration from metadata).
##
## TradeItem:
##   {
##     type: TradeItemType,
##     id: String,                    # design_id, equipment_id, resource key, province_id, etc.
##     quantity: float,               # 12.0 tanks, 4500 steel, 1 design (quantity usually 1)
##     quality_modifier: float = 1.0, # only meaningful for DESIGN (0.9 = -10% performance variant)
##     metadata: Dictionary = {}      # e.g. {"kind": "licensed", "notes": "downgraded export model"}
##   }
##
## TradeVisibility:
##   PUBLIC  — normal diplomatic trade. Visible to both parties, standard fairness.
##   BLACK   — shadow / illicit deal. Can be more lucrative or risky. Hidden from normal
##             diplomacy UI. Future: AgentManager can generate, detect, sabotage, or profit from.
##
## TradeOffer:
##   id, from_tag, to_tag,
##   offered: Array[TradeItem], requested: Array[TradeItem],
##   visibility: TradeVisibility,
##   status: TradeStatus,
##   created_turn: int,
##   expires_turn: int = -1,   # -1 = no expiry
##   fairness_cache: Dictionary = {},  # populated by evaluate_fairness for quick UI
##   metadata: Dictionary = {}
##
## =============================================================================
## FAIRNESS / WEIGHTING SYSTEM (Simple but Extensible)
## =============================================================================
## evaluate_fairness(offer_id, for_country) returns a rich dictionary:
##   {
##     score: float,             # 1.0 = perfectly fair from for_country's perspective.
##                               # >1.0 = good deal for you. <1.0 = bad deal (you are overpaying).
##     value_offered: float,
##     value_requested: float,
##     reason: String,           # Human-readable summary
##     recommendation: String,   # Richer context-aware text for high-value items (PROVINCE/INTEL especially). Multi-sentence strategic advice (core vs peripheral value, permanent production + design capture upside, recon gap vs enemy presence, etc.). Immediately useful and ready for future Trade UI tooltips/panels.
##     breakdown: Dictionary,    # Per-item values (after quality_modifier) plus extra context keys for PROVINCE (dev/infra/port) and INTEL (quantity/type) — fully UI-ready without changing top-level shape.
##     visibility: TradeVisibility,
##     is_from: bool             # Whether for_country is the one making the offer
##   }
##
## Core algorithm (private _calculate_item_value(item: TradeItem, for_country: String) -> float):
##   1. Base value by type:
##        DESIGN     → DesignManager or GameData lookup of production_cost * production_complexity
##                     * strategic_role_multiplier (e.g. if country has no modern MBT designs yet).
##        RESOURCE   → current "market rate" (hardcoded baseline + ProductionManager shortage pressure).
##        EQUIPMENT  → production cost of the equipment template.
##   2. Apply quality_modifier directly (0.9 design is worth 90% of base).
##   3. Strategic / context multipliers (easy to extend):
##        - Desperation: if for_country has very low stock of that resource → higher value.
##        - Tech gap: giving a design far ahead of recipient's current tech → premium.
##        - Role scarcity: design fills a critical missing lifecycle_role → +30%.
##        - PROVINCE: very high strategic value (development + infrastructure + features like ports;
##          contested territory gets extra multiplier). These are core assets, not simple goods.
##        - INTEL: scales with quantity + recipient's current reconnaissance gap or enemy threat level.
##        - Future: diplomacy opinion, "most_favored_nation" modifier from NationalModifierManager,
##          black market risk premium (black deals cost 15-30% more in fairness math).
##   4. Sum offered vs requested from the evaluator's point of view.
##   5. Enhanced recommendations and breakdown for high-value items (provinces/intel produce
##      stronger language in the "recommendation" field for future UI).
##
## How to extend fairness (documented for future sessions):
##   - Add new TradeItemType → add branch in _calculate_item_value + _execute_transfer.
##   - New global modifier → read from NationalModifierManager.get_national_modifier(country, "trade_efficiency").
##   - Black market premium → if visibility == BLACK: value *= 1.2 (or separate risk table).
##   - Province trades → weight by development_level, infrastructure, strategic location (future Map data).
##   - The evaluator is deliberately side-effect free so AI can call it safely for "what if" analysis.
##   - High-value items like PROVINCE and INTEL now produce richer, multi-sentence context-aware "recommendation" text (core vs border value, permanent factory/design capture via MapManager, recon gap vs enemy presence from SupplyIntelBridge patterns) — directly consumable by future Trade UI.

## =============================================================================
## NEW ITEM TYPE EXECUTION (TECH_SHARE, DOCKING_RIGHTS, INTEL)
## =============================================================================
## Lightweight but functional execution added in _execute_transfer (called from accept_offer
## after validation). These provide immediate strategic value:
##
## TECH_SHARE:
##   - Recipient receives research progress via TechnologyManager.apply_tech_intel_bonus
##     (scaled by quantity). Useful for catching up on key tech trees without full theft.
##   - Can specify tech category in item.id for flavor.
##
## DOCKING_RIGHTS:
##   - Applies a temporary national effect (via NationalModifierManager) granting supply
##     or naval/air access bonuses (e.g. {"supply_throughput": +0.2, "port_access": 1.0}).
##   - Duration and exact modifiers come from item.metadata (defaults provided).
##   - Strategic for island or landlocked nations needing port access.
##
## INTEL:
##   - Applies temporary recon / visibility modifiers (e.g. {"recon_bonus": +value}).
##   - Can represent shared intelligence reports or satellite data.
##   - Duration from metadata.
##
## All new types bypass stockpile validation (they are information / rights, not consumables).
## See _execute_transfer for exact implementation and easy extension points.

## =============================================================================
## BASIC + ENHANCED BLACK MARKET SUPPORT
## =============================================================================
## generate_black_market_opportunity(country_tag, risk_level = 0.35) -> offer_id
##   - Creates a risky but high-reward BLACK visibility offer with even higher stakes and variety.
##   - Dynamic RNG now includes ultra high-stakes combinations: PROVINCE + detailed enemy agent network INTEL (territorial concessions for intelligence), rare triple DESIGN + EQUIPMENT + INTEL "full package" leaks, plus all prior mixed EQUIPMENT+DESIGN, INTEL+DESIGN, hot designs, PROVINCE concessions, covert DOCKING, and high-risk INTEL/SUPPLY bundles.
##   - Buyer terms are often favorable, but every offer carries clear `metadata["exposure_risk"]` (0.35–0.95, with extra bumps for territory trades and complex multi-item bundles). Offers are short-lived for urgency.
##   - "from" side marked "BLACK_MARKET".
##   - Higher reward comes with real downside potential in future systems (scandals, counter-intel, prestige hits, war justifications).
##
## How AgentManager (and future systems) can use this:
##   - Successful "Smuggling Ring", "Underworld Contact", or "Corrupt Official" missions can
##     directly call this generator with elevated risk_level (e.g. 3–5) to inject the highest-stakes deals — including the new PROVINCE+INTEL territorial-intel bundles or triple DESIGN+EQUIPMENT+INTEL packages — into a country's active offer list.
##   - Counter-intel or agent networks can periodically scan active BLACK offers (via
##     get_active_offers_for_country with visibility=BLACK filter and high exposure_risk) and act on them
##     (e.g., trigger scandals via LeaderEventUI, prestige hits, "steal the deal" opportunities, war justification events, or spawn special missions such as "Disrupt Black Market Deal", "Infiltrate Smuggling Ring", "Seize Smuggled Equipment", "Expose Province Concession", "Counter Black Market Design Leak", or "Infiltrate Territorial Smuggling Ring").
##   - Black deals can bypass some exportable/owner_countries restrictions at the cost of risk.
##   - Future: exposure events (on TimeManager ticks or agent sweeps) can apply NationalModifier debuffs ("trade_scandal"), enable dedicated agent missions, or create follow-on opportunities.
##
## This keeps black market as a high-risk/high-reward parallel to public diplomacy.

## =============================================================================
## PUBLIC MARKET GENERATION
## =============================================================================
## generate_public_market_offers(country_tag, count = 2) -> Array[String] (offer_ids)
##   - Creates varied and recurring natural PUBLIC offers that feel like ongoing, living diplomatic/trade activity between nations over game time.
##   - Expanded with additional everyday diplomatic flavor: civilian/industrial surplus resource pairs and mixed docking + limited TECH_SHARE naval cooperation deals (on top of steel/rubber/oil mixes, older design export licenses, temporary docking rights packages, diplomatic TECH_SHARE, SUPPLY credit bundles, mixed SUPPLY+DESIGN industrial partnerships, and oil/rubber pairs).
##   - All generated offers use PUBLIC visibility and immediately become queryable via
##     get_public_offers() and get_active_offers_for_country.
##   - Some offers are given short expiry timers to create urgency and market churn over time.
##   - "from" side is often "WORLD_MARKET" or generic partner tags for flavor (future: real
##     country-to-country surplus logic based on actual stockpiles via ProductionManager and DesignManager for obsolete designs).
##
## Strategic feel:
##   - A steel-rich nation might repeatedly offer steel in exchange for rubber or oil it lacks.
##   - A major power might periodically license older tank or fighter variants to smaller allies.
##   - Temporary docking rights offers create naval strategy opportunities for landlocked or island nations.
##   - These offers appear alongside player-initiated diplomacy, making the world feel alive with recurring trade.
##
## Future hooks (already designed for):
##   - Diplomacy / National Focus systems or TimeManager ticks can periodically call this generator for ongoing market activity.
##   - Full public market UI can surface these offers with filtering, counters, and acceptance.
##   - AI countries can use generate + evaluate_fairness to decide whether to create or accept.
##   - "Market intel" from agents or SupplyIntelBridge could unlock better or hidden public offers.

## =============================================================================
## PUBLIC vs BLACK MARKET ARCHITECTURE & EXTENSION POINTS
## =============================================================================
## Every offer carries visibility. This is the primary split.
##
## PUBLIC MARKET
##   - Created via normal diplomacy / player Trade screen or periodic calls to generate_public_market_offers (for recurring natural churn and variety over time).
##   - Visible in get_offers_for_country(tag) and get_public_offers() (populated by generate_public_market_offers and player/AI offers).
##   - Standard fairness. Can be part of larger diplomatic packages (alliances + trade).
##
## BLACK MARKET
##   - Created via special paths (Agent "Smuggler" networks, corrupt officials, underworld contacts).
##   - Not returned by normal public queries unless you have specific intel.
##   - Higher risk / reward: offers may include "hot" (recently captured) designs, restricted tech,
##     or embargoed resources.
##   - Future hooks (explicitly designed for):
##       • AgentManager can call create_offer(..., visibility=BLACK, metadata={"exposure_risk": 0.35})
##       • Agent missions "Disrupt Black Market Deal", "Infiltrate Smuggling Ring", "Sell Captured Prototypes"
##         can generate, accept, sabotage, or expose black offers.
##       • On exposure: apply NationalModifier (prestige hit, "trade_scandal"), possible war justification,
##         or counter-intel bonus.
##       • Black deals can bypass some "exportable" or owner_countries restrictions (at risk).
##       • Special pricing: black market often has worse fairness for the buyer (premium for secrecy)
##         or desperate sellers (discount with strings attached).
##
## Recommended future integration points (already stubbed in comments):
##   - TradeManager.connect_to_agent_signals() or AgentManager has "black_market_event" signal.
##   - NationalModifier keys: "black_market_access", "trade_secrecy", "embargo_resistance".
##   - SupplyIntelBridge or AgentNetwork can provide "market_intel" that unlocks black offers for the player.
##
## =============================================================================
## NATION-SPECIFIC DESIGN TRADING (Core Integration with Existing Systems)
## =============================================================================
## This is the highest-leverage feature enabled by the prior capture work.
##
## When a DESIGN TradeItem is accepted:
##   1. TradeManager calls:
##        DesignManager.grant_acquired_design(
##            to_tag,
##            design_id,
##            ACQUISITION_PURCHASED   # or LICENSED if item.metadata["kind"] == "license"
##        )
##   2. Because grant_acquired_design writes to the authoritative _acquired_designs and the
##      legacy shim, the recipient immediately:
##        - Sees the design in DesignPickerPopup under the correct "Foreign Acquired" (or "Previously Used")
##          bucket with the proper icon (💰 Purchased / 📜 Licensed) + source nation badge.
##        - Passes DesignManager.country_may_use_design() and is_design_foreign_for().
##        - Can build the design in provinces they control (via MapTechnologyContext + Factory rules).
##        - Benefits from any future production or combat bonuses tied to acquired foreign designs.
##
## Variable Quality / Downgraded Exports (strategic depth):
##   - TradeItem for DESIGN may carry quality_modifier (0.75 – 1.10 typical range).
##   - Lower quality = cheaper in fairness calculation (good for seller who wants to offload older
##     variants or earn hard currency from a neutral buyer).
##   - Higher quality (premium licensed copy) = more expensive, but still grants the base design_id.
##   - In v1 the modifier only affects fairness math and is recorded in the offer metadata.
##   - Future (easy extension):
##       • Store per-country per-design variant data in DesignManager (or here).
##       • DesignManager.get_effective_design_stats(country, design_id) applies the modifier
##         to base_stats, reliability, production_complexity, etc.
##       • Production lines using a downgraded variant produce slightly inferior units (or cost less).
##
## Example offer snippet (what future UI or AI will do):
##   var item = {
##       "type": TradeItemType.DESIGN,
##       "id": "pzkpfw_iv_ausf_h",
##       "quantity": 1,
##       "quality_modifier": 0.92,           # slightly downgraded export model
##       "metadata": {"notes": "Licensed production rights with minor simplifications"}
##   }
##   TradeManager.create_offer("GER", "HUN", [item], [resource_steel_5000], TradeVisibility.PUBLIC)
##
## On accept by HUN → HUN now owns the design via grant, appears in their picker as "Purchased from GER".
##
## =============================================================================
## FUTURE EXTENSION POINTS (Explicitly Designed For)
## =============================================================================
## - Intelligence sharing: new item type INTEL_REPORT. On accept → SupplyIntelBridge or AgentManager
##   receives the intel (map reveal, unit sighting, tech leak).
## - Technology trades: TECH_SHARE item → TechnologyManager.apply_tech_share or stolen_research.
## - Province trades / concessions: PROVINCE item → MapManager.update_province_owner + possible
##   population / development side effects.
## - Naval / air basing rights (DOCKING_RIGHTS): temporary or permanent access modifiers in Supply
##   or CombatPresence.
## - Black market events: random or agent-triggered offers that appear only if certain agent networks
##   or national modifiers are active.
## - Full diplomacy integration: TradeOffer can be attached to a larger DiplomaticPackage (alliance +
##   trade + guarantee). Future DiplomacyManager will hold references to active TradeOffers.
## - Save / Load: implement get_save_data() / apply_save_data() that serializes active offers
##   (offers are valuable state — a deal in flight matters).
## - UI reactivity: every public method emits signals. A future TradeDealPopup or DiplomacyScreen
##   can listen without polling.
## - Fairness plugins: register custom value calculators (e.g. "ideological_value" for selling to
##   fellow fascists/communists at a discount).
##
## =============================================================================
## INTEGRATION WITH EXISTING SYSTEMS (What Calls What)
## =============================================================================
## - Design acquisition on trade  → DesignManager.grant_acquired_design (already the single source
##   of truth used by conquest capture path in FactoryManager). Trade passes kind based on metadata
##   (PURCHASED vs LICENSED) and records quality_modifier on the offer for future variant handling.
## - Resource/equipment movement  → ProductionManager (can_afford + pay_cost for resources;
##   take_from_national_stockpile + add_to_national_stockpile for equipment). Validation in
##   accept_offer uses the same helpers so transfers are safe and atomic where possible.
## - Province ownership         → MapManager.update_province_owner (accept path for PROVINCE items).
## - Visibility / risk            → AgentManager (black market ops).
## - Deal effects on nation       → NationalModifierManager.apply_national_effect (e.g. "recent_big_trade"
##   temporary bonus, "trade_scandal" debuff).
## - Build eligibility after trade → MapTechnologyContext + DesignManager.country_may_use_design
##   (zero changes needed — it just works once grant is called).
##
## TradeManager is intentionally an autoload sibling to NationalModifierManager / NationalSpiritManager
## so it can be reached from anywhere (Map, Agents, Production, UI, console) with a single name.
##
## =============================================================================
## SIGNALS
## =============================================================================
signal offer_created(offer_id: String, from: String, to: String, visibility: TradeVisibility)
signal deal_accepted(offer_id: String, from: String, to: String)
signal deal_rejected(offer_id: String, from: String, to: String, reason: String)
signal offer_expired(offer_id: String)

## (More signals can be added later without breaking anything.)

## =============================================================================
## INTERNAL STATE (kept minimal and queryable)
## =============================================================================
var _offers: Dictionary = {}                    # offer_id -> TradeOffer (full data)
var _offers_by_from: Dictionary = {}            # country_tag -> Array[offer_id]
var _offers_by_to: Dictionary = {}              # country_tag -> Array[offer_id]

var _current_year: int = 1936

# Retorna un ID de diseño disponible para comerciar, o "" si no hay ninguno.
func _get_placeholder_design_id() -> String:
	if typeof(DesignManager) == TYPE_NIL:
		return ""
	var catalog := DesignManager._catalog_design_ids("__trade__")
	if catalog.is_empty():
		catalog = DesignManager._catalog_design_ids("")
	if catalog.is_empty():
		return ""
	return catalog[randi() % catalog.size()]

# Retorna ID de provincia en disputa, o -1 si no hay ninguna.
func _get_contested_province_id() -> int:
	if typeof(MapManager) == TYPE_NIL:
		return -1
	var contested := MapManager.get_contested_provinces()
	if contested.is_empty():
		return -1
	var keys := contested.keys()
	return int(keys[randi() % keys.size()])

const DESIGN_BASE_VALUE_MULTIPLIER := 1.0
const RESOURCE_BASE_RATES := {
	"nitrates": 3.5,
	"guano": 2.0,
	"silver": 8.0,
	"copper": 2.5,
	"coal": 1.2,
	"gold": 15.0,
	"tin": 4.0,
}

func _ready() -> void:
	if typeof(TimeManager) != TYPE_NIL:
		if not TimeManager.game_year_advanced.is_connected(_on_game_year_advanced):
			TimeManager.game_year_advanced.connect(_on_game_year_advanced)

	# Future: connect to AgentManager signals for black market generation, etc.

func _on_game_year_advanced(year: int) -> void:
	_current_year = year
	_expire_offers_past_deadline()

## =============================================================================
## PUBLIC API — OFFER LIFECYCLE
## =============================================================================

## Creates a new trade offer. Returns the offer_id (UUID-style string for simplicity).
## Callers (future UI, AI, events, agents) are responsible for validating that the offering
## country actually possesses the items (we do not enforce it in v1).
func create_offer(
	from_tag: String,
	to_tag: String,
	offered_items: Array,
	requested_items: Array,
	visibility: TradeVisibility = TradeVisibility.PUBLIC,
	expires_in_years: int = -1
) -> String:
	var from := _norm_tag(from_tag)
	var to := _norm_tag(to_tag)
	if from.is_empty() or to.is_empty() or from == to:
		push_error("TradeManager: invalid from/to for offer")
		return ""

	if not _is_abstract_trade_party(from) and not _country_can_supply_items(from, offered_items):
		push_warning("TradeManager: offerer %s cannot supply offered items" % from)
		return ""

	var offer_id := _generate_id()
	var offer := {
		"id": offer_id,
		"from_tag": from,
		"to_tag": to,
		"offered": offered_items.duplicate(true),
		"requested": requested_items.duplicate(true),
		"visibility": visibility,
		"status": TradeStatus.PROPOSED,
		"created_turn": _current_year,
		"expires_turn": (_current_year + expires_in_years) if expires_in_years > 0 else -1,
		"fairness_cache": {},
		"metadata": {}
	}

	_offers[offer_id] = offer
	_index_offer(offer_id, from, to)

	offer_created.emit(offer_id, from, to, visibility)
	return offer_id

## Returns a rich fairness evaluation from the perspective of for_country.
## Safe to call repeatedly for "what if" analysis.
func evaluate_fairness(offer_id: String, for_country: String) -> Dictionary:
	var offer = _offers.get(offer_id, {})
	if offer.is_empty():
		return {"score": 0.0, "reason": "Offer not found", "value_offered": 0.0, "value_requested": 0.0}

	var tag := _norm_tag(for_country)
	var is_from: bool = (tag == offer.from_tag)

	var offered_value := 0.0
	var requested_value := 0.0
	var breakdown := {}

	for item in offer.offered:
		var v := _calculate_item_value(item, tag)
		offered_value += v
		breakdown["offered_" + str(item.get("id", ""))] = v

	for item in offer.requested:
		var v := _calculate_item_value(item, tag)
		requested_value += v
		breakdown["requested_" + str(item.get("id", ""))] = v

	# From the evaluator's view: value I give vs value I receive
	var my_outgoing := offered_value if is_from else requested_value
	var my_incoming := requested_value if is_from else offered_value

	var score := 1.0
	if my_outgoing < 0.0001:
		# Offerer gives nothing — treat as invalid offer, not zero-score
		return _build_fairness_result(score, -1.0, my_outgoing, my_incoming,
			"invalid", "Offer has no outgoing value", {}, offer.visibility, is_from)
	score = my_incoming / my_outgoing

	var reason := "Fair deal"
	var recommendation := "Fair"
	if score > 1.15:
		reason = "Excellent deal for %s" % tag
		recommendation = "Strongly recommend"
	elif score < 0.85:
		reason = "Poor deal for %s — you are overpaying" % tag
		recommendation = "Reject or counter"

	# Polish recommendations for high-value items (PROVINCE, INTEL) with richer, context-aware text
	# immediately useful for future Trade UI tooltips and decision panels.
	var saw_province := false
	var saw_intel := false
	for item in offer.offered + offer.requested:
		var itype = item.get("type")
		if itype == TradeItemType.PROVINCE:
			saw_province = true
			recommendation = "High-stakes strategic decision — acquiring this province grants permanent production base, infrastructure, and potential factory seizures with auto design capture via MapManager hooks. Strongly consider if it borders hostile territory, contains ports/resources, or sits on a supply hub (long-term defense + industrial value often exceeds raw score). Reject only if it would over-extend your lines or trigger major diplomatic backlash."
			break
		elif itype == TradeItemType.INTEL:
			saw_intel = true
			if score > 1.1:
				recommendation = "Valuable intelligence opportunity — this package can close your current reconnaissance gap and reveal enemy supply/air/naval dispositions. Prioritize when facing active threats or planning offensives; the recon_bonus and intel_visibility modifiers (applied via NationalModifierManager) provide immediate operational value against known enemy presence."
			else:
				recommendation = "Intel package may be overpriced unless you have an immediate need for visibility. Current recon levels or low enemy air/naval pressure reduce urgency — consider counter-offering or waiting for a better bundle unless agent networks or SupplyIntelBridge data indicate imminent enemy movements."
			break

	# Enrich breakdown for high-value items with extra context keys (still inside the same dict, fully UI-ready)
	if saw_province:
		for item in offer.offered + offer.requested:
			if item.get("type") == TradeItemType.PROVINCE:
				var pid := str(item.get("id", ""))
				if typeof(MapManager) != TYPE_NIL:
					var prov := MapManager.get_province(int(pid))
					if prov != null:
						breakdown["province_dev"] = prov.development_level
						breakdown["province_infra"] = prov.infrastructure
						breakdown["province_has_port"] = "port" in str(prov.features).to_lower() or "naval" in str(prov.features).to_lower()
				break
	if saw_intel:
		for item in offer.offered + offer.requested:
			if item.get("type") == TradeItemType.INTEL:
				breakdown["intel_quantity"] = item.get("quantity", 1)
				breakdown["intel_type"] = item.get("metadata", {}).get("type", "general")
				break

	return _build_fairness_result(score, score, my_outgoing, my_incoming,
		reason, recommendation, breakdown, offer.get("visibility"), is_from)

func _build_fairness_result(
	_score: float,
	_value_ratio: float,
	_my_outgoing: float,
	_my_incoming: float,
	_reason: String,
	_recommendation: String,
	_breakdown: Dictionary = {},
	_visibility = null,
	_is_from: bool = false
) -> Dictionary:
	return {
		"score": _score,
		"value_offered": _my_outgoing,
		"value_requested": _my_incoming,
		"reason": _reason,
		"recommendation": _recommendation,
		"breakdown": _breakdown,
		"visibility": _visibility,
		"is_from": _is_from
	}

## Accepts the offer after validating that the offering country actually possesses
## the items being offered. Executes transfers for DESIGNS (via grant), RESOURCE,
## and EQUIPMENT using ProductionManager's safe helpers.
## Returns true on full success.
func accept_offer(offer_id: String) -> bool:
	var offer = _offers.get(offer_id, {})
	if offer.is_empty() or offer.status != TradeStatus.PROPOSED:
		return false

	var from: String = offer.from_tag
	var to: String = offer.to_tag

	# === Validation: offerer must have offered items; accepter must be able to pay requested ===
	if not _country_can_supply_items(from, offer.offered):
		return false
	if not _country_can_supply_items(to, offer.requested):
		return false

	# Accepter (to) receives offered; pays requested. Offerer (from) gives offered; receives requested.
	for item in offer.offered:
		_execute_transfer(to, item)
		_execute_transfer(from, item, true)

	for item in offer.requested:
		_execute_transfer(from, item)
		_execute_transfer(to, item, true)

	offer.status = TradeStatus.ACCEPTED
	_clean_indexes(offer_id)

	deal_accepted.emit(offer_id, from, to)
	return true

func _is_abstract_trade_party(country_tag: String) -> bool:
	var tag := _norm_tag(country_tag)
	return tag in ["BLACK_MARKET", "UNDERWORLD", "SMUGGLERS"]


## Returns true if country_tag can provide every item in the list (trade payment / offer side).
func _country_can_supply_items(country_tag: String, items: Array) -> bool:
	var tag := _norm_tag(country_tag)
	if _is_abstract_trade_party(tag):
		return true
	for item in items:
		var type = item.get("type", TradeItemType.RESOURCE)
		var id := str(item.get("id", ""))
		var qty := float(item.get("quantity", 0.0))
		if qty <= 0:
			continue

		match type:
			TradeItemType.RESOURCE:
				if _uses_player_stockpile(tag) and typeof(ProductionManager) != TYPE_NIL:
					var cost := {}
					cost[id] = qty
					if not ProductionManager.can_afford(cost):
						return false

			TradeItemType.EQUIPMENT:
				if _uses_player_stockpile(tag) and typeof(ProductionManager) != TYPE_NIL:
					var available := int(ProductionManager.national_equipment_stockpile.get(id, 0))
					if available < int(qty):
						return false

			TradeItemType.DESIGN:
				if typeof(DesignManager) != TYPE_NIL:
					var ownership := DesignManager.get_design_ownership(tag, id)
					if ownership != DesignManager.DesignOwnership.DOMESTIC \
							and not DesignManager.has_acquired_design(tag, id):
						return false

			TradeItemType.PROVINCE:
				if typeof(MapManager) == TYPE_NIL:
					return false
				var prov := MapManager.get_province(int(id))
				if prov == null:
					return false
				var owner := prov.owner_tag.strip_edges().to_upper()
				var ctrl := prov.controller_tag.strip_edges().to_upper()
				if owner != tag and ctrl != tag:
					return false

			TradeItemType.TECH_SHARE, TradeItemType.DOCKING_RIGHTS, TradeItemType.INTEL, TradeItemType.SUPPLY:
				pass

			_:
				pass

	return true


func _expire_offers_past_deadline() -> void:
	var to_expire: Array[String] = []
	for offer_id in _offers.keys():
		var offer: Dictionary = _offers[offer_id]
		if offer.get("status") != TradeStatus.PROPOSED:
			continue
		var deadline: int = int(offer.get("expires_turn", -1))
		if deadline > 0 and _current_year >= deadline:
			to_expire.append(offer_id)
	for offer_id in to_expire:
		expire_offer(offer_id)


func _get_player_country_tag() -> String:
	if typeof(LeaderManager) != TYPE_NIL and LeaderManager.has_method("get_player_country_tag"):
		return _norm_tag(LeaderManager.get_player_country_tag())
	if typeof(MapManager) != TYPE_NIL and MapManager.has_method("get_player_country_tag_fallback"):
		return _norm_tag(MapManager.get_player_country_tag_fallback())
	return "USA"


func _uses_player_stockpile(country_tag: String) -> bool:
	return _norm_tag(country_tag) == _get_player_country_tag()


## Rejects a proposed offer. Returns true if the rejection was successful.
func reject_offer(offer_id: String, reason: String = "") -> bool:
	var offer = _offers.get(offer_id, {})
	if offer.is_empty() or offer.status != TradeStatus.PROPOSED:
		return false
	offer.status = TradeStatus.REJECTED
	_clean_indexes(offer_id)
	deal_rejected.emit(offer_id, offer.from_tag, offer.to_tag, reason)
	return true

## Expires a proposed offer (either because its expires_turn has passed or via forced expiry).
## Returns true if the offer was successfully expired.
func expire_offer(offer_id: String) -> bool:
	var offer = _offers.get(offer_id, {})
	if offer.is_empty() or offer.status != TradeStatus.PROPOSED:
		return false
	offer.status = TradeStatus.EXPIRED
	_clean_indexes(offer_id)
	offer_expired.emit(offer_id)
	return true

## Returns only currently active (PROPOSED) offers involving this country.
func get_active_offers_for_country(country_tag: String, visibility_filter = null) -> Array:
	var tag := _norm_tag(country_tag)
	var result := []
	var all_for_country = get_offers_for_country(tag, visibility_filter)
	for o in all_for_country:
		if o.get("status") == TradeStatus.PROPOSED:
			result.append(o)
	return result

## Convenience for the public (diplomatic) market.
func get_public_offers() -> Array:
	var result := []
	for offer in _offers.values():
		if offer.get("visibility") == TradeVisibility.PUBLIC \
				and offer.get("status") == TradeStatus.PROPOSED:
			result.append(offer)
	return result

func get_offers_for_country(country_tag: String, visibility_filter = null) -> Array:
	var tag := _norm_tag(country_tag)
	var result := []
	if tag.is_empty():
		for offer in _offers.values():
			if offer.get("status") != TradeStatus.PROPOSED:
				continue
			if visibility_filter == null or offer.visibility == visibility_filter:
				result.append(offer)
		return result

	if _offers_by_from.has(tag):
		for id in _offers_by_from[tag]:
			var o = _offers[id]
			if visibility_filter == null or o.visibility == visibility_filter:
				result.append(o)
	if _offers_by_to.has(tag):
		for id in _offers_by_to[tag]:
			var o = _offers[id]
			if visibility_filter == null or o.visibility == visibility_filter:
				if o not in result: result.append(o)
	return result

## Basic black market hook.
## Generates a risky but potentially rewarding offer for the target country.
## The "from" side is treated as a shadow/black market source.
## Returns the offer_id or "" on failure.
## Future: AgentManager can call this (or similar) from successful smuggling / underworld missions,
## and can later scan active BLACK offers for "exposure_risk" to trigger events or counter-intel.
func generate_black_market_opportunity(country_tag: String, risk_level: float = 0.35) -> String:
	var tag := _norm_tag(country_tag)
	if tag.is_empty():
		return ""

	# Example attractive but risky offer: a high-value foreign DESIGN at a "discount"
	# (low requested resources) but with exposure risk.
	var offered := []
	var requested := []

	# Dynamic risky/rewarding offers — higher reward (good terms for buyer) but with exposure risk
	var rng := randf()
	if rng < 0.3:
		var design_id := _get_placeholder_design_id()
		if design_id.is_empty():
			return ""
		offered.append({
			"type": TradeItemType.DESIGN,
			"id": design_id,
			"quantity": 1,
			"quality_modifier": 1.05,  # premium but "hot"
			"metadata": {"kind": "purchased", "notes": "captured prototype - high risk of exposure"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "steel", "quantity": 400.0})  # discounted price
	elif rng < 0.55:
		# Scarce/embargoed resources at a premium but with intel risk
		offered.append({"type": TradeItemType.RESOURCE, "id": "rubber", "quantity": 1200.0})
		requested.append({"type": TradeItemType.RESOURCE, "id": "oil", "quantity": 600.0})
	elif rng < 0.75:
		# Intel package or tech fragment (very high reward, very high risk)
		offered.append({
			"type": TradeItemType.INTEL,
			"id": "enemy_supply_routes",
			"quantity": 1,
			"metadata": {"type": "supply_intel", "notes": "detailed enemy depot locations"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "steel", "quantity": 300.0})
	else:
		# High-risk province concession (extremely valuable but massive exposure)
		var prov_id := _get_contested_province_id()
		if prov_id < 0:
			return ""
		offered.append({
			"type": TradeItemType.PROVINCE,
			"id": prov_id,
			"quantity": 1,
			"metadata": {"notes": "covert territorial concession - extreme exposure risk if discovered"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "fuel", "quantity": 500.0})

	# Occasionally add a very high-reward but ultra-risky tech/intel bundle
	if randf() < 0.15:
		offered.append({
			"type": TradeItemType.TECH_SHARE,
			"id": "advanced_doctrine_fragment",
			"quantity": 1,
			"metadata": {"notes": "stolen or leaked high-value tech - extreme black market risk"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "aluminum", "quantity": 200.0})

	# Ultra high-risk EQUIPMENT bundle (restricted or captured gear)
	if randf() < 0.1:
		offered.append({
			"type": TradeItemType.EQUIPMENT,
			"id": "advanced_tank_engine",
			"quantity": 50,
			"metadata": {"notes": "smuggled restricted equipment - very high exposure risk"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "fuel", "quantity": 400.0})

	# Ultra high-risk DOCKING_RIGHTS (covert naval base access - massive risk)
	if randf() < 0.08:
		offered.append({
			"type": TradeItemType.DOCKING_RIGHTS,
			"id": "secret_naval_facility",
			"quantity": 1,
			"metadata": {"duration_months": 24, "modifiers": {"supply_throughput": 0.25, "naval_access": 2.0}, "notes": "covert naval basing rights - extreme exposure risk if discovered"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "oil", "quantity": 600.0})

	# Ultra high-risk INTEL bundle (enemy agent network details - massive risk)
	if randf() < 0.06:
		offered.append({
			"type": TradeItemType.INTEL,
			"id": "enemy_agent_networks",
			"quantity": 1,
			"metadata": {"type": "agent_intel", "notes": "detailed enemy agent network locations and operations - extreme exposure risk"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "rubber", "quantity": 400.0})

	# Ultra high-risk SUPPLY bundle (covert supply disruption intel - massive risk)
	if randf() < 0.05:
		offered.append({
			"type": TradeItemType.INTEL,
			"id": "enemy_supply_vulnerabilities",
			"quantity": 1,
			"metadata": {"type": "supply_intel", "notes": "detailed enemy supply line vulnerabilities - extreme exposure risk"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "aluminum", "quantity": 350.0})

	# High-stakes mixed EQUIPMENT + DESIGN bundle (captured gear + its technical data - very high risk/reward)
	if randf() < 0.07:
		offered.append({
			"type": TradeItemType.EQUIPMENT,
			"id": "captured_heavy_tank",
			"quantity": 6,
			"metadata": {"notes": "smuggled captured heavy armor - extreme exposure risk if discovered"}
		})
		offered.append({
			"type": TradeItemType.DESIGN,
			"id": "heavy_tank_design",
			"quantity": 1,
			"quality_modifier": 0.95,
			"metadata": {"kind": "purchased", "notes": "full technical package for captured design - massive leak/intel risk"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "fuel", "quantity": 850.0})

	# High-stakes INTEL + DESIGN bundle (leaked prototype data + agent network details)
	if randf() < 0.05:
		offered.append({
			"type": TradeItemType.INTEL,
			"id": "prototype_tech_leak",
			"quantity": 1,
			"metadata": {"type": "tech_intel", "notes": "detailed enemy prototype specifications and test data - extreme exposure risk"}
		})
		offered.append({
			"type": TradeItemType.DESIGN,
			"id": "prototype_tank_variant",
			"quantity": 1,
			"quality_modifier": 1.0,
			"metadata": {"kind": "purchased", "notes": "stolen design data from prototype program"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "aluminum", "quantity": 650.0})

	# Ultra high-stakes PROVINCE + INTEL bundle (territorial concession + detailed enemy agent network intel)
	if randf() < 0.04:
		var prov_id := _get_contested_province_id()
		if prov_id < 0:
			return ""
		offered.append({
			"type": TradeItemType.PROVINCE,
			"id": prov_id,
			"quantity": 1,
			"metadata": {"notes": "covert territorial concession in exchange for intelligence - catastrophic exposure risk if discovered"}
		})
		offered.append({
			"type": TradeItemType.INTEL,
			"id": "enemy_agent_networks_detailed",
			"quantity": 1,
			"metadata": {"type": "agent_intel", "notes": "comprehensive enemy agent network locations, handlers, and safe houses - extreme risk"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "fuel", "quantity": 1200.0})

	# Triple high-risk package (DESIGN + EQUIPMENT + INTEL) - very rare, extremely lucrative but dangerous
	if randf() < 0.03:
		offered.append({
			"type": TradeItemType.DESIGN,
			"id": "advanced_fighter_variant",
			"quantity": 1,
			"quality_modifier": 1.05,
			"metadata": {"kind": "purchased", "notes": "stolen next-generation fighter design data"}
		})
		offered.append({
			"type": TradeItemType.EQUIPMENT,
			"id": "prototype_jet_engine",
			"quantity": 12,
			"metadata": {"notes": "smuggled prototype engines matching the stolen design"}
		})
		offered.append({
			"type": TradeItemType.INTEL,
			"id": "enemy_rnd_facility_details",
			"quantity": 1,
			"metadata": {"type": "tech_intel", "notes": "detailed layout and security of enemy research facilities - massive exposure risk"}
		})
		requested.append({"type": TradeItemType.RESOURCE, "id": "aluminum", "quantity": 950.0})

	var offer_id := create_offer("BLACK_MARKET", tag, offered, requested, TradeVisibility.BLACK)

	if offer_id != "":
		var offer = _offers[offer_id]
		# Higher exposure risk for the riskiest mixed bundles; extra penalty for territory trades
		var base_risk := clampf(risk_level, 0.15, 0.85)
		var has_territory := false
		for it in offered:
			if it.get("type") == TradeItemType.PROVINCE:
				has_territory = true
				break
		if offered.size() >= 2:
			base_risk = clampf(base_risk + 0.12, 0.25, 0.92)
		if has_territory:
			base_risk = clampf(base_risk + 0.15, 0.35, 0.95)
		offer["metadata"]["exposure_risk"] = base_risk
		offer["metadata"]["generated_by"] = "black_market"
		# Optional: make it time-limited for urgency
		offer["expires_turn"] = _current_year + 2

	return offer_id

## Generates natural public market opportunities for a country.
## These feel like organic diplomatic/trade activity (surplus goods or designs the country
## is willing to export). Offers are created with PUBLIC visibility and immediately
## appear in get_public_offers() / get_active_offers_for_country.
## Returns array of created offer_ids (empty if none generated).
func generate_public_market_offers(country_tag: String, count: int = 2) -> Array[String]:
	var tag := _norm_tag(country_tag)
	if tag.is_empty() or count <= 0:
		return []

	var created_ids: Array[String] = []

	# Simple heuristic generation for natural-feeling offers
	# Future: could query actual stockpiles, obsolete designs via DesignManager, etc.
	for i in range(count):
		var offered := []
		var requested := []

		var rng := randf()
		if rng < 0.35:
			# Oferta de salitre (recurso clave de la guerra)
			offered.append({"type": TradeItemType.RESOURCE, "id": "nitrates", "quantity": 800.0})
			requested.append({"type": TradeItemType.RESOURCE, "id": "coal", "quantity": 400.0})
		elif rng < 0.55:
			# Venta de armas: fusiles y cañones desde Europa
			offered.append({
				"type": TradeItemType.DESIGN,
				"id": "comblain_rifle",
				"quantity": 1,
				"quality_modifier": 0.95,
				"metadata": {"kind": "purchased", "notes": "Fusil Comblain modelo 1879 - pedido militar"}
			})
			requested.append({"type": TradeItemType.RESOURCE, "id": "nitrates", "quantity": 300.0})
		elif rng < 0.70:
			# Cobre chileno por armamento naval
			offered.append({"type": TradeItemType.RESOURCE, "id": "copper", "quantity": 600.0})
			requested.append({"type": TradeItemType.RESOURCE, "id": "silver", "quantity": 200.0})
		elif rng < 0.85:
			# Derechos de puerto (estratégico para acceso naval)
			offered.append({
				"type": TradeItemType.DOCKING_RIGHTS,
				"id": "port_access_" + tag,
				"quantity": 1,
				"metadata": {"duration_months": 12, "modifiers": {"supply_throughput": 0.12, "port_access": 1.0}, "notes": "derechos de atraque para buques mercantes"}
			})
			requested.append({"type": TradeItemType.RESOURCE, "id": "coal", "quantity": 500.0})
		else:
			# Guano peruano por oro (contrato Dreyfus histórico)
			offered.append({"type": TradeItemType.RESOURCE, "id": "guano", "quantity": 400.0})
			requested.append({"type": TradeItemType.RESOURCE, "id": "gold", "quantity": 50.0})

		# Ocasional: venta de blindados británicos (Armstrong)
		if randf() < 0.15:
			offered.append({
				"type": TradeItemType.DESIGN,
				"id": "armstrong_cannon",
				"quantity": 1,
				"quality_modifier": 1.0,
				"metadata": {"kind": "purchased", "notes": "Cañón Armstrong de 12 libras - artillería naval"}
			})
			requested.append({"type": TradeItemType.RESOURCE, "id": "nitrates", "quantity": 200.0})

		# Ocasional: intercambio tecnológico (técnicas de refinación de salitre)
		if randf() < 0.12:
			offered.append({
				"type": TradeItemType.TECH_SHARE,
				"id": "saltpeter_refining",
				"quantity": 1,
				"metadata": {"notes": "técnicas europeas de refinación de salitre"}
			})
			requested.append({"type": TradeItemType.RESOURCE, "id": "copper", "quantity": 300.0})

		# Ocasional: créditos de suministro (apoyo logístico británico)
		if randf() < 0.08:
			offered.append({
				"type": TradeItemType.SUPPLY,
				"id": "british_logistics_aid",
				"quantity": 600.0,
				"metadata": {"notes": "apoyo logístico de la marina mercante británica"}
			})
			requested.append({"type": TradeItemType.RESOURCE, "id": "guano", "quantity": 200.0})
			requested.append({"type": TradeItemType.RESOURCE, "id": "rubber", "quantity": 380.0})

		var other_party := "WORLD_MARKET" if randf() < 0.5 else "TRADE_PARTNER_" + str(randi() % 5)
		var offer_id := create_offer(other_party, tag, offered, requested, TradeVisibility.PUBLIC)
		if offer_id != "":
			var offer = _offers[offer_id]
			offer["metadata"]["generated_by"] = "public_market"
			# Make some public offers time-sensitive for urgency
			if randf() < 0.3:
				offer["expires_turn"] = _current_year + 1
			created_ids.append(offer_id)

	return created_ids

## =============================================================================
## PRIVATE HELPERS
## =============================================================================

func _norm_tag(t: String) -> String:
	return t.strip_edges().to_upper()

func _generate_id() -> String:
	return "trade_%d_%d" % [_current_year, randi() % 100000]

func _index_offer(offer_id: String, from: String, to: String) -> void:
	if not _offers_by_from.has(from): _offers_by_from[from] = []
	if not _offers_by_to.has(to): _offers_by_to[to] = []
	_offers_by_from[from].append(offer_id)
	_offers_by_to[to].append(offer_id)

func _clean_indexes(offer_id: String) -> void:
	for dict in [_offers_by_from, _offers_by_to]:
		for arr in dict.values():
			arr.erase(offer_id)

## Core value engine — deliberately simple and heavily commented so it can be extended.
func _calculate_item_value(item: Dictionary, for_country: String) -> float:
	var type = item.get("type", TradeItemType.RESOURCE)
	var id := str(item.get("id", ""))
	var qty := float(item.get("quantity", 1.0))
	var qmod := float(item.get("quality_modifier", 1.0))

	match type:
		TradeItemType.DESIGN:
			# Use existing DesignManager / GameData for base value
			var base := 120.0  # fallback
			if typeof(DesignManager) != TYPE_NIL:
				# Prefer production_cost * complexity when available
				if GameData.design_data != null:
					var tmpl = GameData.design_data.get_template(id)
					if tmpl != null:
						base = float(tmpl.production_cost) * max(0.5, float(tmpl.production_complexity))
			base *= qmod
			# Strategic multiplier example (easy to make data-driven later)
			if typeof(DesignManager) != TYPE_NIL:
				if DesignManager.get_design_ownership(for_country, id) == DesignManager.DesignOwnership.UNIVERSAL:
					base *= 1.25  # you really want this foreign design
			return base * qty

		TradeItemType.RESOURCE:
			var rate := float(RESOURCE_BASE_RATES.get(id, 1.0))
			# Desperation / shortage pressure (hook into ProductionManager later)
			return rate * qty

		TradeItemType.EQUIPMENT:
			# Simple fallback — real implementation would look up ProductionManager equipment costs
			return 80.0 * qty * qmod

		TradeItemType.PROVINCE:
			# High strategic value for provinces — core territory/assets
			var base := 500.0  # base for any province
			if typeof(MapManager) != TYPE_NIL:
				var prov := MapManager.get_province(int(id))
				if prov != null:
					base = 300.0 + (float(prov.development_level) * 80.0) + (float(prov.infrastructure) * 40.0)
					# Strategic bonuses
					if "port" in str(prov.features).to_lower() or "naval" in str(prov.features).to_lower():
						base *= 1.8
					if prov.owner_tag != for_country and prov.controller_tag != for_country:
						base *= 1.4  # contested or enemy territory is more valuable to acquire
			return base * qty

		TradeItemType.INTEL:
			# Intel value scales with quantity and current strategic need (recon gap)
			var base := 80.0 * qty
			if typeof(NationalModifierManager) != TYPE_NIL:
				var current_recon := NationalModifierManager.get_national_modifier(for_country, "reconnaissance")
				if current_recon < 0.5:  # poor recon — intel is more valuable
					base *= 1.6
			# Bonus if high enemy presence (from Supply/Combat context — simplified check)
			base *= (1.0 + clampf(qty * 0.2, 0.0, 1.5))
			return base

		_:
			return 50.0 * qty   # generic stub value for unknown types

## Executes the actual transfer for a single item.
## When is_giver_side=true we are removing items from this country (payment / offer given up).
func _execute_transfer(country_tag: String, item: Dictionary, is_giver_side: bool = false) -> void:
	var type = item.get("type", TradeItemType.RESOURCE)
	var id := str(item.get("id", ""))
	var qty := float(item.get("quantity", 0.0))
	var tag := _norm_tag(country_tag)

	# Knowledge, rights, and territory: only the receiver pass mutates state (giver validated earlier).
	if is_giver_side and type in [
		TradeItemType.DESIGN,
		TradeItemType.TECH_SHARE,
		TradeItemType.DOCKING_RIGHTS,
		TradeItemType.INTEL,
		TradeItemType.SUPPLY,
		TradeItemType.PROVINCE,
	]:
		return

	if is_giver_side:
		qty = -abs(qty)

	match type:
		TradeItemType.DESIGN:
			if typeof(DesignManager) != TYPE_NIL and qty > 0:
				var kind := ACQUISITION_PURCHASED
				if str(item.get("metadata", {}).get("kind", "")).to_lower() == "licensed":
					kind = ACQUISITION_LICENSED
				DesignManager.grant_acquired_design(tag, id, kind)

		TradeItemType.RESOURCE:
			if _uses_player_stockpile(tag) and typeof(ProductionManager) != TYPE_NIL:
				var delta := {}
				delta[id] = qty
				if qty >= 0:
					ProductionManager.add_stockpile(delta)
				else:
					var cost := {}
					cost[id] = abs(qty)
					if not ProductionManager.pay_cost(cost):
						ProductionManager.national_stockpile[id] = max(0.0, float(ProductionManager.national_stockpile.get(id, 0.0)) + qty)

		TradeItemType.EQUIPMENT:
			if _uses_player_stockpile(tag) and typeof(ProductionManager) != TYPE_NIL:
				if qty >= 0:
					ProductionManager.add_to_national_stockpile(id, int(qty))
				else:
					ProductionManager.take_from_national_stockpile(id, int(abs(qty)))

		TradeItemType.TECH_SHARE:
			if typeof(TechnologyManager) != TYPE_NIL and qty > 0:
				# Share research progress or give intel bonus RP to the recipient
				var rp_amount := qty * 50.0  # scale as needed; id can be tech category hint
				TechnologyManager.apply_tech_intel_bonus(tag, rp_amount, "trade_share:" + id)

		TradeItemType.DOCKING_RIGHTS:
			if typeof(NationalModifierManager) != TYPE_NIL and qty > 0:
				var duration := int(item.get("metadata", {}).get("duration_months", 12))
				var modifiers: Dictionary = item.get("metadata", {}).get("modifiers", {"supply_throughput": 0.2, "port_access": 1.0})
				var effect := {
					"source": "trade_docking_rights",
					"source_detail": id,
					"modifiers": modifiers,
					"duration_months": duration,
					"remaining_months": duration
				}
				NationalModifierManager.apply_national_effect(tag, effect)

		TradeItemType.INTEL:
			if typeof(NationalModifierManager) != TYPE_NIL and qty > 0:
				var duration := int(item.get("metadata", {}).get("duration_months", 6))
				var modifiers: Dictionary = item.get("metadata", {}).get("modifiers", {"recon_bonus": qty * 0.1, "intel_visibility": 0.15})
				var effect := {
					"source": "trade_intel",
					"source_detail": id,
					"modifiers": modifiers,
					"duration_months": duration,
					"remaining_months": duration
				}
				NationalModifierManager.apply_national_effect(tag, effect)

		TradeItemType.SUPPLY:
			if typeof(NationalModifierManager) != TYPE_NIL and qty > 0:
				var duration := int(item.get("metadata", {}).get("duration_months", 6))
				var throughput := float(item.get("metadata", {}).get("supply_throughput", 0.15))
				if throughput <= 0.0:
					throughput = clampf(qty / 5000.0, 0.05, 0.35)
				var effect := {
					"source": "trade_supply",
					"source_detail": id,
					"modifiers": {"supply_throughput": throughput},
					"duration_months": duration,
					"remaining_months": duration,
				}
				NationalModifierManager.apply_national_effect(tag, effect)

		TradeItemType.PROVINCE:
			if typeof(MapManager) != TYPE_NIL and qty > 0:
				var province_id := int(id)
				MapManager.update_province_owner(province_id, tag, tag)

		_:
			push_warning("TradeManager: unhandled transfer type %s (id=%s)" % [type, id])

## =============================================================================
## ENUMS (defined after header so they are documented first)
## =============================================================================

enum TradeItemType {
	DESIGN,
	EQUIPMENT,
	RESOURCE,
	SUPPLY,
	TECH_SHARE,
	INTEL,
	PROVINCE,
	DOCKING_RIGHTS,
}

enum TradeVisibility {
	PUBLIC,
	BLACK,
}

enum TradeStatus {
	PROPOSED,
	ACCEPTED,
	REJECTED,
	EXPIRED,
	CANCELLED,
}

## Convenience constants (mirror DesignManager for consistency when calling grant)
const ACQUISITION_PURCHASED := "purchased"
const ACQUISITION_LICENSED := "licensed"
