import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://172.16.1.177:8080/api/v1'; // Replace with your API URL
  static const storage = FlutterSecureStorage();

  static Future<http.Response> signUp(String fullname, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fullname': fullname, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return response;
    } else {
      throw Exception('Signup failed: ${response.reasonPhrase}');
    }
  }

  static Future<bool> verifyOTP(String email, String otp) async {
    final url = Uri.parse('$baseUrl/auth/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false; // Failure: "Invalid OTP!"
    } else {
      throw Exception('OTP verification failed: ${response.reasonPhrase}');
    }
  }

  static Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/signin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await storage.write(key: 'jwt_token', value: token);
      return token;
    } else {
      throw Exception('Login failed: ${response.reasonPhrase}');
    }
  }

  static Future<bool> requestPasswordReset(String email) async {
    final url = Uri.parse('$baseUrl/auth/forget-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return true; // OTP sent successfully
    } else if (response.statusCode == 400) {
      return false; // Email not found or other error
    } else {
      throw Exception('Password reset request failed: ${response.reasonPhrase}');
    }
  }

  static Future<bool> resetPassword(String email, String otp, String newPassword) async {
    final url = Uri.parse('$baseUrl/auth/reset-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp, 'newPassword': newPassword}),
    );

    if (response.statusCode == 200) {
      return true; // "Password reset successfully."
    } else if (response.statusCode == 400) {
      return false; // "Invalid or expired OTP."
    } else {
      throw Exception('Password reset failed: ${response.reasonPhrase}');
    }
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  static Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }
}