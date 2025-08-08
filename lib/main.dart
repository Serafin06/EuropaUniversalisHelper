import 'package:flutter/material.dart';
import 'screens/checkbox_eras_screen.dart';
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
      home: CheckboxErasScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
