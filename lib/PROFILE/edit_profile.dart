// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:Recrutio/PROFILE/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ExperienceDetails {
  String companyName;
  String post;
  int yearFrom; // Year from when you joined
  int yearTill; // Year till when you ended

  ExperienceDetails({
    required this.companyName,
    required this.post,
    required this.yearFrom,
    required this.yearTill,
  });

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'post': post,
      'yearFrom': yearFrom,
      'yearTill': yearTill,
    };
  }

  factory ExperienceDetails.fromMap(Map<String, dynamic> map) {
    return ExperienceDetails(
      companyName: map['companyName'] ?? '',
      post: map['post'] ?? '',
      yearFrom: map['yearFrom'] ?? 0,
      yearTill: map['yearTill'] ?? 0,
    );
  }
}

class EducationDetails {
  String institutionName;
  String degree;
  int yearFrom; // Year from when you started
  int yearTill; // Year till when you completed

  EducationDetails({
    required this.institutionName,
    required this.degree,
    required this.yearFrom,
    required this.yearTill,
  });

  Map<String, dynamic> toMap() {
    return {
      'institutionName': institutionName,
      'degree': degree,
      'yearFrom': yearFrom,
      'yearTill': yearTill,
    };
  }

  factory EducationDetails.fromMap(Map<String, dynamic> map) {
    return EducationDetails(
      institutionName: map['institutionName'] ?? '',
      degree: map['degree'] ?? '',
      yearFrom: map['yearFrom']  ,
      yearTill: map['yearTill']  ,
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }


  late String _name;
  late String _profession;
  late String _aboutMe;
  late String _githubLink;
  late String _linkedinLink;
  late List<ExperienceDetails> _experienceDetails = [];
  late List<EducationDetails> _educationDetails = [];
  String? _selectedProfession;
  String? _profileImageUrl;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _githubLinkController = TextEditingController();
  final TextEditingController _linkedinLinkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();




  // Modify the _pickImage function to save the image to Firebase Storage and update profileImageUrl
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      // User canceled image selection, do nothing.
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not logged in.
      return;
    }

    final uid = user.uid;
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('profile_images/$uid/${const Uuid().v4()}'); // Generate a unique filename

    try {
      // Upload the image to Firebase Storage
      await ref.putFile(File(image.path));

      // Get the download URL of the uploaded image
      final imageUrl = await ref.getDownloadURL();

      if (imageUrl != null) {
        // Save the image URL to Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profileImageUrl': imageUrl,
        });

        setState(() {
          _profileImageUrl = imageUrl;
        });
      } else {
        // Handle the case where imageUrl is null
        print('Image URL is null');
      }
    } catch (error) {
      // Handle any errors that occurred during the upload
      print('Image upload error: $error');
    }
  }






  Future<void> fetchProfileData() async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;


    if (user != null) {
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _name = data['name'] ?? '';
          _profession = data['profession'] ?? '';
          _aboutMe = data['aboutMe'] ?? '';
          _githubLink = data['githubLink'] ?? '';
          _linkedinLink = data['linkedinLink'] ?? '';
          _experienceDetails = (data['experienceDetails'] as List<dynamic>?)
              ?.map((item) => ExperienceDetails.fromMap(item))
              .toList() ??
              [];
          _educationDetails = (data['educationDetails'] as List<dynamic>?)
              ?.map((item) => EducationDetails.fromMap(item))
              .toList() ??
              [];

          _selectedProfession = _profession.isNotEmpty ? _profession : _professions[0];

        });
      }
    }
  }

  // Function to save edited profile data to Firebase
  Future<void> saveProfileDataToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;



    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(user.uid).set({
        'name': _name,
        'profession': _selectedProfession,
        'aboutMe': _aboutMe,
        'githubLink': _githubLink,
        'linkedinLink': _linkedinLink,
        'experienceDetails': _experienceDetails.map((experience) => experience.toMap()).toList(),
        'educationDetails': _educationDetails.map((education) => education.toMap()).toList(),
        'profileImageUrl': _profileImageUrl,
      });

      _selectedProfession = _profession.isNotEmpty ? _profession : _professions[0];




      // After saving, navigate back to the profile page or any other page as needed.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  //image change
  late final List<String> _professions = [
    'Profession',
    'Software Developer',
    'Web Developer',
    'UI/UX Designer',
    'Data Scientist',
    'Product Manager',
    // Add more professions as needed
  ];

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    fetchProfileData();
    fetchProfileImageUrl(); // Add this line to fetch the profile image URL.
  }

// Add this function to fetch the profile image URL from Firestore.
  Future<void> fetchProfileImageUrl() async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        final profileImageUrl = data['profileImageUrl'] as String?;
        setState(() {
          _profileImageUrl = profileImageUrl;
        });
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF494946),
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImage(); // Open the image picker dialog
                  },
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum vertical space
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _profileImageUrl != null
                                  ? NetworkImage(_profileImageUrl!)
                                  : const AssetImage('assets/images/profile/usericon.png') as ImageProvider<Object>, // Use AssetImage for an image from assets
                            ),
                          ),
                        ),
                        const SizedBox(height: 8), // Add spacing between the image and text
                        const Text(
                          'Change Image',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedProfession,
                  items: _professions.map((String profession) {
                    return DropdownMenuItem<String>(
                      value: profession,
                      child: Text(profession),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedProfession = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Profession',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _aboutMeController,
                  decoration: const InputDecoration(
                    labelText: 'About Me',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _aboutMe = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _githubLinkController,
                  decoration: const InputDecoration(
                    labelText: 'GitHub Link',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _githubLink = value;
                    });
                    _validateGitHubLink(value);
                  },
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: _linkedinLinkController,
                  decoration: const InputDecoration(
                    labelText: 'LinkedIn Link',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _linkedinLink = value;
                    });
                    _validateLinkedInLink(value);
                  },
                ),

                const SizedBox(height: 20),

                // Edit Experience Details
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Text(
                      'Edit Experience Details:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: _experienceDetails.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final ExperienceDetails experience = entry.value;
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  initialValue: experience.companyName,
                                  decoration: const InputDecoration(
                                    labelText: 'Company Name',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      experience.companyName = value;
                                    });
                                  },
                                ),
                                TextFormField(
                                  initialValue: experience.post,
                                  decoration: const InputDecoration(
                                    labelText: 'Post',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      experience.post = value;
                                    });
                                  },
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: experience.yearFrom.toString(),
                                        decoration: const InputDecoration(
                                          labelText: 'Year From',
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            experience.yearFrom = int.tryParse(value) ?? 0;
                                          });
                                        },
                                      ),
                                    ),
                                    const Text(
                                      ' - ',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: experience.yearTill.toString(),
                                        decoration: const InputDecoration(
                                          labelText: 'Year Till',
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            experience.yearTill = int.tryParse(value) ?? 0;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _experienceDetails.removeAt(index);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                      'Remove',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _experienceDetails.add(
                            ExperienceDetails(
                              companyName: '',
                              post: '',
                              yearFrom: 0,
                              yearTill: 0,
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[200],
                      ),
                      child: const Text(
                          'Add Experience',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),



                const SizedBox(height: 20),
                Column(
                  children: [
                    const Text(
                      'Edit Education Details:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: _educationDetails.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final EducationDetails education = entry.value;
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  initialValue: education.institutionName,
                                  decoration: const InputDecoration(
                                    labelText: 'Institution Name',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      education.institutionName = value;
                                    });
                                  },
                                ),
                                TextFormField(
                                  initialValue: education.degree,
                                  decoration: const InputDecoration(
                                    labelText: 'Degree',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      education.degree = value;
                                    });
                                  },
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: education.yearFrom.toString(),
                                        decoration: const InputDecoration(
                                          labelText: 'Year From',
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            education.yearFrom = int.tryParse(value) ?? 0;
                                          });
                                        },
                                      ),
                                    ),
                                    const Text(
                                      ' - ',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: education.yearTill.toString(),
                                        decoration: const InputDecoration(
                                          labelText: 'Year Till',
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            education.yearTill = int.tryParse(value) ?? 0;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _educationDetails.removeAt(index);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white
                                  ),
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _educationDetails.add(
                            EducationDetails(
                              institutionName: '',
                              degree: '',
                              yearFrom: 0,
                              yearTill: 0,
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[200],                      ),
                      child: const Text(
                        'Add Education',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (validateFields()) {
                      // Save the profile data to Firebase.
                      saveProfileDataToFirebase();
                    } else {
                      // Show an error message or take other action.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all required fields.'),
                        ),
                      );
                    }
                  },

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
                      "Save",
                      style: TextStyle(
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


  bool validateFields() {
    // Check if at least one of the following conditions is met:
    // 1. Profession is not empty.
    // 2. About Me is not empty.
    // 3. At least one experience detail has either companyName, post, or non-zero yearFrom/yearTill.
    // 4. At least one education detail has either institutionName, degree, or non-zero yearFrom/yearTill.

    if (_profession.isNotEmpty || _aboutMe.isNotEmpty) {
      return true; // If either profession or aboutMe is filled, return true.
    }

    // Check if there's at least one experience detail with non-empty companyName or post or non-zero yearFrom/yearTill.
    if (_experienceDetails.any((experience) {
      return experience.companyName.isNotEmpty ||
          experience.post.isNotEmpty ||
          (experience.yearFrom != 0 && experience.yearTill != 0);
    })) {
      return true;
    }

    // Check if there's at least one education detail with non-empty institutionName or degree or non-zero yearFrom/yearTill.
    if (_educationDetails.any((education) {
      return education.institutionName.isNotEmpty ||
          education.degree.isNotEmpty ||
          (education.yearFrom != 0 && education.yearTill != 0);
    })) {
      return true;
    }

    return false; // If none of the conditions are met, return false.
  }



  // github
  void _validateGitHubLink(String url) {
    final validGitHubUrlPattern = RegExp(
      r'^github.com/[a-zA-Z0-9-]+/?$',
    );

    if (!validGitHubUrlPattern.hasMatch(url)) {
      // Invalid GitHub URL
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid GitHub URL. Please enter a valid GitHub profile URL.'),
        ),
      );

      // Clear the field or take appropriate action
      setState(() {
        _githubLink = '';
        _githubLinkController.clear();
      });
    }
  }

  //linkedin
  void _validateLinkedInLink(String url) {
    final validLinkedInUrlPattern = RegExp(
      r'^https?://www.linkedin.com/in/[a-zA-Z0-9-]+/?$',
    );


    if (!validLinkedInUrlPattern.hasMatch(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid LinkedIn URL. Please enter a valid LinkedIn profile URL.'),
        ),
      );

      setState(() {
        _linkedinLink = '';
        _linkedinLinkController.clear();
      });
    }
  }


}
