//packages
import 'package:chatify/pages/usersPage.dart';
import 'package:flutter/material.dart';

//pages
import '../pages/chatsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  final List<Widget> pages = [
    const ChatsPage(),
    const UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WidgetUI();
  }

  Widget WidgetUI() {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Chats',
            icon: Icon(Icons.chat_bubble_sharp),
          ),
          BottomNavigationBarItem(
            label: 'Users',
            icon: Icon(Icons.supervised_user_circle_sharp),
          )
        ],
      ),
    );
  }
}
