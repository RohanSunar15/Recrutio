import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
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

  void _handlePostButtonPressed() {
    setState(() {
      _isPostButtonClicked = true;
    });

    if (_formKey.currentState!.validate()) {
      // Call the function to store data in Firestore
     // _storeJobDataInFirestore();
    }
  }

  // Initialize Firebase
  // final FirebaseApp app = Firebase.apps.first;
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //
  // // Function to store job data in Firestore
  // void _storeJobDataInFirestore() async {
  //   try {
  //     await firestore.collection('jobs').add({
  //       'companyName': _companyNameController.text,
  //       'jobTitle': _selectedJobTitle,
  //       'workplaceType': _selectedWorkplaceType,
  //       'jobType': _selectedJobType,
  //       'location': _selectedLocation,
  //       'jobDescription': _jobDescription,
  //       'contactNumber': _contactNumber,
  //       'email': _email,
  //     });
  //
  //     // Data added successfully
  //     print('Job data added to Firestore.');
  //   } catch (e) {
  //     // Handle errors
  //     print('Error adding job data to Firestore: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _handlePostButtonPressed,
        child: const Icon(Icons.send), // Use a different icon like 'Icons.send'
      ),
    );
  }

  // ... (Rest of your code)

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