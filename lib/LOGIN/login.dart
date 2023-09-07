import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Recrutio/consts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
              overflowSpacing: 20,
              overflowAlignment: OverflowBarAlignment.center,
              children: [

                //header
                const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 5,
                      fontWeight: FontWeight.w600,
                      fontSize: 50,
                      color: Colors.white),
                ),
                  // textfield of email
                  TextField(
                   keyboardType: TextInputType.text,
                   style: const TextStyle(
                     color: Colors.black
                   ),
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.person),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),

                // textfield of password
                TextField(
                  keyboardType: TextInputType.text,
                  style: const  TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Password',
                    prefixIcon:const Icon(Icons.key_sharp),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0,bottom: 2.0),
                  child: TextButton(
                    onPressed: (){},
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
                      child: const Text("Sign in with Google",
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
                    const Text('Does not have account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        //signup screen
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
