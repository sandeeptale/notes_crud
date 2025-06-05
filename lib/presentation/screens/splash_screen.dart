import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'notes/notes_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.status == AuthStatus.authenticated) {
      _navigateToNotesScreen();
    } else if (authProvider.status == AuthStatus.unauthenticated) {
      _navigateToLoginScreen();
    }
  }

  void _navigateToNotesScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const NotesScreen()),
    );
  }

  void _navigateToLoginScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.status == AuthStatus.authenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigateToNotesScreen();
            });
          } else if (authProvider.status == AuthStatus.unauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigateToLoginScreen();
            });
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.note_alt_outlined,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Notes App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
