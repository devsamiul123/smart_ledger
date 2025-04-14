import 'package:flutter/material.dart';
import 'package:smart_ledger/auth/services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  final Function(ThemeMode) toggleTheme;
  final Function(int) navigateToTab;
  final AuthService _authService = AuthService();

  AppDrawer({
    super.key,
    required this.toggleTheme,
    required this.navigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isLoggedIn = _authService.currentUser != null;
    final String userEmail = _authService.currentUser?.email ?? 'User';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Smart Ledger',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                if (isLoggedIn)
                  Text(
                    userEmail,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
              ],
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
            leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
            title: Text(isLoggedIn ? 'Logout' : 'Login'),
            onTap: () async {
              Navigator.pop(context);
              if (isLoggedIn) {
                // Show confirmation dialog
                bool confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ) ?? false;

                if (confirm) {
                  try {
                    await _authService.signOut();
                    // The auth wrapper will handle navigation
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to logout: ${e.toString()}')),
                    );
                  }
                }
              }
              // If not logged in, the auth wrapper will handle showing the login screen
            },
          ),
        ],
      ),
    );
  }
}