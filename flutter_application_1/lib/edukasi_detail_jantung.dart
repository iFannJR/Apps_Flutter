import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
// import 'edukasi_page.dart';

class EdukasiDetailJantungPage extends StatelessWidget {
  const EdukasiDetailJantungPage({super.key});

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
              color: Colors.black,
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
                        'Pentingnya Olahraga bagi Penderita Penyakit Jantung:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildBulletPoint(
                        'Memperkuat jantung: Olahraga teratur dapat membantu memperkuat otot jantung, sehingga jantung dapat memompa darah lebih efisien.',
                      ),
                      _buildBulletPoint(
                        'Meningkatkan sirkulasi darah: Aktivitas fisik membantu melancarkan aliran darah ke seluruh tubuh.',
                      ),
                      _buildBulletPoint(
                        'Mengendalikan berat badan: Olahraga membantu membakar kalori dan menjaga berat badan yang sehat, yang penting untuk kesehatan jantung.',
                      ),
                      _buildBulletPoint(
                        'Mengurangi stres: Aktivitas fisik dapat membantu mengurangi stres dan meningkatkan suasana hati.',
                      ),
                      _buildBulletPoint(
                        'Menurunkan tekanan darah dan kolesterol: Beberapa jenis olahraga dapat membantu menurunkan tekanan darah tinggi dan kadar kolesterol jahat (LDL).',
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
