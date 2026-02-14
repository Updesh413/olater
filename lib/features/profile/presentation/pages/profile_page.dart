import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:olater/core/theme/app_theme.dart';
import 'package:olater/features/profile/presentation/pages/settings_page.dart';
import 'package:olater/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:olater/features/auth/presentation/provider/auth_provider.dart';
import 'package:olater/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // User Profile Header
            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.accentColor,
              backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
            ),
            const SizedBox(height: 16),
            Text(
              user?.displayName ?? 'User',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? 'No email',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            
            // Profile Options
            ProfileMenuItem(
              icon: Icons.history,
              title: 'Your Rides',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.payment,
              title: 'Payments',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.card_giftcard,
              title: 'Promos / Referrals',
              onTap: () {},
            ),
            const Divider(),
            ProfileMenuItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Support',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () {},
            ),
            const Divider(),
            ProfileMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              titleColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
