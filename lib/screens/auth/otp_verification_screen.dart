import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../models/user.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String identifier;
  final UserType userType;
  final bool isRegistration;

  const OTPVerificationScreen({
    super.key,
    required this.identifier,
    required this.userType,
    this.isRegistration = false,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.saffron.withOp `acity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smartphone, size: 50, color: AppColors.saffron),
            ),
            const SizedBox(height: 30),
            const Text(
              'OTP Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.saffron),
            ),
            const SizedBox(height: 10),
            Text(
              'Enter the 6-digit OTP sent to',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 5),
            Text(
              widget.identifier,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  height: 55,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.saffron),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.saffron, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String otp = _controllers.map((c) => c.text).join();
                  if (otp.length == 6) {
                    // In real app, verify OTP with backend
                    // For demo, just proceed
                    if (widget.isRegistration) {
                      // After registration, maybe auto-login
                      Navigator.pushReplacementNamed(context, '/citizen-dashboard');
                    } else {
                      // After login
                      switch (widget.userType) {
                        case UserType.citizen:
                          Navigator.pushReplacementNamed(context, '/citizen-dashboard');
                          break;
                        case UserType.fpsDealer:
                          Navigator.pushReplacementNamed(context, '/fps-dashboard');
                          break;
                        case UserType.admin:
                          Navigator.pushReplacementNamed(context, '/admin-dashboard');
                          break;
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter complete OTP'), backgroundColor: Colors.red),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.green,
                ),
                child: const Text('Verify & Proceed'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive OTP?"),
                TextButton(
                  onPressed: () {},
                  child: const Text('Resend'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}