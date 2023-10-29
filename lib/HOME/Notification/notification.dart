import 'package:Recrutio/HOME/buttom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String? userProfession = 'Software Developer'; // Replace with the user's selected profession
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('jobPostings').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final jobPostings = snapshot.data!.docs
              .where((jobPosting) => jobPosting['profession'] == userProfession)
              .toList();

          return ListView.builder(
            itemCount: jobPostings.length,
            itemBuilder: (context, index) {
              final jobPosting = jobPostings[index].data() as Map<String, dynamic>;
              final jobTitle = jobPosting['title'];
              final jobDescription = jobPosting['description'];

              return Card(
                child: ListTile(
                  title: Text(jobTitle),
                  subtitle: Text(jobDescription),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
