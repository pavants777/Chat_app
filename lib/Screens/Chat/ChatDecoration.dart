import 'package:chatx/Models/UserModels.dart';
import 'package:chatx/Screens/Chat/ChatPage.dart';
import 'package:flutter/material.dart';

class UserChat extends StatefulWidget {
  final UserModles? user;
  UserChat(this.user);

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  @override
  Widget build(BuildContext context) {
    final srceenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: 5, bottom: 5),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(user: widget.user)));
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      maxRadius: srceenWidth * 0.08,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 0, left: 45),
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 8,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: srceenWidth * 0.05,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.user!.name}',
                          style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 255, 255, 255))),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${widget.user!.email}',
                        softWrap: false,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                Text('06 DEC',
                    style:
                        TextStyle(fontSize: 14, color: Colors.grey.shade500)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
