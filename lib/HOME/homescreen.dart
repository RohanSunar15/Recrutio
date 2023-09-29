import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:file_picker/file_picker.dart';
import '../LOGIN/login.dart';
import 'buttom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Define and initialize _selectedIndex

  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('jobs');

  // Adjust the height of the box here
  double boxHeight = 100.0;

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
          preferredSize: const Size.fromHeight(0), // Remove AppBar
          child: AppBar(
            automaticallyImplyLeading: false, // Remove back button
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
                  _logout(context); // Show the logout confirmation dialog
                },
              ),
              title: const Text(
                "Here's Your Dream Job",
                style: TextStyle(
                  fontSize: 28, // Increase the font size
                  color: Colors.blue, // Change the text color
                  fontWeight: FontWeight.bold, // Add FontWeight if needed
                ),
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  // Wrap each item in a Card with adjustable height
                  return Card(
                    elevation: 2, // Add elevation for a shadow effect
                    margin: const EdgeInsets.all(10), // Adjust the margin as needed
                    child: InkWell(
                      onTap: () {
                        _showJobDetails(context, snapshot);
                      },
                      child: Container(
                        height: boxHeight, // Set the desired height for the box
                        padding: const EdgeInsets.all(16.0), // Add padding for content
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
                                  fontSize: 20, // Optional: Make the company name bold
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
                                  fontSize: 18, // Optional: Make the job title italic
                                ),
                              ),
                            ),
                            // You can add more information here
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

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Sign Out',
            style: TextStyle(color: Colors.white, fontSize: 26),
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
    // Extract job details from the snapshot
    String companyName = snapshot.child('companyName').value.toString();
    String jobTitle = snapshot.child('jobTitle').value.toString();
    String workplaceType = snapshot.child('workplaceType').value.toString();
    String jobType = snapshot.child('jobType').value.toString();
    String location = snapshot.child('location').value.toString();
    String jobDescription = snapshot.child('jobDescription').value.toString();
    String contactNumber = snapshot.child('contactNumber').value.toString();
    String email = snapshot.child('email').value.toString();

    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing dialog by tapping outside
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(
            context,
            companyName,
            jobTitle,
            workplaceType,
            jobType,
            location,
            jobDescription,
            contactNumber,
            email,
          ),
        );
      },
    );
  }

  void _showApplyDialog(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // Specify the file type you want to pick (e.g., FileType.any for any file type)
      allowedExtensions: ['pdf'], // Specify allowed file extensions (e.g., PDF)
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      // Use the 'file' object to access the selected file
      // You can save or process the file as needed
    }

    Navigator.of(context).pop(); // Close the dialog
  }

  Widget contentBox(
      BuildContext context,
      String companyName,
      String jobTitle,
      String workplaceType,
      String jobType,
      String location,
      String jobDescription,
      String contactNumber,
      String email,
      ) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width + 100,
          width: 600,
          // Adjust the width and height of the dialog box
          padding: const EdgeInsets.all(10.0), // Add padding for content
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
              const SizedBox(height: 30.0),
              Text(
                'Company Name: $companyName',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10), // Increased spacing
              Text(
                'Job Title: $jobTitle',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10), // Increased spacing
              Text(
                'Workplace Type: $workplaceType',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16, // Increase the font size
                ),
              ),
              const SizedBox(height: 10), // Increased spacing
              Text(
                'Job Type: $jobType',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16, // Increase the font size
                ),
              ),
              const SizedBox(height: 10), // Increased spacing
              Text(
                'Location: $location',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16, // Increase the font size
                ),
              ),
              const SizedBox(height: 10), // Increased spacing
              Text(
                'Job Description: $jobDescription',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16, // Increase the font size
                ),
              ),
              const SizedBox(height: 10), // Increased spacing
              Text(
                'Contact Number: $contactNumber',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16, // Increase the font size
                ),
              ),
              const SizedBox(height: 10), // Increased spacing
              Text(
                'Email: $email',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16, // Increase the font size
                ),
              ),
              const SizedBox(height: 20), // Increased spacing
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _showApplyDialog(context); // Show the file picking dialog
                  },
                  child: const Text('Upload CV (PDF)'),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Close'), // Close button
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
