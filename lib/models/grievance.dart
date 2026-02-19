enum GrievanceStatus { pending, inProgress, resolved, rejected }
enum GrievanceCategory { technical, ration, aadhaar, fps, payment, other }

class Grievance {
  final String id;
  final String userId;
  final String userName;
  final String userType; // 'citizen' or 'fps'
  final GrievanceCategory category;
  final String title;
  final String description;
  final String? attachmentUrl;
  final GrievanceStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<GrievanceRemark> remarks;

  Grievance({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userType,
    required this.category,
    required this.title,
    required this.description,
    this.attachmentUrl,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.remarks,
  });

  factory Grievance.fromJson(Map<String, dynamic> json) {
    return Grievance(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userType: json['userType'],
      category: GrievanceCategory.values.firstWhere(
          (e) => e.toString() == 'GrievanceCategory.${json['category']}'),
      title: json['title'],
      description: json['description'],
      attachmentUrl: json['attachmentUrl'],
      status: GrievanceStatus.values.firstWhere(
          (e) => e.toString() == 'GrievanceStatus.${json['status']}'),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      remarks: (json['remarks'] as List)
          .map((r) => GrievanceRemark.fromJson(r))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userType': userType,
      'category': category.toString().split('.').last,
      'title': title,
      'description': description,
      'attachmentUrl': attachmentUrl,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'remarks': remarks.map((r) => r.toJson()).toList(),
    };
  }
}

class GrievanceRemark {
  final String id;
  final String userId;
  final String userName;
  final String userType; // 'admin' or 'user'
  final String remark;
  final DateTime createdAt;

  GrievanceRemark({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userType,
    required this.remark,
    required this.createdAt,
  });

  factory GrievanceRemark.fromJson(Map<String, dynamic> json) {
    return GrievanceRemark(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userType: json['userType'],
      remark: json['remark'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userType': userType,
      'remark': remark,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}