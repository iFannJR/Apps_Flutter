import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

// animasinya menggunakan FadeInUp
class EdukasiDetailProgramRinganPage extends StatelessWidget {
  const EdukasiDetailProgramRinganPage({super.key});

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
                        'Contoh Program Olahraga Ringan:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildBulletPoint(
                        'Hari 1–3: Jalan kaki santai selama 15–20 menit.',
                      ),
                      _buildBulletPoint(
                        'Hari 4–6: Bersepeda santai atau berenang selama 20–25 menit.',
                      ),
                      _buildBulletPoint(
                        'Lakukan ini beberapa kali seminggu dan secara bertahap tingkatkan durasi dan intensitasnya sesuai dengan anjuran dokter dan kemampuan tubuh Anda.',
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
