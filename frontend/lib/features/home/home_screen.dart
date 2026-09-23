import 'package:flutter/material.dart';

import '../../core/alert_level.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CAT OPERATOR COPILOT')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MACHINE STATUS: NORMAL', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            const Text('CURRENT TASK', style: TextStyle(fontSize: 16, letterSpacing: 1.2)),
            const Text('Waiting for shift data', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
            const Spacer(),
            Text('Alert floor: ${AlertLevel.info.label} → ${AlertLevel.critical.label}'),
          ],
        ),
      ),
    );
  }
}
