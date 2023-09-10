import 'package:Recrutio/LOGIN/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Recrutio/consts.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  ForgetPasswordPageState createState() => ForgetPasswordPageState();
}

class ForgetPasswordPageState extends State<ForgetPasswordPage> {

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Padding(
                padding:const  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: OverflowBar(
                  overflowSpacing: 10,
                  overflowAlignment: OverflowBarAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    IconButton(onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LoginPage()));

                    },
                        iconSize: 20,
                        icon: const Icon(Icons.arrow_back_outlined)),
                    const SizedBox(height: 10,),
                    Image.asset('assets/images/logo/logo.png',
                      alignment: Alignment.center,
                    ),
                    const SizedBox(height: 15,),
                    //header
                    const Text(
                      "Forget ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 40,
                          color: Colors.black),
                    ),

                    const Text(
                      "Password?",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 40,
                          color: Colors.black),
                    ),

                    const Text(
                          "Don't Worry! We'll send the link to your email to reset the Password.  ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white70),
                    ),

                    const SizedBox(height: 15,),

                    // textfield of email
                    TextFormField(
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
                      ),
                    ),

                    // its a button of continue
                    CupertinoButton(
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: double.infinity,
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
                        onPressed: (){}
                    ),
                    const Text(
                      "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white70),
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


