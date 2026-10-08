
import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Foto profil
            const CircleAvatar(
              radius: 55,
              child: Icon(
                Icons.person,
                size: 60,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Nama Nasabah',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'nasabah@regreen.com',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // Informasi profil
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Nama Lengkap'),
                    subtitle: const Text('Nama Nasabah'),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: const Text('nasabah@regreen.com'),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.phone_outlined),
                    title: const Text('Nomor Telepon'),
                    subtitle: const Text('08xxxxxxxxxx'),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text('Alamat'),
                    subtitle: const Text('Alamat Nasabah'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Tombol edit
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur edit profil belum tersedia'),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
            ),

            const SizedBox(height: 15),

            // Tombol logout
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.login,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

