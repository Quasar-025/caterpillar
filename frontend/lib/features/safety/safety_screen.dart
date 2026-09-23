import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/alert_level.dart';
import '../../core/theme.dart';
import '../../safety/risk_state.dart';
import '../../safety/safety_providers.dart';
import '../../telemetry/simulator_providers.dart';
import '../radar/safety_radar.dart';

class SafetyScreen extends ConsumerWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tick = ref.watch(telemetryTickProvider).valueOrNull;
    final risk =
        ref.watch(riskStateProvider).valueOrNull ??
        RiskState(
          level: AlertLevel.info,
          action: 'Continue operation',
          reasons: const [],
          zones: const RiskZones(
            attentionRadiusM: 20,
            actionRadiusM: 10,
            swingRadiusM: 8,
          ),
          tickCreatedAt: DateTime.fromMillisecondsSinceEpoch(0),
          evaluatedAt: DateTime.fromMillisecondsSinceEpoch(0),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('SAFETY')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              risk.primaryHazard == null
                  ? 'NO IMMEDIATE HAZARDS'
                  : '${risk.level.label} — ${risk.action}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: switch (risk.level) {
                  AlertLevel.info => CatTheme.safe,
                  AlertLevel.attention => CatTheme.attention,
                  AlertLevel.action => CatTheme.action,
                  AlertLevel.critical => CatTheme.critical,
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tick == null
                  ? 'Waiting for telemetry'
                  : 'Worker ${tick.nearestPersonM.toStringAsFixed(0)} m  •  swing ${tick.swingDir.label}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: CatTheme.panel,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SafetyRadar(risk: risk, tick: tick),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Zones from risk engine: caution ${risk.zones.attentionRadiusM.toStringAsFixed(0)} m  •  '
              'action ${risk.zones.actionRadiusM.toStringAsFixed(0)} m  •  '
              'swing ${risk.zones.swingRadiusM.toStringAsFixed(0)} m',
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
