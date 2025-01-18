// MADE BY: NORA ALISSA BINTI ISMAIL (2117862)
// This file contains the NavBar widget,
// which is a custom drawer widget for the application.

import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // The build method constructs the Drawer widget, which is a side navigation menu.
    return Drawer(
      child: ListView(
        padding:
            EdgeInsets.zero, // Removes any default padding from the ListView
        children: [
          // User account header section, which displays the user's name, email, and profile picture.
          const UserAccountsDrawerHeader(
            accountName: Text(
                "Nora Alissa"), // User's name displayed in the drawer header
            accountEmail: Text(
                "noraalissa13@gmail.com"), // User's email displayed in the drawer header
            currentAccountPicture: CircleAvatar(
              backgroundColor: Color.fromARGB(
                  128, 41, 126, 108), // Background color of the profile picture
              child: Text(
                "N", // Initials of the user displayed in the profile picture
                style: TextStyle(
                    fontSize: 40.0), // Sets the font size for the initials
              ),
            ),
          ),
          // Home ListTile: A clickable item that navigates to the home page
          ListTile(
            leading: const Icon(
                Icons.home_rounded), // Icon displayed next to the "Home" text
            title: const Text("Home"), // Text displayed for the "Home" item
            onTap: () {
              // Navigates to the home page when tapped
              Navigator.pushNamed(context, "/home");
            },
          ),
          // Connect Device ListTile: A clickable item that navigates to the connect device page
          ListTile(
            leading: const Icon(Icons
                .bluetooth), // Icon displayed next to the "Connect Device" text
            title: const Text(
                "Connect Device"), // Text displayed for the "Connect Device" item
            onTap: () {
              // Navigates to the connect device page when tapped
              Navigator.pushNamed(context, "/connect_device");
            },
          ),
        ],
      ),
    );
  }
}
