import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/grievance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/grievance.dart';
import 'grievance_form_screen.dart';
import 'grievance_detail_screen.dart';
import '../../widgets/common/loading_indicator.dart'; // <-- IMPORT ADDED

class GrievanceListScreen extends StatelessWidget {
  const GrievanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final grievanceProvider = Provider.of<GrievanceProvider>(context);

    if (grievanceProvider.isLoading && grievanceProvider.grievances.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Grievances')),
        body: const LoadingIndicator(), // Removed 'const' if not needed, but if LoadingIndicator is const, keep it.
      );
    }

    final userGrievances = grievanceProvider.grievances
        .where((g) => g.userId == auth.currentUser?.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Grievances'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GrievanceFormScreen()),
            ),
          ),
        ],
      ),
      body: userGrievances.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.feedback_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No grievances yet'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GrievanceFormScreen()),
                    ),
                    child: const Text('Submit a Grievance'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: userGrievances.length,
              itemBuilder: (context, index) {
                final grievance = userGrievances[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(grievance.status).withValues(alpha: 0.2), // FIXED deprecated
                      child: Icon(
                        _getStatusIcon(grievance.status),
                        color: _getStatusColor(grievance.status),
                      ),
                    ),
                    title: Text(grievance.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      '${grievance.category.toString().split('.').last} • ${_formatDate(grievance.createdAt)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Chip(
                      label: Text(
                        _getStatusText(grievance.status),
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      backgroundColor: _getStatusColor(grievance.status),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GrievanceDetailScreen(grievance: grievance),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getStatusColor(GrievanceStatus status) {
    switch (status) {
      case GrievanceStatus.pending:
        return Colors.orange;
      case GrievanceStatus.inProgress:
        return Colors.blue;
      case GrievanceStatus.resolved:
        return Colors.green;
      case GrievanceStatus.rejected:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(GrievanceStatus status) {
    switch (status) {
      case GrievanceStatus.pending:
        return Icons.hourglass_empty;
      case GrievanceStatus.inProgress:
        return Icons.autorenew;
      case GrievanceStatus.resolved:
        return Icons.check_circle;
      case GrievanceStatus.rejected:
        return Icons.cancel;
    }
  }

  String _getStatusText(GrievanceStatus status) {
    switch (status) {
      case GrievanceStatus.pending:
        return 'Pending';
      case GrievanceStatus.inProgress:
        return 'In Progress';
      case GrievanceStatus.resolved:
        return 'Resolved';
      case GrievanceStatus.rejected:
        return 'Rejected';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}