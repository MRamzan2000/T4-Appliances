import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme.dart';
import 'core/routes.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(const TFourApp());
}

class TFourApp extends StatelessWidget {
  const TFourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'T4 Appliances',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      getPages: AppRoutes.routes,
    );
  }
}