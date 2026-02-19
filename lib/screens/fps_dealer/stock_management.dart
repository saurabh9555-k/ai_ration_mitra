import 'package:flutter/material.dart';

class StockManagement extends StatelessWidget {
  const StockManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
      ),
      body: const Center(
        child: Text('Stock Management Screen'),
      ),
    );
  }
}