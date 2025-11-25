import 'package:flutter/material.dart';
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFc5a059),
          strokeWidth: 4,
        ),
      ),
    );
  }
}