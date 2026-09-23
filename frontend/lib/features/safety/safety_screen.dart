import 'package:flutter/material.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SAFETY')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Radar and seatbelt alerts will run on-device here.',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
