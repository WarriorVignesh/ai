class Chat {
  final String name;

  Chat({required this.name});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(name: json['name']);
  }
}
