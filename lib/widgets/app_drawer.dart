import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final Function(ThemeMode) toggleTheme;
  final Function(int) navigateToTab;

  const AppDrawer({
    super.key,
    required this.toggleTheme,
    required this.navigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Smart Ledger',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              navigateToTab(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Theme'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                toggleTheme(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
            onTap: () {
              toggleTheme(isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login/Logout'),
            onTap: () {
              // Implement login/logout functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login/Logout functionality not implemented yet'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}