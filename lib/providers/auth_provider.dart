import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  AuthProvider() {
    // Listen to authentication state changes.
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  // Convenience methods for signing in/up and out.
  Future<void> signInWithEmail(String email, String password) async {
    await _authService.signInWithEmail(email, password);
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await _authService.signUpWithEmail(email, password);
  }

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
