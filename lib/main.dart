import 'package:Recrutio/HOME/MESSAGE/messagepage.dart';
import 'package:Recrutio/HOME/SEARCH/search.dart';
import 'package:Recrutio/HOME/homescreen.dart';
import 'package:Recrutio/PROFILE/profile.dart';
import 'package:Recrutio/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Recrutio/LOGIN/login.dart';
import 'package:Recrutio/authentication _repo/authentication_repo.dart';
import 'package:get/get.dart';
import 'package:Recrutio/ANIMATION/lottieanimation.dart';
import 'package:Recrutio/HOME/JOB/addjobpage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
     .then((value) => Get.put(authenticationrepo()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recruito',
      theme: ThemeData(),
      routes: <String, WidgetBuilder> {
        'home': (BuildContext context) => const HomePage(),
        'login': (BuildContext context) => const LoginPage(),
        'animation':(BuildContext context) => const LottieAnimation(),
        'message':(BuildContext context) => const MessagePage(),
        'addjob':(BuildContext context) => const AddJobPage(),
        'search':(BuildContext context) => const SearchPage(),
        'profile':(BuildContext context) => const ProfilePage(),

      },
      home:  LoginPage(),
    );
  }
}

