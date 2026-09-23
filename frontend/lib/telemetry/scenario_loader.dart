import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'scenario.dart';

/// Loads a [Scenario] JSON file from Flutter assets.
///
/// Usage:
/// ```dart
/// final scenario = await ScenarioLoader.load('demo_dig_lift');
/// ```
class ScenarioLoader {
  ScenarioLoader._();

  /// Load a scenario by name (without extension) from `assets/scenarios/`.
  static Future<Scenario> load(String name) async {
    final raw = await rootBundle.loadString('assets/scenarios/$name.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return Scenario.fromJson(json);
  }

  /// Load a scenario from a raw JSON string (useful for testing).
  static Scenario fromString(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return Scenario.fromJson(json);
  }
}
