import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

// animasinya menggunakan FadeInUp
class EdukasiDetailJenisOlahragaPage extends StatelessWidget {
  const EdukasiDetailJenisOlahragaPage({super.key});

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
                        'Jenis Olahraga yang Umumnya Aman dan Direkomendasikan:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildBulletPoint(
                        'Jalan kaki: Olahraga ringan yang mudah dilakukan dan baik untuk meningkatkan kesehatan jantung. Bisa dilakukan dengan santai atau lebih cepat.',
                      ),
                      _buildBulletPoint(
                        'Berenang: Olahraga dengan dampak rendah yang melibatkan banyak otot dan baik untuk kardiovaskular.',
                      ),
                      _buildBulletPoint(
                        'Bersepeda: Dapat memperkuat otot jantung dan melancarkan sirkulasi darah. Pilih intensitas yang ringan atau sedang.',
                      ),
                      _buildBulletPoint(
                        'Yoga dan Tai Chi: Latihan dengan gerakan lambat yang dapat membantu mengelola stres, meningkatkan fleksibilitas, dan baik untuk kesehatan jantung.',
                      ),
                      _buildBulletPoint(
                        'Senam jantung: Dirancang khusus untuk menjaga dan meningkatkan performa jantung.',
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
