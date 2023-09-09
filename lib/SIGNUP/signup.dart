import 'package:Recrutio/LOGIN/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Recrutio/consts.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {

  late String _name, _email;

  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();

  final formkey = GlobalKey<FormState>();


  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
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
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-z A-Z]+$').hasMatch(value!)) {
                        return "Please Enter Name";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (name) {
                      _name = name!;
                    },
                  ),

                  // TEXTFEILD OF EMAIL
                  TextFormField(
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.black
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-z A-Z0-9+_.-]+@[a-z A-Z0-9.-]+.[a-z]').hasMatch(value!)) {
                        return "Please Enter Email";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (email) {
                      _email = email!;
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
                      if (value!.isEmpty){
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
                        child: Icon(_obscureText ? Icons.visibility : Icons
                            .visibility_off),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _confirmpassword,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.black
                    ),
                    validator: (value) {
                      if (value!.isEmpty){
                        return "Please Enter Re-Password";
                      }
                      if(_password.text != _confirmpassword.text)
                        {
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
                        child: Icon(_obscureText ? Icons.visibility : Icons
                            .visibility_off),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  ),

                  // its a button of continue
                  CupertinoButton(
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: double.infinity,
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
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          final snackBar =  SnackBar(content: Text('Submitting form'));
                          var scaffoldKey;
                          scaffoldKey.currentState!.showSnackBar(snackBar);
                        }
                      }
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
}

