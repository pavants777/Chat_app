import 'package:chatx/Functions.dart/firebasefunction.dart';
import 'package:chatx/Models/GroupsModel.dart';
import 'package:chatx/Models/UserModels.dart';
import 'package:chatx/Screens/Groups/GroupInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  Group? group;
  GroupScreen({super.key, required this.group});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  TextEditingController _message = TextEditingController();
  List<UserModles> users = [];
  FirebaseFunction function = FirebaseFunction();
  FirebaseAuth _auth = FirebaseAuth.instance;

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

  _sendMessagetoGroup() async {
    if (_message.text.isNotEmpty) {
      await function.sendMessagetoGroup(widget.group!.groupId, _message.text);
      _message.clear();
    }
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
                                builder: (context) => GroupInfo(
                                      group: widget.group!,
                                    )));
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
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Close'),
                        )
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.more_vert))
        ]),
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder(
            stream: function.getMessageFromGroup(widget.group!.groupId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading');
              }
              List<DocumentSnapshot<Map<String, dynamic>>> messages =
                  snapshot.data!.docs;
              return ListView(
                children: snapshot.data!.docs
                    .map((e) => _buildMessageItem(e))
                    .toList(),
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _message,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.black),
                    contentPadding: EdgeInsets.only(left: screenWidth * 0.2),
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
            ),
            Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      _sendMessagetoGroup();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ))),
          ],
        ),
      ]),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();
    int hours = dateTime.hour;
    int minute = dateTime.minute;
    bool isMorning = true;

    if (hours > 12) {
      hours = hours % 12;
      isMorning = false;
    }

    String period = isMorning ? 'AM' : 'PM';
    String formattedString = '$hours : $minute $period';

    Color _color = (data['senderId'] == _auth.currentUser!.uid)
        ? const Color.fromARGB(255, 172, 247, 175)
        : Colors.white;

    var alignment = (data['senderId'] == _auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return FutureBuilder<UserModles?>(
      future: function.getCurrentUser(data['senderId']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          UserModles? user = snapshot.data;

          return Container(
            alignment: alignment,
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                crossAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _color,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user?.name ?? ''}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            data['message'] ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          formattedString,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
