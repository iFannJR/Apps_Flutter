import 'package:flutter/material.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final List<Map<String, String>> dataPasien = [
    {'nama': 'Rudi', 'status': 'Diabetes'},
    {'nama': 'Amba singh', 'status': 'Tidak'},
    {'nama': 'Cik dayat', 'status': 'Diabetes'},
    {'nama': 'Wanto', 'status': 'Tidak'},
    {'nama': 'Tono', 'status': 'Diabetes'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      DataColumn(
                        label: Text('Nama Pasien',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Status Diabetes',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: dataPasien.map((pasien) {
                      return DataRow(cells: [
                        DataCell(Text(pasien['nama']!)),
                        DataCell(
                          Text(
                            pasien['status'] == 'Diabetes'
                                ? 'Diabetes'
                                : 'Tidak',
                            style: TextStyle(
                              color: pasien['status'] == 'Diabetes'
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.w600,
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
    );
  }
}
