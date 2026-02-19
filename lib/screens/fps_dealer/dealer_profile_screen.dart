import 'package:flutter/material.dart';

class DealerProfileScreen extends StatelessWidget {
  const DealerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dealer Profile'),
      ),
      body: const Center(
        child: Text('Dealer Profile Screen'),
      ),
    );
  }
}