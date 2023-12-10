import 'package:chatx/Screens/Account/AccountScreen.dart';
import 'package:chatx/Screens/Groups/GroupHomeScreen.dart';
import 'package:chatx/Screens/Chat/UsersScreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _index = 0;
  Widget page = UserScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account')
        ],
        currentIndex: _index,
        onTap: (int tappedIndex) {
          setState(() {
            _index = tappedIndex;
          });
          switch (_index) {
            case 0:
              setState(() {
                page = UserScreen();
              });
              break;
            case 1:
              setState(() {
                page = GroupHomeScreen();
              });
              break;
            case 2:
              setState(() {
                page = Account();
              });
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
