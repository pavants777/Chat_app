import 'package:chatx/Functions.dart/firebasefunction.dart';
import 'package:chatx/Models/GroupsModel.dart';
import 'package:chatx/Models/UserModels.dart';
import 'package:chatx/Screens/Groups/GroupInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  Group? group;
  GroupScreen({super.key, required this.group});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<UserModles> users = [];
  FirebaseFunction function = FirebaseFunction();

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
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 200,
        title: Row(children: [
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.05,
                    backgroundColor: Colors.pink,
                  ),
                  SizedBox(
                    width: screenWidth * 0.04,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GroupInfo()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.group!.groupName}',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Total Members : ${widget.group!.users.length}',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.green.shade500),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add Users'),
                      content: Container(
                        width: double.maxFinite,
                        height: 200,
                        child: ListView.builder(
                          itemCount: users!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text("${users[index].name}"),
                              onTap: () {
                                function.addMemberToGroup(
                                    widget.group!.groupId, users[index]);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.more_vert))
        ]),
      ),
    );
  }
}
