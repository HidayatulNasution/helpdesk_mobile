import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ApiService {
  final String baseUrl = 'http://192.168.218.104:8000/api/';

  Future<dynamic> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']);
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<dynamic> register(Map<String, String> body) async {
    final response = await http.post(
      Uri.parse('${baseUrl}register'),
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<List<dynamic>> getTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('${baseUrl}gettikets'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['tiket'];
    } else {
      throw Exception('Failed to fetch tickets');
    }
  }

  Future<List<dynamic>> getProfile() async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found. Please log in again.');
      }

      // Kirim permintaan ke endpoint profile
      final response = await http.get(
        Uri.parse('${baseUrl}profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      // Cek status respons
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Pastikan respons mengandung data
        if (jsonResponse['status'] == true) {
          return [jsonResponse['data']];
        } else {
          throw Exception(jsonResponse['message'] ?? 'Unknown error occurred.');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please check your token.');
      } else {
        throw Exception(
            'Failed to fetch profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> logout() async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found. Please log in again.');
      }

      // Kirim permintaan logout ke backend
      final response = await http.get(
        Uri.parse('${baseUrl}logout'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          // Hapus token dari SharedPreferences
          await prefs.remove('token');
        } else {
          throw Exception(jsonResponse['message'] ?? 'Logout failed.');
        }
      } else {
        throw Exception('Logout failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during logout: $e');
    }
  }

  Future<void> addTicket(
    String bidangSystem,
    String kategori,
    String problem,
    String result,
    String status,
    String prioritas,
    File? image, // Gambar bersifat opsional
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Prepare the image to send (if available)
    final uri = Uri.parse('${baseUrl}tikets');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['bidang_system'] = bidangSystem
      ..fields['kategori'] = kategori
      ..fields['problem'] = problem
      ..fields['result'] = result
      ..fields['status'] = status
      ..fields['prioritas'] = prioritas;

    if (image != null) {
      final mimeType = await mime(image.path);
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType.parse(mimeType!),
      ));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Ticket added successfully');
    } else {
      throw Exception('Failed to add ticket');
    }
  }

  // Add more methods for other endpoints
}
