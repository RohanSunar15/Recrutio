import 'package:flutter/material.dart';
import 'package:Recrutio/LOGIN/login.dart';
import 'package:Recrutio/ForgetPassword/forgetpassword.dart';

void main() {
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
      home:  const LoginPage(),
    );
  }
}
