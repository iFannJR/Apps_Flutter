import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'package:animate_do/animate_do.dart';
import 'login_page.dart';
import 'create_account.dart';
import 'auth_service.dart';
import 'unverified_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _isAuthenticated = false;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      // First check if we have a token
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _isAuthenticated = false;
          _isVerified = false;
          _isLoading = false;
        });
        return;
      }

      // If we have a token, get the user profile directly
      try {
        final profile = await _authService.getUserProfile();
        final isVerified = profile['verified'] == true;

        setState(() {
          _isAuthenticated = true;
          _isVerified = isVerified;
          _isLoading = false;
        });
      } catch (e) {
        print('Error getting user profile: $e');
        // If we can't get the profile, assume not verified
        setState(() {
          _isAuthenticated = true;
          _isVerified = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error in auth state check: $e');
      // If anything goes wrong, clear everything
      await _authService.logout();
      setState(() {
        _isAuthenticated = false;
        _isVerified = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isAuthenticated) {
      return const LandingPage();
    }

    if (!_isVerified) {
      return const UnverifiedPage();
    }

    return const DashboardPage();
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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
                  'HeartGuard',
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
                  'Pendamping cerdas Anda untuk manajemen Jantung anda',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 3),

              // Login Button
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7886C7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Register Button
              FadeInUp(
                duration: const Duration(milliseconds: 1500),
                child: SizedBox(
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D336B),
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
