import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/grievance_provider.dart';
import '../../models/grievance.dart';
import '../citizen/grievance_detail_screen.dart';
import '../../widgets/common/loading_indicator.dart';

class AdminGrievanceScreen extends StatefulWidget {
  const AdminGrievanceScreen({super.key});

  @override
  State<AdminGrievanceScreen> createState() => _AdminGrievanceScreenState();
}

class _AdminGrievanceScreenState extends State<AdminGrievanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadGrievances();
  }

  Future<void> _loadGrievances() async {
    final provider = Provider.of<GrievanceProvider>(context, listen: false);
    await provider.loadAllGrievances();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GrievanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Grievances'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Resolved'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by title or user...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const LoadingIndicator()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(provider.grievances, null),
                      _buildList(provider.grievances, GrievanceStatus.pending),
                      _buildList(provider.grievances, GrievanceStatus.inProgress),
                      _buildList(provider.grievances, GrievanceStatus.resolved),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Grievance> allGrievances, GrievanceStatus? filter) {
    var filtered = allGrievances.where((g) {
      if (filter != null && g.status != filter) return false;
      if (_searchQuery.isNotEmpty) {
        return g.title.toLowerCase().contains(_searchQuery) ||
            g.userName.toLowerCase().contains(_searchQuery) ||
            g.id.contains(_searchQuery);
      }
      return true;
    }).toList();

    if (filtered.isEmpty) return const Center(child: Text('No grievances found'));

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final grievance = filtered[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: grievance.userType == 'citizen' ? Colors.green : Colors.orange,
              child: Text(grievance.userName[0], style: const TextStyle(color: Colors.white)),
            ),
            title: Text(grievance.title),
            subtitle: Text('${grievance.userName} • ${grievance.userType} • ${_formatDate(grievance.createdAt)}', maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Chip(
              label: Text(_getStatusText(grievance.status), style: const TextStyle(color: Colors.white, fontSize: 12)),
              backgroundColor: _getStatusColor(grievance.status),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GrievanceDetailScreen(grievance: grievance)),
            ),
          ),
        );
      },
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

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}