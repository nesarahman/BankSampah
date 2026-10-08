import 'package:flutter/material.dart';

class PickupView extends StatelessWidget {
  const PickupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jemput Sampah'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delivery_dining, size: 60, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Halaman Jemput Sampah',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('(Tugas Hadjija)', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
