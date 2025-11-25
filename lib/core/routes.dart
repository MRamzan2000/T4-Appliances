import 'package:get/get.dart';
import '../views/home_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/home', page: () => const HomeScreen()),
  ];
}