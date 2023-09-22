import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final int _selectedIndex = 4;

  // Text editing controllers for user details
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize text editing controllers with current user data
    _nameController.text = "Rohan Sunar"; // Replace with actual user data
    _jobTitleController.text = "Junior Product Designer"; // Replace with actual user data
    _aboutMeController.text =
    "I am a hard working, honest individual. I am a good timekeeper, always willing to learn new skills. I am friendly, helpful and polite."; // Replace with actual user data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF494946),
        title: const Text(
          'Editing Profile',
        ),
      ),
      body: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile/usericon.png'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: _jobTitleController,
                  decoration: InputDecoration(labelText: 'Job Title'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              width: 340,
              child: Card(
                shadowColor: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text('About Me ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _aboutMeController,
                        maxLines: null, // Allow multi-line input
                        maxLength: 200, // Set the maximum character limit
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Tell something about yourself...',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            // Add more form fields for other profile details
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement logic to update the user's profile with the new data
          final updatedName = _nameController.text;
          final updatedJobTitle = _jobTitleController.text;
          final updatedAboutMe = _aboutMeController.text;
          // You can send this data to an API or update it in some way
          // For now, we'll just print it
          print('Name: $updatedName, Job Title: $updatedJobTitle, About Me: $updatedAboutMe');
          // You can also use Navigator.pop to go back to the previous screen
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
