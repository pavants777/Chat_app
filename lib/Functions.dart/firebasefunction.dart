import 'package:chatx/Models/MessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFunction {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String reciverId, Message) async {
    String currentUserEmail = await _auth.currentUser!.email.toString();
    String currentUseUid = await _auth.currentUser!.uid;

    final Timestamp timestamp = Timestamp.now();

    MessageModel newMessage = MessageModel(
        senderId: currentUseUid,
        senderEmail: currentUserEmail,
        receiverId: reciverId,
        Message: Message,
        timestamp: timestamp);

    List<String> ids = [currentUseUid, reciverId];
    ids.sort();

    String chatRoom_id = ids.join("_");

    await _firestore
        .collection('Chat_Room')
        .doc(chatRoom_id)
        .collection('Message')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];

    ids.sort();

    String chatRoom_id = ids.join("_");

    return _firestore
        .collection('Chat_Room')
        .doc(chatRoom_id)
        .collection('Message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
