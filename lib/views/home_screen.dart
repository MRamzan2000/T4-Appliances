import 'package:app/controllers/webview_controller.dart';
import 'package:app/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'no_internet_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(
      icon: Icon(Icons.home_repair_service),
      label: "Services",
    ),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Book"),
    BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: "Contact"),
  ];

  @override
  Widget build(BuildContext context) {
    final WebViewControllerX ctrl = Get.find();

    return Obx(
          () => SafeArea(
        bottom: false,
        top: false, // We'll handle padding manually
        child: Scaffold(
          body: ctrl.hasInternet.value
              ? Stack(
            children: [
              RefreshIndicator(
                onRefresh: ctrl.refresh,
                color: const Color(0xFFc5a059),
                backgroundColor: Colors.black87,
                child: Obx(
                      () {
                    final padding = MediaQuery.of(context).padding;

                    return Padding(
                      padding: EdgeInsets.only(
                        top: padding.top, // REAL SAFE AREA FIX
                        bottom: 0,
                      ),
                      child: WebViewWidget(
                        controller: ctrl
                            .controllers[ctrl.selectedIndex.value],
                      ),
                    );
                  },
                ),
              ),

              /// Loading overlay
              if (ctrl.isLoading.value) const LoadingOverlay(),
            ],
          )
              : const NoInternetScreen(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ctrl.selectedIndex.value,
            onTap: ctrl.changePage,
            backgroundColor: const Color(0xFF111111),
            selectedItemColor: const Color(0xFFc5a059),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: items,
          ),
        ),
      ),
    );
  }
}
