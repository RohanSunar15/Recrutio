// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:Recrutio/SIGNUP/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Recrutio/consts.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }



  // Initialize Firebase Messaging
  void _initializeFirebaseMessaging() async {
    // Request notification permission
    final status = await Permission.notification.request();

    if (status.isGranted) {
      // Permission granted
      _firebaseMessaging.getToken().then((fcmToken) async {
        print("FCM Token: $fcmToken");
        // Save the FCM token to your user's account on your server/database.

        // You can send this token to your server to associate it with the user.
      });

      // Handle incoming messages when the app is in the foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Handle the incoming message when the app is open.
        print("Received message: ${message.notification?.title}");
      });
    } else {
      // Permission denied
      print("Notification permission denied");
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the message when the app is in the background and opened by tapping the notification
      print('Tapped on notification: ${message.notification?.title}');
    });
  }

  void sendTokenToServer(String token) async {
    final response = await http.post(
      Uri.parse('https://your-server.com/api/store-fcm-token'),
      body: {'token': token},
    );

    if (response.statusCode == 200) {
      print('FCM Token sent to server successfully.');
    } else {
      print('Failed to send FCM Token to server.');
    }
  }



  Future<void> _login() async {
    String email = _email.text;
    String password = _password.text;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        print("User is successfully logged in");
        // Navigate to the next screen after successful login
        Navigator.pushNamed(context, "animation");
      } else {
        print("Some error occurred");
        // Show an error message to the user
        const snackBar = SnackBar(
          content: Text("Authentication failed. Please check your email and password."),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      print("Firebase Authentication error: ${e.code}");
      String errorMessage = "Authentication failed. Please check your email and password.";
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Invalid email address.";
          break;
        case "user-not-found":
          errorMessage = "User not found.";
          break;
        case "wrong-password":
          errorMessage = "Wrong password.";
          break;
      }
      // Show an error message to the user
      final snackBar = SnackBar(
        content: Text(errorMessage),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      // Handle other errors
      print("Authentication error: $e");
      // Show an error message to the user
      const snackBar = SnackBar(
        content: Text("Authentication failed. Please check your email and password."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [g1, g2, g3, g4],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: OverflowBar(
                  overflowSpacing: 10,
                  overflowAlignment: OverflowBarAlignment.center,
                  children: [
                    const SizedBox(
                      height: 45,
                    ),
                    Image.asset(
                      'assets/images/logo/logo.png',
                      alignment: Alignment.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Sign in",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 12.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _password,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.black),
                      obscureText: _obscureText,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 12.0,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 20.0,
                          bottom: 2.0,
                        ),
                        child: TextButton(
                          onPressed: () {
                            // Navigate to the "Forgot Password" screen
                            // Navigator.pushNamed(context, "forgot_password_route");
                          },
                          child: const Text(
                            "Forget Password?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _login,
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 350,
                        decoration: BoxDecoration(
                          color: const Color(0xff2c2828),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Does not have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            // Navigate to the "Sign Up" screen
                            // Navigator.pushNamed(context, "sign_up_route");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage(),
                            ),
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
