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
        child:  SingleChildScrollView(
          child: Padding(
            padding:const  EdgeInsets.all(25),
            child: OverflowBar(
              overflowSpacing: 10,
              overflowAlignment: OverflowBarAlignment.center,
              children: [
                //header
                const Text(
                  "Signup",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 5,
                      fontWeight: FontWeight.w600,
                      fontSize: 50,
                      color: Colors.white),
                ),

                // TEXTFEILD OF NAME
                TextField(
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
                ),

                // TEXTFEILD OF EMAIL
                TextField(
                  keyboardType: TextInputType.text,
                  style: const  TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Email',
                    prefixIcon:const Icon(Icons.email),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),

                // TEXTFEILD OF PASSWORD
                TextField(
                  keyboardType: TextInputType.text,
                  style: const  TextStyle(
                      color: Colors.black
                  ),
                  obscureText: _obscureText,
                  obscuringCharacter:'*',
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Enter Password',
                    prefixIcon:const Icon(Icons.key_sharp),
                    suffixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                          _obscureText = !_obscureText; // Toggle the obscureText state.
                        });
                      },
                      child: Icon(_obscureText? Icons.visibility: Icons.visibility_off),
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  style: const  TextStyle(
                      color: Colors.black
                  ),
                  obscureText: _obscureText,
                  obscuringCharacter:'*',
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Confirm Password',
                    prefixIcon:const Icon(Icons.key_sharp),
                    suffixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                          _obscureText = !_obscureText; // Toggle the obscureText state.
                        });
                      },
                      child: Icon(_obscureText? Icons.visibility: Icons.visibility_off),
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
                      decoration:  BoxDecoration(
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
    );
  }
}