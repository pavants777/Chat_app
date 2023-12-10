import 'package:chatx/Models/UserModels.dart';

class Message {
  final String message;
  final String senderId;

  Message({required this.message, required this.senderId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(message: json['message'], senderId: json['senderId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'senderId': senderId,
    };
  }
}

class Group {
  final String groupId;
  final String groupName;
  final List<String> users;
  final List<Message> messages;

  Group({
    required this.groupId,
    required this.groupName,
    required this.users,
    required this.messages,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'users': users,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['groupId'] ?? '',
      groupName: json['groupName'] ?? '',
      users: (json['users'] as List<dynamic>?)
              ?.map((user) => user.toString())
              .toList() ??
          [],
      messages: (json['messages'] as List<dynamic>?)
              ?.map((message) => Message.fromJson(message))
              .toList() ??
          [],
    );
  }
}
