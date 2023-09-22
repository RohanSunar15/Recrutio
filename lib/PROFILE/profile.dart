import 'package:Recrutio/HOME/buttom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int _selectedIndex = 4; // Define and initialize _selectedIndex


  final String aboutMeText = 'I am a hard working, honest individual. I am a good timekeeper, always willing to learn new skills. I am friendly, helpful and polite, have a good sense of humour. I am able to work independently in busy environments and also within a team setting.';



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
          centerTitle: true,
          backgroundColor: const Color(0xFF494946),
          title: const Text(
            'Profile',
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
        body: Scaffold(


          body: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              // COLUMN THAT WILL CONTAIN THE PROFILE
              const Column(
                children:  [
                  CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/profile/usericon.png')
                  ),
                  SizedBox(height: 10),
                  Text( 'Rohan Sunar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Junior Product Designer")
                ],
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                      height: 180,
                      width: 340,
                      child: Card(
                        shadowColor: Colors.black12,
                        child: Padding(
                          padding:  const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text('About Me ', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Text(aboutMeText, style: const TextStyle(fontSize: 14),),
                            ],
                          ),
                        ),
                      )
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Row(
                children: [
                  SizedBox(
                      height: 110,
                      width: 340,
                      child: Card(
                        shadowColor: Colors.black12,
                        child: Padding(
                          padding:  EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text('Connected Account', style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                ],

                              ),
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
                      )
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              const Row(
                children: [
                  SizedBox(
                      height: 180,
                      width: 340,
                      child: Card(
                        shadowColor: Colors.black12,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  TextButton(onPressed:ColorScheme.dark,
                                    child:Text('Experience ',
                                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),),
                                  ),
                                  TextButton(onPressed:ColorScheme.dark,
                                    child:Text('Education',
                                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black ),),
                                  )
                                ],
                              ),
                              SizedBox(height: 5,),
                            ],
                          ),
                        ),
                      )
                  ),
                ],
              ),
              GestureDetector(

                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    color:  Colors.white,
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                      color: Colors.black
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 5, // How much the shadow should spread
                        blurRadius: 7, // How blurry the shadow should be
                        offset: const Offset(0, 3), // Offset of the shadow
                      ),
                    ],
                    ),
                  child: const Text("Logout",
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
    );

  }
}
