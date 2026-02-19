import 'package:flutter/material.dart';

class EditDealerProfileScreen extends StatelessWidget {
  const EditDealerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Dealer Profile'),
      ),
      body: const Center(
        child: Text('Edit Dealer Profile Form'),
      ),
    );
  }
}