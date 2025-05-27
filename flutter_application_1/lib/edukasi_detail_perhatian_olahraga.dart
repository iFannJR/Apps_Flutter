import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

// animasinya menggunakan FadeInUp
class EdukasiDetailPerhatianOlahragaPage extends StatelessWidget {
  const EdukasiDetailPerhatianOlahragaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Color(0xFF2D336B),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Detail Edukasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hal yang Perlu Diperhatikan Sebelum dan Saat Berolahraga:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildBulletPoint(
                        'Konsultasi dengan dokter: Sangat penting untuk berkonsultasi dengan dokter sebelum memulai program olahraga baru. Dokter dapat memberikan rekomendasi jenis dan intensitas olahraga yang aman sesuai dengan kondisi jantung Anda.',
                      ),
                      _buildBulletPoint(
                        'Pemanasan dan pendinginan: Selalu lakukan pemanasan sebelum berolahraga dan pendinginan setelahnya.',
                      ),
                      _buildBulletPoint(
                        'Mulai secara bertahap: Jangan memaksakan diri, mulailah dengan intensitas rendah dan durasi singkat, lalu tingkatkan secara perlahan sesuai kemampuan.',
                      ),
                      _buildBulletPoint(
                        'Perhatikan gejala: Hentikan olahraga segera jika Anda merasakan nyeri dada, sesak napas berlebihan, pusing, atau detak jantung tidak teratur. Segera konsultasikan dengan dokter jika gejala tersebut muncul.',
                      ),
                      _buildBulletPoint(
                        'Hindari olahraga berat: Olahraga dengan intensitas tinggi atau kompetitif seperti sepak bola, bola basket, atau bulu tangkis umumnya tidak disarankan.',
                      ),
                      _buildBulletPoint(
                        'Perhatikan waktu: Sebaiknya berolahraga di pagi hari saat tubuh lebih segar.',
                      ),
                      _buildBulletPoint(
                        'Cukupi cairan: Pastikan minum air yang cukup sebelum, selama, dan setelah berolahraga.',
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("▪ ", style: TextStyle(fontSize: 20)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
