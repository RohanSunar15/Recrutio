// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Recrutio/LOGIN/login.dart'; // Import LoginPage from login.dart
import 'package:Recrutio/HOME/buttom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Recrutio/PROFILE/edit_profile.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4;
  late String name = 'Loading...'; // Declare 'name' variable
  String? profileImageUrl;
  // List<Map<String, dynamic>> userJobPostings = [];

  String aboutMeText = '';

  late List<String> educationDetails = [
    'Update Your Education Details ',
  ];

  List<String> experienceDetails = [
    'Update Your Experience Details',
  ];

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return 'User not authenticated';
    }
  }


// Add this function to fetch the profile image URL from Firestore.
  Future<void> fetchProfileImageUrl() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        final profileImageUrl = data['profileImageUrl'] as String?;
        setState(() {
          this.profileImageUrl = profileImageUrl;
        });
      }
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
  Future<String> fetchAboutMeText() async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = await firestore.collection('users').doc(getCurrentUserId()).get();

    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      final aboutMe = data['aboutMe'] as String;
      print('About Me: $aboutMe'); // Add this line to check the value
      return aboutMe;
    } else {
      print('About Me: Not found'); // Add this line to check if it's not found
      return 'Tell us something about You';
    }
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



  // Fetch experience data from Firestore
  Future<List<Map<String, dynamic>>> fetchExperienceData() async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> details = [];

    if (user != null) {
      try {
        final userDoc = await firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          final experienceData = data['experienceDetails'];

          if (experienceData != null && experienceData is List) {
            // Check if experienceData is not null and is a List
            details = experienceData.map((exp) {
              final title = exp['title'] ?? '';
              final companyName = exp['companyName'] ?? '';
              final post = exp['post'] ?? '';
              final yearFrom = exp['yearFrom'] ?? '';
              final yearTill = exp['yearTill'] ?? '';

              return {
                'title': title,
                'companyName': companyName,
                'post': post,
                'yearFrom': yearFrom,
                'yearTill': yearTill,
              };
            }).toList();
          }
        }
      } catch (e) {
        print("Error fetching experience data: $e");
      }
    }

    return details; // Return an empty list if no data is available or an error occurs.
  }





  // Fetch education data from Firestore
  Future<List<Map<String, dynamic>>>  fetchEducationData() async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final userDoc = await firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          final educationData = data['educationDetails'] as List<dynamic>;

          // Map the education details to a list of strings
          final details = educationData.map((edu) {
            final title = edu['title'] ?? '';
            final institutionName = edu['institutionName'] ?? '';
            final degree = edu['degree'] ?? '';
            final yearFrom = edu['yearFrom'] ?? '';
            final yearTill = edu['yearTill'] ?? '';

            return {
              'title': title,
              'InstitutionName': institutionName,
              'Degree': degree,
              'yearFrom': yearFrom,
              'yearTill': yearTill,
            };
          }).toList();

          return details;
        }
      } catch (e) {
        print("Error fetching experience data: $e");
      }
    }

    return []; // Return an empty list if no data is available or an error occurs.
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
    fetchProfileImageUrl();
    fetchAboutMeText().then((aboutMe) {
      setState(() {
        aboutMeText = aboutMe;
      });
    });// Call this function to fetch and update the profile image URL
    fetchExperienceData();
    fetchEducationData();
    // Fetch user job postings when the page is loaded
    // fetchUserJobPostings();
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
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  iconSize: 40,// You can change the icon to a cross sign icon
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 100,
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
                    ),

                  const SizedBox(height: 2),
                    GestureDetector(
                      onTap: () {
                        _logout(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 150,
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
                  ),
                ],
              ),
            ),
          ],
        ),
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
                const SizedBox(height: 15),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!)
                          : const AssetImage('assets/images/profile/usericon.png') as ImageProvider<Object>,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
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
                      return const Text('Profession not found');
                    } else {
                      final profession = snapshot.data!['profession'] as String?;
                      if (profession != null) {
                        return Text(
                          profession,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const Text('');
                      }
                    }
                  },
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Card(
                    shadowColor: Colors.black,
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
                            aboutMeText.isEmpty ? 'Tell us something about You' : aboutMeText,
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
                // Connected Account Section
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Connected Account',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              IconButton(
                                icon: const Icon(LineAwesomeIcons.linkedin, size: 35, color: Colors.blue),
                                onPressed: () async {
                                  final userProfileData = await fetchUserProfileData();
                                  final linkedinProfileUrl = userProfileData?['linkedinProfile'];

                                  if (linkedinProfileUrl != null) {
                                    try {
                                      await launchUrl(linkedinProfileUrl);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error: $e'),
                                        ),
                                      );
                                    }
                                  }
                                  else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('LinkedIn profile URL is missing or invalid.'),
                                      ),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(LineAwesomeIcons.github, size: 35, color: Colors.black),
                                onPressed: () async {
                                  final userProfileData = await fetchUserProfileData();
                                  final githubProfileUrl = userProfileData?['githubProfile'];

                                  if (githubProfileUrl != null) {
                                    try {
                                      await launchUrl(githubProfileUrl);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error: $e'),
                                        ),
                                      );
                                    }
                                  }
                                  else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('GitHub profile URL is missing or invalid.'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
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

                    shadowColor: Colors.black,
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
                          FutureBuilder<List<Map<String, dynamic>>?>(
                            future: fetchExperienceData(),
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text('Loading...'); // Show a loading indicator while fetching data.
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                                return const Text('No experience data found');
                              } else {
                                final experienceData = snapshot.data!;
                                return Column(
                                  children: experienceData.map((experience) {
                                    final title = experience['title'];
                                    final companyName = experience['companyName'] ?? '';
                                    final post = experience['post'] ?? '';
                                    final yearFrom = experience['yearFrom'] ?? '';
                                    final yearTill = experience['yearTill'] ?? '';

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title, // Display the title for each experience
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8), // Add some spacing between the title and values
                                        Text(
                                          "Company Name: $companyName",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "Post: $post",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "Year: $yearFrom - $yearTill",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    );
                                  }).toList(),
                                );
                              }
                            },
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
                    shadowColor: Colors.black,
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
                          FutureBuilder(
                            future: fetchEducationData(),
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text('Loading...'); // Show a loading indicator while fetching data.
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                                return const Text('No education data found');
                              } else {
                                final experienceData = snapshot.data!;
                                return Column(
                                  children: experienceData.map((experience) {
                                    final title = experience['title'];
                                    final institutionName  = experience['institutionName'] ?? '';
                                    final degree = experience['degree'] ?? '';
                                    final yearFrom = experience['yearFrom'] ?? '';
                                    final yearTill = experience['yearTill'] ?? '';

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title, // Display the title for each experience
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8), // Add some spacing between the title and values
                                        Text(
                                          "Company Name: $institutionName",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "Degree: $degree",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "Year: $yearFrom - $yearTill",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                        ],
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
  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Sign Out',
            style: TextStyle(color: Colors.black, fontSize: 26),
          ),
          content: const Text(
            'DO YOU WANT TO SIGN OUT?',
            style: TextStyle(
              color: Colors.red,
              fontSize: 17,
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
                _auth.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(), // Navigate to LoginPage
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
}
