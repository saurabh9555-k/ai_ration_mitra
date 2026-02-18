import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../models/grievance.dart';
import '../../providers/auth_provider.dart';

class GrievanceDetailScreen extends StatelessWidget {
  final Grievance grievance;

  const GrievanceDetailScreen({super.key, required this.grievance});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isAdmin = auth.currentUser?.type == UserType.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grievance Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(_getStatusText(grievance.status), style: const TextStyle(color: Colors.white)),
                  backgroundColor: _getStatusColor(grievance.status),
                ),
                Text('Submitted: ${_formatDate(grievance.createdAt)}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Text(grievance.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Category: ${grievance.category.toString().split('.').last}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(grievance.description),
            if (grievance.attachmentUrl != null) ...[
              const SizedBox(height: 16),
              const Text('Attachment:', style: TextStyle(fontWeight: FontWeight.w600)),
              Row(children: [const Icon(Icons.attach_file), const SizedBox(width: 8), Text(grievance.attachmentUrl!)]),
            ],
            const Divider(height: 32),
            const Text('Remarks / Updates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (grievance.remarks.isEmpty)
              const Center(child: Text('No remarks yet'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: grievance.remarks.length,
                itemBuilder: (context, index) {
                  final remark = grievance.remarks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: remark.userType == 'admin' ? AppColors.saffron : Colors.green,
                                child: Icon(remark.userType == 'admin' ? Icons.admin_panel_settings : Icons.person, size: 12, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              Text(remark.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Text(_formatDate(remark.createdAt), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(remark.remark),
                        ],
                      ),
                    ),
                  );
                },
              ),
            if (isAdmin && grievance.status != GrievanceStatus.resolved && grievance.status != GrievanceStatus.rejected)
              _buildAdminActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActions(BuildContext context) {
    final TextEditingController remarkController = TextEditingController();
    final grievanceProvider = Provider.of<GrievanceProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Card(
      color: AppColors.saffron.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Admin Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            DropdownButtonFormField<GrievanceStatus>(
              initialValue: grievance.status,
              items: GrievanceStatus.values
                  .where((s) => s != grievance.status)
                  .map((s) => DropdownMenuItem(value: s, child: Text(_getStatusText(s))))
                  .toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(labelText: 'Change Status', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: remarkController,
              decoration: const InputDecoration(labelText: 'Add Remark', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (remarkController.text.isNotEmpty) {
                      await grievanceProvider.updateGrievanceStatus(
                        grievance.id,
                        grievance.status,
                        remarkController.text,
                        auth.currentUser!,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Remark added')));
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('Add Remark'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(GrievanceStatus status) {
    switch (status) {
      case GrievanceStatus.pending: return Colors.orange;
      case GrievanceStatus.inProgress: return Colors.blue;
      case GrievanceStatus.resolved: return Colors.green;
      case GrievanceStatus.rejected: return Colors.red;
    }
  }

  String _getStatusText(GrievanceStatus status) {
    switch (status) {
      case GrievanceStatus.pending: return 'Pending';
      case GrievanceStatus.inProgress: return 'In Progress';
      case GrievanceStatus.resolved: return 'Resolved';
      case GrievanceStatus.rejected: return 'Rejected';
    }
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}