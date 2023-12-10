import 'package:chatx/Functions.dart/firebasefunction.dart';
import 'package:chatx/Models/GroupsModel.dart';
import 'package:chatx/Models/UserModels.dart';
import 'package:chatx/Screens/Groups/GroupDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupHomeScreen extends StatefulWidget {
  const GroupHomeScreen({super.key});

  @override
  State<GroupHomeScreen> createState() => _GroupHomeScreenState();
}

class _GroupHomeScreenState extends State<GroupHomeScreen> {
  TextEditingController _groupName = TextEditingController();
  FirebaseFunction function = FirebaseFunction();
  String userid = FirebaseAuth.instance.currentUser!.uid;
  List<Group> groups = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _createGroup() async {
    UserModles? currentUser = await function.getCurrentUser(userid);
    if (_groupName.text.isNotEmpty && currentUser != null) {
      function.createGroup(_groupName.text, [currentUser.uid]);
    } else {
      print('${currentUser!.email}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GroupChats',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              enableSuggestions: false,
              style: TextStyle(color: Colors.black, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Group Search......',
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
          StreamBuilder<List<Group>>(
            stream: function.getAllGroups(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading');
              }

              List<Group> groups = snapshot.data ?? [];
              List<Group> userGroups = groups
                  .where((group) => isUserInGroup(group, userid))
                  .toList();

              if (userGroups.isEmpty) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: Text('User is not in any group')),
                    ],
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: userGroups.length,
                  itemBuilder: (context, index) {
                    return GroupDesign(
                      group: userGroups[index],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Groups'),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextField(
                      controller: _groupName,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'GroupName',
                        hintStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                  ]),
                  actions: [
                    TextButton(
                        onPressed: () {
                          _createGroup();
                          Navigator.pop(context);
                        },
                        child: Text('Create')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  bool isUserInGroup(Group group, String userId) {
    return group.users.any((user) => user == userId);
  }
}
