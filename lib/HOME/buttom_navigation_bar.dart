// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const BottomNavBar({super.key, required this.onTabSelected, required this.selectedIndex});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(

        color: Color(0xFFFFFFFF), // Background color (hex color code)
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Curved shape
      ),
      child: SalomonBottomBar(
        currentIndex: widget.selectedIndex,
        onTap: (index) async {
          // Call the provided callback to notify the parent widget of the selected index
          widget.onTabSelected(index);

          if (index == 4) { // 4 is the index of the "Profile" item
            await Future.delayed(const Duration(milliseconds: 250)); // Add a 1-second delay
            Navigator.pushNamed(context, 'profile'); // Navigate to the profile page
          } else if (index == 1) { // 1 is the index of the "Notification" item
            await Future.delayed(const Duration(milliseconds: 250)); // Add a 1-second delay
            Navigator.pushNamed(context, 'message'); // Navigate to the notification page
          } else if (index == 2) { // 1 is the index of the "Notification" item
            await Future.delayed(const Duration(milliseconds: 250)); // Add a 1-second delay
            Navigator.pushNamed(context, 'addjob'); // Navigate to the notification page
          } else if (index == 3) { // 1 is the index of the "Notification" item
            await Future.delayed(const Duration(milliseconds: 250)); // Add a 1-second delay
            Navigator.pushNamed(context, 'search'); // Navigate to the notification page
          }
        },

        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home, size: 20),
            title: const Text('Home',style: TextStyle(fontSize: 13),),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.message, size: 20),
            title: const Text('Message',style: TextStyle(fontSize: 13),),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.add_circle, size: 20),
            title: const Text('Add Job',style: TextStyle(fontSize: 13),),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.search, size: 20),
            title: const Text('Search',style: TextStyle(fontSize: 13),),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person, size: 20),
            title: const Text('Profile',style: TextStyle(fontSize: 13),),
          ),
        ],
      ),
    );
  }
}