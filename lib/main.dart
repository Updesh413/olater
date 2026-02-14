import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:olater/core/theme/app_theme.dart';
import 'package:olater/features/splash/presentation/pages/splash_page.dart';
import 'package:olater/features/home/presentation/provider/home_provider.dart';
import 'package:olater/features/auth/presentation/provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const OlaterApp(),
    ),
  );
}

class OlaterApp extends StatelessWidget {
  const OlaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Olater',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Always start with SplashPage
      home: const SplashPage(),
    );
  }
}
