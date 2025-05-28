import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage>
    with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  List<Map<String, dynamic>> _riwayatData = [];
  bool _isLoading = true;
  String? _error;

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
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final userData = await _authService.getUserProfile();
      final userId = userData['id'];

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/riwayat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          setState(() {
            _riwayatData =
                List<Map<String, dynamic>>.from(responseData['riwayat']);
            _isLoading = false;
          });
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load riwayat');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load riwayat');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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
        backgroundColor: Color(0xFF7886C7),
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
                if (_isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_error != null)
                  Expanded(
                    child: Center(
                      child: Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                else if (_riwayatData.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text('Belum ada riwayat klasifikasi'),
                    ),
                  )
                else
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
                          rows: _riwayatData.map((riwayat) {
                            return DataRow(cells: [
                              DataCell(Text(riwayat['name'] ?? '')),
                              DataCell(Text('${riwayat['age'] ?? ''}')),
                              DataCell(Text(
                                  (int.tryParse(riwayat['sex'].toString()) ??
                                              0) ==
                                          1
                                      ? 'Laki-Laki'
                                      : 'Wanita')),
                              DataCell(Text(_getChestPainType(riwayat['cp']))),
                              DataCell(
                                  Text('${riwayat['trestbps'] ?? ''} mmHg')),
                              DataCell(Text('${riwayat['chol'] ?? ''} mg/dL')),
                              DataCell(Text('${riwayat['thalach'] ?? ''} bpm')),
                              DataCell(Text(
                                  (int.tryParse(riwayat['exang'].toString()) ??
                                              0) ==
                                          1
                                      ? 'Iya'
                                      : 'Tidak')),
                              DataCell(
                                Text(
                                  riwayat['hasil'] ?? '',
                                  style: TextStyle(
                                    color: (riwayat['hasil'] ?? '')
                                            .toLowerCase()
                                            .contains('positif')
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

  String _getChestPainType(dynamic cp) {
    int cpInt = int.tryParse(cp.toString()) ?? 0;
    switch (cpInt) {
      case 1:
        return 'Typical Angina';
      case 2:
        return 'Atypical Angina';
      case 3:
        return 'Non-anginal Pain';
      case 4:
        return 'Asymptomatic';
      default:
        return 'Unknown';
    }
  }
}
