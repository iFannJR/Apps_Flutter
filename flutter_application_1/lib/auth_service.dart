import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String _baseUrl = 'http://127.0.0.1:8000/api';
  final _storage = const FlutterSecureStorage();
  final _client = http.Client();
  static const _timeout = Duration(seconds: 10);

  // Token management
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> _deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // HTTP request helper
  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Error handling helper
  String _handleErrorResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('message')) {
        return data['message'].toString();
      }
    } catch (e) {
      print('Error parsing error response: $e');
    }
    return 'An error occurred: ${response.statusCode}';
  }

  // Registration
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/sanctum/register'),
            headers: await _getHeaders(requiresAuth: false),
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'password_confirmation': passwordConfirmation,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(_handleErrorResponse(response));
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: ${e.message}');
      }
      rethrow;
    }
  }

  // Login
  Future<Map<String, dynamic>> login(
    String email,
    String password, {
    String? deviceName,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/sanctum/token'),
            headers: await _getHeaders(requiresAuth: false),
            body: jsonEncode({
              'email': email,
              'password': password,
              if (deviceName != null) 'device_name': deviceName,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('token')) {
          await _saveToken(data['token']);
        }
        return data;
      } else if (response.statusCode == 401) {
        final data = jsonDecode(response.body);
        if (data['message']?.toString().toLowerCase().contains('unverified') ??
            false) {
          throw Exception('Email belum diverifikasi. Silakan cek email Anda.');
        }
        throw Exception('Email atau password salah.');
      } else {
        throw Exception(_handleErrorResponse(response));
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: ${e.message}');
      }
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return;

    try {
      await _client
          .get(
            Uri.parse('$_baseUrl/user/revoke'),
            headers: await _getHeaders(),
          )
          .timeout(_timeout);
    } catch (e) {
      print('Error logging out from server: $e');
    } finally {
      await _deleteToken();
    }
  }

  // Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/user'),
            headers: await _getHeaders(),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data == null ||
            !(data is Map) ||
            !data.containsKey('id') ||
            !data.containsKey('name') ||
            !data.containsKey('email') ||
            !data.containsKey('verified')) {
          throw Exception('Invalid user profile data received from server');
        }
        return Map<String, dynamic>.from(data);
      } else if (response.statusCode == 401) {
        await _deleteToken();
        throw Exception(
            'Unauthorized (401): Token invalid or expired. Please login again.');
      } else {
        throw Exception(_handleErrorResponse(response));
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: ${e.message}');
      }
      rethrow;
    }
  }

  // Check email verification status
  Future<bool> isEmailVerified() async {
    try {
      final profile = await getUserProfile();
      return profile['verified'] == true;
    } catch (e) {
      print('Error checking email verification: $e');
      return false;
    }
  }

  // Resend verification email
  Future<void> resendVerification() async {
    try {
      final profile = await getUserProfile();
      final email = profile['email'];
      if (email == null) {
        throw Exception('Email not found in user profile');
      }

      final response = await _client
          .post(
            Uri.parse('$_baseUrl/resend'),
            headers: await _getHeaders(),
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception(_handleErrorResponse(response));
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: ${e.message}');
      }
      rethrow;
    }
  }

  // Send verification email
  Future<void> sendVerificationEmail(String email) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/resend'),
            headers: await _getHeaders(),
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception(_handleErrorResponse(response));
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: ${e.message}');
      }
      rethrow;
    }
  }

  // Dispose
  void dispose() {
    _client.close();
  }
}
