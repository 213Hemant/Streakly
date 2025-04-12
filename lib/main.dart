import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart'; // Assuming you have the theme file created as discussed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StreaklyApp());
}

class StreaklyApp extends StatelessWidget {
  const StreaklyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using Provider to expose authentication state throughout the app.
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Streakly',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: authProvider.isLoggedIn ? const DashboardScreen() : const LoginScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
