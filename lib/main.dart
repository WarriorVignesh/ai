import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/websocket_provider.dart';
import 'screens/initial_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => ChatProvider()),
        ChangeNotifierProvider(create: (ctx) => SocketProvider('http://localhost:5000')), // Add this provider
      ],
      child: MaterialApp(
        title: 'NearYou',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: InitialScreen(),
        routes: {
          '/login': (ctx) => LoginScreen(),
          '/register': (ctx) => RegisterScreen(),
          '/chat-list': (ctx) => ChatListScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/chat') {
            final chatId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (ctx) => ChatScreen(chatId: chatId), // Ensure chatId is passed here
            );
          }
          return null;
        },
      ),
    );
  }
}
