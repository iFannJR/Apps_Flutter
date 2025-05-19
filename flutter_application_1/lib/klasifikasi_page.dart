import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class KlasifikasiPage extends StatefulWidget {
  const KlasifikasiPage({super.key});

  @override
  State<KlasifikasiPage> createState() => _KlasifikasiPageState();
}

class _KlasifikasiPageState extends State<KlasifikasiPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  String? _gender;
  String? _chestPainType;
  String? _exerciseInducedAngina;

  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cholesterolController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeIn;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeIn =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bloodPressureController.dispose();
    _heartRateController.dispose();
    _ageController.dispose();
    _cholesterolController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Prepare data to send
        final Map<String, dynamic> data = {
          'name': _nameController.text,
          'age': int.tryParse(_ageController.text) ?? 0,
          'sex': _gender == 'Laki-Laki' ? 1 : 0,
          'cp': _getChestPainTypeValue(),
          'trestbps': int.tryParse(_bloodPressureController.text) ?? 0,
          'chol': int.tryParse(_cholesterolController.text) ?? 0,
          'thalach': int.tryParse(_heartRateController.text) ?? 0,
          'exang': _exerciseInducedAngina == 'Iya' ? 1 : 0,
        };

        // Send data to API
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/klasifikasi'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final hasil = responseData['hasil']?.toString() ??
              'Tidak ada hasil dari server';
          _showResultDialog(hasil);
        } else {
          _showErrorDialog(
              'Gagal terhubung dengan server. Status: ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  // Helper method to convert chest pain type to numeric value
  int _getChestPainTypeValue() {
    switch (_chestPainType) {
      case 'Typical Angina':
        return 1;
      case 'Atypical Angina':
        return 2;
      case 'Non-anginal Pain':
        return 3;
      case 'Asymptomatic':
        return 4;
      default:
        return 0;
    }
  }

  // Show result in a dialog
  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hasil Klasifikasi'),
          content: Text(result),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Form Klasifikasi",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // Nama
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'Nama'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan Nama';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Usia
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Usia'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan Usia';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Jenis Kelamin
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: 'Jenis Kelamin'),
                      value: _gender,
                      items: ['Laki-Laki', 'Wanita'].map((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (val) => setState(() => _gender = val),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan pilih jenis kelamin';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Tipe Nyeri Dada
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: 'Tipe Nyeri Dada'),
                      value: _chestPainType,
                      items: [
                        'Typical Angina',
                        'Atypical Angina',
                        'Non-anginal Pain',
                        'Asymptomatic'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (val) => setState(() => _chestPainType = val),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan pilih tipe nyeri dada';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Tekanan Darah
                    TextFormField(
                      controller: _bloodPressureController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Tekanan Darah Saat Istirahat (mm Hg)'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan tekanan darah';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Kolesterol
                    TextFormField(
                      controller: _cholesterolController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Kadar Kolesterol (mg/dl)'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan kadar kolesterol';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Detak Jantung Maksimum
                    TextFormField(
                      controller: _heartRateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Detak Jantung Maksimum (bpm)'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan detak jantung maksimum';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Nyeri Dada Saat Olahraga
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          labelText: 'Nyeri Dada Saat Olahraga'),
                      value: _exerciseInducedAngina,
                      items: ['Iya', 'Tidak'].map((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _exerciseInducedAngina = val),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan pilih status nyeri dada saat olahraga';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Tombol Submit
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                "Klasifikasikan",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
