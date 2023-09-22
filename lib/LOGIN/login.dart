// ignore_for_file: unused_local_variable, avoid_print, use_build_context_synchronously

import 'package:Recrutio/ForgetPassword/forgetpassword.dart';
import 'package:Recrutio/SIGNUP/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Recrutio/consts.dart';
import 'package:Recrutio/authentication _repo/authentication_repo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
   LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  final authenticationrepo _auth = authenticationrepo();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();


  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build( context) {
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
        child:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Padding(
                padding:const  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: OverflowBar(
                  overflowSpacing: 10,
                  overflowAlignment: OverflowBarAlignment.center,
                  children: [
                    const SizedBox(height: 45,),
                     Image.asset('assets/images/logo/logo.png',
                       alignment: Alignment.center,
                     ),
                    const SizedBox(height: 15,),
                    //header
                    const Text(
                      "Sign in",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 15,),

                    // textfield of email
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          color: Colors.black
                      ),

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

                    //TEXTFEILD OF PASSWORD
                    TextFormField(
                      controller: _password,
                      keyboardType: TextInputType.text,
                      style: const  TextStyle(
                          color: Colors.black
                      ),
                      obscureText: _obscureText,
                      obscuringCharacter:'*',
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Password',
                        prefixIcon:const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              _obscureText = !_obscureText; // Toggle the obscureText state.
                            });
                          },
                          child: Icon(_obscureText? Icons.visibility_off: Icons.visibility),
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0,bottom: 2.0),
                        child: TextButton(
                          onPressed: (){
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const ForgetPasswordPage()));
                          },
                          child:const  Text(
                            "Forget Password?",
                            style:TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),

                    // its a button of continue
                    GestureDetector(
                      onTap: _login,
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 350,
                          decoration:  BoxDecoration(
                            color: const Color(0xff2c2828),
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
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(0.0), // Adjust the padding as needed
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40.0), // Adjust the padding around the image
                                child: Image.asset(
                                  'assets/images/loginpage/google.png',
                                  height: 20, // Adjust the image size as needed
                                  width: 20,  // Adjust the image size as needed
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                              const Text(
                                "Sign in with Google",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Row(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Does not have account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            // NAVIGATE TO THE SIGNUP PAGE
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const SignupPage()));
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

  void _login() async {
    String email = _email.text;
    String password = _password.text;


    User? user = await  _auth.signInWithEmailAndPassword( email, password);

    if(user != null){
      print("User is successfully Logged in");
      Navigator.pushNamed(context, "animation");
    }else{
      print("Some error occurred");
    }
  }



}



