import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../LOGIN/login.dart';
import 'buttom_navigation_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('jobs');
  double boxHeight = 100.0;
  File? _selectedFile; // Store the selected file
  bool _errorShown = false; // Flag to track if the error message is shown

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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            automaticallyImplyLeading: false,
          ),
        ),
        body: Column(
          children: [
            ListTile(
              trailing: IconButton(
                icon: const Icon(
                  Icons.exit_to_app,
                  size: 29,
                ),
                onPressed: () {
                  _logout(context);
                },
              ),
              title: const Text(
                "Here's Your Dream Job",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        _showJobDetails(context, snapshot);
                      },
                      child: Container(
                        height: boxHeight,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                snapshot.child('companyName').value.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                snapshot.child('jobTitle').value.toString(),
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onTabSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
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

  void _showJobDetails(BuildContext context, DataSnapshot snapshot) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context, snapshot),
        );
      },
    );
  }

  void _showApplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: applyDialogContent(context),
        );
      },
    ).then((result) {
      // Reset the error flag when the dialog is closed
      _errorShown = false;
    });
  }

  Widget contentBox(BuildContext context, DataSnapshot snapshot) {
    String companyName = snapshot.child('companyName').value.toString();
    String jobTitle = snapshot.child('jobTitle').value.toString();
    String workplaceType = snapshot.child('workplaceType').value.toString();
    String jobType = snapshot.child('jobType').value.toString();
    String location = snapshot.child('location').value.toString();
    String jobDescription = snapshot.child('jobDescription').value.toString();
    String email = snapshot.child('email').value.toString();

    return Stack(
      children: <Widget>[
        Container(
          width: 350,
          height: 430,
          padding: const EdgeInsets.all(34.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 10),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                companyName,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                jobTitle,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 25.0),
              Text(
                'Company Name: $companyName',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Job Title: $jobTitle',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Workplace Type: $workplaceType',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Job Type: $jobType',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Location: $location',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Job Description: $jobDescription',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Email: $email',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _showApplyDialog(context);
                  },
                  child: const Text('Apply'),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget applyDialogContent(BuildContext context) {
    bool isUploading = false; // Track the upload status

    return Stack(
      children: <Widget>[
        Container(
          width: 350,
          height: 300,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 10),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Apply for Job',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _selectFile(); // Call the function to select a file
                },
                child: const Text('Upload CV (PDF)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_selectedFile != null) {
                    setState(() {
                      isUploading = true; // Set uploading to true
                    });
                    _uploadFile(_selectedFile!).then((_) {
                      setState(() {
                        isUploading = false; // Set uploading to false when done
                      });
                      Navigator.of(context).pop(); // Close the dialog on success
                    });
                  } else {
                    // Show an error message if no file is selected
                    _showErrorMessage(context, 'Please select a CV (PDF) file.');
                    // Set the error flag to true
                    _errorShown = true;
                  }
                },
                child: isUploading
                    ? const CircularProgressIndicator() // Show loader when uploading
                    : const Text('Confirm Apply'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      print('Error selecting file: $e');
    }
  }

  Future<void> _uploadFile(File file) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String uid = auth.currentUser!.uid;
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = '$uid-$timestamp.pdf';

      Reference ref = storage.ref().child('user_cv').child(fileName);

      UploadTask uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'application/pdf', // Change to your file type
        ),
      );

      await uploadTask;
    } catch (e) {
      print('Error uploading file: $e');
      // Display an error message here
      _showErrorMessage(context, 'An error occurred while uploading the file.');
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
