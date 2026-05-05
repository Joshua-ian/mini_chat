import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minichat/chats.dart';
import 'package:minichat/register.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  final user = FirebaseAuth.instance.currentUser;

  void welcome() {
    if(user != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Chats()));
    }
    else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Register()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/ttower.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('MINICHAT', style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 30),
              Text('Welcome', style:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 40),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: ElevatedButton(onPressed:welcome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.white,
                            width: 1
                          )
                        )
                      ),
                      child: Text('Proceed')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
