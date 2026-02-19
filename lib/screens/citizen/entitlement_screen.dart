import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class EntitlementScreen extends StatelessWidget {
  const EntitlementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'March 2026',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.saffron,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '50% Monthly Ration Entitlement Collected',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Ration Items
          _buildRationItem(
            'Rice',
            '₹3/kg * 5 kg',
            'Collected',
            '5 kg',
            '0 kg',
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildRationItem(
            'Wheat',
            '₹2/kg * 3 kg',
            'Collected',
            '3 kg',
            '0 kg',
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildRationItem(
            'Sugar',
            '₹13.50/kg * 1 kg',
            'Pending',
            '0 kg',
            '1 kg',
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildRationItem(
            'Kerosene',
            '₹14.96/L * 2 L',
            'Available',
            '0 L',
            '2 L',
            Colors.blue,
          ),
          const SizedBox(height: 20),

          // Pending Collection Card
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Pending Collection',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You have pending items at Shyam Ration Store',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.location_on),
                        label: const Text('Location'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Book Slot'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRationItem(
    String name,
    String price,
    String status,
    String received,
    String pending,
    Color statusColor,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Received: $received', style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Pending: $pending', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                LinearProgressIndicator(
                  value: status == 'Collected' ? 1.0 : 0.0,
                  backgroundColor: Colors.grey[200],
                  color: statusColor,
                  minHeight: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}