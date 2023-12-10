import 'dart:async';
import 'package:chatx/Models/UserModels.dart';
import 'package:chatx/Screens/Chat/ChatDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<UserModles> users = [];
  List<UserModles> _foundUsers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      users = querySnapshot.docs
          .map((doc) => UserModles.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
    setState(() {
      _foundUsers = users;
    });
  }

  _runFilter(String enterKeyword) {
    List<UserModles> res = [];

    if (enterKeyword.isEmpty) {
      res = users;
    } else {
      res = users
          .where((users) =>
              users.name.toLowerCase().contains(enterKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUsers = res;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chats',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 2),
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.pink[50],
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          Text(
                            'New',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                _runFilter(value);
              },
              enableSuggestions: false,
              style: TextStyle(color: Colors.black, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Search......',
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.black,
                contentPadding: EdgeInsets.all(16),
                filled: true,
                fillColor: Colors.grey.shade100,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _foundUsers.length,
            itemBuilder: (context, index) {
              if (_foundUsers[index].email !=
                  FirebaseAuth.instance.currentUser!.email) {
                return ListTile(
                  title: UserChat(_foundUsers[index]),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
