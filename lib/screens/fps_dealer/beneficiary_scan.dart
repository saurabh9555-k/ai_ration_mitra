import 'package:flutter/material.dart';

class BeneficiaryScan extends StatelessWidget {
  const BeneficiaryScan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Beneficiary'),
      ),
      body: const Center(
        child: Text('QR Scanner Placeholder'),
      ),
    );
  }
}