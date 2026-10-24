import 'package:flutter/material.dart';

class EducationDetailView extends StatelessWidget {
  const EducationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Detail Edukasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFC4A882),
                image: DecorationImage(
                  image: AssetImage(
                    'design/plastik.jpg',
                  ), // bisa diganti gambar edukasi
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  ),
                ),
              ),
            ),

            // Konten Artikel
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'EDUKASI',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Judul
                  const Text(
                    'Cara Tepat Memilah Sampah Plastik PET Agar Bernilai Tinggi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Metadata
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '3 menit membaca',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '22 Okt 2026',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Divider(height: 24, thickness: 1),

                  // Isi Artikel
                  const Text(
                    'Sampah plastik PET (Polyethylene Terephthalate) merupakan salah satu jenis plastik yang paling banyak didaur ulang di dunia. Namun, tidak semua plastik PET memiliki nilai jual yang sama. Berikut adalah cara tepat memilahnya agar bernilai tinggi:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildStep(
                    context,
                    '1',
                    'Pisahkan Tutup Botol',
                    'Tutup botol biasanya terbuat dari plastik PP atau HDPE yang berbeda dengan badan botol PET. Memisahkannya akan meningkatkan kemurnian dan nilai jual.',
                  ),
                  const SizedBox(height: 12),
                  _buildStep(
                    context,
                    '2',
                    'Lepaskan Segel & Label',
                    'Segel label dan stiker dapat mengurangi kualitas daur ulang. Lepaskan sebisa mungkin sebelum dipadatkan.',
                  ),
                  const SizedBox(height: 12),
                  _buildStep(
                    context,
                    '3',
                    'Bilas & Keringkan',
                    'Pastikan botol dalam kondisi bersih dan kering. Botol yang masih berisi cairan akan mengurangi berat bersih dan berisiko menimbulkan bau.',
                  ),
                  const SizedBox(height: 12),
                  _buildStep(
                    context,
                    '4',
                    'Padatkan Tanpa Merusak',
                    'Tekan botol untuk mengurangi volume, namun jangan sampai pecah. Botol utuh lebih mudah diproses di pabrik daur ulang.',
                  ),

                  const SizedBox(height: 24),

                  // Tips Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: Colors.green[800],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tips REGREEN',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Botol PET yang bersih dan terpisah tutupnya bisa dihargai hingga 2x lipat lebih tinggi!',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    String number,
    String title,
    String desc,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFF2E7D32),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
