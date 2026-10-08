import 'package:flutter/material.dart';

class DropPointView extends StatelessWidget {
  const DropPointView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drop Point'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 60, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Halaman Drop Point',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('(Tugas Muhajjir)', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
