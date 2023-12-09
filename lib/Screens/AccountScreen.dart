import 'package:chatx/Models/UserModels.dart';
import 'package:chatx/Routes/Routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModles? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    try {
      String userId = _auth.currentUser!.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        UserModles userModel =
            UserModles.fromJson(querySnapshot.docs.first.data());
        setState(() {
          user = userModel;
        });
      } else {
        print('No documents found for the specified user ID.');
      }
    } catch (e) {
      print('Error getting user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Center(
      child: user == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.3,
                ),
                SizedBox(
                  height: 20,
                ),
                Text('${user?.name}'),
                Text('${_auth.currentUser!.email}'),
                IconButton(
                    onPressed: () {
                      _auth.signOut();
                    },
                    icon: Icon(Icons.exit_to_app))
              ],
            ),
    ));
  }
}
