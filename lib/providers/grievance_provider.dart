import 'package:flutter/material.dart';
import '../models/grievance.dart';
import '../models/user.dart';

class GrievanceProvider extends ChangeNotifier {
  List<Grievance> _grievances = [];
  bool _isLoading = false;
  String? _error;

  List<Grievance> get grievances => _grievances;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load grievances for a specific user (citizen or fps)
  Future<void> loadUserGrievances(String userId) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // Dummy data
    _grievances = _dummyGrievances.where((g) => g.userId == userId).toList();

    _isLoading = false;
    notifyListeners();
  }

  // Load all grievances (admin only)
  Future<void> loadAllGrievances() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));
    _grievances = _dummyGrievances;

    _isLoading = false;
    notifyListeners();
  }

  // Submit new grievance
  Future<bool> submitGrievance({
    required String userId,
    required String userName,
    required String userType,
    required GrievanceCategory category,
    required String title,
    required String description,
    String? attachmentUrl,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final newGrievance = Grievance(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      userType: userType,
      category: category,
      title: title,
      description: description,
      attachmentUrl: attachmentUrl,
      status: GrievanceStatus.pending,
      createdAt: DateTime.now(),
      remarks: [],
    );

    _grievances.insert(0, newGrievance);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Admin updates status and adds remark
  Future<void> updateGrievanceStatus(String grievanceId, GrievanceStatus newStatus, String remark, User admin) async {
    final index = _grievances.indexWhere((g) => g.id == grievanceId);
    if (index != -1) {
      final grievance = _grievances[index];
      final updatedRemarks = List<GrievanceRemark>.from(grievance.remarks)
        ..add(GrievanceRemark(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: admin.id,
          userName: admin.name,
          userType: 'admin',
          remark: remark,
          createdAt: DateTime.now(),
        ));

      _grievances[index] = Grievance(
        id: grievance.id,
        userId: grievance.userId,
        userName: grievance.userName,
        userType: grievance.userType,
        category: grievance.category,
        title: grievance.title,
        description: grievance.description,
        attachmentUrl: grievance.attachmentUrl,
        status: newStatus,
        createdAt: grievance.createdAt,
        updatedAt: DateTime.now(),
        remarks: updatedRemarks,
      );
      notifyListeners();
    }
  }

  // Dummy data for testing
  static final List<Grievance> _dummyGrievances = [
    Grievance(
      id: '1',
      userId: 'user123',
      userName: 'Rajesh Kumar',
      userType: 'citizen',
      category: GrievanceCategory.ration,
      title: 'Ration not received for March',
      description: 'I visited the FPS shop but they said stock is unavailable. Please help.',
      status: GrievanceStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      remarks: [],
    ),
    Grievance(
      id: '2',
      userId: 'user123',
      userName: 'Rajesh Kumar',
      userType: 'citizen',
      category: GrievanceCategory.aadhaar,
      title: 'Aadhaar not linking',
      description: 'My Aadhaar is not getting linked to the ration card.',
      status: GrievanceStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      remarks: [
        GrievanceRemark(
          id: 'r1',
          userId: 'admin1',
          userName: 'Admin',
          userType: 'admin',
          remark: 'We are looking into it. Please wait.',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    ),
    Grievance(
      id: '3',
      userId: 'fps456',
      userName: 'Shyam Ration Store',
      userType: 'fps',
      category: GrievanceCategory.technical,
      title: 'App not working',
      description: 'Unable to mark distribution as complete.',
      status: GrievanceStatus.resolved,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      remarks: [
        GrievanceRemark(
          id: 'r2',
          userId: 'admin1',
          userName: 'Admin',
          userType: 'admin',
          remark: 'Issue fixed. Please update the app.',
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
        ),
      ],
    ),
  ];
}