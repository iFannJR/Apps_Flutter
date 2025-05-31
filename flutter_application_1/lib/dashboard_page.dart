import 'dart:convert';

import 'package:flutter/material.dart';
import 'klasifikasi_page.dart';
import 'edukasi_page.dart';
import 'riwayat_page.dart';
import 'auth_service.dart';
import 'main.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<Widget> get _pages => [
        const KlasifikasiPage(),
        _DashboardHome(
          searchController: _searchController,
          searchQuery: _searchQuery,
          onSearchChanged: _onSearchChanged,
          onNavigate: (index) => setState(() => _selectedIndex = index),
        ),
      ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2D336B),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Klasifikasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize),
              label: 'Dashboard',
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHome extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final Function(int) onNavigate;

  const _DashboardHome({
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onNavigate,
  });

  List<Map<String, dynamic>> get edukasiList => [
        {
          'title': 'Pentingnya Olahraga bagi Penderita Penyakit Jantung:',
          'color': const Color(0xFF7886C7),
        },
        {
          'title': 'Jenis Olahraga yang Umumnya Aman dan Direkomendasikan:',
          'color': const Color(0xFF7886C7),
        },
        {
          'title': 'Hal yang Perlu Diperhatikan Sebelum dan Saat Berolahraga:',
          'color': const Color(0xFF7886C7),
        },
        {
          'title': 'Contoh Program Olahraga Ringan:',
          'color': const Color(0xFF7886C7),
        },
      ];

  @override
  Widget build(BuildContext context) {
    final filteredEdukasi = searchQuery.isEmpty
        ? []
        : edukasiList
            .where((item) => item['title']
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();

    return SafeArea(
      child: Column(
        children: [
          Container(
            color: Color(0xFF2D336B),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Dashboard",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () async {
                        final authService = AuthService();
                        await authService.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthWrapper(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color(0xFF7886C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.white70),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onChanged: onSearchChanged,
                                style: const TextStyle(color: Colors.white54),
                                decoration: const InputDecoration.collapsed(
                                  hintText: "Search",
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFF7886C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (searchQuery.isEmpty) const _TimeWidget(),
                if (searchQuery.isNotEmpty)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: filteredEdukasi.isEmpty
                        ? const Center(child: Text('Tidak ada hasil ditemukan'))
                        : ListView.builder(
                            itemCount: filteredEdukasi.length,
                            itemBuilder: (context, index) {
                              final item = filteredEdukasi[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: item['color'],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => onNavigate(0),
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'data/gambar3.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'KLASIFIKASI',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EdukasiPage(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'data/gambar4.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'EDUKASI',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Riwayat Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RiwayatPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFF7886C7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.history,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Riwayat Klasifikasi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//widget grafik
class _TimeWidget extends StatefulWidget {
  const _TimeWidget({super.key});

  @override
  State<_TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<_TimeWidget> {
  List<Map<String, dynamic>> _riwayatData = [];
  bool _isLoadingRiwayat = true;
  String? _errorRiwayat;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadRiwayatForChart();
  }
  //pemanggilan data grafik
  Future<void> _loadRiwayatForChart() async {
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
        final Map<String, dynamic> dataJson = jsonDecode(response.body);
        if (dataJson['status'] == 'success') {
          setState(() {
            _riwayatData =
                List<Map<String, dynamic>>.from(dataJson['riwayat']);
            _isLoadingRiwayat = false;
          });
        } else {
          throw Exception(dataJson['message'] ?? 'Gagal mengambil riwayat');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        final Map<String, dynamic> err = jsonDecode(response.body);
        throw Exception(err['message'] ?? 'Gagal mengambil riwayat');
      }
    } catch (e) {
      setState(() {
        _errorRiwayat = e.toString();
        _isLoadingRiwayat = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container tanpa height statis supaya parent bisa scroll jika diperlukan
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Riwayat Tekanan & Kolesterol',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D336B),
              ),
            ),
            const SizedBox(height: 12),

            if (_isLoadingRiwayat)
              const Center(child: CircularProgressIndicator())
            else if (_errorRiwayat != null)
              Text(
                'Error chart: $_errorRiwayat',
                style: const TextStyle(color: Colors.red),
              )
            else if (_riwayatData.isEmpty)
              const Text('Belum ada data riwayat untuk chart')
            else
              Column(
                children: [
                  // Poin Penting: kita tetap beri BOUND HEIGHT via SizedBox
                  SizedBox(
                    height: 180, // Tinggi chart tetap (misal 180 piksel)
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: LineChart(
                        LineChartData(
                          // → Atur minY / maxY secara manual
                          minY: 0,
                          maxY: 500,
                          // → Atur interval agar tick berurutan 0,50,100,150,200,250
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                interval: 50, // setiap 50 unit ada label
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(), 
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1, // R1, R2, dst.
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    'R${value.toInt() + 1}',
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            topTitles:
                                AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles:
                                AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          lineBarsData: [
                            _buildLineChartBar('trestbps', Colors.blue),
                            _buildLineChartBar('chol', Colors.orange),
                            _buildLineChartBar('thalach', Colors.green),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Legend(color: Colors.blue, text: 'Tekanan Darah'),
                      SizedBox(width: 16),
                      Legend(color: Colors.orange, text: 'Kolesterol'),
                      SizedBox(width: 16),
                      Legend(color: Colors.green, text: 'Detak Jantung'),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
  //implementasi line chart 
  LineChartBarData _buildLineChartBar(String key, Color color) {
    final spots = <FlSpot>[];
    for (int i = 0; i < _riwayatData.length; i++) {
      final yValue = double.tryParse(_riwayatData[i][key].toString()) ?? 0;
      spots.add(FlSpot(i.toDouble(), yValue));
    }
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      barWidth: 2,
      color: color,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}

class Legend extends StatelessWidget {
  final Color color;
  final String text;

  const Legend({required this.color, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}
