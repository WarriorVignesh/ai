import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import '../models/message.dart';

class SocketProvider with ChangeNotifier {
  late WebSocketChannel _channel;
  final String _serverUrl;
  List<Message> _messages = [];

  SocketProvider(this._serverUrl);

  List<Message> get messages => _messages;

  void connect(String userId) {
    _channel = WebSocketChannel.connect(Uri.parse('$_serverUrl/$userId'));

    _channel.stream.listen((data) {
      final messageData = jsonDecode(data);
      final message = Message.fromJson(messageData);
      _messages.add(message);
      notifyListeners();
    });
  }

  void sendMessage(Message message) {
    _channel.sink.add(jsonEncode(message.toJson()));
  }

  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
