import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // IP default kalau bener-bener gak ketemu pas scan
  static String _serverIp = '192.168.101.23';

  // URL jadi dinamis, otomatis nyesuain klo di Web atau Mobile
  static String get baseUrl {
    if (kIsWeb) {
      // Di web mah lgsg pake domain/host yg lagi dibuka aja
      return "${Uri.base.scheme}://${Uri.base.host}:${Uri.base.port}/api";
    }
    return 'http://$_serverIp:8000/api';
  }

  static String get storageUrl {
    if (kIsWeb) {
      return "${Uri.base.scheme}://${Uri.base.host}:${Uri.base.port}/storage";
    }
    return 'http://$_serverIp:8000/storage';
  }

  // Wajib dipanggil di main.dart biar IP-nya sinkron
  static Future<void> init() async {
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();
    _serverIp = prefs.getString('server_ip') ?? _serverIp;

    // Cek koneksi IP lama, klo mati lgsg nyari yg baru
    _testAndAutoDiscover();
  }

  static Future<void> _testAndAutoDiscover() async {
    try {
      // Pake endpoint health biar pasti
      final response = await http.get(Uri.parse('http://$_serverIp:8000/api/health')).timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        if (kDebugMode) print("Koneksi OK ke: $_serverIp");
        return;
      }
      throw Exception("Server down");
    } catch (e) {
      if (kDebugMode) print("Server $_serverIp gak nyaut, nyari IP otomatis...");
      autoDiscover();
    }
  }

  static Future<void> updateIp(String newIp) async {
    _serverIp = newIp;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', newIp);
  }

  // FUNGSI SAKTI: Nyari server di WiFi secara otomatis
  static Future<bool> autoDiscover() async {
    if (kIsWeb) return false;

    try {
      final interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            final ipParts = addr.address.split('.');
            if (ipParts.length != 4) continue;

            final subnet = "${ipParts[0]}.${ipParts[1]}.${ipParts[2]}";
            if (kDebugMode) print("Scanning subnet: $subnet.x");

            // Scan 254 IP secara paralel (barengan) biar super cepet
            final List<Future<String?>> tasks = [];
            for (int i = 1; i <= 254; i++) {
              tasks.add(_verifyIp("$subnet.$i"));
            }

            final results = await Future.wait(tasks);

            String? foundIp;
            try {
              foundIp = results.firstWhere((ip) => ip != null);
            } catch (_) {
              foundIp = null;
            }

            if (foundIp != null) {
              await updateIp(foundIp);
              if (kDebugMode) print("SERVER KETEMU! IP baru: $foundIp");
              return true;
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print("Gagal auto-discover: $e");
    }
    if (kDebugMode) print("Server gak ketemu di jaringan ini.");
    return false;
  }

  static Future<String?> _verifyIp(String ip) async {
    try {
      // Kita coba "ketok pintu" port 8000 ke endpoint health
      final response = await http.get(Uri.parse('http://$ip:8000/api/health'))
          .timeout(const Duration(milliseconds: 1000));

      if (response.statusCode == 200 && response.body.contains('KangMas')) {
        return ip;
      }
    } catch (_) {}
    return null;
  }

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

  static Future<dynamic> multipartPost({
    required String endpoint,
    Map<String, String>? fields,
    File? singleFile,
    String singleFileKey = 'file',
    List<File>? multiFiles,
    String multiFilesKey = 'files[]',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final uri = Uri.parse('$baseUrl$endpoint');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    if (fields != null) request.fields.addAll(fields);
    if (singleFile != null) {
      request.files.add(await http.MultipartFile.fromPath(singleFileKey, singleFile.path));
    }
    if (multiFiles != null) {
      for (var file in multiFiles) {
        request.files.add(await http.MultipartFile.fromPath(multiFilesKey, file.path));
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _processResponse(response);
  }

  static dynamic _processResponse(http.Response response) {
    final body = response.body;
    if (kDebugMode) print("API Response (${response.statusCode}): $body");

    final decodedBody = jsonDecode(body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    } else {
      final message = decodedBody['message'] ?? 'Terjadi kesalahan (${response.statusCode})';
      if (response.statusCode == 401 || (response.statusCode == 403 && message == "Unauthorized")) {
        throw Exception("Sesi Anda telah berakhir. Silakan login kembali.");
      }
      throw Exception(message);
    }
  }
}
