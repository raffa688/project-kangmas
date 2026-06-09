import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Gunakan IP Laptop Anda agar bisa diakses dari HP asli atau Emulator
  static const String baseUrl = 'http://10.60.13.88:8000/api';

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> get(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _processResponse(response);
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  static Future<dynamic> patch(String endpoint, [Map<String, dynamic>? body]) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _processResponse(response);
  }

  static Future<dynamic> delete(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _processResponse(response);
  }

  static dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Decode successful JSON response
      return jsonDecode(response.body);
    } else {
      // Decode error response
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Unknown error occurred');
      } catch (e) {
        throw Exception('Server error: ${response.statusCode}');
      }
    }
  }
}
