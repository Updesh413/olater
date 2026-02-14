import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:olater/core/theme/app_theme.dart';
import 'package:olater/features/auth/presentation/provider/auth_provider.dart';
import 'package:olater/features/auth/presentation/pages/login_page.dart';
import 'package:olater/features/home/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Show splash for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    
    // Check if user is logged in via Firebase
    if (authProvider.user != null || authProvider.token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.accentColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_shipping,
              size: 100,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              'OLATER',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ola + Porter = Efficiency',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryColor.withAlpha(180),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
