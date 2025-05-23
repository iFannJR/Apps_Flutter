import 'package:flutter/material.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> dataPasien = [
    {
      'nama': 'Rudi',
      'usia': 45,
      'jenis_kelamin': 'Laki-Laki',
      'tipe_nyeri': 'Typical Angina',
      'tekanan_darah': 130,
      'kolesterol': 250,
      'detak_jantung': 150,
      'nyeri_olahraga': 'Iya',
      'hasil': 'Positif',
    },
    {
      'nama': 'Amba Singh',
      'usia': 39,
      'jenis_kelamin': 'Laki-Laki',
      'tipe_nyeri': 'Atypical Angina',
      'tekanan_darah': 120,
      'kolesterol': 190,
      'detak_jantung': 140,
      'nyeri_olahraga': 'Tidak',
      'hasil': 'Negatif',
    },
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Riwayat Klasifikasi',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Usia')),
                          DataColumn(label: Text('Jenis Kelamin')),
                          DataColumn(label: Text('Tipe Nyeri')),
                          DataColumn(label: Text('Tekanan Darah')),
                          DataColumn(label: Text('Kolesterol')),
                          DataColumn(label: Text('Detak Jantung')),
                          DataColumn(label: Text('Nyeri Olahraga')),
                          DataColumn(label: Text('Hasil')),
                        ],
                        rows: dataPasien.map((pasien) {
                          return DataRow(cells: [
                            DataCell(Text(pasien['nama'])),
                            DataCell(Text('${pasien['usia']}')),
                            DataCell(Text(pasien['jenis_kelamin'])),
                            DataCell(Text(pasien['tipe_nyeri'])),
                            DataCell(Text('${pasien['tekanan_darah']} mmHg')),
                            DataCell(Text('${pasien['kolesterol']} mg/dL')),
                            DataCell(Text('${pasien['detak_jantung']} bpm')),
                            DataCell(Text(pasien['nyeri_olahraga'])),
                            DataCell(
                              Text(
                                pasien['hasil'],
                                style: TextStyle(
                                  color: pasien['hasil'] == 'Positif'
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
