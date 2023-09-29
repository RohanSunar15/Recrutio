// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:Recrutio/LOGIN/login.dart';
import 'package:Recrutio/HOME/buttom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Recrutio/PROFILE/edit_profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4;
  late String name = 'Loading...';// Declare 'name' variable
  String? profileImageUrl;

  String aboutMeText ='Tell us something about You';

  late List<String> educationDetails = [
    'Update Your Education Details ',
  ];

  List<String> experienceDetails = [
    'Update Your Experience Details',
  ];

  Future<void> initializeFirebase() async {
    //firebase storage
    FirebaseStorage.instance.ref();
  }


  Future<void> updateProfilePictureURL(String url) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userId = getCurrentUserId();

      await firestore.collection('users').doc(userId).update({
        'profileImageUrl': url,
      });
    } catch (e) {
      print('Error updating profile picture URL: $e');
      // Handle the error as needed
    }
  }


  // Fetch the name from Firebase
  Future<String> fetchName() async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = await firestore.collection('users').doc(getCurrentUserId()).get();


    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      final fetchedName = data['name'] as String;
      return fetchedName;
    } else {
      return 'Name not found';
    }
  }

  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return 'User not authenticated';
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    fetchName().then((fetchedName) {
      setState(() {
        name = fetchedName;
      });
    });


// to fetch user profile data
    Future<Map<String, dynamic>?> fetchUserProfileData() async {
      final firestore = FirebaseFirestore.instance;
      final userDoc = await firestore.collection('users').doc(getCurrentUserId()).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return data;
      } else {
        return null; // User profile data not found
      }
    }
    // Fetch user profile information (e.g., aboutMeText, educationDetails, experienceDetails)
    fetchUserProfileData().then((userData) {
      if (userData != null) {
        setState(() {
          aboutMeText = userData['aboutMe'] ?? aboutMeText;
          educationDetails = userData['educationDetails'] ?? educationDetails;
          experienceDetails = userData['experienceDetails'] != null
              ? List<String>.from(userData['experienceDetails'])
              : [];
        });
      }
    });
  }


  Future<Map<String, dynamic>?> fetchUserProfileData() async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = await firestore.collection('users').doc(getCurrentUserId()).get();

    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      return data;
    } else {
      return null; // User profile data not found
    }
  }






  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF494946),
        title: const Text('Profile'),

      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),

      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white24, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            stops: [0.2, 0.9],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth >= 600 ? 40 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!) // Cast to ImageProvider<Object>
                          : const AssetImage('assets/images/profile/usericon.png') as ImageProvider<Object>, // Cast to ImageProvider<Object>
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                Text( name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FutureBuilder(
                  future: fetchUserProfileData(),
                  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading...'); // Show a loading indicator while fetching data.
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('Profession not found'); // Handle case where data is not available.
                    } else {
                      final profession = snapshot.data!['profession'] as String;
                      return Text(
                        profession,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Card(
                    shadowColor: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About Me ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            aboutMeText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Connected Account Section
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connected Account',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(

                            children: [
                              SizedBox(height: 10,),
                              IconButton( icon: Icon(LineAwesomeIcons.linkedin, size: 35,color: Colors.blue,), onPressed: ColorScheme.dark),
                              IconButton( icon: Icon(LineAwesomeIcons.github, size: 35,color: Colors.black,), onPressed: ColorScheme.dark),
                              IconButton( icon: Icon(LineAwesomeIcons.twitter, size: 35,color: Colors.blue,), onPressed: ColorScheme.dark),
                              IconButton( icon: Icon(LineAwesomeIcons.facebook , size: 35,color: Colors.lightBlue,), onPressed: ColorScheme.dark),
                              IconButton( icon: Icon(LineAwesomeIcons.instagram, size: 35,color: Colors.pinkAccent,), onPressed: ColorScheme.dark),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),


                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Card(
                    shadowColor: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Education',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (String detail in educationDetails)
                            Text(detail ,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Card(
                    shadowColor: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Experience',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (String detail in experienceDetails)
                            Text(
                              detail,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  }
