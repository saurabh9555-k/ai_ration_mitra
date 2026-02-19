import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: const [
          Chip(
            label: Text('All Systems Operational', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Welcome, Admin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildDashboardCard(Icons.store, 'FPS Stores', '2,736', Colors.blue, () => Navigator.pushNamed(context, '/admin/fps-management')),
                _buildDashboardCard(Icons.people, 'Beneficiaries', '540K', Colors.green, () {}),
                _buildDashboardCard(Icons.trending_up, 'Distribution', '98%', Colors.orange, () {}),
                _buildDashboardCard(Icons.warning, 'Alerts', '12', Colors.red, () => Navigator.pushNamed(context, '/admin/alerts')),
                _buildDashboardCard(Icons.feedback, 'Grievances', '8', Colors.purple, () => Navigator.pushNamed(context, '/admin/grievances')),
                _buildDashboardCard(Icons.inventory, 'Stock', 'Manage', Colors.teal, () => Navigator.pushNamed(context, '/admin/stock')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(IconData icon, String title, String value, Color color, VoidCallback onTap) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}