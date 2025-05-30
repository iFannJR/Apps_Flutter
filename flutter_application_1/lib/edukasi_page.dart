import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'edukasi_detail_jantung.dart';
import 'edukasi_detail_jenis_olahraga.dart';
import 'edukasi_detail_perhatian_olahraga.dart';
import 'edukasi_detail_program_ringan.dart';

class EdukasiPage extends StatefulWidget {
  const EdukasiPage({super.key});

  @override
  State<EdukasiPage> createState() => _EdukasiPageState();
}

class _EdukasiPageState extends State<EdukasiPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> edukasiList = [
    {
      'title': 'Pentingnya Olahraga bagi Penderita Penyakit Jantung:',
      'color': Color(0xFF7886C7),
    },
    {
      'title': 'Jenis Olahraga yang Umumnya Aman dan Direkomendasikan:',
      'color': Color(0xFF7886C7),
    },
    {
      'title': 'Hal yang Perlu Diperhatikan Sebelum dan Saat Berolahraga:',
      'color': Color(0xFF7886C7),
    },
    {
      'title': 'Contoh Program Olahraga Ringan:',
      'color': Color(0xFF7886C7),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter edukasi sesuai query
    final filteredEdukasi = _searchQuery.isEmpty
        ? edukasiList
        : edukasiList
            .where((item) => item['title']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header + Search bar
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              decoration: const BoxDecoration(
                color: Color(0xFF2D336B),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Edukasi",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF7886C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.tune, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Search bar (sama seperti dashboard)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white70),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            style: const TextStyle(color: Colors.white54),
                            decoration: const InputDecoration.collapsed(
                              hintText: "Cari edukasi...",
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Konten edukasi
            Expanded(
              child: filteredEdukasi.isEmpty
                  ? const Center(child: Text('Tidak ada hasil ditemukan'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredEdukasi.length,
                      itemBuilder: (context, index) {
                        final item = filteredEdukasi[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: 200 * index),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: item['color'],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    item['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2D336B),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (index == 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EdukasiDetailJantungPage(),
                                        ),
                                      );
                                    } else if (index == 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EdukasiDetailJenisOlahragaPage(),
                                        ),
                                      );
                                    } else if (index == 2) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EdukasiDetailPerhatianOlahragaPage(),
                                        ),
                                      );
                                    } else if (index == 3) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EdukasiDetailProgramRinganPage(),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "PELAJARI LEBIH LANJUT",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Tombol kembali
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2D336B),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
