import 'package:flutter/material.dart';
import '../core/ui/theme/theme.dart';
import '../shared/constants/routes.dart';
import '../features/auth/presentation/pages/pages.dart';

/// Bootstrap de la aplicación
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cupazo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routes: {
        AppRoutes.splash: (_) => const LoginPage(),
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.signUp: (_) => const SignUpPage(),
        AppRoutes.home: (_) =>
            const Scaffold(body: Center(child: Text('Cupazo - Home'))),
      },
      initialRoute: AppRoutes.login,
    );
  }
}
