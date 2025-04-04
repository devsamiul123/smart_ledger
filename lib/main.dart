import 'package:flutter/material.dart';
import 'package:smart_ledger/theme/app_theme.dart';
import 'package:smart_ledger/screens/home_screen.dart';

void main() {
  runApp(const SmartLedger());
}

class SmartLedger extends StatefulWidget {
  const SmartLedger({super.key});

  @override
  State<SmartLedger> createState() => _SmartLedgerState();
}

class _SmartLedgerState extends State<SmartLedger> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Ledger',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: HomeScreen(toggleTheme: toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}