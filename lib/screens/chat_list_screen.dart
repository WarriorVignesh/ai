import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_screen.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/websocket_provider.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final webSocketProvider = Provider.of<SocketProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatProvider.defaultChats.isEmpty) {
        chatProvider.fetchDefaultChats();
      }
      if (chatProvider.contacts.isEmpty) {
        final token = authProvider.token ?? '';
        if (token.isNotEmpty) {
          chatProvider.fetchUserChats(token);
        }
      }
      // Connect to the WebSocket for real-time updates
      final userId = authProvider.userId ?? '';
      if (userId.isNotEmpty) {
        webSocketProvider.connect(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by mobile number',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Implement search logic
                  },
                ),
              ),
              onSubmitted: (value) {
                chatProvider.addNewContact(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.contacts.length + chatProvider.defaultChats.length,
              itemBuilder: (context, index) {
                if (index < chatProvider.defaultChats.length) {
                  final chat = chatProvider.defaultChats[index];
                  return ListTile(
                    title: Text(chat.name), // Handle nullable name
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chatId: chat.name), // Ensure chat ID is passed
                        ),
                      );
                    },
                  );
                } else {
                  final contact = chatProvider.contacts[index - chatProvider.defaultChats.length];
                  return ListTile(
                    title: Text(contact.name), // Handle nullable name
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chatId: contact.name), // Ensure contact ID is passed
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
