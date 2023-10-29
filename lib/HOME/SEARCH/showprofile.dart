import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ShowProfilePage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF494946),
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
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
                    image: userData['profileImageUrl'] != null
                        ? NetworkImage(userData['profileImageUrl'])
                        : const AssetImage('assets/images/profile/usericon.png') as ImageProvider<Object>,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                userData['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (userData['profession'] != null)
                Text(
                  userData['profession'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: screenWidth - 40,
                child: Card(
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'About Me',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userData['aboutMe'],
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
                width: screenWidth - 40,
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
                                final linkedinProfileUrl = userData['linkedinProfile'];

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
                                } else {
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
                                final githubProfileUrl = userData['githubProfile'];

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
                                } else {
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
              // Experience Section
              if (userData['experienceDetails'] != null)
                SizedBox(
                  width: screenWidth - 40,
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
                          Column(
                            children: (userData['experienceDetails'] as List<dynamic>).map((experience) {
                              final title = experience['title'] ?? '';
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Education Section
              if (userData['educationDetails'] != null)
                SizedBox(
                  width: screenWidth - 40,
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
                          Column(
                            children: (userData['educationDetails'] as List<dynamic>).map((education) {
                              final title = education['title'] ?? '';
                              final institutionName = education['institutionName'] ?? '';
                              final degree = education['degree'] ?? '';
                              final yearFrom = education['yearFrom'] ?? '';
                              final yearTill = education['yearTill'] ?? '';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title, // Display the title for each education
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8), // Add some spacing between the title and values
                                  Text(
                                    "Institution Name: $institutionName",
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
    );
  }
}
