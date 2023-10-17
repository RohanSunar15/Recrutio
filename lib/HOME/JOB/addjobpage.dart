import 'package:Recrutio/HOME/buttom_navigation_bar.dart';
import 'package:Recrutio/HOME/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MaterialApp(home: AddJobPage()));
}

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);


  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {

  int _selectedIndex = 2;
  // Firebase Realtime Database reference
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref();

  String? _selectedWorkplaceType;
  String? _selectedJobType;
  String? _selectedLocation;
  String? _jobDescription;
  String? _contactNumber;
  String? _email;
  bool _isPostButtonClicked = false; // Flag to track if the "Post" button is clicked
  String? _selectedJobTitle;

  final List<String> _jobTitles = [
    'Assistant',
    'Full-Stack Developer',
    'Associate',
    // ... (your job titles)
    'CA',
  ];

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late SimpleAutoCompleteTextField _jobTitleTextField;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _jobTitleTextField = SimpleAutoCompleteTextField(
      key: GlobalKey(),
      suggestions: _jobTitles,
      textChanged: (text) {},
      clearOnSubmit: false,
      textSubmitted: (text) {
        setState(() {
          _selectedJobTitle = text;
        });
      },
      decoration: InputDecoration(
        hintText: 'Job Title',
        labelText: 'Job Title',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: const Color(0xFCFFFFFF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
      ),
    );
  }


  void _handlePostButtonPressed() {
    setState(() {
      _isPostButtonClicked = true;
    });

    if (_formKey.currentState!.validate()) {
      // Get values from form fields and dropdowns
      final companyName = _companyNameController.text;
      final jobTitle = _selectedJobTitle;
      final workplaceType = _selectedWorkplaceType;
      final jobType = _selectedJobType;
      final location = _selectedLocation;
      final jobDescription = _jobDescription;
      final contactNumber = _contactNumber;
      final email = _email;

      // Define a unique key for the job posting (you can use push() to generate one)
      final jobKey = _databaseReference.child('jobs').push().key;

      // Create a map of the job data
      final jobData = {
        'companyName': companyName,
        'jobTitle': jobTitle,
        'workplaceType': workplaceType,
        'jobType': jobType,
        'location': location,
        'jobDescription': jobDescription,
        'contactNumber': contactNumber,
        'email': email,
      };

      // Store the job data in the Firebase Realtime Database under 'jobs' with the unique key
      _databaseReference.child('jobs').child(jobKey!).set(jobData);

      // Store the job data in Firebase Firestore
      final firestore = FirebaseFirestore.instance;
      firestore.collection('jobs').add(jobData);

      // Data added successfully
      print('Job data added to Firebase Realtime Database and Firestore.');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );

      // Display a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job posted successfully!'),
        ),
      );
    }
  }

  InputDecoration _getInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      labelText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      filled: true,
      fillColor: const Color(0xFCFFFFFF),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
    );
  }

  bool _isValidPhoneNumber(String? value) {
    if (value == null) return false;
    return RegExp(r'^[0-9]{10}$').hasMatch(value);
  }

  bool _isValidEmail(String? value) {
    if (value == null) return false;
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF494946),
        title: const Text('ADD JOB'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _companyNameController,
                  hintText: 'Company Name',
                  validator: (value) {
                    if (_isPostButtonClicked && (value == null || value.isEmpty)) {
                      return 'Company Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _jobTitleTextField,
                if (_isPostButtonClicked && (_selectedJobTitle == null || _selectedJobTitle!.isEmpty))
                  const Text(
                    'Job Title is required',
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                _buildDropdown(
                  value: _selectedWorkplaceType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedWorkplaceType = newValue;
                    });
                  },
                  items: <String>[
                    'On-site',
                    'Remote',
                    'Hybrid',
                  ],
                  hintText: 'Workplace Type',
                  validator: (value) {
                    if (_isPostButtonClicked && (value == null || value.isEmpty)) {
                      return 'Workplace Type is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildDropdown(
                  value: _selectedJobType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedJobType = newValue;
                    });
                  },
                  items: <String>[
                    'Full-Time',
                    'Part-Time',
                    'Contract',
                    'Temporary',
                    'Volunteer',
                    'Internship',
                    'Other',
                  ],
                  hintText: 'Job Type',
                  validator: (value) {
                    if (_isPostButtonClicked && (value == null || value.isEmpty)) {
                      return 'Job Type is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _locationController,
                  hintText: 'Location',
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value;
                    });
                  },
                  validator: (value) {
                    if (_isPostButtonClicked && (value == null || value.isEmpty)) {
                      return 'Location is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _descriptionController,
                  hintText: 'Job Description',
                  onChanged: (value) {
                    setState(() {
                      _jobDescription = value;
                    });
                  },
                  maxLines: 7,
                  validator: (value) {
                    if (_isPostButtonClicked && (value == null || value.isEmpty)) {
                      return 'Job Description is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _contactController,
                  hintText: 'Contact Number',
                  onChanged: (value) {
                    setState(() {
                      _contactNumber = value;
                    });
                  },
                  validator: (value) {
                    if (_isPostButtonClicked && (value == null || value.isEmpty)) {
                      return 'Contact Number is required';
                    }
                    if (_isPostButtonClicked && !_isValidPhoneNumber(value)) {
                      return 'Invalid contact number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  validator: (value) {
                    if (_isPostButtonClicked && (value == null || value.isEmpty)) {
                      return 'Email is required';
                    }
                    if (_isPostButtonClicked && !_isValidEmail(value)) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: _handlePostButtonPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // Change the background color to black
          // Change the text color to white
        ),
        child: const Text(
          'Post Now', // Replace the icon with "Post Now" text
          style: TextStyle(fontSize: 18), // Adjust text size if needed
        ),
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    ValueChanged<String>? onChanged,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0x7EFFFFFF),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: _getInputDecoration(hintText),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required Function(String?)? onChanged,
    required List<String> items,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return Container(
      width: 480,
      height: 50,
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        decoration: _getInputDecoration(hintText),
        validator: validator,
      ),
    );
  }
}


