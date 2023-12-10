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
        appBar: AppBar(
          title: Text('Account'),
          centerTitle: true,
          elevation: 10,
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: user == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      width: screenWidth,
                      decoration: BoxDecoration(color: Colors.black),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${user?.name}',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          Text('${_auth.currentUser!.email}'),
                          Text('${user?.uid}'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      padding: EdgeInsets.all(40),
                      width: screenWidth,
                      child: GestureDetector(
                        onTap: () {
                          _auth.signOut();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.exit_to_app,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'LogOut',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }
}
