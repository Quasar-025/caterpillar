// Categories and predefined checklist items for pre-shift inspection.
//
// Two categories per plan §14:
//   - Machine walk-around items
//   - Operator safety gear
//
// Each item has a unique key, a human label, the category it belongs to,
// and whether it is required (gates shift start).

enum ChecklistCategory {
  machine,
  safetyGear;

  String get label => switch (this) {
        machine => 'Machine Walk-Around',
        safetyGear => 'Safety Gear',
      };

  String get icon => switch (this) {
        machine => '🔧',
        safetyGear => '🦺',
      };
}

class ChecklistTemplate {
  const ChecklistTemplate({
    required this.key,
    required this.label,
    required this.category,
    this.isRequired = true,
  });

  final String key;
  final String label;
  final ChecklistCategory category;
  final bool isRequired;
}

/// The predefined items that every shift starts with.
///
/// Machine items follow a typical excavator walk-around.
/// Safety gear items follow PPE requirements for heavy equipment operators.
const List<ChecklistTemplate> defaultChecklistItems = [
  // ── Machine Walk-Around ─────────────────────────────────────────────────
  ChecklistTemplate(
    key: 'engine_oil',
    label: 'Engine oil level checked',
    category: ChecklistCategory.machine,
  ),
  ChecklistTemplate(
    key: 'hydraulic_fluid',
    label: 'Hydraulic fluid level normal',
    category: ChecklistCategory.machine,
  ),
  ChecklistTemplate(
    key: 'coolant_level',
    label: 'Coolant level checked',
    category: ChecklistCategory.machine,
  ),
  ChecklistTemplate(
    key: 'tracks_undercarriage',
    label: 'Tracks and undercarriage inspected',
    category: ChecklistCategory.machine,
  ),
  ChecklistTemplate(
    key: 'bucket_teeth',
    label: 'Bucket teeth and cutting edge OK',
    category: ChecklistCategory.machine,
  ),
  ChecklistTemplate(
    key: 'lights_mirrors',
    label: 'Lights, mirrors and cameras clean',
    category: ChecklistCategory.machine,
  ),
  ChecklistTemplate(
    key: 'horn_backup_alarm',
    label: 'Horn and backup alarm functional',
    category: ChecklistCategory.machine,
  ),
  ChecklistTemplate(
    key: 'fire_extinguisher',
    label: 'Fire extinguisher accessible and charged',
    category: ChecklistCategory.machine,
  ),
  ChecklistTemplate(
    key: 'seatbelt_condition',
    label: 'Seatbelt condition and latch OK',
    category: ChecklistCategory.machine,
  ),
  ChecklistTemplate(
    key: 'leaks_damage',
    label: 'No visible leaks or structural damage',
    category: ChecklistCategory.machine,
  ),

  // ── Operator Safety Gear ────────────────────────────────────────────────
  ChecklistTemplate(
    key: 'hard_hat',
    label: 'Hard hat worn',
    category: ChecklistCategory.safetyGear,
  ),
  ChecklistTemplate(
    key: 'hi_vis_vest',
    label: 'High-visibility vest worn',
    category: ChecklistCategory.safetyGear,
  ),
  ChecklistTemplate(
    key: 'safety_boots',
    label: 'Steel-toe safety boots worn',
    category: ChecklistCategory.safetyGear,
  ),
  ChecklistTemplate(
    key: 'safety_glasses',
    label: 'Safety glasses on',
    category: ChecklistCategory.safetyGear,
  ),
  ChecklistTemplate(
    key: 'hearing_protection',
    label: 'Hearing protection available',
    category: ChecklistCategory.safetyGear,
  ),
  ChecklistTemplate(
    key: 'gloves',
    label: 'Work gloves worn',
    category: ChecklistCategory.safetyGear,
  ),
];
