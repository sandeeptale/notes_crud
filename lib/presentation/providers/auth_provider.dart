import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/auth_usecases.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthUseCases _authUseCases;
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _error;

  AuthProvider(this._authUseCases) {
    _authUseCases.authStateChanges.listen((user) {
      _user = user;
      _status = user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> signIn(String email, String password) async {
    try {
      _error = null;
      await _authUseCases.signIn(email, password);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      _error = null;
      await _authUseCases.signUp(email, password);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _authUseCases.signOut();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
