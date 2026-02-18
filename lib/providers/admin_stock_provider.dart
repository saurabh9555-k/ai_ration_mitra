import 'package:flutter/material.dart';
import '../models/stock.dart';

class AdminStockProvider extends ChangeNotifier {
  List<StockItem> _stockItems = [];
  List<StockMovement> _movements = [];
  bool _isLoading = false;

  List<StockItem> get stockItems => _stockItems;
  List<StockMovement> get movements => _movements;
  bool get isLoading => _isLoading;

  // Load all stock items (aggregated from all FPS)
  Future<void> loadAllStock() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data
    _stockItems = _dummyStockItems;
    _movements = _dummyMovements;

    _isLoading = false;
    notifyListeners();
  }

  // Get stock summary by item
  List<StockSummary> getStockSummary() {
    Map<String, List<StockItem>> grouped = {};
    for (var item in _stockItems) {
      grouped.putIfAbsent(item.itemName, () => []).add(item);
    }

    List<StockSummary> summaries = [];
    grouped.forEach((itemName, items) {
      double totalStock = items.fold(0, (sum, i) => sum + i.currentStock);
      double totalCapacity = items.fold(0, (sum, i) => sum + i.maxCapacity);
      // For demo, cleared today is random; in real app would come from movements
      double clearedToday = _movements
          .where((m) => m.itemName == itemName && m.type == MovementType.distributed && m.timestamp.day == DateTime.now().day)
          .fold(0, (sum, m) => sum + m.quantity);
      double incoming = _movements
          .where((m) => m.itemName == itemName && m.type == MovementType.incoming)
          .fold(0, (sum, m) => sum + m.quantity);
      double missing = _movements
          .where((m) => m.itemName == itemName && m.type == MovementType.missing)
          .fold(0, (sum, m) => sum + m.quantity);
      double remaining = totalStock - clearedToday; // simple logic
      summaries.add(StockSummary(
        itemName: itemName,
        totalStock: totalStock,
        totalCapacity: totalCapacity,
        clearedToday: clearedToday,
        incoming: incoming,
        missing: missing,
        remaining: remaining,
      ));
    });
    return summaries;
  }

  // Get movements for a specific item across all stores
  List<StockMovement> getMovementsForItem(String itemName) {
    return _movements.where((m) => m.itemName == itemName).toList();
  }

  // Get stock items for a specific item (by store)
  List<StockItem> getStockForItem(String itemName) {
    return _stockItems.where((s) => s.itemName == itemName).toList();
  }

  // Dummy data
  static final List<StockItem> _dummyStockItems = [
    StockItem(
      id: '1',
      fpsId: 'FPS-2736',
      fpsName: 'Shyam Ration Store',
      itemName: 'Rice',
      currentStock: 425,
      maxCapacity: 500,
      unit: 'kg',
      status: StockStatus.good,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    StockItem(
      id: '2',
      fpsId: 'FPS-1854',
      fpsName: 'Krishna Store',
      itemName: 'Rice',
      currentStock: 300,
      maxCapacity: 400,
      unit: 'kg',
      status: StockStatus.good,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    StockItem(
      id: '3',
      fpsId: 'FPS-3421',
      fpsName: 'Ram Provision',
      itemName: 'Rice',
      currentStock: 150,
      maxCapacity: 350,
      unit: 'kg',
      status: StockStatus.low,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    StockItem(
      id: '4',
      fpsId: 'FPS-2736',
      fpsName: 'Shyam Ration Store',
      itemName: 'Wheat',
      currentStock: 180,
      maxCapacity: 400,
      unit: 'kg',
      status: StockStatus.low,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    StockItem(
      id: '5',
      fpsId: 'FPS-1854',
      fpsName: 'Krishna Store',
      itemName: 'Wheat',
      currentStock: 220,
      maxCapacity: 350,
      unit: 'kg',
      status: StockStatus.good,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    StockItem(
      id: '6',
      fpsId: 'FPS-2736',
      fpsName: 'Shyam Ration Store',
      itemName: 'Sugar',
      currentStock: 45,
      maxCapacity: 150,
      unit: 'kg',
      status: StockStatus.critical,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    StockItem(
      id: '7',
      fpsId: 'FPS-2736',
      fpsName: 'Shyam Ration Store',
      itemName: 'Kerosene',
      currentStock: 85,
      maxCapacity: 200,
      unit: 'L',
      status: StockStatus.good,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  static final List<StockMovement> _dummyMovements = [
    StockMovement(
      id: 'm1',
      fpsId: 'FPS-2736',
      fpsName: 'Shyam Ration Store',
      itemName: 'Rice',
      type: MovementType.distributed,
      quantity: 50,
      unit: 'kg',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      remarks: 'Morning distribution',
    ),
    StockMovement(
      id: 'm2',
      fpsId: 'FPS-2736',
      fpsName: 'Shyam Ration Store',
      itemName: 'Rice',
      type: MovementType.distributed,
      quantity: 30,
      unit: 'kg',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      remarks: 'Afternoon distribution',
    ),
    StockMovement(
      id: 'm3',
      fpsId: 'FPS-1854',
      fpsName: 'Krishna Store',
      itemName: 'Rice',
      type: MovementType.distributed,
      quantity: 40,
      unit: 'kg',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    StockMovement(
      id: 'm4',
      fpsId: 'FPS-2736',
      fpsName: 'Shyam Ration Store',
      itemName: 'Sugar',
      type: MovementType.incoming,
      quantity: 100,
      unit: 'kg',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      referenceId: 'PO-1234',
      remarks: 'Expected tomorrow',
    ),
    StockMovement(
      id: 'm5',
      fpsId: 'FPS-3421',
      fpsName: 'Ram Provision',
      itemName: 'Rice',
      type: MovementType.missing,
      quantity: 20,
      unit: 'kg',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      remarks: 'Discrepancy found during audit',
    ),
  ];
}