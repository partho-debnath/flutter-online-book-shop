import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading... Screen'),
      ),
      body: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 8,
        ),
      ),
    );
  }
}
