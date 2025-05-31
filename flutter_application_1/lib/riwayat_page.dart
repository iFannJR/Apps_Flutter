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
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final userData = await _authService.getUserProfile();
      final userId = userData['id'];

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/riwayat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'user_id': userId}),
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

  Future<void> _hapusRiwayat(String id) async {
    // Konfirmasi penghapusan
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus riwayat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
  //hapus riwayat
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final deleteResponse = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/riwayat/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (deleteResponse.statusCode == 200) {
        final Map<String, dynamic> deleteData =
            jsonDecode(deleteResponse.body);
        if (deleteData['status'] == 'success') {
          // Berhasil dihapus → reload
          await _loadRiwayat();
        } else {
          throw Exception(deleteData['message'] ?? 'Failed to delete riwayat');
        }
      } else if (deleteResponse.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        final Map<String, dynamic> err = jsonDecode(deleteResponse.body);
        throw Exception(err['message'] ?? 'Failed to delete riwayat');
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

  String _getChestPainType(dynamic cp) {
    int cpInt = int.tryParse(cp.toString()) ?? -1;
    switch (cpInt) {
      case 0:
        return 'Typical Angina';
      case 1:
        return 'Atypical Angina';
      case 2:
        return 'Non-anginal Pain';
      case 3:
        return 'Asymptomatic';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7886C7),
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
                      // Scroll horizontal
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: 
                          // Scroll vertical
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columnSpacing: 20,
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
                                DataColumn(label: Text('')), // Kolom untuk Delete
                              ],
                              rows: _riwayatData.map((riwayat) {
                                // Ambil ID sebagai String
                                final dynamic rawId = riwayat['id'];
                                final String? id =
                                    (rawId != null) ? rawId.toString() : null;

                                return DataRow(cells: [
                                  DataCell(Text(riwayat['name'] ?? '')),
                                  DataCell(Text('${riwayat['age'] ?? ''}')),
                                  DataCell(Text(
                                    (int.tryParse(riwayat['sex'].toString()) ??
                                                0) ==
                                            1
                                        ? 'Laki-Laki'
                                        : 'Perempuan',
                                  )),
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
                                        : 'Tidak',
                                  )),
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
                                  DataCell(
                                    id != null
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () {
                                              _hapusRiwayat(id);
                                            },
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ]);
                              }).toList(),
                            ),
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
