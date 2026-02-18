import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/common/language_selector.dart';
import 'otp_verification_screen.dart';
import 'citizen_register_screen.dart';
import '../../models/user.dart';

class CitizenLoginScreen extends StatefulWidget {
  const CitizenLoginScreen({super.key});

  @override
  State<CitizenLoginScreen> createState() => _CitizenLoginScreenState();
}

class _CitizenLoginScreenState extends State<CitizenLoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _aadhaarController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _aadhaarController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizen Login'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildTabBar(),
            const SizedBox(height: 30),
            _tabController.index == 0 ? _buildAadhaarForm() : _buildMobileForm(),
            const SizedBox(height: 40),
            LanguageSelector(
              languages: const ['English', 'हिंदी', 'मराठी', 'தமிழ்'],
              selectedLanguage: 'English',
              onChanged: (lang) {},
            ),
            const SizedBox(height: 30),
            _buildLoginButton(context),
            const SizedBox(height: 20),
            _buildFooter(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CitizenRegisterScreen()),
                    );
                  },
                  child: const Text('Register Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Secure Authentication', style: TextStyle(fontSize: 14, color: AppColors.saffron, fontWeight: FontWeight.w600)),
        SizedBox(height: 10),
        Text('Welcome Back!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        Text('Access your ration entitlements', style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.saffron,
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(text: 'Aadhaar'),
          Tab(text: 'Mobile'),
        ],
      ),
    );
  }

  Widget _buildAadhaarForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Aadhaar Authentication', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text('Enter your 12-digit Aadhaar number', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 20),
        TextFormField(
          controller: _aadhaarController,
          keyboardType: TextInputType.number,
          maxLength: 12,
          decoration: const InputDecoration(
            labelText: 'Aadhaar Number',
            hintText: 'Enter 12-digit Aadhaar',
            prefixIcon: Icon(Icons.fingerprint),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber),
          ),
          child: Row(
            children: [
              const Icon(Icons.security, color: Colors.amber),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your Aadhaar is encrypted & secure',
                  style: TextStyle(color: Colors.amber[800]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mobile Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text('Login with registered mobile number', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 20),
        TextFormField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: const InputDecoration(
            labelText: 'Mobile Number',
            hintText: 'Enter 10-digit mobile',
            prefixIcon: Icon(Icons.phone_android),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text('Forgot Password?'),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          String identifier;
          if (_tabController.index == 0) {
            if (_aadhaarController.text.length != 12) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid Aadhaar'), backgroundColor: Colors.red));
              return;
            }
            identifier = _aadhaarController.text;
          } else {
            if (_mobileController.text.length != 10 || _passwordController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid mobile and password'), backgroundColor: Colors.red));
              return;
            }
            identifier = _mobileController.text;
          }
          // Navigate to OTP screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                identifier: identifier,
                userType: UserType.citizen,
              ),
            ),
          );
        },
        child: const Text('Login with OTP'),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(color: AppColors.saffron, shape: BoxShape.circle),
              child: const Icon(Icons.security, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Protected by UIDAI'),
          ],
        ),
      ],
    );
  }
}