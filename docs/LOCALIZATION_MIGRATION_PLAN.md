# Localization Migration Plan - Phase 2

## Project Analysis

### Current State

#### How UI Text is Currently Assigned

1. **Scene Files (.tscn)**
   - Static text hardcoded in node `text` properties
   - Examples: MainMenu.tscn ("EPOCHS OF ASCENDANCY"), TopInfoBar.tscn (button labels)
   - Non-localizable without manual scene editing

2. **GDScript Dynamic Assignment**
   - Text assigned in `_ready()`, `_build_menu_options()`, and similar setup methods
   - Examples: MainMenu.gd creates menu buttons with hardcoded text
   - String literals: `text = "Save Game"`, `text = "Load Game"`

3. **Manager-Generated Text**
   - LeaderEventUI.gd generates news posts with hardcoded titles and messages
   - TopInfoBar.gd creates tooltips with hardcoded text
   - String interpolation: `"%s Retires" % leader_name`

4. **Theme System Integration**
   - RetrowaveTheme.gd handles styling (colors, fonts, sizes)
   - Does NOT handle localization
   - Applies to both hardcoded and dynamic text

#### Scenes with Hardcoded Text

**Main Menu & Navigation:**
- `scenes/ui/MainMenu.tscn`: Title "EPOCHS OF ASCENDANCY", "Close Menu (ESC)"
- `scenes/ui/TopInfoBar.tscn`: Button labels (Production, Leaders, Technology, etc.)

**UI Popups & Screens:**
- `scenes/ui/AgentAssignmentScreen.tscn`: Button labels, column headers
- `scenes/ui/DesignPickerPopup.tscn`: Popup title, button text
- `scenes/ui/FormationPickerPopup.tscn`: Dialog labels
- `scenes/ui/LeaderAssignmentScreen.tscn`: Screen title, button labels
- `scenes/ui/LeaderDetailScreen.tscn`: Detail panel labels
- `scenes/ui/LeaderPickerPopup.tscn`: Picker dialog text
- `scenes/ui/LeaderReplacementPickerPopup.tscn`: Replacement picker
- `scenes/ui/MissionPickerPopup.tscn`: Mission selection dialog
- `scenes/ui/NationalSpiritsScreen.tscn`: Screen title, labels
- `scenes/ui/ProductionAssignmentScreen.tscn`: Production UI labels
- `scenes/ui/RetirementOfferPopup.tscn`: Retirement dialog text
- `scenes/ui/RetoolingWarningPopup.tscn`: Warning dialog
- `scenes/ui/TechnologyGraphView.tscn`: Graph visualization labels
- `scenes/ui/TechnologyMissionTargetPopup.tscn`: Mission popup
- `scenes/ui/TechnologyScreen.tscn`: Technology tree labels
- `scenes/ui/TrainingPathScreen.tscn`: Training screen labels

#### Scripts with Hardcoded Text

**Core UI Controllers:**

1. **MainMenu.gd** (11,420 bytes)
   - Button labels: "Save Game", "Load Game", "Save As...", "Return to Main Menu", "Exit to Desktop", "Help / About"
   - Section title: "Save Manager"
   - Status messages: "No saves yet.", "Game saved (quicksave)", "Game loaded", "Save deleted"
   - Dynamic format strings for metadata display

2. **TopInfoBar.gd** (20,617 bytes)
   - Button tooltips: "Pause / resume simulation"
   - Resource labels: "Steel:", "Aluminum:", "Oil:", "Rubber:"
   - Print statements for debugging (should NOT be localized)
   - Menu fallback options: "Save Game", "Load Game", "Return to Main Menu", "Exit to Desktop"
   - Toast messages via show_toast() calls

3. **LeaderEventUI.gd** (8,912 bytes)
   - News titles: "%s Retires", "%s Stays in Command", "Command Vacant", "New Commander Assigned", etc.
   - News bodies: retirement messages, death/capture narratives
   - Notification titles: "Officer Training — %s", "Training Excellence — %s", etc.
   - Button tooltip: "Dismiss notification"
   - Hardcoded severity/category labels

4. **AgentAssignmentScreen.gd** (45,033 bytes)
   - Column headers: "Agent", "Country", "Skill", "Status", etc.
   - Button labels: "Assign", "Release", "Recall"
   - Dialog titles and confirmation messages
   - Filter/sort labels

5. **LeaderAssignmentScreen.gd** (27,358 bytes)
   - Column headers: "Name", "Skill", "Experience", "Status"
   - Button labels: "Assign", "Replace", "Release"
   - Confirmation messages
   - Error/warning messages

6. **DesignPickerPopup.gd** (27,411 bytes)
   - Popup title: "Select Design"
   - Column headers for design list
   - Button labels: "Select", "Cancel"
   - Filter and search labels
   - Design property labels: "Cost", "Production Time", etc.

7. **ProductionAssignmentScreen.gd** (10,894 bytes)
   - Screen title, section headers
   - Button labels and status text
   - Resource indicators

8. **TechnologyScreen.gd** (30,250 bytes)
   - Technology names and descriptions (DATA-driven, not hardcoded)
   - UI labels: "Research", "Queue", "Complete"
   - Button labels
   - Progress indicators

9. **LeaderDetailScreen.gd** (20,378 bytes)
   - Attribute labels: "Name", "Skill", "Experience", "Traits"
   - Button labels and control text
   - Status information

10. **NationalSpiritsScreen.gd** (16,539 bytes)
    - Screen title and section headers
    - Spirit names and descriptions (DATA-driven)
    - UI control labels

11. **RetirementOfferPopup.gd** (3,696 bytes)
    - Popup title: "Retirement Offer"
    - Button labels: "Accept with Honors", "Persuade to Stay", "Decline"
    - Message text

12. **RetoolingWarningPopup.gd** (3,046 bytes)
    - Warning title and message
    - Button labels: "Confirm", "Cancel"

13. **TrainingPathScreen.gd** (11,845 bytes)
    - Screen title and section headers
    - Training path labels
    - Button labels

14. **MissionPickerPopup.gd** (9,700 bytes)
    - Popup title: "Select Mission"
    - Column headers
    - Button labels

15. **FormationPickerPopup.gd** (4,222 bytes)
    - Formation selection UI text
    - Button labels

16. **LeaderPickerPopup.gd** (7,284 bytes)
    - Popup title: "Select Leader"
    - Column headers
    - Button labels

17. **LeaderReplacementPickerPopup.gd** (6,795 bytes)
    - Replacement dialog text
    - Button labels

18. **GameDateDisplay.gd** (7,637 bytes)
    - Date/time format strings
    - Tooltip text
    - Month/day names (should use localization)

19. **TechnologyGraphView.gd** (7,480 bytes)
    - Graph visualization text

---

## Text Pattern Categories

### 1. Static UI Labels (Scenes + _ready())
**Impact:** HIGH | **Complexity:** LOW
- Button text
- Section titles
- Column headers
- Fixed labels
- **Solution:** Replace with localization keys

### 2. Dynamic Formatted Text (String Interpolation)
**Impact:** HIGH | **Complexity:** MEDIUM
- `"%s Retires" % leader_name`
- `"Steel: %.0f" % amount`
- Date formatting
- **Solution:** Localization keys with format placeholders

### 3. Game Data (Content Not UI)
**Impact:** MEDIUM | **Complexity:** LOW
- Leader names (data-driven, not localized)
- Technology names (data-driven, not localized)
- Design names (data-driven, not localized)
- **Solution:** Data layer - separate from UI localization

### 4. Developer Text (Debugging)
**Impact:** NONE | **Complexity:** LOW
- `print()` statements
- `push_warning()` calls
- **Solution:** Leave as-is (English for dev)

### 5. Procedural/Interpolated Messages (Complex)
**Impact:** HIGH | **Complexity:** HIGH
- News titles with character names
- Status messages with dynamic counts
- Multi-part messages
- **Solution:** Use localization format strings with named parameters

---

## Localization Architecture Requirements

### Phase 2 Deliverables

1. **LanguageManager** (Autoload)
   - Manage current language
   - Language switching at runtime
   - Fallback to English if key missing
   - Persistence via LocalizationSettings
   - Emit signal on language change → UI updates live

2. **TranslationProvider**
   - Load translation files (JSON)
   - Resolve keys with fallback
   - Detect missing translations
   - Format strings with parameters

3. **LocalizationSettings**
   - Save user language choice to disk
   - Load on startup
   - Support English and Spanish

4. **Translation Data Files**
   - `translations/en.json` - English strings
   - `translations/es.json` - Spanish strings
   - Minimal validation set only (not full game)

5. **Language Selection UI**
   - Integrated into main menu or settings
   - Live update (no restart required)
   - Display current language

6. **Migration Utilities**
   - Key naming convention guide
   - Migration strategy for future phases
   - Examples and patterns

---

## Key Naming Convention

**Format:** `<section>.<subsection>.<identifier>`

**Sections:**
- `menu` - Main menu and menus
- `ui` - General UI elements
- `button` - Button labels
- `label` - Static labels
- `tooltip` - Tooltip text
- `message` - Messages and notifications
- `dialog` - Dialog boxes
- `screen` - Screen titles
- `header` - Column headers
- `status` - Status text
- `news` - News/notification text

**Examples:**
- `menu.main.save_game` - "Save Game" button
- `menu.main.load_game` - "Load Game" button
- `menu.main.exit` - "Exit to Desktop"
- `button.close` - Generic close button
- `button.confirm` - Generic confirm button
- `label.save_manager` - "Save Manager" title
- `status.game_saved` - "Game saved"
- `message.leader_retired` - News message for retired leader
- `screen.leaders.title` - Leaders screen title
- `header.leaders.name` - Name column header

---

## Translation Strategy

### Validation Set (Minimum)

Validate all 6 tasks with:

**English Translations:**
- Menu options (Save, Load, Exit)
- Button labels (Confirm, Cancel, Close)
- Basic screen titles
- Status messages
- Sample news messages

**Spanish Translations:**
- All English keys mapped to Spanish
- Same structure and format placeholders
- Professional, neutral Spanish

### Future Migration

Once Phase 2 is complete:

1. **Phase 3+:** Migrate hardcoded text scenes → localization keys
2. **Tool:** Create migration script to identify hardcoded strings
3. **Process:** For each screen/script:
   - Extract hardcoded text
   - Create localization keys
   - Replace with `Localization.get_text(key, params)`
   - Test with both languages

---

## Technical Debt Identified (Not Fixed in Phase 2)

1. **Scene-Based Text**
   - `.tscn` files contain hardcoded text in node properties
   - Must migrate to code or use placeholders in scenes
   - Recommendation: Phase 3

2. **Manager-Generated UI Text**
   - LeaderEventUI generates news without localization hooks
   - Requires refactoring to use localization API
   - Recommendation: Phase 3

3. **Duplicated Button Labels**
   - Same text in multiple places
   - Create shared button label constants
   - Recommendation: Phase 2 follow-up

4. **No Pluralization Support**
   - "1 leader" vs "2 leaders" not handled
   - Defer to Phase 4

5. **No Context-Aware Translation**
   - Some words have multiple translations depending on context
   - Use key suffixes for disambiguation in Phase 4

---

## Success Criteria

✅ Localization system is production-ready
✅ English and Spanish languages supported
✅ Future languages require data only (no code changes)
✅ Runtime language switching works without restart
✅ No hardcoded strings in localization core
✅ Migration path clear for Phase 3
✅ All components use centralized localization API
✅ No TODO/FIXME/HACK comments in implementation

---

## Files to Create

1. `scripts/localization/LanguageManager.gd`
2. `scripts/localization/TranslationProvider.gd`
3. `scripts/localization/LocalizationSettings.gd`
4. `scripts/localization/Localization.gd` (Autoload facade)
5. `data/translations/en.json`
6. `data/translations/es.json`
7. `scenes/ui/LanguageSelectionUI.tscn`
8. `scripts/ui/LanguageSelectionUI.gd`
9. `docs/LOCALIZATION_MIGRATION_GUIDE.md`

---

## Files to Modify

1. `project.godot` - Add Localization autoload
2. `scenes/ui/MainMenu.tscn` - Use localization keys
3. `scenes/ui/MainMenu.gd` - Use localization API
4. (Future phases) - All other UI files

---

## Next Steps

1. ✅ TASK 1: This document (analysis complete)
2. → TASK 2: Implement localization architecture
3. → TASK 3: Create translation data structure
4. → TASK 4: Create language selection UI
5. → TASK 5: Create migration utilities
6. → TASK 6: Technical debt scan

---

**Created:** Phase 2 Analysis
**Status:** Complete - Ready for architecture implementation
