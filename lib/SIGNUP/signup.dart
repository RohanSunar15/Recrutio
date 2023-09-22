// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:Recrutio/LOGIN/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Recrutio/consts.dart';
import 'package:Recrutio/authentication _repo/authentication_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  bool _obscureText = true;

  final authenticationrepo _auth = authenticationrepo();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();





  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _confirmpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();

    return Scaffold(

      //background
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [g1, g2, g3, g4]),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formkey, // key for form
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: OverflowBar(
                overflowSpacing: 8,
                overflowAlignment: OverflowBarAlignment.center,
                children: [
                  const SizedBox(height: 45,),
                  Image.asset('assets/images/logo/logo.png',
                    alignment: Alignment.center,
                  ),
                  const SizedBox(height: 15,),
                  //header
                  const Text(
                    "Sign up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15,),

                  // TEXTFEILD OF NAME
                  TextFormField(
                    controller: _name,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.black
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Name',
                      prefixIcon: const Icon(Icons.person_outline_outlined),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                        return "Please Enter Name";
                      } else {
                        return null;
                      }
                    },
                  ),

                  // TEXTFEILD OF EMAIL
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.black
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-z A-Z0-9+_.-]+@[a-z A-Z0-9.-]+.[a-z]')
                              .hasMatch(value)) {
                        return "Please Enter Email";
                      } else {
                        return null;
                      }
                    },

                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),

                    ),
                  ),

                  // TEXTFEILD OF PASSWORD
                  TextFormField(
                    controller: _password,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.black
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Password";
                      }
                      return null;
                    },

                    obscureText: _obscureText,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Enter Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText =
                            !_obscureText; // Toggle the obscureText state.
                          });
                        },
                        child: Icon(_obscureText ? Icons.visibility_off : Icons
                            .visibility),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),

                    ),
                  ),
                  TextFormField(
                    controller: _confirmpassword,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.black
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Re-Password";
                      }
                      if (_password.text != _confirmpassword.text) {
                        return "Password does not Match";
                      }
                      return null;
                    },

                    obscureText: _obscureText,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText =
                            !_obscureText; // Toggle the obscureText state.
                          });
                        },
                        child: Icon(_obscureText ? Icons.visibility_off : Icons
                            .visibility),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                    ),
                  ),
                  const SizedBox(height: 10,),

                  // its a button of continue
                  GestureDetector(
                    onTap: _signup,
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                        color: const Color(0xff000000),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: const Text("Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),


                  const Text(" ------------------- or ------------------- ",
                    style: TextStyle(
                        color: Color.fromRGBO(225, 225, 225, 70),
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),
                  ),

                  CupertinoButton(
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: double.infinity,
                        decoration:  BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/loginpage/google.png'),
                            alignment: Alignment.centerLeft,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Text("Sign up with Google",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: (){}
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Already have an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 15,
                            color: Colors.black,
                          ),
                        ),


                        onPressed: () {
                          // NAVIGATE TO THE LOGIN PAGE
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }

  void _signup() async {
    String email = _email.text;
    String password = _password.text;
    String confirmPassword = _confirmpassword.text;

    if (password == confirmPassword) {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        print("User is successfully created");
        Navigator.pushNamed(context, "login");
      } else {
        print("Some error occurred");
      }
    } else {
      // Show an error message because the password and confirm password do not match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:  Text('Password and Confirm Password do not match.'),
        ),
      );
    }
  }

}
