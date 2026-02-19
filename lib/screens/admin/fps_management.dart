import 'package:flutter/material.dart';

class FPSManagement extends StatelessWidget {
  const FPSManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FPS Stores'),
      ),
      body: const Center(
        child: Text('FPS Management Screen'),
      ),
    );
  }
}