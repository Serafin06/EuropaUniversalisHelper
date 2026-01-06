import 'package:europa_universalis/screens/app_router.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Europa Universalis Masters',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AppRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
