import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      const UserAccountsDrawerHeader(
        accountName: Text("Nora Alissa"), // Change this to the user's name
        accountEmail:
            Text("noraalissa13@gmail.com"), // Change this to the user's email
        currentAccountPicture: CircleAvatar(
            backgroundColor: Color.fromARGB(128, 41, 126, 108),
            child: Text(
              "N", // Change this to the user's pfp or initials
              style: TextStyle(fontSize: 40.0),
            )),
      ),
      ListTile(
        leading: const Icon(Icons.home_rounded),
        title: const Text("Home"),
        onTap: () {
          Navigator.pushNamed(context, "/home");
        },
      ),
      ListTile(
        leading: const Icon(Icons.assignment_rounded),
        title: const Text("Session Report"),
        onTap: () {
          Navigator.pushNamed(context, "/session report");
        },
      ),
      ListTile(
        leading: const Icon(Icons.menu_book_rounded),
        title: const Text("Learning Strategies"),
        onTap: () {
          Navigator.pushNamed(context, "/learning strategies");
        },
      ),
      ListTile(
        leading: const Icon(Icons.music_note_rounded),
        title: const Text("Music Feedback"),
        onTap: () {
          Navigator.pushNamed(context, "/music feedback");
        },
      ),
      /*
      ListTile(
        leading: const Icon(Icons.bluetooth_rounded),
        title: const Text("Connect Your Device"),
        onTap: () {
          Navigator.pushNamed(context, "/connect device");
        },
      )*/
    ]));
  }
}
