import 'package:Recrutio/HOME/MESSAGE/Message.dart';
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
import 'package:Recrutio/HOME/Notification/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    Get.put(authenticationrepo());
    runApp(const MyApp());
  } catch (e) {
    print('Firebase initialization error: $e');
    // Handle the error gracefully (e.g., show an error message)
  }
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
        'notification':(BuildContext context) => const NotificationPage(),
        'message':(BuildContext context) => const ChatPage(),
        'addjob':(BuildContext context) => const AddJobPage(),
        'search':(BuildContext context) => const SearchPage(),
        'profile':(BuildContext context) => const ProfilePage(),

      },
      home:  const LoginPage(),
    );
  }
}

