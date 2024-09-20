import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package
import '../models/message.dart';
import '../providers/websocket_provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  ChatScreen({required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.connect(widget.chatId);
  }

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = Message(
        id: Uuid().v4(), // Generate a unique ID for the message
        userId: 'user', // Replace with actual sender ID
        text: _messageController.text,
        date: DateTime.now(),
      );
      Provider.of<SocketProvider>(context, listen: false).sendMessage(message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    final messages = socketProvider.messages;

    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(messages[index].text),
                  subtitle: Text(messages[index].userId),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
