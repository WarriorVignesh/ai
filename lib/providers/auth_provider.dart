import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _userName;
  String? _userEmail;

  String? get token => _token;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  Future<bool> register(String username, String password, String name, String email, String mobileNumber) async {
    final url = Uri.parse('http://localhost:5000/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'name': name,
        'email': email,
        'mobileNumber': mobileNumber,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      _token = responseData['token'];
      _userId = responseData['userId'];
      _userName = name;
      _userEmail = email;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('http://localhost:5000/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _token = responseData['token'];
      _userId = responseData['userId'];
      _userName = responseData['name'];
      _userEmail = responseData['email'];
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateProfile({required String name, required String email}) async {
    if (_token == null || _userId == null) {
      throw Exception('Not authenticated');
    }

    final url = Uri.parse('http://localhost:5000/api/auth/updateProfile');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      _userName = name;
      _userEmail = email;
      notifyListeners();
    } else {
      throw Exception('Failed to update profile');
    }
  }
}
