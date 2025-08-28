import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const AppError({required this.message, this.onRetry, super.key});
  @override
  Widget build(BuildContext context) {
    print('AppError: $message');
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        if (onRetry != null) ElevatedButton(onPressed: onRetry, child: Text('Retry'))
      ]),
    );
  }
}
