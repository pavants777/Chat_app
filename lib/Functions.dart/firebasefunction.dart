import 'package:chatx/Models/GroupsModel.dart';
import 'package:chatx/Models/MessageModel.dart';
import 'package:chatx/Models/UserModels.dart';
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

  Future<void> createGroup(String groupName, List<String> usersIds) async {
    try {
      CollectionReference groups =
          FirebaseFirestore.instance.collection('groups');

      // Generate a unique groupId
      String groupId = groups.doc().id;

      // Create a Map representing the data structure
      Map<String, dynamic> groupData = {
        'groupId': groupId,
        'groupName': groupName,
        'users': usersIds,
        'messages': [],
      };

      // Use the Map as the argument for the set method
      await groups.doc(groupId).set(groupData);

      print('Group created successfully!');
    } catch (e) {
      print('Error creating group: $e');
    }
  }

  Future<UserModles?> getCurrentUser(String users) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('uid', isEqualTo: users)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return UserModles.fromJson(snapshot.docs.first.data());
    } else {
      return null;
    }
  }

  Stream<List<Group>> getAllGroups() {
    return FirebaseFirestore.instance
        .collection('groups')
        .snapshots()
        .map((snapshot) {
      List<Group> groups = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Group.fromJson(data);
      }).toList();
      print('Returning ${groups.length} groups');
      return groups;
    });
  }

  Future<void> addMemberToGroup(String groupId, UserModles newUser) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> groupDoc = await FirebaseFirestore
          .instance
          .collection('groups')
          .doc(groupId)
          .get();

      if (groupDoc.exists) {
        String newMemberId = newUser.uid;

        List<dynamic> currentMembers = groupDoc.data()?['users'] ?? [];
        if (!currentMembers.contains(newMemberId)) {
          currentMembers.add(newMemberId);

          await FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .update({'users': currentMembers});

          print('Member added to the group successfully!');
        } else {
          print('Member is already in the group.');
        }
      } else {
        print('Group not found.');
      }
    } catch (e) {
      print('Error adding member to group: $e');
    }
  }
}
