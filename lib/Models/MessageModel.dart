import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'Message': Message,
      'timestamp': timestamp,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        senderId: json['senderId'],
        senderEmail: json['senderEmail'],
        receiverId: json['reciverId'],
        Message: json['Message'],
        timestamp: json['timestamp']);
  }
}
