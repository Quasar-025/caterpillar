import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LEARN')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Training drills will land here after unusual behaviour is detected.',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
