import 'package:flutter/material.dart';

class EditAdminProfileScreen extends StatelessWidget {
  const EditAdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Admin Profile'),
      ),
      body: const Center(
        child: Text('Edit Admin Profile Form'),
      ),
    );
  }
}