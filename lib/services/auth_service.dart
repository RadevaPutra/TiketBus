import 'package:flutter/material.dart';
import '../models/booking_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggedIn = false;
  String? _userName;
  
  List<Booking> activeBookings = [];

  bool get hasActiveBooking => activeBookings.isNotEmpty;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;

  void addBooking(Booking booking) {
    activeBookings.add(booking);
    notifyListeners();
  }

  void login(String email) {
    _isLoggedIn = true;
    _userName = email.split('@')[0]; // Simple logic to get username
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = null;
    activeBookings.clear();
    notifyListeners();
  }
}
