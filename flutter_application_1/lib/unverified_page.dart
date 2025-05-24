import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'auth_service.dart';
import 'main.dart';

class UnverifiedPage extends StatefulWidget {
  const UnverifiedPage({super.key});

  @override
  State<UnverifiedPage> createState() => _UnverifiedPageState();
}

class _UnverifiedPageState extends State<UnverifiedPage> {
  bool _isLoading = false;
  bool _isCheckingVerification = false;
  final AuthService _authService = AuthService();

  void _showAlert(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  Future<void> _resendVerification() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.resendVerification();
      _showAlert(
          'Email verifikasi telah dikirim ulang. Silakan cek email Anda.',
          isError: false);
    } catch (e) {
      _showAlert(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkVerificationStatus() async {
    setState(() {
      _isCheckingVerification = true;
    });

    try {
      // Force logout and login again to get fresh token
      final token = await _authService.getToken();
      if (token != null) {
        // Get fresh user profile to check verification status
        final profile = await _authService.getUserProfile();
        final isVerified = profile['verified'] == true;

        if (isVerified) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthWrapper(),
            ),
          );
        } else {
          _showAlert('Email belum diverifikasi. Silakan cek email Anda.');
        }
      } else {
        _showAlert('Sesi Anda telah berakhir. Silakan login kembali.');
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthWrapper(),
          ),
        );
      }
    } catch (e) {
      _showAlert(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingVerification = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Animated logo
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Image.asset(
                  'data/gambar1.png',
                  width: 300,
                  height: 300,
                ),
              ),
              const SizedBox(height: 48),

              // Animated title
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  'Verifikasi Email',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Animated subtitle
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: const Text(
                  'Silakan cek email Anda untuk verifikasi akun. Setelah terverifikasi, Anda dapat login ke aplikasi.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 1),

              // Check Verification Button
              FadeInUp(
                duration: const Duration(milliseconds: 1250),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _isCheckingVerification
                        ? null
                        : _checkVerificationStatus,
                    child: _isCheckingVerification
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Cek Status Verifikasi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Resend Verification Button
              FadeInUp(
                duration: const Duration(milliseconds: 1300),
                child: Column(
                  children: [
                    const Text(
                      'Tidak menerima email?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Colors.black),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isLoading ? null : _resendVerification,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              )
                            : const Text(
                                'Kirim Ulang Email',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),

              // Back to Login Button
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () async {
                      final authService = AuthService();
                      await authService.logout();
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthWrapper(),
                        ),
                      );
                    },
                    child: const Text(
                      'Kembali ke Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
