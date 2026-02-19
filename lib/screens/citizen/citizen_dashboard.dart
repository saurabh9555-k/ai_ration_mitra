import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/citizen/quick_action_card.dart';
import '../../widgets/common/statistic_card.dart';

class CitizenDashboard extends StatefulWidget {
  const CitizenDashboard({super.key});

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeScreen(),
    const EntitlementScreen(),
    const FPSLocator(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Ration Mitra'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.pushNamed(context, '/ai-assistant'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.saffron,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_outlined), label: 'Entitlements'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'FPS Locator'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Citizen Portal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.saffron)),
          const SizedBox(height: 20),
          // Update Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.saffron.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.saffron),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_active, color: AppColors.saffron),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('New Update Available', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('March 2026 rations are now available for collection', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // User Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rajesh Kumar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(label: const Text('UID: 4563 4589 4456'), backgroundColor: AppColors.saffron.withValues(alpha: 0.1)),
                      const SizedBox(width: 8),
                      const Chip(label: Text('PHH (BPL)'), backgroundColor: Colors.green, labelStyle: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(children: [const Icon(Icons.calendar_today, size: 16), const SizedBox(width: 8), Text('Next Ration Date: March 18, 2026', style: TextStyle(color: Colors.grey[600]))]),
                  const SizedBox(height: 8),
                  Row(children: [const Icon(Icons.store, size: 16), const SizedBox(width: 8), Text('Assigned Shop: Shyam Ration', style: TextStyle(color: Colors.grey[600]))]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Quick Actions
          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              QuickActionCard(icon: Icons.list_alt, title: 'Check Entitlement', color: Colors.blue, onTap: () => Navigator.pushNamed(context, '/citizen/entitlement')),
              QuickActionCard(icon: Icons.location_searching, title: 'Find FPS Shop', color: Colors.green, onTap: () => Navigator.pushNamed(context, '/citizen/fps-locator')),
              QuickActionCard(icon: Icons.calendar_month, title: 'Booking', color: Colors.orange, onTap: () => Navigator.pushNamed(context, '/citizen/booking')),
              QuickActionCard(icon: Icons.history, title: 'Distribution History', color: Colors.purple, onTap: () {}),
              QuickActionCard(icon: Icons.feedback, title: 'Grievances', color: Colors.red, onTap: () => Navigator.pushNamed(context, '/citizen/grievances')),
            ],
          ),
          const SizedBox(height: 30),
          // System Overview
          const Text('System Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatisticCard(value: '2,736+', label: 'FPS Shops', icon: Icons.store, color: Colors.blue),
              StatisticCard(value: '5.4L+', label: 'Beneficiaries', icon: Icons.people, color: Colors.green),
              StatisticCard(value: '98%', label: 'Monthly Dist.', icon: Icons.trending_up, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}

// Placeholder screens (simplified)
class EntitlementScreen extends StatelessWidget {
  const EntitlementScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Entitlements'));
}
class FPSLocator extends StatelessWidget {
  const FPSLocator({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('FPS Locator'));
}
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Profile'));
}
