import 'package:flutter/material.dart';

class ReGreenLogo extends StatelessWidget {
  const ReGreenLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.recycling,
          size: 80,
          color: Colors.green,
        ),
        const SizedBox(height: 8),
        const Text(
          'ReGreen',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const Text(
          'Bank Sampah',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}