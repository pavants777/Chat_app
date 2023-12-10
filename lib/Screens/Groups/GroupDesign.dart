import 'package:chatx/Models/GroupsModel.dart';
import 'package:chatx/Screens/Groups/GroupScreen.dart';
import 'package:flutter/material.dart';

class GroupDesign extends StatefulWidget {
  Group? group;
  GroupDesign({super.key, required this.group});

  @override
  State<GroupDesign> createState() => _GroupDesignState();
}

class _GroupDesignState extends State<GroupDesign> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: 5, bottom: 5),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupScreen(group: widget.group)));
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      maxRadius: screenWidth * 0.08,
                      backgroundColor: Colors.pink,
                    ),
                  ],
                ),
                SizedBox(
                  width: screenWidth * 0.05,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.group!.groupName}',
                          style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 255, 255, 255))),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Total Members :    ${widget.group!.users!.length}',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.green.shade500),
                        softWrap: false,
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
