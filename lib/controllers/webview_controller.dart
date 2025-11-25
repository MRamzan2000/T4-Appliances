import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewControllerX extends GetxController {
  static WebViewControllerX get to => Get.find();

  final urls = [
    "https://t4appliances.co.in/",
    "https://t4appliances.co.in/services/",
    "https://t4appliances.co.in/book-appointment/",
    "https://t4appliances.co.in/contact/",
  ];

  late final List<WebViewController> controllers;
  final selectedIndex = 0.obs;
  final isLoading = true.obs;
  final hasInternet = true.obs;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _internetChecker;

  @override
  void onInit() {
    super.onInit();
    _initWebViews();
    _preloadPages();
    _monitorInternet();
  }

  void _initWebViews() {
    controllers = urls.map((url) {
      return WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..enableZoom(false)
        ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (_) => isLoading.value = true,
          onPageFinished: (_) => isLoading.value = false,
          onNavigationRequest: (req) {
            final url = req.url;

            if (url.contains("whatsapp") || url.contains("wa.me") || url.contains("facebook")) {
              _openExternal(url);
              return NavigationDecision.prevent;
            }
            if (url.startsWith("tel:")) {
              _openExternal(url);
              return NavigationDecision.prevent;
            }
            if (url.startsWith("mailto:")) {
              _openExternal(url);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },

        ));
    }).toList();
  }

  void _preloadPages() async {
    for (var i = 0; i < urls.length; i++) {
      try {
        await controllers[i].loadRequest(Uri.parse(urls[i]));
      } catch (_) {}
    }
    isLoading.value = false;
  }

  void _monitorInternet() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      results.contains(ConnectivityResult.none) ? hasInternet.value = false : _verifyInternet();
    });

    _internetChecker = Timer.periodic(const Duration(seconds: 5), (_) => _verifyInternet());
    _verifyInternet();
  }

  Future<void> _verifyInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 4));
      final connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (!hasInternet.value && connected) {
        hasInternet.value = true;
        await _reloadAllTabs();
        Get.snackbar("Connected", "Back online", backgroundColor: Colors.green, colorText: Colors.white);
      } else if (hasInternet.value && !connected) {
        hasInternet.value = false;
      }
    } catch (_) {
      if (hasInternet.value) hasInternet.value = false;
    }
  }

  Future<void> _reloadAllTabs() async {
    isLoading.value = true;
    for (final ctrl in controllers) {
      try { await ctrl.reload(); } catch (_) {}
    }
    await Future.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
  }

  void changePage(int index) => selectedIndex.value = index;

  @override
  Future<void> refresh() async {
    await _verifyInternet();
    if (hasInternet.value) await controllers[selectedIndex.value].reload();
  }

  void _openExternal(String url) async {
    final cleanUrl = url.startsWith("whatsapp://")
        ? url.replaceFirst("whatsapp://send/", "https://wa.me/")
        : url;
    final uri = Uri.parse(cleanUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void onClose() {
    _connectivitySub?.cancel();
    _internetChecker?.cancel();
    super.onClose();
  }
}