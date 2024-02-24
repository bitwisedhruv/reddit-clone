import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String data;
  const ErrorScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(data),
      ),
    );
  }
}
