import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';

class SMFormScreen extends StatefulWidget {
  @override
  _SMFormScreenState createState() => _SMFormScreenState();
}

class _SMFormScreenState extends State<SMFormScreen> {
  final _textController = TextEditingController();
  DateTime? _revealTime;

  void _sendSM() {
    if (_textController.text.trim().isEmpty || _revealTime == null) {
      return;
    }
    final userId = Provider.of<AuthProvider>(context, listen: false).userId ?? ''; // Handle nullable userId

    Provider.of<ChatProvider>(context, listen: false).sendMessage(
      _textController.text,
      userId,
      type: 'surprise',
      revealTime: _revealTime,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Surprise Message'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Reveal in:'),
                SizedBox(width: 10),
                DropdownButton<DateTime>(
                  value: _revealTime,
                  onChanged: (newValue) {
                    setState(() {
                      _revealTime = newValue;
                    });
                  },
                  items: [
                    DateTime.now().add(Duration(seconds: 10)),
                    DateTime.now().add(Duration(seconds: 30)),
                    DateTime.now().add(Duration(minutes: 1)),
                  ].map((time) {
                    return DropdownMenuItem<DateTime>(
                      value: time,
                      child: Text('${time.difference(DateTime.now()).inSeconds} seconds'),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendSM,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
