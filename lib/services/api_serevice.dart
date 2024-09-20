import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';

  static Future<bool> checkUserExists(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/checkUser/$phoneNumber');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['exists'];
    } else {
      throw Exception('Failed to check user');
    }
  }

  static Future<void> sendInvite(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/invite');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone': phoneNumber}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send invite');
    }
  }
}
