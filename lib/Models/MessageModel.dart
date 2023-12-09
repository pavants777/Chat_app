import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String senderId;
  String senderEmail;
  String receiverId;
  String Message;
  Timestamp timestamp;

  MessageModel(
      {required this.senderId,
      required this.senderEmail,
      required this.receiverId,
      required this.Message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'Message': Message,
      'timestamp': timestamp,
    };
  }
}
