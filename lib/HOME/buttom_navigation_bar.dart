// ignore_for_file: use_build_context_synchronously

import 'package:Recrutio/HOME/JOB/addjobpage.dart';
import 'package:Recrutio/HOME/MESSAGE/Message.dart';
import 'package:Recrutio/HOME/Notification/notification.dart';
import 'package:Recrutio/HOME/SEARCH/search.dart';
import 'package:Recrutio/HOME/homescreen.dart';
import 'package:Recrutio/PROFILE/profile.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const BottomNavBar({Key? key, required this.onTabSelected, required this.selectedIndex}) : super(key: key);

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {

  Route<dynamic> _pageTransitionBuilder(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }


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
            Navigator.of(context).push(_pageTransitionBuilder(const ProfilePage())); // Navigate to the profile page with animation
          } else if (index == 1) { // 1 is the index of the "Notification" item
            await Future.delayed(const Duration(milliseconds: 250)); // Add a 1-second delay
            Navigator.of(context).push(_pageTransitionBuilder( NotificationPage())); // Navigate to the notification page with animation
          } else if (index == 2) { // 2 is the index of the "Add Job" item
            await Future.delayed(const Duration(milliseconds: 250)); // Add a 1-second delay
            Navigator.of(context).push(_pageTransitionBuilder(const AddJobPage())); // Navigate to the add job page with animation
          } else if (index == 3) { // 3 is the index of the "Search" item
            await Future.delayed(const Duration(milliseconds: 250)); // Add a 1-second delay
            Navigator.of(context).push(_pageTransitionBuilder(const SearchPage())); // Navigate to the search page with animation
          } else if (index == 0) { // 0 is the index of the "Home" item
            await Future.delayed(const Duration(milliseconds: 250)); // Add a 1-second delay
            Navigator.of(context).push(_pageTransitionBuilder(const HomePage())); // Navigate to the home page with animation
          }
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home, size: 20),
            title: const Text('Home',style: TextStyle(fontSize: 13),),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.notifications, size: 20),
            title: const Text('Notification',style: TextStyle(fontSize: 13),),
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
