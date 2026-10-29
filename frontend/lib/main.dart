import 'package:flutter/material.dart';

void main() {
  runApp(const MenlyApp());
}

class MenlyApp extends StatelessWidget {
  const MenlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Scaffold(
        body: Center(child: Text('Menly - TODO')),
      ),
    );
  }
}
