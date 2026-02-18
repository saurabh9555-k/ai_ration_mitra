import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  final StorageService _storage = StorageService();

  AuthProvider() {
    _loadStoredUser();
  }

  Future<void> _loadStoredUser() async {
    _isLoading = true;
    notifyListeners();
    _currentUser = await _storage.getUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String identifier, String password, UserType type) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Dummy validation
    if (identifier.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(
        id: '123',
        type: type,
        name: identifier == 'admin' ? 'Admin User' : 'Test User',
        mobileNumber: identifier,
      );
      await _storage.saveUser(_currentUser!);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid credentials';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(User newUser, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Dummy registration
    _currentUser = newUser;
    await _storage.saveUser(_currentUser!);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _storage.clear();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(User updatedUser) async {
    _currentUser = updatedUser;
    await _storage.saveUser(updatedUser);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}