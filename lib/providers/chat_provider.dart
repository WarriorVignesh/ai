import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/chat.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  List<Chat> _defaultChats = [];
  List<Chat> _contacts = [];
  List<Message> _messages = [];
  Timer? _debounce;

  List<Chat> get defaultChats => _defaultChats;
  List<Chat> get contacts => _contacts;
  List<Message> get messages => _messages;

  Future<void> fetchDefaultChats() async {
    final url = 'http://localhost:5000/api/chats/default';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _defaultChats = data.map((item) => Chat.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load default chats');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchUserChats(String token) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final url = 'http://localhost:5000/api/chats/user';
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {'Authorization': 'Bearer $token'},
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          _contacts = data.map((item) => Chat.fromJson(item)).toList();
          notifyListeners();
        } else {
          throw Exception('Failed to load user chats');
        }
      } catch (error) {
        throw error;
      }
    });
  }

  Future<void> addNewContact(String mobileNumber) async {
    final url = 'http://localhost:5000/api/users/find';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'mobileNumber': mobileNumber}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Add the new contact to the contacts list
        _contacts.add(Chat.fromJson(data));
        notifyListeners();
      } else {
        // Handle user not found
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchMessages(String chatId) async {
    final url = 'http://localhost:5000/api/messages/$chatId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _messages = data.map((item) => Message.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> sendMessage(String text, String userId, {String type = 'text', DateTime? revealTime}) async {
    final url = 'http://localhost:5000/api/messages';
    final body = {
      'text': text,
      'userId': userId,
      'type': type,
      'revealTime': revealTime?.toIso8601String(),
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        // Optionally, add the sent message to the messages list
        fetchMessages(userId);
      } else {
        throw Exception('Failed to send message');
      }
    } catch (error) {
      throw error;
    }
  }
}
