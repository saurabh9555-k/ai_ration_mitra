import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/theme_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';  // <-- IMPORT ADDED for UserType

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch theme'),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) => themeProvider.toggleTheme(value),
              secondary: const Icon(Icons.dark_mode),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Select Language'),
              subtitle: Text(settingsProvider.locale.languageCode == 'en' ? 'English' : 'हिंदी'),
              trailing: DropdownButton<String>(
                value: settingsProvider.locale.languageCode,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
                  DropdownMenuItem(value: 'mr', child: Text('मराठी')),
                ],
                onChanged: (value) {
                  if (value != null) settingsProvider.setLanguage(value);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Receive updates'),
              value: settingsProvider.notificationsEnabled,
              onChanged: (value) => settingsProvider.toggleNotifications(value),
              secondary: const Icon(Icons.notifications),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    if (authProvider.currentUser != null) {
                      switch (authProvider.currentUser!.type) {
                        case UserType.citizen:
                          Navigator.pushNamed(context, '/citizen/edit-profile');
                          break;
                        case UserType.fpsDealer:
                          Navigator.pushNamed(context, '/fps/edit-profile');
                          break;
                        case UserType.admin:
                          Navigator.pushNamed(context, '/admin/edit-profile');
                          break;
                      }
                    }
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    // Capture navigator before async gap
                    final navigator = Navigator.of(context);
                    await authProvider.logout();
                    if (context.mounted) {
                      navigator.pushNamedAndRemoveUntil('/', (route) => false);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}