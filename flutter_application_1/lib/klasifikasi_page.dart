import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KlasifikasiPage extends StatefulWidget {
  const KlasifikasiPage({super.key});

  @override
  State<KlasifikasiPage> createState() => _KlasifikasiPageState();
}

class _KlasifikasiPageState extends State<KlasifikasiPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  String? _gender;
  String? _chestPainType;
  String? _exerciseInducedAngina;

  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cholesterolController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeIn = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bloodPressureController.dispose();
    _heartRateController.dispose();
    _ageController.dispose();
    _cholesterolController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // Tanggal
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_selectedDate == null
                      ? "Pilih Tanggal"
                      : DateFormat('dd MMM yyyy').format(_selectedDate!)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),

                const SizedBox(height: 10),

                // Jenis Kelamin
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                  value: _gender,
                  items: ['Cowok', 'Cewek'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (val) => setState(() => _gender = val),
                ),

                const SizedBox(height: 10),

                // Tipe Nyeri Dada
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Tipe Nyeri Dada'),
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
                ),

                const SizedBox(height: 10),

                // Kolesterol
                TextFormField(
                  controller: _cholesterolController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Kadar Kolesterol (mg/dl)'),
                ),

                const SizedBox(height: 10),

                // Tekanan Darah
                TextFormField(
                  controller: _bloodPressureController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Tekanan Darah Saat Istirahat (mm Hg)'),
                ),

                const SizedBox(height: 10),

                // Detak Jantung Maksimum
                TextFormField(
                  controller: _heartRateController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Detak Jantung Maksimum'),
                ),

                const SizedBox(height: 10),

                // Usia
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Usia'),
                ),

                const SizedBox(height: 10),

                // Nyeri Dada Saat Olahraga
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Nyeri Dada Saat Olahraga'),
                  value: _exerciseInducedAngina,
                  items: ['Iya', 'Tidak'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => _exerciseInducedAngina = val),
                ),

                const SizedBox(height: 24),

                // Tombol Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Tambahkan logika klasifikasi di sini
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Memproses Data Klasifikasi...")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Klasifikasikan",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
