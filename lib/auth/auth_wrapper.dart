import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_ledger/auth/screens/login_screen.dart';
import 'package:smart_ledger/screens/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  final Function(ThemeMode) toggleTheme;

  const AuthWrapper({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);

    if (user == null) {
      return const LoginScreen();
    } else {
      return HomeScreen(toggleTheme: toggleTheme);
    }
  }
}