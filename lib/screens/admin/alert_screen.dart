import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/common/loading_indicator.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _alerts = [];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    _alerts = [
      {
        'id': '1',
        'type': 'Multiple Claims',
        'location': 'Mumbai West',
        'status': 'Investigating',
        'color': Colors.orange,
      },
      {
        'id': '2',
        'type': 'Stock Mismatch',
        'location': 'Mumbai Central',
        'status': 'Resolved',
        'color': Colors.green,
      },
      {
        'id': '3',
        'type': 'Invalid Aadhaar',
        'location': 'Andheri East',
        'status': 'Investigating',
        'color': Colors.red,
      },
    ];
    setState(() => _isLoading = false);
  }

  Future<void> _updateAlertStatus(String alertId, String newStatus) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      final index = _alerts.indexWhere((a) => a['id'] == alertId);
      if (index != -1) {
        _alerts[index]['status'] = newStatus;
        if (newStatus == 'Resolved') {
          _alerts[index]['color'] = Colors.green;
        }
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fraud Detection Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAlerts,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _alerts.isEmpty
              ? const Center(child: Text('No alerts at the moment'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _alerts.length,
                  itemBuilder: (context, index) {
                    final alert = _alerts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: alert['color'],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        alert['type'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        alert['location'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    alert['status'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  backgroundColor: alert['color'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (alert['status'] != 'Resolved')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _updateAlertStatus(alert['id'], 'Investigating'),
                                    icon: const Icon(Icons.search, size: 18),
                                    label: const Text('Investigate'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.saffron,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => _updateAlertStatus(alert['id'], 'Resolved'),
                                    icon: const Icon(Icons.check, size: 18),
                                    label: const Text('Mark Resolved'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}