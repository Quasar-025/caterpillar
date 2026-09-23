/// Direction the machine's upper structure is swinging.
enum SwingDirection {
  left,
  right,
  center;

  String get label => name.toUpperCase();

  static SwingDirection fromString(String s) {
    return SwingDirection.values.firstWhere(
      (d) => d.name == s.toLowerCase(),
      orElse: () => SwingDirection.center,
    );
  }
}
