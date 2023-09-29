// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:Recrutio/HOME/buttom_navigation_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedIndex = 3;

  String searchQuery = 'Search query';

  void _performSearch(String query) {
    // Implement your search logic here
    print("Searching for: $query");
    // Update the UI with search results if applicable
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white70],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Search Page',
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF494946),
        ),
        bottomNavigationBar: BottomNavBar(
          // Use your custom bottom navigation bar
          selectedIndex: _selectedIndex,
          onTabSelected: (int index) {
            setState(() {
              _selectedIndex = index; // Update the selected index
            });
          },
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (query) {
                        setState(() {
                          searchQuery = query;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search by company name, job title, etc.',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _performSearch(searchQuery);
                    },
                  ),
                ],
              ),
            ),
            // Rest of your content goes here
          ],
        ),
      ),
    );
  }
}