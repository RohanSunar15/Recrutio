import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const BottomNavBar({super.key, required this.onTabSelected, required this.selectedIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF), // Background color (hex color code)
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Curved shape
      ),
      child: SalomonBottomBar(
        currentIndex: widget.selectedIndex,
        onTap: widget.onTabSelected,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.notifications),
            title: const Text('Notification'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.add_circle),
            title: const Text('Add Job'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text('Search'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }
}
