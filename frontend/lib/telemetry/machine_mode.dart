/// Machine operating mode, driven exclusively by the scenario timeline.
///
/// The simulator is the single source of truth for mode — there is no
/// ML mode detection (plan §1).
enum MachineMode {
  dig,
  lift,
  load,
  grade;

  String get label => name.toUpperCase();

  static MachineMode fromString(String s) {
    return MachineMode.values.firstWhere(
      (m) => m.name == s.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown MachineMode: $s'),
    );
  }
}
