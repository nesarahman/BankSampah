import 'package:flutter/material.dart';

class GoogleAuthSheet extends StatefulWidget {
  final Function(String nama, String email, String? avatarUrl) onAccountSelected;

  const GoogleAuthSheet({super.key, required this.onAccountSelected});

  static void show(
    BuildContext context, {
    required Function(String nama, String email, String? avatarUrl) onAccountSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GoogleAuthSheet(onAccountSelected: onAccountSelected),
    );
  }

  @override
  State<GoogleAuthSheet> createState() => _GoogleAuthSheetState();
}

class _GoogleAuthSheetState extends State<GoogleAuthSheet> {
  bool _showCustomInput = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final List<Map<String, String>> _savedAccounts = [
    {
      'nama': 'Nesa Rahman',
      'email': 'seannesa2@gmail.com',
      'avatarColor': '0xFF34A853', // Google Green
      'initial': 'N',
    },
    {
      'nama': 'Rizky Pratama',
      'email': 'nesa@regreen.com',
      'avatarColor': '0xFF4285F4', // Google Blue
      'initial': 'R',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 16,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Google Logo Header
            Row(
              children: [
                _buildGoogleLogo(size: 28),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih akun Google',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'untuk melanjutkan ke REGREEN',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),

            if (!_showCustomInput) ...[
              // List Akun Google yang Tersedia
              ..._savedAccounts.map((acc) {
                final color = Color(int.parse(acc['avatarColor']!));
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  leading: CircleAvatar(
                    backgroundColor: color,
                    child: Text(
                      acc['initial']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  title: Text(
                    acc['nama']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    acc['email']!,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                  onTap: () {
                    widget.onAccountSelected(
                      acc['nama']!,
                      acc['email']!,
                      'https://api.dicebear.com/7.x/initials/png?seed=${Uri.encodeComponent(acc['nama']!)}&backgroundColor=2e7d32',
                    );
                  },
                );
              }),

              const Divider(),

              // Opsi Tambah Akun Lain
              ListTile(
                contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade100,
                  child: const Icon(Icons.person_add_alt_1, color: Colors.black87),
                ),
                title: const Text(
                  'Gunakan akun Google lain',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                subtitle: const Text(
                  'Ketik nama & email Google Anda',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  setState(() {
                    _showCustomInput = true;
                  });
                },
              ),
            ] else ...[
              // Form Input Akun Custom
              const Text(
                'Masukkan Akun Google Anda',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap Akun Google',
                  hintText: 'Contoh: Sean Nesa',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Alamat Gmail',
                  hintText: 'nama@gmail.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _showCustomInput = false;
                        });
                      },
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final nama = _nameController.text.trim();
                        final email = _emailController.text.trim();
                        if (nama.isEmpty || email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Nama dan Email harus diisi!'),
                            ),
                          );
                          return;
                        }
                        if (!email.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Format email tidak valid!'),
                            ),
                          );
                          return;
                        }
                        widget.onAccountSelected(
                          nama,
                          email,
                          'https://api.dicebear.com/7.x/initials/png?seed=${Uri.encodeComponent(nama)}&backgroundColor=2e7d32',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4285F4),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Lanjutkan'),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),
            Center(
              child: Text(
                'Untuk melanjutkan, Google akan membagikan nama, alamat email, dan preferensi profil Anda kepada REGREEN.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static Widget _buildGoogleLogo({double size = 24}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            color: const Color(0xFF4285F4),
            fontSize: size * 0.7,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
