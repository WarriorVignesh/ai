class Message {
  final String id;
  final String userId;
  final String text;
  final DateTime date;
  final String type;

  Message({
    required this.id,
    required this.userId,
    required this.text,
    required this.date,
    this.type = 'text',
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      userId: json['userId'],
      text: json['text'],
      date: DateTime.parse(json['date']),
      type: json['type'] ?? 'text',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'date': date.toIso8601String(),
      'type': type,
    };
  }
}
