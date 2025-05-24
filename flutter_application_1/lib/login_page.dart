import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'create_account.dart';
import 'auth_service.dart';
import 'unverified_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  bool _rememberMe =
      true; // Logika "Remember Me" belum diimplementasikan sepenuhnya
  bool _isLoading = false; // <-- 2. Tambahkan state untuk loading

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService =
      AuthService(); // <-- 3. Instansiasi AuthService

  @override
  void dispose() {
    _emailController.dispose(); // <-- 4. Dispose controller
    _passwordController.dispose();
    super.dispose();
  }

  void _showAlert(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  void _showSnackBar(String message, {bool success = false}) {
    if (!mounted) return; // Pastikan widget masih ada di tree
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.redAccent,
        duration:
            const Duration(seconds: 3), // Sedikit lebih lama untuk pesan error
      ),
    );
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showAlert('Email dan password harus diisi');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      // Check verification status after successful login
      final isVerified = await _authService.isEmailVerified();

      if (!mounted) return;

      if (!isVerified) {
        // Navigate to unverified page if email is not verified
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UnverifiedPage(),
          ),
        );
      } else {
        // Navigate to dashboard if email is verified
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardPage(),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showAlert(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'data/gambar2.png', // Pastikan path asset ini benar
                  height: 40,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 40), // Fallback jika gambar tidak ada
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Hi, Welcome! 👋',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 32),
              const Text("Email address"),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                enabled: !_isLoading, // Disable saat loading
              ),
              const SizedBox(height: 16),
              const Text("Password"),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                enabled: !_isLoading, // Disable saat loading
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            // Disable saat loading
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                    activeColor: Colors.black,
                  ),
                  const Text('Remember me'),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor:
                        Colors.grey.shade400, // Warna saat tombol disable
                  ),
                  onPressed:
                      _isLoading ? null : _login, // Disable tombol saat loading
                  child: _isLoading
                      ? const SizedBox(
                          // <-- 8. Tampilkan CircularProgressIndicator
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () {
                          // Disable saat loading
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateAccountPage(),
                            ),
                          );
                        },
                  child: const Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
