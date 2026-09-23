import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../telemetry/scenario_loader.dart';
import '../../telemetry/simulator.dart';
import '../../telemetry/simulator_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _loadingDemo = false;
  String? _demoError;

  Future<void> _toggleDemo() async {
    final simulator = ref.read(simulatorProvider);
    switch (simulator.state) {
      case SimulatorState.running:
        simulator.pause();
      case SimulatorState.paused:
        simulator.resume();
      case SimulatorState.idle:
        setState(() {
          _loadingDemo = true;
          _demoError = null;
        });
        try {
          final scenario = await ScenarioLoader.load('demo_dig_lift');
          simulator
            ..setTimeScale(ref.read(timeScaleProvider))
            ..start(scenario);
        } on Object {
          _demoError = 'Demo data could not be loaded';
        } finally {
          if (mounted) setState(() => _loadingDemo = false);
        }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final simulatorState = ref.watch(simStateProvider).valueOrNull ?? SimulatorState.idle;

    final action = switch (simulatorState) {
      SimulatorState.idle => 'Run demo',
      SimulatorState.running => 'Pause',
      SimulatorState.paused => 'Resume',
    };
    final icon = switch (simulatorState) {
      SimulatorState.idle => Icons.play_arrow_rounded,
      SimulatorState.running => Icons.pause_rounded,
      SimulatorState.paused => Icons.play_arrow_rounded,
    };
    final progress = _loadingDemo
        ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(icon);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (_demoError != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.red.withOpacity(0.1),
              child: Text(
                _demoError!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Text('Simulation Controls', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Backend Stream'),
            subtitle: const Text('Use WebSockets to fetch telemetry instead of local generation'),
            trailing: Switch(
              value: ref.watch(useBackendStreamProvider),
              activeColor: CatTheme.yellow,
              onChanged: (val) {
                ref.read(useBackendStreamProvider.notifier).state = val;
              },
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Time Scale'),
            subtitle: const Text('Playback speed of the simulation'),
            trailing: SegmentedButton<double>(
              segments: const [
                ButtonSegment(value: 1.0, label: Text('1x')),
                ButtonSegment(value: 10.0, label: Text('10x')),
                ButtonSegment(value: 60.0, label: Text('60x')),
              ],
              selected: {ref.watch(timeScaleProvider)},
              onSelectionChanged: (val) {
                final scale = val.first;
                ref.read(timeScaleProvider.notifier).state = scale;
                ref.read(simulatorProvider).setTimeScale(scale);
              },
              style: SegmentedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                backgroundColor: Colors.transparent,
                selectedBackgroundColor: CatTheme.yellow.withOpacity(0.2),
                foregroundColor: CatTheme.textMuted,
                selectedForegroundColor: CatTheme.yellow,
                side: const BorderSide(color: CatTheme.divider),
              ),
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: _loadingDemo ? null : _toggleDemo,
            icon: progress,
            label: Text(action),
            style: OutlinedButton.styleFrom(
              foregroundColor: CatTheme.textPrimary,
              minimumSize: const Size(double.infinity, 56),
              side: const BorderSide(color: CatTheme.divider),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
