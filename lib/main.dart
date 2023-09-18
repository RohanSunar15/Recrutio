import 'package:Recrutio/HOME/homescreen.dart';
import 'package:Recrutio/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Recrutio/LOGIN/login.dart';
import 'package:Recrutio/authentication _repo/authentication_repo.dart';
import 'package:get/get.dart';
import 'package:Recrutio/ANIMATION/lottieanimation.dart';

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
        '/home': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/animation':(BuildContext context) => const LottieAnimation(),
      },
      home:  const LoginPage(),
    );
  }
}
