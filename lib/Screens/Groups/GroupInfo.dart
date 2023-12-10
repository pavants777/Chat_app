import 'package:chatx/Functions.dart/firebasefunction.dart';
import 'package:chatx/Models/GroupsModel.dart';
import 'package:chatx/Models/UserModels.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final Group? group;
  GroupInfo({required this.group});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  FirebaseFunction function = FirebaseFunction();
  String? groupId;

  @override
  void initState() {
    super.initState();
    groupId = widget.group?.groupId;
  }

  Future<List<UserModles>> getUserId(String? groupId) async {
    List<UserModles> users = [];
    List<dynamic> userIds = await function.getUserId(groupId ?? '');
    for (String userId in userIds) {
      UserModles? user = await function.getCurrentUser(userId);
      if (user != null) {
        users.add(user);
      }
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 220,
        title: Text('Group Info'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(15)),
                CircleAvatar(
                  radius: screenWidth * 0.25,
                  backgroundColor: Colors.pink,
                ),
                Text(
                  '${widget.group?.groupName ?? ""}',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text(
                  'Group - ${widget.group?.users.length ?? 0} members',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: screenWidth,
            height: 1,
            color: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Members',
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.search))
              ],
            ),
          ),
          StreamBuilder<List<UserModles>>(
            stream: Stream.fromFuture(getUserId(groupId)),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<UserModles> users = snapshot.data ?? [];

              return Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return GroupView(users[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget GroupView(UserModles user) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(children: [
        CircleAvatar(
          maxRadius: screenWidth * 0.08,
        ),
        SizedBox(
          width: screenWidth * 0.05,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${user!.name}',
                  style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255))),
              SizedBox(
                height: 8,
              ),
              Text(
                '${user!.email}',
                softWrap: false,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
