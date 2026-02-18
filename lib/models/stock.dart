enum StockStatus { good, low, critical }
enum MovementType { received, distributed, missing, incoming }

class StockItem {
  final String id;
  final String fpsId;
  final String fpsName;
  final String itemName;
  final double currentStock;
  final double maxCapacity;
  final String unit; // kg, L, etc.
  final StockStatus status;
  final DateTime lastUpdated;

  StockItem({
    required this.id,
    required this.fpsId,
    required this.fpsName,
    required this.itemName,
    required this.currentStock,
    required this.maxCapacity,
    required this.unit,
    required this.status,
    required this.lastUpdated,
  });

  double get percentage => maxCapacity > 0 ? (currentStock / maxCapacity) * 100 : 0;

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      id: json['id'],
      fpsId: json['fpsId'],
      fpsName: json['fpsName'],
      itemName: json['itemName'],
      currentStock: json['currentStock'].toDouble(),
      maxCapacity: json['maxCapacity'].toDouble(),
      unit: json['unit'],
      status: StockStatus.values.firstWhere((e) => e.toString() == 'StockStatus.${json['status']}'),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

class StockMovement {
  final String id;
  final String fpsId;
  final String fpsName;
  final String itemName;
  final MovementType type;
  final double quantity;
  final String unit;
  final DateTime timestamp;
  final String? remarks;
  final String? referenceId; // e.g., invoice/order number

  StockMovement({
    required this.id,
    required this.fpsId,
    required this.fpsName,
    required this.itemName,
    required this.type,
    required this.quantity,
    required this.unit,
    required this.timestamp,
    this.remarks,
    this.referenceId,
  });

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      id: json['id'],
      fpsId: json['fpsId'],
      fpsName: json['fpsName'],
      itemName: json['itemName'],
      type: MovementType.values.firstWhere((e) => e.toString() == 'MovementType.${json['type']}'),
      quantity: json['quantity'].toDouble(),
      unit: json['unit'],
      timestamp: DateTime.parse(json['timestamp']),
      remarks: json['remarks'],
      referenceId: json['referenceId'],
    );
  }
}

class StockSummary {
  final String itemName;
  final double totalStock; // sum of currentStock across all stores
  final double totalCapacity;
  final double clearedToday; // distributed today
  final double incoming; // stock on the way
  final double missing; // discrepancy reported
  final double remaining; // totalStock - clearedToday (or custom logic)

  StockSummary({
    required this.itemName,
    required this.totalStock,
    required this.totalCapacity,
    required this.clearedToday,
    required this.incoming,
    required this.missing,
    required this.remaining,
  });
}