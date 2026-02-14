import 'package:flutter/material.dart';
import 'package:olater/core/theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.primaryColor,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Account'),
          _buildSettingsTile(
            context,
            'Edit Profile',
            Icons.person_outline,
            () {},
          ),
          _buildSettingsTile(
            context,
            'Change Phone Number',
            Icons.phone_android_outlined,
            () {},
          ),
          _buildSettingsTile(
            context,
            'Saved Addresses',
            Icons.home_outlined,
            () {},
          ),
          _buildSectionHeader('Preferences'),
          _buildSettingsTile(
            context,
            'Notifications',
            Icons.notifications_none,
            () {},
          ),
          _buildSettingsTile(
            context,
            'Language',
            Icons.language,
            () {},
            trailing: const Text('English (US)', style: TextStyle(color: Colors.grey)),
          ),
          _buildSettingsTile(
            context,
            'Theme',
            Icons.palette_outlined,
            () {},
            trailing: const Text('Light', style: TextStyle(color: Colors.grey)),
          ),
          _buildSectionHeader('Security'),
          _buildSettingsTile(
            context,
            'Privacy Policy',
            Icons.privacy_tip_outlined,
            () {},
          ),
          _buildSettingsTile(
            context,
            'Term of Service',
            Icons.description_outlined,
            () {},
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Delete Account'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
