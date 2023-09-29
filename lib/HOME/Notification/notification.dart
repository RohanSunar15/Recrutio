import 'package:Recrutio/LOGIN/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Recrutio/HOME/buttom_navigation_bar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedIndex = 1; // Define and initialize _selectedIndex


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
            'Notification  Page',
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF494946),
          actions: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: IconButton(
                icon: const Icon(Icons.exit_to_app , size: 29,),

                onPressed: () {
                  _logout(context);// Show the logout confirmation dialog
                },
              ),
            ),
          ],
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
      ),
    );
  }
}



void _logout(context) {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
            ),
          ],
        ),
        content: const Text(
          'DO YOU WANT TO SIGN OUT?',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'NO',
              style: TextStyle(color: Colors.green, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              // Perform the actual logout action here
              // You can use Firebase Authentication or any other authentication method.
              // Once the user is logged out, you may want to navigate to a login page.
              // For now, we'll just close the app.
              _auth.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(), // Navigate to LottieAnimation page
                ),
              );
            },
            child: const Text(
              'YES',
              style: TextStyle(color: Colors.green, fontSize: 18),
            ),
          )
        ],
      );
    },
  );
}