import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://192.168.54.104:8000/api/';

  // Logic Login
  Future<void> login(String username, String password) async {
    final url = Uri.parse('${baseUrl}login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status']) {
        String token = data['token'];
        print('Login successful, token: $token');

        // Simpan token ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      } else {
        throw Exception('Login failed: ${data['message']}');
      }
    } else if (response.statusCode == 401) {
      final data = jsonDecode(response.body);
      throw Exception(data['message']);
    } else {
      throw Exception('Unexpected error: ${response.statusCode}');
    }
  }

  // Logic Get Tiket
  Future<Map<String, dynamic>> getTickets(
      {required int page, int? status}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = status != null
        ? '${baseUrl}gettikets?page=$page&status=$status'
        : '${baseUrl}gettikets?page=$page';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get tickets');
    }
  }

  // Logic Pagination
  Future<Map<String, dynamic>> paginates(
      {required int page, int? status}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = status != null
        ? '${baseUrl}paginates?page=$page&status=$status'
        : '${baseUrl}paginates?page=$page';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get tickets');
    }
  }

  // Logic Get Profile
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

  // Logic Logout
  Future<void> logout() async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token not found. Please log in again.');
      }
      // Kirim permintaan logout ke backend menggunakan GET
      final response = await http.get(
        Uri.parse('${baseUrl}logout'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          // Hapus token dari SharedPreferences
          await prefs.remove('token');
          print("Logout successful.");
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

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Ticket added successfully');
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to add ticket: ${response.request}');
    }
  }
}
