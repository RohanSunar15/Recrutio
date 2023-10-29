import 'package:Recrutio/HOME/SEARCH/showprofile.dart';
import 'package:Recrutio/HOME/buttom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List searchResult = [];

  void searchFromFirebase(String query ) async{

    final result = await FirebaseFirestore.instance.
    collection('users').
    where('name',
      isEqualTo: query,
    ).get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();

    });
  }



  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 3;
    return Scaffold(
      appBar: AppBar(
        title: null, // Remove the default title
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(

              decoration: const InputDecoration(
                hintText: 'Search by Name, Company Name, or Job Title',
                suffixIcon: Icon(Icons.search), // Search icon on the right side
              ),
              onChanged: (query){
                searchFromFirebase(query);
              },
            ),
            const SizedBox(height: 20),
            const Text('Search Results:'),
            Expanded(
              child: ListView.builder(
                itemCount: searchResult.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the profile page when a result is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowProfilePage(userData: searchResult[index]),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(searchResult[index]['name']),
                      subtitle: Text(searchResult[index]['profession']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
