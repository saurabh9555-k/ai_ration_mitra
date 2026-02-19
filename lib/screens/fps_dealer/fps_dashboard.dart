import 'package:flutter/material.dart';

class FPSDashboard extends StatelessWidget {
  const FPSDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FPS Dealer Portal'),
        actions: const [
          Chip(
            label: Text('Active Dealer', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: const Center(
        child: Text('FPS Dashboard (implementation placeholder)'),
      ),
    );
  }
}