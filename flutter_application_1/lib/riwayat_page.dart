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
      'tekanan': 130,
      'kolesterol': 250,
      'status': 'Positif',
    },
    {
      'nama': 'Amba Singh',
      'usia': 39,
      'tekanan': 120,
      'kolesterol': 190,
      'status': 'Negatif',
    },
    {
      'nama': 'Cik Dayat',
      'usia': 50,
      'tekanan': 145,
      'kolesterol': 300,
      'status': 'Positif',
    },
    {
      'nama': 'Wanto',
      'usia': 60,
      'tekanan': 110,
      'kolesterol': 180,
      'status': 'Negatif',
    },
    {
      'nama': 'Tono',
      'usia': 55,
      'tekanan': 140,
      'kolesterol': 280,
      'status': 'Positif',
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
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeIn,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Riwayat Pemeriksaan",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
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
                        DataColumn(label: Text('Nama Pasien')),
                        DataColumn(label: Text('Usia')),
                        DataColumn(label: Text('Tekanan Darah')),
                        DataColumn(label: Text('Kolesterol')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: dataPasien.map((pasien) {
                        return DataRow(cells: [
                          DataCell(Text(pasien['nama'])),
                          DataCell(Text('${pasien['usia']}')),
                          DataCell(Text('${pasien['tekanan']} mmHg')),
                          DataCell(Text('${pasien['kolesterol']} mg/dL')),
                          DataCell(
                            Text(
                              pasien['status'],
                              style: TextStyle(
                                color: pasien['status'] == 'Positif'
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
    );
  }
}
