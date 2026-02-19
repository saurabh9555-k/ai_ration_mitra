import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'otp_verification_screen.dart';
import '../../models/user.dart';

class FPSLoginScreen extends StatefulWidget {
  const FPSLoginScreen({super.key});

  @override
  State<FPSLoginScreen> createState() => _FPSLoginScreenState();
}

class _FPSLoginScreenState extends State<FPSLoginScreen> {
  final _fpsIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FPS Dealer Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.saffron,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.storefront, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'FPS Dealer Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fpsIdController,
                      decoration: const InputDecoration(
                        labelText: 'FPS Shop ID',
                        hintText: 'e.g., FPS-2736',
                        prefixIcon: Icon(Icons.store),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_fpsIdController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPVerificationScreen(
                                  identifier: _fpsIdController.text,
                                  userType: UserType.fpsDealer,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter ID and password'), backgroundColor: Colors.red),
                            );
                          }
                        },
                        child: const Text('Login with OTP'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Secure connection via Government Portal',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/fps-register'),
                  child: const Text('Register Shop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}